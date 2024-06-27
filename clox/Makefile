# Compiler
CC = clang

# Compiler flags
CFLAGS = -Wall -Wextra -std=c11 -g 

# Source directory
SRCDIR = src

# Output directory
OUTDIR = out

# Executable name
TARGET = clox

# Source files
SRCS = $(wildcard $(SRCDIR)/*.c)

# Object files
OBJS = $(patsubst $(SRCDIR)/%.c, $(OUTDIR)/%.o, $(SRCS))

# Default target
all: $(OUTDIR)/$(TARGET)

out:
	mkdir -p out

# Linking
$(OUTDIR)/$(TARGET): $(OBJS) | $(OUTDIR)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

# Compilation
$(OUTDIR)/%.o: $(SRCDIR)/%.c | $(OUTDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up
clean:
	rm -rf $(OUTDIR)

# Add more .c files to SRCS as needed, for example:
# SRCS = main.c file1.c file2.c
# The object files will be automatically handled by the pattern rule above

.PHONY: all clean
