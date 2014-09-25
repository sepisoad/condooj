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

int create_user()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* user_data_file_path = 0;
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
			break;
					
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

int update_user(const char* access_token, 
				const char* access_token_secret)
{
	int was_successful = 0;
	char* user_data_file_path = 0;
	FILE* user_file = 0;
	char* user_buffer = 0;
	char* encrypted_buffer = 0;
	
	do{
		if(!access_token || !access_token_secret)
			break;
			
		if(!user_exist())
			break;
			
		user_data_file_path = get_user_data_file_path();
		if(!user_data_file_path)
			break;
			
		user_file = fopen(user_data_file_path, "w");
		if(!user_file)
			break;
			
		int user_buffer_len = 	strlen(access_token) + 
								strlen(access_token_secret) + 
								(strlen("\n") * 2) + 1;
							
		user_buffer = (char*) malloc(sizeof(char) * user_buffer_len);
		if(!user_buffer)
			break;
			
		memset(user_buffer, 0, user_buffer_len);
		sprintf(user_buffer, "%s\n%s\n", access_token, access_token_secret);
		
			
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