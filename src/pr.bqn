#!/usr/bin/env dbqn

# Process BQN runtime

impl ← •LNS •path∾"r.bqn"

chrs←⟨
  "+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!"
  "˜˘¨⌜⁼´˝`"
  "∘○⊸⟜⌾⊘◶⎉⚇⍟"
⟩
nc ← ≠¨chrs
chr ← ∾chrs
itr ← 0⥊˜≠chr

init ← " "⊸∾¨(/⟜"_"¨nc/0‿1‿1)∾¨(nc/"FMD")∾¨(nc+´⊸↑⥊"ABC"∾⌜•a)
post ← ∾⟜" "¨/⟜"_"¨nc/0‿0‿1
names ← init∾¨(•UCS 48)∾¨post

Inc ← {
  i←⊑chr⊐𝕩
  n←0 ⋄ itr↩{n↩1+𝕩}⌾(i⊑⊢)itr
  names↩((i⊑init)∾(•UCS 48+n)∾i⊑post)⌾(i⊑⊢)names
}

# Required functionality passed in as an argument
def ← ⟨"IsArray","Type","Log","GroupLen","GroupOrd"⟩
keep ← "!+-×÷⋆⌊=≤≢⥊⊑↕⌜`⊘"
ki ← chr⊐keep
kt ← (+`nc)(∾((≠def)∾¯1↓⊣)+⊔⟜⊒∘⍋)ki
names ↩ (⥊¨kt⊏chr)⌾(ki⊸⊏)names


E_isdef ← (3≤≠)◶⟨0,∧´⟨chr," ","←↩"⟩∊˜¨3⊸↑⟩
E_proc ← ({𝕨∘𝕩}´ {𝕨•_R_𝕩}⟜⥊¨⟜(≠↑chr˜) def)∘{
  l←≠chr
  q←≠`𝕩='"' ⋄ q∨↩≠`q<𝕩=''' ⋄ f←¬∨`q<𝕩='#'
  ∾ (((l×f/q)+chr⊸⊐) (≥⟜l)◶⟨⊑⟜names,⥊∘⊢⟩¨ ⊢) f/𝕩
}
E_redef ← { # handles [fmd] [←↩]
  tail ← E_proc 3↓𝕩 # must use old def
  Inc ⊑𝕩
  (E_proc 1↑𝕩) ∾ "←" ∾ tail
}

ref ← ∾∾⟜(•UCS 10)¨ E_isdef◶E_proc‿E_redef¨ impl∾<"⟨"∾"⟩"∾˜1↓⥊","⊸∾˘chr
⟨ref, def+○≠keep⟩
