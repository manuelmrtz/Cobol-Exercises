# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = asgn01
SOURCE = asgn01.cbl
ZIP_NAME = asgn01_submission.zip

# Default target: builds the binary
all: $(TARGET)

$(TARGET): $(SOURCE)
	$(COBC) $(COBFLAGS) -o $(TARGET) $(SOURCE)

# Run target: builds and executes the program
run: $(TARGET)
	./$(TARGET)

# Zip target: packages files for assignment submission
zip:
	zip -r $(ZIP_NAME) $(SOURCE) Makefile asgn01-i.dat asgn01-o1.dat asgn01-o2.dat

# Clean target: deletes the compiled binary, output logs, and zip archive
clean:
	rm -f $(TARGET) asgn01-o1.dat asgn01-o2.dat $(ZIP_NAME)

.PHONY: all run zip clean
