// Demo 2 (invalid read/write): fills an array of n ints with 1 using a pointer, then sums it. Valid: a .. a + n - 1.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n = 3;
    int *a = (int *)malloc(n * sizeof(int));

    for (int *p = a; p <= a + n; p++) {    // FIX: < instead of <=
        *p = 1;
    }

    int sum = 0;
    for (int i = 0; i <= n; i++) {        // FIX: < instead of <=
        sum += *(a + i);
    }
    printf("sum = %d\n", sum);

    free(a);
    return 0;
}
