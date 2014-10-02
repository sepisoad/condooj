#ifndef UTILS_HEADER
#define UTILS_HEADER

typedef struct{
	char* data;
	size_t size;
}Buffer;

int dir_exist(const char* path);
int file_exist(const char* path);
int create_dir(const char* path);
int remove_dir(const char* path); //FIXME
int remove_file(const char* path); //FIXME
char* get_user_home_folder();
char* load_file_to_mem(const char* path);
char* build_path(const char* base, const char* ext);
Buffer* create_buffer(size_t size);
void free_buffer(Buffer* buf);

#endif //UTILS_HEADER