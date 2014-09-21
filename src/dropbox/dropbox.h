#ifndef DROPBOX_HEADER
#define DROPBOX_HEADER

#include "rest_utils.h"

extern char dropbox_oauth_token[KEY_BUF_SIZE];
extern char dropbox_oauth_token_secret[KEY_BUF_SIZE];

int dropbox_request_token(	const char* consumer_key, 
							const char* consumer_secret);
							
char* dropbox_authorize(const char* consumer_key, 
						const char* consumer_secret);
						
int dropbox_access_token(	const char* consumer_key, 
							const char* consumer_secret, 
							char** access_token,
							char** access_token_secret);
							
int dropbox_account_info(OauthTokenPairs* consumer_keys, OauthTokenPairs* tokens); //FIXME

#endif //DROPBOX_HEADER