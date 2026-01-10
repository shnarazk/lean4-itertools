module

public import Lean
public import Std.Data.Iterators.Combinators.Zip

@[expose] public section

open Std Std.Iterators Std.Iterators.Iter

universe w

/--
Convert an iterator to an enumerated iterator.

Returns a new iterator that yields pairs of `(index, value)` where `index` starts from 0
and increments for each element in the original iterator.

# Example
```lean
#eval [1, 4, 66].iter.enumerate.toArray  -- [(0, 1), (1, 4), (2, 66)]
#eval #[1, 4, 66].iter.enumerate.toArray -- [(0, 1), (1, 4), (2, 66)]
```
-/
@[inline]
def Std.Iterators.Iter.enumerate {α β : Type} [Iterator α Id β] [IteratorLoop α Id Id] [Finite α Id]
    (it : Iter (α := α) β) : Iter (α := Zip (Rxo.Iterator Nat) Id α β) (Nat × β) :=
  (0...it.count).iter.zip it

-- #eval [1, 4, 66].iter.enumerate.toArray
-- #eval #[1, 4, 66].iter.enumerate.toArray

/--
Compute the sum of all elements in an iterator.

Consumes the iterator and returns the sum of all natural number elements.
Returns 0 for an empty iterator.

# Example
```lean
#eval [1, 4, 66].iter.sum  -- 71
```
-/
@[inline]
def Std.Iterators.Iter.sum {α : Type} [Iterator α Id Nat] [IteratorLoop α Id Id]
    (it : Iter (α := α) Nat) : Nat :=
  it.fold (· + ·) 0

-- #eval [1, 4, 66].iter.sum

/--
Compute the product of all elements in an iterator.

Consumes the iterator and returns the product of all natural number elements.
Returns 1 for an empty iterator (multiplicative identity).

# Example
```lean
#eval [2, 3, 6].iter.product  -- 36
```
-/
@[inline]
def Std.Iterators.Iter.product {α : Type} [Iterator α Id Nat] [IteratorLoop α Id Id]
    (it : Iter (α := α) Nat) : Nat :=
  it.fold (· * ·) 1
-- #eval [2, 3, 6].iter.product

/--
Convert an iterator of key-value pairs into a HashMap.

Consumes an iterator of pairs `(key, value)` and constructs a HashMap from them.
If duplicate keys exist, the last value for each key is retained.

The function pre-allocates capacity based on the iterator's count for efficiency.

# Example
```lean
#eval [(2, "aaa"), (3, "three"), (6, "six")].iter.toHashMap
  -- HashMap with entries: 2 → "aaa", 3 → "three", 6 → "six"
```
-/
@[inline]
def Std.Iterators.Iter.toHashMap {α β γ : Type} [BEq β] [Hashable β] [Iterator α Id (β × γ)] [IteratorLoop α Id Id]
    (it : Iter (α := α) (β × γ)) : HashMap β γ :=
  it.fold (fun acc pair ↦ acc.insert pair.fst pair.snd) (HashMap.emptyWithCapacity it.count)
-- #eval [(2, "aaa"), (3, "three"), (6, "six")].iter.toHashMap

/--
Convert an iterator into a HashSet.

Consumes an iterator and constructs a HashSet containing all unique elements from the iterator.
Duplicate elements are automatically eliminated.

The function pre-allocates capacity based on the iterator's count for efficiency.

# Example
```lean
#eval [2, 3, 6].iter.toHashSet  -- HashSet containing {2, 3, 6}
```
-/
@[inline]
def Std.Iterators.Iter.toHashSet {α β : Type} [BEq β] [Hashable β] [Iterator α Id β] [IteratorLoop α Id Id]
    (it : Iter (α := α) β) : HashSet β :=
  it.fold (·.insert ·) (HashSet.emptyWithCapacity it.count)
-- #eval [2, 3, 6].iter.toHashSet

-- universe u

class IterCollect (γ : Type → Type) where
  collectTo {α β : Type} [BEq β] [Nonempty β] [Iterator α Id β] [Finite α Id] [IteratorCollect α Id Id] : Iter (α := α) β → γ β

instance : IterCollect List where
  collectTo {α β : Type} [BEq β] [Nonempty β] [Iterator α Id β] [Finite α Id] [IteratorCollect α Id Id] (it : Iter (α := α) β) : List β := it.toList

instance : IterCollect Array where
  collectTo {α β : Type} [BEq β] [Nonempty β] [Iterator α Id β] [Finite α Id] [IteratorCollect α Id Id] (it : Iter (α := α) β) : Array β := it.toArray

-- #check IterCollect.collectTo (γ := List)
#guard (#[1, 2, 4].iter |> IterCollect.collectTo (γ := List)) == [1, 2, 4]

-- instance : IterCollect HashSet where
--   collectTo {α β : Type} [BEq β] [Nonempty β] [Hashable β] [Iterator α Id β] [Finite α Id] [IteratorCollect α Id Id] (it : Iter (α := α) β) : HashSet β := it.toHashSet


/-
-- collect to the given type
@[inline]
partial
def Std.Iterators.Iter.collect {α β : Type} [BEq β] [Iterator α Id β] [IteratorCollect α Id Id] (it : Iter (α := α) β) (γ : Type → Type) [IterCollect γ] [Nonempty (γ β)] : γ β := IterCollect.collectTo (γ := γ) it

#check IterCollect.collectTo (β := List) #[1, 2, 3].iter
-- #eval (#[1, 2, 3].iter |>.collect List) == #[]
-/
