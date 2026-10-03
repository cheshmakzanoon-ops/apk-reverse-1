package com.appsflyer.internal;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import java.util.Map;

public class AFa1zSDK {
    public static final byte[] $$a = null;
    public static final int $$b = 0;
    private static int $10 = 0;
    private static int $11 = 1;
    private static byte[] AFLogger$LogLevel;
    private static final Map<String, Object> AFVersionDeclaration;
    private static int AppsFlyer2dXConversionCallback;
    public static final Map<Integer, Object> afDebugLog;
    private static Object afErrorLogForExcManagerOnly;
    private static Object afLogForce;
    private static byte[] getLevel;
    private static int onInstallConversionFailureNative;

    private static java.lang.String $$c(short r7, short r8, int r9) {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFa1zSDK.$$c(short, short, int):java.lang.String");
    }

    public static int AFInAppEventType(int i) throws Throwable {
        int i2 = 2 % 2;
        int i3 = $10;
        int i4 = (i3 & 63) + (i3 | 63);
        int i5 = i4 % 128;
        $11 = i5;
        int i6 = i4 % 2;
        Object obj = afLogForce;
        int i7 = i5 + 121;
        $10 = i7 % 128;
        int i8 = i7 % 2;
        int i9 = ((i5 | TypedValues.TYPE_TARGET) << 1) - (i5 ^ TypedValues.TYPE_TARGET);
        $10 = i9 % 128;
        int i10 = i9 % 2;
        try {
            Object[] objArr = {Integer.valueOf(i)};
            byte[] bArr = $$a;
            byte b = bArr[11];
            int iIntValue = ((Integer) Class.forName($$c(b, (short) ((b ^ 808) | (b & 808)), bArr[93]), true, (ClassLoader) afErrorLogForExcManagerOnly).getMethod($$c((byte) (-bArr[86]), (short) 329, bArr[131]), Integer.TYPE).invoke(obj, objArr)).intValue();
            int i11 = $11;
            int i12 = (i11 ^ 89) + ((i11 & 89) << 1);
            $10 = i12 % 128;
            int i13 = i12 % 2;
            return iIntValue;
        } catch (Throwable th) {
            Throwable cause = th.getCause();
            if (cause != null) {
                throw cause;
            }
            throw th;
        }
    }

    public static int AFInAppEventType(Object obj) throws Throwable {
        int i = 2 % 2;
        int i2 = $10;
        int i3 = ((i2 | 107) << 1) - (i2 ^ 107);
        int i4 = i3 % 128;
        $11 = i4;
        int i5 = i3 % 2;
        Object obj2 = afLogForce;
        int i6 = (i4 ^ 125) + ((i4 & 125) << 1);
        int i7 = i6 % 128;
        $10 = i7;
        int i8 = i6 % 2;
        int i9 = ((i7 | 95) << 1) - (i7 ^ 95);
        $11 = i9 % 128;
        int i10 = i9 % 2;
        try {
            Object[] objArr = {obj};
            byte[] bArr = $$a;
            byte b = bArr[11];
            return ((Integer) Class.forName($$c(b, (short) ((b ^ 808) | (b & 808)), bArr[93]), true, (ClassLoader) afErrorLogForExcManagerOnly).getMethod($$c(bArr[42], (short) 698, bArr[442]), Object.class).invoke(obj2, objArr)).intValue();
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
        int i3 = $10;
        int i4 = (i3 ^ 11) + ((i3 & 11) << 1);
        $11 = i4 % 128;
        if (i4 % 2 == 0) {
            byte[] bArr = new byte[1008];
            System.arraycopy("\u000fäùN÷\u0015ëÍ;\u0006¿\u00143ñ\u0000ÿ\róÿå%\u0002\u0005ÿß!þóü\f÷\u0015ëÍ>õ\rùÇ%&ú\u0001ñ\b\u0012ý\u0000ó\t\u0006Í/\u0000üýúþ\u0013õ\u0006ÿ÷\u0015ëÍ@û\u0006¿\u00147ûñÝ3ñ\u0000ÿ\r\rö\u000eýúûÊA\u0004»\u00143ô\u0003øÀ2ï\r\u0001ö\u0006ÿ÷\u0015ëÍ;\u0006¿\u00147ûñÜ1\u0000ï\u0018Ð%\u0002\u0005ÿß!þóü\fý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u001b%ß\u0018\b\u0002\u0003\u0007Ë!\u0013Ë)õ\u0012\u0000Ù#ò\u0003\u0001\róü\u0003â/÷\u0000\r\u0001\u0003ûô\u000bý\u0011ëè\u0018\u000fíò!í\u0013ñþ\u000fÒ#\u0003ù\u000eÑ%\t\u0005ö\u0001\u0013×\u0017û÷\u000bñþ\u000fÏ\u001e\u0002\u0005ýß%\tóü\u0003ý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u0016!\u0013Î#\u0003ù\fõ\u0001ú\u0004þ\u0002\u0005ýý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u0014\u001f\u0012òß!\u0013Ë)õ\u0012\u0000Ù#ò\u0003\u0001\rþ\u000fÏ,õ\u0001Þ\u001e\u0002\u0005ýß%\t\u0006õõë\u0007é\bF\u0001±Fû\u000b\u0000öÿ\u0002\b\b\u00adLù\u0001\u000eµë\u0006ê\bë\u0004ì\bë\bè\b\u0005\u0003%Ó/\u0000Õ1ï\t\u0006Ü\u0011\u0011ï\fø\u000fñ\rÜ\u0013\fø÷\u0015ëÍ>õ\rùÇ\u0015)õ\u0012\u0000Ù#ò\u0003\u0001\r\rö\u000eýúûÊ3\u000f\u0000¾\u0013/\u0000×%\u0003óÿ\u000b\u0007ò\u000fÞ\u0013ü\u0003ë\u001fþ\r4\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ3Ë÷\u0015ëÍ;\u0006¿\u0016\u001d\u0013íè%\u0002\u0005ÿß!þóü\f\u0003ò\u0003à!\u0013\rö\u000eýúûÊHóü\u0012·\u001d\u001a\u0014Ì1ï\t\u0006÷\u0015ëÍ;\u0006¿\u00147ûñÜ1\u0000ï\u0018Ö&ÿü\u0005ÿß!þóü\fë\u000b\tð\u000eøþ\u0007þ\u000fÏ)õ\u0012\u0000Ù#ò\u0003\u0001\r5ý\u0013íÎ5ý\u0013íÎ\u0001\u0007ù\u000fñþ\u000fÒþñ\u0007\u0014ê\u0005\u0006ó\u0013õ\rïç\u001dù\u0010ï\u0011\u0007×\u0011\u0013ôÝ'ù\bø\t\u0006ÿ\t\u0003\u0004ò\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ\u0012\u0005\u001bÐIÙñ\u0007ÙS4\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ2Ì÷\u0015ëÍ;\u0006¿Fù\u0003ô\u0005\tþ\u000fÜ\"ý\u0001õ\r\u0002\u0005þ\u000fÍ!\u0011üý\tÿñë\u0011\u0013ô\rö\u000eýúûÊ3\u000f\u0000¾\u0013\"\u0011õ\ró\u000b\u0005Û\u0014\nóü\u0003ë\u000b\tðê\u0017÷\u0015ëÍ;\u0006¿\u0018#\u0003ùê&ÿü\u0005ÿß!þóü\fþ\ré\u001b÷\u000bñ÷\u0015ëÍ;\u0006¿\u001b\u0006ö3ë\u0002\u000b\u0004õ\u0006ÿ\rö\u000eýúûÊFñ\u0013üº&\u0011\u0013üá\u001fõ\u0003\u0007þ\u000fÛ\u0017\u0000\rò\u000fÍ%\u000eñ\rñ\u0013ôä\u001d\n\u0001þ\u000fÕ%û\u000bõø\u000bÕ/\u0000üýúþ\u0013õ\u0006ÿ÷\u0015ëÍ;\u0006¿\u0018#\u0003ùë\u0003í\b\fþÁ3\u000f\u0000\u0003ó\u0006\rì\r¼;\u0005\u0006ñ\rüó\u000bÂ\u0013\u0005\u001bÐEÝñ\u0007Ù\u0000\u0012ý\u0000ó\t\u0006à\u0015\u0004øè\u001c\u0003\u0000ý\n÷\u0015ëÍ;\u0006¿\u0018#\u0003ùß!\u000eð\u000f÷\u0007\u0004û\u0003ûÓ7ûñÜ1\u0000ï\u0018\u0003ò\u0003ß)õ\u0012\u0000\fþÁ3\u000f\u0000\u0003ó\u0006\rì\rûï\u000f\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ\u0012\u0005\u001bÐEÝñ\u0007Ù\u0000ó\u0013õ\rïç\u001dù\u0010ï\u0011\u0007Ë%\tóþ\u0011û\u0003÷ü\u000e÷\u0015ëÍ;\u0006¿\u001b%\u0002\u0005ÿß!þóü\f".getBytes("ISO-8859-1"), 0, bArr, 0, 1008);
            $$a = bArr;
            i = 43;
        } else {
            byte[] bArr2 = new byte[1008];
            System.arraycopy("\u000fäùN÷\u0015ëÍ;\u0006¿\u00143ñ\u0000ÿ\róÿå%\u0002\u0005ÿß!þóü\f÷\u0015ëÍ>õ\rùÇ%&ú\u0001ñ\b\u0012ý\u0000ó\t\u0006Í/\u0000üýúþ\u0013õ\u0006ÿ÷\u0015ëÍ@û\u0006¿\u00147ûñÝ3ñ\u0000ÿ\r\rö\u000eýúûÊA\u0004»\u00143ô\u0003øÀ2ï\r\u0001ö\u0006ÿ÷\u0015ëÍ;\u0006¿\u00147ûñÜ1\u0000ï\u0018Ð%\u0002\u0005ÿß!þóü\fý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u001b%ß\u0018\b\u0002\u0003\u0007Ë!\u0013Ë)õ\u0012\u0000Ù#ò\u0003\u0001\róü\u0003â/÷\u0000\r\u0001\u0003ûô\u000bý\u0011ëè\u0018\u000fíò!í\u0013ñþ\u000fÒ#\u0003ù\u000eÑ%\t\u0005ö\u0001\u0013×\u0017û÷\u000bñþ\u000fÏ\u001e\u0002\u0005ýß%\tóü\u0003ý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u0016!\u0013Î#\u0003ù\fõ\u0001ú\u0004þ\u0002\u0005ýý\u000b\nó\u0002ÃE\u0006ú\u0001ñ\bÁ\u0014\u001f\u0012òß!\u0013Ë)õ\u0012\u0000Ù#ò\u0003\u0001\rþ\u000fÏ,õ\u0001Þ\u001e\u0002\u0005ýß%\t\u0006õõë\u0007é\bF\u0001±Fû\u000b\u0000öÿ\u0002\b\b\u00adLù\u0001\u000eµë\u0006ê\bë\u0004ì\bë\bè\b\u0005\u0003%Ó/\u0000Õ1ï\t\u0006Ü\u0011\u0011ï\fø\u000fñ\rÜ\u0013\fø÷\u0015ëÍ>õ\rùÇ\u0015)õ\u0012\u0000Ù#ò\u0003\u0001\r\rö\u000eýúûÊ3\u000f\u0000¾\u0013/\u0000×%\u0003óÿ\u000b\u0007ò\u000fÞ\u0013ü\u0003ë\u001fþ\r4\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ3Ë÷\u0015ëÍ;\u0006¿\u0016\u001d\u0013íè%\u0002\u0005ÿß!þóü\f\u0003ò\u0003à!\u0013\rö\u000eýúûÊHóü\u0012·\u001d\u001a\u0014Ì1ï\t\u0006÷\u0015ëÍ;\u0006¿\u00147ûñÜ1\u0000ï\u0018Ö&ÿü\u0005ÿß!þóü\fë\u000b\tð\u000eøþ\u0007þ\u000fÏ)õ\u0012\u0000Ù#ò\u0003\u0001\r5ý\u0013íÎ5ý\u0013íÎ\u0001\u0007ù\u000fñþ\u000fÒþñ\u0007\u0014ê\u0005\u0006ó\u0013õ\rïç\u001dù\u0010ï\u0011\u0007×\u0011\u0013ôÝ'ù\bø\t\u0006ÿ\t\u0003\u0004ò\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ\u0012\u0005\u001bÐIÙñ\u0007ÙS4\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ2Ì÷\u0015ëÍ;\u0006¿Fù\u0003ô\u0005\tþ\u000fÜ\"ý\u0001õ\r\u0002\u0005þ\u000fÍ!\u0011üý\tÿñë\u0011\u0013ô\rö\u000eýúûÊ3\u000f\u0000¾\u0013\"\u0011õ\ró\u000b\u0005Û\u0014\nóü\u0003ë\u000b\tðê\u0017÷\u0015ëÍ;\u0006¿\u0018#\u0003ùê&ÿü\u0005ÿß!þóü\fþ\ré\u001b÷\u000bñ÷\u0015ëÍ;\u0006¿\u001b\u0006ö3ë\u0002\u000b\u0004õ\u0006ÿ\rö\u000eýúûÊFñ\u0013üº&\u0011\u0013üá\u001fõ\u0003\u0007þ\u000fÛ\u0017\u0000\rò\u000fÍ%\u000eñ\rñ\u0013ôä\u001d\n\u0001þ\u000fÕ%û\u000bõø\u000bÕ/\u0000üýúþ\u0013õ\u0006ÿ÷\u0015ëÍ;\u0006¿\u0018#\u0003ùë\u0003í\b\fþÁ3\u000f\u0000\u0003ó\u0006\rì\r¼;\u0005\u0006ñ\rüó\u000bÂ\u0013\u0005\u001bÐEÝñ\u0007Ù\u0000\u0012ý\u0000ó\t\u0006à\u0015\u0004øè\u001c\u0003\u0000ý\n÷\u0015ëÍ;\u0006¿\u0018#\u0003ùß!\u000eð\u000f÷\u0007\u0004û\u0003ûÓ7ûñÜ1\u0000ï\u0018\u0003ò\u0003ß)õ\u0012\u0000\fþÁ3\u000f\u0000\u0003ó\u0006\rì\rûï\u000f\fþÂ2\u000f\u0000\u0003ó\u0006\rì\r½:\u0005\u0006ñ\rüó\u000bÃ\u0012\u0005\u001bÐEÝñ\u0007Ù\u0000ó\u0013õ\rïç\u001dù\u0010ï\u0011\u0007Ë%\tóþ\u0011û\u0003÷ü\u000e÷\u0015ëÍ;\u0006¿\u001b%\u0002\u0005ÿß!þóü\f".getBytes("ISO-8859-1"), 0, bArr2, 0, 1008);
            $$a = bArr2;
            i = 36;
        }
        $$b = i;
    }

    public static Object valueOf(int i, char c, int i2) throws Throwable {
        Object obj;
        int i3 = 2 % 2;
        int i4 = $11;
        int i5 = (i4 & 47) + (i4 | 47);
        $10 = i5 % 128;
        if (i5 % 2 != 0) {
            obj = afLogForce;
            int i6 = 21 / 0;
        } else {
            obj = afLogForce;
        }
        int i7 = i4 + 83;
        int i8 = i7 % 128;
        $10 = i8;
        int i9 = i7 % 2;
        int i10 = (i8 ^ 71) + ((i8 & 71) << 1);
        $11 = i10 % 128;
        int i11 = i10 % 2;
        try {
            Object[] objArr = {Integer.valueOf(i), Character.valueOf(c), Integer.valueOf(i2)};
            byte[] bArr = $$a;
            byte b = bArr[11];
            Class<?> cls = Class.forName($$c(b, (short) ((b ^ 808) | (b & 808)), bArr[93]), true, (ClassLoader) afErrorLogForExcManagerOnly);
            byte b2 = bArr[42];
            String str$$c = $$c(b2, (short) ((b2 ^ 504) | (b2 & 504)), bArr[213]);
            Class<?> cls2 = Integer.TYPE;
            Object objInvoke = cls.getMethod(str$$c, cls2, Character.TYPE, cls2).invoke(obj, objArr);
            int i12 = $11 + 29;
            $10 = i12 % 128;
            if (i12 % 2 != 0) {
                int i13 = 99 / 0;
            }
            return objInvoke;
        } catch (Throwable th) {
            Throwable cause = th.getCause();
            if (cause != null) {
                throw cause;
            }
            throw th;
        }
    }

    private AFa1zSDK() {
    }

    static {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFa1zSDK.<clinit>():void");
    }
}
