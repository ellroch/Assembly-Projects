#include <stdio.h>

extern int _sumAndPrintList(int* list, int list_len);

void main (){
  int list[1000];
  int len=0;
  char term;
  //char* str="";

  printf("\nPlease start inputting integer values:\n");
  while(len<1000){
    if(scanf("%d%c", &list[len], &term) == 2 && term == '\n'){
      len++;
    }
    else{
      getchar();
      printf("To confirm end of list, enter another non-integer value.\nElse continue entering integers:  \n");
      if(scanf("%d%c", &list[len], &term) == 2 && term == '\n'){
        len++;
      }
      else{
        getchar();
        printf("\nEnd Confirmed. calculating the sum of the list.\n");
        break;
      }
    }
  }

  int sum=_sumAndPrintList( list, len);
  printf("the sum of the array is: %d\n\n[insert context appropriate nice/rude/funny message]\n\n", sum);

  return;
}
