#include "textflag.h"

TEXT ·Dot(SB), NOSPLIT, $0
	MOVQ x+0(FP), R8
	MOVQ x_len+8(FP), DI // n = len(x)
	MOVQ y+24(FP), R9

	VXORPD Y8, Y8, Y8 // sum = 0
	VXORPD Y9, Y9, Y9
	VXORPD Y10, Y10, Y10
	VXORPD Y11, Y11, Y11

	MOVQ $0, SI   // i = 0

loop_uni:
	// sum += x[i] * y[i] unrolled 8x.
	VMOVUPD 0(R8)(SI*8), Y0 // Y0 = x[i:i+4]
	VMOVUPD 0(R9)(SI*8), Y1 // Y1 = y[i:i+4]
	VMOVUPD 32(R8)(SI*8), Y2 // Y2 = x[i+4:i+8]
	VMOVUPD 32(R9)(SI*8), Y3 // Y3 = x[i+4:i+8]
	VMOVUPD 64(R8)(SI*8), Y4 // Y4 = x[i+8:i+12]
	VMOVUPD 64(R9)(SI*8), Y5 // Y5 = y[i+8:i+12]
	VMOVUPD 96(R8)(SI*8), Y6 // Y6 = x[i+12:i+16]
	VMOVUPD 96(R9)(SI*8), Y7 // Y7 = x[i+12:i+16]
	VFMADD231PD Y0, Y1, Y8 // Y8 = Y0 * Y1 + Y8
	VFMADD231PD Y2, Y3, Y9
	VFMADD231PD Y4, Y5, Y10
	VFMADD231PD Y6, Y7, Y11
	ADDQ $16, SI   // i += 16
	CMPQ DI, SI
	JG  loop_uni // if len(x) > i goto loop_uni

end_uni:
	// Add the four sums together.
	VADDPD    Y8, Y9, Y8
	VADDPD    Y8, Y10, Y8
	VADDPD    Y8, Y11, Y8
	VMOVAPD Y8, Y0
	VPERM2F128 $1, Y0, Y0, Y8
	VADDPD Y0, Y8, Y0
	VHADDPD Y0, Y0, Y0
	VMOVSD X0, sum+48(FP) // Return final sum.
	RET
