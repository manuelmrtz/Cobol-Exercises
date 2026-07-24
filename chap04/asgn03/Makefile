# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = asgn03
SOURCE = asgn03.cbl
LISTING = asgn03.lst
ZIP_NAME = asgn03_submission.zip

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
		account-master.dat 

# Clean target: removes generated files
clean:
	rm -f $(TARGET) \
		$(LISTING) \
		elec-bill.dat \
		gas-bill.dat \
		$(ZIP_NAME)

.PHONY: all run zip clean