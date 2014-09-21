#ifndef CONFIG_MANAGER_HEADER
#define CONFIG_MANAGER_HEADER

extern char* config_user_info_display_name;
extern char* config_user_info_referral_link;
extern char* config_user_info_uid;
extern char* config_user_info_access_token;
extern char* config_user_info_access_token_secret;

char* get_config_file_path();
int config_file_exist();
int create_config_file();
char* read_config_file(const char* section, const char* key); //FIXME
int update_config_file(const char* section, const char* key, const char* value); //FIXME

#endif // CONFIG_MANAGER_HEADER