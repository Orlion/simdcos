# simdcos
simdcos is a Go library that uses simd instructions to perform cosine similarity calculations. It contains dot and l2norm functions

simdcos 是一个使用 simd 指令执行余弦相似度计算的 Go 库。它包含 dot 和 l2norm 函数

simdcos目前使用了AVX2指令，因此需要您的CPU支持AVX2指令集

# Benchmark
分别使用`simdcos`和`gonum`对长度为512的向量进行计算
```
BenchmarkDot
BenchmarkDot-2        22867993                53.46 ns/op
BenchmarkGonumDot
BenchmarkGonumDot-2   8264486               144.4 ns/op

BenchmarkL2Norm
BenchmarkL2Norm-2          29381442                40.99 ns/op
BenchmarkGonumL2Norm
BenchmarkGonumL2Norm-2     1822386               659.4 ns/op
```