PUSH RBP                                    ; RBPの値をスタックに入れる。
MOV  RBP,RSP                                ; スタックポインタをRBPにコピー。main関数が使用するスタックの開始ポインタをRBPにコピー。
SUB  RSP,0x30                               ; RSPを0x30(48)下げる。48byteを確保している。
CALL __main                                 ; __mainにジャンプ。ジャンプする前にRIP + 8した値（次の命令のアドレス）をスタックにpushしている。
MOV  dword ptr [RBP + local_c],0x64         ; 0x64(100)をRBPとlocal_cを足したアドレスにある値(SUB RSP,0x30内)にDWORD(4byte)分コピーする。
MOV  EAX,dword ptr [RBP + local_c]          ; EAXに0x64(100)をコピー。
LEA  _Argc,[s_Number_is_%d._14000a000]      ; [s_Number_is_%d._14000a000]は.rdata内部にあるprintfで使用する文字列のこと。そのアドレスを_Argc(RCX)にコピー。
MOV  _Argv,EAX                              ; EAX(0x64)を_Argv(RDX)にコピー。
CALL __mingw_printf                         ; __mingw_printfにジャンプ。ジャンプする前にRIP + 8した値（次の命令のアドレス）をスタックにpushしている。
MOV  EAX,0x0                                ; 0x0(0)をEAXにコピー。main関数の戻り値用。
ADD  RSP,0x30                               ; RSPを0x30(48)上げる。48byteを開放している。
POP  RBP                                    ; RSPが指す値(1行目でpushした)をRBPに入れる。
RET                                         ; RSPが指す値をRIPに入れる。RIPが指す値にジャンプする。