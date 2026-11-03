// Demo 3 (uninitialised value): fills n grades with 90, sums them and prints whether the class average is an A.
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n = 5;
    int *grades = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n-1; i++) {        // FIX: fill all n elements
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
