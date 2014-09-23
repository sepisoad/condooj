#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "app.h"
#include "utils.h"
#include "config.h"
#include "user.h"
#include "dropbox/dropbox.h"

int start_app()
{
	if(!user_exist())
	{
		unsigned char passphrase[] = "this is a sample passphrase";
		//unsigned char passphrase[] = "you mother fucker";
		//unsigned char passphrase[] = {"bitch"};
		
		if(!create_user(passphrase))
		{
			return 0;
		}
		
		if(!authorize_dropbox_user())			
		{
			return 0;
		}
	}
	
	return 0;
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
	unsigned char* passphrase = 0;
	char answer = 'n';
	
	do{
		dropbox_request_token(CONSUMER_KEY, CONSUMER_SECRET);
		signed_url = dropbox_authorize(CONSUMER_KEY, CONSUMER_SECRET);
		
		printf("please copy the link below in you favourite browser and authorize the app,");
		printf(" the app will wait for you to perform authorization...\n");
		printf("%s\n", signed_url);
		printf("did you authorized the app (y/n)? ");
		answer = getchar();
		if(answer == 'y')
		{
			dropbox_access_token(CONSUMER_KEY, CONSUMER_SECRET, &access_token, &access_token_secret);
			if(access_token || access_token_secret)
			{
				if(update_user(passphrase, access_token, access_token_secret))
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