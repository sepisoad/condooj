#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "app.h"
#include "utils.h"
#include "config.h"
#include "user.h"
#include "protection.h"
#include "dropbox/dropbox.h"

unsigned char passphrase_digest[32] = {0};

int start_app()
{
	unsigned char passphrase[513] = {0};
	
	if(!config_file_exist())
	{
		if(!create_config_file())
			return 0;
	}
	
	printf("please enter your passphrase here: ");
	fgets((char*)passphrase, 513, stdin);
	if(!create_passphrase_digest(passphrase, passphrase_digest))
	{
		return 0;
	}
	
	if(!user_exist())
	{
		if(!create_user(passphrase))
		{
			return 0;
		}
		
		if(!authorize_dropbox_user())			
		{
			return 0;
		}
	}
	else
	{
		char access_token[KEY_BUF_SIZE] = {0};
		char access_token_secret[KEY_BUF_SIZE] = {0};
		
		if(!get_user_data(access_token, access_token_secret))
		{
			return 0;
		}
		
		printf("%s : %s \n", access_token, access_token_secret);
	}
	
	return 1;
}

char* get_app_folder_path()
{
	int was_successful = 0;
	char* user_home_folder_path = 0;
	char* app_folder_path = 0;
	
	do{
		user_home_folder_path = get_user_home_folder();
		if(!user_home_folder_path)
			break;
		
		app_folder_path = build_path(user_home_folder_path, APP_BASE_FOLDER_NAME);
		if(!app_folder_path)
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		app_folder_path = 0;
	}
	
	if(user_home_folder_path)
	{
		free(user_home_folder_path);
	}

	return app_folder_path;
}

int authorize_dropbox_user()
{
	int was_successful = 0;
	char* signed_url = 0;
	char* access_token = 0;
	char* access_token_secret = 0;
	char answer = 'n';
		
	do{
		dropbox_request_token(CONSUMER_KEY, CONSUMER_SECRET);
		signed_url = dropbox_authorize(CONSUMER_KEY, CONSUMER_SECRET);
		
		printf("\nplease copy the link below in you favourite browser and authorize the app,");
		printf(" the app will wait for you to perform authorization...\n");
		printf("%s\n", signed_url);
		printf("\ndid you authorized the app (y/n)? ");
		fflush (stdout);
		scanf("%c", &answer);
		if(answer == 'y')
		{
			dropbox_access_token(CONSUMER_KEY, CONSUMER_SECRET, &access_token, &access_token_secret);
			if(access_token || access_token_secret)
			{
				if(!update_user(access_token, access_token_secret))
				{
					break;
				}
			}
		}
		
		was_successful = 1;
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	if(signed_url)
	{
		free(signed_url);
		signed_url = 0;
	}
	
	if(access_token)
	{
		free(access_token);
		access_token = 0;
	}
	
	if(access_token_secret)
	{
		free(access_token_secret);
		access_token_secret = 0;
	}
	
	return was_successful;
}