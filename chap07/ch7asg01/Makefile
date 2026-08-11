# Compiler settings
COBC = cobc
COBFLAGS = -std=default -x -Wall

# Target names
TARGET = ch7asg01
SOURCE = ch7asg01.cbl
LISTING = ch7asg01.lst
ZIP_NAME = ch7asg01_submission.zip

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
		salary.txt
		
.PHONY: all run zip clean
