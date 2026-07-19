// compute vector sum C_h = A_h + B_h
#include <malloc.h>
#include <stdio.h>

void vecAdd(
    float* A_h,
    float* B_h,
    float* C_h,
    int n
){
    for(int i=0; i<n; ++i){
        C_h[i] = A_h[i] + B_h[i];
    }
}

int main(){
    int n = 100000000;

    float* A_h = (float*)calloc(n, sizeof(float));
    float* B_h = (float*)calloc(n, sizeof(float));
    float* C_h = (float*)calloc(n, sizeof(float));

    for(int i=0; i<n; ++i){
        A_h[i] = (i+1) * 1.0;
        B_h[i] = A_h[i];
    }

    vecAdd(A_h, B_h, C_h, n);

    // for(int i=0; i<n; ++i){
    //     printf("%f ", C_h[i]);
    // }
    // printf("\n");

    free(A_h);
    free(B_h);
    free(C_h);
}
