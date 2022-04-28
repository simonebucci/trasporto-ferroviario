#include <stdbool.h>
#include <mysql.h>



extern void print_stmt_error (MYSQL_STMT *stmt, char *message);
extern bool setup_prepared_stmt(MYSQL_STMT **stmt, char *statement, MYSQL *conn);
extern void print_error (MYSQL *conn, char *message);
int getInput(unsigned int lung, char *stringa, bool hide);
extern void lavoratore(MYSQL *conn, char *username);
extern void controllore(MYSQL *conn, char *username);
extern void manutentore(MYSQL *conn, char *username);
extern void admin(MYSQL *conn, char *username);
extern void dump_result_set(MYSQL *conn, MYSQL_STMT *stmt, char *title);
extern void finish_with_error(MYSQL *conn, char *message);
extern void finish_with_stmt_error(MYSQL *conn, MYSQL_STMT *stmt, char *message, bool close_stmt);
extern void dump_result_set(MYSQL *conn, MYSQL_STMT *stmt, char *title);
int getInteger(int *dest);
int getDate(MYSQL_TIME *date);
int getTime(MYSQL_TIME *time);
