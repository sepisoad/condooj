#ifndef TESTS_HEADER
#define TESTS_HEADER

typedef int (*callback)();
int run_test(callback test);

int run_all_tests();

int test_dir_exist();
int test_file_exist();
int test_create_dir();
int test_remove_dir();
int test_remove_file();
int test_load_file_to_mem();
int test_get_user_home_folder();

int test_sha256();
int test_aes();
int test_sha256_aes();

#endif //TESTS_HEADER