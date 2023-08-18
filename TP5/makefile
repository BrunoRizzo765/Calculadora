calculadora: calculadora.o main.o scanner.o parser.o

	gcc calculadora.o main.o scanner.o parser.o -o calculadora -lfl -lm -static



main.o: main.c scanner.c parser.c calc.c

	gcc -c main.c



calculadora.o: calc.c parser.h

	gcc -c calc.c



scanner.o: scanner.c parser.h

	gcc -c scanner.c



parser.o: parser.c scanner.h

	gcc -c parser.c



scanner.c scanner.h: scanner.l

	flex scanner.l



parser.c parser.h: parser.y

	bison parser.y



clean : 

	rm parser.c parser.h parser.o scanner.c scanner.o scanner.h main.o main.c calc.c calculadora