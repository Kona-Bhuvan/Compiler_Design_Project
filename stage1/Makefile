# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison

TARGET = bcs24

LEX_SPEC = lexer.l
PARSE_SPEC = parser.y

PARSER_C = parser.tab.c
PARSER_H = parser.tab.h
LEXER_C = lex.yy.c

all: $(TARGET)

$(TARGET): $(PARSER_C) $(LEXER_C) 
	$(CC) $(PARSER_C) $(LEXER_C) -o $(TARGET)

$(PARSER_C) $(PARSER_H): $(PARSE_SPEC)
	$(BISON) -d $(PARSE_SPEC)

$(LEXER_C): $(LEX_SPEC) $(PARSER_H)
	$(FLEX) $(LEX_SPEC)

test: $(TARGET)
	@echo "--- Testing Success Case ---"
	./$(TARGET) success_example.bcs24
	@echo "\n--- Testing Failure Case ---"
	-./$(TARGET) failure_example.bcs24

clean:
	rm -f $(TARGET) $(PARSER_C) $(PARSER_H) $(LEXER_C)

.PHONY: all test clean