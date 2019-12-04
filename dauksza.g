% SPDX-License-Identifier: CC-BY-SA-4.0

alphabet input
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            'a,' 'e,' 'i,' 'u,' 'e2' 'u0' 'e;' l7
            '\.' '\,' '\?' '\!' '\:' '\;' / '\(' '\)' \\\' ' ' '\-' <C-n>,
    modifiers \' ^ \. \` \~,
    token NUM # Nd,
    class BASIC a b c d e f g h i j k l m n o p q r s t u v w x y z
                A B C D E F G H I J K L M N O P Q R S T U V W X Y Z,
    class WS ' ' <C-n>,
    class PUNCT '\.' '\,' '\?' '\!' '\:' '\;' / '\(' '\)'
;

alphabet orthog
    letters a b c d e f g h i j k l m n o p q r s t u v w x y z
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
            ą ę į ų ȩ ů ł eͣ ß
            '.' ',' '?' '!' ';' ':' / '(' ')' ’ ' ' - <C-n>,
    modifiers \́ \̂ \̇ \̀ \̃ ,
    token NUM Nd,
    class WS ' ' <C-n>
    class PUNCT '.' ',' '?' '!' ';' ':' / '(' ')'
;

transform decode: input -> orthog
       {BASIC} -> {}
        _' -> @decode({}-')+́
        _^ -> @decode({}-^)+̂
        _. -> @decode({}-.)+̇
        _` -> @decode({}-`)+̀
        _~ -> @decode({}-`)+̃
        'a,' -> ą
        'e,' -> ę
        'i,' -> į
        u0 -> ů
        'e;' -> ȩ
        'e2' -> eͣ
        'l7' -> ł

        {PUNCT} -> @chop({})
        ' ' -> ' '
        <C-n> -> <C-n>
        '\-' -> -
        \\\' -> ’
       {NUM} -> {}
;
