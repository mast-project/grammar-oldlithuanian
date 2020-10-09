% SPDX-License-Identifier: CC-BY-SA-4.0

alphabet digits
    letters 0 1 2 3 4 5 6 7 8 9
;

alphabet location
    letters 0 1 2 3 4 5 6 7 8 9
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            ',' '(' ')',
    modifiers a b
;

alphabet input
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            'a,' 'e,' 'i,' 'u,' 'e2' 'u0' 'e;' l7
            '\.' '\,' '\?' '\!' '\:' '\;' '\=' '\*' / '\(' '\)' \\\' '\&'
            ' ' '\-' <C-j>,
    modifiers \' ^ \. \` \~,
    token NUM # digits,
    token LOC < location >,
    class BASIC a b c d e f g h i j k l m n o p q r s t u v w x y z
                A B C D E F G H I J K L M N O P Q R S T U V W X Y Z,
    class WS ' ' <C-j>,
    class PUNCT '\.' '\,' '\?' '\!' '\:' '\;' '\=' '\*' / '\(' '\)'
;

alphabet orthog
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            ą ę į ų ȩ ů ł eͣ ß
            '.' ',' '?' '!' ';' ':' '=' '*' / '(' ')' '&' ’ ' ' - <C-j>,
    modifiers \́ \̂ \̇ \̀ \̃ ,
    token NUM '' digits,
    token LOC < location >,
    class WS ' ' <C-j>,
    class PUNCT '.' ',' '?' '!' ';' ':' '=' '*' / '(' ')',
    class UPPER A B C D E F G H I J K L M N O P Q R S T U V W X Y Z,
    class V a e i o u A E I O U ą ę į ų ȩ ů eͣ,
    class C c d f g h k l m n p q r s t w x z
            C D F G H K L M N P Q R S T W X Z
            ł ß
;

default alphabet phonetic
    letters a e i o u æ ɪ ʊ iː uː ã ĩ ẽ ũ
            p b f v m w t d s z n l r ʦ ʣ ʃ ʒ ʧ ʤ j k g x,
    modifiers ʲ,
    class V a e i o u æ ɪ ʊ iː uː ã ĩ ẽ ũ,
    class C p b f v m w t d s z n l r ʦ ʣ ʃ ʒ ʧ ʤ j k g x,
    class LV e o ɪ ʊ  iː uː ã ĩ ẽ ũ
    class NV ã ĩ ẽ ũ
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
        'u,' -> ų
        'u0' -> ů
        'e;' -> ȩ
        'e2' -> eͣ
        'l7' -> ł
        sz   -> ß

        {WS} -> {}
        '\-' -> -
        /    -> /
        '\&' -> &
        {PUNCT} -> @chop({})
        \\' -> '’'
       {NUM} -> {}
       {LOC} -> {}
;

transform normalize: orthog -> orthog
       x -> ks
       {C}2 -> {1}
       ~c~z -> č
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
                    map graphemes input ->
                    map transform decode ->
                    dump
;
