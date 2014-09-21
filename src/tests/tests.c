#include "tests.h"
#include "../utils.h"

int run_test (callback test)
{
	if(!test())
		return 0;
	
	return 1;
}

int test_dir_exist()
{
	return dir_exist("/home");
}

//int test_file_exist(){}
//int test_create_dir(){}
//int test_remove_dir(){}
//int test_remove_file(){}
//int test_load_file_to_mem(){}
//int test_get_user_home_folder(){}
//int test_build_path(){}