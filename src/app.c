#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "app.h"
#include "config.h"
#include "dropbox/dropbox.h"

int start_app()
{
	if(!config_file_exist())
	{
		if(!create_config_file())
		{
			printf("error\n");
		}
		
		if(!authorize_dropbox_user())			
		{
			printf("error\n");
		}
	}
	
	return 0;
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
				if(update_config_file("UserInfo", "AccessToken", access_token))
				{
					break;
				}
				if(update_config_file("UserInfo", "AccessTokenSecret", access_token_secret))
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