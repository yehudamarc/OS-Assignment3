#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096
#define DEBUG 0

int
main(int argc, char *argv[]){

	//#if FIFO

	int i;
	char *arr[30];
	char input[10];
	// Allocate all remaining 13 physical pages
	for (i = 0; i < 15; ++i) {
		arr[i] = sbrk(PGSIZE);
		printf(1, "arr[%d]=0x%x\n", i, arr[i]);
	}
	printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress any key...\n");
	getpid();	
	gets(input, 10);

	/*
	Allocate page 15.
	This allocation would cause page 0 to move to the swap file, but upon returning
	to user space, a PGFLT would occur and pages 0,1 will be hot-swapped.
	Afterwards, page 1 is in the swap file, the rest are in memory.
	*/
	for (int j = 14; j < 30 ; j++){
		arr[j] = sbrk(PGSIZE);
		printf(1, "arr[%d]=0x%x\n", j, arr[j]);
	}
	if (fork()==0){
	printf(1, "Called sbrk(PGSIZE) for the X time, a page fault should occur and one page in swap file.\n");
	for(int j = 0; j < 16; j++){
		// getpid();
		printf(1, "before: %s", arr[j][2]);
		arr[j][2] = 'k';
		printf(1, "after: %s", arr[j][2]);
	}	
	getpid();
	exit();
	}
	wait();
	exit();
}
