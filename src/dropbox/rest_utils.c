#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>
#include <oauth.h>
#include "rest_utils.h"

OauthTokenPairs* create_oauth_token_pairs(size_t token_size, size_t token_secret_size)
{
	OauthTokenPairs* pair = (OauthTokenPairs*) malloc(sizeof(OauthTokenPairs));
	if(!pair)
	{
		return 0;
	}
	
	pair->token = (char*) malloc(sizeof(char) * token_size);
	pair->token_secret = (char*) malloc(sizeof(char) * token_secret_size);
	pair->token_size = token_size;
	pair->token_secret_size = token_secret_size;
	
	memset(pair->token, 0, pair->token_size);
	memset(pair->token_secret, 0, pair->token_secret_size);
	
	return pair;
}

void free_oauth_token_pairs(OauthTokenPairs* pair)
{
	if(pair)
	{
		if(pair->token && pair->token_size)
		{
			free(pair->token);
			pair->token = 0;
			pair->token_size = 0;
		}
		
		if(pair->token_secret && pair->token_secret_size)
		{
			free(pair->token_secret);
			pair->token_secret = 0;
			pair->token_secret_size = 0;
		}
		
		free(pair);
		pair = 0;
	}
}

int set_oauth_token_pairs(OauthTokenPairs* pair, const char* token, const char* token_secret)
{	
	if(!pair || !token || !token_secret)
	{
		return 0;
	}
	
	if(strlen(token) >= pair->token_size || strlen(token_secret) >= pair->token_secret_size)
	{
		return 0;
	}
	
	if(pair->token_size <= 0 || pair->token_secret_size <= 0)
	{
		return 0;
	}
	
	memset(pair->token, 0, pair->token_size);
	memset(pair->token_secret, 0, pair->token_secret_size);
	
	strcpy(pair->token, token);
	strcpy(pair->token_secret, token_secret);
	
	return 1;
}

CurlBuffer* create_curl_buffer(size_t size)
{
	CurlBuffer* buf = (CurlBuffer*) malloc (sizeof(CurlBuffer));
	
	if(!buf)
	{
		return 0;
	}
	
	if(size <= 0)
	{
		buf->data = 0;
		buf->size = 0;
		return buf;
	}
	
	buf->data = (char*) malloc (sizeof(char) * size);
	
	if(!buf->data)
	{
		return 0;
	}
	
	buf->size = size;
	
	memset(buf->data, 0, buf->size);
	
	return buf;
}

void free_curl_buffer(CurlBuffer* buf)
{
	if(buf)
	{
		if(buf->data)
		{
			free(buf->data);
			buf->data = 0;
			buf->size = 0;
		}
		
		free(buf);
		buf = 0;
	}
}

size_t write_into_curl_buffer(char* data, size_t data_size, size_t nmemb, void* buf)
{
	size_t real_size = data_size * nmemb;
	
	if(!data || real_size <= 0)
	{
		return 0;
	}
	
	CurlBuffer* tbuf = (CurlBuffer*) buf;
	
	tbuf->data = (char*) realloc(tbuf->data, tbuf->size + real_size + 1);
	if(tbuf->data)
	{
		memcpy(&(tbuf->data[tbuf->size]), data, real_size);
		tbuf->size += real_size;
		tbuf->data[tbuf->size] = 0;
	}
	
	return real_size;
}

int perform_token_http_request(	const char* URL,
								OauthTokenPairs* consumer_keys, 
								OauthTokenPairs* tokens)
{
	int was_successful = 1;
	char* oauth_post_args = 0;
	char* oauth_result = 0;
	CURL* curl_handler = 0;
	CURLcode curl_result = 0;
	CurlBuffer* curl_buffer = 0;
	
	do
	{
		if(!URL)
		{
			was_successful = 0;
			break;
		}
		
		if(0 == consumer_keys)
		{
			was_successful = 0;
			break;
		}
		
		oauth_result = oauth_sign_url2( URL,
										&oauth_post_args,
										OA_HMAC, 
										0,
										consumer_keys->token,
										consumer_keys->token_secret,
										tokens->token,
										tokens->token_secret);
		if(!oauth_result)
		{
			was_successful = 0;
			break;
		}
		
		curl_handler = curl_easy_init();
		if(!curl_handler)
		{
			was_successful = 0;
			break;
		}
		
		curl_buffer = create_curl_buffer(0);
		
		curl_easy_setopt(curl_handler, CURLOPT_URL, URL);
		curl_easy_setopt(curl_handler, CURLOPT_POSTFIELDS, oauth_post_args);
		curl_easy_setopt(curl_handler, CURLOPT_WRITEDATA, (void*)curl_buffer);
		curl_easy_setopt(curl_handler, CURLOPT_WRITEFUNCTION, write_into_curl_buffer);		
		
		curl_result = curl_easy_perform(curl_handler);
		if(curl_result != 0)
		{
			was_successful = 0;
			break;
		}
		
		if(!parse_rest_call_response(curl_buffer, tokens))
		{
			was_successful = 0;
			break;
		}
		
	}while(0);
		
	if(!was_successful){
		
	}
	
	if(oauth_result)
	{
		if(oauth_post_args)
		{
			free(oauth_post_args);
			oauth_post_args = 0;
		}
		if(oauth_result)
		{
			free(oauth_result);
			oauth_result = 0;
		}
	}
	
	if(curl_buffer)
	{
		free_curl_buffer(curl_buffer);
	}
	
	if(curl_handler)
	{
		curl_easy_cleanup(curl_handler);
	}
	
	return was_successful;
}

char* perform_link_http_request(const char* URL, 
								OauthTokenPairs* consumer_keys, 
								OauthTokenPairs* tokens)
{
	int was_successful = 1;
	char* oauth_post_args = 0;
	char* oauth_result = 0;
	char* signed_url = 0;
	
	do
	{
		if(!URL)
		{
			was_successful = 0;
			break;
		}
		
		if(0 == consumer_keys)
		{
			was_successful = 0;
			break;
		}
		
		oauth_result = oauth_sign_url2( URL,
										&oauth_post_args,
										OA_HMAC, 
										0,
										consumer_keys->token,
										consumer_keys->token_secret,
										tokens->token,
										tokens->token_secret);
		if(!oauth_result)
		{
			was_successful = 0;
			break;
		}
		
		int signed_url_size = strlen(oauth_result) + strlen(oauth_post_args) + 2;
		signed_url = (char*) malloc(sizeof(char) * signed_url_size);
		if(!signed_url)
		{
			was_successful = 0;
			break;
		}
		memset(signed_url, 0, signed_url_size);
		
		strcat(signed_url, oauth_result);
		strcat(signed_url, "?");
		strcat(signed_url, oauth_post_args);
		
	}while(0);
		
	if(!was_successful){
		return 0;
	}
	
	if(oauth_result)
	{
		if(oauth_post_args)
		{
			free(oauth_post_args);
			oauth_post_args = 0;
		}
		if(oauth_result)
		{
			free(oauth_result);
			oauth_result = 0;
		}
	}
	
	return signed_url;
}

int perform_jason_http_request(const char* URL, OauthTokenPairs* consumer_keys, OauthTokenPairs* tokens)
{
	int was_successful = 1;
	
	do{
		
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}

int parse_rest_call_response(CurlBuffer* curl_buffer, OauthTokenPairs* tokens)
{
	int was_successful = 1;
	
	do{
		char* ptr_oauth_token_secret = 0;
		char* ptr_oauth_token = 0;
		char* ptr_seeker = 0;
		
		if(!curl_buffer || !tokens)
		{
			was_successful = 0;
			break;
		}
		
		ptr_oauth_token_secret = strstr(curl_buffer->data, "oauth_token_secret");
		if(!ptr_oauth_token_secret)
		{
			was_successful = 0;
			break;
		}
		ptr_seeker = ptr_oauth_token_secret;
		
		ptr_seeker = strchr(ptr_oauth_token_secret, '=');
		if(!ptr_seeker)
		{
			was_successful = 0;
			break;
		}
		ptr_seeker++;
		
		int index;
		for(; ptr_oauth_token_secret != ptr_seeker; ptr_oauth_token_secret++)
		{
			*ptr_oauth_token_secret = '.';
		}
		
		for(index = 0, ptr_seeker; 
			*ptr_seeker != '&' && *ptr_seeker != 0; 
			index++, ptr_seeker++)
		{
			tokens->token_secret[index] = *ptr_seeker;
		}
		
		ptr_oauth_token = strstr(curl_buffer->data, "oauth_token");
		if(!ptr_oauth_token)
		{
			was_successful = 0;
			break;
		}
		ptr_seeker = ptr_oauth_token;
		
		ptr_seeker = strchr(ptr_oauth_token, '=');
		if(!ptr_seeker)
		{
			was_successful = 0;
			break;
		}
		ptr_seeker++;
		
		for(index = 0, ptr_seeker; 
			*ptr_seeker != '&' && *ptr_seeker != 0; 
			index++, ptr_seeker++)
		{
			tokens->token[index] = *ptr_seeker;
		}
		
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}