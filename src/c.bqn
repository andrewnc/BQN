#! ./dzref

tab←'	'⋄nl←'
'
dig ← "0123456789"
alph ← "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
alow ← "abcdefghijklmnopqrstuvwxyz"
charSet←∾charGroups←⟨
  chF←"+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!" # Function
  "˜˘¨⌜⁼´˝`"            # Modifier
  "∘○⊸⟜⌾⊘◶⎉⚇⍟"          # Composition
  nl∾"⋄,"               # Separator
  "←↩→"                 # Gets
  "(){}⟨⟩"              # Bracket
  "‿"                   # Ligature
  "·"                   # nOthing
  "𝕊𝕏𝕎𝔽𝔾𝕤𝕩𝕨𝕗𝕘"          # Input (𝕣 pending; ℝ not allowed)
  dig                   # Digit
  "¯.π∞"                # Numeric
  alow∾alph∾"_"         # Alphabetic
  " "∾tab               # Whitespace
# #'" eliminated during tokenization
⟩
ErrUnknownChars←{
  "Unclosed quote"!¬∨´⟨''','"'⟩∊𝕩
  ⟨"Unknown character","s"/˜1<≠𝕩,": ",𝕩⟩∾⊸!0
}
CharCode←charSet{
  Chk ← ⊢⊣ErrUnknownChars∘(≠/⊣)⍟≢⟜(⊏⟜𝕗)
  g←⍋𝕗 ⋄ ⊢ Chk g⊏˜1-˜1⌈(g⊏𝕗)⍋⊢
}
bF‿bM‿bC‿bS‿bG‿bB‿bL‿bO‿bI‿bD‿bN‿bA‿bW←≍¨˜⟜(+`≠↑0∾⊢)≠¨charGroups
bA_e←4+⊑bA
M←1⊸⊑(0⊸≤∧>)-⟜⊑
vi←+´≠¨9↑charGroups
charRole←((vi-1⊑bI)↑/0∾≠¨3↑charGroups)∾(5/⌽↕2)∾0
spc←⥊3‿5‿6-⌜3‿0

Tokenize←{
  r←𝕩='#'⋄s←/(≠↑2⊸↓)⊸∧𝕩='''⋄d←/dm←𝕩='"'
  g←⍋q←∾⟨  s⋄¯1↓d⋄/r⟩ ⋄q↩g⊏q
  e← g⊏∾⟨2+s⋄ 1↓d⋄(⊢-¯1↓0∾⊢)∘⊏⟜(0∾+`r)⊸//(𝕩=nl)∾1⟩
  Se←{(⊏˜𝕨)Se 1¨⌾((𝕩/𝕨)⊸⊏)𝕩}⍟{0=⊑⌽𝕩}
  st←¯1↓Se⟜(1↑˜≠)∾⟜≠q⍋e⋄b←st/q∾˘e
  ToI←¯1↓·/⁼(≠𝕩)∾˜⥊
  f←¬≠`bm←ToI b⋄f∧↩¬qe←f∧bm∧(1↓0∾˜⊢)⊸∧dm
  cb←(¬(st/q)⊏r)/b
  lu←⍷lit←𝕩⊔˜1-˜(+`qe-˜ToI⊑˘cb)×≠`ToI cb
  cl←f/ToI⊑∘⌽˘cb

  c←CharCode⌾((¬cl)⊸/) f/𝕩
  w←(≠↑0∾⊢)⊸<l←c M (⊑bD)≍+´1⊑¨bD‿bN‿bA
  na←≠alph⋄us←c=¯1++´bA
  id←(1-˜(us<l)×+`w)⊔na(⊢-⊣×+⟜(⊑bA)⊸≤)c
  ti←na⌊∘÷˜(⊑bA)-˜w/c
  iu←(≠↑¯1∾⌈`)⊸<is←⊐id⋄ni←≠in←0>iu/ti
  ti↩(us/˜(1↓0∾˜⊢)⊸<l)(⊢+∧⟜(2⊸=))0⌈ti

  c↩(w∨¬l∨c M bW)/(vi+is⊏⍋⍋in)⌾(w⊸/)(vi+ni+lu⊐lit)⌾(cl⊸/)c
  c/˜↩¬(≠↑1∾(c∊2‿4+⊑bB)∨⊢)⊸∧c M bS⋄c/˜↩¬(1↓1∾˜c∊3‿5+⊑bB)∧c M bS
  ic←(0⊸≤∧<⟜ni)c-vi⋄t←ti⌾(ic⊸/)(vi⌊c)⊏charRole
  c+↩5×c M 5≍˜⊑bI
  ⟨c,t,+´¬in,((in//iu)⊏id)∾lu⟩
}

ReadNum←{
  n‿d‿p‿i←4↕⊸+⊑bN  # ¯.π∞
  Nat←+⟜(10⊸×)´∘⌽ -⟜(⊑bD)
  Int←(n=⊑)◶⟨Nat,-·Nat 1⊸↓⟩
  Dec←⊐⟜(<d)⊸(Nat∘↑ + ·(0<≠)◶⟨0,Nat÷10⋆≠⟩+⟜1⊸↓)
  Pos←(⊑p‿i⊐⊏)◶⟨π,∞,Dec⟩
  e←⊑𝕩⊐bA_e
  m←(n=⊑)◶⟨Pos,-·Pos 1⊸↓⟩e↑𝕩
  𝕩×⟜(10⋆·Int(e+1)↓⊣)˜⍟(e<≠𝕩)m
}
LitVal←(⊑("'"∾'"')⊐⊏)◶⟨1⊸⊑,1⊸↓,ReadNum⟩


LEBv ← {
  b←128
  l←⌊b⋆⁼1⌈𝕩
  o←⍋⍋((↕¯1⊑⊢)-/⟜(≠↑0∾⊢))⟜(+`)1+l
  o⊏l{f←×𝕨⋄(𝕨-1)(b⊸(×⟜f+|)∾𝕊⟜(⌊÷⟜b)○(f⊸/))⍟(∨´f)𝕩}𝕩
}

ErrMismatchedBrackets←{
  Lcs ← ¯1 ⊑ 0˘∘⊢ {𝕩⌈⌈`𝕨+0∾˜1↓𝕩}˝ =⌜
  _mis ← {"Missing "∾𝕗∾" "∾charSet⊏˜𝕘+⊢/˜≠∘⊣=⊒}
  Msg ← >○≠◶⟨"opening"_mis_ 0, "closing"_mis_ 1˜⟩
  0 !˜ 𝕨 (Lcs<⌊○≠)◶⟨Msg,"Malformed bracket nesting"⟩ 𝕩
}
ErrUndeclared←{
  0 !˜ "Undefined identifier"∾(1<≠𝕩)/"s"
}
Parse ← {nv‿r←𝕨
  g←⍋pd←+`p←𝕩(M×¯1⋆2|-⟜⊑)bB⋄br←p×𝕩M 2≍˜2+⊑bB
  p(=⟜1⊸/ErrMismatchedBrackets⍟≢1-˜=⟜¯1⊸/)○(g⊸⊏)𝕩
  "Swapped open and closed brackets" ! 0≤(⊑g)⊑pd
  sl←1⊸⌽⊸∨𝕩 M bL⋄sr←¯1⊸⌽⌾(g⊸⊏)sl⋄sa←sl∨sr
  g⊏˜↩⍋g⊏sl⋄r×↩¬sa⋄o←p>0
  r+↩(sa<𝕩=1+⊑bB)(⊣∧¬⊸∨=○(⌈`(1+↕∘≠)⊸×)⊢)(¯1⊸⌽⌾(g⊸⊏)3=r)∨1≤r
  rev←⍋+`1+¯1↓g((¯1∾⊣)(⊣⍋⊸⊏⊏˜-⊏˜⟜⍋)⟜⍋1(+`∘∾-∾˜)⊏)o∨sl∨𝕩 M bS

  gf←⍋fd←+`rev⊏br
  rev⊏˜↩gf⋄fd⊏˜↩gf
  𝕩⊏˜↩rev⋄bv←rev⊏br⋄b←/bv<0⋄fi←+`c←bv>0

  FC←-⟜(≠↑0∾⊢)(c∾1)/·+`∾⟜0
  H←0<1↓FC∘=
  ft←(0∾1⊸H+2×2⊸H⌈2×3⊸H)(0‿3‿4‿5+5+⊑bI)⍋𝕩
  fsc←ft⊏spc
  r↩((1↓ft)⊏(1+2⊸≤)⊸/↕4)⌾(b⊸⊏)rev⊏r

  id←/idm←(0⊸≤∧<⟜nv)xv←𝕩-vi⋄idx←id⊏𝕩⋄sp←/𝕩 M bI
  ad←(⌈`↕∘≠⊸×𝕩 M bG)⊏𝕩=⊑bG

  g↩⍋+`rev⊏p-br⋄gr←g⊏rev⋄sll←1+2÷˜0(<-○/>)gr⊏sr-sl⋄l←/g⊏𝕩=5+⊑bB
  g⊏˜↩gs←⍋gr⊏sl⋄gr↩g⊏rev⋄𝕩⊏˜↩g⋄r⊏˜↩g⋄o⊏˜↩gr⋄si←/gr⊏sr>sl
  gi←⍋g⋄l⊏↩⍋gs
  s←𝕩 M bS⋄ps←s∨o∨gr⊏sl⋄a←𝕩 M 2≍˜⊑bG
  r-↩ps∨a⋄op←r≥2⋄fe←(r≥1)∨1⌽r=3
  tr←(⌈`↕∘≠⊸×¯1⌽ps)⊏fe
  ma←tr<(𝕩=1+⊑bG)∧1⌽fe
  ro←op∨a<1⌽r=3⋄os←⌽↕∘≠⊸(⊣-⌈`∘×)⌽¬ro∨ma⋄at←(⊢+1+⊏⟜os)/a
  aa←g⊏asn←¯1⌽+`gi⊏-⟜(≠↑0∾⊢)¯1↓/⁼(≠𝕩)∾˜at-1⋄r↩¯1¨⌾(aa⊸/)r
  tf←(a≤○(⌈`(1+↕∘≠)⊸×)ps)∧(⊢∧2(|<≤)ps(⊢-⌈`∘×)+`)¬ro
  opa←op>1↓0∾˜ps∨a
  oa←⌽/opa⋄fa←/(1⌽aa)<(tf∨¬tr)∧(ro∧1⌽opa)<(r=1)∨op<¯1⌽opa
  dy←fa⊏1↓0∾˜(𝕩≠⊑bO)∧(tr∧r≥0)∨ro<r=0
  n←𝕩≥vi+nv⋄cn←/n∨𝕩≤¯1++´bC⋄u←∧⍷ob←cn⊏𝕩
  lo←(o/𝕩)=4+⊑bB⋄ll←1+lo/1(↓--⊸↓)(o∾1)/+`(s∾0)-(1∾o)∧ps∾1
  dr←/s>o+`⊸⊏0∾lo⋄rt←/𝕩=2+⊑bB

  d←id⊏dec←idm∧ad∧asn⋄lc←FC dec
  ixf←(⊏⟜(¯1∾c/gf)∾d⊸/⊏((≠𝕩)∾b⊏gf)˜)id⊏fi
  ig←(⍋⊏⟜(ixx←∾⟜(d⊸/)idx))⊸⊏⍋ixf
  "Multiple definitions" ! 1∧´ixx∨○((≠↑0∾⊢)⊸≠((≠id)⊸≤⊸/ig)⊏⊢)ixf
  ig↩<⟜(≠id)⊸/(⍋+`∘⊏⟜(d∾-/˜d))⊸⊏ig
  d⊏˜↩ig⋄ErrUndeclared∘/˜⍟(0∨´⊢)⟜(d<(≠↑0∾⊢)⊸≠)ig⊏idx
  ui←(⌈`↕∘≠⊸×d)⊸⊏⌾(ig⊸⊏)id
  ii←(ui⊏(fi⊏fsc)-(⌈`c⊸×)⊸¬+`dec)∾((sp⊏fi)⊏3×2|ft)++⟜(0⊸≤)2+sp⊏xv
  idor←∾3⥊<is←id∾sp
  idbc←⟨21+is⊏asn,(id-○(⊏⟜fd)ui)∾0¨sp,ii⟩

  b⊏↩gi
  or←⍋idor∾g⊏˜∾⟨cn,cn,b,b,rt,dr,l,l,si,si,at,oa+1⌈oa⊏os,(dy×⊏⟜os)⊸+fa+dy⟩
  bc0←∾idbc∾⟨0¨cn,u⊐ob,15¨b,1+↕≠b⟩
  bc←or⊏bc0∾∾⟨25¨rt,14¨dr,3+l⊏aa,ll,3+si⊏aa,sll,(11-⊑bG)+a/ma+𝕩,5+oa⊏r,(⊢+9×10⊸=)16+dy-7×fa⊏tr⟩
  fs←(ft⊏⥊3≍⌜⟜⌽○↕2)∾¨((+`0∾1+⌊128⋆⁼1⌈bc)⊏˜/1∾or M bc0≍○≠rt)≍○<¨lc+fsc
  ⟨LEBv bc∾25,u,fs⟩
}

Compile←{
  ⟨t,r,nVar,lits⟩←Tokenize𝕩
  ⟨bc,u,blk⟩←nVar‿r Parse t
  o←(u-(vi+nVar-≠𝕨)×u≥vi)⊏𝕨∾LitVal¨lits
  ⟨bc,o,blk⟩
}
