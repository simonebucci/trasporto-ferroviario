#include <stdio.h>
#include <mysql.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

static MYSQL *conn;

typedef enum {
	ADMIN = 1,
	LAVORATORE,
	CONTROLLORE,
	MANUTENTORE,
	FAILED_LOGIN
} role_t;

static role_t attempt_login(MYSQL *conn, char *username, char *password) {
	MYSQL_STMT *login_procedure;

	MYSQL_BIND param[3]; // Used both for input and output
	int role = 0;

	if(!setup_prepared_stmt(&login_procedure, "call login(?, ?, ?)", conn)) {
		print_stmt_error(login_procedure, "Unable to initialize login statement\n");
		goto err2;
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = username;
	param[0].buffer_length = strlen(username);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = password;
	param[1].buffer_length = strlen(password);

	param[2].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[2].buffer = &role;
	param[2].buffer_length = sizeof(role);


	if (mysql_stmt_bind_param(login_procedure, param) != 0) { // Note _param
		print_stmt_error(login_procedure, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(login_procedure) != 0) {
		print_stmt_error(login_procedure, "Could not execute login procedure");
		goto err;
	}

	// Prepare output parameters
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[0].buffer = &role;
	param[0].buffer_length = sizeof(role);


	if(mysql_stmt_bind_result(login_procedure, param)) {
		print_stmt_error(login_procedure, "Could not retrieve output parameter");
		goto err;
	}

	// Retrieve output parameter
	if(mysql_stmt_fetch(login_procedure)) {
		print_stmt_error(login_procedure, "Could not buffer results");
		goto err;
	}

	mysql_stmt_close(login_procedure);
	return role;

    err:
	mysql_stmt_close(login_procedure);
    err2:
	return FAILED_LOGIN;
}

int main(void){
	char username[128];
	char password[128];

	conn = mysql_init (NULL);
	if (conn == NULL) {
		fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
		exit(EXIT_FAILURE);
	}

	if (mysql_real_connect(conn, "localhost", "login", "Lineagialla1!","AziendaFerroviaria", 3306, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
		fprintf (stderr, "mysql_real_connect() failed\n");
		mysql_close (conn);
		exit(1);
	}
	printf(ANSI_COLOR_CYAN  "\n******************************\n");
	printf(  "*** Azienda Ferroviaria DB ***\n");
	printf(  "******************************" ANSI_COLOR_RESET "\n");
	printf(ANSI_COLOR_GREEN  "Benvenuto, inserisci i tuoi dati per accedere:\n\n"ANSI_COLOR_RESET);
	
	printf("Username: ");
	getInput(128, username, false);
	printf("Password: ");
	getInput(128, password, true);


	int role = attempt_login(conn, username, password);

	switch(role) {
		case ADMIN:
			admin(conn, username);
			break;
		case LAVORATORE:
			lavoratore(conn, username);
			break;
		case CONTROLLORE:
			controllore(conn, username);
			break;
		case MANUTENTORE:
			manutentore(conn, username);
			break;
		default:
			printf(ANSI_COLOR_RED"Dati non corretti!\n"ANSI_COLOR_RESET);
			abort();
	}

	mysql_close(conn);
	return 0;
}
