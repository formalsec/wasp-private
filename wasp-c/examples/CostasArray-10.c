#include <assert.h>
// This file is part of the SV-Benchmarks collection of verification tasks:
// https://github.com/sosy-lab/sv-benchmarks
//
// SPDX-FileCopyrightText: 2016 Gilles Audemard
// SPDX-FileCopyrightText: 2020 Dirk Beyer <https://www.sosy-lab.org>
// SPDX-FileCopyrightText: 2020 The SV-Benchmarks Community
//
// SPDX-License-Identifier: MIT

extern void abort(void) __attribute__((__nothrow__, __leaf__))
__attribute__((__noreturn__));
extern void __assert_fail(const char *, const char *, unsigned int,
                          const char *) __attribute__((__nothrow__, __leaf__))
__attribute__((__noreturn__));
int __VERIFIER_nondet_int();
void reach_error() { __assert_fail("0", "CostasArray-10.c", 5, "reach_error"); }
void assume(int cond) {
  if (!cond)
    abort();
}
int main() {
  int cond0;
  int dummy = 0;
  int N;
  int var0;
  var0 = __VERIFIER_nondet_int();
  assume(var0 >= 1);
  assume(var0 <= 10);
  int var1;
  var1 = __VERIFIER_nondet_int();
  assume(var1 >= 1);
  assume(var1 <= 10);
  int var2;
  var2 = __VERIFIER_nondet_int();
  assume(var2 >= 1);
  assume(var2 <= 10);
  int var3;
  var3 = __VERIFIER_nondet_int();
  assume(var3 >= 1);
  assume(var3 <= 10);
  int var4;
  var4 = __VERIFIER_nondet_int();
  assume(var4 >= 1);
  assume(var4 <= 10);
  int var5;
  var5 = __VERIFIER_nondet_int();
  assume(var5 >= 1);
  assume(var5 <= 10);
  int var6;
  var6 = __VERIFIER_nondet_int();
  assume(var6 >= 1);
  assume(var6 <= 10);
  int var7;
  var7 = __VERIFIER_nondet_int();
  assume(var7 >= 1);
  assume(var7 <= 10);
  int var8;
  var8 = __VERIFIER_nondet_int();
  assume(var8 >= 1);
  assume(var8 <= 10);
  int var9;
  var9 = __VERIFIER_nondet_int();
  assume(var9 >= 1);
  assume(var9 <= 10);
  int var10;
  var10 = __VERIFIER_nondet_int();
  assume(var10 >= -9);
  assume(var10 <= 9);
  assume(var10 != 0);
  int var11;
  var11 = __VERIFIER_nondet_int();
  assume(var11 >= -9);
  assume(var11 <= 9);
  assume(var11 != 0);
  int var12;
  var12 = __VERIFIER_nondet_int();
  assume(var12 >= -9);
  assume(var12 <= 9);
  assume(var12 != 0);
  int var13;
  var13 = __VERIFIER_nondet_int();
  assume(var13 >= -9);
  assume(var13 <= 9);
  assume(var13 != 0);
  int var14;
  var14 = __VERIFIER_nondet_int();
  assume(var14 >= -9);
  assume(var14 <= 9);
  assume(var14 != 0);
  int var15;
  var15 = __VERIFIER_nondet_int();
  assume(var15 >= -9);
  assume(var15 <= 9);
  assume(var15 != 0);
  int var16;
  var16 = __VERIFIER_nondet_int();
  assume(var16 >= -9);
  assume(var16 <= 9);
  assume(var16 != 0);
  int var17;
  var17 = __VERIFIER_nondet_int();
  assume(var17 >= -9);
  assume(var17 <= 9);
  assume(var17 != 0);
  int var18;
  var18 = __VERIFIER_nondet_int();
  assume(var18 >= -9);
  assume(var18 <= 9);
  assume(var18 != 0);
  int var19;
  var19 = __VERIFIER_nondet_int();
  assume(var19 >= -9);
  assume(var19 <= 9);
  assume(var19 != 0);
  int var20;
  var20 = __VERIFIER_nondet_int();
  assume(var20 >= -9);
  assume(var20 <= 9);
  assume(var20 != 0);
  int var21;
  var21 = __VERIFIER_nondet_int();
  assume(var21 >= -9);
  assume(var21 <= 9);
  assume(var21 != 0);
  int var22;
  var22 = __VERIFIER_nondet_int();
  assume(var22 >= -9);
  assume(var22 <= 9);
  assume(var22 != 0);
  int var23;
  var23 = __VERIFIER_nondet_int();
  assume(var23 >= -9);
  assume(var23 <= 9);
  assume(var23 != 0);
  int var24;
  var24 = __VERIFIER_nondet_int();
  assume(var24 >= -9);
  assume(var24 <= 9);
  assume(var24 != 0);
  int var25;
  var25 = __VERIFIER_nondet_int();
  assume(var25 >= -9);
  assume(var25 <= 9);
  assume(var25 != 0);
  int var26;
  var26 = __VERIFIER_nondet_int();
  assume(var26 >= -9);
  assume(var26 <= 9);
  assume(var26 != 0);
  int var27;
  var27 = __VERIFIER_nondet_int();
  assume(var27 >= -9);
  assume(var27 <= 9);
  assume(var27 != 0);
  int var28;
  var28 = __VERIFIER_nondet_int();
  assume(var28 >= -9);
  assume(var28 <= 9);
  assume(var28 != 0);
  int var29;
  var29 = __VERIFIER_nondet_int();
  assume(var29 >= -9);
  assume(var29 <= 9);
  assume(var29 != 0);
  int var30;
  var30 = __VERIFIER_nondet_int();
  assume(var30 >= -9);
  assume(var30 <= 9);
  assume(var30 != 0);
  int var31;
  var31 = __VERIFIER_nondet_int();
  assume(var31 >= -9);
  assume(var31 <= 9);
  assume(var31 != 0);
  int var32;
  var32 = __VERIFIER_nondet_int();
  assume(var32 >= -9);
  assume(var32 <= 9);
  assume(var32 != 0);
  int var33;
  var33 = __VERIFIER_nondet_int();
  assume(var33 >= -9);
  assume(var33 <= 9);
  assume(var33 != 0);
  int var34;
  var34 = __VERIFIER_nondet_int();
  assume(var34 >= -9);
  assume(var34 <= 9);
  assume(var34 != 0);
  int var35;
  var35 = __VERIFIER_nondet_int();
  assume(var35 >= -9);
  assume(var35 <= 9);
  assume(var35 != 0);
  int var36;
  var36 = __VERIFIER_nondet_int();
  assume(var36 >= -9);
  assume(var36 <= 9);
  assume(var36 != 0);
  int var37;
  var37 = __VERIFIER_nondet_int();
  assume(var37 >= -9);
  assume(var37 <= 9);
  assume(var37 != 0);
  int var38;
  var38 = __VERIFIER_nondet_int();
  assume(var38 >= -9);
  assume(var38 <= 9);
  assume(var38 != 0);
  int var39;
  var39 = __VERIFIER_nondet_int();
  assume(var39 >= -9);
  assume(var39 <= 9);
  assume(var39 != 0);
  int var40;
  var40 = __VERIFIER_nondet_int();
  assume(var40 >= -9);
  assume(var40 <= 9);
  assume(var40 != 0);
  int var41;
  var41 = __VERIFIER_nondet_int();
  assume(var41 >= -9);
  assume(var41 <= 9);
  assume(var41 != 0);
  int var42;
  var42 = __VERIFIER_nondet_int();
  assume(var42 >= -9);
  assume(var42 <= 9);
  assume(var42 != 0);
  int var43;
  var43 = __VERIFIER_nondet_int();
  assume(var43 >= -9);
  assume(var43 <= 9);
  assume(var43 != 0);
  int var44;
  var44 = __VERIFIER_nondet_int();
  assume(var44 >= -9);
  assume(var44 <= 9);
  assume(var44 != 0);
  int var45;
  var45 = __VERIFIER_nondet_int();
  assume(var45 >= -9);
  assume(var45 <= 9);
  assume(var45 != 0);
  int var46;
  var46 = __VERIFIER_nondet_int();
  assume(var46 >= -9);
  assume(var46 <= 9);
  assume(var46 != 0);
  int var47;
  var47 = __VERIFIER_nondet_int();
  assume(var47 >= -9);
  assume(var47 <= 9);
  assume(var47 != 0);
  int var48;
  var48 = __VERIFIER_nondet_int();
  assume(var48 >= -9);
  assume(var48 <= 9);
  assume(var48 != 0);
  int var49;
  var49 = __VERIFIER_nondet_int();
  assume(var49 >= -9);
  assume(var49 <= 9);
  assume(var49 != 0);
  int var50;
  var50 = __VERIFIER_nondet_int();
  assume(var50 >= -9);
  assume(var50 <= 9);
  assume(var50 != 0);
  int var51;
  var51 = __VERIFIER_nondet_int();
  assume(var51 >= -9);
  assume(var51 <= 9);
  assume(var51 != 0);
  int myvar0 = 1;
  assume(var0 != var1);
  assume(var0 != var2);
  assume(var0 != var3);
  assume(var0 != var4);
  assume(var0 != var5);
  assume(var0 != var6);
  assume(var0 != var7);
  assume(var0 != var8);
  assume(var0 != var9);
  assume(var1 != var2);
  assume(var1 != var3);
  assume(var1 != var4);
  assume(var1 != var5);
  assume(var1 != var6);
  assume(var1 != var7);
  assume(var1 != var8);
  assume(var1 != var9);
  assume(var2 != var3);
  assume(var2 != var4);
  assume(var2 != var5);
  assume(var2 != var6);
  assume(var2 != var7);
  assume(var2 != var8);
  assume(var2 != var9);
  assume(var3 != var4);
  assume(var3 != var5);
  assume(var3 != var6);
  assume(var3 != var7);
  assume(var3 != var8);
  assume(var3 != var9);
  assume(var4 != var5);
  assume(var4 != var6);
  assume(var4 != var7);
  assume(var4 != var8);
  assume(var4 != var9);
  assume(var5 != var6);
  assume(var5 != var7);
  assume(var5 != var8);
  assume(var5 != var9);
  assume(var6 != var7);
  assume(var6 != var8);
  assume(var6 != var9);
  assume(var7 != var8);
  assume(var7 != var9);
  assume(var8 != var9);
  assume(var10 != var11);
  assume(var10 != var12);
  assume(var10 != var13);
  assume(var10 != var14);
  assume(var10 != var15);
  assume(var10 != var16);
  assume(var10 != var17);
  assume(var10 != var18);
  assume(var11 != var12);
  assume(var11 != var13);
  assume(var11 != var14);
  assume(var11 != var15);
  assume(var11 != var16);
  assume(var11 != var17);
  assume(var11 != var18);
  assume(var12 != var13);
  assume(var12 != var14);
  assume(var12 != var15);
  assume(var12 != var16);
  assume(var12 != var17);
  assume(var12 != var18);
  assume(var13 != var14);
  assume(var13 != var15);
  assume(var13 != var16);
  assume(var13 != var17);
  assume(var13 != var18);
  assume(var14 != var15);
  assume(var14 != var16);
  assume(var14 != var17);
  assume(var14 != var18);
  assume(var15 != var16);
  assume(var15 != var17);
  assume(var15 != var18);
  assume(var16 != var17);
  assume(var16 != var18);
  assume(var17 != var18);
  assume(var19 != var20);
  assume(var19 != var21);
  assume(var19 != var22);
  assume(var19 != var23);
  assume(var19 != var24);
  assume(var19 != var25);
  assume(var19 != var26);
  assume(var20 != var21);
  assume(var20 != var22);
  assume(var20 != var23);
  assume(var20 != var24);
  assume(var20 != var25);
  assume(var20 != var26);
  assume(var21 != var22);
  assume(var21 != var23);
  assume(var21 != var24);
  assume(var21 != var25);
  assume(var21 != var26);
  assume(var22 != var23);
  assume(var22 != var24);
  assume(var22 != var25);
  assume(var22 != var26);
  assume(var23 != var24);
  assume(var23 != var25);
  assume(var23 != var26);
  assume(var24 != var25);
  assume(var24 != var26);
  assume(var25 != var26);
  assume(var27 != var28);
  assume(var27 != var29);
  assume(var27 != var30);
  assume(var27 != var31);
  assume(var27 != var32);
  assume(var27 != var33);
  assume(var28 != var29);
  assume(var28 != var30);
  assume(var28 != var31);
  assume(var28 != var32);
  assume(var28 != var33);
  assume(var29 != var30);
  assume(var29 != var31);
  assume(var29 != var32);
  assume(var29 != var33);
  assume(var30 != var31);
  assume(var30 != var32);
  assume(var30 != var33);
  assume(var31 != var32);
  assume(var31 != var33);
  assume(var32 != var33);
  assume(var34 != var35);
  assume(var34 != var36);
  assume(var34 != var37);
  assume(var34 != var38);
  assume(var34 != var39);
  assume(var35 != var36);
  assume(var35 != var37);
  assume(var35 != var38);
  assume(var35 != var39);
  assume(var36 != var37);
  assume(var36 != var38);
  assume(var36 != var39);
  assume(var37 != var38);
  assume(var37 != var39);
  assume(var38 != var39);
  assume(var40 != var41);
  assume(var40 != var42);
  assume(var40 != var43);
  assume(var40 != var44);
  assume(var41 != var42);
  assume(var41 != var43);
  assume(var41 != var44);
  assume(var42 != var43);
  assume(var42 != var44);
  assume(var43 != var44);
  assume(var45 != var46);
  assume(var45 != var47);
  assume(var45 != var48);
  assume(var46 != var47);
  assume(var46 != var48);
  assume(var47 != var48);
  assume(var49 != var50);
  assume(var49 != var51);
  assume(var50 != var51);
  assume(var0 - var1 == var10);
  assume(var1 - var2 == var11);
  assume(var2 - var3 == var12);
  assume(var3 - var4 == var13);
  assume(var4 - var5 == var14);
  assume(var5 - var6 == var15);
  assume(var6 - var7 == var16);
  assume(var7 - var8 == var17);
  assume(var8 - var9 == var18);
  assume(var0 - var2 == var19);
  assume(var1 - var3 == var20);
  assume(var2 - var4 == var21);
  assume(var3 - var5 == var22);
  assume(var4 - var6 == var23);
  assume(var5 - var7 == var24);
  assume(var6 - var8 == var25);
  assume(var7 - var9 == var26);
  assume(var0 - var3 == var27);
  assume(var1 - var4 == var28);
  assume(var2 - var5 == var29);
  assume(var3 - var6 == var30);
  assume(var4 - var7 == var31);
  assume(var5 - var8 == var32);
  assume(var6 - var9 == var33);
  assume(var0 - var4 == var34);
  assume(var1 - var5 == var35);
  assume(var2 - var6 == var36);
  assume(var3 - var7 == var37);
  assume(var4 - var8 == var38);
  assume(var5 - var9 == var39);
  assume(var0 - var5 == var40);
  assume(var1 - var6 == var41);
  assume(var2 - var7 == var42);
  assume(var3 - var8 == var43);
  assume(var4 - var9 == var44);
  assume(var0 - var6 == var45);
  assume(var1 - var7 == var46);
  assume(var2 - var8 == var47);
  assume(var3 - var9 == var48);
  assume(var0 - var7 == var49);
  assume(var1 - var8 == var50);
  assume(var2 - var9 == var51);
  assume((var0 - var8) != (var1 - var9));
  reach_error();
  return 0; /* 0 x[0]1 x[1]2 x[2]3 x[3]4 x[4]5 x[5]6 x[6]7 x[7]8 x[8]9 x[9]10
               y[0]11 y[1]12 y[2]13 y[3]14 y[4]15 y[5]16 y[6]17 y[7]18 y[8]19
               y[9]20 y[10]21 y[11]22 y[12]23 y[13]24 y[14]25 y[15]26 y[16]27
               y[17]28 y[18]29 y[19]30 y[20]31 y[21]32 y[22]33 y[23]34 y[24]35
               y[25]36 y[26]37 y[27]38 y[28]39 y[29]40 y[30]41 y[31]42 y[32]43
               y[33]44 y[34]45 y[35]46 y[36]47 y[37]48 y[38]49 y[39]50 y[40]51
               y[41] */
}