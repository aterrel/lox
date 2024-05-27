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


# Main ASTPrint
ASTPRINT_SOURCES = $(wildcard $(SRCDIR)/com/craftinginterpreters/lox/*.java)
ASTPRINT_MAINCLASS = com.craftinginterpreters.lox.AstPrinter
ASTPRINT_CLASSES =  $(ASTPRINT_SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)
ASTPRINT_EXE = ast_print

# Main GenerateAst
AST_SOURCES = $(wildcard $(SRCDIR)/com/craftinginterpreters/tool/*.java)
AST_MAINCLASS = com.craftinginterpreters.tool.GenerateAst
AST_CLASSES =  $(AST_SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)
AST_EXE = generate_ast

# Default target
all: $(OUTDIR)/jlox $(OUTDIR)/generate_ast $(OUTDIR)/ast_print

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
	jar cvfm $(OUTDIR)/$(AST_EXE).jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/$(AST_EXE)
	echo "java -cp .:$(OUTDIR) $(AST_MAINCLASS) \$$1" >> $(OUTDIR)/$(AST_EXE)
	chmod +x $(OUTDIR)/$(AST_EXE)

$(OUTDIR)/ast_print: $(ASTPRINT_CLASSES)
	echo "Main-Class: $(ASTPRINT_MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/$(ASTPRINT_EXE).jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/$(ASTPRINT_EXE)
	echo "java -cp .:$(OUTDIR) $(ASTPRINT_MAINCLASS)" >> $(OUTDIR)/$(ASTPRINT_EXE)
	chmod +x $(OUTDIR)/$(ASTPRINT_EXE)

# Clean target
clean:
	rm -rf $(OUTDIR)

.PHONY: all clean generate_ast