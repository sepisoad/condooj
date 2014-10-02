#include "cli/cli_app.h"
#include "gui/gui_app.h"
#include "tests/tests.h"

//#undef 	RUN_GUI_APP
//#define 	RUN_CLI_APP

int main(int argc, char **argv)
{
#ifdef RUN_GUI_APP
	start_gui_app();
#elif RUN_CLI_APP
	start_cli_app();
#else
	run_all_tests();
#endif
	return 0;
}