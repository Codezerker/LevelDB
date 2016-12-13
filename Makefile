LIBRARY_SEARCH_PATH = /usr/local/lib
LINKER_FLAGS = -Xlinker -L$(LIBRARY_SEARCH_PATH)

BUILD_DIR = ./.build
PACKAGES_DIR = ./Packages
DIRS_TO_CLEAN = $(BUILD_DIR) $(PACKAGES_DIR)

all:
	swift build $(LINKER_FLAGS)

test:
	swift test $(LINKER_FLAGS)

clean:
	rm -rf $(DIRS_TO_CLEAN)
