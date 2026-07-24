# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = asgn05
SOURCE = asgn05.cbl
LISTING = asgn05.lst
ZIP_NAME = asgn05_submission.zip

# Default target: builds the binary and compiler listing
all: $(TARGET)

$(TARGET): $(SOURCE)
	$(COBC) $(COBFLAGS) -t $(LISTING) -Xref \
		-o $(TARGET) $(SOURCE)

# Run target: builds and executes the program
run: $(TARGET)
	./$(TARGET)

# Zip target: builds everything and packages the assignment
zip: $(TARGET)
	zip -r $(ZIP_NAME) \
		$(SOURCE) \
		Makefile \
		$(LISTING) \
		rental-file.dat \
		sales-file.dat  \
		master-file.dat

# Clean target: removes generated files
clean:
	rm -f $(TARGET) \
		$(LISTING) \
		$(ZIP_NAME) \
		master-file.dat

.PHONY: all run zip clean