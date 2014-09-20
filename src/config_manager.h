#ifndef CONFIG_MANAGER_HEADER
#define CONFIG_MANAGER_HEADER

extern char* config_user_info_display_name;
extern char* config_user_info_referral_link;
extern char* config_user_info_uid;
extern char* config_user_info_access_token;
extern char* config_user_info_access_token_secret;

typedef strcut 
{
	char* access_token;
	char* access_token_secret;
}UserInfo;

char* read_config_file(const char* section, const char* key);
int create_config_file(); //FIXME
int update_config_file(const char* section, const char* key, const char* value);

#endif // CONFIG_MANAGER_HEADER