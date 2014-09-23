#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "user.h"
#include "app.h"
#include "utils.h"
#include "encryption/sha256.h"
#include "encryption/aes.h"

char* get_user_data_file_path()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		user_data_file_path = build_path(app_folder_path, USER_DATA_FILE);
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

int create_user(const unsigned char* passphrase)
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
	FILE* user_file = 0;
	
	do{
		if(!passphrase)
			break;
		
		BYTE sha256_hash[SHA256_BLOCK_SIZE];
		SHA256_CTX sha256;
		
		sha256_init(&sha256);
		sha256_update(&sha256, passphrase, strlen((char*)passphrase));
		sha256_final(&sha256, sha256_hash);
			
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
			break;
			
		WORD key_schedule[60];
		BYTE encrypted_passphrase[128];
		BYTE buf16[16] = {0};
		
		aes_key_setup(sha256_hash, key_schedule, 256);
				
		int current_len = strlen((char*)passphrase);
		for(;;)
		{
			if(current_len <= 16)
			{
				aes_encrypt(passphrase, encrypted_passphrase, key_schedule, 256);
				break;
			}
			strncpy((char*)buf16, (char*)passphrase, 16);
			aes_encrypt(passphrase, encrypted_passphrase, key_schedule, 256);
			passphrase += 16;
		
			current_len = strlen((char*)passphrase);
		}
		
		user_file = fopen(user_data_file_path, "w");
		if(!user_file)
			break;
			
		int index = 0;
//		for(index = 0; index < SHA256_BLOCK_SIZE; index++)
//		{
//			unsigned char c = sha256_hash[index];
//			fprintf(user_file, "%x", c);
//		}

		for(index = 0; index < 128; index++)
		{
			char c = encrypted_passphrase[index];
			fwrite((void*)&c, sizeof(char), 1, user_file);
		}
			
			
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

int update_user(const unsigned char* passphrase, 
				const char* access_token, 
				const char* access_token_secret)
{
	int was_successful = 0;
	char* user_data_file_path = 0;
	FILE* user_file = 0;
	char* user_buffer = 0;
	char* encrypted_buffer = 0;
	
	do{
		if(!passphrase || !access_token || !access_token_secret)
			break;
			
		if(!user_exist())
			break;
			
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
			break;
			
		user_file = fopen(user_data_file_path, "w");
		if(!user_file)
			break;
			
		int user_buffer_len = 	strlen((char*)passphrase) + 
								strlen(access_token) + 
								strlen(access_token_secret) + 
								(strlen("\n") * 3) + 1;
							
		user_buffer = (char*) malloc(sizeof(char) * user_buffer_len);
		if(!user_buffer)
			break;
			
		memset(user_buffer, 0, user_buffer_len);
		sprintf(user_buffer, "%s\n%s\n%s\n", passphrase, access_token, access_token_secret);
		
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(user_data_file_path)
	{
		free(user_data_file_path);
	}
	
	if(user_file)
	{
		fclose(user_file);
	}
	
	if(user_buffer)
	{
		free(user_buffer);
	}
	
	if(encrypted_buffer)
	{
		free(encrypted_buffer);
	}

	return was_successful;
}