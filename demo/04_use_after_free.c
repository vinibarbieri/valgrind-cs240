// Demo 4 (use after free): stores 3 scores on the heap, prints the first one, then frees the array.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *scores = (int *)malloc(3 * sizeof(int));
    *scores = 85;
    *(scores + 1) = 92;
    *(scores + 2) = 78;

    printf("First score: %d\n", *scores);

    free(scores);  
    // printf("First score: %d\n", *scores);   // BUG: reads memory that was already freed

    return 0;
}