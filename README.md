# Bcs24 Language Compiler & Parser

This project implements a custom programming language compiler for **Bcs24** using **Flex** and **Bison** (Yacc) in **C**, organized across two progressive stages.

---

## 📌 Project Overview

- **Stage 1:** Focuses on lexical analysis, context-free grammar parsing, symbol table management, and syntax validation (handling success and failure test cases).
- **Stage 2:** Extends the parser to implement intermediate code generation for assignment statements only, outputting **3-Address Code (TAC)** into a text file (`tac_output.txt`).

---

## 📁 Repository Structure

```text
├── Course_Project__Details.pdf
├── sample.bcs24                # General sample Bcs24 program
├── README.md                   # Build and usage documentation
├── stage1
│   ├── failure_example.bcs24   # Sample invalid Bcs24 program (Syntax Error)
│   ├── lexer.l                 # Flex lexical analyzer specification
│   ├── Makefile                # Automated build script for Stage 1
│   ├── parser.y                # Bison grammar rules and evaluation actions
│   └── success_example.bcs24   # Sample valid Bcs24 program (Parsing Successful)
└── stage2
    ├── example.bcs24           # Sample program for TAC generation
    ├── lexer.l                 # Flex lexical analyzer specification
    ├── Makefile                # Automated build script for Stage 2
    ├── parser.y                # Bison grammar rules with TAC emission
    └── tac.h                   # 3-Address Code generation and temp variable module
```

---

## ⚙️ Prerequisites

Ensure you have the required build tools installed on your system:

* **GCC** (GNU Compiler Collection)
* **Flex** (Fast Lexical Analyzer Generator)
* **Bison** (GNU Parser Generator)

To install them on Debian/Ubuntu-based Linux systems:

```bash
sudo apt update
sudo apt install build-essential flex bison

```

---

## 🛠️ Build & Execution Instructions

### Stage 1: Syntax Analysis & Execution

Navigate to the `stage1` directory to build and run syntax checks:

```bash
cd stage1
```

Build the executable using Makefile:

```bash
make all
```


Test valid & invalid programs:

```bash
make test
```

Clean build files:

```bash
make clean
```

---

### Stage 2: 3-Address Code (TAC) Generation

Navigate to the `stage2` directory to generate intermediate code:

```bash
cd stage2
```

Build the TAC compiler executable:

```bash
make all
```

Run compiler on sample program:

```bash
make test
```

Clean build files:

```bash
make clean
```

---

## 📜 Language Grammar & Specifications

### 1. Structure

* **Entry Point:** Starts with the keyword `BcsMain` followed by `{ ... }`.
* **Declarations First:** Declarations (`declist`) must appear before statements (`stmtlist`).
* **Variable Types:** `int`, `bool`

### 2. Supported Statements & Constructs

* **Assignments:** `id = expression`
* **Conditionals:** `if (expr) { stmtlist } else { stmtlist }`
* **Loops:** `while (expr) { stmtlist }`
* **Expressions (expr):** Evaluates `conditional or relational comparisons` (comparing two arithmetic expressions using relational operators) as well as standalone `arithmetic calculations`.

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
