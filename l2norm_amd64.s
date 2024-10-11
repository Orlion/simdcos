#include "textflag.h"

TEXT ·L2Norm(SB), NOSPLIT, $0
	MOVQ x_len+8(FP), DI // DI = len(x)
	MOVQ x_base+0(FP), R8

	VXORPD Y8, Y8, Y8 // Y8 = 0
	VXORPD Y9, Y9, Y9
	VXORPD Y10, Y10, Y10
	VXORPD Y11, Y11, Y11
	VXORPD Y12, Y12, Y12
	VXORPD Y13, Y13, Y13
	VXORPD Y14, Y14, Y14
	VXORPD Y15, Y15, Y15
	MOVQ $0, SI   // i = 0

loop:
	VMOVUPD 0(R8)(SI*8), Y0 // Y0 = x[i:i+4]
	VMOVUPD 32(R8)(SI*8), Y1 // Y1 = y[i+4:i+8]
	VMOVUPD 64(R8)(SI*8), Y2 // Y2 = x[i+8:i+12]
	VMOVUPD 96(R8)(SI*8), Y3 // Y3 = x[i+12:i+16]
	VMOVUPD 128(R8)(SI*8), Y4 // Y4 = x[i+16:i+20]
	VMOVUPD 160(R8)(SI*8), Y5 // Y5 = y[i+20:i+24]
	VMOVUPD 192(R8)(SI*8), Y6 // Y6 = x[i+24:i+28]
	VMOVUPD 224(R8)(SI*8), Y7 // Y7 = x[i+28:i+32]
	VFMADD231PD Y0, Y0, Y8 // Y8 = Y0 * Y0 + Y8
	VFMADD231PD Y1, Y1, Y9
	VFMADD231PD Y2, Y2, Y10
	VFMADD231PD Y3, Y3, Y11
	VFMADD231PD Y4, Y4, Y12
	VFMADD231PD Y5, Y5, Y13
	VFMADD231PD Y6, Y6, Y14
	VFMADD231PD Y7, Y7, Y15

	ADDQ $32, SI // i += 32
	CMPQ DI, SI
	JG  loop // if len(x) > i goto loop

end:  // Calculate return value
	VADDPD Y8, Y9, Y8 // Y8 += Y9
	VADDPD Y8, Y10, Y8
	VADDPD Y8, Y11, Y8
	VADDPD Y8, Y12, Y8
	VADDPD Y8, Y13, Y8
	VADDPD Y8, Y14, Y8
	VADDPD Y8, Y15, Y8
	VMOVAPD Y8, Y0
	VPERM2F128 $1, Y0, Y0, Y8
	VADDPD Y0, Y8, Y0
	VHADDPD Y0, Y0, Y0
	VSQRTPD Y0, Y0
	MOVQ    X0, norm+24(FP)
	RET
