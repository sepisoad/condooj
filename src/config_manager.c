#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include "globals.h"
#include "config_manager.h"

char* read_config_file(const char* section, const char* key)
{
	int was_successful = 0;
	char* user_home_folder_path = 0;
	char* app_folder_path = 0;
	char* return_value = 0;
	
	// here we have some posix function which will stop the code to be compiled
	// on none posix compilent system like fucking MS Windows

	do{
		if(!section || !key)
		{
			break;
		}
		
		struct stat status;
		user_home_folder_path = getenv("HOME"); // no need to free this string buffer
		if(!user_home_folder_path)
		{
			break;
		}
		
		int len = strlen(user_home_folder_path) + strlen("/") + strlen(APP_BASE_FOLDER_NAME) + 1;									
		app_folder_path = (char*) malloc (sizeof(char) * len); 
		if(!app_folder_path)
		{
			break;
		}
		memset(app_folder_path, 0, len);
		
		strcat(app_folder_path, user_home_folder_path);
		strcat(app_folder_path, "/");
		strcat(app_folder_path, APP_BASE_FOLDER_NAME);

		if(stat(app_folder_path, &status) != 0)
		{
			create_config_file(app_folder_path);
			break;
		}
		
		was_successful = 1;
	}while(0);
		
	if(!was_successful)
	{
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	return return_value;
}

int get_user_info_from_config_file(UserInfo* ui)
{
	int was_successful = 0;
	char* user_home_folder_path = 0;
	char* app_folder_path = 0;
	
	// here we have some posix function which will stop the code to be compiled
	// on none posix compilent system like fucking MS Windows

	do{
		if(!section || !key)
		{
			break;
		}
		
		struct stat status;
		user_home_folder_path = getenv("HOME"); // no need to free this string buffer
		if(!user_home_folder_path)
		{
			break;
		}
		
		int len = strlen(user_home_folder_path) + strlen("/") + strlen(APP_BASE_FOLDER_NAME) + 1;									
		app_folder_path = (char*) malloc (sizeof(char) * len); 
		if(!app_folder_path)
		{
			break;
		}
		memset(app_folder_path, 0, len);
		
		strcat(app_folder_path, user_home_folder_path);
		strcat(app_folder_path, "/");
		strcat(app_folder_path, APP_BASE_FOLDER_NAME);

		if(stat(app_folder_path, &status) != 0)
		{
			create_config_file(app_folder_path);
			break;
		}
		
		was_successful = 1;
	}while(0);
		
	if(!was_successful)
	{
		
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	return was_successful;
}

int create_config_file(const char* path)
{
	int was_successful = 0;
	char* app_config_file_path = 0;
	
	do{
		if(mkdir(path, S_IRUSR | S_IWUSR | S_IXUSR) != 0)
		{
			// oh shit
			// failed to create the app directory
			break;
		}	

		int len = strlen(path) + strlen("/") + strlen(CONFIG_FILE_NAME) + 1;
		app_config_file_path = (char*) malloc(sizeof(char) * len);
		if(!app_config_file_path)
		{
			break;
		}
		memset(app_config_file_path, 0, len);
		
		strcat(app_config_file_path, path);
		strcat(app_config_file_path, "/");
		strcat(app_config_file_path, CONFIG_FILE_NAME);
		
		FILE* config_file = fopen(app_config_file_path, "w");
		fprintf(config_file,"{\n\t\"AppInfo\" : \n\t{\n");
		fprintf(config_file,"\t\t\"Name\" : \"condooj\",\n");
		fprintf(config_file,"\t\t\"Version\" : \"0.0.0\",\n");
		fprintf(config_file,"\t\t\"License\" : \"GPLv3\",\n");
		fprintf(config_file,"\t\t\"Description\" : \"\",\n\t},");
		
		fprintf(config_file,"\n\n\t\"AuthorInfo\" : \n\t{\n");
		fprintf(config_file,"\t\t\"Name\" : \"Sepehr Aryani\",\n");
		fprintf(config_file,"\t\t\"Email\" : \"sepehr.aryani@gmail.com\",\n");
		fprintf(config_file,"\t\t\"github\" : \"@sepisoad\",\n");
		fprintf(config_file,"\t\t\"twitter\" : \"@sepisoad\",\n\t},");
		
		fprintf(config_file,"\n\n\t\"UserInfo\" : \n\t{\n");
		fprintf(config_file,"\t\t\"DisplayName\" : \"\",\n");
		fprintf(config_file,"\t\t\"AccessToken\" : \"\",\n");
		fprintf(config_file,"\t\t\"AccessTokenSecret\" : \"\",\n");
		fprintf(config_file,"\t\t\"UID\" : \"\",\n");
		fprintf(config_file,"\t\t\"ReferralLink\" : \"\",\n\t},");
		
		fprintf(config_file,"\n}\n");
		fclose(config_file);
		
		was_successful = 1;
	}while(0);
		
	if(!was_successful)
	{
		
	}
	
	if(app_config_file_path)
	{
		free(app_config_file_path);
	}
	
	return was_successful;
}

int update_config_file(const char* section, const char* key, const char* value)
{
	int was_successful = 0;
	
	do{
		
		was_successful = 1;
	}while(0);
		
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}