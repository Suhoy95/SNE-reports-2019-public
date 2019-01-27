TITLE := Containers Orchestration & Load-balancing
SUBJECT := LIA
NUMBER := 1
TARGET_FILENAME := I_Sukhoplyuev-$(SUBJECT)-$(shell sed -e 's/\s/-/g' <<< "${TITLE}")
TARGET := $(TARGET_FILENAME).pdf

all: $(TARGET)

%.pdf: $(wildcard *.md)
	# More quotes! Welcome to shell-family
	./scripts/preamble.sh "$(TITLE)" "$(SUBJECT)" "$(NUMBER)" | cat - $< | pandoc -o "$@"

export: all $(wildcard *)
	# Welcome to shell-family
	zip "$(TARGET_FILENAME).zip" $(addprefix ",$(addsuffix ",$(wildcard *)))

clean:
	git clean -xnf
	read -p "Are you sure?"
	git clean -xf