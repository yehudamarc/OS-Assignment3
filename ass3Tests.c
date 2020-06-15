#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096
#define DEBUG 0

/*
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
*/
	/*
	Allocate page 15.
	This allocation would cause page 0 to move to the swap file, but upon returning
	to user space, a PGFLT would occur and pages 0,1 will be hot-swapped.
	Afterwards, page 1 is in the swap file, the rest are in memory.
	*/

/*
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

*/

/*
char *a[16];
  int i;
  int j;
  for(i=0; i<8;i++){
    a[i] = malloc(4096);
   	for(j=0;j<4096;j++)
      a[i][j] = 'a';
  }

  for(i=8; i<16;i++){
    a[i] = malloc(4096);

    for(j=0;j<4096;j++)
      a[i][j] = 'b';
  }

  //fork();

  printf(1,"%c\n",a[0][0]);
  printf(1,"%c\n",a[1][0]);
  printf(1,"%c\n",a[2][0]);
  printf(1,"%c\n",a[14][0]);
  printf(1,"%c\n",a[15][3333]);
*/

	// -------------- COW Test -------------------
	
	// Allocate 10 pages, fork and then write to 1 page
	// check prints - should be 1 less free page after the write
	// Also run once with allocuvm and once with old_allocuvm
	// and notice the changes in the number of free pages after fork

	void
	cowtest(void){

		char *arr[30];
		char input[10];
		// Allocate all remaining 13 physical pages
		get_pages_info();
		for (int i = 0; i < 10; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 10 times - all physical pages taken.\nPress any key...\n");
		getpid();
		get_pages_info();	
		gets(input, 10);
		//test cow after fork
		int j=0;
		if (fork()==0){
			get_pages_info();
		//printf(1, "Called sbrk(PGSIZE) for the X time, a page fault should occur and one page in swap file.\n");
			printf(1, "before: %s\n", arr[j][2]);
			arr[j][2] = 'k';
			printf(1, "after: %s\n", arr[j][2]);
		
			get_pages_info();
			printf(1, "Number of free pages should be decreased by 1\n");
			exit();
		}
		wait();
		get_pages_info();
		
		printf(1, "COW test 1 finished - check results\n");
		sleep(100);

	}

	// -------------- Fork Test ----------

	// Performe several forks
	// Just check there is no errors
	void
	forktest(void){
		printf(1, "Fork test ...\n");

		if(fork() == 0){
			if(fork() == 0){
				if(fork() == 0)
					exit();
				wait();
				exit();
			}
			wait();
			exit();
		}

		wait();
		
		printf(1, "Fork test passed\n");
		sleep(100);
	}

	// ------------ COW test 2 ------------------

	// Allocate more than half of total memory
	// then performe fork, should collapse without COW

	// Don't run with SELECTION=NONE - size of currentPages is
	// too small because the pages pre process limitation removed

	void
	cowtest2(void){

		printf(1, "COW test 2 ...\n");

		if(fork() == 0){
			char *arr2[30000];

			for (int i = 0; i < 30000; ++i) {
				arr2[i] = sbrk(PGSIZE);
				if(i < 10)
					printf(1, "arr[%d]=0x%x\n", i, arr2[i]);
			}
			if(fork() == 0)
				exit();
			
			wait();
			exit();
		}

		wait();

		printf(1, "COW test 2 passed\n");
		sleep(100);

	}


	// ------------- Another Test -----------------

/*
	char *arr[30];
	char input[10];
	// Allocate all remaining 13 physical pages
	get_pages_info();
	for (int i = 0; i < 13; ++i) {
		arr[i] = sbrk(PGSIZE);
		printf(1, "arr[%d]=0x%x\n", i, arr[i]);
	}
	printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress any key...\n");
//	getpid();
	get_pages_info();	
	gets(input, 10);
	//test cow after fork
	arr[14] = sbrk(PGSIZE);
	if (fork()==0){
		get_pages_info();
		printf(1, "Called sbrk(PGSIZE) for the X time, a page fault should occur and one page in swap file.\n");
		printf(1, "before: %s\n", arr[1][2]);
		arr[1][2] = 'k';
		printf(1, "after: %s\n", arr[1][2]);
	
		get_pages_info();
		getpid();
		exit();
	}
	wait();
	get_pages_info();
*/

	// ----------------- SOme test we stole -----------------

	void
	stolentest(void){
		// if SCFIFO
		int i, j;
		char *arr[14];
		char input[10];

		// TODO delete
		printf(1, "myMemTest: testing SCFIFO... \n");

		// Allocate all remaining 12 physical pages
		for (i = 0; i < 12; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 14 times - all physical pages taken.\nPress any key...\n");
		gets(input, 10);

		/*
		Allocate page 15.
		For this allocation, SCFIFO will consider moving page 0 to disk, but because it has been accessed, page 1 will be moved instead.
		Afterwards, page 1 is in the swap file, the rest are in memory.
		*/
		arr[12] = sbrk(PGSIZE);
		printf(1, "arr[12]=0x%x\n", arr[12]);
		printf(1, "Called sbrk(PGSIZE) for the 14th time, no page fault should occur and one page in swap file.\nPress any key...\n");
		gets(input, 10);

		/*
		Allocate page 16.
		For this allocation, SCFIFO will consider moving page 2 to disk, but because it has been accessed, page 3 will be moved instead.
		Afterwards, pages 1 & 3 are in the swap file, the rest are in memory.
		*/
		arr[13] = sbrk(PGSIZE);
		printf(1, "arr[13]=0x%x\n", arr[13]);
		printf(1, "Called sbrk(PGSIZE) for the 13th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);

		/*
		Access page 3, causing a PGFLT, since it is in the swap file. It would be
		hot-swapped with page 4. Page 4 is accessed next, so another PGFLT is invoked,
		and this process repeats a total of 5 times.
		*/
		for (i = 0; i < 5; i++) {
			for (j = 0; j < PGSIZE; j++)
				arr[i][j] = 'k';
		}
		printf(1, "5 page faults should have occurred.\nPress any key...\n");
		gets(input, 10);

		/*
		If DEBUG flag is defined as != 0 this is just another example showing 
		that because SCFIFO doesn't page out accessed pages, no needless page faults occurr.
		*/
		if(DEBUG){
			for (i = 0; i < 5; i++) {
				printf(1, "Writing to address 0x%x\n", arr[i]);
				arr[i][0] = 'k';
			}
			//printf(1, "No page faults should have occurred.\nPress any key...\n");
			gets(input, 10);
		}

		if (fork() == 0) {
			printf(1, "Child code running.\n");
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
			gets(input, 10);

			/*
			The purpose of this write is to create a PGFLT in the child process, and
			verify that it is caught and handled properly.
			*/
			arr[5][0] = 'k';
			printf(1, "A Page fault should have occurred in child proccess.\nPress any key to exit the child code.\n");
			gets(input, 10);

			exit();
		}
		else {
			wait();

			/*
			Deallocate all the pages.
			*/
			sbrk(-14 * PGSIZE);
			printf(1, "Deallocated all extra pages.\nPress any key to exit the father code.\n");
			gets(input, 10);
		}

	}

int
main(int argc, char *argv[]){

	// cowtest();
	// forktest();
	// cowtest2();

	stolentest();

	exit();

}
