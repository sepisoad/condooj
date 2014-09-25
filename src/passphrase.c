#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "passphrase.h"
#include "app.h"
#include "utils.h"
#include "encryption/sha256.h"

char* get_passphrase_file_path()
{
	int was_successful = 0;
	char* app_folder_path = 0;
	char* passphrase_file_path = 0;
	
	do{
		app_folder_path = get_app_folder_path();
		if(!app_folder_path)
			break;
			
		passphrase_file_path = build_path(app_folder_path, PASSPHRASE_FILE);
		if(!passphrase_file_path)
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
		passphrase_file_path = 0;
	}
	
	if(app_folder_path)
	{
		free(app_folder_path);
	}

	return passphrase_file_path;
}

int create_passphrase(const char* passphrase)
{
	int was_successful = 0;
	char* passphrase_file_path = 0;
	FILE* passphrase_file = 0;
	
	do{
		if(!passphrase)
			break;
			
		passphrase_file_path = get_passphrase_file_path();
		if(!passphrase_file_path)
			break;
		
		unsigned char digest[32] = {0};
		SHA256_CTX ctx;
		size_t passphrase_len = strlen((char*)passphrase);
		
		sha256_init(&ctx);
		sha256_update(&ctx, (unsigned char*)passphrase, passphrase_len);
		sha256_final(&ctx, digest);
		
		passphrase_file = fopen(passphrase_file_path, "w");
		if(!passphrase_file)
			break;
			
		fwrite((void*)digest, sizeof(char), 32, passphrase_file);
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}
	
	if(!passphrase_file_path)
	{
		free(passphrase_file_path);
	}
	
	if(passphrase_file)
	{
		fclose(passphrase_file);
	}

	return was_successful;
}

char* get_passphrase()
{
	int was_successful = 0;
	char* passphrase_file_path = 0;
	FILE* passphrase_file = 0;
	char* passphrase = 0;
	
	do{
		passphrase_file_path = get_passphrase_file_path();
		if(!passphrase_file_path)
			break;
			
		if(!file_exist(passphrase_file_path))
			break;
		
		passphrase_file = fopen(passphrase_file_path, "r");
		if(!passphrase_file)
			break;
			
		fseek(passphrase_file, 0, SEEK_END);
		size_t file_len = ftell(passphrase_file);
		rewind(passphrase_file);
		if(0 == file_len)
			break;
		
		passphrase = (char*) malloc (sizeof(char) * (file_len + 1));
		if(!passphrase)
			break;
			
		memset(passphrase, 0, file_len);
		
		if(!fread((void*)passphrase, sizeof(char), file_len, passphrase_file))
			break;
			
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}
	
	if(passphrase_file_path)
	{
		free(passphrase_file_path);
	}
	
	if(passphrase_file)
	{
		fclose(passphrase_file);
	}

	return passphrase;
}