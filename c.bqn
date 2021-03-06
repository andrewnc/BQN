#! ./dzref

nl‿tab←•UCS 10‿9
charSet←∾charGroups←⟨
  chF←"+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!" # Function
  "˜˘¨⌜⁼´˝`"            # Modifier
  "∘○⊸⟜⌾⊘◶⎉⚇⍟"          # Composition
  nl∾"⋄,"               # Separator
  "←↩→"                 # Gets
  "(){}⟨⟩"              # Bracket
  "‿"                   # Ligature
  "·"                   # nOthing
  ¯1⊏˘10‿2⥊"𝕊𝕏𝕎𝔽𝔾𝕤𝕩𝕨𝕗𝕘" # Input (𝕣 pending; ℝ not allowed)
  •d # +⟜(↕10)⌾•UCS'0'  # Digit
  "¯.π∞"                # Numeric
  "_"∾˜' '(+∾⊢)⌾•UCS•a  # Alphabetic
  1↑"𝕨"                 # Prefix for input (hack around UTF-16)
  " "∾tab               # Whitespace
# #'" eliminated during tokenization
⟩
bF‿bM‿bC‿bS‿bG‿bB‿bL‿bO‿bI‿bD‿bN‿bA‿bP‿bW←≍¨˜⟜(+`≠↑0∾⊢)≠¨charGroups
bA_e←4+⊑bA
M←1⊸⊑(0⊸≤∧>)-⟜⊑
vi←+´≠¨9↑charGroups
charRole←((vi-1⊑bI)↑/0∾≠¨3↑charGroups)∾(5/⌽↕2)∾0
special←<˘6‿2⥊"𝕤𝕩𝕨𝕣𝕗𝕘"
spd←⥊⍉3‿0↓⌜↑⟜special⌜3‿5‿6

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

  c←charSet⊐f/𝕩
  w←(≠↑0∾⊢)⊸<l←c M (⊑bD)≍+´1⊑¨bD‿bN‿bA
  i←(1-˜l×+`w)⊔c
  na←≠•a⋄us←¯1++´bA
  in←na(⊢-⊣×+⟜(⊑bA)⊸≤)us⊸≠⊸/¨i
  id←⍷(bA M˜w/c)⍒⊸⊏in⋄nv←+´bA M˜⊑¨id

  c↩(w∨¬l∨c M (⊑bP)≍+´1⊑¨bP‿bW)/(vi+id⊐in)⌾(w⊸/)(vi+(≠id)+lu⊐lit)⌾(cl⊸/)c
  c/˜↩¬(≠↑1∾(c∊2‿4+⊑bB)∨⊢)⊸∧c M bS⋄c/˜↩¬(1↓1∾˜c∊3‿5+⊑bB)∧c M bS
  ti←(us=¯1⊸⊑¨i)(⊢+∧⟜(2⊸=))0⌈na⌊∘÷˜(⊑bA)-˜⊑¨i
  t←ti⌾(((0⊸≤∧<⟜(≠id))c-vi)⊸/)(vi⌊c)⊏charRole
  c+↩5×c M 5≍˜⊑bI
  ⟨c,t,nv,(nv↓id)∾lu⟩
}

Parse←{
  a←𝕩M(2≍˜⊑bG)⋄at←1⌽a⋄𝕩/˜↩¬a⋄a/˜↩¬at
  l←≠𝕩⋄sep←𝕩M bS⋄𝕩↩(bF⊑⊸+⊑chF⊐<'⊣')¨⌾(sep⊸/)𝕩⋄sep∨↩𝕩=2+⊑bB
  o←𝕩=⊑bB⋄c←𝕩=1+⊑bB⋄v←a-˜𝕩≥vi⋄f←¬o∨c∨v∨sep
  na←(2×sep)+f×1+l↑0∾c∨v
  d←+`o-c⋄fe←(+`⌾((⍋d)⊸⊏)o)⊏l∾(⍋⊏⟜d)⊸⊏/c
  fe⌊↩l-l↑⌽⌈`↕∘≠⊸×⌽1∾˜sep
  sel←¬∘⊏⟜(o∨c)⊸/⍋((f×fe)⌈↕l)-+`f-l↑/⁼∧f/fe
  sel⊸⊏¨𝕩‿na
}

Base←{+⟜(𝕨⊸×)´𝕩}
Enc2←{2|⌊∘÷⟜2⍟(↕𝕨)𝕩}

Hex←16 Base⟜⌽ (•d∾"ABCDEF")⊸⊐

ReadNum←{
  n‿d‿p‿i←4↕⊸+⊑bN  # ¯.π∞
  Nat←10 Base⟜⌽ -⟜(⊑bD)
  Int←(n=⊑)◶⟨Nat,-·Nat 1⊸↓⟩
  Dec←⊐⟜(<d)⊸(Nat∘↑ + ·(0<≠)◶⟨0,Nat÷10⋆≠⟩+⟜1⊸↓)
  Pos←(⊑p‿i⊐⊏)◶⟨π,∞,Dec⟩
  e←⊑𝕩⊐bA_e
  m←(n=⊑)◶⟨Pos,-·Pos 1⊸↓⟩e↑𝕩
  𝕩×⟜(10⋆·Int(e+1)↓⊣)˜⍟(e<≠𝕩)m
}
LitVal←(⊑"'"""⊐⊏)◶⟨1⊸⊑,1⊸↓,ReadNum⟩
GenF64←{
  0:8⥊0;
  l←2(⌊⋆⁼)𝕩
  (Hex"44")∾2 Base˘8‿8⥊∾⟨¯52↑(0⌈l)Enc2𝕩,11 Enc2 1023+l,⥊0⟩
}
MakeTab←{{⊑∘(∾⟜0)¨¯1↓(chF⊐𝕨)⊔○(∾⟜(≠chF))𝕩}○∾⟜(⥊¨∘⥊¨)˝⍉(2(÷˜∾⊣)≢)⊸⥊𝕩}
tab1←MakeTab⟨
  "⊣⊢"     , 2⥊<⟨⟩
  "|-⌈⌊√"  , (Hex"99")+(↕4)∾6
  "÷"      , <(Hex"10")∾0
  "¬"      , <∾⥊¨⟨Hex"9A",GenF64 1,Hex"A0"⟩
⟩
tab2←MakeTab⟨
  "⊣"      , Hex"1A"
  "+-×÷⌊⌈∧", (Hex"A0")+(↕6)∾2
  "¬"      , <∾⥊¨⟨Hex"A1",GenF64 1,Hex"A0"⟩
  "∨"      , <(Hex"10")∾1
⟩
fntab←⍉(0¨tab1)∾tab1≍tab2
f64←127-3

GenFn←{
  ⟨t,r,nVar,lits⟩←Tokenize𝕩
  nLoc←nVar-𝕨⊢0
  t⊏˜↩⍋+`-˝(2‿3+⊑bB)=⌜t
  nd←+´c←t=3+⊑bB
  t↩((vi+nVar+≠lits)+↕∘≠)⌾(c⊸/)t
  ⟨a,na⟩←Parse t
  ops←⥊∾⟨
    ∾⟜(0⥊˜3∾˜vi-≠)fntab
    ⍉(Hex¨"20"‿"22"‿"21")∾⌜↕nVar
    ⊣⌜⟜(↕3)(GenF64∘ReadNum¨lits)∾(Hex"10")∾¨3+↕nd
  ⟩
  (((≠∾∾)⟨nLoc∾f64⟩)∾(Hex"0B")∾˜∾)¨((⊢-˜¬×+`)a=2+⊑bB)⊔(na+3×a)⊏ops
}

Gen←{
  LEB←{0:⥊0;128⊸+⌾(¯1⊸↓) 2 Base˘ (∨`⌾⌽∨˝˘)⊸/ 10‿7(⊣⥊×´⊸↑) 64 Enc2 𝕩}
  C←LEB∘≠⊸∾
  S←∾⟜C
  V←≠∾∾
  I←C∘•UCS
  t‿n‿b←𝕩
  ∾⟨
   0∾(•UCS"asm")∾4↑1
   1 S V (96∾⟜∾C¨)¨t
   3 S V ⥊¨↕≠b
   7 S V ⥊<"fn"I⊸(⊣∾0∾⊢)n
  10 S V C¨ b
  ⟩
}

rcp←1 GenFn "1÷x"
or ←2 GenFn "(w+x)-w∧x"
Compile←{
  body←GenFn 𝕩
  f←⟨rcp,or,body⟩
  Gen ⟨(≠¨f)/(1‿2‿0∾¨1)⥊¨¨f64 ⋄ 2 ⋄ ∾f⟩
}


# Targetting dzaima/BQN bytecode:

LEBv ← {
  b←128
  l←⌊b⋆⁼1⌈𝕩
  o←⍋⍋⊒/1+l
  o⊏l{f←×𝕨⋄(𝕨-1)(b⊸(×⟜f+|)∾𝕊⟜(⌊÷⟜b)○(f⊸/))⍟(∨´f)𝕩}𝕩
}

DParse ← {nv‿r𝕊𝕩:
  g←⍋+`p←𝕩(M×¯1⋆2|-⟜⊑)bB⋄br←p×𝕩M 2≍˜2+⊑bB
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
  ig←⍋(⊏⟜(¯1∾c/gf)∾d⊸/⊏((≠𝕩)∾b⊏gf)˜)id⊏fi
  ig↩<⟜(≠id)⊸/(⍋+`∘⊏⟜(d∾-/˜d))⊸⊏(⍋⊏⟜(∾⟜(d⊸/)idx))⊸⊏ig
  ui←d(⌈`↕∘≠⊸×)⊸⊏⌾(ig⊸⊏)id
  ii←(ui⊏(fi⊏ft⊏≠¨spd)-(⌈`c⊸×)⊸¬+`dec)∾((sp⊏fi)⊏3×2|ft)++⟜(0⊸≤)2+sp⊏xv
  idor←∾3⥊<is←id∾sp
  idbc←⟨21+is⊏asn,(id-○(⊏⟜fd)ui)∾0¨sp,ii⟩

  b⊏↩gi
  or←⍋idor∾g⊏˜∾⟨cn,cn,b,b,rt,dr,l,l,si,si,at,oa+1⌈oa⊏os,(dy×⊏⟜os)⊸+fa+dy⟩
  bc0←∾idbc∾⟨0¨cn,u⊐ob,15¨b,1+↕≠b⟩
  bc←or⊏bc0∾∾⟨25¨rt,14¨dr,3+l⊏aa,ll,3+si⊏aa,sll,(11-⊑bG)+a/ma+𝕩,5+oa⊏r,(⊢+9×10⊸=)16+dy-7×fa⊏tr⟩
  fs←(ft⊏⥊"fmd"≍⌜⌽↕2)∾¨((+`0∾1+⌊128⋆⁼1⌈bc)⊏˜/1∾or M bc0≍○≠rt)≍○<¨(ft⊏spd)∾⟜(⥊¨↑⟜•a)¨lc
  ⟨LEBv bc,u,fs⟩
}

prims←⟨
  +,-,×,÷,⋆,√,⌊,⌈,|,¬,∧,∨,<,>,≠,=,≤,≥,≡,≢,⊣,⊢,⥊,∾,≍,↑,↓,↕,⌽,⍉,/,⍋,⍒,⊏,⊑,⊐,⊒,∊,⍷,⊔,!
  ˜,˘,¨,⌜,⁼,´,˝,`
  ∘,○,⊸,⟜,⌾,⊘,◶,⎉,⚇,⍟
⟩
DGenFn←{
  p←𝕨⊣prims
  ⟨t,r,nVar,lits⟩←Tokenize𝕩
  ⟨bc,u,blk⟩←nVar‿r DParse t
  o←(u-(vi+nVar-≠p)×u≥vi)⊏p∾LitVal¨lits
  ⟨bc,o,⟨⟩,blk⟩
}
DRun←{
  •COMP DGenFn 𝕩
}
