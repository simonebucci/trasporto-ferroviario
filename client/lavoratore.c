#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "defines.h"
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_RESET   "\x1b[0m"
#define ANSI_COLOR_CYAN    "\x1b[36m"

static void turni(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	char cf[16];
	int status;

    printf("\n************\nReport Turni\n************\n");

	// Get the required information
	printf("CF: ");
	if(getInput(45, cf, false) < 0) return;


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call report_lavoratore(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = cf;
	param[0].buffer_length = strlen(cf);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'ottenere i turni.");
	}

	do {
		dump_result_set(conn, prepared_stmt, "Turni per il lavoratore selezionato");
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

	mysql_stmt_close(prepared_stmt);
}



void lavoratore(MYSQL *conn, char *username) {
    char command[20];

    printf("\033[2J\033[H");

    if(mysql_change_user(conn, "lavoratore", "Lineagialla1!","AziendaFerroviaria")) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

  printf(ANSI_COLOR_GREEN  "*************************************\n");
    printf(                  "*Connesso al sistema come lavoratore*\n");
    printf(                  "*************************************\n" ANSI_COLOR_RESET);
    printf("Inserisci un comando, digita help per aiuto\n\n");


	struct sigaction act, sa;

	memset (&act, '\0', sizeof(act));



    while(1) {

    	printf("%s-lavoratore$ ", username);
        getInput(20, command, false);

		sigaction(SIGINT, &act, NULL);

        if(!strcmp(command, "quit")) {
            printf(ANSI_COLOR_RED"Arrivederci!\n" ANSI_COLOR_RESET);
            return;
        } else if(!strcmp(command, "help")) {
			printf(ANSI_COLOR_GREEN "*** Comandi lavoratore ***" ANSI_COLOR_RESET "\n");
            printf(ANSI_COLOR_CYAN "turni" ANSI_COLOR_RESET " - report dei turni" "\n");;
            printf(ANSI_COLOR_YELLOW "quit" ANSI_COLOR_RESET " - per uscire dall'applicazione\n");
            printf(ANSI_COLOR_YELLOW  "clear" ANSI_COLOR_RESET " - per pulire il terminale\n");
			printf(ANSI_COLOR_GREEN "*******************************" ANSI_COLOR_RESET "\n");
    } else if(!strcmp(command, "turni")) {
            turni(conn);
        } else {
            printf("comando %s non riconosciuto, digita help per aiuto\n", command);
        }

		sigaction(SIGINT, &sa, NULL);
    }
}
