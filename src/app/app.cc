#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "app.hh"
#include "../utils/utils.hh"

unsigned char passphrase_digest[32] = {0};

char* get_app_folder_path()
{
	int was_successful = 0;
	char* user_home_folder_path = 0;
	char* app_folder_path = 0;
	
	do{
		user_home_folder_path = get_user_home_folder();
		if(!user_home_folder_path)
			break;
		
		app_folder_path = build_path(user_home_folder_path, APP_BASE_FOLDER_NAME);
		if(!app_folder_path)
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		app_folder_path = 0;
	}
	
	if(user_home_folder_path)
	{
		free(user_home_folder_path);
	}

	return app_folder_path;
}