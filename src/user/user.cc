#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "user.hh"
#include "../app/app.hh"
#include "../utils/utils.hh"
#include "../json/cJSON.hh"
#include "../encryption/protection.hh"
#include "../dropbox/dropbox.hh"

char* get_user_data_file_path()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		user_data_file_path = build_path(app_folder_path, USER_FILE);
		if(!user_data_file_path)
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		user_data_file_path = 0;
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}

	return user_data_file_path;
}

int user_exist()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		if(!dir_exist(app_folder_path))
			break;
			
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
			break;
		
		if(!file_exist(user_data_file_path))
			break;
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	if(user_data_file_path)
	{
		free(user_data_file_path);
	}

	return was_successful;
}

int create_user(const unsigned char* passphrase_digest)
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
	unsigned char* encrypted_buffer = 0;
	size_t encrypted_buffer_len = 0;
	FILE* user_file = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		if(!dir_exist(app_folder_path))
		{
			if(!create_dir(app_folder_path))
				break;
		}
		
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
		{
			break;
		}
		
		user_file = fopen(user_data_file_path, "w");
		if(!user_file)
			break;
			
		unsigned char buffer[] = {"{\n\t\"AccessToken\":\"\",\
\n\t\"AccessTokenSecret\":\"\",\
\n\t\"UID\":\"\"\n}"};

		if(!encrypt_memory( buffer, 
							strlen((char*)buffer),
							passphrase_digest,
							&encrypted_buffer,
							&encrypted_buffer_len))
		{
			break;
		}
			
		fwrite((void*)encrypted_buffer, sizeof(char), encrypted_buffer_len, user_file);
					
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(user_file)
	{
		fclose(user_file);
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	if(user_data_file_path)
	{
		free(user_data_file_path);
	}
	
	if(encrypted_buffer)
	{
		free(encrypted_buffer);
	}

	return was_successful;
}

int remove_user()
{
	int was_successful = 0;
	
	do{
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}

	return was_successful;
}

int update_user(const char* access_token, 
				const char* access_token_secret)
{
	int was_successful = 0;
	char* user_data_file_path = 0;
	unsigned char* encrypted_buffer = 0;
	size_t encrypted_buffer_len = 0;
	unsigned char* decrypted_buffer = 0;
	size_t decrypted_buffer_len = 0;
	FILE* user_file = 0;
	cJSON* json = 0;
	char* access_token_copy = 0;
	char* access_token_secret_copy = 0;
	
	do{
		if(!access_token || !access_token_secret)
			break;
			
		if(!user_exist())
			break;
			
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
			break;
			
		if(!file_exist(user_data_file_path))
			break;
			
		user_file = fopen(user_data_file_path, "r");
		if(!user_file)
			break;
			
		fseek(user_file, 0, SEEK_END);
		encrypted_buffer_len = ftell(user_file);
		rewind(user_file);
			
		encrypted_buffer = (unsigned char*) malloc(sizeof(char) * encrypted_buffer_len);
		if(!encrypted_buffer)
			break;
			
		memset(encrypted_buffer, 0, encrypted_buffer_len);
		
		if(fread((void*)encrypted_buffer, 
				 sizeof(char), 
				 encrypted_buffer_len, 
				 user_file) < encrypted_buffer_len)
			break;
		
		if(!decrypt_memory(	encrypted_buffer, 
							encrypted_buffer_len,
							passphrase_digest,
							&decrypted_buffer,
							&decrypted_buffer_len))
		{
			break;
		}
				
		json = cJSON_Parse((char*)decrypted_buffer);
		if(!json)
			break;
			
		cJSON* root = json;
		
		access_token_copy = strdup(access_token);
		access_token_secret_copy = strdup(access_token_secret);
		
		if(!access_token_copy || !access_token_secret_copy)
			break;
		
		cJSON_GetObjectItem(root, "AccessToken")->valuestring = access_token_copy;
		cJSON_GetObjectItem(root, "AccessTokenSecret")->valuestring = access_token_secret_copy;
		
		decrypted_buffer = (unsigned char*) cJSON_Print(json);
		if(!decrypted_buffer)
			break;
			
		decrypted_buffer_len = (size_t) strlen((char*)decrypted_buffer);
			
		// these two lines prevent stack crash
		// i still don't know where things go wrong
		// i hope there is no memory leak in this fucntion
		cJSON_GetObjectItem(root, "AccessToken")->valuestring = 0;
		cJSON_GetObjectItem(root, "AccessTokenSecret")->valuestring = 0;
		
		if(encrypted_buffer)
		{
			free(encrypted_buffer);
			encrypted_buffer = 0;
			encrypted_buffer_len = 0;
		}

		if(!encrypt_memory(	decrypted_buffer,
							decrypted_buffer_len,
							passphrase_digest,
							&encrypted_buffer,
							&encrypted_buffer_len))
		{
			break;
		}
		
		fflush(user_file);
		fclose(user_file);
		user_file = fopen(user_data_file_path, "w");
		if(!user_file)
			break;
			
		if(fwrite((void*)encrypted_buffer, 
				  sizeof(char), 
				  encrypted_buffer_len, 
				  user_file) < encrypted_buffer_len)
		{
			break;
		}
		
		
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(json)
	{
		cJSON_Delete(json);
	}
	
	if(user_data_file_path)
	{
		free(user_data_file_path);
	}
	
	if(user_file)
	{
		fclose(user_file);
	}
	
	if(encrypted_buffer)
	{
		free(encrypted_buffer);
	}
	
	if(decrypted_buffer)
	{
		free(decrypted_buffer);
	}
	
	if(access_token_copy)
	{
		free(access_token_copy);
	}
	
	if(access_token_secret_copy)
	{
		free(access_token_secret_copy);
	}

	return was_successful;
}

int get_user_data(	char* access_token,
					char* access_token_secret)
{
	int was_successful = 0;
	char* user_data_file_path = 0;
	unsigned char* encrypted_buffer = 0;
	size_t encrypted_buffer_len = 0;
	unsigned char* decrypted_buffer = 0;
	size_t decrypted_buffer_len = 0;
	FILE* user_file = 0;
	cJSON* json = 0;
	
	do{
		if(!access_token || !access_token_secret)
			break;
			
		if(!user_exist())
			break;
			
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
			break;
			
		if(!file_exist(user_data_file_path))
			break;
			
		user_file = fopen(user_data_file_path, "r");
		if(!user_file)
			break;
			
		fseek(user_file, 0, SEEK_END);
		encrypted_buffer_len = ftell(user_file);
		rewind(user_file);
			
		encrypted_buffer = (unsigned char*) malloc(sizeof(char) * encrypted_buffer_len);
		if(!encrypted_buffer)
			break;
			
		memset(encrypted_buffer, 0, encrypted_buffer_len);
		
		if(fread((void*)encrypted_buffer, 
				 sizeof(char), 
				 encrypted_buffer_len, 
				 user_file) < encrypted_buffer_len)
			break;
		
		 if(!decrypt_memory(encrypted_buffer, 
							encrypted_buffer_len,
							passphrase_digest,
							&decrypted_buffer,
							&decrypted_buffer_len))
		{
			break;
		}
		
		json = cJSON_Parse((char*)decrypted_buffer);
		if(!json)
			break;
			
		cJSON* root = json;
		char* str = 0;
		
		str = cJSON_GetObjectItem(root, "AccessToken")->valuestring;
		strncpy(access_token, str, KEY_BUF_SIZE);
		
		str = cJSON_GetObjectItem(root, "AccessTokenSecret")->valuestring ;
		strncpy(access_token_secret, str, KEY_BUF_SIZE);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(json)
	{
		cJSON_Delete(json);
	}
	
	if(user_data_file_path)
	{
		free(user_data_file_path);
	}
	
	if(user_file)
	{
		fclose(user_file);
	}
	
	if(encrypted_buffer)
	{
		free(encrypted_buffer);
	}
	
	if(decrypted_buffer)
	{
		free(decrypted_buffer);
	}

	return was_successful;
}