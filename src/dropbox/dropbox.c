#include <stdlib.h>
#include <curl/curl.h>
#include <oauth.h>
#include "dropbox.h"
#include "rest_utils.h"

#define DROPBOX_API_REQUEST_TOKEN "https://api.dropbox.com/1/oauth/request_token"
#define DROPBOX_API_AUTHORIZE "https://www.dropbox.com/1/oauth/authorize"
#define DROPBOX_API_ACCESS_TOKEN "https://api.dropbox.com/1/oauth/access_token"
#define DROPBOX_API_ACCOUNT_INFO "https://api.dropbox.com/1/account/info"

char dropbox_oauth_token[KEY_BUF_SIZE] = {0};
char dropbox_oauth_token_secret[KEY_BUF_SIZE] = {0};
int is_there_already_a_token_pair = 0;

int dropbox_request_token(const char* consumer_key, const char* consumer_secret)
{
	int was_successful = 1;
	
	OauthTokenPairs* consumer_key_pairs = 0;
	OauthTokenPairs* token_key_pairs = 0;
	
	do
	{
		if(!consumer_key || !consumer_secret)
		{
			was_successful = 0;
			break;
		}
		
		consumer_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		token_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		set_oauth_token_pairs(consumer_key_pairs, consumer_key, consumer_secret);
		
		if(!perform_token_http_request(	DROPBOX_API_REQUEST_TOKEN, 
										consumer_key_pairs, 
										token_key_pairs))
		{
			was_successful = 0;
			break;
		}
		
		strcpy(dropbox_oauth_token, token_key_pairs->token);
		strcpy(dropbox_oauth_token_secret, token_key_pairs->token_secret);
		
		//on next api calls we will check this flag
		is_there_already_a_token_pair = 1;
	}while(0);
		
	if(!was_successful){
		
	}
	
	if(consumer_key_pairs)
	{
		free_oauth_token_pairs(consumer_key_pairs);
	}
	
	if(token_key_pairs)
	{
		free_oauth_token_pairs(token_key_pairs);
	}
	
	return was_successful;			
}

char* dropbox_authorize(const char* consumer_key, const char* consumer_secret)
{
	int was_successful = 1;
	
	OauthTokenPairs* consumer_key_pairs = 0;
	OauthTokenPairs* token_key_pairs = 0;
	char* signed_url = 0;
	
	do
	{
		if(!consumer_key || !consumer_secret)
		{
			was_successful = 0;
			break;
		}
		
		if(!is_there_already_a_token_pair)
		{
			was_successful = 0;
			break;
		}
		
		consumer_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		token_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		set_oauth_token_pairs(consumer_key_pairs, consumer_key, consumer_secret);
		set_oauth_token_pairs(token_key_pairs, dropbox_oauth_token, dropbox_oauth_token_secret);
		
		signed_url = perform_link_http_request(DROPBOX_API_AUTHORIZE, 
												consumer_key_pairs, 
												token_key_pairs);
		if(!signed_url)
		{
			was_successful = 0;
			break;
		}
		
	}while(0);
		
	if(!was_successful)
	{
		return 0;
	}
	
	if(consumer_key_pairs)
	{
		free_oauth_token_pairs(consumer_key_pairs);
	}
	
	if(token_key_pairs)
	{
		free_oauth_token_pairs(token_key_pairs);
	}
	
	return signed_url;;
}

int dropbox_access_token(	const char* consumer_key, 
							const char* consumer_secret, 
							char** access_token,
							char** access_token_secret)
{
	int was_successful = 1;
	
	OauthTokenPairs* consumer_key_pairs = 0;
	OauthTokenPairs* token_key_pairs = 0;
	
	do
	{
		if(!is_there_already_a_token_pair)
		{
			was_successful = 0;
			break;
		}
		
		if(!consumer_key || !consumer_secret)
		{
			was_successful = 0;
			break;
		}
		
		consumer_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		token_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		set_oauth_token_pairs(consumer_key_pairs, consumer_key, consumer_secret);
		set_oauth_token_pairs(token_key_pairs, dropbox_oauth_token, dropbox_oauth_token_secret);
		
		if(!perform_token_http_request(	DROPBOX_API_ACCESS_TOKEN, 
										consumer_key_pairs, 
										token_key_pairs))
		{
			was_successful = 0;
			break;
		}
		
		
		int access_token_len = strlen(token_key_pairs->token) + 1;
		int access_token_secret_len = strlen(token_key_pairs->token_secret) + 1;
		
		*access_token = (char*) malloc (sizeof(char) * access_token_len);
		*access_token_secret = (char*) malloc (sizeof(char) * access_token_secret_len);
		
		memset(*access_token, 0, access_token_len);
		memset(*access_token_secret, 0, access_token_len);
		
		strcpy(dropbox_oauth_token, token_key_pairs->token);
		strcpy(dropbox_oauth_token_secret, token_key_pairs->token_secret);
		
		strcpy(*access_token, token_key_pairs->token);
		strcpy(*access_token_secret, token_key_pairs->token_secret);
		
		//on next api calls we will check this flag
		is_there_already_a_token_pair = 1;
	}while(0);
		
	if(!was_successful){
		
	}
	
	if(consumer_key_pairs)
	{
		free_oauth_token_pairs(consumer_key_pairs);
	}
	
	if(token_key_pairs)
	{
		free_oauth_token_pairs(token_key_pairs);
	}
	
	return was_successful;
}



