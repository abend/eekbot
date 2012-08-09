
all: compile run

debug: compile-debug run-debug

compile:
	nxjc Dangler.java

run:
	nxj -r Dangler

compile-debug:
	nxjc Dangler.java
	nxjlink -gr -o Dangler.nxj -od Dangler.nxd Dangler

run-debug:
	nxjupload -r Dangler.nxj
	sleep 5
	nxjconsole -di Dangler.nxd
