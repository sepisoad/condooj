#define APP_NAME "Condooj"
#define APP_VERSION "0.0.1"
#define APP_LICENSE "GPLv3"
#define APP_DESCRIPTION "a simple password manager"
#define AUTHOR_NAME "Sepehr Aryani"
#define AUTHOR_EMAIL "sepehr.aryani@gmail.com"
#define AUTHOR_GITHUB "@sepisoad"
#define AUTHOR_TWITTER "@sepisoad"

#define APP_BASE_FOLDER_NAME ".condooj"
#define CONFIG_FILE "config"
#define USER_FILE "user"

#define CONSUMER_KEY "hkcnl3viglfuf5k"
#define CONSUMER_SECRET "q7mkice2q1t22xz"

#define MAX_SHA_LOOP 1000

extern unsigned char passphrase_digest[32];

char* get_app_folder_path();