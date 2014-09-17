#ifndef REST_UTILS_HEADER
#define REST_UTILS_HEADER

#include <string.h>
#include "../json/cJSON.h"

#define KEY_BUF_SIZE 256
#define CURL_BUF_SIZE 2048

typedef struct{
	char* token;
	char* token_secret;
	size_t token_size;
	size_t token_secret_size;
}OauthTokenPairs;

typedef struct{
	char* data;
	size_t size;
}CurlBuffer;

OauthTokenPairs* create_oauth_token_pairs(	size_t token_size, 
											size_t token_secret_size);
											
void free_oauth_token_pairs(OauthTokenPairs* pair);

int set_oauth_token_pairs(	OauthTokenPairs* pair, 
							const char* token, 
							const char* token_secret);
							
CurlBuffer* create_curl_buffer(size_t size);

void free_curl_buffer(CurlBuffer* buf);

size_t write_into_curl_buffer(	char* data, 
								size_t data_size, 
								size_t nmemb, 
								void* buf);
								
int perform_token_http_request(	const char* URL, 
								OauthTokenPairs* consumer_keys, 
								OauthTokenPairs* tokens);
								
char* perform_link_http_request(const char* URL, 
								OauthTokenPairs* consumer_keys, 
								OauthTokenPairs* tokens);
								
int parse_rest_call_response(	CurlBuffer* curl_buffer, 
								OauthTokenPairs* tokens);

#endif //REST_UTILS_HEADER