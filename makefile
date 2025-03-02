TARGET=lib/libringlog.a
CXX=g++
CFLAGS=-g -O2 -Wall -fPIC
SRC=src
INC=-Isrc
OBJS = $(addsuffix .o, $(basename $(wildcard $(SRC)/*.cc)))

$(TARGET): $(OBJS)
	-mkdir -p lib
	ar cqs $@ $^

-include $(OBJS:.o=.d)

%.o: %.cc
	$(CXX) $(CFLAGS) -c -o $@ $< $(INC)
	@$(CXX) -MM $*.cc $(INC) > $*.d
	@mv -f $*.d $*.d.tmp
	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
	sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
	rm -f $*.d.tmp

.PHONY: clean

clean:
	-rm -f src/*.o $(TARGET)

vvlog:
	g++ -g -o vvlog test.cc -lpthread -I./src -L./lib/ -lringlog
