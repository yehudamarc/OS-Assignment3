#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096

#define NONE 0
#define NFUA 1
#define LAPA 2
#define SCFIFO 3
#define AQ 4

#define FALSE 0
#define TRUE 1

	// ------------------------- SCFIFO Test ----------------------------------

	// Test SCFIFO algorithm 
	// Allocate more than 16 pages and examine the pages
	// we choose to swap.
	// also test fork process done right regarding swapFile

	void
	scfifotest(void){
		#if (SELECTION == SCFIFO)

		int i, j;
		char *arr[15];
		char input[10];

		printf(1,"SCFIFO test... \n");

		// Allocate all remaining 12 physical pages
		for (i = 0; i < 12; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 12 times - all physical pages taken.\nPress Enter...\n");
		gets(input, 10);

		// Try to allocate another page
		// Run out of memory so calling swapToFile, doesn't choose page 0 beacuse it has been
		// accessed. choose page 1

		arr[12] = sbrk(PGSIZE);
		printf(1, "arr[12]=0x%x\n", arr[12]);
		printf(1, "Called sbrk(PGSIZE) for the 13th time, no page fault should occur and one page in swap file.\nPress Enter...\n");
		gets(input, 10);

		
		// Allocate anothr page
		// Now it will choose page 2, moved to place 1 in queue
		
		arr[13] = sbrk(PGSIZE);
		printf(1, "arr[13]=0x%x\n", arr[13]);
		printf(1, "Called sbrk(PGSIZE) for the 14th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);

		// Allocate anothr page
		// page 3 was accessed, so page 4 is chosen (moved to place 2 in queue)

		arr[14] = sbrk(PGSIZE);
		printf(1, "arr[14]=0x%x\n", arr[14]);
		printf(1, "Called sbrk(PGSIZE) for the 15th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);
		
		// Try to access page 4, which is in swap file - causing page fault
		// replace with the next page (no. 5) and then try to access it and 
		// cause another page fault and so on... total 5 page faults
		
		for (i = 0; i < 5; i++) {
			for (j = 0; j < PGSIZE; j++)
				arr[i][j] = 'k';
		}
		printf(1, "5 page faults should have occurred.\nPress Enter...\n");
		gets(input, 10);

		if (fork() == 0) {
			printf(1, "Child code running.\n");
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
			gets(input, 10);

			// Access the page in swapFile to test that swapFile
			// and paging info coplied right to child proccess
			
			arr[5][0] = 'k';
			printf(1, "A Page fault should have occurred in child proccess.\nPress Enter to exit the child code.\n");
			gets(input, 10);

			exit();
		}
		else {
			wait();
			
			// Check father statistics here
			sbrk(-15 * PGSIZE);
			printf(1, "Press Enter to exit the father code.\n");
			gets(input, 10);
		}
		#endif
	}

	// ------------------------- NFUA Test ----------------------------------

	// Test NFUA algorithm 
	// Similiar to SCFIFO test - Allocate more than 16 pages and examine the pages
	// we choose to swap and fork.

	void
	nfuatest(void){
		#if (SELECTION == NFUA)
		int i, j;
		char *arr[15];
		char input[10];

		printf(1,"NFUA test... \n");

		// Allocate all remaining 13 physical pages
		for (i = 0; i < 13; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress Enter...\n");
		gets(input, 10);

		// Try to allocate another page
		// Run out of memory so calling swapToFile, choose page 0 because
		// it's first in queue and counter is upadtes only in page fault

		// After that tries to access page 0 and another page fault occurs
		// page out page 1

		arr[13] = sbrk(PGSIZE);
		printf(1, "arr[13]=0x%x\n", arr[13]);
		printf(1, "Called sbrk(PGSIZE) for the 14th time, no page fault should occur and one page in swap file.\nPress Enter...\n");
		gets(input, 10);

		
		// Allocate anothr page
		// Now page 0 is in the end of the array
		// page 2 (index 0) is accessed, its counter increased due to page fault
		// so page 3 (index 1) should page out
		
		arr[14] = sbrk(PGSIZE);
		printf(1, "arr[14]=0x%x\n", arr[14]);
		printf(1, "Called sbrk(PGSIZE) for the 15th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);

		// Allocate anothr page
		// skip page 2 (counter still high)
		// should page out page 4 (index 1)

		arr[15] = sbrk(PGSIZE);
		printf(1, "arr[15]=0x%x\n", arr[15]);
		printf(1, "Called sbrk(PGSIZE) for the 16th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);
		
		// Try to access page 4, which is in swap file - causing page fault
		// replace with the next page (no. 5) and then try to access it and 
		// cause another page fault and so on... total 5 page faults
		
		for (i = 0; i < 5; i++) {
			for (j = 0; j < PGSIZE; j++)
				arr[i][j] = 'k';
		}
		printf(1, "5 page faults should have occurred.\nPress Enter...\n");
		gets(input, 10);

			// Test the different between LAPA and NFUA

		// Access page 5 multiple times 
		for (i = 0; i < 15; i++) {
			for (j = 0; j < PGSIZE; j++){
				arr[5][j] = 'k';
				arr[i][j] = 'k';
			}
		}
		printf(1, "Accessed page 5 multiple times...\n");
		// Do not access page 5
		for (i = 0; i < 15; i++) {
			for (j = 0; j < PGSIZE; j++){
				if(i != 5)
					arr[i][j] = 'k';
			}
		}

		// Allocate another page
		// will page out the last page that paged in from file
		// because the counter is reset to 0
		arr[0] = sbrk(PGSIZE);
		printf(1, "arr[0]=0x%x\n", arr[0]);

		printf(1, "Check which page is paged out - should be last one called.\nPress Enter...\n");
		gets(input, 10);

		if (fork() == 0) {
			printf(1, "Child code running.\n");
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
			gets(input, 10);

			// Access the page in swapFile to test that swapFile
			// and paging info copied right to child proccess
			// Page 10 should be pages out
			
			arr[5][0] = 'k';
			printf(1, "A Page fault should have occurred in child proccess.\nPress Enter to exit the child code.\n");
			gets(input, 10);

			exit();
		}
		else {
			wait();
			
			// Check father statistics here
			sbrk(-15 * PGSIZE);
			printf(1, "Press Enter to exit the father code.\n");
			gets(input, 10);
		}
		#endif
	}

	// ------------------------- LAPA Test ----------------------------------

	// Test LAPA algorithm 
	// Similiar to previous test - Allocate more than 16 pages and examine the pages
	// we choose to swap and fork.

	void
	lapatest(void){
		#if (SELECTION == LAPA)
		int i, j;
		char *arr[15];
		char input[10];

		printf(1,"LAPA test... \n");

		// Allocate all remaining 13 physical pages
		for (i = 0; i < 13; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress Enter...\n");
		gets(input, 10);

		// Try to allocate another page
		// Run out of memory so calling swapToFile, choose page 0 because
		// it's first in queue and counter is upadtes only in page fault

		// After that tries to access page 0 and another page fault occurs
		// page out page 1

		arr[13] = sbrk(PGSIZE);
		printf(1, "arr[13]=0x%x\n", arr[13]);
		printf(1, "Called sbrk(PGSIZE) for the 14th time, no page fault should occur and one page in swap file.\nPress Enter...\n");
		gets(input, 10);

		
		// Allocate anothr page
		// Now page 0 is in the end of the array
		// page 2 (index 0) is accessed, its counter increased due to page fault
		// so page 3 (index 1) should page out
		
		arr[14] = sbrk(PGSIZE);
		printf(1, "arr[14]=0x%x\n", arr[14]);
		printf(1, "Called sbrk(PGSIZE) for the 15th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);

		// Allocate anothr page
		// skip page 2 (counter still high)
		// should page out page 4 (index 1)

		arr[15] = sbrk(PGSIZE);
		printf(1, "arr[15]=0x%x\n", arr[15]);
		printf(1, "Called sbrk(PGSIZE) for the 16th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
		gets(input, 10);
		
		// Try to access page 4, which is in swap file - causing page fault
		// replace with the next page (no. 5) and then try to access it and 
		// cause another page fault and so on... total 5 page faults
		
		for (i = 0; i < 5; i++) {
			for (j = 0; j < PGSIZE; j++)
				arr[i][j] = 'k';
		}
		printf(1, "5 page faults should have occurred.\nPress Enter...\n");
		gets(input, 10);

		// Test the different between LAPA and NFUA

		// Access page 5 multiple times 
		for (i = 0; i < 15; i++) {
			for (j = 0; j < PGSIZE; j++){
				arr[5][j] = 'k';
				arr[i][j] = 'k';
			}
		}
		printf(1, "Accessed page 5 multiple times...\n");
		// Do not access page 5
		for (i = 0; i < 15; i++) {
			for (j = 0; j < PGSIZE; j++){
				if(i != 5)
					arr[i][j] = 'k';
			}
		}

		// Allocate another page
		// page 5 didnt accessed recently but is the most accessed page
		// hence should page out some other page
		arr[0] = sbrk(PGSIZE);
		printf(1, "arr[0]=0x%x\n", arr[0]);

		printf(1, "Check which page is paged out - shouldn't be page 5.\nPress Enter...\n");
		gets(input, 10);


		if (fork() == 0) {
			printf(1, "Child code running.\n");
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
			gets(input, 10);

			// Access the page in swapFile to test that swapFile
			// and paging info copied right to child proccess
			// Page 10 should be pages out
			
			arr[5][0] = 'k';
			printf(1, "A Page fault should have occurred in child proccess.\nPress Enter to exit the child code.\n");
			gets(input, 10);

			exit();
		}
		else {
			wait();
			
			// Check father statistics here
			sbrk(-15 * PGSIZE);
			printf(1, "Press Enter to exit the father code.\n");
			gets(input, 10);
		}
		#endif
	}

		// ------------------------- AQ Test ----------------------------------

	// Test AQ algorithm 
	// Allocate more than 16 pages and examine the pages
	// we choose to swap.
	// also test fork process done right regarding swapFile

	// AQ shuold always choose the page with index 0
	// Notice that page 0 is accessed frequently so it'll only
	// be chosen once (before page fault occurs)

	void
	aqtest(void){
		#if (SELECTION == AQ)

		int i, j;
		char *arr[15];
		char input[10];

		printf(1,"AQ test... \n");

		// Allocate all remaining 13 physical pages
		for (i = 0; i < 13; ++i) {
			arr[i] = sbrk(PGSIZE);
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
		}
		printf(1, "Called sbrk(PGSIZE) 13 times - all physical pages taken.\nPress Enter...\n");
		gets(input, 10);

		// Try to allocate another page
		// Run out of memory so calling swapToFile
		// Queue didn't update because there wasn't page fault
		// so page 0 is chosen.
		// Then try to access page 0 and paging out page 1

		arr[13] = sbrk(PGSIZE);
		printf(1, "arr[13]=0x%x\n", arr[13]);
		printf(1, "Called sbrk(PGSIZE) for the 14th time.\nPress Enter...\n");
		gets(input, 10);

		
		// Allocate another page
		// Page 2 was accessed and moves 1 place in the queue
		// so page 3 should be chosen
		
		arr[14] = sbrk(PGSIZE);
		printf(1, "arr[14]=0x%x\n", arr[14]);
		printf(1, "Called sbrk(PGSIZE) for the 15th time.\nPress Enter...\n");
		gets(input, 10);

		// Allocate anothr page
		// Now page 2 should page out, then accessed again
		// and should page out the next one - page 4

		arr[15] = sbrk(PGSIZE);
		printf(1, "arr[15]=0x%x\n", arr[15]);
		printf(1, "Called sbrk(PGSIZE) for the 16th time.\nPress Enter...\n");
		gets(input, 10);
		
		// Try to access page 4, which is in swap file - causing page fault
		// replace with the next page (no. 5) and then try to access it and 
		// cause another page fault and so on... total 5 page faults
		
		for (i = 0; i < 5; i++) {
			for (j = 0; j < PGSIZE; j++)
				arr[i][j] = 'k';
		}
		printf(1, "5 page faults should have occurred.\nPress Enter...\n");
		gets(input, 10);

		if (fork() == 0) {
			printf(1, "Child code running.\n");
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
			gets(input, 10);

			// Access the page in swapFile to test that swapFile
			// and paging info coplied right to child proccess
			
			arr[5][0] = 'k';
			printf(1, "A Page fault should have occurred in child proccess.\nPress Enter to exit the child code.\n");
			gets(input, 10);

			exit();
		}
		else {
			wait();
			
			// Check father statistics here
			sbrk(-15 * PGSIZE);
			printf(1, "Press Enter to exit the father code.\n");
			gets(input, 10);
		}
		#endif
	}


int
main(int argc, char *argv[]){

	#if (SELECTION==SCFIFO)
	scfifotest();	
	#endif
	#if (SELECTION == NFUA)
	nfuatest();
	#endif
	#if (SELECTION == LAPA)
	lapatest();
	#endif
	#if (SELECTION == AQ)
	aqtest();
	#endif

	exit();

}
