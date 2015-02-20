#ifndef PROTECTION_HEADER
#define PROTECTION_HEADER

int say_hi(const char* str);
void repeat_char(char c, int n);

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

int free_allocated_mem(unsigned char* buffer);

// int encrypt_file(const char* file,
// 				 unsigned const char* key); 
					
// int decrypt_file(const char* file,
// 				 unsigned const char* key); 

#endif //PROTECTION_HEADER