package simdcos

// Calculates the dot product of two vectors.
// Note: len(a) must be equal to len(b), and len(a)/len(b) must be greater than 16 and an integer multiple of 16.
func Dot(a, b []float64) float64

// Calculates the L2 norm of a vector.
// Note: len(x) must be greater than 32, and len(x) must be an integer multiple of 32.
func L2Norm(x []float64) float64
