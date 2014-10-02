#ifndef USER_HEADER
#define USER_HEADER

char* get_user_data_file_path();
int user_exist();
int create_user();
int remove_user(); //FIXME
int update_user(const char* access_token, 
				const char* access_token_secret);
int get_user_data(	char* access_token,
					char* access_token_secret);

#endif //USER_HEADER