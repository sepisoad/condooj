#include "app.h"
#include "tests/tests.h"

#undef RUN_TESTS

int main(int argc, char **argv)
{
#ifndef RUN_TESTS
	start_app();
#else
	run_all_tests();
#endif
	return 0;
}