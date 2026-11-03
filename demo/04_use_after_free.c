// Demo 4 (fixed): use the memory first, free it last.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *scores = (int *)malloc(3 * sizeof(int));
    *scores = 85;
    *(scores + 1) = 92;
    *(scores + 2) = 78;

    printf("First score: %d\n", *scores);

    free(scores);    // FIX: free after the last use
    scores = NULL;   // good habit: a later mistake becomes a clear crash, not garbage
    return 0;
}
