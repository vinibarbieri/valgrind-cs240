// Demo 3 (fixed): every element is written before it is read.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n = 5;
    int *grades = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n-1; i++) {        // FIX: fill all n elements (or use calloc)
        *(grades + i) = 90;
    }

    int total = 0;
    for (int i = 0; i < n; i++) {
        total += *(grades + i);             // garbage is copied into total here: no error yet
    }

    if (total / n >= 90) {                  // garbage is USED here: Valgrind reports this line (18)
        printf("Class average: A\n");
    } else {
        printf("Class average: not an A\n");
    }

    free(grades);
    return 0;
}
