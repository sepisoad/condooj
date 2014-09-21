#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include "utils.h"

int dir_exist(const char* path)
{
	int was_successful = 0;
	
	do{
		if(!path)
			break;

		struct stat status;
		if(stat(path, &status) != 0)
			break;
			
		if(!S_ISDIR(status.st_mode))
			break;
		
		was_successful = 1;
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}

int file_exist(const char* path)
{
	int was_successful = 0;
	
	do{
		if(!path)
			break;

		struct stat status;
		if(stat(path, &status) != 0)
			break;
			
		if(!S_ISREG(status.st_mode))
			break;
		
		was_successful = 1;
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}

int create_dir(const char* path)
{
	int was_successful = 0;
	
	do{
		if(!path)
			break;

		if(mkdir(path, S_IRUSR | S_IWUSR | S_IXUSR) != 0)
			break;
		
		was_successful = 1;
	}while(0);
	
	if(!was_successful)
	{
		
	}
	
	return was_successful;
}

int remove_dir(const char* path);
int remove_file(const char* path);

char* get_user_home_folder()
{
	int was_successful = 0;
	const char* protected_string = 0;
	char* return_value = 0;

	do{
		protected_string = getenv("HOME"); 
		if(!protected_string)
			break;
		
		int len = strlen(protected_string) + 1;
		return_value = (char*) malloc(sizeof(char) * len);
		if(!return_value)
			break;
			
		memset(return_value, 0, len);
		strcpy(return_value, protected_string);
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		return_value = 0;
	}

	return return_value;
}

char* load_file_to_mem(const char* path)
{
	int was_successful = 0;
	char* buffer = 0;
	int buffer_len = 0;
	FILE* file = 0;
		
	do{
		if(!path)
			break;
			
		file = fopen(path, "r");
		if(!file)
			break;
			
		fseek(file, 0, SEEK_END);
		buffer_len = ftell(file);
		rewind(file);
		
		buffer = (char*) malloc(sizeof(char) * (buffer_len + 1));
		if(!buffer)
			break;
		
		if(fread((void*)buffer, sizeof(char), buffer_len, file) < buffer_len)
			break;
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		buffer = 0;
	}
	
	if(file)
	{
		fclose(file);
	}

	return buffer;
}

char* build_path(const char* old_path, const char* ext)
{
	int was_successful = 0;
	char* new_path = 0;
		
	do{
		if(!old_path)
			break;
			
		if(!ext)	
			break;
			
		int new_path_len = strlen(old_path) + strlen(ext) + 2;
		
		new_path = (char*) malloc(sizeof(char) * new_path_len);
		if(!new_path)
			break;
			
		memset(new_path, 0, new_path_len);
		
		strcat(new_path, old_path);
		strcat(new_path, "/");
		strcat(new_path, ext);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		
	}
	
	return new_path;
}