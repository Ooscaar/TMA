# SPDX-License-Identifier: (GPL-2.0)
CC := gcc

all: common_params.o common_user_bpf_xdp.o common_libbpf.o

CFLAGS := -g -Wall

BASE_DIR = `pwd`

LIBBPF_DIR = $(BASE_DIR)/libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I$(BASE_DIR)/headers

common_params.o: common_params.c common_params.h
	$(CC) $(CFLAGS) -c -o $@ $<

common_user_bpf_xdp.o: common_user_bpf_xdp.c common_user_bpf_xdp.h
	$(CC) $(CFLAGS) -c -o $@ $<

common_libbpf.o: common_libbpf.c common_libbpf.h
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	echo "Disabled option" # rm -f *.o
