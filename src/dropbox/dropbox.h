#ifndef DROPBOX_HEADER
#define DROPBOX_HEADER

#define KEY_BUF_SIZE 256

extern char dropbox_oauth_token[KEY_BUF_SIZE];
extern char dropbox_oauth_token_secret[KEY_BUF_SIZE];

typedef struct{
	char* referral_link;
	char* display_name;
	char* country;
	char* email;
	unsigned long uid;
}DropBoxUserInfo;

DropBoxUserInfo* create_dropbox_user_info(	const char* referral_link,
											const char* display_name,
											const char* country,
											const char* email,
											unsigned long uid);

int delete_dropbox_user_info(DropBoxUserInfo* dbui);

int set_dropbox_access_tokens(	const char* access_token,
								const char* access_token_secret);

int dropbox_request_token(	const char* consumer_key, 
							const char* consumer_secret);
							
char* dropbox_authorize(const char* consumer_key, 
						const char* consumer_secret);
						
int dropbox_access_token(	const char* consumer_key, 
							const char* consumer_secret, 
							char** access_token,
							char** access_token_secret);
							
int dropbox_account_info(	const char* consumer_key, 
							const char* consumer_secret);

#endif //DROPBOX_HEADER