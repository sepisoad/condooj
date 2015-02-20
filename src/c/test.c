#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "protection.h"

int test_encrypt_decrypt_memory()
{
	// unsigned char data[] = "my name is sepehr aryani, what the fuck does the name mean? ha? why don't you ask the kids at te...";
	unsigned char data[] = "hello mother fuckers this is a sample fucking string buffer";
	// unsigned char passphrase[] = "shitty passphrase";
	unsigned char passphrase[] = "a fucking key";
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

void main(){
	test_encrypt_decrypt_memory();
}