#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main()
{
	puts("welcome to moectf");
	puts("I put a shell on my program to prevent you from reversing it, you will never be able to reverse it hhhh~~");
  puts("Now tell me your flag:");
	//char flag[] = "moectf{0h_y0u_Kn0w_H0w_to_Rev3rse_UPX!!!}";
  char flag[42]={0};
  scanf("%s",flag);
  static char enc[]={0x0a,0x08,0x02,0x04,0x13,0x01,0x1c,0x57,0x0f,0x38,0x1e,0x57,0x12,0x38,0x2c,0x09,0x57,0x10,0x38,0x2f,0x57,0x10,0x38,0x13,0x08,0x38,0x35,0x02,0x11,0x54,0x15,0x14,0x02,0x38,0x32,0x37,0x3f,0x46,0x46,0x46,0x1a};
	for (int i = 0; i < strlen(flag); ++i)
	{
		flag[i] ^= 0x67;
		if(enc[i]==flag[i])
    {
      ;
    }
    else{
      printf("try again~~");
      exit(0);
    }
	}
  printf("you are so clever!");
}