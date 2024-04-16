#include <stdio.h>
#include <string.h>

int _replaceChar(char* str, int len, char a, char b);

int main(){
  char string[]= "rainbows\n\0";
  printf("in '%s' we replace all a's with b's", string );
  int num_changed=0;
  printf("%d\n", num_changed);
  int len = strlen(string);
  char a= 'a';
  char b= 'b';
  num_changed=_replaceChar(string, len, a, b);

  printf("%d characters were altered, creating the following string:\n%s", num_changed, string);

  return 0;
}
