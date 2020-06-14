// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

int getNumberOfFreePages(void);
int totalPages;
int freePages;

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);

  // Calculate total number of free pages
  totalPages = (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart))/PGSIZE;

  
  // initilize current pages array
  for(int i = 0; i < MAX_PAGES; i++){
    currentPages[i].pa = -1;
    currentPages[i].refCounter = 0;
  }

}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;

  // Continue to calculate total number of free pages
  totalPages += (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart))/PGSIZE;
  freePages = totalPages;

}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  if(kmem.use_lock)
    acquire(&kmem.lock);

/*
  // COW is not relevant for init and shell
  struct proc *p;
  if(isSchedActive)
    p = myproc();
  else
    p = 0;
  if(p && p->pid > 2){
      cprintf("%s%d\n", "kfree, process pid: " , p->pid);
      cprintf("%s%d\n", "v: " , (uint)v );
    // find page in current pages array
    int pgindx = -1;
    for(int i = 0; i < MAX_PAGES; i++){
      if(currentPages[i].va == (uint)v){
        pgindx = i;
        break;
      }
    }
    if(pgindx == -1)
      panic("kfree: couldnt fing page in currentPages");

    if(currentPages[pgindx].refCounter < 1)
      panic("kfree: refCounter is under 1");

    // if refrence count is more than 1, just decrease it
    if(currentPages[pgindx].refCounter > 1){
      currentPages[pgindx].refCounter--;
      
      if(kmem.use_lock)
      release(&kmem.lock);
      return;
    }
    // else, it's the only reference - remove from memory
    currentPages[pgindx].va = 0;
    currentPages[pgindx].refCounter = 0;
  }
*/
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  // Update free pages counter
  freePages++;
 
  if(kmem.use_lock)
    release(&kmem.lock);

}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;

    // Update free pages counter
    freePages--;
/*
    struct proc *p;
    if(isSchedActive)
      p = myproc();
    else
      p = 0;
    if(p && p->pid > 2){
      // Update free pages counter
      freePages--;
      // Update currentPages array
      int pgindx = -1;
       for(int i = 0; i < MAX_PAGES; i++){
        if(currentPages[i].va == 0){
          pgindx = i;
          break;
        }
      }
      if(pgindx == -1)
        panic("kalloc: couldnt find a free spot in currentPages");
      currentPages[pgindx].va = (uint)r;
      currentPages[pgindx].refCounter = 1;
      // Test prints
      cprintf("%s%d\n", "process pid: " , p->pid);
      cprintf("%s%d\n", "r: " , (uint)r );
      cprintf("%s%d\n", "virtual address: " , currentPages[pgindx].va);

    }
    */
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int
getNumberOfFreePages(void){
  return freePages;
}

int
getNumberOfTotalPages(void){
  return totalPages;
}

