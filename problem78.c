#include <stdio.h>

#define GP_MAX 10000

int gp[GP_MAX];

int pentagonal(int n) { return (3*n-1)*n/2; }

int generalised_pentagonal(int n) {
    if (n & 0x01) {
        return pentagonal((n+1)/2);
    } else {
        return pentagonal(-n/2);
    }
}

void fill_gp() {
    int i;
    for (i = 0; i < GP_MAX; i++) {
        gp[i] = generalised_pentagonal(i);
    }
}

int main() {
    fill_gp();

    int pt[100000];
    pt[0] = 1;

    int n = 1;
    while (1) {
        int r = 0;
        int f = -1;
        
        int i = 1;
        while (1) {
            int k = n - gp[i];
            if (k < 0) { break; }

            if (i & 0x01) { f = -f; }
            if (f > 0) {
                r += pt[k];
                if (r >= 1000000) { r -= 1000000; }
            } else {
                r -= pt[k];
                if (r < 0) { r += 1000000; }
            }
        
            i += 1;
        }

        pt[n] = r;

        if (0 == r) {
            printf("%d\n", n);
            break;
        }

        n += 1;
    }
}
