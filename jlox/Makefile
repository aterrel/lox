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

# LOX files
LOXDIR = $(SRCDIR)/com/craftinginterpreters/lox
SOURCES = $(wildcard $(LOXDIR)/*.java)
CLASSES = $(SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)
MAINCLASS = com.craftinginterpreters.lox.Lox
JLOX_EXE = jlox
JLOX_JAR = $(JLOX_EXE).jar
JLOX_DEBUG_EXE = jlox-debug

# Main ASTPrint
ASTPRINT_SOURCES = $(wildcard $(LOXDIR)/*.java)
ASTPRINT_MAINCLASS = com.craftinginterpreters.lox.AstPrinter
ASTPRINT_CLASSES =  $(ASTPRINT_SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)
ASTPRINT_EXE = ast_print

# Main GenerateAst
TOOLDIR = $(SRCDIR)/com/craftinginterpreters/tool
AST_SOURCES = $(wildcard $(TOOLDIR)/*.java)
AST_MAINCLASS = com.craftinginterpreters.tool.GenerateAst
AST_CLASSES =  $(AST_SOURCES:$(SRCDIR)/%.java=$(OUTDIR)/%.class)
AST_EXE = generate_ast

# Default target
all: jlox ast $(OUTDIR)/ast_print

# Rule to compile Java source files
$(OUTDIR)/%.class: $(SRCDIR)/%.java
	$(JAVAC) $(JFLAGS) -d $(OUTDIR) -cp $(CLASSPATH) $<

$(OUTDIR)/$(JLOX_JAR):$(CLASSES)
	echo "Main-Class: $(MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/$(JLOX_JAR) $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt

# Rule to create jlox executable
$(OUTDIR)/$(JLOX_EXE): $(OUTDIR)/$(JLOX_JAR)
	echo "#!/bin/bash" > $(OUTDIR)/$(JLOX_EXE)
	echo "java -cp .:$(OUTDIR) $(MAINCLASS) \$${@}" >> $(OUTDIR)/$(JLOX_EXE)
	chmod +x $(OUTDIR)/$(JLOX_EXE)

# Rule to create jlox executable
$(OUTDIR)/$(JLOX_DEBUG_EXE): $(OUTDIR)/$(JLOX_JAR)
	echo "#!/bin/bash" > $(OUTDIR)/$(JLOX_EXE)
	echo "jdb -sourcepath src -classpath .:$(OUTDIR) $(MAINCLASS) \$${@}" >> $(OUTDIR)/$(JLOX_DEBUG_EXE)
	chmod +x $(OUTDIR)/$(JLOX_DEBUG_EXE)

# Rule to create generate_ast executable
$(OUTDIR)/$(AST_EXE): $(AST_CLASSES)
	echo "Main-Class: $(AST_MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/$(AST_EXE).jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/$(AST_EXE)
	echo "java -cp .:$(OUTDIR) $(AST_MAINCLASS) \$${@}" >> $(OUTDIR)/$(AST_EXE)
	chmod +x $(OUTDIR)/$(AST_EXE)

$(OUTDIR)/$(ASTPRINT_EXE): $(ASTPRINT_CLASSES)
	echo "Main-Class: $(ASTPRINT_MAINCLASS)" > $(OUTDIR)/manifest.txt
	jar cvfm $(OUTDIR)/$(ASTPRINT_EXE).jar $(OUTDIR)/manifest.txt -C $(OUTDIR) .
	rm $(OUTDIR)/manifest.txt
	echo "#!/bin/bash" > $(OUTDIR)/$(ASTPRINT_EXE)
	echo "java -cp .:$(OUTDIR) $(ASTPRINT_MAINCLASS)" >> $(OUTDIR)/$(ASTPRINT_EXE)
	chmod +x $(OUTDIR)/$(ASTPRINT_EXE)

jlox: $(OUTDIR)/$(JLOX_EXE)

jlox-debug: $(OUTDIR)/$(JLOX_DEBUG_EXE)

# Generate the ast
ast: $(OUTDIR)/generate_ast
	./$(OUTDIR)/generate_ast $(LOXDIR)

# Clean target
clean:
	rm -rf $(OUTDIR)

.PHONY: all clean ast jlox jlox-debug