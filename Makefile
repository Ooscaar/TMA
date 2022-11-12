index: index.c
	gcc -Wall -g -o a.out index.c -lpcap
sniffer: sniffer.c
	gcc -Wall -g -o sniffer sniffer.c -lpcap

clean:
	rm a.out