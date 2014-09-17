#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "dropbox/dropbox.h"

#define CONSUMER_KEY "hkcnl3viglfuf5k"
#define CONSUMER_SECRET "q7mkice2q1t22xz"
#define ACCESS_TOKEN "upgdf8ebdbjkbpl6"
#define TOKEN_SECRET "y6s5cyzn2denzqj"

int main(int argc, char **argv)
{
	char* signed_url = 0;
	char* access_token = 0;
	char* access_token_secret = 0;
	char answer = 'n';
	
	dropbox_request_token(CONSUMER_KEY, CONSUMER_SECRET);
	signed_url = dropbox_authorize(CONSUMER_KEY, CONSUMER_SECRET);
	
	printf("please copy the link below in you favourite browser and authorize the app,");
	printf(" the app will wait for you to perform authorization...\n");
	printf("%s\n", signed_url);
	printf("did you authorized the app (y/n)? ");
	answer = getchar();
	if(answer == 'y')
	{
		dropbox_access_token(CONSUMER_KEY, CONSUMER_SECRET, &access_token, &access_token_secret);
		if(access_token || access_token_secret)
		{
			FILE* user = fopen("user.dat", "w");
			fprintf(user, "access_token=%s\n", access_token);
			fprintf(user, "access_token_secret=%s\n", access_token_secret);
			fclose(user);
		}
	}
	
	if(signed_url)
	{
		free(signed_url);
		signed_url = 0;
	}
	
	if(access_token)
	{
		free(access_token);
		access_token = 0;
	}
	
	if(access_token_secret)
	{
		free(access_token_secret);
		access_token_secret = 0;
	}

	return 0;
}