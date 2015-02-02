#include <stdlib.h>
#include <curl/curl.h>
#include <oauth.h>
#include "dropbox.hh"
#include "rest_utils.hh"
#include "../json/cJSON.hh"

#define DROPBOX_API_REQUEST_TOKEN "https://api.dropbox.com/1/oauth/request_token"
#define DROPBOX_API_AUTHORIZE "https://www.dropbox.com/1/oauth/authorize"
#define DROPBOX_API_ACCESS_TOKEN "https://api.dropbox.com/1/oauth/access_token"
#define DROPBOX_API_ACCOUNT_INFO "https://api.dropbox.com/1/account/info"

char dropbox_oauth_token[KEY_BUF_SIZE] = {0};
char dropbox_oauth_token_secret[KEY_BUF_SIZE] = {0};
int is_there_already_a_token_pair = 0;

int set_dropbox_access_tokens(	const char* access_token,
								const char* access_token_secret)
{
	int was_successful = 0;
	
	do{
		if(!access_token || !access_token_secret)
			break;
			
		if(strlen(access_token) > KEY_BUF_SIZE)
			break;
			
		if(strlen(access_token_secret) > KEY_BUF_SIZE)
			break;	
			
		strcpy(dropbox_oauth_token, access_token);
		strcpy(dropbox_oauth_token_secret, access_token_secret);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}

	return was_successful;
}			

DropBoxUserInfo* create_dropbox_user_info(	const char* referral_link,
											const char* display_name,
											const char* country,
											const char* email,
											unsigned long uid)
{
	int was_successful = 0;
	DropBoxUserInfo* dbui = 0;
	
	do{
		if(	!referral_link || 
			!display_name ||
			!country || 
			!email)
		{
			break;
		}
		
		dbui = (DropBoxUserInfo*) malloc (sizeof(DropBoxUserInfo));
		if(!dbui)
			break;
		memset(dbui, 0, sizeof(DropBoxUserInfo));
		
		size_t str_len = 0;
	
		str_len = strlen(referral_link) + 1;
		dbui->referral_link = (char*) malloc (sizeof(char) * str_len);
		if(!dbui->referral_link)
			break;
		memset(dbui->referral_link, 0, str_len);
		strcpy(dbui->referral_link, referral_link);
		
		str_len = strlen(display_name) + 1;
		dbui->display_name = (char*) malloc (sizeof(char) * str_len);
		if(!dbui->display_name)
			break;
		memset(dbui->display_name, 0, str_len);
		strcpy(dbui->display_name, display_name);
		
		str_len = strlen(country) + 1;
		dbui->country = (char*) malloc (sizeof(char) * str_len);
		if(!dbui->country)
			break;
		memset(dbui->country, 0, str_len);
		strcpy(dbui->country, country);
		
		str_len = strlen(email) + 1;
		dbui->email = (char*) malloc (sizeof(char) * str_len);
		if(!dbui->email)
			break;
		memset(dbui->email, 0, str_len);
		strcpy(dbui->email, email);
		
		dbui->uid = uid;
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		if(dbui)
		{
			delete_dropbox_user_info(dbui);
		}
	}

	return dbui;
}

int delete_dropbox_user_info(DropBoxUserInfo* dbui)
{
	if(dbui)
	{
		if(dbui->country)
			free(dbui->country);
			
		if(dbui->display_name)
			free(dbui->display_name);
			
		if(dbui->country)
			free(dbui->country);
			
		if(dbui->email)
			free(dbui->email);
			
		free(dbui);
	}
	
	return 1;
}

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

int dropbox_account_info(	const char* consumer_key, 
							const char* consumer_secret)
{
	int was_successful = 0;
	
	OauthTokenPairs* consumer_key_pairs = 0;
	OauthTokenPairs* token_secret_key_pairs = 0;
	Buffer* buffer = 0;
	cJSON* json = 0;
	DropBoxUserInfo* dbui = 0;
	
	do{
		consumer_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		token_secret_key_pairs = create_oauth_token_pairs(KEY_BUF_SIZE, KEY_BUF_SIZE);
		set_oauth_token_pairs(consumer_key_pairs, consumer_key, consumer_secret);
		set_oauth_token_pairs(token_secret_key_pairs, dropbox_oauth_token, dropbox_oauth_token_secret);
		
		buffer = perform_http_request(	DROPBOX_API_ACCOUNT_INFO, 
										HTTP_METHOD_GET,
										consumer_key_pairs, 
										token_secret_key_pairs);
		if(!buffer)
		{
			was_successful = 0;
			break;
		}
		
		json = cJSON_Parse(buffer->data);
		if(!json)
		{
			break;
		}
		
		char* p_referral_link = cJSON_GetObjectItem(json, "referral_link")->valuestring;
		char* p_display_name = cJSON_GetObjectItem(json, "display_name")->valuestring;
		char* p_country = cJSON_GetObjectItem(json, "country")->valuestring;
		char* p_email = cJSON_GetObjectItem(json, "email")->valuestring;
		unsigned long uid = cJSON_GetObjectItem(json, "uid")->valueint;

		dbui = create_dropbox_user_info(p_referral_link,
										p_display_name,
										p_country,
										p_email,
										uid);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		if(dbui)
		{
			delete_dropbox_user_info(dbui);
		}
	}
	
	if(buffer)
	{
		free_buffer(buffer);
	}
	
	if(json)
	{
		cJSON_Delete(json);
	}

	return was_successful;
}