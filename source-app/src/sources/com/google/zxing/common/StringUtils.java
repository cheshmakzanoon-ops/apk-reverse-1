package com.google.zxing.common;

import com.google.common.base.Ascii;
import com.google.common.primitives.SignedBytes;
import com.google.common.primitives.UnsignedBytes;
import com.google.zxing.DecodeHintType;
import java.nio.charset.Charset;
import java.util.Map;

public final class StringUtils {
    private static final boolean ASSUME_SHIFT_JIS;
    private static final String EUC_JP = "EUC_JP";
    public static final String GB2312 = "GB2312";
    private static final String ISO88591 = "ISO8859_1";
    private static final String PLATFORM_DEFAULT_ENCODING;
    public static final String SHIFT_JIS = "SJIS";
    private static final String UTF8 = "UTF8";

    static {
        String strName = Charset.defaultCharset().name();
        PLATFORM_DEFAULT_ENCODING = strName;
        ASSUME_SHIFT_JIS = SHIFT_JIS.equalsIgnoreCase(strName) || EUC_JP.equalsIgnoreCase(strName);
    }

    private StringUtils() {
    }

    public static String guessEncoding(byte[] bArr, Map<DecodeHintType, ?> map) {
        int i;
        byte[] bArr2 = bArr;
        if (map != null && map.containsKey(DecodeHintType.CHARACTER_SET)) {
            return map.get(DecodeHintType.CHARACTER_SET).toString();
        }
        int length = bArr2.length;
        boolean z = true;
        int i2 = 0;
        boolean z2 = bArr2.length > 3 && bArr2[0] == -17 && bArr2[1] == -69 && bArr2[2] == -65;
        boolean z3 = true;
        boolean z4 = true;
        int i3 = 0;
        int i4 = 0;
        int i5 = 0;
        int i6 = 0;
        int i7 = 0;
        int i8 = 0;
        int i9 = 0;
        int i10 = 0;
        int i11 = 0;
        int i12 = 0;
        int i13 = 0;
        while (i4 < length && (z || z3 || z4)) {
            byte b = bArr2[i4];
            int i14 = b & UnsignedBytes.MAX_VALUE;
            if (z4) {
                if (i5 <= 0) {
                    i = length;
                    if ((b & UnsignedBytes.MAX_POWER_OF_TWO) != 0) {
                        if ((b & SignedBytes.MAX_POWER_OF_TWO) != 0) {
                            int i15 = i5 + 1;
                            if ((b & 32) == 0) {
                                i7++;
                            } else {
                                i15 = i5 + 2;
                                if ((b & Ascii.DLE) == 0) {
                                    i8++;
                                } else {
                                    i5 += 3;
                                    if ((b & 8) == 0) {
                                        i9++;
                                    }
                                }
                            }
                            i5 = i15;
                        }
                    }
                } else if ((b & UnsignedBytes.MAX_POWER_OF_TWO) != 0) {
                    i5--;
                    i = length;
                } else {
                    i = length;
                }
                z4 = false;
            } else {
                i = length;
            }
            if (z) {
                if (i14 > 127 && i14 < 160) {
                    z = false;
                } else if (i14 > 159 && (i14 < 192 || i14 == 215 || i14 == 247)) {
                    i11++;
                }
            }
            if (z3) {
                if (i6 > 0) {
                    if (i14 < 64 || i14 == 127 || i14 > 252) {
                        z3 = false;
                    } else {
                        i6--;
                    }
                } else if (i14 == 128 || i14 == 160 || i14 > 239) {
                    z3 = false;
                } else if (i14 <= 160 || i14 >= 224) {
                    if (i14 > 127) {
                        i6++;
                        int i16 = i12 + 1;
                        if (i16 > i2) {
                            i2 = i16;
                            i12 = i2;
                        } else {
                            i12 = i16;
                        }
                    } else {
                        i12 = 0;
                    }
                    i13 = 0;
                } else {
                    i3++;
                    int i17 = i13 + 1;
                    if (i17 > i10) {
                        i10 = i17;
                        i13 = i10;
                    } else {
                        i13 = i17;
                    }
                    i12 = 0;
                }
            }
            i4++;
            bArr2 = bArr;
            length = i;
        }
        int i18 = length;
        if (z4 && i5 > 0) {
            z4 = false;
        }
        if (z3 && i6 > 0) {
            z3 = false;
        }
        if (z4 && (z2 || i7 + i8 + i9 > 0)) {
            return UTF8;
        }
        if (z3 && (ASSUME_SHIFT_JIS || i10 >= 3 || i2 >= 3)) {
            return SHIFT_JIS;
        }
        if (z && z3) {
            if ((i10 == 2 && i3 == 2) || i11 * 10 >= i18) {
                return SHIFT_JIS;
            }
            return ISO88591;
        }
        if (z) {
            return ISO88591;
        }
        if (z3) {
            return SHIFT_JIS;
        }
        if (z4) {
            return UTF8;
        }
        return PLATFORM_DEFAULT_ENCODING;
    }
}
