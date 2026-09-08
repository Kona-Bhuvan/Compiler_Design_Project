# Compiler_Design_Project

## Bcs24 Language Syntax Parser

This project implements a lexical analyzer and syntax parser for the **Bcs24** custom programming language using **Flex** and **Bison** (Yacc) in **C**.

---

## 📌 Project Overview

The parser verifies whether an input `.bcs24` source code file complies with the Bcs24 formal context-free grammar.

* **Output:**
* Prints **`Parsing Successful`** if the source code is syntactically valid.
* Prints **`Syntax Error`** if the source code contains syntax or lexical errors.



---

## 📁 Repository Structure

```text
├── lexer.l      # Flex lexical analyzer specification
├── parser.y     # Bison grammar rules and semantic actions
├── sample.bcs24   # Sample valid Bcs24 program
└── README.md    # Build and usage documentation

```

---

## ⚙️ Prerequisites

Ensure you have the following installed on your system:

* **GCC** (GNU Compiler Collection)
* **Flex** (Fast Lexical Analyzer Generator)
* **Bison** (GNU Parser Generator)

To install them on Debian/Ubuntu-based Linux systems:

```bash
sudo apt update
sudo apt install build-essential flex bison

```

---

## 🛠️ Build Instructions

1. **Generate the Parser Header and Source:**
```bash
bison -d parser.y
```

*Generates `parser.tab.c` and `parser.tab.h`.*

2. **Generate the Lexer Source:**
```bash
flex lexer.l
```

*Generates `lex.yy.c`.*

3. **Compile the Executable:**
```bash
gcc lex.yy.c parser.tab.c -o bcs24
```

---

## 🚀 How to Run

Pass the target `.bcs24` program file as a command-line argument:

```bash
./bcs24 sample.bcs24
```

### Expected Output for Valid Input (`sample.bcs24`):

```text
Parsing Successful
```

---

## 📜 Language Grammar & Specifications

### 1. Structure

* **Entry Point:** Starts with the keyword `BcsMain` followed by `{ ... }`.
* **Declarations First:** Declarations (`declist`) must appear before statements (`stmtlist`).
* **Statement List:** It is of the form `statmentlist ; statement | statement`
* **Variable Types:** `int`, `bool`

### 2. Supported Statements & Constructs

* **Assignments:** `id = expression`
* **Conditionals:** `if (expr) { stmtlist } else { stmtlist }`
* **Loops:** `while (expr) { stmtlist }`

### 3. Operators

* **Relational:** `==`, `!=`, `<`, `<=`, `>`, `>=`
* **Arithmetic:** `+` (addition), `*` (multiplication)

---

## 🧪 Sample Test Code (`sample.bcs24`)

```text
BcsMain
{
    int sum; int i; int n;
    n=10;
    i=1; sum=0;
    while(i<n)
    {sum=sum+i; i=i+1};
    sum=sum*10
}

```
