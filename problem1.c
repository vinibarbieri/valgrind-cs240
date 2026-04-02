#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n;
    if (scanf("%d", &n) != 1) {
        return 1;
    }
    printf("Read from input: %d\n", n);

    /* Allocate 100 ints on the heap and never call free — intentional leak. */
    int *p = malloc(100 * sizeof(int));
    if (p == NULL) {
        return 1;
    }

    for (int i = 0; i < 100; i++) {
        p[i] = i;
    }

    printf("Sum of first 5 elements: %d\n",
           p[0] + p[1] + p[2] + p[3] + p[4]);

    /* Bug: missing free(p); — Valgrind should report ~400 bytes "definitely lost". */
    // free(p);

    return 0;
}
