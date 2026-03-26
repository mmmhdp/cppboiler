
CMAKE ?= cmake
GENERATOR ?=

BUILD_DIR        ?= build
BUILD_DIR_DEBUG  ?= build-debug
BUILD_DIR_ASAN   ?= build-asan

TARGET ?= REPLACE_WITH_TARGET_impl

VALGRIND ?= valgrind
VG_OPTS  ?= --leak-check=full --show-leak-kinds=all --track-origins=yes

.PHONY: all
all: release

.PHONY: run
run: all
	./$(BUILD_DIR)/$(TARGET)

.PHONY: r
r: run 

.PHONY: test-debug
test-debug: debug
	cd $(BUILD_DIR_DEBUG) && ctest --rerun-failed --output-on-failure

.PHONY: td
td: test-debug

.PHONY: test
test: all
	cd $(BUILD_DIR) && ctest --rerun-failed --output-on-failure

.PHONY: t
t: test

.PHONY: docs
docs:
	doxygen Doxyfile

.PHONY: release
release:
	$(CMAKE) -S . -B $(BUILD_DIR) \
		-DCMAKE_BUILD_TYPE=Release \
		$(GENERATOR)
	$(CMAKE) --build $(BUILD_DIR)

.PHONY: debug
debug:
	$(CMAKE) -S . -B $(BUILD_DIR_DEBUG) \
		-DCMAKE_BUILD_TYPE=Debug \
		$(GENERATOR)
	$(CMAKE) --build $(BUILD_DIR_DEBUG)

.PHONY: d
d: debug

.PHONY: asan
asan:
	$(CMAKE) -S . -B $(BUILD_DIR_ASAN) \
		-DCMAKE_BUILD_TYPE=Debug \
		-DSANITIZE_ADDRESS=ON \
		$(GENERATOR)
	$(CMAKE) --build $(BUILD_DIR_ASAN)
	./$(BUILD_DIR_ASAN)/$(TARGET)

.PHONY: as
as: asan

.PHONY: valgrind
valgrind: debug
	$(VALGRIND) $(VG_OPTS) ./$(BUILD_DIR_DEBUG)/$(TARGET)

.PHONY: v
v: valgrind 

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(BUILD_DIR_DEBUG) $(BUILD_DIR_ASAN)
