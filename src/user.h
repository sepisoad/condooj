#ifndef USER_HEADER
#define USER_HEADER

char* get_user_data_file_path();
int user_exist();
int create_user(const unsigned char* passphrase); //FIXME
int remove_user(); //FIXME
int update_user(const unsigned char* passphrase, 
				const char* access_token, 
				const char* access_token_secret); //FIXME

#endif //USER_HEADER