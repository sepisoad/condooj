#define APP_BASE_FOLDER_NAME ".condooj"
#define CONFIG_FILE_NAME "config.json"
#define USER_DATA_FILE "user.data"
#define CONSUMER_KEY "hkcnl3viglfuf5k"
#define CONSUMER_SECRET "q7mkice2q1t22xz"

#define MAX_SHA_LOOP 1000

int start_app();
char* get_app_folder_path();
int authorize_dropbox_user();