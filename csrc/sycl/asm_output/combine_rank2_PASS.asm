//.kernel _ZTSZZN7deep_ep9intranode7combineEDnPvPfPKvPKfS4_S4_PKiS8_S8_PiiiiiPS1_iiRN4sycl3_V15queueEiiiENKUlRNSC_7handlerEE0_clESG_EUlNSC_7nd_itemILi1EEEE_
//.platform XE2
//.thread_config numGRF=128, numAcc=4, numSWSB=16
//.options_string "-emitCrossThreadOffR0Reloc -hashmovs 2644185670 1879950407 -hashmovs1 0 16 "
//.full_options "-emitLocation -enableCoalesceScalarMoves -supportLSCImmScale 0 -samplerHeaderWA -enablePreemptionR0Only -hasRNEandDenorm -noStitchExternFunc -useInlineData -emitCrossThreadOffR0Reloc -abortOnSpill 4 -enableBundleCR 3 -freqBasedSpillCost 8 -freqBasedSpillCostFunc 1 -boundsChecking -presched-ctrl 6 -presched-rp 100 -nodpsendreorder -SBIDDepLoc -PVCSendWARWA -output -binary -dumpcommonisa -dumpcombinedcisa -dumpvisa -printHexFloatInAsm -noverifyCISA -enableHalfLSC -partialInt64 -activeThreadsOnlyBarrier -generateDebugInfo -hashmovs 2644185670 1879950407 -hashmovs1 0 16 "
//.instCount 1227
//.RA type	HYBRID_BC_RA
//.git-hash 8a9a27bbde4417e20b54507ca89a46693ac9f225
//.spill flag store 7
//.spill flag load 8

//.declare BuiltInR0 (0)  rf=r size=64 type=ud align=32 words (r0.0) IsBuiltin
//.declare  (1)  rf=r size=64 type=ud align=32 words (r60.0) IsBuiltin
//.declare BuiltinA0 (2)  rf=a size=4 type=ud align=1 words (a0.0) IsBuiltin
//.declare BuiltinA0Dot2 (3)  rf=a size=4 type=ud align=1 words (a0.2) IsBuiltin
//.declare BuiltinSR0Dot1 (5)  rf=r size=4 type=ud align=2 words IsBuiltin
//.declare %null (10)  rf=r size=4 type=ud align=32 words
//.declare %local_id_x (13)  rf=r size=4 type=ud align=2 words (r3.4)
//.declare %local_id_y (14)  rf=r size=4 type=ud align=2 words (r3.5)
//.declare %local_size_x (15)  rf=r size=4 type=ud align=2 words (r3.0)
//.declare %local_size_y (16)  rf=r size=4 type=ud align=2 words (r3.1)
//.declare %group_id_x (17)  rf=r size=4 type=ud align=2 words (r0.1)
//.declare %group_id_y (18)  rf=r size=4 type=ud align=2 words (r0.6)
//.declare %group_id_z (19)  rf=r size=4 type=ud align=2 words (r0.7)
//.declare %group_count_x (20)  rf=r size=4 type=ud align=2 words (r3.2)
//.declare %group_count_y (21)  rf=r size=4 type=ud align=2 words (r3.3)
//.declare %tsc (22)  rf=r size=20 type=ud align=2 words
//.declare %arg (23)  rf=r size=0 type=ud align=32 words (r26.0)
//.declare %retval (24)  rf=r size=0 type=ud align=32 words (r26.0) Output
//.declare %sp (25)  rf=r size=8 type=uq align=32 words (r127.3)
//.declare %fp (26)  rf=r size=8 type=uq align=32 words (r127.2)
//.declare %sr0 (27)  rf=r size=16 type=ud align=2 words
//.declare %cr0 (28)  rf=r size=12 type=ud align=2 words
//.declare %ce0 (29)  rf=r size=4 type=ud align=2 words
//.declare %dbg0 (30)  rf=r size=8 type=ud align=2 words
//.declare implBufPtr (32)  rf=r size=8 type=uq align=32 words (r126.0)
//.declare localIdBufPtr (33)  rf=r size=8 type=uq align=32 words (r126.3)
//.declare %msg0 (34)  rf=r size=12 type=ud align=2 words
//.declare %scratchloc (35)  rf=r size=8 type=uq align=4 words (s0.7)
//.declare V0033 (43)  rf=r size=64 type=d alias=+0 align=32 words (r60.0)
//.declare V0034 (44)  rf=r size=8 type=uq align=4 words (r4.3)
//.declare V0035 (45)  rf=r size=8 type=uq align=4 words (r5.0)
//.declare V0036 (46)  rf=r size=8 type=uq align=4 words (r5.1)
//.declare V0037 (47)  rf=r size=8 type=uq align=4 words (r5.2)
//.declare V0038 (48)  rf=r size=8 type=uq align=4 words (r5.3)
//.declare V0039 (49)  rf=r size=8 type=uq align=4 words (r5.4)
//.declare V0040 (50)  rf=r size=8 type=uq align=4 words (r5.5)
//.declare V0041 (51)  rf=r size=8 type=uq align=4 words (r5.6)
//.declare V0042 (52)  rf=r size=8 type=uq align=4 words (r5.7)
//.declare V0043 (53)  rf=r size=8 type=uq align=4 words (r6.0)
//.declare V0044 (54)  rf=r size=4 type=d align=2 words (r6.4)
//.declare V0045 (55)  rf=r size=4 type=d align=2 words (r6.5)
//.declare V0046 (56)  rf=r size=4 type=d align=2 words (r6.6)
//.declare V0047 (57)  rf=r size=8 type=uq align=4 words (r6.1)
//.declare V0048 (58)  rf=r size=4 type=d align=2 words (r6.7)
//.declare V0049 (59)  rf=r size=4 type=d align=2 words (r6.8)
//.declare V0050 (60)  rf=r size=4 type=d align=2 words (r6.9)
//.declare V0051 (61)  rf=r size=4 type=d align=2 words (r6.10)
//.declare V0052 (62)  rf=r size=4 type=ud align=2 words (r4.2)
//.declare V0053 (63)  rf=r size=4 type=ud align=2 words (r4.4)
//.declare V0055 (65)  rf=r size=32 type=d alias=+0 align=32 words (r60.0)
//.declare V0057 (67)  rf=r size=64 type=w align=32 words (r1.0)
//.declare V0058 (68)  rf=r size=64 type=w align=32 words (r2.0)
//.declare V0059 (69)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0060 (70)  rf=r size=8 type=uq align=4 words (r6.6)
//.declare V0061 (71)  rf=r size=8 type=uq align=4 words (r6.7)
//.declare V0085 (95)  rf=r size=512 type=d align=32 words (r12.0)
//.declare V0087 (97)  rf=r size=64 type=uw alias=V0057+0 align=32 words (r1.0)
//.declare V0088 (98)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0089 (99)  rf=r size=4 type=ud alias=V0049+0 align=32 words (r6.8)
//.declare V0090 (100)  rf=r size=4 type=ud alias=V0088+0 align=2 words (r4.0)
//.declare V0091 (101)  rf=r size=4 type=d alias=+0 align=2 words (r112.4)
//.declare V0092 (102)  rf=r size=4 type=d align=2 words (r112.6)
//.declare V0093 (103)  rf=r size=4 type=d align=2 words (r112.10)
//.declare V0094 (104)  rf=r size=32 type=ud alias=V0055+0 align=32 words (r60.0)
//.declare V0095 (105)  rf=r size=4 type=ud alias=V0093+0 align=2 words (r112.10)
//.declare V0096 (106)  rf=r size=4 type=d align=2 words (r61.0)
//.declare V0097 (107)  rf=r size=128 type=d align=32 words (r40.0)
//.declare V0098 (108)  rf=r size=128 type=d align=32 words (r46.0)
//.declare V0099 (109)  rf=r size=128 type=d align=32 words (r90.0)
//.declare V0100 (110)  rf=r size=128 type=ud alias=V0097+0 align=32 words (r40.0)
//.declare V0101 (111)  rf=r size=128 type=ud alias=V0099+0 align=32 words (r90.0)
//.declare P1 (112)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0102 (113)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0103 (114)  rf=r size=4 type=d align=2 words (r61.1)
//.declare V0104 (115)  rf=r size=4 type=ud align=2 words (r2.0)
//.declare V0106 (117)  rf=r size=4 type=ud align=2 words (r2.1)
//.declare V0108 (119)  rf=r size=4 type=ud align=2 words (r2.3)
//.declare V0109 (120)  rf=r size=4 type=ud align=2 words (r2.2)
//.declare V0110 (121)  rf=r size=4 type=ud alias=V0103+0 align=2 words (r61.1)
//.declare P2 (122)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0114 (126)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0115 (127)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0116 (128)  rf=r size=128 type=ud alias=V0115+0 align=32 words (r8.0)
//.declare V0117 (129)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P3 (130)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0118 (131)  rf=r size=128 type=ud alias=V0098+0 align=32 words (r46.0)
//.declare V0119 (132)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0120 (133)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0121 (134)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0122 (135)  rf=r size=128 type=ud alias=V0121+0 align=32 words (r10.0)
//.declare V0123 (136)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0127 (140)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0128 (141)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0129 (142)  rf=r size=128 type=ud alias=V0128+0 align=32 words (r8.0)
//.declare V0130 (143)  rf=r size=128 type=d align=32 words (r10.0)
//.declare  (144)  rf=r size=64 type=ud align=32 words (r2.0)
//.declare  (145)  rf=r size=32 type=ud align=32 words (r3.0)
//.declare P4 (146)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0131 (147)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0132 (148)  rf=r size=8 type=q alias=V0061+0 align=32 words (r6.7)
//.declare V0134 (150)  rf=r size=4 type=ud alias=V0131+0 align=2 words (r2.0)
//.declare V0135 (151)  rf=r size=8 type=q align=4 words (r112.1)
//.declare V0136 (152)  rf=r size=8 type=uq alias=V0135+0 align=4 words (r112.1)
//.declare V0137 (153)  rf=r size=16 type=d align=32 words (r3.0)
//.declare V0138 (154)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0139 (155)  rf=r size=4 type=d align=2 words (r3.4)
//.declare V0141 (157)  rf=r size=4 type=ud alias=V0139+0 align=2 words (r3.4)
//.declare V0142 (158)  rf=r size=8 type=q align=4 words (r61.7)
//.declare V0143 (159)  rf=r size=8 type=uq alias=V0142+0 align=4 words (r61.7)
//.declare V0145 (161)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V0146 (162)  rf=r size=4 type=d align=2 words (r4.3)
//.declare V0147 (163)  rf=r size=4 type=d align=2 words (r4.5)
//.declare V0148 (164)  rf=r size=8 type=q alias=V0047+0 align=32 words (r6.1)
//.declare V0150 (166)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0151 (167)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V0152 (168)  rf=r size=8 type=uq alias=V0151+0 align=32 words (r8.0)
//.declare V0153 (169)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V0154 (170)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0156 (172)  rf=r size=8 type=q align=4 words (r7.1)
//.declare V0157 (173)  rf=r size=8 type=q align=4 words (r10.0)
//.declare V0158 (174)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0159 (175)  rf=r size=4 type=d align=2 words (r2.1)
//.declare V0160 (176)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0161 (177)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0162 (178)  rf=r size=4 type=ud alias=V0160+0 align=2 words (r3.0)
//.declare V0163 (179)  rf=r size=4 type=ud alias=V0147+0 align=2 words (r4.5)
//.declare V0164 (180)  rf=r size=4 type=ud alias=V0051+0 align=32 words (r6.10)
//.declare V0165 (181)  rf=r size=4 type=d align=32 words (r11.0)
//.declare V0167 (183)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0169 (185)  rf=r size=8 type=q align=4 words (r3.1)
//.declare V0170 (186)  rf=r size=8 type=d alias=V0169+0 align=4 words (r3.2)
//.declare V0171 (187)  rf=r size=4 type=d align=2 words (r61.10)
//.declare V0175 (191)  rf=r size=4 type=ud alias=V0096+0 align=2 words (r61.0)
//.declare V0176 (192)  rf=r size=4 type=d align=32 words (r9.0)
//.declare V0178 (194)  rf=r size=4 type=d align=32 words (r13.0)
//.declare V0180 (196)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V0181 (197)  rf=r size=8 type=d alias=V0180+0 align=4 words (r8.0)
//.declare V0182 (198)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0183 (199)  rf=r size=4 type=d align=2 words (r2.2)
//.declare V0184 (200)  rf=r size=4 type=ud alias=V0182+0 align=2 words (r2.0)
//.declare V0185 (201)  rf=r size=4 type=d align=32 words (r11.0)
//.declare V0187 (203)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0188 (204)  rf=r size=8 type=q align=4 words (r2.2)
//.declare V0189 (205)  rf=r size=8 type=q align=4 words (r3.0)
//.declare V0190 (206)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0191 (207)  rf=r size=8 type=q align=4 words (r6.6)
//.declare V0192 (208)  rf=r size=4 type=d align=2 words (r61.12)
//.declare V0193 (209)  rf=r size=4 type=d align=32 words (r9.0)
//.declare V0194 (210)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0195 (211)  rf=r size=4 type=ud alias=V0193+0 align=2 words (r9.0)
//.declare V0196 (212)  rf=r size=4 type=ud alias=V0046+0 align=32 words (r6.6)
//.declare V0197 (213)  rf=r size=4 type=d align=32 words (r13.0)
//.declare V0199 (215)  rf=r size=4 type=d align=32 words (r14.0)
//.declare V0203 (219)  rf=r size=4 type=ud alias=V0146+0 align=2 words (r4.3)
//.declare V0204 (220)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0206 (222)  rf=r size=4 type=d align=32 words (r11.0)
//.declare V0208 (224)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V0209 (225)  rf=r size=8 type=d alias=V0208+0 align=4 words (r3.0)
//.declare V0213 (229)  rf=r size=4 type=d align=32 words (r15.0)
//.declare V0215 (231)  rf=r size=4 type=d align=32 words (r13.0)
//.declare V0217 (233)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V0218 (234)  rf=r size=8 type=d alias=V0217+0 align=4 words (r12.0)
//.declare V0219 (235)  rf=r size=8 type=q align=4 words (r2.2)
//.declare V0221 (237)  rf=r size=8 type=d align=32 words (r14.0)
//.declare V0223 (239)  rf=r size=8 type=uq align=32 words (r16.0)
//.declare V0224 (240)  rf=r size=8 type=q align=4 words (r7.1)
//.declare V0226 (242)  rf=r size=8 type=d align=32 words (r8.0)
//.declare V0228 (244)  rf=r size=8 type=uq align=32 words (r11.0)
//.declare V0229 (245)  rf=r size=4 type=d align=2 words (r9.1)
//.declare V0233 (249)  rf=r size=4 type=ud alias=V0229+0 align=2 words (r9.1)
//.declare V0234 (250)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0236 (252)  rf=r size=4 type=d align=32 words (r13.0)
//.declare V0238 (254)  rf=r size=8 type=q align=32 words (r17.0)
//.declare V0239 (255)  rf=r size=8 type=d alias=V0238+0 align=4 words (r17.0)
//.declare V0243 (259)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0245 (261)  rf=r size=4 type=d align=32 words (r11.0)
//.declare V0247 (263)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V0248 (264)  rf=r size=8 type=d alias=V0247+0 align=4 words (r3.0)
//.declare V0249 (265)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0251 (267)  rf=r size=8 type=d align=32 words (r14.0)
//.declare V0253 (269)  rf=r size=8 type=q align=32 words (r15.0)
//.declare V0254 (270)  rf=r size=8 type=q align=4 words (r7.1)
//.declare V0256 (272)  rf=r size=8 type=d align=32 words (r12.0)
//.declare V0258 (274)  rf=r size=8 type=q align=32 words (r13.0)
//.declare P5 (275)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0259 (276)  rf=r size=4 type=ud alias=V0091+0 align=2 words (r112.4)
//.declare V0260 (277)  rf=r size=4 type=d align=2 words (r112.0)
//.declare V0261 (278)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0262 (279)  rf=r size=4 type=d alias=+4 align=2 words (r112.5)
//.declare V0263 (280)  rf=r size=4 type=d alias=+0 align=2 words (r2.0)
//.declare V0264 (281)  rf=r size=4 type=d alias=+4 align=2 words (r2.1)
//.declare V0265 (282)  rf=r size=4 type=d align=2 words (r2.2)
//.declare V0266 (283)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0267 (284)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0268 (285)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0269 (286)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0270 (287)  rf=r size=4 type=ud alias=V0266+0 align=2 words (r3.1)
//.declare V0271 (288)  rf=r size=4 type=d align=2 words (r6.13)
//.declare V0272 (289)  rf=r size=4 type=ud alias=V0271+0 align=2 words (r6.13)
//.declare V0273 (290)  rf=r size=4 type=d alias=+0 align=2 words (r7.0)
//.declare V0274 (291)  rf=r size=4 type=f align=2 words (r7.2)
//.declare V0275 (292)  rf=r size=4 type=ud alias=V0268+0 align=2 words (r6.11)
//.declare V0276 (293)  rf=r size=4 type=f align=2 words (r8.0)
//.declare V0277 (294)  rf=r size=4 type=f align=2 words (r9.0)
//.declare V0278 (295)  rf=r size=4 type=f align=2 words (r9.1)
//.declare V0279 (296)  rf=r size=4 type=d align=2 words (r2.2)
//.declare V0280 (297)  rf=r size=4 type=ud alias=V0279+0 align=2 words (r2.2)
//.declare V0281 (298)  rf=r size=4 type=d alias=+4 align=2 words (r7.1)
//.declare V0282 (299)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0283 (300)  rf=r size=4 type=ud alias=V0282+0 align=2 words (r3.0)
//.declare V0284 (301)  rf=r size=4 type=f alias=+0 align=2 words (r4.0)
//.declare V0285 (302)  rf=r size=4 type=ud alias=V0273+0 align=2 words (r7.0)
//.declare V0286 (303)  rf=r size=4 type=f alias=+4 align=2 words (r4.1)
//.declare V0287 (304)  rf=r size=4 type=ud alias=V0281+0 align=2 words (r7.1)
//.declare V0288 (305)  rf=r size=4 type=f align=2 words (r3.2)
//.declare V0290 (307)  rf=r size=4 type=f align=2 words (r3.3)
//.declare V0292 (309)  rf=r size=4 type=f align=2 words (r10.0)
//.declare V0293 (310)  rf=r size=4 type=f align=2 words (r11.0)
//.declare V0294 (311)  rf=r size=4 type=f align=2 words (r12.0)
//.declare V0295 (312)  rf=r size=4 type=d align=2 words (r8.0)
//.declare V0296 (313)  rf=r size=4 type=ud alias=V0295+0 align=2 words (r8.0)
//.declare V0297 (314)  rf=r size=4 type=d align=2 words (r13.0)
//.declare V0298 (315)  rf=r size=4 type=d align=2 words (r13.1)
//.declare V0299 (316)  rf=r size=4 type=d align=32 words (r14.0)
//.declare V0300 (317)  rf=r size=4 type=d align=2 words (r2.2)
//.declare V0301 (318)  rf=r size=4 type=d align=2 words (r16.0)
//.declare V0302 (319)  rf=r size=4 type=ud alias=V0300+0 align=2 words (r2.2)
//.declare V0303 (320)  rf=r size=4 type=ud alias=V0301+0 align=2 words (r16.0)
//.declare  (321)  rf=f16  size=2 type=uw align=1 words (f2.0)
//.declare V0304 (322)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V0305 (323)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0306 (324)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0307 (325)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0308 (326)  rf=r size=4 type=d align=2 words (r112.9)
//.declare V0309 (327)  rf=r size=128 type=d align=32 words (r16.0)
//.declare V0310 (328)  rf=r size=4 type=d align=2 words (r4.3)
//.declare V0311 (329)  rf=r size=4 type=d align=2 words (r4.11)
//.declare V0312 (330)  rf=r size=8 type=d alias=V0038+0 align=32 words (r5.6)
//.declare V0313 (331)  rf=r size=8 type=uq align=4 words (r6.6)
//.declare V0314 (332)  rf=r size=4 type=d align=2 words (r4.1)
//.declare V0315 (333)  rf=r size=4 type=d align=2 words (r4.10)
//.declare V0316 (334)  rf=r size=8 type=d alias=V0313+0 align=4 words (r6.12)
//.declare V0317 (335)  rf=r size=4 type=d align=2 words (r4.9)
//.declare V0318 (336)  rf=r size=4 type=d align=2 words (r4.8)
//.declare V0319 (337)  rf=r size=8 type=d alias=V0039+0 align=32 words (r5.8)
//.declare V0321 (339)  rf=r size=4 type=d align=2 words (r4.5)
//.declare V0322 (340)  rf=r size=4 type=d align=2 words (r4.0)
//.declare P6 (342)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0324 (343)  rf=r size=4 type=d align=2 words (r112.8)
//.declare V0333 (352)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0335 (354)  rf=r size=64 type=uw alias=V0333+0 align=32 words (r7.0)
//.declare V0336 (355)  rf=r size=128 type=d align=32 words (r84.0)
//.declare V0337 (356)  rf=r size=128 type=ud alias=V0336+0 align=32 words (r84.0)
//.declare P7 (357)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P8 (358)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare P9 (359)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P10 (360)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0338 (361)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0339 (362)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V0340 (363)  rf=r size=128 type=d align=32 words (r108.0)
//.declare V0341 (364)  rf=r size=128 type=ud alias=V0340+0 align=32 words (r108.0)
//.declare V0342 (365)  rf=r size=8 type=q alias=V0043+0 align=32 words (r6.0)
//.declare V0345 (368)  rf=r size=8 type=q alias=V0035+0 align=32 words (r5.0)
//.declare P11 (370)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare P12 (371)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare V0347 (372)  rf=r size=4 type=d align=2 words (r61.13)
//.declare V0348 (373)  rf=r size=8 type=q alias=V0038+0 align=32 words (r5.3)
//.declare V0349 (374)  rf=r size=8 type=q alias=V0039+0 align=32 words (r5.4)
//.declare V0350 (375)  rf=r size=8 type=q alias=V0034+0 align=32 words (r4.3)
//.declare P13 (376)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare V0352 (378)  rf=r size=8 type=d align=32 words (r4.0)
//.declare V0353 (379)  rf=r size=8 type=d align=2 words (r61.7)
//.declare V0354 (380)  rf=r size=8 type=d align=32 words (r4.0)
//.declare V0355 (381)  rf=r size=8 type=d align=2 words (r61.5)
//.declare V0356 (382)  rf=r size=64 type=w align=32 words (r77.0)
//.declare V0357 (383)  rf=r size=64 type=w align=32 words (r76.0)
//.declare V0358 (384)  rf=r size=64 type=w align=32 words (r75.0)
//.declare V0359 (385)  rf=r size=64 type=w align=32 words (r74.0)
//.declare V0360 (386)  rf=r size=64 type=w align=32 words (r73.0)
//.declare V0361 (387)  rf=r size=64 type=w align=32 words (r72.0)
//.declare V0362 (388)  rf=r size=64 type=w align=32 words (r71.0)
//.declare V0363 (389)  rf=r size=64 type=w align=32 words (r70.0)
//.declare V0364 (390)  rf=r size=64 type=w align=32 words (r69.0)
//.declare V0365 (391)  rf=r size=64 type=w align=32 words (r68.0)
//.declare V0366 (392)  rf=r size=64 type=w align=32 words (r67.0)
//.declare V0367 (393)  rf=r size=64 type=w align=32 words (r66.0)
//.declare V0368 (394)  rf=r size=64 type=w align=32 words (r65.0)
//.declare V0369 (395)  rf=r size=64 type=w align=32 words (r64.0)
//.declare V0370 (396)  rf=r size=64 type=w align=32 words (r63.0)
//.declare V0371 (397)  rf=r size=64 type=w align=32 words (r62.0)
//.declare V0374 (400)  rf=r size=128 type=d align=32 words (r40.0)
//.declare V0375 (401)  rf=r size=128 type=d align=32 words (r48.0)
//.declare P14 (402)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0376 (403)  rf=r size=128 type=d align=32 words (r44.0)
//.declare V0378 (405)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V0379 (406)  rf=r size=256 type=uq alias=V0378+0 align=32 words (r9.0)
//.declare P15 (407)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P16 (408)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0380 (409)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0381 (410)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (411)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0382 (412)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (413)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0384 (415)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0385 (416)  rf=r size=128 type=ud align=32 words (r7.0)
//.declare V0386 (417)  rf=r size=128 type=d alias=V0385+0 align=32 words (r7.0)
//.declare V0387 (418)  rf=r size=64 type=ud align=32 words (r9.0)
//.declare V0388 (419)  rf=r size=32 type=ud align=2 words (r4.8)
//.declare V0389 (420)  rf=r size=16 type=ud align=2 words (r10.0)
//.declare V0390 (421)  rf=r size=8 type=ud align=2 words (r6.11)
//.declare P17 (422)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P18 (423)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0391 (424)  rf=r size=8 type=d align=32 words (r16.0)
//.declare V0392 (425)  rf=r size=8 type=d align=32 words (r14.0)
//.declare V0393 (426)  rf=r size=2 type=w align=1 words (r14.6)
//.declare V0394 (427)  rf=r size=4 type=d align=2 words (r14.2)
//.declare V0395 (428)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0396 (429)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0397 (430)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0398 (431)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0399 (432)  rf=r size=4 type=ud alias=V0347+0 align=2 words (r61.13)
//.declare V0400 (433)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0401 (434)  rf=r size=4 type=ud alias=V0400+0 align=2 words (r3.2)
//.declare V0402 (435)  rf=r size=4 type=d alias=+0 align=2 words (r4.8)
//.declare V0403 (436)  rf=r size=4 type=f align=2 words (r4.1)
//.declare V0404 (437)  rf=r size=4 type=ud alias=V0397+0 align=2 words (r3.1)
//.declare V0405 (438)  rf=r size=4 type=f align=2 words (r4.3)
//.declare V0406 (439)  rf=r size=4 type=f align=2 words (r6.11)
//.declare V0407 (440)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0408 (441)  rf=r size=4 type=d align=2 words (r6.13)
//.declare V0409 (442)  rf=r size=4 type=ud alias=V0408+0 align=2 words (r6.13)
//.declare V0410 (443)  rf=r size=4 type=d alias=+4 align=2 words (r4.9)
//.declare V0411 (444)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0412 (445)  rf=r size=4 type=ud alias=V0411+0 align=2 words (r2.0)
//.declare V0413 (446)  rf=r size=4 type=f alias=+0 align=2 words (r2.4)
//.declare V0414 (447)  rf=r size=4 type=ud alias=V0402+0 align=2 words (r4.8)
//.declare V0415 (448)  rf=r size=4 type=f alias=+4 align=2 words (r2.5)
//.declare V0416 (449)  rf=r size=4 type=ud alias=V0410+0 align=2 words (r4.9)
//.declare V0417 (450)  rf=r size=4 type=f align=2 words (r9.0)
//.declare V0419 (452)  rf=r size=4 type=f align=2 words (r2.1)
//.declare V0421 (454)  rf=r size=4 type=f align=2 words (r3.2)
//.declare V0422 (455)  rf=r size=4 type=f align=2 words (r8.0)
//.declare V0423 (456)  rf=r size=4 type=f align=2 words (r10.0)
//.declare V0424 (457)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V0425 (458)  rf=r size=4 type=ud alias=V0424+0 align=2 words (r7.0)
//.declare V0426 (459)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0427 (460)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0428 (461)  rf=r size=4 type=d align=2 words (r13.0)
//.declare P19 (462)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare V0429 (463)  rf=r size=4 type=ud alias=V0428+0 align=2 words (r13.0)
//.declare V0430 (464)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0431 (465)  rf=r size=4 type=d align=2 words (r9.0)
//.declare V0432 (466)  rf=r size=2 type=b align=1 words (r2.0)
//.declare V0433 (467)  rf=r size=4 type=d align=2 words (r14.2)
//.declare V0434 (468)  rf=r size=2 type=ub alias=V0432+0 align=1 words (r2.0)
//.declare P20 (469)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0435 (470)  rf=r size=8 type=d align=2 words (r61.1)
//.declare V0436 (471)  rf=r size=8 type=d align=2 words (r61.3)
//.declare V0437 (472)  rf=r size=4 type=d align=2 words (r61.9)
//.declare V0438 (473)  rf=r size=4 type=d align=2 words (r14.3)
//.declare V0439 (474)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0440 (475)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0441 (476)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0442 (477)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0443 (478)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0444 (479)  rf=r size=4 type=ud alias=V0443+0 align=2 words (r3.2)
//.declare V0445 (480)  rf=r size=4 type=d alias=+0 align=2 words (r4.8)
//.declare V0446 (481)  rf=r size=4 type=f align=2 words (r4.1)
//.declare V0447 (482)  rf=r size=4 type=ud alias=V0441+0 align=2 words (r3.1)
//.declare V0448 (483)  rf=r size=4 type=f align=2 words (r4.3)
//.declare V0449 (484)  rf=r size=4 type=f align=2 words (r6.11)
//.declare V0450 (485)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0451 (486)  rf=r size=4 type=d align=2 words (r6.13)
//.declare V0452 (487)  rf=r size=4 type=ud alias=V0451+0 align=2 words (r6.13)
//.declare V0453 (488)  rf=r size=4 type=d alias=+4 align=2 words (r4.9)
//.declare V0454 (489)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0455 (490)  rf=r size=4 type=ud alias=V0454+0 align=2 words (r2.0)
//.declare V0456 (491)  rf=r size=4 type=f alias=+0 align=2 words (r2.4)
//.declare V0457 (492)  rf=r size=4 type=ud alias=V0445+0 align=2 words (r4.8)
//.declare V0458 (493)  rf=r size=4 type=f alias=+4 align=2 words (r2.5)
//.declare V0459 (494)  rf=r size=4 type=ud alias=V0453+0 align=2 words (r4.9)
//.declare V0460 (495)  rf=r size=4 type=f align=2 words (r9.0)
//.declare V0462 (497)  rf=r size=4 type=f align=2 words (r2.1)
//.declare V0464 (499)  rf=r size=4 type=f align=2 words (r3.2)
//.declare V0465 (500)  rf=r size=4 type=f align=2 words (r8.0)
//.declare V0466 (501)  rf=r size=4 type=f align=2 words (r10.0)
//.declare V0467 (502)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V0468 (503)  rf=r size=4 type=ud alias=V0467+0 align=2 words (r7.0)
//.declare V0469 (504)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0470 (505)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0471 (506)  rf=r size=4 type=d align=2 words (r13.0)
//.declare P21 (507)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare V0472 (508)  rf=r size=4 type=ud alias=V0471+0 align=2 words (r13.0)
//.declare V0473 (509)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0474 (510)  rf=r size=4 type=d align=2 words (r9.0)
//.declare V0475 (511)  rf=r size=4 type=uw alias=V0433+0 align=2 words (r14.4)
//.declare V0476 (512)  rf=r size=2 type=uw align=1 words (r2.0)
//.declare A0 (513)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare V0478 (515)  rf=r size=2 type=uw align=1 words (r3.0)
//.declare A1 (516)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare V0479 (517)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0480 (518)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0481 (519)  rf=r size=128 type=ud alias=V0479+0 align=32 words (r10.0)
//.declare V0482 (520)  rf=r size=128 type=ud alias=V0374+0 align=32 words (r40.0)
//.declare V0483 (521)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0485 (523)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P22 (531)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0495 (534)  rf=r size=8 type=q align=4 words (r4.0)
//.declare V0496 (535)  rf=r size=8 type=q align=32 words (r114.0)
//.declare V0497 (536)  rf=r size=8 type=uq alias=V0496+0 align=32 words (r114.0)
//.declare V0499 (538)  rf=r size=4 type=d alias=+0 align=2 words (r2.0)
//.declare P23 (539)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0502 (542)  rf=r size=8 type=q align=4 words (r2.1)
//.declare V0503 (543)  rf=r size=8 type=q align=32 words (r112.0)
//.declare V0504 (544)  rf=r size=8 type=uq alias=V0503+0 align=32 words (r112.0)
//.declare V0506 (546)  rf=r size=4 type=d alias=+4 align=2 words (r2.1)
//.declare V0508 (548)  rf=r size=8 type=q alias=+0 align=4 words (r6.6)
//.declare V0510 (550)  rf=r size=8 type=q alias=+8 align=4 words (r6.7)
//.declare V0511 (551)  rf=r size=128 type=d align=32 words (r42.0)
//.declare V0512 (552)  rf=r size=64 type=w align=32 words (r100.0)
//.declare V0513 (553)  rf=r size=64 type=w align=32 words (r102.0)
//.declare V0514 (554)  rf=r size=64 type=w align=32 words (r96.0)
//.declare V0515 (555)  rf=r size=64 type=w align=32 words (r98.0)
//.declare V0516 (556)  rf=r size=64 type=w align=32 words (r30.0)
//.declare V0517 (557)  rf=r size=64 type=w align=32 words (r32.0)
//.declare V0518 (558)  rf=r size=128 type=d align=32 words (r34.0)
//.declare V0520 (560)  rf=r size=128 type=ud alias=V0511+0 align=32 words (r42.0)
//.declare V0522 (562)  rf=r size=256 type=q align=32 words (r14.0)
//.declare V0523 (563)  rf=r size=256 type=uq alias=V0522+0 align=32 words (r14.0)
//.declare V0524 (564)  rf=r size=512 type=d align=32 words (r18.0)
//.declare V0528 (568)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0530 (570)  rf=r size=128 type=ud alias=V0528+0 align=32 words (r26.0)
//.declare V0531 (571)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0533 (573)  rf=r size=128 type=ud alias=V0531+0 align=32 words (r28.0)
//.declare V0534 (574)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0536 (576)  rf=r size=128 type=ud alias=V0534+0 align=32 words (r2.0)
//.declare V0538 (578)  rf=r size=64 type=w align=32 words (r101.0)
//.declare V0539 (579)  rf=r size=64 type=w align=32 words (r103.0)
//.declare V0540 (580)  rf=r size=64 type=w align=32 words (r97.0)
//.declare V0541 (581)  rf=r size=64 type=w align=32 words (r99.0)
//.declare V0542 (582)  rf=r size=64 type=w align=32 words (r31.0)
//.declare V0543 (583)  rf=r size=64 type=w align=32 words (r33.0)
//.declare V0544 (584)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0546 (586)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V0547 (587)  rf=r size=256 type=uq alias=V0546+0 align=32 words (r9.0)
//.declare V0548 (588)  rf=r size=512 type=d align=32 words (r14.0)
//.declare V0552 (592)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0554 (594)  rf=r size=128 type=ud alias=V0552+0 align=32 words (r22.0)
//.declare V0555 (595)  rf=r size=128 type=d align=32 words (r24.0)
//.declare V0557 (597)  rf=r size=128 type=ud alias=V0555+0 align=32 words (r24.0)
//.declare V0558 (598)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0560 (600)  rf=r size=128 type=ud alias=V0558+0 align=32 words (r26.0)
//.declare V0561 (601)  rf=r size=8 type=q align=32 words (r2.0)
//.declare V0562 (602)  rf=r size=8 type=q align=4 words (r3.0)
//.declare V0566 (606)  rf=r size=256 type=uq align=32 words (r7.0)
//.declare V0567 (607)  rf=r size=512 type=d align=32 words (r12.0)
//.declare V0569 (609)  rf=r size=512 type=w alias=V0567+0 align=32 words (r12.0)
//.declare V0570 (610)  rf=r size=8 type=q align=32 words (r2.0)
//.declare V0571 (611)  rf=r size=8 type=q align=4 words (r3.0)
//.declare V0574 (614)  rf=r size=256 type=uq align=32 words (r7.0)
//.declare V0575 (615)  rf=r size=512 type=d align=32 words (r12.0)
//.declare V0577 (617)  rf=r size=512 type=w alias=V0575+0 align=32 words (r12.0)
//.declare V0579 (619)  rf=r size=64 type=bf alias=V0513+0 align=32 words (r102.0)
//.declare V0581 (621)  rf=r size=64 type=bf alias=V0539+0 align=32 words (r103.0)
//.declare V0582 (622)  rf=r size=128 type=f align=32 words (r16.0)
//.declare V0584 (624)  rf=r size=64 type=bf alias=V0512+0 align=32 words (r100.0)
//.declare V0586 (626)  rf=r size=64 type=bf alias=V0538+0 align=32 words (r101.0)
//.declare V0587 (627)  rf=r size=128 type=f align=32 words (r14.0)
//.declare V0589 (629)  rf=r size=64 type=bf alias=V0515+0 align=32 words (r98.0)
//.declare V0591 (631)  rf=r size=64 type=bf alias=V0541+0 align=32 words (r99.0)
//.declare V0592 (632)  rf=r size=128 type=f align=32 words (r20.0)
//.declare V0594 (634)  rf=r size=64 type=bf alias=V0514+0 align=32 words (r96.0)
//.declare V0596 (636)  rf=r size=64 type=bf alias=V0540+0 align=32 words (r97.0)
//.declare V0597 (637)  rf=r size=128 type=f align=32 words (r22.0)
//.declare V0599 (639)  rf=r size=64 type=bf alias=V0517+0 align=32 words (r32.0)
//.declare V0601 (641)  rf=r size=64 type=bf alias=V0543+0 align=32 words (r33.0)
//.declare V0602 (642)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0604 (644)  rf=r size=64 type=bf alias=V0516+0 align=32 words (r30.0)
//.declare V0606 (646)  rf=r size=64 type=bf alias=V0542+0 align=32 words (r31.0)
//.declare V0607 (647)  rf=r size=128 type=f align=32 words (r32.0)
//.declare V0608 (648)  rf=r size=64 type=w align=32 words (r2.0)
//.declare V0610 (650)  rf=r size=64 type=bf alias=V0608+0 align=32 words (r2.0)
//.declare V0611 (651)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0613 (653)  rf=r size=64 type=bf alias=V0611+0 align=32 words (r3.0)
//.declare V0614 (654)  rf=r size=128 type=f align=32 words (r30.0)
//.declare V0615 (655)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0616 (656)  rf=r size=128 type=ud alias=V0518+0 align=32 words (r34.0)
//.declare V0617 (657)  rf=r size=128 type=ud alias=V0615+0 align=32 words (r8.0)
//.declare V0618 (658)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0620 (660)  rf=r size=64 type=bf alias=V0618+0 align=32 words (r7.0)
//.declare V0621 (661)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0622 (662)  rf=r size=128 type=ud alias=V0544+0 align=32 words (r28.0)
//.declare V0623 (663)  rf=r size=128 type=ud alias=V0621+0 align=32 words (r10.0)
//.declare V0624 (664)  rf=r size=64 type=w align=32 words (r12.0)
//.declare V0626 (666)  rf=r size=64 type=bf alias=V0624+0 align=32 words (r12.0)
//.declare V0627 (667)  rf=r size=128 type=f align=32 words (r28.0)
//.declare V0629 (669)  rf=r size=64 type=bf alias=V0371+0 align=32 words (r62.0)
//.declare V0631 (671)  rf=r size=64 type=bf alias=V0370+0 align=32 words (r63.0)
//.declare V0633 (673)  rf=r size=64 type=bf alias=V0369+0 align=32 words (r64.0)
//.declare V0635 (675)  rf=r size=64 type=bf alias=V0368+0 align=32 words (r65.0)
//.declare V0637 (677)  rf=r size=64 type=bf alias=V0367+0 align=32 words (r66.0)
//.declare V0639 (679)  rf=r size=64 type=bf alias=V0366+0 align=32 words (r67.0)
//.declare V0641 (681)  rf=r size=64 type=bf alias=V0365+0 align=32 words (r68.0)
//.declare V0643 (683)  rf=r size=64 type=bf alias=V0364+0 align=32 words (r69.0)
//.declare V0645 (685)  rf=r size=64 type=bf alias=V0363+0 align=32 words (r70.0)
//.declare V0647 (687)  rf=r size=64 type=bf alias=V0362+0 align=32 words (r71.0)
//.declare V0649 (689)  rf=r size=64 type=bf alias=V0361+0 align=32 words (r72.0)
//.declare V0651 (691)  rf=r size=64 type=bf alias=V0360+0 align=32 words (r73.0)
//.declare V0653 (693)  rf=r size=64 type=bf alias=V0359+0 align=32 words (r74.0)
//.declare V0655 (695)  rf=r size=64 type=bf alias=V0358+0 align=32 words (r75.0)
//.declare V0657 (697)  rf=r size=64 type=bf alias=V0357+0 align=32 words (r76.0)
//.declare V0659 (699)  rf=r size=64 type=bf alias=V0356+0 align=32 words (r77.0)
//.declare V0660 (700)  rf=r size=64 type=w align=32 words (r2.0)
//.declare V0661 (701)  rf=r size=64 type=bf alias=V0660+0 align=32 words (r2.0)
//.declare V0662 (702)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0663 (703)  rf=r size=64 type=bf alias=V0662+0 align=32 words (r3.0)
//.declare V0664 (704)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0665 (705)  rf=r size=64 type=uw alias=V0662+0 align=32 words (r3.0)
//.declare V0666 (706)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0668 (708)  rf=r size=64 type=uw alias=V0660+0 align=32 words (r2.0)
//.declare V0669 (709)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0670 (710)  rf=r size=64 type=bf alias=V0669+0 align=32 words (r7.0)
//.declare V0671 (711)  rf=r size=64 type=w align=32 words (r20.0)
//.declare V0672 (712)  rf=r size=64 type=bf alias=V0671+0 align=32 words (r20.0)
//.declare V0673 (713)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0674 (714)  rf=r size=64 type=uw alias=V0671+0 align=32 words (r20.0)
//.declare V0675 (715)  rf=r size=128 type=d align=32 words (r24.0)
//.declare V0677 (717)  rf=r size=64 type=uw alias=V0669+0 align=32 words (r7.0)
//.declare V0678 (718)  rf=r size=64 type=w align=32 words (r21.0)
//.declare V0679 (719)  rf=r size=64 type=bf alias=V0678+0 align=32 words (r21.0)
//.declare V0680 (720)  rf=r size=64 type=w align=32 words (r26.0)
//.declare V0681 (721)  rf=r size=64 type=bf alias=V0680+0 align=32 words (r26.0)
//.declare V0682 (722)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0683 (723)  rf=r size=64 type=uw alias=V0680+0 align=32 words (r26.0)
//.declare V0684 (724)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0686 (726)  rf=r size=64 type=uw alias=V0678+0 align=32 words (r21.0)
//.declare V0687 (727)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0688 (728)  rf=r size=64 type=bf alias=V0687+0 align=32 words (r3.0)
//.declare V0689 (729)  rf=r size=64 type=w align=32 words (r27.0)
//.declare V0690 (730)  rf=r size=64 type=bf alias=V0689+0 align=32 words (r27.0)
//.declare V0691 (731)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0692 (732)  rf=r size=64 type=uw alias=V0689+0 align=32 words (r27.0)
//.declare V0693 (733)  rf=r size=128 type=d align=32 words (r24.0)
//.declare V0695 (735)  rf=r size=64 type=uw alias=V0687+0 align=32 words (r3.0)
//.declare V0697 (737)  rf=r size=256 type=q align=32 words (r32.0)
//.declare V0698 (738)  rf=r size=256 type=uq alias=V0697+0 align=32 words (r32.0)
//.declare V0699 (739)  rf=r size=128 type=f align=32 words (r8.0)
//.declare V0700 (740)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0701 (741)  rf=r size=256 type=q align=32 words (r36.0)
//.declare V0702 (742)  rf=r size=256 type=ud alias=V0701+0 align=32 words (r36.0)
//.declare V0703 (743)  rf=r size=8 type=ud alias=V0700+0 align=32 words (r4.0)
//.declare V0704 (744)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P24 (745)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P25 (746)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0705 (747)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0708 (750)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0709 (751)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0710 (752)  rf=r size=8 type=uq alias=V0709+0 align=32 words (r4.0)
//.declare V0711 (753)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V0713 (755)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0716 (758)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0719 (761)  rf=r size=256 type=uq align=32 words (r12.0)
//.declare P26 (762)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0722 (765)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0723 (766)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0724 (767)  rf=r size=8 type=uq alias=V0723+0 align=32 words (r4.0)
//.declare V0725 (768)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V0727 (770)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0730 (773)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0733 (776)  rf=r size=256 type=uq align=32 words (r12.0)
//.declare V0734 (777)  rf=r size=128 type=f align=32 words (r16.0)
//.declare V0738 (781)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0740 (783)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0745 (788)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V0746 (789)  rf=r size=256 type=uq alias=V0745+0 align=32 words (r22.0)
//.declare P27 (790)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0747 (791)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0748 (792)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0749 (793)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0750 (794)  rf=r size=128 type=d align=32 words (r10.0)
//.declare  (795)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0752 (797)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0753 (798)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P28 (799)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0754 (800)  rf=r size=128 type=ud alias=V0752+0 align=32 words (r2.0)
//.declare V0755 (801)  rf=r size=4 type=ud alias=V0308+0 align=2 words (r112.9)
//.declare P29 (802)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P30 (803)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0756 (804)  rf=r size=64 type=w align=32 words (r2.0)
//.declare P31 (805)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0760 (809)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0761 (810)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0762 (811)  rf=r size=128 type=ud alias=V0761+0 align=32 words (r8.0)
//.declare V0763 (812)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P32 (813)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0765 (815)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0766 (816)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0767 (817)  rf=r size=8 type=uq alias=V0766+0 align=32 words (r4.0)
//.declare V0768 (818)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V0769 (819)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0771 (821)  rf=r size=4 type=ud alias=V0769+0 align=2 words (r3.2)
//.declare V0772 (822)  rf=r size=8 type=q align=4 words (r6.6)
//.declare V0773 (823)  rf=r size=8 type=q align=4 words (r7.0)
//.declare V0775 (825)  rf=r size=256 type=q align=32 words (r14.0)
//.declare V0776 (826)  rf=r size=256 type=uq alias=V0775+0 align=32 words (r14.0)
//.declare V0777 (827)  rf=r size=4 type=d align=2 words (r12.0)
//.declare V0779 (829)  rf=r size=8 type=q align=4 words (r13.0)
//.declare V0780 (830)  rf=r size=256 type=q align=32 words (r7.0)
//.declare V0781 (831)  rf=r size=256 type=uq alias=V0780+0 align=32 words (r7.0)
//.declare V0785 (835)  rf=r size=4 type=d align=32 words (r6.0)
//.declare V0786 (836)  rf=r size=4 type=ud alias=V0785+0 align=32 words (r6.0)
//.declare V0790 (840)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0791 (841)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0792 (842)  rf=r size=128 type=ud alias=V0791+0 align=32 words (r20.0)
//.declare V0793 (843)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0794 (844)  rf=r size=4 type=d align=32 words (r2.0)
//.declare P33 (845)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0795 (846)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0796 (847)  rf=r size=4 type=d align=32 words (r4.0)
//.declare P34 (848)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0797 (849)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0798 (850)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P35 (851)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P36 (852)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0799 (853)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0800 (854)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0801 (855)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0803 (857)  rf=r size=128 type=ud alias=V0801+0 align=32 words (r8.0)
//.declare V0804 (858)  rf=r size=256 type=q align=32 words (r12.0)
//.declare V0805 (859)  rf=r size=256 type=uq alias=V0804+0 align=32 words (r12.0)
//.declare V0806 (860)  rf=r size=256 type=q align=32 words (r24.0)
//.declare V0807 (861)  rf=r size=4 type=d alias=+0 align=2 words (r61.4)
//.declare V0808 (862)  rf=r size=4 type=d alias=+4 align=2 words (r61.5)
//.declare V0809 (863)  rf=r size=4 type=d alias=+0 align=2 words (r4.0)
//.declare V0810 (864)  rf=r size=4 type=d alias=+4 align=2 words (r4.1)
//.declare V0811 (865)  rf=r size=4 type=d align=2 words (r4.3)
//.declare V0812 (866)  rf=r size=4 type=d align=32 words (r32.0)
//.declare V0813 (867)  rf=r size=4 type=d align=2 words (r32.2)
//.declare V0814 (868)  rf=r size=4 type=ud alias=V0812+0 align=2 words (r32.0)
//.declare V0815 (869)  rf=r size=4 type=ud alias=V0807+0 align=2 words (r61.4)
//.declare V0816 (870)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0818 (872)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0819 (873)  rf=r size=4 type=d align=2 words (r61.1)
//.declare V0820 (874)  rf=r size=4 type=d align=32 words (r38.0)
//.declare V0821 (875)  rf=r size=4 type=d align=2 words (r32.4)
//.declare V0822 (876)  rf=r size=4 type=ud alias=V0820+0 align=2 words (r38.0)
//.declare V0823 (877)  rf=r size=4 type=d align=32 words (r7.0)
//.declare V0825 (879)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0826 (880)  rf=r size=4 type=d align=32 words (r112.0)
//.declare V0827 (881)  rf=r size=4 type=d align=2 words (r32.1)
//.declare V0828 (882)  rf=r size=4 type=ud alias=V0826+0 align=2 words (r112.0)
//.declare V0829 (883)  rf=r size=4 type=ud alias=V0808+0 align=2 words (r61.5)
//.declare V0830 (884)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0832 (886)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0833 (887)  rf=r size=4 type=d align=32 words (r33.0)
//.declare V0834 (888)  rf=r size=4 type=d align=2 words (r32.3)
//.declare V0835 (889)  rf=r size=4 type=ud alias=V0833+0 align=2 words (r33.0)
//.declare V0836 (890)  rf=r size=4 type=d align=32 words (r7.0)
//.declare V0838 (892)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0839 (893)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0840 (894)  rf=r size=4 type=d align=32 words (r39.0)
//.declare V0841 (895)  rf=r size=4 type=d align=2 words (r32.5)
//.declare V0842 (896)  rf=r size=4 type=ud alias=V0840+0 align=2 words (r39.0)
//.declare V0843 (897)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0845 (899)  rf=r size=4 type=d align=32 words (r3.0)
//.declare P37 (900)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0846 (901)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0847 (902)  rf=r size=8 type=q alias=V0041+0 align=32 words (r5.6)
//.declare V0849 (904)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0850 (905)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0851 (906)  rf=r size=8 type=uq alias=V0850+0 align=32 words (r4.0)
//.declare V0852 (907)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0853 (908)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0854 (909)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0855 (910)  rf=r size=8 type=q alias=V0042+0 align=32 words (r5.7)
//.declare V0858 (913)  rf=r size=256 type=q align=32 words (r7.0)
//.declare V0859 (914)  rf=r size=256 type=uq alias=V0858+0 align=32 words (r7.0)
//.declare V0860 (915)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0861 (916)  rf=r size=4 type=d align=2 words (r4.0)
//.declare P38 (917)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0862 (918)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0863 (919)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0864 (920)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0867 (923)  rf=r size=256 type=q align=32 words (r18.0)
//.declare V0868 (924)  rf=r size=256 type=uq alias=V0867+0 align=32 words (r18.0)
//.declare V0869 (925)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0870 (926)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0871 (927)  rf=r size=128 type=d align=32 words (r88.0)
//.declare P39 (928)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0872 (929)  rf=r size=128 type=d align=32 words (r92.0)
//.declare V0873 (930)  rf=r size=128 type=ud alias=V0872+0 align=32 words (r92.0)
//.declare V0875 (932)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0877 (934)  rf=r size=8 type=q align=4 words (r2.1)
//.declare V0878 (935)  rf=r size=256 type=q align=32 words (r34.0)
//.declare V0879 (936)  rf=r size=256 type=uq alias=V0878+0 align=32 words (r34.0)
//.declare V0881 (938)  rf=r size=256 type=q align=32 words (r94.0)
//.declare V0882 (939)  rf=r size=256 type=uq alias=V0881+0 align=32 words (r94.0)
//.declare V0885 (942)  rf=r size=8 type=q alias=+0 align=4 words (r3.0)
//.declare V0886 (943)  rf=r size=8 type=d alias=V0885+0 align=4 words (r3.0)
//.declare V0888 (945)  rf=r size=8 type=q alias=+0 align=4 words (r3.2)
//.declare V0889 (946)  rf=r size=8 type=d alias=V0888+0 align=4 words (r3.4)
//.declare V0891 (948)  rf=r size=8 type=q alias=+8 align=4 words (r3.1)
//.declare V0892 (949)  rf=r size=8 type=d alias=V0891+0 align=4 words (r3.2)
//.declare V0894 (951)  rf=r size=8 type=q alias=+8 align=4 words (r3.3)
//.declare V0895 (952)  rf=r size=8 type=d alias=V0894+0 align=4 words (r3.6)
//.declare V0896 (953)  rf=r size=8 type=q alias=+0 align=4 words (r3.4)
//.declare V0897 (954)  rf=r size=8 type=q alias=+8 align=4 words (r3.5)
//.declare V0900 (957)  rf=r size=8 type=q alias=+0 align=4 words (r2.0)
//.declare V0901 (958)  rf=r size=8 type=q alias=+8 align=4 words (r2.1)
//.declare V0905 (962)  rf=r size=8 type=q align=4 words (r4.0)
//.declare V0906 (963)  rf=r size=8 type=d alias=V0905+0 align=4 words (r4.0)
//.declare V0907 (964)  rf=r size=8 type=q align=4 words (r6.6)
//.declare V0909 (966)  rf=r size=128 type=d align=32 words (r90.0)
//.declare V0910 (967)  rf=r size=64 type=w align=32 words (r98.0)
//.declare P40 (968)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P41 (969)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare V0911 (970)  rf=r size=8 type=q alias=V0037+0 align=32 words (r5.2)
//.declare V0915 (974)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P42 (980)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P43 (981)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0921 (982)  rf=r size=4 type=d align=2 words (r5.1)
//.declare V0922 (983)  rf=r size=8 type=q alias=V0036+0 align=32 words (r5.1)
//.declare V0923 (984)  rf=r size=8 type=q alias=V0040+0 align=32 words (r5.5)
//.declare P44 (985)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0925 (987)  rf=r size=128 type=d align=32 words (r42.0)
//.declare V0926 (988)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0927 (989)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0928 (990)  rf=r size=128 type=d align=32 words (r40.0)
//.declare P45 (991)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0929 (992)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0930 (993)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P46 (994)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P47 (995)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0933 (998)  rf=r size=128 type=d align=32 words (r38.0)
//.declare V0934 (999)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0935 (1000)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0936 (1001)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0937 (1002)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0938 (1003)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0939 (1004)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0940 (1005)  rf=r size=4 type=ud alias=V0921+0 align=2 words (r5.1)
//.declare V0941 (1006)  rf=r size=4 type=d align=2 words (r4.1)
//.declare V0942 (1007)  rf=r size=4 type=ud alias=V0941+0 align=2 words (r4.1)
//.declare V0943 (1008)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0944 (1009)  rf=r size=128 type=f align=32 words (r14.0)
//.declare V0945 (1010)  rf=r size=128 type=ud alias=V0938+0 align=32 words (r12.0)
//.declare V0946 (1011)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0947 (1012)  rf=r size=4 type=f align=2 words (r16.0)
//.declare V0948 (1013)  rf=r size=128 type=f align=32 words (r18.0)
//.declare V0949 (1014)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0950 (1015)  rf=r size=128 type=ud alias=V0949+0 align=32 words (r2.0)
//.declare V0951 (1016)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0952 (1017)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0953 (1018)  rf=r size=128 type=ud alias=V0952+0 align=32 words (r10.0)
//.declare V0954 (1019)  rf=r size=4 type=f align=2 words (r16.1)
//.declare V0955 (1020)  rf=r size=4 type=ud alias=V0943+0 align=2 words (r6.11)
//.declare V0956 (1021)  rf=r size=128 type=f align=32 words (r22.0)
//.declare V0957 (1022)  rf=r size=128 type=ud alias=V0951+0 align=32 words (r20.0)
//.declare V0958 (1023)  rf=r size=128 type=f align=32 words (r24.0)
//.declare V0964 (1029)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0965 (1030)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0966 (1031)  rf=r size=128 type=ud alias=V0965+0 align=32 words (r28.0)
//.declare V0967 (1032)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0968 (1033)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0969 (1034)  rf=r size=128 type=d align=32 words (r14.0)
//.declare P48 (1035)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0970 (1036)  rf=r size=128 type=ud alias=V0969+0 align=32 words (r14.0)
//.declare V0971 (1037)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0972 (1038)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0974 (1040)  rf=r size=128 type=ud alias=V0933+0 align=32 words (r38.0)
//.declare V0978 (1044)  rf=r size=128 type=d align=32 words (r32.0)
//.declare V0979 (1045)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0980 (1046)  rf=r size=128 type=d align=32 words (r16.0)
//.declare V0981 (1047)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0982 (1048)  rf=r size=128 type=ud alias=V0980+0 align=32 words (r16.0)
//.declare V0983 (1049)  rf=r size=128 type=ud alias=V0978+0 align=32 words (r32.0)
//.declare V0984 (1050)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0986 (1052)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0987 (1053)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0996 (1062)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0998 (1064)  rf=r size=128 type=ud alias=V0996+0 align=32 words (r26.0)
//.declare V1002 (1068)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V1003 (1069)  rf=r size=256 type=uq alias=V1002+0 align=32 words (r22.0)
//.declare V1005 (1071)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V1006 (1072)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V1008 (1074)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V1009 (1075)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P49 (1077)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V1011 (1078)  rf=r size=128 type=ud alias=V1005+0 align=32 words (r18.0)
//.declare V1012 (1079)  rf=r size=128 type=ud alias=V1008+0 align=32 words (r2.0)
//.declare P50 (1080)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P51 (1081)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1013 (1082)  rf=r size=128 type=ud alias=V1006+0 align=32 words (r20.0)
//.declare V1014 (1083)  rf=r size=128 type=ud alias=V1009+0 align=32 words (r10.0)
//.declare V1015 (1084)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V1016 (1085)  rf=r size=128 type=d align=32 words (r16.0)
//.declare V1017 (1086)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V1018 (1087)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1019 (1088)  rf=r size=256 type=uq align=32 words (r10.0)
//.declare V1020 (1089)  rf=r size=256 type=q alias=V1019+0 align=32 words (r10.0)
//.declare V1021 (1090)  rf=r size=512 type=d align=32 words (r8.0)
//.declare V1022 (1091)  rf=r size=256 type=uq align=32 words (r16.0)
//.declare V1023 (1092)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P52 (1093)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P53 (1094)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1025 (1096)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V1026 (1097)  rf=r size=256 type=uq alias=V1025+0 align=32 words (r9.0)
//.declare V1027 (1098)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V1032 (1103)  rf=r size=256 type=uq align=32 words (r24.0)
//.declare V1036 (1107)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1038 (1109)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V1043 (1114)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V1044 (1115)  rf=r size=256 type=uq alias=V1043+0 align=32 words (r22.0)
//.declare V1045 (1116)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V1046 (1117)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V1047 (1118)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1052 (1123)  rf=r size=256 type=uq align=32 words (r30.0)
//.declare V1053 (1124)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P54 (1125)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1057 (1129)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1058 (1130)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1131)  rf=r size=64 type=ud align=32 words (r7.0)
//.declare  (1132)  rf=r size=64 type=ud align=32 words (r10.0)
//.declare P55 (1133)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1059 (1134)  rf=r size=128 type=ud alias=V1057+0 align=32 words (r8.0)
//.declare V1060 (1135)  rf=r size=128 type=ud alias=V0871+0 align=32 words (r88.0)
//.declare P56 (1136)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P57 (1137)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1138)  rf=r size=64 type=ud align=32 words (r2.0)
//.declare V1061 (1139)  rf=r size=4 type=ud align=2 words (r4.0)
//.declare  (1140)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare  (1141)  rf=r size=8 type=d align=8 words (r2.0)
//.declare  (1142)  rf=r size=8 type=d align=8 words (r112.4)
//.declare  (1143)  rf=r size=8 type=f align=8 words (r4.0)
//.declare  (1144)  rf=r size=8 type=ud align=8 words (r7.0)
//.declare  (1145)  rf=r size=8 type=f align=8 words (r2.4)
//.declare  (1146)  rf=r size=8 type=ud align=8 words (r4.8)
//.declare  (1147)  rf=r size=8 type=f align=8 words (r2.4)
//.declare  (1148)  rf=r size=8 type=ud align=8 words (r4.8)
//.declare  (1149)  rf=r size=16 type=q align=8 words (r6.6)
//.declare  (1150)  rf=r size=8 type=d align=32 words (r2.0)
//.declare  (1151)  rf=r size=8 type=d align=8 words (r4.0)
//.declare  (1152)  rf=r size=8 type=d align=8 words (r61.4)
//.declare  (1153)  rf=r size=16 type=q align=8 words (r3.4)
//.declare  (1154)  rf=r size=16 type=q align=8 words (r3.2)
//.declare  (1155)  rf=r size=16 type=q align=8 words (r2.0)
//.declare  (1156)  rf=r size=16 type=q align=8 words (r3.0)
//.declare  (1157)  rf=r size=128 type=uw align=32 words (r2.0)
//.declare  (1158)  rf=r size=128 type=uw align=32 words (r7.0)
//.declare  (1159)  rf=r size=4 type=d align=2 words (r3.0)
//.declare  (1160)  rf=r size=4 type=f align=2 words (r7.3)
//.declare  (1161)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1162)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1163)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1164)  rf=r size=4 type=d align=2 words (r11.1)
//.declare  (1165)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1166)  rf=r size=4 type=d align=2 words (r11.1)
//.declare  (1167)  rf=r size=4 type=d align=32 words (r3.0)
//.declare  (1168)  rf=r size=128 type=w alias=V0524+0 align=32 words (r18.0)
//.declare  (1169)  rf=r size=128 type=w alias=V0528+0 align=32 words (r26.0)
//.declare  (1170)  rf=r size=128 type=w alias=V0524+0 align=32 words (r18.0)
//.declare  (1171)  rf=r size=128 type=w alias=V0531+0 align=32 words (r28.0)
//.declare  (1172)  rf=r size=128 type=w alias=V0524+0 align=32 words (r18.0)
//.declare  (1173)  rf=r size=128 type=w alias=V0534+0 align=32 words (r2.0)
//.declare  (1174)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1175)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1176)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1177)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1178)  rf=r size=128 type=w alias=V0548+0 align=32 words (r14.0)
//.declare  (1179)  rf=r size=128 type=w alias=V0552+0 align=32 words (r22.0)
//.declare  (1180)  rf=r size=128 type=w alias=V0548+0 align=32 words (r14.0)
//.declare  (1181)  rf=r size=128 type=w alias=V0555+0 align=32 words (r24.0)
//.declare  (1182)  rf=r size=128 type=w alias=V0548+0 align=32 words (r14.0)
//.declare  (1183)  rf=r size=128 type=w alias=V0558+0 align=32 words (r26.0)
//.declare  (1184)  rf=r size=128 type=w alias=V0518+0 align=32 words (r34.0)
//.declare  (1185)  rf=r size=128 type=w alias=V0544+0 align=32 words (r28.0)
//.declare  (1186)  rf=r size=128 type=w alias=V0615+0 align=32 words (r8.0)
//.declare  (1187)  rf=r size=128 type=w alias=V0621+0 align=32 words (r10.0)
//.declare  (1188)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1189)  rf=r size=128 type=ud align=32 words (r16.0)
//.declare  (1190)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1191)  rf=r size=128 type=ud align=32 words (r14.0)
//.declare  (1192)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1193)  rf=r size=128 type=ud align=32 words (r14.0)
//.declare  (1194)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1195)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1198)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1199)  rf=r size=4 type=d align=2 words (r2.0)
//.declare  (1201)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1202)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1203)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1204)  rf=r size=128 type=ud align=32 words (r12.0)
//.declare  (1205)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1206)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1207)  rf=r size=128 type=ud align=32 words (r16.0)
//.declare  (1208)  rf=r size=128 type=ud align=32 words (r20.0)
//.declare  (1209)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1210)  rf=r size=128 type=ud align=32 words (r12.0)
//.declare  (1211)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1212)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1213)  rf=r size=128 type=q align=32 words (r52.0)
//.declare  (1214)  rf=r size=128 type=q align=32 words (r110.0)
//.declare  (1215)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1216)  rf=r size=128 type=d align=32 words (r8.0)
//.declare  (1217)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1218)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1219)  rf=r size=128 type=q align=32 words (r88.0)
//.declare  (1220)  rf=r size=128 type=q align=32 words (r86.0)
//.declare  (1221)  rf=r size=128 type=q align=32 words (r106.0)
//.declare  (1222)  rf=r size=128 type=q align=32 words (r104.0)
//.declare  (1223)  rf=r size=128 type=q align=32 words (r94.0)
//.declare  (1224)  rf=r size=128 type=q align=32 words (r92.0)
//.declare  (1225)  rf=r size=128 type=q align=32 words (r52.0)
//.declare  (1226)  rf=r size=128 type=q align=32 words (r50.0)
//.declare  (1229)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1230)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1231)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1232)  rf=r size=128 type=d align=32 words (r8.0)
//.declare  (1233)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1234)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1235)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1236)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1237)  rf=r size=128 type=q align=32 words (r82.0)
//.declare  (1238)  rf=r size=128 type=q align=32 words (r80.0)
//.declare  (1239)  rf=r size=128 type=q align=32 words (r78.0)
//.declare  (1240)  rf=r size=128 type=q align=32 words (r58.0)
//.declare  (1241)  rf=r size=128 type=q align=32 words (r56.0)
//.declare  (1242)  rf=r size=128 type=q align=32 words (r54.0)
//.declare  (1245)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1246)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1247)  rf=r size=128 type=q align=32 words (r38.0)
//.declare  (1248)  rf=r size=128 type=q align=32 words (r36.0)
//.declare  (1249)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1250)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1251)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1252)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1257)  rf=r size=128 type=q align=32 words (r28.0)
//.declare  (1258)  rf=r size=128 type=q align=32 words (r30.0)
//.declare  (1259)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1260)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1263)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1264)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1267)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1268)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1269)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1270)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1271)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1272)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1275)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1276)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1281)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1282)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1285)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1286)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1287)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1288)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1289)  rf=r size=128 type=q align=32 words (r11.0)
//.declare  (1290)  rf=r size=128 type=q align=32 words (r13.0)
//.declare  (1291)  rf=r size=128 type=q align=32 words (r86.0)
//.declare  (1292)  rf=r size=128 type=q align=32 words (r84.0)
//.declare  (1293)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1294)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1295)  rf=r size=128 type=q align=32 words (r82.0)
//.declare  (1296)  rf=r size=128 type=q align=32 words (r80.0)
//.declare  (1297)  rf=r size=128 type=q align=32 words (r15.0)
//.declare  (1298)  rf=r size=128 type=q align=32 words (r17.0)
//.declare  (1299)  rf=r size=128 type=q align=32 words (r78.0)
//.declare  (1300)  rf=r size=128 type=q align=32 words (r68.0)
//.declare  (1301)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1302)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1303)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1304)  rf=r size=128 type=d align=32 words (r14.0)
//.declare  (1305)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1306)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1307)  rf=r size=128 type=q align=32 words (r66.0)
//.declare  (1308)  rf=r size=128 type=q align=32 words (r44.0)
//.declare  (1309)  rf=r size=128 type=q align=32 words (r54.0)
//.declare  (1310)  rf=r size=128 type=q align=32 words (r52.0)
//.declare  (1311)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1312)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1313)  rf=r size=128 type=q align=32 words (r50.0)
//.declare  (1314)  rf=r size=128 type=q align=32 words (r48.0)
//.declare  (1315)  rf=r size=128 type=q align=32 words (r64.0)
//.declare  (1316)  rf=r size=128 type=q align=32 words (r62.0)
//.declare  (1317)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1318)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1323)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1324)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1325)  rf=r size=128 type=q align=32 words (r58.0)
//.declare  (1326)  rf=r size=128 type=q align=32 words (r56.0)
//.declare  (1327)  rf=r size=128 type=d align=32 words (r16.0)
//.declare  (1328)  rf=r size=128 type=d align=32 words (r18.0)
//.declare  (1329)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1330)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1331)  rf=r size=128 type=q align=32 words (r24.0)
//.declare  (1332)  rf=r size=128 type=q align=32 words (r26.0)
//.declare  (1333)  rf=r size=128 type=q align=32 words (r70.0)
//.declare  (1334)  rf=r size=128 type=q align=32 words (r72.0)
//.declare  (1337)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1338)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1339)  rf=r size=128 type=q align=32 words (r76.0)
//.declare  (1340)  rf=r size=128 type=q align=32 words (r74.0)
//.declare  (1341)  rf=r size=128 type=uq align=32 words (r14.0)
//.declare  (1342)  rf=r size=128 type=uq align=32 words (r16.0)
//.declare  (1343)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1344)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1347)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1348)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1351)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1352)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1353)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1354)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1355)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1356)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1359)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1360)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1367)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1368)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1369)  rf=r size=128 type=d alias=+0 align=32 words (r52.0)
//.declare  (1370)  rf=r size=128 type=d alias=+0 align=32 words (r50.0)
//.declare  (1371)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1372)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1373)  rf=r size=128 type=ud alias=+0 align=32 words (r2.0)
//.declare  (1374)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1375)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1376)  rf=r size=128 type=d alias=+0 align=32 words (r2.0)
//.declare  (1377)  rf=r size=128 type=d alias=+0 align=32 words (r7.0)
//.declare  (1378)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1379)  rf=r size=128 type=d alias=+0 align=32 words (r18.0)
//.declare  (1380)  rf=r size=128 type=d alias=+0 align=32 words (r54.0)
//.declare  (1381)  rf=r size=128 type=d alias=+0 align=32 words (r52.0)
//.declare  (1382)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1383)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1384)  rf=r size=128 type=d alias=+0 align=32 words (r20.0)
//.declare  (1385)  rf=r size=128 type=d alias=+0 align=32 words (r22.0)
//.declare  (1386)  rf=r size=128 type=d alias=+0 align=32 words (r76.0)
//.declare  (1387)  rf=r size=128 type=d alias=+0 align=32 words (r74.0)
//.declare  (1388)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1389)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1390)  rf=r size=128 type=uq alias=+0 align=32 words (r76.0)
//.declare  (1391)  rf=r size=128 type=uq alias=+0 align=32 words (r74.0)
//.declare  (1392)  rf=r size=128 type=ud alias=+0 align=32 words (r2.0)
//.declare  (1393)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1394)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1395)  rf=r size=4 type=uw align=2 words (r61.22)
//.declare  (1396)  rf=r size=4 type=uw align=2 words (r112.14)
//.declare  (1397)  rf=r size=4 type=uw align=2 words (r5.0)
//.declare  (1398)  rf=r size=4 type=uw align=2 words (r112.24)
//.declare  (1399)  rf=r size=4 type=uw align=2 words (r112.22)
//.declare  (1400)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1401)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1402)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1403)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1404)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1405)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1406)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1407)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1408)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1409)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1410)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1411)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1412)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1413)  rf=r size=64 type=d align=32 words (r2.0)
//.declare  (1414)  rf=r size=64 type=d align=32 words (r3.0)
//.declare  (1415)  rf=r size=64 type=d align=32 words (r4.0)
//.declare  (1416)  rf=r size=64 type=d align=32 words (r6.0)
//.declare  (1417)  rf=r size=64 type=d align=32 words (r7.0)
//.declare  (1418)  rf=r size=64 type=d align=32 words (r8.0)
//.declare  (1419)  rf=r size=64 type=d align=32 words (r9.0)
//.declare  (1420)  rf=r size=64 type=d align=32 words (r10.0)
//.declare  (1421)  rf=r size=64 type=d align=32 words (r11.0)
//.declare  (1422)  rf=r size=64 type=d align=32 words (r12.0)
//.declare  (1423)  rf=r size=64 type=d align=32 words (r13.0)
//.declare  (1424)  rf=r size=64 type=d align=32 words (r14.0)
//.declare  (1425)  rf=r size=64 type=d align=32 words (r15.0)
//.declare  (1426)  rf=r size=64 type=d align=32 words (r16.0)
//.declare  (1427)  rf=r size=64 type=d align=32 words (r17.0)
//.declare  (1428)  rf=r size=64 type=d align=32 words (r18.0)
//.declare  (1429)  rf=r size=64 type=d align=32 words (r19.0)
//.declare  (1430)  rf=r size=64 type=d align=32 words (r20.0)
//.declare  (1431)  rf=r size=64 type=d align=32 words (r21.0)
//.declare  (1432)  rf=r size=64 type=d align=32 words (r22.0)
//.declare  (1433)  rf=r size=64 type=d align=32 words (r23.0)
//.declare  (1434)  rf=r size=64 type=d align=32 words (r24.0)
//.declare  (1435)  rf=r size=64 type=d align=32 words (r25.0)
//.declare  (1436)  rf=r size=64 type=d align=32 words (r26.0)
//.declare  (1437)  rf=r size=64 type=d align=32 words (r27.0)
//.declare  (1438)  rf=r size=64 type=d align=32 words (r28.0)
//.declare  (1439)  rf=r size=64 type=d align=32 words (r29.0)
//.declare  (1440)  rf=r size=64 type=d align=32 words (r30.0)
//.declare  (1441)  rf=r size=64 type=d align=32 words (r31.0)
//.declare  (1442)  rf=r size=64 type=d align=32 words (r32.0)
//.declare  (1443)  rf=r size=64 type=d align=32 words (r33.0)
//.declare  (1444)  rf=r size=64 type=d align=32 words (r34.0)
//.declare  (1445)  rf=r size=64 type=d align=32 words (r35.0)
//.declare  (1446)  rf=r size=64 type=d align=32 words (r36.0)
//.declare  (1447)  rf=r size=64 type=d align=32 words (r37.0)
//.declare  (1448)  rf=r size=64 type=d align=32 words (r38.0)
//.declare  (1449)  rf=r size=64 type=d align=32 words (r39.0)
//.declare r0 (1450)  rf=r size=64 type=ud align=32 words (r0.0)
//.declare rtmp (1451)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare inlineRegFromTDL (1452)  rf=r size=32 type=ud align=2 words (r1.0)
//.declare inlineRegExpectedLocation (1453)  rf=r size=32 type=ud align=2 words (r4.0)
//.declare  (1454)  rf=r size=128 type=ud align=32 words (r1.0)
//.declare  (1455)  rf=r size=64 type=ud align=32 words (r3.0)
//.declare  (1456)  rf=r size=128 type=ud align=32 words (r5.0)

// .inputs
// +----------+----------+--------+----------+------------------+
// | id       | type     |  bytes | at       | from             |
// +----------+----------+--------+----------+------------------+
// | V0057    | :w x 32  |   0x40 | r1       | pti[tid]+0x0     |
// | V0058    | :w x 32  |   0x40 | r2       | pti[tid]+0x40    |
// | V0059    | :w x 32  |   0x40 | r3       | pti[tid]+0x80    |
// | V1061    | :ud      |    0x4 | r4       | inline+0x0       |
// | V0052    | :ud      |    0x4 | r4+0x8   | inline+0x8       |
// | V0053    | :ud      |    0x4 | r4+0x10  | inline+0x10      |
// | V0034    | :uq      |    0x8 | r4+0x18  | inline+0x18      |
// | V0035    | :uq      |    0x8 | r5       | cti+0x20         |
// | V0036    | :uq      |    0x8 | r5+0x8   | cti+0x28         |
// | V0037    | :uq      |    0x8 | r5+0x10  | cti+0x30         |
// | V0038    | :uq      |    0x8 | r5+0x18  | cti+0x38         |
// | V0039    | :uq      |    0x8 | r5+0x20  | cti+0x40         |
// | V0040    | :uq      |    0x8 | r5+0x28  | cti+0x48         |
// | V0041    | :uq      |    0x8 | r5+0x30  | cti+0x50         |
// | V0042    | :uq      |    0x8 | r5+0x38  | cti+0x58         |
// | V0043    | :uq      |    0x8 | r6       | cti+0x60         |
// | V0047    | :uq      |    0x8 | r6+0x8   | cti+0x68         |
// | V0044    | :d       |    0x4 | r6+0x10  | cti+0x70         |
// | V0045    | :d       |    0x4 | r6+0x14  | cti+0x74         |
// | V0046    | :d       |    0x4 | r6+0x18  | cti+0x78         |
// | V0048    | :d       |    0x4 | r6+0x1C  | cti+0x7C         |
// | V0049    | :d       |    0x4 | r6+0x20  | cti+0x80         |
// | V0050    | :d       |    0x4 | r6+0x24  | cti+0x84         |
// | V0051    | :d       |    0x4 | r6+0x28  | cti+0x88         |
// | V0060    | :uq      |    0x8 | r6+0x30  | cti+0x90         |
// | V0061    | :uq      |    0x8 | r6+0x38  | cti+0x98         |
// +----------+----------+--------+----------+------------------+


// B000: Preds:{},  Succs:{B001}
per_thread_prolog:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                                                //  ALU pipe: int; 
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud                       //  ALU pipe: int; 
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw                             //  ALU pipe: int; 
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x80:ud              {I@2}          //  ALU pipe: int; 
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x0:ud              {I@1}           //  R_SYM_ADDR_32: __INTEL_PATCH_CROSS_THREAD_OFFSET_OFF_R0; ALU pipe: int; 
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0xC0:uw              {I@1} //  ALU pipe: int; 
(W)     mov (8|M0)               r4.0<1>:ud    r1.0<1;1,0>:ud                                        //  ALU pipe: int; 

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     load.ugm.d32x32t.a32.ca.cc (1|M0)  r1:2 bti[255][r127:1]   {A@1,$0} // ex_desc:0xFF000000; desc:0x6229E500 // 
(W)     load.ugm.d32x16t.a32.ca.cc (1|M0)  r3:1 bti[255][r127:1+0x80]  {$1} // ex_desc:0xFF080000; desc:0x6219D500 // 
        nop                                                                                          // 
        nop                                                                                          // 
        nop                                                                                          // 
// B001: Preds:{B000},  Succs:{B002}
// cross_thread_prolog:
        sync.nop                             null                             {Compacted,$1.src}     // 
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src} //  ALU pipe: int; 
(W)     add (1|M0)               r127.0<1>:ud  r127.0<0;1,0>:ud  0x0:ud              {I@1}           //  R_SYM_ADDR_32: __INTEL_PATCH_CROSS_THREAD_OFFSET_OFF_R0; ALU pipe: int; 
(W)     load.ugm.d32x32t.a32.ca.cc (1|M0)  r5:2 bti[255][r127:1]   {I@1,$2} // ex_desc:0xFF000000; desc:0x6229E500 // 
// B002: Preds:{B001},  Succs:{B003, B074}
// _main_0:
(W)     mov (16|M0)              r60.0<1>:ud   r0.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1
(W)     or (1|M0)                cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x400004C0:ud              {A@1}    // $1

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1129:  const bool is_sender = (sm_id % 2 == 0);
(W)     and (1|M0)               r6.11<1>:d    r60.1<0;1,0>:d    1:w               {A@1,$2.dst}      //  ALU pipe: int; $29
        mov (32|M0)              r40.0<1>:d    r1.0<1;1,0>:uw                   {$0.dst}             //  ALU pipe: int; $25

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     shr (1|M0)               r4.0<1>:ud    r6.8<0;1,0>:ud    31:w                                //  ALU pipe: int; $15

// Line 1129:  const bool is_sender = (sm_id % 2 == 0);
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.11<0;1,0>:d    0:w               {I@3}             //  ALU pipe: int; $30

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 156:  return __spirv_BuiltInLocalInvocationId.x;
        mov (16|M0)              r2.0<4>:uw    r1.0<1;1,0>:uw                   {$1.dst}             //  ALU pipe: int; $10
        mov (16|M16)             r7.0<4>:uw    r1.16<1;1,0>:uw                                       //  ALU pipe: int; $10

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        and (32|M0)              r46.0<1>:d    r40.0<1;1,0>:d    31:w               {Compacted,I@5}  //  ALU pipe: int; $26
        shr (32|M0)              r90.0<1>:ud   r40.0<1;1,0>:ud   5:w                                 //  ALU pipe: int; $27

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     add (1|M0)               r112.4<1>:d   r4.0<0;1,0>:d     r6.8<0;1,0>:d    {Compacted,I@6}    //  ALU pipe: int; $16

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 156:  return __spirv_BuiltInLocalInvocationId.x;
        mov (16|M0)              r52.0<1>:q    r2.0<4;1,0>:uw                   {I@5}                //  ALU pipe: int; $10
        mov (16|M16)             r110.0<1>:q   r7.0<4;1,0>:uw                   {I@5}                //  ALU pipe: int; $10

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1130:  const int responsible_channel = sm_id / 2;
(W)     shr (1|M0)               r112.10<1>:ud  r60.1<0;1,0>:ud  1:w                                 //  ALU pipe: int; $20

// Line 1133:  int hidden_int4 = hidden_ * sizeof(dtype_t) / sizeof(int4);
(W)     asr (1|M0)               r61.0<1>:d    r6.5<0;1,0>:d     3:w                                 //  ALU pipe: int; $23

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     asr (1|M0)               r112.6<1>:d   r112.4<0;1,0>:d   1:w               {I@5}             //  ALU pipe: int; $17

// Line 1139:  if (is_sender) {
(W&f2.0) jmpi                                _0_136                                                  //  ALU pipe: int; $32
// B003: Preds:{B002},  Succs:{B004, B005}
_0_137:
(W)     and (1|M0)               r2.0<1>:ud    msg0.0<0;1,0>:ud  0xFF:uw                             //  ALU pipe: int; $34
(W)     and (1|M0)               r2.1<1>:ud    sr0.0<0;1,0>:ud   0x7F:uw              {A@1}          //  ALU pipe: int; $35
(W)     and (1|M0)               r2.2<1>:ud    r2.1<0;1,0>:ud    7:w               {A@1}             //  ALU pipe: int; $37
(W)     asr (1|M0)               r2.3<1>:ud    r2.1<0;1,0>:ud    1:w                                 //  ALU pipe: int; $38
(W)     mov (1|M0)               r3.0<1>:d     -8:w                               {Compacted}        //  ALU pipe: int; $39
(W)     shl (1|M0)               r2.0<1>:ud    r2.0<0;1,0>:ud    0x6:uw              {Compacted}     //  ALU pipe: int; $36

// Line 1285:  if (thread_id < num_recv_warps) {
        cmp (32|M0)   (lt)f0.0   null<2>:uw    r1.0<1;1,0>:uw    0x2:uw                              //  ALU pipe: int; $48

// Line 1139:  if (is_sender) {
(W)     bfn.(s0&s1|s2) (1|M0)    r2.1<1>:ud    r2.3<0;0>:ud      r3.0<0;0>:ud      r2.2<0>:ud       {I@3} //  ALU pipe: int; $39
(W)     or (1|M0)                r2.0<1>:ud    r2.0<0;1,0>:ud    r2.1<0;1,0>:ud   {Compacted,I@1}    //  ALU pipe: int; $40
(W)     mov (1|M0)               r61.1<1>:ud   r2.0<0;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $41

// Line 1285:  if (thread_id < num_recv_warps) {
(~f0.0) goto (32|M0)                         _0_138            _0_138                                //  ALU pipe: int; $49
// B004: [inDivergent],  Preds:{B003},  Succs:{B005}
_0_139:

// Line 1286:  warp_retired[thread_id] = 0;  // false
        shl (32|M0)              r2.0<1>:d     r40.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $54
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r4.4<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $55
        mov (32|M0)              r10.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $56
        store.slm.d32.a32 (32|M0)  [r8:2]       r10:2              {I@1,$3} // ex_desc:0x0; desc:0x4000504 // $57
// B005: Preds:{B004, B003},  Succs:{B006, B007}
_0_138:
        join (32|M0)                         L696                                                    // 
L696:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r46.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $61
(~f1.0) goto (32|M0)                         _0_140            _0_140                                //  ALU pipe: int; $62
// B006: [inDivergent],  Preds:{B005},  Succs:{B007}
_0_141:

// Line 1289:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] = 0;
        shl (32|M0)              r2.0<1>:d     r90.0<1;1,0>:d    3:w               {Compacted}       //  ALU pipe: int; $65
        shl (32|M0)              r8.0<1>:d     r46.0<1;1,0>:d    2:w               {Compacted,$3.src} //  ALU pipe: int; $66
        mov (32|M0)              r12.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $68
        or (32|M0)               r10.0<1>:d    r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $67
        store.slm.d32.a32 (32|M0)  [r10:2]      r12:2              {I@1,$4} // ex_desc:0x0; desc:0x4000504 // $69
// B007: Preds:{B006, B005},  Succs:{B008, B009}
_0_140:
        join (32|M0)                         L792                                                    // 
L792:

// Line 1291:  if (thread_id < kNumRanks) {
(~f0.0) goto (32|M0)                         _0_142            _0_142                                //  ALU pipe: int; $73
// B008: [inDivergent],  Preds:{B007},  Succs:{B009}
_0_143:

// Line 1292:  channel_tail_idx_shared[thread_id] = 0;
        shl (32|M0)              r2.0<1>:d     r40.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $78
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r4.2<0;1,0>:d    {Compacted,@1,$3.src} //  ALU pipe: int; $79
        mov (32|M0)              r10.0<1>:d    0:w                               {Compacted,$4.src}  //  ALU pipe: int; $80
        store.slm.d32.a32 (32|M0)  [r8:2]       r10:2              {I@1,$5} // ex_desc:0x0; desc:0x4000504 // $81
// B009: Preds:{B008, B007},  Succs:{B010, B064}
_0_142:
        join (32|M0)                         L864                                                    // 
L864:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/nd_item.hpp

// Line 218:  __spirv_ControlBarrier(__spv::Scope::Workgroup, __spv::Scope::Workgroup,
(W)     send.slm (1|M0)          r2       r60  null:0  0x0            0x0210001F           {$6} // wr:1+0, rd:1; fence.slm.none.group // $87
(W)     mov (1|M0)               r3.2<1>:f     0x100:f                                               //  signal barrier payload init (active only); (0x00000100:f); ALU pipe: float; $88
(W)     mov (2|M0)               r3.10<1>:ub   r60.11<0;1,0>:ub                 {F@1}                //  signal barrier payload (nprods, ncons); ALU pipe: int; $88
(W)     mov (8|M0)               null<1>:ud    r2.0<1;1,0>:ud                   {Compacted,$6.dst}   //  memory fence commit; ALU pipe: int; $88
(W)     send.gtwy (1|M0)         null     r3  null:0  0x0            0x02000004           {I@2,$7} // wr:1+0, rd:0; signal barrier // $88
(W)     sync.bar                             0x0                                                     // $88

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1297:  if (thread_id < 32) {
        cmp (32|M0)   (lt)f0.0   null<2>:uw    r1.0<1;1,0>:uw    0x20:uw                             //  ALU pipe: int; $91
(f0.0)  goto (32|M0)                         _0_144            _0_144                                //  ALU pipe: int; $92
// B010: [inDivergent],  Preds:{B009},  Succs:{B011, B012}
_0_145:
(W)     mul (1|M0)               r2.0<1>:d     r61.1<0;1,0>:d    2048:w                              //  ALU pipe: int; $94

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 20:  Buffer() : ptr(nullptr), total_bytes(0) {}
(W)     mov (4|M0)               r3.0<1>:d     0:w                               {Compacted,$7.src}  //  ALU pipe: int; $101
(W)     add (1|M0)               r3.4<1>:d     r2.0<0;1,0>:d     1024:w               {Compacted,I@2} //  ALU pipe: int; $104

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1297:  if (thread_id < 32) {
(W)     add (1|M0)               r112.1<1>:q   r6.7<0;1,0>:q     r2.0<0;1,0>:ud                      //  ALU pipe: int; $96

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 20:  Buffer() : ptr(nullptr), total_bytes(0) {}
(W)     add (1|M0)               r61.7<1>:q    r6.7<0;1,0>:q     r3.4<0;1,0>:ud   {I@2}              //  ALU pipe: int; $106
(W)     mov (1|M0)               r4.0<1>:q     r112.1<0;1,0>:q                  {I@2}                //  ALU pipe: int; $102
(W)     mov (1|M0)               r7.0<1>:q     r61.7<0;1,0>:q                   {I@2}                //  ALU pipe: int; $113
(W)     store.ugm.d32x4t.a64.wb.wb (1|M0)  [r4:1+0x10] r3:1        {I@2,$8} // ex_desc:0x10000; desc:0x20EB584 // $103
(W)     store.ugm.d32x4t.a64.wb.wb (1|M0)  [r7:1+0x10] r3:1        {I@1,$9} // ex_desc:0x10000; desc:0x20EB584 // $114

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1345:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) +
(W)     shl (1|M0)               r4.4<1>:q     r6.7<0;1,0>:d     3:w               {$8.src}          //  ALU pipe: int; $122

// Line 1343:  auto num_channels_total = num_channels * kNumRanks;
(W)     and (1|M0)               r4.5<1>:d     r112.4<0;1,0>:d   -2:w                                //  ALU pipe: int; $119

// Line 1345:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) +
        sync.nop                             null                             {Compacted,$5.src}     // $123
(W)     add (1|M0)               r8.0<1>:q     r4.4<0;1,0>:q     r6.1<0;1,0>:q    {Compacted,@2,$3.src} //  ALU pipe: int; $123

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     asr (1|M0)               r2.1<1>:d     r6.10<0;1,0>:d    31:w                                //  ALU pipe: int; $133
(W)     mul (1|M0)               acc0.0<1>:ud  r4.5<0;1,0>:ud    r6.20<0;1,0>:uw  {I@3}              //  ALU pipe: int; $134
(W)     macl (1|M0)              r3.0<1>:ud    r4.5<0;1,0>:ud    r6.10<0;1,0>:ud  {$9.src}           //  ALU pipe: int; $135
(W)     mul (1|M0)               acc0.0<1>:ud  r4.5<0;1,0>:ud    r6.20<0;1,0>:uw                     //  ALU pipe: int; $135
(W)     asr (1|M0)               r2.0<1>:d     r4.5<0;1,0>:d     31:w                                //  ALU pipe: int; $132
(W)     mach (1|M0)              r11.0<1>:d    r4.5<0;1,0>:ud    r6.10<0;1,0>:ud  {$4.src}           //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r4.5<0;1,0>:ud    r2.2<0;1,0>:uw   {I@6}              //  ALU pipe: int; $136

// Line 1346:  2 * num_channels * kNumRanks * sizeof(int));
(W)     shl (1|M0)               r6.11<1>:d    r112.6<0;1,0>:d   2:w                                 //  ALU pipe: int; $126

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     macl (1|M0)              r12.0<1>:d    r4.5<0;1,0>:ud    r2.1<0;1,0>:d                       //  ALU pipe: int; $137
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r2.0<0;1,0>:uw   {I@5}              //  ALU pipe: int; $138
(W)     asr (1|M0)               r61.10<1>:d   r61.0<0;1,0>:d    31:w                                //  ALU pipe: int; $145

// Line 1346:  2 * num_channels * kNumRanks * sizeof(int));
(W)     shl (1|M0)               r7.1<1>:q     r6.11<0;1,0>:d    2:w               {I@4}             //  ALU pipe: int; $128

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     add (1|M0)               r11.0<1>:d    r11.0<0;1,0>:d    r12.0<0;1,0>:d   {Compacted,I@4}    //  ALU pipe: int; $137
(W)     macl (1|M0)              r12.0<1>:d    r6.10<0;1,0>:ud   r2.0<0;1,0>:d                       //  ALU pipe: int; $140
(W)     mul (1|M0)               acc0.0<1>:ud  r3.0<0;1,0>:ud    r61.0<0;1,0>:uw                     //  ALU pipe: int; $146
(W)     add (1|M0)               r3.1<1>:d     r11.0<0;1,0>:d    r12.0<0;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $140

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     asr (1|M0)               r61.12<1>:d   r6.6<0;1,0>:d     31:w                                //  ALU pipe: int; $176

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.2<1>:d     r3.0<0;1,0>:d                    {Compacted}          //  ALU pipe: int; $141
(W)     mov (1|M0)               r3.3<1>:d     r3.1<0;1,0>:d                    {I@3}                //  ALU pipe: int; $142

// Line 1342:  auto channel_rank_offset = responsible_channel * kNumRanks + i;
(W)     and (1|M0)               r4.3<1>:d     r60.1<0;1,0>:d    2147483646:d                        //  ALU pipe: int; $117

// Line 1355:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * sizeof(int));
(W)     shl (1|M0)               r4.4<1>:q     r3.1<0;1,0>:q     2:w               {I@2}             //  ALU pipe: int; $172

// Line 1348:  channel_x_buffers[i] = Buffer<int4>(
(W)     mov (1|M0)               r16.0<1>:uq   r4.0<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $214

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 37:  return (a + b - 1) / b;
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r112.4<0;1,0>:ud  0x2:uw                              //  ALU pipe: int; $274

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1345:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) +
(W)     load.ugm.d64x1t.a64 (1|M0)  r9:1        [r8:1]             {$10} // ex_desc:0x0; desc:0x2108780 // $124

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     macl (1|M0)              r8.0<1>:ud    r3.0<0;1,0>:ud    r61.0<0;1,0>:ud  {Compacted,$10.src} //  ALU pipe: int; $147
(W)     mul (1|M0)               acc0.0<1>:ud  r3.0<0;1,0>:ud    r61.0<0;1,0>:uw                     //  ALU pipe: int; $147

// Line 1345:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) +
(W)     add (1|M0)               r10.0<1>:q    r7.1<0;1,0>:q     r9.0<0;1,0>:q    {Compacted,$10.dst} //  ALU pipe: int; $130
(W)     mach (1|M0)              r9.0<1>:d     r3.0<0;1,0>:ud    r61.0<0;1,0>:ud                     //  ALU pipe: int; 

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mul (1|M0)               acc0.0<1>:d   r3.0<0;1,0>:ud    r61.20<0;1,0>:uw                    //  ALU pipe: int; $148
(W)     macl (1|M0)              r13.0<1>:d    r3.0<0;1,0>:ud    r61.10<0;1,0>:d                     //  ALU pipe: int; $149
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r3.2<0;1,0>:uw                      //  ALU pipe: int; $150
(W)     add (1|M0)               r9.0<1>:d     r9.0<0;1,0>:d     r13.0<0;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $149
(W)     macl (1|M0)              r13.0<1>:d    r61.0<0;1,0>:ud   r3.1<0;1,0>:d                       //  ALU pipe: int; $152

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     mul (1|M0)               acc0.0<1>:ud  r6.10<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $158
(W)     macl (1|M0)              r2.0<1>:ud    r6.10<0;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $159
(W)     mul (1|M0)               acc0.0<1>:ud  r6.10<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $159
(W)     mach (1|M0)              r11.0<1>:d    r6.10<0;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r61.20<0;1,0>:uw                    //  ALU pipe: int; $160
(W)     macl (1|M0)              r12.0<1>:d    r6.10<0;1,0>:ud   r61.10<0;1,0>:d                     //  ALU pipe: int; $161
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r2.2<0;1,0>:uw                      //  ALU pipe: int; $162
(W)     add (1|M0)               r11.0<1>:d    r11.0<0;1,0>:d    r12.0<0;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $161
(W)     macl (1|M0)              r12.0<1>:d    r61.0<0;1,0>:ud   r2.1<0;1,0>:d                       //  ALU pipe: int; $164
(W)     mul (1|M0)               acc0.0<1>:ud  r6.10<0;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $177

// Line 1350:  static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     add (1|M0)               r8.1<1>:d     r9.0<0;1,0>:d     r13.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $152

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     macl (1|M0)              r9.0<1>:ud    r6.10<0;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $178
(W)     mul (1|M0)               acc0.0<1>:ud  r6.10<0;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $178
(W)     mach (1|M0)              r13.0<1>:d    r6.10<0;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r61.24<0;1,0>:uw                    //  ALU pipe: int; $179
(W)     macl (1|M0)              r14.0<1>:d    r6.10<0;1,0>:ud   r61.12<0;1,0>:d                     //  ALU pipe: int; $180

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.2<1>:q     r8.0<0;1,0>:q     4:w               {Compacted,I@6}   //  ALU pipe: int; $167

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     mul (1|M0)               acc0.0<1>:d   r6.6<0;1,0>:ud    r2.2<0;1,0>:uw                      //  ALU pipe: int; $181
(W)     add (1|M0)               r13.0<1>:d    r13.0<0;1,0>:d    r14.0<0;1,0>:d   {Compacted,I@3}    //  ALU pipe: int; $180
(W)     macl (1|M0)              r14.0<1>:d    r6.6<0;1,0>:ud    r2.1<0;1,0>:d                       //  ALU pipe: int; $183

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
(W)     add (1|M0)               r3.0<1>:q     r10.0<0;1,0>:q    r2.2<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $169

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
(W)     mul (1|M0)               acc0.0<1>:ud  r9.0<0;1,0>:ud    r4.6<0;1,0>:uw                      //  ALU pipe: int; $185

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     add (1|M0)               r6.11<1>:d    r13.0<0;1,0>:d    r14.0<0;1,0>:d   {I@3}              //  ALU pipe: int; $183

// Line 1354:  ptr = reinterpret_cast<void*>(static_cast<int8_t*>(ptr) +
(W)     add (1|M0)               r6.6<1>:q     r3.0<0;1,0>:q     r4.4<0;1,0>:q    {I@3}              //  ALU pipe: int; $174
(W)     macl (1|M0)              r3.0<1>:ud    r9.0<0;1,0>:ud    r4.3<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $186
(W)     mul (1|M0)               acc0.0<1>:ud  r9.0<0;1,0>:ud    r4.6<0;1,0>:uw                      //  ALU pipe: int; $186
(W)     mach (1|M0)              r8.0<1>:d     r9.0<0;1,0>:ud    r4.3<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r4.3<0;1,0>:ud    r6.22<0;1,0>:uw  {I@5}              //  ALU pipe: int; $189

// Line 1341:  for (int i = 0; i < kNumRanks; ++i) {
(W)     add (1|M0)               r2.2<1>:d     r11.0<0;1,0>:d    r12.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $164
(W)     macl (1|M0)              r11.0<1>:d    r4.3<0;1,0>:ud    r6.11<0;1,0>:d                      //  ALU pipe: int; $191
(W)     mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r4.6<0;1,0>:uw                      //  ALU pipe: int; $196
(W)     macl (1|M0)              r12.0<1>:ud   r2.0<0;1,0>:ud    r4.3<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $197
(W)     mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r4.6<0;1,0>:uw                      //  ALU pipe: int; $197
(W)     mach (1|M0)              r15.0<1>:d    r2.0<0;1,0>:ud    r4.3<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r4.3<0;1,0>:ud    r2.4<0;1,0>:uw   {I@6}              //  ALU pipe: int; $200
(W)     macl (1|M0)              r13.0<1>:d    r4.3<0;1,0>:ud    r2.2<0;1,0>:d                       //  ALU pipe: int; $202

// Line 1342:  auto channel_rank_offset = responsible_channel * kNumRanks + i;
(W)     or (1|M0)                r9.1<1>:d     r60.1<0;1,0>:d    1:w                                 //  ALU pipe: int; $228
(W)     add (1|M0)               r3.1<1>:d     r8.0<0;1,0>:d     r11.0<0;1,0>:d   {Compacted,I@7}    //  ALU pipe: int; $191
(W)     add (1|M0)               r12.1<1>:d    r15.0<0;1,0>:d    r13.0<0;1,0>:d   {Compacted,I@3}    //  ALU pipe: int; $202
(W)     mul (1|M0)               acc0.0<1>:ud  r9.0<0;1,0>:ud    r9.2<0;1,0>:uw   {I@3}              //  ALU pipe: int; $230

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r7.1<1>:q     r3.0<0;1,0>:q     2:w               {Compacted,I@3}   //  ALU pipe: int; $219
(W)     shl (1|M0)               r2.2<1>:q     r12.0<0;1,0>:q    4:w               {Compacted,I@3}   //  ALU pipe: int; $209

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
(W)     macl (1|M0)              r17.0<1>:ud   r9.0<0;1,0>:ud    r9.1<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $231
(W)     mul (1|M0)               acc0.0<1>:ud  r9.0<0;1,0>:ud    r9.2<0;1,0>:uw                      //  ALU pipe: int; $231
(W)     mach (1|M0)              r12.0<1>:d    r9.0<0;1,0>:ud    r9.1<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r9.1<0;1,0>:ud    r6.22<0;1,0>:uw                     //  ALU pipe: int; $234

// Line 1357:  channel_topk_weights_buffers[i] = Buffer<float>(
(W)     mov (1|M0)               r11.0<1>:uq   r7.0<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $224

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     add (1|M0)               r8.0<1>:q     r6.6<0;1,0>:q     r7.1<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $220
(W)     add (1|M0)               r14.0<1>:q    r10.0<0;1,0>:q    r2.2<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $210

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
(W)     macl (1|M0)              r13.0<1>:d    r9.1<0;1,0>:ud    r6.11<0;1,0>:d                      //  ALU pipe: int; $236
(W)     mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r9.2<0;1,0>:uw                      //  ALU pipe: int; $241
(W)     macl (1|M0)              r3.0<1>:ud    r2.0<0;1,0>:ud    r9.1<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $242
(W)     mul (1|M0)               acc0.0<1>:ud  r2.0<0;1,0>:ud    r9.2<0;1,0>:uw                      //  ALU pipe: int; $242

// Line 1348:  channel_x_buffers[i] = Buffer<int4>(
(W)     store.ugm.d32x2t.a64.wb.wb (1|M0)  [r16:1] r14:1           {I@5,$11} // ex_desc:0x0; desc:0x20E9584 // $215

// Line 1357:  channel_topk_weights_buffers[i] = Buffer<float>(
(W)     store.ugm.d32x2t.a64.wb.wb (1|M0)  [r11:1] r8:1            {$12} // ex_desc:0x0; desc:0x20E9584 // $225
(W)     mach (1|M0)              r8.0<1>:d     r2.0<0;1,0>:ud    r9.1<0;1,0>:ud   {$12.src}          //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r9.1<0;1,0>:ud    r2.4<0;1,0>:uw                      //  ALU pipe: int; $245
(W)     macl (1|M0)              r11.0<1>:d    r9.1<0;1,0>:ud    r2.2<0;1,0>:d                       //  ALU pipe: int; $247
(W)     add (1|M0)               r17.1<1>:d    r12.0<0;1,0>:d    r13.0<0;1,0>:d   {Compacted,I@7}    //  ALU pipe: int; $236
(W)     add (1|M0)               r3.1<1>:d     r8.0<0;1,0>:d     r11.0<0;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $247

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r7.1<1>:q     r17.0<0;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $264
(W)     shl (1|M0)               r4.4<1>:q     r3.0<0;1,0>:q     4:w               {I@2}             //  ALU pipe: int; $254

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1348:  channel_x_buffers[i] = Buffer<int4>(
(W)     mov (1|M0)               r15.0<1>:q    r4.0<0;1,0>:q                                         //  ALU pipe: int; $259

// Line 1357:  channel_topk_weights_buffers[i] = Buffer<float>(
(W)     mov (1|M0)               r13.0<1>:q    r7.0<0;1,0>:q                                         //  ALU pipe: int; $269

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     add (1|M0)               r12.0<1>:q    r6.6<0;1,0>:q     r7.1<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $265
(W)     add (1|M0)               r14.0<1>:q    r10.0<0;1,0>:q    r4.4<0;1,0>:q    {Compacted,@4,$11.src} //  ALU pipe: int; $255

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1348:  channel_x_buffers[i] = Buffer<int4>(
(W)     store.ugm.d32x2t.a64.wb.wb (1|M0)  [r15:1+0x10] r14:1      {I@1,$13} // ex_desc:0x10000; desc:0x20E9584 // $260

// Line 1357:  channel_topk_weights_buffers[i] = Buffer<float>(
(W)     store.ugm.d32x2t.a64.wb.wb (1|M0)  [r13:1+0x10] r12:1      {$14} // ex_desc:0x10000; desc:0x20E9584 // $270

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 37:  return (a + b - 1) / b;
(W&~f3.0) jmpi                               _0_146                                                  //  ALU pipe: int; $275
// B011: [inDivergent],  Preds:{B010},  Succs:{B013}
_0_147:
(W)     mov (1|M0)               r112.0<1>:d   -1:w                               {Compacted}        //  ALU pipe: int; $277
(W)     jmpi                                 _0_148                                                  // $278
// B012: [inDivergent],  Preds:{B010},  Succs:{B013}
_0_146:
(W)     add3 (1|M0)              r112.5<1>:d   r112.6<0;0>:d     r6.4<0;0>:d       -1:w               //  ALU pipe: int; $281
(W)     add (1|M0)               r3.0<1>:d     r112.6<0;1,0>:d   r6.4<0;1,0>:d    {Compacted}        //  ALU pipe: int; $280
(W)     asr (2|M0)               r2.0<1>:d     r112.4<1;1,0>:d   31:w               {Compacted,I@2}  //  ALU pipe: int; $282
(W)     add (1|M0)               r2.2<1>:d     r2.0<0;1,0>:d     r112.6<0;1,0>:d  {Compacted,I@1}    //  ALU pipe: int; $284
(W)     add3 (1|M0)              r4.0<1>:d     r2.1<0;0>:d       r3.0<0;0>:d       -1:w               //  ALU pipe: int; $286
(W)     xor (1|M0)               r3.1<1>:d     r2.2<0;1,0>:d     r2.0<0;1,0>:d    {I@2}              //  ALU pipe: int; $285
(W)     xor (1|M0)               r6.11<1>:d    r4.0<0;1,0>:d     r2.1<0;1,0>:d    {I@2}              //  ALU pipe: int; $287
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $288
(W)     mov (1|M0)               r6.12<1>:f    r3.1<0;1,0>:ud                   {A@1}                //  ALU pipe: float; $289
(W)     mov (1|M0)               r7.3<1>:f     0xB4C00000:f                                          //  ALU pipe: float; $294
(W)     math.inv (1|M0)          r8.0<1>:f     r6.12<0;1,0>:f                   {F@2}                //  ALU pipe: math; $293
(W)     mov (1|M0)               r7.2<1>:f     r6.11<0;1,0>:ud                  {I@2}                //  ALU pipe: float; $292
(W)     mad (1|M0)               r9.0<1>:f     r8.0<0;0>:f       r7.3<0;0>:f       r8.0<0>:f        {A@1} //  ALU pipe: float; $294
(W)     mov (1|M0)               r6.13<1>:ud   r6.12<0;1,0>:f                                        //  ALU pipe: int; $290
(W)     mov (1|M0)               r2.2<1>:ud    r7.2<0;1,0>:f                    {F@2}                //  ALU pipe: int; $296
(W)     mul (1|M0)               r9.1<1>:f     r7.2<0;1,0>:f     r9.0<0;1,0>:f    {F@1}              //  ALU pipe: float; $295
(W)     add (1|M0)               r7.0<1>:d     r3.1<0;1,0>:d     -r6.13<0;1,0>:d  {I@2}              //  ALU pipe: int; $291
(W)     add (1|M0)               r7.1<1>:d     r6.11<0;1,0>:d    -r2.2<0;1,0>:d   {I@2}              //  ALU pipe: int; $297
(W)     mov (1|M0)               r3.0<1>:ud    r9.1<0;1,0>:f                    {F@1}                //  ALU pipe: int; $298
(W)     mov (1|M0)               r4.0<1>:f     r7.0<0;1,0>:ud                   {I@3}                //  ALU pipe: float; $299
(W)     mov (1|M0)               r4.1<1>:f     r7.1<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $299
(W)     mov (1|M0)               r3.2<1>:f     r3.0<0;1,0>:ud                   {I@1}                //  ALU pipe: float; $301
(W)     mad (1|M0)               r3.3<1>:f     r7.2<0;0>:f       r3.2<0;0>:f       -r6.12<0>:f      {F@1} //  ALU pipe: float; $303
(W)     mad (1|M0)               r10.0<1>:f    r4.1<0;0>:f       r3.2<0;0>:f       -r4.0<0>:f        //  ALU pipe: float; $305
(W)     add (1|M0)               r11.0<1>:f    r3.3<0;1,0>:f     r10.0<0;1,0>:f   {Compacted,F@1}    //  ALU pipe: float; $306
(W)     mul (1|M0)               r12.0<1>:f    r9.0<0;1,0>:f     r11.0<0;1,0>:f   {Compacted,@1,$14.src} //  ALU pipe: float; $307
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $308
(W)     mov (1|M0)               r8.0<1>:ud    r12.0<0;1,0>:f                   {A@1}                //  ALU pipe: int; $309
(W)     xor (1|M0)               r13.1<1>:d    r2.0<0;1,0>:d     r2.1<0;1,0>:d    {Compacted}        //  ALU pipe: int; $311
(W)     add (1|M0)               r13.0<1>:d    r8.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $310
(W)     mul (1|M0)               acc0.0<1>:d   r13.0<0;1,0>:d    r3.2<0;1,0>:uw   {I@1}              //  ALU pipe: int; $312
(W)     macl (1|M0)              r14.0<1>:d    r13.0<0;1,0>:d    r3.1<0;1,0>:d    {Compacted,$13.src} //  ALU pipe: int; $313
(W)     add (1|M0)               r2.2<1>:d     r6.11<0;1,0>:d    -r14.0<0;1,0>:d  {I@1}              //  ALU pipe: int; $313
(W)     cmp (1|M0)    (ge)f2.0   r16.0<1>:ud   r2.2<0;1,0>:ud    r3.1<0;1,0>:ud   {I@1}              //  ALU pipe: int; $314
(W)     add3 (1|M0)              r7.0<1>:d     r13.0<0;0>:d      r13.1<0;0>:d      -r16.0<0>:d      {I@1} //  ALU pipe: int; $315
(W)     bfn.(s0^s1^s2) (1|M0)    r112.0<1>:ud  r7.0<0;0>:ud      r2.0<0;0>:ud      r2.1<0>:ud       {I@1} //  ALU pipe: int; $316
// B013: [inDivergent],  Preds:{B012, B011},  Succs:{B014, B061}
_0_148:

// Line 53:  token_start_idx = sycl::min(num_tokens_per_sm * sm_id, num_tokens);
(W)     mul (1|M0)               acc0.0<1>:d   r112.0<0;1,0>:d   r112.20<0;1,0>:uw {I@1}             //  ALU pipe: int; $320

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
(W)     macl (1|M0)              r2.0<1>:d     r112.0<0;1,0>:d   r112.10<0;1,0>:d {Compacted}        //  ALU pipe: int; $324

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     mov (1|M0)               r6.6<1>:uq    0x0:uw                                                //  ALU pipe: int; $339

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
(W)     sel (1|M0)    (lt)f0.0   r4.0<1>:d     r2.0<0;1,0>:d     r6.4<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $324

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     mov (1|M0)               r4.3<1>:d     r5.6<0;1,0>:d                                         //  ALU pipe: int; $337

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 54:  token_end_idx = sycl::min(token_start_idx + num_tokens_per_sm, num_tokens);
(W)     add (1|M0)               r3.0<1>:d     r4.0<0;1,0>:d     r112.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $327

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        add3 (32|M0)             r16.0<1>:d    r4.0<0;0>:d       r90.0<1;0>:d      -1:w               //  ALU pipe: int; $335

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
(W)     sel (1|M0)    (lt)f0.0   r112.9<1>:d   r3.0<0;1,0>:d     r6.4<0;1,0>:d    {I@2}              //  ALU pipe: int; $331

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     mov (1|M0)               r4.11<1>:d    r5.7<0;1,0>:d                                         //  ALU pipe: int; $338

// Line 1370:  token_idx < token_end_idx;
        cmp (32|M0)   (lt)f2.0   null<1>:d     r16.0<1;1,0>:d    r112.9<0;1,0>:d  {I@2}              //  ALU pipe: int; $350 R{} IR{}{E:0,E:0,},  R{r112,} IR{} {BC=1}

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W)     mov (1|M0)               r4.9<1>:d     r5.8<0;1,0>:d                                         //  ALU pipe: int; $343
(W)     mov (1|M0)               r4.8<1>:d     r5.9<0;1,0>:d                                         //  ALU pipe: int; $344

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     mov (1|M0)               r4.1<1>:d     r6.12<0;1,0>:d                                        //  ALU pipe: int; $340
(W)     mov (1|M0)               r4.10<1>:d    r6.13<0;1,0>:d                                        //  ALU pipe: int; $341

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W)     mov (1|M0)               r4.5<1>:d     r6.12<0;1,0>:d                                        //  ALU pipe: int; $346
(W)     mov (1|M0)               r4.0<1>:d     r6.13<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $347

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
(~f2.0) goto (32|M0)                         _0_149            _0_149                                //  ALU pipe: int; $352
// B014: [inDivergent],  Preds:{B013},  Succs:{B015}
_0_150:

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r4.3<0;1,0>:d     r4.1<0;1,0>:d    {I@5}              //  ALU pipe: int; $376

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r61.11<1>:ud  f1.0<0;1,0>:ud                                        //  ALU pipe: int; $376

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        and (32|M0)              r2.0<1>:d     r1.0<1;1,0>:uw    31:w                                //  ALU pipe: int; $361

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f0.0<1>:ud    r61.11<0;1,0>:ud                 {Compacted,I@2}      //  ALU pipe: int; $377

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        shl (32|M0)              r7.0<1>:w     r1.0<1;1,0>:w     2:w                                 //  ALU pipe: int; $371

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W&f0.0) cmp (32|M0)  (eq)f0.0   null<1>:d     r4.11<0;1,0>:d    r4.10<0;1,0>:d                      //  ALU pipe: int; $377

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        mov (32|M0)              r8.0<1>:d     0:w                               {Compacted}         //  ALU pipe: int; $363

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        shl (32|M0)              r14.0<1>:d    r46.0<1;1,0>:d    2:w               {Compacted,$13.src} //  ALU pipe: int; $385

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        mov (16|M0)              r10.0<2>:d    r2.0<1;1,0>:d                    {I@6}                //  ALU pipe: int; $364
        mov (16|M16)             r12.0<2>:d    r3.0<1;1,0>:d                    {$14.src}            //  ALU pipe: int; $365

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r61.11<1>:ud  f0.0<0;1,0>:ud                                        //  ALU pipe: int; $377

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        shl (32|M0)              r2.0<1>:d     r90.0<1;1,0>:d    3:w               {Compacted}       //  ALU pipe: int; $384

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W)     cmp (32|M0)   (eq)f0.0   null<1>:d     r4.9<0;1,0>:d     r4.5<0;1,0>:d                       //  ALU pipe: int; $380

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        and (32|M0)              r7.0<1>:w     r7.0<1;1,0>:w     124:w               {I@7}           //  ALU pipe: int; $372

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        mov (16|M0)              r10.1<2>:d    r8.0<1;1,0>:d                    {I@7}                //  ALU pipe: int; $366
        mov (16|M16)             r12.1<2>:d    r9.0<1;1,0>:d                                         //  ALU pipe: int; $367

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        cmp (32|M0)   (lt)f3.0   null<1>:d     r46.0<1;1,0>:d    r61.0<0;1,0>:d                      //  ALU pipe: int; $393
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.10<0;1,0>:d    0:w                                 //  ALU pipe: int; $394

// Line 1492:  if (lane_id < num_topk_) {
        cmp (32|M0)   (lt)f1.0   null<1>:d     r46.0<1;1,0>:d    r6.6<0;1,0>:d                       //  ALU pipe: int; $397

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        or (32|M0)               r108.0<1>:d   r2.0<1;1,0>:d     r14.0<1;1,0>:d   {Compacted,I@7}    //  ALU pipe: int; $386

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W&f0.0) cmp (32|M0)  (eq)f0.0   null<1>:d     r4.8<0;1,0>:d     r4.0<0;1,0>:d                       //  ALU pipe: int; $381

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        add (32|M0)              r84.0<1>:d    r4.2<0;1,0>:d     r7.0<1;1,0>:uw   {I@7}              //  ALU pipe: int; $374

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        shl (16|M0)              r88.0<1>:q    r10.0<1;1,0>:q    2:w               {Compacted,I@7}   //  ALU pipe: int; $388
        shl (16|M16)             r86.0<1>:q    r12.0<1;1,0>:q    2:w               {Compacted,I@7}   //  ALU pipe: int; $388
        mov (16|M16)             r8.0<2>:ud    r17.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $399
        mov (16|M0)              r2.0<2>:ud    r16.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $399
        add (16|M0)              r106.0<1>:q   r88.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $389
        add (16|M0)              r94.0<1>:q    r88.0<1;1,0>:q    r5.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $392
        add (16|M16)             r104.0<1>:q   r86.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@5}    //  ALU pipe: int; $389 R{} IR{}{E:3,E:3,},  R{r6,} IR{} {BC=1}
        add (16|M16)             r92.0<1>:q    r86.0<1;1,0>:q    r5.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $392
        mov (16|M16)             r50.0<1>:q    r8.0<2;1,0>:d                    {I@6}                //  ALU pipe: int; $399
        mov (16|M0)              r52.0<1>:q    r2.0<2;1,0>:d                    {I@6}                //  ALU pipe: int; $399

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
(W)     asr (1|M0)               r112.8<1>:d   r112.9<0;1,0>:d   31:w                                //  ALU pipe: int; $355

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
(W)     mov (1|M0)               r61.13<1>:d   (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $395
(W)     mov (2|M0)               r61.7<1>:d    r4.0<1;1,0>:d                                         //  ALU pipe: int; $402
(W)     mov (2|M0)               r61.5<1>:d    r4.0<1;1,0>:d                                         //  ALU pipe: int; $403

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r112.11<1>:ud  f3.0<0;1,0>:ud                                       //  ALU pipe: int; $393
(W)     mov (1|M0)               r112.7<1>:ud  f2.0<0;1,0>:ud                                        //  ALU pipe: int; $394
(W)     mov (1|M0)               r112.12<1>:ud  f1.0<0;1,0>:ud                                       //  ALU pipe: int; $397
// B015: [inDivergent],  Preds:{B060, B014},  Succs:{B016, B017}
_0_151:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r46.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $411
        mov (16|M0)              r40.0<1>:d    r52.0<2;1,0>:d                   {Compacted,I@7}      //  ALU pipe: int; $406
        mov (16|M16)             r41.0<1>:d    r50.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $407
        mov (16|M0)              r48.0<1>:d    r52.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $408
        mov (16|M16)             r49.0<1>:d    r50.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $409

// Line 1375:  if (lane_id < kNumRanks) {
(f3.0)  goto (32|M0)                         _0_152            _0_152                                //  ALU pipe: int; $413
// B016: [inDivergent],  Preds:{B015},  Succs:{B018}
_0_153:
        mov (32|M0)              r44.0<1>:d    -1:w                               {Compacted}        //  ALU pipe: int; $415
        goto (32|M0)                         _0_152            _0_154                                // $416
// B017: [inDivergent],  Preds:{B015},  Succs:{B018}
_0_152:
        join (32|M0)                         _0_154                                                  // 
L3944:

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        shl (16|M0)              r2.0<1>:q     r52.0<1;1,0>:q    3:w               {Compacted}       //  ALU pipe: int; $419
        shl (16|M16)             r7.0<1>:q     r50.0<1;1,0>:q    3:w               {Compacted}       //  ALU pipe: int; $419
        add (16|M0)              r9.0<1>:q     r106.0<1;1,0>:q   r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $420
        sync.nop                             null                             {Compacted,$0.src}     // $420
        add (16|M16)             r11.0<1>:q    r104.0<1;1,0>:q   r7.0<1;1,0>:q    {Compacted,@2,$15.src} //  ALU pipe: int; $420

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r44:2         [r9:4]             {I@1,$2} // ex_desc:0x0; desc:0x8200580 // $424
// B018: [inDivergent],  Preds:{B017, B016},  Succs:{B019}
_0_154:
        join (32|M0)                         _0_149                                                  // 
L4016:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        cmp (32|M0)   (gt)f3.0   null<1>:d     r44.0<1;1,0>:d    -1:w               {$2.dst}         //  ALU pipe: int; $430

// Line 1385:  if (lane_id < kNumRanks && expected_head >= 0) {
(f3.0)  cmp (32|M0)   (lt)f3.0   null<1>:ud    r46.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $432
// B019: [inDivergent],  Preds:{B022, B018},  Succs:{B020, B021}
_0_155:
(f3.0)  goto (32|M0)                         _0_156            _0_156                                //  ALU pipe: int; $438
// B020: [inDivergent],  Preds:{B019},  Succs:{B022}
_0_157:
        mov (32|M0)              r2.0<1>:d     0:w                               {Compacted}         //  ALU pipe: int; $440
        goto (32|M0)                         _0_156            _0_158                                // $441
// B021: [inDivergent],  Preds:{B019},  Succs:{B022}
_0_156:
        join (32|M0)                         _0_158                                                  // 
L4104:

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        load.slm.d32.a32 (32|M0)  r2:2          [r84:2]            {I@3,$6} // ex_desc:0x0; desc:0x4200500 // $444
        cmp (32|M0)   (le)f2.0   r2.0<1>:d     r2.0<1;1,0>:d     r44.0<1;1,0>:d   {$6.dst}           //  ALU pipe: int; $445
// B022: [inDivergent],  Preds:{B021, B020},  Succs:{B023, B019}
_0_158:
        join (32|M0)                         _0_149                                                  // 
L4152:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/spirv.hpp

// Line 214:  return __spirv_GroupAny(group_scope<Group>::value, pred);
        cmp (32|M0)   (ne)f1.0   r2.0<1>:d     r2.0<1;1,0>:d     0:w               {I@2}             //  ALU pipe: int; $455
(W)     mov (32|M0)              r7.0<1>:ud    0x0:uw                                                //  ALU pipe: int; $457
        mov (32|M0)              r7.0<1>:d     -r2.0<1;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $456
(W)     sel (16|M0)   (ge)f0.0   r9.0<1>:ud    r7.0<1;1,0>:ud    r8.0<1;1,0>:ud   {I@1}              //  ALU pipe: int; $459
(W)     sel (8|M0)    (ge)f0.0   r4.8<1>:ud    r9.0<1;1,0>:ud    r9.8<1;1,0>:ud   {I@1}              //  ALU pipe: int; $460
(W)     sel (4|M0)    (ge)f0.0   r10.0<1>:ud   r4.8<1;1,0>:ud    r4.12<1;1,0>:ud  {I@1}              //  ALU pipe: int; $461
(W)     sel (2|M0)    (ge)f0.0   r6.11<1>:ud   r10.0<1;1,0>:ud   r10.2<1;1,0>:ud  {I@1}              //  ALU pipe: int; $462
(W)     sel (1|M0)    (ge)f0.0   r11.0<1>:d    r6.11<0;1,0>:ud   r6.12<0;1,0>:ud  {I@1}              //  ALU pipe: int; $463
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r11.0<0;1,0>:d    0:w               {I@1}             //  ALU pipe: int; $464

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1382:  while (any_waiting) {
(W&~f1.0) jmpi                               _0_155                                                  //  ALU pipe: int; $467
// B023: [inDivergent],  Preds:{B022},  Succs:{B024, B025}
_0_159:

// Line 1405:  if (expected_head_i >= 0) {
(W)     cmp (32|M0)   (gt)f2.0   null<1>:d     r44.0<0;1,0>:d    -1:w                                //  ALU pipe: int; $490
(W&f2.0) jmpi                                _0_160                                                  //  ALU pipe: int; $491
// B024: [inDivergent],  Preds:{B023},  Succs:{B029}
_0_161:
(W)     mov (2|M0)               r16.0<1>:d    r61.7<1;1,0>:d                   {$15.src}            //  ALU pipe: int; $493
(W)     mov (2|M0)               r14.0<1>:d    r61.5<1;1,0>:d                                        //  ALU pipe: int; $494
(W)     mov (1|M0)               r14.6<1>:hf   0x0:hf                                                //  ALU pipe: float; $495
(W)     jmpi                                 _0_162                                                  // $496
// B025: [inDivergent],  Preds:{B023},  Succs:{B026, B027}
_0_160:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r112.7<0;1,0>:ud                                      //  ALU pipe: int; $499

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W&~f3.0) jmpi                               _0_163                                                  //  ALU pipe: int; $499
// B026: [inDivergent],  Preds:{B025},  Succs:{B028}
_0_164:
(W)     mov (1|M0)               r14.2<1>:d    -1:w                               {Compacted,$15.src} //  ALU pipe: int; $501
(W)     jmpi                                 _0_165                                                  // $502
// B027: [inDivergent],  Preds:{B025},  Succs:{B028}
_0_163:
(W)     asr (1|M0)               r3.0<1>:d     r44.0<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $504
(W)     add (1|M0)               r2.0<1>:d     r3.0<0;1,0>:d     r44.0<0;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $505
(W)     xor (1|M0)               r3.1<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $506
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $507
(W)     mov (1|M0)               r4.0<1>:f     r61.13<0;1,0>:ud                 {A@1}                //  ALU pipe: float; $508
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $513
(W)     math.inv (1|M0)          r4.3<1>:f     r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $512
(W)     mov (1|M0)               r4.1<1>:f     r3.1<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $511
(W)     mad (1|M0)               r6.11<1>:f    r4.3<0;0>:f       r7.0<0;0>:f       r4.3<0>:f        {A@1} //  ALU pipe: float; $513
(W)     mov (1|M0)               r3.2<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $509
(W)     mov (1|M0)               r6.13<1>:ud   r4.1<0;1,0>:f                    {F@2}                //  ALU pipe: int; $515
(W)     mul (1|M0)               r6.12<1>:f    r4.1<0;1,0>:f     r6.11<0;1,0>:f   {F@1}              //  ALU pipe: float; $514
(W)     add (1|M0)               r4.8<1>:d     (abs)r6.10<0;1,0>:d  -r3.2<0;1,0>:d {I@2}             //  ALU pipe: int; $510
(W)     add (1|M0)               r4.9<1>:d     r3.1<0;1,0>:d     -r6.13<0;1,0>:d  {I@2}              //  ALU pipe: int; $516
(W)     mov (1|M0)               r2.0<1>:ud    r6.12<0;1,0>:f                   {F@1}                //  ALU pipe: int; $517
(W)     mov (1|M0)               r2.4<1>:f     r4.8<0;1,0>:ud                   {I@3}                //  ALU pipe: float; $518
(W)     mov (1|M0)               r2.5<1>:f     r4.9<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $518
(W)     mov (1|M0)               r9.0<1>:f     r2.0<0;1,0>:ud                   {I@1}                //  ALU pipe: float; $520
(W)     mad (1|M0)               r2.1<1>:f     r4.1<0;0>:f       r9.0<0;0>:f       -r4.0<0>:f       {F@1} //  ALU pipe: float; $522
(W)     mad (1|M0)               r3.2<1>:f     r2.5<0;0>:f       r9.0<0;0>:f       -r2.4<0>:f        //  ALU pipe: float; $524
(W)     add (1|M0)               r8.0<1>:f     r2.1<0;1,0>:f     r3.2<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $525
(W)     mul (1|M0)               r10.0<1>:f    r6.11<0;1,0>:f    r8.0<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $526
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $527
(W)     mov (1|M0)               r7.0<1>:ud    r10.0<0;1,0>:f                   {A@1}                //  ALU pipe: int; $528
(W)     mov (1|M0)               r11.1<1>:d    (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $530
(W)     add (1|M0)               r11.0<1>:d    r7.0<0;1,0>:d     r2.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $529
(W)     mul (1|M0)               acc0.0<1>:d   r11.0<0;1,0>:d    r11.2<0;1,0>:uw  {I@1}              //  ALU pipe: int; $530
        sync.nop                             null                             {Compacted,$0.src}     // $531
(W)     macl (1|M0)              r12.0<1>:d    r11.0<0;1,0>:d    r11.1<0;1,0>:d   {Compacted,$15.src} //  ALU pipe: int; $531
(W)     add (1|M0)               r13.0<1>:d    r3.1<0;1,0>:d     -r12.0<0;1,0>:d  {I@1}              //  ALU pipe: int; $531
(W)     cmp (1|M0)    (lt)f2.0   null<1>:ud    r13.0<0;1,0>:ud   r61.13<0;1,0>:ud {I@1}              //  ALU pipe: int; $532 R{} IR{}{O:6,O:6,},  {BC=1}
(W&~f2.0) sel (1|M0)             r4.0<1>:d     (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $533
(W)     add3 (1|M0)              r9.0<1>:d     r13.0<0;0>:d      r3.0<0;0>:d       -r4.0<0>:d       {I@1} //  ALU pipe: int; $534
(W)     xor (1|M0)               r14.2<1>:d    r9.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $535
// B028: [inDivergent],  Preds:{B027, B026},  Succs:{B029}
_0_165:
(W)     mov (1|M0)               r61.7<1>:d    r14.2<0;1,0>:d                   {I@1}                //  ALU pipe: int; $537

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     mov (1|M0)               r61.5<1>:d    0:w                                                   //  ALU pipe: int; $540

// Line 1408:  }
(W)     mov (1|M0)               r14.6<1>:hf   0x1:hf                                                //  ALU pipe: float; $545
(W)     mov (2|M0)               r16.0<1>:d    r61.7<1;1,0>:d                   {I@2}                //  ALU pipe: int; $543
(W)     mov (2|M0)               r14.0<1>:d    r61.5<1;1,0>:d                   {I@2}                //  ALU pipe: int; $544
// B029: [inDivergent],  Preds:{B028, B024},  Succs:{B030, B031}
_0_162:

// Line 1405:  if (expected_head_i >= 0) {
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r44.1<0;1,0>:d    -1:w                                //  ALU pipe: int; $565
(W)     mov (1|M0)               r2.0<2>:b     r14.6<0;1,0>:w                   {F@1}                //  ALU pipe: int; $548
(W)     mov (1|M0)               r14.2<1>:d    r2.0<0;1,0>:ub                   {I@1}                //  ALU pipe: int; $549
(W&f1.0) jmpi                                _0_166                                                  //  ALU pipe: int; $566
// B030: [inDivergent],  Preds:{B029},  Succs:{B035}
_0_167:
(W)     mov (2|M0)               r61.1<1>:d    r16.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $568
(W)     mov (2|M0)               r61.3<1>:d    r14.0<1;1,0>:d                                        //  ALU pipe: int; $569
(W)     mov (1|M0)               r61.9<1>:d    r14.2<0;1,0>:d                   {I@4}                //  ALU pipe: int; $570
(W)     jmpi                                 _0_168                                                  // $571
// B031: [inDivergent],  Preds:{B029},  Succs:{B032, B033}
_0_166:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f2.0<1>:ud    r112.7<0;1,0>:ud                                      //  ALU pipe: int; $574

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W&~f2.0) jmpi                               _0_169                                                  //  ALU pipe: int; $574
// B032: [inDivergent],  Preds:{B031},  Succs:{B034}
_0_170:
(W)     mov (1|M0)               r14.3<1>:d    -1:w                                                  //  ALU pipe: int; $576
(W)     jmpi                                 _0_171                                                  // $577
// B033: [inDivergent],  Preds:{B031},  Succs:{B034}
_0_169:
(W)     asr (1|M0)               r3.0<1>:d     r44.1<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $579
(W)     add (1|M0)               r2.0<1>:d     r3.0<0;1,0>:d     r44.1<0;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $580
(W)     xor (1|M0)               r3.1<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $581
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $582
(W)     mov (1|M0)               r4.0<1>:f     r61.13<0;1,0>:ud                 {A@1}                //  ALU pipe: float; $583
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $588
(W)     math.inv (1|M0)          r4.3<1>:f     r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $587
(W)     mov (1|M0)               r4.1<1>:f     r3.1<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $586
(W)     mad (1|M0)               r6.11<1>:f    r4.3<0;0>:f       r7.0<0;0>:f       r4.3<0>:f        {A@1} //  ALU pipe: float; $588
(W)     mov (1|M0)               r3.2<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $584
(W)     mov (1|M0)               r6.13<1>:ud   r4.1<0;1,0>:f                    {F@2}                //  ALU pipe: int; $590
(W)     mul (1|M0)               r6.12<1>:f    r4.1<0;1,0>:f     r6.11<0;1,0>:f   {F@1}              //  ALU pipe: float; $589
(W)     add (1|M0)               r4.8<1>:d     (abs)r6.10<0;1,0>:d  -r3.2<0;1,0>:d {I@2}             //  ALU pipe: int; $585
(W)     add (1|M0)               r4.9<1>:d     r3.1<0;1,0>:d     -r6.13<0;1,0>:d  {I@2}              //  ALU pipe: int; $591
(W)     mov (1|M0)               r2.0<1>:ud    r6.12<0;1,0>:f                   {F@1}                //  ALU pipe: int; $592
(W)     mov (1|M0)               r2.4<1>:f     r4.8<0;1,0>:ud                   {I@3}                //  ALU pipe: float; $593
(W)     mov (1|M0)               r2.5<1>:f     r4.9<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $593
(W)     mov (1|M0)               r9.0<1>:f     r2.0<0;1,0>:ud                   {I@1}                //  ALU pipe: float; $595
(W)     mad (1|M0)               r2.1<1>:f     r4.1<0;0>:f       r9.0<0;0>:f       -r4.0<0>:f       {F@1} //  ALU pipe: float; $597
(W)     mad (1|M0)               r3.2<1>:f     r2.5<0;0>:f       r9.0<0;0>:f       -r2.4<0>:f        //  ALU pipe: float; $599
(W)     add (1|M0)               r8.0<1>:f     r2.1<0;1,0>:f     r3.2<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $600
(W)     mul (1|M0)               r10.0<1>:f    r6.11<0;1,0>:f    r8.0<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $601
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $602
(W)     mov (1|M0)               r7.0<1>:ud    r10.0<0;1,0>:f                   {A@1}                //  ALU pipe: int; $603
(W)     mov (1|M0)               r11.1<1>:d    (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $605
(W)     add (1|M0)               r11.0<1>:d    r7.0<0;1,0>:d     r2.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $604
(W)     mul (1|M0)               acc0.0<1>:d   r11.0<0;1,0>:d    r11.2<0;1,0>:uw  {I@1}              //  ALU pipe: int; $605
(W)     macl (1|M0)              r12.0<1>:d    r11.0<0;1,0>:d    r11.1<0;1,0>:d   {Compacted,$0.src} //  ALU pipe: int; $606
(W)     add (1|M0)               r13.0<1>:d    r3.1<0;1,0>:d     -r12.0<0;1,0>:d  {I@1}              //  ALU pipe: int; $606
(W)     cmp (1|M0)    (lt)f1.0   null<1>:ud    r13.0<0;1,0>:ud   r61.13<0;1,0>:ud {I@1}              //  ALU pipe: int; $607 R{} IR{}{O:6,O:6,},  {BC=1}
(W&~f1.0) sel (1|M0)             r4.0<1>:d     (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $608
(W)     add3 (1|M0)              r9.0<1>:d     r13.0<0;0>:d      r3.0<0;0>:d       -r4.0<0>:d       {I@1} //  ALU pipe: int; $609
(W)     xor (1|M0)               r14.3<1>:d    r9.0<0;1,0>:d     r3.0<0;1,0>:d    {I@1}              //  ALU pipe: int; $610
// B034: [inDivergent],  Preds:{B033, B032},  Succs:{B035}
_0_171:
(W)     mul (1|M0)               r2.0<1>:uw    r14.4<0;1,0>:uw   0x4:uw                              //  ALU pipe: int; $612

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     mul (1|M0)               r3.0<1>:uw    r14.4<0;1,0>:uw   0x4:uw                              //  ALU pipe: int; $620

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W)     add (1|M0)               a0.0<1>:uw    r2.0<0;1,0>:uw    0x400:uw              {A@1}         //  ALU pipe: int; src1 is addr of V0391(r16.0:d); $613
(W)     mov (1|M0)               r[a0.0]<1>:d  r14.3<0;1,0>:d                                        //  ALU pipe: int; $614

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     add (1|M0)               a0.0<1>:uw    r3.0<0;1,0>:uw    0x380:uw              {I@3}         //  ALU pipe: int; src1 is addr of V0392(r14.0:d); $621
(W)     mov (1|M0)               r[a0.0]<1>:d  1:w                                                   //  ALU pipe: int; $622
(W)     add (1|M0)               r61.9<1>:d    r14.2<0;1,0>:d    1:w                                 //  ALU pipe: int; $617

// Line 1408:  }
(W)     mov (2|M0)               r61.1<1>:d    r16.0<1;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $625
(W)     mov (2|M0)               r61.3<1>:d    r14.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $626
// B035: [inDivergent],  Preds:{B034, B030},  Succs:{B036, B051}
_0_168:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
(W)     mul (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $631
        macl (16|M0)             r10.0<1>:ud   r40.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $631
(W)     mul (16|M16)             acc0.0<1>:ud  r41.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $631
        macl (16|M16)            r11.0<1>:ud   r41.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $632
(W)     mul (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $632
        mach (16|M0)             r2.0<1>:d     r40.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $632
        mach (16|M16)            r3.0<1>:d     r41.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; $633
(W)     mul (16|M0)              acc0.0<1>:d   r40.0<1;1,0>:ud   r61.20<0;1,0>:uw                    //  ALU pipe: int; $633
        macl (16|M0)             r8.0<1>:d     r40.0<1;1,0>:ud   r61.10<0;1,0>:d                     //  ALU pipe: int; $633
(W)     mul (16|M16)             acc0.0<1>:d   r41.0<1;1,0>:ud   r61.20<0;1,0>:uw                    //  ALU pipe: int; $633
        macl (16|M16)            r9.0<1>:d     r41.0<1;1,0>:ud   r61.10<0;1,0>:d                     //  ALU pipe: int; $634
        add (32|M0)              r2.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $634
(W)     mul (16|M0)              acc0.0<1>:d   r61.0<0;1,0>:ud   r48.0<2;1,0>:uw                     //  ALU pipe: int; $635

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f1.0<1>:ud    r112.11<0;1,0>:ud                {Compacted}          //  ALU pipe: int; $640

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        macl (16|M0)             r8.0<1>:d     r61.0<0;1,0>:ud   r48.0<1;1,0>:d                      //  ALU pipe: int; $635
(W)     mul (16|M16)             acc0.0<1>:d   r61.0<0;1,0>:ud   r49.0<2;1,0>:uw                     //  ALU pipe: int; $635
        macl (16|M16)            r9.0<1>:d     r61.0<0;1,0>:ud   r49.0<1;1,0>:d                      //  ALU pipe: int; $637
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $637

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
(~f1.0) goto (32|M0)                         _0_172            _0_172                                //  ALU pipe: int; $640
// B036: [inDivergent],  Preds:{B035},  Succs:{B037}
_0_173:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (32|M0)              r2.0<1>:d     r10.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $643

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     mul (1|M0)               acc0.0<1>:d   r61.1<0;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $661

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M0)              r10.0<2>:d    r2.0<1;1,0>:d                    {I@2}                //  ALU pipe: int; $645
        mov (16|M16)             r12.0<2>:d    r3.0<1;1,0>:d                    {$0.src}             //  ALU pipe: int; $646
        mov (16|M0)              r10.1<2>:d    r8.0<1;1,0>:d                                         //  ALU pipe: int; $647

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     macl (1|M0)              r2.0<1>:d     r61.1<0;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $662

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M16)             r12.1<2>:d    r9.0<1;1,0>:d                                         //  ALU pipe: int; $648

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     mul (1|M0)               acc0.0<1>:d   r61.2<0;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $668
(W)     macl (1|M0)              r3.0<1>:d     r61.2<0;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $670
(W)     cmp (32|M0)   (gt)f2.0   null<1>:d     r61.9<0;1,0>:d    0:w                                 //  ALU pipe: int; $655
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r61.9<0;1,0>:d    1:w                                 //  ALU pipe: int; $662

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        mov (32|M0)              r42.0<1>:d    r46.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $674

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        shl (16|M0)              r14.0<1>:q    r10.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $649
        shl (16|M16)             r16.0<1>:q    r12.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $649

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     shl (1|M0)               r4.0<1>:q     r61.3<0;1,0>:d    4:w                                 //  ALU pipe: int; $658
(W)     shl (1|M0)               r2.1<1>:q     r61.4<0;1,0>:d    4:w                                 //  ALU pipe: int; $665
(W)     mov (1|M0)               r2.1<1>:d     r3.0<0;1,0>:d                    {Compacted,I@7}      //  ALU pipe: int; $670

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        add (16|M0)              r82.0<1>:q    r14.0<1;1,0>:q    r5.3<0;1,0>:q    {Compacted,I@5}    //  ALU pipe: int; $650

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        add (16|M0)              r78.0<1>:q    r14.0<1;1,0>:q    r5.4<0;1,0>:q    {Compacted}        //  ALU pipe: int; $652

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M0)              r56.0<1>:q    r14.0<1;1,0>:q    r4.3<0;1,0>:q    {Compacted}        //  ALU pipe: int; $654

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        add (16|M16)             r80.0<1>:q    r16.0<1;1,0>:q    r5.3<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $650

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        add (16|M16)             r58.0<1>:q    r16.0<1;1,0>:q    r5.4<0;1,0>:q    {Compacted}        //  ALU pipe: int; $652

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M16)             r54.0<1>:q    r16.0<1;1,0>:q    r4.3<0;1,0>:q    {Compacted}        //  ALU pipe: int; $654
(W)     shl (1|M0)               r6.6<1>:q     r2.0<0;1,0>:d     4:w                                 //  ALU pipe: int; $670
(W)     add (1|M0)               r114.0<1>:q   r112.1<0;1,0>:q   r4.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $659
(W)     add (1|M0)               r112.0<1>:q   r112.1<0;1,0>:q   r2.1<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $666
(W)     shl (1|M0)               r6.7<1>:q     r2.1<0;1,0>:d     4:w               {I@7}             //  ALU pipe: int; $670
// B037: [inDivergent],  Preds:{B050, B036},  Succs:{B038, B039}
_0_174:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r61.11<0;1,0>:ud                 {Compacted}          //  ALU pipe: int; $678

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W&~f3.0) jmpi                               _0_175                                                  //  ALU pipe: int; $678
// B038: [inDivergent],  Preds:{B037},  Succs:{B040}
_0_176:
        mov (32|M0)              r100.0<1>:hf  0x0:hf                                                //  ALU pipe: float; $680
        mov (32|M0)              r102.0<1>:hf  0x0:hf                                                //  ALU pipe: float; $681
        mov (32|M0)              r96.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $682
        mov (32|M0)              r98.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $683
        mov (32|M0)              r30.0<1>:w    0:w                                                   //  ALU pipe: int; $684
        mov (32|M0)              r32.0<1>:w    0:w                               {$15.src}           //  ALU pipe: int; $685
        mov (32|M0)              r34.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $686
(W)     jmpi                                 _0_177                                                  // $687
// B039: [inDivergent],  Preds:{B037},  Succs:{B040}
_0_175:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M0)              r2.0<2>:ud    r42.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $691
        mov (16|M16)             r10.0<2>:ud   r43.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $691
        shl (16|M0)              r7.0<1>:q     r2.0<2;1,0>:ud    4:w               {@2,$8.src}       //  ALU pipe: int; $691
        shl (16|M16)             r12.0<1>:q    r10.0<2;1,0>:ud   4:w               {@2,$15.src}      //  ALU pipe: int; $691
        add (16|M0)              r14.0<1>:q    r82.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $692
        add (16|M16)             r16.0<1>:q    r80.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $692
        load.ugm.d32x4.a64 (32|M0)  r18:8       [r14:4]            {I@1,$9} // ex_desc:0x0; desc:0x8803580 // $693
        sync.nop                             null                             {Compacted,$1.src}     // $701
        shr (32|M0)              r26.0<1>:ud   r18.0<1;1,0>:ud   16:w               {$9.dst}         //  ALU pipe: int; $701
        shr (32|M0)              r28.0<1>:ud   r20.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $708
        shr (32|M0)              r2.0<1>:ud    r22.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $715
        mov (32|M0)              r34.0<1>:f    r24.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $697
        mov (32|M0)              r102.0<1>:w   r18.0<2;1,0>:w                   {F@4}                //  ALU pipe: int; $698
        mov (32|M0)              r98.0<1>:w    r20.0<2;1,0>:w                   {F@2}                //  ALU pipe: int; $705
        mov (32|M0)              r32.0<1>:w    r22.0<2;1,0>:w                                        //  ALU pipe: int; $712
        mov (32|M0)              r100.0<1>:w   r26.0<2;1,0>:w                   {I@6}                //  ALU pipe: int; $702
        mov (32|M0)              r96.0<1>:w    r28.0<2;1,0>:w                   {I@6}                //  ALU pipe: int; $709
        mov (32|M0)              r30.0<1>:w    r2.0<2;1,0>:w                    {I@6}                //  ALU pipe: int; $716
// B040: [inDivergent],  Preds:{B039, B038},  Succs:{B041, B042}
_0_177:

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
        mov (16|M0)              r2.0<2>:ud    r42.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $722
        mov (16|M16)             r8.0<2>:ud    r43.0<1;1,0>:ud                  {Compacted,$8.src}   //  ALU pipe: int; $722
        mov (16|M0)              r38.0<1>:q    r2.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $722
        mov (16|M16)             r36.0<1>:q    r8.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $722

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W&~f0.0) jmpi                               _0_178                                                  //  ALU pipe: int; $724
// B041: [inDivergent],  Preds:{B040},  Succs:{B043}
_0_179:
        mov (32|M0)              r101.0<1>:hf  0x0:hf                                                //  ALU pipe: float; $728
        mov (32|M0)              r103.0<1>:hf  0x0:hf                                                //  ALU pipe: float; $729
        mov (32|M0)              r97.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $730
        mov (32|M0)              r99.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $731
        mov (32|M0)              r31.0<1>:w    0:w                                                   //  ALU pipe: int; $732
        mov (32|M0)              r33.0<1>:w    0:w                                                   //  ALU pipe: int; $733
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $734
(W)     jmpi                                 _0_180                                                  // $735
// B042: [inDivergent],  Preds:{B040},  Succs:{B043}
_0_178:

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        shl (16|M0)              r2.0<1>:q     r38.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $738
        shl (16|M16)             r7.0<1>:q     r36.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $738
        add (16|M0)              r9.0<1>:q     r78.0<1;1,0>:q    r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $739
        add (16|M16)             r11.0<1>:q    r58.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $739
        load.ugm.d32x4.a64 (32|M0)  r14:8       [r9:4]             {I@1,$10} // ex_desc:0x0; desc:0x8803580 // $740
        sync.nop                             null                             {Compacted,$1.src}     // $748
        shr (32|M0)              r22.0<1>:ud   r14.0<1;1,0>:ud   16:w               {$10.dst}        //  ALU pipe: int; $748
        shr (32|M0)              r24.0<1>:ud   r16.0<1;1,0>:ud   16:w               {F@5}            //  ALU pipe: int; $755
        shr (32|M0)              r26.0<1>:ud   r18.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $762
        mov (32|M0)              r28.0<1>:f    r20.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $744
        mov (32|M0)              r103.0<1>:w   r14.0<2;1,0>:w                   {F@4}                //  ALU pipe: int; $745
        mov (32|M0)              r99.0<1>:w    r16.0<2;1,0>:w                   {F@2}                //  ALU pipe: int; $752
        mov (32|M0)              r33.0<1>:w    r18.0<2;1,0>:w                                        //  ALU pipe: int; $759
        mov (32|M0)              r101.0<1>:w   r22.0<2;1,0>:w                   {I@6}                //  ALU pipe: int; $749
        mov (32|M0)              r97.0<1>:w    r24.0<2;1,0>:w                   {I@6}                //  ALU pipe: int; $756
        mov (32|M0)              r31.0<1>:w    r26.0<2;1,0>:w                   {I@6}                //  ALU pipe: int; $763
// B043: [inDivergent],  Preds:{B042, B041},  Succs:{B044, B046}
_0_180:

// Line 1423:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f2.0) jmpi                               _0_181                                                  //  ALU pipe: int; $769
// B044: [inDivergent],  Preds:{B043},  Succs:{B045, B046}
_0_182:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r2:1  [r114:1]           {$11} // ex_desc:0x0; desc:0x2188780 // $774

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
        shl (16|M0)              r22.0<1>:q    r38.0<1;1,0>:q    4:w               {Compacted,$1.src} //  ALU pipe: int; $778
        shl (16|M16)             r20.0<1>:q    r36.0<1;1,0>:q    4:w               {Compacted,F@1}   //  ALU pipe: int; $778
(W)     add (1|M0)               r3.0<1>:q     r6.6<0;1,0>:q     r2.0<0;1,0>:q    {Compacted,$11.dst} //  ALU pipe: int; $777
        add (16|M0)              r7.0<1>:q     r3.0<0;1,0>:q     r22.0<1;1,0>:q   {Compacted,I@1}    //  ALU pipe: int; $779
        add (16|M16)             r9.0<1>:q     r3.0<0;1,0>:q     r20.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $779

// Line 1424:  recv_value_int4[j] = ld_nc_global(
        load.ugm.d32x4.a64 (32|M0)  r12:8       [r7:4]             {I@1,$12} // ex_desc:0x0; desc:0x8803580 // $782
        mov (32|M0)              r62.0<1>:w    r12.0<2;1,0>:w                   {$12.dst}            //  ALU pipe: int; $783
        mov (32|M0)              r63.0<1>:w    r12.1<2;1,0>:w                                        //  ALU pipe: int; $784
        mov (32|M0)              r64.0<1>:w    r14.0<2;1,0>:w                                        //  ALU pipe: int; $785
        mov (32|M0)              r65.0<1>:w    r14.1<2;1,0>:w                                        //  ALU pipe: int; $786
        mov (32|M0)              r66.0<1>:w    r16.0<2;1,0>:w                                        //  ALU pipe: int; $787
        mov (32|M0)              r67.0<1>:w    r16.1<2;1,0>:w                                        //  ALU pipe: int; $788
        mov (32|M0)              r68.0<1>:w    r18.0<2;1,0>:w                                        //  ALU pipe: int; $789
        mov (32|M0)              r69.0<1>:w    r18.1<2;1,0>:w                                        //  ALU pipe: int; $790

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
(W&~f1.0) jmpi                               _0_181                                                  //  ALU pipe: int; $801
// B045: [inDivergent],  Preds:{B044},  Succs:{B046}
_0_183:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r2:1  [r112:1]           {$6} // ex_desc:0x0; desc:0x2188780 // $806

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
(W)     add (1|M0)               r3.0<1>:q     r6.7<0;1,0>:q     r2.0<0;1,0>:q    {Compacted,$6.dst} //  ALU pipe: int; $809
        add (16|M0)              r7.0<1>:q     r3.0<0;1,0>:q     r22.0<1;1,0>:q   {Compacted,I@1}    //  ALU pipe: int; $810
        add (16|M16)             r9.0<1>:q     r3.0<0;1,0>:q     r20.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $810

// Line 1424:  recv_value_int4[j] = ld_nc_global(
        load.ugm.d32x4.a64 (32|M0)  r12:8       [r7:4]             {I@1,$9} // ex_desc:0x0; desc:0x8803580 // $813
        mov (32|M0)              r70.0<1>:w    r12.0<2;1,0>:w                   {$9.dst}             //  ALU pipe: int; $814
        mov (32|M0)              r71.0<1>:w    r12.1<2;1,0>:w                                        //  ALU pipe: int; $815
        mov (32|M0)              r72.0<1>:w    r14.0<2;1,0>:w                                        //  ALU pipe: int; $816
        mov (32|M0)              r73.0<1>:w    r14.1<2;1,0>:w                                        //  ALU pipe: int; $817
        mov (32|M0)              r74.0<1>:w    r16.0<2;1,0>:w                                        //  ALU pipe: int; $818
        mov (32|M0)              r75.0<1>:w    r16.1<2;1,0>:w                                        //  ALU pipe: int; $819
        mov (32|M0)              r76.0<1>:w    r18.0<2;1,0>:w                                        //  ALU pipe: int; $820
        mov (32|M0)              r77.0<1>:w    r18.1<2;1,0>:w                                        //  ALU pipe: int; $821
// B046: [inDivergent],  Preds:{B045, B044, B043},  Succs:{B047, B049}
_0_181:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 202:  return __devicelib_ConvertBF16ToFINTEL(a);
        shr (32|M0)              r8.0<1>:ud    r34.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $908
        shr (32|M0)              r10.0<1>:ud   r28.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $913
        mov (32|M0)              r2.0<1>:w     r34.0<2;1,0>:w                                        //  ALU pipe: int; $896
        mov (32|M0)              r3.0<1>:w     r28.0<2;1,0>:w                                        //  ALU pipe: int; $900
        mov (32|M0)              r7.0<1>:w     r8.0<2;1,0>:w                    {I@4}                //  ALU pipe: int; $909
        mov (32|M0)              r12.0<1>:w    r10.0<2;1,0>:w                   {I@4}                //  ALU pipe: int; $914

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1434:  values[j] = static_cast<float>(bias_0_values[j]) + static_cast<float>(bias_1_values[j]);
        add (16|M0)              r16.0<1>:f    r102.0<1;1,0>:bf  r103.0<1;1,0>:bf                    //  ALU pipe: float; $842
        add (16|M16)             r17.0<1>:f    r102.16<1;1,0>:bf  r103.16<1;1,0>:bf                  //  ALU pipe: float; $842
        add (16|M0)              r14.0<1>:f    r100.0<1;1,0>:bf  r101.0<1;1,0>:bf                    //  ALU pipe: float; $852
        add (16|M16)             r15.0<1>:f    r100.16<1;1,0>:bf  r101.16<1;1,0>:bf                  //  ALU pipe: float; $852
        add (16|M0)              r20.0<1>:f    r98.0<1;1,0>:bf   r99.0<1;1,0>:bf                     //  ALU pipe: float; $862
        add (16|M16)             r21.0<1>:f    r98.16<1;1,0>:bf  r99.16<1;1,0>:bf                    //  ALU pipe: float; $862
        add (16|M0)              r22.0<1>:f    r96.0<1;1,0>:bf   r97.0<1;1,0>:bf  {$1.src}           //  ALU pipe: float; $872
        add (16|M16)             r23.0<1>:f    r96.16<1;1,0>:bf  r97.16<1;1,0>:bf                    //  ALU pipe: float; $872
        add (16|M0)              r26.0<1>:f    r32.0<1;1,0>:bf   r33.0<1;1,0>:bf                     //  ALU pipe: float; $882
        add (16|M16)             r27.0<1>:f    r32.16<1;1,0>:bf  r33.16<1;1,0>:bf                    //  ALU pipe: float; $882
        add (16|M0)              r28.0<1>:f    r7.0<1;1,0>:bf    r12.0<1;1,0>:bf  {I@1}              //  ALU pipe: float; $918
        add (16|M16)             r29.0<1>:f    r7.16<1;1,0>:bf   r12.16<1;1,0>:bf                    //  ALU pipe: float; $918
        add (16|M0)              r32.0<1>:f    r30.0<1;1,0>:bf   r31.0<1;1,0>:bf                     //  ALU pipe: float; $892
        add (16|M16)             r33.0<1>:f    r30.16<1;1,0>:bf  r31.16<1;1,0>:bf                    //  ALU pipe: float; $892
        add (16|M0)              r30.0<1>:f    r2.0<1;1,0>:bf    r3.0<1;1,0>:bf                      //  ALU pipe: float; $904
        add (16|M16)             r31.0<1>:f    r2.16<1;1,0>:bf   r3.16<1;1,0>:bf                     //  ALU pipe: float; $904

// Line 1438:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f2.0) jmpi                               _0_184                                                  //  ALU pipe: int; $921
// B047: [inDivergent],  Preds:{B046},  Succs:{B048, B049}
_0_185:

// Line 1441:  values[k] += static_cast<float>(recv_value_dtypes[k]);
        add (16|M0)              r16.0<1>:f    r16.0<1;1,0>:f    r62.0<1;1,0>:bf                     //  ALU pipe: float; $929
        add (16|M16)             r17.0<1>:f    r17.0<1;1,0>:f    r62.16<1;1,0>:bf                    //  ALU pipe: float; $929
        add (16|M0)              r14.0<1>:f    r14.0<1;1,0>:f    r63.0<1;1,0>:bf                     //  ALU pipe: float; $936
        add (16|M16)             r15.0<1>:f    r15.0<1;1,0>:f    r63.16<1;1,0>:bf                    //  ALU pipe: float; $936
        add (16|M0)              r20.0<1>:f    r20.0<1;1,0>:f    r64.0<1;1,0>:bf                     //  ALU pipe: float; $943
        add (16|M16)             r21.0<1>:f    r21.0<1;1,0>:f    r64.16<1;1,0>:bf                    //  ALU pipe: float; $943
        add (16|M0)              r22.0<1>:f    r22.0<1;1,0>:f    r65.0<1;1,0>:bf                     //  ALU pipe: float; $950
        add (16|M16)             r23.0<1>:f    r23.0<1;1,0>:f    r65.16<1;1,0>:bf                    //  ALU pipe: float; $950
        add (16|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r66.0<1;1,0>:bf                     //  ALU pipe: float; $957
        add (16|M16)             r27.0<1>:f    r27.0<1;1,0>:f    r66.16<1;1,0>:bf                    //  ALU pipe: float; $957
        add (16|M0)              r32.0<1>:f    r32.0<1;1,0>:f    r67.0<1;1,0>:bf                     //  ALU pipe: float; $964
        add (16|M16)             r33.0<1>:f    r33.0<1;1,0>:f    r67.16<1;1,0>:bf                    //  ALU pipe: float; $964
        add (16|M0)              r30.0<1>:f    r30.0<1;1,0>:f    r68.0<1;1,0>:bf                     //  ALU pipe: float; $971
        add (16|M16)             r31.0<1>:f    r31.0<1;1,0>:f    r68.16<1;1,0>:bf                    //  ALU pipe: float; $971
        add (16|M0)              r28.0<1>:f    r28.0<1;1,0>:f    r69.0<1;1,0>:bf                     //  ALU pipe: float; $978
        add (16|M16)             r29.0<1>:f    r29.0<1;1,0>:f    r69.16<1;1,0>:bf                    //  ALU pipe: float; $978

// Line 1438:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f1.0) jmpi                               _0_184                                                  //  ALU pipe: int; $981
// B048: [inDivergent],  Preds:{B047},  Succs:{B049}
_0_186:

// Line 1441:  values[k] += static_cast<float>(recv_value_dtypes[k]);
        add (16|M0)              r16.0<1>:f    r16.0<1;1,0>:f    r70.0<1;1,0>:bf                     //  ALU pipe: float; $989
        add (16|M16)             r17.0<1>:f    r17.0<1;1,0>:f    r70.16<1;1,0>:bf                    //  ALU pipe: float; $989
        add (16|M0)              r14.0<1>:f    r14.0<1;1,0>:f    r71.0<1;1,0>:bf                     //  ALU pipe: float; $996
        add (16|M16)             r15.0<1>:f    r15.0<1;1,0>:f    r71.16<1;1,0>:bf                    //  ALU pipe: float; $996
        add (16|M0)              r20.0<1>:f    r20.0<1;1,0>:f    r72.0<1;1,0>:bf                     //  ALU pipe: float; $1003
        add (16|M16)             r21.0<1>:f    r21.0<1;1,0>:f    r72.16<1;1,0>:bf                    //  ALU pipe: float; $1003
        add (16|M0)              r22.0<1>:f    r22.0<1;1,0>:f    r73.0<1;1,0>:bf                     //  ALU pipe: float; $1010
        add (16|M16)             r23.0<1>:f    r23.0<1;1,0>:f    r73.16<1;1,0>:bf                    //  ALU pipe: float; $1010
        add (16|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r74.0<1;1,0>:bf                     //  ALU pipe: float; $1017 R{} IR{}{E:5,E:5,},  {BC=1}
        add (16|M16)             r27.0<1>:f    r27.0<1;1,0>:f    r74.16<1;1,0>:bf                    //  ALU pipe: float; $1017
        add (16|M0)              r32.0<1>:f    r32.0<1;1,0>:f    r75.0<1;1,0>:bf                     //  ALU pipe: float; $1024
        add (16|M16)             r33.0<1>:f    r33.0<1;1,0>:f    r75.16<1;1,0>:bf                    //  ALU pipe: float; $1024
        add (16|M0)              r30.0<1>:f    r30.0<1;1,0>:f    r76.0<1;1,0>:bf                     //  ALU pipe: float; $1031
        add (16|M16)             r31.0<1>:f    r31.0<1;1,0>:f    r76.16<1;1,0>:bf                    //  ALU pipe: float; $1031
        add (16|M0)              r28.0<1>:f    r28.0<1;1,0>:f    r77.0<1;1,0>:bf                     //  ALU pipe: float; $1038
        add (16|M16)             r29.0<1>:f    r29.0<1;1,0>:f    r77.16<1;1,0>:bf                    //  ALU pipe: float; $1038
// B049: [inDivergent],  Preds:{B048, B047, B046},  Succs:{B050, B051}
_0_184:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r7.0<1>:bf    r20.0<1;1,0>:f                                        //  ALU pipe: float; $1058
        mov (16|M0)              r20.0<1>:bf   r22.0<1;1,0>:f                   {F@7}                //  ALU pipe: float; $1063
        mov (16|M16)             r20.16<1>:bf  r23.0<1;1,0>:f                   {F@7}                //  ALU pipe: float; $1063

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        mov (32|M0)              r22.0<1>:d    r20.0<1;1,0>:uw                  {F@1}                //  ALU pipe: int; $1066

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r3.0<1>:bf    r14.0<1;1,0>:f                                        //  ALU pipe: float; $1048
        mov (16|M16)             r3.16<1>:bf   r15.0<1;1,0>:f                                        //  ALU pipe: float; $1048
        mov (16|M16)             r7.16<1>:bf   r21.0<1;1,0>:f                                        //  ALU pipe: float; $1058

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        shl (32|M0)              r24.0<1>:d    r22.0<1;1,0>:d    16:w               {Compacted,I@1}  //  ALU pipe: int; $1067

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M16)             r21.16<1>:bf  r27.0<1;1,0>:f                                        //  ALU pipe: float; $1073
        mov (16|M0)              r27.0<1>:bf   r28.0<1;1,0>:f                                        //  ALU pipe: float; $1093
        mov (16|M16)             r27.16<1>:bf  r29.0<1;1,0>:f                                        //  ALU pipe: float; $1093

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        mov (32|M0)              r8.0<1>:d     r3.0<1;1,0>:uw                   {F@5}                //  ALU pipe: int; $1051
        mov (32|M0)              r22.0<1>:d    r27.0<1;1,0>:uw                  {F@1}                //  ALU pipe: int; $1096

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r21.0<1>:bf   r26.0<1;1,0>:f                                        //  ALU pipe: float; $1073

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        or (32|M0)               r14.0<1>:d    r24.0<1;1,0>:d    r7.0<1;1,0>:uw   {I@3}              //  ALU pipe: int; $1069
        shl (32|M0)              r10.0<1>:d    r8.0<1;1,0>:d     16:w               {Compacted,I@3}  //  ALU pipe: int; $1052

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r26.0<1>:bf   r32.0<1;1,0>:f                                        //  ALU pipe: float; $1078
        mov (16|M16)             r26.16<1>:bf  r33.0<1;1,0>:f                                        //  ALU pipe: float; $1078
        mov (16|M0)              r2.0<1>:bf    r16.0<1;1,0>:f                                        //  ALU pipe: float; $1043
        mov (16|M16)             r2.16<1>:bf   r17.0<1;1,0>:f                                        //  ALU pipe: float; $1043

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        shl (32|M0)              r24.0<1>:d    r22.0<1;1,0>:d    16:w               {Compacted,I@3}  //  ALU pipe: int; $1097

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r3.0<1>:bf    r30.0<1;1,0>:f                                        //  ALU pipe: float; $1088
        mov (16|M16)             r3.16<1>:bf   r31.0<1;1,0>:f                                        //  ALU pipe: float; $1088

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        mov (32|M0)              r8.0<1>:d     r26.0<1;1,0>:uw                  {F@5}                //  ALU pipe: int; $1081
        or (32|M0)               r12.0<1>:d    r10.0<1;1,0>:d    r2.0<1;1,0>:uw   {A@3}              //  ALU pipe: int; $1054
        or (32|M0)               r18.0<1>:d    r24.0<1;1,0>:d    r3.0<1;1,0>:uw   {A@1}              //  ALU pipe: int; $1099
        shl (32|M0)              r10.0<1>:d    r8.0<1;1,0>:d     16:w               {Compacted,I@3}  //  ALU pipe: int; $1082

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 202:  return __devicelib_ConvertBF16ToFINTEL(a);
        shl (16|M0)              r8.0<1>:ud    r2.0<1;1,0>:uw    0x10:uw                             //  ALU pipe: int; $1108
        shl (16|M16)             r9.0<1>:ud    r2.16<1;1,0>:uw   0x10:uw                             //  ALU pipe: int; $1108

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        add (32|M0)              r2.0<1>:d     r42.0<1;1,0>:d    32:w               {Compacted}      //  ALU pipe: int; $1116

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        shl (16|M0)              r28.0<1>:q    r38.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $1102
        shl (16|M16)             r30.0<1>:q    r36.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $1102

// Line 1481:  recv_topk_weights_[8] = static_cast<float>(reinterpret_cast<const dtype_t*>(&out_int4)[0]);
(W)     mov (1|M0)               r4.0<1>:q     r5.0<0;1,0>:q                                         //  ALU pipe: int; $1111

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        or (32|M0)               r16.0<1>:d    r10.0<1;1,0>:d    r21.0<1;1,0>:uw  {I@7}              //  ALU pipe: int; $1084

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        cmp (32|M0)   (lt)f3.0   null<1>:d     r2.0<1;1,0>:d     r61.0<0;1,0>:d   {I@5}              //  ALU pipe: int; $1119

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M0)              r32.0<1>:q    r56.0<1;1,0>:q    r28.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1103
        add (16|M16)             r34.0<1>:q    r54.0<1;1,0>:q    r30.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1103

// Line 1481:  recv_topk_weights_[8] = static_cast<float>(reinterpret_cast<const dtype_t*>(&out_int4)[0]);
        mov (16|M0)              r36.0<2>:f    r4.0<0;1,0>:f                    {I@5}                //  ALU pipe: float; $1112
        mov (16|M16)             r38.0<2>:f    r4.0<0;1,0>:f                                         //  ALU pipe: float; $1112
        mov (16|M0)              r36.1<2>:f    r4.1<0;1,0>:f                                         //  ALU pipe: float; $1113
        mov (16|M16)             r38.1<2>:f    r4.1<0;1,0>:f                                         //  ALU pipe: float; $1113

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        store.ugm.d32x4.a64 (32|M0)  [r32:4]    r12:8              {I@1,$15} // ex_desc:0x0; desc:0x8003584 // $1104

// Line 1481:  recv_topk_weights_[8] = static_cast<float>(reinterpret_cast<const dtype_t*>(&out_int4)[0]);
        store.ugm.d32.a64 (32|M0)  [r36:4+0x20] r8:2               {F@1,$8} // ex_desc:0x20000; desc:0x8000584 // $1114

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
(~f3.0) goto (32|M0)                         _0_172            _0_172                                //  ALU pipe: int; $1120
// B050: [inDivergent],  Preds:{B049},  Succs:{B037}
_0_187:
        mov (32|M0)              r42.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1122
(W)     jmpi                                 _0_174                                                  // $1123
// B051: [inDivergent],  Preds:{B049, B035},  Succs:{B052, B057}
_0_172:
        join (32|M0)                         _0_149                                                  // 
L9136:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r112.12<0;1,0>:ud                {Compacted}          //  ALU pipe: int; $1127

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1492:  if (lane_id < num_topk_) {
(~f3.0) goto (32|M0)                         _0_188            _0_188                                //  ALU pipe: int; $1127
// B052: [inDivergent],  Preds:{B051},  Succs:{B053, B054}
_0_189:

// Line 1494:  for (int i = 0; i < num_topk_ranks; ++i) {
(W)     cmp (32|M0)   (gt)f3.0   null<1>:d     r61.9<0;1,0>:d    0:w                                 //  ALU pipe: int; $1131
(W&f3.0) jmpi                                _0_190                                                  //  ALU pipe: int; $1132
// B053: [inDivergent],  Preds:{B052},  Succs:{B056}
_0_191:
        mov (32|M0)              r26.0<1>:ud   0x0:ud                              {Compacted,$1.src} //  ALU pipe: int; $1134
(W)     jmpi                                 _0_192                                                  // $1135
// B054: [inDivergent],  Preds:{B052},  Succs:{B055, B056}
_0_190:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     shl (1|M0)               r2.0<1>:q     r61.3<0;1,0>:d    4:w               {F@1}             //  ALU pipe: int; $1147

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     mul (1|M0)               acc0.0<1>:d   r61.1<0;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1153

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     add (1|M0)               r4.0<1>:q     r61.7<0;1,0>:q    r2.0<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1148

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W)     macl (1|M0)              r3.0<1>:d     r61.1<0;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1155

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r7:1  [r4:1]             {I@2,$10} // ex_desc:0x0; desc:0x2188780 // $1149

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     shl (1|M0)               r4.4<1>:q     r3.0<0;1,0>:d     2:w               {@1,$10.src}      //  ALU pipe: int; $1158

// Line 1494:  for (int i = 0; i < num_topk_ranks; ++i) {
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r61.9<0;1,0>:d    1:w                                 //  ALU pipe: int; $1168

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
        sync.nop                             null                             {Compacted,$8.src}     // $1155
        add (16|M0)              r8.0<1>:q     r88.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted,$10.dst} //  ALU pipe: int; $1155
        add (16|M16)             r10.0<1>:q    r86.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1155

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
        sync.nop                             null                             {Compacted,$0.src}     // $1159
        add (16|M0)              r12.0<1>:q    r8.0<1;1,0>:q     r4.4<0;1,0>:q    {Compacted,@2,$15.src} //  ALU pipe: int; $1159
        add (16|M16)             r14.0<1>:q    r10.0<1;1,0>:q    r4.4<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1159

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r26:2         [r12:4]            {I@1,$11} // ex_desc:0x0; desc:0x8200580 // $1164

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W&f2.0) jmpi                                _0_192                                                  //  ALU pipe: int; $1170
// B055: [inDivergent],  Preds:{B054},  Succs:{B056}
_0_193:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     shl (1|M0)               r2.0<1>:q     r61.4<0;1,0>:d    4:w                                 //  ALU pipe: int; $1180

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     mul (1|M0)               acc0.0<1>:d   r61.2<0;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1186

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     add (1|M0)               r4.0<1>:q     r61.7<0;1,0>:q    r2.0<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1181

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W)     macl (1|M0)              r3.0<1>:d     r61.2<0;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1188

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r7:1  [r4:1]             {I@2,$12} // ex_desc:0x0; desc:0x2188780 // $1182

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     shl (1|M0)               r4.4<1>:q     r3.0<0;1,0>:d     2:w               {@1,$12.src}      //  ALU pipe: int; $1191

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
        add (16|M0)              r8.0<1>:q     r88.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted,$12.dst} //  ALU pipe: int; $1188
        add (16|M16)             r10.0<1>:q    r86.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1188

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
        add (16|M0)              r12.0<1>:q    r8.0<1;1,0>:q     r4.4<0;1,0>:q    {Compacted,@2,$11.src} //  ALU pipe: int; $1192
        add (16|M16)             r14.0<1>:q    r10.0<1;1,0>:q    r4.4<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1192

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r16:2         [r12:4]            {I@1,$6} // ex_desc:0x0; desc:0x8200580 // $1197

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1495:  value += ld_nc_global(
        sync.nop                             null                             {Compacted,$6.dst}     // $1200
        sync.nop                             null                             {Compacted,$1.src}     // $1200
        add (32|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,$11.dst} //  ALU pipe: float; $1200
// B056: [inDivergent],  Preds:{B055, B054, B053},  Succs:{B057}
_0_192:

// Line 1499:  recv_topk_weights_[token_idx * num_topk_ + lane_id] = value;
(W)     mul (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1205
        macl (16|M0)             r2.0<1>:ud    r40.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1205
(W)     mul (16|M16)             acc0.0<1>:ud  r41.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1205
        macl (16|M16)            r3.0<1>:ud    r41.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1206
(W)     mul (16|M0)              acc0.0<1>:ud  r40.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1206
        mach (16|M0)             r8.0<1>:d     r40.0<1;1,0>:ud   r6.6<0;1,0>:ud   {$8.src}           //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r41.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1206
        mach (16|M16)            r9.0<1>:d     r41.0<1;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; $1207
(W)     mul (16|M0)              acc0.0<1>:d   r40.0<1;1,0>:ud   r61.24<0;1,0>:uw                    //  ALU pipe: int; $1207
        macl (16|M0)             r10.0<1>:d    r40.0<1;1,0>:ud   r61.12<0;1,0>:d                     //  ALU pipe: int; $1207
(W)     mul (16|M16)             acc0.0<1>:d   r41.0<1;1,0>:ud   r61.24<0;1,0>:uw                    //  ALU pipe: int; $1207
        macl (16|M16)            r11.0<1>:d    r41.0<1;1,0>:ud   r61.12<0;1,0>:d                     //  ALU pipe: int; $1208
        add (32|M0)              r8.0<1>:d     r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1208
(W)     mul (16|M0)              acc0.0<1>:d   r6.6<0;1,0>:ud    r48.0<2;1,0>:uw                     //  ALU pipe: int; $1209
        macl (16|M0)             r10.0<1>:d    r6.6<0;1,0>:ud    r48.0<1;1,0>:d                      //  ALU pipe: int; $1209
(W)     mul (16|M16)             acc0.0<1>:d   r6.6<0;1,0>:ud    r49.0<2;1,0>:uw                     //  ALU pipe: int; $1209
        macl (16|M16)            r11.0<1>:d    r6.6<0;1,0>:ud    r49.0<1;1,0>:d                      //  ALU pipe: int; $1211
        sync.allrd                           ($0,$11)                                                // $1211
        add (32|M0)              r12.0<1>:d    r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,@1,$15.src} //  ALU pipe: int; $1211
        mov (16|M0)              r14.0<2>:d    r2.0<1;1,0>:d                                         //  ALU pipe: int; $1214
        mov (16|M16)             r16.0<2>:d    r3.0<1;1,0>:d                    {F@1}                //  ALU pipe: int; $1215
        mov (16|M0)              r14.1<2>:d    r12.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $1216
        mov (16|M16)             r16.1<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1217
        shl (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1218
        shl (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1218
        add (16|M0)              r22.0<1>:q    r94.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,@2,$1.src} //  ALU pipe: int; $1219
        add (16|M16)             r24.0<1>:q    r92.0<1;1,0>:q    r20.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1219
        sync.nop                             null                             {Compacted,$11.dst}    // $1220
        store.ugm.d32.a64 (32|M0)  [r22:4]      r26:2              {I@1,$1} // ex_desc:0x0; desc:0x8000584 // $1220
// B057: [inDivergent],  Preds:{B056, B051},  Succs:{B058, B059}
_0_188:
        join (32|M0)                         _0_149                                                  // 
L9952:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r46.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $1224

// Line 1503:  if (lane_id < kNumRanks) {
(~f1.0) goto (32|M0)                         _0_194            _0_194                                //  ALU pipe: int; $1226
// B058: [inDivergent],  Preds:{B057},  Succs:{B059}
_0_195:

// Line 1505:  (expected_head < 0) ? -expected_head - 1 : expected_head + 1;
        cmp (32|M0)   (lt)f3.0   r10.0<1>:d    r44.0<1;1,0>:d    0:w                                 //  ALU pipe: int; $1231
        add (32|M0)              r8.0<1>:d     r44.0<1;1,0>:d    1:w               {Compacted,$8.src} //  ALU pipe: int; $1230
        not (32|M0)              r2.0<1>:d     r44.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1229
        sync.nop                             null                             {Compacted,$0.src}     // $1232
        bfn.(s0&s1|~s0&s2) (32|M0)   r12.0<1>:ud  r10.0<1;0>:ud  r2.0<1;0>:ud      r8.0<1>:ud       {@1,$15.src} //  ALU pipe: int; $1232 R{} IR{}{E:5,E:1,E:4,},  R{} IR{}{O:5,O:1,O:4,},  {BC=2}

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        store.slm.d32.a32 (32|M0)  [r108:2]     r12:2              {I@1,$0} // ex_desc:0x0; desc:0x4000504 // $1234
// B059: [inDivergent],  Preds:{B058, B057},  Succs:{B060, B061}
_0_194:
        join (32|M0)                         _0_149                                                  // 
L10072:

// Line 1371:  token_idx += num_recv_warps - 1) {
        add (16|M0)              r52.0<1>:q    r52.0<1;1,0>:q    1:w               {Compacted}       //  ALU pipe: int; $1238
        add (16|M16)             r50.0<1>:q    r50.0<1;1,0>:q    1:w               {Compacted}       //  ALU pipe: int; $1238
        mov (16|M0)              r2.0<1>:d     r52.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1240
        mov (16|M16)             r3.0<1>:d     r50.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1241

// Line 1370:  token_idx < token_end_idx;
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r2.0<1;1,0>:ud    r112.9<0;1,0>:ud {I@1}              //  ALU pipe: int; $1245
        mov (16|M0)              r8.0<1>:d     r52.1<2;1,0>:d                   {Compacted,$8.src}   //  ALU pipe: int; $1242
        mov (16|M16)             r9.0<1>:d     r50.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1243
(f1.0)  cmp (32|M0)   (eq)f1.0   null<1>:d     r8.0<1;1,0>:d     r112.8<0;1,0>:d  {I@1}              //  ALU pipe: int; $1246
(~f1.0) cmp (32|M0)   (lt)f1.0   null<1>:d     r8.0<1;1,0>:d     r112.8<0;1,0>:d                     //  ALU pipe: int; $1248

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
(~f1.0) goto (32|M0)                         _0_149            _0_149                                //  ALU pipe: int; $1251
// B060: [inDivergent],  Preds:{B059},  Succs:{B015}
_0_196:
(W)     mov (2|M0)               r61.7<1>:d    r61.1<1;1,0>:d                                        //  ALU pipe: int; $1253
(W)     mov (2|M0)               r61.5<1>:d    r61.3<1;1,0>:d                                        //  ALU pipe: int; $1254
(W)     jmpi                                 _0_151                                                  // $1255
// B061: [inDivergent],  Preds:{B059, B013},  Succs:{B062, B063}
_0_149:
        join (32|M0)                         _0_144                                                  // 
L10248:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     mov (8|M0)               r2.0<1>:w     0x76543210:v                                          //  ALU pipe: int; $1266
(W)     add (8|M0)               r2.8<1>:w     r2.0<1;1,0>:w     8:w               {I@1}             //  ALU pipe: int; $1267
(W)     add (16|M0)              r2.16<1>:w    r2.0<1;1,0>:w     16:w               {I@1}            //  ALU pipe: int; $1268

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (eq)f1.0   null<2>:w     r2.0<1;1,0>:w     0:w               {I@1}             //  ALU pipe: int; $1271

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1511:  if (elect_one_sync(item)) {
(~f1.0) goto (32|M0)                         _0_197            _0_197                                //  ALU pipe: int; $1274
// B062: [inDivergent],  Preds:{B061},  Succs:{B063}
_0_198:

// Line 1512:  warp_retired[recv_warp_id] = 1;  // true
        shl (32|M0)              r2.0<1>:d     r90.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $1279
        sync.nop                             null                             {Compacted,$8.src}     // $1280
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r4.4<0;1,0>:d    {Compacted,@1,$2.src} //  ALU pipe: int; $1280
        mov (32|M0)              r10.0<1>:d    1:w                               {Compacted}         //  ALU pipe: int; $1281
        store.slm.d32.a32 (32|M0)  [r8:2]       r10:2              {I@1,$9} // ex_desc:0x0; desc:0x4000504 // $1282
// B063: [inDivergent],  Preds:{B062, B061},  Succs:{B106}
_0_197:
        join (32|M0)                         _0_144                                                  // 
L10392:

// Line 1514:  }
        goto (32|M0)                         _0_144            _0_199                                // $1286
// B064: [inDivergent],  Preds:{B009},  Succs:{B065, B106}
_0_144:
        join (32|M0)                         _0_199                                                  // 
L10424:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r46.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $1290

// Line 1304:  while (lane_id < kNumRanks) {
(~f0.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1292
// B065: [inDivergent],  Preds:{B064},  Succs:{B066}
_0_200:

// Line 1299:  int* channel_head_idx_ptr = static_cast<int*>(buffer_ptrs_[rank_]) + responsible_channel * kNumRanks + lane_id;
(W)     shl (1|M0)               r2.0<1>:q     r6.7<0;1,0>:d     3:w                                 //  ALU pipe: int; $1296
(W)     and (1|M0)               r3.2<1>:d     r60.1<0;1,0>:d    2147483646:d               {$7.src} //  ALU pipe: int; $1299
(W)     add (1|M0)               r4.0<1>:q     r2.0<0;1,0>:q     r6.1<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1297
(W)     shl (1|M0)               r6.6<1>:q     r3.2<0;1,0>:ud    2:w               {I@2}             //  ALU pipe: int; $1301
(W)     load.ugm.d64x1t.a64 (1|M0)  r3:1        [r4:1]             {I@1,$10} // ex_desc:0x0; desc:0x2108780 // $1298
        sync.allrd                           ($2,$5,$8,$9)                                           // $1303
        shl (16|M0)              r8.0<1>:q     r52.0<1;1,0>:q    2:w               {Compacted,$3.src} //  ALU pipe: int; $1303
        shl (16|M16)             r10.0<1>:q    r110.0<1;1,0>:q   2:w               {Compacted,$4.src} //  ALU pipe: int; $1303

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
        sync.allrd                           ($0,$15)                                                // $1307
(W)     and (1|M0)               r12.0<1>:d    r112.4<0;1,0>:d   -2:w               {Compacted,$14.src} //  ALU pipe: int; $1307

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        shl (32|M0)              r18.0<1>:d    r40.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $1319

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
(W)     shl (1|M0)               r13.0<1>:q    r12.0<0;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1309

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        add (32|M0)              r20.0<1>:d    r18.0<1;1,0>:d    r4.2<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1320

// Line 1308:  if (warp_retired[i] == 0) {
(W)     add (1|M0)               r6.0<1>:d     r4.4<0;1,0>:d     4:w               {Compacted}       //  ALU pipe: int; $1315

// Line 1299:  int* channel_head_idx_ptr = static_cast<int*>(buffer_ptrs_[rank_]) + responsible_channel * kNumRanks + lane_id;
(W)     add (1|M0)               r7.0<1>:q     r6.6<0;1,0>:q     r3.0<0;1,0>:q    {Compacted,$10.dst} //  ALU pipe: int; $1302
        add (16|M0)              r14.0<1>:q    r7.0<0;1,0>:q     r8.0<1;1,0>:q    {Compacted,@1,$13.src} //  ALU pipe: int; $1304
        add (16|M16)             r16.0<1>:q    r7.0<0;1,0>:q     r10.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1304

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
        add (16|M0)              r7.0<1>:q     r14.0<1;1,0>:q    r13.0<0;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1310
        add (16|M16)             r9.0<1>:q     r16.0<1;1,0>:q    r13.0<0;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1310

// Line 1308:  if (warp_retired[i] == 0) {
        mov (32|M0)              r12.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1322
// B066: [inDivergent],  Preds:{B073, B065},  Succs:{B067, B106}
_0_201:
        sync.allrd                           ($2,$12)                                                // $1326
(W)     load.slm.d32x1t.a32 (1|M0)  r2:1        [r6:1]             {$11} // ex_desc:0x0; desc:0x2108500 // $1326
(W)     cmp (32|M0)   (eq)f0.0   null<1>:d     r2.0<0;1,0>:d     0:w               {$11.dst}         //  ALU pipe: int; $1327
(~f0.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1328
// B067: [inDivergent],  Preds:{B066},  Succs:{B068, B069}
_0_202:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 216:  asm volatile (
        load.ugm.d32.a64.uc.uc (32|M0)  r2:2    [r7:4]             {I@2,$3} // ex_desc:0x0; desc:0x8220580 // $1333

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        sync.nop                             null                             {Compacted,$3.dst}     // $1337
        store.slm.d32.a32 (32|M0)  [r20:2]      r2:2               {$12} // ex_desc:0x0; desc:0x4000504 // $1337

// Line 1321:  if (warp_retired[i] == 0) {
(W)     load.slm.d32x1t.a32 (1|M0)  r4:1        [r6:1]             {$4} // ex_desc:0x0; desc:0x2108500 // $1340
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r4.0<0;1,0>:d     0:w               {$4.dst}          //  ALU pipe: int; $1341
(W&f3.0) jmpi                                _0_203                                                  //  ALU pipe: int; $1342
// B068: [inDivergent],  Preds:{B067},  Succs:{B070}
_0_204:
        mov (32|M0)              r2.0<1>:f     0x7FFFFFFF:f                               {$12.src}  //  (0x7fffffff:f); ALU pipe: float; $1344
(W)     jmpi                                 _0_205                                                  // $1345
// B069: [inDivergent],  Preds:{B067},  Succs:{B070}
_0_203:

// Line 1322:  int warp_head = warp_channel_head_idx[i * kNumRanks + lane_id];
        load.slm.d32.a32 (32|M0)  r2:2          [r18:2+0x8]        {F@1,$5} // ex_desc:0x8000; desc:0x4200500 // $1348
// B070: [inDivergent],  Preds:{B069, B068},  Succs:{B071, B072}
_0_205:
        cmp (32|M0)   (gt)f2.0   null<1>:d     r2.0<1;1,0>:d     r12.0<1;1,0>:d   {$5.dst}           //  ALU pipe: int; $1354

// Line 1330:  if (min_head != std::numeric_limits<int>::max() && min_head > last_head) {
(f2.0)  cmp (32|M0)   (ne)f2.0   null<1>:d     r2.0<1;1,0>:d     2147483647:d                        //  ALU pipe: int; $1356
(f2.0)  goto (32|M0)                         _0_206            _0_206                                //  ALU pipe: int; $1358
// B071: [inDivergent],  Preds:{B070},  Succs:{B073}
_0_207:
        sync.nop                             null                             {Compacted,I@2}        // $1360
        mov (32|M0)              r2.0<1>:f     r12.0<1;1,0>:f                   {Compacted,$12.src}  //  ALU pipe: float; $1360
        goto (32|M0)                         _0_206            _0_208                                // $1361
// B072: [inDivergent],  Preds:{B070},  Succs:{B073}
_0_206:
        join (32|M0)                         _0_208                                                  // 
L10968:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 234:  asm volatile (
        store.ugm.d32.a64.uc.uc (32|M0)  [r14:4] r2:2              {F@1,$2} // ex_desc:0x0; desc:0x8020584 // $1366
// B073: [inDivergent],  Preds:{B072, B071},  Succs:{B066}
_0_208:
        join (32|M0)                         _0_199                                                  // 
L11000:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        mov (32|M0)              r12.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1372
(W)     jmpi                                 _0_201                                                  // $1373
// B074: [inDivergent],  Preds:{B002},  Succs:{B075, B076}
_0_136:

// Line 1165:  const int send_rank_id = (responsible_channel + send_warp_id) % kNumRanks;
        add (32|M0)              r2.0<1>:d     r112.10<0;1,0>:d  r90.0<1;1,0>:d   {Compacted,F@1}    //  ALU pipe: int; $1380
        and (32|M0)   (eq)f1.0   r18.0<1>:d    r2.0<1;1,0>:d     1:w               {I@1}             //  ALU pipe: int; $1381

// Line 1170:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[send_rank_id]));
        shl (32|M0)              r8.0<1>:d     r18.0<1;1,0>:d    3:w               {Compacted,I@1}   //  ALU pipe: int; $1384
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1386
        mov (16|M16)             r16.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1386
        add (16|M0)              r12.0<1>:q    r6.1<0;1,0>:q     r10.0<2;1,0>:ud  {I@2}              //  ALU pipe: int; $1386
        add (16|M16)             r14.0<1>:q    r6.1<0;1,0>:q     r16.0<2;1,0>:ud  {I@2}              //  ALU pipe: int; $1386
        load.ugm.d64.a64 (32|M0)  r24:4         [r12:4]            {I@1,$6} // ex_desc:0x0; desc:0x8400780 // $1387

// Line 1171:  auto num_channels_total = num_channels * kNumRanks;
(W)     and (1|M0)               r61.4<1>:d    r112.4<0;1,0>:d   -2:w                                //  ALU pipe: int; $1390

// Line 1172:  auto channel_rank_offset = responsible_channel * kNumRanks + rank_;  // 写入时用自己的rank标识来源
(W)     add (1|M0)               r61.5<1>:d    r60.1<0;1,0>:d    r6.7<0;1,0>:d                       //  ALU pipe: int; $1393

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     asr (1|M0)               r4.3<1>:d     r6.10<0;1,0>:d    31:w                                //  ALU pipe: int; $1402
(W)     mul (1|M0)               acc0.0<1>:ud  r61.4<0;1,0>:ud   r6.20<0;1,0>:uw  {I@3}              //  ALU pipe: int; $1403
(W)     macl (1|M0)              r32.0<1>:ud   r61.4<0;1,0>:ud   r6.10<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1404
(W)     mul (1|M0)               acc0.0<1>:ud  r61.4<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1404

// Line 1180:  auto channel_head_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
(W)     asr (2|M0)               r4.0<1>:d     r61.4<1;1,0>:d    31:w               {Compacted,I@5}  //  ALU pipe: int; $1396
(W)     mach (1|M0)              r2.0<1>:d     r61.4<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; 

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mul (1|M0)               acc0.0<1>:d   r61.4<0;1,0>:ud   r4.6<0;1,0>:uw   {I@6}              //  ALU pipe: int; $1405
(W)     macl (1|M0)              r3.0<1>:d     r61.4<0;1,0>:ud   r4.3<0;1,0>:d                       //  ALU pipe: int; $1406
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r4.0<0;1,0>:uw   {I@4}              //  ALU pipe: int; $1407
(W)     asr (1|M0)               r61.1<1>:d    r61.0<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $1410
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@3}    //  ALU pipe: int; $1406
(W)     macl (1|M0)              r3.0<1>:d     r6.10<0;1,0>:ud   r4.0<0;1,0>:d                       //  ALU pipe: int; $1409
(W)     mul (1|M0)               acc0.0<1>:ud  r32.0<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1411
(W)     macl (1|M0)              r38.0<1>:ud   r32.0<0;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1412
(W)     mul (1|M0)               acc0.0<1>:ud  r32.0<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1412
(W)     add (1|M0)               r32.2<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@4}    //  ALU pipe: int; $1409
(W)     mach (1|M0)              r7.0<1>:d     r32.0<0;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r32.0<0;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1413
(W)     macl (1|M0)              r8.0<1>:d     r32.0<0;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1414
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r32.4<0;1,0>:uw  {I@4}              //  ALU pipe: int; $1415
(W)     add (1|M0)               r7.0<1>:d     r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1414
(W)     macl (1|M0)              r8.0<1>:d     r61.0<0;1,0>:ud   r32.2<0;1,0>:d                      //  ALU pipe: int; $1417

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     mul (1|M0)               acc0.0<1>:ud  r61.5<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1419
(W)     macl (1|M0)              r112.0<1>:ud  r61.5<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; $1420
(W)     mul (1|M0)               acc0.0<1>:ud  r61.5<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1420
(W)     mach (1|M0)              r2.0<1>:d     r61.5<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r61.5<0;1,0>:ud   r4.6<0;1,0>:uw                      //  ALU pipe: int; $1421
(W)     macl (1|M0)              r3.0<1>:d     r61.5<0;1,0>:ud   r4.3<0;1,0>:d                       //  ALU pipe: int; $1422
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r4.2<0;1,0>:uw                      //  ALU pipe: int; $1423
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1422
(W)     macl (1|M0)              r3.0<1>:d     r6.10<0;1,0>:ud   r4.1<0;1,0>:d                       //  ALU pipe: int; $1425
(W)     mul (1|M0)               acc0.0<1>:ud  r112.0<0;1,0>:ud  r61.0<0;1,0>:uw                     //  ALU pipe: int; $1426
(W)     macl (1|M0)              r33.0<1>:ud   r112.0<0;1,0>:ud  r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1427
(W)     mul (1|M0)               acc0.0<1>:ud  r112.0<0;1,0>:ud  r61.0<0;1,0>:uw                     //  ALU pipe: int; $1427

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     add (1|M0)               r32.4<1>:d    r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1417

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r32.1<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@5}    //  ALU pipe: int; $1425
(W)     mach (1|M0)              r7.0<1>:d     r112.0<0;1,0>:ud  r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r112.0<0;1,0>:ud  r61.2<0;1,0>:uw                     //  ALU pipe: int; $1428
(W)     macl (1|M0)              r8.0<1>:d     r112.0<0;1,0>:ud  r61.1<0;1,0>:d                      //  ALU pipe: int; $1429
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r32.2<0;1,0>:uw  {I@4}              //  ALU pipe: int; $1430

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     asr (1|M0)               r4.0<1>:d     r6.6<0;1,0>:d     31:w               {Compacted}      //  ALU pipe: int; $1437

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r7.0<1>:d     r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted,I@3}    //  ALU pipe: int; $1429
(W)     macl (1|M0)              r8.0<1>:d     r61.0<0;1,0>:ud   r32.1<0;1,0>:d                      //  ALU pipe: int; $1432

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     mul (1|M0)               acc0.0<1>:ud  r112.0<0;1,0>:ud  r6.12<0;1,0>:uw                     //  ALU pipe: int; $1438
(W)     macl (1|M0)              r39.0<1>:ud   r112.0<0;1,0>:ud  r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1439
(W)     mul (1|M0)               acc0.0<1>:ud  r112.0<0;1,0>:ud  r6.12<0;1,0>:uw                     //  ALU pipe: int; $1439
(W)     mach (1|M0)              r2.0<1>:d     r112.0<0;1,0>:ud  r6.6<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r112.0<0;1,0>:ud  r4.0<0;1,0>:uw   {I@7}              //  ALU pipe: int; $1440
(W)     macl (1|M0)              r3.0<1>:d     r112.0<0;1,0>:ud  r4.0<0;1,0>:d                       //  ALU pipe: int; $1441
(W)     mul (1|M0)               acc0.0<1>:d   r6.6<0;1,0>:ud    r32.2<0;1,0>:uw                     //  ALU pipe: int; $1442
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1441
(W)     macl (1|M0)              r3.0<1>:d     r6.6<0;1,0>:ud    r32.1<0;1,0>:d                      //  ALU pipe: int; $1444

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r32.3<1>:d    r7.0<0;1,0>:d     r8.0<0;1,0>:d                       //  ALU pipe: int; $1432

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     add (1|M0)               r32.5<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {I@2}              //  ALU pipe: int; $1444

// Line 1194:  int rank_offset = send_rank_id > 0 ? rank_prefix_matrix_[(send_rank_id - 1) * kNumRanks + rank_] : 0;
(~f1.0) goto (32|M0)                         _0_209            _0_209                                //  ALU pipe: int; $1450
// B075: [inDivergent],  Preds:{B074},  Succs:{B077}
_0_210:
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1452
        goto (32|M0)                         _0_209            _0_211                                // $1453
// B076: [inDivergent],  Preds:{B074},  Succs:{B077}
_0_209:
        join (32|M0)                         _0_211                                                  // 
L11952:
(W)     shl (1|M0)               r2.0<1>:q     r6.7<0;1,0>:d     2:w                                 //  ALU pipe: int; $1456
(W)     add (1|M0)               r4.0<1>:q     r2.0<0;1,0>:q     r5.6<0;1,0>:q    {I@1}              //  ALU pipe: int; $1457
(W)     load.ugm.d32x1t.a64 (1|M0)  r3:1        [r4:1]             {I@1,$7} // ex_desc:0x0; desc:0x2108580 // $1458
        mov (32|M0)              r28.0<1>:d    r3.0<0;1,0>:d                    {Compacted,$7.dst}   //  ALU pipe: int; $1459
// B077: [inDivergent],  Preds:{B076, B075},  Succs:{B078, B079}
_0_211:
        join (32|M0)                         _0_199                                                  // 
L12024:

// Line 1196:  int channel_offset = channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel];
(W)     mul (16|M0)              acc0.0<1>:d   r18.0<1;1,0>:d    r112.12<0;1,0>:uw                   //  ALU pipe: int; $1463
        macl (16|M0)             r2.0<1>:d     r18.0<1;1,0>:d    r112.6<0;1,0>:d  {Compacted}        //  ALU pipe: int; $1463
(W)     mul (16|M16)             acc0.0<1>:d   r19.0<1;1,0>:d    r112.12<0;1,0>:uw                   //  ALU pipe: int; $1463
        macl (16|M16)            r3.0<1>:d     r19.0<1;1,0>:d    r112.6<0;1,0>:d  {Compacted}        //  ALU pipe: int; $1464
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r112.10<0;1,0>:d {Compacted,I@1}    //  ALU pipe: int; $1464
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1466
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$6.src}   //  ALU pipe: int; $1466
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1466
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1466
        add (16|M0)              r7.0<1>:q     r12.0<1;1,0>:q    r5.7<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1467
        add (16|M16)             r9.0<1>:q     r16.0<1;1,0>:q    r5.7<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1467
        load.ugm.d32.a64 (32|M0)  r30:2         [r7:4]             {I@1,$8} // ex_desc:0x0; desc:0x8200580 // $1468

// Line 1198:  (responsible_channel == num_channels - 1 ? num_rank_tokens
(W)     add (1|M0)               r4.0<1>:d     r112.6<0;1,0>:d   -1:w               {Compacted}      //  ALU pipe: int; $1471
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r112.10<0;1,0>:d  r4.0<0;1,0>:d    {I@1}              //  ALU pipe: int; $1472
(W&f3.0) jmpi                                _0_212                                                  //  ALU pipe: int; $1473
// B078: [inDivergent],  Preds:{B077},  Succs:{B080}
_0_213:

// Line 1199:  : channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel + 1])
        load.ugm.d32.a64 (32|M0)  r2:2          [r7:4+0x4]         {$9} // ex_desc:0x4000; desc:0x8200580 // $1476

// Line 1198:  (responsible_channel == num_channels - 1 ? num_rank_tokens
(W)     jmpi                                 _0_214                                                  // $1478
// B079: [inDivergent],  Preds:{B077},  Succs:{B080}
_0_212:

// Line 1195:  int num_rank_tokens = rank_prefix_matrix_[send_rank_id * kNumRanks + rank_] - rank_offset;
        shl (32|M0)              r2.0<1>:d     r18.0<1;1,0>:d    1:w               {Compacted}       //  ALU pipe: int; $1481
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r6.7<0;1,0>:d    {Compacted,@1,$8.src} //  ALU pipe: int; $1482
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1484
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1484
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1484
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1484
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r5.6<0;1,0>:q    {I@2}              //  ALU pipe: int; $1485
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r5.6<0;1,0>:q    {I@2}              //  ALU pipe: int; $1485
        load.ugm.d32.a64 (32|M0)  r22:2         [r18:4]            {I@1,$10} // ex_desc:0x0; desc:0x8200580 // $1486
        add (32|M0)              r2.0<1>:d     r22.0<1;1,0>:d    -r28.0<1;1,0>:d  {Compacted,$10.dst} //  ALU pipe: int; $1489
// B080: [inDivergent],  Preds:{B079, B078},  Succs:{B081, B106}
_0_214:

// Line 1201:  int token_start_idx = rank_offset + channel_offset;
        add (32|M0)              r20.0<1>:d    r28.0<1;1,0>:d    r30.0<1;1,0>:d   {Compacted,$8.dst} //  ALU pipe: int; $1495

// Line 1202:  int token_end_idx = rank_offset + channel_offset + num_channel_tokens;
        add (32|M0)              r88.0<1>:d    r28.0<1;1,0>:d    r2.0<1;1,0>:d    {Compacted,@2,$9.dst} //  ALU pipe: int; $1498

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        cmp (32|M0)   (lt)f2.0   null<1>:d     r20.0<1;1,0>:d    r88.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1501
(~f2.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1502
// B081: [inDivergent],  Preds:{B080},  Succs:{B082}
_0_215:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     mov (8|M0)               r98.0<1>:w    0x76543210:v                                          //  ALU pipe: int; $1587

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.0<1>:q     r61.4<0;1,0>:d    2:w                                 //  ALU pipe: int; $1512

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     add (8|M0)               r98.8<1>:w    r98.0<1;1,0>:w    8:w               {I@2}             //  ALU pipe: int; $1588

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.4<1>:d     r38.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1537

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     add (16|M0)              r98.16<1>:w   r98.0<1;1,0>:w    16:w               {I@2}            //  ALU pipe: int; $1589

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f2.0   null<2>:w     r98.0<1;1,0>:w    0:w               {I@1}             //  ALU pipe: int; $1592

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.5<1>:d     r32.4<0;1,0>:d                                        //  ALU pipe: int; $1538

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r7.0<1>:q     r2.0<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,$6.dst} //  ALU pipe: int; $1522
        add (16|M16)             r9.0<1>:q     r2.0<0;1,0>:q     r26.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1522

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r2.1<1>:q     r61.5<0;1,0>:d    2:w                                 //  ALU pipe: int; $1519

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.0<1>:d     r32.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1529
(W)     mov (1|M0)               r3.1<1>:d     r32.2<0;1,0>:d                                        //  ALU pipe: int; $1530

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     mov (1|M0)               r3.2<1>:d     r112.0<0;1,0>:d                  {Compacted}          //  ALU pipe: int; $1545
(W)     mov (1|M0)               r3.3<1>:d     r32.1<0;1,0>:d                                        //  ALU pipe: int; $1546
(W)     mov (1|M0)               r3.6<1>:d     r33.0<0;1,0>:d                                        //  ALU pipe: int; $1553
(W)     mov (1|M0)               r3.7<1>:d     r32.3<0;1,0>:d                                        //  ALU pipe: int; $1554

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r5.0<1>:ud    f2.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1592

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r3.4<1>:q     r3.2<0;1,0>:q     4:w               {I@7}             //  ALU pipe: int; $1560

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r11.0<1>:q    r7.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1526
        add (16|M16)             r13.0<1>:q    r9.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1526

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r34.0<1>:q    r2.1<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@7}    //  ALU pipe: int; $1520
        add (16|M16)             r36.0<1>:q    r2.1<0;1,0>:q     r26.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1520
        add (16|M0)              r94.0<1>:q    r7.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1524
        add (16|M16)             r96.0<1>:q    r9.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1524

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r3.5<1>:q     r3.3<0;1,0>:q     4:w               {I@7}             //  ALU pipe: int; $1560

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f1.0<1>:ud    r5.0<0;1,0>:ud                   {Compacted,I@7}      //  ALU pipe: int; $1595

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.0<1>:q     r3.0<0;1,0>:q     2:w               {Compacted}       //  ALU pipe: int; $1567

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r7.0<1>:q     r11.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1565
        add (16|M16)             r9.0<1>:q     r13.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1565

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.1<1>:q     r3.1<0;1,0>:q     2:w                                 //  ALU pipe: int; $1567

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     mov (1|M0)               r4.0<1>:d     r39.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1575
(W)     mov (1|M0)               r4.1<1>:d     r32.5<0;1,0>:d                                        //  ALU pipe: int; $1576

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r86.0<1>:q    r11.0<1;1,0>:q    r3.5<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1563
        add (16|M16)             r84.0<1>:q    r13.0<1;1,0>:q    r3.5<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1563

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r15.0<1>:q    r7.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1572
        add (16|M16)             r17.0<1>:q    r9.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1572

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r82.0<1>:q    r7.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1570
        add (16|M16)             r80.0<1>:q    r9.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1570

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        shl (16|M16)             r7.0<1>:q     r110.0<1;1,0>:q   2:w               {Compacted}       //  ALU pipe: int; $1598
        shl (16|M0)              r2.0<1>:q     r52.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1598

// Line 1256:  if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
(~f1.0) cmp (32|M0)   (gt)f1.0   null<2>:uw    r1.0<1;1,0>:uw    0x3F:uw                             //  ALU pipe: int; $1595

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r6.6<1>:q     r4.0<0;1,0>:q     2:w               {I@7}             //  ALU pipe: int; $1582

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        mov (16|M16)             r11.0<1>:d    r7.0<2;1,0>:d                    {Compacted,I@4}      //  ALU pipe: int; $1600
        mov (16|M0)              r10.0<1>:d    r2.0<2;1,0>:d                    {Compacted,I@4}      //  ALU pipe: int; $1599

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r78.0<1>:q    r15.0<1;1,0>:q    r6.6<0;1,0>:q    {I@3}              //  ALU pipe: int; $1583

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        and (32|M0)              r12.0<1>:d    r10.0<1;1,0>:d    124:w               {Compacted,I@2} //  ALU pipe: int; $1601
        mov (32|M0)              r14.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1603

// Line 1166:  const int send_warp_id_in_rank = send_warp_id / kNumRanks;
        shr (32|M0)              r92.0<1>:ud   r40.0<1;1,0>:ud   6:w                                 //  ALU pipe: int; $1505

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
        asr (32|M0)              r90.0<1>:d    r88.0<1;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $1586

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f3.0   null<1>:d     r46.0<1;1,0>:d    r61.0<0;1,0>:d                      //  ALU pipe: int; $1609

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (32|M0)              r42.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1617

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.10<0;1,0>:d    0:w                                 //  ALU pipe: int; $1610

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r5.0<1>:ud    f1.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1595

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M16)             r68.0<1>:q    r17.0<1;1,0>:q    r6.6<0;1,0>:q                       //  ALU pipe: int; $1583

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (16|M16)             r8.0<2>:ud    r21.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1614
        mov (16|M0)              r2.0<2>:ud    r20.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1614

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f1.0   null<1>:d     r46.0<1;1,0>:d    r6.6<0;1,0>:d                       //  ALU pipe: int; $1612
        mov (16|M0)              r16.0<2>:d    r12.0<1;1,0>:d                                        //  ALU pipe: int; $1604
        mov (16|M16)             r18.0<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1605
        mov (16|M0)              r16.1<2>:d    r14.0<1;1,0>:d                                        //  ALU pipe: int; $1606
        mov (16|M16)             r18.1<2>:d    r15.0<1;1,0>:d                                        //  ALU pipe: int; $1607

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (16|M16)             r52.0<1>:q    r8.0<2;1,0>:d                    {I@7}                //  ALU pipe: int; $1614
        mov (16|M0)              r54.0<1>:q    r2.0<2;1,0>:d                    {I@7}                //  ALU pipe: int; $1614

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (16|M0)              r66.0<1>:q    r16.0<1;1,0>:q    r5.2<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1608
        add (16|M16)             r44.0<1>:q    r18.0<1;1,0>:q    r5.2<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1608
(W)     mov (1|M0)               r5.1<1>:d     (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $1611
// B082: [inDivergent],  Preds:{B105, B081},  Succs:{B083, B085}
_0_216:

// Line 1208:  int num_round_tokens = sycl::min(num_max_send_tokens_, token_end_idx - static_cast<int>(token_idx));
        mov (16|M0)              r2.0<1>:d     r54.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1621
        mov (16|M16)             r3.0<1>:d     r52.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1621

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f0.0   null<2>:w     r98.0<1;1,0>:w    0:w                                 //  ALU pipe: int; $1633

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1208:  int num_round_tokens = sycl::min(num_max_send_tokens_, token_end_idx - static_cast<int>(token_idx));
        add (32|M0)              r8.0<1>:d     r88.0<1;1,0>:d    -r2.0<1;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $1622

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
        sel (32|M0)   (lt)f0.0   r40.0<1>:d    r6.9<0;1,0>:d     r8.0<1;1,0>:d    {I@1}              //  ALU pipe: int; $1626

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1210:  if (elect_one_sync(item)) {
(f0.0)  goto (32|M0)                         _0_217            _0_217                                //  ALU pipe: int; $1636
// B083: Preds:{B082},  Succs:{B084}
_L_k0_0_preHeader:
_0_218:
// B084: [inDivergent],  Preds:{B083, B084},  Succs:{B085, B084}

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 216:  asm volatile (
        load.ugm.d32.a64.uc.uc (32|M0)  r2:2    [r34:4]            {$1} // ex_desc:0x0; desc:0x8220580 // $1641

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1213:  if (num_recv_buffer_tokens_ - num_used_slots >= num_round_tokens)
        add3 (32|M0)             r8.0<1>:d     r2.0<1;0>:d       -r42.0<1;0>:d     r6.10<0>:d       {Compacted,$1.dst} //  ALU pipe: int; $1645 R{} IR{}{E:1,E:5,E:3,},  R{r6,} IR{}{O:1,O:5,},  {BC=1}
        cmp (32|M0)   (lt)f0.0   null<1>:d     r8.0<1;1,0>:d     r40.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1646 R{} IR{}{E:4,E:4,},  R{} IR{}{O:4,O:4,},  {BC=2}
(f0.0)  goto.b (32|M0)                       _0_217            _L_k0_0_preHeader                     //  ALU pipe: int; $1647
// B085: [inDivergent],  Preds:{B084, B082},  Succs:{B086, B103}
_0_217:
        join (32|M0)                         _0_199                                                  // 
L13312:

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f0.0   null<1>:d     r92.0<1;1,0>:d    r40.0<1;1,0>:d                      //  ALU pipe: int; $1656
(~f0.0) goto (32|M0)                         _0_219            _0_219                                //  ALU pipe: int; $1657
// B086: [inDivergent],  Preds:{B085},  Succs:{B087}
_0_220:
        shl (16|M0)              r2.0<1>:q     r54.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1659
        shl (16|M16)             r7.0<1>:q     r52.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1659

// Line 1222:  int dst_slot_idx = (current_channel_tail_idx + i) % num_recv_buffer_tokens_;
        mov (32|M0)              r38.0<1>:d    r92.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1662

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (16|M0)              r50.0<1>:q    r2.0<1;1,0>:q     r5.5<0;1,0>:q    {Compacted,I@3}    //  ALU pipe: int; $1660
        add (16|M16)             r48.0<1>:q    r7.0<1;1,0>:q     r5.5<0;1,0>:q    {Compacted,I@3}    //  ALU pipe: int; $1660
// B087: [inDivergent],  Preds:{B102, B086},  Succs:{B088, B089}
_0_221:

// Line 1222:  int dst_slot_idx = (current_channel_tail_idx + i) % num_recv_buffer_tokens_;
(W&~f2.0) jmpi                               _0_222                                                  //  ALU pipe: int; $1666
// B088: [inDivergent],  Preds:{B087},  Succs:{B090}
_0_223:
        mov (32|M0)              r30.0<1>:d    -1:w                               {Compacted,$15.src} //  ALU pipe: int; $1668
(W)     jmpi                                 _0_224                                                  // $1669
// B089: [inDivergent],  Preds:{B087},  Succs:{B090}
_0_222:
        add (32|M0)              r2.0<1>:d     r42.0<1;1,0>:d    r38.0<1;1,0>:d   {Compacted,I@6}    //  ALU pipe: int; $1671
        sync.nop                             null                             {Compacted,$4.src}     // $1672
        asr (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     31:w               {Compacted,@1,$3.src} //  ALU pipe: int; $1672
        add3 (32|M0)             r10.0<1>:d    r8.0<1;0>:d       r42.0<1;0>:d      r38.0<1>:d       {Compacted,I@1} //  ALU pipe: int; $1673 R{} IR{}{E:4,E:5,E:3,},  R{} IR{}{O:4,O:5,O:3,},  {BC=2}
        xor (32|M0)              r12.0<1>:d    r10.0<1;1,0>:d    r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1674
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $1675
(W)     mov (1|M0)               r4.0<1>:f     r5.1<0;1,0>:ud                   {A@1}                //  ALU pipe: float; $1676
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $1681
(W)     math.inv (1|M0)          r6.12<1>:f    r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $1680
        sync.nop                             null                             {Compacted,$14.src}    // $1679
        mov (32|M0)              r14.0<1>:f    r12.0<1;1,0>:ud                  {@2,$11.src}         //  ALU pipe: float; $1679
        sync.nop                             null                             {Compacted,A@1}        // $1681
(W)     mad (1|M0)               r16.0<1>:f    r6.12<0;0>:f      r7.0<0;0>:f       r6.12<0>:f       {$13.src} //  ALU pipe: float; $1681
        mov (32|M0)              r2.0<1>:ud    r14.0<1;1,0>:f                   {F@2}                //  ALU pipe: int; $1683
        mul (32|M0)              r18.0<1>:f    r14.0<1;1,0>:f    r16.0<0;1,0>:f   {Compacted,F@1}    //  ALU pipe: float; $1682
(W)     mov (1|M0)               r4.1<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $1677
        add (32|M0)              r20.0<1>:d    r12.0<1;1,0>:d    -r2.0<1;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $1684
        mov (32|M0)              r10.0<1>:ud   r18.0<1;1,0>:f                   {F@1}                //  ALU pipe: int; $1685
(W)     add (1|M0)               r6.11<1>:d    (abs)r6.10<0;1,0>:d  -r4.1<0;1,0>:d {I@3}             //  ALU pipe: int; $1678
        mov (32|M0)              r24.0<1>:f    r10.0<1;1,0>:ud                  {I@2}                //  ALU pipe: float; $1688
        mov (32|M0)              r22.0<1>:f    r20.0<1;1,0>:ud                                       //  ALU pipe: float; $1687
(W)     mov (1|M0)               r16.1<1>:f    r6.11<0;1,0>:ud                  {I@1}                //  ALU pipe: float; $1686
        mad (32|M0)              acc0.0<1>:f   r14.0<1;0>:f      r24.0<1;0>:f      -r4.0<0>:f       {F@3} //  ALU pipe: float; $1690 R{} IR{}{E:7,E:4,E:2,},  R{r4,} IR{}{O:7,O:12,},  {BC=1}
        mad (32|M0)              acc2.0<1>:f   r22.0<1;0>:f      r24.0<1;0>:f      -r16.1<0>:f      {F@2} //  ALU pipe: float; $1692 R{} IR{}{E:3,E:4,E:0,},  R{r16,} IR{}{O:11,O:12,},  {BC=1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}        //  ALU pipe: float; $1693
        mul (32|M0)              r26.0<1>:f    r16.0<0;1,0>:f    acc0.0<1;1,0>:f  {Compacted,$15.src} //  ALU pipe: float; $1694
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $1695
        mov (32|M0)              r28.0<1>:ud   r26.0<1;1,0>:f                   {A@1}                //  ALU pipe: int; $1696
        add (32|M0)              r30.0<1>:d    r28.0<1;1,0>:d    r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1697
(W)     mov (1|M0)               r2.0<1>:d     (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $1698
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r2.0<0;1,0>:uw   {I@1}              //  ALU pipe: int; $1698
        macl (16|M0)             r18.0<1>:d    r30.0<1;1,0>:d    r2.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1698
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r2.0<0;1,0>:uw                      //  ALU pipe: int; $1698
        macl (16|M16)            r19.0<1>:d    r31.0<1;1,0>:d    r2.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1699
        add (32|M0)              r14.0<1>:d    r12.0<1;1,0>:d    -r18.0<1;1,0>:d  {Compacted,I@1}    //  ALU pipe: int; $1699
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r14.0<1;1,0>:ud   r5.1<0;1,0>:ud   {I@1}              //  ALU pipe: int; $1700
(~f0.0) sel (32|M0)              r20.0<1>:d    (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $1701
        add3 (32|M0)             r22.0<1>:d    r14.0<1;0>:d      r8.0<1;0>:d       -r20.0<1>:d      {Compacted,I@1} //  ALU pipe: int; $1702 R{} IR{}{E:7,E:4,E:2,},  R{} IR{}{O:7,O:4,O:10,},  {BC=2}
        xor (32|M0)              r30.0<1>:d    r22.0<1;1,0>:d    r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1703
// B090: [inDivergent],  Preds:{B089, B088},  Succs:{B091, B097}
_0_224:

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M0)              r2.0<2>:ud    r38.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1707
        sync.nop                             null                             {Compacted,$4.src}     // $1707
        mov (16|M16)             r8.0<2>:ud    r39.0<1;1,0>:ud                  {Compacted,$3.src}   //  ALU pipe: int; $1707
        mov (16|M0)              r64.0<1>:q    r2.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $1707
        mov (16|M16)             r62.0<1>:q    r8.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $1707
        add (16|M0)              r10.0<1>:q    r54.0<1;1,0>:q    r64.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1708
        add (16|M16)             r12.0<1>:q    r52.0<1;1,0>:q    r62.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1708
        mov (16|M0)              r32.0<1>:d    r10.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1709
        mov (16|M16)             r33.0<1>:d    r12.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1710
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw  {I@2}              //  ALU pipe: int; $1713
        macl (16|M0)             r16.0<1>:ud   r32.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted,$13.src} //  ALU pipe: int; $1713
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw  {I@3}              //  ALU pipe: int; $1713
        macl (16|M16)            r17.0<1>:ud   r33.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1714
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1714
        mach (16|M0)             r2.0<1>:d     r32.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1714
        mach (16|M16)            r3.0<1>:d     r33.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; $1715
(W)     mul (16|M0)              acc0.0<1>:d   r32.0<1;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1715
        macl (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1715
(W)     mul (16|M16)             acc0.0<1>:d   r33.0<1;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1715
        mov (16|M0)              r28.0<1>:d    r10.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1711
        macl (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1716
        mov (16|M16)             r29.0<1>:d    r12.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1712
        add (32|M0)              r2.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1716
(W)     mul (16|M0)              acc0.0<1>:d   r61.0<0;1,0>:ud   r28.0<2;1,0>:uw                     //  ALU pipe: int; $1717
        macl (16|M0)             r8.0<1>:d     r61.0<0;1,0>:ud   r28.0<1;1,0>:d                      //  ALU pipe: int; $1717
(W)     mul (16|M16)             acc0.0<1>:d   r61.0<0;1,0>:ud   r29.0<2;1,0>:uw  {I@4}              //  ALU pipe: int; $1717
        macl (16|M16)            r9.0<1>:d     r61.0<0;1,0>:ud   r29.0<1;1,0>:d                      //  ALU pipe: int; $1719
        add (32|M0)              r18.0<1>:d    r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1719

// Line 1227:  for (int j = lane_id; j < hidden_int4; j += 32) {
(~f3.0) goto (32|M0)                         _0_225            _0_225                                //  ALU pipe: int; $1722
// B091: [inDivergent],  Preds:{B090},  Succs:{B092}
_0_226:

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $1725
        macl (16|M0)             r2.0<1>:d     r30.0<1;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $1725
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $1725

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M16)             r22.0<2>:d    r17.0<1;1,0>:d                                        //  ALU pipe: int; $1734

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        macl (16|M16)            r3.0<1>:d     r31.0<1;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $1727

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M16)             r22.1<2>:d    r19.0<1;1,0>:d                   {I@7}                //  ALU pipe: int; $1736
        mov (16|M0)              r20.0<2>:d    r16.0<1;1,0>:d                                        //  ALU pipe: int; $1733

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        mov (16|M0)              r8.0<2>:ud    r2.0<1;1,0>:ud                   {Compacted,I@6}      //  ALU pipe: int; $1727
        mov (16|M16)             r12.0<2>:ud   r3.0<1;1,0>:ud                   {Compacted,I@4}      //  ALU pipe: int; $1727

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        shl (16|M16)             r26.0<1>:q    r22.0<1;1,0>:q    4:w               {Compacted,@4,$14.src} //  ALU pipe: int; $1737
        mov (16|M0)              r20.1<2>:d    r18.0<1;1,0>:d                                        //  ALU pipe: int; $1735

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        shl (16|M0)              r10.0<1>:q    r8.0<2;1,0>:d     4:w               {I@4}             //  ALU pipe: int; $1727
        shl (16|M16)             r14.0<1>:q    r12.0<2;1,0>:d    4:w               {@4,$11.src}      //  ALU pipe: int; $1727

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        add (16|M16)             r72.0<1>:q    r26.0<1;1,0>:q    r5.1<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1738
        shl (16|M0)              r24.0<1>:q    r20.0<1;1,0>:q    4:w               {Compacted,I@4}   //  ALU pipe: int; $1737

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 207:  *ptr = value;
        mov (32|M0)              r26.0<1>:d    r46.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1742

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        add (16|M0)              r58.0<1>:q    r86.0<1;1,0>:q    r10.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1728
        add (16|M16)             r56.0<1>:q    r84.0<1;1,0>:q    r14.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1728

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        add (16|M0)              r70.0<1>:q    r24.0<1;1,0>:q    r5.1<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1738
// B092: [inDivergent],  Preds:{B096, B091},  Succs:{B093, B094}
_0_227:

// Line 1228:  st_na_global(shifted_x_buffers + j, ld_nc_global(shifted_x + j));
        mov (16|M0)              r2.0<2>:ud    r26.0<1;1,0>:ud                  {Compacted,I@4}      //  ALU pipe: int; $1748
        sync.nop                             null                             {Compacted,$4.src}     // $1748
        mov (16|M16)             r10.0<2>:ud   r27.0<1;1,0>:ud                  {Compacted,$3.src}   //  ALU pipe: int; $1748
        shl (16|M0)              r7.0<1>:q     r2.0<2;1,0>:ud    4:w               {I@2}             //  ALU pipe: int; $1748
        shl (16|M16)             r12.0<1>:q    r10.0<2;1,0>:ud   4:w               {I@2}             //  ALU pipe: int; $1748
        add (16|M0)              r22.0<1>:q    r70.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1750
        add (16|M16)             r24.0<1>:q    r72.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1750
        add (16|M0)              r76.0<1>:q    r58.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted}        //  ALU pipe: int; $1749
        add (16|M16)             r74.0<1>:q    r56.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1749

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 207:  *ptr = value;
        mov (16|M0)              r14.0<1>:uq   r22.0<1;1,0>:uq                  {Compacted,@4,$11.src} //  ALU pipe: int; $1755
        mov (16|M16)             r16.0<1>:uq   r24.0<1;1,0>:uq                  {Compacted,@4,$13.src} //  ALU pipe: int; $1755
        mov (16|M0)              r18.0<1>:d    r76.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1756
        mov (16|M16)             r19.0<1>:d    r74.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1756
        mov (16|M0)              r2.0<1>:d     r14.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1758
        mov (16|M16)             r3.0<1>:d     r16.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1758
        cmp (32|M0)   (gt)f0.0   null<1>:ud    r18.0<1;1,0>:ud   r2.0<1;1,0>:ud   {I@1}              //  ALU pipe: int; $1760 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:1,},  {BC=1}
        mov (16|M0)              r20.0<1>:d    r76.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1757
        mov (16|M16)             r21.0<1>:d    r74.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1757
        mov (16|M0)              r10.0<1>:d    r14.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1759
        mov (16|M16)             r11.0<1>:d    r16.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1759
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:d     r20.0<1;1,0>:d    r10.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1761
(~f0.0) cmp (32|M0)   (gt)f0.0   null<1>:ud    r20.0<1;1,0>:ud   r10.0<1;1,0>:ud                     //  ALU pipe: int; $1763
(f0.0)  goto (32|M0)                         _0_228            _0_228                                //  ALU pipe: int; $1765
// B093: [inDivergent],  Preds:{B092},  Succs:{B095}
_0_229:
        load.ugm.d32.a64 (32|M0)  r14:2         [r22:4]            {$5} // ex_desc:0x0; desc:0x8200580 // $1767
        load.ugm.d32.a64 (32|M0)  r16:2         [r22:4+0x4]        {$6} // ex_desc:0x4000; desc:0x8200580 // $1768
        load.ugm.d32.a64 (32|M0)  r2:2          [r22:4+0x8]        {$7} // ex_desc:0x8000; desc:0x8200580 // $1769
        load.ugm.d32.a64 (32|M0)  r8:2          [r22:4+0xC]        {$8} // ex_desc:0xC000; desc:0x8200580 // $1770
        mov (16|M0)              r10.0<1>:uq   r76.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1771
        mov (16|M16)             r12.0<1>:uq   r74.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1771
        sync.nop                             null                             {Compacted,$5.dst}     // $1772
        store.ugm.d32.a64 (32|M0)  [r10:4]      r14:2              {I@1,$11} // ex_desc:0x0; desc:0x8000584 // $1772
        sync.nop                             null                             {Compacted,$6.dst}     // $1773
        store.ugm.d32.a64 (32|M0)  [r10:4+0x4]  r16:2              {$13} // ex_desc:0x4000; desc:0x8000584 // $1773
        store.ugm.d32.a64 (32|M0)  [r10:4+0x8]  r2:2               {$7} // ex_desc:0x8000; desc:0x8000584 // $1774
        sync.nop                             null                             {Compacted,$8.dst}     // $1775
        store.ugm.d32.a64 (32|M0)  [r10:4+0xC]  r8:2               {$3} // ex_desc:0xC000; desc:0x8000584 // $1775
        goto (32|M0)                         _0_228            _0_230                                // $1776
// B094: [inDivergent],  Preds:{B092},  Succs:{B095}
_0_228:
        join (32|M0)                         _0_230                                                  // 
L14928:
        load.ugm.d32x4.a64 (32|M0)  r8:8        [r22:4]            {$9} // ex_desc:0x0; desc:0x8803580 // $1778
        mov (16|M0)              r16.0<1>:uq   r76.0<1;1,0>:uq                  {Compacted,$13.src}  //  ALU pipe: int; $1779
        mov (16|M16)             r18.0<1>:uq   r74.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1779
        sync.nop                             null                             {Compacted,$9.dst}     // $1780
        store.ugm.d32x4.a64 (32|M0)  [r16:4]    r8:8               {I@1,$4} // ex_desc:0x0; desc:0x8003584 // $1780
// B095: [inDivergent],  Preds:{B094, B093},  Succs:{B096, B097}
_0_230:
        join (32|M0)                         _0_225                                                  // 
L15000:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1227:  for (int j = lane_id; j < hidden_int4; j += 32) {
        add (32|M0)              r2.0<1>:d     r26.0<1;1,0>:d    32:w               {Compacted,$7.src} //  ALU pipe: int; $1784
        cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r61.0<0;1,0>:d   {I@1}              //  ALU pipe: int; $1787
(~f0.0) goto (32|M0)                         _0_225            _0_225                                //  ALU pipe: int; $1788
// B096: [inDivergent],  Preds:{B095},  Succs:{B092}
_0_231:
        mov (32|M0)              r26.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1790
(W)     jmpi                                 _0_227                                                  // $1791
// B097: [inDivergent],  Preds:{B095, B090},  Succs:{B098, B099}
_0_225:
        join (32|M0)                         _0_219                                                  // 
L15080:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f0.0   null<2>:w     r98.0<1;1,0>:w    0:w                                 //  ALU pipe: int; $1798

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1234:  if (elect_one_sync(item)) {
(f0.0)  goto (32|M0)                         _0_232            _0_232                                //  ALU pipe: int; $1801
// B098: [inDivergent],  Preds:{B097},  Succs:{B099}
_0_233:

// Line 1235:  channel_src_idx_buffers[dst_slot_idx] = src_idx_[token_idx + i];
        sync.nop                             null                             {Compacted,F@1}        // $1804
        shl (16|M0)              r2.0<1>:q     r64.0<1;1,0>:q    2:w               {Compacted,$7.src} //  ALU pipe: int; $1804
        sync.nop                             null                             {Compacted,$4.src}     // $1804
        shl (16|M16)             r7.0<1>:q     r62.0<1;1,0>:q    2:w               {Compacted,$3.src} //  ALU pipe: int; $1804
        add (16|M0)              r9.0<1>:q     r50.0<1;1,0>:q    r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1805 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:1,},  {BC=1}
        add (16|M16)             r11.0<1>:q    r48.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1805
        load.ugm.d32.a64 (32|M0)  r14:2         [r9:4]             {I@1,$10} // ex_desc:0x0; desc:0x8200580 // $1806

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 45:  dtype_t& operator[](int64_t idx) { return buffer()[idx]; }
        mov (16|M0)              r16.0<2>:ud   r30.0<1;1,0>:ud                  {Compacted,$13.src}  //  ALU pipe: int; $1815
        mov (16|M16)             r20.0<2>:ud   r31.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1815
        shl (16|M0)              r18.0<1>:q    r16.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1815
        shl (16|M16)             r22.0<1>:q    r20.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1815
        add (16|M0)              r24.0<1>:q    r82.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,@2,$14.src} //  ALU pipe: int; $1816 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:9,},  {BC=2}
        add (16|M16)             r26.0<1>:q    r80.0<1;1,0>:q    r22.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1816

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1235:  channel_src_idx_buffers[dst_slot_idx] = src_idx_[token_idx + i];
        sync.nop                             null                             {Compacted,$10.dst}    // $1820
        store.ugm.d32.a64 (32|M0)  [r24:4]      r14:2              {I@1,$14} // ex_desc:0x0; desc:0x8000584 // $1820
// B099: [inDivergent],  Preds:{B098, B097},  Succs:{B100, B101}
_0_232:
        join (32|M0)                         _0_219                                                  // 
L15280:

// Line 1239:  if (num_topk_ > 0 && lane_id < num_topk_) {
(~f1.0) goto (32|M0)                         _0_234            _0_234                                //  ALU pipe: int; $1824
// B100: [inDivergent],  Preds:{B099},  Succs:{B101}
_0_235:

// Line 1241:  topk_weights_[(token_idx + i) * num_topk_ + lane_id];
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1827
        macl (16|M0)             r2.0<1>:ud    r32.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted,$7.src} //  ALU pipe: int; $1827
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1827
        macl (16|M16)            r3.0<1>:ud    r33.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1828
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1828
        sync.nop                             null                             {Compacted,$4.src}     // 
        mach (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r6.6<0;1,0>:ud   {$3.src}           //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1828
        mach (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; $1831
(W)     mul (16|M0)              acc0.0<1>:d   r6.6<0;1,0>:ud    r28.0<2;1,0>:uw                     //  ALU pipe: int; $1831
        macl (16|M0)             r10.0<1>:d    r6.6<0;1,0>:ud    r28.0<1;1,0>:d                      //  ALU pipe: int; $1831
(W)     mul (16|M16)             acc0.0<1>:d   r6.6<0;1,0>:ud    r29.0<2;1,0>:uw                     //  ALU pipe: int; $1831
        macl (16|M16)            r11.0<1>:d    r6.6<0;1,0>:ud    r29.0<1;1,0>:d                      //  ALU pipe: int; $1833
        add (32|M0)              r12.0<1>:d    r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1833
        sync.nop                             null                             {Compacted,$14.src}    // $1836
        mov (16|M0)              r14.0<2>:d    r2.0<1;1,0>:d                    {$11.src}            //  ALU pipe: int; $1836
        mov (16|M16)             r16.0<2>:d    r3.0<1;1,0>:d                    {$13.src}            //  ALU pipe: int; $1837
        mov (16|M0)              r14.1<2>:d    r12.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $1838
        mov (16|M16)             r16.1<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1839
        shl (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1840
        shl (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1840
        add (16|M0)              r22.0<1>:q    r66.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1841 R{} IR{}{E:1,E:1,},  R{} IR{}{O:1,O:9,},  {BC=1}
        add (16|M16)             r24.0<1>:q    r44.0<1;1,0>:q    r20.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1841
        load.ugm.d32.a64 (32|M0)  r26:2         [r22:4]            {I@1,$1} // ex_desc:0x0; desc:0x8200580 // $1842

// Line 1240:  channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] =
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1844
        macl (16|M0)             r28.0<1>:d    r30.0<1;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1844
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1844
        macl (16|M16)            r29.0<1>:d    r31.0<1;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1845
        add (32|M0)              r8.0<1>:d     r28.0<1;1,0>:d    r46.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1845

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 45:  dtype_t& operator[](int64_t idx) { return buffer()[idx]; }
        mov (16|M0)              r2.0<2>:ud    r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1854
        mov (16|M16)             r12.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1854
        shl (16|M0)              r10.0<1>:q    r2.0<2;1,0>:d     2:w               {I@2}             //  ALU pipe: int; $1854
        shl (16|M16)             r14.0<1>:q    r12.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1854
        add (16|M0)              r30.0<1>:q    r78.0<1;1,0>:q    r10.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1855
        add (16|M16)             r32.0<1>:q    r68.0<1;1,0>:q    r14.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1855

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1240:  channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] =
        sync.nop                             null                             {Compacted,$1.dst}     // $1859
        store.ugm.d32.a64 (32|M0)  [r30:4]      r26:2              {I@1,$15} // ex_desc:0x0; desc:0x8000584 // $1859
// B101: [inDivergent],  Preds:{B100, B099},  Succs:{B102, B103}
_0_234:
        join (32|M0)                         _0_219                                                  // 
L15768:

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (32|M0)              r2.0<1>:d     r38.0<1;1,0>:d    1:w               {Compacted,$7.src} //  ALU pipe: int; $1863
        cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r40.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1866
(~f0.0) goto (32|M0)                         _0_219            _0_219                                //  ALU pipe: int; $1867
// B102: [inDivergent],  Preds:{B101},  Succs:{B087}
_0_236:
        mov (32|M0)              r38.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1869
(W)     jmpi                                 _0_221                                                  // $1870
// B103: [inDivergent],  Preds:{B101, B085},  Succs:{B104, B105}
_0_219:
        join (32|M0)                         _0_199                                                  // 
L15848:

// Line 1245:  token_idx += num_round_tokens;
        sync.nop                             null                             {Compacted,F@1}        // $1874
        mov (16|M0)              r2.0<2>:ud    r40.0<1;1,0>:ud                  {Compacted,$7.src}   //  ALU pipe: int; $1874
        sync.nop                             null                             {Compacted,$4.src}     // $1874
        mov (16|M16)             r8.0<2>:ud    r41.0<1;1,0>:ud                  {Compacted,$3.src}   //  ALU pipe: int; $1874
        add (16|M0)              r54.0<1>:q    r54.0<1;1,0>:q    r2.0<2;1,0>:d    {I@2}              //  ALU pipe: int; $1874
        add (16|M16)             r52.0<1>:q    r52.0<1;1,0>:q    r8.0<2;1,0>:d    {I@2}              //  ALU pipe: int; $1874

// Line 1246:  current_channel_tail_idx += num_round_tokens;
        add (32|M0)              r42.0<1>:d    r42.0<1;1,0>:d    r40.0<1;1,0>:d   {Compacted,$0.src} //  ALU pipe: int; $1881
        mov (16|M0)              r2.0<1>:d     r54.1<2;1,0>:d                   {Compacted,I@3}      //  ALU pipe: int; $1878
        mov (16|M0)              r8.0<1>:d     r54.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1876
        mov (16|M16)             r9.0<1>:d     r52.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1877
        mov (16|M16)             r3.0<1>:d     r52.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1879

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/atomic_fence.hpp

// Line 26:  __spirv_MemoryBarrier(SPIRVScope, static_cast<uint32_t>(SPIRVOrder));
(W)     send.slm (1|M0)          r7       r60  null:0  0x0            0x0210001F           {$5} // wr:1+0, rd:1; fence.slm.none.group // $1889
(W)     mov (8|M0)               null<1>:ud    r7.0<1;1,0>:ud                   {Compacted,$5.dst}   //  memory fence commit; ALU pipe: int; $1890
(W)     send.ugm (1|M0)          r10      r60  null:0  0x0            0x0210261F           {$6} // wr:1+0, rd:1; fence.ugm.invalidate.gpu // $1890

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f0.0<1>:ud    r5.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1893

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1256:  if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
(W)     mov (8|M0)               null<1>:ud    r10.0<1;1,0>:ud                  {Compacted,$6.dst}   //  memory fence commit; ALU pipe: int; $1893
(f0.0)  goto (32|M0)                         _0_237            _0_237                                //  ALU pipe: int; $1893
// B104: [inDivergent],  Preds:{B103},  Succs:{B105}
_0_238:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 234:  asm volatile (
        store.ugm.d32.a64.uc.uc (32|M0)  [r94:4] r42:2             {I@7,$0} // ex_desc:0x0; desc:0x8020584 // $1898
// B105: [inDivergent],  Preds:{B104, B103},  Succs:{B106, B082}
_0_237:
        join (32|M0)                         _0_199                                                  // 
L16056:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r8.0<1;1,0>:ud    r88.0<1;1,0>:ud  {I@7}              //  ALU pipe: int; $1904 R{} IR{}{E:4,E:4,},  R{} IR{}{O:4,O:12,},  {BC=1}
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:d     r2.0<1;1,0>:d     r90.0<1;1,0>:d   {I@7}              //  ALU pipe: int; $1905
(~f0.0) cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r90.0<1;1,0>:d                      //  ALU pipe: int; $1907
(f0.0)  goto.b (32|M0)                       _0_199            _0_216                                //  ALU pipe: int; $1909
// B106: Preds:{B105, B080, B066, B064, B063},  Succs:{}
_0_199:
        join (32|M0)                         L16136                                                  // 
L16136:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
        sync.allrd                           ($2,$7,$12)                                             // $1913
(W)     send.slm (1|M0)          r2       r60  null:0  0x0            0x0210001F           {I@3,$8} // wr:1+0, rd:1; fence.slm.none.group // $1913
(W)     mov (16|M0)              r127.0<1>:f   r60.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $1914
(W)     mov (8|M0)               null<1>:ud    r2.0<1;1,0>:ud                   {Compacted,$8.dst}   //  memory fence commit; ALU pipe: int; $1914
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,F@1,$9} // wr:1+0, rd:0; end of thread // $1914
L16200:
(W)     mov (16|M0)              null<1>:ud    0x9D9B1246:ud                                         // 
(W)     mov (16|M0)              null<1>:ud    0x700DC447:ud                                         // 
(W)     mov (16|M0)              null<1>:ud    0x0:ud                                                // 
(W)     mov (16|M0)              null<1>:ud    0x10:ud                                               // 


//.BankConflicts: 22
//.ByteRMWs: 1
//


//.numALUInst: 1065
//.accSubDef: 3
//.accSubUse: 3
//.accSubCandidateDef: 3
//.accSubCandidateUse: 3
//
//
//.singlePipeAtOneDistNum: 147
//.allAtOneDistNum: 27
//.syncInstCount: 32
//.tokenReuseCount: 0
//.AfterWriteTokenDepCount: 38
//.AfterReadTokenDepCount: 107
