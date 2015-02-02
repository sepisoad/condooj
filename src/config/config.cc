#include <stdlib.h>
#include <stdio.h>
#include "../app/app.hh"
#include "../utils/utils.hh"
#include "config.hh"

char* get_config_file_path()
{
	int was_successful = 0;
	char* user_home_folder_path = 0;
	char* app_folder_path = 0;
	char* app_config_file_path = 0;
	
	do{
		user_home_folder_path = get_user_home_folder();
		if(!user_home_folder_path)
			break;
		
		app_folder_path = build_path(user_home_folder_path, APP_BASE_FOLDER_NAME);
		if(!app_folder_path)
			break;
			
		app_config_file_path = build_path(app_folder_path, CONFIG_FILE);
		if(!app_config_file_path)
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		app_config_file_path = 0;
	}
	
	if(user_home_folder_path)
	{
		free(user_home_folder_path);
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}

	return app_config_file_path;
}

int config_file_exist()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* app_config_file_path = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		if(!dir_exist(app_folder_path))
			break;
		
		app_config_file_path = get_config_file_path();
		if(!app_config_file_path)
			break;
			
		if(!file_exist(app_config_file_path))
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	if(app_config_file_path)
	{
		free(app_config_file_path);
	}

	return was_successful;
}

int create_config_file()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* app_config_file_path = 0;
	FILE* config_file = 0;
	
	do{		
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		if(!dir_exist(app_folder_path))
		{
			if(!create_dir(app_folder_path))
				break;
		}
		
		app_config_file_path = get_config_file_path();
		if(!app_config_file_path)
			break;
			
		if(!file_exist(app_config_file_path))
		{
			config_file = fopen(app_config_file_path, "w");
			if(!config_file)
				break;
		}
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	if(config_file)
	{
		fclose(config_file);
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}
	
	if(app_config_file_path)
	{
		free(app_config_file_path);
	}

	return was_successful;
}

char* read_config_file(const char* section, const char* key)
{
	int was_successful = 0;
	char* app_config_file_path = 0;
	char* config_file_content = 0;
	
	do{
		if(!section || !key)
		{
			break;
		}
		
		if(!config_file_exist())
			break;
		
		app_config_file_path = get_config_file_path();
		if(!app_config_file_path)
			break;
			
		config_file_content = load_file_to_mem(app_config_file_path);
		if(!config_file_content)
			break;
		
		was_successful = 1;
	}while(0);
		
	if(!was_successful)
	{
		config_file_content = 0;
	}
	
	if(app_config_file_path)
	{
		free(app_config_file_path);
	}
	
	return config_file_content;
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