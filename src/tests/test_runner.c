#include "tests.h"

int run_all_tests()
{
	int was_successful = 0;
	
	do{
//		if(!test_sha256())
//			break;
//			
//		if(!test_aes())
//			break;
			
		if(!test_sha256_aes())
			break;

		was_successful = 1;
	}while(0);
	
	return was_successful;
}