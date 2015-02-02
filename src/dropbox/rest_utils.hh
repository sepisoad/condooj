#ifndef REST_UTILS_HEADER
#define REST_UTILS_HEADER

#include <string.h>
#include "../utils/utils.hh"
#include "../json/cJSON.hh"

#define CURL_BUF_SIZE 2048

typedef enum{
	HTTP_METHOD_NONE = 0,
	HTTP_METHOD_GET,
	HTTP_METHOD_POST
}HttpMethod;

typedef struct{
	char* token;
	char* token_secret;
	size_t token_size;
	size_t token_secret_size;
}OauthTokenPairs;

OauthTokenPairs* create_oauth_token_pairs(	size_t token_size, 
											size_t token_secret_size);
											
void free_oauth_token_pairs(OauthTokenPairs* pair);

int set_oauth_token_pairs(	OauthTokenPairs* pair, 
							const char* token, 
							const char* token_secret);
							
int zero_oauth_token_pairs(OauthTokenPairs* pair);
						
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
								
Buffer* perform_http_request(	const char* URL, 
								HttpMethod method,
								OauthTokenPairs* consumer_keys, 
								OauthTokenPairs* tokens);

int is_http_result_ok(const Buffer* curl_buffer);
								
int parse_rest_call_response(	const Buffer* curl_buffer, 
								OauthTokenPairs* tokens);

#endif //REST_UTILS_HEADER