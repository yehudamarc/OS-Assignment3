
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 d5 10 80       	mov    $0x8010d5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 33 10 80       	mov    $0x801033f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 d5 10 80       	mov    $0x8010d5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 84 10 80       	push   $0x80108420
80100051:	68 c0 d5 10 80       	push   $0x8010d5c0
80100056:	e8 85 49 00 00       	call   801049e0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 1d 11 80 bc 	movl   $0x80111cbc,0x80111d0c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 1d 11 80 bc 	movl   $0x80111cbc,0x80111d10
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 1c 11 80       	mov    $0x80111cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 84 10 80       	push   $0x80108427
80100097:	50                   	push   %eax
80100098:	e8 13 48 00 00       	call   801048b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 1d 11 80       	mov    0x80111d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 d5 10 80       	push   $0x8010d5c0
801000e4:	e8 37 4a 00 00       	call   80104b20 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 1d 11 80    	mov    0x80111d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 1d 11 80    	mov    0x80111d0c,%ebx
80100126:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100162:	e8 79 4a 00 00       	call   80104be0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 47 00 00       	call   801048f0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 24 00 00       	call   801025e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 84 10 80       	push   $0x8010842e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 dd 47 00 00       	call   80104990 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 17 24 00 00       	jmp    801025e0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 84 10 80       	push   $0x8010843f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 9c 47 00 00       	call   80104990 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 47 00 00       	call   80104950 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010020b:	e8 10 49 00 00       	call   80104b20 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 1d 11 80       	mov    0x80111d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 1d 11 80       	mov    0x80111d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 d5 10 80 	movl   $0x8010d5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 7f 49 00 00       	jmp    80104be0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 84 10 80       	push   $0x80108446
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 16 00 00       	call   80101890 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 8f 48 00 00       	call   80104b20 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 3f 11 80    	mov    0x80113fa0,%edx
801002a7:	39 15 a4 3f 11 80    	cmp    %edx,0x80113fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 a0 3f 11 80       	push   $0x80113fa0
801002c5:	e8 c6 41 00 00       	call   80104490 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 3f 11 80    	mov    0x80113fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 3f 11 80    	cmp    0x80113fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 3a 00 00       	call   80103db0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 ec 48 00 00       	call   80104be0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 14 00 00       	call   801017b0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 3f 11 80       	mov    %eax,0x80113fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 3f 11 80 	movsbl -0x7feec0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 8e 48 00 00       	call   80104be0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 14 00 00       	call   801017b0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 3f 11 80    	mov    %edx,0x80113fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 d2 28 00 00       	call   80102c80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 84 10 80       	push   $0x8010844d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b5 8e 10 80 	movl   $0x80108eb5,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 23 46 00 00       	call   80104a00 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 84 10 80       	push   $0x80108461
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 51 5f 00 00       	call   80106390 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 9f 5e 00 00       	call   80106390 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 93 5e 00 00       	call   80106390 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 87 5e 00 00       	call   80106390 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 b7 47 00 00       	call   80104ce0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ea 46 00 00       	call   80104c30 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 84 10 80       	push   $0x80108465
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 84 10 80 	movzbl -0x7fef7b70(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 12 00 00       	call   80101890 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 00 45 00 00       	call   80104b20 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 94 45 00 00       	call   80104be0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 11 00 00       	call   801017b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 bc 44 00 00       	call   80104be0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 84 10 80       	mov    $0x80108478,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 2b 43 00 00       	call   80104b20 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 84 10 80       	push   $0x8010847f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 f8 42 00 00       	call   80104b20 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
80100856:	3b 05 a4 3f 11 80    	cmp    0x80113fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 3f 11 80       	mov    %eax,0x80113fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 53 43 00 00       	call   80104be0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 3f 11 80    	sub    0x80113fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 3f 11 80    	mov    %edx,0x80113fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 3f 11 80    	mov    %cl,-0x7feec0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 3f 11 80       	mov    0x80113fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 3f 11 80    	cmp    %eax,0x80113fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 3f 11 80       	mov    %eax,0x80113fa4
          wakeup(&input.r);
80100911:	68 a0 3f 11 80       	push   $0x80113fa0
80100916:	e8 95 3d 00 00       	call   801046b0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
8010093d:	39 05 a4 3f 11 80    	cmp    %eax,0x80113fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 3f 11 80       	mov    %eax,0x80113fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
80100964:	3b 05 a4 3f 11 80    	cmp    0x80113fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 3f 11 80 0a 	cmpb   $0xa,-0x7feec0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 3d 00 00       	jmp    80104790 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 3f 11 80 0a 	movb   $0xa,-0x7feec0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 84 10 80       	push   $0x80108488
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 0b 40 00 00       	call   801049e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 49 11 80 00 	movl   $0x80100600,0x8011496c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 49 11 80 70 	movl   $0x80100270,0x80114968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 92 1d 00 00       	call   80102790 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 8f 33 00 00       	call   80103db0 <myproc>
80100a21:	89 c7                	mov    %eax,%edi

  begin_op();
80100a23:	e8 c8 26 00 00       	call   801030f0 <begin_op>

  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 dd 15 00 00       	call   80102010 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 96 02 00 00    	je     80100cd4 <exec+0x2c4>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 67 0d 00 00       	call   801017b0 <ilock>
  pgdir = 0;

  // Backup swap file and paging info
  // @TODO: backup paging info and swapFile
  // struct file *swapFileBackup = curproc->swapFile; // save pointer
  uint ramCounterBackup = curproc->ramCounter;
80100a49:	8b b7 40 01 00 00    	mov    0x140(%edi),%esi
80100a4f:	83 c4 10             	add    $0x10,%esp
  // uint swapCounterBackup = curproc->swapCounter;
  // uint swapPagesBackup[16];
  struct ramPage ramPagesBackup[16];
  for(int i = 0; i < 16; i++){
80100a52:	31 c0                	xor    %eax,%eax
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    // swapPagesBackup[i] = curproc->swapPages[i];
    ramPagesBackup[i].va = curproc->ramPages[i].va;
80100a58:	8b 94 c7 c0 00 00 00 	mov    0xc0(%edi,%eax,8),%edx
80100a5f:	89 94 c5 d8 fe ff ff 	mov    %edx,-0x128(%ebp,%eax,8)
    ramPagesBackup[i].counter = curproc->ramPages[i].counter;
80100a66:	8b 94 c7 c4 00 00 00 	mov    0xc4(%edi,%eax,8),%edx
80100a6d:	89 94 c5 dc fe ff ff 	mov    %edx,-0x124(%ebp,%eax,8)
  for(int i = 0; i < 16; i++){
80100a74:	83 c0 01             	add    $0x1,%eax
80100a77:	83 f8 10             	cmp    $0x10,%eax
80100a7a:	75 dc                	jne    80100a58 <exec+0x48>
  }

  // Clean paging info and structures
  removeSwapFile(curproc);
80100a7c:	83 ec 0c             	sub    $0xc,%esp
80100a7f:	57                   	push   %edi
80100a80:	e8 5b 16 00 00       	call   801020e0 <removeSwapFile>
  createSwapFile(curproc);
80100a85:	89 3c 24             	mov    %edi,(%esp)
80100a88:	e8 53 18 00 00       	call   801022e0 <createSwapFile>
  curproc->swapCounter = 0;
80100a8d:	c7 87 44 01 00 00 00 	movl   $0x0,0x144(%edi)
80100a94:	00 00 00 
  curproc->ramCounter = 0;
80100a97:	c7 87 40 01 00 00 00 	movl   $0x0,0x140(%edi)
80100a9e:	00 00 00 
80100aa1:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < 16; i++){
80100aa4:	31 c0                	xor    %eax,%eax
80100aa6:	8d 76 00             	lea    0x0(%esi),%esi
80100aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curproc->swapPages[i] = -1;
80100ab0:	c7 84 87 80 00 00 00 	movl   $0xffffffff,0x80(%edi,%eax,4)
80100ab7:	ff ff ff ff 
    curproc->ramPages[i].va = -1;
80100abb:	c7 84 c7 c0 00 00 00 	movl   $0xffffffff,0xc0(%edi,%eax,8)
80100ac2:	ff ff ff ff 
    curproc->ramPages[i].counter = 0;
80100ac6:	c7 84 c7 c4 00 00 00 	movl   $0x0,0xc4(%edi,%eax,8)
80100acd:	00 00 00 00 
  for(int i = 0; i < 16; i++){
80100ad1:	83 c0 01             	add    $0x1,%eax
80100ad4:	83 f8 10             	cmp    $0x10,%eax
80100ad7:	75 d7                	jne    80100ab0 <exec+0xa0>
  }

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ad9:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
80100adf:	6a 34                	push   $0x34
80100ae1:	6a 00                	push   $0x0
80100ae3:	50                   	push   %eax
80100ae4:	53                   	push   %ebx
80100ae5:	e8 a6 0f 00 00       	call   80101a90 <readi>
80100aea:	83 c4 10             	add    $0x10,%esp
80100aed:	83 f8 34             	cmp    $0x34,%eax
80100af0:	74 56                	je     80100b48 <exec+0x138>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100af2:	83 ec 0c             	sub    $0xc,%esp
80100af5:	53                   	push   %ebx
80100af6:	e8 45 0f 00 00       	call   80101a40 <iunlockput>
    end_op();
80100afb:	e8 60 26 00 00       	call   80103160 <end_op>
80100b00:	83 c4 10             	add    $0x10,%esp
  }

  //Restore from Backup
  // removeSwapFile(curproc);
  // curproc->swapFile = swapFileBackup;
  curproc->ramCounter = ramCounterBackup;
80100b03:	89 b7 40 01 00 00    	mov    %esi,0x140(%edi)
  // curproc->swapCounter = swapCounterBackup;
  for(int i = 0; i < 16; i++){
80100b09:	31 c0                	xor    %eax,%eax
80100b0b:	90                   	nop
80100b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    // curproc->swapPages[i] = swapPagesBackup[i];
    curproc->ramPages[i].va = ramPagesBackup[i].va;
80100b10:	8b 94 c5 d8 fe ff ff 	mov    -0x128(%ebp,%eax,8),%edx
80100b17:	89 94 c7 c0 00 00 00 	mov    %edx,0xc0(%edi,%eax,8)
    curproc->ramPages[i].counter = ramPagesBackup[i].counter;
80100b1e:	8b 94 c5 dc fe ff ff 	mov    -0x124(%ebp,%eax,8),%edx
80100b25:	89 94 c7 c4 00 00 00 	mov    %edx,0xc4(%edi,%eax,8)
  for(int i = 0; i < 16; i++){
80100b2c:	83 c0 01             	add    $0x1,%eax
80100b2f:	83 f8 10             	cmp    $0x10,%eax
80100b32:	75 dc                	jne    80100b10 <exec+0x100>
  }

  return -1;
80100b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b3c:	5b                   	pop    %ebx
80100b3d:	5e                   	pop    %esi
80100b3e:	5f                   	pop    %edi
80100b3f:	5d                   	pop    %ebp
80100b40:	c3                   	ret    
80100b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b48:	81 bd a4 fe ff ff 7f 	cmpl   $0x464c457f,-0x15c(%ebp)
80100b4f:	45 4c 46 
80100b52:	75 9e                	jne    80100af2 <exec+0xe2>
  if((pgdir = setupkvm()) == 0)
80100b54:	e8 37 70 00 00       	call   80107b90 <setupkvm>
80100b59:	85 c0                	test   %eax,%eax
80100b5b:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
80100b61:	74 8f                	je     80100af2 <exec+0xe2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b63:	66 83 bd d0 fe ff ff 	cmpw   $0x0,-0x130(%ebp)
80100b6a:	00 
80100b6b:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
80100b71:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
80100b77:	0f 84 21 02 00 00    	je     80100d9e <exec+0x38e>
  sz = 0;
80100b7d:	31 c9                	xor    %ecx,%ecx
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7f:	31 c0                	xor    %eax,%eax
80100b81:	89 bd 6c fe ff ff    	mov    %edi,-0x194(%ebp)
80100b87:	89 b5 68 fe ff ff    	mov    %esi,-0x198(%ebp)
80100b8d:	89 cf                	mov    %ecx,%edi
80100b8f:	89 c6                	mov    %eax,%esi
80100b91:	eb 7f                	jmp    80100c12 <exec+0x202>
80100b93:	90                   	nop
80100b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b98:	83 bd 84 fe ff ff 01 	cmpl   $0x1,-0x17c(%ebp)
80100b9f:	75 63                	jne    80100c04 <exec+0x1f4>
    if(ph.memsz < ph.filesz)
80100ba1:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
80100ba7:	3b 85 94 fe ff ff    	cmp    -0x16c(%ebp),%eax
80100bad:	0f 82 86 00 00 00    	jb     80100c39 <exec+0x229>
80100bb3:	03 85 8c fe ff ff    	add    -0x174(%ebp),%eax
80100bb9:	72 7e                	jb     80100c39 <exec+0x229>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bbb:	83 ec 04             	sub    $0x4,%esp
80100bbe:	50                   	push   %eax
80100bbf:	57                   	push   %edi
80100bc0:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100bc6:	e8 65 6d 00 00       	call   80107930 <allocuvm>
80100bcb:	83 c4 10             	add    $0x10,%esp
80100bce:	85 c0                	test   %eax,%eax
80100bd0:	89 c7                	mov    %eax,%edi
80100bd2:	74 65                	je     80100c39 <exec+0x229>
    if(ph.vaddr % PGSIZE != 0)
80100bd4:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
80100bda:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bdf:	75 58                	jne    80100c39 <exec+0x229>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100be1:	83 ec 0c             	sub    $0xc,%esp
80100be4:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
80100bea:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
80100bf0:	53                   	push   %ebx
80100bf1:	50                   	push   %eax
80100bf2:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100bf8:	e8 83 69 00 00       	call   80107580 <loaduvm>
80100bfd:	83 c4 20             	add    $0x20,%esp
80100c00:	85 c0                	test   %eax,%eax
80100c02:	78 35                	js     80100c39 <exec+0x229>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c04:	0f b7 85 d0 fe ff ff 	movzwl -0x130(%ebp),%eax
80100c0b:	83 c6 01             	add    $0x1,%esi
80100c0e:	39 f0                	cmp    %esi,%eax
80100c10:	7e 49                	jle    80100c5b <exec+0x24b>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c12:	89 f0                	mov    %esi,%eax
80100c14:	6a 20                	push   $0x20
80100c16:	c1 e0 05             	shl    $0x5,%eax
80100c19:	03 85 70 fe ff ff    	add    -0x190(%ebp),%eax
80100c1f:	50                   	push   %eax
80100c20:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
80100c26:	50                   	push   %eax
80100c27:	53                   	push   %ebx
80100c28:	e8 63 0e 00 00       	call   80101a90 <readi>
80100c2d:	83 c4 10             	add    $0x10,%esp
80100c30:	83 f8 20             	cmp    $0x20,%eax
80100c33:	0f 84 5f ff ff ff    	je     80100b98 <exec+0x188>
    freevm(pgdir);
80100c39:	83 ec 0c             	sub    $0xc,%esp
80100c3c:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100c42:	8b bd 6c fe ff ff    	mov    -0x194(%ebp),%edi
80100c48:	8b b5 68 fe ff ff    	mov    -0x198(%ebp),%esi
80100c4e:	e8 bd 6e 00 00       	call   80107b10 <freevm>
80100c53:	83 c4 10             	add    $0x10,%esp
80100c56:	e9 97 fe ff ff       	jmp    80100af2 <exec+0xe2>
80100c5b:	89 f8                	mov    %edi,%eax
80100c5d:	8b b5 68 fe ff ff    	mov    -0x198(%ebp),%esi
80100c63:	8b bd 6c fe ff ff    	mov    -0x194(%ebp),%edi
80100c69:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c73:	89 c2                	mov    %eax,%edx
80100c75:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
  iunlockput(ip);
80100c7b:	83 ec 0c             	sub    $0xc,%esp
80100c7e:	89 95 6c fe ff ff    	mov    %edx,-0x194(%ebp)
80100c84:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
80100c8a:	53                   	push   %ebx
80100c8b:	e8 b0 0d 00 00       	call   80101a40 <iunlockput>
  end_op();
80100c90:	e8 cb 24 00 00       	call   80103160 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c95:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
80100c9b:	8b 95 6c fe ff ff    	mov    -0x194(%ebp),%edx
80100ca1:	83 c4 0c             	add    $0xc,%esp
80100ca4:	50                   	push   %eax
80100ca5:	52                   	push   %edx
80100ca6:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100cac:	e8 7f 6c 00 00       	call   80107930 <allocuvm>
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	85 c0                	test   %eax,%eax
80100cb6:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
80100cbc:	75 35                	jne    80100cf3 <exec+0x2e3>
    freevm(pgdir);
80100cbe:	83 ec 0c             	sub    $0xc,%esp
80100cc1:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100cc7:	e8 44 6e 00 00       	call   80107b10 <freevm>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	e9 2f fe ff ff       	jmp    80100b03 <exec+0xf3>
    end_op();
80100cd4:	e8 87 24 00 00       	call   80103160 <end_op>
    cprintf("exec: fail\n");
80100cd9:	83 ec 0c             	sub    $0xc,%esp
80100cdc:	68 a1 84 10 80       	push   $0x801084a1
80100ce1:	e8 7a f9 ff ff       	call   80100660 <cprintf>
    return -1;
80100ce6:	83 c4 10             	add    $0x10,%esp
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 46 fe ff ff       	jmp    80100b39 <exec+0x129>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf3:	89 c3                	mov    %eax,%ebx
80100cf5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100cfb:	83 ec 08             	sub    $0x8,%esp
80100cfe:	50                   	push   %eax
80100cff:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100d05:	e8 26 6f 00 00       	call   80107c30 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d0d:	83 c4 10             	add    $0x10,%esp
80100d10:	31 c9                	xor    %ecx,%ecx
80100d12:	8b 00                	mov    (%eax),%eax
80100d14:	85 c0                	test   %eax,%eax
80100d16:	0f 84 54 01 00 00    	je     80100e70 <exec+0x460>
80100d1c:	89 b5 6c fe ff ff    	mov    %esi,-0x194(%ebp)
80100d22:	89 de                	mov    %ebx,%esi
80100d24:	89 cb                	mov    %ecx,%ebx
80100d26:	eb 1f                	jmp    80100d47 <exec+0x337>
80100d28:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d2b:	89 b4 9d 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100d32:	83 c3 01             	add    $0x1,%ebx
    ustack[3+argc] = sp;
80100d35:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d3b:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100d3e:	85 c0                	test   %eax,%eax
80100d40:	74 68                	je     80100daa <exec+0x39a>
    if(argc >= MAXARG)
80100d42:	83 fb 20             	cmp    $0x20,%ebx
80100d45:	74 3b                	je     80100d82 <exec+0x372>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d47:	83 ec 0c             	sub    $0xc,%esp
80100d4a:	50                   	push   %eax
80100d4b:	e8 00 41 00 00       	call   80104e50 <strlen>
80100d50:	f7 d0                	not    %eax
80100d52:	01 f0                	add    %esi,%eax
80100d54:	83 e0 fc             	and    $0xfffffffc,%eax
80100d57:	89 c6                	mov    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d59:	58                   	pop    %eax
80100d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5d:	ff 34 98             	pushl  (%eax,%ebx,4)
80100d60:	e8 eb 40 00 00       	call   80104e50 <strlen>
80100d65:	83 c0 01             	add    $0x1,%eax
80100d68:	50                   	push   %eax
80100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6c:	ff 34 98             	pushl  (%eax,%ebx,4)
80100d6f:	56                   	push   %esi
80100d70:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100d76:	e8 65 71 00 00       	call   80107ee0 <copyout>
80100d7b:	83 c4 20             	add    $0x20,%esp
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	79 a6                	jns    80100d28 <exec+0x318>
    freevm(pgdir);
80100d82:	83 ec 0c             	sub    $0xc,%esp
80100d85:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
80100d8b:	8b b5 6c fe ff ff    	mov    -0x194(%ebp),%esi
80100d91:	e8 7a 6d 00 00       	call   80107b10 <freevm>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	e9 65 fd ff ff       	jmp    80100b03 <exec+0xf3>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d9e:	31 d2                	xor    %edx,%edx
80100da0:	b8 00 20 00 00       	mov    $0x2000,%eax
80100da5:	e9 d1 fe ff ff       	jmp    80100c7b <exec+0x26b>
80100daa:	89 d9                	mov    %ebx,%ecx
80100dac:	89 f3                	mov    %esi,%ebx
80100dae:	8b b5 6c fe ff ff    	mov    -0x194(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db4:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  ustack[3+argc] = 0;
80100dbb:	c7 84 8d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ecx,4)
80100dc2:	00 00 00 00 
  ustack[1] = argc;
80100dc6:	89 8d 5c ff ff ff    	mov    %ecx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dcc:	89 d9                	mov    %ebx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100dce:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dd5:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd8:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100dda:	83 c0 0c             	add    $0xc,%eax
80100ddd:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ddf:	50                   	push   %eax
80100de0:	52                   	push   %edx
80100de1:	53                   	push   %ebx
80100de2:	ff b5 74 fe ff ff    	pushl  -0x18c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100de8:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dee:	e8 ed 70 00 00       	call   80107ee0 <copyout>
80100df3:	83 c4 10             	add    $0x10,%esp
80100df6:	85 c0                	test   %eax,%eax
80100df8:	0f 88 c0 fe ff ff    	js     80100cbe <exec+0x2ae>
  for(last=s=path; *s; s++)
80100dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80100e01:	0f b6 00             	movzbl (%eax),%eax
80100e04:	84 c0                	test   %al,%al
80100e06:	74 17                	je     80100e1f <exec+0x40f>
80100e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100e0b:	89 ca                	mov    %ecx,%edx
80100e0d:	83 c2 01             	add    $0x1,%edx
80100e10:	3c 2f                	cmp    $0x2f,%al
80100e12:	0f b6 02             	movzbl (%edx),%eax
80100e15:	0f 44 ca             	cmove  %edx,%ecx
80100e18:	84 c0                	test   %al,%al
80100e1a:	75 f1                	jne    80100e0d <exec+0x3fd>
80100e1c:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e1f:	8d 47 6c             	lea    0x6c(%edi),%eax
80100e22:	83 ec 04             	sub    $0x4,%esp
80100e25:	6a 10                	push   $0x10
80100e27:	ff 75 08             	pushl  0x8(%ebp)
80100e2a:	50                   	push   %eax
80100e2b:	e8 e0 3f 00 00       	call   80104e10 <safestrcpy>
  curproc->pgdir = pgdir;
80100e30:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e36:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100e39:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100e3c:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
80100e42:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100e44:	8b 47 18             	mov    0x18(%edi),%eax
80100e47:	8b 8d bc fe ff ff    	mov    -0x144(%ebp),%ecx
80100e4d:	89 48 38             	mov    %ecx,0x38(%eax)
  curproc->tf->esp = sp;
80100e50:	8b 47 18             	mov    0x18(%edi),%eax
80100e53:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e56:	89 3c 24             	mov    %edi,(%esp)
80100e59:	e8 92 65 00 00       	call   801073f0 <switchuvm>
  freevm(oldpgdir);
80100e5e:	89 34 24             	mov    %esi,(%esp)
80100e61:	e8 aa 6c 00 00       	call   80107b10 <freevm>
  return 0;
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	31 c0                	xor    %eax,%eax
80100e6b:	e9 c9 fc ff ff       	jmp    80100b39 <exec+0x129>
  for(argc = 0; argv[argc]; argc++) {
80100e70:	8b 9d 70 fe ff ff    	mov    -0x190(%ebp),%ebx
80100e76:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100e7c:	e9 33 ff ff ff       	jmp    80100db4 <exec+0x3a4>
80100e81:	66 90                	xchg   %ax,%ax
80100e83:	66 90                	xchg   %ax,%ax
80100e85:	66 90                	xchg   %ax,%ax
80100e87:	66 90                	xchg   %ax,%ax
80100e89:	66 90                	xchg   %ax,%ax
80100e8b:	66 90                	xchg   %ax,%ax
80100e8d:	66 90                	xchg   %ax,%ax
80100e8f:	90                   	nop

80100e90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e96:	68 ad 84 10 80       	push   $0x801084ad
80100e9b:	68 c0 3f 11 80       	push   $0x80113fc0
80100ea0:	e8 3b 3b 00 00       	call   801049e0 <initlock>
}
80100ea5:	83 c4 10             	add    $0x10,%esp
80100ea8:	c9                   	leave  
80100ea9:	c3                   	ret    
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100eb0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb4:	bb f4 3f 11 80       	mov    $0x80113ff4,%ebx
{
80100eb9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ebc:	68 c0 3f 11 80       	push   $0x80113fc0
80100ec1:	e8 5a 3c 00 00       	call   80104b20 <acquire>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb 10                	jmp    80100edb <filealloc+0x2b>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ed0:	83 c3 18             	add    $0x18,%ebx
80100ed3:	81 fb 54 49 11 80    	cmp    $0x80114954,%ebx
80100ed9:	73 25                	jae    80100f00 <filealloc+0x50>
    if(f->ref == 0){
80100edb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ede:	85 c0                	test   %eax,%eax
80100ee0:	75 ee                	jne    80100ed0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ee2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ee5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100eec:	68 c0 3f 11 80       	push   $0x80113fc0
80100ef1:	e8 ea 3c 00 00       	call   80104be0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ef6:	89 d8                	mov    %ebx,%eax
      return f;
80100ef8:	83 c4 10             	add    $0x10,%esp
}
80100efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100efe:	c9                   	leave  
80100eff:	c3                   	ret    
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f05:	68 c0 3f 11 80       	push   $0x80113fc0
80100f0a:	e8 d1 3c 00 00       	call   80104be0 <release>
}
80100f0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f11:	83 c4 10             	add    $0x10,%esp
}
80100f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 10             	sub    $0x10,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f2a:	68 c0 3f 11 80       	push   $0x80113fc0
80100f2f:	e8 ec 3b 00 00       	call   80104b20 <acquire>
  if(f->ref < 1)
80100f34:	8b 43 04             	mov    0x4(%ebx),%eax
80100f37:	83 c4 10             	add    $0x10,%esp
80100f3a:	85 c0                	test   %eax,%eax
80100f3c:	7e 1a                	jle    80100f58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f47:	68 c0 3f 11 80       	push   $0x80113fc0
80100f4c:	e8 8f 3c 00 00       	call   80104be0 <release>
  return f;
}
80100f51:	89 d8                	mov    %ebx,%eax
80100f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f56:	c9                   	leave  
80100f57:	c3                   	ret    
    panic("filedup");
80100f58:	83 ec 0c             	sub    $0xc,%esp
80100f5b:	68 b4 84 10 80       	push   $0x801084b4
80100f60:	e8 2b f4 ff ff       	call   80100390 <panic>
80100f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 28             	sub    $0x28,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f7c:	68 c0 3f 11 80       	push   $0x80113fc0
80100f81:	e8 9a 3b 00 00       	call   80104b20 <acquire>
  if(f->ref < 1)
80100f86:	8b 43 04             	mov    0x4(%ebx),%eax
80100f89:	83 c4 10             	add    $0x10,%esp
80100f8c:	85 c0                	test   %eax,%eax
80100f8e:	0f 8e 9b 00 00 00    	jle    8010102f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f94:	83 e8 01             	sub    $0x1,%eax
80100f97:	85 c0                	test   %eax,%eax
80100f99:	89 43 04             	mov    %eax,0x4(%ebx)
80100f9c:	74 1a                	je     80100fb8 <fileclose+0x48>
    release(&ftable.lock);
80100f9e:	c7 45 08 c0 3f 11 80 	movl   $0x80113fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa8:	5b                   	pop    %ebx
80100fa9:	5e                   	pop    %esi
80100faa:	5f                   	pop    %edi
80100fab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fac:	e9 2f 3c 00 00       	jmp    80104be0 <release>
80100fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100fb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100fbc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fc1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100fc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fcd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fd0:	68 c0 3f 11 80       	push   $0x80113fc0
  ff = *f;
80100fd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fd8:	e8 03 3c 00 00       	call   80104be0 <release>
  if(ff.type == FD_PIPE)
80100fdd:	83 c4 10             	add    $0x10,%esp
80100fe0:	83 ff 01             	cmp    $0x1,%edi
80100fe3:	74 13                	je     80100ff8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100fe5:	83 ff 02             	cmp    $0x2,%edi
80100fe8:	74 26                	je     80101010 <fileclose+0xa0>
}
80100fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fed:	5b                   	pop    %ebx
80100fee:	5e                   	pop    %esi
80100fef:	5f                   	pop    %edi
80100ff0:	5d                   	pop    %ebp
80100ff1:	c3                   	ret    
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ff8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ffc:	83 ec 08             	sub    $0x8,%esp
80100fff:	53                   	push   %ebx
80101000:	56                   	push   %esi
80101001:	e8 9a 28 00 00       	call   801038a0 <pipeclose>
80101006:	83 c4 10             	add    $0x10,%esp
80101009:	eb df                	jmp    80100fea <fileclose+0x7a>
8010100b:	90                   	nop
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101010:	e8 db 20 00 00       	call   801030f0 <begin_op>
    iput(ff.ip);
80101015:	83 ec 0c             	sub    $0xc,%esp
80101018:	ff 75 e0             	pushl  -0x20(%ebp)
8010101b:	e8 c0 08 00 00       	call   801018e0 <iput>
    end_op();
80101020:	83 c4 10             	add    $0x10,%esp
}
80101023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101026:	5b                   	pop    %ebx
80101027:	5e                   	pop    %esi
80101028:	5f                   	pop    %edi
80101029:	5d                   	pop    %ebp
    end_op();
8010102a:	e9 31 21 00 00       	jmp    80103160 <end_op>
    panic("fileclose");
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	68 bc 84 10 80       	push   $0x801084bc
80101037:	e8 54 f3 ff ff       	call   80100390 <panic>
8010103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	pushl  0x10(%ebx)
80101055:	e8 56 07 00 00       	call   801017b0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	pushl  0xc(%ebp)
8010105f:	ff 73 10             	pushl  0x10(%ebx)
80101062:	e8 f9 09 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	pushl  0x10(%ebx)
8010106b:	e8 20 08 00 00       	call   80101890 <iunlock>
    return 0;
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101085:	eb ee                	jmp    80101075 <filestat+0x35>
80101087:	89 f6                	mov    %esi,%esi
80101089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	pushl  0x10(%ebx)
801010ba:	e8 f1 06 00 00       	call   801017b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	pushl  0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	pushl  0x10(%ebx)
801010c7:	e8 c4 09 00 00       	call   80101a90 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	85 c0                	test   %eax,%eax
801010d1:	89 c6                	mov    %eax,%esi
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	pushl  0x10(%ebx)
801010de:	e8 ad 07 00 00       	call   80101890 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 4e 29 00 00       	jmp    80103a50 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 c6 84 10 80       	push   $0x801084c6
80101117:	e8 74 f2 ff ff       	call   80100390 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 75 08             	mov    0x8(%ebp),%esi
8010112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010112f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101133:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101136:	8b 45 10             	mov    0x10(%ebp),%eax
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 aa 00 00 00    	je     801011ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 06                	mov    (%esi),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 c3 00 00 00    	je     80101210 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 d9 00 00 00    	jne    8010122f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 ff                	xor    %edi,%edi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 34                	jg     80101193 <filewrite+0x73>
8010115f:	e9 9c 00 00 00       	jmp    80101200 <filewrite+0xe0>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
8010116e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101171:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101174:	e8 17 07 00 00       	call   80101890 <iunlock>
      end_op();
80101179:	e8 e2 1f 00 00       	call   80103160 <end_op>
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101184:	39 c3                	cmp    %eax,%ebx
80101186:	0f 85 96 00 00 00    	jne    80101222 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010118c:	01 df                	add    %ebx,%edi
    while(i < n){
8010118e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101191:	7e 6d                	jle    80101200 <filewrite+0xe0>
      int n1 = n - i;
80101193:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101196:	b8 00 06 00 00       	mov    $0x600,%eax
8010119b:	29 fb                	sub    %edi,%ebx
8010119d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011a6:	e8 45 1f 00 00       	call   801030f0 <begin_op>
      ilock(f->ip);
801011ab:	83 ec 0c             	sub    $0xc,%esp
801011ae:	ff 76 10             	pushl  0x10(%esi)
801011b1:	e8 fa 05 00 00       	call   801017b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	53                   	push   %ebx
801011ba:	ff 76 14             	pushl  0x14(%esi)
801011bd:	01 f8                	add    %edi,%eax
801011bf:	50                   	push   %eax
801011c0:	ff 76 10             	pushl  0x10(%esi)
801011c3:	e8 c8 09 00 00       	call   80101b90 <writei>
801011c8:	83 c4 20             	add    $0x20,%esp
801011cb:	85 c0                	test   %eax,%eax
801011cd:	7f 99                	jg     80101168 <filewrite+0x48>
      iunlock(f->ip);
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	ff 76 10             	pushl  0x10(%esi)
801011d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d8:	e8 b3 06 00 00       	call   80101890 <iunlock>
      end_op();
801011dd:	e8 7e 1f 00 00       	call   80103160 <end_op>
      if(r < 0)
801011e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	85 c0                	test   %eax,%eax
801011ea:	74 98                	je     80101184 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801011ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801011f4:	89 f8                	mov    %edi,%eax
801011f6:	5b                   	pop    %ebx
801011f7:	5e                   	pop    %esi
801011f8:	5f                   	pop    %edi
801011f9:	5d                   	pop    %ebp
801011fa:	c3                   	ret    
801011fb:	90                   	nop
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101200:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101203:	75 e7                	jne    801011ec <filewrite+0xcc>
}
80101205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101208:	89 f8                	mov    %edi,%eax
8010120a:	5b                   	pop    %ebx
8010120b:	5e                   	pop    %esi
8010120c:	5f                   	pop    %edi
8010120d:	5d                   	pop    %ebp
8010120e:	c3                   	ret    
8010120f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101210:	8b 46 0c             	mov    0xc(%esi),%eax
80101213:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101219:	5b                   	pop    %ebx
8010121a:	5e                   	pop    %esi
8010121b:	5f                   	pop    %edi
8010121c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010121d:	e9 1e 27 00 00       	jmp    80103940 <pipewrite>
        panic("short filewrite");
80101222:	83 ec 0c             	sub    $0xc,%esp
80101225:	68 cf 84 10 80       	push   $0x801084cf
8010122a:	e8 61 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	68 d5 84 10 80       	push   $0x801084d5
80101237:	e8 54 f1 ff ff       	call   80100390 <panic>
8010123c:	66 90                	xchg   %ax,%ax
8010123e:	66 90                	xchg   %ax,%ax

80101240 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	56                   	push   %esi
80101244:	53                   	push   %ebx
80101245:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101247:	c1 ea 0c             	shr    $0xc,%edx
8010124a:	03 15 d8 49 11 80    	add    0x801149d8,%edx
80101250:	83 ec 08             	sub    $0x8,%esp
80101253:	52                   	push   %edx
80101254:	50                   	push   %eax
80101255:	e8 76 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010125a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010125c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010125f:	ba 01 00 00 00       	mov    $0x1,%edx
80101264:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101267:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010126d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101270:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101272:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101277:	85 d1                	test   %edx,%ecx
80101279:	74 25                	je     801012a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010127b:	f7 d2                	not    %edx
8010127d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010127f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101282:	21 ca                	and    %ecx,%edx
80101284:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101288:	56                   	push   %esi
80101289:	e8 32 20 00 00       	call   801032c0 <log_write>
  brelse(bp);
8010128e:	89 34 24             	mov    %esi,(%esp)
80101291:	e8 4a ef ff ff       	call   801001e0 <brelse>
}
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010129c:	5b                   	pop    %ebx
8010129d:	5e                   	pop    %esi
8010129e:	5d                   	pop    %ebp
8010129f:	c3                   	ret    
    panic("freeing free block");
801012a0:	83 ec 0c             	sub    $0xc,%esp
801012a3:	68 df 84 10 80       	push   $0x801084df
801012a8:	e8 e3 f0 ff ff       	call   80100390 <panic>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi

801012b0 <balloc>:
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012b9:	8b 0d c0 49 11 80    	mov    0x801149c0,%ecx
{
801012bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012c2:	85 c9                	test   %ecx,%ecx
801012c4:	0f 84 87 00 00 00    	je     80101351 <balloc+0xa1>
801012ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	89 f0                	mov    %esi,%eax
801012d9:	c1 f8 0c             	sar    $0xc,%eax
801012dc:	03 05 d8 49 11 80    	add    0x801149d8,%eax
801012e2:	50                   	push   %eax
801012e3:	ff 75 d8             	pushl  -0x28(%ebp)
801012e6:	e8 e5 ed ff ff       	call   801000d0 <bread>
801012eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ee:	a1 c0 49 11 80       	mov    0x801149c0,%eax
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f9:	31 c0                	xor    %eax,%eax
801012fb:	eb 2f                	jmp    8010132c <balloc+0x7c>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101300:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101305:	bb 01 00 00 00       	mov    $0x1,%ebx
8010130a:	83 e1 07             	and    $0x7,%ecx
8010130d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010130f:	89 c1                	mov    %eax,%ecx
80101311:	c1 f9 03             	sar    $0x3,%ecx
80101314:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101319:	85 df                	test   %ebx,%edi
8010131b:	89 fa                	mov    %edi,%edx
8010131d:	74 41                	je     80101360 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010131f:	83 c0 01             	add    $0x1,%eax
80101322:	83 c6 01             	add    $0x1,%esi
80101325:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010132a:	74 05                	je     80101331 <balloc+0x81>
8010132c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010132f:	77 cf                	ja     80101300 <balloc+0x50>
    brelse(bp);
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	ff 75 e4             	pushl  -0x1c(%ebp)
80101337:	e8 a4 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010133c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101343:	83 c4 10             	add    $0x10,%esp
80101346:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101349:	39 05 c0 49 11 80    	cmp    %eax,0x801149c0
8010134f:	77 80                	ja     801012d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	68 f2 84 10 80       	push   $0x801084f2
80101359:	e8 32 f0 ff ff       	call   80100390 <panic>
8010135e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101363:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101366:	09 da                	or     %ebx,%edx
80101368:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010136c:	57                   	push   %edi
8010136d:	e8 4e 1f 00 00       	call   801032c0 <log_write>
        brelse(bp);
80101372:	89 3c 24             	mov    %edi,(%esp)
80101375:	e8 66 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010137a:	58                   	pop    %eax
8010137b:	5a                   	pop    %edx
8010137c:	56                   	push   %esi
8010137d:	ff 75 d8             	pushl  -0x28(%ebp)
80101380:	e8 4b ed ff ff       	call   801000d0 <bread>
80101385:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101387:	8d 40 5c             	lea    0x5c(%eax),%eax
8010138a:	83 c4 0c             	add    $0xc,%esp
8010138d:	68 00 02 00 00       	push   $0x200
80101392:	6a 00                	push   $0x0
80101394:	50                   	push   %eax
80101395:	e8 96 38 00 00       	call   80104c30 <memset>
  log_write(bp);
8010139a:	89 1c 24             	mov    %ebx,(%esp)
8010139d:	e8 1e 1f 00 00       	call   801032c0 <log_write>
  brelse(bp);
801013a2:	89 1c 24             	mov    %ebx,(%esp)
801013a5:	e8 36 ee ff ff       	call   801001e0 <brelse>
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 f0                	mov    %esi,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	bb 14 4a 11 80       	mov    $0x80114a14,%ebx
{
801013cf:	83 ec 28             	sub    $0x28,%esp
801013d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013d5:	68 e0 49 11 80       	push   $0x801149e0
801013da:	e8 41 37 00 00       	call   80104b20 <acquire>
801013df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013e5:	eb 17                	jmp    801013fe <iget+0x3e>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801013f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f6:	81 fb 34 66 11 80    	cmp    $0x80116634,%ebx
801013fc:	73 22                	jae    80101420 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101401:	85 c9                	test   %ecx,%ecx
80101403:	7e 04                	jle    80101409 <iget+0x49>
80101405:	39 3b                	cmp    %edi,(%ebx)
80101407:	74 4f                	je     80101458 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101409:	85 f6                	test   %esi,%esi
8010140b:	75 e3                	jne    801013f0 <iget+0x30>
8010140d:	85 c9                	test   %ecx,%ecx
8010140f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101412:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101418:	81 fb 34 66 11 80    	cmp    $0x80116634,%ebx
8010141e:	72 de                	jb     801013fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101420:	85 f6                	test   %esi,%esi
80101422:	74 5b                	je     8010147f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101424:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101427:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101429:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010142c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101433:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010143a:	68 e0 49 11 80       	push   $0x801149e0
8010143f:	e8 9c 37 00 00       	call   80104be0 <release>

  return ip;
80101444:	83 c4 10             	add    $0x10,%esp
}
80101447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144a:	89 f0                	mov    %esi,%eax
8010144c:	5b                   	pop    %ebx
8010144d:	5e                   	pop    %esi
8010144e:	5f                   	pop    %edi
8010144f:	5d                   	pop    %ebp
80101450:	c3                   	ret    
80101451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101458:	39 53 04             	cmp    %edx,0x4(%ebx)
8010145b:	75 ac                	jne    80101409 <iget+0x49>
      release(&icache.lock);
8010145d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101460:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101463:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101465:	68 e0 49 11 80       	push   $0x801149e0
      ip->ref++;
8010146a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010146d:	e8 6e 37 00 00       	call   80104be0 <release>
      return ip;
80101472:	83 c4 10             	add    $0x10,%esp
}
80101475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101478:	89 f0                	mov    %esi,%eax
8010147a:	5b                   	pop    %ebx
8010147b:	5e                   	pop    %esi
8010147c:	5f                   	pop    %edi
8010147d:	5d                   	pop    %ebp
8010147e:	c3                   	ret    
    panic("iget: no inodes");
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	68 08 85 10 80       	push   $0x80108508
80101487:	e8 04 ef ff ff       	call   80100390 <panic>
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	57                   	push   %edi
80101494:	56                   	push   %esi
80101495:	53                   	push   %ebx
80101496:	89 c6                	mov    %eax,%esi
80101498:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010149b:	83 fa 0b             	cmp    $0xb,%edx
8010149e:	77 18                	ja     801014b8 <bmap+0x28>
801014a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801014a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014a6:	85 db                	test   %ebx,%ebx
801014a8:	74 76                	je     80101520 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ad:	89 d8                	mov    %ebx,%eax
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5f                   	pop    %edi
801014b2:	5d                   	pop    %ebp
801014b3:	c3                   	ret    
801014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801014b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801014bb:	83 fb 7f             	cmp    $0x7f,%ebx
801014be:	0f 87 90 00 00 00    	ja     80101554 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801014ca:	8b 00                	mov    (%eax),%eax
801014cc:	85 d2                	test   %edx,%edx
801014ce:	74 70                	je     80101540 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	52                   	push   %edx
801014d4:	50                   	push   %eax
801014d5:	e8 f6 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801014da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801014de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801014e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014e3:	8b 1a                	mov    (%edx),%ebx
801014e5:	85 db                	test   %ebx,%ebx
801014e7:	75 1d                	jne    80101506 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801014e9:	8b 06                	mov    (%esi),%eax
801014eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014ee:	e8 bd fd ff ff       	call   801012b0 <balloc>
801014f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014f9:	89 c3                	mov    %eax,%ebx
801014fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014fd:	57                   	push   %edi
801014fe:	e8 bd 1d 00 00       	call   801032c0 <log_write>
80101503:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101506:	83 ec 0c             	sub    $0xc,%esp
80101509:	57                   	push   %edi
8010150a:	e8 d1 ec ff ff       	call   801001e0 <brelse>
8010150f:	83 c4 10             	add    $0x10,%esp
}
80101512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101515:	89 d8                	mov    %ebx,%eax
80101517:	5b                   	pop    %ebx
80101518:	5e                   	pop    %esi
80101519:	5f                   	pop    %edi
8010151a:	5d                   	pop    %ebp
8010151b:	c3                   	ret    
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101520:	8b 00                	mov    (%eax),%eax
80101522:	e8 89 fd ff ff       	call   801012b0 <balloc>
80101527:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010152d:	89 c3                	mov    %eax,%ebx
}
8010152f:	89 d8                	mov    %ebx,%eax
80101531:	5b                   	pop    %ebx
80101532:	5e                   	pop    %esi
80101533:	5f                   	pop    %edi
80101534:	5d                   	pop    %ebp
80101535:	c3                   	ret    
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101540:	e8 6b fd ff ff       	call   801012b0 <balloc>
80101545:	89 c2                	mov    %eax,%edx
80101547:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010154d:	8b 06                	mov    (%esi),%eax
8010154f:	e9 7c ff ff ff       	jmp    801014d0 <bmap+0x40>
  panic("bmap: out of range");
80101554:	83 ec 0c             	sub    $0xc,%esp
80101557:	68 18 85 10 80       	push   $0x80108518
8010155c:	e8 2f ee ff ff       	call   80100390 <panic>
80101561:	eb 0d                	jmp    80101570 <readsb>
80101563:	90                   	nop
80101564:	90                   	nop
80101565:	90                   	nop
80101566:	90                   	nop
80101567:	90                   	nop
80101568:	90                   	nop
80101569:	90                   	nop
8010156a:	90                   	nop
8010156b:	90                   	nop
8010156c:	90                   	nop
8010156d:	90                   	nop
8010156e:	90                   	nop
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	pushl  0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
80101585:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101587:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158a:	83 c4 0c             	add    $0xc,%esp
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 4a 37 00 00       	call   80104ce0 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 39 ec ff ff       	jmp    801001e0 <brelse>
801015a7:	89 f6                	mov    %esi,%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb 20 4a 11 80       	mov    $0x80114a20,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 2b 85 10 80       	push   $0x8010852b
801015c1:	68 e0 49 11 80       	push   $0x801149e0
801015c6:	e8 15 34 00 00       	call   801049e0 <initlock>
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 32 85 10 80       	push   $0x80108532
801015d8:	53                   	push   %ebx
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015df:	e8 cc 32 00 00       	call   801048b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb 40 66 11 80    	cmp    $0x80116640,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  readsb(dev, &sb);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	68 c0 49 11 80       	push   $0x801149c0
801015f7:	ff 75 08             	pushl  0x8(%ebp)
801015fa:	e8 71 ff ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015ff:	ff 35 d8 49 11 80    	pushl  0x801149d8
80101605:	ff 35 d4 49 11 80    	pushl  0x801149d4
8010160b:	ff 35 d0 49 11 80    	pushl  0x801149d0
80101611:	ff 35 cc 49 11 80    	pushl  0x801149cc
80101617:	ff 35 c8 49 11 80    	pushl  0x801149c8
8010161d:	ff 35 c4 49 11 80    	pushl  0x801149c4
80101623:	ff 35 c0 49 11 80    	pushl  0x801149c0
80101629:	68 dc 85 10 80       	push   $0x801085dc
8010162e:	e8 2d f0 ff ff       	call   80100660 <cprintf>
}
80101633:	83 c4 30             	add    $0x30,%esp
80101636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101639:	c9                   	leave  
8010163a:	c3                   	ret    
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101640 <ialloc>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	57                   	push   %edi
80101644:	56                   	push   %esi
80101645:	53                   	push   %ebx
80101646:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	83 3d c8 49 11 80 01 	cmpl   $0x1,0x801149c8
{
80101650:	8b 45 0c             	mov    0xc(%ebp),%eax
80101653:	8b 75 08             	mov    0x8(%ebp),%esi
80101656:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101659:	0f 86 91 00 00 00    	jbe    801016f0 <ialloc+0xb0>
8010165f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101664:	eb 21                	jmp    80101687 <ialloc+0x47>
80101666:	8d 76 00             	lea    0x0(%esi),%esi
80101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101673:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101676:	57                   	push   %edi
80101677:	e8 64 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 c4 10             	add    $0x10,%esp
8010167f:	39 1d c8 49 11 80    	cmp    %ebx,0x801149c8
80101685:	76 69                	jbe    801016f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101687:	89 d8                	mov    %ebx,%eax
80101689:	83 ec 08             	sub    $0x8,%esp
8010168c:	c1 e8 03             	shr    $0x3,%eax
8010168f:	03 05 d4 49 11 80    	add    0x801149d4,%eax
80101695:	50                   	push   %eax
80101696:	56                   	push   %esi
80101697:	e8 34 ea ff ff       	call   801000d0 <bread>
8010169c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010169e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801016a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801016a3:	83 e0 07             	and    $0x7,%eax
801016a6:	c1 e0 06             	shl    $0x6,%eax
801016a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016b1:	75 bd                	jne    80101670 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016b3:	83 ec 04             	sub    $0x4,%esp
801016b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016b9:	6a 40                	push   $0x40
801016bb:	6a 00                	push   $0x0
801016bd:	51                   	push   %ecx
801016be:	e8 6d 35 00 00       	call   80104c30 <memset>
      dip->type = type;
801016c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016cd:	89 3c 24             	mov    %edi,(%esp)
801016d0:	e8 eb 1b 00 00       	call   801032c0 <log_write>
      brelse(bp);
801016d5:	89 3c 24             	mov    %edi,(%esp)
801016d8:	e8 03 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801016dd:	83 c4 10             	add    $0x10,%esp
}
801016e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016e3:	89 da                	mov    %ebx,%edx
801016e5:	89 f0                	mov    %esi,%eax
}
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5f                   	pop    %edi
801016ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801016eb:	e9 d0 fc ff ff       	jmp    801013c0 <iget>
  panic("ialloc: no inodes");
801016f0:	83 ec 0c             	sub    $0xc,%esp
801016f3:	68 38 85 10 80       	push   $0x80108538
801016f8:	e8 93 ec ff ff       	call   80100390 <panic>
801016fd:	8d 76 00             	lea    0x0(%esi),%esi

80101700 <iupdate>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101708:	83 ec 08             	sub    $0x8,%esp
8010170b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101711:	c1 e8 03             	shr    $0x3,%eax
80101714:	03 05 d4 49 11 80    	add    0x801149d4,%eax
8010171a:	50                   	push   %eax
8010171b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010171e:	e8 ad e9 ff ff       	call   801000d0 <bread>
80101723:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101725:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101728:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010172f:	83 e0 07             	and    $0x7,%eax
80101732:	c1 e0 06             	shl    $0x6,%eax
80101735:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101739:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010173c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101740:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101743:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101747:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010174b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010174f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101753:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101757:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010175a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175d:	6a 34                	push   $0x34
8010175f:	53                   	push   %ebx
80101760:	50                   	push   %eax
80101761:	e8 7a 35 00 00       	call   80104ce0 <memmove>
  log_write(bp);
80101766:	89 34 24             	mov    %esi,(%esp)
80101769:	e8 52 1b 00 00       	call   801032c0 <log_write>
  brelse(bp);
8010176e:	89 75 08             	mov    %esi,0x8(%ebp)
80101771:	83 c4 10             	add    $0x10,%esp
}
80101774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101777:	5b                   	pop    %ebx
80101778:	5e                   	pop    %esi
80101779:	5d                   	pop    %ebp
  brelse(bp);
8010177a:	e9 61 ea ff ff       	jmp    801001e0 <brelse>
8010177f:	90                   	nop

80101780 <idup>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	53                   	push   %ebx
80101784:	83 ec 10             	sub    $0x10,%esp
80101787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010178a:	68 e0 49 11 80       	push   $0x801149e0
8010178f:	e8 8c 33 00 00       	call   80104b20 <acquire>
  ip->ref++;
80101794:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101798:	c7 04 24 e0 49 11 80 	movl   $0x801149e0,(%esp)
8010179f:	e8 3c 34 00 00       	call   80104be0 <release>
}
801017a4:	89 d8                	mov    %ebx,%eax
801017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a9:	c9                   	leave  
801017aa:	c3                   	ret    
801017ab:	90                   	nop
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017b0 <ilock>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017b8:	85 db                	test   %ebx,%ebx
801017ba:	0f 84 b7 00 00 00    	je     80101877 <ilock+0xc7>
801017c0:	8b 53 08             	mov    0x8(%ebx),%edx
801017c3:	85 d2                	test   %edx,%edx
801017c5:	0f 8e ac 00 00 00    	jle    80101877 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801017ce:	83 ec 0c             	sub    $0xc,%esp
801017d1:	50                   	push   %eax
801017d2:	e8 19 31 00 00       	call   801048f0 <acquiresleep>
  if(ip->valid == 0){
801017d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017da:	83 c4 10             	add    $0x10,%esp
801017dd:	85 c0                	test   %eax,%eax
801017df:	74 0f                	je     801017f0 <ilock+0x40>
}
801017e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017e4:	5b                   	pop    %ebx
801017e5:	5e                   	pop    %esi
801017e6:	5d                   	pop    %ebp
801017e7:	c3                   	ret    
801017e8:	90                   	nop
801017e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017f0:	8b 43 04             	mov    0x4(%ebx),%eax
801017f3:	83 ec 08             	sub    $0x8,%esp
801017f6:	c1 e8 03             	shr    $0x3,%eax
801017f9:	03 05 d4 49 11 80    	add    0x801149d4,%eax
801017ff:	50                   	push   %eax
80101800:	ff 33                	pushl  (%ebx)
80101802:	e8 c9 e8 ff ff       	call   801000d0 <bread>
80101807:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101809:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101819:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010181c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010181f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101823:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101827:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010182b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010182f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101833:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101837:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010183b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010183e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101841:	6a 34                	push   $0x34
80101843:	50                   	push   %eax
80101844:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101847:	50                   	push   %eax
80101848:	e8 93 34 00 00       	call   80104ce0 <memmove>
    brelse(bp);
8010184d:	89 34 24             	mov    %esi,(%esp)
80101850:	e8 8b e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010185d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101864:	0f 85 77 ff ff ff    	jne    801017e1 <ilock+0x31>
      panic("ilock: no type");
8010186a:	83 ec 0c             	sub    $0xc,%esp
8010186d:	68 50 85 10 80       	push   $0x80108550
80101872:	e8 19 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101877:	83 ec 0c             	sub    $0xc,%esp
8010187a:	68 4a 85 10 80       	push   $0x8010854a
8010187f:	e8 0c eb ff ff       	call   80100390 <panic>
80101884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010188a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101890 <iunlock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	74 28                	je     801018c4 <iunlock+0x34>
8010189c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010189f:	83 ec 0c             	sub    $0xc,%esp
801018a2:	56                   	push   %esi
801018a3:	e8 e8 30 00 00       	call   80104990 <holdingsleep>
801018a8:	83 c4 10             	add    $0x10,%esp
801018ab:	85 c0                	test   %eax,%eax
801018ad:	74 15                	je     801018c4 <iunlock+0x34>
801018af:	8b 43 08             	mov    0x8(%ebx),%eax
801018b2:	85 c0                	test   %eax,%eax
801018b4:	7e 0e                	jle    801018c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018bc:	5b                   	pop    %ebx
801018bd:	5e                   	pop    %esi
801018be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018bf:	e9 8c 30 00 00       	jmp    80104950 <releasesleep>
    panic("iunlock");
801018c4:	83 ec 0c             	sub    $0xc,%esp
801018c7:	68 5f 85 10 80       	push   $0x8010855f
801018cc:	e8 bf ea ff ff       	call   80100390 <panic>
801018d1:	eb 0d                	jmp    801018e0 <iput>
801018d3:	90                   	nop
801018d4:	90                   	nop
801018d5:	90                   	nop
801018d6:	90                   	nop
801018d7:	90                   	nop
801018d8:	90                   	nop
801018d9:	90                   	nop
801018da:	90                   	nop
801018db:	90                   	nop
801018dc:	90                   	nop
801018dd:	90                   	nop
801018de:	90                   	nop
801018df:	90                   	nop

801018e0 <iput>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 28             	sub    $0x28,%esp
801018e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018ef:	57                   	push   %edi
801018f0:	e8 fb 2f 00 00       	call   801048f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018f8:	83 c4 10             	add    $0x10,%esp
801018fb:	85 d2                	test   %edx,%edx
801018fd:	74 07                	je     80101906 <iput+0x26>
801018ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101904:	74 32                	je     80101938 <iput+0x58>
  releasesleep(&ip->lock);
80101906:	83 ec 0c             	sub    $0xc,%esp
80101909:	57                   	push   %edi
8010190a:	e8 41 30 00 00       	call   80104950 <releasesleep>
  acquire(&icache.lock);
8010190f:	c7 04 24 e0 49 11 80 	movl   $0x801149e0,(%esp)
80101916:	e8 05 32 00 00       	call   80104b20 <acquire>
  ip->ref--;
8010191b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010191f:	83 c4 10             	add    $0x10,%esp
80101922:	c7 45 08 e0 49 11 80 	movl   $0x801149e0,0x8(%ebp)
}
80101929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010192c:	5b                   	pop    %ebx
8010192d:	5e                   	pop    %esi
8010192e:	5f                   	pop    %edi
8010192f:	5d                   	pop    %ebp
  release(&icache.lock);
80101930:	e9 ab 32 00 00       	jmp    80104be0 <release>
80101935:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101938:	83 ec 0c             	sub    $0xc,%esp
8010193b:	68 e0 49 11 80       	push   $0x801149e0
80101940:	e8 db 31 00 00       	call   80104b20 <acquire>
    int r = ip->ref;
80101945:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101948:	c7 04 24 e0 49 11 80 	movl   $0x801149e0,(%esp)
8010194f:	e8 8c 32 00 00       	call   80104be0 <release>
    if(r == 1){
80101954:	83 c4 10             	add    $0x10,%esp
80101957:	83 fe 01             	cmp    $0x1,%esi
8010195a:	75 aa                	jne    80101906 <iput+0x26>
8010195c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101962:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101965:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101968:	89 cf                	mov    %ecx,%edi
8010196a:	eb 0b                	jmp    80101977 <iput+0x97>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101970:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101973:	39 fe                	cmp    %edi,%esi
80101975:	74 19                	je     80101990 <iput+0xb0>
    if(ip->addrs[i]){
80101977:	8b 16                	mov    (%esi),%edx
80101979:	85 d2                	test   %edx,%edx
8010197b:	74 f3                	je     80101970 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010197d:	8b 03                	mov    (%ebx),%eax
8010197f:	e8 bc f8 ff ff       	call   80101240 <bfree>
      ip->addrs[i] = 0;
80101984:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010198a:	eb e4                	jmp    80101970 <iput+0x90>
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101990:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101996:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101999:	85 c0                	test   %eax,%eax
8010199b:	75 33                	jne    801019d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010199d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019a7:	53                   	push   %ebx
801019a8:	e8 53 fd ff ff       	call   80101700 <iupdate>
      ip->type = 0;
801019ad:	31 c0                	xor    %eax,%eax
801019af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019b3:	89 1c 24             	mov    %ebx,(%esp)
801019b6:	e8 45 fd ff ff       	call   80101700 <iupdate>
      ip->valid = 0;
801019bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019c2:	83 c4 10             	add    $0x10,%esp
801019c5:	e9 3c ff ff ff       	jmp    80101906 <iput+0x26>
801019ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019d0:	83 ec 08             	sub    $0x8,%esp
801019d3:	50                   	push   %eax
801019d4:	ff 33                	pushl  (%ebx)
801019d6:	e8 f5 e6 ff ff       	call   801000d0 <bread>
801019db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801019e7:	8d 70 5c             	lea    0x5c(%eax),%esi
801019ea:	83 c4 10             	add    $0x10,%esp
801019ed:	89 cf                	mov    %ecx,%edi
801019ef:	eb 0e                	jmp    801019ff <iput+0x11f>
801019f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801019fb:	39 fe                	cmp    %edi,%esi
801019fd:	74 0f                	je     80101a0e <iput+0x12e>
      if(a[j])
801019ff:	8b 16                	mov    (%esi),%edx
80101a01:	85 d2                	test   %edx,%edx
80101a03:	74 f3                	je     801019f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a05:	8b 03                	mov    (%ebx),%eax
80101a07:	e8 34 f8 ff ff       	call   80101240 <bfree>
80101a0c:	eb ea                	jmp    801019f8 <iput+0x118>
    brelse(bp);
80101a0e:	83 ec 0c             	sub    $0xc,%esp
80101a11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a14:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a17:	e8 c4 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a1c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a22:	8b 03                	mov    (%ebx),%eax
80101a24:	e8 17 f8 ff ff       	call   80101240 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a29:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a30:	00 00 00 
80101a33:	83 c4 10             	add    $0x10,%esp
80101a36:	e9 62 ff ff ff       	jmp    8010199d <iput+0xbd>
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a40 <iunlockput>:
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	53                   	push   %ebx
80101a44:	83 ec 10             	sub    $0x10,%esp
80101a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a4a:	53                   	push   %ebx
80101a4b:	e8 40 fe ff ff       	call   80101890 <iunlock>
  iput(ip);
80101a50:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a53:	83 c4 10             	add    $0x10,%esp
}
80101a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a59:	c9                   	leave  
  iput(ip);
80101a5a:	e9 81 fe ff ff       	jmp    801018e0 <iput>
80101a5f:	90                   	nop

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	90                   	nop
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101aca:	89 f9                	mov    %edi,%ecx
80101acc:	01 f1                	add    %esi,%ecx
80101ace:	0f 82 ad 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ad4:	89 c2                	mov    %eax,%edx
80101ad6:	29 f2                	sub    %esi,%edx
80101ad8:	39 c8                	cmp    %ecx,%eax
80101ada:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101add:	31 ff                	xor    %edi,%edi
80101adf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101ae1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae4:	74 6c                	je     80101b52 <readi+0xc2>
80101ae6:	8d 76 00             	lea    0x0(%esi),%esi
80101ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 91 f9 ff ff       	call   80101490 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	pushl  (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0f:	89 f0                	mov    %esi,%eax
80101b11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b1b:	83 c4 0c             	add    $0xc,%esp
80101b1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	29 fb                	sub    %edi,%ebx
80101b29:	39 d9                	cmp    %ebx,%ecx
80101b2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2e:	53                   	push   %ebx
80101b2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b37:	e8 a4 31 00 00       	call   80104ce0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 99 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 60 49 11 80 	mov    -0x7feeb6a0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	90                   	nop
80101b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	39 70 58             	cmp    %esi,0x58(%eax)
80101bbf:	0f 82 eb 00 00 00    	jb     80101cb0 <writei+0x120>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d4 00 00 00    	ja     80101cb0 <writei+0x120>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 cc 00 00 00    	jne    80101cb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	85 ff                	test   %edi,%edi
80101be6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 91 f8 ff ff       	call   80101490 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	pushl  (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c12:	89 f0                	mov    %esi,%eax
80101c14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c19:	83 c4 0c             	add    $0xc,%esp
80101c1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	39 d9                	cmp    %ebx,%ecx
80101c29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c2c:	53                   	push   %ebx
80101c2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c32:	50                   	push   %eax
80101c33:	e8 a8 30 00 00       	call   80104ce0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 80 16 00 00       	call   801032c0 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 98 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c4e:	83 c4 10             	add    $0x10,%esp
80101c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 36                	ja     80101cb0 <writei+0x120>
80101c7a:	8b 04 c5 64 49 11 80 	mov    -0x7feeb69c(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 2b                	je     80101cb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 59 fa ff ff       	call   80101700 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb5:	eb ad                	jmp    80101c64 <writei+0xd4>
80101cb7:	89 f6                	mov    %esi,%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	pushl  0xc(%ebp)
80101ccb:	ff 75 08             	pushl  0x8(%ebp)
80101cce:	e8 7d 30 00 00       	call   80104d50 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	90                   	nop
80101d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d24:	83 ec 04             	sub    $0x4,%esp
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	pushl  0xc(%ebp)
80101d2d:	e8 1e 30 00 00       	call   80104d50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	90                   	nop
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 59 f6 ff ff       	call   801013c0 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 79 85 10 80       	push   $0x80108579
80101d77:	e8 14 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 85 10 80       	push   $0x80108567
80101d84:	e8 07 e6 ff ff       	call   80100390 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 cf                	mov    %ecx,%edi
80101d98:	89 c3                	mov    %eax,%ebx
80101d9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101da0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101da3:	0f 84 67 01 00 00    	je     80101f10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101da9:	e8 02 20 00 00       	call   80103db0 <myproc>
  acquire(&icache.lock);
80101dae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db4:	68 e0 49 11 80       	push   $0x801149e0
80101db9:	e8 62 2d 00 00       	call   80104b20 <acquire>
  ip->ref++;
80101dbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc2:	c7 04 24 e0 49 11 80 	movl   $0x801149e0,(%esp)
80101dc9:	e8 12 2e 00 00       	call   80104be0 <release>
80101dce:	83 c4 10             	add    $0x10,%esp
80101dd1:	eb 08                	jmp    80101ddb <namex+0x4b>
80101dd3:	90                   	nop
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 ee 00 00 00    	je     80101ed8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	3c 2f                	cmp    $0x2f,%al
80101def:	0f 84 b3 00 00 00    	je     80101ea8 <namex+0x118>
80101df5:	84 c0                	test   %al,%al
80101df7:	89 da                	mov    %ebx,%edx
80101df9:	75 09                	jne    80101e04 <namex+0x74>
80101dfb:	e9 a8 00 00 00       	jmp    80101ea8 <namex+0x118>
80101e00:	84 c0                	test   %al,%al
80101e02:	74 0a                	je     80101e0e <namex+0x7e>
    path++;
80101e04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e07:	0f b6 02             	movzbl (%edx),%eax
80101e0a:	3c 2f                	cmp    $0x2f,%al
80101e0c:	75 f2                	jne    80101e00 <namex+0x70>
80101e0e:	89 d1                	mov    %edx,%ecx
80101e10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e12:	83 f9 0d             	cmp    $0xd,%ecx
80101e15:	0f 8e 91 00 00 00    	jle    80101eac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e1b:	83 ec 04             	sub    $0x4,%esp
80101e1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e21:	6a 0e                	push   $0xe
80101e23:	53                   	push   %ebx
80101e24:	57                   	push   %edi
80101e25:	e8 b6 2e 00 00       	call   80104ce0 <memmove>
    path++;
80101e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101e2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101e30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101e32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e35:	75 11                	jne    80101e48 <namex+0xb8>
80101e37:	89 f6                	mov    %esi,%esi
80101e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101e40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e46:	74 f8                	je     80101e40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e48:	83 ec 0c             	sub    $0xc,%esp
80101e4b:	56                   	push   %esi
80101e4c:	e8 5f f9 ff ff       	call   801017b0 <ilock>
    if(ip->type != T_DIR){
80101e51:	83 c4 10             	add    $0x10,%esp
80101e54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e59:	0f 85 91 00 00 00    	jne    80101ef0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e62:	85 d2                	test   %edx,%edx
80101e64:	74 09                	je     80101e6f <namex+0xdf>
80101e66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e69:	0f 84 b7 00 00 00    	je     80101f26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e6f:	83 ec 04             	sub    $0x4,%esp
80101e72:	6a 00                	push   $0x0
80101e74:	57                   	push   %edi
80101e75:	56                   	push   %esi
80101e76:	e8 65 fe ff ff       	call   80101ce0 <dirlookup>
80101e7b:	83 c4 10             	add    $0x10,%esp
80101e7e:	85 c0                	test   %eax,%eax
80101e80:	74 6e                	je     80101ef0 <namex+0x160>
  iunlock(ip);
80101e82:	83 ec 0c             	sub    $0xc,%esp
80101e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e88:	56                   	push   %esi
80101e89:	e8 02 fa ff ff       	call   80101890 <iunlock>
  iput(ip);
80101e8e:	89 34 24             	mov    %esi,(%esp)
80101e91:	e8 4a fa ff ff       	call   801018e0 <iput>
80101e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e99:	83 c4 10             	add    $0x10,%esp
80101e9c:	89 c6                	mov    %eax,%esi
80101e9e:	e9 38 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ea3:	90                   	nop
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101ea8:	89 da                	mov    %ebx,%edx
80101eaa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101eac:	83 ec 04             	sub    $0x4,%esp
80101eaf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101eb5:	51                   	push   %ecx
80101eb6:	53                   	push   %ebx
80101eb7:	57                   	push   %edi
80101eb8:	e8 23 2e 00 00       	call   80104ce0 <memmove>
    name[len] = 0;
80101ebd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ec3:	83 c4 10             	add    $0x10,%esp
80101ec6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101eca:	89 d3                	mov    %edx,%ebx
80101ecc:	e9 61 ff ff ff       	jmp    80101e32 <namex+0xa2>
80101ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101edb:	85 c0                	test   %eax,%eax
80101edd:	75 5d                	jne    80101f3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee2:	89 f0                	mov    %esi,%eax
80101ee4:	5b                   	pop    %ebx
80101ee5:	5e                   	pop    %esi
80101ee6:	5f                   	pop    %edi
80101ee7:	5d                   	pop    %ebp
80101ee8:	c3                   	ret    
80101ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	56                   	push   %esi
80101ef4:	e8 97 f9 ff ff       	call   80101890 <iunlock>
  iput(ip);
80101ef9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101efc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101efe:	e8 dd f9 ff ff       	call   801018e0 <iput>
      return 0;
80101f03:	83 c4 10             	add    $0x10,%esp
}
80101f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f09:	89 f0                	mov    %esi,%eax
80101f0b:	5b                   	pop    %ebx
80101f0c:	5e                   	pop    %esi
80101f0d:	5f                   	pop    %edi
80101f0e:	5d                   	pop    %ebp
80101f0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	e8 a1 f4 ff ff       	call   801013c0 <iget>
80101f1f:	89 c6                	mov    %eax,%esi
80101f21:	e9 b5 fe ff ff       	jmp    80101ddb <namex+0x4b>
      iunlock(ip);
80101f26:	83 ec 0c             	sub    $0xc,%esp
80101f29:	56                   	push   %esi
80101f2a:	e8 61 f9 ff ff       	call   80101890 <iunlock>
      return ip;
80101f2f:	83 c4 10             	add    $0x10,%esp
}
80101f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f35:	89 f0                	mov    %esi,%eax
80101f37:	5b                   	pop    %ebx
80101f38:	5e                   	pop    %esi
80101f39:	5f                   	pop    %edi
80101f3a:	5d                   	pop    %ebp
80101f3b:	c3                   	ret    
    iput(ip);
80101f3c:	83 ec 0c             	sub    $0xc,%esp
80101f3f:	56                   	push   %esi
    return 0;
80101f40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f42:	e8 99 f9 ff ff       	call   801018e0 <iput>
    return 0;
80101f47:	83 c4 10             	add    $0x10,%esp
80101f4a:	eb 93                	jmp    80101edf <namex+0x14f>
80101f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f50 <dirlink>:
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 20             	sub    $0x20,%esp
80101f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f5c:	6a 00                	push   $0x0
80101f5e:	ff 75 0c             	pushl  0xc(%ebp)
80101f61:	53                   	push   %ebx
80101f62:	e8 79 fd ff ff       	call   80101ce0 <dirlookup>
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	75 67                	jne    80101fd5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f74:	85 ff                	test   %edi,%edi
80101f76:	74 29                	je     80101fa1 <dirlink+0x51>
80101f78:	31 ff                	xor    %edi,%edi
80101f7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f7d:	eb 09                	jmp    80101f88 <dirlink+0x38>
80101f7f:	90                   	nop
80101f80:	83 c7 10             	add    $0x10,%edi
80101f83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f86:	73 19                	jae    80101fa1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f88:	6a 10                	push   $0x10
80101f8a:	57                   	push   %edi
80101f8b:	56                   	push   %esi
80101f8c:	53                   	push   %ebx
80101f8d:	e8 fe fa ff ff       	call   80101a90 <readi>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	83 f8 10             	cmp    $0x10,%eax
80101f98:	75 4e                	jne    80101fe8 <dirlink+0x98>
    if(de.inum == 0)
80101f9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f9f:	75 df                	jne    80101f80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101fa1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fa4:	83 ec 04             	sub    $0x4,%esp
80101fa7:	6a 0e                	push   $0xe
80101fa9:	ff 75 0c             	pushl  0xc(%ebp)
80101fac:	50                   	push   %eax
80101fad:	e8 fe 2d 00 00       	call   80104db0 <strncpy>
  de.inum = inum;
80101fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb5:	6a 10                	push   $0x10
80101fb7:	57                   	push   %edi
80101fb8:	56                   	push   %esi
80101fb9:	53                   	push   %ebx
  de.inum = inum;
80101fba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fbe:	e8 cd fb ff ff       	call   80101b90 <writei>
80101fc3:	83 c4 20             	add    $0x20,%esp
80101fc6:	83 f8 10             	cmp    $0x10,%eax
80101fc9:	75 2a                	jne    80101ff5 <dirlink+0xa5>
  return 0;
80101fcb:	31 c0                	xor    %eax,%eax
}
80101fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd0:	5b                   	pop    %ebx
80101fd1:	5e                   	pop    %esi
80101fd2:	5f                   	pop    %edi
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    
    iput(ip);
80101fd5:	83 ec 0c             	sub    $0xc,%esp
80101fd8:	50                   	push   %eax
80101fd9:	e8 02 f9 ff ff       	call   801018e0 <iput>
    return -1;
80101fde:	83 c4 10             	add    $0x10,%esp
80101fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe6:	eb e5                	jmp    80101fcd <dirlink+0x7d>
      panic("dirlink read");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 88 85 10 80       	push   $0x80108588
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 31 8c 10 80       	push   $0x80108c31
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <namei>:

struct inode*
namei(char *path)
{
80102010:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102011:	31 d2                	xor    %edx,%edx
{
80102013:	89 e5                	mov    %esp,%ebp
80102015:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102018:	8b 45 08             	mov    0x8(%ebp),%eax
8010201b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010201e:	e8 6d fd ff ff       	call   80101d90 <namex>
}
80102023:	c9                   	leave  
80102024:	c3                   	ret    
80102025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102030:	55                   	push   %ebp
  return namex(path, 1, name);
80102031:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102036:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010203b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010203e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010203f:	e9 4c fd ff ff       	jmp    80101d90 <namex>
80102044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010204a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102050 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102050:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102051:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80102056:	89 e5                	mov    %esp,%ebp
80102058:	57                   	push   %edi
80102059:	56                   	push   %esi
8010205a:	53                   	push   %ebx
8010205b:	83 ec 10             	sub    $0x10,%esp
8010205e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102061:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80102068:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
8010206f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102073:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102077:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010207a:	85 c9                	test   %ecx,%ecx
8010207c:	79 0a                	jns    80102088 <itoa+0x38>
8010207e:	89 f0                	mov    %esi,%eax
80102080:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102083:	f7 d9                	neg    %ecx
        *p++ = '-';
80102085:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102088:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010208a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010208f:	90                   	nop
80102090:	89 d8                	mov    %ebx,%eax
80102092:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102095:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102098:	f7 ef                	imul   %edi
8010209a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010209d:	29 da                	sub    %ebx,%edx
8010209f:	89 d3                	mov    %edx,%ebx
801020a1:	75 ed                	jne    80102090 <itoa+0x40>
    *p = '\0';
801020a3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801020a6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
801020ab:	90                   	nop
801020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b0:	89 c8                	mov    %ecx,%eax
801020b2:	83 ee 01             	sub    $0x1,%esi
801020b5:	f7 eb                	imul   %ebx
801020b7:	89 c8                	mov    %ecx,%eax
801020b9:	c1 f8 1f             	sar    $0x1f,%eax
801020bc:	c1 fa 02             	sar    $0x2,%edx
801020bf:	29 c2                	sub    %eax,%edx
801020c1:	8d 04 92             	lea    (%edx,%edx,4),%eax
801020c4:	01 c0                	add    %eax,%eax
801020c6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
801020c8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
801020ca:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801020cf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801020d1:	88 06                	mov    %al,(%esi)
    }while(i);
801020d3:	75 db                	jne    801020b0 <itoa+0x60>
    return b;
}
801020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d8:	83 c4 10             	add    $0x10,%esp
801020db:	5b                   	pop    %ebx
801020dc:	5e                   	pop    %esi
801020dd:	5f                   	pop    %edi
801020de:	5d                   	pop    %ebp
801020df:	c3                   	ret    

801020e0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801020e6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801020e9:	83 ec 40             	sub    $0x40,%esp
801020ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801020ef:	6a 06                	push   $0x6
801020f1:	68 95 85 10 80       	push   $0x80108595
801020f6:	56                   	push   %esi
801020f7:	e8 e4 2b 00 00       	call   80104ce0 <memmove>
  itoa(p->pid, path+ 6);
801020fc:	58                   	pop    %eax
801020fd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102100:	5a                   	pop    %edx
80102101:	50                   	push   %eax
80102102:	ff 73 10             	pushl  0x10(%ebx)
80102105:	e8 46 ff ff ff       	call   80102050 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010210a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010210d:	83 c4 10             	add    $0x10,%esp
80102110:	85 c0                	test   %eax,%eax
80102112:	0f 84 88 01 00 00    	je     801022a0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102118:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010211b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010211e:	50                   	push   %eax
8010211f:	e8 4c ee ff ff       	call   80100f70 <fileclose>

  begin_op();
80102124:	e8 c7 0f 00 00       	call   801030f0 <begin_op>
  return namex(path, 1, name);
80102129:	89 f0                	mov    %esi,%eax
8010212b:	89 d9                	mov    %ebx,%ecx
8010212d:	ba 01 00 00 00       	mov    $0x1,%edx
80102132:	e8 59 fc ff ff       	call   80101d90 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010213c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010213e:	0f 84 66 01 00 00    	je     801022aa <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102144:	83 ec 0c             	sub    $0xc,%esp
80102147:	50                   	push   %eax
80102148:	e8 63 f6 ff ff       	call   801017b0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010214d:	83 c4 0c             	add    $0xc,%esp
80102150:	6a 0e                	push   $0xe
80102152:	68 9d 85 10 80       	push   $0x8010859d
80102157:	53                   	push   %ebx
80102158:	e8 f3 2b 00 00       	call   80104d50 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010215d:	83 c4 10             	add    $0x10,%esp
80102160:	85 c0                	test   %eax,%eax
80102162:	0f 84 f8 00 00 00    	je     80102260 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102168:	83 ec 04             	sub    $0x4,%esp
8010216b:	6a 0e                	push   $0xe
8010216d:	68 9c 85 10 80       	push   $0x8010859c
80102172:	53                   	push   %ebx
80102173:	e8 d8 2b 00 00       	call   80104d50 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102178:	83 c4 10             	add    $0x10,%esp
8010217b:	85 c0                	test   %eax,%eax
8010217d:	0f 84 dd 00 00 00    	je     80102260 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102183:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102186:	83 ec 04             	sub    $0x4,%esp
80102189:	50                   	push   %eax
8010218a:	53                   	push   %ebx
8010218b:	56                   	push   %esi
8010218c:	e8 4f fb ff ff       	call   80101ce0 <dirlookup>
80102191:	83 c4 10             	add    $0x10,%esp
80102194:	85 c0                	test   %eax,%eax
80102196:	89 c3                	mov    %eax,%ebx
80102198:	0f 84 c2 00 00 00    	je     80102260 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	50                   	push   %eax
801021a2:	e8 09 f6 ff ff       	call   801017b0 <ilock>

  if(ip->nlink < 1)
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801021af:	0f 8e 11 01 00 00    	jle    801022c6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801021b5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021ba:	74 74                	je     80102230 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801021bc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801021bf:	83 ec 04             	sub    $0x4,%esp
801021c2:	6a 10                	push   $0x10
801021c4:	6a 00                	push   $0x0
801021c6:	57                   	push   %edi
801021c7:	e8 64 2a 00 00       	call   80104c30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021cc:	6a 10                	push   $0x10
801021ce:	ff 75 b8             	pushl  -0x48(%ebp)
801021d1:	57                   	push   %edi
801021d2:	56                   	push   %esi
801021d3:	e8 b8 f9 ff ff       	call   80101b90 <writei>
801021d8:	83 c4 20             	add    $0x20,%esp
801021db:	83 f8 10             	cmp    $0x10,%eax
801021de:	0f 85 d5 00 00 00    	jne    801022b9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801021e4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021e9:	0f 84 91 00 00 00    	je     80102280 <removeSwapFile+0x1a0>
  iunlock(ip);
801021ef:	83 ec 0c             	sub    $0xc,%esp
801021f2:	56                   	push   %esi
801021f3:	e8 98 f6 ff ff       	call   80101890 <iunlock>
  iput(ip);
801021f8:	89 34 24             	mov    %esi,(%esp)
801021fb:	e8 e0 f6 ff ff       	call   801018e0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102200:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102205:	89 1c 24             	mov    %ebx,(%esp)
80102208:	e8 f3 f4 ff ff       	call   80101700 <iupdate>
  iunlock(ip);
8010220d:	89 1c 24             	mov    %ebx,(%esp)
80102210:	e8 7b f6 ff ff       	call   80101890 <iunlock>
  iput(ip);
80102215:	89 1c 24             	mov    %ebx,(%esp)
80102218:	e8 c3 f6 ff ff       	call   801018e0 <iput>
  iunlockput(ip);

  end_op();
8010221d:	e8 3e 0f 00 00       	call   80103160 <end_op>

  return 0;
80102222:	83 c4 10             	add    $0x10,%esp
80102225:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102227:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010222a:	5b                   	pop    %ebx
8010222b:	5e                   	pop    %esi
8010222c:	5f                   	pop    %edi
8010222d:	5d                   	pop    %ebp
8010222e:	c3                   	ret    
8010222f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	53                   	push   %ebx
80102234:	e8 d7 31 00 00       	call   80105410 <isdirempty>
80102239:	83 c4 10             	add    $0x10,%esp
8010223c:	85 c0                	test   %eax,%eax
8010223e:	0f 85 78 ff ff ff    	jne    801021bc <removeSwapFile+0xdc>
  iunlock(ip);
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	53                   	push   %ebx
80102248:	e8 43 f6 ff ff       	call   80101890 <iunlock>
  iput(ip);
8010224d:	89 1c 24             	mov    %ebx,(%esp)
80102250:	e8 8b f6 ff ff       	call   801018e0 <iput>
80102255:	83 c4 10             	add    $0x10,%esp
80102258:	90                   	nop
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102260:	83 ec 0c             	sub    $0xc,%esp
80102263:	56                   	push   %esi
80102264:	e8 27 f6 ff ff       	call   80101890 <iunlock>
  iput(ip);
80102269:	89 34 24             	mov    %esi,(%esp)
8010226c:	e8 6f f6 ff ff       	call   801018e0 <iput>
    end_op();
80102271:	e8 ea 0e 00 00       	call   80103160 <end_op>
    return -1;
80102276:	83 c4 10             	add    $0x10,%esp
80102279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010227e:	eb a7                	jmp    80102227 <removeSwapFile+0x147>
    dp->nlink--;
80102280:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	56                   	push   %esi
80102289:	e8 72 f4 ff ff       	call   80101700 <iupdate>
8010228e:	83 c4 10             	add    $0x10,%esp
80102291:	e9 59 ff ff ff       	jmp    801021ef <removeSwapFile+0x10f>
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801022a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a5:	e9 7d ff ff ff       	jmp    80102227 <removeSwapFile+0x147>
    end_op();
801022aa:	e8 b1 0e 00 00       	call   80103160 <end_op>
    return -1;
801022af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b4:	e9 6e ff ff ff       	jmp    80102227 <removeSwapFile+0x147>
    panic("unlink: writei");
801022b9:	83 ec 0c             	sub    $0xc,%esp
801022bc:	68 b1 85 10 80       	push   $0x801085b1
801022c1:	e8 ca e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801022c6:	83 ec 0c             	sub    $0xc,%esp
801022c9:	68 9f 85 10 80       	push   $0x8010859f
801022ce:	e8 bd e0 ff ff       	call   80100390 <panic>
801022d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	56                   	push   %esi
801022e4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801022e5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801022e8:	83 ec 14             	sub    $0x14,%esp
801022eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801022ee:	6a 06                	push   $0x6
801022f0:	68 95 85 10 80       	push   $0x80108595
801022f5:	56                   	push   %esi
801022f6:	e8 e5 29 00 00       	call   80104ce0 <memmove>
  itoa(p->pid, path+ 6);
801022fb:	58                   	pop    %eax
801022fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801022ff:	5a                   	pop    %edx
80102300:	50                   	push   %eax
80102301:	ff 73 10             	pushl  0x10(%ebx)
80102304:	e8 47 fd ff ff       	call   80102050 <itoa>

    begin_op();
80102309:	e8 e2 0d 00 00       	call   801030f0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010230e:	6a 00                	push   $0x0
80102310:	6a 00                	push   $0x0
80102312:	6a 02                	push   $0x2
80102314:	56                   	push   %esi
80102315:	e8 06 33 00 00       	call   80105620 <create>
  iunlock(in);
8010231a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010231d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010231f:	50                   	push   %eax
80102320:	e8 6b f5 ff ff       	call   80101890 <iunlock>

  p->swapFile = filealloc();
80102325:	e8 86 eb ff ff       	call   80100eb0 <filealloc>
  if (p->swapFile == 0)
8010232a:	83 c4 10             	add    $0x10,%esp
8010232d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010232f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102332:	74 32                	je     80102366 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102334:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102337:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010233a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102340:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102343:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010234a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010234d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102351:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102354:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102358:	e8 03 0e 00 00       	call   80103160 <end_op>

    return 0;
}
8010235d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102360:	31 c0                	xor    %eax,%eax
80102362:	5b                   	pop    %ebx
80102363:	5e                   	pop    %esi
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
    panic("no slot for files on /store");
80102366:	83 ec 0c             	sub    $0xc,%esp
80102369:	68 c0 85 10 80       	push   $0x801085c0
8010236e:	e8 1d e0 ff ff       	call   80100390 <panic>
80102373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102380 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	8b 45 08             	mov    0x8(%ebp),%eax
  
  p->swapFile->off = placeOnFile;
80102386:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102389:	8b 50 7c             	mov    0x7c(%eax),%edx
8010238c:	89 4a 14             	mov    %ecx,0x14(%edx)
  
  return filewrite(p->swapFile, buffer, size);
8010238f:	8b 55 14             	mov    0x14(%ebp),%edx
80102392:	89 55 10             	mov    %edx,0x10(%ebp)
80102395:	8b 40 7c             	mov    0x7c(%eax),%eax
80102398:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010239b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010239c:	e9 7f ed ff ff       	jmp    80101120 <filewrite>
801023a1:	eb 0d                	jmp    801023b0 <readFromSwapFile>
801023a3:	90                   	nop
801023a4:	90                   	nop
801023a5:	90                   	nop
801023a6:	90                   	nop
801023a7:	90                   	nop
801023a8:	90                   	nop
801023a9:	90                   	nop
801023aa:	90                   	nop
801023ab:	90                   	nop
801023ac:	90                   	nop
801023ad:	90                   	nop
801023ae:	90                   	nop
801023af:	90                   	nop

801023b0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801023b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023b9:	8b 50 7c             	mov    0x7c(%eax),%edx
801023bc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801023bf:	8b 55 14             	mov    0x14(%ebp),%edx
801023c2:	89 55 10             	mov    %edx,0x10(%ebp)
801023c5:	8b 40 7c             	mov    0x7c(%eax),%eax
801023c8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801023cb:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801023cc:	e9 bf ec ff ff       	jmp    80101090 <fileread>
801023d1:	66 90                	xchg   %ax,%ax
801023d3:	66 90                	xchg   %ax,%ax
801023d5:	66 90                	xchg   %ax,%ax
801023d7:	66 90                	xchg   %ax,%ax
801023d9:	66 90                	xchg   %ax,%ax
801023db:	66 90                	xchg   %ax,%ax
801023dd:	66 90                	xchg   %ax,%ax
801023df:	90                   	nop

801023e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	57                   	push   %edi
801023e4:	56                   	push   %esi
801023e5:	53                   	push   %ebx
801023e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023e9:	85 c0                	test   %eax,%eax
801023eb:	0f 84 b4 00 00 00    	je     801024a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801023f1:	8b 58 08             	mov    0x8(%eax),%ebx
801023f4:	89 c6                	mov    %eax,%esi
801023f6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801023fc:	0f 87 96 00 00 00    	ja     80102498 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102402:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102407:	89 f6                	mov    %esi,%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102410:	89 ca                	mov    %ecx,%edx
80102412:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102413:	83 e0 c0             	and    $0xffffffc0,%eax
80102416:	3c 40                	cmp    $0x40,%al
80102418:	75 f6                	jne    80102410 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010241a:	31 ff                	xor    %edi,%edi
8010241c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102421:	89 f8                	mov    %edi,%eax
80102423:	ee                   	out    %al,(%dx)
80102424:	b8 01 00 00 00       	mov    $0x1,%eax
80102429:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010242e:	ee                   	out    %al,(%dx)
8010242f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102434:	89 d8                	mov    %ebx,%eax
80102436:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102437:	89 d8                	mov    %ebx,%eax
80102439:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010243e:	c1 f8 08             	sar    $0x8,%eax
80102441:	ee                   	out    %al,(%dx)
80102442:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102447:	89 f8                	mov    %edi,%eax
80102449:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010244a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010244e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102453:	c1 e0 04             	shl    $0x4,%eax
80102456:	83 e0 10             	and    $0x10,%eax
80102459:	83 c8 e0             	or     $0xffffffe0,%eax
8010245c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010245d:	f6 06 04             	testb  $0x4,(%esi)
80102460:	75 16                	jne    80102478 <idestart+0x98>
80102462:	b8 20 00 00 00       	mov    $0x20,%eax
80102467:	89 ca                	mov    %ecx,%edx
80102469:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010246a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010246d:	5b                   	pop    %ebx
8010246e:	5e                   	pop    %esi
8010246f:	5f                   	pop    %edi
80102470:	5d                   	pop    %ebp
80102471:	c3                   	ret    
80102472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102478:	b8 30 00 00 00       	mov    $0x30,%eax
8010247d:	89 ca                	mov    %ecx,%edx
8010247f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102480:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102485:	83 c6 5c             	add    $0x5c,%esi
80102488:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010248d:	fc                   	cld    
8010248e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102493:	5b                   	pop    %ebx
80102494:	5e                   	pop    %esi
80102495:	5f                   	pop    %edi
80102496:	5d                   	pop    %ebp
80102497:	c3                   	ret    
    panic("incorrect blockno");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 38 86 10 80       	push   $0x80108638
801024a0:	e8 eb de ff ff       	call   80100390 <panic>
    panic("idestart");
801024a5:	83 ec 0c             	sub    $0xc,%esp
801024a8:	68 2f 86 10 80       	push   $0x8010862f
801024ad:	e8 de de ff ff       	call   80100390 <panic>
801024b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <ideinit>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024c6:	68 4a 86 10 80       	push   $0x8010864a
801024cb:	68 80 c5 10 80       	push   $0x8010c580
801024d0:	e8 0b 25 00 00       	call   801049e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024d5:	58                   	pop    %eax
801024d6:	a1 20 6d 11 80       	mov    0x80116d20,%eax
801024db:	5a                   	pop    %edx
801024dc:	83 e8 01             	sub    $0x1,%eax
801024df:	50                   	push   %eax
801024e0:	6a 0e                	push   $0xe
801024e2:	e8 a9 02 00 00       	call   80102790 <ioapicenable>
801024e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024ef:	90                   	nop
801024f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024f1:	83 e0 c0             	and    $0xffffffc0,%eax
801024f4:	3c 40                	cmp    $0x40,%al
801024f6:	75 f8                	jne    801024f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801024fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102502:	ee                   	out    %al,(%dx)
80102503:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102508:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010250d:	eb 06                	jmp    80102515 <ideinit+0x55>
8010250f:	90                   	nop
  for(i=0; i<1000; i++){
80102510:	83 e9 01             	sub    $0x1,%ecx
80102513:	74 0f                	je     80102524 <ideinit+0x64>
80102515:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102516:	84 c0                	test   %al,%al
80102518:	74 f6                	je     80102510 <ideinit+0x50>
      havedisk1 = 1;
8010251a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102521:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102524:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102529:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010252e:	ee                   	out    %al,(%dx)
}
8010252f:	c9                   	leave  
80102530:	c3                   	ret    
80102531:	eb 0d                	jmp    80102540 <ideintr>
80102533:	90                   	nop
80102534:	90                   	nop
80102535:	90                   	nop
80102536:	90                   	nop
80102537:	90                   	nop
80102538:	90                   	nop
80102539:	90                   	nop
8010253a:	90                   	nop
8010253b:	90                   	nop
8010253c:	90                   	nop
8010253d:	90                   	nop
8010253e:	90                   	nop
8010253f:	90                   	nop

80102540 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	57                   	push   %edi
80102544:	56                   	push   %esi
80102545:	53                   	push   %ebx
80102546:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102549:	68 80 c5 10 80       	push   $0x8010c580
8010254e:	e8 cd 25 00 00       	call   80104b20 <acquire>

  if((b = idequeue) == 0){
80102553:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102559:	83 c4 10             	add    $0x10,%esp
8010255c:	85 db                	test   %ebx,%ebx
8010255e:	74 67                	je     801025c7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102560:	8b 43 58             	mov    0x58(%ebx),%eax
80102563:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102568:	8b 3b                	mov    (%ebx),%edi
8010256a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102570:	75 31                	jne    801025a3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102572:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102577:	89 f6                	mov    %esi,%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102580:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102581:	89 c6                	mov    %eax,%esi
80102583:	83 e6 c0             	and    $0xffffffc0,%esi
80102586:	89 f1                	mov    %esi,%ecx
80102588:	80 f9 40             	cmp    $0x40,%cl
8010258b:	75 f3                	jne    80102580 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010258d:	a8 21                	test   $0x21,%al
8010258f:	75 12                	jne    801025a3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102591:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102594:	b9 80 00 00 00       	mov    $0x80,%ecx
80102599:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010259e:	fc                   	cld    
8010259f:	f3 6d                	rep insl (%dx),%es:(%edi)
801025a1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025a3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801025a6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025a9:	89 f9                	mov    %edi,%ecx
801025ab:	83 c9 02             	or     $0x2,%ecx
801025ae:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801025b0:	53                   	push   %ebx
801025b1:	e8 fa 20 00 00       	call   801046b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025b6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801025bb:	83 c4 10             	add    $0x10,%esp
801025be:	85 c0                	test   %eax,%eax
801025c0:	74 05                	je     801025c7 <ideintr+0x87>
    idestart(idequeue);
801025c2:	e8 19 fe ff ff       	call   801023e0 <idestart>
    release(&idelock);
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 80 c5 10 80       	push   $0x8010c580
801025cf:	e8 0c 26 00 00       	call   80104be0 <release>

  release(&idelock);
}
801025d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5f                   	pop    %edi
801025da:	5d                   	pop    %ebp
801025db:	c3                   	ret    
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	53                   	push   %ebx
801025e4:	83 ec 10             	sub    $0x10,%esp
801025e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801025ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801025ed:	50                   	push   %eax
801025ee:	e8 9d 23 00 00       	call   80104990 <holdingsleep>
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	85 c0                	test   %eax,%eax
801025f8:	0f 84 c6 00 00 00    	je     801026c4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801025fe:	8b 03                	mov    (%ebx),%eax
80102600:	83 e0 06             	and    $0x6,%eax
80102603:	83 f8 02             	cmp    $0x2,%eax
80102606:	0f 84 ab 00 00 00    	je     801026b7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010260c:	8b 53 04             	mov    0x4(%ebx),%edx
8010260f:	85 d2                	test   %edx,%edx
80102611:	74 0d                	je     80102620 <iderw+0x40>
80102613:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102618:	85 c0                	test   %eax,%eax
8010261a:	0f 84 b1 00 00 00    	je     801026d1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 80 c5 10 80       	push   $0x8010c580
80102628:	e8 f3 24 00 00       	call   80104b20 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010262d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102633:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102636:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010263d:	85 d2                	test   %edx,%edx
8010263f:	75 09                	jne    8010264a <iderw+0x6a>
80102641:	eb 6d                	jmp    801026b0 <iderw+0xd0>
80102643:	90                   	nop
80102644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102648:	89 c2                	mov    %eax,%edx
8010264a:	8b 42 58             	mov    0x58(%edx),%eax
8010264d:	85 c0                	test   %eax,%eax
8010264f:	75 f7                	jne    80102648 <iderw+0x68>
80102651:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102654:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102656:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010265c:	74 42                	je     801026a0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010265e:	8b 03                	mov    (%ebx),%eax
80102660:	83 e0 06             	and    $0x6,%eax
80102663:	83 f8 02             	cmp    $0x2,%eax
80102666:	74 23                	je     8010268b <iderw+0xab>
80102668:	90                   	nop
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102670:	83 ec 08             	sub    $0x8,%esp
80102673:	68 80 c5 10 80       	push   $0x8010c580
80102678:	53                   	push   %ebx
80102679:	e8 12 1e 00 00       	call   80104490 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010267e:	8b 03                	mov    (%ebx),%eax
80102680:	83 c4 10             	add    $0x10,%esp
80102683:	83 e0 06             	and    $0x6,%eax
80102686:	83 f8 02             	cmp    $0x2,%eax
80102689:	75 e5                	jne    80102670 <iderw+0x90>
  }


  release(&idelock);
8010268b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102695:	c9                   	leave  
  release(&idelock);
80102696:	e9 45 25 00 00       	jmp    80104be0 <release>
8010269b:	90                   	nop
8010269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801026a0:	89 d8                	mov    %ebx,%eax
801026a2:	e8 39 fd ff ff       	call   801023e0 <idestart>
801026a7:	eb b5                	jmp    8010265e <iderw+0x7e>
801026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026b0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801026b5:	eb 9d                	jmp    80102654 <iderw+0x74>
    panic("iderw: nothing to do");
801026b7:	83 ec 0c             	sub    $0xc,%esp
801026ba:	68 64 86 10 80       	push   $0x80108664
801026bf:	e8 cc dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801026c4:	83 ec 0c             	sub    $0xc,%esp
801026c7:	68 4e 86 10 80       	push   $0x8010864e
801026cc:	e8 bf dc ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801026d1:	83 ec 0c             	sub    $0xc,%esp
801026d4:	68 79 86 10 80       	push   $0x80108679
801026d9:	e8 b2 dc ff ff       	call   80100390 <panic>
801026de:	66 90                	xchg   %ax,%ax

801026e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801026e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801026e1:	c7 05 34 66 11 80 00 	movl   $0xfec00000,0x80116634
801026e8:	00 c0 fe 
{
801026eb:	89 e5                	mov    %esp,%ebp
801026ed:	56                   	push   %esi
801026ee:	53                   	push   %ebx
  ioapic->reg = reg;
801026ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801026f6:	00 00 00 
  return ioapic->data;
801026f9:	a1 34 66 11 80       	mov    0x80116634,%eax
801026fe:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102707:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010270d:	0f b6 15 80 67 11 80 	movzbl 0x80116780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102714:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102717:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010271a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010271d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102720:	39 c2                	cmp    %eax,%edx
80102722:	74 16                	je     8010273a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102724:	83 ec 0c             	sub    $0xc,%esp
80102727:	68 98 86 10 80       	push   $0x80108698
8010272c:	e8 2f df ff ff       	call   80100660 <cprintf>
80102731:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx
80102737:	83 c4 10             	add    $0x10,%esp
8010273a:	83 c3 21             	add    $0x21,%ebx
{
8010273d:	ba 10 00 00 00       	mov    $0x10,%edx
80102742:	b8 20 00 00 00       	mov    $0x20,%eax
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102750:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102752:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102758:	89 c6                	mov    %eax,%esi
8010275a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102760:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102763:	89 71 10             	mov    %esi,0x10(%ecx)
80102766:	8d 72 01             	lea    0x1(%edx),%esi
80102769:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010276c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010276e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102770:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx
80102776:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010277d:	75 d1                	jne    80102750 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010277f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102782:	5b                   	pop    %ebx
80102783:	5e                   	pop    %esi
80102784:	5d                   	pop    %ebp
80102785:	c3                   	ret    
80102786:	8d 76 00             	lea    0x0(%esi),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102790:	55                   	push   %ebp
  ioapic->reg = reg;
80102791:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx
{
80102797:	89 e5                	mov    %esp,%ebp
80102799:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010279c:	8d 50 20             	lea    0x20(%eax),%edx
8010279f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027a5:	8b 0d 34 66 11 80    	mov    0x80116634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027b6:	a1 34 66 11 80       	mov    0x80116634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027be:	89 50 10             	mov    %edx,0x10(%eax)
}
801027c1:	5d                   	pop    %ebp
801027c2:	c3                   	ret    
801027c3:	66 90                	xchg   %ax,%ax
801027c5:	66 90                	xchg   %ax,%ax
801027c7:	66 90                	xchg   %ax,%ax
801027c9:	66 90                	xchg   %ax,%ax
801027cb:	66 90                	xchg   %ax,%ax
801027cd:	66 90                	xchg   %ax,%ax
801027cf:	90                   	nop

801027d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	53                   	push   %ebx
801027d4:	83 ec 04             	sub    $0x4,%esp
801027d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027e0:	0f 85 7c 00 00 00    	jne    80102862 <kfree+0x92>
801027e6:	81 fb 18 ca 11 80    	cmp    $0x8011ca18,%ebx
801027ec:	72 74                	jb     80102862 <kfree+0x92>
801027ee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027f4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027f9:	77 67                	ja     80102862 <kfree+0x92>
    panic("kfree");

  if(kmem.use_lock)
801027fb:	8b 15 74 66 11 80    	mov    0x80116674,%edx
80102801:	85 d2                	test   %edx,%edx
80102803:	75 4b                	jne    80102850 <kfree+0x80>
    currentPages[pgindx].va = 0;
    currentPages[pgindx].refCounter = 0;
  }
*/
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102805:	83 ec 04             	sub    $0x4,%esp
80102808:	68 00 10 00 00       	push   $0x1000
8010280d:	6a 01                	push   $0x1
8010280f:	53                   	push   %ebx
80102810:	e8 1b 24 00 00       	call   80104c30 <memset>

  r = (struct run*)v;
  r->next = kmem.freelist;
80102815:	a1 78 66 11 80       	mov    0x80116678,%eax
  kmem.freelist = r;
  // Update free pages counter
  freePages++;
 
  if(kmem.use_lock)
8010281a:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
8010281d:	89 03                	mov    %eax,(%ebx)
  if(kmem.use_lock)
8010281f:	a1 74 66 11 80       	mov    0x80116674,%eax
  freePages++;
80102824:	83 05 80 66 11 80 01 	addl   $0x1,0x80116680
  kmem.freelist = r;
8010282b:	89 1d 78 66 11 80    	mov    %ebx,0x80116678
  if(kmem.use_lock)
80102831:	85 c0                	test   %eax,%eax
80102833:	75 0b                	jne    80102840 <kfree+0x70>
    release(&kmem.lock);

}
80102835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102838:	c9                   	leave  
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102840:	c7 45 08 40 66 11 80 	movl   $0x80116640,0x8(%ebp)
}
80102847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284a:	c9                   	leave  
    release(&kmem.lock);
8010284b:	e9 90 23 00 00       	jmp    80104be0 <release>
    acquire(&kmem.lock);
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	68 40 66 11 80       	push   $0x80116640
80102858:	e8 c3 22 00 00       	call   80104b20 <acquire>
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	eb a3                	jmp    80102805 <kfree+0x35>
    panic("kfree");
80102862:	83 ec 0c             	sub    $0xc,%esp
80102865:	68 ca 86 10 80       	push   $0x801086ca
8010286a:	e8 21 db ff ff       	call   80100390 <panic>
8010286f:	90                   	nop

80102870 <freerange>:
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	56                   	push   %esi
80102874:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102875:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102878:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010287b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102881:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102887:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010288d:	39 de                	cmp    %ebx,%esi
8010288f:	72 23                	jb     801028b4 <freerange+0x44>
80102891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102898:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010289e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028a7:	50                   	push   %eax
801028a8:	e8 23 ff ff ff       	call   801027d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	39 f3                	cmp    %esi,%ebx
801028b2:	76 e4                	jbe    80102898 <freerange+0x28>
}
801028b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b7:	5b                   	pop    %ebx
801028b8:	5e                   	pop    %esi
801028b9:	5d                   	pop    %ebp
801028ba:	c3                   	ret    
801028bb:	90                   	nop
801028bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028c0 <kinit1>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	57                   	push   %edi
801028c4:	56                   	push   %esi
801028c5:	53                   	push   %ebx
801028c6:	83 ec 14             	sub    $0x14,%esp
801028c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028cc:	68 d0 86 10 80       	push   $0x801086d0
801028d1:	68 40 66 11 80       	push   $0x80116640
801028d6:	e8 05 21 00 00       	call   801049e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028db:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028de:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028e1:	c7 05 74 66 11 80 00 	movl   $0x0,0x80116674
801028e8:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028eb:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
801028f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f7:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
801028fd:	39 de                	cmp    %ebx,%esi
801028ff:	72 23                	jb     80102924 <kinit1+0x64>
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102908:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010290e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102911:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102917:	50                   	push   %eax
80102918:	e8 b3 fe ff ff       	call   801027d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010291d:	83 c4 10             	add    $0x10,%esp
80102920:	39 de                	cmp    %ebx,%esi
80102922:	73 e4                	jae    80102908 <kinit1+0x48>
  totalPages = (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart))/PGSIZE;
80102924:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010292a:	b8 20 1f 11 80       	mov    $0x80111f20,%eax
8010292f:	29 fe                	sub    %edi,%esi
80102931:	c1 ee 0c             	shr    $0xc,%esi
80102934:	89 35 7c 66 11 80    	mov    %esi,0x8011667c
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    currentPages[i].pa = -1;
80102940:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    currentPages[i].refCounter = 0;
80102946:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010294d:	83 c0 08             	add    $0x8,%eax
  for(int i = 0; i < MAX_PAGES; i++){
80102950:	3d 20 3f 11 80       	cmp    $0x80113f20,%eax
80102955:	75 e9                	jne    80102940 <kinit1+0x80>
}
80102957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010295a:	5b                   	pop    %ebx
8010295b:	5e                   	pop    %esi
8010295c:	5f                   	pop    %edi
8010295d:	5d                   	pop    %ebp
8010295e:	c3                   	ret    
8010295f:	90                   	nop

80102960 <kinit2>:
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
80102966:	83 ec 0c             	sub    $0xc,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102969:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010296c:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010296f:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
80102975:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010297b:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
80102981:	39 de                	cmp    %ebx,%esi
80102983:	72 1f                	jb     801029a4 <kinit2+0x44>
80102985:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102988:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010298e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102997:	50                   	push   %eax
80102998:	e8 33 fe ff ff       	call   801027d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010299d:	83 c4 10             	add    $0x10,%esp
801029a0:	39 de                	cmp    %ebx,%esi
801029a2:	73 e4                	jae    80102988 <kinit2+0x28>
  totalPages += (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart))/PGSIZE;
801029a4:	89 f0                	mov    %esi,%eax
  kmem.use_lock = 1;
801029a6:	c7 05 74 66 11 80 01 	movl   $0x1,0x80116674
801029ad:	00 00 00 
  totalPages += (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart))/PGSIZE;
801029b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801029b5:	29 f8                	sub    %edi,%eax
801029b7:	c1 e8 0c             	shr    $0xc,%eax
801029ba:	03 05 7c 66 11 80    	add    0x8011667c,%eax
801029c0:	a3 7c 66 11 80       	mov    %eax,0x8011667c
  freePages = totalPages;
801029c5:	a3 80 66 11 80       	mov    %eax,0x80116680
}
801029ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029cd:	5b                   	pop    %ebx
801029ce:	5e                   	pop    %esi
801029cf:	5f                   	pop    %edi
801029d0:	5d                   	pop    %ebp
801029d1:	c3                   	ret    
801029d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801029e0:	a1 74 66 11 80       	mov    0x80116674,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	75 27                	jne    80102a10 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029e9:	a1 78 66 11 80       	mov    0x80116678,%eax
  if(r){
801029ee:	85 c0                	test   %eax,%eax
801029f0:	74 16                	je     80102a08 <kalloc+0x28>
    kmem.freelist = r->next;
801029f2:	8b 10                	mov    (%eax),%edx

    // Update free pages counter
    freePages--;
801029f4:	83 2d 80 66 11 80 01 	subl   $0x1,0x80116680
    kmem.freelist = r->next;
801029fb:	89 15 78 66 11 80    	mov    %edx,0x80116678
80102a01:	c3                   	ret    
80102a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    */
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102a08:	f3 c3                	repz ret 
80102a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102a16:	68 40 66 11 80       	push   $0x80116640
80102a1b:	e8 00 21 00 00       	call   80104b20 <acquire>
  r = kmem.freelist;
80102a20:	a1 78 66 11 80       	mov    0x80116678,%eax
  if(r){
80102a25:	83 c4 10             	add    $0x10,%esp
80102a28:	8b 15 74 66 11 80    	mov    0x80116674,%edx
80102a2e:	85 c0                	test   %eax,%eax
80102a30:	74 0f                	je     80102a41 <kalloc+0x61>
    kmem.freelist = r->next;
80102a32:	8b 08                	mov    (%eax),%ecx
    freePages--;
80102a34:	83 2d 80 66 11 80 01 	subl   $0x1,0x80116680
    kmem.freelist = r->next;
80102a3b:	89 0d 78 66 11 80    	mov    %ecx,0x80116678
  if(kmem.use_lock)
80102a41:	85 d2                	test   %edx,%edx
80102a43:	74 16                	je     80102a5b <kalloc+0x7b>
    release(&kmem.lock);
80102a45:	83 ec 0c             	sub    $0xc,%esp
80102a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a4b:	68 40 66 11 80       	push   $0x80116640
80102a50:	e8 8b 21 00 00       	call   80104be0 <release>
  return (char*)r;
80102a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a58:	83 c4 10             	add    $0x10,%esp
}
80102a5b:	c9                   	leave  
80102a5c:	c3                   	ret    
80102a5d:	8d 76 00             	lea    0x0(%esi),%esi

80102a60 <getNumberOfFreePages>:

int
getNumberOfFreePages(void){
80102a60:	55                   	push   %ebp
  return freePages;
}
80102a61:	a1 80 66 11 80       	mov    0x80116680,%eax
getNumberOfFreePages(void){
80102a66:	89 e5                	mov    %esp,%ebp
}
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a70 <getNumberOfTotalPages>:

int
getNumberOfTotalPages(void){
80102a70:	55                   	push   %ebp
  return totalPages;
}
80102a71:	a1 7c 66 11 80       	mov    0x8011667c,%eax
getNumberOfTotalPages(void){
80102a76:	89 e5                	mov    %esp,%ebp
}
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	66 90                	xchg   %ax,%ax
80102a7c:	66 90                	xchg   %ax,%ax
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	ba 64 00 00 00       	mov    $0x64,%edx
80102a85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a86:	a8 01                	test   $0x1,%al
80102a88:	0f 84 c2 00 00 00    	je     80102b50 <kbdgetc+0xd0>
80102a8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102a93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a94:	0f b6 d0             	movzbl %al,%edx
80102a97:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102a9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102aa3:	0f 84 7f 00 00 00    	je     80102b28 <kbdgetc+0xa8>
{
80102aa9:	55                   	push   %ebp
80102aaa:	89 e5                	mov    %esp,%ebp
80102aac:	53                   	push   %ebx
80102aad:	89 cb                	mov    %ecx,%ebx
80102aaf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ab2:	84 c0                	test   %al,%al
80102ab4:	78 4a                	js     80102b00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ab6:	85 db                	test   %ebx,%ebx
80102ab8:	74 09                	je     80102ac3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102aba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102abd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102ac0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102ac3:	0f b6 82 00 88 10 80 	movzbl -0x7fef7800(%edx),%eax
80102aca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102acc:	0f b6 82 00 87 10 80 	movzbl -0x7fef7900(%edx),%eax
80102ad3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ad5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102ad7:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102add:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ae0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ae3:	8b 04 85 e0 86 10 80 	mov    -0x7fef7920(,%eax,4),%eax
80102aea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102aee:	74 31                	je     80102b21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102af0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102af3:	83 fa 19             	cmp    $0x19,%edx
80102af6:	77 40                	ja     80102b38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102af8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102afb:	5b                   	pop    %ebx
80102afc:	5d                   	pop    %ebp
80102afd:	c3                   	ret    
80102afe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102b00:	83 e0 7f             	and    $0x7f,%eax
80102b03:	85 db                	test   %ebx,%ebx
80102b05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102b08:	0f b6 82 00 88 10 80 	movzbl -0x7fef7800(%edx),%eax
80102b0f:	83 c8 40             	or     $0x40,%eax
80102b12:	0f b6 c0             	movzbl %al,%eax
80102b15:	f7 d0                	not    %eax
80102b17:	21 c1                	and    %eax,%ecx
    return 0;
80102b19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102b1b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102b21:	5b                   	pop    %ebx
80102b22:	5d                   	pop    %ebp
80102b23:	c3                   	ret    
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102b28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102b2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b2d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102b33:	c3                   	ret    
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102b38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102b3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102b42:	0f 42 c2             	cmovb  %edx,%eax
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	89 f6                	mov    %esi,%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b55:	c3                   	ret    
80102b56:	8d 76 00             	lea    0x0(%esi),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <kbdintr>:

void
kbdintr(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b66:	68 80 2a 10 80       	push   $0x80102a80
80102b6b:	e8 a0 dc ff ff       	call   80100810 <consoleintr>
}
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	c9                   	leave  
80102b74:	c3                   	ret    
80102b75:	66 90                	xchg   %ax,%ax
80102b77:	66 90                	xchg   %ax,%ax
80102b79:	66 90                	xchg   %ax,%ax
80102b7b:	66 90                	xchg   %ax,%ax
80102b7d:	66 90                	xchg   %ax,%ax
80102b7f:	90                   	nop

80102b80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b80:	a1 84 66 11 80       	mov    0x80116684,%eax
{
80102b85:	55                   	push   %ebp
80102b86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	0f 84 c8 00 00 00    	je     80102c58 <lapicinit+0xd8>
  lapic[index] = value;
80102b90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ba4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102baa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102bb1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bbe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102bcb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102bd8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102bde:	8b 50 30             	mov    0x30(%eax),%edx
80102be1:	c1 ea 10             	shr    $0x10,%edx
80102be4:	80 fa 03             	cmp    $0x3,%dl
80102be7:	77 77                	ja     80102c60 <lapicinit+0xe0>
  lapic[index] = value;
80102be9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102bf0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bf6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bfd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c34:	8b 50 20             	mov    0x20(%eax),%edx
80102c37:	89 f6                	mov    %esi,%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c46:	80 e6 10             	and    $0x10,%dh
80102c49:	75 f5                	jne    80102c40 <lapicinit+0xc0>
  lapic[index] = value;
80102c4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c58:	5d                   	pop    %ebp
80102c59:	c3                   	ret    
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102c60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c6a:	8b 50 20             	mov    0x20(%eax),%edx
80102c6d:	e9 77 ff ff ff       	jmp    80102be9 <lapicinit+0x69>
80102c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c80:	8b 15 84 66 11 80    	mov    0x80116684,%edx
{
80102c86:	55                   	push   %ebp
80102c87:	31 c0                	xor    %eax,%eax
80102c89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102c8b:	85 d2                	test   %edx,%edx
80102c8d:	74 06                	je     80102c95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102c8f:	8b 42 20             	mov    0x20(%edx),%eax
80102c92:	c1 e8 18             	shr    $0x18,%eax
}
80102c95:	5d                   	pop    %ebp
80102c96:	c3                   	ret    
80102c97:	89 f6                	mov    %esi,%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ca0:	a1 84 66 11 80       	mov    0x80116684,%eax
{
80102ca5:	55                   	push   %ebp
80102ca6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ca8:	85 c0                	test   %eax,%eax
80102caa:	74 0d                	je     80102cb9 <lapiceoi+0x19>
  lapic[index] = value;
80102cac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102cb9:	5d                   	pop    %ebp
80102cba:	c3                   	ret    
80102cbb:	90                   	nop
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
}
80102cc3:	5d                   	pop    %ebp
80102cc4:	c3                   	ret    
80102cc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102cd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102cd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cdb:	89 e5                	mov    %esp,%ebp
80102cdd:	53                   	push   %ebx
80102cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ce1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ce4:	ee                   	out    %al,(%dx)
80102ce5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cea:	ba 71 00 00 00       	mov    $0x71,%edx
80102cef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102cf0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102cf2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102cf5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102cfb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cfd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102d00:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102d03:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d0e:	a1 84 66 11 80       	mov    0x80116684,%eax
80102d13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d5a:	5b                   	pop    %ebx
80102d5b:	5d                   	pop    %ebp
80102d5c:	c3                   	ret    
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi

80102d60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d60:	55                   	push   %ebp
80102d61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d66:	ba 70 00 00 00       	mov    $0x70,%edx
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	57                   	push   %edi
80102d6e:	56                   	push   %esi
80102d6f:	53                   	push   %ebx
80102d70:	83 ec 4c             	sub    $0x4c,%esp
80102d73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d74:	ba 71 00 00 00       	mov    $0x71,%edx
80102d79:	ec                   	in     (%dx),%al
80102d7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
80102d88:	31 c0                	xor    %eax,%eax
80102d8a:	89 da                	mov    %ebx,%edx
80102d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d92:	89 ca                	mov    %ecx,%edx
80102d94:	ec                   	in     (%dx),%al
80102d95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d98:	89 da                	mov    %ebx,%edx
80102d9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da0:	89 ca                	mov    %ecx,%edx
80102da2:	ec                   	in     (%dx),%al
80102da3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da6:	89 da                	mov    %ebx,%edx
80102da8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dae:	89 ca                	mov    %ecx,%edx
80102db0:	ec                   	in     (%dx),%al
80102db1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	89 da                	mov    %ebx,%edx
80102db6:	b8 07 00 00 00       	mov    $0x7,%eax
80102dbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbc:	89 ca                	mov    %ecx,%edx
80102dbe:	ec                   	in     (%dx),%al
80102dbf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc2:	89 da                	mov    %ebx,%edx
80102dc4:	b8 08 00 00 00       	mov    $0x8,%eax
80102dc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dca:	89 ca                	mov    %ecx,%edx
80102dcc:	ec                   	in     (%dx),%al
80102dcd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcf:	89 da                	mov    %ebx,%edx
80102dd1:	b8 09 00 00 00       	mov    $0x9,%eax
80102dd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd7:	89 ca                	mov    %ecx,%edx
80102dd9:	ec                   	in     (%dx),%al
80102dda:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ddc:	89 da                	mov    %ebx,%edx
80102dde:	b8 0a 00 00 00       	mov    $0xa,%eax
80102de3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de4:	89 ca                	mov    %ecx,%edx
80102de6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102de7:	84 c0                	test   %al,%al
80102de9:	78 9d                	js     80102d88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102deb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102def:	89 fa                	mov    %edi,%edx
80102df1:	0f b6 fa             	movzbl %dl,%edi
80102df4:	89 f2                	mov    %esi,%edx
80102df6:	0f b6 f2             	movzbl %dl,%esi
80102df9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e01:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e04:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e08:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e0b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e19:	31 c0                	xor    %eax,%eax
80102e1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e1c:	89 ca                	mov    %ecx,%edx
80102e1e:	ec                   	in     (%dx),%al
80102e1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e22:	89 da                	mov    %ebx,%edx
80102e24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e27:	b8 02 00 00 00       	mov    $0x2,%eax
80102e2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e2d:	89 ca                	mov    %ecx,%edx
80102e2f:	ec                   	in     (%dx),%al
80102e30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e33:	89 da                	mov    %ebx,%edx
80102e35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e38:	b8 04 00 00 00       	mov    $0x4,%eax
80102e3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3e:	89 ca                	mov    %ecx,%edx
80102e40:	ec                   	in     (%dx),%al
80102e41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e44:	89 da                	mov    %ebx,%edx
80102e46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e49:	b8 07 00 00 00       	mov    $0x7,%eax
80102e4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4f:	89 ca                	mov    %ecx,%edx
80102e51:	ec                   	in     (%dx),%al
80102e52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e55:	89 da                	mov    %ebx,%edx
80102e57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e60:	89 ca                	mov    %ecx,%edx
80102e62:	ec                   	in     (%dx),%al
80102e63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e66:	89 da                	mov    %ebx,%edx
80102e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e71:	89 ca                	mov    %ecx,%edx
80102e73:	ec                   	in     (%dx),%al
80102e74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e80:	6a 18                	push   $0x18
80102e82:	50                   	push   %eax
80102e83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e86:	50                   	push   %eax
80102e87:	e8 f4 1d 00 00       	call   80104c80 <memcmp>
80102e8c:	83 c4 10             	add    $0x10,%esp
80102e8f:	85 c0                	test   %eax,%eax
80102e91:	0f 85 f1 fe ff ff    	jne    80102d88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e9b:	75 78                	jne    80102f15 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ea0:	89 c2                	mov    %eax,%edx
80102ea2:	83 e0 0f             	and    $0xf,%eax
80102ea5:	c1 ea 04             	shr    $0x4,%edx
80102ea8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102eb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102eb4:	89 c2                	mov    %eax,%edx
80102eb6:	83 e0 0f             	and    $0xf,%eax
80102eb9:	c1 ea 04             	shr    $0x4,%edx
80102ebc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ec2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ec5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ec8:	89 c2                	mov    %eax,%edx
80102eca:	83 e0 0f             	and    $0xf,%eax
80102ecd:	c1 ea 04             	shr    $0x4,%edx
80102ed0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ed3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ed6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ed9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102edc:	89 c2                	mov    %eax,%edx
80102ede:	83 e0 0f             	and    $0xf,%eax
80102ee1:	c1 ea 04             	shr    $0x4,%edx
80102ee4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ee7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102eed:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ef0:	89 c2                	mov    %eax,%edx
80102ef2:	83 e0 0f             	and    $0xf,%eax
80102ef5:	c1 ea 04             	shr    $0x4,%edx
80102ef8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102efb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102efe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f01:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f04:	89 c2                	mov    %eax,%edx
80102f06:	83 e0 0f             	and    $0xf,%eax
80102f09:	c1 ea 04             	shr    $0x4,%edx
80102f0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f12:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f15:	8b 75 08             	mov    0x8(%ebp),%esi
80102f18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f1b:	89 06                	mov    %eax,(%esi)
80102f1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f20:	89 46 04             	mov    %eax,0x4(%esi)
80102f23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f26:	89 46 08             	mov    %eax,0x8(%esi)
80102f29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f2c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f32:	89 46 10             	mov    %eax,0x10(%esi)
80102f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f38:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f3b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f45:	5b                   	pop    %ebx
80102f46:	5e                   	pop    %esi
80102f47:	5f                   	pop    %edi
80102f48:	5d                   	pop    %ebp
80102f49:	c3                   	ret    
80102f4a:	66 90                	xchg   %ax,%ax
80102f4c:	66 90                	xchg   %ax,%ax
80102f4e:	66 90                	xchg   %ax,%ax

80102f50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f50:	8b 0d e8 66 11 80    	mov    0x801166e8,%ecx
80102f56:	85 c9                	test   %ecx,%ecx
80102f58:	0f 8e 8a 00 00 00    	jle    80102fe8 <install_trans+0x98>
{
80102f5e:	55                   	push   %ebp
80102f5f:	89 e5                	mov    %esp,%ebp
80102f61:	57                   	push   %edi
80102f62:	56                   	push   %esi
80102f63:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f64:	31 db                	xor    %ebx,%ebx
{
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f70:	a1 d4 66 11 80       	mov    0x801166d4,%eax
80102f75:	83 ec 08             	sub    $0x8,%esp
80102f78:	01 d8                	add    %ebx,%eax
80102f7a:	83 c0 01             	add    $0x1,%eax
80102f7d:	50                   	push   %eax
80102f7e:	ff 35 e4 66 11 80    	pushl  0x801166e4
80102f84:	e8 47 d1 ff ff       	call   801000d0 <bread>
80102f89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f8b:	58                   	pop    %eax
80102f8c:	5a                   	pop    %edx
80102f8d:	ff 34 9d ec 66 11 80 	pushl  -0x7fee9914(,%ebx,4)
80102f94:	ff 35 e4 66 11 80    	pushl  0x801166e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f9d:	e8 2e d1 ff ff       	call   801000d0 <bread>
80102fa2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fa4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102fa7:	83 c4 0c             	add    $0xc,%esp
80102faa:	68 00 02 00 00       	push   $0x200
80102faf:	50                   	push   %eax
80102fb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fb3:	50                   	push   %eax
80102fb4:	e8 27 1d 00 00       	call   80104ce0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fb9:	89 34 24             	mov    %esi,(%esp)
80102fbc:	e8 df d1 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102fc1:	89 3c 24             	mov    %edi,(%esp)
80102fc4:	e8 17 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 0f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	39 1d e8 66 11 80    	cmp    %ebx,0x801166e8
80102fda:	7f 94                	jg     80102f70 <install_trans+0x20>
  }
}
80102fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdf:	5b                   	pop    %ebx
80102fe0:	5e                   	pop    %esi
80102fe1:	5f                   	pop    %edi
80102fe2:	5d                   	pop    %ebp
80102fe3:	c3                   	ret    
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	f3 c3                	repz ret 
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ff0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	56                   	push   %esi
80102ff4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	ff 35 d4 66 11 80    	pushl  0x801166d4
80102ffe:	ff 35 e4 66 11 80    	pushl  0x801166e4
80103004:	e8 c7 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103009:	8b 1d e8 66 11 80    	mov    0x801166e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010300f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103012:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103014:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103016:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103019:	7e 16                	jle    80103031 <write_head+0x41>
8010301b:	c1 e3 02             	shl    $0x2,%ebx
8010301e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103020:	8b 8a ec 66 11 80    	mov    -0x7fee9914(%edx),%ecx
80103026:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010302a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010302d:	39 da                	cmp    %ebx,%edx
8010302f:	75 ef                	jne    80103020 <write_head+0x30>
  }
  bwrite(buf);
80103031:	83 ec 0c             	sub    $0xc,%esp
80103034:	56                   	push   %esi
80103035:	e8 66 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010303a:	89 34 24             	mov    %esi,(%esp)
8010303d:	e8 9e d1 ff ff       	call   801001e0 <brelse>
}
80103042:	83 c4 10             	add    $0x10,%esp
80103045:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103048:	5b                   	pop    %ebx
80103049:	5e                   	pop    %esi
8010304a:	5d                   	pop    %ebp
8010304b:	c3                   	ret    
8010304c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103050 <initlog>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 2c             	sub    $0x2c,%esp
80103057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010305a:	68 00 89 10 80       	push   $0x80108900
8010305f:	68 a0 66 11 80       	push   $0x801166a0
80103064:	e8 77 19 00 00       	call   801049e0 <initlock>
  readsb(dev, &sb);
80103069:	58                   	pop    %eax
8010306a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010306d:	5a                   	pop    %edx
8010306e:	50                   	push   %eax
8010306f:	53                   	push   %ebx
80103070:	e8 fb e4 ff ff       	call   80101570 <readsb>
  log.size = sb.nlog;
80103075:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010307b:	59                   	pop    %ecx
  log.dev = dev;
8010307c:	89 1d e4 66 11 80    	mov    %ebx,0x801166e4
  log.size = sb.nlog;
80103082:	89 15 d8 66 11 80    	mov    %edx,0x801166d8
  log.start = sb.logstart;
80103088:	a3 d4 66 11 80       	mov    %eax,0x801166d4
  struct buf *buf = bread(log.dev, log.start);
8010308d:	5a                   	pop    %edx
8010308e:	50                   	push   %eax
8010308f:	53                   	push   %ebx
80103090:	e8 3b d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103095:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010309d:	89 1d e8 66 11 80    	mov    %ebx,0x801166e8
  for (i = 0; i < log.lh.n; i++) {
801030a3:	7e 1c                	jle    801030c1 <initlog+0x71>
801030a5:	c1 e3 02             	shl    $0x2,%ebx
801030a8:	31 d2                	xor    %edx,%edx
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801030b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801030b4:	83 c2 04             	add    $0x4,%edx
801030b7:	89 8a e8 66 11 80    	mov    %ecx,-0x7fee9918(%edx)
  for (i = 0; i < log.lh.n; i++) {
801030bd:	39 d3                	cmp    %edx,%ebx
801030bf:	75 ef                	jne    801030b0 <initlog+0x60>
  brelse(buf);
801030c1:	83 ec 0c             	sub    $0xc,%esp
801030c4:	50                   	push   %eax
801030c5:	e8 16 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030ca:	e8 81 fe ff ff       	call   80102f50 <install_trans>
  log.lh.n = 0;
801030cf:	c7 05 e8 66 11 80 00 	movl   $0x0,0x801166e8
801030d6:	00 00 00 
  write_head(); // clear the log
801030d9:	e8 12 ff ff ff       	call   80102ff0 <write_head>
}
801030de:	83 c4 10             	add    $0x10,%esp
801030e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030e4:	c9                   	leave  
801030e5:	c3                   	ret    
801030e6:	8d 76 00             	lea    0x0(%esi),%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030f6:	68 a0 66 11 80       	push   $0x801166a0
801030fb:	e8 20 1a 00 00       	call   80104b20 <acquire>
80103100:	83 c4 10             	add    $0x10,%esp
80103103:	eb 18                	jmp    8010311d <begin_op+0x2d>
80103105:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103108:	83 ec 08             	sub    $0x8,%esp
8010310b:	68 a0 66 11 80       	push   $0x801166a0
80103110:	68 a0 66 11 80       	push   $0x801166a0
80103115:	e8 76 13 00 00       	call   80104490 <sleep>
8010311a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010311d:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80103122:	85 c0                	test   %eax,%eax
80103124:	75 e2                	jne    80103108 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103126:	a1 dc 66 11 80       	mov    0x801166dc,%eax
8010312b:	8b 15 e8 66 11 80    	mov    0x801166e8,%edx
80103131:	83 c0 01             	add    $0x1,%eax
80103134:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103137:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010313a:	83 fa 1e             	cmp    $0x1e,%edx
8010313d:	7f c9                	jg     80103108 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010313f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103142:	a3 dc 66 11 80       	mov    %eax,0x801166dc
      release(&log.lock);
80103147:	68 a0 66 11 80       	push   $0x801166a0
8010314c:	e8 8f 1a 00 00       	call   80104be0 <release>
      break;
    }
  }
}
80103151:	83 c4 10             	add    $0x10,%esp
80103154:	c9                   	leave  
80103155:	c3                   	ret    
80103156:	8d 76 00             	lea    0x0(%esi),%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103160 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103169:	68 a0 66 11 80       	push   $0x801166a0
8010316e:	e8 ad 19 00 00       	call   80104b20 <acquire>
  log.outstanding -= 1;
80103173:	a1 dc 66 11 80       	mov    0x801166dc,%eax
  if(log.committing)
80103178:	8b 35 e0 66 11 80    	mov    0x801166e0,%esi
8010317e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103181:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103184:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103186:	89 1d dc 66 11 80    	mov    %ebx,0x801166dc
  if(log.committing)
8010318c:	0f 85 1a 01 00 00    	jne    801032ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103192:	85 db                	test   %ebx,%ebx
80103194:	0f 85 ee 00 00 00    	jne    80103288 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010319a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010319d:	c7 05 e0 66 11 80 01 	movl   $0x1,0x801166e0
801031a4:	00 00 00 
  release(&log.lock);
801031a7:	68 a0 66 11 80       	push   $0x801166a0
801031ac:	e8 2f 1a 00 00       	call   80104be0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031b1:	8b 0d e8 66 11 80    	mov    0x801166e8,%ecx
801031b7:	83 c4 10             	add    $0x10,%esp
801031ba:	85 c9                	test   %ecx,%ecx
801031bc:	0f 8e 85 00 00 00    	jle    80103247 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031c2:	a1 d4 66 11 80       	mov    0x801166d4,%eax
801031c7:	83 ec 08             	sub    $0x8,%esp
801031ca:	01 d8                	add    %ebx,%eax
801031cc:	83 c0 01             	add    $0x1,%eax
801031cf:	50                   	push   %eax
801031d0:	ff 35 e4 66 11 80    	pushl  0x801166e4
801031d6:	e8 f5 ce ff ff       	call   801000d0 <bread>
801031db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031dd:	58                   	pop    %eax
801031de:	5a                   	pop    %edx
801031df:	ff 34 9d ec 66 11 80 	pushl  -0x7fee9914(,%ebx,4)
801031e6:	ff 35 e4 66 11 80    	pushl  0x801166e4
  for (tail = 0; tail < log.lh.n; tail++) {
801031ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ef:	e8 dc ce ff ff       	call   801000d0 <bread>
801031f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801031f9:	83 c4 0c             	add    $0xc,%esp
801031fc:	68 00 02 00 00       	push   $0x200
80103201:	50                   	push   %eax
80103202:	8d 46 5c             	lea    0x5c(%esi),%eax
80103205:	50                   	push   %eax
80103206:	e8 d5 1a 00 00       	call   80104ce0 <memmove>
    bwrite(to);  // write the log
8010320b:	89 34 24             	mov    %esi,(%esp)
8010320e:	e8 8d cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103213:	89 3c 24             	mov    %edi,(%esp)
80103216:	e8 c5 cf ff ff       	call   801001e0 <brelse>
    brelse(to);
8010321b:	89 34 24             	mov    %esi,(%esp)
8010321e:	e8 bd cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103223:	83 c4 10             	add    $0x10,%esp
80103226:	3b 1d e8 66 11 80    	cmp    0x801166e8,%ebx
8010322c:	7c 94                	jl     801031c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010322e:	e8 bd fd ff ff       	call   80102ff0 <write_head>
    install_trans(); // Now install writes to home locations
80103233:	e8 18 fd ff ff       	call   80102f50 <install_trans>
    log.lh.n = 0;
80103238:	c7 05 e8 66 11 80 00 	movl   $0x0,0x801166e8
8010323f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103242:	e8 a9 fd ff ff       	call   80102ff0 <write_head>
    acquire(&log.lock);
80103247:	83 ec 0c             	sub    $0xc,%esp
8010324a:	68 a0 66 11 80       	push   $0x801166a0
8010324f:	e8 cc 18 00 00       	call   80104b20 <acquire>
    wakeup(&log);
80103254:	c7 04 24 a0 66 11 80 	movl   $0x801166a0,(%esp)
    log.committing = 0;
8010325b:	c7 05 e0 66 11 80 00 	movl   $0x0,0x801166e0
80103262:	00 00 00 
    wakeup(&log);
80103265:	e8 46 14 00 00       	call   801046b0 <wakeup>
    release(&log.lock);
8010326a:	c7 04 24 a0 66 11 80 	movl   $0x801166a0,(%esp)
80103271:	e8 6a 19 00 00       	call   80104be0 <release>
80103276:	83 c4 10             	add    $0x10,%esp
}
80103279:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327c:	5b                   	pop    %ebx
8010327d:	5e                   	pop    %esi
8010327e:	5f                   	pop    %edi
8010327f:	5d                   	pop    %ebp
80103280:	c3                   	ret    
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103288:	83 ec 0c             	sub    $0xc,%esp
8010328b:	68 a0 66 11 80       	push   $0x801166a0
80103290:	e8 1b 14 00 00       	call   801046b0 <wakeup>
  release(&log.lock);
80103295:	c7 04 24 a0 66 11 80 	movl   $0x801166a0,(%esp)
8010329c:	e8 3f 19 00 00       	call   80104be0 <release>
801032a1:	83 c4 10             	add    $0x10,%esp
}
801032a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032a7:	5b                   	pop    %ebx
801032a8:	5e                   	pop    %esi
801032a9:	5f                   	pop    %edi
801032aa:	5d                   	pop    %ebp
801032ab:	c3                   	ret    
    panic("log.committing");
801032ac:	83 ec 0c             	sub    $0xc,%esp
801032af:	68 04 89 10 80       	push   $0x80108904
801032b4:	e8 d7 d0 ff ff       	call   80100390 <panic>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	53                   	push   %ebx
801032c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032c7:	8b 15 e8 66 11 80    	mov    0x801166e8,%edx
{
801032cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032d0:	83 fa 1d             	cmp    $0x1d,%edx
801032d3:	0f 8f 9d 00 00 00    	jg     80103376 <log_write+0xb6>
801032d9:	a1 d8 66 11 80       	mov    0x801166d8,%eax
801032de:	83 e8 01             	sub    $0x1,%eax
801032e1:	39 c2                	cmp    %eax,%edx
801032e3:	0f 8d 8d 00 00 00    	jge    80103376 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032e9:	a1 dc 66 11 80       	mov    0x801166dc,%eax
801032ee:	85 c0                	test   %eax,%eax
801032f0:	0f 8e 8d 00 00 00    	jle    80103383 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	68 a0 66 11 80       	push   $0x801166a0
801032fe:	e8 1d 18 00 00       	call   80104b20 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103303:	8b 0d e8 66 11 80    	mov    0x801166e8,%ecx
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	83 f9 00             	cmp    $0x0,%ecx
8010330f:	7e 57                	jle    80103368 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103311:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103314:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103316:	3b 15 ec 66 11 80    	cmp    0x801166ec,%edx
8010331c:	75 0b                	jne    80103329 <log_write+0x69>
8010331e:	eb 38                	jmp    80103358 <log_write+0x98>
80103320:	39 14 85 ec 66 11 80 	cmp    %edx,-0x7fee9914(,%eax,4)
80103327:	74 2f                	je     80103358 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103329:	83 c0 01             	add    $0x1,%eax
8010332c:	39 c1                	cmp    %eax,%ecx
8010332e:	75 f0                	jne    80103320 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103330:	89 14 85 ec 66 11 80 	mov    %edx,-0x7fee9914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103337:	83 c0 01             	add    $0x1,%eax
8010333a:	a3 e8 66 11 80       	mov    %eax,0x801166e8
  b->flags |= B_DIRTY; // prevent eviction
8010333f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103342:	c7 45 08 a0 66 11 80 	movl   $0x801166a0,0x8(%ebp)
}
80103349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010334c:	c9                   	leave  
  release(&log.lock);
8010334d:	e9 8e 18 00 00       	jmp    80104be0 <release>
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103358:	89 14 85 ec 66 11 80 	mov    %edx,-0x7fee9914(,%eax,4)
8010335f:	eb de                	jmp    8010333f <log_write+0x7f>
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103368:	8b 43 08             	mov    0x8(%ebx),%eax
8010336b:	a3 ec 66 11 80       	mov    %eax,0x801166ec
  if (i == log.lh.n)
80103370:	75 cd                	jne    8010333f <log_write+0x7f>
80103372:	31 c0                	xor    %eax,%eax
80103374:	eb c1                	jmp    80103337 <log_write+0x77>
    panic("too big a transaction");
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	68 13 89 10 80       	push   $0x80108913
8010337e:	e8 0d d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103383:	83 ec 0c             	sub    $0xc,%esp
80103386:	68 29 89 10 80       	push   $0x80108929
8010338b:	e8 00 d0 ff ff       	call   80100390 <panic>

80103390 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	53                   	push   %ebx
80103394:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103397:	e8 f4 09 00 00       	call   80103d90 <cpuid>
8010339c:	89 c3                	mov    %eax,%ebx
8010339e:	e8 ed 09 00 00       	call   80103d90 <cpuid>
801033a3:	83 ec 04             	sub    $0x4,%esp
801033a6:	53                   	push   %ebx
801033a7:	50                   	push   %eax
801033a8:	68 44 89 10 80       	push   $0x80108944
801033ad:	e8 ae d2 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801033b2:	e8 69 2b 00 00       	call   80105f20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033b7:	e8 54 09 00 00       	call   80103d10 <mycpu>
801033bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033be:	b8 01 00 00 00       	mov    $0x1,%eax
801033c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033ca:	e8 b1 0d 00 00       	call   80104180 <scheduler>
801033cf:	90                   	nop

801033d0 <mpenter>:
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033d6:	e8 f5 3f 00 00       	call   801073d0 <switchkvm>
  seginit();
801033db:	e8 60 3f 00 00       	call   80107340 <seginit>
  lapicinit();
801033e0:	e8 9b f7 ff ff       	call   80102b80 <lapicinit>
  mpmain();
801033e5:	e8 a6 ff ff ff       	call   80103390 <mpmain>
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <main>:
{
801033f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033f4:	83 e4 f0             	and    $0xfffffff0,%esp
801033f7:	ff 71 fc             	pushl  -0x4(%ecx)
801033fa:	55                   	push   %ebp
801033fb:	89 e5                	mov    %esp,%ebp
801033fd:	53                   	push   %ebx
801033fe:	51                   	push   %ecx
  currlockinit();  // initillize currentPages lock
801033ff:	e8 1c 3f 00 00       	call   80107320 <currlockinit>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103404:	83 ec 08             	sub    $0x8,%esp
80103407:	68 00 00 40 80       	push   $0x80400000
8010340c:	68 18 ca 11 80       	push   $0x8011ca18
80103411:	e8 aa f4 ff ff       	call   801028c0 <kinit1>
  kvmalloc();      // kernel page table
80103416:	e8 f5 47 00 00       	call   80107c10 <kvmalloc>
  mpinit();        // detect other processors
8010341b:	e8 70 01 00 00       	call   80103590 <mpinit>
  lapicinit();     // interrupt controller
80103420:	e8 5b f7 ff ff       	call   80102b80 <lapicinit>
  seginit();       // segment descriptors
80103425:	e8 16 3f 00 00       	call   80107340 <seginit>
  picinit();       // disable pic
8010342a:	e8 41 03 00 00       	call   80103770 <picinit>
  ioapicinit();    // another interrupt controller
8010342f:	e8 ac f2 ff ff       	call   801026e0 <ioapicinit>
  consoleinit();   // console hardware
80103434:	e8 87 d5 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103439:	e8 92 2e 00 00       	call   801062d0 <uartinit>
  pinit();         // process table
8010343e:	e8 ad 08 00 00       	call   80103cf0 <pinit>
  tvinit();        // trap vectors
80103443:	e8 58 2a 00 00       	call   80105ea0 <tvinit>
  binit();         // buffer cache
80103448:	e8 f3 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010344d:	e8 3e da ff ff       	call   80100e90 <fileinit>
  ideinit();       // disk 
80103452:	e8 69 f0 ff ff       	call   801024c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103457:	83 c4 0c             	add    $0xc,%esp
8010345a:	68 8a 00 00 00       	push   $0x8a
8010345f:	68 8c c4 10 80       	push   $0x8010c48c
80103464:	68 00 70 00 80       	push   $0x80007000
80103469:	e8 72 18 00 00       	call   80104ce0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010346e:	69 05 20 6d 11 80 b0 	imul   $0xb0,0x80116d20,%eax
80103475:	00 00 00 
80103478:	83 c4 10             	add    $0x10,%esp
8010347b:	05 a0 67 11 80       	add    $0x801167a0,%eax
80103480:	3d a0 67 11 80       	cmp    $0x801167a0,%eax
80103485:	76 6c                	jbe    801034f3 <main+0x103>
80103487:	bb a0 67 11 80       	mov    $0x801167a0,%ebx
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103490:	e8 7b 08 00 00       	call   80103d10 <mycpu>
80103495:	39 d8                	cmp    %ebx,%eax
80103497:	74 41                	je     801034da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103499:	e8 42 f5 ff ff       	call   801029e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010349e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801034a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801033d0,0x80006ff8
801034aa:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034ad:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801034b4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801034bc:	0f b6 03             	movzbl (%ebx),%eax
801034bf:	83 ec 08             	sub    $0x8,%esp
801034c2:	68 00 70 00 00       	push   $0x7000
801034c7:	50                   	push   %eax
801034c8:	e8 03 f8 ff ff       	call   80102cd0 <lapicstartap>
801034cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034d6:	85 c0                	test   %eax,%eax
801034d8:	74 f6                	je     801034d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801034da:	69 05 20 6d 11 80 b0 	imul   $0xb0,0x80116d20,%eax
801034e1:	00 00 00 
801034e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801034ea:	05 a0 67 11 80       	add    $0x801167a0,%eax
801034ef:	39 c3                	cmp    %eax,%ebx
801034f1:	72 9d                	jb     80103490 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034f3:	83 ec 08             	sub    $0x8,%esp
801034f6:	68 00 00 00 8e       	push   $0x8e000000
801034fb:	68 00 00 40 80       	push   $0x80400000
80103500:	e8 5b f4 ff ff       	call   80102960 <kinit2>
  userinit();      // first user process
80103505:	e8 d6 08 00 00       	call   80103de0 <userinit>
  mpmain();        // finish this processor's setup
8010350a:	e8 81 fe ff ff       	call   80103390 <mpmain>
8010350f:	90                   	nop

80103510 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103515:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010351b:	53                   	push   %ebx
  e = addr+len;
8010351c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010351f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103522:	39 de                	cmp    %ebx,%esi
80103524:	72 10                	jb     80103536 <mpsearch1+0x26>
80103526:	eb 50                	jmp    80103578 <mpsearch1+0x68>
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103530:	39 fb                	cmp    %edi,%ebx
80103532:	89 fe                	mov    %edi,%esi
80103534:	76 42                	jbe    80103578 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103536:	83 ec 04             	sub    $0x4,%esp
80103539:	8d 7e 10             	lea    0x10(%esi),%edi
8010353c:	6a 04                	push   $0x4
8010353e:	68 58 89 10 80       	push   $0x80108958
80103543:	56                   	push   %esi
80103544:	e8 37 17 00 00       	call   80104c80 <memcmp>
80103549:	83 c4 10             	add    $0x10,%esp
8010354c:	85 c0                	test   %eax,%eax
8010354e:	75 e0                	jne    80103530 <mpsearch1+0x20>
80103550:	89 f1                	mov    %esi,%ecx
80103552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103558:	0f b6 11             	movzbl (%ecx),%edx
8010355b:	83 c1 01             	add    $0x1,%ecx
8010355e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103560:	39 f9                	cmp    %edi,%ecx
80103562:	75 f4                	jne    80103558 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103564:	84 c0                	test   %al,%al
80103566:	75 c8                	jne    80103530 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356b:	89 f0                	mov    %esi,%eax
8010356d:	5b                   	pop    %ebx
8010356e:	5e                   	pop    %esi
8010356f:	5f                   	pop    %edi
80103570:	5d                   	pop    %ebp
80103571:	c3                   	ret    
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010357b:	31 f6                	xor    %esi,%esi
}
8010357d:	89 f0                	mov    %esi,%eax
8010357f:	5b                   	pop    %ebx
80103580:	5e                   	pop    %esi
80103581:	5f                   	pop    %edi
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
80103584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010358a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103590 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103599:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035a7:	c1 e0 08             	shl    $0x8,%eax
801035aa:	09 d0                	or     %edx,%eax
801035ac:	c1 e0 04             	shl    $0x4,%eax
801035af:	85 c0                	test   %eax,%eax
801035b1:	75 1b                	jne    801035ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035c1:	c1 e0 08             	shl    $0x8,%eax
801035c4:	09 d0                	or     %edx,%eax
801035c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035ce:	ba 00 04 00 00       	mov    $0x400,%edx
801035d3:	e8 38 ff ff ff       	call   80103510 <mpsearch1>
801035d8:	85 c0                	test   %eax,%eax
801035da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035dd:	0f 84 3d 01 00 00    	je     80103720 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e6:	8b 58 04             	mov    0x4(%eax),%ebx
801035e9:	85 db                	test   %ebx,%ebx
801035eb:	0f 84 4f 01 00 00    	je     80103740 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801035f7:	83 ec 04             	sub    $0x4,%esp
801035fa:	6a 04                	push   $0x4
801035fc:	68 75 89 10 80       	push   $0x80108975
80103601:	56                   	push   %esi
80103602:	e8 79 16 00 00       	call   80104c80 <memcmp>
80103607:	83 c4 10             	add    $0x10,%esp
8010360a:	85 c0                	test   %eax,%eax
8010360c:	0f 85 2e 01 00 00    	jne    80103740 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103612:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103619:	3c 01                	cmp    $0x1,%al
8010361b:	0f 95 c2             	setne  %dl
8010361e:	3c 04                	cmp    $0x4,%al
80103620:	0f 95 c0             	setne  %al
80103623:	20 c2                	and    %al,%dl
80103625:	0f 85 15 01 00 00    	jne    80103740 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010362b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103632:	66 85 ff             	test   %di,%di
80103635:	74 1a                	je     80103651 <mpinit+0xc1>
80103637:	89 f0                	mov    %esi,%eax
80103639:	01 f7                	add    %esi,%edi
  sum = 0;
8010363b:	31 d2                	xor    %edx,%edx
8010363d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103640:	0f b6 08             	movzbl (%eax),%ecx
80103643:	83 c0 01             	add    $0x1,%eax
80103646:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103648:	39 c7                	cmp    %eax,%edi
8010364a:	75 f4                	jne    80103640 <mpinit+0xb0>
8010364c:	84 d2                	test   %dl,%dl
8010364e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103651:	85 f6                	test   %esi,%esi
80103653:	0f 84 e7 00 00 00    	je     80103740 <mpinit+0x1b0>
80103659:	84 d2                	test   %dl,%dl
8010365b:	0f 85 df 00 00 00    	jne    80103740 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103661:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103667:	a3 84 66 11 80       	mov    %eax,0x80116684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010366c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103673:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103679:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010367e:	01 d6                	add    %edx,%esi
80103680:	39 c6                	cmp    %eax,%esi
80103682:	76 23                	jbe    801036a7 <mpinit+0x117>
    switch(*p){
80103684:	0f b6 10             	movzbl (%eax),%edx
80103687:	80 fa 04             	cmp    $0x4,%dl
8010368a:	0f 87 ca 00 00 00    	ja     8010375a <mpinit+0x1ca>
80103690:	ff 24 95 9c 89 10 80 	jmp    *-0x7fef7664(,%edx,4)
80103697:	89 f6                	mov    %esi,%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801036a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036a3:	39 c6                	cmp    %eax,%esi
801036a5:	77 dd                	ja     80103684 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801036a7:	85 db                	test   %ebx,%ebx
801036a9:	0f 84 9e 00 00 00    	je     8010374d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801036b6:	74 15                	je     801036cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036b8:	b8 70 00 00 00       	mov    $0x70,%eax
801036bd:	ba 22 00 00 00       	mov    $0x22,%edx
801036c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036c3:	ba 23 00 00 00       	mov    $0x23,%edx
801036c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801036c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036cc:	ee                   	out    %al,(%dx)
  }
}
801036cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d0:	5b                   	pop    %ebx
801036d1:	5e                   	pop    %esi
801036d2:	5f                   	pop    %edi
801036d3:	5d                   	pop    %ebp
801036d4:	c3                   	ret    
801036d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801036d8:	8b 0d 20 6d 11 80    	mov    0x80116d20,%ecx
801036de:	83 f9 07             	cmp    $0x7,%ecx
801036e1:	7f 19                	jg     801036fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801036e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801036ed:	83 c1 01             	add    $0x1,%ecx
801036f0:	89 0d 20 6d 11 80    	mov    %ecx,0x80116d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036f6:	88 97 a0 67 11 80    	mov    %dl,-0x7fee9860(%edi)
      p += sizeof(struct mpproc);
801036fc:	83 c0 14             	add    $0x14,%eax
      continue;
801036ff:	e9 7c ff ff ff       	jmp    80103680 <mpinit+0xf0>
80103704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103708:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010370c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010370f:	88 15 80 67 11 80    	mov    %dl,0x80116780
      continue;
80103715:	e9 66 ff ff ff       	jmp    80103680 <mpinit+0xf0>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103720:	ba 00 00 01 00       	mov    $0x10000,%edx
80103725:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010372a:	e8 e1 fd ff ff       	call   80103510 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010372f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103734:	0f 85 a9 fe ff ff    	jne    801035e3 <mpinit+0x53>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 5d 89 10 80       	push   $0x8010895d
80103748:	e8 43 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	68 7c 89 10 80       	push   $0x8010897c
80103755:	e8 36 cc ff ff       	call   80100390 <panic>
      ismp = 0;
8010375a:	31 db                	xor    %ebx,%ebx
8010375c:	e9 26 ff ff ff       	jmp    80103687 <mpinit+0xf7>
80103761:	66 90                	xchg   %ax,%ax
80103763:	66 90                	xchg   %ax,%ax
80103765:	66 90                	xchg   %ax,%ax
80103767:	66 90                	xchg   %ax,%ax
80103769:	66 90                	xchg   %ax,%ax
8010376b:	66 90                	xchg   %ax,%ax
8010376d:	66 90                	xchg   %ax,%ax
8010376f:	90                   	nop

80103770 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103770:	55                   	push   %ebp
80103771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103776:	ba 21 00 00 00       	mov    $0x21,%edx
8010377b:	89 e5                	mov    %esp,%ebp
8010377d:	ee                   	out    %al,(%dx)
8010377e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103783:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103784:	5d                   	pop    %ebp
80103785:	c3                   	ret    
80103786:	66 90                	xchg   %ax,%ax
80103788:	66 90                	xchg   %ax,%ax
8010378a:	66 90                	xchg   %ax,%ax
8010378c:	66 90                	xchg   %ax,%ax
8010378e:	66 90                	xchg   %ax,%ax

80103790 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 0c             	sub    $0xc,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010379c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010379f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801037a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801037ab:	e8 00 d7 ff ff       	call   80100eb0 <filealloc>
801037b0:	85 c0                	test   %eax,%eax
801037b2:	89 03                	mov    %eax,(%ebx)
801037b4:	74 22                	je     801037d8 <pipealloc+0x48>
801037b6:	e8 f5 d6 ff ff       	call   80100eb0 <filealloc>
801037bb:	85 c0                	test   %eax,%eax
801037bd:	89 06                	mov    %eax,(%esi)
801037bf:	74 3f                	je     80103800 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037c1:	e8 1a f2 ff ff       	call   801029e0 <kalloc>
801037c6:	85 c0                	test   %eax,%eax
801037c8:	89 c7                	mov    %eax,%edi
801037ca:	75 54                	jne    80103820 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801037cc:	8b 03                	mov    (%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 34                	jne    80103806 <pipealloc+0x76>
801037d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801037d8:	8b 06                	mov    (%esi),%eax
801037da:	85 c0                	test   %eax,%eax
801037dc:	74 0c                	je     801037ea <pipealloc+0x5a>
    fileclose(*f1);
801037de:	83 ec 0c             	sub    $0xc,%esp
801037e1:	50                   	push   %eax
801037e2:	e8 89 d7 ff ff       	call   80100f70 <fileclose>
801037e7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801037ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037f2:	5b                   	pop    %ebx
801037f3:	5e                   	pop    %esi
801037f4:	5f                   	pop    %edi
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103800:	8b 03                	mov    (%ebx),%eax
80103802:	85 c0                	test   %eax,%eax
80103804:	74 e4                	je     801037ea <pipealloc+0x5a>
    fileclose(*f0);
80103806:	83 ec 0c             	sub    $0xc,%esp
80103809:	50                   	push   %eax
8010380a:	e8 61 d7 ff ff       	call   80100f70 <fileclose>
  if(*f1)
8010380f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103811:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103814:	85 c0                	test   %eax,%eax
80103816:	75 c6                	jne    801037de <pipealloc+0x4e>
80103818:	eb d0                	jmp    801037ea <pipealloc+0x5a>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103820:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103823:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010382a:	00 00 00 
  p->writeopen = 1;
8010382d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103834:	00 00 00 
  p->nwrite = 0;
80103837:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010383e:	00 00 00 
  p->nread = 0;
80103841:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103848:	00 00 00 
  initlock(&p->lock, "pipe");
8010384b:	68 b0 89 10 80       	push   $0x801089b0
80103850:	50                   	push   %eax
80103851:	e8 8a 11 00 00       	call   801049e0 <initlock>
  (*f0)->type = FD_PIPE;
80103856:	8b 03                	mov    (%ebx),%eax
  return 0;
80103858:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010385b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103861:	8b 03                	mov    (%ebx),%eax
80103863:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103867:	8b 03                	mov    (%ebx),%eax
80103869:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010386d:	8b 03                	mov    (%ebx),%eax
8010386f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103872:	8b 06                	mov    (%esi),%eax
80103874:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010387a:	8b 06                	mov    (%esi),%eax
8010387c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103880:	8b 06                	mov    (%esi),%eax
80103882:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103886:	8b 06                	mov    (%esi),%eax
80103888:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010388b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010388e:	31 c0                	xor    %eax,%eax
}
80103890:	5b                   	pop    %ebx
80103891:	5e                   	pop    %esi
80103892:	5f                   	pop    %edi
80103893:	5d                   	pop    %ebp
80103894:	c3                   	ret    
80103895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801038ab:	83 ec 0c             	sub    $0xc,%esp
801038ae:	53                   	push   %ebx
801038af:	e8 6c 12 00 00       	call   80104b20 <acquire>
  if(writable){
801038b4:	83 c4 10             	add    $0x10,%esp
801038b7:	85 f6                	test   %esi,%esi
801038b9:	74 45                	je     80103900 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801038bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038c1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801038c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038cb:	00 00 00 
    wakeup(&p->nread);
801038ce:	50                   	push   %eax
801038cf:	e8 dc 0d 00 00       	call   801046b0 <wakeup>
801038d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038dd:	85 d2                	test   %edx,%edx
801038df:	75 0a                	jne    801038eb <pipeclose+0x4b>
801038e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038e7:	85 c0                	test   %eax,%eax
801038e9:	74 35                	je     80103920 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f1:	5b                   	pop    %ebx
801038f2:	5e                   	pop    %esi
801038f3:	5d                   	pop    %ebp
    release(&p->lock);
801038f4:	e9 e7 12 00 00       	jmp    80104be0 <release>
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103900:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103906:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103909:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103910:	00 00 00 
    wakeup(&p->nwrite);
80103913:	50                   	push   %eax
80103914:	e8 97 0d 00 00       	call   801046b0 <wakeup>
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	eb b9                	jmp    801038d7 <pipeclose+0x37>
8010391e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103920:	83 ec 0c             	sub    $0xc,%esp
80103923:	53                   	push   %ebx
80103924:	e8 b7 12 00 00       	call   80104be0 <release>
    kfree((char*)p);
80103929:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010392c:	83 c4 10             	add    $0x10,%esp
}
8010392f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103932:	5b                   	pop    %ebx
80103933:	5e                   	pop    %esi
80103934:	5d                   	pop    %ebp
    kfree((char*)p);
80103935:	e9 96 ee ff ff       	jmp    801027d0 <kfree>
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103940 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 28             	sub    $0x28,%esp
80103949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010394c:	53                   	push   %ebx
8010394d:	e8 ce 11 00 00       	call   80104b20 <acquire>
  for(i = 0; i < n; i++){
80103952:	8b 45 10             	mov    0x10(%ebp),%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	0f 8e c9 00 00 00    	jle    80103a29 <pipewrite+0xe9>
80103960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103963:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103969:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010396f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103972:	03 4d 10             	add    0x10(%ebp),%ecx
80103975:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103978:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010397e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103984:	39 d0                	cmp    %edx,%eax
80103986:	75 71                	jne    801039f9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103988:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010398e:	85 c0                	test   %eax,%eax
80103990:	74 4e                	je     801039e0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103992:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103998:	eb 3a                	jmp    801039d4 <pipewrite+0x94>
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	57                   	push   %edi
801039a4:	e8 07 0d 00 00       	call   801046b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039a9:	5a                   	pop    %edx
801039aa:	59                   	pop    %ecx
801039ab:	53                   	push   %ebx
801039ac:	56                   	push   %esi
801039ad:	e8 de 0a 00 00       	call   80104490 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039b2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039b8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039be:	83 c4 10             	add    $0x10,%esp
801039c1:	05 00 02 00 00       	add    $0x200,%eax
801039c6:	39 c2                	cmp    %eax,%edx
801039c8:	75 36                	jne    80103a00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801039ca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039d0:	85 c0                	test   %eax,%eax
801039d2:	74 0c                	je     801039e0 <pipewrite+0xa0>
801039d4:	e8 d7 03 00 00       	call   80103db0 <myproc>
801039d9:	8b 40 24             	mov    0x24(%eax),%eax
801039dc:	85 c0                	test   %eax,%eax
801039de:	74 c0                	je     801039a0 <pipewrite+0x60>
        release(&p->lock);
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	53                   	push   %ebx
801039e4:	e8 f7 11 00 00       	call   80104be0 <release>
        return -1;
801039e9:	83 c4 10             	add    $0x10,%esp
801039ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f4:	5b                   	pop    %ebx
801039f5:	5e                   	pop    %esi
801039f6:	5f                   	pop    %edi
801039f7:	5d                   	pop    %ebp
801039f8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039f9:	89 c2                	mov    %eax,%edx
801039fb:	90                   	nop
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a03:	8d 42 01             	lea    0x1(%edx),%eax
80103a06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a0c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103a12:	83 c6 01             	add    $0x1,%esi
80103a15:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103a19:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a1c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a1f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a23:	0f 85 4f ff ff ff    	jne    80103978 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a29:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a2f:	83 ec 0c             	sub    $0xc,%esp
80103a32:	50                   	push   %eax
80103a33:	e8 78 0c 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
80103a38:	89 1c 24             	mov    %ebx,(%esp)
80103a3b:	e8 a0 11 00 00       	call   80104be0 <release>
  return n;
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	8b 45 10             	mov    0x10(%ebp),%eax
80103a46:	eb a9                	jmp    801039f1 <pipewrite+0xb1>
80103a48:	90                   	nop
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 18             	sub    $0x18,%esp
80103a59:	8b 75 08             	mov    0x8(%ebp),%esi
80103a5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a5f:	56                   	push   %esi
80103a60:	e8 bb 10 00 00       	call   80104b20 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a6e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a74:	75 6a                	jne    80103ae0 <piperead+0x90>
80103a76:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103a7c:	85 db                	test   %ebx,%ebx
80103a7e:	0f 84 c4 00 00 00    	je     80103b48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a8a:	eb 2d                	jmp    80103ab9 <piperead+0x69>
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a90:	83 ec 08             	sub    $0x8,%esp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	e8 f6 09 00 00       	call   80104490 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a9a:	83 c4 10             	add    $0x10,%esp
80103a9d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103aa3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103aa9:	75 35                	jne    80103ae0 <piperead+0x90>
80103aab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103ab1:	85 d2                	test   %edx,%edx
80103ab3:	0f 84 8f 00 00 00    	je     80103b48 <piperead+0xf8>
    if(myproc()->killed){
80103ab9:	e8 f2 02 00 00       	call   80103db0 <myproc>
80103abe:	8b 48 24             	mov    0x24(%eax),%ecx
80103ac1:	85 c9                	test   %ecx,%ecx
80103ac3:	74 cb                	je     80103a90 <piperead+0x40>
      release(&p->lock);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ac8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103acd:	56                   	push   %esi
80103ace:	e8 0d 11 00 00       	call   80104be0 <release>
      return -1;
80103ad3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad9:	89 d8                	mov    %ebx,%eax
80103adb:	5b                   	pop    %ebx
80103adc:	5e                   	pop    %esi
80103add:	5f                   	pop    %edi
80103ade:	5d                   	pop    %ebp
80103adf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	7e 61                	jle    80103b48 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103ae7:	31 db                	xor    %ebx,%ebx
80103ae9:	eb 13                	jmp    80103afe <piperead+0xae>
80103aeb:	90                   	nop
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103af6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103afc:	74 1f                	je     80103b1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103afe:	8d 41 01             	lea    0x1(%ecx),%eax
80103b01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103b07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103b0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103b12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b15:	83 c3 01             	add    $0x1,%ebx
80103b18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103b1b:	75 d3                	jne    80103af0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b23:	83 ec 0c             	sub    $0xc,%esp
80103b26:	50                   	push   %eax
80103b27:	e8 84 0b 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
80103b2c:	89 34 24             	mov    %esi,(%esp)
80103b2f:	e8 ac 10 00 00       	call   80104be0 <release>
  return i;
80103b34:	83 c4 10             	add    $0x10,%esp
}
80103b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3a:	89 d8                	mov    %ebx,%eax
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b48:	31 db                	xor    %ebx,%ebx
80103b4a:	eb d1                	jmp    80103b1d <piperead+0xcd>
80103b4c:	66 90                	xchg   %ax,%ax
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b54:	bb 74 6d 11 80       	mov    $0x80116d74,%ebx
{
80103b59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b5c:	68 40 6d 11 80       	push   $0x80116d40
80103b61:	e8 ba 0f 00 00       	call   80104b20 <acquire>
80103b66:	83 c4 10             	add    $0x10,%esp
80103b69:	eb 17                	jmp    80103b82 <allocproc+0x32>
80103b6b:	90                   	nop
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b70:	81 c3 50 01 00 00    	add    $0x150,%ebx
80103b76:	81 fb 74 c1 11 80    	cmp    $0x8011c174,%ebx
80103b7c:	0f 83 f6 00 00 00    	jae    80103c78 <allocproc+0x128>
    if(p->state == UNUSED)
80103b82:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b85:	85 c0                	test   %eax,%eax
80103b87:	75 e7                	jne    80103b70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b89:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103b8e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b91:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b98:	8d 50 01             	lea    0x1(%eax),%edx
80103b9b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103b9e:	68 40 6d 11 80       	push   $0x80116d40
  p->pid = nextpid++;
80103ba3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103ba9:	e8 32 10 00 00       	call   80104be0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103bae:	e8 2d ee ff ff       	call   801029e0 <kalloc>
80103bb3:	83 c4 10             	add    $0x10,%esp
80103bb6:	85 c0                	test   %eax,%eax
80103bb8:	89 43 08             	mov    %eax,0x8(%ebx)
80103bbb:	0f 84 d0 00 00 00    	je     80103c91 <allocproc+0x141>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103bc1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103bc7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bca:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bcf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bd2:	c7 40 14 8a 5e 10 80 	movl   $0x80105e8a,0x14(%eax)
  p->context = (struct context*)sp;
80103bd9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bdc:	6a 14                	push   $0x14
80103bde:	6a 00                	push   $0x0
80103be0:	50                   	push   %eax
80103be1:	e8 4a 10 00 00       	call   80104c30 <memset>
  p->context->eip = (uint)forkret;
80103be6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be9:	83 c4 10             	add    $0x10,%esp
80103bec:	c7 40 10 a0 3c 10 80 	movl   $0x80103ca0,0x10(%eax)

  // Initilize fields
  for(int i = 0; i < 16; i++){
80103bf3:	31 c0                	xor    %eax,%eax
80103bf5:	8d 76 00             	lea    0x0(%esi),%esi
    p->swapPages[i] = -1;
80103bf8:	c7 84 83 80 00 00 00 	movl   $0xffffffff,0x80(%ebx,%eax,4)
80103bff:	ff ff ff ff 
    p->ramPages[i].va = -1;
80103c03:	c7 84 c3 c0 00 00 00 	movl   $0xffffffff,0xc0(%ebx,%eax,8)
80103c0a:	ff ff ff ff 
    p->ramPages[i].counter = 0;
80103c0e:	c7 84 c3 c4 00 00 00 	movl   $0x0,0xc4(%ebx,%eax,8)
80103c15:	00 00 00 00 
  for(int i = 0; i < 16; i++){
80103c19:	83 c0 01             	add    $0x1,%eax
80103c1c:	83 f8 10             	cmp    $0x10,%eax
80103c1f:	75 d7                	jne    80103bf8 <allocproc+0xa8>
  // struct pageLink *oldLink;
  // while(currLink != 0){}

  // p->pageQueue = malloc(sizeof(struct pageLink));

  if(p->pid > 2)
80103c21:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  p->ramCounter = 0;
80103c25:	c7 83 40 01 00 00 00 	movl   $0x0,0x140(%ebx)
80103c2c:	00 00 00 
  p->swapCounter = 0;
80103c2f:	c7 83 44 01 00 00 00 	movl   $0x0,0x144(%ebx)
80103c36:	00 00 00 
  p->pageFaults = 0;
80103c39:	c7 83 48 01 00 00 00 	movl   $0x0,0x148(%ebx)
80103c40:	00 00 00 
  p->totalPagedOut = 0;
80103c43:	c7 83 4c 01 00 00 00 	movl   $0x0,0x14c(%ebx)
80103c4a:	00 00 00 
  if(p->pid > 2)
80103c4d:	7f 11                	jg     80103c60 <allocproc+0x110>
    createSwapFile(p);

  return p;
}
80103c4f:	89 d8                	mov    %ebx,%eax
80103c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c54:	c9                   	leave  
80103c55:	c3                   	ret    
80103c56:	8d 76 00             	lea    0x0(%esi),%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    createSwapFile(p);
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	53                   	push   %ebx
80103c64:	e8 77 e6 ff ff       	call   801022e0 <createSwapFile>
}
80103c69:	89 d8                	mov    %ebx,%eax
    createSwapFile(p);
80103c6b:	83 c4 10             	add    $0x10,%esp
}
80103c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c71:	c9                   	leave  
80103c72:	c3                   	ret    
80103c73:	90                   	nop
80103c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103c78:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c7b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c7d:	68 40 6d 11 80       	push   $0x80116d40
80103c82:	e8 59 0f 00 00       	call   80104be0 <release>
}
80103c87:	89 d8                	mov    %ebx,%eax
  return 0;
80103c89:	83 c4 10             	add    $0x10,%esp
}
80103c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c8f:	c9                   	leave  
80103c90:	c3                   	ret    
    p->state = UNUSED;
80103c91:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c98:	31 db                	xor    %ebx,%ebx
80103c9a:	eb b3                	jmp    80103c4f <allocproc+0xff>
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ca6:	68 40 6d 11 80       	push   $0x80116d40
80103cab:	e8 30 0f 00 00       	call   80104be0 <release>

  if (first) {
80103cb0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	85 c0                	test   %eax,%eax
80103cba:	75 04                	jne    80103cc0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103cbc:	c9                   	leave  
80103cbd:	c3                   	ret    
80103cbe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103cc0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103cc3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103cca:	00 00 00 
    iinit(ROOTDEV);
80103ccd:	6a 01                	push   $0x1
80103ccf:	e8 dc d8 ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
80103cd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103cdb:	e8 70 f3 ff ff       	call   80103050 <initlog>
80103ce0:	83 c4 10             	add    $0x10,%esp
}
80103ce3:	c9                   	leave  
80103ce4:	c3                   	ret    
80103ce5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <pinit>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103cf6:	68 b5 89 10 80       	push   $0x801089b5
80103cfb:	68 40 6d 11 80       	push   $0x80116d40
80103d00:	e8 db 0c 00 00       	call   801049e0 <initlock>
}
80103d05:	83 c4 10             	add    $0x10,%esp
80103d08:	c9                   	leave  
80103d09:	c3                   	ret    
80103d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d10 <mycpu>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d15:	9c                   	pushf  
80103d16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d17:	f6 c4 02             	test   $0x2,%ah
80103d1a:	75 5e                	jne    80103d7a <mycpu+0x6a>
  apicid = lapicid();
80103d1c:	e8 5f ef ff ff       	call   80102c80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d21:	8b 35 20 6d 11 80    	mov    0x80116d20,%esi
80103d27:	85 f6                	test   %esi,%esi
80103d29:	7e 42                	jle    80103d6d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d2b:	0f b6 15 a0 67 11 80 	movzbl 0x801167a0,%edx
80103d32:	39 d0                	cmp    %edx,%eax
80103d34:	74 30                	je     80103d66 <mycpu+0x56>
80103d36:	b9 50 68 11 80       	mov    $0x80116850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103d3b:	31 d2                	xor    %edx,%edx
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
80103d40:	83 c2 01             	add    $0x1,%edx
80103d43:	39 f2                	cmp    %esi,%edx
80103d45:	74 26                	je     80103d6d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d47:	0f b6 19             	movzbl (%ecx),%ebx
80103d4a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d50:	39 c3                	cmp    %eax,%ebx
80103d52:	75 ec                	jne    80103d40 <mycpu+0x30>
80103d54:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d5a:	05 a0 67 11 80       	add    $0x801167a0,%eax
}
80103d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d62:	5b                   	pop    %ebx
80103d63:	5e                   	pop    %esi
80103d64:	5d                   	pop    %ebp
80103d65:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103d66:	b8 a0 67 11 80       	mov    $0x801167a0,%eax
      return &cpus[i];
80103d6b:	eb f2                	jmp    80103d5f <mycpu+0x4f>
  panic("unknown apicid\n");
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	68 bc 89 10 80       	push   $0x801089bc
80103d75:	e8 16 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 a4 8a 10 80       	push   $0x80108aa4
80103d82:	e8 09 c6 ff ff       	call   80100390 <panic>
80103d87:	89 f6                	mov    %esi,%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <cpuid>:
cpuid() {
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d96:	e8 75 ff ff ff       	call   80103d10 <mycpu>
80103d9b:	2d a0 67 11 80       	sub    $0x801167a0,%eax
}
80103da0:	c9                   	leave  
  return mycpu()-cpus;
80103da1:	c1 f8 04             	sar    $0x4,%eax
80103da4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103daa:	c3                   	ret    
80103dab:	90                   	nop
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <myproc>:
myproc(void) {
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103db7:	e8 94 0c 00 00       	call   80104a50 <pushcli>
  c = mycpu();
80103dbc:	e8 4f ff ff ff       	call   80103d10 <mycpu>
  p = c->proc;
80103dc1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc7:	e8 c4 0c 00 00       	call   80104a90 <popcli>
}
80103dcc:	83 c4 04             	add    $0x4,%esp
80103dcf:	89 d8                	mov    %ebx,%eax
80103dd1:	5b                   	pop    %ebx
80103dd2:	5d                   	pop    %ebp
80103dd3:	c3                   	ret    
80103dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103de0 <userinit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103de7:	e8 64 fd ff ff       	call   80103b50 <allocproc>
80103dec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103dee:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80103df3:	e8 98 3d 00 00       	call   80107b90 <setupkvm>
80103df8:	85 c0                	test   %eax,%eax
80103dfa:	89 43 04             	mov    %eax,0x4(%ebx)
80103dfd:	0f 84 bd 00 00 00    	je     80103ec0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e03:	83 ec 04             	sub    $0x4,%esp
80103e06:	68 2c 00 00 00       	push   $0x2c
80103e0b:	68 60 c4 10 80       	push   $0x8010c460
80103e10:	50                   	push   %eax
80103e11:	e8 ea 36 00 00       	call   80107500 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e1f:	6a 4c                	push   $0x4c
80103e21:	6a 00                	push   $0x0
80103e23:	ff 73 18             	pushl  0x18(%ebx)
80103e26:	e8 05 0e 00 00       	call   80104c30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e33:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e38:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e46:	8b 43 18             	mov    0x18(%ebx),%eax
80103e49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e51:	8b 43 18             	mov    0x18(%ebx),%eax
80103e54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e66:	8b 43 18             	mov    0x18(%ebx),%eax
80103e69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e70:	8b 43 18             	mov    0x18(%ebx),%eax
80103e73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	68 e5 89 10 80       	push   $0x801089e5
80103e84:	50                   	push   %eax
80103e85:	e8 86 0f 00 00       	call   80104e10 <safestrcpy>
  p->cwd = namei("/");
80103e8a:	c7 04 24 ee 89 10 80 	movl   $0x801089ee,(%esp)
80103e91:	e8 7a e1 ff ff       	call   80102010 <namei>
80103e96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e99:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
80103ea0:	e8 7b 0c 00 00       	call   80104b20 <acquire>
  p->state = RUNNABLE;
80103ea5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103eac:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
80103eb3:	e8 28 0d 00 00       	call   80104be0 <release>
}
80103eb8:	83 c4 10             	add    $0x10,%esp
80103ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ebe:	c9                   	leave  
80103ebf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	68 cc 89 10 80       	push   $0x801089cc
80103ec8:	e8 c3 c4 ff ff       	call   80100390 <panic>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi

80103ed0 <growproc>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	56                   	push   %esi
80103ed4:	53                   	push   %ebx
80103ed5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ed8:	e8 73 0b 00 00       	call   80104a50 <pushcli>
  c = mycpu();
80103edd:	e8 2e fe ff ff       	call   80103d10 <mycpu>
  p = c->proc;
80103ee2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ee8:	e8 a3 0b 00 00       	call   80104a90 <popcli>
  if(n > 0){
80103eed:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ef0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ef2:	7f 1c                	jg     80103f10 <growproc+0x40>
  } else if(n < 0){
80103ef4:	75 3a                	jne    80103f30 <growproc+0x60>
  switchuvm(curproc);
80103ef6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ef9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103efb:	53                   	push   %ebx
80103efc:	e8 ef 34 00 00       	call   801073f0 <switchuvm>
  return 0;
80103f01:	83 c4 10             	add    $0x10,%esp
80103f04:	31 c0                	xor    %eax,%eax
}
80103f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f09:	5b                   	pop    %ebx
80103f0a:	5e                   	pop    %esi
80103f0b:	5d                   	pop    %ebp
80103f0c:	c3                   	ret    
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f10:	83 ec 04             	sub    $0x4,%esp
80103f13:	01 c6                	add    %eax,%esi
80103f15:	56                   	push   %esi
80103f16:	50                   	push   %eax
80103f17:	ff 73 04             	pushl  0x4(%ebx)
80103f1a:	e8 11 3a 00 00       	call   80107930 <allocuvm>
80103f1f:	83 c4 10             	add    $0x10,%esp
80103f22:	85 c0                	test   %eax,%eax
80103f24:	75 d0                	jne    80103ef6 <growproc+0x26>
      return -1;
80103f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2b:	eb d9                	jmp    80103f06 <growproc+0x36>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f30:	83 ec 04             	sub    $0x4,%esp
80103f33:	01 c6                	add    %eax,%esi
80103f35:	56                   	push   %esi
80103f36:	50                   	push   %eax
80103f37:	ff 73 04             	pushl  0x4(%ebx)
80103f3a:	e8 01 37 00 00       	call   80107640 <deallocuvm>
80103f3f:	83 c4 10             	add    $0x10,%esp
80103f42:	85 c0                	test   %eax,%eax
80103f44:	75 b0                	jne    80103ef6 <growproc+0x26>
80103f46:	eb de                	jmp    80103f26 <growproc+0x56>
80103f48:	90                   	nop
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f50 <fork>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
80103f5c:	e8 ef 0a 00 00       	call   80104a50 <pushcli>
  c = mycpu();
80103f61:	e8 aa fd ff ff       	call   80103d10 <mycpu>
  p = c->proc;
80103f66:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f6c:	e8 1f 0b 00 00       	call   80104a90 <popcli>
  if((np = allocproc()) == 0){
80103f71:	e8 da fb ff ff       	call   80103b50 <allocproc>
80103f76:	85 c0                	test   %eax,%eax
80103f78:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
80103f7e:	0f 84 b3 01 00 00    	je     80104137 <fork+0x1e7>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f84:	83 ec 08             	sub    $0x8,%esp
80103f87:	ff 33                	pushl  (%ebx)
80103f89:	ff 73 04             	pushl  0x4(%ebx)
80103f8c:	e8 cf 3c 00 00       	call   80107c60 <copyuvm>
80103f91:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
80103f97:	83 c4 10             	add    $0x10,%esp
80103f9a:	85 c0                	test   %eax,%eax
80103f9c:	89 42 04             	mov    %eax,0x4(%edx)
80103f9f:	0f 84 9e 01 00 00    	je     80104143 <fork+0x1f3>
  np->sz = curproc->sz;
80103fa5:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103fa7:	8b 7a 18             	mov    0x18(%edx),%edi
80103faa:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103faf:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80103fb2:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103fb4:	8b 73 18             	mov    0x18(%ebx),%esi
80103fb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103fb9:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103fbb:	8b 42 18             	mov    0x18(%edx),%eax
80103fbe:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103fc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103fc8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103fcc:	85 c0                	test   %eax,%eax
80103fce:	74 1c                	je     80103fec <fork+0x9c>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80103fd9:	50                   	push   %eax
80103fda:	e8 41 cf ff ff       	call   80100f20 <filedup>
80103fdf:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
80103fe5:	83 c4 10             	add    $0x10,%esp
80103fe8:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103fec:	83 c6 01             	add    $0x1,%esi
80103fef:	83 fe 10             	cmp    $0x10,%esi
80103ff2:	75 d4                	jne    80103fc8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	ff 73 68             	pushl  0x68(%ebx)
80103ffa:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80104000:	e8 7b d7 ff ff       	call   80101780 <idup>
80104005:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010400b:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010400e:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104011:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104014:	6a 10                	push   $0x10
80104016:	50                   	push   %eax
80104017:	8d 42 6c             	lea    0x6c(%edx),%eax
8010401a:	50                   	push   %eax
8010401b:	e8 f0 0d 00 00       	call   80104e10 <safestrcpy>
  pid = np->pid;
80104020:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
  if(curproc->swapFile != 0){
80104026:	83 c4 10             	add    $0x10,%esp
  pid = np->pid;
80104029:	8b 42 10             	mov    0x10(%edx),%eax
8010402c:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
  if(curproc->swapFile != 0){
80104032:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104035:	85 c0                	test   %eax,%eax
80104037:	0f 84 bd 00 00 00    	je     801040fa <fork+0x1aa>
    char buf[PGSIZE/2] = "";
8010403d:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104043:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104048:	31 c0                	xor    %eax,%eax
8010404a:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104051:	00 00 00 
    while(readFromSwapFile(curproc, buf, i*(PGSIZE/2), PGSIZE/2) != 0){
80104054:	31 f6                	xor    %esi,%esi
    char buf[PGSIZE/2] = "";
80104056:	f3 ab                	rep stos %eax,%es:(%edi)
80104058:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
    while(readFromSwapFile(curproc, buf, i*(PGSIZE/2), PGSIZE/2) != 0){
8010405e:	eb 2a                	jmp    8010408a <fork+0x13a>
      if(writeToSwapFile(np, buf, i*(PGSIZE/2), PGSIZE/2) < 0)
80104060:	68 00 08 00 00       	push   $0x800
80104065:	56                   	push   %esi
80104066:	81 c6 00 08 00 00    	add    $0x800,%esi
8010406c:	57                   	push   %edi
8010406d:	52                   	push   %edx
8010406e:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80104074:	e8 07 e3 ff ff       	call   80102380 <writeToSwapFile>
80104079:	83 c4 10             	add    $0x10,%esp
8010407c:	85 c0                	test   %eax,%eax
8010407e:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
80104084:	0f 88 e7 00 00 00    	js     80104171 <fork+0x221>
    while(readFromSwapFile(curproc, buf, i*(PGSIZE/2), PGSIZE/2) != 0){
8010408a:	68 00 08 00 00       	push   $0x800
8010408f:	56                   	push   %esi
80104090:	57                   	push   %edi
80104091:	53                   	push   %ebx
80104092:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80104098:	e8 13 e3 ff ff       	call   801023b0 <readFromSwapFile>
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	85 c0                	test   %eax,%eax
801040a2:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
801040a8:	75 b6                	jne    80104060 <fork+0x110>
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      np->ramPages[j].va = curproc->ramPages[j].va;
801040b0:	8b 8c c3 c0 00 00 00 	mov    0xc0(%ebx,%eax,8),%ecx
801040b7:	89 8c c2 c0 00 00 00 	mov    %ecx,0xc0(%edx,%eax,8)
      np->ramPages[j].counter = curproc->ramPages[j].counter;
801040be:	8b 8c c3 c4 00 00 00 	mov    0xc4(%ebx,%eax,8),%ecx
801040c5:	89 8c c2 c4 00 00 00 	mov    %ecx,0xc4(%edx,%eax,8)
      np->swapPages[j] = curproc->swapPages[j];
801040cc:	8b 8c 83 80 00 00 00 	mov    0x80(%ebx,%eax,4),%ecx
801040d3:	89 8c 82 80 00 00 00 	mov    %ecx,0x80(%edx,%eax,4)
    for(int j = 0; j < 16; j++){
801040da:	83 c0 01             	add    $0x1,%eax
801040dd:	83 f8 10             	cmp    $0x10,%eax
801040e0:	75 ce                	jne    801040b0 <fork+0x160>
    np->swapCounter = curproc->swapCounter;
801040e2:	8b 83 44 01 00 00    	mov    0x144(%ebx),%eax
801040e8:	89 82 44 01 00 00    	mov    %eax,0x144(%edx)
    np->ramCounter = curproc->ramCounter;
801040ee:	8b 83 40 01 00 00    	mov    0x140(%ebx),%eax
801040f4:	89 82 40 01 00 00    	mov    %eax,0x140(%edx)
  acquire(&ptable.lock);
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80104103:	68 40 6d 11 80       	push   $0x80116d40
80104108:	e8 13 0a 00 00       	call   80104b20 <acquire>
  np->state = RUNNABLE;
8010410d:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
80104113:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
8010411a:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
80104121:	e8 ba 0a 00 00       	call   80104be0 <release>
  return pid;
80104126:	83 c4 10             	add    $0x10,%esp
}
80104129:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
8010412f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5f                   	pop    %edi
80104135:	5d                   	pop    %ebp
80104136:	c3                   	ret    
    return -1;
80104137:	c7 85 e0 f7 ff ff ff 	movl   $0xffffffff,-0x820(%ebp)
8010413e:	ff ff ff 
80104141:	eb e6                	jmp    80104129 <fork+0x1d9>
    kfree(np->kstack);
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	ff 72 08             	pushl  0x8(%edx)
80104149:	e8 82 e6 ff ff       	call   801027d0 <kfree>
    np->kstack = 0;
8010414e:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
    return -1;
80104154:	83 c4 10             	add    $0x10,%esp
80104157:	c7 85 e0 f7 ff ff ff 	movl   $0xffffffff,-0x820(%ebp)
8010415e:	ff ff ff 
    np->kstack = 0;
80104161:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104168:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
8010416f:	eb b8                	jmp    80104129 <fork+0x1d9>
        panic("fork: couldnt write to swap file");
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	68 cc 8a 10 80       	push   $0x80108acc
80104179:	e8 12 c2 ff ff       	call   80100390 <panic>
8010417e:	66 90                	xchg   %ax,%ax

80104180 <scheduler>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104189:	e8 82 fb ff ff       	call   80103d10 <mycpu>
8010418e:	8d 78 04             	lea    0x4(%eax),%edi
80104191:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104193:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010419a:	00 00 00 
  isSchedActive = 1;
8010419d:	c7 05 ac 3f 11 80 01 	movl   $0x1,0x80113fac
801041a4:	00 00 00 
801041a7:	89 f6                	mov    %esi,%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  asm volatile("sti");
801041b0:	fb                   	sti    
    acquire(&ptable.lock);
801041b1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b4:	bb 74 6d 11 80       	mov    $0x80116d74,%ebx
    acquire(&ptable.lock);
801041b9:	68 40 6d 11 80       	push   $0x80116d40
801041be:	e8 5d 09 00 00       	call   80104b20 <acquire>
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801041d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041d4:	75 33                	jne    80104209 <scheduler+0x89>
      switchuvm(p);
801041d6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801041d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801041df:	53                   	push   %ebx
801041e0:	e8 0b 32 00 00       	call   801073f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801041e5:	58                   	pop    %eax
801041e6:	5a                   	pop    %edx
801041e7:	ff 73 1c             	pushl  0x1c(%ebx)
801041ea:	57                   	push   %edi
      p->state = RUNNING;
801041eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801041f2:	e8 74 0c 00 00       	call   80104e6b <swtch>
      switchkvm();
801041f7:	e8 d4 31 00 00       	call   801073d0 <switchkvm>
      c->proc = 0;
801041fc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104203:	00 00 00 
80104206:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104209:	81 c3 50 01 00 00    	add    $0x150,%ebx
8010420f:	81 fb 74 c1 11 80    	cmp    $0x8011c174,%ebx
80104215:	72 b9                	jb     801041d0 <scheduler+0x50>
    release(&ptable.lock);
80104217:	83 ec 0c             	sub    $0xc,%esp
8010421a:	68 40 6d 11 80       	push   $0x80116d40
8010421f:	e8 bc 09 00 00       	call   80104be0 <release>
    sti();
80104224:	83 c4 10             	add    $0x10,%esp
80104227:	eb 87                	jmp    801041b0 <scheduler+0x30>
80104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104230 <sched>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
  pushcli();
80104235:	e8 16 08 00 00       	call   80104a50 <pushcli>
  c = mycpu();
8010423a:	e8 d1 fa ff ff       	call   80103d10 <mycpu>
  p = c->proc;
8010423f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104245:	e8 46 08 00 00       	call   80104a90 <popcli>
  if(!holding(&ptable.lock))
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 40 6d 11 80       	push   $0x80116d40
80104252:	e8 99 08 00 00       	call   80104af0 <holding>
80104257:	83 c4 10             	add    $0x10,%esp
8010425a:	85 c0                	test   %eax,%eax
8010425c:	74 4f                	je     801042ad <sched+0x7d>
  if(mycpu()->ncli != 1)
8010425e:	e8 ad fa ff ff       	call   80103d10 <mycpu>
80104263:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010426a:	75 68                	jne    801042d4 <sched+0xa4>
  if(p->state == RUNNING)
8010426c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104270:	74 55                	je     801042c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104272:	9c                   	pushf  
80104273:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104274:	f6 c4 02             	test   $0x2,%ah
80104277:	75 41                	jne    801042ba <sched+0x8a>
  intena = mycpu()->intena;
80104279:	e8 92 fa ff ff       	call   80103d10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010427e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104281:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104287:	e8 84 fa ff ff       	call   80103d10 <mycpu>
8010428c:	83 ec 08             	sub    $0x8,%esp
8010428f:	ff 70 04             	pushl  0x4(%eax)
80104292:	53                   	push   %ebx
80104293:	e8 d3 0b 00 00       	call   80104e6b <swtch>
  mycpu()->intena = intena;
80104298:	e8 73 fa ff ff       	call   80103d10 <mycpu>
}
8010429d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042a9:	5b                   	pop    %ebx
801042aa:	5e                   	pop    %esi
801042ab:	5d                   	pop    %ebp
801042ac:	c3                   	ret    
    panic("sched ptable.lock");
801042ad:	83 ec 0c             	sub    $0xc,%esp
801042b0:	68 f0 89 10 80       	push   $0x801089f0
801042b5:	e8 d6 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 1c 8a 10 80       	push   $0x80108a1c
801042c2:	e8 c9 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
801042c7:	83 ec 0c             	sub    $0xc,%esp
801042ca:	68 0e 8a 10 80       	push   $0x80108a0e
801042cf:	e8 bc c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 02 8a 10 80       	push   $0x80108a02
801042dc:	e8 af c0 ff ff       	call   80100390 <panic>
801042e1:	eb 0d                	jmp    801042f0 <exit>
801042e3:	90                   	nop
801042e4:	90                   	nop
801042e5:	90                   	nop
801042e6:	90                   	nop
801042e7:	90                   	nop
801042e8:	90                   	nop
801042e9:	90                   	nop
801042ea:	90                   	nop
801042eb:	90                   	nop
801042ec:	90                   	nop
801042ed:	90                   	nop
801042ee:	90                   	nop
801042ef:	90                   	nop

801042f0 <exit>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801042f9:	e8 52 07 00 00       	call   80104a50 <pushcli>
  c = mycpu();
801042fe:	e8 0d fa ff ff       	call   80103d10 <mycpu>
  p = c->proc;
80104303:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104309:	e8 82 07 00 00       	call   80104a90 <popcli>
  if(curproc == initproc)
8010430e:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
80104314:	8d 73 28             	lea    0x28(%ebx),%esi
80104317:	8d 7b 68             	lea    0x68(%ebx),%edi
8010431a:	0f 84 11 01 00 00    	je     80104431 <exit+0x141>
    if(curproc->ofile[fd]){
80104320:	8b 06                	mov    (%esi),%eax
80104322:	85 c0                	test   %eax,%eax
80104324:	74 12                	je     80104338 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	50                   	push   %eax
8010432a:	e8 41 cc ff ff       	call   80100f70 <fileclose>
      curproc->ofile[fd] = 0;
8010432f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104335:	83 c4 10             	add    $0x10,%esp
80104338:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010433b:	39 fe                	cmp    %edi,%esi
8010433d:	75 e1                	jne    80104320 <exit+0x30>
  if(curproc->pid > 2)
8010433f:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104343:	7e 0c                	jle    80104351 <exit+0x61>
    removeSwapFile(curproc);
80104345:	83 ec 0c             	sub    $0xc,%esp
80104348:	53                   	push   %ebx
80104349:	e8 92 dd ff ff       	call   801020e0 <removeSwapFile>
8010434e:	83 c4 10             	add    $0x10,%esp
  begin_op();
80104351:	e8 9a ed ff ff       	call   801030f0 <begin_op>
  iput(curproc->cwd);
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	ff 73 68             	pushl  0x68(%ebx)
8010435c:	e8 7f d5 ff ff       	call   801018e0 <iput>
  end_op();
80104361:	e8 fa ed ff ff       	call   80103160 <end_op>
  curproc->cwd = 0;
80104366:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010436d:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
80104374:	e8 a7 07 00 00       	call   80104b20 <acquire>
  wakeup1(curproc->parent);
80104379:	8b 53 14             	mov    0x14(%ebx),%edx
8010437c:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010437f:	b8 74 6d 11 80       	mov    $0x80116d74,%eax
80104384:	eb 16                	jmp    8010439c <exit+0xac>
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104390:	05 50 01 00 00       	add    $0x150,%eax
80104395:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
8010439a:	73 1e                	jae    801043ba <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010439c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043a0:	75 ee                	jne    80104390 <exit+0xa0>
801043a2:	3b 50 20             	cmp    0x20(%eax),%edx
801043a5:	75 e9                	jne    80104390 <exit+0xa0>
      p->state = RUNNABLE;
801043a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ae:	05 50 01 00 00       	add    $0x150,%eax
801043b3:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
801043b8:	72 e2                	jb     8010439c <exit+0xac>
      p->parent = initproc;
801043ba:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c0:	ba 74 6d 11 80       	mov    $0x80116d74,%edx
801043c5:	eb 17                	jmp    801043de <exit+0xee>
801043c7:	89 f6                	mov    %esi,%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801043d0:	81 c2 50 01 00 00    	add    $0x150,%edx
801043d6:	81 fa 74 c1 11 80    	cmp    $0x8011c174,%edx
801043dc:	73 3a                	jae    80104418 <exit+0x128>
    if(p->parent == curproc){
801043de:	39 5a 14             	cmp    %ebx,0x14(%edx)
801043e1:	75 ed                	jne    801043d0 <exit+0xe0>
      if(p->state == ZOMBIE)
801043e3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043e7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043ea:	75 e4                	jne    801043d0 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ec:	b8 74 6d 11 80       	mov    $0x80116d74,%eax
801043f1:	eb 11                	jmp    80104404 <exit+0x114>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f8:	05 50 01 00 00       	add    $0x150,%eax
801043fd:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
80104402:	73 cc                	jae    801043d0 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104404:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104408:	75 ee                	jne    801043f8 <exit+0x108>
8010440a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010440d:	75 e9                	jne    801043f8 <exit+0x108>
      p->state = RUNNABLE;
8010440f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104416:	eb e0                	jmp    801043f8 <exit+0x108>
  curproc->state = ZOMBIE;
80104418:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010441f:	e8 0c fe ff ff       	call   80104230 <sched>
  panic("zombie exit");
80104424:	83 ec 0c             	sub    $0xc,%esp
80104427:	68 3d 8a 10 80       	push   $0x80108a3d
8010442c:	e8 5f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 30 8a 10 80       	push   $0x80108a30
80104439:	e8 52 bf ff ff       	call   80100390 <panic>
8010443e:	66 90                	xchg   %ax,%ax

80104440 <yield>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104447:	68 40 6d 11 80       	push   $0x80116d40
8010444c:	e8 cf 06 00 00       	call   80104b20 <acquire>
  pushcli();
80104451:	e8 fa 05 00 00       	call   80104a50 <pushcli>
  c = mycpu();
80104456:	e8 b5 f8 ff ff       	call   80103d10 <mycpu>
  p = c->proc;
8010445b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104461:	e8 2a 06 00 00       	call   80104a90 <popcli>
  myproc()->state = RUNNABLE;
80104466:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010446d:	e8 be fd ff ff       	call   80104230 <sched>
  release(&ptable.lock);
80104472:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
80104479:	e8 62 07 00 00       	call   80104be0 <release>
}
8010447e:	83 c4 10             	add    $0x10,%esp
80104481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104484:	c9                   	leave  
80104485:	c3                   	ret    
80104486:	8d 76 00             	lea    0x0(%esi),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <sleep>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	8b 7d 08             	mov    0x8(%ebp),%edi
8010449c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010449f:	e8 ac 05 00 00       	call   80104a50 <pushcli>
  c = mycpu();
801044a4:	e8 67 f8 ff ff       	call   80103d10 <mycpu>
  p = c->proc;
801044a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044af:	e8 dc 05 00 00       	call   80104a90 <popcli>
  if(p == 0)
801044b4:	85 db                	test   %ebx,%ebx
801044b6:	0f 84 87 00 00 00    	je     80104543 <sleep+0xb3>
  if(lk == 0)
801044bc:	85 f6                	test   %esi,%esi
801044be:	74 76                	je     80104536 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044c0:	81 fe 40 6d 11 80    	cmp    $0x80116d40,%esi
801044c6:	74 50                	je     80104518 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	68 40 6d 11 80       	push   $0x80116d40
801044d0:	e8 4b 06 00 00       	call   80104b20 <acquire>
    release(lk);
801044d5:	89 34 24             	mov    %esi,(%esp)
801044d8:	e8 03 07 00 00       	call   80104be0 <release>
  p->chan = chan;
801044dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044e7:	e8 44 fd ff ff       	call   80104230 <sched>
  p->chan = 0;
801044ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044f3:	c7 04 24 40 6d 11 80 	movl   $0x80116d40,(%esp)
801044fa:	e8 e1 06 00 00       	call   80104be0 <release>
    acquire(lk);
801044ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104502:	83 c4 10             	add    $0x10,%esp
}
80104505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
    acquire(lk);
8010450c:	e9 0f 06 00 00       	jmp    80104b20 <acquire>
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104518:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010451b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104522:	e8 09 fd ff ff       	call   80104230 <sched>
  p->chan = 0;
80104527:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010452e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104531:	5b                   	pop    %ebx
80104532:	5e                   	pop    %esi
80104533:	5f                   	pop    %edi
80104534:	5d                   	pop    %ebp
80104535:	c3                   	ret    
    panic("sleep without lk");
80104536:	83 ec 0c             	sub    $0xc,%esp
80104539:	68 4f 8a 10 80       	push   $0x80108a4f
8010453e:	e8 4d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	68 49 8a 10 80       	push   $0x80108a49
8010454b:	e8 40 be ff ff       	call   80100390 <panic>

80104550 <wait>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
  pushcli();
80104555:	e8 f6 04 00 00       	call   80104a50 <pushcli>
  c = mycpu();
8010455a:	e8 b1 f7 ff ff       	call   80103d10 <mycpu>
  p = c->proc;
8010455f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104565:	e8 26 05 00 00       	call   80104a90 <popcli>
  acquire(&ptable.lock);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 40 6d 11 80       	push   $0x80116d40
80104572:	e8 a9 05 00 00       	call   80104b20 <acquire>
80104577:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010457a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010457c:	bb 74 6d 11 80       	mov    $0x80116d74,%ebx
80104581:	eb 13                	jmp    80104596 <wait+0x46>
80104583:	90                   	nop
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	81 c3 50 01 00 00    	add    $0x150,%ebx
8010458e:	81 fb 74 c1 11 80    	cmp    $0x8011c174,%ebx
80104594:	73 1e                	jae    801045b4 <wait+0x64>
      if(p->parent != curproc)
80104596:	39 73 14             	cmp    %esi,0x14(%ebx)
80104599:	75 ed                	jne    80104588 <wait+0x38>
      if(p->state == ZOMBIE){
8010459b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010459f:	74 3f                	je     801045e0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a1:	81 c3 50 01 00 00    	add    $0x150,%ebx
      havekids = 1;
801045a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ac:	81 fb 74 c1 11 80    	cmp    $0x8011c174,%ebx
801045b2:	72 e2                	jb     80104596 <wait+0x46>
    if(!havekids || curproc->killed){
801045b4:	85 c0                	test   %eax,%eax
801045b6:	0f 84 d5 00 00 00    	je     80104691 <wait+0x141>
801045bc:	8b 46 24             	mov    0x24(%esi),%eax
801045bf:	85 c0                	test   %eax,%eax
801045c1:	0f 85 ca 00 00 00    	jne    80104691 <wait+0x141>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045c7:	83 ec 08             	sub    $0x8,%esp
801045ca:	68 40 6d 11 80       	push   $0x80116d40
801045cf:	56                   	push   %esi
801045d0:	e8 bb fe ff ff       	call   80104490 <sleep>
    havekids = 0;
801045d5:	83 c4 10             	add    $0x10,%esp
801045d8:	eb a0                	jmp    8010457a <wait+0x2a>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045e9:	e8 e2 e1 ff ff       	call   801027d0 <kfree>
        freevm(p->pgdir);
801045ee:	5a                   	pop    %edx
801045ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045f9:	e8 12 35 00 00       	call   80107b10 <freevm>
        p->pid = 0;
801045fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104605:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
8010460c:	83 c4 10             	add    $0x10,%esp
        p->name[0] = 0;
8010460f:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104613:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        for(int i = 0; i < 16; i++){
8010461a:	31 c0                	xor    %eax,%eax
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          p->swapPages[i] = -1;
80104620:	c7 84 83 80 00 00 00 	movl   $0xffffffff,0x80(%ebx,%eax,4)
80104627:	ff ff ff ff 
          p->ramPages[i].va = -1;
8010462b:	c7 84 c3 c0 00 00 00 	movl   $0xffffffff,0xc0(%ebx,%eax,8)
80104632:	ff ff ff ff 
          p->ramPages[i].counter = 0;
80104636:	c7 84 c3 c4 00 00 00 	movl   $0x0,0xc4(%ebx,%eax,8)
8010463d:	00 00 00 00 
        for(int i = 0; i < 16; i++){
80104641:	83 c0 01             	add    $0x1,%eax
80104644:	83 f8 10             	cmp    $0x10,%eax
80104647:	75 d7                	jne    80104620 <wait+0xd0>
        release(&ptable.lock);
80104649:	83 ec 0c             	sub    $0xc,%esp
        p->swapCounter = 0;
8010464c:	c7 83 44 01 00 00 00 	movl   $0x0,0x144(%ebx)
80104653:	00 00 00 
        p->ramCounter = 0;
80104656:	c7 83 40 01 00 00 00 	movl   $0x0,0x140(%ebx)
8010465d:	00 00 00 
        release(&ptable.lock);
80104660:	68 40 6d 11 80       	push   $0x80116d40
        p->pageFaults = 0;
80104665:	c7 83 48 01 00 00 00 	movl   $0x0,0x148(%ebx)
8010466c:	00 00 00 
        p->totalPagedOut = 0;
8010466f:	c7 83 4c 01 00 00 00 	movl   $0x0,0x14c(%ebx)
80104676:	00 00 00 
        p->state = UNUSED;
80104679:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104680:	e8 5b 05 00 00       	call   80104be0 <release>
        return pid;
80104685:	83 c4 10             	add    $0x10,%esp
}
80104688:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468b:	89 f0                	mov    %esi,%eax
8010468d:	5b                   	pop    %ebx
8010468e:	5e                   	pop    %esi
8010468f:	5d                   	pop    %ebp
80104690:	c3                   	ret    
      release(&ptable.lock);
80104691:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104694:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104699:	68 40 6d 11 80       	push   $0x80116d40
8010469e:	e8 3d 05 00 00       	call   80104be0 <release>
      return -1;
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	eb e0                	jmp    80104688 <wait+0x138>
801046a8:	90                   	nop
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046ba:	68 40 6d 11 80       	push   $0x80116d40
801046bf:	e8 5c 04 00 00       	call   80104b20 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c7:	b8 74 6d 11 80       	mov    $0x80116d74,%eax
801046cc:	eb 0e                	jmp    801046dc <wakeup+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 50 01 00 00       	add    $0x150,%eax
801046d5:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
801046da:	73 1e                	jae    801046fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801046dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046e0:	75 ee                	jne    801046d0 <wakeup+0x20>
801046e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801046e5:	75 e9                	jne    801046d0 <wakeup+0x20>
      p->state = RUNNABLE;
801046e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ee:	05 50 01 00 00       	add    $0x150,%eax
801046f3:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
801046f8:	72 e2                	jb     801046dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801046fa:	c7 45 08 40 6d 11 80 	movl   $0x80116d40,0x8(%ebp)
}
80104701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104704:	c9                   	leave  
  release(&ptable.lock);
80104705:	e9 d6 04 00 00       	jmp    80104be0 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010471a:	68 40 6d 11 80       	push   $0x80116d40
8010471f:	e8 fc 03 00 00       	call   80104b20 <acquire>
80104724:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104727:	b8 74 6d 11 80       	mov    $0x80116d74,%eax
8010472c:	eb 0e                	jmp    8010473c <kill+0x2c>
8010472e:	66 90                	xchg   %ax,%ax
80104730:	05 50 01 00 00       	add    $0x150,%eax
80104735:	3d 74 c1 11 80       	cmp    $0x8011c174,%eax
8010473a:	73 34                	jae    80104770 <kill+0x60>
    if(p->pid == pid){
8010473c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010473f:	75 ef                	jne    80104730 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104741:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104745:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010474c:	75 07                	jne    80104755 <kill+0x45>
        p->state = RUNNABLE;
8010474e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104755:	83 ec 0c             	sub    $0xc,%esp
80104758:	68 40 6d 11 80       	push   $0x80116d40
8010475d:	e8 7e 04 00 00       	call   80104be0 <release>
      return 0;
80104762:	83 c4 10             	add    $0x10,%esp
80104765:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010476a:	c9                   	leave  
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104770:	83 ec 0c             	sub    $0xc,%esp
80104773:	68 40 6d 11 80       	push   $0x80116d40
80104778:	e8 63 04 00 00       	call   80104be0 <release>
  return -1;
8010477d:	83 c4 10             	add    $0x10,%esp
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104788:	c9                   	leave  
80104789:	c3                   	ret    
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	53                   	push   %ebx
80104796:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104799:	bb 74 6d 11 80       	mov    $0x80116d74,%ebx
{
8010479e:	83 ec 3c             	sub    $0x3c,%esp
801047a1:	eb 27                	jmp    801047ca <procdump+0x3a>
801047a3:	90                   	nop
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 b5 8e 10 80       	push   $0x80108eb5
801047b0:	e8 ab be ff ff       	call   80100660 <cprintf>
801047b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b8:	81 c3 50 01 00 00    	add    $0x150,%ebx
801047be:	81 fb 74 c1 11 80    	cmp    $0x8011c174,%ebx
801047c4:	0f 83 b6 00 00 00    	jae    80104880 <procdump+0xf0>
    if(p->state == UNUSED)
801047ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801047cd:	85 c0                	test   %eax,%eax
801047cf:	74 e7                	je     801047b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047d1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801047d4:	ba 60 8a 10 80       	mov    $0x80108a60,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047d9:	77 11                	ja     801047ec <procdump+0x5c>
801047db:	8b 14 85 18 8b 10 80 	mov    -0x7fef74e8(,%eax,4),%edx
      state = "???";
801047e2:	b8 60 8a 10 80       	mov    $0x80108a60,%eax
801047e7:	85 d2                	test   %edx,%edx
801047e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s ", p->pid, state, p->name);
801047ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047ef:	50                   	push   %eax
801047f0:	52                   	push   %edx
801047f1:	ff 73 10             	pushl  0x10(%ebx)
801047f4:	68 64 8a 10 80       	push   $0x80108a64
801047f9:	e8 62 be ff ff       	call   80100660 <cprintf>
    cprintf("%d %d %d %d", p->ramCounter, p->swapCounter, p->pageFaults, p->totalPagedOut);
801047fe:	58                   	pop    %eax
801047ff:	ff b3 4c 01 00 00    	pushl  0x14c(%ebx)
80104805:	ff b3 48 01 00 00    	pushl  0x148(%ebx)
8010480b:	ff b3 44 01 00 00    	pushl  0x144(%ebx)
80104811:	ff b3 40 01 00 00    	pushl  0x140(%ebx)
80104817:	68 6e 8a 10 80       	push   $0x80108a6e
8010481c:	e8 3f be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104821:	83 c4 20             	add    $0x20,%esp
80104824:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104828:	0f 85 7a ff ff ff    	jne    801047a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010482e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104831:	83 ec 08             	sub    $0x8,%esp
80104834:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104837:	50                   	push   %eax
80104838:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010483b:	8b 40 0c             	mov    0xc(%eax),%eax
8010483e:	83 c0 08             	add    $0x8,%eax
80104841:	50                   	push   %eax
80104842:	e8 b9 01 00 00       	call   80104a00 <getcallerpcs>
80104847:	83 c4 10             	add    $0x10,%esp
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104850:	8b 17                	mov    (%edi),%edx
80104852:	85 d2                	test   %edx,%edx
80104854:	0f 84 4e ff ff ff    	je     801047a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010485a:	83 ec 08             	sub    $0x8,%esp
8010485d:	83 c7 04             	add    $0x4,%edi
80104860:	52                   	push   %edx
80104861:	68 61 84 10 80       	push   $0x80108461
80104866:	e8 f5 bd ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010486b:	83 c4 10             	add    $0x10,%esp
8010486e:	39 fe                	cmp    %edi,%esi
80104870:	75 de                	jne    80104850 <procdump+0xc0>
80104872:	e9 31 ff ff ff       	jmp    801047a8 <procdump+0x18>
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
  cprintf("%d / %d free page frames in the system\n", getNumberOfFreePages(), getNumberOfTotalPages());
80104880:	e8 eb e1 ff ff       	call   80102a70 <getNumberOfTotalPages>
80104885:	89 c3                	mov    %eax,%ebx
80104887:	e8 d4 e1 ff ff       	call   80102a60 <getNumberOfFreePages>
8010488c:	83 ec 04             	sub    $0x4,%esp
8010488f:	53                   	push   %ebx
80104890:	50                   	push   %eax
80104891:	68 f0 8a 10 80       	push   $0x80108af0
80104896:	e8 c5 bd ff ff       	call   80100660 <cprintf>
}
8010489b:	83 c4 10             	add    $0x10,%esp
8010489e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048a1:	5b                   	pop    %ebx
801048a2:	5e                   	pop    %esi
801048a3:	5f                   	pop    %edi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret    
801048a6:	66 90                	xchg   %ax,%ax
801048a8:	66 90                	xchg   %ax,%ax
801048aa:	66 90                	xchg   %ax,%ax
801048ac:	66 90                	xchg   %ax,%ax
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048ba:	68 30 8b 10 80       	push   $0x80108b30
801048bf:	8d 43 04             	lea    0x4(%ebx),%eax
801048c2:	50                   	push   %eax
801048c3:	e8 18 01 00 00       	call   801049e0 <initlock>
  lk->name = name;
801048c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801048d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801048d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801048db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801048de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e1:	c9                   	leave  
801048e2:	c3                   	ret    
801048e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	8d 73 04             	lea    0x4(%ebx),%esi
801048fe:	56                   	push   %esi
801048ff:	e8 1c 02 00 00       	call   80104b20 <acquire>
  while (lk->locked) {
80104904:	8b 13                	mov    (%ebx),%edx
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	85 d2                	test   %edx,%edx
8010490b:	74 16                	je     80104923 <acquiresleep+0x33>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104910:	83 ec 08             	sub    $0x8,%esp
80104913:	56                   	push   %esi
80104914:	53                   	push   %ebx
80104915:	e8 76 fb ff ff       	call   80104490 <sleep>
  while (lk->locked) {
8010491a:	8b 03                	mov    (%ebx),%eax
8010491c:	83 c4 10             	add    $0x10,%esp
8010491f:	85 c0                	test   %eax,%eax
80104921:	75 ed                	jne    80104910 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104923:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104929:	e8 82 f4 ff ff       	call   80103db0 <myproc>
8010492e:	8b 40 10             	mov    0x10(%eax),%eax
80104931:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104934:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104937:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010493a:	5b                   	pop    %ebx
8010493b:	5e                   	pop    %esi
8010493c:	5d                   	pop    %ebp
  release(&lk->lk);
8010493d:	e9 9e 02 00 00       	jmp    80104be0 <release>
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104958:	83 ec 0c             	sub    $0xc,%esp
8010495b:	8d 73 04             	lea    0x4(%ebx),%esi
8010495e:	56                   	push   %esi
8010495f:	e8 bc 01 00 00       	call   80104b20 <acquire>
  lk->locked = 0;
80104964:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010496a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104971:	89 1c 24             	mov    %ebx,(%esp)
80104974:	e8 37 fd ff ff       	call   801046b0 <wakeup>
  release(&lk->lk);
80104979:	89 75 08             	mov    %esi,0x8(%ebp)
8010497c:	83 c4 10             	add    $0x10,%esp
}
8010497f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104982:	5b                   	pop    %ebx
80104983:	5e                   	pop    %esi
80104984:	5d                   	pop    %ebp
  release(&lk->lk);
80104985:	e9 56 02 00 00       	jmp    80104be0 <release>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	31 ff                	xor    %edi,%edi
80104998:	83 ec 18             	sub    $0x18,%esp
8010499b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010499e:	8d 73 04             	lea    0x4(%ebx),%esi
801049a1:	56                   	push   %esi
801049a2:	e8 79 01 00 00       	call   80104b20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049a7:	8b 03                	mov    (%ebx),%eax
801049a9:	83 c4 10             	add    $0x10,%esp
801049ac:	85 c0                	test   %eax,%eax
801049ae:	74 13                	je     801049c3 <holdingsleep+0x33>
801049b0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049b3:	e8 f8 f3 ff ff       	call   80103db0 <myproc>
801049b8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049bb:	0f 94 c0             	sete   %al
801049be:	0f b6 c0             	movzbl %al,%eax
801049c1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801049c3:	83 ec 0c             	sub    $0xc,%esp
801049c6:	56                   	push   %esi
801049c7:	e8 14 02 00 00       	call   80104be0 <release>
  return r;
}
801049cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049cf:	89 f8                	mov    %edi,%eax
801049d1:	5b                   	pop    %ebx
801049d2:	5e                   	pop    %esi
801049d3:	5f                   	pop    %edi
801049d4:	5d                   	pop    %ebp
801049d5:	c3                   	ret    
801049d6:	66 90                	xchg   %ax,%ax
801049d8:	66 90                	xchg   %ax,%ax
801049da:	66 90                	xchg   %ax,%ax
801049dc:	66 90                	xchg   %ax,%ax
801049de:	66 90                	xchg   %ax,%ax

801049e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801049e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801049e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801049ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801049f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	90                   	nop
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a00 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a00:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a01:	31 d2                	xor    %edx,%edx
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a06:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a0c:	83 e8 08             	sub    $0x8,%eax
80104a0f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a10:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a16:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a1c:	77 1a                	ja     80104a38 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a1e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a21:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a24:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a27:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a29:	83 fa 0a             	cmp    $0xa,%edx
80104a2c:	75 e2                	jne    80104a10 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a2e:	5b                   	pop    %ebx
80104a2f:	5d                   	pop    %ebp
80104a30:	c3                   	ret    
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a38:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a3b:	83 c1 28             	add    $0x28,%ecx
80104a3e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a46:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a49:	39 c1                	cmp    %eax,%ecx
80104a4b:	75 f3                	jne    80104a40 <getcallerpcs+0x40>
}
80104a4d:	5b                   	pop    %ebx
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
80104a57:	9c                   	pushf  
80104a58:	5b                   	pop    %ebx
  asm volatile("cli");
80104a59:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a5a:	e8 b1 f2 ff ff       	call   80103d10 <mycpu>
80104a5f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a65:	85 c0                	test   %eax,%eax
80104a67:	75 11                	jne    80104a7a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a69:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a6f:	e8 9c f2 ff ff       	call   80103d10 <mycpu>
80104a74:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a7a:	e8 91 f2 ff ff       	call   80103d10 <mycpu>
80104a7f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a86:	83 c4 04             	add    $0x4,%esp
80104a89:	5b                   	pop    %ebx
80104a8a:	5d                   	pop    %ebp
80104a8b:	c3                   	ret    
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <popcli>:

void
popcli(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a96:	9c                   	pushf  
80104a97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a98:	f6 c4 02             	test   $0x2,%ah
80104a9b:	75 35                	jne    80104ad2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a9d:	e8 6e f2 ff ff       	call   80103d10 <mycpu>
80104aa2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104aa9:	78 34                	js     80104adf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104aab:	e8 60 f2 ff ff       	call   80103d10 <mycpu>
80104ab0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ab6:	85 d2                	test   %edx,%edx
80104ab8:	74 06                	je     80104ac0 <popcli+0x30>
    sti();
}
80104aba:	c9                   	leave  
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ac0:	e8 4b f2 ff ff       	call   80103d10 <mycpu>
80104ac5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104acb:	85 c0                	test   %eax,%eax
80104acd:	74 eb                	je     80104aba <popcli+0x2a>
  asm volatile("sti");
80104acf:	fb                   	sti    
}
80104ad0:	c9                   	leave  
80104ad1:	c3                   	ret    
    panic("popcli - interruptible");
80104ad2:	83 ec 0c             	sub    $0xc,%esp
80104ad5:	68 3b 8b 10 80       	push   $0x80108b3b
80104ada:	e8 b1 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	68 52 8b 10 80       	push   $0x80108b52
80104ae7:	e8 a4 b8 ff ff       	call   80100390 <panic>
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <holding>:
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 75 08             	mov    0x8(%ebp),%esi
80104af8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104afa:	e8 51 ff ff ff       	call   80104a50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aff:	8b 06                	mov    (%esi),%eax
80104b01:	85 c0                	test   %eax,%eax
80104b03:	74 10                	je     80104b15 <holding+0x25>
80104b05:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b08:	e8 03 f2 ff ff       	call   80103d10 <mycpu>
80104b0d:	39 c3                	cmp    %eax,%ebx
80104b0f:	0f 94 c3             	sete   %bl
80104b12:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104b15:	e8 76 ff ff ff       	call   80104a90 <popcli>
}
80104b1a:	89 d8                	mov    %ebx,%eax
80104b1c:	5b                   	pop    %ebx
80104b1d:	5e                   	pop    %esi
80104b1e:	5d                   	pop    %ebp
80104b1f:	c3                   	ret    

80104b20 <acquire>:
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b25:	e8 26 ff ff ff       	call   80104a50 <pushcli>
  if(holding(lk))
80104b2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b2d:	83 ec 0c             	sub    $0xc,%esp
80104b30:	53                   	push   %ebx
80104b31:	e8 ba ff ff ff       	call   80104af0 <holding>
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 c0                	test   %eax,%eax
80104b3b:	0f 85 83 00 00 00    	jne    80104bc4 <acquire+0xa4>
80104b41:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b43:	ba 01 00 00 00       	mov    $0x1,%edx
80104b48:	eb 09                	jmp    80104b53 <acquire+0x33>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b50:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b53:	89 d0                	mov    %edx,%eax
80104b55:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	75 f4                	jne    80104b50 <acquire+0x30>
  __sync_synchronize();
80104b5c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b64:	e8 a7 f1 ff ff       	call   80103d10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b69:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104b6c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b6f:	89 e8                	mov    %ebp,%eax
80104b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b78:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104b7e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104b84:	77 1a                	ja     80104ba0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b86:	8b 48 04             	mov    0x4(%eax),%ecx
80104b89:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104b8c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b8f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b91:	83 fe 0a             	cmp    $0xa,%esi
80104b94:	75 e2                	jne    80104b78 <acquire+0x58>
}
80104b96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ba3:	83 c2 28             	add    $0x28,%edx
80104ba6:	8d 76 00             	lea    0x0(%esi),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104bb6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104bb9:	39 d0                	cmp    %edx,%eax
80104bbb:	75 f3                	jne    80104bb0 <acquire+0x90>
}
80104bbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc0:	5b                   	pop    %ebx
80104bc1:	5e                   	pop    %esi
80104bc2:	5d                   	pop    %ebp
80104bc3:	c3                   	ret    
    panic("acquire");
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	68 59 8b 10 80       	push   $0x80108b59
80104bcc:	e8 bf b7 ff ff       	call   80100390 <panic>
80104bd1:	eb 0d                	jmp    80104be0 <release>
80104bd3:	90                   	nop
80104bd4:	90                   	nop
80104bd5:	90                   	nop
80104bd6:	90                   	nop
80104bd7:	90                   	nop
80104bd8:	90                   	nop
80104bd9:	90                   	nop
80104bda:	90                   	nop
80104bdb:	90                   	nop
80104bdc:	90                   	nop
80104bdd:	90                   	nop
80104bde:	90                   	nop
80104bdf:	90                   	nop

80104be0 <release>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 10             	sub    $0x10,%esp
80104be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bea:	53                   	push   %ebx
80104beb:	e8 00 ff ff ff       	call   80104af0 <holding>
80104bf0:	83 c4 10             	add    $0x10,%esp
80104bf3:	85 c0                	test   %eax,%eax
80104bf5:	74 22                	je     80104c19 <release+0x39>
  lk->pcs[0] = 0;
80104bf7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bfe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c05:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c0a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c13:	c9                   	leave  
  popcli();
80104c14:	e9 77 fe ff ff       	jmp    80104a90 <popcli>
    panic("release");
80104c19:	83 ec 0c             	sub    $0xc,%esp
80104c1c:	68 61 8b 10 80       	push   $0x80108b61
80104c21:	e8 6a b7 ff ff       	call   80100390 <panic>
80104c26:	66 90                	xchg   %ax,%ax
80104c28:	66 90                	xchg   %ax,%ax
80104c2a:	66 90                	xchg   %ax,%ax
80104c2c:	66 90                	xchg   %ax,%ax
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	53                   	push   %ebx
80104c35:	8b 55 08             	mov    0x8(%ebp),%edx
80104c38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c3b:	f6 c2 03             	test   $0x3,%dl
80104c3e:	75 05                	jne    80104c45 <memset+0x15>
80104c40:	f6 c1 03             	test   $0x3,%cl
80104c43:	74 13                	je     80104c58 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104c45:	89 d7                	mov    %edx,%edi
80104c47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4a:	fc                   	cld    
80104c4b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c4d:	5b                   	pop    %ebx
80104c4e:	89 d0                	mov    %edx,%eax
80104c50:	5f                   	pop    %edi
80104c51:	5d                   	pop    %ebp
80104c52:	c3                   	ret    
80104c53:	90                   	nop
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104c58:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c5c:	c1 e9 02             	shr    $0x2,%ecx
80104c5f:	89 f8                	mov    %edi,%eax
80104c61:	89 fb                	mov    %edi,%ebx
80104c63:	c1 e0 18             	shl    $0x18,%eax
80104c66:	c1 e3 10             	shl    $0x10,%ebx
80104c69:	09 d8                	or     %ebx,%eax
80104c6b:	09 f8                	or     %edi,%eax
80104c6d:	c1 e7 08             	shl    $0x8,%edi
80104c70:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c72:	89 d7                	mov    %edx,%edi
80104c74:	fc                   	cld    
80104c75:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104c77:	5b                   	pop    %ebx
80104c78:	89 d0                	mov    %edx,%eax
80104c7a:	5f                   	pop    %edi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret    
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi

80104c80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	53                   	push   %ebx
80104c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c89:	8b 75 08             	mov    0x8(%ebp),%esi
80104c8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c8f:	85 db                	test   %ebx,%ebx
80104c91:	74 29                	je     80104cbc <memcmp+0x3c>
    if(*s1 != *s2)
80104c93:	0f b6 16             	movzbl (%esi),%edx
80104c96:	0f b6 0f             	movzbl (%edi),%ecx
80104c99:	38 d1                	cmp    %dl,%cl
80104c9b:	75 2b                	jne    80104cc8 <memcmp+0x48>
80104c9d:	b8 01 00 00 00       	mov    $0x1,%eax
80104ca2:	eb 14                	jmp    80104cb8 <memcmp+0x38>
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104cac:	83 c0 01             	add    $0x1,%eax
80104caf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104cb4:	38 ca                	cmp    %cl,%dl
80104cb6:	75 10                	jne    80104cc8 <memcmp+0x48>
  while(n-- > 0){
80104cb8:	39 d8                	cmp    %ebx,%eax
80104cba:	75 ec                	jne    80104ca8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104cbc:	5b                   	pop    %ebx
  return 0;
80104cbd:	31 c0                	xor    %eax,%eax
}
80104cbf:	5e                   	pop    %esi
80104cc0:	5f                   	pop    %edi
80104cc1:	5d                   	pop    %ebp
80104cc2:	c3                   	ret    
80104cc3:	90                   	nop
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104cc8:	0f b6 c2             	movzbl %dl,%eax
}
80104ccb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104ccc:	29 c8                	sub    %ecx,%eax
}
80104cce:	5e                   	pop    %esi
80104ccf:	5f                   	pop    %edi
80104cd0:	5d                   	pop    %ebp
80104cd1:	c3                   	ret    
80104cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ceb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cee:	39 c3                	cmp    %eax,%ebx
80104cf0:	73 26                	jae    80104d18 <memmove+0x38>
80104cf2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104cf5:	39 c8                	cmp    %ecx,%eax
80104cf7:	73 1f                	jae    80104d18 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104cf9:	85 f6                	test   %esi,%esi
80104cfb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104cfe:	74 0f                	je     80104d0f <memmove+0x2f>
      *--d = *--s;
80104d00:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d04:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d07:	83 ea 01             	sub    $0x1,%edx
80104d0a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d0d:	75 f1                	jne    80104d00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	90                   	nop
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d18:	31 d2                	xor    %edx,%edx
80104d1a:	85 f6                	test   %esi,%esi
80104d1c:	74 f1                	je     80104d0f <memmove+0x2f>
80104d1e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d20:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d27:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d2a:	39 d6                	cmp    %edx,%esi
80104d2c:	75 f2                	jne    80104d20 <memmove+0x40>
}
80104d2e:	5b                   	pop    %ebx
80104d2f:	5e                   	pop    %esi
80104d30:	5d                   	pop    %ebp
80104d31:	c3                   	ret    
80104d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d43:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104d44:	eb 9a                	jmp    80104ce0 <memmove>
80104d46:	8d 76 00             	lea    0x0(%esi),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	8b 7d 10             	mov    0x10(%ebp),%edi
80104d58:	53                   	push   %ebx
80104d59:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d5f:	85 ff                	test   %edi,%edi
80104d61:	74 2f                	je     80104d92 <strncmp+0x42>
80104d63:	0f b6 01             	movzbl (%ecx),%eax
80104d66:	0f b6 1e             	movzbl (%esi),%ebx
80104d69:	84 c0                	test   %al,%al
80104d6b:	74 37                	je     80104da4 <strncmp+0x54>
80104d6d:	38 c3                	cmp    %al,%bl
80104d6f:	75 33                	jne    80104da4 <strncmp+0x54>
80104d71:	01 f7                	add    %esi,%edi
80104d73:	eb 13                	jmp    80104d88 <strncmp+0x38>
80104d75:	8d 76 00             	lea    0x0(%esi),%esi
80104d78:	0f b6 01             	movzbl (%ecx),%eax
80104d7b:	84 c0                	test   %al,%al
80104d7d:	74 21                	je     80104da0 <strncmp+0x50>
80104d7f:	0f b6 1a             	movzbl (%edx),%ebx
80104d82:	89 d6                	mov    %edx,%esi
80104d84:	38 d8                	cmp    %bl,%al
80104d86:	75 1c                	jne    80104da4 <strncmp+0x54>
    n--, p++, q++;
80104d88:	8d 56 01             	lea    0x1(%esi),%edx
80104d8b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d8e:	39 fa                	cmp    %edi,%edx
80104d90:	75 e6                	jne    80104d78 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d92:	5b                   	pop    %ebx
    return 0;
80104d93:	31 c0                	xor    %eax,%eax
}
80104d95:	5e                   	pop    %esi
80104d96:	5f                   	pop    %edi
80104d97:	5d                   	pop    %ebp
80104d98:	c3                   	ret    
80104d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104da4:	29 d8                	sub    %ebx,%eax
}
80104da6:	5b                   	pop    %ebx
80104da7:	5e                   	pop    %esi
80104da8:	5f                   	pop    %edi
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    
80104dab:	90                   	nop
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104db0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 45 08             	mov    0x8(%ebp),%eax
80104db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104dbe:	89 c2                	mov    %eax,%edx
80104dc0:	eb 19                	jmp    80104ddb <strncpy+0x2b>
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dc8:	83 c3 01             	add    $0x1,%ebx
80104dcb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104dcf:	83 c2 01             	add    $0x1,%edx
80104dd2:	84 c9                	test   %cl,%cl
80104dd4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dd7:	74 09                	je     80104de2 <strncpy+0x32>
80104dd9:	89 f1                	mov    %esi,%ecx
80104ddb:	85 c9                	test   %ecx,%ecx
80104ddd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104de0:	7f e6                	jg     80104dc8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104de2:	31 c9                	xor    %ecx,%ecx
80104de4:	85 f6                	test   %esi,%esi
80104de6:	7e 17                	jle    80104dff <strncpy+0x4f>
80104de8:	90                   	nop
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104df0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104df4:	89 f3                	mov    %esi,%ebx
80104df6:	83 c1 01             	add    $0x1,%ecx
80104df9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104dfb:	85 db                	test   %ebx,%ebx
80104dfd:	7f f1                	jg     80104df0 <strncpy+0x40>
  return os;
}
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
80104e15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e18:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e1e:	85 c9                	test   %ecx,%ecx
80104e20:	7e 26                	jle    80104e48 <safestrcpy+0x38>
80104e22:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e26:	89 c1                	mov    %eax,%ecx
80104e28:	eb 17                	jmp    80104e41 <safestrcpy+0x31>
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e30:	83 c2 01             	add    $0x1,%edx
80104e33:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e37:	83 c1 01             	add    $0x1,%ecx
80104e3a:	84 db                	test   %bl,%bl
80104e3c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e3f:	74 04                	je     80104e45 <safestrcpy+0x35>
80104e41:	39 f2                	cmp    %esi,%edx
80104e43:	75 eb                	jne    80104e30 <safestrcpy+0x20>
    ;
  *s = 0;
80104e45:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e48:	5b                   	pop    %ebx
80104e49:	5e                   	pop    %esi
80104e4a:	5d                   	pop    %ebp
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e50 <strlen>:

int
strlen(const char *s)
{
80104e50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e58:	80 3a 00             	cmpb   $0x0,(%edx)
80104e5b:	74 0c                	je     80104e69 <strlen+0x19>
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	83 c0 01             	add    $0x1,%eax
80104e63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e67:	75 f7                	jne    80104e60 <strlen+0x10>
    ;
  return n;
}
80104e69:	5d                   	pop    %ebp
80104e6a:	c3                   	ret    

80104e6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e73:	55                   	push   %ebp
  pushl %ebx
80104e74:	53                   	push   %ebx
  pushl %esi
80104e75:	56                   	push   %esi
  pushl %edi
80104e76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e7b:	5f                   	pop    %edi
  popl %esi
80104e7c:	5e                   	pop    %esi
  popl %ebx
80104e7d:	5b                   	pop    %ebx
  popl %ebp
80104e7e:	5d                   	pop    %ebp
  ret
80104e7f:	c3                   	ret    

80104e80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	53                   	push   %ebx
80104e84:	83 ec 04             	sub    $0x4,%esp
80104e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e8a:	e8 21 ef ff ff       	call   80103db0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e8f:	8b 00                	mov    (%eax),%eax
80104e91:	39 d8                	cmp    %ebx,%eax
80104e93:	76 1b                	jbe    80104eb0 <fetchint+0x30>
80104e95:	8d 53 04             	lea    0x4(%ebx),%edx
80104e98:	39 d0                	cmp    %edx,%eax
80104e9a:	72 14                	jb     80104eb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9f:	8b 13                	mov    (%ebx),%edx
80104ea1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ea3:	31 c0                	xor    %eax,%eax
}
80104ea5:	83 c4 04             	add    $0x4,%esp
80104ea8:	5b                   	pop    %ebx
80104ea9:	5d                   	pop    %ebp
80104eaa:	c3                   	ret    
80104eab:	90                   	nop
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb5:	eb ee                	jmp    80104ea5 <fetchint+0x25>
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	53                   	push   %ebx
80104ec4:	83 ec 04             	sub    $0x4,%esp
80104ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eca:	e8 e1 ee ff ff       	call   80103db0 <myproc>

  if(addr >= curproc->sz)
80104ecf:	39 18                	cmp    %ebx,(%eax)
80104ed1:	76 29                	jbe    80104efc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ed6:	89 da                	mov    %ebx,%edx
80104ed8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104eda:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104edc:	39 c3                	cmp    %eax,%ebx
80104ede:	73 1c                	jae    80104efc <fetchstr+0x3c>
    if(*s == 0)
80104ee0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ee3:	75 10                	jne    80104ef5 <fetchstr+0x35>
80104ee5:	eb 39                	jmp    80104f20 <fetchstr+0x60>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ef0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ef3:	74 1b                	je     80104f10 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ef5:	83 c2 01             	add    $0x1,%edx
80104ef8:	39 d0                	cmp    %edx,%eax
80104efa:	77 f4                	ja     80104ef0 <fetchstr+0x30>
    return -1;
80104efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f01:	83 c4 04             	add    $0x4,%esp
80104f04:	5b                   	pop    %ebx
80104f05:	5d                   	pop    %ebp
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f10:	83 c4 04             	add    $0x4,%esp
80104f13:	89 d0                	mov    %edx,%eax
80104f15:	29 d8                	sub    %ebx,%eax
80104f17:	5b                   	pop    %ebx
80104f18:	5d                   	pop    %ebp
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f20:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f22:	eb dd                	jmp    80104f01 <fetchstr+0x41>
80104f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f35:	e8 76 ee ff ff       	call   80103db0 <myproc>
80104f3a:	8b 40 18             	mov    0x18(%eax),%eax
80104f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f40:	8b 40 44             	mov    0x44(%eax),%eax
80104f43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f46:	e8 65 ee ff ff       	call   80103db0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f4b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f4d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f50:	39 c6                	cmp    %eax,%esi
80104f52:	73 1c                	jae    80104f70 <argint+0x40>
80104f54:	8d 53 08             	lea    0x8(%ebx),%edx
80104f57:	39 d0                	cmp    %edx,%eax
80104f59:	72 15                	jb     80104f70 <argint+0x40>
  *ip = *(int*)(addr);
80104f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f61:	89 10                	mov    %edx,(%eax)
  return 0;
80104f63:	31 c0                	xor    %eax,%eax
}
80104f65:	5b                   	pop    %ebx
80104f66:	5e                   	pop    %esi
80104f67:	5d                   	pop    %ebp
80104f68:	c3                   	ret    
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f75:	eb ee                	jmp    80104f65 <argint+0x35>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	83 ec 10             	sub    $0x10,%esp
80104f88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f8b:	e8 20 ee ff ff       	call   80103db0 <myproc>
80104f90:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104f92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f95:	83 ec 08             	sub    $0x8,%esp
80104f98:	50                   	push   %eax
80104f99:	ff 75 08             	pushl  0x8(%ebp)
80104f9c:	e8 8f ff ff ff       	call   80104f30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fa1:	83 c4 10             	add    $0x10,%esp
80104fa4:	85 c0                	test   %eax,%eax
80104fa6:	78 28                	js     80104fd0 <argptr+0x50>
80104fa8:	85 db                	test   %ebx,%ebx
80104faa:	78 24                	js     80104fd0 <argptr+0x50>
80104fac:	8b 16                	mov    (%esi),%edx
80104fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb1:	39 c2                	cmp    %eax,%edx
80104fb3:	76 1b                	jbe    80104fd0 <argptr+0x50>
80104fb5:	01 c3                	add    %eax,%ebx
80104fb7:	39 da                	cmp    %ebx,%edx
80104fb9:	72 15                	jb     80104fd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fbe:	89 02                	mov    %eax,(%edx)
  return 0;
80104fc0:	31 c0                	xor    %eax,%eax
}
80104fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fc5:	5b                   	pop    %ebx
80104fc6:	5e                   	pop    %esi
80104fc7:	5d                   	pop    %ebp
80104fc8:	c3                   	ret    
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	eb eb                	jmp    80104fc2 <argptr+0x42>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe9:	50                   	push   %eax
80104fea:	ff 75 08             	pushl  0x8(%ebp)
80104fed:	e8 3e ff ff ff       	call   80104f30 <argint>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	78 17                	js     80105010 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ff9:	83 ec 08             	sub    $0x8,%esp
80104ffc:	ff 75 0c             	pushl  0xc(%ebp)
80104fff:	ff 75 f4             	pushl  -0xc(%ebp)
80105002:	e8 b9 fe ff ff       	call   80104ec0 <fetchstr>
80105007:	83 c4 10             	add    $0x10,%esp
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <syscall>:
[SYS_get_pages_info]   sys_get_pages_info,
};

void
syscall(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105027:	e8 84 ed ff ff       	call   80103db0 <myproc>
8010502c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010502e:	8b 40 18             	mov    0x18(%eax),%eax
80105031:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105034:	8d 50 ff             	lea    -0x1(%eax),%edx
80105037:	83 fa 15             	cmp    $0x15,%edx
8010503a:	77 1c                	ja     80105058 <syscall+0x38>
8010503c:	8b 14 85 a0 8b 10 80 	mov    -0x7fef7460(,%eax,4),%edx
80105043:	85 d2                	test   %edx,%edx
80105045:	74 11                	je     80105058 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105047:	ff d2                	call   *%edx
80105049:	8b 53 18             	mov    0x18(%ebx),%edx
8010504c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010504f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105052:	c9                   	leave  
80105053:	c3                   	ret    
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105058:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105059:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010505c:	50                   	push   %eax
8010505d:	ff 73 10             	pushl  0x10(%ebx)
80105060:	68 69 8b 10 80       	push   $0x80108b69
80105065:	e8 f6 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010506a:	8b 43 18             	mov    0x18(%ebx),%eax
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	66 90                	xchg   %ax,%ax
8010507e:	66 90                	xchg   %ax,%ax

80105080 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105087:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010508a:	89 d6                	mov    %edx,%esi
8010508c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508f:	50                   	push   %eax
80105090:	6a 00                	push   $0x0
80105092:	e8 99 fe ff ff       	call   80104f30 <argint>
80105097:	83 c4 10             	add    $0x10,%esp
8010509a:	85 c0                	test   %eax,%eax
8010509c:	78 2a                	js     801050c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050a2:	77 24                	ja     801050c8 <argfd.constprop.0+0x48>
801050a4:	e8 07 ed ff ff       	call   80103db0 <myproc>
801050a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050b0:	85 c0                	test   %eax,%eax
801050b2:	74 14                	je     801050c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801050b4:	85 db                	test   %ebx,%ebx
801050b6:	74 02                	je     801050ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801050b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801050ba:	89 06                	mov    %eax,(%esi)
  return 0;
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5d                   	pop    %ebp
801050c4:	c3                   	ret    
801050c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb ef                	jmp    801050be <argfd.constprop.0+0x3e>
801050cf:	90                   	nop

801050d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801050d0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050d1:	31 c0                	xor    %eax,%eax
{
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	56                   	push   %esi
801050d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050dd:	e8 9e ff ff ff       	call   80105080 <argfd.constprop.0>
801050e2:	85 c0                	test   %eax,%eax
801050e4:	78 42                	js     80105128 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801050e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050eb:	e8 c0 ec ff ff       	call   80103db0 <myproc>
801050f0:	eb 0e                	jmp    80105100 <sys_dup+0x30>
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050f8:	83 c3 01             	add    $0x1,%ebx
801050fb:	83 fb 10             	cmp    $0x10,%ebx
801050fe:	74 28                	je     80105128 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105100:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105104:	85 d2                	test   %edx,%edx
80105106:	75 f0                	jne    801050f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105108:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	ff 75 f4             	pushl  -0xc(%ebp)
80105112:	e8 09 be ff ff       	call   80100f20 <filedup>
  return fd;
80105117:	83 c4 10             	add    $0x10,%esp
}
8010511a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511d:	89 d8                	mov    %ebx,%eax
8010511f:	5b                   	pop    %ebx
80105120:	5e                   	pop    %esi
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret    
80105123:	90                   	nop
80105124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105128:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010512b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105130:	89 d8                	mov    %ebx,%eax
80105132:	5b                   	pop    %ebx
80105133:	5e                   	pop    %esi
80105134:	5d                   	pop    %ebp
80105135:	c3                   	ret    
80105136:	8d 76 00             	lea    0x0(%esi),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <sys_read>:

int
sys_read(void)
{
80105140:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105141:	31 c0                	xor    %eax,%eax
{
80105143:	89 e5                	mov    %esp,%ebp
80105145:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105148:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010514b:	e8 30 ff ff ff       	call   80105080 <argfd.constprop.0>
80105150:	85 c0                	test   %eax,%eax
80105152:	78 4c                	js     801051a0 <sys_read+0x60>
80105154:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105157:	83 ec 08             	sub    $0x8,%esp
8010515a:	50                   	push   %eax
8010515b:	6a 02                	push   $0x2
8010515d:	e8 ce fd ff ff       	call   80104f30 <argint>
80105162:	83 c4 10             	add    $0x10,%esp
80105165:	85 c0                	test   %eax,%eax
80105167:	78 37                	js     801051a0 <sys_read+0x60>
80105169:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010516c:	83 ec 04             	sub    $0x4,%esp
8010516f:	ff 75 f0             	pushl  -0x10(%ebp)
80105172:	50                   	push   %eax
80105173:	6a 01                	push   $0x1
80105175:	e8 06 fe ff ff       	call   80104f80 <argptr>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	85 c0                	test   %eax,%eax
8010517f:	78 1f                	js     801051a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105181:	83 ec 04             	sub    $0x4,%esp
80105184:	ff 75 f0             	pushl  -0x10(%ebp)
80105187:	ff 75 f4             	pushl  -0xc(%ebp)
8010518a:	ff 75 ec             	pushl  -0x14(%ebp)
8010518d:	e8 fe be ff ff       	call   80101090 <fileread>
80105192:	83 c4 10             	add    $0x10,%esp
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_write>:

int
sys_write(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b1:	31 c0                	xor    %eax,%eax
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051bb:	e8 c0 fe ff ff       	call   80105080 <argfd.constprop.0>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 4c                	js     80105210 <sys_write+0x60>
801051c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	50                   	push   %eax
801051cb:	6a 02                	push   $0x2
801051cd:	e8 5e fd ff ff       	call   80104f30 <argint>
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	85 c0                	test   %eax,%eax
801051d7:	78 37                	js     80105210 <sys_write+0x60>
801051d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051dc:	83 ec 04             	sub    $0x4,%esp
801051df:	ff 75 f0             	pushl  -0x10(%ebp)
801051e2:	50                   	push   %eax
801051e3:	6a 01                	push   $0x1
801051e5:	e8 96 fd ff ff       	call   80104f80 <argptr>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	78 1f                	js     80105210 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801051f1:	83 ec 04             	sub    $0x4,%esp
801051f4:	ff 75 f0             	pushl  -0x10(%ebp)
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	ff 75 ec             	pushl  -0x14(%ebp)
801051fd:	e8 1e bf ff ff       	call   80101120 <filewrite>
80105202:	83 c4 10             	add    $0x10,%esp
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_close>:

int
sys_close(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105226:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105229:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010522c:	e8 4f fe ff ff       	call   80105080 <argfd.constprop.0>
80105231:	85 c0                	test   %eax,%eax
80105233:	78 2b                	js     80105260 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105235:	e8 76 eb ff ff       	call   80103db0 <myproc>
8010523a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010523d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105240:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105247:	00 
  fileclose(f);
80105248:	ff 75 f4             	pushl  -0xc(%ebp)
8010524b:	e8 20 bd ff ff       	call   80100f70 <fileclose>
  return 0;
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	31 c0                	xor    %eax,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_fstat>:

int
sys_fstat(void)
{
80105270:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105271:	31 c0                	xor    %eax,%eax
{
80105273:	89 e5                	mov    %esp,%ebp
80105275:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105278:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010527b:	e8 00 fe ff ff       	call   80105080 <argfd.constprop.0>
80105280:	85 c0                	test   %eax,%eax
80105282:	78 2c                	js     801052b0 <sys_fstat+0x40>
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 04             	sub    $0x4,%esp
8010528a:	6a 14                	push   $0x14
8010528c:	50                   	push   %eax
8010528d:	6a 01                	push   $0x1
8010528f:	e8 ec fc ff ff       	call   80104f80 <argptr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	78 15                	js     801052b0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010529b:	83 ec 08             	sub    $0x8,%esp
8010529e:	ff 75 f4             	pushl  -0xc(%ebp)
801052a1:	ff 75 f0             	pushl  -0x10(%ebp)
801052a4:	e8 97 bd ff ff       	call   80101040 <filestat>
801052a9:	83 c4 10             	add    $0x10,%esp
}
801052ac:	c9                   	leave  
801052ad:	c3                   	ret    
801052ae:	66 90                	xchg   %ax,%ax
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 0c fd ff ff       	call   80104fe0 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 fb 00 00 00    	js     801053da <sys_link+0x11a>
801052df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052e2:	83 ec 08             	sub    $0x8,%esp
801052e5:	50                   	push   %eax
801052e6:	6a 01                	push   $0x1
801052e8:	e8 f3 fc ff ff       	call   80104fe0 <argstr>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	0f 88 e2 00 00 00    	js     801053da <sys_link+0x11a>
    return -1;

  begin_op();
801052f8:	e8 f3 dd ff ff       	call   801030f0 <begin_op>
  if((ip = namei(old)) == 0){
801052fd:	83 ec 0c             	sub    $0xc,%esp
80105300:	ff 75 d4             	pushl  -0x2c(%ebp)
80105303:	e8 08 cd ff ff       	call   80102010 <namei>
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	85 c0                	test   %eax,%eax
8010530d:	89 c3                	mov    %eax,%ebx
8010530f:	0f 84 ea 00 00 00    	je     801053ff <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	50                   	push   %eax
80105319:	e8 92 c4 ff ff       	call   801017b0 <ilock>
  if(ip->type == T_DIR){
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105326:	0f 84 bb 00 00 00    	je     801053e7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010532c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105334:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105337:	53                   	push   %ebx
80105338:	e8 c3 c3 ff ff       	call   80101700 <iupdate>
  iunlock(ip);
8010533d:	89 1c 24             	mov    %ebx,(%esp)
80105340:	e8 4b c5 ff ff       	call   80101890 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105345:	58                   	pop    %eax
80105346:	5a                   	pop    %edx
80105347:	57                   	push   %edi
80105348:	ff 75 d0             	pushl  -0x30(%ebp)
8010534b:	e8 e0 cc ff ff       	call   80102030 <nameiparent>
80105350:	83 c4 10             	add    $0x10,%esp
80105353:	85 c0                	test   %eax,%eax
80105355:	89 c6                	mov    %eax,%esi
80105357:	74 5b                	je     801053b4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	50                   	push   %eax
8010535d:	e8 4e c4 ff ff       	call   801017b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	8b 03                	mov    (%ebx),%eax
80105367:	39 06                	cmp    %eax,(%esi)
80105369:	75 3d                	jne    801053a8 <sys_link+0xe8>
8010536b:	83 ec 04             	sub    $0x4,%esp
8010536e:	ff 73 04             	pushl  0x4(%ebx)
80105371:	57                   	push   %edi
80105372:	56                   	push   %esi
80105373:	e8 d8 cb ff ff       	call   80101f50 <dirlink>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	78 29                	js     801053a8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	56                   	push   %esi
80105383:	e8 b8 c6 ff ff       	call   80101a40 <iunlockput>
  iput(ip);
80105388:	89 1c 24             	mov    %ebx,(%esp)
8010538b:	e8 50 c5 ff ff       	call   801018e0 <iput>

  end_op();
80105390:	e8 cb dd ff ff       	call   80103160 <end_op>

  return 0;
80105395:	83 c4 10             	add    $0x10,%esp
80105398:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010539a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010539d:	5b                   	pop    %ebx
8010539e:	5e                   	pop    %esi
8010539f:	5f                   	pop    %edi
801053a0:	5d                   	pop    %ebp
801053a1:	c3                   	ret    
801053a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	56                   	push   %esi
801053ac:	e8 8f c6 ff ff       	call   80101a40 <iunlockput>
    goto bad;
801053b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	53                   	push   %ebx
801053b8:	e8 f3 c3 ff ff       	call   801017b0 <ilock>
  ip->nlink--;
801053bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053c2:	89 1c 24             	mov    %ebx,(%esp)
801053c5:	e8 36 c3 ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
801053ca:	89 1c 24             	mov    %ebx,(%esp)
801053cd:	e8 6e c6 ff ff       	call   80101a40 <iunlockput>
  end_op();
801053d2:	e8 89 dd ff ff       	call   80103160 <end_op>
  return -1;
801053d7:	83 c4 10             	add    $0x10,%esp
}
801053da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053e2:	5b                   	pop    %ebx
801053e3:	5e                   	pop    %esi
801053e4:	5f                   	pop    %edi
801053e5:	5d                   	pop    %ebp
801053e6:	c3                   	ret    
    iunlockput(ip);
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	53                   	push   %ebx
801053eb:	e8 50 c6 ff ff       	call   80101a40 <iunlockput>
    end_op();
801053f0:	e8 6b dd ff ff       	call   80103160 <end_op>
    return -1;
801053f5:	83 c4 10             	add    $0x10,%esp
801053f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053fd:	eb 9b                	jmp    8010539a <sys_link+0xda>
    end_op();
801053ff:	e8 5c dd ff ff       	call   80103160 <end_op>
    return -1;
80105404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105409:	eb 8f                	jmp    8010539a <sys_link+0xda>
8010540b:	90                   	nop
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
80105416:	83 ec 1c             	sub    $0x1c,%esp
80105419:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010541c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105420:	76 3e                	jbe    80105460 <isdirempty+0x50>
80105422:	bb 20 00 00 00       	mov    $0x20,%ebx
80105427:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010542a:	eb 0c                	jmp    80105438 <isdirempty+0x28>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105430:	83 c3 10             	add    $0x10,%ebx
80105433:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105436:	73 28                	jae    80105460 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105438:	6a 10                	push   $0x10
8010543a:	53                   	push   %ebx
8010543b:	57                   	push   %edi
8010543c:	56                   	push   %esi
8010543d:	e8 4e c6 ff ff       	call   80101a90 <readi>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	83 f8 10             	cmp    $0x10,%eax
80105448:	75 23                	jne    8010546d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010544a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010544f:	74 df                	je     80105430 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105451:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105454:	31 c0                	xor    %eax,%eax
}
80105456:	5b                   	pop    %ebx
80105457:	5e                   	pop    %esi
80105458:	5f                   	pop    %edi
80105459:	5d                   	pop    %ebp
8010545a:	c3                   	ret    
8010545b:	90                   	nop
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105463:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105468:	5b                   	pop    %ebx
80105469:	5e                   	pop    %esi
8010546a:	5f                   	pop    %edi
8010546b:	5d                   	pop    %ebp
8010546c:	c3                   	ret    
      panic("isdirempty: readi");
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	68 fc 8b 10 80       	push   $0x80108bfc
80105475:	e8 16 af ff ff       	call   80100390 <panic>
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105480 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
80105485:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105486:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105489:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010548c:	50                   	push   %eax
8010548d:	6a 00                	push   $0x0
8010548f:	e8 4c fb ff ff       	call   80104fe0 <argstr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	0f 88 51 01 00 00    	js     801055f0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010549f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801054a2:	e8 49 dc ff ff       	call   801030f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054a7:	83 ec 08             	sub    $0x8,%esp
801054aa:	53                   	push   %ebx
801054ab:	ff 75 c0             	pushl  -0x40(%ebp)
801054ae:	e8 7d cb ff ff       	call   80102030 <nameiparent>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	89 c6                	mov    %eax,%esi
801054ba:	0f 84 37 01 00 00    	je     801055f7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	50                   	push   %eax
801054c4:	e8 e7 c2 ff ff       	call   801017b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054c9:	58                   	pop    %eax
801054ca:	5a                   	pop    %edx
801054cb:	68 9d 85 10 80       	push   $0x8010859d
801054d0:	53                   	push   %ebx
801054d1:	e8 ea c7 ff ff       	call   80101cc0 <namecmp>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	85 c0                	test   %eax,%eax
801054db:	0f 84 d7 00 00 00    	je     801055b8 <sys_unlink+0x138>
801054e1:	83 ec 08             	sub    $0x8,%esp
801054e4:	68 9c 85 10 80       	push   $0x8010859c
801054e9:	53                   	push   %ebx
801054ea:	e8 d1 c7 ff ff       	call   80101cc0 <namecmp>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	85 c0                	test   %eax,%eax
801054f4:	0f 84 be 00 00 00    	je     801055b8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054fa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054fd:	83 ec 04             	sub    $0x4,%esp
80105500:	50                   	push   %eax
80105501:	53                   	push   %ebx
80105502:	56                   	push   %esi
80105503:	e8 d8 c7 ff ff       	call   80101ce0 <dirlookup>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	89 c3                	mov    %eax,%ebx
8010550f:	0f 84 a3 00 00 00    	je     801055b8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	50                   	push   %eax
80105519:	e8 92 c2 ff ff       	call   801017b0 <ilock>

  if(ip->nlink < 1)
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105526:	0f 8e e4 00 00 00    	jle    80105610 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010552c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105531:	74 65                	je     80105598 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105533:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105536:	83 ec 04             	sub    $0x4,%esp
80105539:	6a 10                	push   $0x10
8010553b:	6a 00                	push   $0x0
8010553d:	57                   	push   %edi
8010553e:	e8 ed f6 ff ff       	call   80104c30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105543:	6a 10                	push   $0x10
80105545:	ff 75 c4             	pushl  -0x3c(%ebp)
80105548:	57                   	push   %edi
80105549:	56                   	push   %esi
8010554a:	e8 41 c6 ff ff       	call   80101b90 <writei>
8010554f:	83 c4 20             	add    $0x20,%esp
80105552:	83 f8 10             	cmp    $0x10,%eax
80105555:	0f 85 a8 00 00 00    	jne    80105603 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010555b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105560:	74 6e                	je     801055d0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105562:	83 ec 0c             	sub    $0xc,%esp
80105565:	56                   	push   %esi
80105566:	e8 d5 c4 ff ff       	call   80101a40 <iunlockput>

  ip->nlink--;
8010556b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105570:	89 1c 24             	mov    %ebx,(%esp)
80105573:	e8 88 c1 ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
80105578:	89 1c 24             	mov    %ebx,(%esp)
8010557b:	e8 c0 c4 ff ff       	call   80101a40 <iunlockput>

  end_op();
80105580:	e8 db db ff ff       	call   80103160 <end_op>

  return 0;
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010558a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010558d:	5b                   	pop    %ebx
8010558e:	5e                   	pop    %esi
8010558f:	5f                   	pop    %edi
80105590:	5d                   	pop    %ebp
80105591:	c3                   	ret    
80105592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	53                   	push   %ebx
8010559c:	e8 6f fe ff ff       	call   80105410 <isdirempty>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	75 8b                	jne    80105533 <sys_unlink+0xb3>
    iunlockput(ip);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	53                   	push   %ebx
801055ac:	e8 8f c4 ff ff       	call   80101a40 <iunlockput>
    goto bad;
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	56                   	push   %esi
801055bc:	e8 7f c4 ff ff       	call   80101a40 <iunlockput>
  end_op();
801055c1:	e8 9a db ff ff       	call   80103160 <end_op>
  return -1;
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ce:	eb ba                	jmp    8010558a <sys_unlink+0x10a>
    dp->nlink--;
801055d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	56                   	push   %esi
801055d9:	e8 22 c1 ff ff       	call   80101700 <iupdate>
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	e9 7c ff ff ff       	jmp    80105562 <sys_unlink+0xe2>
801055e6:	8d 76 00             	lea    0x0(%esi),%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f5:	eb 93                	jmp    8010558a <sys_unlink+0x10a>
    end_op();
801055f7:	e8 64 db ff ff       	call   80103160 <end_op>
    return -1;
801055fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105601:	eb 87                	jmp    8010558a <sys_unlink+0x10a>
    panic("unlink: writei");
80105603:	83 ec 0c             	sub    $0xc,%esp
80105606:	68 b1 85 10 80       	push   $0x801085b1
8010560b:	e8 80 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	68 9f 85 10 80       	push   $0x8010859f
80105618:	e8 73 ad ff ff       	call   80100390 <panic>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi

80105620 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
80105625:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105626:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105629:	83 ec 34             	sub    $0x34,%esp
8010562c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562f:	8b 55 10             	mov    0x10(%ebp),%edx
80105632:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105635:	56                   	push   %esi
80105636:	ff 75 08             	pushl  0x8(%ebp)
{
80105639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010563c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010563f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105642:	e8 e9 c9 ff ff       	call   80102030 <nameiparent>
80105647:	83 c4 10             	add    $0x10,%esp
8010564a:	85 c0                	test   %eax,%eax
8010564c:	0f 84 4e 01 00 00    	je     801057a0 <create+0x180>
    return 0;
  ilock(dp);
80105652:	83 ec 0c             	sub    $0xc,%esp
80105655:	89 c3                	mov    %eax,%ebx
80105657:	50                   	push   %eax
80105658:	e8 53 c1 ff ff       	call   801017b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010565d:	83 c4 0c             	add    $0xc,%esp
80105660:	6a 00                	push   $0x0
80105662:	56                   	push   %esi
80105663:	53                   	push   %ebx
80105664:	e8 77 c6 ff ff       	call   80101ce0 <dirlookup>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	89 c7                	mov    %eax,%edi
80105670:	74 3e                	je     801056b0 <create+0x90>
    iunlockput(dp);
80105672:	83 ec 0c             	sub    $0xc,%esp
80105675:	53                   	push   %ebx
80105676:	e8 c5 c3 ff ff       	call   80101a40 <iunlockput>
    ilock(ip);
8010567b:	89 3c 24             	mov    %edi,(%esp)
8010567e:	e8 2d c1 ff ff       	call   801017b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010568b:	0f 85 9f 00 00 00    	jne    80105730 <create+0x110>
80105691:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105696:	0f 85 94 00 00 00    	jne    80105730 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010569c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569f:	89 f8                	mov    %edi,%eax
801056a1:	5b                   	pop    %ebx
801056a2:	5e                   	pop    %esi
801056a3:	5f                   	pop    %edi
801056a4:	5d                   	pop    %ebp
801056a5:	c3                   	ret    
801056a6:	8d 76 00             	lea    0x0(%esi),%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
801056b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801056b4:	83 ec 08             	sub    $0x8,%esp
801056b7:	50                   	push   %eax
801056b8:	ff 33                	pushl  (%ebx)
801056ba:	e8 81 bf ff ff       	call   80101640 <ialloc>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	89 c7                	mov    %eax,%edi
801056c6:	0f 84 e8 00 00 00    	je     801057b4 <create+0x194>
  ilock(ip);
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	50                   	push   %eax
801056d0:	e8 db c0 ff ff       	call   801017b0 <ilock>
  ip->major = major;
801056d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801056d9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801056dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801056e1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801056e5:	b8 01 00 00 00       	mov    $0x1,%eax
801056ea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801056ee:	89 3c 24             	mov    %edi,(%esp)
801056f1:	e8 0a c0 ff ff       	call   80101700 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056fe:	74 50                	je     80105750 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105700:	83 ec 04             	sub    $0x4,%esp
80105703:	ff 77 04             	pushl  0x4(%edi)
80105706:	56                   	push   %esi
80105707:	53                   	push   %ebx
80105708:	e8 43 c8 ff ff       	call   80101f50 <dirlink>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	0f 88 8f 00 00 00    	js     801057a7 <create+0x187>
  iunlockput(dp);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	53                   	push   %ebx
8010571c:	e8 1f c3 ff ff       	call   80101a40 <iunlockput>
  return ip;
80105721:	83 c4 10             	add    $0x10,%esp
}
80105724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105727:	89 f8                	mov    %edi,%eax
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5f                   	pop    %edi
8010572c:	5d                   	pop    %ebp
8010572d:	c3                   	ret    
8010572e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	57                   	push   %edi
    return 0;
80105734:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105736:	e8 05 c3 ff ff       	call   80101a40 <iunlockput>
    return 0;
8010573b:	83 c4 10             	add    $0x10,%esp
}
8010573e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105741:	89 f8                	mov    %edi,%eax
80105743:	5b                   	pop    %ebx
80105744:	5e                   	pop    %esi
80105745:	5f                   	pop    %edi
80105746:	5d                   	pop    %ebp
80105747:	c3                   	ret    
80105748:	90                   	nop
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105750:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	53                   	push   %ebx
80105759:	e8 a2 bf ff ff       	call   80101700 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010575e:	83 c4 0c             	add    $0xc,%esp
80105761:	ff 77 04             	pushl  0x4(%edi)
80105764:	68 9d 85 10 80       	push   $0x8010859d
80105769:	57                   	push   %edi
8010576a:	e8 e1 c7 ff ff       	call   80101f50 <dirlink>
8010576f:	83 c4 10             	add    $0x10,%esp
80105772:	85 c0                	test   %eax,%eax
80105774:	78 1c                	js     80105792 <create+0x172>
80105776:	83 ec 04             	sub    $0x4,%esp
80105779:	ff 73 04             	pushl  0x4(%ebx)
8010577c:	68 9c 85 10 80       	push   $0x8010859c
80105781:	57                   	push   %edi
80105782:	e8 c9 c7 ff ff       	call   80101f50 <dirlink>
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	85 c0                	test   %eax,%eax
8010578c:	0f 89 6e ff ff ff    	jns    80105700 <create+0xe0>
      panic("create dots");
80105792:	83 ec 0c             	sub    $0xc,%esp
80105795:	68 1d 8c 10 80       	push   $0x80108c1d
8010579a:	e8 f1 ab ff ff       	call   80100390 <panic>
8010579f:	90                   	nop
    return 0;
801057a0:	31 ff                	xor    %edi,%edi
801057a2:	e9 f5 fe ff ff       	jmp    8010569c <create+0x7c>
    panic("create: dirlink");
801057a7:	83 ec 0c             	sub    $0xc,%esp
801057aa:	68 29 8c 10 80       	push   $0x80108c29
801057af:	e8 dc ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057b4:	83 ec 0c             	sub    $0xc,%esp
801057b7:	68 0e 8c 10 80       	push   $0x80108c0e
801057bc:	e8 cf ab ff ff       	call   80100390 <panic>
801057c1:	eb 0d                	jmp    801057d0 <sys_open>
801057c3:	90                   	nop
801057c4:	90                   	nop
801057c5:	90                   	nop
801057c6:	90                   	nop
801057c7:	90                   	nop
801057c8:	90                   	nop
801057c9:	90                   	nop
801057ca:	90                   	nop
801057cb:	90                   	nop
801057cc:	90                   	nop
801057cd:	90                   	nop
801057ce:	90                   	nop
801057cf:	90                   	nop

801057d0 <sys_open>:

int
sys_open(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801057d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057dc:	50                   	push   %eax
801057dd:	6a 00                	push   $0x0
801057df:	e8 fc f7 ff ff       	call   80104fe0 <argstr>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	0f 88 1d 01 00 00    	js     8010590c <sys_open+0x13c>
801057ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057f2:	83 ec 08             	sub    $0x8,%esp
801057f5:	50                   	push   %eax
801057f6:	6a 01                	push   $0x1
801057f8:	e8 33 f7 ff ff       	call   80104f30 <argint>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	0f 88 04 01 00 00    	js     8010590c <sys_open+0x13c>
    return -1;

  begin_op();
80105808:	e8 e3 d8 ff ff       	call   801030f0 <begin_op>

  if(omode & O_CREATE){
8010580d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105811:	0f 85 a9 00 00 00    	jne    801058c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	ff 75 e0             	pushl  -0x20(%ebp)
8010581d:	e8 ee c7 ff ff       	call   80102010 <namei>
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	85 c0                	test   %eax,%eax
80105827:	89 c6                	mov    %eax,%esi
80105829:	0f 84 ac 00 00 00    	je     801058db <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010582f:	83 ec 0c             	sub    $0xc,%esp
80105832:	50                   	push   %eax
80105833:	e8 78 bf ff ff       	call   801017b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105838:	83 c4 10             	add    $0x10,%esp
8010583b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105840:	0f 84 aa 00 00 00    	je     801058f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105846:	e8 65 b6 ff ff       	call   80100eb0 <filealloc>
8010584b:	85 c0                	test   %eax,%eax
8010584d:	89 c7                	mov    %eax,%edi
8010584f:	0f 84 a6 00 00 00    	je     801058fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105855:	e8 56 e5 ff ff       	call   80103db0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010585a:	31 db                	xor    %ebx,%ebx
8010585c:	eb 0e                	jmp    8010586c <sys_open+0x9c>
8010585e:	66 90                	xchg   %ax,%ax
80105860:	83 c3 01             	add    $0x1,%ebx
80105863:	83 fb 10             	cmp    $0x10,%ebx
80105866:	0f 84 ac 00 00 00    	je     80105918 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010586c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105870:	85 d2                	test   %edx,%edx
80105872:	75 ec                	jne    80105860 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105874:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105877:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010587b:	56                   	push   %esi
8010587c:	e8 0f c0 ff ff       	call   80101890 <iunlock>
  end_op();
80105881:	e8 da d8 ff ff       	call   80103160 <end_op>

  f->type = FD_INODE;
80105886:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010588c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010588f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105892:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105895:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010589c:	89 d0                	mov    %edx,%eax
8010589e:	f7 d0                	not    %eax
801058a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b0:	89 d8                	mov    %ebx,%eax
801058b2:	5b                   	pop    %ebx
801058b3:	5e                   	pop    %esi
801058b4:	5f                   	pop    %edi
801058b5:	5d                   	pop    %ebp
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801058c0:	6a 00                	push   $0x0
801058c2:	6a 00                	push   $0x0
801058c4:	6a 02                	push   $0x2
801058c6:	ff 75 e0             	pushl  -0x20(%ebp)
801058c9:	e8 52 fd ff ff       	call   80105620 <create>
    if(ip == 0){
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801058d3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058d5:	0f 85 6b ff ff ff    	jne    80105846 <sys_open+0x76>
      end_op();
801058db:	e8 80 d8 ff ff       	call   80103160 <end_op>
      return -1;
801058e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058e5:	eb c6                	jmp    801058ad <sys_open+0xdd>
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
801058f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058f3:	85 c9                	test   %ecx,%ecx
801058f5:	0f 84 4b ff ff ff    	je     80105846 <sys_open+0x76>
    iunlockput(ip);
801058fb:	83 ec 0c             	sub    $0xc,%esp
801058fe:	56                   	push   %esi
801058ff:	e8 3c c1 ff ff       	call   80101a40 <iunlockput>
    end_op();
80105904:	e8 57 d8 ff ff       	call   80103160 <end_op>
    return -1;
80105909:	83 c4 10             	add    $0x10,%esp
8010590c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105911:	eb 9a                	jmp    801058ad <sys_open+0xdd>
80105913:	90                   	nop
80105914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	57                   	push   %edi
8010591c:	e8 4f b6 ff ff       	call   80100f70 <fileclose>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	eb d5                	jmp    801058fb <sys_open+0x12b>
80105926:	8d 76 00             	lea    0x0(%esi),%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <sys_mkdir>:

int
sys_mkdir(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105936:	e8 b5 d7 ff ff       	call   801030f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010593b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593e:	83 ec 08             	sub    $0x8,%esp
80105941:	50                   	push   %eax
80105942:	6a 00                	push   $0x0
80105944:	e8 97 f6 ff ff       	call   80104fe0 <argstr>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	85 c0                	test   %eax,%eax
8010594e:	78 30                	js     80105980 <sys_mkdir+0x50>
80105950:	6a 00                	push   $0x0
80105952:	6a 00                	push   $0x0
80105954:	6a 01                	push   $0x1
80105956:	ff 75 f4             	pushl  -0xc(%ebp)
80105959:	e8 c2 fc ff ff       	call   80105620 <create>
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	85 c0                	test   %eax,%eax
80105963:	74 1b                	je     80105980 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105965:	83 ec 0c             	sub    $0xc,%esp
80105968:	50                   	push   %eax
80105969:	e8 d2 c0 ff ff       	call   80101a40 <iunlockput>
  end_op();
8010596e:	e8 ed d7 ff ff       	call   80103160 <end_op>
  return 0;
80105973:	83 c4 10             	add    $0x10,%esp
80105976:	31 c0                	xor    %eax,%eax
}
80105978:	c9                   	leave  
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105980:	e8 db d7 ff ff       	call   80103160 <end_op>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_mknod>:

int
sys_mknod(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105996:	e8 55 d7 ff ff       	call   801030f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010599b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010599e:	83 ec 08             	sub    $0x8,%esp
801059a1:	50                   	push   %eax
801059a2:	6a 00                	push   $0x0
801059a4:	e8 37 f6 ff ff       	call   80104fe0 <argstr>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	85 c0                	test   %eax,%eax
801059ae:	78 60                	js     80105a10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801059b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059b3:	83 ec 08             	sub    $0x8,%esp
801059b6:	50                   	push   %eax
801059b7:	6a 01                	push   $0x1
801059b9:	e8 72 f5 ff ff       	call   80104f30 <argint>
  if((argstr(0, &path)) < 0 ||
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	85 c0                	test   %eax,%eax
801059c3:	78 4b                	js     80105a10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801059c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c8:	83 ec 08             	sub    $0x8,%esp
801059cb:	50                   	push   %eax
801059cc:	6a 02                	push   $0x2
801059ce:	e8 5d f5 ff ff       	call   80104f30 <argint>
     argint(1, &major) < 0 ||
801059d3:	83 c4 10             	add    $0x10,%esp
801059d6:	85 c0                	test   %eax,%eax
801059d8:	78 36                	js     80105a10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801059da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801059de:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801059df:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801059e3:	50                   	push   %eax
801059e4:	6a 03                	push   $0x3
801059e6:	ff 75 ec             	pushl  -0x14(%ebp)
801059e9:	e8 32 fc ff ff       	call   80105620 <create>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	74 1b                	je     80105a10 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 42 c0 ff ff       	call   80101a40 <iunlockput>
  end_op();
801059fe:	e8 5d d7 ff ff       	call   80103160 <end_op>
  return 0;
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	31 c0                	xor    %eax,%eax
}
80105a08:	c9                   	leave  
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a10:	e8 4b d7 ff ff       	call   80103160 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_chdir>:

int
sys_chdir(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	56                   	push   %esi
80105a24:	53                   	push   %ebx
80105a25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a28:	e8 83 e3 ff ff       	call   80103db0 <myproc>
80105a2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a2f:	e8 bc d6 ff ff       	call   801030f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a37:	83 ec 08             	sub    $0x8,%esp
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 9e f5 ff ff       	call   80104fe0 <argstr>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 77                	js     80105ac0 <sys_chdir+0xa0>
80105a49:	83 ec 0c             	sub    $0xc,%esp
80105a4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4f:	e8 bc c5 ff ff       	call   80102010 <namei>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	89 c3                	mov    %eax,%ebx
80105a5b:	74 63                	je     80105ac0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	50                   	push   %eax
80105a61:	e8 4a bd ff ff       	call   801017b0 <ilock>
  if(ip->type != T_DIR){
80105a66:	83 c4 10             	add    $0x10,%esp
80105a69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a6e:	75 30                	jne    80105aa0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	53                   	push   %ebx
80105a74:	e8 17 be ff ff       	call   80101890 <iunlock>
  iput(curproc->cwd);
80105a79:	58                   	pop    %eax
80105a7a:	ff 76 68             	pushl  0x68(%esi)
80105a7d:	e8 5e be ff ff       	call   801018e0 <iput>
  end_op();
80105a82:	e8 d9 d6 ff ff       	call   80103160 <end_op>
  curproc->cwd = ip;
80105a87:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	31 c0                	xor    %eax,%eax
}
80105a8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a92:	5b                   	pop    %ebx
80105a93:	5e                   	pop    %esi
80105a94:	5d                   	pop    %ebp
80105a95:	c3                   	ret    
80105a96:	8d 76 00             	lea    0x0(%esi),%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	53                   	push   %ebx
80105aa4:	e8 97 bf ff ff       	call   80101a40 <iunlockput>
    end_op();
80105aa9:	e8 b2 d6 ff ff       	call   80103160 <end_op>
    return -1;
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab6:	eb d7                	jmp    80105a8f <sys_chdir+0x6f>
80105ab8:	90                   	nop
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ac0:	e8 9b d6 ff ff       	call   80103160 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aca:	eb c3                	jmp    80105a8f <sys_chdir+0x6f>
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_exec>:

int
sys_exec(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ad6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105adc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ae2:	50                   	push   %eax
80105ae3:	6a 00                	push   $0x0
80105ae5:	e8 f6 f4 ff ff       	call   80104fe0 <argstr>
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	85 c0                	test   %eax,%eax
80105aef:	0f 88 87 00 00 00    	js     80105b7c <sys_exec+0xac>
80105af5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105afb:	83 ec 08             	sub    $0x8,%esp
80105afe:	50                   	push   %eax
80105aff:	6a 01                	push   $0x1
80105b01:	e8 2a f4 ff ff       	call   80104f30 <argint>
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	78 6f                	js     80105b7c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b0d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b13:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105b16:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b18:	68 80 00 00 00       	push   $0x80
80105b1d:	6a 00                	push   $0x0
80105b1f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b25:	50                   	push   %eax
80105b26:	e8 05 f1 ff ff       	call   80104c30 <memset>
80105b2b:	83 c4 10             	add    $0x10,%esp
80105b2e:	eb 2c                	jmp    80105b5c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105b30:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b36:	85 c0                	test   %eax,%eax
80105b38:	74 56                	je     80105b90 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b3a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b40:	83 ec 08             	sub    $0x8,%esp
80105b43:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b46:	52                   	push   %edx
80105b47:	50                   	push   %eax
80105b48:	e8 73 f3 ff ff       	call   80104ec0 <fetchstr>
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	85 c0                	test   %eax,%eax
80105b52:	78 28                	js     80105b7c <sys_exec+0xac>
  for(i=0;; i++){
80105b54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b57:	83 fb 20             	cmp    $0x20,%ebx
80105b5a:	74 20                	je     80105b7c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b5c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b62:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b69:	83 ec 08             	sub    $0x8,%esp
80105b6c:	57                   	push   %edi
80105b6d:	01 f0                	add    %esi,%eax
80105b6f:	50                   	push   %eax
80105b70:	e8 0b f3 ff ff       	call   80104e80 <fetchint>
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	85 c0                	test   %eax,%eax
80105b7a:	79 b4                	jns    80105b30 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b84:	5b                   	pop    %ebx
80105b85:	5e                   	pop    %esi
80105b86:	5f                   	pop    %edi
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b96:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105b99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ba0:	00 00 00 00 
  return exec(path, argv);
80105ba4:	50                   	push   %eax
80105ba5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bab:	e8 60 ae ff ff       	call   80100a10 <exec>
80105bb0:	83 c4 10             	add    $0x10,%esp
}
80105bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5f                   	pop    %edi
80105bb9:	5d                   	pop    %ebp
80105bba:	c3                   	ret    
80105bbb:	90                   	nop
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_pipe>:

int
sys_pipe(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	56                   	push   %esi
80105bc5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bc6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105bc9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bcc:	6a 08                	push   $0x8
80105bce:	50                   	push   %eax
80105bcf:	6a 00                	push   $0x0
80105bd1:	e8 aa f3 ff ff       	call   80104f80 <argptr>
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	0f 88 ae 00 00 00    	js     80105c8f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105be1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105be4:	83 ec 08             	sub    $0x8,%esp
80105be7:	50                   	push   %eax
80105be8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105beb:	50                   	push   %eax
80105bec:	e8 9f db ff ff       	call   80103790 <pipealloc>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	0f 88 93 00 00 00    	js     80105c8f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bfc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105bff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c01:	e8 aa e1 ff ff       	call   80103db0 <myproc>
80105c06:	eb 10                	jmp    80105c18 <sys_pipe+0x58>
80105c08:	90                   	nop
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c10:	83 c3 01             	add    $0x1,%ebx
80105c13:	83 fb 10             	cmp    $0x10,%ebx
80105c16:	74 60                	je     80105c78 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105c18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c1c:	85 f6                	test   %esi,%esi
80105c1e:	75 f0                	jne    80105c10 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105c20:	8d 73 08             	lea    0x8(%ebx),%esi
80105c23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c2a:	e8 81 e1 ff ff       	call   80103db0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c2f:	31 d2                	xor    %edx,%edx
80105c31:	eb 0d                	jmp    80105c40 <sys_pipe+0x80>
80105c33:	90                   	nop
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c38:	83 c2 01             	add    $0x1,%edx
80105c3b:	83 fa 10             	cmp    $0x10,%edx
80105c3e:	74 28                	je     80105c68 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105c40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c44:	85 c9                	test   %ecx,%ecx
80105c46:	75 f0                	jne    80105c38 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105c48:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c57:	31 c0                	xor    %eax,%eax
}
80105c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c5c:	5b                   	pop    %ebx
80105c5d:	5e                   	pop    %esi
80105c5e:	5f                   	pop    %edi
80105c5f:	5d                   	pop    %ebp
80105c60:	c3                   	ret    
80105c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c68:	e8 43 e1 ff ff       	call   80103db0 <myproc>
80105c6d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c74:	00 
80105c75:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c7e:	e8 ed b2 ff ff       	call   80100f70 <fileclose>
    fileclose(wf);
80105c83:	58                   	pop    %eax
80105c84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c87:	e8 e4 b2 ff ff       	call   80100f70 <fileclose>
    return -1;
80105c8c:	83 c4 10             	add    $0x10,%esp
80105c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c94:	eb c3                	jmp    80105c59 <sys_pipe+0x99>
80105c96:	66 90                	xchg   %ax,%ax
80105c98:	66 90                	xchg   %ax,%ax
80105c9a:	66 90                	xchg   %ax,%ax
80105c9c:	66 90                	xchg   %ax,%ax
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ca3:	5d                   	pop    %ebp
  return fork();
80105ca4:	e9 a7 e2 ff ff       	jmp    80103f50 <fork>
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exit>:

int
sys_exit(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cb6:	e8 35 e6 ff ff       	call   801042f0 <exit>
  return 0;  // not reached
}
80105cbb:	31 c0                	xor    %eax,%eax
80105cbd:	c9                   	leave  
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <sys_wait>:

int
sys_wait(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105cc3:	5d                   	pop    %ebp
  return wait();
80105cc4:	e9 87 e8 ff ff       	jmp    80104550 <wait>
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_kill>:

int
sys_kill(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 4f f2 ff ff       	call   80104f30 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 18                	js     80105d00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cee:	e8 1d ea ff ff       	call   80104710 <kill>
80105cf3:	83 c4 10             	add    $0x10,%esp
}
80105cf6:	c9                   	leave  
80105cf7:	c3                   	ret    
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <sys_getpid>:

int
sys_getpid(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  //   cprintf("%s%d%s", "the ", i, " place: ");
  //   cprintf("%s%d%s%d", "ram: ", p->ramPages[i], " file: ",p->swapPages[i]);
  //   cprintf("\n");
  // }
  // return 0;
  return myproc()->pid;
80105d16:	e8 95 e0 ff ff       	call   80103db0 <myproc>
80105d1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d1e:	c9                   	leave  
80105d1f:	c3                   	ret    

80105d20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 fe f1 ff ff       	call   80104f30 <argint>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 27                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d39:	e8 72 e0 ff ff       	call   80103db0 <myproc>
  if(growproc(n) < 0)
80105d3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d43:	ff 75 f4             	pushl  -0xc(%ebp)
80105d46:	e8 85 e1 ff ff       	call   80103ed0 <growproc>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	85 c0                	test   %eax,%eax
80105d50:	78 0e                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d52:	89 d8                	mov    %ebx,%eax
80105d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d57:	c9                   	leave  
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d65:	eb eb                	jmp    80105d52 <sys_sbrk+0x32>
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_sleep>:

int
sys_sleep(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 ae f1 ff ff       	call   80104f30 <argint>
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	85 c0                	test   %eax,%eax
80105d87:	0f 88 8a 00 00 00    	js     80105e17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	68 80 c1 11 80       	push   $0x8011c180
80105d95:	e8 86 ed ff ff       	call   80104b20 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105da0:	8b 1d c0 c9 11 80    	mov    0x8011c9c0,%ebx
  while(ticks - ticks0 < n){
80105da6:	85 d2                	test   %edx,%edx
80105da8:	75 27                	jne    80105dd1 <sys_sleep+0x61>
80105daa:	eb 54                	jmp    80105e00 <sys_sleep+0x90>
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105db0:	83 ec 08             	sub    $0x8,%esp
80105db3:	68 80 c1 11 80       	push   $0x8011c180
80105db8:	68 c0 c9 11 80       	push   $0x8011c9c0
80105dbd:	e8 ce e6 ff ff       	call   80104490 <sleep>
  while(ticks - ticks0 < n){
80105dc2:	a1 c0 c9 11 80       	mov    0x8011c9c0,%eax
80105dc7:	83 c4 10             	add    $0x10,%esp
80105dca:	29 d8                	sub    %ebx,%eax
80105dcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105dcf:	73 2f                	jae    80105e00 <sys_sleep+0x90>
    if(myproc()->killed){
80105dd1:	e8 da df ff ff       	call   80103db0 <myproc>
80105dd6:	8b 40 24             	mov    0x24(%eax),%eax
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	74 d3                	je     80105db0 <sys_sleep+0x40>
      release(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 80 c1 11 80       	push   $0x8011c180
80105de5:	e8 f6 ed ff ff       	call   80104be0 <release>
      return -1;
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105df2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	68 80 c1 11 80       	push   $0x8011c180
80105e08:	e8 d3 ed ff ff       	call   80104be0 <release>
  return 0;
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	31 c0                	xor    %eax,%eax
}
80105e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
    return -1;
80105e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1c:	eb f4                	jmp    80105e12 <sys_sleep+0xa2>
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	53                   	push   %ebx
80105e24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e27:	68 80 c1 11 80       	push   $0x8011c180
80105e2c:	e8 ef ec ff ff       	call   80104b20 <acquire>
  xticks = ticks;
80105e31:	8b 1d c0 c9 11 80    	mov    0x8011c9c0,%ebx
  release(&tickslock);
80105e37:	c7 04 24 80 c1 11 80 	movl   $0x8011c180,(%esp)
80105e3e:	e8 9d ed ff ff       	call   80104be0 <release>
  return xticks;
}
80105e43:	89 d8                	mov    %ebx,%eax
80105e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e48:	c9                   	leave  
80105e49:	c3                   	ret    
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e50 <sys_get_pages_info>:

// Print system pages info
int
sys_get_pages_info(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 08             	sub    $0x8,%esp
	cprintf("%s%d\n", "Number of free pages: ", getNumberOfFreePages());
80105e56:	e8 05 cc ff ff       	call   80102a60 <getNumberOfFreePages>
80105e5b:	83 ec 04             	sub    $0x4,%esp
80105e5e:	50                   	push   %eax
80105e5f:	68 39 8c 10 80       	push   $0x80108c39
80105e64:	68 50 8c 10 80       	push   $0x80108c50
80105e69:	e8 f2 a7 ff ff       	call   80100660 <cprintf>
	return 0;
80105e6e:	31 c0                	xor    %eax,%eax
80105e70:	c9                   	leave  
80105e71:	c3                   	ret    

80105e72 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e72:	1e                   	push   %ds
  pushl %es
80105e73:	06                   	push   %es
  pushl %fs
80105e74:	0f a0                	push   %fs
  pushl %gs
80105e76:	0f a8                	push   %gs
  pushal
80105e78:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e79:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e7d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e7f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e81:	54                   	push   %esp
  call trap
80105e82:	e8 c9 00 00 00       	call   80105f50 <trap>
  addl $4, %esp
80105e87:	83 c4 04             	add    $0x4,%esp

80105e8a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e8a:	61                   	popa   
  popl %gs
80105e8b:	0f a9                	pop    %gs
  popl %fs
80105e8d:	0f a1                	pop    %fs
  popl %es
80105e8f:	07                   	pop    %es
  popl %ds
80105e90:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e91:	83 c4 08             	add    $0x8,%esp
  iret
80105e94:	cf                   	iret   
80105e95:	66 90                	xchg   %ax,%ax
80105e97:	66 90                	xchg   %ax,%ax
80105e99:	66 90                	xchg   %ax,%ax
80105e9b:	66 90                	xchg   %ax,%ax
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ea0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ea1:	31 c0                	xor    %eax,%eax
{
80105ea3:	89 e5                	mov    %esp,%ebp
80105ea5:	83 ec 08             	sub    $0x8,%esp
80105ea8:	90                   	nop
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105eb0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105eb7:	c7 04 c5 c2 c1 11 80 	movl   $0x8e000008,-0x7fee3e3e(,%eax,8)
80105ebe:	08 00 00 8e 
80105ec2:	66 89 14 c5 c0 c1 11 	mov    %dx,-0x7fee3e40(,%eax,8)
80105ec9:	80 
80105eca:	c1 ea 10             	shr    $0x10,%edx
80105ecd:	66 89 14 c5 c6 c1 11 	mov    %dx,-0x7fee3e3a(,%eax,8)
80105ed4:	80 
  for(i = 0; i < 256; i++)
80105ed5:	83 c0 01             	add    $0x1,%eax
80105ed8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105edd:	75 d1                	jne    80105eb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105edf:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80105ee4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ee7:	c7 05 c2 c3 11 80 08 	movl   $0xef000008,0x8011c3c2
80105eee:	00 00 ef 
  initlock(&tickslock, "time");
80105ef1:	68 56 8c 10 80       	push   $0x80108c56
80105ef6:	68 80 c1 11 80       	push   $0x8011c180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105efb:	66 a3 c0 c3 11 80    	mov    %ax,0x8011c3c0
80105f01:	c1 e8 10             	shr    $0x10,%eax
80105f04:	66 a3 c6 c3 11 80    	mov    %ax,0x8011c3c6
  initlock(&tickslock, "time");
80105f0a:	e8 d1 ea ff ff       	call   801049e0 <initlock>
}
80105f0f:	83 c4 10             	add    $0x10,%esp
80105f12:	c9                   	leave  
80105f13:	c3                   	ret    
80105f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f20 <idtinit>:

void
idtinit(void)
{
80105f20:	55                   	push   %ebp
  pd[0] = size-1;
80105f21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f26:	89 e5                	mov    %esp,%ebp
80105f28:	83 ec 10             	sub    $0x10,%esp
80105f2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f2f:	b8 c0 c1 11 80       	mov    $0x8011c1c0,%eax
80105f34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f38:	c1 e8 10             	shr    $0x10,%eax
80105f3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	57                   	push   %edi
80105f54:	56                   	push   %esi
80105f55:	53                   	push   %ebx
80105f56:	83 ec 1c             	sub    $0x1c,%esp
80105f59:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f5c:	8b 47 30             	mov    0x30(%edi),%eax
80105f5f:	83 f8 40             	cmp    $0x40,%eax
80105f62:	0f 84 f0 00 00 00    	je     80106058 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f68:	83 e8 0e             	sub    $0xe,%eax
80105f6b:	83 f8 31             	cmp    $0x31,%eax
80105f6e:	77 10                	ja     80105f80 <trap+0x30>
80105f70:	ff 24 85 08 8d 10 80 	jmp    *-0x7fef72f8(,%eax,4)
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }


  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f80:	e8 2b de ff ff       	call   80103db0 <myproc>
80105f85:	85 c0                	test   %eax,%eax
80105f87:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f8a:	0f 84 94 02 00 00    	je     80106224 <trap+0x2d4>
80105f90:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f94:	0f 84 8a 02 00 00    	je     80106224 <trap+0x2d4>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f9a:	0f 20 d1             	mov    %cr2,%ecx
80105f9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fa0:	e8 eb dd ff ff       	call   80103d90 <cpuid>
80105fa5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105fa8:	8b 47 34             	mov    0x34(%edi),%eax
80105fab:	8b 77 30             	mov    0x30(%edi),%esi
80105fae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fb1:	e8 fa dd ff ff       	call   80103db0 <myproc>
80105fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fb9:	e8 f2 dd ff ff       	call   80103db0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fc4:	51                   	push   %ecx
80105fc5:	53                   	push   %ebx
80105fc6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fca:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fcd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fce:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fd1:	52                   	push   %edx
80105fd2:	ff 70 10             	pushl  0x10(%eax)
80105fd5:	68 c4 8c 10 80       	push   $0x80108cc4
80105fda:	e8 81 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fdf:	83 c4 20             	add    $0x20,%esp
80105fe2:	e8 c9 dd ff ff       	call   80103db0 <myproc>
80105fe7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fee:	e8 bd dd ff ff       	call   80103db0 <myproc>
80105ff3:	85 c0                	test   %eax,%eax
80105ff5:	74 1d                	je     80106014 <trap+0xc4>
80105ff7:	e8 b4 dd ff ff       	call   80103db0 <myproc>
80105ffc:	8b 50 24             	mov    0x24(%eax),%edx
80105fff:	85 d2                	test   %edx,%edx
80106001:	74 11                	je     80106014 <trap+0xc4>
80106003:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106007:	83 e0 03             	and    $0x3,%eax
8010600a:	66 83 f8 03          	cmp    $0x3,%ax
8010600e:	0f 84 cc 01 00 00    	je     801061e0 <trap+0x290>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106014:	e8 97 dd ff ff       	call   80103db0 <myproc>
80106019:	85 c0                	test   %eax,%eax
8010601b:	74 0b                	je     80106028 <trap+0xd8>
8010601d:	e8 8e dd ff ff       	call   80103db0 <myproc>
80106022:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106026:	74 68                	je     80106090 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106028:	e8 83 dd ff ff       	call   80103db0 <myproc>
8010602d:	85 c0                	test   %eax,%eax
8010602f:	74 19                	je     8010604a <trap+0xfa>
80106031:	e8 7a dd ff ff       	call   80103db0 <myproc>
80106036:	8b 40 24             	mov    0x24(%eax),%eax
80106039:	85 c0                	test   %eax,%eax
8010603b:	74 0d                	je     8010604a <trap+0xfa>
8010603d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106041:	83 e0 03             	and    $0x3,%eax
80106044:	66 83 f8 03          	cmp    $0x3,%ax
80106048:	74 37                	je     80106081 <trap+0x131>
    exit();
}
8010604a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604d:	5b                   	pop    %ebx
8010604e:	5e                   	pop    %esi
8010604f:	5f                   	pop    %edi
80106050:	5d                   	pop    %ebp
80106051:	c3                   	ret    
80106052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106058:	e8 53 dd ff ff       	call   80103db0 <myproc>
8010605d:	8b 58 24             	mov    0x24(%eax),%ebx
80106060:	85 db                	test   %ebx,%ebx
80106062:	0f 85 48 01 00 00    	jne    801061b0 <trap+0x260>
    myproc()->tf = tf;
80106068:	e8 43 dd ff ff       	call   80103db0 <myproc>
8010606d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106070:	e8 ab ef ff ff       	call   80105020 <syscall>
    if(myproc()->killed)
80106075:	e8 36 dd ff ff       	call   80103db0 <myproc>
8010607a:	8b 48 24             	mov    0x24(%eax),%ecx
8010607d:	85 c9                	test   %ecx,%ecx
8010607f:	74 c9                	je     8010604a <trap+0xfa>
}
80106081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
      exit();
80106088:	e9 63 e2 ff ff       	jmp    801042f0 <exit>
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106090:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106094:	75 92                	jne    80106028 <trap+0xd8>
    yield();
80106096:	e8 a5 e3 ff ff       	call   80104440 <yield>
8010609b:	eb 8b                	jmp    80106028 <trap+0xd8>
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
  	 cprintf("Page fault\n");
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	68 5b 8c 10 80       	push   $0x80108c5b
801060a8:	e8 b3 a5 ff ff       	call   80100660 <cprintf>
  	myproc()->pageFaults++;
801060ad:	e8 fe dc ff ff       	call   80103db0 <myproc>
801060b2:	83 80 48 01 00 00 01 	addl   $0x1,0x148(%eax)
801060b9:	0f 20 d0             	mov    %cr2,%eax
  	UpdatePagingInfo(PGROUNDDOWN(rcr2()));
801060bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801060c1:	89 04 24             	mov    %eax,(%esp)
801060c4:	e8 47 23 00 00       	call   80108410 <UpdatePagingInfo>
801060c9:	0f 20 d0             	mov    %cr2,%eax
    if(checkIfSwapFault(PGROUNDDOWN(rcr2()))){
801060cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801060d1:	89 04 24             	mov    %eax,(%esp)
801060d4:	e8 a7 1e 00 00       	call   80107f80 <checkIfSwapFault>
801060d9:	83 c4 10             	add    $0x10,%esp
801060dc:	85 c0                	test   %eax,%eax
801060de:	0f 85 dc 00 00 00    	jne    801061c0 <trap+0x270>
801060e4:	0f 20 d0             	mov    %cr2,%eax
    if(checkIfCowFault(PGROUNDDOWN(rcr2()))){
801060e7:	83 ec 0c             	sub    $0xc,%esp
801060ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801060ef:	50                   	push   %eax
801060f0:	e8 eb 20 00 00       	call   801081e0 <checkIfCowFault>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	85 c0                	test   %eax,%eax
801060fa:	0f 84 80 fe ff ff    	je     80105f80 <trap+0x30>
80106100:	0f 20 d0             	mov    %cr2,%eax
    	copyOnWrite(PGROUNDDOWN(rcr2()));
80106103:	83 ec 0c             	sub    $0xc,%esp
80106106:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010610b:	50                   	push   %eax
8010610c:	e8 1f 21 00 00       	call   80108230 <copyOnWrite>
    	break;
80106111:	83 c4 10             	add    $0x10,%esp
80106114:	e9 d5 fe ff ff       	jmp    80105fee <trap+0x9e>
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106120:	e8 6b dc ff ff       	call   80103d90 <cpuid>
80106125:	85 c0                	test   %eax,%eax
80106127:	0f 84 c3 00 00 00    	je     801061f0 <trap+0x2a0>
    lapiceoi();
8010612d:	e8 6e cb ff ff       	call   80102ca0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106132:	e8 79 dc ff ff       	call   80103db0 <myproc>
80106137:	85 c0                	test   %eax,%eax
80106139:	0f 85 b8 fe ff ff    	jne    80105ff7 <trap+0xa7>
8010613f:	e9 d0 fe ff ff       	jmp    80106014 <trap+0xc4>
80106144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106148:	e8 13 ca ff ff       	call   80102b60 <kbdintr>
    lapiceoi();
8010614d:	e8 4e cb ff ff       	call   80102ca0 <lapiceoi>
    break;
80106152:	e9 97 fe ff ff       	jmp    80105fee <trap+0x9e>
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106160:	e8 5b 02 00 00       	call   801063c0 <uartintr>
    lapiceoi();
80106165:	e8 36 cb ff ff       	call   80102ca0 <lapiceoi>
    break;
8010616a:	e9 7f fe ff ff       	jmp    80105fee <trap+0x9e>
8010616f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106170:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106174:	8b 77 38             	mov    0x38(%edi),%esi
80106177:	e8 14 dc ff ff       	call   80103d90 <cpuid>
8010617c:	56                   	push   %esi
8010617d:	53                   	push   %ebx
8010617e:	50                   	push   %eax
8010617f:	68 6c 8c 10 80       	push   $0x80108c6c
80106184:	e8 d7 a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106189:	e8 12 cb ff ff       	call   80102ca0 <lapiceoi>
    break;
8010618e:	83 c4 10             	add    $0x10,%esp
80106191:	e9 58 fe ff ff       	jmp    80105fee <trap+0x9e>
80106196:	8d 76 00             	lea    0x0(%esi),%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801061a0:	e8 9b c3 ff ff       	call   80102540 <ideintr>
801061a5:	eb 86                	jmp    8010612d <trap+0x1dd>
801061a7:	89 f6                	mov    %esi,%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
801061b0:	e8 3b e1 ff ff       	call   801042f0 <exit>
801061b5:	e9 ae fe ff ff       	jmp    80106068 <trap+0x118>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061c0:	0f 20 d0             	mov    %cr2,%eax
      swapToRam(PGROUNDDOWN(rcr2()));
801061c3:	83 ec 0c             	sub    $0xc,%esp
801061c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801061cb:	50                   	push   %eax
801061cc:	e8 ff 1d 00 00       	call   80107fd0 <swapToRam>
      break;
801061d1:	83 c4 10             	add    $0x10,%esp
801061d4:	e9 15 fe ff ff       	jmp    80105fee <trap+0x9e>
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801061e0:	e8 0b e1 ff ff       	call   801042f0 <exit>
801061e5:	e9 2a fe ff ff       	jmp    80106014 <trap+0xc4>
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	68 80 c1 11 80       	push   $0x8011c180
801061f8:	e8 23 e9 ff ff       	call   80104b20 <acquire>
      wakeup(&ticks);
801061fd:	c7 04 24 c0 c9 11 80 	movl   $0x8011c9c0,(%esp)
      ticks++;
80106204:	83 05 c0 c9 11 80 01 	addl   $0x1,0x8011c9c0
      wakeup(&ticks);
8010620b:	e8 a0 e4 ff ff       	call   801046b0 <wakeup>
      release(&tickslock);
80106210:	c7 04 24 80 c1 11 80 	movl   $0x8011c180,(%esp)
80106217:	e8 c4 e9 ff ff       	call   80104be0 <release>
8010621c:	83 c4 10             	add    $0x10,%esp
8010621f:	e9 09 ff ff ff       	jmp    8010612d <trap+0x1dd>
80106224:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106227:	e8 64 db ff ff       	call   80103d90 <cpuid>
8010622c:	83 ec 0c             	sub    $0xc,%esp
8010622f:	56                   	push   %esi
80106230:	53                   	push   %ebx
80106231:	50                   	push   %eax
80106232:	ff 77 30             	pushl  0x30(%edi)
80106235:	68 90 8c 10 80       	push   $0x80108c90
8010623a:	e8 21 a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010623f:	83 c4 14             	add    $0x14,%esp
80106242:	68 67 8c 10 80       	push   $0x80108c67
80106247:	e8 44 a1 ff ff       	call   80100390 <panic>
8010624c:	66 90                	xchg   %ax,%ax
8010624e:	66 90                	xchg   %ax,%ax

80106250 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106250:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
80106255:	55                   	push   %ebp
80106256:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106258:	85 c0                	test   %eax,%eax
8010625a:	74 1c                	je     80106278 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010625c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106261:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106262:	a8 01                	test   $0x1,%al
80106264:	74 12                	je     80106278 <uartgetc+0x28>
80106266:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010626c:	0f b6 c0             	movzbl %al,%eax
}
8010626f:	5d                   	pop    %ebp
80106270:	c3                   	ret    
80106271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010627d:	5d                   	pop    %ebp
8010627e:	c3                   	ret    
8010627f:	90                   	nop

80106280 <uartputc.part.0>:
uartputc(int c)
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	56                   	push   %esi
80106285:	53                   	push   %ebx
80106286:	89 c7                	mov    %eax,%edi
80106288:	bb 80 00 00 00       	mov    $0x80,%ebx
8010628d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106292:	83 ec 0c             	sub    $0xc,%esp
80106295:	eb 1b                	jmp    801062b2 <uartputc.part.0+0x32>
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	6a 0a                	push   $0xa
801062a5:	e8 16 ca ff ff       	call   80102cc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	83 eb 01             	sub    $0x1,%ebx
801062b0:	74 07                	je     801062b9 <uartputc.part.0+0x39>
801062b2:	89 f2                	mov    %esi,%edx
801062b4:	ec                   	in     (%dx),%al
801062b5:	a8 20                	test   $0x20,%al
801062b7:	74 e7                	je     801062a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062be:	89 f8                	mov    %edi,%eax
801062c0:	ee                   	out    %al,(%dx)
}
801062c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c4:	5b                   	pop    %ebx
801062c5:	5e                   	pop    %esi
801062c6:	5f                   	pop    %edi
801062c7:	5d                   	pop    %ebp
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <uartinit>:
{
801062d0:	55                   	push   %ebp
801062d1:	31 c9                	xor    %ecx,%ecx
801062d3:	89 c8                	mov    %ecx,%eax
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	57                   	push   %edi
801062d8:	56                   	push   %esi
801062d9:	53                   	push   %ebx
801062da:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062df:	89 da                	mov    %ebx,%edx
801062e1:	83 ec 0c             	sub    $0xc,%esp
801062e4:	ee                   	out    %al,(%dx)
801062e5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062ef:	89 fa                	mov    %edi,%edx
801062f1:	ee                   	out    %al,(%dx)
801062f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fc:	ee                   	out    %al,(%dx)
801062fd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106302:	89 c8                	mov    %ecx,%eax
80106304:	89 f2                	mov    %esi,%edx
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 03 00 00 00       	mov    $0x3,%eax
8010630c:	89 fa                	mov    %edi,%edx
8010630e:	ee                   	out    %al,(%dx)
8010630f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106314:	89 c8                	mov    %ecx,%eax
80106316:	ee                   	out    %al,(%dx)
80106317:	b8 01 00 00 00       	mov    $0x1,%eax
8010631c:	89 f2                	mov    %esi,%edx
8010631e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010631f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106324:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106325:	3c ff                	cmp    $0xff,%al
80106327:	74 5a                	je     80106383 <uartinit+0xb3>
  uart = 1;
80106329:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106330:	00 00 00 
80106333:	89 da                	mov    %ebx,%edx
80106335:	ec                   	in     (%dx),%al
80106336:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010633c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010633f:	bb d0 8d 10 80       	mov    $0x80108dd0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106344:	6a 00                	push   $0x0
80106346:	6a 04                	push   $0x4
80106348:	e8 43 c4 ff ff       	call   80102790 <ioapicenable>
8010634d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106350:	b8 78 00 00 00       	mov    $0x78,%eax
80106355:	eb 13                	jmp    8010636a <uartinit+0x9a>
80106357:	89 f6                	mov    %esi,%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106360:	83 c3 01             	add    $0x1,%ebx
80106363:	0f be 03             	movsbl (%ebx),%eax
80106366:	84 c0                	test   %al,%al
80106368:	74 19                	je     80106383 <uartinit+0xb3>
  if(!uart)
8010636a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80106370:	85 d2                	test   %edx,%edx
80106372:	74 ec                	je     80106360 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106374:	83 c3 01             	add    $0x1,%ebx
80106377:	e8 04 ff ff ff       	call   80106280 <uartputc.part.0>
8010637c:	0f be 03             	movsbl (%ebx),%eax
8010637f:	84 c0                	test   %al,%al
80106381:	75 e7                	jne    8010636a <uartinit+0x9a>
}
80106383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106386:	5b                   	pop    %ebx
80106387:	5e                   	pop    %esi
80106388:	5f                   	pop    %edi
80106389:	5d                   	pop    %ebp
8010638a:	c3                   	ret    
8010638b:	90                   	nop
8010638c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106390 <uartputc>:
  if(!uart)
80106390:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80106396:	55                   	push   %ebp
80106397:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106399:	85 d2                	test   %edx,%edx
{
8010639b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010639e:	74 10                	je     801063b0 <uartputc+0x20>
}
801063a0:	5d                   	pop    %ebp
801063a1:	e9 da fe ff ff       	jmp    80106280 <uartputc.part.0>
801063a6:	8d 76 00             	lea    0x0(%esi),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    
801063b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <uartintr>:

void
uartintr(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063c6:	68 50 62 10 80       	push   $0x80106250
801063cb:	e8 40 a4 ff ff       	call   80100810 <consoleintr>
}
801063d0:	83 c4 10             	add    $0x10,%esp
801063d3:	c9                   	leave  
801063d4:	c3                   	ret    

801063d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $0
801063d7:	6a 00                	push   $0x0
  jmp alltraps
801063d9:	e9 94 fa ff ff       	jmp    80105e72 <alltraps>

801063de <vector1>:
.globl vector1
vector1:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $1
801063e0:	6a 01                	push   $0x1
  jmp alltraps
801063e2:	e9 8b fa ff ff       	jmp    80105e72 <alltraps>

801063e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $2
801063e9:	6a 02                	push   $0x2
  jmp alltraps
801063eb:	e9 82 fa ff ff       	jmp    80105e72 <alltraps>

801063f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $3
801063f2:	6a 03                	push   $0x3
  jmp alltraps
801063f4:	e9 79 fa ff ff       	jmp    80105e72 <alltraps>

801063f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $4
801063fb:	6a 04                	push   $0x4
  jmp alltraps
801063fd:	e9 70 fa ff ff       	jmp    80105e72 <alltraps>

80106402 <vector5>:
.globl vector5
vector5:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $5
80106404:	6a 05                	push   $0x5
  jmp alltraps
80106406:	e9 67 fa ff ff       	jmp    80105e72 <alltraps>

8010640b <vector6>:
.globl vector6
vector6:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $6
8010640d:	6a 06                	push   $0x6
  jmp alltraps
8010640f:	e9 5e fa ff ff       	jmp    80105e72 <alltraps>

80106414 <vector7>:
.globl vector7
vector7:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $7
80106416:	6a 07                	push   $0x7
  jmp alltraps
80106418:	e9 55 fa ff ff       	jmp    80105e72 <alltraps>

8010641d <vector8>:
.globl vector8
vector8:
  pushl $8
8010641d:	6a 08                	push   $0x8
  jmp alltraps
8010641f:	e9 4e fa ff ff       	jmp    80105e72 <alltraps>

80106424 <vector9>:
.globl vector9
vector9:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $9
80106426:	6a 09                	push   $0x9
  jmp alltraps
80106428:	e9 45 fa ff ff       	jmp    80105e72 <alltraps>

8010642d <vector10>:
.globl vector10
vector10:
  pushl $10
8010642d:	6a 0a                	push   $0xa
  jmp alltraps
8010642f:	e9 3e fa ff ff       	jmp    80105e72 <alltraps>

80106434 <vector11>:
.globl vector11
vector11:
  pushl $11
80106434:	6a 0b                	push   $0xb
  jmp alltraps
80106436:	e9 37 fa ff ff       	jmp    80105e72 <alltraps>

8010643b <vector12>:
.globl vector12
vector12:
  pushl $12
8010643b:	6a 0c                	push   $0xc
  jmp alltraps
8010643d:	e9 30 fa ff ff       	jmp    80105e72 <alltraps>

80106442 <vector13>:
.globl vector13
vector13:
  pushl $13
80106442:	6a 0d                	push   $0xd
  jmp alltraps
80106444:	e9 29 fa ff ff       	jmp    80105e72 <alltraps>

80106449 <vector14>:
.globl vector14
vector14:
  pushl $14
80106449:	6a 0e                	push   $0xe
  jmp alltraps
8010644b:	e9 22 fa ff ff       	jmp    80105e72 <alltraps>

80106450 <vector15>:
.globl vector15
vector15:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $15
80106452:	6a 0f                	push   $0xf
  jmp alltraps
80106454:	e9 19 fa ff ff       	jmp    80105e72 <alltraps>

80106459 <vector16>:
.globl vector16
vector16:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $16
8010645b:	6a 10                	push   $0x10
  jmp alltraps
8010645d:	e9 10 fa ff ff       	jmp    80105e72 <alltraps>

80106462 <vector17>:
.globl vector17
vector17:
  pushl $17
80106462:	6a 11                	push   $0x11
  jmp alltraps
80106464:	e9 09 fa ff ff       	jmp    80105e72 <alltraps>

80106469 <vector18>:
.globl vector18
vector18:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $18
8010646b:	6a 12                	push   $0x12
  jmp alltraps
8010646d:	e9 00 fa ff ff       	jmp    80105e72 <alltraps>

80106472 <vector19>:
.globl vector19
vector19:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $19
80106474:	6a 13                	push   $0x13
  jmp alltraps
80106476:	e9 f7 f9 ff ff       	jmp    80105e72 <alltraps>

8010647b <vector20>:
.globl vector20
vector20:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $20
8010647d:	6a 14                	push   $0x14
  jmp alltraps
8010647f:	e9 ee f9 ff ff       	jmp    80105e72 <alltraps>

80106484 <vector21>:
.globl vector21
vector21:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $21
80106486:	6a 15                	push   $0x15
  jmp alltraps
80106488:	e9 e5 f9 ff ff       	jmp    80105e72 <alltraps>

8010648d <vector22>:
.globl vector22
vector22:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $22
8010648f:	6a 16                	push   $0x16
  jmp alltraps
80106491:	e9 dc f9 ff ff       	jmp    80105e72 <alltraps>

80106496 <vector23>:
.globl vector23
vector23:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $23
80106498:	6a 17                	push   $0x17
  jmp alltraps
8010649a:	e9 d3 f9 ff ff       	jmp    80105e72 <alltraps>

8010649f <vector24>:
.globl vector24
vector24:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $24
801064a1:	6a 18                	push   $0x18
  jmp alltraps
801064a3:	e9 ca f9 ff ff       	jmp    80105e72 <alltraps>

801064a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $25
801064aa:	6a 19                	push   $0x19
  jmp alltraps
801064ac:	e9 c1 f9 ff ff       	jmp    80105e72 <alltraps>

801064b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $26
801064b3:	6a 1a                	push   $0x1a
  jmp alltraps
801064b5:	e9 b8 f9 ff ff       	jmp    80105e72 <alltraps>

801064ba <vector27>:
.globl vector27
vector27:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $27
801064bc:	6a 1b                	push   $0x1b
  jmp alltraps
801064be:	e9 af f9 ff ff       	jmp    80105e72 <alltraps>

801064c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $28
801064c5:	6a 1c                	push   $0x1c
  jmp alltraps
801064c7:	e9 a6 f9 ff ff       	jmp    80105e72 <alltraps>

801064cc <vector29>:
.globl vector29
vector29:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $29
801064ce:	6a 1d                	push   $0x1d
  jmp alltraps
801064d0:	e9 9d f9 ff ff       	jmp    80105e72 <alltraps>

801064d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $30
801064d7:	6a 1e                	push   $0x1e
  jmp alltraps
801064d9:	e9 94 f9 ff ff       	jmp    80105e72 <alltraps>

801064de <vector31>:
.globl vector31
vector31:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $31
801064e0:	6a 1f                	push   $0x1f
  jmp alltraps
801064e2:	e9 8b f9 ff ff       	jmp    80105e72 <alltraps>

801064e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $32
801064e9:	6a 20                	push   $0x20
  jmp alltraps
801064eb:	e9 82 f9 ff ff       	jmp    80105e72 <alltraps>

801064f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $33
801064f2:	6a 21                	push   $0x21
  jmp alltraps
801064f4:	e9 79 f9 ff ff       	jmp    80105e72 <alltraps>

801064f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $34
801064fb:	6a 22                	push   $0x22
  jmp alltraps
801064fd:	e9 70 f9 ff ff       	jmp    80105e72 <alltraps>

80106502 <vector35>:
.globl vector35
vector35:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $35
80106504:	6a 23                	push   $0x23
  jmp alltraps
80106506:	e9 67 f9 ff ff       	jmp    80105e72 <alltraps>

8010650b <vector36>:
.globl vector36
vector36:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $36
8010650d:	6a 24                	push   $0x24
  jmp alltraps
8010650f:	e9 5e f9 ff ff       	jmp    80105e72 <alltraps>

80106514 <vector37>:
.globl vector37
vector37:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $37
80106516:	6a 25                	push   $0x25
  jmp alltraps
80106518:	e9 55 f9 ff ff       	jmp    80105e72 <alltraps>

8010651d <vector38>:
.globl vector38
vector38:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $38
8010651f:	6a 26                	push   $0x26
  jmp alltraps
80106521:	e9 4c f9 ff ff       	jmp    80105e72 <alltraps>

80106526 <vector39>:
.globl vector39
vector39:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $39
80106528:	6a 27                	push   $0x27
  jmp alltraps
8010652a:	e9 43 f9 ff ff       	jmp    80105e72 <alltraps>

8010652f <vector40>:
.globl vector40
vector40:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $40
80106531:	6a 28                	push   $0x28
  jmp alltraps
80106533:	e9 3a f9 ff ff       	jmp    80105e72 <alltraps>

80106538 <vector41>:
.globl vector41
vector41:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $41
8010653a:	6a 29                	push   $0x29
  jmp alltraps
8010653c:	e9 31 f9 ff ff       	jmp    80105e72 <alltraps>

80106541 <vector42>:
.globl vector42
vector42:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $42
80106543:	6a 2a                	push   $0x2a
  jmp alltraps
80106545:	e9 28 f9 ff ff       	jmp    80105e72 <alltraps>

8010654a <vector43>:
.globl vector43
vector43:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $43
8010654c:	6a 2b                	push   $0x2b
  jmp alltraps
8010654e:	e9 1f f9 ff ff       	jmp    80105e72 <alltraps>

80106553 <vector44>:
.globl vector44
vector44:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $44
80106555:	6a 2c                	push   $0x2c
  jmp alltraps
80106557:	e9 16 f9 ff ff       	jmp    80105e72 <alltraps>

8010655c <vector45>:
.globl vector45
vector45:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $45
8010655e:	6a 2d                	push   $0x2d
  jmp alltraps
80106560:	e9 0d f9 ff ff       	jmp    80105e72 <alltraps>

80106565 <vector46>:
.globl vector46
vector46:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $46
80106567:	6a 2e                	push   $0x2e
  jmp alltraps
80106569:	e9 04 f9 ff ff       	jmp    80105e72 <alltraps>

8010656e <vector47>:
.globl vector47
vector47:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $47
80106570:	6a 2f                	push   $0x2f
  jmp alltraps
80106572:	e9 fb f8 ff ff       	jmp    80105e72 <alltraps>

80106577 <vector48>:
.globl vector48
vector48:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $48
80106579:	6a 30                	push   $0x30
  jmp alltraps
8010657b:	e9 f2 f8 ff ff       	jmp    80105e72 <alltraps>

80106580 <vector49>:
.globl vector49
vector49:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $49
80106582:	6a 31                	push   $0x31
  jmp alltraps
80106584:	e9 e9 f8 ff ff       	jmp    80105e72 <alltraps>

80106589 <vector50>:
.globl vector50
vector50:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $50
8010658b:	6a 32                	push   $0x32
  jmp alltraps
8010658d:	e9 e0 f8 ff ff       	jmp    80105e72 <alltraps>

80106592 <vector51>:
.globl vector51
vector51:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $51
80106594:	6a 33                	push   $0x33
  jmp alltraps
80106596:	e9 d7 f8 ff ff       	jmp    80105e72 <alltraps>

8010659b <vector52>:
.globl vector52
vector52:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $52
8010659d:	6a 34                	push   $0x34
  jmp alltraps
8010659f:	e9 ce f8 ff ff       	jmp    80105e72 <alltraps>

801065a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $53
801065a6:	6a 35                	push   $0x35
  jmp alltraps
801065a8:	e9 c5 f8 ff ff       	jmp    80105e72 <alltraps>

801065ad <vector54>:
.globl vector54
vector54:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $54
801065af:	6a 36                	push   $0x36
  jmp alltraps
801065b1:	e9 bc f8 ff ff       	jmp    80105e72 <alltraps>

801065b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $55
801065b8:	6a 37                	push   $0x37
  jmp alltraps
801065ba:	e9 b3 f8 ff ff       	jmp    80105e72 <alltraps>

801065bf <vector56>:
.globl vector56
vector56:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $56
801065c1:	6a 38                	push   $0x38
  jmp alltraps
801065c3:	e9 aa f8 ff ff       	jmp    80105e72 <alltraps>

801065c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $57
801065ca:	6a 39                	push   $0x39
  jmp alltraps
801065cc:	e9 a1 f8 ff ff       	jmp    80105e72 <alltraps>

801065d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $58
801065d3:	6a 3a                	push   $0x3a
  jmp alltraps
801065d5:	e9 98 f8 ff ff       	jmp    80105e72 <alltraps>

801065da <vector59>:
.globl vector59
vector59:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $59
801065dc:	6a 3b                	push   $0x3b
  jmp alltraps
801065de:	e9 8f f8 ff ff       	jmp    80105e72 <alltraps>

801065e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $60
801065e5:	6a 3c                	push   $0x3c
  jmp alltraps
801065e7:	e9 86 f8 ff ff       	jmp    80105e72 <alltraps>

801065ec <vector61>:
.globl vector61
vector61:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $61
801065ee:	6a 3d                	push   $0x3d
  jmp alltraps
801065f0:	e9 7d f8 ff ff       	jmp    80105e72 <alltraps>

801065f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $62
801065f7:	6a 3e                	push   $0x3e
  jmp alltraps
801065f9:	e9 74 f8 ff ff       	jmp    80105e72 <alltraps>

801065fe <vector63>:
.globl vector63
vector63:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $63
80106600:	6a 3f                	push   $0x3f
  jmp alltraps
80106602:	e9 6b f8 ff ff       	jmp    80105e72 <alltraps>

80106607 <vector64>:
.globl vector64
vector64:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $64
80106609:	6a 40                	push   $0x40
  jmp alltraps
8010660b:	e9 62 f8 ff ff       	jmp    80105e72 <alltraps>

80106610 <vector65>:
.globl vector65
vector65:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $65
80106612:	6a 41                	push   $0x41
  jmp alltraps
80106614:	e9 59 f8 ff ff       	jmp    80105e72 <alltraps>

80106619 <vector66>:
.globl vector66
vector66:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $66
8010661b:	6a 42                	push   $0x42
  jmp alltraps
8010661d:	e9 50 f8 ff ff       	jmp    80105e72 <alltraps>

80106622 <vector67>:
.globl vector67
vector67:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $67
80106624:	6a 43                	push   $0x43
  jmp alltraps
80106626:	e9 47 f8 ff ff       	jmp    80105e72 <alltraps>

8010662b <vector68>:
.globl vector68
vector68:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $68
8010662d:	6a 44                	push   $0x44
  jmp alltraps
8010662f:	e9 3e f8 ff ff       	jmp    80105e72 <alltraps>

80106634 <vector69>:
.globl vector69
vector69:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $69
80106636:	6a 45                	push   $0x45
  jmp alltraps
80106638:	e9 35 f8 ff ff       	jmp    80105e72 <alltraps>

8010663d <vector70>:
.globl vector70
vector70:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $70
8010663f:	6a 46                	push   $0x46
  jmp alltraps
80106641:	e9 2c f8 ff ff       	jmp    80105e72 <alltraps>

80106646 <vector71>:
.globl vector71
vector71:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $71
80106648:	6a 47                	push   $0x47
  jmp alltraps
8010664a:	e9 23 f8 ff ff       	jmp    80105e72 <alltraps>

8010664f <vector72>:
.globl vector72
vector72:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $72
80106651:	6a 48                	push   $0x48
  jmp alltraps
80106653:	e9 1a f8 ff ff       	jmp    80105e72 <alltraps>

80106658 <vector73>:
.globl vector73
vector73:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $73
8010665a:	6a 49                	push   $0x49
  jmp alltraps
8010665c:	e9 11 f8 ff ff       	jmp    80105e72 <alltraps>

80106661 <vector74>:
.globl vector74
vector74:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $74
80106663:	6a 4a                	push   $0x4a
  jmp alltraps
80106665:	e9 08 f8 ff ff       	jmp    80105e72 <alltraps>

8010666a <vector75>:
.globl vector75
vector75:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $75
8010666c:	6a 4b                	push   $0x4b
  jmp alltraps
8010666e:	e9 ff f7 ff ff       	jmp    80105e72 <alltraps>

80106673 <vector76>:
.globl vector76
vector76:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $76
80106675:	6a 4c                	push   $0x4c
  jmp alltraps
80106677:	e9 f6 f7 ff ff       	jmp    80105e72 <alltraps>

8010667c <vector77>:
.globl vector77
vector77:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $77
8010667e:	6a 4d                	push   $0x4d
  jmp alltraps
80106680:	e9 ed f7 ff ff       	jmp    80105e72 <alltraps>

80106685 <vector78>:
.globl vector78
vector78:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $78
80106687:	6a 4e                	push   $0x4e
  jmp alltraps
80106689:	e9 e4 f7 ff ff       	jmp    80105e72 <alltraps>

8010668e <vector79>:
.globl vector79
vector79:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $79
80106690:	6a 4f                	push   $0x4f
  jmp alltraps
80106692:	e9 db f7 ff ff       	jmp    80105e72 <alltraps>

80106697 <vector80>:
.globl vector80
vector80:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $80
80106699:	6a 50                	push   $0x50
  jmp alltraps
8010669b:	e9 d2 f7 ff ff       	jmp    80105e72 <alltraps>

801066a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $81
801066a2:	6a 51                	push   $0x51
  jmp alltraps
801066a4:	e9 c9 f7 ff ff       	jmp    80105e72 <alltraps>

801066a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $82
801066ab:	6a 52                	push   $0x52
  jmp alltraps
801066ad:	e9 c0 f7 ff ff       	jmp    80105e72 <alltraps>

801066b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $83
801066b4:	6a 53                	push   $0x53
  jmp alltraps
801066b6:	e9 b7 f7 ff ff       	jmp    80105e72 <alltraps>

801066bb <vector84>:
.globl vector84
vector84:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $84
801066bd:	6a 54                	push   $0x54
  jmp alltraps
801066bf:	e9 ae f7 ff ff       	jmp    80105e72 <alltraps>

801066c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $85
801066c6:	6a 55                	push   $0x55
  jmp alltraps
801066c8:	e9 a5 f7 ff ff       	jmp    80105e72 <alltraps>

801066cd <vector86>:
.globl vector86
vector86:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $86
801066cf:	6a 56                	push   $0x56
  jmp alltraps
801066d1:	e9 9c f7 ff ff       	jmp    80105e72 <alltraps>

801066d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $87
801066d8:	6a 57                	push   $0x57
  jmp alltraps
801066da:	e9 93 f7 ff ff       	jmp    80105e72 <alltraps>

801066df <vector88>:
.globl vector88
vector88:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $88
801066e1:	6a 58                	push   $0x58
  jmp alltraps
801066e3:	e9 8a f7 ff ff       	jmp    80105e72 <alltraps>

801066e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $89
801066ea:	6a 59                	push   $0x59
  jmp alltraps
801066ec:	e9 81 f7 ff ff       	jmp    80105e72 <alltraps>

801066f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $90
801066f3:	6a 5a                	push   $0x5a
  jmp alltraps
801066f5:	e9 78 f7 ff ff       	jmp    80105e72 <alltraps>

801066fa <vector91>:
.globl vector91
vector91:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $91
801066fc:	6a 5b                	push   $0x5b
  jmp alltraps
801066fe:	e9 6f f7 ff ff       	jmp    80105e72 <alltraps>

80106703 <vector92>:
.globl vector92
vector92:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $92
80106705:	6a 5c                	push   $0x5c
  jmp alltraps
80106707:	e9 66 f7 ff ff       	jmp    80105e72 <alltraps>

8010670c <vector93>:
.globl vector93
vector93:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $93
8010670e:	6a 5d                	push   $0x5d
  jmp alltraps
80106710:	e9 5d f7 ff ff       	jmp    80105e72 <alltraps>

80106715 <vector94>:
.globl vector94
vector94:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $94
80106717:	6a 5e                	push   $0x5e
  jmp alltraps
80106719:	e9 54 f7 ff ff       	jmp    80105e72 <alltraps>

8010671e <vector95>:
.globl vector95
vector95:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $95
80106720:	6a 5f                	push   $0x5f
  jmp alltraps
80106722:	e9 4b f7 ff ff       	jmp    80105e72 <alltraps>

80106727 <vector96>:
.globl vector96
vector96:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $96
80106729:	6a 60                	push   $0x60
  jmp alltraps
8010672b:	e9 42 f7 ff ff       	jmp    80105e72 <alltraps>

80106730 <vector97>:
.globl vector97
vector97:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $97
80106732:	6a 61                	push   $0x61
  jmp alltraps
80106734:	e9 39 f7 ff ff       	jmp    80105e72 <alltraps>

80106739 <vector98>:
.globl vector98
vector98:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $98
8010673b:	6a 62                	push   $0x62
  jmp alltraps
8010673d:	e9 30 f7 ff ff       	jmp    80105e72 <alltraps>

80106742 <vector99>:
.globl vector99
vector99:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $99
80106744:	6a 63                	push   $0x63
  jmp alltraps
80106746:	e9 27 f7 ff ff       	jmp    80105e72 <alltraps>

8010674b <vector100>:
.globl vector100
vector100:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $100
8010674d:	6a 64                	push   $0x64
  jmp alltraps
8010674f:	e9 1e f7 ff ff       	jmp    80105e72 <alltraps>

80106754 <vector101>:
.globl vector101
vector101:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $101
80106756:	6a 65                	push   $0x65
  jmp alltraps
80106758:	e9 15 f7 ff ff       	jmp    80105e72 <alltraps>

8010675d <vector102>:
.globl vector102
vector102:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $102
8010675f:	6a 66                	push   $0x66
  jmp alltraps
80106761:	e9 0c f7 ff ff       	jmp    80105e72 <alltraps>

80106766 <vector103>:
.globl vector103
vector103:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $103
80106768:	6a 67                	push   $0x67
  jmp alltraps
8010676a:	e9 03 f7 ff ff       	jmp    80105e72 <alltraps>

8010676f <vector104>:
.globl vector104
vector104:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $104
80106771:	6a 68                	push   $0x68
  jmp alltraps
80106773:	e9 fa f6 ff ff       	jmp    80105e72 <alltraps>

80106778 <vector105>:
.globl vector105
vector105:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $105
8010677a:	6a 69                	push   $0x69
  jmp alltraps
8010677c:	e9 f1 f6 ff ff       	jmp    80105e72 <alltraps>

80106781 <vector106>:
.globl vector106
vector106:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $106
80106783:	6a 6a                	push   $0x6a
  jmp alltraps
80106785:	e9 e8 f6 ff ff       	jmp    80105e72 <alltraps>

8010678a <vector107>:
.globl vector107
vector107:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $107
8010678c:	6a 6b                	push   $0x6b
  jmp alltraps
8010678e:	e9 df f6 ff ff       	jmp    80105e72 <alltraps>

80106793 <vector108>:
.globl vector108
vector108:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $108
80106795:	6a 6c                	push   $0x6c
  jmp alltraps
80106797:	e9 d6 f6 ff ff       	jmp    80105e72 <alltraps>

8010679c <vector109>:
.globl vector109
vector109:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $109
8010679e:	6a 6d                	push   $0x6d
  jmp alltraps
801067a0:	e9 cd f6 ff ff       	jmp    80105e72 <alltraps>

801067a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $110
801067a7:	6a 6e                	push   $0x6e
  jmp alltraps
801067a9:	e9 c4 f6 ff ff       	jmp    80105e72 <alltraps>

801067ae <vector111>:
.globl vector111
vector111:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $111
801067b0:	6a 6f                	push   $0x6f
  jmp alltraps
801067b2:	e9 bb f6 ff ff       	jmp    80105e72 <alltraps>

801067b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $112
801067b9:	6a 70                	push   $0x70
  jmp alltraps
801067bb:	e9 b2 f6 ff ff       	jmp    80105e72 <alltraps>

801067c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $113
801067c2:	6a 71                	push   $0x71
  jmp alltraps
801067c4:	e9 a9 f6 ff ff       	jmp    80105e72 <alltraps>

801067c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $114
801067cb:	6a 72                	push   $0x72
  jmp alltraps
801067cd:	e9 a0 f6 ff ff       	jmp    80105e72 <alltraps>

801067d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $115
801067d4:	6a 73                	push   $0x73
  jmp alltraps
801067d6:	e9 97 f6 ff ff       	jmp    80105e72 <alltraps>

801067db <vector116>:
.globl vector116
vector116:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $116
801067dd:	6a 74                	push   $0x74
  jmp alltraps
801067df:	e9 8e f6 ff ff       	jmp    80105e72 <alltraps>

801067e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $117
801067e6:	6a 75                	push   $0x75
  jmp alltraps
801067e8:	e9 85 f6 ff ff       	jmp    80105e72 <alltraps>

801067ed <vector118>:
.globl vector118
vector118:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $118
801067ef:	6a 76                	push   $0x76
  jmp alltraps
801067f1:	e9 7c f6 ff ff       	jmp    80105e72 <alltraps>

801067f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $119
801067f8:	6a 77                	push   $0x77
  jmp alltraps
801067fa:	e9 73 f6 ff ff       	jmp    80105e72 <alltraps>

801067ff <vector120>:
.globl vector120
vector120:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $120
80106801:	6a 78                	push   $0x78
  jmp alltraps
80106803:	e9 6a f6 ff ff       	jmp    80105e72 <alltraps>

80106808 <vector121>:
.globl vector121
vector121:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $121
8010680a:	6a 79                	push   $0x79
  jmp alltraps
8010680c:	e9 61 f6 ff ff       	jmp    80105e72 <alltraps>

80106811 <vector122>:
.globl vector122
vector122:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $122
80106813:	6a 7a                	push   $0x7a
  jmp alltraps
80106815:	e9 58 f6 ff ff       	jmp    80105e72 <alltraps>

8010681a <vector123>:
.globl vector123
vector123:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $123
8010681c:	6a 7b                	push   $0x7b
  jmp alltraps
8010681e:	e9 4f f6 ff ff       	jmp    80105e72 <alltraps>

80106823 <vector124>:
.globl vector124
vector124:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $124
80106825:	6a 7c                	push   $0x7c
  jmp alltraps
80106827:	e9 46 f6 ff ff       	jmp    80105e72 <alltraps>

8010682c <vector125>:
.globl vector125
vector125:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $125
8010682e:	6a 7d                	push   $0x7d
  jmp alltraps
80106830:	e9 3d f6 ff ff       	jmp    80105e72 <alltraps>

80106835 <vector126>:
.globl vector126
vector126:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $126
80106837:	6a 7e                	push   $0x7e
  jmp alltraps
80106839:	e9 34 f6 ff ff       	jmp    80105e72 <alltraps>

8010683e <vector127>:
.globl vector127
vector127:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $127
80106840:	6a 7f                	push   $0x7f
  jmp alltraps
80106842:	e9 2b f6 ff ff       	jmp    80105e72 <alltraps>

80106847 <vector128>:
.globl vector128
vector128:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $128
80106849:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010684e:	e9 1f f6 ff ff       	jmp    80105e72 <alltraps>

80106853 <vector129>:
.globl vector129
vector129:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $129
80106855:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010685a:	e9 13 f6 ff ff       	jmp    80105e72 <alltraps>

8010685f <vector130>:
.globl vector130
vector130:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $130
80106861:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106866:	e9 07 f6 ff ff       	jmp    80105e72 <alltraps>

8010686b <vector131>:
.globl vector131
vector131:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $131
8010686d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106872:	e9 fb f5 ff ff       	jmp    80105e72 <alltraps>

80106877 <vector132>:
.globl vector132
vector132:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $132
80106879:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010687e:	e9 ef f5 ff ff       	jmp    80105e72 <alltraps>

80106883 <vector133>:
.globl vector133
vector133:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $133
80106885:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010688a:	e9 e3 f5 ff ff       	jmp    80105e72 <alltraps>

8010688f <vector134>:
.globl vector134
vector134:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $134
80106891:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106896:	e9 d7 f5 ff ff       	jmp    80105e72 <alltraps>

8010689b <vector135>:
.globl vector135
vector135:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $135
8010689d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068a2:	e9 cb f5 ff ff       	jmp    80105e72 <alltraps>

801068a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $136
801068a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068ae:	e9 bf f5 ff ff       	jmp    80105e72 <alltraps>

801068b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $137
801068b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ba:	e9 b3 f5 ff ff       	jmp    80105e72 <alltraps>

801068bf <vector138>:
.globl vector138
vector138:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $138
801068c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068c6:	e9 a7 f5 ff ff       	jmp    80105e72 <alltraps>

801068cb <vector139>:
.globl vector139
vector139:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $139
801068cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068d2:	e9 9b f5 ff ff       	jmp    80105e72 <alltraps>

801068d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $140
801068d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068de:	e9 8f f5 ff ff       	jmp    80105e72 <alltraps>

801068e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $141
801068e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068ea:	e9 83 f5 ff ff       	jmp    80105e72 <alltraps>

801068ef <vector142>:
.globl vector142
vector142:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $142
801068f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068f6:	e9 77 f5 ff ff       	jmp    80105e72 <alltraps>

801068fb <vector143>:
.globl vector143
vector143:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $143
801068fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106902:	e9 6b f5 ff ff       	jmp    80105e72 <alltraps>

80106907 <vector144>:
.globl vector144
vector144:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $144
80106909:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010690e:	e9 5f f5 ff ff       	jmp    80105e72 <alltraps>

80106913 <vector145>:
.globl vector145
vector145:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $145
80106915:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010691a:	e9 53 f5 ff ff       	jmp    80105e72 <alltraps>

8010691f <vector146>:
.globl vector146
vector146:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $146
80106921:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106926:	e9 47 f5 ff ff       	jmp    80105e72 <alltraps>

8010692b <vector147>:
.globl vector147
vector147:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $147
8010692d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106932:	e9 3b f5 ff ff       	jmp    80105e72 <alltraps>

80106937 <vector148>:
.globl vector148
vector148:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $148
80106939:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010693e:	e9 2f f5 ff ff       	jmp    80105e72 <alltraps>

80106943 <vector149>:
.globl vector149
vector149:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $149
80106945:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010694a:	e9 23 f5 ff ff       	jmp    80105e72 <alltraps>

8010694f <vector150>:
.globl vector150
vector150:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $150
80106951:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106956:	e9 17 f5 ff ff       	jmp    80105e72 <alltraps>

8010695b <vector151>:
.globl vector151
vector151:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $151
8010695d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106962:	e9 0b f5 ff ff       	jmp    80105e72 <alltraps>

80106967 <vector152>:
.globl vector152
vector152:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $152
80106969:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010696e:	e9 ff f4 ff ff       	jmp    80105e72 <alltraps>

80106973 <vector153>:
.globl vector153
vector153:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $153
80106975:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010697a:	e9 f3 f4 ff ff       	jmp    80105e72 <alltraps>

8010697f <vector154>:
.globl vector154
vector154:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $154
80106981:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106986:	e9 e7 f4 ff ff       	jmp    80105e72 <alltraps>

8010698b <vector155>:
.globl vector155
vector155:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $155
8010698d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106992:	e9 db f4 ff ff       	jmp    80105e72 <alltraps>

80106997 <vector156>:
.globl vector156
vector156:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $156
80106999:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010699e:	e9 cf f4 ff ff       	jmp    80105e72 <alltraps>

801069a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $157
801069a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069aa:	e9 c3 f4 ff ff       	jmp    80105e72 <alltraps>

801069af <vector158>:
.globl vector158
vector158:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $158
801069b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069b6:	e9 b7 f4 ff ff       	jmp    80105e72 <alltraps>

801069bb <vector159>:
.globl vector159
vector159:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $159
801069bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069c2:	e9 ab f4 ff ff       	jmp    80105e72 <alltraps>

801069c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $160
801069c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069ce:	e9 9f f4 ff ff       	jmp    80105e72 <alltraps>

801069d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $161
801069d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069da:	e9 93 f4 ff ff       	jmp    80105e72 <alltraps>

801069df <vector162>:
.globl vector162
vector162:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $162
801069e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069e6:	e9 87 f4 ff ff       	jmp    80105e72 <alltraps>

801069eb <vector163>:
.globl vector163
vector163:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $163
801069ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069f2:	e9 7b f4 ff ff       	jmp    80105e72 <alltraps>

801069f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $164
801069f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069fe:	e9 6f f4 ff ff       	jmp    80105e72 <alltraps>

80106a03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $165
80106a05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a0a:	e9 63 f4 ff ff       	jmp    80105e72 <alltraps>

80106a0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $166
80106a11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a16:	e9 57 f4 ff ff       	jmp    80105e72 <alltraps>

80106a1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $167
80106a1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a22:	e9 4b f4 ff ff       	jmp    80105e72 <alltraps>

80106a27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $168
80106a29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a2e:	e9 3f f4 ff ff       	jmp    80105e72 <alltraps>

80106a33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $169
80106a35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a3a:	e9 33 f4 ff ff       	jmp    80105e72 <alltraps>

80106a3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $170
80106a41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a46:	e9 27 f4 ff ff       	jmp    80105e72 <alltraps>

80106a4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $171
80106a4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a52:	e9 1b f4 ff ff       	jmp    80105e72 <alltraps>

80106a57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $172
80106a59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a5e:	e9 0f f4 ff ff       	jmp    80105e72 <alltraps>

80106a63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $173
80106a65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a6a:	e9 03 f4 ff ff       	jmp    80105e72 <alltraps>

80106a6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $174
80106a71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a76:	e9 f7 f3 ff ff       	jmp    80105e72 <alltraps>

80106a7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $175
80106a7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a82:	e9 eb f3 ff ff       	jmp    80105e72 <alltraps>

80106a87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $176
80106a89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a8e:	e9 df f3 ff ff       	jmp    80105e72 <alltraps>

80106a93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $177
80106a95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a9a:	e9 d3 f3 ff ff       	jmp    80105e72 <alltraps>

80106a9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $178
80106aa1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106aa6:	e9 c7 f3 ff ff       	jmp    80105e72 <alltraps>

80106aab <vector179>:
.globl vector179
vector179:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $179
80106aad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ab2:	e9 bb f3 ff ff       	jmp    80105e72 <alltraps>

80106ab7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $180
80106ab9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106abe:	e9 af f3 ff ff       	jmp    80105e72 <alltraps>

80106ac3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $181
80106ac5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106aca:	e9 a3 f3 ff ff       	jmp    80105e72 <alltraps>

80106acf <vector182>:
.globl vector182
vector182:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $182
80106ad1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ad6:	e9 97 f3 ff ff       	jmp    80105e72 <alltraps>

80106adb <vector183>:
.globl vector183
vector183:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $183
80106add:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ae2:	e9 8b f3 ff ff       	jmp    80105e72 <alltraps>

80106ae7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $184
80106ae9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106aee:	e9 7f f3 ff ff       	jmp    80105e72 <alltraps>

80106af3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $185
80106af5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106afa:	e9 73 f3 ff ff       	jmp    80105e72 <alltraps>

80106aff <vector186>:
.globl vector186
vector186:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $186
80106b01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b06:	e9 67 f3 ff ff       	jmp    80105e72 <alltraps>

80106b0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $187
80106b0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b12:	e9 5b f3 ff ff       	jmp    80105e72 <alltraps>

80106b17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $188
80106b19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b1e:	e9 4f f3 ff ff       	jmp    80105e72 <alltraps>

80106b23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $189
80106b25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b2a:	e9 43 f3 ff ff       	jmp    80105e72 <alltraps>

80106b2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $190
80106b31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b36:	e9 37 f3 ff ff       	jmp    80105e72 <alltraps>

80106b3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $191
80106b3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b42:	e9 2b f3 ff ff       	jmp    80105e72 <alltraps>

80106b47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $192
80106b49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b4e:	e9 1f f3 ff ff       	jmp    80105e72 <alltraps>

80106b53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $193
80106b55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b5a:	e9 13 f3 ff ff       	jmp    80105e72 <alltraps>

80106b5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $194
80106b61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b66:	e9 07 f3 ff ff       	jmp    80105e72 <alltraps>

80106b6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $195
80106b6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b72:	e9 fb f2 ff ff       	jmp    80105e72 <alltraps>

80106b77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $196
80106b79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b7e:	e9 ef f2 ff ff       	jmp    80105e72 <alltraps>

80106b83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $197
80106b85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b8a:	e9 e3 f2 ff ff       	jmp    80105e72 <alltraps>

80106b8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $198
80106b91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b96:	e9 d7 f2 ff ff       	jmp    80105e72 <alltraps>

80106b9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $199
80106b9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ba2:	e9 cb f2 ff ff       	jmp    80105e72 <alltraps>

80106ba7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $200
80106ba9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bae:	e9 bf f2 ff ff       	jmp    80105e72 <alltraps>

80106bb3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $201
80106bb5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bba:	e9 b3 f2 ff ff       	jmp    80105e72 <alltraps>

80106bbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $202
80106bc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bc6:	e9 a7 f2 ff ff       	jmp    80105e72 <alltraps>

80106bcb <vector203>:
.globl vector203
vector203:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $203
80106bcd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bd2:	e9 9b f2 ff ff       	jmp    80105e72 <alltraps>

80106bd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $204
80106bd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bde:	e9 8f f2 ff ff       	jmp    80105e72 <alltraps>

80106be3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $205
80106be5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bea:	e9 83 f2 ff ff       	jmp    80105e72 <alltraps>

80106bef <vector206>:
.globl vector206
vector206:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $206
80106bf1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bf6:	e9 77 f2 ff ff       	jmp    80105e72 <alltraps>

80106bfb <vector207>:
.globl vector207
vector207:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $207
80106bfd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c02:	e9 6b f2 ff ff       	jmp    80105e72 <alltraps>

80106c07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $208
80106c09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c0e:	e9 5f f2 ff ff       	jmp    80105e72 <alltraps>

80106c13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $209
80106c15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c1a:	e9 53 f2 ff ff       	jmp    80105e72 <alltraps>

80106c1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $210
80106c21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c26:	e9 47 f2 ff ff       	jmp    80105e72 <alltraps>

80106c2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $211
80106c2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c32:	e9 3b f2 ff ff       	jmp    80105e72 <alltraps>

80106c37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $212
80106c39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c3e:	e9 2f f2 ff ff       	jmp    80105e72 <alltraps>

80106c43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $213
80106c45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c4a:	e9 23 f2 ff ff       	jmp    80105e72 <alltraps>

80106c4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $214
80106c51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c56:	e9 17 f2 ff ff       	jmp    80105e72 <alltraps>

80106c5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $215
80106c5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c62:	e9 0b f2 ff ff       	jmp    80105e72 <alltraps>

80106c67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $216
80106c69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c6e:	e9 ff f1 ff ff       	jmp    80105e72 <alltraps>

80106c73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $217
80106c75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c7a:	e9 f3 f1 ff ff       	jmp    80105e72 <alltraps>

80106c7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $218
80106c81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c86:	e9 e7 f1 ff ff       	jmp    80105e72 <alltraps>

80106c8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $219
80106c8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c92:	e9 db f1 ff ff       	jmp    80105e72 <alltraps>

80106c97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $220
80106c99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c9e:	e9 cf f1 ff ff       	jmp    80105e72 <alltraps>

80106ca3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $221
80106ca5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106caa:	e9 c3 f1 ff ff       	jmp    80105e72 <alltraps>

80106caf <vector222>:
.globl vector222
vector222:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $222
80106cb1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cb6:	e9 b7 f1 ff ff       	jmp    80105e72 <alltraps>

80106cbb <vector223>:
.globl vector223
vector223:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $223
80106cbd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cc2:	e9 ab f1 ff ff       	jmp    80105e72 <alltraps>

80106cc7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $224
80106cc9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cce:	e9 9f f1 ff ff       	jmp    80105e72 <alltraps>

80106cd3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $225
80106cd5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cda:	e9 93 f1 ff ff       	jmp    80105e72 <alltraps>

80106cdf <vector226>:
.globl vector226
vector226:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $226
80106ce1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ce6:	e9 87 f1 ff ff       	jmp    80105e72 <alltraps>

80106ceb <vector227>:
.globl vector227
vector227:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $227
80106ced:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cf2:	e9 7b f1 ff ff       	jmp    80105e72 <alltraps>

80106cf7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $228
80106cf9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cfe:	e9 6f f1 ff ff       	jmp    80105e72 <alltraps>

80106d03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $229
80106d05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d0a:	e9 63 f1 ff ff       	jmp    80105e72 <alltraps>

80106d0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $230
80106d11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d16:	e9 57 f1 ff ff       	jmp    80105e72 <alltraps>

80106d1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $231
80106d1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d22:	e9 4b f1 ff ff       	jmp    80105e72 <alltraps>

80106d27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $232
80106d29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d2e:	e9 3f f1 ff ff       	jmp    80105e72 <alltraps>

80106d33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $233
80106d35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d3a:	e9 33 f1 ff ff       	jmp    80105e72 <alltraps>

80106d3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $234
80106d41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d46:	e9 27 f1 ff ff       	jmp    80105e72 <alltraps>

80106d4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $235
80106d4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d52:	e9 1b f1 ff ff       	jmp    80105e72 <alltraps>

80106d57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $236
80106d59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d5e:	e9 0f f1 ff ff       	jmp    80105e72 <alltraps>

80106d63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $237
80106d65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d6a:	e9 03 f1 ff ff       	jmp    80105e72 <alltraps>

80106d6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $238
80106d71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d76:	e9 f7 f0 ff ff       	jmp    80105e72 <alltraps>

80106d7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $239
80106d7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d82:	e9 eb f0 ff ff       	jmp    80105e72 <alltraps>

80106d87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $240
80106d89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d8e:	e9 df f0 ff ff       	jmp    80105e72 <alltraps>

80106d93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $241
80106d95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d9a:	e9 d3 f0 ff ff       	jmp    80105e72 <alltraps>

80106d9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $242
80106da1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106da6:	e9 c7 f0 ff ff       	jmp    80105e72 <alltraps>

80106dab <vector243>:
.globl vector243
vector243:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $243
80106dad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106db2:	e9 bb f0 ff ff       	jmp    80105e72 <alltraps>

80106db7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $244
80106db9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dbe:	e9 af f0 ff ff       	jmp    80105e72 <alltraps>

80106dc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $245
80106dc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dca:	e9 a3 f0 ff ff       	jmp    80105e72 <alltraps>

80106dcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $246
80106dd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106dd6:	e9 97 f0 ff ff       	jmp    80105e72 <alltraps>

80106ddb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $247
80106ddd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106de2:	e9 8b f0 ff ff       	jmp    80105e72 <alltraps>

80106de7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $248
80106de9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dee:	e9 7f f0 ff ff       	jmp    80105e72 <alltraps>

80106df3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $249
80106df5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dfa:	e9 73 f0 ff ff       	jmp    80105e72 <alltraps>

80106dff <vector250>:
.globl vector250
vector250:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $250
80106e01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e06:	e9 67 f0 ff ff       	jmp    80105e72 <alltraps>

80106e0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $251
80106e0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e12:	e9 5b f0 ff ff       	jmp    80105e72 <alltraps>

80106e17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $252
80106e19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e1e:	e9 4f f0 ff ff       	jmp    80105e72 <alltraps>

80106e23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $253
80106e25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e2a:	e9 43 f0 ff ff       	jmp    80105e72 <alltraps>

80106e2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $254
80106e31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e36:	e9 37 f0 ff ff       	jmp    80105e72 <alltraps>

80106e3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $255
80106e3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e42:	e9 2b f0 ff ff       	jmp    80105e72 <alltraps>
80106e47:	66 90                	xchg   %ax,%ax
80106e49:	66 90                	xchg   %ax,%ax
80106e4b:	66 90                	xchg   %ax,%ax
80106e4d:	66 90                	xchg   %ax,%ax
80106e4f:	90                   	nop

80106e50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e56:	89 d3                	mov    %edx,%ebx
{
80106e58:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e5a:	c1 eb 16             	shr    $0x16,%ebx
80106e5d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e60:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e63:	8b 06                	mov    (%esi),%eax
80106e65:	a8 01                	test   $0x1,%al
80106e67:	74 27                	je     80106e90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e6e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e74:	c1 ef 0a             	shr    $0xa,%edi
}
80106e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e7a:	89 fa                	mov    %edi,%edx
80106e7c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e82:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e90:	85 c9                	test   %ecx,%ecx
80106e92:	74 2c                	je     80106ec0 <walkpgdir+0x70>
80106e94:	e8 47 bb ff ff       	call   801029e0 <kalloc>
80106e99:	85 c0                	test   %eax,%eax
80106e9b:	89 c3                	mov    %eax,%ebx
80106e9d:	74 21                	je     80106ec0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e9f:	83 ec 04             	sub    $0x4,%esp
80106ea2:	68 00 10 00 00       	push   $0x1000
80106ea7:	6a 00                	push   $0x0
80106ea9:	50                   	push   %eax
80106eaa:	e8 81 dd ff ff       	call   80104c30 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106eaf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106eb5:	83 c4 10             	add    $0x10,%esp
80106eb8:	83 c8 07             	or     $0x7,%eax
80106ebb:	89 06                	mov    %eax,(%esi)
80106ebd:	eb b5                	jmp    80106e74 <walkpgdir+0x24>
80106ebf:	90                   	nop
}
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ec3:	31 c0                	xor    %eax,%eax
}
80106ec5:	5b                   	pop    %ebx
80106ec6:	5e                   	pop    %esi
80106ec7:	5f                   	pop    %edi
80106ec8:	5d                   	pop    %ebp
80106ec9:	c3                   	ret    
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ed0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ed6:	89 d3                	mov    %edx,%ebx
80106ed8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ede:	83 ec 1c             	sub    $0x1c,%esp
80106ee1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ee4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ee8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ef0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ef6:	29 df                	sub    %ebx,%edi
80106ef8:	83 c8 01             	or     $0x1,%eax
80106efb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106efe:	eb 15                	jmp    80106f15 <mappages+0x45>
    if(*pte & PTE_P)
80106f00:	f6 00 01             	testb  $0x1,(%eax)
80106f03:	75 45                	jne    80106f4a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f05:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f08:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f0b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f0d:	74 31                	je     80106f40 <mappages+0x70>
      break;
    a += PGSIZE;
80106f0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f18:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f1d:	89 da                	mov    %ebx,%edx
80106f1f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f22:	e8 29 ff ff ff       	call   80106e50 <walkpgdir>
80106f27:	85 c0                	test   %eax,%eax
80106f29:	75 d5                	jne    80106f00 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5f                   	pop    %edi
80106f36:	5d                   	pop    %ebp
80106f37:	c3                   	ret    
80106f38:	90                   	nop
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f43:	31 c0                	xor    %eax,%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
      panic("remap");
80106f4a:	83 ec 0c             	sub    $0xc,%esp
80106f4d:	68 d8 8d 10 80       	push   $0x80108dd8
80106f52:	e8 39 94 ff ff       	call   80100390 <panic>
80106f57:	89 f6                	mov    %esi,%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <SCFIFOAlgorithm>:
    return count; 
} 

// Implementation of Second Chance FIFO algorithm
static int
SCFIFOAlgorithm(struct proc *p){
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	56                   	push   %esi
80106f64:	89 c6                	mov    %eax,%esi
80106f66:	53                   	push   %ebx
	pte_t *pte;
	for(int i = 0; i < 16; i++){
80106f67:	31 db                	xor    %ebx,%ebx
		if(p->ramPages[i].va != -1){
80106f69:	8b 94 de c0 00 00 00 	mov    0xc0(%esi,%ebx,8),%edx
80106f70:	83 fa ff             	cmp    $0xffffffff,%edx
80106f73:	74 28                	je     80106f9d <SCFIFOAlgorithm+0x3d>
			pte = walkpgdir(p->pgdir, (char*)p->ramPages[i].va, 0);
80106f75:	8b 46 04             	mov    0x4(%esi),%eax
80106f78:	31 c9                	xor    %ecx,%ecx
80106f7a:	e8 d1 fe ff ff       	call   80106e50 <walkpgdir>
			if(pte == 0)
80106f7f:	85 c0                	test   %eax,%eax
80106f81:	74 30                	je     80106fb3 <SCFIFOAlgorithm+0x53>
				panic("SCFIFOAlgorithm: couldnt find PTE");
			if(*pte & PTE_A){
80106f83:	8b 10                	mov    (%eax),%edx
80106f85:	f6 c2 20             	test   $0x20,%dl
80106f88:	75 0e                	jne    80106f98 <SCFIFOAlgorithm+0x38>
      }

		}
	}
	return -1;
}
80106f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f8d:	89 d8                	mov    %ebx,%eax
80106f8f:	5b                   	pop    %ebx
80106f90:	5e                   	pop    %esi
80106f91:	5d                   	pop    %ebp
80106f92:	c3                   	ret    
80106f93:	90                   	nop
80106f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				*pte &= ~PTE_A;
80106f98:	83 e2 df             	and    $0xffffffdf,%edx
80106f9b:	89 10                	mov    %edx,(%eax)
	for(int i = 0; i < 16; i++){
80106f9d:	83 c3 01             	add    $0x1,%ebx
80106fa0:	83 fb 10             	cmp    $0x10,%ebx
80106fa3:	75 c4                	jne    80106f69 <SCFIFOAlgorithm+0x9>
}
80106fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
	return -1;
80106fa8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106fad:	89 d8                	mov    %ebx,%eax
80106faf:	5b                   	pop    %ebx
80106fb0:	5e                   	pop    %esi
80106fb1:	5d                   	pop    %ebp
80106fb2:	c3                   	ret    
				panic("SCFIFOAlgorithm: couldnt find PTE");
80106fb3:	83 ec 0c             	sub    $0xc,%esp
80106fb6:	68 98 8f 10 80       	push   $0x80108f98
80106fbb:	e8 d0 93 ff ff       	call   80100390 <panic>

80106fc0 <swapToFile.part.0>:
swapToFile(struct proc *p){
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
  for(int i = 0; i < 16; i++){
80106fc6:	31 f6                	xor    %esi,%esi
swapToFile(struct proc *p){
80106fc8:	83 ec 1c             	sub    $0x1c,%esp
80106fcb:	eb 0f                	jmp    80106fdc <swapToFile.part.0+0x1c>
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i = 0; i < 16; i++){
80106fd0:	83 c6 01             	add    $0x1,%esi
80106fd3:	83 fe 10             	cmp    $0x10,%esi
80106fd6:	0f 84 64 02 00 00    	je     80107240 <swapToFile.part.0+0x280>
    if(p->swapPages[i] == -1){
80106fdc:	83 bc b0 80 00 00 00 	cmpl   $0xffffffff,0x80(%eax,%esi,4)
80106fe3:	ff 
80106fe4:	75 ea                	jne    80106fd0 <swapToFile.part.0+0x10>
80106fe6:	89 c3                	mov    %eax,%ebx
    ret = SCFIFOAlgorithm(p);
80106fe8:	e8 73 ff ff ff       	call   80106f60 <SCFIFOAlgorithm>
    if(ret == -1)
80106fed:	83 f8 ff             	cmp    $0xffffffff,%eax
    ret = SCFIFOAlgorithm(p);
80106ff0:	89 c7                	mov    %eax,%edi
    if(ret == -1)
80106ff2:	0f 84 68 02 00 00    	je     80107260 <swapToFile.part.0+0x2a0>
    cprintf("choosePageToSwap: index of page chosen: %d\n", ret);
80106ff8:	83 ec 08             	sub    $0x8,%esp
80106ffb:	50                   	push   %eax
80106ffc:	68 bc 8f 10 80       	push   $0x80108fbc
80107001:	e8 5a 96 ff ff       	call   80100660 <cprintf>
    cprintf("choosePageToSwap: page chosen: %d\n", (p->ramPages[ret].va)/4096);
80107006:	58                   	pop    %eax
80107007:	8b 84 fb c0 00 00 00 	mov    0xc0(%ebx,%edi,8),%eax
8010700e:	5a                   	pop    %edx
8010700f:	c1 e8 0c             	shr    $0xc,%eax
80107012:	50                   	push   %eax
80107013:	68 e8 8f 10 80       	push   $0x80108fe8
80107018:	e8 43 96 ff ff       	call   80100660 <cprintf>
8010701d:	83 c4 10             	add    $0x10,%esp
80107020:	8d 3c fb             	lea    (%ebx,%edi,8),%edi
  pte_t* pte = walkpgdir(p->pgdir, (void*)va, 0);
80107023:	31 c9                	xor    %ecx,%ecx
  uint va = p->ramPages[ramIndx].va;
80107025:	8b 87 c0 00 00 00    	mov    0xc0(%edi),%eax
8010702b:	89 c2                	mov    %eax,%edx
8010702d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t* pte = walkpgdir(p->pgdir, (void*)va, 0);
80107030:	8b 43 04             	mov    0x4(%ebx),%eax
80107033:	e8 18 fe ff ff       	call   80106e50 <walkpgdir>
80107038:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint pa = PTE_ADDR(*pte);
8010703b:	8b 00                	mov    (%eax),%eax
  if(writeToSwapFile(p, (char*) P2V(PTE_ADDR(*pte)), indx*PGSIZE, PGSIZE/2) < 0)
8010703d:	89 f2                	mov    %esi,%edx
8010703f:	c1 e2 0c             	shl    $0xc,%edx
80107042:	68 00 08 00 00       	push   $0x800
80107047:	52                   	push   %edx
80107048:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint pa = PTE_ADDR(*pte);
8010704b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107050:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(writeToSwapFile(p, (char*) P2V(PTE_ADDR(*pte)), indx*PGSIZE, PGSIZE/2) < 0)
80107053:	05 00 00 00 80       	add    $0x80000000,%eax
80107058:	50                   	push   %eax
80107059:	53                   	push   %ebx
8010705a:	e8 21 b3 ff ff       	call   80102380 <writeToSwapFile>
8010705f:	83 c4 10             	add    $0x10,%esp
80107062:	85 c0                	test   %eax,%eax
80107064:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107067:	0f 88 9e 02 00 00    	js     8010730b <swapToFile.part.0+0x34b>
  if(writeToSwapFile(p, (char*) (P2V(PTE_ADDR(*pte)) + PGSIZE/2), indx*PGSIZE + PGSIZE/2, PGSIZE/2) < 0)
8010706d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107070:	81 c2 00 08 00 00    	add    $0x800,%edx
80107076:	68 00 08 00 00       	push   $0x800
8010707b:	52                   	push   %edx
8010707c:	8b 00                	mov    (%eax),%eax
8010707e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107081:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107086:	2d 00 f8 ff 7f       	sub    $0x7ffff800,%eax
8010708b:	50                   	push   %eax
8010708c:	53                   	push   %ebx
8010708d:	e8 ee b2 ff ff       	call   80102380 <writeToSwapFile>
80107092:	83 c4 10             	add    $0x10,%esp
80107095:	85 c0                	test   %eax,%eax
80107097:	0f 88 6e 02 00 00    	js     8010730b <swapToFile.part.0+0x34b>
  p->swapPages[indx] = va;
8010709d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  p->ramPages[ramIndx].va = -1;
801070a0:	c7 87 c0 00 00 00 ff 	movl   $0xffffffff,0xc0(%edi)
801070a7:	ff ff ff 
  for(int i = 0; i < 16; i++){
801070aa:	31 d2                	xor    %edx,%edx
  p->ramPages[ramIndx].counter = 0;
801070ac:	c7 87 c4 00 00 00 00 	movl   $0x0,0xc4(%edi)
801070b3:	00 00 00 
  p->ramCounter--;
801070b6:	83 ab 40 01 00 00 01 	subl   $0x1,0x140(%ebx)
  p->swapPages[indx] = va;
801070bd:	89 84 b3 80 00 00 00 	mov    %eax,0x80(%ebx,%esi,4)
  p->swapCounter++;
801070c4:	83 83 44 01 00 00 01 	addl   $0x1,0x144(%ebx)
  p->totalPagedOut++;
801070cb:	83 83 4c 01 00 00 01 	addl   $0x1,0x14c(%ebx)
801070d2:	eb 10                	jmp    801070e4 <swapToFile.part.0+0x124>
801070d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < 16; i++){
801070d8:	83 c2 01             	add    $0x1,%edx
801070db:	83 fa 10             	cmp    $0x10,%edx
801070de:	0f 84 6c 01 00 00    	je     80107250 <swapToFile.part.0+0x290>
    if(p->ramPages[i].va == -1){
801070e4:	83 bc d3 c0 00 00 00 	cmpl   $0xffffffff,0xc0(%ebx,%edx,8)
801070eb:	ff 
801070ec:	75 ea                	jne    801070d8 <swapToFile.part.0+0x118>
// after removing 1 page from ramArray
static void
updateQueue(struct proc *p){
  // find the freed entry
  int indx = findFreePage(p);
  for(int i = indx; i < 15; i++){
801070ee:	83 fa 0f             	cmp    $0xf,%edx
801070f1:	8d 42 01             	lea    0x1(%edx),%eax
801070f4:	74 5f                	je     80107155 <swapToFile.part.0+0x195>
    if(p->ramPages[i+1].va == -1)
801070f6:	8b 8c c3 c0 00 00 00 	mov    0xc0(%ebx,%eax,8),%ecx
801070fd:	83 f9 ff             	cmp    $0xffffffff,%ecx
80107100:	74 53                	je     80107155 <swapToFile.part.0+0x195>
80107102:	8b bc d3 c4 00 00 00 	mov    0xc4(%ebx,%edx,8),%edi
80107109:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010710c:	eb 13                	jmp    80107121 <swapToFile.part.0+0x161>
8010710e:	66 90                	xchg   %ax,%ax
80107110:	83 c0 01             	add    $0x1,%eax
80107113:	89 fa                	mov    %edi,%edx
80107115:	8b 8c c3 c0 00 00 00 	mov    0xc0(%ebx,%eax,8),%ecx
8010711c:	83 f9 ff             	cmp    $0xffffffff,%ecx
8010711f:	74 34                	je     80107155 <swapToFile.part.0+0x195>
80107121:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
  for(int i = indx; i < 15; i++){
80107124:	83 f8 0f             	cmp    $0xf,%eax
80107127:	89 c7                	mov    %eax,%edi
	temp.va = p->ramPages[i].va;
80107129:	8b b2 c0 00 00 00    	mov    0xc0(%edx),%esi
	p->ramPages[i].va = p->ramPages[j].va;
8010712f:	89 8a c0 00 00 00    	mov    %ecx,0xc0(%edx)
	p->ramPages[i].counter = p->ramPages[j].counter;
80107135:	8b 8c c3 c4 00 00 00 	mov    0xc4(%ebx,%eax,8),%ecx
8010713c:	89 8a c4 00 00 00    	mov    %ecx,0xc4(%edx)
	p->ramPages[j].counter = temp.counter;
80107142:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	p->ramPages[j].va = temp.va;
80107145:	89 b4 c3 c0 00 00 00 	mov    %esi,0xc0(%ebx,%eax,8)
	p->ramPages[j].counter = temp.counter;
8010714c:	89 8c c3 c4 00 00 00 	mov    %ecx,0xc4(%ebx,%eax,8)
  for(int i = indx; i < 15; i++){
80107153:	75 bb                	jne    80107110 <swapToFile.part.0+0x150>
  *pte &= ~PTE_P;       // Turn off
80107155:	8b 7d e0             	mov    -0x20(%ebp),%edi
80107158:	8b 07                	mov    (%edi),%eax
8010715a:	89 c2                	mov    %eax,%edx
8010715c:	83 e2 fe             	and    $0xfffffffe,%edx
  *pte |= PTE_PG;       // Turn on
8010715f:	80 ce 02             	or     $0x2,%dh
80107162:	89 17                	mov    %edx,(%edi)
  lcr3(V2P(p->pgdir));  // Flush TLB 
80107164:	8b 7b 04             	mov    0x4(%ebx),%edi
80107167:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010716d:	0f 22 da             	mov    %edx,%cr3
  if(*pte & PTE_RO){
80107170:	f6 c4 04             	test   $0x4,%ah
80107173:	0f 84 a7 00 00 00    	je     80107220 <swapToFile.part.0+0x260>
	  *pte |= PTE_W; 		    // Turn on
80107179:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010717c:	25 fe fb ff ff       	and    $0xfffffbfe,%eax
80107181:	0d 02 02 00 00       	or     $0x202,%eax
80107186:	89 07                	mov    %eax,(%edi)
	  lcr3(V2P(p->pgdir));  // Flush TLB
80107188:	8b 43 04             	mov    0x4(%ebx),%eax
8010718b:	05 00 00 00 80       	add    $0x80000000,%eax
80107190:	0f 22 d8             	mov    %eax,%cr3
    if(!holding(&currentPagesLock))
80107193:	83 ec 0c             	sub    $0xc,%esp
80107196:	68 e0 c9 11 80       	push   $0x8011c9e0
8010719b:	e8 50 d9 ff ff       	call   80104af0 <holding>
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	85 c0                	test   %eax,%eax
801071a5:	0f 84 05 01 00 00    	je     801072b0 <swapToFile.part.0+0x2f0>
	for (int i = 0; i < MAX_PAGES; ++i)
801071ab:	31 c0                	xor    %eax,%eax
801071ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
801071b0:	eb 14                	jmp    801071c6 <swapToFile.part.0+0x206>
801071b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071b8:	83 c0 01             	add    $0x1,%eax
801071bb:	3d 00 04 00 00       	cmp    $0x400,%eax
801071c0:	0f 84 38 01 00 00    	je     801072fe <swapToFile.part.0+0x33e>
		if(currentPages[i].pa == pa){
801071c6:	3b 14 c5 20 1f 11 80 	cmp    -0x7feee0e0(,%eax,8),%edx
801071cd:	75 e9                	jne    801071b8 <swapToFile.part.0+0x1f8>
	  }else if(currentPages[indx].refCounter == 1){
801071cf:	8b 14 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%edx
801071d6:	83 fa 01             	cmp    $0x1,%edx
801071d9:	0f 84 e9 00 00 00    	je     801072c8 <swapToFile.part.0+0x308>
	  	currentPages[indx].refCounter--;
801071df:	83 ea 01             	sub    $0x1,%edx
801071e2:	89 14 c5 24 1f 11 80 	mov    %edx,-0x7feee0dc(,%eax,8)
    if(holding(&currentPagesLock))
801071e9:	83 ec 0c             	sub    $0xc,%esp
801071ec:	68 e0 c9 11 80       	push   $0x8011c9e0
801071f1:	e8 fa d8 ff ff       	call   80104af0 <holding>
801071f6:	83 c4 10             	add    $0x10,%esp
801071f9:	85 c0                	test   %eax,%eax
801071fb:	74 3b                	je     80107238 <swapToFile.part.0+0x278>
      release(&currentPagesLock);
801071fd:	83 ec 0c             	sub    $0xc,%esp
80107200:	68 e0 c9 11 80       	push   $0x8011c9e0
80107205:	e8 d6 d9 ff ff       	call   80104be0 <release>
8010720a:	83 c4 10             	add    $0x10,%esp
}
8010720d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107210:	31 c0                	xor    %eax,%eax
}
80107212:	5b                   	pop    %ebx
80107213:	5e                   	pop    %esi
80107214:	5f                   	pop    %edi
80107215:	5d                   	pop    %ebp
80107216:	c3                   	ret    
80107217:	89 f6                	mov    %esi,%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  	kfree((char*) P2V(PTE_ADDR(*pte)));
80107220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107225:	83 ec 0c             	sub    $0xc,%esp
80107228:	05 00 00 00 80       	add    $0x80000000,%eax
8010722d:	50                   	push   %eax
8010722e:	e8 9d b5 ff ff       	call   801027d0 <kfree>
80107233:	83 c4 10             	add    $0x10,%esp
  return 0;
80107236:	31 c0                	xor    %eax,%eax
}
80107238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723b:	5b                   	pop    %ebx
8010723c:	5e                   	pop    %esi
8010723d:	5f                   	pop    %edi
8010723e:	5d                   	pop    %ebp
8010723f:	c3                   	ret    
80107240:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80107243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107248:	5b                   	pop    %ebx
80107249:	5e                   	pop    %esi
8010724a:	5f                   	pop    %edi
8010724b:	5d                   	pop    %ebp
8010724c:	c3                   	ret    
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i = 0; i < 16; i++){
80107250:	31 c0                	xor    %eax,%eax
  int indx = -1;
80107252:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107257:	e9 9a fe ff ff       	jmp    801070f6 <swapToFile.part.0+0x136>
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    	ret = SCFIFOAlgorithm(p);
80107260:	89 d8                	mov    %ebx,%eax
80107262:	e8 f9 fc ff ff       	call   80106f60 <SCFIFOAlgorithm>
    cprintf("choosePageToSwap: index of page chosen: %d\n", ret);
80107267:	83 ec 08             	sub    $0x8,%esp
    	ret = SCFIFOAlgorithm(p);
8010726a:	89 c7                	mov    %eax,%edi
    cprintf("choosePageToSwap: index of page chosen: %d\n", ret);
8010726c:	50                   	push   %eax
8010726d:	68 bc 8f 10 80       	push   $0x80108fbc
80107272:	e8 e9 93 ff ff       	call   80100660 <cprintf>
    cprintf("choosePageToSwap: page chosen: %d\n", (p->ramPages[ret].va)/4096);
80107277:	59                   	pop    %ecx
80107278:	58                   	pop    %eax
80107279:	8b 84 fb c0 00 00 00 	mov    0xc0(%ebx,%edi,8),%eax
80107280:	c1 e8 0c             	shr    $0xc,%eax
80107283:	50                   	push   %eax
80107284:	68 e8 8f 10 80       	push   $0x80108fe8
80107289:	e8 d2 93 ff ff       	call   80100660 <cprintf>
  if(ramIndx == -1)
8010728e:	83 c4 10             	add    $0x10,%esp
80107291:	83 ff ff             	cmp    $0xffffffff,%edi
80107294:	0f 85 86 fd ff ff    	jne    80107020 <swapToFile.part.0+0x60>
  	panic("swapToFile: couldnt find page to swap");
8010729a:	83 ec 0c             	sub    $0xc,%esp
8010729d:	68 0c 90 10 80       	push   $0x8010900c
801072a2:	e8 e9 90 ff ff       	call   80100390 <panic>
801072a7:	89 f6                	mov    %esi,%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      acquire(&currentPagesLock);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	68 e0 c9 11 80       	push   $0x8011c9e0
801072b8:	e8 63 d8 ff ff       	call   80104b20 <acquire>
801072bd:	83 c4 10             	add    $0x10,%esp
801072c0:	e9 e6 fe ff ff       	jmp    801071ab <swapToFile.part.0+0x1eb>
801072c5:	8d 76 00             	lea    0x0(%esi),%esi

// Given an index, clear the correspond currentPages entry
// Need to be called with currentPagesLock held
static void
clearCurrentPagesEntry(int indx){
  currentPages[indx].pa = -1;
801072c8:	c7 04 c5 20 1f 11 80 	movl   $0xffffffff,-0x7feee0e0(,%eax,8)
801072cf:	ff ff ff ff 
  currentPages[indx].refCounter = 0;
801072d3:	c7 04 c5 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%eax,8)
801072da:	00 00 00 00 
	  	kfree((char*) P2V(PTE_ADDR(*pte)));
801072de:	83 ec 0c             	sub    $0xc,%esp
801072e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072e4:	8b 00                	mov    (%eax),%eax
801072e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072eb:	05 00 00 00 80       	add    $0x80000000,%eax
801072f0:	50                   	push   %eax
801072f1:	e8 da b4 ff ff       	call   801027d0 <kfree>
801072f6:	83 c4 10             	add    $0x10,%esp
801072f9:	e9 eb fe ff ff       	jmp    801071e9 <swapToFile.part.0+0x229>
	  	panic("swapToFile: PTE_RO on, but not in current pages table");
801072fe:	83 ec 0c             	sub    $0xc,%esp
80107301:	68 58 90 10 80       	push   $0x80109058
80107306:	e8 85 90 ff ff       	call   80100390 <panic>
    panic("swapToFile: couldnt write to file!");
8010730b:	83 ec 0c             	sub    $0xc,%esp
8010730e:	68 34 90 10 80       	push   $0x80109034
80107313:	e8 78 90 ff ff       	call   80100390 <panic>
80107318:	90                   	nop
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <currlockinit>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	83 ec 10             	sub    $0x10,%esp
  initlock(&currentPagesLock, "currentPagesLock");
80107326:	68 de 8d 10 80       	push   $0x80108dde
8010732b:	68 e0 c9 11 80       	push   $0x8011c9e0
80107330:	e8 ab d6 ff ff       	call   801049e0 <initlock>
}
80107335:	83 c4 10             	add    $0x10,%esp
80107338:	c9                   	leave  
80107339:	c3                   	ret    
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <seginit>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107346:	e8 45 ca ff ff       	call   80103d90 <cpuid>
8010734b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107351:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107356:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010735a:	c7 80 18 68 11 80 ff 	movl   $0xffff,-0x7fee97e8(%eax)
80107361:	ff 00 00 
80107364:	c7 80 1c 68 11 80 00 	movl   $0xcf9a00,-0x7fee97e4(%eax)
8010736b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010736e:	c7 80 20 68 11 80 ff 	movl   $0xffff,-0x7fee97e0(%eax)
80107375:	ff 00 00 
80107378:	c7 80 24 68 11 80 00 	movl   $0xcf9200,-0x7fee97dc(%eax)
8010737f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107382:	c7 80 28 68 11 80 ff 	movl   $0xffff,-0x7fee97d8(%eax)
80107389:	ff 00 00 
8010738c:	c7 80 2c 68 11 80 00 	movl   $0xcffa00,-0x7fee97d4(%eax)
80107393:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107396:	c7 80 30 68 11 80 ff 	movl   $0xffff,-0x7fee97d0(%eax)
8010739d:	ff 00 00 
801073a0:	c7 80 34 68 11 80 00 	movl   $0xcff200,-0x7fee97cc(%eax)
801073a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801073aa:	05 10 68 11 80       	add    $0x80116810,%eax
  pd[1] = (uint)p;
801073af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801073b3:	c1 e8 10             	shr    $0x10,%eax
801073b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801073ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801073bd:	0f 01 10             	lgdtl  (%eax)
}
801073c0:	c9                   	leave  
801073c1:	c3                   	ret    
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d0:	a1 14 ca 11 80       	mov    0x8011ca14,%eax
{
801073d5:	55                   	push   %ebp
801073d6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073dd:	0f 22 d8             	mov    %eax,%cr3
}
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret    
801073e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <switchuvm>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
801073f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801073fc:	85 db                	test   %ebx,%ebx
801073fe:	0f 84 cb 00 00 00    	je     801074cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107404:	8b 43 08             	mov    0x8(%ebx),%eax
80107407:	85 c0                	test   %eax,%eax
80107409:	0f 84 da 00 00 00    	je     801074e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010740f:	8b 43 04             	mov    0x4(%ebx),%eax
80107412:	85 c0                	test   %eax,%eax
80107414:	0f 84 c2 00 00 00    	je     801074dc <switchuvm+0xec>
  pushcli();
8010741a:	e8 31 d6 ff ff       	call   80104a50 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010741f:	e8 ec c8 ff ff       	call   80103d10 <mycpu>
80107424:	89 c6                	mov    %eax,%esi
80107426:	e8 e5 c8 ff ff       	call   80103d10 <mycpu>
8010742b:	89 c7                	mov    %eax,%edi
8010742d:	e8 de c8 ff ff       	call   80103d10 <mycpu>
80107432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107435:	83 c7 08             	add    $0x8,%edi
80107438:	e8 d3 c8 ff ff       	call   80103d10 <mycpu>
8010743d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107440:	83 c0 08             	add    $0x8,%eax
80107443:	ba 67 00 00 00       	mov    $0x67,%edx
80107448:	c1 e8 18             	shr    $0x18,%eax
8010744b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107452:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107459:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010745f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107464:	83 c1 08             	add    $0x8,%ecx
80107467:	c1 e9 10             	shr    $0x10,%ecx
8010746a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107470:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107475:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010747c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107481:	e8 8a c8 ff ff       	call   80103d10 <mycpu>
80107486:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010748d:	e8 7e c8 ff ff       	call   80103d10 <mycpu>
80107492:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107496:	8b 73 08             	mov    0x8(%ebx),%esi
80107499:	e8 72 c8 ff ff       	call   80103d10 <mycpu>
8010749e:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074a4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074a7:	e8 64 c8 ff ff       	call   80103d10 <mycpu>
801074ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801074b0:	b8 28 00 00 00       	mov    $0x28,%eax
801074b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801074b8:	8b 43 04             	mov    0x4(%ebx),%eax
801074bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074c0:	0f 22 d8             	mov    %eax,%cr3
}
801074c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c6:	5b                   	pop    %ebx
801074c7:	5e                   	pop    %esi
801074c8:	5f                   	pop    %edi
801074c9:	5d                   	pop    %ebp
  popcli();
801074ca:	e9 c1 d5 ff ff       	jmp    80104a90 <popcli>
    panic("switchuvm: no process");
801074cf:	83 ec 0c             	sub    $0xc,%esp
801074d2:	68 ef 8d 10 80       	push   $0x80108def
801074d7:	e8 b4 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	68 1a 8e 10 80       	push   $0x80108e1a
801074e4:	e8 a7 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801074e9:	83 ec 0c             	sub    $0xc,%esp
801074ec:	68 05 8e 10 80       	push   $0x80108e05
801074f1:	e8 9a 8e ff ff       	call   80100390 <panic>
801074f6:	8d 76 00             	lea    0x0(%esi),%esi
801074f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107500 <inituvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
80107509:	8b 75 10             	mov    0x10(%ebp),%esi
8010750c:	8b 45 08             	mov    0x8(%ebp),%eax
8010750f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107512:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010751b:	77 49                	ja     80107566 <inituvm+0x66>
  mem = kalloc();
8010751d:	e8 be b4 ff ff       	call   801029e0 <kalloc>
  memset(mem, 0, PGSIZE);
80107522:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107525:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107527:	68 00 10 00 00       	push   $0x1000
8010752c:	6a 00                	push   $0x0
8010752e:	50                   	push   %eax
8010752f:	e8 fc d6 ff ff       	call   80104c30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107534:	58                   	pop    %eax
80107535:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010753b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107540:	5a                   	pop    %edx
80107541:	6a 06                	push   $0x6
80107543:	50                   	push   %eax
80107544:	31 d2                	xor    %edx,%edx
80107546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107549:	e8 82 f9 ff ff       	call   80106ed0 <mappages>
  memmove(mem, init, sz);
8010754e:	89 75 10             	mov    %esi,0x10(%ebp)
80107551:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107554:	83 c4 10             	add    $0x10,%esp
80107557:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010755a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010755d:	5b                   	pop    %ebx
8010755e:	5e                   	pop    %esi
8010755f:	5f                   	pop    %edi
80107560:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107561:	e9 7a d7 ff ff       	jmp    80104ce0 <memmove>
    panic("inituvm: more than a page");
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	68 2e 8e 10 80       	push   $0x80108e2e
8010756e:	e8 1d 8e ff ff       	call   80100390 <panic>
80107573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107580 <loaduvm>:
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107589:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107590:	0f 85 91 00 00 00    	jne    80107627 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107596:	8b 75 18             	mov    0x18(%ebp),%esi
80107599:	31 db                	xor    %ebx,%ebx
8010759b:	85 f6                	test   %esi,%esi
8010759d:	75 1a                	jne    801075b9 <loaduvm+0x39>
8010759f:	eb 6f                	jmp    80107610 <loaduvm+0x90>
801075a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801075b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801075b7:	76 57                	jbe    80107610 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801075bc:	8b 45 08             	mov    0x8(%ebp),%eax
801075bf:	31 c9                	xor    %ecx,%ecx
801075c1:	01 da                	add    %ebx,%edx
801075c3:	e8 88 f8 ff ff       	call   80106e50 <walkpgdir>
801075c8:	85 c0                	test   %eax,%eax
801075ca:	74 4e                	je     8010761a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801075cc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801075d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075e4:	01 d9                	add    %ebx,%ecx
801075e6:	05 00 00 00 80       	add    $0x80000000,%eax
801075eb:	57                   	push   %edi
801075ec:	51                   	push   %ecx
801075ed:	50                   	push   %eax
801075ee:	ff 75 10             	pushl  0x10(%ebp)
801075f1:	e8 9a a4 ff ff       	call   80101a90 <readi>
801075f6:	83 c4 10             	add    $0x10,%esp
801075f9:	39 f8                	cmp    %edi,%eax
801075fb:	74 ab                	je     801075a8 <loaduvm+0x28>
}
801075fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107605:	5b                   	pop    %ebx
80107606:	5e                   	pop    %esi
80107607:	5f                   	pop    %edi
80107608:	5d                   	pop    %ebp
80107609:	c3                   	ret    
8010760a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107610:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107613:	31 c0                	xor    %eax,%eax
}
80107615:	5b                   	pop    %ebx
80107616:	5e                   	pop    %esi
80107617:	5f                   	pop    %edi
80107618:	5d                   	pop    %ebp
80107619:	c3                   	ret    
      panic("loaduvm: address should exist");
8010761a:	83 ec 0c             	sub    $0xc,%esp
8010761d:	68 48 8e 10 80       	push   $0x80108e48
80107622:	e8 69 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107627:	83 ec 0c             	sub    $0xc,%esp
8010762a:	68 90 90 10 80       	push   $0x80109090
8010762f:	e8 5c 8d ff ff       	call   80100390 <panic>
80107634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010763a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107640 <deallocuvm>:
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80107649:	e8 62 c7 ff ff       	call   80103db0 <myproc>
8010764e:	89 c3                	mov    %eax,%ebx
  if(newsz >= oldsz)
80107650:	8b 45 0c             	mov    0xc(%ebp),%eax
80107653:	39 45 10             	cmp    %eax,0x10(%ebp)
80107656:	0f 83 e6 00 00 00    	jae    80107742 <deallocuvm+0x102>
  a = PGROUNDUP(newsz);
8010765c:	8b 45 10             	mov    0x10(%ebp),%eax
8010765f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107664:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; a  < oldsz; a += PGSIZE){
80107669:	39 45 0c             	cmp    %eax,0xc(%ebp)
  a = PGROUNDUP(newsz);
8010766c:	89 c7                	mov    %eax,%edi
  for(; a  < oldsz; a += PGSIZE){
8010766e:	0f 86 cb 00 00 00    	jbe    8010773f <deallocuvm+0xff>
80107674:	89 de                	mov    %ebx,%esi
80107676:	eb 57                	jmp    801076cf <deallocuvm+0x8f>
80107678:	90                   	nop
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80107680:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107686:	0f 84 82 02 00 00    	je     8010790e <deallocuvm+0x2ce>
    if(p && p->pid > 2){
8010768c:	85 f6                	test   %esi,%esi
8010768e:	74 0a                	je     8010769a <deallocuvm+0x5a>
80107690:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107694:	0f 8f 96 01 00 00    	jg     80107830 <deallocuvm+0x1f0>
		kfree(v);
8010769a:	83 ec 0c             	sub    $0xc,%esp
		char *v = P2V(pa);
8010769d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801076a3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		kfree(v);
801076a6:	53                   	push   %ebx
801076a7:	e8 24 b1 ff ff       	call   801027d0 <kfree>
801076ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801076af:	83 c4 10             	add    $0x10,%esp
      if(p->pgdir == pgdir)
801076b2:	8b 45 08             	mov    0x8(%ebp),%eax
801076b5:	39 46 04             	cmp    %eax,0x4(%esi)
801076b8:	0f 84 92 00 00 00    	je     80107750 <deallocuvm+0x110>
      *pte = 0;
801076be:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
801076c4:	81 c7 00 10 00 00    	add    $0x1000,%edi
801076ca:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801076cd:	76 70                	jbe    8010773f <deallocuvm+0xff>
    pte = walkpgdir(pgdir, (char*)a, 0);
801076cf:	8b 45 08             	mov    0x8(%ebp),%eax
801076d2:	31 c9                	xor    %ecx,%ecx
801076d4:	89 fa                	mov    %edi,%edx
801076d6:	e8 75 f7 ff ff       	call   80106e50 <walkpgdir>
    if(!pte)
801076db:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
801076dd:	89 c1                	mov    %eax,%ecx
    if(!pte)
801076df:	74 47                	je     80107728 <deallocuvm+0xe8>
    else if((*pte & PTE_P) != 0){
801076e1:	8b 18                	mov    (%eax),%ebx
801076e3:	f6 c3 01             	test   $0x1,%bl
801076e6:	75 98                	jne    80107680 <deallocuvm+0x40>
    }else if((*pte & PTE_PG) != 0){ // In case page is in swapFile
801076e8:	80 e7 02             	and    $0x2,%bh
801076eb:	74 d7                	je     801076c4 <deallocuvm+0x84>
      if(p->pgdir == pgdir){
801076ed:	8b 45 08             	mov    0x8(%ebp),%eax
801076f0:	39 46 04             	cmp    %eax,0x4(%esi)
801076f3:	75 c9                	jne    801076be <deallocuvm+0x7e>
        for (int i = 0; i < 16; ++i){
801076f5:	31 c0                	xor    %eax,%eax
801076f7:	eb 0f                	jmp    80107708 <deallocuvm+0xc8>
801076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107700:	83 c0 01             	add    $0x1,%eax
80107703:	83 f8 10             	cmp    $0x10,%eax
80107706:	74 b6                	je     801076be <deallocuvm+0x7e>
          if(p->swapPages[i] == a){
80107708:	39 bc 86 80 00 00 00 	cmp    %edi,0x80(%esi,%eax,4)
8010770f:	75 ef                	jne    80107700 <deallocuvm+0xc0>
            p->swapPages[i] = -1;
80107711:	c7 84 86 80 00 00 00 	movl   $0xffffffff,0x80(%esi,%eax,4)
80107718:	ff ff ff ff 
            p->swapCounter--;
8010771c:	83 ae 44 01 00 00 01 	subl   $0x1,0x144(%esi)
            break;
80107723:	eb 99                	jmp    801076be <deallocuvm+0x7e>
80107725:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107728:	81 e7 00 00 c0 ff    	and    $0xffc00000,%edi
8010772e:	81 c7 00 f0 3f 00    	add    $0x3ff000,%edi
  for(; a  < oldsz; a += PGSIZE){
80107734:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010773a:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010773d:	77 90                	ja     801076cf <deallocuvm+0x8f>
  return newsz;
8010773f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for(int i = 0; i < 16; i++){
80107750:	31 c0                	xor    %eax,%eax
80107752:	eb 10                	jmp    80107764 <deallocuvm+0x124>
80107754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107758:	83 c0 01             	add    $0x1,%eax
8010775b:	83 f8 10             	cmp    $0x10,%eax
8010775e:	0f 84 5a ff ff ff    	je     801076be <deallocuvm+0x7e>
		if(p->ramPages[i].va == va){
80107764:	39 bc c6 c0 00 00 00 	cmp    %edi,0xc0(%esi,%eax,8)
8010776b:	75 eb                	jne    80107758 <deallocuvm+0x118>
8010776d:	8d 04 c6             	lea    (%esi,%eax,8),%eax
  for(int i = 0; i < 16; i++){
80107770:	31 d2                	xor    %edx,%edx
			p->ramPages[i].va = -1;
80107772:	c7 80 c0 00 00 00 ff 	movl   $0xffffffff,0xc0(%eax)
80107779:	ff ff ff 
			p->ramPages[i].counter = 0;
8010777c:	c7 80 c4 00 00 00 00 	movl   $0x0,0xc4(%eax)
80107783:	00 00 00 
80107786:	eb 14                	jmp    8010779c <deallocuvm+0x15c>
80107788:	90                   	nop
80107789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < 16; i++){
80107790:	83 c2 01             	add    $0x1,%edx
80107793:	83 fa 10             	cmp    $0x10,%edx
80107796:	0f 84 44 01 00 00    	je     801078e0 <deallocuvm+0x2a0>
    if(p->ramPages[i].va == -1){
8010779c:	83 bc d6 c0 00 00 00 	cmpl   $0xffffffff,0xc0(%esi,%edx,8)
801077a3:	ff 
801077a4:	75 ea                	jne    80107790 <deallocuvm+0x150>
  for(int i = indx; i < 15; i++){
801077a6:	83 fa 0f             	cmp    $0xf,%edx
801077a9:	0f 84 0f ff ff ff    	je     801076be <deallocuvm+0x7e>
801077af:	8d 42 01             	lea    0x1(%edx),%eax
801077b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(p->ramPages[i+1].va == -1)
801077b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077b8:	8b 9c c6 c0 00 00 00 	mov    0xc0(%esi,%eax,8),%ebx
801077bf:	83 fb ff             	cmp    $0xffffffff,%ebx
801077c2:	0f 84 f6 fe ff ff    	je     801076be <deallocuvm+0x7e>
801077c8:	8b 84 d6 c4 00 00 00 	mov    0xc4(%esi,%edx,8),%eax
801077cf:	89 7d dc             	mov    %edi,-0x24(%ebp)
801077d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077d8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801077db:	eb 14                	jmp    801077f1 <deallocuvm+0x1b1>
801077dd:	8d 76 00             	lea    0x0(%esi),%esi
801077e0:	83 c0 01             	add    $0x1,%eax
801077e3:	89 fa                	mov    %edi,%edx
801077e5:	8b 9c c6 c0 00 00 00 	mov    0xc0(%esi,%eax,8),%ebx
801077ec:	83 fb ff             	cmp    $0xffffffff,%ebx
801077ef:	74 34                	je     80107825 <deallocuvm+0x1e5>
801077f1:	8d 14 d6             	lea    (%esi,%edx,8),%edx
  for(int i = indx; i < 15; i++){
801077f4:	83 f8 0f             	cmp    $0xf,%eax
801077f7:	89 c7                	mov    %eax,%edi
	temp.va = p->ramPages[i].va;
801077f9:	8b 8a c0 00 00 00    	mov    0xc0(%edx),%ecx
	p->ramPages[i].va = p->ramPages[j].va;
801077ff:	89 9a c0 00 00 00    	mov    %ebx,0xc0(%edx)
	p->ramPages[i].counter = p->ramPages[j].counter;
80107805:	8b 9c c6 c4 00 00 00 	mov    0xc4(%esi,%eax,8),%ebx
8010780c:	89 9a c4 00 00 00    	mov    %ebx,0xc4(%edx)
	p->ramPages[j].counter = temp.counter;
80107812:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	p->ramPages[j].va = temp.va;
80107815:	89 8c c6 c0 00 00 00 	mov    %ecx,0xc0(%esi,%eax,8)
	p->ramPages[j].counter = temp.counter;
8010781c:	89 94 c6 c4 00 00 00 	mov    %edx,0xc4(%esi,%eax,8)
  for(int i = indx; i < 15; i++){
80107823:	75 bb                	jne    801077e0 <deallocuvm+0x1a0>
80107825:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107828:	8b 7d dc             	mov    -0x24(%ebp),%edi
8010782b:	e9 8e fe ff ff       	jmp    801076be <deallocuvm+0x7e>
      acquire(&currentPagesLock);
80107830:	83 ec 0c             	sub    $0xc,%esp
80107833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107836:	68 e0 c9 11 80       	push   $0x8011c9e0
8010783b:	e8 e0 d2 ff ff       	call   80104b20 <acquire>
80107840:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < MAX_PAGES; ++i)
80107843:	31 d2                	xor    %edx,%edx
80107845:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107848:	eb 15                	jmp    8010785f <deallocuvm+0x21f>
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107850:	83 c2 01             	add    $0x1,%edx
80107853:	81 fa 00 04 00 00    	cmp    $0x400,%edx
80107859:	0f 84 92 00 00 00    	je     801078f1 <deallocuvm+0x2b1>
		if(currentPages[i].pa == pa){
8010785f:	3b 1c d5 20 1f 11 80 	cmp    -0x7feee0e0(,%edx,8),%ebx
80107866:	75 e8                	jne    80107850 <deallocuvm+0x210>
    	else if(currentPages[indx].refCounter == 1){
80107868:	8b 04 d5 24 1f 11 80 	mov    -0x7feee0dc(,%edx,8),%eax
8010786f:	83 f8 01             	cmp    $0x1,%eax
80107872:	74 2c                	je     801078a0 <deallocuvm+0x260>
    	else if(currentPages[indx].refCounter > 1){
80107874:	0f 8e a1 00 00 00    	jle    8010791b <deallocuvm+0x2db>
    		currentPages[indx].refCounter--;
8010787a:	83 e8 01             	sub    $0x1,%eax
8010787d:	89 04 d5 24 1f 11 80 	mov    %eax,-0x7feee0dc(,%edx,8)
      release(&currentPagesLock);
80107884:	83 ec 0c             	sub    $0xc,%esp
80107887:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010788a:	68 e0 c9 11 80       	push   $0x8011c9e0
8010788f:	e8 4c d3 ff ff       	call   80104be0 <release>
    if(p && p->pid > 2){
80107894:	83 c4 10             	add    $0x10,%esp
80107897:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010789a:	e9 13 fe ff ff       	jmp    801076b2 <deallocuvm+0x72>
8010789f:	90                   	nop
  			kfree(v);
801078a0:	83 ec 0c             	sub    $0xc,%esp
      	char *v = P2V(pa);
801078a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801078a9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  			kfree(v);
801078ac:	53                   	push   %ebx
801078ad:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801078b0:	e8 1b af ff ff       	call   801027d0 <kfree>
  currentPages[indx].pa = -1;
801078b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  currentPages[indx].refCounter = 0;
801078b8:	83 c4 10             	add    $0x10,%esp
801078bb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  currentPages[indx].pa = -1;
801078be:	c7 04 d5 20 1f 11 80 	movl   $0xffffffff,-0x7feee0e0(,%edx,8)
801078c5:	ff ff ff ff 
  currentPages[indx].refCounter = 0;
801078c9:	c7 04 d5 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%edx,8)
801078d0:	00 00 00 00 
801078d4:	eb ae                	jmp    80107884 <deallocuvm+0x244>
801078d6:	8d 76 00             	lea    0x0(%esi),%esi
801078d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < 16; i++){
801078e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  int indx = -1;
801078e7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801078ec:	e9 c4 fe ff ff       	jmp    801077b5 <deallocuvm+0x175>
        kfree(v);
801078f1:	83 ec 0c             	sub    $0xc,%esp
    		char *v = P2V(pa);
801078f4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801078fa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        kfree(v);
801078fd:	53                   	push   %ebx
801078fe:	e8 cd ae ff ff       	call   801027d0 <kfree>
80107903:	83 c4 10             	add    $0x10,%esp
80107906:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107909:	e9 76 ff ff ff       	jmp    80107884 <deallocuvm+0x244>
        panic("kfree");
8010790e:	83 ec 0c             	sub    $0xc,%esp
80107911:	68 ca 86 10 80       	push   $0x801086ca
80107916:	e8 75 8a ff ff       	call   80100390 <panic>
    		panic("deallocuvm: refCounter under 1");
8010791b:	83 ec 0c             	sub    $0xc,%esp
8010791e:	68 b4 90 10 80       	push   $0x801090b4
80107923:	e8 68 8a ff ff       	call   80100390 <panic>
80107928:	90                   	nop
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107930 <allocuvm>:
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80107939:	e8 72 c4 ff ff       	call   80103db0 <myproc>
8010793e:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80107940:	8b 45 10             	mov    0x10(%ebp),%eax
80107943:	85 c0                	test   %eax,%eax
80107945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107948:	0f 88 2a 01 00 00    	js     80107a78 <allocuvm+0x148>
  if(newsz < oldsz)
8010794e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107951:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107954:	0f 82 ce 00 00 00    	jb     80107a28 <allocuvm+0xf8>
  a = PGROUNDUP(oldsz);
8010795a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107960:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107966:	39 75 10             	cmp    %esi,0x10(%ebp)
80107969:	0f 86 bc 00 00 00    	jbe    80107a2b <allocuvm+0xfb>
8010796f:	8b 53 10             	mov    0x10(%ebx),%edx
80107972:	eb 13                	jmp    80107987 <allocuvm+0x57>
80107974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107978:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010797e:	39 75 10             	cmp    %esi,0x10(%ebp)
80107981:	0f 86 a4 00 00 00    	jbe    80107a2b <allocuvm+0xfb>
    if(p->pid > 2 && p->ramCounter == 16){
80107987:	83 fa 02             	cmp    $0x2,%edx
8010798a:	7e 0d                	jle    80107999 <allocuvm+0x69>
8010798c:	83 bb 40 01 00 00 10 	cmpl   $0x10,0x140(%ebx)
80107993:	0f 84 a7 00 00 00    	je     80107a40 <allocuvm+0x110>
    mem = kalloc();
80107999:	e8 42 b0 ff ff       	call   801029e0 <kalloc>
    if(mem == 0){
8010799e:	85 c0                	test   %eax,%eax
    mem = kalloc();
801079a0:	89 c7                	mov    %eax,%edi
    if(mem == 0){
801079a2:	0f 84 e8 00 00 00    	je     80107a90 <allocuvm+0x160>
    memset(mem, 0, PGSIZE);
801079a8:	83 ec 04             	sub    $0x4,%esp
801079ab:	68 00 10 00 00       	push   $0x1000
801079b0:	6a 00                	push   $0x0
801079b2:	50                   	push   %eax
801079b3:	e8 78 d2 ff ff       	call   80104c30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801079b8:	58                   	pop    %eax
801079b9:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801079bf:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079c4:	5a                   	pop    %edx
801079c5:	6a 06                	push   $0x6
801079c7:	50                   	push   %eax
801079c8:	89 f2                	mov    %esi,%edx
801079ca:	8b 45 08             	mov    0x8(%ebp),%eax
801079cd:	e8 fe f4 ff ff       	call   80106ed0 <mappages>
801079d2:	83 c4 10             	add    $0x10,%esp
801079d5:	85 c0                	test   %eax,%eax
801079d7:	0f 88 eb 00 00 00    	js     80107ac8 <allocuvm+0x198>
    if(p->pid > 2){
801079dd:	8b 53 10             	mov    0x10(%ebx),%edx
801079e0:	83 fa 02             	cmp    $0x2,%edx
801079e3:	7e 93                	jle    80107978 <allocuvm+0x48>
  for(int i = 0; i < 16; i++){
801079e5:	31 c0                	xor    %eax,%eax
801079e7:	eb 0f                	jmp    801079f8 <allocuvm+0xc8>
801079e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079f0:	83 c0 01             	add    $0x1,%eax
801079f3:	83 f8 10             	cmp    $0x10,%eax
801079f6:	74 70                	je     80107a68 <allocuvm+0x138>
    if(p->ramPages[i].va == -1){
801079f8:	83 bc c3 c0 00 00 00 	cmpl   $0xffffffff,0xc0(%ebx,%eax,8)
801079ff:	ff 
80107a00:	75 ee                	jne    801079f0 <allocuvm+0xc0>
80107a02:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
        p->ramPages[indx].va = a;
80107a05:	89 b0 c0 00 00 00    	mov    %esi,0xc0(%eax)
        p->ramPages[indx].counter = 0;
80107a0b:	c7 80 c4 00 00 00 00 	movl   $0x0,0xc4(%eax)
80107a12:	00 00 00 
      p->ramCounter++;
80107a15:	83 83 40 01 00 00 01 	addl   $0x1,0x140(%ebx)
80107a1c:	e9 57 ff ff ff       	jmp    80107978 <allocuvm+0x48>
80107a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107a28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a31:	5b                   	pop    %ebx
80107a32:	5e                   	pop    %esi
80107a33:	5f                   	pop    %edi
80107a34:	5d                   	pop    %ebp
80107a35:	c3                   	ret    
80107a36:	8d 76 00             	lea    0x0(%esi),%esi
80107a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->swapCounter < 16){
80107a40:	83 bb 44 01 00 00 0f 	cmpl   $0xf,0x144(%ebx)
80107a47:	77 2f                	ja     80107a78 <allocuvm+0x148>
80107a49:	89 d8                	mov    %ebx,%eax
80107a4b:	e8 70 f5 ff ff       	call   80106fc0 <swapToFile.part.0>
        if(swapToFile(p) < 0)
80107a50:	85 c0                	test   %eax,%eax
80107a52:	0f 89 41 ff ff ff    	jns    80107999 <allocuvm+0x69>
          panic("allocuvm: swapToFile failed!");
80107a58:	83 ec 0c             	sub    $0xc,%esp
80107a5b:	68 66 8e 10 80       	push   $0x80108e66
80107a60:	e8 2b 89 ff ff       	call   80100390 <panic>
80107a65:	8d 76 00             	lea    0x0(%esi),%esi
        panic("alocuvm: no free space in ramPages!");
80107a68:	83 ec 0c             	sub    $0xc,%esp
80107a6b:	68 d4 90 10 80       	push   $0x801090d4
80107a70:	e8 1b 89 ff ff       	call   80100390 <panic>
80107a75:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80107a78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a85:	5b                   	pop    %ebx
80107a86:	5e                   	pop    %esi
80107a87:	5f                   	pop    %edi
80107a88:	5d                   	pop    %ebp
80107a89:	c3                   	ret    
80107a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107a90:	83 ec 0c             	sub    $0xc,%esp
80107a93:	68 83 8e 10 80       	push   $0x80108e83
80107a98:	e8 c3 8b ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107a9d:	83 c4 0c             	add    $0xc,%esp
80107aa0:	ff 75 0c             	pushl  0xc(%ebp)
80107aa3:	ff 75 10             	pushl  0x10(%ebp)
80107aa6:	ff 75 08             	pushl  0x8(%ebp)
80107aa9:	e8 92 fb ff ff       	call   80107640 <deallocuvm>
      return 0;
80107aae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107ab5:	83 c4 10             	add    $0x10,%esp
}
80107ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107abe:	5b                   	pop    %ebx
80107abf:	5e                   	pop    %esi
80107ac0:	5f                   	pop    %edi
80107ac1:	5d                   	pop    %ebp
80107ac2:	c3                   	ret    
80107ac3:	90                   	nop
80107ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107ac8:	83 ec 0c             	sub    $0xc,%esp
80107acb:	68 9b 8e 10 80       	push   $0x80108e9b
80107ad0:	e8 8b 8b ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107ad5:	83 c4 0c             	add    $0xc,%esp
80107ad8:	ff 75 0c             	pushl  0xc(%ebp)
80107adb:	ff 75 10             	pushl  0x10(%ebp)
80107ade:	ff 75 08             	pushl  0x8(%ebp)
80107ae1:	e8 5a fb ff ff       	call   80107640 <deallocuvm>
      kfree(mem);
80107ae6:	89 3c 24             	mov    %edi,(%esp)
80107ae9:	e8 e2 ac ff ff       	call   801027d0 <kfree>
      return 0;
80107aee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107af5:	83 c4 10             	add    $0x10,%esp
}
80107af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107afe:	5b                   	pop    %ebx
80107aff:	5e                   	pop    %esi
80107b00:	5f                   	pop    %edi
80107b01:	5d                   	pop    %ebp
80107b02:	c3                   	ret    
80107b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b10 <freevm>:
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 0c             	sub    $0xc,%esp
80107b19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
80107b1c:	85 f6                	test   %esi,%esi
80107b1e:	74 59                	je     80107b79 <freevm+0x69>
  deallocuvm(pgdir, KERNBASE, 0);
80107b20:	83 ec 04             	sub    $0x4,%esp
80107b23:	89 f3                	mov    %esi,%ebx
80107b25:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107b2b:	6a 00                	push   $0x0
80107b2d:	68 00 00 00 80       	push   $0x80000000
80107b32:	56                   	push   %esi
80107b33:	e8 08 fb ff ff       	call   80107640 <deallocuvm>
80107b38:	83 c4 10             	add    $0x10,%esp
80107b3b:	eb 0a                	jmp    80107b47 <freevm+0x37>
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
80107b40:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107b43:	39 fb                	cmp    %edi,%ebx
80107b45:	74 23                	je     80107b6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107b47:	8b 03                	mov    (%ebx),%eax
80107b49:	a8 01                	test   $0x1,%al
80107b4b:	74 f3                	je     80107b40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107b52:	83 ec 0c             	sub    $0xc,%esp
80107b55:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b58:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107b5d:	50                   	push   %eax
80107b5e:	e8 6d ac ff ff       	call   801027d0 <kfree>
80107b63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b66:	39 fb                	cmp    %edi,%ebx
80107b68:	75 dd                	jne    80107b47 <freevm+0x37>
  kfree((char*)pgdir);
80107b6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b70:	5b                   	pop    %ebx
80107b71:	5e                   	pop    %esi
80107b72:	5f                   	pop    %edi
80107b73:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107b74:	e9 57 ac ff ff       	jmp    801027d0 <kfree>
    panic("freevm: no pgdir");
80107b79:	83 ec 0c             	sub    $0xc,%esp
80107b7c:	68 b7 8e 10 80       	push   $0x80108eb7
80107b81:	e8 0a 88 ff ff       	call   80100390 <panic>
80107b86:	8d 76 00             	lea    0x0(%esi),%esi
80107b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b90 <setupkvm>:
{
80107b90:	55                   	push   %ebp
80107b91:	89 e5                	mov    %esp,%ebp
80107b93:	56                   	push   %esi
80107b94:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107b95:	e8 46 ae ff ff       	call   801029e0 <kalloc>
80107b9a:	85 c0                	test   %eax,%eax
80107b9c:	89 c6                	mov    %eax,%esi
80107b9e:	74 42                	je     80107be2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107ba0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ba3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107ba8:	68 00 10 00 00       	push   $0x1000
80107bad:	6a 00                	push   $0x0
80107baf:	50                   	push   %eax
80107bb0:	e8 7b d0 ff ff       	call   80104c30 <memset>
80107bb5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107bb8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107bbb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107bbe:	83 ec 08             	sub    $0x8,%esp
80107bc1:	8b 13                	mov    (%ebx),%edx
80107bc3:	ff 73 0c             	pushl  0xc(%ebx)
80107bc6:	50                   	push   %eax
80107bc7:	29 c1                	sub    %eax,%ecx
80107bc9:	89 f0                	mov    %esi,%eax
80107bcb:	e8 00 f3 ff ff       	call   80106ed0 <mappages>
80107bd0:	83 c4 10             	add    $0x10,%esp
80107bd3:	85 c0                	test   %eax,%eax
80107bd5:	78 19                	js     80107bf0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107bd7:	83 c3 10             	add    $0x10,%ebx
80107bda:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107be0:	75 d6                	jne    80107bb8 <setupkvm+0x28>
}
80107be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107be5:	89 f0                	mov    %esi,%eax
80107be7:	5b                   	pop    %ebx
80107be8:	5e                   	pop    %esi
80107be9:	5d                   	pop    %ebp
80107bea:	c3                   	ret    
80107beb:	90                   	nop
80107bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107bf0:	83 ec 0c             	sub    $0xc,%esp
80107bf3:	56                   	push   %esi
      return 0;
80107bf4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107bf6:	e8 15 ff ff ff       	call   80107b10 <freevm>
      return 0;
80107bfb:	83 c4 10             	add    $0x10,%esp
}
80107bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c01:	89 f0                	mov    %esi,%eax
80107c03:	5b                   	pop    %ebx
80107c04:	5e                   	pop    %esi
80107c05:	5d                   	pop    %ebp
80107c06:	c3                   	ret    
80107c07:	89 f6                	mov    %esi,%esi
80107c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c10 <kvmalloc>:
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c16:	e8 75 ff ff ff       	call   80107b90 <setupkvm>
80107c1b:	a3 14 ca 11 80       	mov    %eax,0x8011ca14
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c20:	05 00 00 00 80       	add    $0x80000000,%eax
80107c25:	0f 22 d8             	mov    %eax,%cr3
}
80107c28:	c9                   	leave  
80107c29:	c3                   	ret    
80107c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c30 <clearpteu>:
{
80107c30:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107c31:	31 c9                	xor    %ecx,%ecx
{
80107c33:	89 e5                	mov    %esp,%ebp
80107c35:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107c38:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3e:	e8 0d f2 ff ff       	call   80106e50 <walkpgdir>
  if(pte == 0)
80107c43:	85 c0                	test   %eax,%eax
80107c45:	74 05                	je     80107c4c <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107c47:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107c4a:	c9                   	leave  
80107c4b:	c3                   	ret    
    panic("clearpteu");
80107c4c:	83 ec 0c             	sub    $0xc,%esp
80107c4f:	68 c8 8e 10 80       	push   $0x80108ec8
80107c54:	e8 37 87 ff ff       	call   80100390 <panic>
80107c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c60 <copyuvm>:
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80107c69:	e8 42 c1 ff ff       	call   80103db0 <myproc>
80107c6e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if((d = setupkvm()) == 0)
80107c71:	e8 1a ff ff ff       	call   80107b90 <setupkvm>
80107c76:	85 c0                	test   %eax,%eax
80107c78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c7b:	0f 84 ec 00 00 00    	je     80107d6d <copyuvm+0x10d>
  for(i = 0; i < sz; i += PGSIZE){
80107c81:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c84:	85 d2                	test   %edx,%edx
80107c86:	0f 84 e1 00 00 00    	je     80107d6d <copyuvm+0x10d>
	    lcr3(V2P(d));  // Flush TLB
80107c8c:	05 00 00 00 80       	add    $0x80000000,%eax
  for(i = 0; i < sz; i += PGSIZE){
80107c91:	31 f6                	xor    %esi,%esi
	    lcr3(V2P(d));  // Flush TLB
80107c93:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107c96:	eb 35                	jmp    80107ccd <copyuvm+0x6d>
80107c98:	90                   	nop
80107c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(*pte & PTE_PG){ // If in swapFile 
80107ca0:	f6 c4 02             	test   $0x2,%ah
80107ca3:	0f 84 d0 01 00 00    	je     80107e79 <copyuvm+0x219>
        pte = walkpgdir(d, (void*)i, 1); // Create PTE for the page
80107ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cac:	b9 01 00 00 00       	mov    $0x1,%ecx
80107cb1:	89 f2                	mov    %esi,%edx
80107cb3:	e8 98 f1 ff ff       	call   80106e50 <walkpgdir>
        *pte = PTE_U | PTE_W | PTE_PG;
80107cb8:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80107cbe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cc4:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cc7:	0f 86 a0 00 00 00    	jbe    80107d6d <copyuvm+0x10d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd0:	31 c9                	xor    %ecx,%ecx
80107cd2:	89 f2                	mov    %esi,%edx
80107cd4:	e8 77 f1 ff ff       	call   80106e50 <walkpgdir>
80107cd9:	85 c0                	test   %eax,%eax
80107cdb:	89 c7                	mov    %eax,%edi
80107cdd:	0f 84 89 01 00 00    	je     80107e6c <copyuvm+0x20c>
    if(!(*pte & PTE_P)){
80107ce3:	8b 00                	mov    (%eax),%eax
80107ce5:	a8 01                	test   $0x1,%al
80107ce7:	74 b7                	je     80107ca0 <copyuvm+0x40>
    pa = PTE_ADDR(*pte);
80107ce9:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107ceb:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(p && p->pid > 2){
80107cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
    pa = PTE_ADDR(*pte);
80107cf6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(p && p->pid > 2){
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	74 06                	je     80107d06 <copyuvm+0xa6>
80107d00:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107d04:	7f 7a                	jg     80107d80 <copyuvm+0x120>
  		if((mem = kalloc()) == 0)
80107d06:	e8 d5 ac ff ff       	call   801029e0 <kalloc>
80107d0b:	85 c0                	test   %eax,%eax
80107d0d:	89 c7                	mov    %eax,%edi
80107d0f:	74 47                	je     80107d58 <copyuvm+0xf8>
      	memmove(mem, (char*)P2V(pa), PGSIZE);
80107d11:	83 ec 04             	sub    $0x4,%esp
80107d14:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107d1a:	68 00 10 00 00       	push   $0x1000
80107d1f:	53                   	push   %ebx
80107d20:	50                   	push   %eax
80107d21:	e8 ba cf ff ff       	call   80104ce0 <memmove>
      	if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d26:	58                   	pop    %eax
80107d27:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107d2d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d32:	5a                   	pop    %edx
80107d33:	ff 75 e0             	pushl  -0x20(%ebp)
80107d36:	50                   	push   %eax
80107d37:	89 f2                	mov    %esi,%edx
80107d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d3c:	e8 8f f1 ff ff       	call   80106ed0 <mappages>
80107d41:	83 c4 10             	add    $0x10,%esp
80107d44:	85 c0                	test   %eax,%eax
80107d46:	0f 89 72 ff ff ff    	jns    80107cbe <copyuvm+0x5e>
        		kfree(mem);
80107d4c:	83 ec 0c             	sub    $0xc,%esp
80107d4f:	57                   	push   %edi
80107d50:	e8 7b aa ff ff       	call   801027d0 <kfree>
        		goto bad;
80107d55:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107d58:	83 ec 0c             	sub    $0xc,%esp
80107d5b:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d5e:	e8 ad fd ff ff       	call   80107b10 <freevm>
  return 0;
80107d63:	83 c4 10             	add    $0x10,%esp
80107d66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d73:	5b                   	pop    %ebx
80107d74:	5e                   	pop    %esi
80107d75:	5f                   	pop    %edi
80107d76:	5d                   	pop    %ebp
80107d77:	c3                   	ret    
80107d78:	90                   	nop
80107d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      acquire(&currentPagesLock);
80107d80:	83 ec 0c             	sub    $0xc,%esp
80107d83:	68 e0 c9 11 80       	push   $0x8011c9e0
80107d88:	e8 93 cd ff ff       	call   80104b20 <acquire>
	    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107d8d:	59                   	pop    %ecx
80107d8e:	58                   	pop    %eax
80107d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d92:	ff 75 e0             	pushl  -0x20(%ebp)
80107d95:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d9a:	53                   	push   %ebx
80107d9b:	89 f2                	mov    %esi,%edx
80107d9d:	e8 2e f1 ff ff       	call   80106ed0 <mappages>
80107da2:	83 c4 10             	add    $0x10,%esp
80107da5:	85 c0                	test   %eax,%eax
80107da7:	78 af                	js     80107d58 <copyuvm+0xf8>
	for (int i = 0; i < MAX_PAGES; ++i)
80107da9:	31 c0                	xor    %eax,%eax
80107dab:	eb 0d                	jmp    80107dba <copyuvm+0x15a>
80107dad:	8d 76 00             	lea    0x0(%esi),%esi
80107db0:	83 c0 01             	add    $0x1,%eax
80107db3:	3d 00 04 00 00       	cmp    $0x400,%eax
80107db8:	74 66                	je     80107e20 <copyuvm+0x1c0>
		if(currentPages[i].pa == pa){
80107dba:	3b 1c c5 20 1f 11 80 	cmp    -0x7feee0e0(,%eax,8),%ebx
80107dc1:	75 ed                	jne    80107db0 <copyuvm+0x150>
		currentPages[indx].refCounter++;
80107dc3:	83 04 c5 24 1f 11 80 	addl   $0x1,-0x7feee0dc(,%eax,8)
80107dca:	01 
	    *pte &= ~PTE_W;
80107dcb:	8b 07                	mov    (%edi),%eax
80107dcd:	83 e0 fd             	and    $0xfffffffd,%eax
80107dd0:	80 cc 04             	or     $0x4,%ah
80107dd3:	89 07                	mov    %eax,(%edi)
	    lcr3(V2P(p->pgdir));  // Flush TLB
80107dd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107dd8:	8b 40 04             	mov    0x4(%eax),%eax
80107ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107dde:	05 00 00 00 80       	add    $0x80000000,%eax
80107de3:	0f 22 d8             	mov    %eax,%cr3
	    pte_t *newPte = walkpgdir(d, (void*)i, 0);
80107de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107de9:	31 c9                	xor    %ecx,%ecx
80107deb:	89 f2                	mov    %esi,%edx
80107ded:	e8 5e f0 ff ff       	call   80106e50 <walkpgdir>
	    if(newPte == 0)
80107df2:	85 c0                	test   %eax,%eax
80107df4:	0f 84 8c 00 00 00    	je     80107e86 <copyuvm+0x226>
	    *newPte &= ~PTE_W;
80107dfa:	8b 10                	mov    (%eax),%edx
80107dfc:	83 e2 fd             	and    $0xfffffffd,%edx
80107dff:	80 ce 04             	or     $0x4,%dh
80107e02:	89 10                	mov    %edx,(%eax)
80107e04:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107e07:	0f 22 d8             	mov    %eax,%cr3
      release(&currentPagesLock);
80107e0a:	83 ec 0c             	sub    $0xc,%esp
80107e0d:	68 e0 c9 11 80       	push   $0x8011c9e0
80107e12:	e8 c9 cd ff ff       	call   80104be0 <release>
    if(p && p->pid > 2){
80107e17:	83 c4 10             	add    $0x10,%esp
80107e1a:	e9 9f fe ff ff       	jmp    80107cbe <copyuvm+0x5e>
80107e1f:	90                   	nop
		if(currentPages[i].pa == -1){
80107e20:	83 3d 20 1f 11 80 ff 	cmpl   $0xffffffff,0x80111f20
80107e27:	74 3f                	je     80107e68 <copyuvm+0x208>
	for(int i = 0; i < MAX_PAGES; i++){
80107e29:	b8 01 00 00 00       	mov    $0x1,%eax
80107e2e:	eb 0a                	jmp    80107e3a <copyuvm+0x1da>
80107e30:	83 c0 01             	add    $0x1,%eax
80107e33:	3d 00 04 00 00       	cmp    $0x400,%eax
80107e38:	74 21                	je     80107e5b <copyuvm+0x1fb>
		if(currentPages[i].pa == -1){
80107e3a:	83 3c c5 20 1f 11 80 	cmpl   $0xffffffff,-0x7feee0e0(,%eax,8)
80107e41:	ff 
80107e42:	75 ec                	jne    80107e30 <copyuvm+0x1d0>
    currentPages[freeEntry].pa = pa;
80107e44:	89 1c c5 20 1f 11 80 	mov    %ebx,-0x7feee0e0(,%eax,8)
		currentPages[freeEntry].refCounter = 2; // parent and child
80107e4b:	c7 04 c5 24 1f 11 80 	movl   $0x2,-0x7feee0dc(,%eax,8)
80107e52:	02 00 00 00 
80107e56:	e9 70 ff ff ff       	jmp    80107dcb <copyuvm+0x16b>
			panic("addToCurrentPages: no free entry in currentPages");
80107e5b:	83 ec 0c             	sub    $0xc,%esp
80107e5e:	68 f8 90 10 80       	push   $0x801090f8
80107e63:	e8 28 85 ff ff       	call   80100390 <panic>
	for(int i = 0; i < MAX_PAGES; i++){
80107e68:	31 c0                	xor    %eax,%eax
80107e6a:	eb d8                	jmp    80107e44 <copyuvm+0x1e4>
      panic("copyuvm: pte should exist");
80107e6c:	83 ec 0c             	sub    $0xc,%esp
80107e6f:	68 d2 8e 10 80       	push   $0x80108ed2
80107e74:	e8 17 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107e79:	83 ec 0c             	sub    $0xc,%esp
80107e7c:	68 ec 8e 10 80       	push   $0x80108eec
80107e81:	e8 0a 85 ff ff       	call   80100390 <panic>
	    	panic("cpyuvm: NEW PTE havent found");
80107e86:	83 ec 0c             	sub    $0xc,%esp
80107e89:	68 06 8f 10 80       	push   $0x80108f06
80107e8e:	e8 fd 84 ff ff       	call   80100390 <panic>
80107e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ea0 <uva2ka>:
{
80107ea0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107ea1:	31 c9                	xor    %ecx,%ecx
{
80107ea3:	89 e5                	mov    %esp,%ebp
80107ea5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107eab:	8b 45 08             	mov    0x8(%ebp),%eax
80107eae:	e8 9d ef ff ff       	call   80106e50 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107eb3:	8b 00                	mov    (%eax),%eax
}
80107eb5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107eb6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ebd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ec0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ec5:	83 fa 05             	cmp    $0x5,%edx
80107ec8:	ba 00 00 00 00       	mov    $0x0,%edx
80107ecd:	0f 45 c2             	cmovne %edx,%eax
}
80107ed0:	c3                   	ret    
80107ed1:	eb 0d                	jmp    80107ee0 <copyout>
80107ed3:	90                   	nop
80107ed4:	90                   	nop
80107ed5:	90                   	nop
80107ed6:	90                   	nop
80107ed7:	90                   	nop
80107ed8:	90                   	nop
80107ed9:	90                   	nop
80107eda:	90                   	nop
80107edb:	90                   	nop
80107edc:	90                   	nop
80107edd:	90                   	nop
80107ede:	90                   	nop
80107edf:	90                   	nop

80107ee0 <copyout>:
{
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	57                   	push   %edi
80107ee4:	56                   	push   %esi
80107ee5:	53                   	push   %ebx
80107ee6:	83 ec 1c             	sub    $0x1c,%esp
80107ee9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107eec:	8b 55 0c             	mov    0xc(%ebp),%edx
80107eef:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80107ef2:	85 db                	test   %ebx,%ebx
80107ef4:	75 40                	jne    80107f36 <copyout+0x56>
80107ef6:	eb 70                	jmp    80107f68 <copyout+0x88>
80107ef8:	90                   	nop
80107ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80107f00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f03:	89 f1                	mov    %esi,%ecx
80107f05:	29 d1                	sub    %edx,%ecx
80107f07:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107f0d:	39 d9                	cmp    %ebx,%ecx
80107f0f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
80107f12:	29 f2                	sub    %esi,%edx
80107f14:	83 ec 04             	sub    $0x4,%esp
80107f17:	01 d0                	add    %edx,%eax
80107f19:	51                   	push   %ecx
80107f1a:	57                   	push   %edi
80107f1b:	50                   	push   %eax
80107f1c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107f1f:	e8 bc cd ff ff       	call   80104ce0 <memmove>
    buf += n;
80107f24:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107f27:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107f2a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107f30:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107f32:	29 cb                	sub    %ecx,%ebx
80107f34:	74 32                	je     80107f68 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107f36:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f38:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107f3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f3e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f44:	56                   	push   %esi
80107f45:	ff 75 08             	pushl  0x8(%ebp)
80107f48:	e8 53 ff ff ff       	call   80107ea0 <uva2ka>
    if(pa0 == 0)
80107f4d:	83 c4 10             	add    $0x10,%esp
80107f50:	85 c0                	test   %eax,%eax
80107f52:	75 ac                	jne    80107f00 <copyout+0x20>
}
80107f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f5c:	5b                   	pop    %ebx
80107f5d:	5e                   	pop    %esi
80107f5e:	5f                   	pop    %edi
80107f5f:	5d                   	pop    %ebp
80107f60:	c3                   	ret    
80107f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f6b:	31 c0                	xor    %eax,%eax
}
80107f6d:	5b                   	pop    %ebx
80107f6e:	5e                   	pop    %esi
80107f6f:	5f                   	pop    %edi
80107f70:	5d                   	pop    %ebp
80107f71:	c3                   	ret    
80107f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <checkIfSwapFault>:
checkIfSwapFault(uint va){
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	53                   	push   %ebx
80107f84:	83 ec 04             	sub    $0x4,%esp
80107f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde_t* pgdir = myproc()->pgdir;
80107f8a:	e8 21 be ff ff       	call   80103db0 <myproc>
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f8f:	8b 40 04             	mov    0x4(%eax),%eax
  pde_t *pde = &pgdir[PDX(va)];
80107f92:	89 da                	mov    %ebx,%edx
  pte_t * pte = &pgtab[PTX(va)];
80107f94:	c1 eb 0c             	shr    $0xc,%ebx
  pde_t *pde = &pgdir[PDX(va)];
80107f97:	c1 ea 16             	shr    $0x16,%edx
  pte_t * pte = &pgtab[PTX(va)];
80107f9a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fa0:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107fa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return ((!(*pte & PTE_P)) && (*pte & PTE_PG));
80107fa8:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
80107faf:	25 01 02 00 00       	and    $0x201,%eax
80107fb4:	3d 00 02 00 00       	cmp    $0x200,%eax
80107fb9:	0f 94 c0             	sete   %al
}
80107fbc:	83 c4 04             	add    $0x4,%esp
  return ((!(*pte & PTE_P)) && (*pte & PTE_PG));
80107fbf:	0f b6 c0             	movzbl %al,%eax
}
80107fc2:	5b                   	pop    %ebx
80107fc3:	5d                   	pop    %ebp
80107fc4:	c3                   	ret    
80107fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fd0 <swapToRam>:
swapToRam(uint va){
80107fd0:	55                   	push   %ebp
80107fd1:	89 e5                	mov    %esp,%ebp
80107fd3:	57                   	push   %edi
80107fd4:	56                   	push   %esi
80107fd5:	53                   	push   %ebx
80107fd6:	81 ec 1c 10 00 00    	sub    $0x101c,%esp
80107fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *p = myproc();
80107fdf:	e8 cc bd ff ff       	call   80103db0 <myproc>
  if(p->pid < 2)
80107fe4:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80107fe8:	0f 8e e1 01 00 00    	jle    801081cf <swapToRam+0x1ff>
80107fee:	89 c6                	mov    %eax,%esi
  for(int i = 0; i < 16; i++){
80107ff0:	31 db                	xor    %ebx,%ebx
80107ff2:	eb 10                	jmp    80108004 <swapToRam+0x34>
80107ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ff8:	83 c3 01             	add    $0x1,%ebx
80107ffb:	83 fb 10             	cmp    $0x10,%ebx
80107ffe:	0f 84 94 01 00 00    	je     80108198 <swapToRam+0x1c8>
    if(p->swapPages[i] == va){
80108004:	8b 84 9e 80 00 00 00 	mov    0x80(%esi,%ebx,4),%eax
8010800b:	39 f8                	cmp    %edi,%eax
8010800d:	75 e9                	jne    80107ff8 <swapToRam+0x28>
  char buf1[PGSIZE/2] = "";
8010800f:	8d bd ec ef ff ff    	lea    -0x1014(%ebp),%edi
80108015:	89 85 e4 ef ff ff    	mov    %eax,-0x101c(%ebp)
8010801b:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80108020:	31 c0                	xor    %eax,%eax
80108022:	c7 85 e8 ef ff ff 00 	movl   $0x0,-0x1018(%ebp)
80108029:	00 00 00 
  char buf2[PGSIZE/2] = "";
8010802c:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80108033:	00 00 00 
  char buf1[PGSIZE/2] = "";
80108036:	f3 ab                	rep stos %eax,%es:(%edi)
  char buf2[PGSIZE/2] = "";
80108038:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
8010803e:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80108043:	f3 ab                	rep stos %eax,%es:(%edi)
  if(readFromSwapFile(p, buf1, indx*PGSIZE, PGSIZE/2) < 0)
80108045:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
8010804b:	89 df                	mov    %ebx,%edi
8010804d:	68 00 08 00 00       	push   $0x800
80108052:	c1 e7 0c             	shl    $0xc,%edi
80108055:	57                   	push   %edi
80108056:	50                   	push   %eax
80108057:	56                   	push   %esi
80108058:	e8 53 a3 ff ff       	call   801023b0 <readFromSwapFile>
8010805d:	83 c4 10             	add    $0x10,%esp
80108060:	85 c0                	test   %eax,%eax
80108062:	0f 88 4d 01 00 00    	js     801081b5 <swapToRam+0x1e5>
   if(readFromSwapFile(p, buf2, indx*PGSIZE + PGSIZE/2, PGSIZE/2) < 0)
80108068:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
8010806e:	81 c7 00 08 00 00    	add    $0x800,%edi
80108074:	68 00 08 00 00       	push   $0x800
80108079:	57                   	push   %edi
8010807a:	50                   	push   %eax
8010807b:	56                   	push   %esi
8010807c:	e8 2f a3 ff ff       	call   801023b0 <readFromSwapFile>
80108081:	83 c4 10             	add    $0x10,%esp
80108084:	85 c0                	test   %eax,%eax
80108086:	0f 88 29 01 00 00    	js     801081b5 <swapToRam+0x1e5>
  p->swapPages[indx] = -1;
8010808c:	c7 84 9e 80 00 00 00 	movl   $0xffffffff,0x80(%esi,%ebx,4)
80108093:	ff ff ff ff 
  p->swapCounter--;
80108097:	83 ae 44 01 00 00 01 	subl   $0x1,0x144(%esi)
  if(p->ramCounter >= 16)
8010809e:	83 be 40 01 00 00 0f 	cmpl   $0xf,0x140(%esi)
801080a5:	0f 87 c5 00 00 00    	ja     80108170 <swapToRam+0x1a0>
  for(int i = 0; i < 16; i++){
801080ab:	31 db                	xor    %ebx,%ebx
801080ad:	eb 0d                	jmp    801080bc <swapToRam+0xec>
801080af:	90                   	nop
801080b0:	83 c3 01             	add    $0x1,%ebx
801080b3:	83 fb 10             	cmp    $0x10,%ebx
801080b6:	0f 84 ec 00 00 00    	je     801081a8 <swapToRam+0x1d8>
    if(p->ramPages[i].va == -1){
801080bc:	83 bc de c0 00 00 00 	cmpl   $0xffffffff,0xc0(%esi,%ebx,8)
801080c3:	ff 
801080c4:	75 ea                	jne    801080b0 <swapToRam+0xe0>
  char *mem = kalloc();
801080c6:	e8 15 a9 ff ff       	call   801029e0 <kalloc>
  if(mem == 0)
801080cb:	85 c0                	test   %eax,%eax
  char *mem = kalloc();
801080cd:	89 c7                	mov    %eax,%edi
  if(mem == 0)
801080cf:	0f 84 ed 00 00 00    	je     801081c2 <swapToRam+0x1f2>
  memset(mem, 0, PGSIZE);
801080d5:	83 ec 04             	sub    $0x4,%esp
801080d8:	68 00 10 00 00       	push   $0x1000
801080dd:	6a 00                	push   $0x0
801080df:	57                   	push   %edi
801080e0:	e8 4b cb ff ff       	call   80104c30 <memset>
  memmove(mem, buf1, PGSIZE/2);
801080e5:	8d 85 e8 ef ff ff    	lea    -0x1018(%ebp),%eax
801080eb:	83 c4 0c             	add    $0xc,%esp
801080ee:	68 00 08 00 00       	push   $0x800
801080f3:	50                   	push   %eax
801080f4:	57                   	push   %edi
801080f5:	e8 e6 cb ff ff       	call   80104ce0 <memmove>
  memmove(mem + PGSIZE/2, buf2, PGSIZE/2);
801080fa:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
80108100:	83 c4 0c             	add    $0xc,%esp
80108103:	68 00 08 00 00       	push   $0x800
80108108:	50                   	push   %eax
80108109:	8d 87 00 08 00 00    	lea    0x800(%edi),%eax
8010810f:	50                   	push   %eax
80108110:	e8 cb cb ff ff       	call   80104ce0 <memmove>
  pte_t *pte = walkpgdir(p->pgdir, (char*)va, 0);
80108115:	8b 95 e4 ef ff ff    	mov    -0x101c(%ebp),%edx
8010811b:	8b 46 04             	mov    0x4(%esi),%eax
8010811e:	31 c9                	xor    %ecx,%ecx
80108120:	e8 2b ed ff ff       	call   80106e50 <walkpgdir>
  *pte = V2P(mem) | ((PTE_FLAGS(*pte) | PTE_P) & ~PTE_PG);
80108125:	8b 10                	mov    (%eax),%edx
80108127:	8d 8f 00 00 00 80    	lea    -0x80000000(%edi),%ecx
8010812d:	83 c9 01             	or     $0x1,%ecx
80108130:	81 e2 fe 0d 00 00    	and    $0xdfe,%edx
80108136:	09 ca                	or     %ecx,%edx
80108138:	89 10                	mov    %edx,(%eax)
  lcr3(V2P(p->pgdir));  // Flush TLB
8010813a:	8b 46 04             	mov    0x4(%esi),%eax
8010813d:	05 00 00 00 80       	add    $0x80000000,%eax
80108142:	0f 22 d8             	mov    %eax,%cr3
    p->ramPages[indx].va = va;
80108145:	8b 95 e4 ef ff ff    	mov    -0x101c(%ebp),%edx
8010814b:	8d 04 de             	lea    (%esi,%ebx,8),%eax
    p->ramPages[indx].counter = 0;
8010814e:	c7 80 c4 00 00 00 00 	movl   $0x0,0xc4(%eax)
80108155:	00 00 00 
    p->ramPages[indx].va = va;
80108158:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  p->ramCounter++;
8010815e:	83 86 40 01 00 00 01 	addl   $0x1,0x140(%esi)
}
80108165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108168:	5b                   	pop    %ebx
80108169:	5e                   	pop    %esi
8010816a:	5f                   	pop    %edi
8010816b:	5d                   	pop    %ebp
8010816c:	c3                   	ret    
8010816d:	8d 76 00             	lea    0x0(%esi),%esi
  if(p->pid < 2)
80108170:	83 7e 10 01          	cmpl   $0x1,0x10(%esi)
80108174:	7e 0f                	jle    80108185 <swapToRam+0x1b5>
80108176:	89 f0                	mov    %esi,%eax
80108178:	e8 43 ee ff ff       	call   80106fc0 <swapToFile.part.0>
    if(swapToFile(p) < 0)
8010817d:	85 c0                	test   %eax,%eax
8010817f:	0f 89 26 ff ff ff    	jns    801080ab <swapToRam+0xdb>
      panic("swapToRam: swapToFile failed!");
80108185:	83 ec 0c             	sub    $0xc,%esp
80108188:	68 3f 8f 10 80       	push   $0x80108f3f
8010818d:	e8 fe 81 ff ff       	call   80100390 <panic>
80108192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("swapToRam: requested page not found");
80108198:	83 ec 0c             	sub    $0xc,%esp
8010819b:	68 78 91 10 80       	push   $0x80109178
801081a0:	e8 eb 81 ff ff       	call   80100390 <panic>
801081a5:	8d 76 00             	lea    0x0(%esi),%esi
    panic("swapToRam: couldnt find free space in RAM");
801081a8:	83 ec 0c             	sub    $0xc,%esp
801081ab:	68 9c 91 10 80       	push   $0x8010919c
801081b0:	e8 db 81 ff ff       	call   80100390 <panic>
    panic("swapToRam: couldnt read from swap file");
801081b5:	83 ec 0c             	sub    $0xc,%esp
801081b8:	68 2c 91 10 80       	push   $0x8010912c
801081bd:	e8 ce 81 ff ff       	call   80100390 <panic>
    panic("swapToRam: couldnt allocate memory");
801081c2:	83 ec 0c             	sub    $0xc,%esp
801081c5:	68 54 91 10 80       	push   $0x80109154
801081ca:	e8 c1 81 ff ff       	call   80100390 <panic>
    panic("swapToRam: process pid <= 2");
801081cf:	83 ec 0c             	sub    $0xc,%esp
801081d2:	68 23 8f 10 80       	push   $0x80108f23
801081d7:	e8 b4 81 ff ff       	call   80100390 <panic>
801081dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801081e0 <checkIfCowFault>:
checkIfCowFault(uint va){
801081e0:	55                   	push   %ebp
801081e1:	89 e5                	mov    %esp,%ebp
801081e3:	53                   	push   %ebx
801081e4:	83 ec 04             	sub    $0x4,%esp
801081e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde_t* pgdir = myproc()->pgdir;
801081ea:	e8 c1 bb ff ff       	call   80103db0 <myproc>
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081ef:	8b 40 04             	mov    0x4(%eax),%eax
  pde_t *pde = &pgdir[PDX(va)];
801081f2:	89 da                	mov    %ebx,%edx
  pte_t * pte = &pgtab[PTX(va)];
801081f4:	c1 eb 0c             	shr    $0xc,%ebx
  pde_t *pde = &pgdir[PDX(va)];
801081f7:	c1 ea 16             	shr    $0x16,%edx
  pte_t * pte = &pgtab[PTX(va)];
801081fa:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108200:	8b 04 90             	mov    (%eax,%edx,4),%eax
80108203:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return ((!(*pte & PTE_W)) && (*pte & PTE_RO));
80108208:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
8010820f:	25 02 04 00 00       	and    $0x402,%eax
80108214:	3d 00 04 00 00       	cmp    $0x400,%eax
80108219:	0f 94 c0             	sete   %al
}
8010821c:	83 c4 04             	add    $0x4,%esp
  return ((!(*pte & PTE_W)) && (*pte & PTE_RO));
8010821f:	0f b6 c0             	movzbl %al,%eax
}
80108222:	5b                   	pop    %ebx
80108223:	5d                   	pop    %ebp
80108224:	c3                   	ret    
80108225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108230 <copyOnWrite>:
copyOnWrite(uint va){
80108230:	55                   	push   %ebp
80108231:	89 e5                	mov    %esp,%ebp
80108233:	57                   	push   %edi
80108234:	56                   	push   %esi
80108235:	53                   	push   %ebx
80108236:	83 ec 1c             	sub    $0x1c,%esp
80108239:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *p = myproc();
8010823c:	e8 6f bb ff ff       	call   80103db0 <myproc>
80108241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if((pte = walkpgdir(p->pgdir, (void *) va, 0)) == 0)
80108244:	8b 40 04             	mov    0x4(%eax),%eax
80108247:	31 c9                	xor    %ecx,%ecx
80108249:	89 da                	mov    %ebx,%edx
8010824b:	e8 00 ec ff ff       	call   80106e50 <walkpgdir>
80108250:	85 c0                	test   %eax,%eax
80108252:	0f 84 7d 01 00 00    	je     801083d5 <copyOnWrite+0x1a5>
  if(!(*pte & PTE_P))
80108258:	8b 30                	mov    (%eax),%esi
8010825a:	89 c7                	mov    %eax,%edi
8010825c:	f7 c6 01 00 00 00    	test   $0x1,%esi
80108262:	0f 84 87 01 00 00    	je     801083ef <copyOnWrite+0x1bf>
  if((*pte & PTE_W) || !(*pte & PTE_RO))
80108268:	89 f0                	mov    %esi,%eax
8010826a:	25 02 04 00 00       	and    $0x402,%eax
8010826f:	3d 00 04 00 00       	cmp    $0x400,%eax
80108274:	0f 85 82 01 00 00    	jne    801083fc <copyOnWrite+0x1cc>
  if(!holding(&currentPagesLock))
8010827a:	83 ec 0c             	sub    $0xc,%esp
  pa = PTE_ADDR(*pte);
8010827d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if(!holding(&currentPagesLock))
80108283:	68 e0 c9 11 80       	push   $0x8011c9e0
80108288:	e8 63 c8 ff ff       	call   80104af0 <holding>
8010828d:	83 c4 10             	add    $0x10,%esp
80108290:	85 c0                	test   %eax,%eax
80108292:	0f 84 88 00 00 00    	je     80108320 <copyOnWrite+0xf0>
	for (int i = 0; i < MAX_PAGES; ++i)
80108298:	31 db                	xor    %ebx,%ebx
8010829a:	eb 13                	jmp    801082af <copyOnWrite+0x7f>
8010829c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082a0:	83 c3 01             	add    $0x1,%ebx
801082a3:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801082a9:	0f 84 19 01 00 00    	je     801083c8 <copyOnWrite+0x198>
		if(currentPages[i].pa == pa){
801082af:	3b 34 dd 20 1f 11 80 	cmp    -0x7feee0e0(,%ebx,8),%esi
801082b6:	75 e8                	jne    801082a0 <copyOnWrite+0x70>
  if(currentPages[indx].refCounter < 1)
801082b8:	8b 04 dd 24 1f 11 80 	mov    -0x7feee0dc(,%ebx,8),%eax
801082bf:	85 c0                	test   %eax,%eax
801082c1:	0f 8e 1b 01 00 00    	jle    801083e2 <copyOnWrite+0x1b2>
  else if(currentPages[indx].refCounter == 1){
801082c7:	83 f8 01             	cmp    $0x1,%eax
801082ca:	75 6c                	jne    80108338 <copyOnWrite+0x108>
  currentPages[indx].pa = -1;
801082cc:	c7 04 dd 20 1f 11 80 	movl   $0xffffffff,-0x7feee0e0(,%ebx,8)
801082d3:	ff ff ff ff 
  currentPages[indx].refCounter = 0;
801082d7:	c7 04 dd 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%ebx,8)
801082de:	00 00 00 00 
  	*pte &= ~PTE_RO;
801082e2:	8b 07                	mov    (%edi),%eax
801082e4:	80 e4 fb             	and    $0xfb,%ah
801082e7:	83 c8 02             	or     $0x2,%eax
801082ea:	89 07                	mov    %eax,(%edi)
  	lcr3(V2P(p->pgdir));  // Flush TLB
801082ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082ef:	8b 40 04             	mov    0x4(%eax),%eax
801082f2:	05 00 00 00 80       	add    $0x80000000,%eax
801082f7:	0f 22 d8             	mov    %eax,%cr3
  if(holding(&currentPagesLock))
801082fa:	83 ec 0c             	sub    $0xc,%esp
801082fd:	68 e0 c9 11 80       	push   $0x8011c9e0
80108302:	e8 e9 c7 ff ff       	call   80104af0 <holding>
80108307:	83 c4 10             	add    $0x10,%esp
8010830a:	85 c0                	test   %eax,%eax
8010830c:	0f 85 8e 00 00 00    	jne    801083a0 <copyOnWrite+0x170>
}
80108312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108315:	5b                   	pop    %ebx
80108316:	5e                   	pop    %esi
80108317:	5f                   	pop    %edi
80108318:	5d                   	pop    %ebp
80108319:	c3                   	ret    
8010831a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&currentPagesLock);
80108320:	83 ec 0c             	sub    $0xc,%esp
80108323:	68 e0 c9 11 80       	push   $0x8011c9e0
80108328:	e8 f3 c7 ff ff       	call   80104b20 <acquire>
8010832d:	83 c4 10             	add    $0x10,%esp
80108330:	e9 63 ff ff ff       	jmp    80108298 <copyOnWrite+0x68>
80108335:	8d 76 00             	lea    0x0(%esi),%esi
  	if((mem = kalloc()) == 0){
80108338:	e8 a3 a6 ff ff       	call   801029e0 <kalloc>
8010833d:	85 c0                	test   %eax,%eax
8010833f:	89 c6                	mov    %eax,%esi
80108341:	74 75                	je     801083b8 <copyOnWrite+0x188>
  	uint pa = PTE_ADDR(*pte);
80108343:	8b 0f                	mov    (%edi),%ecx
  	memmove(mem, (char*)P2V(pa), PGSIZE);
80108345:	83 ec 04             	sub    $0x4,%esp
80108348:	68 00 10 00 00       	push   $0x1000
  	uint pa = PTE_ADDR(*pte);
8010834d:	89 c8                	mov    %ecx,%eax
8010834f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80108352:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  	memmove(mem, (char*)P2V(pa), PGSIZE);
80108357:	05 00 00 00 80       	add    $0x80000000,%eax
8010835c:	50                   	push   %eax
8010835d:	56                   	push   %esi
8010835e:	e8 7d c9 ff ff       	call   80104ce0 <memmove>
  	uint flags = PTE_FLAGS(*pte);
80108363:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  	*pte = V2P(mem) | flags;
80108366:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  	uint flags = PTE_FLAGS(*pte);
8010836c:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  	*pte = V2P(mem) | flags;
80108372:	09 c8                	or     %ecx,%eax
  	*pte &= ~PTE_RO;
80108374:	80 e4 fb             	and    $0xfb,%ah
80108377:	83 c8 02             	or     $0x2,%eax
8010837a:	89 07                	mov    %eax,(%edi)
  	lcr3(V2P(p->pgdir));  // Flush TLB
8010837c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010837f:	8b 40 04             	mov    0x4(%eax),%eax
80108382:	05 00 00 00 80       	add    $0x80000000,%eax
80108387:	0f 22 d8             	mov    %eax,%cr3
  	currentPages[indx].refCounter--;
8010838a:	83 2c dd 24 1f 11 80 	subl   $0x1,-0x7feee0dc(,%ebx,8)
80108391:	01 
80108392:	83 c4 10             	add    $0x10,%esp
80108395:	e9 60 ff ff ff       	jmp    801082fa <copyOnWrite+0xca>
8010839a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&currentPagesLock);
801083a0:	c7 45 08 e0 c9 11 80 	movl   $0x8011c9e0,0x8(%ebp)
}
801083a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083aa:	5b                   	pop    %ebx
801083ab:	5e                   	pop    %esi
801083ac:	5f                   	pop    %edi
801083ad:	5d                   	pop    %ebp
    release(&currentPagesLock);
801083ae:	e9 2d c8 ff ff       	jmp    80104be0 <release>
801083b3:	90                   	nop
801083b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801083b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083bb:	5b                   	pop    %ebx
801083bc:	5e                   	pop    %esi
801083bd:	5f                   	pop    %edi
801083be:	5d                   	pop    %ebp
  		exit();
801083bf:	e9 2c bf ff ff       	jmp    801042f0 <exit>
801083c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  	panic("copyOnWrite: couldnt find page in currentPages");
801083c8:	83 ec 0c             	sub    $0xc,%esp
801083cb:	68 0c 92 10 80       	push   $0x8010920c
801083d0:	e8 bb 7f ff ff       	call   80100390 <panic>
      panic("copyOnWrite: pte should exist");
801083d5:	83 ec 0c             	sub    $0xc,%esp
801083d8:	68 5d 8f 10 80       	push   $0x80108f5d
801083dd:	e8 ae 7f ff ff       	call   80100390 <panic>
  	panic("copyOnWrite: refCounter under 1");
801083e2:	83 ec 0c             	sub    $0xc,%esp
801083e5:	68 ec 91 10 80       	push   $0x801091ec
801083ea:	e8 a1 7f ff ff       	call   80100390 <panic>
  	panic("copyOnWrite: file is not present");
801083ef:	83 ec 0c             	sub    $0xc,%esp
801083f2:	68 c8 91 10 80       	push   $0x801091c8
801083f7:	e8 94 7f ff ff       	call   80100390 <panic>
  	panic("copyOnWrite: not COW fault");
801083fc:	83 ec 0c             	sub    $0xc,%esp
801083ff:	68 7b 8f 10 80       	push   $0x80108f7b
80108404:	e8 87 7f ff ff       	call   80100390 <panic>
80108409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108410 <UpdatePagingInfo>:
UpdatePagingInfo(uint va){
80108410:	55                   	push   %ebp
80108411:	89 e5                	mov    %esp,%ebp
}
80108413:	5d                   	pop    %ebp
80108414:	c3                   	ret    
