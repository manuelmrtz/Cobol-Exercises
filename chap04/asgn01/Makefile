# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = asgn01
SOURCE = asgn01.cbl
LISTING = asgn01.lst
ZIP_NAME = asgn01_submission.zip

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
		asgn01-i.dat \
		asgn01-o1.dat \
		asgn01-o2.dat

# Clean target: removes generated files
clean:
	rm -f $(TARGET) \
		$(LISTING) \
		asgn01-o1.dat \
		asgn01-o2.dat \
		$(ZIP_NAME)

.PHONY: all run zip clean