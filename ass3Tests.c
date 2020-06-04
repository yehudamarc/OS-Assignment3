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
	char *arr[15];
	char input[10];
	// Allocate all remaining 13 physical pages
	for (i = 0; i < 13; ++i) {
		arr[i] = sbrk(PGSIZE);
		printf(1, "arr[%d]=0x%x\n", i, arr[i]);
	}
	printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress any key...\n");
	gets(input, 10);

	/*
	Allocate page 15.
	This allocation would cause page 0 to move to the swap file, but upon returning
	to user space, a PGFLT would occur and pages 0,1 will be hot-swapped.
	Afterwards, page 1 is in the swap file, the rest are in memory.
	*/
	arr[13] = sbrk(PGSIZE);
	printf(1, "arr[13]=0x%x\n", arr[13]);
	printf(1, "Called sbrk(PGSIZE) for the 14th time, a page fault should occur and one page in swap file.\nPress any key...\n");
	gets(input, 10);

	exit();
}
