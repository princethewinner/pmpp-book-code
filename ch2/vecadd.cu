#include <cuda.h>
#include <stdio.h>
#include <math.h>

#define CUDA_CHECK(call)                                                  \
    do {                                                                  \
        cudaError_t err = (call);                                         \
        if (err != cudaSuccess) {                                         \
            fprintf(stderr, "CUDA error %s:%d: %s\n",                     \
                    __FILE__, __LINE__, cudaGetErrorString(err));         \
            exit(EXIT_FAILURE);                                           \
        }                                                                 \
    } while (0)


__global__ void vecAddKernal(
    float *A,
    float *B,
    float *C,
    int n
){
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    if(i < n){
        C[i] = A[i] + B[i];
    }
}


void vecAdd(
    float* A_h,
    float* B_h,
    float* C_h,
    int n
){

    // stub for calling the kernel.

    int size = n * sizeof(float);
    float *A_d, *B_d, *C_d;

    // How to define macro to chek for cuda allocation errors.??
    CUDA_CHECK(cudaMalloc((void **) &A_d, size));
    CUDA_CHECK(cudaMalloc((void **) &B_d, size));
    CUDA_CHECK(cudaMalloc((void **) &C_d, size));

    cudaMemcpy(A_d, A_h, size, cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B_h, size, cudaMemcpyHostToDevice);

    vecAddKernal<<<ceil((float)n/1024.0), 1024>>>(A_d, B_d, C_d, n);
    CUDA_CHECK(cudaGetLastError());        // catches launch-config errors
    CUDA_CHECK(cudaDeviceSynchronize());   // catches errors during execution

    cudaMemcpy(C_h, C_d, size, cudaMemcpyDeviceToHost);

    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);

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
