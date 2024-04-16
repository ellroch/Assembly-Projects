#include <stdio.h>
#include <string.h>

void _search(FILE* file, char* str, int str_len){
  char* line=NULL;       // ebp-4
  char c;           // ebp-8
  FILE* scout=file; // ebp-12
  int offset=0;     // ebp-16
  int lineNum=0;    // ebp-20
  char* flag=NULL;       // ebp-24
            // use as bool (o=false) to signal match_found

  do{
    if(!feof(file)){
    c=fgetc(scout);
    offset+=1;
      if(c==10 || feof(scout)){ // ascii for \n
        lineNum+=1;
        fgets(line, offset, file);
        flag= strstr(line, str);
        if (flag!=NULL){ //if match was found
          //call printLine(lineNum, line);
          file=scout;
        }
        else{// if no match was found
          file=scout;
        }
        offset=0; // bottom of if: c==\n'
      }
    }
    else{
      break;
    }
  }while(1);
  return;
}


int main(){
  FILE* file= fopen("filename.txt","r");
  char* str= "searchString";
  int str_len = strlen(str);

  _search(file, str, str_len);

  return 0;
}
