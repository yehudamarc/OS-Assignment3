
_ass3Tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
		#endif
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

	#if (SELECTION==SCFIFO)
	scfifotest();	
  11:	e8 0a 00 00 00       	call   20 <scfifotest>
	#endif
	#if (SELECTION == AQ)
	aqtest();
	#endif

	exit();
  16:	e8 67 04 00 00       	call   482 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <scfifotest>:
	scfifotest(void){
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	53                   	push   %ebx
		for (i = 0; i < 12; ++i) {
  24:	31 db                	xor    %ebx,%ebx
	scfifotest(void){
  26:	83 ec 5c             	sub    $0x5c,%esp
		printf(1,"SCFIFO test... \n");
  29:	68 28 09 00 00       	push   $0x928
  2e:	6a 01                	push   $0x1
  30:	e8 9b 05 00 00       	call   5d0 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  38:	90                   	nop
  39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			arr[i] = sbrk(PGSIZE);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 00 10 00 00       	push   $0x1000
  48:	e8 bd 04 00 00       	call   50a <sbrk>
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
  4d:	50                   	push   %eax
  4e:	53                   	push   %ebx
  4f:	68 39 09 00 00       	push   $0x939
  54:	6a 01                	push   $0x1
			arr[i] = sbrk(PGSIZE);
  56:	89 44 9d bc          	mov    %eax,-0x44(%ebp,%ebx,4)
		for (i = 0; i < 12; ++i) {
  5a:	83 c3 01             	add    $0x1,%ebx
			printf(1, "arr[%d]=0x%x\n", i, arr[i]);
  5d:	e8 6e 05 00 00       	call   5d0 <printf>
		for (i = 0; i < 12; ++i) {
  62:	83 c4 20             	add    $0x20,%esp
  65:	83 fb 0c             	cmp    $0xc,%ebx
  68:	75 d6                	jne    40 <scfifotest+0x20>
		printf(1, "Called sbrk(PGSIZE) 12 times - all physical pages taken.\nPress Enter...\n");
  6a:	83 ec 08             	sub    $0x8,%esp
		gets(input, 10);
  6d:	8d 5d b2             	lea    -0x4e(%ebp),%ebx
		printf(1, "Called sbrk(PGSIZE) 12 times - all physical pages taken.\nPress Enter...\n");
  70:	68 88 09 00 00       	push   $0x988
  75:	6a 01                	push   $0x1
  77:	e8 54 05 00 00       	call   5d0 <printf>
		gets(input, 10);
  7c:	58                   	pop    %eax
  7d:	5a                   	pop    %edx
  7e:	6a 0a                	push   $0xa
  80:	53                   	push   %ebx
  81:	e8 ba 02 00 00       	call   340 <gets>
		arr[12] = sbrk(PGSIZE);
  86:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  8d:	e8 78 04 00 00       	call   50a <sbrk>
		printf(1, "arr[12]=0x%x\n", arr[12]);
  92:	83 c4 0c             	add    $0xc,%esp
		arr[12] = sbrk(PGSIZE);
  95:	89 45 ec             	mov    %eax,-0x14(%ebp)
		printf(1, "arr[12]=0x%x\n", arr[12]);
  98:	50                   	push   %eax
  99:	68 47 09 00 00       	push   $0x947
  9e:	6a 01                	push   $0x1
  a0:	e8 2b 05 00 00       	call   5d0 <printf>
		printf(1, "Called sbrk(PGSIZE) for the 13th time, no page fault should occur and one page in swap file.\nPress Enter...\n");
  a5:	59                   	pop    %ecx
  a6:	58                   	pop    %eax
  a7:	68 d4 09 00 00       	push   $0x9d4
  ac:	6a 01                	push   $0x1
  ae:	e8 1d 05 00 00       	call   5d0 <printf>
		gets(input, 10);
  b3:	58                   	pop    %eax
  b4:	5a                   	pop    %edx
  b5:	6a 0a                	push   $0xa
  b7:	53                   	push   %ebx
  b8:	e8 83 02 00 00       	call   340 <gets>
		arr[13] = sbrk(PGSIZE);
  bd:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  c4:	e8 41 04 00 00       	call   50a <sbrk>
		printf(1, "arr[13]=0x%x\n", arr[13]);
  c9:	83 c4 0c             	add    $0xc,%esp
		arr[13] = sbrk(PGSIZE);
  cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf(1, "arr[13]=0x%x\n", arr[13]);
  cf:	50                   	push   %eax
  d0:	68 55 09 00 00       	push   $0x955
  d5:	6a 01                	push   $0x1
  d7:	e8 f4 04 00 00       	call   5d0 <printf>
		printf(1, "Called sbrk(PGSIZE) for the 14th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
  dc:	59                   	pop    %ecx
  dd:	58                   	pop    %eax
  de:	68 44 0a 00 00       	push   $0xa44
  e3:	6a 01                	push   $0x1
  e5:	e8 e6 04 00 00       	call   5d0 <printf>
		gets(input, 10);
  ea:	58                   	pop    %eax
  eb:	5a                   	pop    %edx
  ec:	6a 0a                	push   $0xa
  ee:	53                   	push   %ebx
  ef:	e8 4c 02 00 00       	call   340 <gets>
		arr[14] = sbrk(PGSIZE);
  f4:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  fb:	e8 0a 04 00 00       	call   50a <sbrk>
		printf(1, "arr[14]=0x%x\n", arr[14]);
 100:	83 c4 0c             	add    $0xc,%esp
		arr[14] = sbrk(PGSIZE);
 103:	89 45 f4             	mov    %eax,-0xc(%ebp)
		printf(1, "arr[14]=0x%x\n", arr[14]);
 106:	50                   	push   %eax
 107:	68 63 09 00 00       	push   $0x963
 10c:	6a 01                	push   $0x1
 10e:	e8 bd 04 00 00       	call   5d0 <printf>
		printf(1, "Called sbrk(PGSIZE) for the 15th time, no page fault should occur and two pages in swap file.\nPress any key...\n");
 113:	59                   	pop    %ecx
 114:	58                   	pop    %eax
 115:	68 b4 0a 00 00       	push   $0xab4
 11a:	6a 01                	push   $0x1
 11c:	e8 af 04 00 00       	call   5d0 <printf>
		gets(input, 10);
 121:	58                   	pop    %eax
 122:	5a                   	pop    %edx
 123:	6a 0a                	push   $0xa
 125:	53                   	push   %ebx
 126:	e8 15 02 00 00       	call   340 <gets>
 12b:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 5; i++) {
 12e:	31 c9                	xor    %ecx,%ecx
 130:	8b 44 8d bc          	mov    -0x44(%ebp,%ecx,4),%eax
 134:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				arr[i][j] = 'k';
 140:	c6 00 6b             	movb   $0x6b,(%eax)
 143:	83 c0 01             	add    $0x1,%eax
			for (j = 0; j < PGSIZE; j++)
 146:	39 c2                	cmp    %eax,%edx
 148:	75 f6                	jne    140 <scfifotest+0x120>
		for (i = 0; i < 5; i++) {
 14a:	83 c1 01             	add    $0x1,%ecx
 14d:	83 f9 05             	cmp    $0x5,%ecx
 150:	75 de                	jne    130 <scfifotest+0x110>
		printf(1, "5 page faults should have occurred.\nPress Enter...\n");
 152:	83 ec 08             	sub    $0x8,%esp
 155:	68 24 0b 00 00       	push   $0xb24
 15a:	6a 01                	push   $0x1
 15c:	e8 6f 04 00 00       	call   5d0 <printf>
		gets(input, 10);
 161:	59                   	pop    %ecx
 162:	58                   	pop    %eax
 163:	6a 0a                	push   $0xa
 165:	53                   	push   %ebx
 166:	e8 d5 01 00 00       	call   340 <gets>
		if (fork() == 0) {
 16b:	e8 0a 03 00 00       	call   47a <fork>
 170:	83 c4 10             	add    $0x10,%esp
 173:	85 c0                	test   %eax,%eax
 175:	74 32                	je     1a9 <scfifotest+0x189>
			wait();
 177:	e8 0e 03 00 00       	call   48a <wait>
			sbrk(-15 * PGSIZE);
 17c:	83 ec 0c             	sub    $0xc,%esp
 17f:	68 00 10 ff ff       	push   $0xffff1000
 184:	e8 81 03 00 00       	call   50a <sbrk>
			printf(1, "Press Enter to exit the father code.\n");
 189:	58                   	pop    %eax
 18a:	5a                   	pop    %edx
 18b:	68 e8 0b 00 00       	push   $0xbe8
 190:	6a 01                	push   $0x1
 192:	e8 39 04 00 00       	call   5d0 <printf>
			gets(input, 10);
 197:	59                   	pop    %ecx
 198:	58                   	pop    %eax
 199:	6a 0a                	push   $0xa
 19b:	53                   	push   %ebx
 19c:	e8 9f 01 00 00       	call   340 <gets>
	}
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
			printf(1, "Child code running.\n");
 1a9:	50                   	push   %eax
 1aa:	50                   	push   %eax
 1ab:	68 71 09 00 00       	push   $0x971
 1b0:	6a 01                	push   $0x1
 1b2:	e8 19 04 00 00       	call   5d0 <printf>
			printf(1, "View statistics for pid %d, then press any key...\n", getpid());
 1b7:	e8 46 03 00 00       	call   502 <getpid>
 1bc:	83 c4 0c             	add    $0xc,%esp
 1bf:	50                   	push   %eax
 1c0:	68 58 0b 00 00       	push   $0xb58
 1c5:	6a 01                	push   $0x1
 1c7:	e8 04 04 00 00       	call   5d0 <printf>
			gets(input, 10);
 1cc:	58                   	pop    %eax
 1cd:	5a                   	pop    %edx
 1ce:	6a 0a                	push   $0xa
 1d0:	53                   	push   %ebx
 1d1:	e8 6a 01 00 00       	call   340 <gets>
			arr[5][0] = 'k';
 1d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1d9:	c6 00 6b             	movb   $0x6b,(%eax)
			printf(1, "A Page fault should have occurred in child proccess.\nPress Enter to exit the child code.\n");
 1dc:	59                   	pop    %ecx
 1dd:	58                   	pop    %eax
 1de:	68 8c 0b 00 00       	push   $0xb8c
 1e3:	6a 01                	push   $0x1
 1e5:	e8 e6 03 00 00       	call   5d0 <printf>
			gets(input, 10);
 1ea:	58                   	pop    %eax
 1eb:	5a                   	pop    %edx
 1ec:	6a 0a                	push   $0xa
 1ee:	53                   	push   %ebx
 1ef:	e8 4c 01 00 00       	call   340 <gets>
			exit();
 1f4:	e8 89 02 00 00       	call   482 <exit>
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000200 <nfuatest>:
	nfuatest(void){
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
	}
 203:	5d                   	pop    %ebp
 204:	c3                   	ret    
 205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <lapatest>:
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <aqtest>:
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	5d                   	pop    %ebp
 224:	c3                   	ret    
 225:	66 90                	xchg   %ax,%ax
 227:	66 90                	xchg   %ax,%ax
 229:	66 90                	xchg   %ax,%ax
 22b:	66 90                	xchg   %ax,%ax
 22d:	66 90                	xchg   %ax,%ax
 22f:	90                   	nop

00000230 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 23a:	89 c2                	mov    %eax,%edx
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 240:	83 c1 01             	add    $0x1,%ecx
 243:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 247:	83 c2 01             	add    $0x1,%edx
 24a:	84 db                	test   %bl,%bl
 24c:	88 5a ff             	mov    %bl,-0x1(%edx)
 24f:	75 ef                	jne    240 <strcpy+0x10>
    ;
  return os;
}
 251:	5b                   	pop    %ebx
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    
 254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 25a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
 267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 26a:	0f b6 02             	movzbl (%edx),%eax
 26d:	0f b6 19             	movzbl (%ecx),%ebx
 270:	84 c0                	test   %al,%al
 272:	75 1c                	jne    290 <strcmp+0x30>
 274:	eb 2a                	jmp    2a0 <strcmp+0x40>
 276:	8d 76 00             	lea    0x0(%esi),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 280:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 283:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 286:	83 c1 01             	add    $0x1,%ecx
 289:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 28c:	84 c0                	test   %al,%al
 28e:	74 10                	je     2a0 <strcmp+0x40>
 290:	38 d8                	cmp    %bl,%al
 292:	74 ec                	je     280 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 294:	29 d8                	sub    %ebx,%eax
}
 296:	5b                   	pop    %ebx
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2a2:	29 d8                	sub    %ebx,%eax
}
 2a4:	5b                   	pop    %ebx
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
 2a7:	89 f6                	mov    %esi,%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <strlen>:

uint
strlen(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2b6:	80 39 00             	cmpb   $0x0,(%ecx)
 2b9:	74 15                	je     2d0 <strlen+0x20>
 2bb:	31 d2                	xor    %edx,%edx
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
 2c0:	83 c2 01             	add    $0x1,%edx
 2c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2c7:	89 d0                	mov    %edx,%eax
 2c9:	75 f5                	jne    2c0 <strlen+0x10>
    ;
  return n;
}
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2d0:	31 c0                	xor    %eax,%eax
}
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    
 2d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 d7                	mov    %edx,%edi
 2ef:	fc                   	cld    
 2f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2f2:	89 d0                	mov    %edx,%eax
 2f4:	5f                   	pop    %edi
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    
 2f7:	89 f6                	mov    %esi,%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 30a:	0f b6 10             	movzbl (%eax),%edx
 30d:	84 d2                	test   %dl,%dl
 30f:	74 1d                	je     32e <strchr+0x2e>
    if(*s == c)
 311:	38 d3                	cmp    %dl,%bl
 313:	89 d9                	mov    %ebx,%ecx
 315:	75 0d                	jne    324 <strchr+0x24>
 317:	eb 17                	jmp    330 <strchr+0x30>
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 320:	38 ca                	cmp    %cl,%dl
 322:	74 0c                	je     330 <strchr+0x30>
  for(; *s; s++)
 324:	83 c0 01             	add    $0x1,%eax
 327:	0f b6 10             	movzbl (%eax),%edx
 32a:	84 d2                	test   %dl,%dl
 32c:	75 f2                	jne    320 <strchr+0x20>
      return (char*)s;
  return 0;
 32e:	31 c0                	xor    %eax,%eax
}
 330:	5b                   	pop    %ebx
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	31 f6                	xor    %esi,%esi
 348:	89 f3                	mov    %esi,%ebx
{
 34a:	83 ec 1c             	sub    $0x1c,%esp
 34d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 350:	eb 2f                	jmp    381 <gets+0x41>
 352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 358:	8d 45 e7             	lea    -0x19(%ebp),%eax
 35b:	83 ec 04             	sub    $0x4,%esp
 35e:	6a 01                	push   $0x1
 360:	50                   	push   %eax
 361:	6a 00                	push   $0x0
 363:	e8 32 01 00 00       	call   49a <read>
    if(cc < 1)
 368:	83 c4 10             	add    $0x10,%esp
 36b:	85 c0                	test   %eax,%eax
 36d:	7e 1c                	jle    38b <gets+0x4b>
      break;
    buf[i++] = c;
 36f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 373:	83 c7 01             	add    $0x1,%edi
 376:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 379:	3c 0a                	cmp    $0xa,%al
 37b:	74 23                	je     3a0 <gets+0x60>
 37d:	3c 0d                	cmp    $0xd,%al
 37f:	74 1f                	je     3a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 381:	83 c3 01             	add    $0x1,%ebx
 384:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 387:	89 fe                	mov    %edi,%esi
 389:	7c cd                	jl     358 <gets+0x18>
 38b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 390:	c6 03 00             	movb   $0x0,(%ebx)
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	90                   	nop
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a0:	8b 75 08             	mov    0x8(%ebp),%esi
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	01 de                	add    %ebx,%esi
 3a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 3ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b0:	5b                   	pop    %ebx
 3b1:	5e                   	pop    %esi
 3b2:	5f                   	pop    %edi
 3b3:	5d                   	pop    %ebp
 3b4:	c3                   	ret    
 3b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c5:	83 ec 08             	sub    $0x8,%esp
 3c8:	6a 00                	push   $0x0
 3ca:	ff 75 08             	pushl  0x8(%ebp)
 3cd:	e8 f0 00 00 00       	call   4c2 <open>
  if(fd < 0)
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 27                	js     400 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3d9:	83 ec 08             	sub    $0x8,%esp
 3dc:	ff 75 0c             	pushl  0xc(%ebp)
 3df:	89 c3                	mov    %eax,%ebx
 3e1:	50                   	push   %eax
 3e2:	e8 f3 00 00 00       	call   4da <fstat>
  close(fd);
 3e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ea:	89 c6                	mov    %eax,%esi
  close(fd);
 3ec:	e8 b9 00 00 00       	call   4aa <close>
  return r;
 3f1:	83 c4 10             	add    $0x10,%esp
}
 3f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f7:	89 f0                	mov    %esi,%eax
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 400:	be ff ff ff ff       	mov    $0xffffffff,%esi
 405:	eb ed                	jmp    3f4 <stat+0x34>
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <atoi>:

int
atoi(const char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 417:	0f be 11             	movsbl (%ecx),%edx
 41a:	8d 42 d0             	lea    -0x30(%edx),%eax
 41d:	3c 09                	cmp    $0x9,%al
  n = 0;
 41f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 424:	77 1f                	ja     445 <atoi+0x35>
 426:	8d 76 00             	lea    0x0(%esi),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 430:	8d 04 80             	lea    (%eax,%eax,4),%eax
 433:	83 c1 01             	add    $0x1,%ecx
 436:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 43a:	0f be 11             	movsbl (%ecx),%edx
 43d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 440:	80 fb 09             	cmp    $0x9,%bl
 443:	76 eb                	jbe    430 <atoi+0x20>
  return n;
}
 445:	5b                   	pop    %ebx
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
 448:	90                   	nop
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
 455:	8b 5d 10             	mov    0x10(%ebp),%ebx
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45e:	85 db                	test   %ebx,%ebx
 460:	7e 14                	jle    476 <memmove+0x26>
 462:	31 d2                	xor    %edx,%edx
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 468:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 46c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 46f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 472:	39 d3                	cmp    %edx,%ebx
 474:	75 f2                	jne    468 <memmove+0x18>
  return vdst;
}
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47a:	b8 01 00 00 00       	mov    $0x1,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <exit>:
SYSCALL(exit)
 482:	b8 02 00 00 00       	mov    $0x2,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <wait>:
SYSCALL(wait)
 48a:	b8 03 00 00 00       	mov    $0x3,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <pipe>:
SYSCALL(pipe)
 492:	b8 04 00 00 00       	mov    $0x4,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <read>:
SYSCALL(read)
 49a:	b8 05 00 00 00       	mov    $0x5,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <write>:
SYSCALL(write)
 4a2:	b8 10 00 00 00       	mov    $0x10,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <close>:
SYSCALL(close)
 4aa:	b8 15 00 00 00       	mov    $0x15,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <kill>:
SYSCALL(kill)
 4b2:	b8 06 00 00 00       	mov    $0x6,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <exec>:
SYSCALL(exec)
 4ba:	b8 07 00 00 00       	mov    $0x7,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <open>:
SYSCALL(open)
 4c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mknod>:
SYSCALL(mknod)
 4ca:	b8 11 00 00 00       	mov    $0x11,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <unlink>:
SYSCALL(unlink)
 4d2:	b8 12 00 00 00       	mov    $0x12,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <fstat>:
SYSCALL(fstat)
 4da:	b8 08 00 00 00       	mov    $0x8,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <link>:
SYSCALL(link)
 4e2:	b8 13 00 00 00       	mov    $0x13,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mkdir>:
SYSCALL(mkdir)
 4ea:	b8 14 00 00 00       	mov    $0x14,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <chdir>:
SYSCALL(chdir)
 4f2:	b8 09 00 00 00       	mov    $0x9,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <dup>:
SYSCALL(dup)
 4fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <getpid>:
SYSCALL(getpid)
 502:	b8 0b 00 00 00       	mov    $0xb,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <sbrk>:
SYSCALL(sbrk)
 50a:	b8 0c 00 00 00       	mov    $0xc,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <sleep>:
SYSCALL(sleep)
 512:	b8 0d 00 00 00       	mov    $0xd,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <uptime>:
SYSCALL(uptime)
 51a:	b8 0e 00 00 00       	mov    $0xe,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <get_pages_info>:
SYSCALL(get_pages_info)
 522:	b8 16 00 00 00       	mov    $0x16,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    
 52a:	66 90                	xchg   %ax,%ax
 52c:	66 90                	xchg   %ax,%ax
 52e:	66 90                	xchg   %ax,%ax

00000530 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 539:	85 d2                	test   %edx,%edx
{
 53b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 53e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 540:	79 76                	jns    5b8 <printint+0x88>
 542:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 546:	74 70                	je     5b8 <printint+0x88>
    x = -xx;
 548:	f7 d8                	neg    %eax
    neg = 1;
 54a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 551:	31 f6                	xor    %esi,%esi
 553:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 556:	eb 0a                	jmp    562 <printint+0x32>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 560:	89 fe                	mov    %edi,%esi
 562:	31 d2                	xor    %edx,%edx
 564:	8d 7e 01             	lea    0x1(%esi),%edi
 567:	f7 f1                	div    %ecx
 569:	0f b6 92 18 0c 00 00 	movzbl 0xc18(%edx),%edx
  }while((x /= base) != 0);
 570:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 572:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 575:	75 e9                	jne    560 <printint+0x30>
  if(neg)
 577:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 57a:	85 c0                	test   %eax,%eax
 57c:	74 08                	je     586 <printint+0x56>
    buf[i++] = '-';
 57e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 583:	8d 7e 02             	lea    0x2(%esi),%edi
 586:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 58a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	83 ee 01             	sub    $0x1,%esi
 599:	6a 01                	push   $0x1
 59b:	53                   	push   %ebx
 59c:	57                   	push   %edi
 59d:	88 45 d7             	mov    %al,-0x29(%ebp)
 5a0:	e8 fd fe ff ff       	call   4a2 <write>

  while(--i >= 0)
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	39 de                	cmp    %ebx,%esi
 5aa:	75 e4                	jne    590 <printint+0x60>
    putc(fd, buf[i]);
}
 5ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5bf:	eb 90                	jmp    551 <printint+0x21>
 5c1:	eb 0d                	jmp    5d0 <printf>
 5c3:	90                   	nop
 5c4:	90                   	nop
 5c5:	90                   	nop
 5c6:	90                   	nop
 5c7:	90                   	nop
 5c8:	90                   	nop
 5c9:	90                   	nop
 5ca:	90                   	nop
 5cb:	90                   	nop
 5cc:	90                   	nop
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop

000005d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5dc:	0f b6 1e             	movzbl (%esi),%ebx
 5df:	84 db                	test   %bl,%bl
 5e1:	0f 84 b3 00 00 00    	je     69a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5e7:	8d 45 10             	lea    0x10(%ebp),%eax
 5ea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5ed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5f2:	eb 2f                	jmp    623 <printf+0x53>
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 a7 00 00 00    	je     6a8 <printf+0xd8>
  write(fd, &c, 1);
 601:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 604:	83 ec 04             	sub    $0x4,%esp
 607:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 60a:	6a 01                	push   $0x1
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 8d fe ff ff       	call   4a2 <write>
 615:	83 c4 10             	add    $0x10,%esp
 618:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 61b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	74 77                	je     69a <printf+0xca>
    if(state == 0){
 623:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 625:	0f be cb             	movsbl %bl,%ecx
 628:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 62b:	74 cb                	je     5f8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62d:	83 ff 25             	cmp    $0x25,%edi
 630:	75 e6                	jne    618 <printf+0x48>
      if(c == 'd'){
 632:	83 f8 64             	cmp    $0x64,%eax
 635:	0f 84 05 01 00 00    	je     740 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 63b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 641:	83 f9 70             	cmp    $0x70,%ecx
 644:	74 72                	je     6b8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 646:	83 f8 73             	cmp    $0x73,%eax
 649:	0f 84 99 00 00 00    	je     6e8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64f:	83 f8 63             	cmp    $0x63,%eax
 652:	0f 84 08 01 00 00    	je     760 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	0f 84 ef 00 00 00    	je     750 <printf+0x180>
  write(fd, &c, 1);
 661:	8d 45 e7             	lea    -0x19(%ebp),%eax
 664:	83 ec 04             	sub    $0x4,%esp
 667:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 66b:	6a 01                	push   $0x1
 66d:	50                   	push   %eax
 66e:	ff 75 08             	pushl  0x8(%ebp)
 671:	e8 2c fe ff ff       	call   4a2 <write>
 676:	83 c4 0c             	add    $0xc,%esp
 679:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 67c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 67f:	6a 01                	push   $0x1
 681:	50                   	push   %eax
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 68a:	e8 13 fe ff ff       	call   4a2 <write>
  for(i = 0; fmt[i]; i++){
 68f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 693:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 696:	84 db                	test   %bl,%bl
 698:	75 89                	jne    623 <printf+0x53>
    }
  }
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6a8:	bf 25 00 00 00       	mov    $0x25,%edi
 6ad:	e9 66 ff ff ff       	jmp    618 <printf+0x48>
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	b9 10 00 00 00       	mov    $0x10,%ecx
 6c0:	6a 00                	push   $0x0
 6c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	8b 17                	mov    (%edi),%edx
 6ca:	e8 61 fe ff ff       	call   530 <printint>
        ap++;
 6cf:	89 f8                	mov    %edi,%eax
 6d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d4:	31 ff                	xor    %edi,%edi
        ap++;
 6d6:	83 c0 04             	add    $0x4,%eax
 6d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6dc:	e9 37 ff ff ff       	jmp    618 <printf+0x48>
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6eb:	8b 08                	mov    (%eax),%ecx
        ap++;
 6ed:	83 c0 04             	add    $0x4,%eax
 6f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6f3:	85 c9                	test   %ecx,%ecx
 6f5:	0f 84 8e 00 00 00    	je     789 <printf+0x1b9>
        while(*s != 0){
 6fb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6fe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 700:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 702:	84 c0                	test   %al,%al
 704:	0f 84 0e ff ff ff    	je     618 <printf+0x48>
 70a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 70d:	89 de                	mov    %ebx,%esi
 70f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 712:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 715:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 718:	83 ec 04             	sub    $0x4,%esp
          s++;
 71b:	83 c6 01             	add    $0x1,%esi
 71e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 721:	6a 01                	push   $0x1
 723:	57                   	push   %edi
 724:	53                   	push   %ebx
 725:	e8 78 fd ff ff       	call   4a2 <write>
        while(*s != 0){
 72a:	0f b6 06             	movzbl (%esi),%eax
 72d:	83 c4 10             	add    $0x10,%esp
 730:	84 c0                	test   %al,%al
 732:	75 e4                	jne    718 <printf+0x148>
 734:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 737:	31 ff                	xor    %edi,%edi
 739:	e9 da fe ff ff       	jmp    618 <printf+0x48>
 73e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 740:	83 ec 0c             	sub    $0xc,%esp
 743:	b9 0a 00 00 00       	mov    $0xa,%ecx
 748:	6a 01                	push   $0x1
 74a:	e9 73 ff ff ff       	jmp    6c2 <printf+0xf2>
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 756:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 759:	6a 01                	push   $0x1
 75b:	e9 21 ff ff ff       	jmp    681 <printf+0xb1>
        putc(fd, *ap);
 760:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 766:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 768:	6a 01                	push   $0x1
        ap++;
 76a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 76d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 770:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 26 fd ff ff       	call   4a2 <write>
        ap++;
 77c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 77f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 782:	31 ff                	xor    %edi,%edi
 784:	e9 8f fe ff ff       	jmp    618 <printf+0x48>
          s = "(null)";
 789:	bb 10 0c 00 00       	mov    $0xc10,%ebx
        while(*s != 0){
 78e:	b8 28 00 00 00       	mov    $0x28,%eax
 793:	e9 72 ff ff ff       	jmp    70a <printf+0x13a>
 798:	66 90                	xchg   %ax,%ax
 79a:	66 90                	xchg   %ax,%ax
 79c:	66 90                	xchg   %ax,%ax
 79e:	66 90                	xchg   %ax,%ax

000007a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	a1 44 0f 00 00       	mov    0xf44,%eax
{
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	57                   	push   %edi
 7a9:	56                   	push   %esi
 7aa:	53                   	push   %ebx
 7ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	39 c8                	cmp    %ecx,%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	73 32                	jae    7f0 <free+0x50>
 7be:	39 d1                	cmp    %edx,%ecx
 7c0:	72 04                	jb     7c6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	39 d0                	cmp    %edx,%eax
 7c4:	72 32                	jb     7f8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7cc:	39 fa                	cmp    %edi,%edx
 7ce:	74 30                	je     800 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d3:	8b 50 04             	mov    0x4(%eax),%edx
 7d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7d9:	39 f1                	cmp    %esi,%ecx
 7db:	74 3a                	je     817 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7dd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7df:	a3 44 0f 00 00       	mov    %eax,0xf44
}
 7e4:	5b                   	pop    %ebx
 7e5:	5e                   	pop    %esi
 7e6:	5f                   	pop    %edi
 7e7:	5d                   	pop    %ebp
 7e8:	c3                   	ret    
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	39 d0                	cmp    %edx,%eax
 7f2:	72 04                	jb     7f8 <free+0x58>
 7f4:	39 d1                	cmp    %edx,%ecx
 7f6:	72 ce                	jb     7c6 <free+0x26>
{
 7f8:	89 d0                	mov    %edx,%eax
 7fa:	eb bc                	jmp    7b8 <free+0x18>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 800:	03 72 04             	add    0x4(%edx),%esi
 803:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 12                	mov    (%edx),%edx
 80a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 80d:	8b 50 04             	mov    0x4(%eax),%edx
 810:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 813:	39 f1                	cmp    %esi,%ecx
 815:	75 c6                	jne    7dd <free+0x3d>
    p->s.size += bp->s.size;
 817:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 81a:	a3 44 0f 00 00       	mov    %eax,0xf44
    p->s.size += bp->s.size;
 81f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 822:	8b 53 f8             	mov    -0x8(%ebx),%edx
 825:	89 10                	mov    %edx,(%eax)
}
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 839:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 83c:	8b 15 44 0f 00 00    	mov    0xf44,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	8d 78 07             	lea    0x7(%eax),%edi
 845:	c1 ef 03             	shr    $0x3,%edi
 848:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 84b:	85 d2                	test   %edx,%edx
 84d:	0f 84 9d 00 00 00    	je     8f0 <malloc+0xc0>
 853:	8b 02                	mov    (%edx),%eax
 855:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 858:	39 cf                	cmp    %ecx,%edi
 85a:	76 6c                	jbe    8c8 <malloc+0x98>
 85c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 862:	bb 00 10 00 00       	mov    $0x1000,%ebx
 867:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 86a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 871:	eb 0e                	jmp    881 <malloc+0x51>
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 87a:	8b 48 04             	mov    0x4(%eax),%ecx
 87d:	39 f9                	cmp    %edi,%ecx
 87f:	73 47                	jae    8c8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 881:	39 05 44 0f 00 00    	cmp    %eax,0xf44
 887:	89 c2                	mov    %eax,%edx
 889:	75 ed                	jne    878 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	56                   	push   %esi
 88f:	e8 76 fc ff ff       	call   50a <sbrk>
  if(p == (char*)-1)
 894:	83 c4 10             	add    $0x10,%esp
 897:	83 f8 ff             	cmp    $0xffffffff,%eax
 89a:	74 1c                	je     8b8 <malloc+0x88>
  hp->s.size = nu;
 89c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	83 c0 08             	add    $0x8,%eax
 8a5:	50                   	push   %eax
 8a6:	e8 f5 fe ff ff       	call   7a0 <free>
  return freep;
 8ab:	8b 15 44 0f 00 00    	mov    0xf44,%edx
      if((p = morecore(nunits)) == 0)
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	85 d2                	test   %edx,%edx
 8b6:	75 c0                	jne    878 <malloc+0x48>
        return 0;
  }
}
 8b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8bb:	31 c0                	xor    %eax,%eax
}
 8bd:	5b                   	pop    %ebx
 8be:	5e                   	pop    %esi
 8bf:	5f                   	pop    %edi
 8c0:	5d                   	pop    %ebp
 8c1:	c3                   	ret    
 8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	74 54                	je     920 <malloc+0xf0>
        p->s.size -= nunits;
 8cc:	29 f9                	sub    %edi,%ecx
 8ce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8d4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8d7:	89 15 44 0f 00 00    	mov    %edx,0xf44
}
 8dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8e0:	83 c0 08             	add    $0x8,%eax
}
 8e3:	5b                   	pop    %ebx
 8e4:	5e                   	pop    %esi
 8e5:	5f                   	pop    %edi
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 44 0f 00 00 48 	movl   $0xf48,0xf44
 8f7:	0f 00 00 
 8fa:	c7 05 48 0f 00 00 48 	movl   $0xf48,0xf48
 901:	0f 00 00 
    base.s.size = 0;
 904:	b8 48 0f 00 00       	mov    $0xf48,%eax
 909:	c7 05 4c 0f 00 00 00 	movl   $0x0,0xf4c
 910:	00 00 00 
 913:	e9 44 ff ff ff       	jmp    85c <malloc+0x2c>
 918:	90                   	nop
 919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 920:	8b 08                	mov    (%eax),%ecx
 922:	89 0a                	mov    %ecx,(%edx)
 924:	eb b1                	jmp    8d7 <malloc+0xa7>
