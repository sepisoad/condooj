#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tests.hh"
#include "../utils/utils.hh"
#include "../encryption/sha256.hh"
#include "../encryption/aes.hh"
#include "../encryption/protection.hh"
#include "../user/user.hh"

int run_test (callback test)
{
	if(!test())
		return 0;
	
	return 1;
}

int test_dir_exist()
{
	return dir_exist("/home");
}

//int test_file_exist(){}
//int test_create_dir(){}
//int test_remove_dir(){}
//int test_remove_file(){}
//int test_load_file_to_mem(){}
//int test_get_user_home_folder(){}
//int test_build_path(){}

int test_sha256()
{
	unsigned char input[] = {"my name is sepehr aryani"};
	unsigned char hash[33] = {0}; // one extra byte for null termination ;)
	SHA256_CTX ctx;
	size_t len = strlen((char*)input);
	
	sha256_init(&ctx);
	sha256_update(&ctx, input, len);
	sha256_final(&ctx, hash);
	
	printf("\n");
	int index;
	for(index = 0; index < 33; index++)
		printf("%x", hash[index]);
	printf("\n");
	return 1;
}

int test_aes()
{
	unsigned char text[] = "wow, hey mother fucker, what are you up to, fuck you bitch, what the fuck are you doing, suck my cock";
	unsigned char key[32] = {"abcdefghijklmnopqrstuvwxyz12345"};
	unsigned int key_schedule[60] = {0};
	size_t len = strlen((char*)text);
	int index = 0;
	int can_break = 0;
	
	aes_key_setup(key, key_schedule, 256);
	do
	{
		int count;
		unsigned char input[16];
		unsigned char cipher[16];
		unsigned char dec[16];
		
		memset(input, 0, 16);
		memset(cipher, 0, 16);
		memset(dec, 0, 16);
		
		if(len <= 0)
			break;
		
		if(len < 16)
		{
			memcpy(input, text + index, len);
			can_break = 1;
		}
		else
		{
			memcpy(input, text + index, 16);
			len -= 16;
			index += 16;
		}
		
		aes_encrypt(input, cipher, key_schedule, 256);
		
		for(count = 0; count < 16; count++)
			printf("%x", cipher[count]);
		printf("\n");
		
		aes_decrypt(cipher, dec, key_schedule, 256);
		
		for(count = 0; count < 16; count++)
			printf("%c", dec[count]);
		printf("\n");
		
	}while(!can_break);
	
	return 1;
}

int test_sha256_aes()
{
	unsigned char text[] = "wow, hey mother fucker, what are you up to, fuck you bitch, what the fuck are you doing, suck my cock";
	unsigned char passphrase[] = {"my name is sepehr aryani"};
	unsigned char digest[32] = {0};
	unsigned int key_schedule[60] = {0};
	size_t text_len = strlen((char*)text);
	size_t passphrase_len = strlen((char*)passphrase);
	SHA256_CTX ctx;
	
	sha256_init(&ctx);
	sha256_update(&ctx, passphrase, passphrase_len);
	sha256_final(&ctx, digest);
	
	int index = 0;
	int can_break = 0;
	
	aes_key_setup(digest, key_schedule, 256);
	do
	{
		int count;
		unsigned char input[16];
		unsigned char cipher[16];
		unsigned char dec[16];
		
		memset(input, 0, 16);
		memset(cipher, 0, 16);
		memset(dec, 0, 16);
		
		if(text_len <= 0)
			break;
		
		if(text_len < 16)
		{
			memcpy(input, text + index, text_len);
			can_break = 1;
		}
		else
		{
			memcpy(input, text + index, 16);
			text_len -= 16;
			index += 16;
		}
		
		aes_encrypt(input, cipher, key_schedule, 256);
		
		for(count = 0; count < 16; count++)
			printf("%x", cipher[count]);
		printf("\n");
		
		aes_decrypt(cipher, dec, key_schedule, 256);
		
		for(count = 0; count < 16; count++)
			printf("%c", dec[count]);
		printf("\n");
		
	}while(!can_break);
	
	return 1;
}

int test_encrypt_memory()
{
	unsigned char data[] = "my name is sepehr aryani, what the fuck does the name mean? ha?";
	unsigned char passphrase[] = "shitty passphrase";
	unsigned char digest[32] = {0};
	unsigned char* enc_data = 0;
	size_t enc_data_len = 0;
	
	if(!create_passphrase_digest(passphrase, digest))
		return 0;
	
	if(!encrypt_memory(data, strlen((char*)data), digest, &enc_data, &enc_data_len))
		return 0;
		
	printf("\n%s\n", enc_data);
	
	return 1;
}
int test_decrypt_memory();

int test_encrypt_decrypt_memory()
{
	unsigned char data[] = "my name is sepehr aryani, what the fuck does the name mean? ha? why don't you ask the kids at te...";
	unsigned char passphrase[] = "shitty passphrase";
	unsigned char digest[32] = {0};
	unsigned char* enc_data = 0;
	unsigned char* dec_data = 0;
	size_t enc_data_len = 0;
	size_t dec_data_len = 0;
	
	if(!create_passphrase_digest(passphrase, digest))
		return 0;
	
	if(!encrypt_memory(data, strlen((char*)data), digest, &enc_data, &enc_data_len))
		return 0;
	
	printf("%s", enc_data);
	printf("\n============\n");
		
	if(!decrypt_memory(enc_data, enc_data_len, digest, &dec_data, &dec_data_len))
		return 0;
	
	printf("%s", dec_data);
	printf("\n============\n");
	
	free(enc_data);
	free(dec_data);
	
	return 1;
}


int test_update_user()
{
	int was_successful = 0;
	
	do{
		if(!update_user("sepi", "soad"))
			break;
			
		if(!update_user("fuck", "you"))
			break;
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}

	return was_successful;
}