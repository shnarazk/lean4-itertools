# Lean4 Itertools

A Lean4 library that provides Rust-like iterator methods for working with collections efficiently for Rust programmers using Lean4. This library extends Lean4's standard iterator functionality with commonly-used operations inspired by Rust's iterator traits.

## Overview

Itertools adds five powerful iterator methods to Lean4:

- **`enumerate`** - Add indices to iterator elements
- **`sum`** - Calculate the sum of numeric iterators
- **`product`** - Calculate the product of numeric iterators
- **`toHashMap`** - Convert key-value pair iterators to HashMaps
- **`toHashSet`** - Convert iterators to HashSets

## Installation

Add this package to your Lean4 project using Lake:

```toml
[[require]]
name = "Itertools"
scope = "shnarazk"
```

Or clone and build manually:

```bash
git clone https://github.com/shnarazk/lean4-itertools
cd lean4-itertools
lake build
```

## Usage

Import the library in your Lean4 code:

```lean
import Itertools
```

### enumerate

Convert an iterator to an enumerated iterator that yields `(index, value)` pairs starting from index 0.

```lean
#eval [1, 4, 66].iter.enumerate.toArray
-- Output: [(0, 1), (1, 4), (2, 66)]

#eval #[1, 4, 66].iter.enumerate.toArray
-- Output: [(0, 1), (1, 4), (2, 66)]
```

### sum

Compute the sum of all elements in a numeric iterator. Returns 0 for empty iterators.

```lean
#eval [1, 4, 66].iter.sum
-- Output: 71

#eval [].iter.sum
-- Output: 0
```

### product

Compute the product of all elements in a numeric iterator. Returns 1 for empty iterators (multiplicative identity).

```lean
#eval [2, 3, 6].iter.product
-- Output: 36

#eval [].iter.product
-- Output: 1
```

### toHashMap

Convert an iterator of key-value pairs into a HashMap. If duplicate keys exist, the last value is retained.

```lean
#eval [(2, "aaa"), (3, "three"), (6, "six")].iter.toHashMap
-- Output: HashMap with entries: 2 → "aaa", 3 → "three", 6 → "six"
```

The function pre-allocates capacity based on the iterator's count for optimal performance.

### toHashSet

Convert an iterator into a HashSet containing all unique elements. Duplicate elements are automatically eliminated.

```lean
#eval [2, 3, 6].iter.toHashSet
-- Output: HashSet containing {2, 3, 6}

#eval [1, 2, 2, 3, 3, 3].iter.toHashSet
-- Output: HashSet containing {1, 2, 3}
```

The function pre-allocates capacity based on the iterator's count for optimal performance.

## API Reference

All methods extend `Std.Iterators.Iter` and can be chained together:

```lean
-- Chain multiple operations
#eval [1, 2, 3, 4, 5].iter
  .enumerate
  .toArray
-- Output: [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)]
```

### Method Signatures

```lean
def Std.Iterators.Iter.enumerate {α β : Type} [Iterator α Id β] [IteratorLoop α Id Id] [Finite α Id]
    (it : Iter (α := α) β) : Iter (α := Zip (Rxo.Iterator Nat) Id α β) (Nat × β)

def Std.Iterators.Iter.sum {α : Type} [Iterator α Id Nat] [IteratorLoop α Id Id]
    (it : Iter (α := α) Nat) : Nat

def Std.Iterators.Iter.product {α : Type} [Iterator α Id Nat] [IteratorLoop α Id Id]
    (it : Iter (α := α) Nat) : Nat

def Std.Iterators.Iter.toHashMap {α β γ : Type} [BEq β] [Hashable β] [Iterator α Id (β × γ)] [IteratorLoop α Id Id]
    (it : Iter (α := α) (β × γ)) : HashMap β γ

def Std.Iterators.Iter.toHashSet {α β : Type} [BEq β] [Hashable β] [Iterator α Id β] [IteratorLoop α Id Id]
    (it : Iter (α := α) β) : HashSet β
```

## Requirements

- Lean4 version: v4.27.0-rc1 or compatible
- Standard library with iterator support

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests on GitHub.

## License

This project is open source. Please check the repository for license details.

## Acknowledgments

Inspired by Rust's Iterator trait and its convenient iterator methods.
