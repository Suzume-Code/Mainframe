# CICSA

The TSO/E installation exit routine, IKJEFF53, is used to customize the behavior of the CANCEL and OUTPUT commands. The default exit routine receives control when a user cancels another user's job or processes the output of another user's job.
In a multilevel secure system, the default IKJEFF53 exit routine provided by IBM must be replaced with a non-default exit routine in SYS1.SAMPLIB to control job name limits using the JESJOBS and JESSPOOL resource classes SYS1.SAMPLIB.

TSO/Eのインストール出口ルーチンであるIKJEFF53は、CANCELコマンドやOUTPUTコマンドの動作をカスタマイズするために使用されます。デフォルトの出口ルーチンは、ユーザーが他のユーザーのジョブをキャンセルしたり、他のユーザーのジョブの出力を処理したりする際に制御を受け取ります。
マルチレベルセキュアシステムでは、JESJOBSおよびJESSPOOLリソースクラスを使用してジョブ名の制限を制御するために、IBMが提供するデフォルトのIKJEFF53出口ルーチンをSYS1.SAMPLIBにある非デフォルトの出口ルーチンに置き換える必要があります。

# Installation

## AUTO INSTALL RESOURCES
This example is “HERC”, but it can be broken down into “HERCPCT”, “HERCPPT”, “HERCFCT”, etc.

* CEDA ADD GROUP(HERC) (HERCLIST)
OR
* CEDA ADD GROUP(HERCPCT) (HERCLIST)
* CEDA ADD GROUP(HERCPPT) (HERCLIST)
* CEDA ADD GROUP(HERCFCT) (HERCLIST)




* DFH320.SYSIN(DFH$SIP1)
  OLD: GRPLIST=(XYZLIST),
  NEW: GRPLIST=(XYZLIST,HERCLIST),
