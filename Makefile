# Java compiler
JAVAC = javac

# Java flags
JFLAGS = -g

# Source directory
SRCDIR = src

# Classpath
CLASSPATH = $(SRCDIR)

# Output directory
OUTDIR = out

# Java source files
SOURCES = $(wildcard $(SRCDIR)/com/craftinginterpreters/lox/*.java)

# Class files
CLASSES = $(SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)

# Main Lox class
MAINCLASS = com.craftinginterpreters.lox.Lox

# Main GenerateAst
AST_SOURCES = $(wildcard $(SRCDIR)/com/craftinginterpreters/tool/*.java)
AST_MAINCLASS = com.craftinginterpreters.tool.GenerateAst
AST_CLASSES =  $(AST_SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)

# Default target
all: $(OUTDIR)/jlox $(OUTDIR)/generate_ast

generate_ast: $(OUTDIR)/generate_ast

# Rule to compile Java source files
$(OUTDIR)/%.class: $(SRCDIR)/%.java
	$(JAVAC) $(JFLAGS) -d $(OUTDIR) -cp $(CLASSPATH) $<

# Rule to create jlox executable
$(OUTDIR)/jlox: $(CLASSES)
	echo "Main-Class: $(MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/jlox.jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/jlox
	echo "java -cp .:$(OUTDIR) $(MAINCLASS)" >> $(OUTDIR)/jlox
	chmod +x $(OUTDIR)/jlox

# Rule to create generate_ast executable
$(OUTDIR)/generate_ast: $(AST_CLASSES)
	echo "Main-Class: $(AST_MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/generate_ast.jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/generate_ast
	echo "java -cp .:$(OUTDIR) $(AST_MAINCLASS) \$$1" >> $(OUTDIR)/generate_ast
	chmod +x $(OUTDIR)/generate_ast


# Clean target
clean:
	rm -rf $(OUTDIR)

.PHONY: all clean generate_ast