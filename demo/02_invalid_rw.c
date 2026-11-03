// Demo 2: valid indexes are 0 .. n-1, so the last valid pointer is a + n - 1.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n = 3;
    int *a = (int *)malloc(n * sizeof(int));

    for (int *p = a; p = a + n; p++) {   // FIX: < instead of <=
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
