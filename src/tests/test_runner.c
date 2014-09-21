#include "tests.h"

int run_all_tests()
{
	int was_successful = 0;
	
	do{
		if(!run_test(test_dir_exist))
			break;

		was_successful = 1;
	}while(0);
	
	return was_successful;
}