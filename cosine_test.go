package simdcos

import (
	"math"
	"math/rand"
	"testing"
	"time"
)

func TestDot(t *testing.T) {
	rand.Seed(time.Now().Unix())

	for i := 0; i < 100000; i++ {
		a := make([]float64, 512)
		b := make([]float64, 512)
		for i := range a {
			a[i] = rand.Float64()
			b[i] = rand.Float64()
		}
		dotAvx := Dot(a, b)
		dotGonum := goDot(a, b)
		if int(dotAvx*100000) != int(dotGonum*100000) {
			t.Fatalf("dotAvx: %v, dotGonum: %v", dotAvx, dotGonum)
		}
	}
}

func goDot(x, y []float64) (sum float64) {
	for i, v := range x {
		sum += y[i] * v
	}
	return sum
}

func BenchmarkDot(b *testing.B) {
	rand.Seed(100000)
	x := make([]float64, 512)
	y := make([]float64, 512)
	for i := range x {
		x[i] = rand.Float64()
		y[i] = rand.Float64()
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		Dot(x, y)
	}
}

func TestL2NormSimple(t *testing.T) {
	x := []float64{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
	norm := L2Norm(x)
	t.Log("L2Norm = ", norm)
	norm = goL2Norm(x)
	t.Log("goL2Norm = ", norm)
}

func goL2Norm(vector []float64) float64 {
	var sum float64
	for _, v := range vector {
		sum += v * v
	}
	return math.Sqrt(sum)
}

func TestL2Norm(t *testing.T) {
	// 随机生成10000个长度为512的float64数组
	rand.Seed(time.Now().Unix())

	for i := 0; i < 300000; i++ {
		a := make([]float64, 512)
		for i := range a {
			a[i] = rand.Float64()
		}
		normAvx := L2Norm(a)
		normGonum := goL2Norm(a)
		if int(normAvx*100000) != int(normGonum*100000) {
			t.Fatalf("dotAvx: %v, dotGonum: %v", normAvx, normGonum)
		}
	}
}

func BenchmarkL2Norm(b *testing.B) {
	rand.Seed(100000)
	x := make([]float64, 512)
	for i := range x {
		x[i] = rand.Float64()
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		L2Norm(x)
	}
}
