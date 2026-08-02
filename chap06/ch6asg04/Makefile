# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = ch6asg04
SOURCE = ch6asg04.cbl
LISTING = ch6asg04.lst
ZIP_NAME = ch6asg04_submission.zip

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
		$(LISTING)

# Clean target: removes generated files
clean:
	rm -f $(TARGET) \
		$(LISTING) \
		$(ZIP_NAME) \
		mailing-list.txt
		
		
.PHONY: all run zip clean
