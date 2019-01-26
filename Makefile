TITLE := Containers Orchestration & Load-balancing
SUBJECT := LIA
NUMBER := 1
TARGET := I_Sukhoplyuev-$(SUBJECT)-$(shell sed -e 's/\s/-/g' <<< "${TITLE}").pdf

all: $(TARGET)

%.pdf: $(wildcard *.md)
	# More quotes! Welcome to shell-family
	./scripts/preamble.sh "$(TITLE)" "$(SUBJECT)" "$(NUMBER)" | cat - $< | pandoc -o "$@"

clean:
	git clean -nf
	read -p "Are you sure?"
	git clean -xf