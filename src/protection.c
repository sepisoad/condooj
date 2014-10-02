#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "protection.h"
#include "utils.h"
#include "encryption/sha256.h"
#include "encryption/aes.h"

int create_passphrase_digest(const unsigned char* passphrase, unsigned char* digest)
{
	int was_successful = 0;
	
	do{
		if(!passphrase)
			break;
			
		SHA256_CTX ctx;
		size_t passphrase_len = strlen((char*)passphrase);
		
		sha256_init(&ctx);
		sha256_update(&ctx, passphrase, passphrase_len);
		sha256_final(&ctx, digest);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}

	return was_successful;
}


int encrypt_memory(const unsigned char* buffer,
				   size_t buffer_len,
				   const unsigned char* key,
				   unsigned char** encrypted_buffer,
				   size_t* encrypted_buffer_len)
{
	int was_successful = 0;
	unsigned int key_schedule[60] = {0};
	
	do{
		if(!buffer || !key || 0 >= buffer_len)
			break;
			
		*encrypted_buffer_len = buffer_len % 16;
		*encrypted_buffer_len = 16 - *encrypted_buffer_len;
		*encrypted_buffer_len += buffer_len;
		
		*encrypted_buffer = (unsigned char*) malloc(sizeof(unsigned char) * (*encrypted_buffer_len));
		if(!(*encrypted_buffer))
			break;
			
		memset(*encrypted_buffer, 0, *encrypted_buffer_len);
		
		const unsigned char* ptr_buffer = buffer;
		unsigned char* ptr_encrypted_buffer = *encrypted_buffer;
			
		aes_key_setup((unsigned char*)key, key_schedule, 256);
		
		int index = 0;
		int can_break = 0;
		do
		{
			unsigned char input[16];
			unsigned char cipher[16];
			
			memset(input, 0, 16);
			memset(cipher, 0, 16);
			
			if(buffer_len <= 0)
				break;
			
			if(buffer_len < 16)
			{
				memcpy(input, ptr_buffer + index, buffer_len);
				can_break = 1;
			}
			else
			{
				memcpy(input, ptr_buffer + index, 16);
				buffer_len -= 16;
				index += 16;
			}
			
			aes_encrypt(input, cipher, key_schedule, 256);	
			memcpy(ptr_encrypted_buffer, cipher, 16);

			ptr_encrypted_buffer += 16;
		}while(!can_break);
		
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	}

	return was_successful;
}

int decrypt_memory(const unsigned char* buffer,
				   size_t buffer_len,
				   const unsigned char* key,
				   unsigned char** decrypted_buffer,
				   size_t* decrypted_buffer_len)
{
	int was_successful = 0;
	unsigned int key_schedule[60] = {0};
	
	do{
		if(!buffer || !key || 0 >= buffer_len)
			break;
			
		*decrypted_buffer_len = buffer_len % 16;
		*decrypted_buffer_len = 16 - *decrypted_buffer_len;
		*decrypted_buffer_len += buffer_len;
			
		*decrypted_buffer = (unsigned char*) malloc(sizeof(unsigned char) * (*decrypted_buffer_len));
		if(!(*decrypted_buffer))
			break;
			
		memset(*decrypted_buffer, 0, *decrypted_buffer_len);
		
		const unsigned char* ptr_buffer = buffer;
		unsigned char* ptr_decrypted_buffer = *decrypted_buffer;
			
		aes_key_setup(key, key_schedule, 256);
		
		int index = 0;
		int can_break = 0;
		do
		{
			unsigned char output[16];
			unsigned char cipher[16];
			
			memset(output, 0, 16);
			memset(cipher, 0, 16);
			
			if(buffer_len <= 0)
				break;
			
			if(buffer_len < 16)
			{
				memcpy(cipher, ptr_buffer + index, buffer_len);
				can_break = 1;
			}
			else
			{
				memcpy(cipher, ptr_buffer + index, 16);
				buffer_len -= 16;
				index += 16;
			}
						
			aes_decrypt(cipher, output, key_schedule, 256);
			memcpy(ptr_decrypted_buffer, output, 16);

			ptr_decrypted_buffer += 16;
		}while(!can_break);

		was_successful = 1;
	}while(0);
	

	if(!was_successful)
	{
	}

	return was_successful;
}