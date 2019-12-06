% SPDX-License-Identifier: CC-BY-SA-4.0

alphabet input
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            'a,' 'e,' 'i,' 'u,' 'e2' 'u0' 'e;' l7
            '\.' '\,' '\?' '\!' '\:' '\;' / '\(' '\)' \\\' ' ' '\-' <C-n>,
    modifiers \' ^ \. \` \~,
    token NUM # Nd,
    token LOC < Nd Lu Po >,
    class BASIC a b c d e f g h i j k l m n o p q r s t u v w x y z
                A B C D E F G H I J K L M N O P Q R S T U V W X Y Z,
    class WS ' ' <C-n>,
    class PUNCT '\.' '\,' '\?' '\!' '\:' '\;' / '\(' '\)'
;

default alphabet orthog
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            ą ę į ų ȩ ů ł eͣ ß
            '.' ',' '?' '!' ';' ':' / '(' ')' ’ ' ' - <C-n>,
    modifiers \́ \̂ \̇ \̀ \̃ ,
    token NUM '' Nd,
    token LOC < Nd Lu Po >,
    class WS ' ' <C-n>
    class PUNCT '.' ',' '?' '!' ';' ':' / '(' ')'
;

transform decode: input -> orthog
        {BASIC} -> {}
         _' -> @decode({}-')+́
         _^ -> @decode({}-^)+̂
         _. -> @decode({}-.)+̇
         _` -> @decode({}-`)+̀
         _~ -> @decode({}-~)+̃
        'a,' -> ą
        'e,' -> ę
        'i,' -> į
        'u0' -> ů
        'e;' -> ȩ
        'e2' -> eͣ
        'l7' -> ł

        ' ' -> ' '
        <C-n> -> <C-n>
        '\-' -> -
        \\' -> '’'
       {NUM} -> {}
;

category POS : N Adj V Cop Inf Adv Prep Conj;
category CASE : Nom Gen Dat Acc Instr Loc Ill All Adess Voc;
category NUM : Sg Pl Dual;
category PRS : 1 2 3;
category GENDER : m f;
category TENSE: Pres Past PastIter Fut;
category MOOD: Ind Imp Conj Opt;
category VOICE: Act Pass;
category REFL: yes;
category NEG: yes;
category EMPH: yes;
category INTERROG: yes;

category DECL: 1 2 3 4 5 6;
category CONJ: 1 2 3 4;

category GOVERN: Gen Dat Acc Instr Loc Ill All Adess;

NUMPRS = PRS\{PRS: 3} * NUM\{NUM: Dual} | {PRS: 3 NUM: ?};

ROOTN = {POS: N};

ROOTV = {POS: V};

NUMCASE = CASE * NUM;

word (ROOTN)-NUMCASE;
word (ROOTV)-NUMPRS;

paradigm NUMCASE {DECL: 1 GENDER: m}
    -as           -ai    -u
    -o            -ų, -u <<<
    -ai           -omus  -om 
    -ą            -as    -u
    -a            -ais   -om
    -oj[e]        -ůse   <<<
    -on           -asn   -un
    -ieṗ          -ůsṗ   <<<
    -oṗ           -umṗ   <<<
    -e            -ai    -u
;

paradigm NUMPRS {CONJ: 1 TENSE: Pres MOOD: Ind}
    -u            -ame
    -i            -ate
          -a
;

exclusive paradigm ROOTV {TENSE: Pres MOOD: Ind PRS: 3}
    yr = bu
;

paradigm ROOTN {}
    -0
;


paradigm ROOTV {}
    -0
;

pipeline normalize: filename ->
                    read ->
                    graphemes input ->
                    transform decode ->
                    dump
;
