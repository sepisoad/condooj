#include "app.h"
#include "tests/tests.h"

int main(int argc, char **argv)
{
#if 1
	start_app();
#else
	run_all_tests();
#endif
	return 0;
}