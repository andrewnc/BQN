#! /usr/bin/env dbqn

compile ← ⟨•path∾"../c.bqn"⋄"DGenFn"⟩ •EX •path∾"../dzref"
Comp ← ((<"runtime["∾⍕∾"]"˜)¨↕59)⊸Compile
FP ← ∞⊸=◶⟨⍕,"Infinity"⟩
Str ← "str("""∾∾⟜""")"
Char ← "'"(∾∾⊣)(⟨"\t","\n","\'"⟩∾<)⊑˜("'"∾˜•UCS 9‿10)⊑∘⊐⊢
Fconst ← ≡◶⟨(⊑⍋)∘(∾⟜∞)◶⟨0⊸≤◶⟨"-"∾FP∘|,FP⟩,Char⟩⋄Str⋄⊑⟩
L ← "["∾"]"∾˜1↓·∾","⊸∾⟜⍕¨
J ← ∾∾⟜(•UCS 10)¨
Fout ← ⟨L∾⟜25,L Fconst¨,L⟨⊑"fmd"⊸⊐,⊢,⊢,≠⟩⊸(L{𝕎𝕩}¨)¨⟩ {𝕎𝕩}¨ 0‿1‿3 ⊏ ⊢
Frun ← ("provide.concat("∾∾⟜")")⌾(1⊸⊑) Fout
Long ← ∾ (1‿2/⟨"  new Uint8Array("∾∾⟜")"⋄((•UCS 10)∾" ,")⊸∾⟩) {𝕎𝕩}¨ ⊢
• ← (⊑"r"‿"c"‿"fmt"⊐⊏)◶⟨
  {𝕩⋄Long Frun {𝕩⊸↓⌾(1⊸⊑)Comp𝕨}´ •EX •path∾"pr.bqn"}
  {𝕩⋄Long Fout Comp J •LNS •path∾"c.bqn"}
  {𝕩⋄Long Fout Comp J •LNS •path∾"fmt.bqn"}
  J L∘Fout∘Comp¨
⟩ •args
