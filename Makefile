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

# Main class
MAINCLASS = com.craftinginterpreters.lox.Lox

# Default target
all: $(OUTDIR)/jlox

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

# Clean target
clean:
	rm -rf $(OUTDIR)

.PHONY: all clean