//.kernel _ZTSZZN7deep_ep9intranode7combineEDnPvPfPKvPKfS4_S4_PKiS8_S8_PiiiiiPS1_iiRN4sycl3_V15queueEiiiENKUlRNSC_7handlerEE0_clESG_EUlNSC_7nd_itemILi1EEEE_
//.platform XE2
//.thread_config numGRF=128, numAcc=4, numSWSB=16
//.options_string "-emitCrossThreadOffR0Reloc -hashmovs 2251663716 2295679891 -hashmovs1 0 16 "
//.full_options "-emitLocation -enableCoalesceScalarMoves -supportLSCImmScale 0 -samplerHeaderWA -enablePreemptionR0Only -hasRNEandDenorm -noStitchExternFunc -useInlineData -emitCrossThreadOffR0Reloc -abortOnSpill 4 -enableBundleCR 3 -freqBasedSpillCost 8 -freqBasedSpillCostFunc 1 -boundsChecking -presched-ctrl 6 -presched-rp 100 -nodpsendreorder -SBIDDepLoc -PVCSendWARWA -output -binary -dumpcommonisa -dumpcombinedcisa -dumpvisa -printHexFloatInAsm -noverifyCISA -enableHalfLSC -partialInt64 -activeThreadsOnlyBarrier -generateDebugInfo -hashmovs 2251663716 2295679891 -hashmovs1 0 16 "
//.instCount 1191
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
//.declare V0085 (95)  rf=r size=384 type=d align=32 words (r12.0)
//.declare V0087 (97)  rf=r size=64 type=uw alias=V0057+0 align=32 words (r1.0)
//.declare V0088 (98)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0089 (99)  rf=r size=4 type=ud alias=V0049+0 align=32 words (r6.8)
//.declare V0090 (100)  rf=r size=4 type=ud alias=V0088+0 align=2 words (r4.0)
//.declare V0091 (101)  rf=r size=4 type=d alias=+0 align=2 words (r102.4)
//.declare V0092 (102)  rf=r size=4 type=d align=2 words (r102.2)
//.declare V0093 (103)  rf=r size=4 type=d align=2 words (r102.8)
//.declare V0094 (104)  rf=r size=32 type=ud alias=V0055+0 align=32 words (r60.0)
//.declare V0095 (105)  rf=r size=4 type=ud alias=V0093+0 align=2 words (r102.8)
//.declare V0096 (106)  rf=r size=4 type=d align=2 words (r61.0)
//.declare V0097 (107)  rf=r size=128 type=d align=32 words (r32.0)
//.declare V0098 (108)  rf=r size=128 type=d align=32 words (r38.0)
//.declare V0099 (109)  rf=r size=128 type=d align=32 words (r80.0)
//.declare V0100 (110)  rf=r size=128 type=ud alias=V0097+0 align=32 words (r32.0)
//.declare V0101 (111)  rf=r size=128 type=ud alias=V0099+0 align=32 words (r80.0)
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
//.declare V0118 (131)  rf=r size=128 type=ud alias=V0098+0 align=32 words (r38.0)
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
//.declare V0135 (151)  rf=r size=8 type=q align=4 words (r102.0)
//.declare V0136 (152)  rf=r size=8 type=uq alias=V0135+0 align=4 words (r102.0)
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
//.declare V0259 (276)  rf=r size=4 type=ud alias=V0091+0 align=2 words (r102.4)
//.declare V0260 (277)  rf=r size=4 type=d align=2 words (r102.3)
//.declare V0261 (278)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0262 (279)  rf=r size=4 type=d alias=+4 align=2 words (r102.5)
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
//.declare V0308 (326)  rf=r size=4 type=d align=2 words (r102.7)
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
//.declare V0324 (343)  rf=r size=4 type=d align=2 words (r102.6)
//.declare V0333 (352)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0335 (354)  rf=r size=64 type=uw alias=V0333+0 align=32 words (r7.0)
//.declare V0336 (355)  rf=r size=128 type=d align=32 words (r62.0)
//.declare V0337 (356)  rf=r size=128 type=ud alias=V0336+0 align=32 words (r62.0)
//.declare P7 (357)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P8 (358)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare P9 (359)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P10 (360)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0338 (361)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0339 (362)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V0340 (363)  rf=r size=128 type=d align=32 words (r90.0)
//.declare V0341 (364)  rf=r size=128 type=ud alias=V0340+0 align=32 words (r90.0)
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
//.declare V0356 (382)  rf=r size=64 type=w align=32 words (r79.0)
//.declare V0357 (383)  rf=r size=64 type=w align=32 words (r78.0)
//.declare V0358 (384)  rf=r size=64 type=w align=32 words (r77.0)
//.declare V0359 (385)  rf=r size=64 type=w align=32 words (r76.0)
//.declare V0360 (386)  rf=r size=64 type=w align=32 words (r75.0)
//.declare V0361 (387)  rf=r size=64 type=w align=32 words (r74.0)
//.declare V0362 (388)  rf=r size=64 type=w align=32 words (r73.0)
//.declare V0363 (389)  rf=r size=64 type=w align=32 words (r72.0)
//.declare V0364 (390)  rf=r size=64 type=w align=32 words (r71.0)
//.declare V0365 (391)  rf=r size=64 type=w align=32 words (r70.0)
//.declare V0366 (392)  rf=r size=64 type=w align=32 words (r69.0)
//.declare V0367 (393)  rf=r size=64 type=w align=32 words (r68.0)
//.declare V0370 (396)  rf=r size=128 type=d align=32 words (r32.0)
//.declare V0371 (397)  rf=r size=128 type=d align=32 words (r40.0)
//.declare P14 (398)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0372 (399)  rf=r size=128 type=d align=32 words (r36.0)
//.declare V0374 (401)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V0375 (402)  rf=r size=256 type=uq alias=V0374+0 align=32 words (r9.0)
//.declare P15 (403)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P16 (404)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0376 (405)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0377 (406)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (407)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0378 (408)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (409)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0380 (411)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0381 (412)  rf=r size=128 type=ud align=32 words (r7.0)
//.declare V0382 (413)  rf=r size=128 type=d alias=V0381+0 align=32 words (r7.0)
//.declare V0383 (414)  rf=r size=64 type=ud align=32 words (r9.0)
//.declare V0384 (415)  rf=r size=32 type=ud align=2 words (r4.8)
//.declare V0385 (416)  rf=r size=16 type=ud align=2 words (r10.0)
//.declare V0386 (417)  rf=r size=8 type=ud align=2 words (r6.11)
//.declare P17 (418)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P18 (419)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0387 (420)  rf=r size=8 type=d align=32 words (r16.0)
//.declare V0388 (421)  rf=r size=8 type=d align=32 words (r14.0)
//.declare V0389 (422)  rf=r size=2 type=w align=1 words (r14.6)
//.declare V0390 (423)  rf=r size=4 type=d align=2 words (r14.2)
//.declare V0391 (424)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0392 (425)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0393 (426)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0394 (427)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0395 (428)  rf=r size=4 type=ud alias=V0347+0 align=2 words (r61.13)
//.declare V0396 (429)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0397 (430)  rf=r size=4 type=ud alias=V0396+0 align=2 words (r3.2)
//.declare V0398 (431)  rf=r size=4 type=d alias=+0 align=2 words (r4.8)
//.declare V0399 (432)  rf=r size=4 type=f align=2 words (r4.1)
//.declare V0400 (433)  rf=r size=4 type=ud alias=V0393+0 align=2 words (r3.1)
//.declare V0401 (434)  rf=r size=4 type=f align=2 words (r4.3)
//.declare V0402 (435)  rf=r size=4 type=f align=2 words (r6.11)
//.declare V0403 (436)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0404 (437)  rf=r size=4 type=d align=2 words (r6.13)
//.declare V0405 (438)  rf=r size=4 type=ud alias=V0404+0 align=2 words (r6.13)
//.declare V0406 (439)  rf=r size=4 type=d alias=+4 align=2 words (r4.9)
//.declare V0407 (440)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0408 (441)  rf=r size=4 type=ud alias=V0407+0 align=2 words (r2.0)
//.declare V0409 (442)  rf=r size=4 type=f alias=+0 align=2 words (r2.4)
//.declare V0410 (443)  rf=r size=4 type=ud alias=V0398+0 align=2 words (r4.8)
//.declare V0411 (444)  rf=r size=4 type=f alias=+4 align=2 words (r2.5)
//.declare V0412 (445)  rf=r size=4 type=ud alias=V0406+0 align=2 words (r4.9)
//.declare V0413 (446)  rf=r size=4 type=f align=2 words (r9.0)
//.declare V0415 (448)  rf=r size=4 type=f align=2 words (r2.1)
//.declare V0417 (450)  rf=r size=4 type=f align=2 words (r3.2)
//.declare V0418 (451)  rf=r size=4 type=f align=2 words (r8.0)
//.declare V0419 (452)  rf=r size=4 type=f align=2 words (r10.0)
//.declare V0420 (453)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V0421 (454)  rf=r size=4 type=ud alias=V0420+0 align=2 words (r7.0)
//.declare V0422 (455)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0423 (456)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0424 (457)  rf=r size=4 type=d align=2 words (r13.0)
//.declare P19 (458)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare V0425 (459)  rf=r size=4 type=ud alias=V0424+0 align=2 words (r13.0)
//.declare V0426 (460)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0427 (461)  rf=r size=4 type=d align=2 words (r9.0)
//.declare V0428 (462)  rf=r size=2 type=b align=1 words (r2.0)
//.declare V0429 (463)  rf=r size=4 type=d align=2 words (r14.2)
//.declare V0430 (464)  rf=r size=2 type=ub alias=V0428+0 align=1 words (r2.0)
//.declare P20 (465)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0431 (466)  rf=r size=8 type=d align=2 words (r61.1)
//.declare V0432 (467)  rf=r size=8 type=d align=2 words (r61.3)
//.declare V0433 (468)  rf=r size=4 type=d align=2 words (r61.9)
//.declare V0434 (469)  rf=r size=4 type=d align=2 words (r14.3)
//.declare V0435 (470)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V0436 (471)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0437 (472)  rf=r size=4 type=d align=2 words (r3.1)
//.declare V0438 (473)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0439 (474)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0440 (475)  rf=r size=4 type=ud alias=V0439+0 align=2 words (r3.2)
//.declare V0441 (476)  rf=r size=4 type=d alias=+0 align=2 words (r4.8)
//.declare V0442 (477)  rf=r size=4 type=f align=2 words (r4.1)
//.declare V0443 (478)  rf=r size=4 type=ud alias=V0437+0 align=2 words (r3.1)
//.declare V0444 (479)  rf=r size=4 type=f align=2 words (r4.3)
//.declare V0445 (480)  rf=r size=4 type=f align=2 words (r6.11)
//.declare V0446 (481)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0447 (482)  rf=r size=4 type=d align=2 words (r6.13)
//.declare V0448 (483)  rf=r size=4 type=ud alias=V0447+0 align=2 words (r6.13)
//.declare V0449 (484)  rf=r size=4 type=d alias=+4 align=2 words (r4.9)
//.declare V0450 (485)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V0451 (486)  rf=r size=4 type=ud alias=V0450+0 align=2 words (r2.0)
//.declare V0452 (487)  rf=r size=4 type=f alias=+0 align=2 words (r2.4)
//.declare V0453 (488)  rf=r size=4 type=ud alias=V0441+0 align=2 words (r4.8)
//.declare V0454 (489)  rf=r size=4 type=f alias=+4 align=2 words (r2.5)
//.declare V0455 (490)  rf=r size=4 type=ud alias=V0449+0 align=2 words (r4.9)
//.declare V0456 (491)  rf=r size=4 type=f align=2 words (r9.0)
//.declare V0458 (493)  rf=r size=4 type=f align=2 words (r2.1)
//.declare V0460 (495)  rf=r size=4 type=f align=2 words (r3.2)
//.declare V0461 (496)  rf=r size=4 type=f align=2 words (r8.0)
//.declare V0462 (497)  rf=r size=4 type=f align=2 words (r10.0)
//.declare V0463 (498)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V0464 (499)  rf=r size=4 type=ud alias=V0463+0 align=2 words (r7.0)
//.declare V0465 (500)  rf=r size=4 type=d align=2 words (r11.0)
//.declare V0466 (501)  rf=r size=4 type=d align=32 words (r12.0)
//.declare V0467 (502)  rf=r size=4 type=d align=2 words (r13.0)
//.declare P21 (503)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare V0468 (504)  rf=r size=4 type=ud alias=V0467+0 align=2 words (r13.0)
//.declare V0469 (505)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0470 (506)  rf=r size=4 type=d align=2 words (r9.0)
//.declare V0471 (507)  rf=r size=4 type=uw alias=V0429+0 align=2 words (r14.4)
//.declare V0472 (508)  rf=r size=2 type=uw align=1 words (r2.0)
//.declare A0 (509)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare V0474 (511)  rf=r size=2 type=uw align=1 words (r3.0)
//.declare A1 (512)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare V0475 (513)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0476 (514)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0477 (515)  rf=r size=128 type=ud alias=V0475+0 align=32 words (r10.0)
//.declare V0478 (516)  rf=r size=128 type=ud alias=V0370+0 align=32 words (r32.0)
//.declare V0479 (517)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0481 (519)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P22 (527)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0491 (530)  rf=r size=8 type=q align=4 words (r4.0)
//.declare V0492 (531)  rf=r size=8 type=q align=32 words (r6.0)
//.declare V0493 (532)  rf=r size=8 type=uq alias=V0492+0 align=32 words (r6.0)
//.declare V0495 (534)  rf=r size=4 type=d alias=+0 align=2 words (r2.0)
//.declare P23 (535)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0498 (538)  rf=r size=8 type=q align=4 words (r2.1)
//.declare V0499 (539)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0500 (540)  rf=r size=8 type=uq alias=V0499+0 align=32 words (r4.0)
//.declare V0502 (542)  rf=r size=4 type=d alias=+4 align=2 words (r2.1)
//.declare V0504 (544)  rf=r size=8 type=q alias=+0 align=4 words (r4.4)
//.declare V0506 (546)  rf=r size=8 type=q alias=+8 align=4 words (r4.5)
//.declare V0507 (547)  rf=r size=128 type=d align=32 words (r34.0)
//.declare V0508 (548)  rf=r size=64 type=w align=32 words (r95.0)
//.declare V0509 (549)  rf=r size=64 type=w align=32 words (r97.0)
//.declare V0510 (550)  rf=r size=64 type=w align=32 words (r92.0)
//.declare V0511 (551)  rf=r size=64 type=w align=32 words (r93.0)
//.declare V0512 (552)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0514 (554)  rf=r size=128 type=ud alias=V0507+0 align=32 words (r34.0)
//.declare V0516 (556)  rf=r size=256 type=q align=32 words (r14.0)
//.declare V0517 (557)  rf=r size=384 type=d align=32 words (r18.0)
//.declare V0520 (560)  rf=r size=128 type=d align=32 words (r24.0)
//.declare V0522 (562)  rf=r size=128 type=ud alias=V0520+0 align=32 words (r24.0)
//.declare V0523 (563)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0525 (565)  rf=r size=128 type=ud alias=V0523+0 align=32 words (r26.0)
//.declare V0527 (567)  rf=r size=64 type=w align=32 words (r98.0)
//.declare V0528 (568)  rf=r size=64 type=w align=32 words (r101.0)
//.declare V0529 (569)  rf=r size=64 type=w align=32 words (r94.0)
//.declare V0530 (570)  rf=r size=64 type=w align=32 words (r96.0)
//.declare V0531 (571)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0533 (573)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V0534 (574)  rf=r size=384 type=d align=32 words (r14.0)
//.declare V0537 (577)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0539 (579)  rf=r size=128 type=ud alias=V0537+0 align=32 words (r20.0)
//.declare V0540 (580)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0542 (582)  rf=r size=128 type=ud alias=V0540+0 align=32 words (r22.0)
//.declare V0543 (583)  rf=r size=8 type=q align=32 words (r2.0)
//.declare V0544 (584)  rf=r size=8 type=q align=4 words (r3.0)
//.declare V0549 (589)  rf=r size=256 type=uq align=32 words (r11.0)
//.declare V0550 (590)  rf=r size=256 type=d align=32 words (r16.0)
//.declare V0551 (591)  rf=r size=256 type=q alias=V0549+0 align=32 words (r11.0)
//.declare V0552 (592)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0554 (594)  rf=r size=256 type=w alias=V0550+0 align=32 words (r16.0)
//.declare V0556 (596)  rf=r size=128 type=w alias=V0552+0 align=32 words (r20.0)
//.declare V0559 (599)  rf=r size=8 type=q align=32 words (r2.0)
//.declare V0560 (600)  rf=r size=8 type=q align=4 words (r3.0)
//.declare V0564 (604)  rf=r size=256 type=uq align=32 words (r11.0)
//.declare V0565 (605)  rf=r size=256 type=d align=32 words (r16.0)
//.declare V0566 (606)  rf=r size=256 type=q alias=V0564+0 align=32 words (r11.0)
//.declare V0567 (607)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0569 (609)  rf=r size=256 type=w alias=V0565+0 align=32 words (r16.0)
//.declare V0571 (611)  rf=r size=128 type=w alias=V0567+0 align=32 words (r20.0)
//.declare V0575 (615)  rf=r size=64 type=bf alias=V0509+0 align=32 words (r97.0)
//.declare V0577 (617)  rf=r size=64 type=bf alias=V0528+0 align=32 words (r101.0)
//.declare V0578 (618)  rf=r size=128 type=f align=32 words (r16.0)
//.declare V0580 (620)  rf=r size=64 type=bf alias=V0508+0 align=32 words (r95.0)
//.declare V0582 (622)  rf=r size=64 type=bf alias=V0527+0 align=32 words (r98.0)
//.declare V0583 (623)  rf=r size=128 type=f align=32 words (r14.0)
//.declare V0585 (625)  rf=r size=64 type=bf alias=V0511+0 align=32 words (r93.0)
//.declare V0587 (627)  rf=r size=64 type=bf alias=V0530+0 align=32 words (r96.0)
//.declare V0588 (628)  rf=r size=128 type=f align=32 words (r18.0)
//.declare V0590 (630)  rf=r size=64 type=bf alias=V0510+0 align=32 words (r92.0)
//.declare V0592 (632)  rf=r size=64 type=bf alias=V0529+0 align=32 words (r94.0)
//.declare V0593 (633)  rf=r size=128 type=f align=32 words (r20.0)
//.declare V0594 (634)  rf=r size=64 type=w align=32 words (r2.0)
//.declare V0596 (636)  rf=r size=64 type=bf alias=V0594+0 align=32 words (r2.0)
//.declare V0597 (637)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0599 (639)  rf=r size=64 type=bf alias=V0597+0 align=32 words (r3.0)
//.declare V0600 (640)  rf=r size=128 type=f align=32 words (r24.0)
//.declare V0601 (641)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0602 (642)  rf=r size=128 type=ud alias=V0512+0 align=32 words (r28.0)
//.declare V0603 (643)  rf=r size=128 type=ud alias=V0601+0 align=32 words (r8.0)
//.declare V0604 (644)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0606 (646)  rf=r size=64 type=bf alias=V0604+0 align=32 words (r7.0)
//.declare V0607 (647)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0608 (648)  rf=r size=128 type=ud alias=V0531+0 align=32 words (r26.0)
//.declare V0609 (649)  rf=r size=128 type=ud alias=V0607+0 align=32 words (r10.0)
//.declare V0610 (650)  rf=r size=64 type=w align=32 words (r12.0)
//.declare V0612 (652)  rf=r size=64 type=bf alias=V0610+0 align=32 words (r12.0)
//.declare V0613 (653)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0615 (655)  rf=r size=64 type=bf alias=V0367+0 align=32 words (r68.0)
//.declare V0617 (657)  rf=r size=64 type=bf alias=V0366+0 align=32 words (r69.0)
//.declare V0619 (659)  rf=r size=64 type=bf alias=V0365+0 align=32 words (r70.0)
//.declare V0621 (661)  rf=r size=64 type=bf alias=V0364+0 align=32 words (r71.0)
//.declare V0623 (663)  rf=r size=64 type=bf alias=V0363+0 align=32 words (r72.0)
//.declare V0625 (665)  rf=r size=64 type=bf alias=V0362+0 align=32 words (r73.0)
//.declare V0627 (667)  rf=r size=64 type=bf alias=V0361+0 align=32 words (r74.0)
//.declare V0629 (669)  rf=r size=64 type=bf alias=V0360+0 align=32 words (r75.0)
//.declare V0631 (671)  rf=r size=64 type=bf alias=V0359+0 align=32 words (r76.0)
//.declare V0633 (673)  rf=r size=64 type=bf alias=V0358+0 align=32 words (r77.0)
//.declare V0635 (675)  rf=r size=64 type=bf alias=V0357+0 align=32 words (r78.0)
//.declare V0637 (677)  rf=r size=64 type=bf alias=V0356+0 align=32 words (r79.0)
//.declare V0638 (678)  rf=r size=64 type=w align=32 words (r2.0)
//.declare V0639 (679)  rf=r size=64 type=bf alias=V0638+0 align=32 words (r2.0)
//.declare V0640 (680)  rf=r size=64 type=w align=32 words (r3.0)
//.declare V0641 (681)  rf=r size=64 type=bf alias=V0640+0 align=32 words (r3.0)
//.declare V0642 (682)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0643 (683)  rf=r size=64 type=uw alias=V0640+0 align=32 words (r3.0)
//.declare V0644 (684)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0646 (686)  rf=r size=64 type=uw alias=V0638+0 align=32 words (r2.0)
//.declare V0647 (687)  rf=r size=64 type=w align=32 words (r7.0)
//.declare V0648 (688)  rf=r size=64 type=bf alias=V0647+0 align=32 words (r7.0)
//.declare V0649 (689)  rf=r size=64 type=w align=32 words (r18.0)
//.declare V0650 (690)  rf=r size=64 type=bf alias=V0649+0 align=32 words (r18.0)
//.declare V0651 (691)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0652 (692)  rf=r size=64 type=uw alias=V0649+0 align=32 words (r18.0)
//.declare V0653 (693)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0655 (695)  rf=r size=64 type=uw alias=V0647+0 align=32 words (r7.0)
//.declare V0656 (696)  rf=r size=64 type=w align=32 words (r19.0)
//.declare V0657 (697)  rf=r size=64 type=bf alias=V0656+0 align=32 words (r19.0)
//.declare V0658 (698)  rf=r size=64 type=w align=32 words (r24.0)
//.declare V0659 (699)  rf=r size=64 type=bf alias=V0658+0 align=32 words (r24.0)
//.declare V0660 (700)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0661 (701)  rf=r size=64 type=uw alias=V0658+0 align=32 words (r24.0)
//.declare V0662 (702)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0664 (704)  rf=r size=64 type=uw alias=V0656+0 align=32 words (r19.0)
//.declare V0666 (706)  rf=r size=256 type=q align=32 words (r27.0)
//.declare V0667 (707)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P24 (708)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P25 (709)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0668 (710)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0671 (713)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0672 (714)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0673 (715)  rf=r size=8 type=uq alias=V0672+0 align=32 words (r4.0)
//.declare V0674 (716)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V0676 (718)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0679 (721)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0682 (724)  rf=r size=256 type=uq align=32 words (r12.0)
//.declare P26 (725)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0685 (728)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0686 (729)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0687 (730)  rf=r size=8 type=uq alias=V0686+0 align=32 words (r4.0)
//.declare V0688 (731)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V0690 (733)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0693 (736)  rf=r size=8 type=q align=4 words (r4.4)
//.declare V0696 (739)  rf=r size=256 type=uq align=32 words (r12.0)
//.declare V0697 (740)  rf=r size=128 type=f align=32 words (r16.0)
//.declare V0701 (744)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0703 (746)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0708 (751)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V0709 (752)  rf=r size=256 type=uq alias=V0708+0 align=32 words (r22.0)
//.declare P27 (753)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0710 (754)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0711 (755)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0712 (756)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0713 (757)  rf=r size=128 type=d align=32 words (r10.0)
//.declare  (758)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0715 (760)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0716 (761)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P28 (762)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0717 (763)  rf=r size=128 type=ud alias=V0715+0 align=32 words (r2.0)
//.declare V0718 (764)  rf=r size=4 type=ud alias=V0308+0 align=2 words (r102.7)
//.declare P29 (765)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P30 (766)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0719 (767)  rf=r size=64 type=w align=32 words (r2.0)
//.declare P31 (768)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0723 (772)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0724 (773)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0725 (774)  rf=r size=128 type=ud alias=V0724+0 align=32 words (r8.0)
//.declare V0726 (775)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P32 (776)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0728 (778)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0729 (779)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0730 (780)  rf=r size=8 type=uq alias=V0729+0 align=32 words (r4.0)
//.declare V0731 (781)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V0732 (782)  rf=r size=4 type=d align=2 words (r3.2)
//.declare V0734 (784)  rf=r size=4 type=ud alias=V0732+0 align=2 words (r3.2)
//.declare V0735 (785)  rf=r size=8 type=q align=4 words (r6.6)
//.declare V0736 (786)  rf=r size=8 type=q align=4 words (r7.0)
//.declare V0738 (788)  rf=r size=256 type=q align=32 words (r14.0)
//.declare V0739 (789)  rf=r size=256 type=uq alias=V0738+0 align=32 words (r14.0)
//.declare V0740 (790)  rf=r size=4 type=d align=2 words (r12.0)
//.declare V0742 (792)  rf=r size=8 type=q align=4 words (r13.0)
//.declare V0743 (793)  rf=r size=256 type=q align=32 words (r7.0)
//.declare V0744 (794)  rf=r size=256 type=uq alias=V0743+0 align=32 words (r7.0)
//.declare V0748 (798)  rf=r size=4 type=d align=32 words (r6.0)
//.declare V0749 (799)  rf=r size=4 type=ud alias=V0748+0 align=32 words (r6.0)
//.declare V0753 (803)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0754 (804)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0755 (805)  rf=r size=128 type=ud alias=V0754+0 align=32 words (r20.0)
//.declare V0756 (806)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0757 (807)  rf=r size=4 type=d align=32 words (r2.0)
//.declare P33 (808)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0758 (809)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0759 (810)  rf=r size=4 type=d align=32 words (r4.0)
//.declare P34 (811)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0760 (812)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0761 (813)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P35 (814)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P36 (815)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0762 (816)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0763 (817)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0764 (818)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0766 (820)  rf=r size=128 type=ud alias=V0764+0 align=32 words (r8.0)
//.declare V0767 (821)  rf=r size=256 type=q align=32 words (r12.0)
//.declare V0768 (822)  rf=r size=256 type=uq alias=V0767+0 align=32 words (r12.0)
//.declare V0769 (823)  rf=r size=256 type=q align=32 words (r24.0)
//.declare V0770 (824)  rf=r size=4 type=d alias=+0 align=2 words (r61.4)
//.declare V0771 (825)  rf=r size=4 type=d alias=+4 align=2 words (r61.5)
//.declare V0772 (826)  rf=r size=4 type=d alias=+0 align=2 words (r4.0)
//.declare V0773 (827)  rf=r size=4 type=d alias=+4 align=2 words (r4.1)
//.declare V0774 (828)  rf=r size=4 type=d align=2 words (r4.3)
//.declare V0775 (829)  rf=r size=4 type=d align=32 words (r40.0)
//.declare V0776 (830)  rf=r size=4 type=d align=2 words (r40.2)
//.declare V0777 (831)  rf=r size=4 type=ud alias=V0775+0 align=2 words (r40.0)
//.declare V0778 (832)  rf=r size=4 type=ud alias=V0770+0 align=2 words (r61.4)
//.declare V0779 (833)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0781 (835)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0782 (836)  rf=r size=4 type=d align=2 words (r61.1)
//.declare V0783 (837)  rf=r size=4 type=d align=32 words (r42.0)
//.declare V0784 (838)  rf=r size=4 type=d align=2 words (r40.4)
//.declare V0785 (839)  rf=r size=4 type=ud alias=V0783+0 align=2 words (r42.0)
//.declare V0786 (840)  rf=r size=4 type=d align=32 words (r7.0)
//.declare V0788 (842)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0789 (843)  rf=r size=4 type=d align=32 words (r102.0)
//.declare V0790 (844)  rf=r size=4 type=d align=2 words (r40.1)
//.declare V0791 (845)  rf=r size=4 type=ud alias=V0789+0 align=2 words (r102.0)
//.declare V0792 (846)  rf=r size=4 type=ud alias=V0771+0 align=2 words (r61.5)
//.declare V0793 (847)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0795 (849)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0796 (850)  rf=r size=4 type=d align=32 words (r41.0)
//.declare V0797 (851)  rf=r size=4 type=d align=2 words (r40.3)
//.declare V0798 (852)  rf=r size=4 type=ud alias=V0796+0 align=2 words (r41.0)
//.declare V0799 (853)  rf=r size=4 type=d align=32 words (r7.0)
//.declare V0801 (855)  rf=r size=4 type=d align=32 words (r8.0)
//.declare V0802 (856)  rf=r size=4 type=d align=2 words (r4.0)
//.declare V0803 (857)  rf=r size=4 type=d align=32 words (r43.0)
//.declare V0804 (858)  rf=r size=4 type=d align=2 words (r40.5)
//.declare V0805 (859)  rf=r size=4 type=ud alias=V0803+0 align=2 words (r43.0)
//.declare V0806 (860)  rf=r size=4 type=d align=32 words (r2.0)
//.declare V0808 (862)  rf=r size=4 type=d align=32 words (r3.0)
//.declare P37 (863)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0809 (864)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0810 (865)  rf=r size=8 type=q alias=V0041+0 align=32 words (r5.6)
//.declare V0812 (867)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0813 (868)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V0814 (869)  rf=r size=8 type=uq alias=V0813+0 align=32 words (r4.0)
//.declare V0815 (870)  rf=r size=4 type=d align=32 words (r3.0)
//.declare V0816 (871)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0817 (872)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0818 (873)  rf=r size=8 type=q alias=V0042+0 align=32 words (r5.7)
//.declare V0821 (876)  rf=r size=256 type=q align=32 words (r7.0)
//.declare V0822 (877)  rf=r size=256 type=uq alias=V0821+0 align=32 words (r7.0)
//.declare V0823 (878)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0824 (879)  rf=r size=4 type=d align=2 words (r4.0)
//.declare P38 (880)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare V0825 (881)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0826 (882)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0827 (883)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0830 (886)  rf=r size=256 type=q align=32 words (r18.0)
//.declare V0831 (887)  rf=r size=256 type=uq alias=V0830+0 align=32 words (r18.0)
//.declare V0832 (888)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0833 (889)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0834 (890)  rf=r size=128 type=d align=32 words (r88.0)
//.declare P39 (891)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0835 (892)  rf=r size=128 type=d align=32 words (r92.0)
//.declare V0836 (893)  rf=r size=128 type=ud alias=V0835+0 align=32 words (r92.0)
//.declare V0838 (895)  rf=r size=8 type=q align=4 words (r2.0)
//.declare V0840 (897)  rf=r size=8 type=q align=4 words (r2.1)
//.declare V0841 (898)  rf=r size=256 type=q align=32 words (r34.0)
//.declare V0842 (899)  rf=r size=256 type=uq alias=V0841+0 align=32 words (r34.0)
//.declare V0844 (901)  rf=r size=256 type=q align=32 words (r94.0)
//.declare V0845 (902)  rf=r size=256 type=uq alias=V0844+0 align=32 words (r94.0)
//.declare V0848 (905)  rf=r size=8 type=q alias=+0 align=4 words (r3.0)
//.declare V0849 (906)  rf=r size=8 type=d alias=V0848+0 align=4 words (r3.0)
//.declare V0851 (908)  rf=r size=8 type=q alias=+0 align=4 words (r3.2)
//.declare V0852 (909)  rf=r size=8 type=d alias=V0851+0 align=4 words (r3.4)
//.declare V0854 (911)  rf=r size=8 type=q alias=+8 align=4 words (r3.1)
//.declare V0855 (912)  rf=r size=8 type=d alias=V0854+0 align=4 words (r3.2)
//.declare V0857 (914)  rf=r size=8 type=q alias=+8 align=4 words (r3.3)
//.declare V0858 (915)  rf=r size=8 type=d alias=V0857+0 align=4 words (r3.6)
//.declare V0859 (916)  rf=r size=8 type=q alias=+0 align=4 words (r3.4)
//.declare V0860 (917)  rf=r size=8 type=q alias=+8 align=4 words (r3.5)
//.declare V0863 (920)  rf=r size=8 type=q alias=+0 align=4 words (r2.0)
//.declare V0864 (921)  rf=r size=8 type=q alias=+8 align=4 words (r2.1)
//.declare V0868 (925)  rf=r size=8 type=q align=4 words (r4.0)
//.declare V0869 (926)  rf=r size=8 type=d alias=V0868+0 align=4 words (r4.0)
//.declare V0870 (927)  rf=r size=8 type=q align=4 words (r6.6)
//.declare V0872 (929)  rf=r size=128 type=d align=32 words (r90.0)
//.declare V0873 (930)  rf=r size=64 type=w align=32 words (r98.0)
//.declare P40 (931)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P41 (932)  rf=f32  size=4 type=uw align=2 words (spilled -> )
//.declare V0874 (933)  rf=r size=8 type=q alias=V0037+0 align=32 words (r5.2)
//.declare V0878 (937)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P42 (943)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P43 (944)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0884 (945)  rf=r size=4 type=d align=2 words (r5.1)
//.declare V0885 (946)  rf=r size=8 type=q alias=V0036+0 align=32 words (r5.1)
//.declare V0886 (947)  rf=r size=8 type=q alias=V0040+0 align=32 words (r5.5)
//.declare P44 (948)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare V0888 (950)  rf=r size=128 type=d align=32 words (r44.0)
//.declare V0889 (951)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0890 (952)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0891 (953)  rf=r size=128 type=d align=32 words (r42.0)
//.declare P45 (954)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0892 (955)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0893 (956)  rf=r size=128 type=d align=32 words (r8.0)
//.declare P46 (957)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P47 (958)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0896 (961)  rf=r size=128 type=d align=32 words (r40.0)
//.declare V0897 (962)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0898 (963)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0899 (964)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0900 (965)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0901 (966)  rf=r size=128 type=d align=32 words (r12.0)
//.declare V0902 (967)  rf=r size=4 type=f align=2 words (r4.0)
//.declare V0903 (968)  rf=r size=4 type=ud alias=V0884+0 align=2 words (r5.1)
//.declare V0904 (969)  rf=r size=4 type=d align=2 words (r4.1)
//.declare V0905 (970)  rf=r size=4 type=ud alias=V0904+0 align=2 words (r4.1)
//.declare V0906 (971)  rf=r size=4 type=d align=2 words (r6.11)
//.declare V0907 (972)  rf=r size=128 type=f align=32 words (r14.0)
//.declare V0908 (973)  rf=r size=128 type=ud alias=V0901+0 align=32 words (r12.0)
//.declare V0909 (974)  rf=r size=4 type=f align=2 words (r6.12)
//.declare V0910 (975)  rf=r size=4 type=f align=2 words (r16.0)
//.declare V0911 (976)  rf=r size=128 type=f align=32 words (r18.0)
//.declare V0912 (977)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0913 (978)  rf=r size=128 type=ud alias=V0912+0 align=32 words (r2.0)
//.declare V0914 (979)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0915 (980)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V0916 (981)  rf=r size=128 type=ud alias=V0915+0 align=32 words (r10.0)
//.declare V0917 (982)  rf=r size=4 type=f align=2 words (r16.1)
//.declare V0918 (983)  rf=r size=4 type=ud alias=V0906+0 align=2 words (r6.11)
//.declare V0919 (984)  rf=r size=128 type=f align=32 words (r22.0)
//.declare V0920 (985)  rf=r size=128 type=ud alias=V0914+0 align=32 words (r20.0)
//.declare V0921 (986)  rf=r size=128 type=f align=32 words (r24.0)
//.declare V0927 (992)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V0928 (993)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0929 (994)  rf=r size=128 type=ud alias=V0928+0 align=32 words (r28.0)
//.declare V0930 (995)  rf=r size=128 type=d align=32 words (r30.0)
//.declare V0931 (996)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0932 (997)  rf=r size=128 type=d align=32 words (r14.0)
//.declare P48 (998)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0933 (999)  rf=r size=128 type=ud alias=V0932+0 align=32 words (r14.0)
//.declare V0934 (1000)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0935 (1001)  rf=r size=128 type=d align=32 words (r22.0)
//.declare V0937 (1003)  rf=r size=128 type=ud alias=V0896+0 align=32 words (r40.0)
//.declare V0941 (1007)  rf=r size=128 type=d align=32 words (r32.0)
//.declare V0942 (1008)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V0943 (1009)  rf=r size=128 type=d align=32 words (r16.0)
//.declare V0944 (1010)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0945 (1011)  rf=r size=128 type=ud alias=V0943+0 align=32 words (r16.0)
//.declare V0946 (1012)  rf=r size=128 type=ud alias=V0941+0 align=32 words (r32.0)
//.declare V0947 (1013)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0949 (1015)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0950 (1016)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0959 (1025)  rf=r size=128 type=d align=32 words (r26.0)
//.declare V0961 (1027)  rf=r size=128 type=ud alias=V0959+0 align=32 words (r26.0)
//.declare V0965 (1031)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V0966 (1032)  rf=r size=256 type=uq alias=V0965+0 align=32 words (r22.0)
//.declare V0968 (1034)  rf=r size=128 type=d align=32 words (r18.0)
//.declare V0969 (1035)  rf=r size=128 type=d align=32 words (r20.0)
//.declare V0971 (1037)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0972 (1038)  rf=r size=128 type=d align=32 words (r10.0)
//.declare P49 (1040)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare V0974 (1041)  rf=r size=128 type=ud alias=V0968+0 align=32 words (r18.0)
//.declare V0975 (1042)  rf=r size=128 type=ud alias=V0971+0 align=32 words (r2.0)
//.declare P50 (1043)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare P51 (1044)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0976 (1045)  rf=r size=128 type=ud alias=V0969+0 align=32 words (r20.0)
//.declare V0977 (1046)  rf=r size=128 type=ud alias=V0972+0 align=32 words (r10.0)
//.declare V0978 (1047)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V0979 (1048)  rf=r size=128 type=d align=32 words (r16.0)
//.declare V0980 (1049)  rf=r size=128 type=d align=32 words (r2.0)
//.declare V0981 (1050)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V0982 (1051)  rf=r size=256 type=uq align=32 words (r10.0)
//.declare V0983 (1052)  rf=r size=256 type=q alias=V0982+0 align=32 words (r10.0)
//.declare V0984 (1053)  rf=r size=512 type=d align=32 words (r8.0)
//.declare V0985 (1054)  rf=r size=256 type=uq align=32 words (r16.0)
//.declare V0986 (1055)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P52 (1056)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare P53 (1057)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V0988 (1059)  rf=r size=256 type=q align=32 words (r9.0)
//.declare V0989 (1060)  rf=r size=256 type=uq alias=V0988+0 align=32 words (r9.0)
//.declare V0990 (1061)  rf=r size=128 type=d align=32 words (r14.0)
//.declare V0995 (1066)  rf=r size=256 type=uq align=32 words (r24.0)
//.declare V0999 (1070)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1001 (1072)  rf=r size=128 type=d align=32 words (r10.0)
//.declare V1006 (1077)  rf=r size=256 type=q align=32 words (r22.0)
//.declare V1007 (1078)  rf=r size=256 type=uq alias=V1006+0 align=32 words (r22.0)
//.declare V1008 (1079)  rf=r size=128 type=f align=32 words (r26.0)
//.declare V1009 (1080)  rf=r size=128 type=d align=32 words (r28.0)
//.declare V1010 (1081)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1015 (1086)  rf=r size=256 type=uq align=32 words (r30.0)
//.declare V1016 (1087)  rf=r size=128 type=d align=32 words (r2.0)
//.declare P54 (1088)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1020 (1092)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V1021 (1093)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1094)  rf=r size=64 type=ud align=32 words (r7.0)
//.declare  (1095)  rf=r size=64 type=ud align=32 words (r10.0)
//.declare P55 (1096)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare V1022 (1097)  rf=r size=128 type=ud alias=V1020+0 align=32 words (r8.0)
//.declare V1023 (1098)  rf=r size=128 type=ud alias=V0834+0 align=32 words (r88.0)
//.declare P56 (1099)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare P57 (1100)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1101)  rf=r size=64 type=ud align=32 words (r2.0)
//.declare V1024 (1102)  rf=r size=4 type=ud align=2 words (r4.0)
//.declare  (1103)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare  (1104)  rf=r size=8 type=d align=8 words (r2.0)
//.declare  (1105)  rf=r size=8 type=d align=8 words (r102.4)
//.declare  (1106)  rf=r size=8 type=f align=8 words (r4.0)
//.declare  (1107)  rf=r size=8 type=ud align=8 words (r7.0)
//.declare  (1108)  rf=r size=8 type=f align=8 words (r2.4)
//.declare  (1109)  rf=r size=8 type=ud align=8 words (r4.8)
//.declare  (1110)  rf=r size=8 type=f align=8 words (r2.4)
//.declare  (1111)  rf=r size=8 type=ud align=8 words (r4.8)
//.declare  (1112)  rf=r size=16 type=q align=8 words (r4.4)
//.declare  (1113)  rf=r size=8 type=d align=32 words (r2.0)
//.declare  (1114)  rf=r size=8 type=d align=8 words (r4.0)
//.declare  (1115)  rf=r size=8 type=d align=8 words (r61.4)
//.declare  (1116)  rf=r size=16 type=q align=8 words (r3.4)
//.declare  (1117)  rf=r size=16 type=q align=8 words (r3.2)
//.declare  (1118)  rf=r size=16 type=q align=8 words (r2.0)
//.declare  (1119)  rf=r size=16 type=q align=8 words (r3.0)
//.declare  (1120)  rf=r size=128 type=uw align=32 words (r2.0)
//.declare  (1121)  rf=r size=128 type=uw align=32 words (r7.0)
//.declare  (1122)  rf=r size=4 type=d align=2 words (r3.0)
//.declare  (1123)  rf=r size=4 type=f align=2 words (r7.3)
//.declare  (1124)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1125)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1126)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1127)  rf=r size=4 type=d align=2 words (r11.1)
//.declare  (1128)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1129)  rf=r size=4 type=d align=2 words (r11.1)
//.declare  (1130)  rf=r size=4 type=d align=32 words (r3.0)
//.declare  (1131)  rf=r size=128 type=w alias=V0517+0 align=32 words (r18.0)
//.declare  (1132)  rf=r size=128 type=w alias=V0520+0 align=32 words (r24.0)
//.declare  (1133)  rf=r size=128 type=w alias=V0517+0 align=32 words (r18.0)
//.declare  (1134)  rf=r size=128 type=w alias=V0523+0 align=32 words (r26.0)
//.declare  (1135)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1136)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1137)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1138)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1139)  rf=r size=128 type=w alias=V0534+0 align=32 words (r14.0)
//.declare  (1140)  rf=r size=128 type=w alias=V0537+0 align=32 words (r20.0)
//.declare  (1141)  rf=r size=128 type=w alias=V0534+0 align=32 words (r14.0)
//.declare  (1142)  rf=r size=128 type=w alias=V0540+0 align=32 words (r22.0)
//.declare  (1143)  rf=r size=128 type=w alias=V0512+0 align=32 words (r28.0)
//.declare  (1144)  rf=r size=128 type=w alias=V0531+0 align=32 words (r26.0)
//.declare  (1145)  rf=r size=128 type=w alias=V0601+0 align=32 words (r8.0)
//.declare  (1146)  rf=r size=128 type=w alias=V0607+0 align=32 words (r10.0)
//.declare  (1147)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1148)  rf=r size=128 type=ud align=32 words (r16.0)
//.declare  (1149)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1150)  rf=r size=128 type=ud align=32 words (r14.0)
//.declare  (1151)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1152)  rf=r size=128 type=ud align=32 words (r14.0)
//.declare  (1153)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1154)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1157)  rf=r size=4 type=f align=2 words (r7.0)
//.declare  (1158)  rf=r size=4 type=d align=2 words (r2.0)
//.declare  (1160)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1161)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1162)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1163)  rf=r size=128 type=ud align=32 words (r12.0)
//.declare  (1164)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1165)  rf=r size=128 type=ud align=32 words (r10.0)
//.declare  (1166)  rf=r size=128 type=ud align=32 words (r16.0)
//.declare  (1167)  rf=r size=128 type=ud align=32 words (r20.0)
//.declare  (1168)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1169)  rf=r size=128 type=ud align=32 words (r12.0)
//.declare  (1170)  rf=r size=128 type=ud align=32 words (r2.0)
//.declare  (1171)  rf=r size=128 type=ud align=32 words (r8.0)
//.declare  (1172)  rf=r size=128 type=q align=32 words (r44.0)
//.declare  (1173)  rf=r size=128 type=q align=32 words (r99.0)
//.declare  (1174)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1175)  rf=r size=128 type=d align=32 words (r8.0)
//.declare  (1176)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1177)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1178)  rf=r size=128 type=q align=32 words (r66.0)
//.declare  (1179)  rf=r size=128 type=q align=32 words (r64.0)
//.declare  (1180)  rf=r size=128 type=q align=32 words (r88.0)
//.declare  (1181)  rf=r size=128 type=q align=32 words (r86.0)
//.declare  (1182)  rf=r size=128 type=q align=32 words (r84.0)
//.declare  (1183)  rf=r size=128 type=q align=32 words (r82.0)
//.declare  (1184)  rf=r size=128 type=q align=32 words (r44.0)
//.declare  (1185)  rf=r size=128 type=q align=32 words (r42.0)
//.declare  (1188)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1189)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1190)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1191)  rf=r size=128 type=d align=32 words (r8.0)
//.declare  (1192)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1193)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1194)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1195)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1196)  rf=r size=128 type=q align=32 words (r58.0)
//.declare  (1197)  rf=r size=128 type=q align=32 words (r56.0)
//.declare  (1198)  rf=r size=128 type=q align=32 words (r54.0)
//.declare  (1199)  rf=r size=128 type=q align=32 words (r52.0)
//.declare  (1200)  rf=r size=128 type=q align=32 words (r50.0)
//.declare  (1201)  rf=r size=128 type=q align=32 words (r46.0)
//.declare  (1204)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1205)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1206)  rf=r size=128 type=q align=32 words (r48.0)
//.declare  (1207)  rf=r size=128 type=q align=32 words (r30.0)
//.declare  (1208)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1209)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1210)  rf=r size=128 type=q align=32 words (r24.0)
//.declare  (1211)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1212)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1213)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1218)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1219)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1224)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1225)  rf=r size=128 type=q align=32 words (r25.0)
//.declare  (1226)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1227)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1230)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1231)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1234)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1235)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1236)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1237)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1238)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1239)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1242)  rf=r size=128 type=q align=32 words (r8.0)
//.declare  (1243)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1248)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1249)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1252)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1253)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1254)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1255)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1256)  rf=r size=128 type=q align=32 words (r11.0)
//.declare  (1257)  rf=r size=128 type=q align=32 words (r13.0)
//.declare  (1258)  rf=r size=128 type=q align=32 words (r86.0)
//.declare  (1259)  rf=r size=128 type=q align=32 words (r84.0)
//.declare  (1260)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1261)  rf=r size=128 type=q align=32 words (r9.0)
//.declare  (1262)  rf=r size=128 type=q align=32 words (r82.0)
//.declare  (1263)  rf=r size=128 type=q align=32 words (r80.0)
//.declare  (1264)  rf=r size=128 type=q align=32 words (r15.0)
//.declare  (1265)  rf=r size=128 type=q align=32 words (r17.0)
//.declare  (1266)  rf=r size=128 type=q align=32 words (r78.0)
//.declare  (1267)  rf=r size=128 type=q align=32 words (r68.0)
//.declare  (1268)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1269)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1270)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1271)  rf=r size=128 type=d align=32 words (r14.0)
//.declare  (1272)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1273)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1274)  rf=r size=128 type=q align=32 words (r66.0)
//.declare  (1275)  rf=r size=128 type=q align=32 words (r46.0)
//.declare  (1276)  rf=r size=128 type=q align=32 words (r54.0)
//.declare  (1277)  rf=r size=128 type=q align=32 words (r52.0)
//.declare  (1278)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1279)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1280)  rf=r size=128 type=q align=32 words (r50.0)
//.declare  (1281)  rf=r size=128 type=q align=32 words (r48.0)
//.declare  (1282)  rf=r size=128 type=q align=32 words (r64.0)
//.declare  (1283)  rf=r size=128 type=q align=32 words (r62.0)
//.declare  (1284)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1285)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1290)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1291)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1292)  rf=r size=128 type=q align=32 words (r58.0)
//.declare  (1293)  rf=r size=128 type=q align=32 words (r56.0)
//.declare  (1294)  rf=r size=128 type=d align=32 words (r16.0)
//.declare  (1295)  rf=r size=128 type=d align=32 words (r18.0)
//.declare  (1296)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1297)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1298)  rf=r size=128 type=q align=32 words (r24.0)
//.declare  (1299)  rf=r size=128 type=q align=32 words (r26.0)
//.declare  (1300)  rf=r size=128 type=q align=32 words (r70.0)
//.declare  (1301)  rf=r size=128 type=q align=32 words (r72.0)
//.declare  (1304)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1305)  rf=r size=128 type=q align=32 words (r12.0)
//.declare  (1306)  rf=r size=128 type=q align=32 words (r76.0)
//.declare  (1307)  rf=r size=128 type=q align=32 words (r74.0)
//.declare  (1308)  rf=r size=128 type=uq align=32 words (r14.0)
//.declare  (1309)  rf=r size=128 type=uq align=32 words (r16.0)
//.declare  (1310)  rf=r size=128 type=q align=32 words (r2.0)
//.declare  (1311)  rf=r size=128 type=q align=32 words (r7.0)
//.declare  (1314)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1315)  rf=r size=128 type=q align=32 words (r22.0)
//.declare  (1318)  rf=r size=128 type=d align=32 words (r2.0)
//.declare  (1319)  rf=r size=128 type=d align=32 words (r12.0)
//.declare  (1320)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1321)  rf=r size=128 type=q align=32 words (r16.0)
//.declare  (1322)  rf=r size=128 type=q align=32 words (r18.0)
//.declare  (1323)  rf=r size=128 type=q align=32 words (r20.0)
//.declare  (1326)  rf=r size=128 type=q align=32 words (r10.0)
//.declare  (1327)  rf=r size=128 type=q align=32 words (r14.0)
//.declare  (1334)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1335)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1336)  rf=r size=128 type=d alias=+0 align=32 words (r44.0)
//.declare  (1337)  rf=r size=128 type=d alias=+0 align=32 words (r42.0)
//.declare  (1338)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1339)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1340)  rf=r size=128 type=ud alias=+0 align=32 words (r2.0)
//.declare  (1341)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1342)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1343)  rf=r size=128 type=d alias=+0 align=32 words (r2.0)
//.declare  (1344)  rf=r size=128 type=d alias=+0 align=32 words (r7.0)
//.declare  (1345)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1346)  rf=r size=128 type=d alias=+0 align=32 words (r18.0)
//.declare  (1347)  rf=r size=128 type=d alias=+0 align=32 words (r54.0)
//.declare  (1348)  rf=r size=128 type=d alias=+0 align=32 words (r52.0)
//.declare  (1349)  rf=r size=128 type=d alias=+0 align=32 words (r10.0)
//.declare  (1350)  rf=r size=128 type=d alias=+0 align=32 words (r12.0)
//.declare  (1351)  rf=r size=128 type=d alias=+0 align=32 words (r20.0)
//.declare  (1352)  rf=r size=128 type=d alias=+0 align=32 words (r22.0)
//.declare  (1353)  rf=r size=128 type=d alias=+0 align=32 words (r76.0)
//.declare  (1354)  rf=r size=128 type=d alias=+0 align=32 words (r74.0)
//.declare  (1355)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1356)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1357)  rf=r size=128 type=uq alias=+0 align=32 words (r76.0)
//.declare  (1358)  rf=r size=128 type=uq alias=+0 align=32 words (r74.0)
//.declare  (1359)  rf=r size=128 type=ud alias=+0 align=32 words (r2.0)
//.declare  (1360)  rf=r size=128 type=d alias=+0 align=32 words (r14.0)
//.declare  (1361)  rf=r size=128 type=d alias=+0 align=32 words (r16.0)
//.declare  (1362)  rf=r size=4 type=uw align=2 words (r61.22)
//.declare  (1363)  rf=r size=4 type=uw align=2 words (r102.6)
//.declare  (1364)  rf=r size=4 type=uw align=2 words (r5.0)
//.declare  (1365)  rf=r size=4 type=uw align=2 words (r102.20)
//.declare  (1366)  rf=r size=4 type=uw align=2 words (r102.18)
//.declare  (1367)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1368)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1369)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1370)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1371)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1372)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1373)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1374)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1375)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1376)  rf=f32  size=4 type=uw align=2 words (f3.0)
//.declare  (1377)  rf=f32  size=4 type=uw align=2 words (f2.0)
//.declare  (1378)  rf=f32  size=4 type=uw align=2 words (f1.0)
//.declare  (1379)  rf=f32  size=4 type=uw align=2 words (f0.0)
//.declare  (1380)  rf=r size=64 type=d align=32 words (r2.0)
//.declare  (1381)  rf=r size=64 type=d align=32 words (r3.0)
//.declare  (1382)  rf=r size=64 type=d align=32 words (r4.0)
//.declare  (1383)  rf=r size=64 type=d align=32 words (r6.0)
//.declare  (1384)  rf=r size=64 type=d align=32 words (r7.0)
//.declare  (1385)  rf=r size=64 type=d align=32 words (r8.0)
//.declare  (1386)  rf=r size=64 type=d align=32 words (r9.0)
//.declare  (1387)  rf=r size=64 type=d align=32 words (r10.0)
//.declare  (1388)  rf=r size=64 type=d align=32 words (r11.0)
//.declare  (1389)  rf=r size=64 type=d align=32 words (r12.0)
//.declare  (1390)  rf=r size=64 type=d align=32 words (r13.0)
//.declare  (1391)  rf=r size=64 type=d align=32 words (r14.0)
//.declare  (1392)  rf=r size=64 type=d align=32 words (r15.0)
//.declare  (1393)  rf=r size=64 type=d align=32 words (r16.0)
//.declare  (1394)  rf=r size=64 type=d align=32 words (r17.0)
//.declare  (1395)  rf=r size=64 type=d align=32 words (r18.0)
//.declare  (1396)  rf=r size=64 type=d align=32 words (r19.0)
//.declare  (1397)  rf=r size=64 type=d align=32 words (r20.0)
//.declare  (1398)  rf=r size=64 type=d align=32 words (r21.0)
//.declare  (1399)  rf=r size=64 type=d align=32 words (r22.0)
//.declare  (1400)  rf=r size=64 type=d align=32 words (r23.0)
//.declare  (1401)  rf=r size=64 type=d align=32 words (r24.0)
//.declare  (1402)  rf=r size=64 type=d align=32 words (r25.0)
//.declare  (1403)  rf=r size=64 type=d align=32 words (r26.0)
//.declare  (1404)  rf=r size=64 type=d align=32 words (r27.0)
//.declare  (1405)  rf=r size=64 type=d align=32 words (r28.0)
//.declare  (1406)  rf=r size=64 type=d align=32 words (r29.0)
//.declare  (1407)  rf=r size=64 type=d align=32 words (r30.0)
//.declare  (1408)  rf=r size=64 type=d align=32 words (r31.0)
//.declare  (1409)  rf=r size=64 type=d align=32 words (r32.0)
//.declare  (1410)  rf=r size=64 type=d align=32 words (r33.0)
//.declare r0 (1411)  rf=r size=64 type=ud align=32 words (r0.0)
//.declare rtmp (1412)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare inlineRegFromTDL (1413)  rf=r size=32 type=ud align=2 words (r1.0)
//.declare inlineRegExpectedLocation (1414)  rf=r size=32 type=ud align=2 words (r4.0)
//.declare  (1415)  rf=r size=128 type=ud align=32 words (r1.0)
//.declare  (1416)  rf=r size=64 type=ud align=32 words (r3.0)
//.declare  (1417)  rf=r size=128 type=ud align=32 words (r5.0)

// .inputs
// +----------+----------+--------+----------+------------------+
// | id       | type     |  bytes | at       | from             |
// +----------+----------+--------+----------+------------------+
// | V0057    | :w x 32  |   0x40 | r1       | pti[tid]+0x0     |
// | V0058    | :w x 32  |   0x40 | r2       | pti[tid]+0x40    |
// | V0059    | :w x 32  |   0x40 | r3       | pti[tid]+0x80    |
// | V1024    | :ud      |    0x4 | r4       | inline+0x0       |
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
        mov (32|M0)              r32.0<1>:d    r1.0<1;1,0>:uw                   {$0.dst}             //  ALU pipe: int; $25

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     shr (1|M0)               r4.0<1>:ud    r6.8<0;1,0>:ud    31:w                                //  ALU pipe: int; $15

// Line 1129:  const bool is_sender = (sm_id % 2 == 0);
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.11<0;1,0>:d    0:w               {I@3}             //  ALU pipe: int; $30

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 156:  return __spirv_BuiltInLocalInvocationId.x;
        mov (16|M0)              r2.0<4>:uw    r1.0<1;1,0>:uw                   {$1.dst}             //  ALU pipe: int; $10
        mov (16|M16)             r7.0<4>:uw    r1.16<1;1,0>:uw                                       //  ALU pipe: int; $10

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        and (32|M0)              r38.0<1>:d    r32.0<1;1,0>:d    31:w               {Compacted,I@5}  //  ALU pipe: int; $26
        shr (32|M0)              r80.0<1>:ud   r32.0<1;1,0>:ud   5:w                                 //  ALU pipe: int; $27

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     add (1|M0)               r102.4<1>:d   r4.0<0;1,0>:d     r6.8<0;1,0>:d    {Compacted,I@6}    //  ALU pipe: int; $16

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 156:  return __spirv_BuiltInLocalInvocationId.x;
        mov (16|M0)              r44.0<1>:q    r2.0<4;1,0>:uw                   {I@5}                //  ALU pipe: int; $10
        mov (16|M16)             r99.0<1>:q    r7.0<4;1,0>:uw                   {I@5}                //  ALU pipe: int; $10

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1130:  const int responsible_channel = sm_id / 2;
(W)     shr (1|M0)               r102.8<1>:ud  r60.1<0;1,0>:ud   1:w                                 //  ALU pipe: int; $20

// Line 1133:  int hidden_int4 = hidden_ * sizeof(dtype_t) / sizeof(int4);
(W)     asr (1|M0)               r61.0<1>:d    r6.5<0;1,0>:d     3:w                                 //  ALU pipe: int; $23

// Line 1128:  const int num_channels = num_sms_ / 2;
(W)     asr (1|M0)               r102.2<1>:d   r102.4<0;1,0>:d   1:w               {I@5}             //  ALU pipe: int; $17

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
        shl (32|M0)              r2.0<1>:d     r32.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $54
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r4.4<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $55
        mov (32|M0)              r10.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $56
        store.slm.d32.a32 (32|M0)  [r8:2]       r10:2              {I@1,$3} // ex_desc:0x0; desc:0x4000504 // $57
// B005: Preds:{B004, B003},  Succs:{B006, B007}
_0_138:
        join (32|M0)                         L696                                                    // 
L696:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r38.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $61
(~f1.0) goto (32|M0)                         _0_140            _0_140                                //  ALU pipe: int; $62
// B006: [inDivergent],  Preds:{B005},  Succs:{B007}
_0_141:

// Line 1289:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] = 0;
        shl (32|M0)              r2.0<1>:d     r80.0<1;1,0>:d    3:w               {Compacted}       //  ALU pipe: int; $65
        shl (32|M0)              r8.0<1>:d     r38.0<1;1,0>:d    2:w               {Compacted,$3.src} //  ALU pipe: int; $66
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
        shl (32|M0)              r2.0<1>:d     r32.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $78
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
(W)     add (1|M0)               r102.0<1>:q   r6.7<0;1,0>:q     r2.0<0;1,0>:ud                      //  ALU pipe: int; $96

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 20:  Buffer() : ptr(nullptr), total_bytes(0) {}
(W)     add (1|M0)               r61.7<1>:q    r6.7<0;1,0>:q     r3.4<0;1,0>:ud   {I@2}              //  ALU pipe: int; $106
(W)     mov (1|M0)               r4.0<1>:q     r102.0<0;1,0>:q                  {I@2}                //  ALU pipe: int; $102
(W)     mov (1|M0)               r7.0<1>:q     r61.7<0;1,0>:q                   {I@2}                //  ALU pipe: int; $113
(W)     store.ugm.d32x4t.a64.wb.wb (1|M0)  [r4:1+0x10] r3:1        {I@2,$8} // ex_desc:0x10000; desc:0x20EB584 // $103
(W)     store.ugm.d32x4t.a64.wb.wb (1|M0)  [r7:1+0x10] r3:1        {I@1,$9} // ex_desc:0x10000; desc:0x20EB584 // $114

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1345:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) +
(W)     shl (1|M0)               r4.4<1>:q     r6.7<0;1,0>:d     3:w               {$8.src}          //  ALU pipe: int; $122

// Line 1343:  auto num_channels_total = num_channels * kNumRanks;
(W)     and (1|M0)               r4.5<1>:d     r102.4<0;1,0>:d   -2:w                                //  ALU pipe: int; $119

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
(W)     shl (1|M0)               r6.11<1>:d    r102.2<0;1,0>:d   2:w                                 //  ALU pipe: int; $126

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
(W)     cmp (32|M0)   (lt)f3.0   null<1>:ud    r102.4<0;1,0>:ud  0x2:uw                              //  ALU pipe: int; $274

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
(W)     mov (1|M0)               r102.3<1>:d   -1:w                                                  //  ALU pipe: int; $277
(W)     jmpi                                 _0_148                                                  // $278
// B012: [inDivergent],  Preds:{B010},  Succs:{B013}
_0_146:
(W)     add3 (1|M0)              r102.5<1>:d   r102.2<0;0>:d     r6.4<0;0>:d       -1:w               //  ALU pipe: int; $281 R{} IR{}{E:3,E:3,},  {BC=1}
(W)     add (1|M0)               r3.0<1>:d     r102.2<0;1,0>:d   r6.4<0;1,0>:d    {Compacted}        //  ALU pipe: int; $280
(W)     asr (2|M0)               r2.0<1>:d     r102.4<1;1,0>:d   31:w               {Compacted,I@2}  //  ALU pipe: int; $282
(W)     add (1|M0)               r2.2<1>:d     r2.0<0;1,0>:d     r102.2<0;1,0>:d  {Compacted,I@1}    //  ALU pipe: int; $284
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
(W)     bfn.(s0^s1^s2) (1|M0)    r102.3<1>:ud  r7.0<0;0>:ud      r2.0<0;0>:ud      r2.1<0>:ud       {I@1} //  ALU pipe: int; $316
// B013: [inDivergent],  Preds:{B012, B011},  Succs:{B014, B061}
_0_148:

// Line 53:  token_start_idx = sycl::min(num_tokens_per_sm * sm_id, num_tokens);
(W)     mul (1|M0)               acc0.0<1>:d   r102.3<0;1,0>:d   r102.16<0;1,0>:uw {I@1}             //  ALU pipe: int; $320

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
(W)     macl (1|M0)              r2.0<1>:d     r102.3<0;1,0>:d   r102.8<0;1,0>:d  {Compacted}        //  ALU pipe: int; $324

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
(W)     add (1|M0)               r3.0<1>:d     r4.0<0;1,0>:d     r102.3<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $327

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        add3 (32|M0)             r16.0<1>:d    r4.0<0;0>:d       r80.0<1;0>:d      -1:w               //  ALU pipe: int; $335

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
(W)     sel (1|M0)    (lt)f0.0   r102.7<1>:d   r3.0<0;1,0>:d     r6.4<0;1,0>:d    {I@2}              //  ALU pipe: int; $331

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W)     mov (1|M0)               r4.11<1>:d    r5.7<0;1,0>:d                                         //  ALU pipe: int; $338

// Line 1370:  token_idx < token_end_idx;
        cmp (32|M0)   (lt)f2.0   null<1>:d     r16.0<1;1,0>:d    r102.7<0;1,0>:d  {I@2}              //  ALU pipe: int; $350

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
        shl (32|M0)              r14.0<1>:d    r38.0<1;1,0>:d    2:w               {Compacted,$13.src} //  ALU pipe: int; $385

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        mov (16|M0)              r10.0<2>:d    r2.0<1;1,0>:d                    {I@6}                //  ALU pipe: int; $364
        mov (16|M16)             r12.0<2>:d    r3.0<1;1,0>:d                    {$14.src}            //  ALU pipe: int; $365

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r61.11<1>:ud  f0.0<0;1,0>:ud                                        //  ALU pipe: int; $377

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        shl (32|M0)              r2.0<1>:d     r80.0<1;1,0>:d    3:w               {Compacted}       //  ALU pipe: int; $384

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W)     cmp (32|M0)   (eq)f0.0   null<1>:d     r4.9<0;1,0>:d     r4.5<0;1,0>:d                       //  ALU pipe: int; $380

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        and (32|M0)              r7.0<1>:w     r7.0<1;1,0>:w     124:w               {I@7}           //  ALU pipe: int; $372

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        mov (16|M0)              r10.1<2>:d    r8.0<1;1,0>:d                    {I@7}                //  ALU pipe: int; $366
        mov (16|M16)             r12.1<2>:d    r9.0<1;1,0>:d                                         //  ALU pipe: int; $367

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        cmp (32|M0)   (lt)f3.0   null<1>:d     r38.0<1;1,0>:d    r61.0<0;1,0>:d                      //  ALU pipe: int; $391
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.10<0;1,0>:d    0:w                                 //  ALU pipe: int; $392

// Line 1492:  if (lane_id < num_topk_) {
        cmp (32|M0)   (lt)f1.0   null<1>:d     r38.0<1;1,0>:d    r6.6<0;1,0>:d                       //  ALU pipe: int; $395 R{} IR{}{E:3,E:3,},  R{r6,} IR{} {BC=1}

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        or (32|M0)               r90.0<1>:d    r2.0<1;1,0>:d     r14.0<1;1,0>:d   {Compacted,I@7}    //  ALU pipe: int; $386

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W&f0.0) cmp (32|M0)  (eq)f0.0   null<1>:d     r4.8<0;1,0>:d     r4.0<0;1,0>:d                       //  ALU pipe: int; $381

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        add (32|M0)              r62.0<1>:d    r4.2<0;1,0>:d     r7.0<1;1,0>:uw   {I@7}              //  ALU pipe: int; $374

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
        shl (16|M0)              r66.0<1>:q    r10.0<1;1,0>:q    2:w               {Compacted,I@7}   //  ALU pipe: int; $388
        shl (16|M16)             r64.0<1>:q    r12.0<1;1,0>:q    2:w               {Compacted,I@7}   //  ALU pipe: int; $388
        mov (16|M16)             r8.0<2>:ud    r17.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $397
        mov (16|M0)              r2.0<2>:ud    r16.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $397
        add (16|M0)              r88.0<1>:q    r66.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $389
        add (16|M0)              r84.0<1>:q    r66.0<1;1,0>:q    r5.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $390
        add (16|M16)             r86.0<1>:q    r64.0<1;1,0>:q    r6.0<0;1,0>:q    {Compacted,I@5}    //  ALU pipe: int; $389
        add (16|M16)             r82.0<1>:q    r64.0<1;1,0>:q    r5.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $390
        mov (16|M16)             r42.0<1>:q    r8.0<2;1,0>:d                    {I@6}                //  ALU pipe: int; $397
        mov (16|M0)              r44.0<1>:q    r2.0<2;1,0>:d                    {I@6}                //  ALU pipe: int; $397

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
(W)     asr (1|M0)               r102.6<1>:d   r102.7<0;1,0>:d   31:w                                //  ALU pipe: int; $355

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
(W)     mov (1|M0)               r61.13<1>:d   (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $393
(W)     mov (2|M0)               r61.7<1>:d    r4.0<1;1,0>:d                                         //  ALU pipe: int; $400
(W)     mov (2|M0)               r61.5<1>:d    r4.0<1;1,0>:d                                         //  ALU pipe: int; $401

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r102.9<1>:ud  f3.0<0;1,0>:ud                                        //  ALU pipe: int; $391
(W)     mov (1|M0)               r102.3<1>:ud  f2.0<0;1,0>:ud                                        //  ALU pipe: int; $392
(W)     mov (1|M0)               r102.10<1>:ud  f1.0<0;1,0>:ud                                       //  ALU pipe: int; $395
// B015: [inDivergent],  Preds:{B060, B014},  Succs:{B016, B017}
_0_151:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f3.0   null<1>:ud    r38.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $409
        mov (16|M0)              r32.0<1>:d    r44.0<2;1,0>:d                   {Compacted,I@7}      //  ALU pipe: int; $404
        mov (16|M16)             r33.0<1>:d    r42.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $405
        mov (16|M0)              r40.0<1>:d    r44.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $406
        mov (16|M16)             r41.0<1>:d    r42.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $407

// Line 1375:  if (lane_id < kNumRanks) {
(f3.0)  goto (32|M0)                         _0_152            _0_152                                //  ALU pipe: int; $411
// B016: [inDivergent],  Preds:{B015},  Succs:{B018}
_0_153:
        mov (32|M0)              r36.0<1>:d    -1:w                               {Compacted}        //  ALU pipe: int; $413
        goto (32|M0)                         _0_152            _0_154                                // $414
// B017: [inDivergent],  Preds:{B015},  Succs:{B018}
_0_152:
        join (32|M0)                         _0_154                                                  // 
L3952:

// Line 1376:  expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
        shl (16|M0)              r2.0<1>:q     r44.0<1;1,0>:q    3:w               {Compacted}       //  ALU pipe: int; $417
        shl (16|M16)             r7.0<1>:q     r42.0<1;1,0>:q    3:w               {Compacted}       //  ALU pipe: int; $417
        add (16|M0)              r9.0<1>:q     r88.0<1;1,0>:q    r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $418
        sync.nop                             null                             {Compacted,$15.src}    // $418
        add (16|M16)             r11.0<1>:q    r86.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,@2,$0.src} //  ALU pipe: int; $418

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r36:2         [r9:4]             {I@1,$2} // ex_desc:0x0; desc:0x8200580 // $422
// B018: [inDivergent],  Preds:{B017, B016},  Succs:{B019}
_0_154:
        join (32|M0)                         _0_149                                                  // 
L4024:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        cmp (32|M0)   (gt)f3.0   null<1>:d     r36.0<1;1,0>:d    -1:w               {$2.dst}         //  ALU pipe: int; $428

// Line 1385:  if (lane_id < kNumRanks && expected_head >= 0) {
(f3.0)  cmp (32|M0)   (lt)f3.0   null<1>:ud    r38.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $430
// B019: [inDivergent],  Preds:{B022, B018},  Succs:{B020, B021}
_0_155:
(f3.0)  goto (32|M0)                         _0_156            _0_156                                //  ALU pipe: int; $436
// B020: [inDivergent],  Preds:{B019},  Succs:{B022}
_0_157:
        mov (32|M0)              r2.0<1>:d     0:w                               {Compacted}         //  ALU pipe: int; $438
        goto (32|M0)                         _0_156            _0_158                                // $439
// B021: [inDivergent],  Preds:{B019},  Succs:{B022}
_0_156:
        join (32|M0)                         _0_158                                                  // 
L4112:

// Line 1386:  if (channel_tail_idx_shared[lane_id] <= expected_head) {
        load.slm.d32.a32 (32|M0)  r2:2          [r62:2]            {I@3,$6} // ex_desc:0x0; desc:0x4200500 // $442
        cmp (32|M0)   (le)f2.0   r2.0<1>:d     r2.0<1;1,0>:d     r36.0<1;1,0>:d   {$6.dst}           //  ALU pipe: int; $443
// B022: [inDivergent],  Preds:{B021, B020},  Succs:{B023, B019}
_0_158:
        join (32|M0)                         _0_149                                                  // 
L4160:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/spirv.hpp

// Line 214:  return __spirv_GroupAny(group_scope<Group>::value, pred);
        cmp (32|M0)   (ne)f1.0   r2.0<1>:d     r2.0<1;1,0>:d     0:w               {I@2}             //  ALU pipe: int; $453
(W)     mov (32|M0)              r7.0<1>:ud    0x0:uw                                                //  ALU pipe: int; $455
        mov (32|M0)              r7.0<1>:d     -r2.0<1;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $454
(W)     sel (16|M0)   (ge)f0.0   r9.0<1>:ud    r7.0<1;1,0>:ud    r8.0<1;1,0>:ud   {I@1}              //  ALU pipe: int; $457
(W)     sel (8|M0)    (ge)f0.0   r4.8<1>:ud    r9.0<1;1,0>:ud    r9.8<1;1,0>:ud   {I@1}              //  ALU pipe: int; $458
(W)     sel (4|M0)    (ge)f0.0   r10.0<1>:ud   r4.8<1;1,0>:ud    r4.12<1;1,0>:ud  {I@1}              //  ALU pipe: int; $459
(W)     sel (2|M0)    (ge)f0.0   r6.11<1>:ud   r10.0<1;1,0>:ud   r10.2<1;1,0>:ud  {I@1}              //  ALU pipe: int; $460
(W)     sel (1|M0)    (ge)f0.0   r11.0<1>:d    r6.11<0;1,0>:ud   r6.12<0;1,0>:ud  {I@1}              //  ALU pipe: int; $461
(W)     cmp (32|M0)   (eq)f1.0   null<1>:d     r11.0<0;1,0>:d    0:w               {I@1}             //  ALU pipe: int; $462

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1382:  while (any_waiting) {
(W&~f1.0) jmpi                               _0_155                                                  //  ALU pipe: int; $465
// B023: [inDivergent],  Preds:{B022},  Succs:{B024, B025}
_0_159:

// Line 1405:  if (expected_head_i >= 0) {
(W)     cmp (32|M0)   (gt)f2.0   null<1>:d     r36.0<0;1,0>:d    -1:w                                //  ALU pipe: int; $488
(W&f2.0) jmpi                                _0_160                                                  //  ALU pipe: int; $489
// B024: [inDivergent],  Preds:{B023},  Succs:{B029}
_0_161:
(W)     mov (2|M0)               r16.0<1>:d    r61.7<1;1,0>:d                   {$0.src}             //  ALU pipe: int; $491
(W)     mov (2|M0)               r14.0<1>:d    r61.5<1;1,0>:d                                        //  ALU pipe: int; $492
(W)     mov (1|M0)               r14.6<1>:hf   0x0:hf                                                //  ALU pipe: float; $493
(W)     jmpi                                 _0_162                                                  // $494
// B025: [inDivergent],  Preds:{B023},  Succs:{B026, B027}
_0_160:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r102.3<0;1,0>:ud                 {Compacted}          //  ALU pipe: int; $497

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W&~f3.0) jmpi                               _0_163                                                  //  ALU pipe: int; $497
// B026: [inDivergent],  Preds:{B025},  Succs:{B028}
_0_164:
(W)     mov (1|M0)               r14.2<1>:d    -1:w                               {Compacted,$0.src} //  ALU pipe: int; $499
(W)     jmpi                                 _0_165                                                  // $500
// B027: [inDivergent],  Preds:{B025},  Succs:{B028}
_0_163:
(W)     asr (1|M0)               r3.0<1>:d     r36.0<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $502
(W)     add (1|M0)               r2.0<1>:d     r3.0<0;1,0>:d     r36.0<0;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $503
(W)     xor (1|M0)               r3.1<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $504
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $505
(W)     mov (1|M0)               r4.0<1>:f     r61.13<0;1,0>:ud                 {A@1}                //  ALU pipe: float; $506
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $511
(W)     math.inv (1|M0)          r4.3<1>:f     r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $510
(W)     mov (1|M0)               r4.1<1>:f     r3.1<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $509
(W)     mad (1|M0)               r6.11<1>:f    r4.3<0;0>:f       r7.0<0;0>:f       r4.3<0>:f        {A@1} //  ALU pipe: float; $511
(W)     mov (1|M0)               r3.2<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $507
(W)     mov (1|M0)               r6.13<1>:ud   r4.1<0;1,0>:f                    {F@2}                //  ALU pipe: int; $513
(W)     mul (1|M0)               r6.12<1>:f    r4.1<0;1,0>:f     r6.11<0;1,0>:f   {F@1}              //  ALU pipe: float; $512
(W)     add (1|M0)               r4.8<1>:d     (abs)r6.10<0;1,0>:d  -r3.2<0;1,0>:d {I@2}             //  ALU pipe: int; $508
(W)     add (1|M0)               r4.9<1>:d     r3.1<0;1,0>:d     -r6.13<0;1,0>:d  {I@2}              //  ALU pipe: int; $514
(W)     mov (1|M0)               r2.0<1>:ud    r6.12<0;1,0>:f                   {F@1}                //  ALU pipe: int; $515
(W)     mov (1|M0)               r2.4<1>:f     r4.8<0;1,0>:ud                   {I@3}                //  ALU pipe: float; $516
(W)     mov (1|M0)               r2.5<1>:f     r4.9<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $516
(W)     mov (1|M0)               r9.0<1>:f     r2.0<0;1,0>:ud                   {I@1}                //  ALU pipe: float; $518
(W)     mad (1|M0)               r2.1<1>:f     r4.1<0;0>:f       r9.0<0;0>:f       -r4.0<0>:f       {F@1} //  ALU pipe: float; $520
(W)     mad (1|M0)               r3.2<1>:f     r2.5<0;0>:f       r9.0<0;0>:f       -r2.4<0>:f        //  ALU pipe: float; $522
(W)     add (1|M0)               r8.0<1>:f     r2.1<0;1,0>:f     r3.2<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $523
(W)     mul (1|M0)               r10.0<1>:f    r6.11<0;1,0>:f    r8.0<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $524
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $525
(W)     mov (1|M0)               r7.0<1>:ud    r10.0<0;1,0>:f                   {A@1}                //  ALU pipe: int; $526
(W)     mov (1|M0)               r11.1<1>:d    (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $528
(W)     add (1|M0)               r11.0<1>:d    r7.0<0;1,0>:d     r2.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $527
(W)     mul (1|M0)               acc0.0<1>:d   r11.0<0;1,0>:d    r11.2<0;1,0>:uw  {I@1}              //  ALU pipe: int; $528
        sync.nop                             null                             {Compacted,$15.src}    // $529
(W)     macl (1|M0)              r12.0<1>:d    r11.0<0;1,0>:d    r11.1<0;1,0>:d   {Compacted,$0.src} //  ALU pipe: int; $529
(W)     add (1|M0)               r13.0<1>:d    r3.1<0;1,0>:d     -r12.0<0;1,0>:d  {I@1}              //  ALU pipe: int; $529
(W)     cmp (1|M0)    (lt)f2.0   null<1>:ud    r13.0<0;1,0>:ud   r61.13<0;1,0>:ud {I@1}              //  ALU pipe: int; $530 R{} IR{}{O:6,O:6,},  {BC=1}
(W&~f2.0) sel (1|M0)             r4.0<1>:d     (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $531
(W)     add3 (1|M0)              r9.0<1>:d     r13.0<0;0>:d      r3.0<0;0>:d       -r4.0<0>:d       {I@1} //  ALU pipe: int; $532
(W)     xor (1|M0)               r14.2<1>:d    r9.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $533
// B028: [inDivergent],  Preds:{B027, B026},  Succs:{B029}
_0_165:
(W)     mov (1|M0)               r61.7<1>:d    r14.2<0;1,0>:d                   {I@1}                //  ALU pipe: int; $535

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     mov (1|M0)               r61.5<1>:d    0:w                                                   //  ALU pipe: int; $538

// Line 1408:  }
(W)     mov (1|M0)               r14.6<1>:hf   0x1:hf                                                //  ALU pipe: float; $543
(W)     mov (2|M0)               r16.0<1>:d    r61.7<1;1,0>:d                   {I@2}                //  ALU pipe: int; $541
(W)     mov (2|M0)               r14.0<1>:d    r61.5<1;1,0>:d                   {I@2}                //  ALU pipe: int; $542
// B029: [inDivergent],  Preds:{B028, B024},  Succs:{B030, B031}
_0_162:

// Line 1405:  if (expected_head_i >= 0) {
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r36.1<0;1,0>:d    -1:w                                //  ALU pipe: int; $563
(W)     mov (1|M0)               r2.0<2>:b     r14.6<0;1,0>:w                   {F@1}                //  ALU pipe: int; $546
(W)     mov (1|M0)               r14.2<1>:d    r2.0<0;1,0>:ub                   {I@1}                //  ALU pipe: int; $547
(W&f1.0) jmpi                                _0_166                                                  //  ALU pipe: int; $564
// B030: [inDivergent],  Preds:{B029},  Succs:{B035}
_0_167:
(W)     mov (2|M0)               r61.1<1>:d    r16.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $566
(W)     mov (2|M0)               r61.3<1>:d    r14.0<1;1,0>:d                                        //  ALU pipe: int; $567
(W)     mov (1|M0)               r61.9<1>:d    r14.2<0;1,0>:d                   {I@4}                //  ALU pipe: int; $568
(W)     jmpi                                 _0_168                                                  // $569
// B031: [inDivergent],  Preds:{B029},  Succs:{B032, B033}
_0_166:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f2.0<1>:ud    r102.3<0;1,0>:ud                 {Compacted}          //  ALU pipe: int; $572

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W&~f2.0) jmpi                               _0_169                                                  //  ALU pipe: int; $572
// B032: [inDivergent],  Preds:{B031},  Succs:{B034}
_0_170:
(W)     mov (1|M0)               r14.3<1>:d    -1:w                                                  //  ALU pipe: int; $574
(W)     jmpi                                 _0_171                                                  // $575
// B033: [inDivergent],  Preds:{B031},  Succs:{B034}
_0_169:
(W)     asr (1|M0)               r3.0<1>:d     r36.1<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $577
(W)     add (1|M0)               r2.0<1>:d     r3.0<0;1,0>:d     r36.1<0;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $578
(W)     xor (1|M0)               r3.1<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $579
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $580
(W)     mov (1|M0)               r4.0<1>:f     r61.13<0;1,0>:ud                 {A@1}                //  ALU pipe: float; $581
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $586
(W)     math.inv (1|M0)          r4.3<1>:f     r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $585
(W)     mov (1|M0)               r4.1<1>:f     r3.1<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $584
(W)     mad (1|M0)               r6.11<1>:f    r4.3<0;0>:f       r7.0<0;0>:f       r4.3<0>:f        {A@1} //  ALU pipe: float; $586
(W)     mov (1|M0)               r3.2<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $582
(W)     mov (1|M0)               r6.13<1>:ud   r4.1<0;1,0>:f                    {F@2}                //  ALU pipe: int; $588
(W)     mul (1|M0)               r6.12<1>:f    r4.1<0;1,0>:f     r6.11<0;1,0>:f   {F@1}              //  ALU pipe: float; $587
(W)     add (1|M0)               r4.8<1>:d     (abs)r6.10<0;1,0>:d  -r3.2<0;1,0>:d {I@2}             //  ALU pipe: int; $583
(W)     add (1|M0)               r4.9<1>:d     r3.1<0;1,0>:d     -r6.13<0;1,0>:d  {I@2}              //  ALU pipe: int; $589
(W)     mov (1|M0)               r2.0<1>:ud    r6.12<0;1,0>:f                   {F@1}                //  ALU pipe: int; $590
(W)     mov (1|M0)               r2.4<1>:f     r4.8<0;1,0>:ud                   {I@3}                //  ALU pipe: float; $591
(W)     mov (1|M0)               r2.5<1>:f     r4.9<0;1,0>:ud                   {I@2}                //  ALU pipe: float; $591
(W)     mov (1|M0)               r9.0<1>:f     r2.0<0;1,0>:ud                   {I@1}                //  ALU pipe: float; $593
(W)     mad (1|M0)               r2.1<1>:f     r4.1<0;0>:f       r9.0<0;0>:f       -r4.0<0>:f       {F@1} //  ALU pipe: float; $595
(W)     mad (1|M0)               r3.2<1>:f     r2.5<0;0>:f       r9.0<0;0>:f       -r2.4<0>:f        //  ALU pipe: float; $597
(W)     add (1|M0)               r8.0<1>:f     r2.1<0;1,0>:f     r3.2<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $598
(W)     mul (1|M0)               r10.0<1>:f    r6.11<0;1,0>:f    r8.0<0;1,0>:f    {Compacted,F@1}    //  ALU pipe: float; $599
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $600
(W)     mov (1|M0)               r7.0<1>:ud    r10.0<0;1,0>:f                   {A@1}                //  ALU pipe: int; $601
(W)     mov (1|M0)               r11.1<1>:d    (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $603
(W)     add (1|M0)               r11.0<1>:d    r7.0<0;1,0>:d     r2.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $602
(W)     mul (1|M0)               acc0.0<1>:d   r11.0<0;1,0>:d    r11.2<0;1,0>:uw  {I@1}              //  ALU pipe: int; $603
(W)     macl (1|M0)              r12.0<1>:d    r11.0<0;1,0>:d    r11.1<0;1,0>:d   {Compacted,$15.src} //  ALU pipe: int; $604
(W)     add (1|M0)               r13.0<1>:d    r3.1<0;1,0>:d     -r12.0<0;1,0>:d  {I@1}              //  ALU pipe: int; $604
(W)     cmp (1|M0)    (lt)f1.0   null<1>:ud    r13.0<0;1,0>:ud   r61.13<0;1,0>:ud {I@1}              //  ALU pipe: int; $605 R{} IR{}{O:6,O:6,},  {BC=1}
(W&~f1.0) sel (1|M0)             r4.0<1>:d     (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $606
(W)     add3 (1|M0)              r9.0<1>:d     r13.0<0;0>:d      r3.0<0;0>:d       -r4.0<0>:d       {I@1} //  ALU pipe: int; $607
(W)     xor (1|M0)               r14.3<1>:d    r9.0<0;1,0>:d     r3.0<0;1,0>:d    {I@1}              //  ALU pipe: int; $608
// B034: [inDivergent],  Preds:{B033, B032},  Succs:{B035}
_0_171:
(W)     mul (1|M0)               r2.0<1>:uw    r14.4<0;1,0>:uw   0x4:uw                              //  ALU pipe: int; $610

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     mul (1|M0)               r3.0<1>:uw    r14.4<0;1,0>:uw   0x4:uw                              //  ALU pipe: int; $618

// Line 1406:  slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
(W)     add (1|M0)               a0.0<1>:uw    r2.0<0;1,0>:uw    0x400:uw              {A@1}         //  ALU pipe: int; src1 is addr of V0387(r16.0:d); $611
(W)     mov (1|M0)               r[a0.0]<1>:d  r14.3<0;1,0>:d                                        //  ALU pipe: int; $612

// Line 1407:  topk_ranks[num_topk_ranks++] = i;
(W)     add (1|M0)               a0.0<1>:uw    r3.0<0;1,0>:uw    0x380:uw              {I@3}         //  ALU pipe: int; src1 is addr of V0388(r14.0:d); $619
(W)     mov (1|M0)               r[a0.0]<1>:d  1:w                                                   //  ALU pipe: int; $620
(W)     add (1|M0)               r61.9<1>:d    r14.2<0;1,0>:d    1:w                                 //  ALU pipe: int; $615

// Line 1408:  }
(W)     mov (2|M0)               r61.1<1>:d    r16.0<1;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $623
(W)     mov (2|M0)               r61.3<1>:d    r14.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $624
// B035: [inDivergent],  Preds:{B034, B030},  Succs:{B036, B051}
_0_168:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $629
        macl (16|M0)             r10.0<1>:ud   r32.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $629
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $629
        macl (16|M16)            r11.0<1>:ud   r33.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $630
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $630
        mach (16|M0)             r2.0<1>:d     r32.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $630
        mach (16|M16)            r3.0<1>:d     r33.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; $631
(W)     mul (16|M0)              acc0.0<1>:d   r32.0<1;1,0>:ud   r61.20<0;1,0>:uw                    //  ALU pipe: int; $631
        macl (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r61.10<0;1,0>:d                     //  ALU pipe: int; $631
(W)     mul (16|M16)             acc0.0<1>:d   r33.0<1;1,0>:ud   r61.20<0;1,0>:uw                    //  ALU pipe: int; $631
        macl (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r61.10<0;1,0>:d                     //  ALU pipe: int; $632
        add (32|M0)              r2.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $632
(W)     mul (16|M0)              acc0.0<1>:d   r61.0<0;1,0>:ud   r40.0<2;1,0>:uw                     //  ALU pipe: int; $633

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f1.0<1>:ud    r102.9<0;1,0>:ud                 {Compacted}          //  ALU pipe: int; $638

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        macl (16|M0)             r8.0<1>:d     r61.0<0;1,0>:ud   r40.0<1;1,0>:d                      //  ALU pipe: int; $633
(W)     mul (16|M16)             acc0.0<1>:d   r61.0<0;1,0>:ud   r41.0<2;1,0>:uw                     //  ALU pipe: int; $633
        macl (16|M16)            r9.0<1>:d     r61.0<0;1,0>:ud   r41.0<1;1,0>:d                      //  ALU pipe: int; $635
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $635

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
(~f1.0) goto (32|M0)                         _0_172            _0_172                                //  ALU pipe: int; $638
// B036: [inDivergent],  Preds:{B035},  Succs:{B037}
_0_173:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (32|M0)              r2.0<1>:d     r10.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $641

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     mul (1|M0)               acc0.0<1>:d   r61.1<0;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $659

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M0)              r10.0<2>:d    r2.0<1;1,0>:d                    {I@2}                //  ALU pipe: int; $643
        mov (16|M16)             r12.0<2>:d    r3.0<1;1,0>:d                    {$15.src}            //  ALU pipe: int; $644
        mov (16|M0)              r10.1<2>:d    r8.0<1;1,0>:d                                         //  ALU pipe: int; $645

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     macl (1|M0)              r2.0<1>:d     r61.1<0;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $660

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M16)             r12.1<2>:d    r9.0<1;1,0>:d                                         //  ALU pipe: int; $646

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     mul (1|M0)               acc0.0<1>:d   r61.2<0;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $666
(W)     macl (1|M0)              r3.0<1>:d     r61.2<0;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $668
(W)     cmp (32|M0)   (gt)f2.0   null<1>:d     r61.9<0;1,0>:d    0:w                                 //  ALU pipe: int; $653
(W)     cmp (32|M0)   (gt)f1.0   null<1>:d     r61.9<0;1,0>:d    1:w                                 //  ALU pipe: int; $660

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        mov (32|M0)              r34.0<1>:d    r38.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $672

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        shl (16|M0)              r14.0<1>:q    r10.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $647
        shl (16|M16)             r16.0<1>:q    r12.0<1;1,0>:q    4:w               {Compacted,I@7}   //  ALU pipe: int; $647

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
(W)     shl (1|M0)               r4.0<1>:q     r61.3<0;1,0>:d    4:w                                 //  ALU pipe: int; $656
(W)     shl (1|M0)               r2.1<1>:q     r61.4<0;1,0>:d    4:w                                 //  ALU pipe: int; $663
(W)     mov (1|M0)               r2.1<1>:d     r3.0<0;1,0>:d                    {Compacted,I@7}      //  ALU pipe: int; $668

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        add (16|M0)              r58.0<1>:q    r14.0<1;1,0>:q    r5.3<0;1,0>:q    {Compacted,I@5}    //  ALU pipe: int; $648

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        add (16|M0)              r54.0<1>:q    r14.0<1;1,0>:q    r5.4<0;1,0>:q    {Compacted}        //  ALU pipe: int; $650

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M0)              r50.0<1>:q    r14.0<1;1,0>:q    r4.3<0;1,0>:q    {Compacted}        //  ALU pipe: int; $652

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        add (16|M16)             r56.0<1>:q    r16.0<1;1,0>:q    r5.3<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $648

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        add (16|M16)             r52.0<1>:q    r16.0<1;1,0>:q    r5.4<0;1,0>:q    {Compacted}        //  ALU pipe: int; $650

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M16)             r46.0<1>:q    r16.0<1;1,0>:q    r4.3<0;1,0>:q    {Compacted}        //  ALU pipe: int; $652
(W)     shl (1|M0)               r4.4<1>:q     r2.0<0;1,0>:d     4:w                                 //  ALU pipe: int; $668
(W)     add (1|M0)               r6.0<1>:q     r102.0<0;1,0>:q   r4.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $657
(W)     shl (1|M0)               r4.5<1>:q     r2.1<0;1,0>:d     4:w               {I@7}             //  ALU pipe: int; $668
(W)     add (1|M0)               r4.0<1>:q     r102.0<0;1,0>:q   r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $664
// B037: [inDivergent],  Preds:{B050, B036},  Succs:{B038, B039}
_0_174:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r61.11<0;1,0>:ud                 {Compacted}          //  ALU pipe: int; $676

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1414:  int4 bias_0_value_int4 = (bias_0_int4 != nullptr)
(W&~f3.0) jmpi                               _0_175                                                  //  ALU pipe: int; $676
// B038: [inDivergent],  Preds:{B037},  Succs:{B040}
_0_176:
        mov (32|M0)              r95.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $678
        mov (32|M0)              r97.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $679
        mov (32|M0)              r92.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $680
        mov (32|M0)              r93.0<1>:w    0:w                                                   //  ALU pipe: int; $681
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted,$0.src}  //  ALU pipe: int; $682
(W)     jmpi                                 _0_177                                                  // $683
// B039: [inDivergent],  Preds:{B037},  Succs:{B040}
_0_175:

// Line 1415:  ? bias_0_int4[token_idx * hidden_int4 + i]
        mov (16|M0)              r2.0<2>:ud    r34.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $687
        mov (16|M16)             r10.0<2>:ud   r35.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $687
        shl (16|M0)              r7.0<1>:q     r2.0<2;1,0>:ud    4:w               {I@2}             //  ALU pipe: int; $687
        shl (16|M16)             r12.0<1>:q    r10.0<2;1,0>:ud   4:w               {@2,$0.src}       //  ALU pipe: int; $687
        add (16|M0)              r14.0<1>:q    r58.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $688
        add (16|M16)             r16.0<1>:q    r56.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $688
        load.ugm.d32x3.a64 (32|M0)  r18:6       [r14:4+0x4]        {I@1,$8} // ex_desc:0x4000; desc:0x8602580 // $691
        sync.nop                             null                             {Compacted,$1.src}     // $698
        shr (32|M0)              r24.0<1>:ud   r18.0<1;1,0>:ud   16:w               {$8.dst}         //  ALU pipe: int; $698
        shr (32|M0)              r26.0<1>:ud   r20.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $705
        mov (32|M0)              r28.0<1>:f    r22.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $694
        mov (32|M0)              r97.0<1>:w    r18.0<2;1,0>:w                   {F@3}                //  ALU pipe: int; $695
        mov (32|M0)              r93.0<1>:w    r20.0<2;1,0>:w                                        //  ALU pipe: int; $702
        mov (32|M0)              r95.0<1>:w    r24.0<2;1,0>:w                   {I@4}                //  ALU pipe: int; $699
        mov (32|M0)              r92.0<1>:w    r26.0<2;1,0>:w                   {A@2}                //  ALU pipe: int; $706
// B040: [inDivergent],  Preds:{B039, B038},  Succs:{B041, B042}
_0_177:

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
        mov (16|M0)              r2.0<2>:ud    r34.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $712
        mov (16|M16)             r8.0<2>:ud    r35.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $712
        mov (16|M0)              r48.0<1>:q    r2.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $712
        mov (16|M16)             r30.0<1>:q    r8.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $712

// Line 1417:  int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
(W&~f0.0) jmpi                               _0_178                                                  //  ALU pipe: int; $714
// B041: [inDivergent],  Preds:{B040},  Succs:{B043}
_0_179:
        mov (32|M0)              r98.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $718
        mov (32|M0)              r101.0<1>:hf  0x0:hf                                                //  ALU pipe: float; $719
        mov (32|M0)              r94.0<1>:hf   0x0:hf                                                //  ALU pipe: float; $720
        mov (32|M0)              r96.0<1>:w    0:w                                                   //  ALU pipe: int; $721
        mov (32|M0)              r26.0<1>:d    0:w                               {Compacted,$1.src}  //  ALU pipe: int; $722
(W)     jmpi                                 _0_180                                                  // $723
// B042: [inDivergent],  Preds:{B040},  Succs:{B043}
_0_178:

// Line 1418:  ? bias_1_int4[token_idx * hidden_int4 + i]
        shl (16|M0)              r2.0<1>:q     r48.0<1;1,0>:q    4:w               {Compacted,I@6}   //  ALU pipe: int; $726
        shl (16|M16)             r7.0<1>:q     r30.0<1;1,0>:q    4:w               {Compacted,I@6}   //  ALU pipe: int; $726
        add (16|M0)              r9.0<1>:q     r54.0<1;1,0>:q    r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $727
        add (16|M16)             r11.0<1>:q    r52.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $727
        load.ugm.d32x3.a64 (32|M0)  r14:6       [r9:4+0x4]         {I@1,$9} // ex_desc:0x4000; desc:0x8602580 // $730
        shr (32|M0)              r20.0<1>:ud   r14.0<1;1,0>:ud   16:w               {$9.dst}         //  ALU pipe: int; $737
        sync.nop                             null                             {Compacted,F@4}        // $744
        shr (32|M0)              r22.0<1>:ud   r16.0<1;1,0>:ud   16:w               {$1.src}         //  ALU pipe: int; $744
        mov (32|M0)              r26.0<1>:f    r18.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $733
        mov (32|M0)              r101.0<1>:w   r14.0<2;1,0>:w                   {F@3}                //  ALU pipe: int; $734
        mov (32|M0)              r96.0<1>:w    r16.0<2;1,0>:w                                        //  ALU pipe: int; $741
        mov (32|M0)              r98.0<1>:w    r20.0<2;1,0>:w                   {I@4}                //  ALU pipe: int; $738
        mov (32|M0)              r94.0<1>:w    r22.0<2;1,0>:w                   {A@2}                //  ALU pipe: int; $745
// B043: [inDivergent],  Preds:{B042, B041},  Succs:{B044, B046}
_0_180:

// Line 1423:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f2.0) jmpi                               _0_181                                                  //  ALU pipe: int; $751
// B044: [inDivergent],  Preds:{B043},  Succs:{B045, B046}
_0_182:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r2:1  [r6:1]             {$10} // ex_desc:0x0; desc:0x2188780 // $756

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
        shl (16|M0)              r24.0<1>:q    r48.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $760
        shl (16|M16)             r22.0<1>:q    r30.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $760
(W)     add (1|M0)               r3.0<1>:q     r4.4<0;1,0>:q     r2.0<0;1,0>:q    {Compacted,$10.dst} //  ALU pipe: int; $759
        add (16|M0)              r7.0<1>:q     r3.0<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@1}    //  ALU pipe: int; $761
        add (16|M16)             r9.0<1>:q     r3.0<0;1,0>:q     r22.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $761

// Line 1424:  recv_value_int4[j] = ld_nc_global(
        add (16|M0)              r11.0<1>:q    r7.0<1;1,0>:q     4:w               {Compacted,I@2}   //  ALU pipe: int; $763
        add (16|M16)             r13.0<1>:q    r9.0<1;1,0>:q     4:w               {Compacted,I@2}   //  ALU pipe: int; $763
        load.ugm.d32x2.a64 (32|M0)  r16:4       [r11:4]            {A@1,$11} // ex_desc:0x0; desc:0x8401580 // $765
        load.ugm.d32.a64 (32|M0)  r20:2         [r11:4+0x8]        {$12} // ex_desc:0x8000; desc:0x8200580 // $766
        mov (32|M0)              r68.0<1>:w    r16.0<2;1,0>:w                   {$11.dst}            //  ALU pipe: int; $767
        mov (32|M0)              r69.0<1>:w    r16.1<2;1,0>:w                                        //  ALU pipe: int; $768
        mov (32|M0)              r70.0<1>:w    r18.0<2;1,0>:w                                        //  ALU pipe: int; $769
        mov (32|M0)              r71.0<1>:w    r18.1<2;1,0>:w                                        //  ALU pipe: int; $770
        mov (32|M0)              r72.0<1>:w    r20.0<2;1,0>:w                   {$12.dst}            //  ALU pipe: int; $771
        mov (32|M0)              r73.0<1>:w    r20.1<2;1,0>:w                                        //  ALU pipe: int; $772

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
(W&~f1.0) jmpi                               _0_181                                                  //  ALU pipe: int; $781
// B045: [inDivergent],  Preds:{B044},  Succs:{B046}
_0_183:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r2:1  [r4:1]             {$6} // ex_desc:0x0; desc:0x2188780 // $786

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1425:  channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
(W)     add (1|M0)               r3.0<1>:q     r4.5<0;1,0>:q     r2.0<0;1,0>:q    {Compacted,$6.dst} //  ALU pipe: int; $789
        add (16|M0)              r7.0<1>:q     r3.0<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@1}    //  ALU pipe: int; $790
        add (16|M16)             r9.0<1>:q     r3.0<0;1,0>:q     r22.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $790

// Line 1424:  recv_value_int4[j] = ld_nc_global(
        add (16|M0)              r11.0<1>:q    r7.0<1;1,0>:q     4:w               {Compacted,I@2}   //  ALU pipe: int; $792
        add (16|M16)             r13.0<1>:q    r9.0<1;1,0>:q     4:w               {Compacted,I@2}   //  ALU pipe: int; $792
        load.ugm.d32x2.a64 (32|M0)  r16:4       [r11:4]            {I@1,$8} // ex_desc:0x0; desc:0x8401580 // $794
        load.ugm.d32.a64 (32|M0)  r20:2         [r11:4+0x8]        {$9} // ex_desc:0x8000; desc:0x8200580 // $795
        mov (32|M0)              r74.0<1>:w    r16.0<2;1,0>:w                   {$8.dst}             //  ALU pipe: int; $796
        mov (32|M0)              r75.0<1>:w    r16.1<2;1,0>:w                                        //  ALU pipe: int; $797
        mov (32|M0)              r76.0<1>:w    r18.0<2;1,0>:w                                        //  ALU pipe: int; $798
        mov (32|M0)              r77.0<1>:w    r18.1<2;1,0>:w                                        //  ALU pipe: int; $799
        mov (32|M0)              r78.0<1>:w    r20.0<2;1,0>:w                   {$9.dst}             //  ALU pipe: int; $800
        mov (32|M0)              r79.0<1>:w    r20.1<2;1,0>:w                                        //  ALU pipe: int; $801
// B046: [inDivergent],  Preds:{B045, B044, B043},  Succs:{B047, B049}
_0_181:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 202:  return __devicelib_ConvertBF16ToFINTEL(a);
        shr (32|M0)              r8.0<1>:ud    r28.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $870
        shr (32|M0)              r10.0<1>:ud   r26.0<1;1,0>:ud   16:w                                //  ALU pipe: int; $875
        mov (32|M0)              r2.0<1>:w     r28.0<2;1,0>:w                                        //  ALU pipe: int; $858
        mov (32|M0)              r3.0<1>:w     r26.0<2;1,0>:w                                        //  ALU pipe: int; $862
        mov (32|M0)              r7.0<1>:w     r8.0<2;1,0>:w                    {I@4}                //  ALU pipe: int; $871
        mov (32|M0)              r12.0<1>:w    r10.0<2;1,0>:w                   {I@4}                //  ALU pipe: int; $876

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1434:  values[j] = static_cast<float>(bias_0_values[j]) + static_cast<float>(bias_1_values[j]);
        add (16|M0)              r16.0<1>:f    r97.0<1;1,0>:bf   r101.0<1;1,0>:bf                    //  ALU pipe: float; $824
        add (16|M16)             r17.0<1>:f    r97.16<1;1,0>:bf  r101.16<1;1,0>:bf                   //  ALU pipe: float; $824
        add (16|M0)              r14.0<1>:f    r95.0<1;1,0>:bf   r98.0<1;1,0>:bf                     //  ALU pipe: float; $834
        add (16|M16)             r15.0<1>:f    r95.16<1;1,0>:bf  r98.16<1;1,0>:bf                    //  ALU pipe: float; $834
        add (16|M0)              r18.0<1>:f    r93.0<1;1,0>:bf   r96.0<1;1,0>:bf                     //  ALU pipe: float; $844
        add (16|M16)             r19.0<1>:f    r93.16<1;1,0>:bf  r96.16<1;1,0>:bf                    //  ALU pipe: float; $844
        add (16|M0)              r20.0<1>:f    r92.0<1;1,0>:bf   r94.0<1;1,0>:bf                     //  ALU pipe: float; $854
        add (16|M16)             r21.0<1>:f    r92.16<1;1,0>:bf  r94.16<1;1,0>:bf                    //  ALU pipe: float; $854
        add (16|M0)              r24.0<1>:f    r2.0<1;1,0>:bf    r3.0<1;1,0>:bf   {I@3}              //  ALU pipe: float; $866
        add (16|M16)             r25.0<1>:f    r2.16<1;1,0>:bf   r3.16<1;1,0>:bf                     //  ALU pipe: float; $866
        add (16|M0)              r26.0<1>:f    r7.0<1;1,0>:bf    r12.0<1;1,0>:bf  {I@1}              //  ALU pipe: float; $880
        add (16|M16)             r27.0<1>:f    r7.16<1;1,0>:bf   r12.16<1;1,0>:bf                    //  ALU pipe: float; $880

// Line 1438:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f2.0) jmpi                               _0_184                                                  //  ALU pipe: int; $883
// B047: [inDivergent],  Preds:{B046},  Succs:{B048, B049}
_0_185:

// Line 1441:  values[k] += static_cast<float>(recv_value_dtypes[k]);
        add (16|M0)              r16.0<1>:f    r16.0<1;1,0>:f    r68.0<1;1,0>:bf                     //  ALU pipe: float; $895
        add (16|M16)             r17.0<1>:f    r17.0<1;1,0>:f    r68.16<1;1,0>:bf                    //  ALU pipe: float; $895
        add (16|M0)              r14.0<1>:f    r14.0<1;1,0>:f    r69.0<1;1,0>:bf                     //  ALU pipe: float; $902
        add (16|M16)             r15.0<1>:f    r15.0<1;1,0>:f    r69.16<1;1,0>:bf                    //  ALU pipe: float; $902
        add (16|M0)              r18.0<1>:f    r18.0<1;1,0>:f    r70.0<1;1,0>:bf                     //  ALU pipe: float; $909
        add (16|M16)             r19.0<1>:f    r19.0<1;1,0>:f    r70.16<1;1,0>:bf                    //  ALU pipe: float; $909
        add (16|M0)              r20.0<1>:f    r20.0<1;1,0>:f    r71.0<1;1,0>:bf                     //  ALU pipe: float; $916
        add (16|M16)             r21.0<1>:f    r21.0<1;1,0>:f    r71.16<1;1,0>:bf                    //  ALU pipe: float; $916
        add (16|M0)              r24.0<1>:f    r24.0<1;1,0>:f    r72.0<1;1,0>:bf                     //  ALU pipe: float; $923 R{} IR{}{E:4,E:4,},  {BC=1}
        add (16|M16)             r25.0<1>:f    r25.0<1;1,0>:f    r72.16<1;1,0>:bf                    //  ALU pipe: float; $923
        add (16|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r73.0<1;1,0>:bf                     //  ALU pipe: float; $930
        add (16|M16)             r27.0<1>:f    r27.0<1;1,0>:f    r73.16<1;1,0>:bf                    //  ALU pipe: float; $930

// Line 1438:  for (int j = 0; j < num_topk_ranks; ++j) {
(W&~f1.0) jmpi                               _0_184                                                  //  ALU pipe: int; $933
// B048: [inDivergent],  Preds:{B047},  Succs:{B049}
_0_186:

// Line 1441:  values[k] += static_cast<float>(recv_value_dtypes[k]);
        add (16|M0)              r16.0<1>:f    r16.0<1;1,0>:f    r74.0<1;1,0>:bf                     //  ALU pipe: float; $945
        add (16|M16)             r17.0<1>:f    r17.0<1;1,0>:f    r74.16<1;1,0>:bf                    //  ALU pipe: float; $945
        add (16|M0)              r14.0<1>:f    r14.0<1;1,0>:f    r75.0<1;1,0>:bf                     //  ALU pipe: float; $952
        add (16|M16)             r15.0<1>:f    r15.0<1;1,0>:f    r75.16<1;1,0>:bf                    //  ALU pipe: float; $952
        add (16|M0)              r18.0<1>:f    r18.0<1;1,0>:f    r76.0<1;1,0>:bf                     //  ALU pipe: float; $959
        add (16|M16)             r19.0<1>:f    r19.0<1;1,0>:f    r76.16<1;1,0>:bf                    //  ALU pipe: float; $959
        add (16|M0)              r20.0<1>:f    r20.0<1;1,0>:f    r77.0<1;1,0>:bf                     //  ALU pipe: float; $966
        add (16|M16)             r21.0<1>:f    r21.0<1;1,0>:f    r77.16<1;1,0>:bf                    //  ALU pipe: float; $966
        add (16|M0)              r24.0<1>:f    r24.0<1;1,0>:f    r78.0<1;1,0>:bf                     //  ALU pipe: float; $973
        add (16|M16)             r25.0<1>:f    r25.0<1;1,0>:f    r78.16<1;1,0>:bf                    //  ALU pipe: float; $973
        add (16|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r79.0<1;1,0>:bf                     //  ALU pipe: float; $980
        add (16|M16)             r27.0<1>:f    r27.0<1;1,0>:f    r79.16<1;1,0>:bf                    //  ALU pipe: float; $980
// B049: [inDivergent],  Preds:{B048, B047, B046},  Succs:{B050, B051}
_0_184:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r3.0<1>:bf    r14.0<1;1,0>:f                   {F@7}                //  ALU pipe: float; $994
        mov (16|M16)             r3.16<1>:bf   r15.0<1;1,0>:f                   {F@7}                //  ALU pipe: float; $994

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        mov (32|M0)              r8.0<1>:d     r3.0<1;1,0>:uw                   {F@1}                //  ALU pipe: int; $997

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M16)             r7.16<1>:bf   r19.0<1;1,0>:f                                        //  ALU pipe: float; $1004

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        shl (32|M0)              r10.0<1>:d    r8.0<1;1,0>:d     16:w               {Compacted,I@1}  //  ALU pipe: int; $998

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r19.0<1>:bf   r24.0<1;1,0>:f                                        //  ALU pipe: float; $1019
        mov (16|M0)              r24.0<1>:bf   r26.0<1;1,0>:f                                        //  ALU pipe: float; $1024
        mov (16|M16)             r24.16<1>:bf  r27.0<1;1,0>:f                                        //  ALU pipe: float; $1024
        mov (16|M0)              r2.0<1>:bf    r16.0<1;1,0>:f                                        //  ALU pipe: float; $989
        mov (16|M16)             r2.16<1>:bf   r17.0<1;1,0>:f                                        //  ALU pipe: float; $989

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        mov (32|M0)              r8.0<1>:d     r24.0<1;1,0>:uw                  {F@3}                //  ALU pipe: int; $1027
        or (32|M0)               r12.0<1>:d    r10.0<1;1,0>:d    r2.0<1;1,0>:uw   {A@1}              //  ALU pipe: int; $1000
        shl (32|M0)              r2.0<1>:d     r8.0<1;1,0>:d     16:w               {Compacted,I@2}  //  ALU pipe: int; $1028

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/ext/oneapi/bfloat16.hpp

// Line 253:  return __devicelib_ConvertFToBF16INTEL(a);
        mov (16|M0)              r7.0<1>:bf    r18.0<1;1,0>:f                                        //  ALU pipe: float; $1004
        mov (16|M16)             r19.16<1>:bf  r25.0<1;1,0>:f                                        //  ALU pipe: float; $1019
        mov (16|M0)              r18.0<1>:bf   r20.0<1;1,0>:f                                        //  ALU pipe: float; $1009
        mov (16|M16)             r18.16<1>:bf  r21.0<1;1,0>:f                                        //  ALU pipe: float; $1009

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        or (32|M0)               r16.0<1>:d    r2.0<1;1,0>:d     r19.0<1;1,0>:uw  {A@1}              //  ALU pipe: int; $1030
        mov (32|M0)              r20.0<1>:d    r18.0<1;1,0>:uw                  {F@1}                //  ALU pipe: int; $1012

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        add (32|M0)              r2.0<1>:d     r34.0<1;1,0>:d    32:w               {Compacted}      //  ALU pipe: int; $1037

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        shl (32|M0)              r22.0<1>:d    r20.0<1;1,0>:d    16:w               {Compacted,I@2}  //  ALU pipe: int; $1013

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        shl (16|M0)              r10.0<1>:q    r48.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $1033
        shl (16|M16)             r25.0<1>:q    r30.0<1;1,0>:q    4:w               {Compacted}       //  ALU pipe: int; $1033

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
        cmp (32|M0)   (lt)f3.0   null<1>:d     r2.0<1;1,0>:d     r61.0<0;1,0>:d   {I@4}              //  ALU pipe: int; $1040

// Line 1449:  out_dtypes[j] = static_cast<dtype_t>(values[j]);
        or (32|M0)               r14.0<1>:d    r22.0<1;1,0>:d    r7.0<1;1,0>:uw   {I@4}              //  ALU pipe: int; $1015

// Line 1453:  recv_int4[token_idx * hidden_int4 + i] = out_int4;
        add (16|M0)              r27.0<1>:q    r50.0<1;1,0>:q    r10.0<1;1,0>:q   {Compacted,I@4}    //  ALU pipe: int; $1034
        add (16|M16)             r29.0<1>:q    r46.0<1;1,0>:q    r25.0<1;1,0>:q   {Compacted,I@4}    //  ALU pipe: int; $1034
        store.ugm.d32x3.a64 (32|M0)  [r27:4+0x4] r12:6             {I@1,$0} // ex_desc:0x4000; desc:0x8002584 // $1035

// Line 1412:  for (int i = lane_id; i < hidden_int4; i += 32) {
(~f3.0) goto (32|M0)                         _0_172            _0_172                                //  ALU pipe: int; $1041
// B050: [inDivergent],  Preds:{B049},  Succs:{B037}
_0_187:
        mov (32|M0)              r34.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1043
(W)     jmpi                                 _0_174                                                  // $1044
// B051: [inDivergent],  Preds:{B049, B035},  Succs:{B052, B057}
_0_172:
        join (32|M0)                         _0_149                                                  // 
L8544:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f3.0<1>:ud    r102.10<0;1,0>:ud                {Compacted}          //  ALU pipe: int; $1048

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1492:  if (lane_id < num_topk_) {
(~f3.0) goto (32|M0)                         _0_188            _0_188                                //  ALU pipe: int; $1048
// B052: [inDivergent],  Preds:{B051},  Succs:{B053, B054}
_0_189:

// Line 1494:  for (int i = 0; i < num_topk_ranks; ++i) {
(W)     cmp (32|M0)   (gt)f3.0   null<1>:d     r61.9<0;1,0>:d    0:w                                 //  ALU pipe: int; $1052
(W&f3.0) jmpi                                _0_190                                                  //  ALU pipe: int; $1053
// B053: [inDivergent],  Preds:{B052},  Succs:{B056}
_0_191:
        sync.nop                             null                             {Compacted,$1.src}     // $1055
        mov (32|M0)              r26.0<1>:ud   0x0:ud                              {Compacted,$0.src} //  ALU pipe: int; $1055
(W)     jmpi                                 _0_192                                                  // $1056
// B054: [inDivergent],  Preds:{B052},  Succs:{B055, B056}
_0_190:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     shl (1|M0)               r2.0<1>:q     r61.3<0;1,0>:d    4:w               {F@1}             //  ALU pipe: int; $1068

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     mul (1|M0)               acc0.0<1>:d   r61.1<0;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1074

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     add (1|M0)               r4.0<1>:q     r61.7<0;1,0>:q    r2.0<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1069

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W)     macl (1|M0)              r3.0<1>:d     r61.1<0;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1076

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r7:1  [r4:1]             {I@2,$10} // ex_desc:0x0; desc:0x2188780 // $1070

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     shl (1|M0)               r4.4<1>:q     r3.0<0;1,0>:d     2:w               {@1,$10.src}      //  ALU pipe: int; $1079

// Line 1494:  for (int i = 0; i < num_topk_ranks; ++i) {
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r61.9<0;1,0>:d    1:w                                 //  ALU pipe: int; $1089

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
        add (16|M0)              r8.0<1>:q     r66.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted,$10.dst} //  ALU pipe: int; $1076
        add (16|M16)             r10.0<1>:q    r64.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1076

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
        sync.nop                             null                             {Compacted,$15.src}    // $1080
        add (16|M0)              r12.0<1>:q    r8.0<1;1,0>:q     r4.4<0;1,0>:q    {Compacted,@2,$0.src} //  ALU pipe: int; $1080
        add (16|M16)             r14.0<1>:q    r10.0<1;1,0>:q    r4.4<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1080

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r26:2         [r12:4]            {I@1,$11} // ex_desc:0x0; desc:0x8200580 // $1085

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W&f2.0) jmpi                                _0_192                                                  //  ALU pipe: int; $1091
// B055: [inDivergent],  Preds:{B054},  Succs:{B056}
_0_193:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     shl (1|M0)               r2.0<1>:q     r61.4<0;1,0>:d    4:w                                 //  ALU pipe: int; $1101

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     mul (1|M0)               acc0.0<1>:d   r61.2<0;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1107

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     add (1|M0)               r4.0<1>:q     r61.7<0;1,0>:q    r2.0<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1102

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
(W)     macl (1|M0)              r3.0<1>:d     r61.2<0;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1109

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 39:  dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }
(W)     load.ugm.d64x1t.a64.ca.ca (1|M0)  r7:1  [r4:1]             {I@2,$12} // ex_desc:0x0; desc:0x2188780 // $1103

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
(W)     shl (1|M0)               r4.4<1>:q     r3.0<0;1,0>:d     2:w               {@1,$12.src}      //  ALU pipe: int; $1112

// Line 1496:  channel_topk_weights_buffers[topk_ranks[i]].buffer() +
        add (16|M0)              r8.0<1>:q     r66.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted,$12.dst} //  ALU pipe: int; $1109
        add (16|M16)             r10.0<1>:q    r64.0<1;1,0>:q    r7.0<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1109

// Line 1497:  slot_indices[i] * num_topk_ + lane_id);
        add (16|M0)              r12.0<1>:q    r8.0<1;1,0>:q     r4.4<0;1,0>:q    {Compacted,@2,$11.src} //  ALU pipe: int; $1113
        add (16|M16)             r14.0<1>:q    r10.0<1;1,0>:q    r4.4<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1113

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 202:  return *ptr;  // SYCL编译器会自动优化
        load.ugm.d32.a64 (32|M0)  r16:2         [r12:4]            {I@1,$6} // ex_desc:0x0; desc:0x8200580 // $1118

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1495:  value += ld_nc_global(
        sync.nop                             null                             {Compacted,$6.dst}     // $1121
        sync.nop                             null                             {Compacted,$1.src}     // $1121
        add (32|M0)              r26.0<1>:f    r26.0<1;1,0>:f    r16.0<1;1,0>:f   {Compacted,$11.dst} //  ALU pipe: float; $1121
// B056: [inDivergent],  Preds:{B055, B054, B053},  Succs:{B057}
_0_192:

// Line 1499:  recv_topk_weights_[token_idx * num_topk_ + lane_id] = value;
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1126
        macl (16|M0)             r2.0<1>:ud    r32.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1126
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1126
        macl (16|M16)            r3.0<1>:ud    r33.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1127
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1127
        mach (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1127
        mach (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; $1128
(W)     mul (16|M0)              acc0.0<1>:d   r32.0<1;1,0>:ud   r61.24<0;1,0>:uw                    //  ALU pipe: int; $1128
        macl (16|M0)             r10.0<1>:d    r32.0<1;1,0>:ud   r61.12<0;1,0>:d                     //  ALU pipe: int; $1128
(W)     mul (16|M16)             acc0.0<1>:d   r33.0<1;1,0>:ud   r61.24<0;1,0>:uw                    //  ALU pipe: int; $1128
        macl (16|M16)            r11.0<1>:d    r33.0<1;1,0>:ud   r61.12<0;1,0>:d                     //  ALU pipe: int; $1129
        add (32|M0)              r8.0<1>:d     r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1129
(W)     mul (16|M0)              acc0.0<1>:d   r6.6<0;1,0>:ud    r40.0<2;1,0>:uw                     //  ALU pipe: int; $1130
        macl (16|M0)             r10.0<1>:d    r6.6<0;1,0>:ud    r40.0<1;1,0>:d                      //  ALU pipe: int; $1130
(W)     mul (16|M16)             acc0.0<1>:d   r6.6<0;1,0>:ud    r41.0<2;1,0>:uw                     //  ALU pipe: int; $1130
        macl (16|M16)            r11.0<1>:d    r6.6<0;1,0>:ud    r41.0<1;1,0>:d                      //  ALU pipe: int; $1132
        sync.nop                             null                             {Compacted,$15.src}    // $1132
        add (32|M0)              r12.0<1>:d    r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,@1,$11.src} //  ALU pipe: int; $1132
        mov (16|M0)              r14.0<2>:d    r2.0<1;1,0>:d                                         //  ALU pipe: int; $1135
        mov (16|M16)             r16.0<2>:d    r3.0<1;1,0>:d                    {F@1}                //  ALU pipe: int; $1136
        mov (16|M0)              r14.1<2>:d    r12.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $1137
        mov (16|M16)             r16.1<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1138
        shl (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1139
        shl (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1139
        add (16|M0)              r22.0<1>:q    r84.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,@2,$1.src} //  ALU pipe: int; $1140
        add (16|M16)             r24.0<1>:q    r82.0<1;1,0>:q    r20.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1140
        sync.nop                             null                             {Compacted,$11.dst}    // $1141
        store.ugm.d32.a64 (32|M0)  [r22:4]      r26:2              {I@1,$1} // ex_desc:0x0; desc:0x8000584 // $1141
// B057: [inDivergent],  Preds:{B056, B051},  Succs:{B058, B059}
_0_188:
        join (32|M0)                         _0_149                                                  // 
L9352:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r38.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $1145

// Line 1503:  if (lane_id < kNumRanks) {
(~f1.0) goto (32|M0)                         _0_194            _0_194                                //  ALU pipe: int; $1147
// B058: [inDivergent],  Preds:{B057},  Succs:{B059}
_0_195:

// Line 1505:  (expected_head < 0) ? -expected_head - 1 : expected_head + 1;
        cmp (32|M0)   (lt)f3.0   r10.0<1>:d    r36.0<1;1,0>:d    0:w                                 //  ALU pipe: int; $1152
        add (32|M0)              r8.0<1>:d     r36.0<1;1,0>:d    1:w               {Compacted}       //  ALU pipe: int; $1151
        not (32|M0)              r2.0<1>:d     r36.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1150
        sync.nop                             null                             {Compacted,$15.src}    // $1153
        bfn.(s0&s1|~s0&s2) (32|M0)   r12.0<1>:ud  r10.0<1;0>:ud  r2.0<1;0>:ud      r8.0<1>:ud       {@1,$0.src} //  ALU pipe: int; $1153 R{} IR{}{E:5,E:1,E:4,},  R{} IR{}{O:5,O:1,O:4,},  {BC=2}

// Line 1504:  warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] =
        store.slm.d32.a32 (32|M0)  [r90:2]      r12:2              {I@1,$15} // ex_desc:0x0; desc:0x4000504 // $1155
// B059: [inDivergent],  Preds:{B058, B057},  Succs:{B060, B061}
_0_194:
        join (32|M0)                         _0_149                                                  // 
L9472:

// Line 1371:  token_idx += num_recv_warps - 1) {
        add (16|M0)              r44.0<1>:q    r44.0<1;1,0>:q    1:w               {Compacted}       //  ALU pipe: int; $1159
        add (16|M16)             r42.0<1>:q    r42.0<1;1,0>:q    1:w               {Compacted}       //  ALU pipe: int; $1159
        mov (16|M0)              r2.0<1>:d     r44.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1161
        mov (16|M16)             r3.0<1>:d     r42.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1162

// Line 1370:  token_idx < token_end_idx;
        cmp (32|M0)   (lt)f1.0   null<1>:ud    r2.0<1;1,0>:ud    r102.7<0;1,0>:ud {I@1}              //  ALU pipe: int; $1166
        mov (16|M0)              r8.0<1>:d     r44.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1163
        mov (16|M16)             r9.0<1>:d     r42.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1164
(f1.0)  cmp (32|M0)   (eq)f1.0   null<1>:d     r8.0<1;1,0>:d     r102.6<0;1,0>:d  {I@1}              //  ALU pipe: int; $1167
(~f1.0) cmp (32|M0)   (lt)f1.0   null<1>:d     r8.0<1;1,0>:d     r102.6<0;1,0>:d                     //  ALU pipe: int; $1169

// Line 1369:  for (int64_t token_idx = token_start_idx + recv_warp_id - 1;
(~f1.0) goto (32|M0)                         _0_149            _0_149                                //  ALU pipe: int; $1172
// B060: [inDivergent],  Preds:{B059},  Succs:{B015}
_0_196:
(W)     mov (2|M0)               r61.7<1>:d    r61.1<1;1,0>:d                                        //  ALU pipe: int; $1174
(W)     mov (2|M0)               r61.5<1>:d    r61.3<1;1,0>:d                                        //  ALU pipe: int; $1175
(W)     jmpi                                 _0_151                                                  // $1176
// B061: [inDivergent],  Preds:{B059, B013},  Succs:{B062, B063}
_0_149:
        join (32|M0)                         _0_144                                                  // 
L9648:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     mov (8|M0)               r2.0<1>:w     0x76543210:v                                          //  ALU pipe: int; $1187
(W)     add (8|M0)               r2.8<1>:w     r2.0<1;1,0>:w     8:w               {I@1}             //  ALU pipe: int; $1188
(W)     add (16|M0)              r2.16<1>:w    r2.0<1;1,0>:w     16:w               {I@1}            //  ALU pipe: int; $1189

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (eq)f1.0   null<2>:w     r2.0<1;1,0>:w     0:w               {I@1}             //  ALU pipe: int; $1192

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1511:  if (elect_one_sync(item)) {
(~f1.0) goto (32|M0)                         _0_197            _0_197                                //  ALU pipe: int; $1195
// B062: [inDivergent],  Preds:{B061},  Succs:{B063}
_0_198:

// Line 1512:  warp_retired[recv_warp_id] = 1;  // true
        shl (32|M0)              r2.0<1>:d     r80.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $1200
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r4.4<0;1,0>:d    {Compacted,@1,$2.src} //  ALU pipe: int; $1201
        mov (32|M0)              r10.0<1>:d    1:w                               {Compacted}         //  ALU pipe: int; $1202
        store.slm.d32.a32 (32|M0)  [r8:2]       r10:2              {I@1,$8} // ex_desc:0x0; desc:0x4000504 // $1203
// B063: [inDivergent],  Preds:{B062, B061},  Succs:{B106}
_0_197:
        join (32|M0)                         _0_144                                                  // 
L9784:

// Line 1514:  }
        goto (32|M0)                         _0_144            _0_199                                // $1207
// B064: [inDivergent],  Preds:{B009},  Succs:{B065, B106}
_0_144:
        join (32|M0)                         _0_199                                                  // 
L9816:

// Line 1288:  if (lane_id < kNumRanks) {
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r38.0<1;1,0>:ud   0x2:uw                              //  ALU pipe: int; $1211

// Line 1304:  while (lane_id < kNumRanks) {
(~f0.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1213
// B065: [inDivergent],  Preds:{B064},  Succs:{B066}
_0_200:

// Line 1299:  int* channel_head_idx_ptr = static_cast<int*>(buffer_ptrs_[rank_]) + responsible_channel * kNumRanks + lane_id;
(W)     shl (1|M0)               r2.0<1>:q     r6.7<0;1,0>:d     3:w                                 //  ALU pipe: int; $1217
(W)     and (1|M0)               r3.2<1>:d     r60.1<0;1,0>:d    2147483646:d               {$7.src} //  ALU pipe: int; $1220
(W)     add (1|M0)               r4.0<1>:q     r2.0<0;1,0>:q     r6.1<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1218
(W)     shl (1|M0)               r6.6<1>:q     r3.2<0;1,0>:ud    2:w               {I@2}             //  ALU pipe: int; $1222
(W)     load.ugm.d64x1t.a64 (1|M0)  r3:1        [r4:1]             {I@1,$9} // ex_desc:0x0; desc:0x2108780 // $1219
        sync.allrd                           ($2,$5,$8)                                              // $1224
        shl (16|M0)              r8.0<1>:q     r44.0<1;1,0>:q    2:w               {Compacted,$3.src} //  ALU pipe: int; $1224
        shl (16|M16)             r10.0<1>:q    r99.0<1;1,0>:q    2:w               {Compacted,$4.src} //  ALU pipe: int; $1224

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
        sync.allrd                           ($0,$15)                                                // $1228
(W)     and (1|M0)               r12.0<1>:d    r102.4<0;1,0>:d   -2:w               {Compacted,$14.src} //  ALU pipe: int; $1228

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        shl (32|M0)              r18.0<1>:d    r32.0<1;1,0>:d    2:w               {Compacted}       //  ALU pipe: int; $1240

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
(W)     shl (1|M0)               r13.0<1>:q    r12.0<0;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1230

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        add (32|M0)              r20.0<1>:d    r18.0<1;1,0>:d    r4.2<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1241

// Line 1308:  if (warp_retired[i] == 0) {
(W)     add (1|M0)               r6.0<1>:d     r4.4<0;1,0>:d     4:w               {Compacted}       //  ALU pipe: int; $1236

// Line 1299:  int* channel_head_idx_ptr = static_cast<int*>(buffer_ptrs_[rank_]) + responsible_channel * kNumRanks + lane_id;
(W)     add (1|M0)               r7.0<1>:q     r6.6<0;1,0>:q     r3.0<0;1,0>:q    {Compacted,$9.dst} //  ALU pipe: int; $1223
        add (16|M0)              r14.0<1>:q    r7.0<0;1,0>:q     r8.0<1;1,0>:q    {Compacted,@1,$13.src} //  ALU pipe: int; $1225
        add (16|M16)             r16.0<1>:q    r7.0<0;1,0>:q     r10.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1225

// Line 1301:  int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
        add (16|M0)              r7.0<1>:q     r14.0<1;1,0>:q    r13.0<0;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1231
        add (16|M16)             r9.0<1>:q     r16.0<1;1,0>:q    r13.0<0;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1231

// Line 1308:  if (warp_retired[i] == 0) {
        mov (32|M0)              r12.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1243
// B066: [inDivergent],  Preds:{B073, B065},  Succs:{B067, B106}
_0_201:
        sync.allrd                           ($11,$12)                                               // $1247
(W)     load.slm.d32x1t.a32 (1|M0)  r2:1        [r6:1]             {$10} // ex_desc:0x0; desc:0x2108500 // $1247
(W)     cmp (32|M0)   (eq)f0.0   null<1>:d     r2.0<0;1,0>:d     0:w               {$10.dst}         //  ALU pipe: int; $1248
(~f0.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1249
// B067: [inDivergent],  Preds:{B066},  Succs:{B068, B069}
_0_202:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 216:  asm volatile (
        load.ugm.d32.a64.uc.uc (32|M0)  r2:2    [r7:4]             {I@2,$2} // ex_desc:0x0; desc:0x8220580 // $1254

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1316:  channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
        sync.nop                             null                             {Compacted,$2.dst}     // $1258
        store.slm.d32.a32 (32|M0)  [r20:2]      r2:2               {$11} // ex_desc:0x0; desc:0x4000504 // $1258

// Line 1321:  if (warp_retired[i] == 0) {
(W)     load.slm.d32x1t.a32 (1|M0)  r4:1        [r6:1]             {$3} // ex_desc:0x0; desc:0x2108500 // $1261
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r4.0<0;1,0>:d     0:w               {$3.dst}          //  ALU pipe: int; $1262
(W&f3.0) jmpi                                _0_203                                                  //  ALU pipe: int; $1263
// B068: [inDivergent],  Preds:{B067},  Succs:{B070}
_0_204:
        mov (32|M0)              r2.0<1>:f     0x7FFFFFFF:f                               {$11.src}  //  (0x7fffffff:f); ALU pipe: float; $1265
(W)     jmpi                                 _0_205                                                  // $1266
// B069: [inDivergent],  Preds:{B067},  Succs:{B070}
_0_203:

// Line 1322:  int warp_head = warp_channel_head_idx[i * kNumRanks + lane_id];
        load.slm.d32.a32 (32|M0)  r2:2          [r18:2+0x8]        {F@1,$4} // ex_desc:0x8000; desc:0x4200500 // $1269
// B070: [inDivergent],  Preds:{B069, B068},  Succs:{B071, B072}
_0_205:
        cmp (32|M0)   (gt)f2.0   null<1>:d     r2.0<1;1,0>:d     r12.0<1;1,0>:d   {$4.dst}           //  ALU pipe: int; $1275

// Line 1330:  if (min_head != std::numeric_limits<int>::max() && min_head > last_head) {
(f2.0)  cmp (32|M0)   (ne)f2.0   null<1>:d     r2.0<1;1,0>:d     2147483647:d                        //  ALU pipe: int; $1277
(f2.0)  goto (32|M0)                         _0_206            _0_206                                //  ALU pipe: int; $1279
// B071: [inDivergent],  Preds:{B070},  Succs:{B073}
_0_207:
        sync.nop                             null                             {Compacted,I@2}        // $1281
        mov (32|M0)              r2.0<1>:f     r12.0<1;1,0>:f                   {Compacted,$11.src}  //  ALU pipe: float; $1281
        goto (32|M0)                         _0_206            _0_208                                // $1282
// B072: [inDivergent],  Preds:{B070},  Succs:{B073}
_0_206:
        join (32|M0)                         _0_208                                                  // 
L10360:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 234:  asm volatile (
        store.ugm.d32.a64.uc.uc (32|M0)  [r14:4] r2:2              {F@1,$12} // ex_desc:0x0; desc:0x8020584 // $1287
// B073: [inDivergent],  Preds:{B072, B071},  Succs:{B066}
_0_208:
        join (32|M0)                         _0_199                                                  // 
L10392:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp
        mov (32|M0)              r12.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1293
(W)     jmpi                                 _0_201                                                  // $1294
// B074: [inDivergent],  Preds:{B002},  Succs:{B075, B076}
_0_136:

// Line 1165:  const int send_rank_id = (responsible_channel + send_warp_id) % kNumRanks;
        add (32|M0)              r2.0<1>:d     r102.8<0;1,0>:d   r80.0<1;1,0>:d   {Compacted,F@1}    //  ALU pipe: int; $1301
        and (32|M0)   (eq)f1.0   r18.0<1>:d    r2.0<1;1,0>:d     1:w               {I@1}             //  ALU pipe: int; $1302

// Line 1170:  auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[send_rank_id]));
        shl (32|M0)              r8.0<1>:d     r18.0<1;1,0>:d    3:w               {Compacted,I@1}   //  ALU pipe: int; $1305
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1307
        mov (16|M16)             r16.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1307
        add (16|M0)              r12.0<1>:q    r6.1<0;1,0>:q     r10.0<2;1,0>:ud  {I@2}              //  ALU pipe: int; $1307
        add (16|M16)             r14.0<1>:q    r6.1<0;1,0>:q     r16.0<2;1,0>:ud  {I@2}              //  ALU pipe: int; $1307
        load.ugm.d64.a64 (32|M0)  r24:4         [r12:4]            {I@1,$5} // ex_desc:0x0; desc:0x8400780 // $1308

// Line 1171:  auto num_channels_total = num_channels * kNumRanks;
(W)     and (1|M0)               r61.4<1>:d    r102.4<0;1,0>:d   -2:w                                //  ALU pipe: int; $1311

// Line 1172:  auto channel_rank_offset = responsible_channel * kNumRanks + rank_;  // 写入时用自己的rank标识来源
(W)     add (1|M0)               r61.5<1>:d    r60.1<0;1,0>:d    r6.7<0;1,0>:d                       //  ALU pipe: int; $1314

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     asr (1|M0)               r4.3<1>:d     r6.10<0;1,0>:d    31:w                                //  ALU pipe: int; $1323
(W)     mul (1|M0)               acc0.0<1>:ud  r61.4<0;1,0>:ud   r6.20<0;1,0>:uw  {I@3}              //  ALU pipe: int; $1324
(W)     macl (1|M0)              r40.0<1>:ud   r61.4<0;1,0>:ud   r6.10<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1325
(W)     mul (1|M0)               acc0.0<1>:ud  r61.4<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1325

// Line 1180:  auto channel_head_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
(W)     asr (2|M0)               r4.0<1>:d     r61.4<1;1,0>:d    31:w               {Compacted,I@5}  //  ALU pipe: int; $1317
(W)     mach (1|M0)              r2.0<1>:d     r61.4<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; 

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mul (1|M0)               acc0.0<1>:d   r61.4<0;1,0>:ud   r4.6<0;1,0>:uw   {I@6}              //  ALU pipe: int; $1326
(W)     macl (1|M0)              r3.0<1>:d     r61.4<0;1,0>:ud   r4.3<0;1,0>:d                       //  ALU pipe: int; $1327
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r4.0<0;1,0>:uw   {I@4}              //  ALU pipe: int; $1328
(W)     asr (1|M0)               r61.1<1>:d    r61.0<0;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $1331
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@3}    //  ALU pipe: int; $1327
(W)     macl (1|M0)              r3.0<1>:d     r6.10<0;1,0>:ud   r4.0<0;1,0>:d                       //  ALU pipe: int; $1330
(W)     mul (1|M0)               acc0.0<1>:ud  r40.0<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1332
(W)     macl (1|M0)              r42.0<1>:ud   r40.0<0;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1333
(W)     mul (1|M0)               acc0.0<1>:ud  r40.0<0;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1333
(W)     add (1|M0)               r40.2<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@4}    //  ALU pipe: int; $1330
(W)     mach (1|M0)              r7.0<1>:d     r40.0<0;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r40.0<0;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1334
(W)     macl (1|M0)              r8.0<1>:d     r40.0<0;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1335
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r40.4<0;1,0>:uw  {I@4}              //  ALU pipe: int; $1336
(W)     add (1|M0)               r7.0<1>:d     r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1335
(W)     macl (1|M0)              r8.0<1>:d     r61.0<0;1,0>:ud   r40.2<0;1,0>:d                      //  ALU pipe: int; $1338

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     mul (1|M0)               acc0.0<1>:ud  r61.5<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1340
(W)     macl (1|M0)              r102.0<1>:ud  r61.5<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; $1341
(W)     mul (1|M0)               acc0.0<1>:ud  r61.5<0;1,0>:ud   r6.20<0;1,0>:uw                     //  ALU pipe: int; $1341
(W)     mach (1|M0)              r2.0<1>:d     r61.5<0;1,0>:ud   r6.10<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r61.5<0;1,0>:ud   r4.6<0;1,0>:uw                      //  ALU pipe: int; $1342
(W)     macl (1|M0)              r3.0<1>:d     r61.5<0;1,0>:ud   r4.3<0;1,0>:d                       //  ALU pipe: int; $1343
(W)     mul (1|M0)               acc0.0<1>:d   r6.10<0;1,0>:ud   r4.2<0;1,0>:uw                      //  ALU pipe: int; $1344
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1343
(W)     macl (1|M0)              r3.0<1>:d     r6.10<0;1,0>:ud   r4.1<0;1,0>:d                       //  ALU pipe: int; $1346
(W)     mul (1|M0)               acc0.0<1>:ud  r102.0<0;1,0>:ud  r61.0<0;1,0>:uw                     //  ALU pipe: int; $1347
(W)     macl (1|M0)              r41.0<1>:ud   r102.0<0;1,0>:ud  r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1348
(W)     mul (1|M0)               acc0.0<1>:ud  r102.0<0;1,0>:ud  r61.0<0;1,0>:uw                     //  ALU pipe: int; $1348

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     add (1|M0)               r40.4<1>:d    r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1338

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r40.1<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@5}    //  ALU pipe: int; $1346
(W)     mach (1|M0)              r7.0<1>:d     r102.0<0;1,0>:ud  r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r102.0<0;1,0>:ud  r61.2<0;1,0>:uw                     //  ALU pipe: int; $1349
(W)     macl (1|M0)              r8.0<1>:d     r102.0<0;1,0>:ud  r61.1<0;1,0>:d                      //  ALU pipe: int; $1350
(W)     mul (1|M0)               acc0.0<1>:d   r61.0<0;1,0>:ud   r40.2<0;1,0>:uw  {I@4}              //  ALU pipe: int; $1351

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     asr (1|M0)               r4.0<1>:d     r6.6<0;1,0>:d     31:w               {Compacted}      //  ALU pipe: int; $1358

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r7.0<1>:d     r7.0<0;1,0>:d     r8.0<0;1,0>:d    {Compacted,I@3}    //  ALU pipe: int; $1350
(W)     macl (1|M0)              r8.0<1>:d     r61.0<0;1,0>:ud   r40.1<0;1,0>:d                      //  ALU pipe: int; $1353

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     mul (1|M0)               acc0.0<1>:ud  r102.0<0;1,0>:ud  r6.12<0;1,0>:uw                     //  ALU pipe: int; $1359 R{} IR{}{E:3,E:3,},  {BC=1}
(W)     macl (1|M0)              r43.0<1>:ud   r102.0<0;1,0>:ud  r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1360
(W)     mul (1|M0)               acc0.0<1>:ud  r102.0<0;1,0>:ud  r6.12<0;1,0>:uw                     //  ALU pipe: int; $1360
(W)     mach (1|M0)              r2.0<1>:d     r102.0<0;1,0>:ud  r6.6<0;1,0>:ud                      //  ALU pipe: int; 
(W)     mul (1|M0)               acc0.0<1>:d   r102.0<0;1,0>:ud  r4.0<0;1,0>:uw   {I@7}              //  ALU pipe: int; $1361
(W)     macl (1|M0)              r3.0<1>:d     r102.0<0;1,0>:ud  r4.0<0;1,0>:d                       //  ALU pipe: int; $1362
(W)     mul (1|M0)               acc0.0<1>:d   r6.6<0;1,0>:ud    r40.2<0;1,0>:uw                     //  ALU pipe: int; $1363
(W)     add (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     r3.0<0;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1362
(W)     macl (1|M0)              r3.0<1>:d     r6.6<0;1,0>:ud    r40.1<0;1,0>:d                      //  ALU pipe: int; $1365

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     add (1|M0)               r40.3<1>:d    r7.0<0;1,0>:d     r8.0<0;1,0>:d                       //  ALU pipe: int; $1353

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     add (1|M0)               r40.5<1>:d    r2.0<0;1,0>:d     r3.0<0;1,0>:d    {I@2}              //  ALU pipe: int; $1365

// Line 1194:  int rank_offset = send_rank_id > 0 ? rank_prefix_matrix_[(send_rank_id - 1) * kNumRanks + rank_] : 0;
(~f1.0) goto (32|M0)                         _0_209            _0_209                                //  ALU pipe: int; $1371
// B075: [inDivergent],  Preds:{B074},  Succs:{B077}
_0_210:
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1373
        goto (32|M0)                         _0_209            _0_211                                // $1374
// B076: [inDivergent],  Preds:{B074},  Succs:{B077}
_0_209:
        join (32|M0)                         _0_211                                                  // 
L11344:
(W)     shl (1|M0)               r2.0<1>:q     r6.7<0;1,0>:d     2:w                                 //  ALU pipe: int; $1377
(W)     add (1|M0)               r4.0<1>:q     r2.0<0;1,0>:q     r5.6<0;1,0>:q    {I@1}              //  ALU pipe: int; $1378
(W)     load.ugm.d32x1t.a64 (1|M0)  r3:1        [r4:1]             {I@1,$6} // ex_desc:0x0; desc:0x2108580 // $1379
        mov (32|M0)              r28.0<1>:d    r3.0<0;1,0>:d                    {Compacted,$6.dst}   //  ALU pipe: int; $1380
// B077: [inDivergent],  Preds:{B076, B075},  Succs:{B078, B079}
_0_211:
        join (32|M0)                         _0_199                                                  // 
L11416:

// Line 1196:  int channel_offset = channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel];
(W)     mul (16|M0)              acc0.0<1>:d   r18.0<1;1,0>:d    r102.4<0;1,0>:uw                    //  ALU pipe: int; $1384
        macl (16|M0)             r2.0<1>:d     r18.0<1;1,0>:d    r102.2<0;1,0>:d  {Compacted}        //  ALU pipe: int; $1384
(W)     mul (16|M16)             acc0.0<1>:d   r19.0<1;1,0>:d    r102.4<0;1,0>:uw                    //  ALU pipe: int; $1384
        macl (16|M16)            r3.0<1>:d     r19.0<1;1,0>:d    r102.2<0;1,0>:d  {Compacted}        //  ALU pipe: int; $1385
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r102.8<0;1,0>:d  {Compacted,I@1}    //  ALU pipe: int; $1385
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1387
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted,$5.src}   //  ALU pipe: int; $1387
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1387
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1387
        add (16|M0)              r7.0<1>:q     r12.0<1;1,0>:q    r5.7<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1388
        add (16|M16)             r9.0<1>:q     r16.0<1;1,0>:q    r5.7<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1388
        load.ugm.d32.a64 (32|M0)  r30:2         [r7:4]             {I@1,$7} // ex_desc:0x0; desc:0x8200580 // $1389

// Line 1198:  (responsible_channel == num_channels - 1 ? num_rank_tokens
(W)     add (1|M0)               r4.0<1>:d     r102.2<0;1,0>:d   -1:w               {Compacted}      //  ALU pipe: int; $1392
(W)     cmp (32|M0)   (eq)f3.0   null<1>:d     r102.8<0;1,0>:d   r4.0<0;1,0>:d    {I@1}              //  ALU pipe: int; $1393
(W&f3.0) jmpi                                _0_212                                                  //  ALU pipe: int; $1394
// B078: [inDivergent],  Preds:{B077},  Succs:{B080}
_0_213:

// Line 1199:  : channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel + 1])
        load.ugm.d32.a64 (32|M0)  r2:2          [r7:4+0x4]         {$8} // ex_desc:0x4000; desc:0x8200580 // $1397

// Line 1198:  (responsible_channel == num_channels - 1 ? num_rank_tokens
(W)     jmpi                                 _0_214                                                  // $1399
// B079: [inDivergent],  Preds:{B077},  Succs:{B080}
_0_212:

// Line 1195:  int num_rank_tokens = rank_prefix_matrix_[send_rank_id * kNumRanks + rank_] - rank_offset;
        shl (32|M0)              r2.0<1>:d     r18.0<1;1,0>:d    1:w               {Compacted}       //  ALU pipe: int; $1402
        add (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     r6.7<0;1,0>:d    {Compacted,@1,$7.src} //  ALU pipe: int; $1403
        mov (16|M0)              r10.0<2>:ud   r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1405
        mov (16|M16)             r14.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1405
        shl (16|M0)              r12.0<1>:q    r10.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1405
        shl (16|M16)             r16.0<1>:q    r14.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1405
        add (16|M0)              r18.0<1>:q    r12.0<1;1,0>:q    r5.6<0;1,0>:q    {I@2}              //  ALU pipe: int; $1406
        add (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    r5.6<0;1,0>:q    {I@2}              //  ALU pipe: int; $1406
        load.ugm.d32.a64 (32|M0)  r22:2         [r18:4]            {I@1,$9} // ex_desc:0x0; desc:0x8200580 // $1407
        add (32|M0)              r2.0<1>:d     r22.0<1;1,0>:d    -r28.0<1;1,0>:d  {Compacted,$9.dst} //  ALU pipe: int; $1410
// B080: [inDivergent],  Preds:{B079, B078},  Succs:{B081, B106}
_0_214:

// Line 1201:  int token_start_idx = rank_offset + channel_offset;
        add (32|M0)              r20.0<1>:d    r28.0<1;1,0>:d    r30.0<1;1,0>:d   {Compacted,$7.dst} //  ALU pipe: int; $1416

// Line 1202:  int token_end_idx = rank_offset + channel_offset + num_channel_tokens;
        add (32|M0)              r88.0<1>:d    r28.0<1;1,0>:d    r2.0<1;1,0>:d    {Compacted,@2,$8.dst} //  ALU pipe: int; $1419

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        cmp (32|M0)   (lt)f2.0   null<1>:d     r20.0<1;1,0>:d    r88.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1422
(~f2.0) goto (32|M0)                         _0_199            _0_199                                //  ALU pipe: int; $1423
// B081: [inDivergent],  Preds:{B080},  Succs:{B082}
_0_215:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     mov (8|M0)               r98.0<1>:w    0x76543210:v                                          //  ALU pipe: int; $1508

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.0<1>:q     r61.4<0;1,0>:d    2:w                                 //  ALU pipe: int; $1433

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     add (8|M0)               r98.8<1>:w    r98.0<1;1,0>:w    8:w               {I@2}             //  ALU pipe: int; $1509

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.4<1>:d     r42.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1458

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
(W)     add (16|M0)              r98.16<1>:w   r98.0<1;1,0>:w    16:w               {I@2}            //  ALU pipe: int; $1510

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f2.0   null<2>:w     r98.0<1;1,0>:w    0:w               {I@1}             //  ALU pipe: int; $1513

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.5<1>:d     r40.4<0;1,0>:d                                        //  ALU pipe: int; $1459

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r7.0<1>:q     r2.0<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,$5.dst} //  ALU pipe: int; $1443
        add (16|M16)             r9.0<1>:q     r2.0<0;1,0>:q     r26.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1443

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r2.1<1>:q     r61.5<0;1,0>:d    2:w                                 //  ALU pipe: int; $1440

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1183:  ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
(W)     mov (1|M0)               r3.0<1>:d     r40.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1450
(W)     mov (1|M0)               r3.1<1>:d     r40.2<0;1,0>:d                                        //  ALU pipe: int; $1451

// Line 1184:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
(W)     mov (1|M0)               r3.2<1>:d     r102.0<0;1,0>:d                  {Compacted}          //  ALU pipe: int; $1466
(W)     mov (1|M0)               r3.3<1>:d     r40.1<0;1,0>:d                                        //  ALU pipe: int; $1467
(W)     mov (1|M0)               r3.6<1>:d     r41.0<0;1,0>:d                                        //  ALU pipe: int; $1474
(W)     mov (1|M0)               r3.7<1>:d     r40.3<0;1,0>:d                                        //  ALU pipe: int; $1475

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r5.0<1>:ud    f2.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1513

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r3.4<1>:q     r3.2<0;1,0>:q     4:w               {I@7}             //  ALU pipe: int; $1481

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r11.0<1>:q    r7.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1447
        add (16|M16)             r13.0<1>:q    r9.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1447

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r34.0<1>:q    r2.1<0;1,0>:q     r24.0<1;1,0>:q   {Compacted,I@7}    //  ALU pipe: int; $1441
        add (16|M16)             r36.0<1>:q    r2.1<0;1,0>:q     r26.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1441
        add (16|M0)              r94.0<1>:q    r7.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1445
        add (16|M16)             r96.0<1>:q    r9.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1445

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r3.5<1>:q     r3.3<0;1,0>:q     4:w               {I@7}             //  ALU pipe: int; $1481

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f1.0<1>:ud    r5.0<0;1,0>:ud                   {Compacted,I@7}      //  ALU pipe: int; $1516

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.0<1>:q     r3.0<0;1,0>:q     2:w               {Compacted}       //  ALU pipe: int; $1488

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r7.0<1>:q     r11.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1486
        add (16|M16)             r9.0<1>:q     r13.0<1;1,0>:q    r3.4<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1486

// Line 27:  total_bytes = num_elems * sizeof(dtype_t);
(W)     shl (1|M0)               r2.1<1>:q     r3.1<0;1,0>:q     2:w                                 //  ALU pipe: int; $1488

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1190:  static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
(W)     mov (1|M0)               r4.0<1>:d     r43.0<0;1,0>:d                   {Compacted}          //  ALU pipe: int; $1496
(W)     mov (1|M0)               r4.1<1>:d     r40.5<0;1,0>:d                                        //  ALU pipe: int; $1497

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r86.0<1>:q    r11.0<1;1,0>:q    r3.5<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1484
        add (16|M16)             r84.0<1>:q    r13.0<1;1,0>:q    r3.5<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1484

// Line 29:  gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        add (16|M0)              r15.0<1>:q    r7.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1493
        add (16|M16)             r17.0<1>:q    r9.0<1;1,0>:q     r2.0<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1493

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r82.0<1>:q    r7.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted,I@7}    //  ALU pipe: int; $1491
        add (16|M16)             r80.0<1>:q    r9.0<1;1,0>:q     r2.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $1491

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        shl (16|M16)             r7.0<1>:q     r99.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1519
        shl (16|M0)              r2.0<1>:q     r44.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1519

// Line 1256:  if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
(~f1.0) cmp (32|M0)   (gt)f1.0   null<2>:uw    r1.0<1;1,0>:uw    0x3F:uw                             //  ALU pipe: int; $1516

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
(W)     shl (1|M0)               r6.6<1>:q     r4.0<0;1,0>:q     2:w               {I@7}             //  ALU pipe: int; $1503

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        mov (16|M16)             r11.0<1>:d    r7.0<2;1,0>:d                    {Compacted,I@4}      //  ALU pipe: int; $1521
        mov (16|M0)              r10.0<1>:d    r2.0<2;1,0>:d                    {Compacted,I@4}      //  ALU pipe: int; $1520

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M0)              r78.0<1>:q    r15.0<1;1,0>:q    r6.6<0;1,0>:q    {I@3}              //  ALU pipe: int; $1504

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        and (32|M0)              r12.0<1>:d    r10.0<1;1,0>:d    124:w               {Compacted,I@2} //  ALU pipe: int; $1522
        mov (32|M0)              r14.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1524

// Line 1166:  const int send_warp_id_in_rank = send_warp_id / kNumRanks;
        shr (32|M0)              r92.0<1>:ud   r32.0<1;1,0>:ud   6:w                                 //  ALU pipe: int; $1426

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/__spirv/spirv_vars.hpp

// Line 178:  return __spirv_BuiltInSubgroupLocalInvocationId;
        asr (32|M0)              r90.0<1>:d    r88.0<1;1,0>:d    31:w               {Compacted}      //  ALU pipe: int; $1507

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f3.0   null<1>:d     r38.0<1;1,0>:d    r61.0<0;1,0>:d                      //  ALU pipe: int; $1530
(W)     cmp (32|M0)   (eq)f2.0   null<1>:d     r6.10<0;1,0>:d    0:w                                 //  ALU pipe: int; $1531

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (32|M0)              r44.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $1538

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               r5.0<1>:ud    f1.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1516

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 28:  ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        add (16|M16)             r68.0<1>:q    r17.0<1;1,0>:q    r6.6<0;1,0>:q                       //  ALU pipe: int; $1504

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (16|M16)             r8.0<2>:ud    r21.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1535
        mov (16|M0)              r2.0<2>:ud    r20.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1535

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f1.0   null<1>:d     r38.0<1;1,0>:d    r6.6<0;1,0>:d                       //  ALU pipe: int; $1533 R{} IR{}{E:3,E:3,},  R{r6,} IR{} {BC=1}
        mov (16|M0)              r16.0<2>:d    r12.0<1;1,0>:d                                        //  ALU pipe: int; $1525
        mov (16|M16)             r18.0<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1526
        mov (16|M0)              r16.1<2>:d    r14.0<1;1,0>:d                                        //  ALU pipe: int; $1527
        mov (16|M16)             r18.1<2>:d    r15.0<1;1,0>:d                                        //  ALU pipe: int; $1528

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        mov (16|M16)             r52.0<1>:q    r8.0<2;1,0>:d                    {I@7}                //  ALU pipe: int; $1535
        mov (16|M0)              r54.0<1>:q    r2.0<2;1,0>:d                    {I@7}                //  ALU pipe: int; $1535

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (16|M0)              r66.0<1>:q    r16.0<1;1,0>:q    r5.2<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1529
        add (16|M16)             r46.0<1>:q    r18.0<1;1,0>:q    r5.2<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1529
(W)     mov (1|M0)               r5.1<1>:d     (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $1532
// B082: [inDivergent],  Preds:{B105, B081},  Succs:{B083, B085}
_0_216:

// Line 1208:  int num_round_tokens = sycl::min(num_max_send_tokens_, token_end_idx - static_cast<int>(token_idx));
        mov (16|M0)              r2.0<1>:d     r54.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1542
        mov (16|M16)             r3.0<1>:d     r52.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1542

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f0.0   null<2>:w     r98.0<1;1,0>:w    0:w                                 //  ALU pipe: int; $1554

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1208:  int num_round_tokens = sycl::min(num_max_send_tokens_, token_end_idx - static_cast<int>(token_idx));
        add (32|M0)              r8.0<1>:d     r88.0<1;1,0>:d    -r2.0<1;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $1543

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/detail/builtins/integer_functions.inc

// Line 112:  BUILTIN_GENINT_SU(TWO_ARGS, min)
        sel (32|M0)   (lt)f0.0   r42.0<1>:d    r6.9<0;1,0>:d     r8.0<1;1,0>:d    {I@1}              //  ALU pipe: int; $1547

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1210:  if (elect_one_sync(item)) {
(f0.0)  goto (32|M0)                         _0_217            _0_217                                //  ALU pipe: int; $1557
// B083: Preds:{B082},  Succs:{B084}
_L_k0_0_preHeader:
_0_218:
// B084: [inDivergent],  Preds:{B083, B084},  Succs:{B085, B084}

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 216:  asm volatile (
        load.ugm.d32.a64.uc.uc (32|M0)  r2:2    [r34:4]            {$1} // ex_desc:0x0; desc:0x8220580 // $1562

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1213:  if (num_recv_buffer_tokens_ - num_used_slots >= num_round_tokens)
        add3 (32|M0)             r8.0<1>:d     r2.0<1;0>:d       -r44.0<1;0>:d     r6.10<0>:d       {Compacted,$1.dst} //  ALU pipe: int; $1566 R{} IR{}{E:1,E:6,E:3,},  R{r6,} IR{}{O:1,O:6,},  {BC=1}
        cmp (32|M0)   (lt)f0.0   null<1>:d     r8.0<1;1,0>:d     r42.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1567
(f0.0)  goto.b (32|M0)                       _0_217            _L_k0_0_preHeader                     //  ALU pipe: int; $1568
// B085: [inDivergent],  Preds:{B084, B082},  Succs:{B086, B103}
_0_217:
        join (32|M0)                         _0_199                                                  // 
L12704:

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        cmp (32|M0)   (lt)f0.0   null<1>:d     r92.0<1;1,0>:d    r42.0<1;1,0>:d                      //  ALU pipe: int; $1577
(~f0.0) goto (32|M0)                         _0_219            _0_219                                //  ALU pipe: int; $1578
// B086: [inDivergent],  Preds:{B085},  Succs:{B087}
_0_220:
        shl (16|M0)              r2.0<1>:q     r54.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1580
        shl (16|M16)             r7.0<1>:q     r52.0<1;1,0>:q    2:w               {Compacted}       //  ALU pipe: int; $1580

// Line 1222:  int dst_slot_idx = (current_channel_tail_idx + i) % num_recv_buffer_tokens_;
        mov (32|M0)              r40.0<1>:d    r92.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1583

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (16|M0)              r50.0<1>:q    r2.0<1;1,0>:q     r5.5<0;1,0>:q    {Compacted,I@3}    //  ALU pipe: int; $1581
        add (16|M16)             r48.0<1>:q    r7.0<1;1,0>:q     r5.5<0;1,0>:q    {Compacted,I@3}    //  ALU pipe: int; $1581
// B087: [inDivergent],  Preds:{B102, B086},  Succs:{B088, B089}
_0_221:

// Line 1222:  int dst_slot_idx = (current_channel_tail_idx + i) % num_recv_buffer_tokens_;
(W&~f2.0) jmpi                               _0_222                                                  //  ALU pipe: int; $1587
// B088: [inDivergent],  Preds:{B087},  Succs:{B090}
_0_223:
        mov (32|M0)              r30.0<1>:d    -1:w                               {Compacted,$15.src} //  ALU pipe: int; $1589
(W)     jmpi                                 _0_224                                                  // $1590
// B089: [inDivergent],  Preds:{B087},  Succs:{B090}
_0_222:
        add (32|M0)              r2.0<1>:d     r44.0<1;1,0>:d    r40.0<1;1,0>:d   {Compacted,I@6}    //  ALU pipe: int; $1592
        sync.nop                             null                             {Compacted,$3.src}     // $1593
        asr (32|M0)              r8.0<1>:d     r2.0<1;1,0>:d     31:w               {Compacted,@1,$2.src} //  ALU pipe: int; $1593
        add3 (32|M0)             r10.0<1>:d    r8.0<1;0>:d       r44.0<1;0>:d      r40.0<1>:d       {Compacted,I@1} //  ALU pipe: int; $1594 R{} IR{}{E:4,E:6,E:4,},  R{} IR{}{O:4,O:6,O:4,},  {BC=2}
        xor (32|M0)              r12.0<1>:d    r10.0<1;1,0>:d    r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1595
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $1596
(W)     mov (1|M0)               r4.0<1>:f     r5.1<0;1,0>:ud                   {A@1}                //  ALU pipe: float; $1597
(W)     mov (1|M0)               r7.0<1>:f     0xB4C00000:f                               {Compacted} //  ALU pipe: float; $1602
(W)     math.inv (1|M0)          r6.12<1>:f    r4.0<0;1,0>:f                    {F@2}                //  ALU pipe: math; $1601
        sync.nop                             null                             {Compacted,$14.src}    // $1600
        mov (32|M0)              r14.0<1>:f    r12.0<1;1,0>:ud                  {@2,$10.src}         //  ALU pipe: float; $1600
        sync.nop                             null                             {Compacted,A@1}        // $1602
(W)     mad (1|M0)               r16.0<1>:f    r6.12<0;0>:f      r7.0<0;0>:f       r6.12<0>:f       {$13.src} //  ALU pipe: float; $1602
        mov (32|M0)              r2.0<1>:ud    r14.0<1;1,0>:f                   {F@2}                //  ALU pipe: int; $1604
        mul (32|M0)              r18.0<1>:f    r14.0<1;1,0>:f    r16.0<0;1,0>:f   {Compacted,F@1}    //  ALU pipe: float; $1603
(W)     mov (1|M0)               r4.1<1>:ud    r4.0<0;1,0>:f                                         //  ALU pipe: int; $1598
        add (32|M0)              r20.0<1>:d    r12.0<1;1,0>:d    -r2.0<1;1,0>:d   {Compacted,I@2}    //  ALU pipe: int; $1605
        mov (32|M0)              r10.0<1>:ud   r18.0<1;1,0>:f                   {F@1}                //  ALU pipe: int; $1606
(W)     add (1|M0)               r6.11<1>:d    (abs)r6.10<0;1,0>:d  -r4.1<0;1,0>:d {I@3}             //  ALU pipe: int; $1599
        mov (32|M0)              r24.0<1>:f    r10.0<1;1,0>:ud                  {I@2}                //  ALU pipe: float; $1609
        mov (32|M0)              r22.0<1>:f    r20.0<1;1,0>:ud                                       //  ALU pipe: float; $1608
(W)     mov (1|M0)               r16.1<1>:f    r6.11<0;1,0>:ud                  {I@1}                //  ALU pipe: float; $1607
        mad (32|M0)              acc0.0<1>:f   r14.0<1;0>:f      r24.0<1;0>:f      -r4.0<0>:f       {F@3} //  ALU pipe: float; $1611 R{} IR{}{E:7,E:4,E:2,},  R{r4,} IR{}{O:7,O:12,},  {BC=1}
        mad (32|M0)              acc2.0<1>:f   r22.0<1;0>:f      r24.0<1;0>:f      -r16.1<0>:f      {F@2} //  ALU pipe: float; $1613 R{} IR{}{E:3,E:4,E:0,},  R{r16,} IR{}{O:11,O:12,},  {BC=1}
        add (32|M0)              acc0.0<1>:f   acc0.0<1;1,0>:f   acc2.0<1;1,0>:f  {Compacted}        //  ALU pipe: float; $1614
        mul (32|M0)              r26.0<1>:f    r16.0<0;1,0>:f    acc0.0<1;1,0>:f  {Compacted,$15.src} //  ALU pipe: float; $1615
(W)     xor (1|M0)               cr0.0<1>:ud   cr0.0<0;1,0>:ud   0x30:uw              {A@1}          // $1616
        mov (32|M0)              r28.0<1>:ud   r26.0<1;1,0>:f                   {A@1}                //  ALU pipe: int; $1617
        add (32|M0)              r30.0<1>:d    r28.0<1;1,0>:d    r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1618
(W)     mov (1|M0)               r2.0<1>:d     (abs)r6.10<0;1,0>:d                                   //  ALU pipe: int; $1619
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r2.0<0;1,0>:uw   {I@1}              //  ALU pipe: int; $1619
        macl (16|M0)             r18.0<1>:d    r30.0<1;1,0>:d    r2.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1619
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r2.0<0;1,0>:uw                      //  ALU pipe: int; $1619
        macl (16|M16)            r19.0<1>:d    r31.0<1;1,0>:d    r2.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1620
        add (32|M0)              r14.0<1>:d    r12.0<1;1,0>:d    -r18.0<1;1,0>:d  {Compacted,I@1}    //  ALU pipe: int; $1620
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r14.0<1;1,0>:ud   r5.1<0;1,0>:ud   {I@1}              //  ALU pipe: int; $1621
(~f0.0) sel (32|M0)              r20.0<1>:d    (abs)r6.10<0;1,0>:d  0:w                              //  ALU pipe: int; $1622
        add3 (32|M0)             r22.0<1>:d    r14.0<1;0>:d      r8.0<1;0>:d       -r20.0<1>:d      {Compacted,I@1} //  ALU pipe: int; $1623 R{} IR{}{E:7,E:4,E:2,},  R{} IR{}{O:7,O:4,O:10,},  {BC=2}
        xor (32|M0)              r30.0<1>:d    r22.0<1;1,0>:d    r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1624
// B090: [inDivergent],  Preds:{B089, B088},  Succs:{B091, B097}
_0_224:

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M0)              r2.0<2>:ud    r40.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1628
        sync.nop                             null                             {Compacted,$3.src}     // $1628
        mov (16|M16)             r8.0<2>:ud    r41.0<1;1,0>:ud                  {Compacted,$2.src}   //  ALU pipe: int; $1628
        mov (16|M0)              r64.0<1>:q    r2.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $1628
        mov (16|M16)             r62.0<1>:q    r8.0<2;1,0>:ud                   {I@2}                //  ALU pipe: int; $1628
        add (16|M0)              r10.0<1>:q    r54.0<1;1,0>:q    r64.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1629
        add (16|M16)             r12.0<1>:q    r52.0<1;1,0>:q    r62.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1629
        mov (16|M0)              r32.0<1>:d    r10.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1630
        mov (16|M16)             r33.0<1>:d    r12.0<2;1,0>:d                   {Compacted,I@2}      //  ALU pipe: int; $1631
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw  {I@2}              //  ALU pipe: int; $1634
        macl (16|M0)             r16.0<1>:ud   r32.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted,$13.src} //  ALU pipe: int; $1634
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw  {I@3}              //  ALU pipe: int; $1634
        macl (16|M16)            r17.0<1>:ud   r33.0<1;1,0>:ud   r61.0<0;1,0>:ud  {Compacted}        //  ALU pipe: int; $1635
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1635
        mach (16|M0)             r2.0<1>:d     r32.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r61.0<0;1,0>:uw                     //  ALU pipe: int; $1635
        mach (16|M16)            r3.0<1>:d     r33.0<1;1,0>:ud   r61.0<0;1,0>:ud                     //  ALU pipe: int; $1636
(W)     mul (16|M0)              acc0.0<1>:d   r32.0<1;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1636
        macl (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1636
(W)     mul (16|M16)             acc0.0<1>:d   r33.0<1;1,0>:ud   r61.2<0;1,0>:uw                     //  ALU pipe: int; $1636
        mov (16|M0)              r28.0<1>:d    r10.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1632
        macl (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r61.1<0;1,0>:d                      //  ALU pipe: int; $1637
        mov (16|M16)             r29.0<1>:d    r12.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1633
        add (32|M0)              r2.0<1>:d     r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@2}    //  ALU pipe: int; $1637
(W)     mul (16|M0)              acc0.0<1>:d   r61.0<0;1,0>:ud   r28.0<2;1,0>:uw                     //  ALU pipe: int; $1638
        macl (16|M0)             r8.0<1>:d     r61.0<0;1,0>:ud   r28.0<1;1,0>:d                      //  ALU pipe: int; $1638
(W)     mul (16|M16)             acc0.0<1>:d   r61.0<0;1,0>:ud   r29.0<2;1,0>:uw  {I@4}              //  ALU pipe: int; $1638
        macl (16|M16)            r9.0<1>:d     r61.0<0;1,0>:ud   r29.0<1;1,0>:d                      //  ALU pipe: int; $1640
        add (32|M0)              r18.0<1>:d    r2.0<1;1,0>:d     r8.0<1;1,0>:d    {Compacted,I@1}    //  ALU pipe: int; $1640

// Line 1227:  for (int j = lane_id; j < hidden_int4; j += 32) {
(~f3.0) goto (32|M0)                         _0_225            _0_225                                //  ALU pipe: int; $1643
// B091: [inDivergent],  Preds:{B090},  Succs:{B092}
_0_226:

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $1646
        macl (16|M0)             r2.0<1>:d     r30.0<1;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $1646
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r61.0<0;1,0>:uw                     //  ALU pipe: int; $1646

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M16)             r22.0<2>:d    r17.0<1;1,0>:d                                        //  ALU pipe: int; $1655

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        macl (16|M16)            r3.0<1>:d     r31.0<1;1,0>:d    r61.0<0;1,0>:d   {Compacted}        //  ALU pipe: int; $1648

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        mov (16|M16)             r22.1<2>:d    r19.0<1;1,0>:d                   {I@7}                //  ALU pipe: int; $1657
        mov (16|M0)              r20.0<2>:d    r16.0<1;1,0>:d                                        //  ALU pipe: int; $1654

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        mov (16|M0)              r8.0<2>:ud    r2.0<1;1,0>:ud                   {Compacted,I@6}      //  ALU pipe: int; $1648
        mov (16|M16)             r12.0<2>:ud   r3.0<1;1,0>:ud                   {Compacted,I@4}      //  ALU pipe: int; $1648

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        shl (16|M16)             r26.0<1>:q    r22.0<1;1,0>:q    4:w               {Compacted,@4,$14.src} //  ALU pipe: int; $1658
        mov (16|M0)              r20.1<2>:d    r18.0<1;1,0>:d                                        //  ALU pipe: int; $1656

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        shl (16|M0)              r10.0<1>:q    r8.0<2;1,0>:d     4:w               {I@4}             //  ALU pipe: int; $1648
        shl (16|M16)             r14.0<1>:q    r12.0<2;1,0>:d    4:w               {@4,$10.src}      //  ALU pipe: int; $1648

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        add (16|M16)             r72.0<1>:q    r26.0<1;1,0>:q    r5.1<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1659
        shl (16|M0)              r24.0<1>:q    r20.0<1;1,0>:q    4:w               {Compacted,I@4}   //  ALU pipe: int; $1658

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 207:  *ptr = value;
        mov (32|M0)              r26.0<1>:d    r38.0<1;1,0>:d                   {Compacted}          //  ALU pipe: int; $1663

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1225:  auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
        add (16|M0)              r58.0<1>:q    r86.0<1;1,0>:q    r10.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1649
        add (16|M16)             r56.0<1>:q    r84.0<1;1,0>:q    r14.0<1;1,0>:q   {Compacted,I@5}    //  ALU pipe: int; $1649

// Line 1226:  auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
        add (16|M0)              r70.0<1>:q    r24.0<1;1,0>:q    r5.1<0;1,0>:q    {Compacted,I@4}    //  ALU pipe: int; $1659
// B092: [inDivergent],  Preds:{B096, B091},  Succs:{B093, B094}
_0_227:

// Line 1228:  st_na_global(shifted_x_buffers + j, ld_nc_global(shifted_x + j));
        mov (16|M0)              r2.0<2>:ud    r26.0<1;1,0>:ud                  {Compacted,I@4}      //  ALU pipe: int; $1669
        sync.nop                             null                             {Compacted,$3.src}     // $1669
        mov (16|M16)             r10.0<2>:ud   r27.0<1;1,0>:ud                  {Compacted,$2.src}   //  ALU pipe: int; $1669
        shl (16|M0)              r7.0<1>:q     r2.0<2;1,0>:ud    4:w               {I@2}             //  ALU pipe: int; $1669
        shl (16|M16)             r12.0<1>:q    r10.0<2;1,0>:ud   4:w               {I@2}             //  ALU pipe: int; $1669
        add (16|M0)              r22.0<1>:q    r70.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1671
        add (16|M16)             r24.0<1>:q    r72.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1671
        add (16|M0)              r76.0<1>:q    r58.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted}        //  ALU pipe: int; $1670
        add (16|M16)             r74.0<1>:q    r56.0<1;1,0>:q    r12.0<1;1,0>:q   {Compacted}        //  ALU pipe: int; $1670

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 207:  *ptr = value;
        mov (16|M0)              r14.0<1>:uq   r22.0<1;1,0>:uq                  {Compacted,@4,$10.src} //  ALU pipe: int; $1676
        mov (16|M16)             r16.0<1>:uq   r24.0<1;1,0>:uq                  {Compacted,@4,$13.src} //  ALU pipe: int; $1676
        mov (16|M0)              r18.0<1>:d    r76.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1677
        mov (16|M16)             r19.0<1>:d    r74.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1677
        mov (16|M0)              r2.0<1>:d     r14.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1679
        mov (16|M16)             r3.0<1>:d     r16.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1679
        cmp (32|M0)   (gt)f0.0   null<1>:ud    r18.0<1;1,0>:ud   r2.0<1;1,0>:ud   {I@1}              //  ALU pipe: int; $1681 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:1,},  {BC=1}
        mov (16|M0)              r20.0<1>:d    r76.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1678
        mov (16|M16)             r21.0<1>:d    r74.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1678
        mov (16|M0)              r10.0<1>:d    r14.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1680
        mov (16|M16)             r11.0<1>:d    r16.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1680
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:d     r20.0<1;1,0>:d    r10.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1682
(~f0.0) cmp (32|M0)   (gt)f0.0   null<1>:ud    r20.0<1;1,0>:ud   r10.0<1;1,0>:ud                     //  ALU pipe: int; $1684
(f0.0)  goto (32|M0)                         _0_228            _0_228                                //  ALU pipe: int; $1686
// B093: [inDivergent],  Preds:{B092},  Succs:{B095}
_0_229:
        load.ugm.d32.a64 (32|M0)  r14:2         [r22:4]            {$4} // ex_desc:0x0; desc:0x8200580 // $1688
        load.ugm.d32.a64 (32|M0)  r16:2         [r22:4+0x4]        {$5} // ex_desc:0x4000; desc:0x8200580 // $1689
        load.ugm.d32.a64 (32|M0)  r2:2          [r22:4+0x8]        {$6} // ex_desc:0x8000; desc:0x8200580 // $1690
        load.ugm.d32.a64 (32|M0)  r8:2          [r22:4+0xC]        {$7} // ex_desc:0xC000; desc:0x8200580 // $1691
        mov (16|M0)              r10.0<1>:uq   r76.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1692
        mov (16|M16)             r12.0<1>:uq   r74.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1692
        sync.nop                             null                             {Compacted,$4.dst}     // $1693
        store.ugm.d32.a64 (32|M0)  [r10:4]      r14:2              {I@1,$10} // ex_desc:0x0; desc:0x8000584 // $1693
        sync.nop                             null                             {Compacted,$5.dst}     // $1694
        store.ugm.d32.a64 (32|M0)  [r10:4+0x4]  r16:2              {$13} // ex_desc:0x4000; desc:0x8000584 // $1694
        store.ugm.d32.a64 (32|M0)  [r10:4+0x8]  r2:2               {$6} // ex_desc:0x8000; desc:0x8000584 // $1695
        sync.nop                             null                             {Compacted,$7.dst}     // $1696
        store.ugm.d32.a64 (32|M0)  [r10:4+0xC]  r8:2               {$2} // ex_desc:0xC000; desc:0x8000584 // $1696
        goto (32|M0)                         _0_228            _0_230                                // $1697
// B094: [inDivergent],  Preds:{B092},  Succs:{B095}
_0_228:
        join (32|M0)                         _0_230                                                  // 
L14320:
        load.ugm.d32x4.a64 (32|M0)  r8:8        [r22:4]            {$8} // ex_desc:0x0; desc:0x8803580 // $1699
        mov (16|M0)              r16.0<1>:uq   r76.0<1;1,0>:uq                  {Compacted,$13.src}  //  ALU pipe: int; $1700
        mov (16|M16)             r18.0<1>:uq   r74.0<1;1,0>:uq                  {Compacted}          //  ALU pipe: int; $1700
        sync.nop                             null                             {Compacted,$8.dst}     // $1701
        store.ugm.d32x4.a64 (32|M0)  [r16:4]    r8:8               {I@1,$3} // ex_desc:0x0; desc:0x8003584 // $1701
// B095: [inDivergent],  Preds:{B094, B093},  Succs:{B096, B097}
_0_230:
        join (32|M0)                         _0_225                                                  // 
L14392:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1227:  for (int j = lane_id; j < hidden_int4; j += 32) {
        add (32|M0)              r2.0<1>:d     r26.0<1;1,0>:d    32:w               {Compacted,$6.src} //  ALU pipe: int; $1705
        cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r61.0<0;1,0>:d   {I@1}              //  ALU pipe: int; $1708
(~f0.0) goto (32|M0)                         _0_225            _0_225                                //  ALU pipe: int; $1709
// B096: [inDivergent],  Preds:{B095},  Succs:{B092}
_0_231:
        mov (32|M0)              r26.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1711
(W)     jmpi                                 _0_227                                                  // $1712
// B097: [inDivergent],  Preds:{B095, B090},  Succs:{B098, B099}
_0_225:
        join (32|M0)                         _0_219                                                  // 
L14472:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 77:  return sg.get_local_linear_id() == 0;
        cmp (32|M0)   (ne)f0.0   null<2>:w     r98.0<1;1,0>:w    0:w                                 //  ALU pipe: int; $1719

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1234:  if (elect_one_sync(item)) {
(f0.0)  goto (32|M0)                         _0_232            _0_232                                //  ALU pipe: int; $1722
// B098: [inDivergent],  Preds:{B097},  Succs:{B099}
_0_233:

// Line 1235:  channel_src_idx_buffers[dst_slot_idx] = src_idx_[token_idx + i];
        sync.nop                             null                             {Compacted,F@1}        // $1725
        shl (16|M0)              r2.0<1>:q     r64.0<1;1,0>:q    2:w               {Compacted,$6.src} //  ALU pipe: int; $1725
        sync.nop                             null                             {Compacted,$3.src}     // $1725
        shl (16|M16)             r7.0<1>:q     r62.0<1;1,0>:q    2:w               {Compacted,$2.src} //  ALU pipe: int; $1725
        add (16|M0)              r9.0<1>:q     r50.0<1;1,0>:q    r2.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1726 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:1,},  {BC=1}
        add (16|M16)             r11.0<1>:q    r48.0<1;1,0>:q    r7.0<1;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $1726
        load.ugm.d32.a64 (32|M0)  r14:2         [r9:4]             {I@1,$9} // ex_desc:0x0; desc:0x8200580 // $1727

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 45:  dtype_t& operator[](int64_t idx) { return buffer()[idx]; }
        mov (16|M0)              r16.0<2>:ud   r30.0<1;1,0>:ud                  {Compacted,$13.src}  //  ALU pipe: int; $1736
        mov (16|M16)             r20.0<2>:ud   r31.0<1;1,0>:ud                  {Compacted}          //  ALU pipe: int; $1736
        shl (16|M0)              r18.0<1>:q    r16.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1736
        shl (16|M16)             r22.0<1>:q    r20.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1736
        add (16|M0)              r24.0<1>:q    r82.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,@2,$14.src} //  ALU pipe: int; $1737 R{} IR{}{E:1,E:1,},  R{} IR{}{O:9,O:9,},  {BC=2}
        add (16|M16)             r26.0<1>:q    r80.0<1;1,0>:q    r22.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1737

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1235:  channel_src_idx_buffers[dst_slot_idx] = src_idx_[token_idx + i];
        sync.nop                             null                             {Compacted,$9.dst}     // $1741
        store.ugm.d32.a64 (32|M0)  [r24:4]      r14:2              {I@1,$14} // ex_desc:0x0; desc:0x8000584 // $1741
// B099: [inDivergent],  Preds:{B098, B097},  Succs:{B100, B101}
_0_232:
        join (32|M0)                         _0_219                                                  // 
L14672:

// Line 1239:  if (num_topk_ > 0 && lane_id < num_topk_) {
(~f1.0) goto (32|M0)                         _0_234            _0_234                                //  ALU pipe: int; $1745
// B100: [inDivergent],  Preds:{B099},  Succs:{B101}
_0_235:

// Line 1241:  topk_weights_[(token_idx + i) * num_topk_ + lane_id];
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1748
        macl (16|M0)             r2.0<1>:ud    r32.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted,$6.src} //  ALU pipe: int; $1748
(W)     mul (16|M16)             acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1748
        macl (16|M16)            r3.0<1>:ud    r33.0<1;1,0>:ud   r6.6<0;1,0>:ud   {Compacted}        //  ALU pipe: int; $1749
(W)     mul (16|M0)              acc0.0<1>:ud  r32.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1749
        sync.nop                             null                             {Compacted,$3.src}     // 
        mach (16|M0)             r8.0<1>:d     r32.0<1;1,0>:ud   r6.6<0;1,0>:ud   {$2.src}           //  ALU pipe: int; 
(W)     mul (16|M0)              acc0.0<1>:ud  r33.0<1;1,0>:ud   r6.12<0;1,0>:uw                     //  ALU pipe: int; $1749
        mach (16|M16)            r9.0<1>:d     r33.0<1;1,0>:ud   r6.6<0;1,0>:ud                      //  ALU pipe: int; $1752
(W)     mul (16|M0)              acc0.0<1>:d   r6.6<0;1,0>:ud    r28.0<2;1,0>:uw                     //  ALU pipe: int; $1752
        macl (16|M0)             r10.0<1>:d    r6.6<0;1,0>:ud    r28.0<1;1,0>:d                      //  ALU pipe: int; $1752
(W)     mul (16|M16)             acc0.0<1>:d   r6.6<0;1,0>:ud    r29.0<2;1,0>:uw                     //  ALU pipe: int; $1752
        macl (16|M16)            r11.0<1>:d    r6.6<0;1,0>:ud    r29.0<1;1,0>:d                      //  ALU pipe: int; $1754
        add (32|M0)              r12.0<1>:d    r8.0<1;1,0>:d     r10.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1754
        sync.nop                             null                             {Compacted,$14.src}    // $1757
        mov (16|M0)              r14.0<2>:d    r2.0<1;1,0>:d                    {$10.src}            //  ALU pipe: int; $1757
        mov (16|M16)             r16.0<2>:d    r3.0<1;1,0>:d                    {$13.src}            //  ALU pipe: int; $1758
        mov (16|M0)              r14.1<2>:d    r12.0<1;1,0>:d                   {I@3}                //  ALU pipe: int; $1759
        mov (16|M16)             r16.1<2>:d    r13.0<1;1,0>:d                                        //  ALU pipe: int; $1760
        shl (16|M0)              r18.0<1>:q    r14.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1761
        shl (16|M16)             r20.0<1>:q    r16.0<1;1,0>:q    2:w               {Compacted,I@2}   //  ALU pipe: int; $1761
        add (16|M0)              r22.0<1>:q    r66.0<1;1,0>:q    r18.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1762 R{} IR{}{E:1,E:1,},  R{} IR{}{O:1,O:9,},  {BC=1}
        add (16|M16)             r24.0<1>:q    r46.0<1;1,0>:q    r20.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1762
        load.ugm.d32.a64 (32|M0)  r26:2         [r22:4]            {I@1,$1} // ex_desc:0x0; desc:0x8200580 // $1763

// Line 1240:  channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] =
(W)     mul (16|M0)              acc0.0<1>:d   r30.0<1;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1765
        macl (16|M0)             r28.0<1>:d    r30.0<1;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1765
(W)     mul (16|M16)             acc0.0<1>:d   r31.0<1;1,0>:d    r6.12<0;1,0>:uw                     //  ALU pipe: int; $1765
        macl (16|M16)            r29.0<1>:d    r31.0<1;1,0>:d    r6.6<0;1,0>:d    {Compacted}        //  ALU pipe: int; $1766
        add (32|M0)              r8.0<1>:d     r28.0<1;1,0>:d    r38.0<1;1,0>:d   {Compacted,I@1}    //  ALU pipe: int; $1766

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/buffer.hpp

// Line 45:  dtype_t& operator[](int64_t idx) { return buffer()[idx]; }
        mov (16|M0)              r2.0<2>:ud    r8.0<1;1,0>:ud                   {Compacted,I@1}      //  ALU pipe: int; $1775
        mov (16|M16)             r12.0<2>:ud   r9.0<1;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1775
        shl (16|M0)              r10.0<1>:q    r2.0<2;1,0>:d     2:w               {I@2}             //  ALU pipe: int; $1775
        shl (16|M16)             r14.0<1>:q    r12.0<2;1,0>:d    2:w               {I@2}             //  ALU pipe: int; $1775
        add (16|M0)              r30.0<1>:q    r78.0<1;1,0>:q    r10.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1776
        add (16|M16)             r32.0<1>:q    r68.0<1;1,0>:q    r14.0<1;1,0>:q   {Compacted,I@2}    //  ALU pipe: int; $1776

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1240:  channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] =
        sync.nop                             null                             {Compacted,$1.dst}     // $1780
        store.ugm.d32.a64 (32|M0)  [r30:4]      r26:2              {I@1,$15} // ex_desc:0x0; desc:0x8000584 // $1780
// B101: [inDivergent],  Preds:{B100, B099},  Succs:{B102, B103}
_0_234:
        join (32|M0)                         _0_219                                                  // 
L15160:

// Line 1221:  for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
        add (32|M0)              r2.0<1>:d     r40.0<1;1,0>:d    1:w               {Compacted,$6.src} //  ALU pipe: int; $1784
        cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r42.0<1;1,0>:d   {I@1}              //  ALU pipe: int; $1787
(~f0.0) goto (32|M0)                         _0_219            _0_219                                //  ALU pipe: int; $1788
// B102: [inDivergent],  Preds:{B101},  Succs:{B087}
_0_236:
        mov (32|M0)              r40.0<1>:f    r2.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $1790
(W)     jmpi                                 _0_221                                                  // $1791
// B103: [inDivergent],  Preds:{B101, B085},  Succs:{B104, B105}
_0_219:
        join (32|M0)                         _0_199                                                  // 
L15240:

// Line 1245:  token_idx += num_round_tokens;
        sync.nop                             null                             {Compacted,F@1}        // $1795
        mov (16|M0)              r2.0<2>:ud    r42.0<1;1,0>:ud                  {Compacted,$6.src}   //  ALU pipe: int; $1795
        sync.nop                             null                             {Compacted,$3.src}     // $1795
        mov (16|M16)             r8.0<2>:ud    r43.0<1;1,0>:ud                  {Compacted,$2.src}   //  ALU pipe: int; $1795
        add (16|M0)              r54.0<1>:q    r54.0<1;1,0>:q    r2.0<2;1,0>:d    {I@2}              //  ALU pipe: int; $1795
        add (16|M16)             r52.0<1>:q    r52.0<1;1,0>:q    r8.0<2;1,0>:d    {I@2}              //  ALU pipe: int; $1795

// Line 1246:  current_channel_tail_idx += num_round_tokens;
        add (32|M0)              r44.0<1>:d    r44.0<1;1,0>:d    r42.0<1;1,0>:d   {Compacted,$0.src} //  ALU pipe: int; $1802
        mov (16|M0)              r2.0<1>:d     r54.1<2;1,0>:d                   {Compacted,I@3}      //  ALU pipe: int; $1799
        mov (16|M0)              r8.0<1>:d     r54.0<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1797
        mov (16|M16)             r9.0<1>:d     r52.0<2;1,0>:d                   {Compacted,I@4}      //  ALU pipe: int; $1798
        mov (16|M16)             r3.0<1>:d     r52.1<2;1,0>:d                   {Compacted}          //  ALU pipe: int; $1800

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/atomic_fence.hpp

// Line 26:  __spirv_MemoryBarrier(SPIRVScope, static_cast<uint32_t>(SPIRVOrder));
(W)     send.slm (1|M0)          r7       r60  null:0  0x0            0x0210001F           {$4} // wr:1+0, rd:1; fence.slm.none.group // $1810
(W)     mov (8|M0)               null<1>:ud    r7.0<1;1,0>:ud                   {Compacted,$4.dst}   //  memory fence commit; ALU pipe: int; $1811
(W)     send.ugm (1|M0)          r10      r60  null:0  0x0            0x0210261F           {$5} // wr:1+0, rd:1; fence.ugm.invalidate.gpu // $1811

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
(W)     mov (1|M0)               f0.0<1>:ud    r5.0<0;1,0>:ud                   {Compacted}          //  ALU pipe: int; $1814

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1256:  if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
(W)     mov (8|M0)               null<1>:ud    r10.0<1;1,0>:ud                  {Compacted,$5.dst}   //  memory fence commit; ALU pipe: int; $1814
(f0.0)  goto (32|M0)                         _0_237            _0_237                                //  ALU pipe: int; $1814
// B104: [inDivergent],  Preds:{B103},  Succs:{B105}
_0_238:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/utils.hpp

// Line 234:  asm volatile (
        store.ugm.d32.a64.uc.uc (32|M0)  [r94:4] r44:2             {I@7,$0} // ex_desc:0x0; desc:0x8020584 // $1819
// B105: [inDivergent],  Preds:{B104, B103},  Succs:{B106, B082}
_0_237:
        join (32|M0)                         _0_199                                                  // 
L15448:

// File: /home/sdp/zhenyuan/DeepEP/csrc/sycl/intranode.cpp

// Line 1206:  for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
        cmp (32|M0)   (lt)f0.0   null<1>:ud    r8.0<1;1,0>:ud    r88.0<1;1,0>:ud  {I@7}              //  ALU pipe: int; $1825 R{} IR{}{E:4,E:4,},  R{} IR{}{O:4,O:12,},  {BC=1}
(f0.0)  cmp (32|M0)   (eq)f0.0   null<1>:d     r2.0<1;1,0>:d     r90.0<1;1,0>:d   {I@7}              //  ALU pipe: int; $1826
(~f0.0) cmp (32|M0)   (lt)f0.0   null<1>:d     r2.0<1;1,0>:d     r90.0<1;1,0>:d                      //  ALU pipe: int; $1828
(f0.0)  goto.b (32|M0)                       _0_199            _0_216                                //  ALU pipe: int; $1830
// B106: Preds:{B105, B080, B066, B064, B063},  Succs:{}
_0_199:
        join (32|M0)                         L15528                                                  // 
L15528:

// File: /data/model/zhenyuan/old/compiler/2025.2/bin/compiler/../../include/sycl/handler.hpp

// Line 1496:  }
        sync.allrd                           ($6,$11,$12)                                            // $1834
(W)     send.slm (1|M0)          r2       r60  null:0  0x0            0x0210001F           {I@3,$7} // wr:1+0, rd:1; fence.slm.none.group // $1834
(W)     mov (16|M0)              r127.0<1>:f   r60.0<1;1,0>:f                   {Compacted}          //  ALU pipe: float; $1835
(W)     mov (8|M0)               null<1>:ud    r2.0<1;1,0>:ud                   {Compacted,$7.dst}   //  memory fence commit; ALU pipe: int; $1835
(W)     send.gtwy (1|M0)         null     r127  null:0  0x0            0x02000010           {EOT,F@1,$8} // wr:1+0, rd:0; end of thread // $1835
L15592:
(W)     mov (16|M0)              null<1>:ud    0x8635A964:ud                                         // 
(W)     mov (16|M0)              null<1>:ud    0x88D54B93:ud                                         // 
(W)     mov (16|M0)              null<1>:ud    0x0:ud                                                // 
(W)     mov (16|M0)              null<1>:ud    0x10:ud                                               // 


//.BankConflicts: 22
//.ByteRMWs: 1
//


//.numALUInst: 1028
//.accSubDef: 3
//.accSubUse: 3
//.accSubCandidateDef: 3
//.accSubCandidateUse: 3
//
//
//.singlePipeAtOneDistNum: 144
//.allAtOneDistNum: 29
//.syncInstCount: 32
//.tokenReuseCount: 0
//.AfterWriteTokenDepCount: 40
//.AfterReadTokenDepCount: 98
