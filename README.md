# AKS Primality Test

An implementation of AKS Primality Test in Swift. 

## Build

```bash
git clone https://github.com/fh2ctm/aks.git
cd aks
swift build -c release
swift build --show-bin-path
```

## Usage

To test whether a number is prime: 
```bash
aks 13
```

To find primes in a range: 
```bash
aks 1 200
```

## Known Issues

Large numbers might cause arithmetic overflow since modular multiplication is not optimized. 

## References

The implementation follows the original paper: 

> Agrawal, M., Kayal, N., &amp; Saxena, N. (2004). Primes is in $P$. *Annals of Mathematics*, 160(2), 781–793. https://doi.org/10.4007/annals.2004.160.781 
