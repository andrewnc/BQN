*View this file with results and syntax highlighting [here](https://mlochbaum.github.io/BQN/doc/depth.html).*

# Depth

The depth of an array is the greatest level of array nesting it attains, or, put another way, the greatest number of times you can pick an element starting from the original array before reaching a non-array. The monadic function Depth (`≡`) returns the depth of its argument, while the 2-modifier Depth (`⚇`) can control the way its left operand is applied based on the depth of its arguments. Several primitive functions also use the depth of the left argument to decide whether it applies to a single axis of the right argument or to several axes.

## The Depth function

To find the depth of an array, use Depth (`≡`). For example, the depth of a list of numbers or characters is 1:

        ≡ 2‿3‿4
        ≡ "a string is a list of characters"

Depth is somewhat analogous to an array's rank `=𝕩`, and in fact rank can be "converted" to depth by splitting rows with `<⎉1`, reducing the rank by 1 and increasing the depth. Unlike rank, Depth doesn't care at all about its argument's shape:

        ≡ 3‿4⥊"characters"
        ≡ (1+↕10)⥊"characters"

Also unlike rank, Depth *does* care about the elements of its argument: in fact, to find the depth of an array, every element must be inspected.

        ≡ ⟨2,3,4,5⟩
        ≡ ⟨2,<3,4,5⟩
        ≡ ⟨2,<3,4,<<<5⟩

As the above expressions suggest, the depth of an array is the maximum of its elements' depths, plus one. The base case, a non-array (including a function or modifier), has depth 0.

        ≡'c'
        F←+⋄≡f
        ≡⟨'c',f,2⟩
        ≡⟨5,⟨'c',f,2⟩⟩

If the function `IsArray` indicates whether its argument is an array, then we can write a recursive definition of Depth using the Choose modifier.

    Depth←IsArray◶0‿{1+0⌈´Depth¨⥊𝕩}

The minimum element depth of 0 implies that an empty array's depth is 1.

        ≡⟨⟩
        ≡2‿0‿3⥊0

## Testing depth for multiple-axis primitives

Several primitive functions use the left argument to manipulate the right argument along one or more axes, using [the leading axis convention](leading.md#multiple-axes).

| Single-axis depth | Functions
|-------------------|----------
| 0                 | `↑↓↕⌽⍉`
| 1                 | `/⊏⊔`

Functions such as Take and Drop use a single number per axis. When the left argument is a list of numbers, they apply to initial axes. But for convenience, a single number is also accepted, and applied to the first axis only. This is equivalent to ravelling the left argument before applying the function.

        ≢2↑7‿7‿7‿7⥊"abc"
        ≢2‿1‿1↑7‿7‿7‿7⥊"abc"

In these cases the flexibility seems trivial because the left argument has depth 1 or 0: it is an array or isn't, and it's obvious what a plain number should do. But for the second row in the table, the left argument is always an array. The general case is that the left argument is a vector and its elements correspond to right argument axes:

        ⟨3‿2,1‿4‿1⟩ ⊏ ↕6‿7

This means the left argument is homogeneous of depth 2. What should an argument of depth 1, or an argument that contains non-arrays, do? One option is to continue to require the left argument to be a list, and convert any non-array argument into an array by enclosing it:

        ⟨3‿2,1⟩ <⍟(0=≡)¨⊸⊏ ↕6‿7

While very consistent, this extension represents a small convenience and makes it difficult to act on a single axis, which for Replicate and [Group](group.md) is probably the most common way the primitive is used:

        3‿2‿1‿2‿3 / "abcde"

With the extension above, every case like this would have to use `<⊸/` instead of just `/`. BQN avoids this difficulty by testing the left argument's depth. A depth-1 argument applies to the first axis only, giving the behavior above.

For Select, the depth-1 case is still quite useful, but it may also be desirable to choose a single cell using a list of numbers. In this case the left argument depth can be increased from the bottom using `<¨`.

        2‿1‿4 <¨⊸⊏ ↕3‿4‿5‿2

## The Depth modifier

The Depth 2-modifier (`⚇`) is a generalization of Each that allows diving deeper into an array. To illustrate it we'll use a shape `4‿3` array of lists of lists.

        ⊢ n ← <⎉1⍟2 4‿3‿2‿2⥊↕48
        ≡ n

Reversing n swaps all the rows:

        ⌽ n

Depth `¯1` is equivalent to Each, and reverses the larger vectors, while depth `¯2` applies Each twice to reverse the smaller vectors:

        ⌽⚇¯1 n
        ⌽⚇¯2 n

While a negative depth tells how many levels to go down, a non-negative depth gives the maximum depth of the argument before applying the left operand. On a depth-3 array like above, depth `2` is equivalent to `¯1` and depth `1` is equivalent to `¯2`. A depth of `0` means to loop until non-arrays are reached, that is, apply [pervasively](https://aplwiki.com/wiki/Pervasion), like a scalar function.

        ⟨'a',"bc"⟩ ≍⚇0 ⟨2‿3,4⟩

With a positive operand, Depth doesn't have to use the same depth everywhere. Here, Length is applied as soon as the depth for a particular element is 1 or less, including if the argument has depth 0. For example, it maps over `⟨2,⟨3,4⟩⟩`, but not over `⟨11,12⟩`, even though these are elements of the same array.

        ≠⚇1 ⟨1,⟨2,⟨3,4⟩⟩,⟨5,⟨6,7⟩,⟨8,9,10⟩⟩,⟨11,12⟩⟩
