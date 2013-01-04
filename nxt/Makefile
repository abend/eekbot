DEFAULT=Floorbot

# USB: -u
# Bluetooth: -b
CONNECT_FLAG=-u

all: run

debug: $(DEFAULT)-debug.nxj

run: $(DEFAULT).nxj
	nxj -r $(CONNECT_FLAG) $(DEFAULT)

run-debug: $(DEFAULT).nxd
	nxjupload -r $(CONNECT_FLAG) $(DEFAULT)-debug.nxj
	sleep 5
	nxjconsole $(CONNECT_FLAG) -di $(DEFAULT)-debug.nxd

clean:
	rm *.nxj *.nxd *.class


Floorbot.class: Data.class HomingButtonListener.class


%.class: %.java
	@echo compiling $@
	@nxjc $<

%.nxj: %.class
	@echo linking $@
	@nxjlink -o $*.nxj $*

%.nxd: %.class
	@echo debug linking $@
	@nxjlink -gr -o $*-debug.nxj -od $*-debug.nxd $*
