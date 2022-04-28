#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <errno.h>

#include "defines.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"


char command[20];

static void aggiungi_lavoratore(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[8];

	char cf[16];
	int mansione_id;
    	char name[45];
    	char surname[45];
	MYSQL_TIME *date;	//Date of birth
   	char pob[45];	//Place of birth
	date = malloc(sizeof(MYSQL_TIME));
    	char username[45];
	char password[45];
	char passwordtmp[45];

    printf("Aggiungi lavoratore\n");

	// Get the required information
	printf("CF: ");
	if(getInput(16, cf, false) < 0) {
		return;
	}
	printf("ID Mansione: ");
	if(getInteger(&mansione_id) < 0){
		return;
	}

    printf("Nome: ");
	if(getInput(45, name, false) < 0) {
		return;
	}

	printf("Cognome: ");
	if(getInput(45, surname, false) < 0) {
		return;
	}

    printf("Luogo di nascita: ");
	if(getInput(45, pob, false) < 0) {
		return;
	}

	printf("Inserisci data di nascita(formato dd/mm/yyyy): ");
	if(getDate(date) < 0){
		return;
	}

	printf("Username: ");
	if(getInput(45, username, false) < 0) {
		return;
	}

	printf("Password: ");
	if(getInput(45, password, true) < 0) {
		return;
	}

	printf("Ripeti password: ");
	if(getInput(45, passwordtmp, true) < 0) {
		return;
	}

    if(strcmp(password, passwordtmp)) {
        printf("Le password non corrispondono\n");
		return;
    }

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_lavoratore(?, ?, ?, ?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = cf;
	param[0].buffer_length = strlen(cf);

	param[1].buffer_type = MYSQL_TYPE_LONG;
	param[1].buffer = &mansione_id;
	param[1].buffer_length = sizeof(mansione_id);

	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = name;
	param[2].buffer_length = strlen(name);

  	param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[3].buffer = surname;
	param[3].buffer_length = strlen(surname);

	param[4].buffer_type = MYSQL_TYPE_DATE;
	param[4].buffer = date;
	param[4].buffer_length = sizeof(*date);

  	param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[5].buffer = pob;
	param[5].buffer_length = strlen(pob);

  	param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[6].buffer = username;
	param[6].buffer_length = strlen(username);

	param[7].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[7].buffer = password;
	param[7].buffer_length = strlen(password);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta del lavoratore.");
	} else {
		printf("Lavoratore %s aggiunto correttamente\n", username);
	}

	free(date);

	mysql_stmt_close(prepared_stmt);
}


static void aggiungi_turno(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];

	int id;
	MYSQL_TIME *date;
	date = malloc(sizeof(MYSQL_TIME));
	MYSQL_TIME *start;
	MYSQL_TIME *end;

	    start = malloc(sizeof(MYSQL_TIME));
	    end = malloc(sizeof(MYSQL_TIME));

	    printf("Aggiungi turno\n");

		// Get the required information
	    printf("\nID Turno: ");
		if(getInteger(&id) < 0) {
			return;
		}
		printf("Inserisci data(formato dd/mm/yyyy): ");
		if(getDate(date) < 0){
			return;
		}

	    printf("Inserisci orario di inizio(formato hh:mm): ");
	    if(getTime(start) < 0) {
			return;
		}

	    printf("Inserisci orario di fine(formato hh:mm): ");
	    if(getTime(end) < 0) {
			return;
		}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_turno(?, ?, ?, ?)", conn)) {
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

    	param[2].buffer_type = MYSQL_TYPE_TIME;
	param[2].buffer = start;
	param[2].buffer_length = sizeof(*start);

   	param[3].buffer_type = MYSQL_TYPE_TIME;
	param[3].buffer = end;
	param[3].buffer_length = sizeof(*end);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta del turno.");
	} else {
		printf("Turno %d aggiunto correttamente\n", id);
	}

	free(start);
	free(end);
	free(date);

	mysql_stmt_close(prepared_stmt);
}

static void assegna_turno(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];


	int turno;
	char cf[17];

    printf("Assegna turno\n");

	// Get the required information
   	printf("CF Lavoratore: ");
	if(getInput(17, cf, false) < 0){
		return;
	}
	printf("\nID Turno: ");
	if(getInteger(&turno) < 0){
		return;
	}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call assegna_turno(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

    	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = cf;
	param[0].buffer_length = strlen(cf);

	param[1].buffer_type = MYSQL_TYPE_LONG;
	param[1].buffer = &turno;
	param[1].buffer_length = sizeof(turno);




	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nella assegnazione del turno.");
	} else {
		printf("Lavoratore %s assegnato al turno %d.\n", cf, turno);
	}

	mysql_stmt_close(prepared_stmt);
}

static void aggiungi_azienda(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	char nome[45];
	char piva[12];


    printf("Aggiungi Azienda\n");

	// Get the required information
    printf("\nPartita IVA: ");
	if(getInput(12, piva, false) < 0){
		return;
	}

    printf("Nome azienda: ");
	if(getInput(45, nome, false) < 0){
		return;
	}


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_azienda(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

    	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = piva;
	param[0].buffer_length = strlen(piva);

   	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = nome;
	param[1].buffer_length = strlen(nome);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta dell'azienda.");
	} else {
		printf("Azienda %s aggiunta correttamente.\n", nome);
	}

	mysql_stmt_close(prepared_stmt);
}

static void aggiungi_passeggero(MYSQL *conn) {
		MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	char cf[16];
	char carta[16];
    	char name[45];
    	char surname[45];
	MYSQL_TIME *date;//Date of birth
	date = malloc(sizeof(MYSQL_TIME));


    printf("Aggiungi Passeggero\n");

	// Get the required information
	printf("CF: ");
	if(getInput(16, cf, false) < 0) {
		return;
	}

    	printf("Nome: ");
	if(getInput(45, name, false) < 0) {
		return;
	}

	printf("Cognome: ");
	if(getInput(45, surname, false) < 0) {
		return;
	}

	printf("Data di nascita(formato dd/mm/yyyy): ");
	if(getDate(date) < 0){
		return;
	}

	printf("Carta di credito: ");
	if(getInput(16, carta, false) < 0) {
		return;
	}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_passeggero(?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));


	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = cf;
	param[0].buffer_length = strlen(cf);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = name;
	param[1].buffer_length = strlen(name);

  	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = surname;
	param[2].buffer_length = strlen(surname);

	param[3].buffer_type = MYSQL_TYPE_DATE;
	param[3].buffer = date;
	param[3].buffer_length = sizeof(*date);

  	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = carta;
	param[4].buffer_length = strlen(carta);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta del passeggero.");
	} else {
		printf("Passeggero %s aggiunto correttamente\n", cf);
	}

	free(date);

	mysql_stmt_close(prepared_stmt);

}

static void aggiungi_prenotazione(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];

	char codice[6];
	char cf[17];
    	char posto[4];
    	int servizio;


    printf("Aggiungi Prenotazione\n");

	// Get the required information
	printf("Codice prenotazione (5 cifre): ");
	if(getInput(6, codice, false) < 0) {
		return;
	}

	printf("Numero posto (3 cifre): ");
	if(getInput(4, posto, false) < 0) {
		return;
	}

    	printf("Codice fiscale passeggero: ");
	if(getInput(17, cf, false) < 0) {
		return;
	}


	printf("ID Servizio Ferroviario: ");
	if(getInteger(&servizio) < 0){
		return;
	}


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_prenotazione(?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));


	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = codice;
	param[0].buffer_length = strlen(codice);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = posto;
	param[1].buffer_length = strlen(posto);

  	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = cf;
	param[2].buffer_length = strlen(cf);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &servizio;
	param[3].buffer_length = sizeof(servizio);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta della prenotazione.");
	} else {
		printf("Prenotazione %s per il passeggero %s aggiunta correttamente\n", codice, cf);
	}


	mysql_stmt_close(prepared_stmt);
}

static void aggiungi_servizio(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

    	char treno[4];
    	int servizio;
    	int turno;
    	int tratta;
	MYSQL_TIME *date;
	date = malloc(sizeof(MYSQL_TIME));


    printf("Aggiungi Servizio\n");

	// Get the required informationù
	printf("ID Servizio Ferroviario: ");
	if(getInteger(&servizio) < 0){
		return;
	}
	printf("Matricola treno (4 cifre): ");
	if(getInput(5, treno, false) < 0) {
		return;
	}

	printf("ID Tratta: ");
	if(getInteger(&tratta) < 0) {
		return;
	}

    	printf("ID Turno: ");
	if(getInteger(&turno) < 0) {
		return;
	}
	
	printf("Data (formato dd/mm/yyyy): ");
	if(getDate(date) < 0){
		return;
	}



	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_servizio(?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &servizio;
	param[0].buffer_length = sizeof(servizio);
	
	param[1].buffer_type = MYSQL_TYPE_LONG;
	param[1].buffer = &turno;
	param[1].buffer_length = sizeof(turno);
	
	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = treno;
	param[2].buffer_length = strlen(treno);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &tratta;
	param[3].buffer_length = sizeof(tratta);
	
	param[4].buffer_type = MYSQL_TYPE_DATE;
	param[4].buffer = date;
	param[4].buffer_length = sizeof(*date);
	

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta del servizio ferroviario.");
	} else {
		printf("Servizio ferroviario %d sulla tratta %d aggiunto correttamente\n", servizio, tratta);
	}

	free(date);
	mysql_stmt_close(prepared_stmt);
}

static void aggiungi_spedizione(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[7];

	char mittente[11];
	char fattura[45];
	char descrizione[120];
	int massa;
	int servizio;
    	int vagone;
    	int id;


    printf("Aggiungi Spedizione\n");

	// Get the required information
	printf("Codice spedizione: ");
	if(getInteger(&id) < 0) {
		return;
	}

	printf("Partita IVA mittente: ");
	if(getInput(11, mittente, false) < 0) {
		return;
	}

    	printf("Numero fattura: ");
	if(getInput(45, fattura, false) < 0) {
		return;
	}


	printf("ID Servizio Ferroviario: ");
	if(getInteger(&servizio) < 0){
		return;
	}
	
	printf("ID Vagone: ");
	if(getInteger(&vagone) < 0){
		return;
	}
	
	printf("Descrizione contenuto: ");
	if(getInput(120, descrizione, false) < 0) {
		return;
	}

	printf("Massa: ");
	if(getInteger(&massa) < 0){
		return;
	}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_spedizione(?, ?, ?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));


	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &id;
	param[0].buffer_length = sizeof(id);
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = mittente;
	param[1].buffer_length = strlen(mittente);

	param[2].buffer_type = MYSQL_TYPE_LONG;
	param[2].buffer = &servizio;
	param[2].buffer_length = sizeof(servizio);
	
	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &vagone;
	param[3].buffer_length = sizeof(vagone);
	
	param[4].buffer_type = MYSQL_TYPE_LONG;
	param[4].buffer = &massa;
	param[4].buffer_length = sizeof(massa);

  	param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[5].buffer = descrizione;
	param[5].buffer_length = strlen(descrizione);
	
	param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[6].buffer = fattura;
	param[6].buffer_length = strlen(fattura);
	

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta della spedizione.");
	} else {
		printf("Spedizione %d aggiunta correttamente\n", id);
	}


	mysql_stmt_close(prepared_stmt);
}

static void richiesta_malattia(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

    	char cf[16];
	int turno;
	

    printf("\nRichiesta malattia\n");

	// Get the required information
	printf("\nCF Lavoratore: ");
	if(getInput(16, cf, false) < 0) {
		return;
	}

	printf("ID Turno: ");
	if(getInteger(&turno) < 0) {
		return;
	}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call richiesta_malattia(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = cf;
	param[0].buffer_length = strlen(cf);

	param[1].buffer_type = MYSQL_TYPE_LONG;
	param[1].buffer = &turno;
	param[1].buffer_length = sizeof(turno);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nella richiesta di malattia.");
	} else {
        printf("Lavoratore %s correttamente inserito in malattia.\n", cf);
    }

	mysql_stmt_close(prepared_stmt);
}


static void lavoratori_disponibili(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

    	MYSQL_TIME *date;
	MYSQL_TIME *start;
	MYSQL_TIME *end;
	int status;

	date = malloc(sizeof(MYSQL_TIME));
    	start = malloc(sizeof(MYSQL_TIME));
    	end = malloc(sizeof(MYSQL_TIME));

    printf("\n");
    printf("Ricerca lavoratori disponibili\n");

	// Get the required information
    	printf("Inserisci data turno(formato dd/mm/yyyy): ");
	if(getDate(date) < 0) return;

	printf("Inserisci orario di inizio(formato hh:mm): ");
   	if(getTime(start) < 0) return;

    	printf("Inserisci orario di fine(formato hh:mm): ");
    	if(getTime(end) < 0) return;
    	getchar();

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call lavoratori_disponibili(?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_DATE;
	param[0].buffer = date;
	param[0].buffer_length = sizeof(*date);

	param[1].buffer_type = MYSQL_TYPE_TIME;
	param[1].buffer = start;
	param[1].buffer_length = sizeof(*start);

	param[2].buffer_type = MYSQL_TYPE_TIME;
	param[2].buffer = end;
	param[2].buffer_length = sizeof(*end);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nella ricerca di lavoratori disponibili.");
	}

	  char buff[100];
	  sprintf(buff, "Lavoratori disponibili il giorno %d/%d/%d %u:%u-%u:%u", date->day, date->month, date->year, start->hour, start->minute, end->hour, end->minute);
	
	  
	do {
		dump_result_set(conn, prepared_stmt, buff);
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

    	free(start);
	free(end);
	free(date);

	mysql_stmt_close(prepared_stmt);
}

static void modifica_servizio(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	int servizio;
	int tratta;
	

    printf("\nModifica associazione Servizio a Tratta\n");

	// Get the required information
	printf("ID Servizio Ferroviario: ");
	if(getInteger(&servizio) < 0){
		return;
	}
	
	printf("ID Tratta: ");
	if(getInteger(&tratta) < 0){
		return;
	}

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call modifica_tratta_servizio(?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &servizio;
	param[0].buffer_length = sizeof(servizio);
	
	param[1].buffer_type = MYSQL_TYPE_LONG;
	param[1].buffer = &tratta;
	param[1].buffer_length = sizeof(tratta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nella modifica associazione Servizio a Tratta.");
	}else {
        printf("Modifica effettuata con successo.\n");
    }

	mysql_stmt_close(prepared_stmt);
}

static void modifica_treno(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	int servizio;
	char treno[4];
	

    printf("\nModifica associazione Treno a Servizio\n");

	// Get the required information
	printf("ID Servizio Ferroviario: ");
	if(getInteger(&servizio) < 0){
		return;
	}
	
	printf("Matricola treno (4 cifre): ");
	if(getInput(5, treno, false) < 0) {
		return;
	}


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call modifica_treno_servizio(?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &servizio;
	param[0].buffer_length = sizeof(servizio);
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = treno;
	param[1].buffer_length = strlen(treno);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nella modifica associazione treno a servizio.");
	}else {
        printf("Modifica effettuata con successo.\n");
    }


	mysql_stmt_close(prepared_stmt);
}

static void configurazione(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	char treno[5];
	int status;

    printf("\nConfigurazione Treno\n");

	// Get the required information
	printf("Matricola Treno: ");
	if(getInput(5, treno, false) < 0) return;


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call configurazione_treno(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = treno;
	param[0].buffer_length = strlen(treno);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore, impossibile ottenere la composizione del treno.");
	}

	do {
		dump_result_set(conn, prepared_stmt, "");
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

	mysql_stmt_close(prepared_stmt);
}

static void composizione(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	char treno[5];
	int status;

    printf("\nComposizione Treno\n");

	// Get the required information
	printf("Matricola Treno: ");
	if(getInput(5, treno, false) < 0) return;


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call composizione_treno(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = treno;
	param[0].buffer_length = strlen(treno);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore, impossibile ottenere la configurazione del treno.");
	}

	do {
		dump_result_set(conn, prepared_stmt, "");
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

	mysql_stmt_close(prepared_stmt);
}

static void fermate(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	int tratta;
	int status;

    printf("\nFermate della tratta\n");

	// Get the required information
	printf("ID Tratta: ");
	if(getInteger(&tratta) < 0) 
	return;


	// Prepare stored procedure call

	if(!setup_prepared_stmt(&prepared_stmt, "call fermate_tratta(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &tratta;
	param[0].buffer_length = sizeof(tratta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nel binding dei parametri.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore, impossibile ottenere le fermate della tratta.");
	}

	do {
		dump_result_set(conn, prepared_stmt, "");
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

	mysql_stmt_close(prepared_stmt);
}

static void tratte(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	
	int status;

    printf("\nTratte giornaliere\n");


	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call tratte_giornaliere()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Impossibile inizializzare lo statement.\n", false);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore, impossibile ottenere le fermate della tratta.");
	}

	do {
		dump_result_set(conn, prepared_stmt, "");
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
	} while (status == 0);

	mysql_stmt_close(prepared_stmt);
}



void admin(MYSQL *conn, char *username) {

    printf("\033[2J\033[H");

    if(mysql_change_user(conn, "admin", "Lineagialla1!", "AziendaFerroviaria")) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	struct sigaction act, sa;

	memset (&act, '\0', sizeof(act));


    printf(ANSI_COLOR_YELLOW "************************\n" ANSI_COLOR_RESET);
    printf(ANSI_COLOR_YELLOW "***Connected as admin***\n" ANSI_COLOR_RESET);
    printf(ANSI_COLOR_YELLOW "************************\n" ANSI_COLOR_RESET);
    while(1) {

        printf("%s-admin$ ", username);
        getInput(20, command, false);

		sigaction(SIGINT, &act, NULL);

        if(!strcmp(command, "quit")) {
            printf(ANSI_COLOR_RED"Arrivederci!\n" ANSI_COLOR_RESET);
            return;
        } else if(!strcmp(command, "help")) {
            printf(ANSI_COLOR_CYAN  "******************************"  "\n");
            printf(  "*** Comandi Amministratore ***"  "\n");
            printf( "******************************" ANSI_COLOR_RESET "\n");
            printf(ANSI_COLOR_MAGENTA "addlavoratore" ANSI_COLOR_RESET " - per aggiungere un lavoratore\n");
            printf(ANSI_COLOR_MAGENTA "addazienda" ANSI_COLOR_RESET "- per aggiungere un'azienda\n");
	    printf(ANSI_COLOR_MAGENTA "addpasseggero" ANSI_COLOR_RESET "- per aggiungere un passeggero\n");
            printf(ANSI_COLOR_MAGENTA "addprenotazione" ANSI_COLOR_RESET " - per aggiungere una prenotazione\n");
            printf(ANSI_COLOR_MAGENTA "addspedizione" ANSI_COLOR_RESET " - per aggiungere una spedizione\n");
            printf(ANSI_COLOR_MAGENTA "addservizio" ANSI_COLOR_RESET " - per aggiungere un servizio ferroviario\n");
            printf(ANSI_COLOR_MAGENTA "addturno" ANSI_COLOR_RESET " - per aggiungere un turno\n");
            printf(ANSI_COLOR_MAGENTA "serviziotratta" ANSI_COLOR_RESET " - per modificare la tratta di un servizio\n");
            printf(ANSI_COLOR_MAGENTA "serviziotreno" ANSI_COLOR_RESET " - per modificare il treno di un servizio\n");
            printf(ANSI_COLOR_MAGENTA "comptreno" ANSI_COLOR_RESET " - per ottenere la composizione di un treno\n");
            printf(ANSI_COLOR_MAGENTA "configtreno" ANSI_COLOR_RESET " - per ottenere la configurazione di un treno\n");
            printf(ANSI_COLOR_MAGENTA "assegnaturno" ANSI_COLOR_RESET " - per assegnare un turno ad un lavoratore\n");
            printf(ANSI_COLOR_MAGENTA "malattia" ANSI_COLOR_RESET " - per inserire un lavoratore in malattia\n");
            printf(ANSI_COLOR_MAGENTA "freelavoratori" ANSI_COLOR_RESET " - per vedere i lavoratori liberi\n");
            printf(ANSI_COLOR_MAGENTA "tratte" ANSI_COLOR_RESET " - per ottenere le tratte giornaliere\n");
            printf(ANSI_COLOR_MAGENTA "fermatetratta" ANSI_COLOR_RESET " - per ottenere le fermate di una tratta\n");
            printf(ANSI_COLOR_YELLOW "quit" ANSI_COLOR_RESET " - per uscire dall'applicazione\n");
            printf(ANSI_COLOR_YELLOW "clear" ANSI_COLOR_RESET " - per pulire lo schermo\n");
	    printf(ANSI_COLOR_CYAN  "******************************" ANSI_COLOR_RESET "\n");
        }  else if(!strcmp(command, "clear")) {
            printf("\033[2J\033[H");
        }  else if(!strcmp(command, "addlavoratore")) {
            aggiungi_lavoratore(conn);
        }  else if(!strcmp(command, "addturno")) {
            aggiungi_turno(conn);
        }  else if(!strcmp(command, "assegnaturno")) {
            assegna_turno(conn);
        }  else if(!strcmp(command, "malattia")) {
            richiesta_malattia(conn);
        }  else if(!strcmp(command, "addazienda")) {
            aggiungi_azienda(conn);
        }  else if(!strcmp(command, "addspedizione")) {
            aggiungi_spedizione(conn);
        }  else if(!strcmp(command, "addpasseggero")) {
            aggiungi_passeggero(conn);
        }  else if(!strcmp(command, "addprenotazione")) {
            aggiungi_prenotazione(conn);
        }  else if(!strcmp(command, "addservizio")) {
            aggiungi_servizio(conn);
        } else if(!strcmp(command, "freelavoratori")) {
            lavoratori_disponibili(conn);
        } else if(!strcmp(command, "serviziotratta")) {
            modifica_servizio(conn);
        } else if(!strcmp(command, "serviziotreno")) {
            modifica_treno(conn);
        } else if(!strcmp(command, "configtreno")) {
            configurazione(conn);
        } else if(!strcmp(command, "comptreno")) {
            composizione(conn);
        } else if(!strcmp(command, "fermatetratta")) {
            fermate(conn);
        } else if(!strcmp(command, "tratte")) {
            tratte(conn);
        } else {
            printf("comando %s non riconosciuto, digita help per aiuto\n", command);
        }

		sigaction(SIGINT, &sa, NULL);
    }
}
