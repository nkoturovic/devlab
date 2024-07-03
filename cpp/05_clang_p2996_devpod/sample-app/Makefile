
C=/usr/local/bin/clang
CXX=/usr/local/bin/clang++
CXXFLAGS=-std=c++26 -freflection -fparameter-reflection -nostdinc++ -cxx-isystem /usr/local/include/c++/v1
LDFLSGS=-stdlib=libc++ -lc++abi
#LDFLSGS=-fuse-ld=lld -stdlib=libstdc++ -L/usr/local/lib -Wl,-rpath,/usr/local/lib -lc++ -lc++abi -lm -lc -lgcc_s -lgcc 

main: main.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $<

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c $<

clean:
	rm main.o main
