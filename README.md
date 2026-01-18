# このリポジトリについて
実際にCを使ってプログラムを作成し、Ghidraとx64dbgで解析する。

## レジスタ
`RSP` 現時点のスタックポインタ  
`RIP` 次に実行する命令のアドレス  
`RBP` 関数が使用するスタックの開始地点のアドレス  
`RDI`, `RSI`, `RAX`, `RDX`, `RBX` `R8~R15`  

R... 64bit  
E... 32bit  
AX.. 16bit  
AL.. 8bit  
AH.. 8bit  

## Windowsの引数
Windows x64では最初の4つまでの引数はレジスタに入れて渡す性質がある。  
`RCX`, `RDX`, `R8`, `R9`

## 命令など
```bash
sub rsp,30 # RSPから0x30(48)byte確保(減算)
mov ecx,eax # EAXをECXにコピー
mov rax, qword ptr ds:[7FF7B6EB1010] # データセグメントのアドレスが指す値をRAXに8byte(QWORD)分コピー
ds:[address] # データセグメントで.data, .rdataを指す
call cprogram.7FF7B6EB1010 # 呼び出し元の次のアドレスをpushし、引数のアドレスへジャンプ
push r15 # R15をスタックに入れる
xor eax,eax # EAX同士の排他的論理和、EAX == 0と同様
jne cprogram.7FF7B6EB1010 # ZF == 0のとき、引数のアドレスへジャンプ
cmp eax,1 # 減算、0ならZF == 1, それ以外ZF == 0、EAXから1を引ききれなければCF == 1
je cprogram.7FF7B6EB1010 # ZF == 1のとき、引数のアドレスへジャンプ
test eax,eax # 論理積、真ならZF == 0, それ以外ZF == 1
lea rbp,qword ptr ds:[rsp+40] # RSP+40の計算結果をRBPに8byte(QWORD)分コピー
ret # RSPにある値をRIPに入れ、IPにジャンプ
cdqe # EAXを符号を維持したままRAXに拡張する。
jb cprogram.7FF7B6EB1010 # CF == 1のとき、引数のアドレスへジャンプ
or qword ptr ds:[rcx],0 # 論理和、真ならZF == 0, それ以外ZF == 1
jle cprogram.7FF7B6EB1010 # ZF == 1またはSF != OFのとき、引数のアドレスへジャンプ
5A4D # Windowsにおける実行ファイルの先頭にあるMZ(Magic Number)
```

## Flag
`ZF` 0なら1, 0でなければ0  
`CF` 引ききれないと1, そうでなければ0  
`SF` マイナスなら1, そうでなければ0  
`OF` 桁があふれたら1, そうでなければ0  

## exeファイルの中身  
`.text` 機械語  
`.idata` 外部関数のアドレステーブル(IAT)  
`.data` 初期化済み変数やグローバル変数など  
`.rdata` printfで使用する文字列や定数  

## gsセグメントレジスタ
Windows x64におけるスレッドごとの固有情報のポインタ。TEBとはスレッド環境ブロックのこと。  
`gs:[ox08]` スタックの底  
`gs:[0x10]` スタックの限界  
`gs:[0x30]` TEB自身の開始アドレス  
`gs:[0x60]` PEBのアドレス、ロードされているDLLのリスト
