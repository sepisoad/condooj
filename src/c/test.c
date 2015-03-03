#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "utils.h"

int test_encrypt_decrypt_memory()
{
	// unsigned char data[] = "my name is sepehr aryani, what the fuck does the name mean? ha? why don't you ask the kids at te...";
	// unsigned char data[] = "hello mother fuckers this is a sample fucking string buffer";
	unsigned char data[] = 
// "\
// 	{\
// 	\"title\": \"Shit\",\
// 	\"username\": \"sepi\",\
// 	\"password\": \"1987\",\
// 	\"email\": \"UNDEFINED\",\
// 	\"description\": \"UNDEFINED\",\
// 	\"date\": \"2015-03-01\",\
// 	}\
// ";
"{\"title\": \"mom\", \"username\": \"sepi\", \"password\": \"1987\", \"email\": \"UNDEFINED\", \"description\": \"wtf\", \"date\": \"2015-03-03\" }";

	unsigned char passphrase[] = "a fucking key";
	unsigned char digest[32] = {0};
	unsigned char* enc_data_mem = 0;
	unsigned char* dec_data_mem = 0;
	size_t enc_data_mem_len = 0;
	size_t dec_data_mem_len = 0;
	
	if(!create_passphrase_digest(passphrase, digest))
		return 0;
	
	if(!encrypt_memory(data, strlen((char*)data), digest, &enc_data_mem, &enc_data_mem_len))
		return 0;

	if(!save_encrypted_memory("db", enc_data_mem, enc_data_mem_len))
		return 0;

	if(!load_encrypted_file("db", digest, &dec_data_mem, &dec_data_mem_len))
		return 0;

	printf("%s\n", dec_data_mem);

	free_allocated_mem(enc_data_mem);
	free_allocated_mem(dec_data_mem);
	
	return 1;
}

void main(){
	test_encrypt_decrypt_memory();
}