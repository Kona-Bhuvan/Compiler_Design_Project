#ifndef TAC_H
#define TAC_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int temp_count = 0;
static FILE *tac_file = NULL;

char* newTemp() {
    char* temp = (char *)malloc(sizeof(char) * 10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

void emit(const char* result, const char* arg1, const char* op, const char* arg2) {
    if (!tac_file) {
        tac_file = fopen("tac_output.txt", "w");
        if (!tac_file) {
            perror("Could not open tac_output.txt for writing");
            return;
        }
    }
    
    if (op == NULL) {
        fprintf(tac_file, "%s = %s\n", result, arg1);
    } else {
        fprintf(tac_file, "%s = %s %s %s\n", result, arg1, op, arg2);
    }
    fflush(tac_file);
}

void close_tac_file() {
    if (tac_file) {
        fclose(tac_file);
        tac_file = NULL;
    }
}

#endif