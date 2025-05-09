#include <stdio.h>

// strlen(const char *str) {
//   const char *s;
//   for (s = str; *s; ++s);
//   return(s - str);
// }

char *readFile(char *path) {
  const FILE *file = fopen(path, "r");

  if(file == NULL) {
    printf("No file found!\n");
    return "";
  }

  const int N = 100;
  char buffer[N][N];
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      buffer[i][j] = 0;
    }
  }

  int i = 0;
  while (fgets(buffer[i], N, file)) i++;

  int k = 0;
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      if(buffer[i][j] != '\0') k++;

  char str[k];

  k = 0;
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      const char c = buffer[i][j];
      if(c == '\0') continue;
      str[k] = c;
      k++;
    }
  }

  fclose(file);

  return str;
}

int main (int argc, char **argv ) {
  if(argc < 2) {
    printf("No path given!\n");
    return 1;
  }

  printf("Path: %s\n", argv[1]);

  // const char *path = (char)argv[1];

  const char *f = readFile(argv[1]);
  int i = 0;

  printf("%s/nSize: %i", f, sizeof(f));

  return 0;
}