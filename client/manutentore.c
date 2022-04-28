#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "defines.h"
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"

static void report(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];

	int id;
	char info[500];
	int mr_id;
	MYSQL_TIME  *date;
	date = malloc(sizeof(MYSQL_TIME));


    printf("\n*********************\nReport Manutenzione\n*********************\n");

	// Get the required information
	//printf("ID REPORT: ");
	//if(getInteger(&id) < 0) return;
	printf("Inserisci data di manutenzione(formato dd/mm/yyyy): ");
	if(getDate(date) < 0) return;
	printf("Inserisci ID materiale rotabile: ");
	if(getInteger(&mr_id) < 0) return;
	printf("Descrizione manutenzione: ");
	if(getInput(500, info, false) < 0) return;


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call report_manutenzione(?,?,?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &id;
	param[0].buffer_length = sizeof(id);

	param[1].buffer_type = MYSQL_TYPE_DATE;
	param[1].buffer = date;
	param[1].buffer_length = sizeof(*date);

	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = info;
	param[2].buffer_length = strlen(info);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &mr_id;
	param[3].buffer_length = sizeof(mr_id);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'inserimento del report.");
		goto out;
	}
	
	printf("Report aggiunto con successo...\n");

    	out:
    	free(date);
	mysql_stmt_close(prepared_stmt);
	
}




void manutentore(MYSQL *conn, char *username) {
    char command[20];

    printf("\033[2J\033[H");

    if(mysql_change_user(conn, "manutentore", "Lineagialla1!","AziendaFerroviaria")) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

    printf(ANSI_COLOR_GREEN  "**************************************\n");
    printf(  "*Connesso al sistema come manutentore*\n");
    printf(  "**************************************\n" ANSI_COLOR_RESET);
    printf("Inserisci un comando, digita help per aiuto\n\n");

	struct sigaction act, sa;

	memset (&act, '\0', sizeof(act));



    while(1) {

    	printf("%s-Manutentore$ ", username);
        getInput(20, command, false);

		sigaction(SIGINT, &act, NULL);

        if(!strcmp(command, "quit")) {
            printf(ANSI_COLOR_RED"Arrivederci!\n" ANSI_COLOR_RESET);
            return;
        } else if(!strcmp(command, "help")) {
			printf(ANSI_COLOR_GREEN "*** Comandi manutentore ***" ANSI_COLOR_RESET "\n");
            printf(ANSI_COLOR_CYAN "report" ANSI_COLOR_RESET " - report della manutenzione" "\n");;
            printf(ANSI_COLOR_YELLOW "quit" ANSI_COLOR_RESET " - per uscire dall'applicazione\n");
            printf(ANSI_COLOR_YELLOW "clear" ANSI_COLOR_RESET " - per pulire il terminale\n");
			printf(ANSI_COLOR_GREEN "*******************************" ANSI_COLOR_RESET "\n");
    } else if(!strcmp(command, "report")) {
            report(conn);
        } else {
            printf("comando %s non riconosciuto, digita help per aiuto\n", command);
        }

		sigaction(SIGINT, &sa, NULL);
    }
}
