#ifndef PROTECTION_HEADER
#define PROTECTION_HEADER

int create_passphrase_digest(unsigned const char* passphrase, 
							 unsigned char* digest);
								
int encrypt_memory(const unsigned char* buffer,
				   size_t buffer_len,
				   const unsigned char* key,
				   unsigned char** encrypted_buffer,
				   size_t* encrypted_buffer_len);
										
int decrypt_memory(const unsigned char* buffer,
				   size_t buffer_len,
				   const unsigned char* key,
				   unsigned char** decrypted_buffer,
				   size_t* decrypted_buffer_len);

int encrypt_file(const char* file,
				 unsigned const char* key); //FIXME
					
int decrypt_file(const char* file,
				 unsigned const char* key); //FIXME

#endif //PROTECTION_HEADER