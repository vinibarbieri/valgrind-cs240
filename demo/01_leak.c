// Demo 1 (memory leak): make_squares mallocs an array of n squares (0 1 4 9 16), main prints it and must free it.
#include <stdio.h>
#include <stdlib.h>

int *make_squares(int n) {
    int *a = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        *(a + i) = i * i;
    }
    return a;
}

int main(void) {
    int *sq = make_squares(5);
    for (int i = 0; i < 5; i++) {
        printf("%d ", *(sq + i));
    }
    printf("\n");
    // free(sq);   // FIX: the caller owns the memory, so the caller frees it
    return 0;
}
