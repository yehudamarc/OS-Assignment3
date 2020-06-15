
_ass3Tests2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

	}


int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp

	cowtest();
  11:	e8 4a 00 00 00       	call   60 <cowtest>
	forktest();
  16:	e8 35 01 00 00       	call   150 <forktest>
	cowtest2();
  1b:	e8 a0 01 00 00       	call   1c0 <cowtest2>

	exit();
  20:	e8 6d 04 00 00       	call   492 <exit>
  25:	66 90                	xchg   %ax,%ax
  27:	66 90                	xchg   %ax,%ax
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <cowtest2.part.1>:
	cowtest2(void){
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 ec 08             	sub    $0x8,%esp
		wait();
  36:	e8 5f 04 00 00       	call   49a <wait>
		printf(1, "COW test 2 passed\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 38 09 00 00       	push   $0x938
  43:	6a 01                	push   $0x1
  45:	e8 96 05 00 00       	call   5e0 <printf>
		sleep(100);
  4a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  51:	e8 cc 04 00 00       	call   522 <sleep>
  56:	83 c4 10             	add    $0x10,%esp
	}
  59:	c9                   	leave  
  5a:	c3                   	ret    
  5b:	90                   	nop
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000060 <cowtest>:
	cowtest(void){
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
		for (int i = 0; i < 10; ++i) {
  64:	31 db                	xor    %ebx,%ebx
	cowtest(void){
  66:	81 ec 94 00 00 00    	sub    $0x94,%esp
		get_pages_info();
  6c:	e8 c1 04 00 00       	call   532 <get_pages_info>
  71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			arr[i] = sbrk(PGSIZE);
  78:	83 ec 0c             	sub    $0xc,%esp
  7b:	68 00 10 00 00       	push   $0x1000
  80:	e8 95 04 00 00       	call   51a <sbrk>
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
  85:	50                   	push   %eax
  86:	53                   	push   %ebx
  87:	68 4b 09 00 00       	push   $0x94b
  8c:	6a 01                	push   $0x1
			arr[i] = sbrk(PGSIZE);
  8e:	89 44 9d 80          	mov    %eax,-0x80(%ebp,%ebx,4)
		for (int i = 0; i < 10; ++i) {
  92:	83 c3 01             	add    $0x1,%ebx
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
  95:	e8 46 05 00 00       	call   5e0 <printf>
		for (int i = 0; i < 10; ++i) {
  9a:	83 c4 20             	add    $0x20,%esp
  9d:	83 fb 0a             	cmp    $0xa,%ebx
  a0:	75 d6                	jne    78 <cowtest+0x18>
		printf(1, "Called sbrk(PGSIZE) 10 times - all physical pages taken.\nPress any key...\n");
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	68 a4 09 00 00       	push   $0x9a4
  aa:	6a 01                	push   $0x1
  ac:	e8 2f 05 00 00       	call   5e0 <printf>
		getpid();
  b1:	e8 5c 04 00 00       	call   512 <getpid>
		get_pages_info();	
  b6:	e8 77 04 00 00       	call   532 <get_pages_info>
		gets(input, 10);
  bb:	5b                   	pop    %ebx
  bc:	58                   	pop    %eax
  bd:	8d 85 76 ff ff ff    	lea    -0x8a(%ebp),%eax
  c3:	6a 0a                	push   $0xa
  c5:	50                   	push   %eax
  c6:	e8 85 02 00 00       	call   350 <gets>
		if (fork()==0){
  cb:	e8 ba 03 00 00       	call   48a <fork>
  d0:	83 c4 10             	add    $0x10,%esp
  d3:	85 c0                	test   %eax,%eax
  d5:	74 2d                	je     104 <cowtest+0xa4>
		wait();
  d7:	e8 be 03 00 00       	call   49a <wait>
		get_pages_info();
  dc:	e8 51 04 00 00       	call   532 <get_pages_info>
		printf(1, "COW test 1 finished - check results\n");
  e1:	83 ec 08             	sub    $0x8,%esp
  e4:	68 20 0a 00 00       	push   $0xa20
  e9:	6a 01                	push   $0x1
  eb:	e8 f0 04 00 00       	call   5e0 <printf>
		sleep(100);
  f0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  f7:	e8 26 04 00 00       	call   522 <sleep>
	}
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 102:	c9                   	leave  
 103:	c3                   	ret    
			get_pages_info();
 104:	e8 29 04 00 00       	call   532 <get_pages_info>
			printf(1, "before: %s\n", arr[j][2]);
 109:	8b 5d 80             	mov    -0x80(%ebp),%ebx
 10c:	50                   	push   %eax
 10d:	0f be 43 02          	movsbl 0x2(%ebx),%eax
 111:	50                   	push   %eax
 112:	68 59 09 00 00       	push   $0x959
 117:	6a 01                	push   $0x1
 119:	e8 c2 04 00 00       	call   5e0 <printf>
			printf(1, "after: %s\n", arr[j][2]);
 11e:	83 c4 0c             	add    $0xc,%esp
			arr[j][2] = 'k';
 121:	c6 43 02 6b          	movb   $0x6b,0x2(%ebx)
			printf(1, "after: %s\n", arr[j][2]);
 125:	6a 6b                	push   $0x6b
 127:	68 65 09 00 00       	push   $0x965
 12c:	6a 01                	push   $0x1
 12e:	e8 ad 04 00 00       	call   5e0 <printf>
			get_pages_info();
 133:	e8 fa 03 00 00       	call   532 <get_pages_info>
			printf(1, "Number of free pages should be decreased by 1\n");
 138:	5a                   	pop    %edx
 139:	59                   	pop    %ecx
 13a:	68 f0 09 00 00       	push   $0x9f0
 13f:	6a 01                	push   $0x1
 141:	e8 9a 04 00 00       	call   5e0 <printf>
			exit();
 146:	e8 47 03 00 00       	call   492 <exit>
 14b:	90                   	nop
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000150 <forktest>:
	forktest(void){
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 10             	sub    $0x10,%esp
		printf(1, "Fork test ...\n");
 156:	68 70 09 00 00       	push   $0x970
 15b:	6a 01                	push   $0x1
 15d:	e8 7e 04 00 00       	call   5e0 <printf>
		if(fork() == 0){
 162:	e8 23 03 00 00       	call   48a <fork>
 167:	83 c4 10             	add    $0x10,%esp
 16a:	85 c0                	test   %eax,%eax
 16c:	75 2a                	jne    198 <forktest+0x48>
			if(fork() == 0){
 16e:	e8 17 03 00 00       	call   48a <fork>
 173:	85 c0                	test   %eax,%eax
 175:	75 11                	jne    188 <forktest+0x38>
				if(fork() == 0)
 177:	e8 0e 03 00 00       	call   48a <fork>
 17c:	85 c0                	test   %eax,%eax
 17e:	75 08                	jne    188 <forktest+0x38>
				exit();
 180:	e8 0d 03 00 00       	call   492 <exit>
 185:	8d 76 00             	lea    0x0(%esi),%esi
				wait();
 188:	e8 0d 03 00 00       	call   49a <wait>
				exit();
 18d:	e8 00 03 00 00       	call   492 <exit>
 192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		wait();
 198:	e8 fd 02 00 00       	call   49a <wait>
		printf(1, "Fork test passed\n");
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	68 7f 09 00 00       	push   $0x97f
 1a5:	6a 01                	push   $0x1
 1a7:	e8 34 04 00 00       	call   5e0 <printf>
		sleep(100);
 1ac:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 1b3:	e8 6a 03 00 00       	call   522 <sleep>
 1b8:	83 c4 10             	add    $0x10,%esp
	}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <cowtest2>:
	cowtest2(void){
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	83 ec 0c             	sub    $0xc,%esp
		printf(1, "COW test 2 ...\n");
 1c7:	68 91 09 00 00       	push   $0x991
 1cc:	6a 01                	push   $0x1
 1ce:	e8 0d 04 00 00       	call   5e0 <printf>
		if(fork() == 0){
 1d3:	e8 b2 02 00 00       	call   48a <fork>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	85 c0                	test   %eax,%eax
 1dd:	75 41                	jne    220 <cowtest2+0x60>
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				arr2[i] = sbrk(PGSIZE);
 1e8:	83 ec 0c             	sub    $0xc,%esp
 1eb:	68 00 10 00 00       	push   $0x1000
 1f0:	e8 25 03 00 00       	call   51a <sbrk>
				if(i < 10)
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	83 fb 09             	cmp    $0x9,%ebx
 1fb:	7e 2c                	jle    229 <cowtest2+0x69>
			for (int i = 0; i < 30000; ++i) {
 1fd:	83 c3 01             	add    $0x1,%ebx
 200:	81 fb 30 75 00 00    	cmp    $0x7530,%ebx
 206:	75 e0                	jne    1e8 <cowtest2+0x28>
			if(fork() == 0)
 208:	e8 7d 02 00 00       	call   48a <fork>
 20d:	85 c0                	test   %eax,%eax
 20f:	75 05                	jne    216 <cowtest2+0x56>
			exit();
 211:	e8 7c 02 00 00       	call   492 <exit>
			wait();
 216:	e8 7f 02 00 00       	call   49a <wait>
			exit();
 21b:	e8 72 02 00 00       	call   492 <exit>
	}
 220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 223:	c9                   	leave  
 224:	e9 07 fe ff ff       	jmp    30 <cowtest2.part.1>
					printf(1, "arr[%d]=0x%x\n", i, arr2[i]);
 229:	50                   	push   %eax
 22a:	53                   	push   %ebx
 22b:	68 4b 09 00 00       	push   $0x94b
 230:	6a 01                	push   $0x1
 232:	e8 a9 03 00 00       	call   5e0 <printf>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	eb c1                	jmp    1fd <cowtest2+0x3d>
 23c:	66 90                	xchg   %ax,%ax
 23e:	66 90                	xchg   %ax,%ax

00000240 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24a:	89 c2                	mov    %eax,%edx
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	83 c1 01             	add    $0x1,%ecx
 253:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 257:	83 c2 01             	add    $0x1,%edx
 25a:	84 db                	test   %bl,%bl
 25c:	88 5a ff             	mov    %bl,-0x1(%edx)
 25f:	75 ef                	jne    250 <strcpy+0x10>
    ;
  return os;
}
 261:	5b                   	pop    %ebx
 262:	5d                   	pop    %ebp
 263:	c3                   	ret    
 264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 26a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000270 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
 277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 27a:	0f b6 02             	movzbl (%edx),%eax
 27d:	0f b6 19             	movzbl (%ecx),%ebx
 280:	84 c0                	test   %al,%al
 282:	75 1c                	jne    2a0 <strcmp+0x30>
 284:	eb 2a                	jmp    2b0 <strcmp+0x40>
 286:	8d 76 00             	lea    0x0(%esi),%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 290:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 293:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 296:	83 c1 01             	add    $0x1,%ecx
 299:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 29c:	84 c0                	test   %al,%al
 29e:	74 10                	je     2b0 <strcmp+0x40>
 2a0:	38 d8                	cmp    %bl,%al
 2a2:	74 ec                	je     290 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2a4:	29 d8                	sub    %ebx,%eax
}
 2a6:	5b                   	pop    %ebx
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2b2:	29 d8                	sub    %ebx,%eax
}
 2b4:	5b                   	pop    %ebx
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2c6:	80 39 00             	cmpb   $0x0,(%ecx)
 2c9:	74 15                	je     2e0 <strlen+0x20>
 2cb:	31 d2                	xor    %edx,%edx
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2d7:	89 d0                	mov    %edx,%eax
 2d9:	75 f5                	jne    2d0 <strlen+0x10>
    ;
  return n;
}
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2e0:	31 c0                	xor    %eax,%eax
}
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret    
 2e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 d7                	mov    %edx,%edi
 2ff:	fc                   	cld    
 300:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 302:	89 d0                	mov    %edx,%eax
 304:	5f                   	pop    %edi
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 31a:	0f b6 10             	movzbl (%eax),%edx
 31d:	84 d2                	test   %dl,%dl
 31f:	74 1d                	je     33e <strchr+0x2e>
    if(*s == c)
 321:	38 d3                	cmp    %dl,%bl
 323:	89 d9                	mov    %ebx,%ecx
 325:	75 0d                	jne    334 <strchr+0x24>
 327:	eb 17                	jmp    340 <strchr+0x30>
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 330:	38 ca                	cmp    %cl,%dl
 332:	74 0c                	je     340 <strchr+0x30>
  for(; *s; s++)
 334:	83 c0 01             	add    $0x1,%eax
 337:	0f b6 10             	movzbl (%eax),%edx
 33a:	84 d2                	test   %dl,%dl
 33c:	75 f2                	jne    330 <strchr+0x20>
      return (char*)s;
  return 0;
 33e:	31 c0                	xor    %eax,%eax
}
 340:	5b                   	pop    %ebx
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <gets>:

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 356:	31 f6                	xor    %esi,%esi
 358:	89 f3                	mov    %esi,%ebx
{
 35a:	83 ec 1c             	sub    $0x1c,%esp
 35d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 360:	eb 2f                	jmp    391 <gets+0x41>
 362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 368:	8d 45 e7             	lea    -0x19(%ebp),%eax
 36b:	83 ec 04             	sub    $0x4,%esp
 36e:	6a 01                	push   $0x1
 370:	50                   	push   %eax
 371:	6a 00                	push   $0x0
 373:	e8 32 01 00 00       	call   4aa <read>
    if(cc < 1)
 378:	83 c4 10             	add    $0x10,%esp
 37b:	85 c0                	test   %eax,%eax
 37d:	7e 1c                	jle    39b <gets+0x4b>
      break;
    buf[i++] = c;
 37f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 383:	83 c7 01             	add    $0x1,%edi
 386:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 389:	3c 0a                	cmp    $0xa,%al
 38b:	74 23                	je     3b0 <gets+0x60>
 38d:	3c 0d                	cmp    $0xd,%al
 38f:	74 1f                	je     3b0 <gets+0x60>
  for(i=0; i+1 < max; ){
 391:	83 c3 01             	add    $0x1,%ebx
 394:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 397:	89 fe                	mov    %edi,%esi
 399:	7c cd                	jl     368 <gets+0x18>
 39b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    
 3ab:	90                   	nop
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b0:	8b 75 08             	mov    0x8(%ebp),%esi
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	01 de                	add    %ebx,%esi
 3b8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 3bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c0:	5b                   	pop    %ebx
 3c1:	5e                   	pop    %esi
 3c2:	5f                   	pop    %edi
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    
 3c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d5:	83 ec 08             	sub    $0x8,%esp
 3d8:	6a 00                	push   $0x0
 3da:	ff 75 08             	pushl  0x8(%ebp)
 3dd:	e8 f0 00 00 00       	call   4d2 <open>
  if(fd < 0)
 3e2:	83 c4 10             	add    $0x10,%esp
 3e5:	85 c0                	test   %eax,%eax
 3e7:	78 27                	js     410 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3e9:	83 ec 08             	sub    $0x8,%esp
 3ec:	ff 75 0c             	pushl  0xc(%ebp)
 3ef:	89 c3                	mov    %eax,%ebx
 3f1:	50                   	push   %eax
 3f2:	e8 f3 00 00 00       	call   4ea <fstat>
  close(fd);
 3f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3fa:	89 c6                	mov    %eax,%esi
  close(fd);
 3fc:	e8 b9 00 00 00       	call   4ba <close>
  return r;
 401:	83 c4 10             	add    $0x10,%esp
}
 404:	8d 65 f8             	lea    -0x8(%ebp),%esp
 407:	89 f0                	mov    %esi,%eax
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 410:	be ff ff ff ff       	mov    $0xffffffff,%esi
 415:	eb ed                	jmp    404 <stat+0x34>
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <atoi>:

int
atoi(const char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 427:	0f be 11             	movsbl (%ecx),%edx
 42a:	8d 42 d0             	lea    -0x30(%edx),%eax
 42d:	3c 09                	cmp    $0x9,%al
  n = 0;
 42f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 434:	77 1f                	ja     455 <atoi+0x35>
 436:	8d 76 00             	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 440:	8d 04 80             	lea    (%eax,%eax,4),%eax
 443:	83 c1 01             	add    $0x1,%ecx
 446:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 44a:	0f be 11             	movsbl (%ecx),%edx
 44d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 450:	80 fb 09             	cmp    $0x9,%bl
 453:	76 eb                	jbe    440 <atoi+0x20>
  return n;
}
 455:	5b                   	pop    %ebx
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
 458:	90                   	nop
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000460 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	56                   	push   %esi
 464:	53                   	push   %ebx
 465:	8b 5d 10             	mov    0x10(%ebp),%ebx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 46e:	85 db                	test   %ebx,%ebx
 470:	7e 14                	jle    486 <memmove+0x26>
 472:	31 d2                	xor    %edx,%edx
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 478:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 47c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 47f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 482:	39 d3                	cmp    %edx,%ebx
 484:	75 f2                	jne    478 <memmove+0x18>
  return vdst;
}
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5d                   	pop    %ebp
 489:	c3                   	ret    

0000048a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 48a:	b8 01 00 00 00       	mov    $0x1,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <exit>:
SYSCALL(exit)
 492:	b8 02 00 00 00       	mov    $0x2,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <wait>:
SYSCALL(wait)
 49a:	b8 03 00 00 00       	mov    $0x3,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <pipe>:
SYSCALL(pipe)
 4a2:	b8 04 00 00 00       	mov    $0x4,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <read>:
SYSCALL(read)
 4aa:	b8 05 00 00 00       	mov    $0x5,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <write>:
SYSCALL(write)
 4b2:	b8 10 00 00 00       	mov    $0x10,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <close>:
SYSCALL(close)
 4ba:	b8 15 00 00 00       	mov    $0x15,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <kill>:
SYSCALL(kill)
 4c2:	b8 06 00 00 00       	mov    $0x6,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <exec>:
SYSCALL(exec)
 4ca:	b8 07 00 00 00       	mov    $0x7,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <open>:
SYSCALL(open)
 4d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <mknod>:
SYSCALL(mknod)
 4da:	b8 11 00 00 00       	mov    $0x11,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <unlink>:
SYSCALL(unlink)
 4e2:	b8 12 00 00 00       	mov    $0x12,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <fstat>:
SYSCALL(fstat)
 4ea:	b8 08 00 00 00       	mov    $0x8,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <link>:
SYSCALL(link)
 4f2:	b8 13 00 00 00       	mov    $0x13,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <mkdir>:
SYSCALL(mkdir)
 4fa:	b8 14 00 00 00       	mov    $0x14,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <chdir>:
SYSCALL(chdir)
 502:	b8 09 00 00 00       	mov    $0x9,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <dup>:
SYSCALL(dup)
 50a:	b8 0a 00 00 00       	mov    $0xa,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <getpid>:
SYSCALL(getpid)
 512:	b8 0b 00 00 00       	mov    $0xb,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <sbrk>:
SYSCALL(sbrk)
 51a:	b8 0c 00 00 00       	mov    $0xc,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <sleep>:
SYSCALL(sleep)
 522:	b8 0d 00 00 00       	mov    $0xd,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <uptime>:
SYSCALL(uptime)
 52a:	b8 0e 00 00 00       	mov    $0xe,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <get_pages_info>:
SYSCALL(get_pages_info)
 532:	b8 16 00 00 00       	mov    $0x16,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    
 53a:	66 90                	xchg   %ax,%ax
 53c:	66 90                	xchg   %ax,%ax
 53e:	66 90                	xchg   %ax,%ax

00000540 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 549:	85 d2                	test   %edx,%edx
{
 54b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 54e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 550:	79 76                	jns    5c8 <printint+0x88>
 552:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 556:	74 70                	je     5c8 <printint+0x88>
    x = -xx;
 558:	f7 d8                	neg    %eax
    neg = 1;
 55a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 561:	31 f6                	xor    %esi,%esi
 563:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 566:	eb 0a                	jmp    572 <printint+0x32>
 568:	90                   	nop
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 570:	89 fe                	mov    %edi,%esi
 572:	31 d2                	xor    %edx,%edx
 574:	8d 7e 01             	lea    0x1(%esi),%edi
 577:	f7 f1                	div    %ecx
 579:	0f b6 92 50 0a 00 00 	movzbl 0xa50(%edx),%edx
  }while((x /= base) != 0);
 580:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 582:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 585:	75 e9                	jne    570 <printint+0x30>
  if(neg)
 587:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 58a:	85 c0                	test   %eax,%eax
 58c:	74 08                	je     596 <printint+0x56>
    buf[i++] = '-';
 58e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 593:	8d 7e 02             	lea    0x2(%esi),%edi
 596:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 59a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
 5a0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5a3:	83 ec 04             	sub    $0x4,%esp
 5a6:	83 ee 01             	sub    $0x1,%esi
 5a9:	6a 01                	push   $0x1
 5ab:	53                   	push   %ebx
 5ac:	57                   	push   %edi
 5ad:	88 45 d7             	mov    %al,-0x29(%ebp)
 5b0:	e8 fd fe ff ff       	call   4b2 <write>

  while(--i >= 0)
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	39 de                	cmp    %ebx,%esi
 5ba:	75 e4                	jne    5a0 <printint+0x60>
    putc(fd, buf[i]);
}
 5bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5e                   	pop    %esi
 5c1:	5f                   	pop    %edi
 5c2:	5d                   	pop    %ebp
 5c3:	c3                   	ret    
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5c8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5cf:	eb 90                	jmp    561 <printint+0x21>
 5d1:	eb 0d                	jmp    5e0 <printf>
 5d3:	90                   	nop
 5d4:	90                   	nop
 5d5:	90                   	nop
 5d6:	90                   	nop
 5d7:	90                   	nop
 5d8:	90                   	nop
 5d9:	90                   	nop
 5da:	90                   	nop
 5db:	90                   	nop
 5dc:	90                   	nop
 5dd:	90                   	nop
 5de:	90                   	nop
 5df:	90                   	nop

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5ec:	0f b6 1e             	movzbl (%esi),%ebx
 5ef:	84 db                	test   %bl,%bl
 5f1:	0f 84 b3 00 00 00    	je     6aa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5f7:	8d 45 10             	lea    0x10(%ebp),%eax
 5fa:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5fd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 602:	eb 2f                	jmp    633 <printf+0x53>
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 608:	83 f8 25             	cmp    $0x25,%eax
 60b:	0f 84 a7 00 00 00    	je     6b8 <printf+0xd8>
  write(fd, &c, 1);
 611:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 614:	83 ec 04             	sub    $0x4,%esp
 617:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 61a:	6a 01                	push   $0x1
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 8d fe ff ff       	call   4b2 <write>
 625:	83 c4 10             	add    $0x10,%esp
 628:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 62b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 62f:	84 db                	test   %bl,%bl
 631:	74 77                	je     6aa <printf+0xca>
    if(state == 0){
 633:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 635:	0f be cb             	movsbl %bl,%ecx
 638:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 63b:	74 cb                	je     608 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 63d:	83 ff 25             	cmp    $0x25,%edi
 640:	75 e6                	jne    628 <printf+0x48>
      if(c == 'd'){
 642:	83 f8 64             	cmp    $0x64,%eax
 645:	0f 84 05 01 00 00    	je     750 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 64b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 651:	83 f9 70             	cmp    $0x70,%ecx
 654:	74 72                	je     6c8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 656:	83 f8 73             	cmp    $0x73,%eax
 659:	0f 84 99 00 00 00    	je     6f8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65f:	83 f8 63             	cmp    $0x63,%eax
 662:	0f 84 08 01 00 00    	je     770 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 668:	83 f8 25             	cmp    $0x25,%eax
 66b:	0f 84 ef 00 00 00    	je     760 <printf+0x180>
  write(fd, &c, 1);
 671:	8d 45 e7             	lea    -0x19(%ebp),%eax
 674:	83 ec 04             	sub    $0x4,%esp
 677:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 67b:	6a 01                	push   $0x1
 67d:	50                   	push   %eax
 67e:	ff 75 08             	pushl  0x8(%ebp)
 681:	e8 2c fe ff ff       	call   4b2 <write>
 686:	83 c4 0c             	add    $0xc,%esp
 689:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 68c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 68f:	6a 01                	push   $0x1
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 698:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 69a:	e8 13 fe ff ff       	call   4b2 <write>
  for(i = 0; fmt[i]; i++){
 69f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6a6:	84 db                	test   %bl,%bl
 6a8:	75 89                	jne    633 <printf+0x53>
    }
  }
}
 6aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ad:	5b                   	pop    %ebx
 6ae:	5e                   	pop    %esi
 6af:	5f                   	pop    %edi
 6b0:	5d                   	pop    %ebp
 6b1:	c3                   	ret    
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6b8:	bf 25 00 00 00       	mov    $0x25,%edi
 6bd:	e9 66 ff ff ff       	jmp    628 <printf+0x48>
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6c8:	83 ec 0c             	sub    $0xc,%esp
 6cb:	b9 10 00 00 00       	mov    $0x10,%ecx
 6d0:	6a 00                	push   $0x0
 6d2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
 6d8:	8b 17                	mov    (%edi),%edx
 6da:	e8 61 fe ff ff       	call   540 <printint>
        ap++;
 6df:	89 f8                	mov    %edi,%eax
 6e1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6e4:	31 ff                	xor    %edi,%edi
        ap++;
 6e6:	83 c0 04             	add    $0x4,%eax
 6e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6ec:	e9 37 ff ff ff       	jmp    628 <printf+0x48>
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6fb:	8b 08                	mov    (%eax),%ecx
        ap++;
 6fd:	83 c0 04             	add    $0x4,%eax
 700:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 703:	85 c9                	test   %ecx,%ecx
 705:	0f 84 8e 00 00 00    	je     799 <printf+0x1b9>
        while(*s != 0){
 70b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 70e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 710:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 712:	84 c0                	test   %al,%al
 714:	0f 84 0e ff ff ff    	je     628 <printf+0x48>
 71a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 71d:	89 de                	mov    %ebx,%esi
 71f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 722:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 725:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 728:	83 ec 04             	sub    $0x4,%esp
          s++;
 72b:	83 c6 01             	add    $0x1,%esi
 72e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 731:	6a 01                	push   $0x1
 733:	57                   	push   %edi
 734:	53                   	push   %ebx
 735:	e8 78 fd ff ff       	call   4b2 <write>
        while(*s != 0){
 73a:	0f b6 06             	movzbl (%esi),%eax
 73d:	83 c4 10             	add    $0x10,%esp
 740:	84 c0                	test   %al,%al
 742:	75 e4                	jne    728 <printf+0x148>
 744:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 747:	31 ff                	xor    %edi,%edi
 749:	e9 da fe ff ff       	jmp    628 <printf+0x48>
 74e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	b9 0a 00 00 00       	mov    $0xa,%ecx
 758:	6a 01                	push   $0x1
 75a:	e9 73 ff ff ff       	jmp    6d2 <printf+0xf2>
 75f:	90                   	nop
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 766:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 769:	6a 01                	push   $0x1
 76b:	e9 21 ff ff ff       	jmp    691 <printf+0xb1>
        putc(fd, *ap);
 770:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 773:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 776:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 778:	6a 01                	push   $0x1
        ap++;
 77a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 77d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 780:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 783:	50                   	push   %eax
 784:	ff 75 08             	pushl  0x8(%ebp)
 787:	e8 26 fd ff ff       	call   4b2 <write>
        ap++;
 78c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 78f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 792:	31 ff                	xor    %edi,%edi
 794:	e9 8f fe ff ff       	jmp    628 <printf+0x48>
          s = "(null)";
 799:	bb 48 0a 00 00       	mov    $0xa48,%ebx
        while(*s != 0){
 79e:	b8 28 00 00 00       	mov    $0x28,%eax
 7a3:	e9 72 ff ff ff       	jmp    71a <printf+0x13a>
 7a8:	66 90                	xchg   %ax,%ax
 7aa:	66 90                	xchg   %ax,%ax
 7ac:	66 90                	xchg   %ax,%ax
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b1:	a1 84 0d 00 00       	mov    0xd84,%eax
{
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c8:	39 c8                	cmp    %ecx,%eax
 7ca:	8b 10                	mov    (%eax),%edx
 7cc:	73 32                	jae    800 <free+0x50>
 7ce:	39 d1                	cmp    %edx,%ecx
 7d0:	72 04                	jb     7d6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	39 d0                	cmp    %edx,%eax
 7d4:	72 32                	jb     808 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7d9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7dc:	39 fa                	cmp    %edi,%edx
 7de:	74 30                	je     810 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7e3:	8b 50 04             	mov    0x4(%eax),%edx
 7e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e9:	39 f1                	cmp    %esi,%ecx
 7eb:	74 3a                	je     827 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ed:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7ef:	a3 84 0d 00 00       	mov    %eax,0xd84
}
 7f4:	5b                   	pop    %ebx
 7f5:	5e                   	pop    %esi
 7f6:	5f                   	pop    %edi
 7f7:	5d                   	pop    %ebp
 7f8:	c3                   	ret    
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	39 d0                	cmp    %edx,%eax
 802:	72 04                	jb     808 <free+0x58>
 804:	39 d1                	cmp    %edx,%ecx
 806:	72 ce                	jb     7d6 <free+0x26>
{
 808:	89 d0                	mov    %edx,%eax
 80a:	eb bc                	jmp    7c8 <free+0x18>
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 810:	03 72 04             	add    0x4(%edx),%esi
 813:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 12                	mov    (%edx),%edx
 81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 823:	39 f1                	cmp    %esi,%ecx
 825:	75 c6                	jne    7ed <free+0x3d>
    p->s.size += bp->s.size;
 827:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 82a:	a3 84 0d 00 00       	mov    %eax,0xd84
    p->s.size += bp->s.size;
 82f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 832:	8b 53 f8             	mov    -0x8(%ebx),%edx
 835:	89 10                	mov    %edx,(%eax)
}
 837:	5b                   	pop    %ebx
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret    
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 84c:	8b 15 84 0d 00 00    	mov    0xd84,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8d 78 07             	lea    0x7(%eax),%edi
 855:	c1 ef 03             	shr    $0x3,%edi
 858:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 85b:	85 d2                	test   %edx,%edx
 85d:	0f 84 9d 00 00 00    	je     900 <malloc+0xc0>
 863:	8b 02                	mov    (%edx),%eax
 865:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 868:	39 cf                	cmp    %ecx,%edi
 86a:	76 6c                	jbe    8d8 <malloc+0x98>
 86c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 872:	bb 00 10 00 00       	mov    $0x1000,%ebx
 877:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 87a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 881:	eb 0e                	jmp    891 <malloc+0x51>
 883:	90                   	nop
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 88a:	8b 48 04             	mov    0x4(%eax),%ecx
 88d:	39 f9                	cmp    %edi,%ecx
 88f:	73 47                	jae    8d8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 891:	39 05 84 0d 00 00    	cmp    %eax,0xd84
 897:	89 c2                	mov    %eax,%edx
 899:	75 ed                	jne    888 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 89b:	83 ec 0c             	sub    $0xc,%esp
 89e:	56                   	push   %esi
 89f:	e8 76 fc ff ff       	call   51a <sbrk>
  if(p == (char*)-1)
 8a4:	83 c4 10             	add    $0x10,%esp
 8a7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8aa:	74 1c                	je     8c8 <malloc+0x88>
  hp->s.size = nu;
 8ac:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8af:	83 ec 0c             	sub    $0xc,%esp
 8b2:	83 c0 08             	add    $0x8,%eax
 8b5:	50                   	push   %eax
 8b6:	e8 f5 fe ff ff       	call   7b0 <free>
  return freep;
 8bb:	8b 15 84 0d 00 00    	mov    0xd84,%edx
      if((p = morecore(nunits)) == 0)
 8c1:	83 c4 10             	add    $0x10,%esp
 8c4:	85 d2                	test   %edx,%edx
 8c6:	75 c0                	jne    888 <malloc+0x48>
        return 0;
  }
}
 8c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8cb:	31 c0                	xor    %eax,%eax
}
 8cd:	5b                   	pop    %ebx
 8ce:	5e                   	pop    %esi
 8cf:	5f                   	pop    %edi
 8d0:	5d                   	pop    %ebp
 8d1:	c3                   	ret    
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8d8:	39 cf                	cmp    %ecx,%edi
 8da:	74 54                	je     930 <malloc+0xf0>
        p->s.size -= nunits;
 8dc:	29 f9                	sub    %edi,%ecx
 8de:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8e1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8e4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8e7:	89 15 84 0d 00 00    	mov    %edx,0xd84
}
 8ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8f0:	83 c0 08             	add    $0x8,%eax
}
 8f3:	5b                   	pop    %ebx
 8f4:	5e                   	pop    %esi
 8f5:	5f                   	pop    %edi
 8f6:	5d                   	pop    %ebp
 8f7:	c3                   	ret    
 8f8:	90                   	nop
 8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 900:	c7 05 84 0d 00 00 88 	movl   $0xd88,0xd84
 907:	0d 00 00 
 90a:	c7 05 88 0d 00 00 88 	movl   $0xd88,0xd88
 911:	0d 00 00 
    base.s.size = 0;
 914:	b8 88 0d 00 00       	mov    $0xd88,%eax
 919:	c7 05 8c 0d 00 00 00 	movl   $0x0,0xd8c
 920:	00 00 00 
 923:	e9 44 ff ff ff       	jmp    86c <malloc+0x2c>
 928:	90                   	nop
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 930:	8b 08                	mov    (%eax),%ecx
 932:	89 0a                	mov    %ecx,(%edx)
 934:	eb b1                	jmp    8e7 <malloc+0xa7>
