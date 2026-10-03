package com.appsflyer.internal;

import java.util.Map;

public class AFc1fSDK {
    public static final byte[] $$a = null;
    public static final int $$b = 0;
    private static int $10 = 0;
    private static int $11 = 1;
    private static byte[] AFLogger$LogLevel;
    private static byte[] AFVersionDeclaration;
    private static byte[] AppsFlyer2dXConversionCallback;
    private static Object afErrorLogForExcManagerOnly;
    private static final Map<String, Object> afLogForce;
    public static final Map<Integer, Object> afRDLog;
    private static Object getLevel;
    private static int init;
    private static long onAppOpenAttributionNative;
    private static int onInstallConversionFailureNative;

    private static String $$c(int i, short s, short s2) {
        int i2;
        int i3;
        byte[] bArr;
        byte[] bArr2;
        int i4;
        int i5 = 2 % 2;
        int i6 = $11 + 79;
        int i7 = i6 % 128;
        $10 = i7;
        int i8 = 0;
        if (i6 % 2 != 0) {
            i2 = 114 % i;
            i3 = ((s ^ 196) + ((s & 196) << 1)) - 123;
            int i9 = 57 >>> s2;
            bArr = $$a;
            bArr2 = new byte[i9];
            i4 = (i9 ^ 77) + ((i9 & 77) << 1);
            if (bArr == null) {
                int i10 = i7 + 17;
                $11 = i10 % 128;
                int i11 = i10 % 2;
                int i12 = i7 + 117;
                $11 = i12 % 128;
                int i13 = i12 % 2;
                int i14 = i3;
                int i15 = -i3;
                i2 = (i2 & i15) + (i15 | i2) + 1;
                int i16 = $10;
                int i17 = (i16 ^ 77) + ((i16 & 77) << 1);
                $11 = i17 % 128;
                int i18 = i17 % 2;
                i3 = i14;
            }
        } else {
            int i19 = -i;
            i2 = ((i19 | 119) << 1) - (i19 ^ 119);
            int i20 = (s ^ 88) + ((s & 88) << 1);
            i3 = ((i20 & (-84)) << 1) + (i20 ^ (-84));
            int i21 = 36 - s2;
            bArr = $$a;
            bArr2 = new byte[i21];
            i4 = (~i21) + (i21 << 1);
            if (bArr == null) {
                int i110 = i7 + 17;
                $11 = i110 % 128;
                int i111 = i110 % 2;
                int i112 = i7 + 117;
                $11 = i112 % 128;
                int i113 = i112 % 2;
                int i114 = i3;
                int i115 = -i3;
                i2 = (i2 & i115) + (i115 | i2) + 1;
                int i116 = $10;
                int i117 = (i116 ^ 77) + ((i116 & 77) << 1);
                $11 = i117 % 128;
                int i118 = i117 % 2;
                i3 = i114;
            }
        }
        while (true) {
            bArr2[i8] = (byte) i2;
            int i22 = ((i3 ^ 28) + ((i3 & 28) << 1)) - 27;
            if (i8 == i4) {
                return new String(bArr2, 0);
            }
            int i23 = (i8 ^ 1) + ((i8 & 1) << 1);
            byte b = bArr[i22];
            int i24 = $10;
            int i25 = (i24 ^ 49) + ((i24 & 49) << 1);
            $11 = i25 % 128;
            int i26 = i25 % 2;
            i8 = i23;
            int i27 = -b;
            i2 = (i2 & i27) + (i27 | i2) + 1;
            int i28 = $10;
            int i29 = (i28 ^ 77) + ((i28 & 77) << 1);
            $11 = i29 % 128;
            int i30 = i29 % 2;
            i3 = i22;
        }
    }

    public static int AFInAppEventParameterName(int i) throws Throwable {
        int i2 = 2 % 2;
        int i3 = $11;
        int i4 = ((i3 | 13) << 1) - (i3 ^ 13);
        $10 = i4 % 128;
        int i5 = i4 % 2;
        Object obj = afErrorLogForExcManagerOnly;
        int i6 = ((i3 | 125) << 1) - (i3 ^ 125);
        int i7 = i6 % 128;
        $10 = i7;
        int i8 = i6 % 2;
        int i9 = (i7 & 75) + (i7 | 75);
        $11 = i9 % 128;
        int i10 = i9 % 2;
        try {
            Object[] objArr = {Integer.valueOf(i)};
            byte[] bArr = $$a;
            int iIntValue = ((Integer) Class.forName($$c(bArr[225], (short) 523, bArr[6]), true, (ClassLoader) getLevel).getMethod($$c(bArr[176], (short) 335, bArr[225]), Integer.TYPE).invoke(obj, objArr)).intValue();
            int i11 = $11;
            int i12 = (i11 & 47) + (i11 | 47);
            $10 = i12 % 128;
            if (i12 % 2 != 0) {
                int i13 = 84 / 0;
            }
            return iIntValue;
        } catch (Throwable th) {
            Throwable cause = th.getCause();
            if (cause != null) {
                throw cause;
            }
            throw th;
        }
    }

    public static Object AFInAppEventType(int i, char c, int i2) throws Throwable {
        Object obj;
        int i3 = 2 % 2;
        int i4 = $10 + 7;
        int i5 = i4 % 128;
        $11 = i5;
        if (i4 % 2 == 0) {
            obj = afErrorLogForExcManagerOnly;
            int i6 = 18 / 0;
        } else {
            obj = afErrorLogForExcManagerOnly;
        }
        int i7 = i5 + 31;
        $10 = i7 % 128;
        int i8 = i7 % 2;
        int i9 = ((i5 | 29) << 1) - (i5 ^ 29);
        $10 = i9 % 128;
        int i10 = i9 % 2;
        try {
            Object[] objArr = {Integer.valueOf(i), Character.valueOf(c), Integer.valueOf(i2)};
            byte[] bArr = $$a;
            Class<?> cls = Class.forName($$c(bArr[225], (short) 523, bArr[6]), true, (ClassLoader) getLevel);
            byte b = bArr[10];
            String str$$c = $$c(b, (short) ((b ^ 710) | (b & 710)), bArr[794]);
            Class<?> cls2 = Integer.TYPE;
            Object objInvoke = cls.getMethod(str$$c, cls2, Character.TYPE, cls2).invoke(obj, objArr);
            int i11 = $10;
            int i12 = (i11 & 43) + (i11 | 43);
            $11 = i12 % 128;
            if (i12 % 2 != 0) {
                return objInvoke;
            }
            throw null;
        } catch (Throwable th) {
            Throwable cause = th.getCause();
            if (cause != null) {
                throw cause;
            }
            throw th;
        }
    }

    public static int AFKeystoreWrapper(Object obj) throws Throwable {
        int i = 2 % 2;
        int i2 = $10;
        int i3 = ((i2 | 113) << 1) - (i2 ^ 113);
        $11 = i3 % 128;
        int i4 = i3 % 2;
        Object obj2 = afErrorLogForExcManagerOnly;
        int i5 = i2 + 91;
        $11 = i5 % 128;
        int i6 = i5 % 2;
        int i7 = i2 + 63;
        $11 = i7 % 128;
        int i8 = i7 % 2;
        try {
            Object[] objArr = {obj};
            byte[] bArr = $$a;
            Class<?> cls = Class.forName($$c(bArr[225], (short) 523, bArr[6]), true, (ClassLoader) getLevel);
            byte b = bArr[10];
            int iIntValue = ((Integer) cls.getMethod($$c(b, (short) ((b ^ 710) | (b & 710)), bArr[794]), Object.class).invoke(obj2, objArr)).intValue();
            int i9 = $11;
            int i10 = (i9 ^ 57) + ((i9 & 57) << 1);
            $10 = i10 % 128;
            int i11 = i10 % 2;
            return iIntValue;
        } catch (Throwable th) {
            Throwable cause = th.getCause();
            if (cause != null) {
                throw cause;
            }
            throw th;
        }
    }

    static void init$0() {
        int i;
        int i2 = 2 % 2;
        int i3 = $11 + 23;
        $10 = i3 % 128;
        if (i3 % 2 != 0) {
            byte[] bArr = new byte[982];
            System.arraycopy("1_£KÍõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>Ì8\nì\u00164ÆûBíÎ\u0010\u0001\u0002ô\u000e\u0002\u001cÜÿü\u0002\"à\u0003\u000e\u0005õ\nì\u00164Ã\fô\b:ÜÛ\u0007\u0000\u0010ùï\u0004\u0001\u000eøû4Ò\u0001\u0005\u0004\u0007\u0003î\fû\u0002\nì\u00164Á\u0006ûBíÊ\u0006\u0010$Î\u0010\u0001\u0002ôô\u000bó\u0004\u0007\u00067ÀýFíÎ\rþ\tAÏ\u0012ô\u0000\u000bû\u0002\nì\u00164ÆûBíÊ\u0006\u0010%Ð\u0001\u0012é1Üÿü\u0002\"à\u0003\u000e\u0005õ\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@æÜ\"éùÿþú6àî6Ø\fï\u0001(Þ\u000fþ\u0000ô\u000e\u0005þ\u001fÒ\n\u0001ôõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>ïüä3Ì\u0014\u0010ú(«\u0003ò/Þþ\bó0Üøü\u000b\u0000î*ê\u0006\nö\u0010\u0003ò2ãÿü\u0004\"Üø\u000e\u0005þ\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@ëàî3Þþ\bõ\f\u0000\u0007ý\u0003ÿü\u0004\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@íâï\u000f\"àî6Ø\fï\u0001(Þ\u000fþ\u0000ô\u0003ò2Õ\f\u0000#ãÿü\u0004\"Üøû\f\füþÜ.Ò\u0001,Ð\u0012øû!Ü\n\f\u0016ú\u0018ù»\u0000P»\u0006ö\u0001\u000b\u0002ÿùùTµ\b\u0000óLõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>ïüä3É\u0017\u0010ú(\u0001\u0016û\u0017ù\u0016ý\u0015ù\u0016ù\u0019ù\nì\u00164Ã\fô\b:ìØ\fï\u0001(Þ\u000fþ\u0000ôô\u000bó\u0004\u0007\u00067Îò\u0001CîÒ\u0001*Üþ\u000e\u0002öú\u000fò#î\u0005þ\u0016â\u0003ô\nì\u00164ÆûBëäî\u0014\u0019Üÿü\u0002\"à\u0003\u000e\u0005õþ\u000fþ!àî\nì\u00164ÆûBíÊ\u0006\u0010%Ð\u0001\u0012é+Û\u0002\u0005ü\u0002\"à\u0003\u000e\u0005õõ\u0003@Îò\u0001þ\u000eûô\u0015ôEÆüû\u0010ô\u0005\u000eö?îüä3É\u0017\u0010ú(\u0001\t\u0003ú\u0003ò2Ø\fï\u0001(Þ\u000fþ\u0000ôÌ\u0004î\u00143Ì\u0004î\u00143\u0000ú\bò\u0010\u0003ò/\u0003\u0010úí\u0017üû\u000eî\fô\u0012\u001aä\bñ\u0012ðú*ðî\r$Ú\bù\tøû\u0002øþý\u000fÍõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>Í7\nì\u00164ÆûB»\bþ\rüø\u0003ò%ß\u0004\u0000\fôÿü\u0003ò4àð\u0005\u0004ø\u0002\u0010\u0016ðî\rô\u000bó\u0004\u0007\u00067Îò\u0001Cîßð\fô\u000eöü&í÷\u000e\u0005þ\u0016öø\u0011\u0017ê\nì\u00164ÆûBéÞþ\b\u0017Û\u0002\u0005ü\u0002\"à\u0003\u000e\u0005õ\u0003ô\u0018æ\nö\u0010\nì\u00164ÆûBæû\u000bÎ\u0016ÿöý\fû\u0002ô\u000bó\u0004\u0007\u00067»\u0010î\u0005GÛðî\u0005 â\fþú\u0010î\r\u001dä÷\u0000\u0003ò,Ü\u0006ö\f\tö,Ò\u0001\u0005\u0004\u0007\u0003î\fû\u0002\nì\u00164ÆûBéÞþ\bõ\u0003þ\u0005\bî%æ*Õ\u0012ÿð\fû\u0002\u0016þ\u0014ùô\u000bó\u0004\u0007\u00067º\u0002\fþ?ÛÜ\n\f\u0002\u000fööø\u0011ï\u0004\u0001\u000eøû!ìý\t\u0019åþ\u0001\u0004÷\nì\u00164ÆûBéÞþ\b\"àó\u0011ò\núý\u0006þ\u0006.Ê\u0006\u0010%Ð\u0001\u0012éþ\u000fþ\"Ø\fï\u0001õ\u0003@Îò\u0001þ\u000eûô\u0015ô\u0006\u0012ò\u000eî\fô\u0012\u001aä\bñ\u0012ðú6Üø\u000e\u0003ð\u0006þ\n\u0005ó\nì\u00164ÆûBæÜÿü\u0002\"à\u0003\u000e\u0005õ".getBytes("ISO-8859-1"), 0, bArr, 0, 982);
            $$a = bArr;
            i = 125;
        } else {
            byte[] bArr2 = new byte[982];
            System.arraycopy("1_£KÍõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>Ì8\nì\u00164ÆûBíÎ\u0010\u0001\u0002ô\u000e\u0002\u001cÜÿü\u0002\"à\u0003\u000e\u0005õ\nì\u00164Ã\fô\b:ÜÛ\u0007\u0000\u0010ùï\u0004\u0001\u000eøû4Ò\u0001\u0005\u0004\u0007\u0003î\fû\u0002\nì\u00164Á\u0006ûBíÊ\u0006\u0010$Î\u0010\u0001\u0002ôô\u000bó\u0004\u0007\u00067ÀýFíÎ\rþ\tAÏ\u0012ô\u0000\u000bû\u0002\nì\u00164ÆûBíÊ\u0006\u0010%Ð\u0001\u0012é1Üÿü\u0002\"à\u0003\u000e\u0005õ\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@æÜ\"éùÿþú6àî6Ø\fï\u0001(Þ\u000fþ\u0000ô\u000e\u0005þ\u001fÒ\n\u0001ôõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>ïüä3Ì\u0014\u0010ú(«\u0003ò/Þþ\bó0Üøü\u000b\u0000î*ê\u0006\nö\u0010\u0003ò2ãÿü\u0004\"Üø\u000e\u0005þ\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@ëàî3Þþ\bõ\f\u0000\u0007ý\u0003ÿü\u0004\u0004ö÷\u000eÿ>¼û\u0007\u0000\u0010ù@íâï\u000f\"àî6Ø\fï\u0001(Þ\u000fþ\u0000ô\u0003ò2Õ\f\u0000#ãÿü\u0004\"Üøû\f\füþÜ.Ò\u0001,Ð\u0012øû!Ü\n\f\u0016ú\u0018ù»\u0000P»\u0006ö\u0001\u000b\u0002ÿùùTµ\b\u0000óLõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>ïüä3É\u0017\u0010ú(\u0001\u0016û\u0017ù\u0016ý\u0015ù\u0016ù\u0019ù\nì\u00164Ã\fô\b:ìØ\fï\u0001(Þ\u000fþ\u0000ôô\u000bó\u0004\u0007\u00067Îò\u0001CîÒ\u0001*Üþ\u000e\u0002öú\u000fò#î\u0005þ\u0016â\u0003ô\nì\u00164ÆûBëäî\u0014\u0019Üÿü\u0002\"à\u0003\u000e\u0005õþ\u000fþ!àî\nì\u00164ÆûBíÊ\u0006\u0010%Ð\u0001\u0012é+Û\u0002\u0005ü\u0002\"à\u0003\u000e\u0005õõ\u0003@Îò\u0001þ\u000eûô\u0015ôEÆüû\u0010ô\u0005\u000eö?îüä3É\u0017\u0010ú(\u0001\t\u0003ú\u0003ò2Ø\fï\u0001(Þ\u000fþ\u0000ôÌ\u0004î\u00143Ì\u0004î\u00143\u0000ú\bò\u0010\u0003ò/\u0003\u0010úí\u0017üû\u000eî\fô\u0012\u001aä\bñ\u0012ðú*ðî\r$Ú\bù\tøû\u0002øþý\u000fÍõ\u0003?Ïò\u0001þ\u000eûô\u0015ôDÇüû\u0010ô\u0005\u000eö>Í7\nì\u00164ÆûB»\bþ\rüø\u0003ò%ß\u0004\u0000\fôÿü\u0003ò4àð\u0005\u0004ø\u0002\u0010\u0016ðî\rô\u000bó\u0004\u0007\u00067Îò\u0001Cîßð\fô\u000eöü&í÷\u000e\u0005þ\u0016öø\u0011\u0017ê\nì\u00164ÆûBéÞþ\b\u0017Û\u0002\u0005ü\u0002\"à\u0003\u000e\u0005õ\u0003ô\u0018æ\nö\u0010\nì\u00164ÆûBæû\u000bÎ\u0016ÿöý\fû\u0002ô\u000bó\u0004\u0007\u00067»\u0010î\u0005GÛðî\u0005 â\fþú\u0010î\r\u001dä÷\u0000\u0003ò,Ü\u0006ö\f\tö,Ò\u0001\u0005\u0004\u0007\u0003î\fû\u0002\nì\u00164ÆûBéÞþ\bõ\u0003þ\u0005\bî%æ*Õ\u0012ÿð\fû\u0002\u0016þ\u0014ùô\u000bó\u0004\u0007\u00067º\u0002\fþ?ÛÜ\n\f\u0002\u000fööø\u0011ï\u0004\u0001\u000eøû!ìý\t\u0019åþ\u0001\u0004÷\nì\u00164ÆûBéÞþ\b\"àó\u0011ò\núý\u0006þ\u0006.Ê\u0006\u0010%Ð\u0001\u0012éþ\u000fþ\"Ø\fï\u0001õ\u0003@Îò\u0001þ\u000eûô\u0015ô\u0006\u0012ò\u000eî\fô\u0012\u001aä\bñ\u0012ðú6Üø\u000e\u0003ð\u0006þ\n\u0005ó\nì\u00164ÆûBæÜÿü\u0002\"à\u0003\u000e\u0005õ".getBytes("ISO-8859-1"), 0, bArr2, 0, 982);
            $$a = bArr2;
            i = 55;
        }
        $$b = i;
        int i4 = $10;
        int i5 = (i4 ^ 71) + ((i4 & 71) << 1);
        $11 = i5 % 128;
        int i6 = i5 % 2;
    }

    private AFc1fSDK() {
    }

    static {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFc1fSDK.<clinit>():void");
    }
}
