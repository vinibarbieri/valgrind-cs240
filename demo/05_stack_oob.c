// Demo 5 (fixed): the valid indexes of int a[5] are 0 .. 4.
#include <stdio.h>

int main(void) {
    int a[5];

    for (int i = 0; i < 5; i++) {    // FIX: < instead of <=
        *(a + i) = i * 10;
    }

    for (int i = 0; i < 5; i++) {
        printf("%d ", *(a + i));
    }
    printf("\n");
    return 0;
}
