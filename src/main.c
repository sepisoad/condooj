#include "app.h"
#include "tests/tests.h"

int main(int argc, char **argv)
{
#ifndef RUN_TESTS
	start_app();
#else
	run_all_tests();
#endif
	return 0;
}

#if 0
int was_successful = 0;
	
do{
	
	was_successful = 1;
}while(0);

if(!was_successful)
{
	
}

return was_successful;
#endif