##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=condooj
ConfigurationName      :=Debug
WorkspacePath          := "/home/sepisoad/Projects/github/condooj"
ProjectPath            := "/home/sepisoad/Projects/github/condooj"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=Sepehr Aryani
Date                   :=10/02/14
CodeLitePath           :="/home/sepisoad/.codelite"
LinkerName             :=/usr/bin/g++ 
SharedObjectLinkerName :=/usr/bin/g++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.i
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=$(PreprocessorSwitch)DEBUG $(PreprocessorSwitch)RUN_CLI_APP 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :="condooj.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)oauth $(LibrarySwitch)curl 
ArLibs                 :=  "oauth" "curl" 
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := /usr/bin/ar rcu
CXX      := /usr/bin/g++ 
CC       := /usr/bin/gcc 
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := /usr/bin/as 


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/src_main.c$(ObjectSuffix) $(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) $(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) $(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) $(IntermediateDirectory)/tests_tests.c$(ObjectSuffix) $(IntermediateDirectory)/tests_test_runner.c$(ObjectSuffix) $(IntermediateDirectory)/encryption_sha256.c$(ObjectSuffix) $(IntermediateDirectory)/encryption_aes.c$(ObjectSuffix) $(IntermediateDirectory)/encryption_protection.c$(ObjectSuffix) $(IntermediateDirectory)/gui_gui_app.c$(ObjectSuffix) \
	$(IntermediateDirectory)/cli_cli_app.c$(ObjectSuffix) $(IntermediateDirectory)/app_app.c$(ObjectSuffix) $(IntermediateDirectory)/config_config.c$(ObjectSuffix) $(IntermediateDirectory)/user_user.c$(ObjectSuffix) $(IntermediateDirectory)/utils_utils.c$(ObjectSuffix) $(IntermediateDirectory)/imgui_imgui.cpp$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/src_main.c$(ObjectSuffix): src/main.c $(IntermediateDirectory)/src_main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/src_main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/src_main.c$(DependSuffix): src/main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/src_main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/src_main.c$(DependSuffix) -MM "src/main.c"

$(IntermediateDirectory)/src_main.c$(PreprocessSuffix): src/main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/src_main.c$(PreprocessSuffix) "src/main.c"

$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix): src/json/cJSON.c $(IntermediateDirectory)/json_cJSON.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/json/cJSON.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/json_cJSON.c$(DependSuffix): src/json/cJSON.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) -MF$(IntermediateDirectory)/json_cJSON.c$(DependSuffix) -MM "src/json/cJSON.c"

$(IntermediateDirectory)/json_cJSON.c$(PreprocessSuffix): src/json/cJSON.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/json_cJSON.c$(PreprocessSuffix) "src/json/cJSON.c"

$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix): src/dropbox/rest_utils.c $(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/dropbox/rest_utils.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix): src/dropbox/rest_utils.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix) -MM "src/dropbox/rest_utils.c"

$(IntermediateDirectory)/dropbox_rest_utils.c$(PreprocessSuffix): src/dropbox/rest_utils.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_rest_utils.c$(PreprocessSuffix) "src/dropbox/rest_utils.c"

$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix): src/dropbox/dropbox.c $(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/dropbox/dropbox.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix): src/dropbox/dropbox.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix) -MM "src/dropbox/dropbox.c"

$(IntermediateDirectory)/dropbox_dropbox.c$(PreprocessSuffix): src/dropbox/dropbox.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_dropbox.c$(PreprocessSuffix) "src/dropbox/dropbox.c"

$(IntermediateDirectory)/tests_tests.c$(ObjectSuffix): src/tests/tests.c $(IntermediateDirectory)/tests_tests.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/tests/tests.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/tests_tests.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/tests_tests.c$(DependSuffix): src/tests/tests.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/tests_tests.c$(ObjectSuffix) -MF$(IntermediateDirectory)/tests_tests.c$(DependSuffix) -MM "src/tests/tests.c"

$(IntermediateDirectory)/tests_tests.c$(PreprocessSuffix): src/tests/tests.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/tests_tests.c$(PreprocessSuffix) "src/tests/tests.c"

$(IntermediateDirectory)/tests_test_runner.c$(ObjectSuffix): src/tests/test_runner.c $(IntermediateDirectory)/tests_test_runner.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/tests/test_runner.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/tests_test_runner.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/tests_test_runner.c$(DependSuffix): src/tests/test_runner.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/tests_test_runner.c$(ObjectSuffix) -MF$(IntermediateDirectory)/tests_test_runner.c$(DependSuffix) -MM "src/tests/test_runner.c"

$(IntermediateDirectory)/tests_test_runner.c$(PreprocessSuffix): src/tests/test_runner.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/tests_test_runner.c$(PreprocessSuffix) "src/tests/test_runner.c"

$(IntermediateDirectory)/encryption_sha256.c$(ObjectSuffix): src/encryption/sha256.c $(IntermediateDirectory)/encryption_sha256.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/encryption/sha256.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_sha256.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_sha256.c$(DependSuffix): src/encryption/sha256.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_sha256.c$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_sha256.c$(DependSuffix) -MM "src/encryption/sha256.c"

$(IntermediateDirectory)/encryption_sha256.c$(PreprocessSuffix): src/encryption/sha256.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_sha256.c$(PreprocessSuffix) "src/encryption/sha256.c"

$(IntermediateDirectory)/encryption_aes.c$(ObjectSuffix): src/encryption/aes.c $(IntermediateDirectory)/encryption_aes.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/encryption/aes.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_aes.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_aes.c$(DependSuffix): src/encryption/aes.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_aes.c$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_aes.c$(DependSuffix) -MM "src/encryption/aes.c"

$(IntermediateDirectory)/encryption_aes.c$(PreprocessSuffix): src/encryption/aes.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_aes.c$(PreprocessSuffix) "src/encryption/aes.c"

$(IntermediateDirectory)/encryption_protection.c$(ObjectSuffix): src/encryption/protection.c $(IntermediateDirectory)/encryption_protection.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/encryption/protection.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_protection.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_protection.c$(DependSuffix): src/encryption/protection.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_protection.c$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_protection.c$(DependSuffix) -MM "src/encryption/protection.c"

$(IntermediateDirectory)/encryption_protection.c$(PreprocessSuffix): src/encryption/protection.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_protection.c$(PreprocessSuffix) "src/encryption/protection.c"

$(IntermediateDirectory)/gui_gui_app.c$(ObjectSuffix): src/gui/gui_app.c $(IntermediateDirectory)/gui_gui_app.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/gui/gui_app.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/gui_gui_app.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/gui_gui_app.c$(DependSuffix): src/gui/gui_app.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/gui_gui_app.c$(ObjectSuffix) -MF$(IntermediateDirectory)/gui_gui_app.c$(DependSuffix) -MM "src/gui/gui_app.c"

$(IntermediateDirectory)/gui_gui_app.c$(PreprocessSuffix): src/gui/gui_app.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/gui_gui_app.c$(PreprocessSuffix) "src/gui/gui_app.c"

$(IntermediateDirectory)/cli_cli_app.c$(ObjectSuffix): src/cli/cli_app.c $(IntermediateDirectory)/cli_cli_app.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/cli/cli_app.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/cli_cli_app.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/cli_cli_app.c$(DependSuffix): src/cli/cli_app.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/cli_cli_app.c$(ObjectSuffix) -MF$(IntermediateDirectory)/cli_cli_app.c$(DependSuffix) -MM "src/cli/cli_app.c"

$(IntermediateDirectory)/cli_cli_app.c$(PreprocessSuffix): src/cli/cli_app.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/cli_cli_app.c$(PreprocessSuffix) "src/cli/cli_app.c"

$(IntermediateDirectory)/app_app.c$(ObjectSuffix): src/app/app.c $(IntermediateDirectory)/app_app.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/app/app.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/app_app.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/app_app.c$(DependSuffix): src/app/app.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/app_app.c$(ObjectSuffix) -MF$(IntermediateDirectory)/app_app.c$(DependSuffix) -MM "src/app/app.c"

$(IntermediateDirectory)/app_app.c$(PreprocessSuffix): src/app/app.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/app_app.c$(PreprocessSuffix) "src/app/app.c"

$(IntermediateDirectory)/config_config.c$(ObjectSuffix): src/config/config.c $(IntermediateDirectory)/config_config.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/config/config.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/config_config.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/config_config.c$(DependSuffix): src/config/config.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/config_config.c$(ObjectSuffix) -MF$(IntermediateDirectory)/config_config.c$(DependSuffix) -MM "src/config/config.c"

$(IntermediateDirectory)/config_config.c$(PreprocessSuffix): src/config/config.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/config_config.c$(PreprocessSuffix) "src/config/config.c"

$(IntermediateDirectory)/user_user.c$(ObjectSuffix): src/user/user.c $(IntermediateDirectory)/user_user.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/user/user.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/user_user.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/user_user.c$(DependSuffix): src/user/user.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/user_user.c$(ObjectSuffix) -MF$(IntermediateDirectory)/user_user.c$(DependSuffix) -MM "src/user/user.c"

$(IntermediateDirectory)/user_user.c$(PreprocessSuffix): src/user/user.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/user_user.c$(PreprocessSuffix) "src/user/user.c"

$(IntermediateDirectory)/utils_utils.c$(ObjectSuffix): src/utils/utils.c $(IntermediateDirectory)/utils_utils.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/utils/utils.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/utils_utils.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/utils_utils.c$(DependSuffix): src/utils/utils.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/utils_utils.c$(ObjectSuffix) -MF$(IntermediateDirectory)/utils_utils.c$(DependSuffix) -MM "src/utils/utils.c"

$(IntermediateDirectory)/utils_utils.c$(PreprocessSuffix): src/utils/utils.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/utils_utils.c$(PreprocessSuffix) "src/utils/utils.c"

$(IntermediateDirectory)/imgui_imgui.cpp$(ObjectSuffix): src/imgui/imgui.cpp $(IntermediateDirectory)/imgui_imgui.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/imgui/imgui.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/imgui_imgui.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/imgui_imgui.cpp$(DependSuffix): src/imgui/imgui.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/imgui_imgui.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/imgui_imgui.cpp$(DependSuffix) -MM "src/imgui/imgui.cpp"

$(IntermediateDirectory)/imgui_imgui.cpp$(PreprocessSuffix): src/imgui/imgui.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/imgui_imgui.cpp$(PreprocessSuffix) "src/imgui/imgui.cpp"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) ".build-debug/condooj"


