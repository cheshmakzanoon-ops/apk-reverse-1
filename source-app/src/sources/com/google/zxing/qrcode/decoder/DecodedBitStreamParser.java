package com.google.zxing.qrcode.decoder;

import com.google.zxing.DecodeHintType;
import com.google.zxing.FormatException;
import com.google.zxing.common.BitSource;
import com.google.zxing.common.CharacterSetECI;
import com.google.zxing.common.DecoderResult;
import com.google.zxing.common.StringUtils;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

final class DecodedBitStreamParser {
    private static final char[] ALPHANUMERIC_CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:".toCharArray();
    private static final int GB2312_SUBSET = 1;

    private DecodedBitStreamParser() {
    }

    static DecoderResult decode(byte[] bArr, Version version, ErrorCorrectionLevel errorCorrectionLevel, Map<DecodeHintType, ?> map) throws FormatException {
        Mode modeForBits;
        ?? r15;
        ArrayList arrayList;
        String string;
        BitSource bitSource = new BitSource(bArr);
        StringBuilder sb = new StringBuilder(50);
        int i = 1;
        ArrayList arrayList2 = new ArrayList(1);
        int i2 = -1;
        int bits = -1;
        ?? r16 = 0;
        CharacterSetECI characterSetECIByValue = null;
        while (true) {
            try {
                if (bitSource.available() < 4) {
                    modeForBits = Mode.TERMINATOR;
                } else {
                    modeForBits = Mode.forBits(bitSource.readBits(4));
                }
                Mode mode = modeForBits;
                ?? r17 = r16;
                switch (mode) {
                    case TERMINATOR:
                        r15 = r17;
                        if (mode == Mode.TERMINATOR) {
                            String string2 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string2, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                    case FNC1_FIRST_POSITION:
                    case FNC1_SECOND_POSITION:
                        r17 = i;
                        r15 = r17;
                        if (mode == Mode.TERMINATOR) {
                            String string3 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string3, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                    case STRUCTURED_APPEND:
                        if (bitSource.available() < 16) {
                            throw FormatException.getFormatInstance();
                        }
                        int bits2 = bitSource.readBits(8);
                        bits = bitSource.readBits(8);
                        i2 = bits2;
                        r17 = r16;
                        r15 = r17;
                        if (mode == Mode.TERMINATOR) {
                            String string4 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string4, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                        break;
                    case ECI:
                        characterSetECIByValue = CharacterSetECI.getCharacterSetECIByValue(parseECIValue(bitSource));
                        if (characterSetECIByValue == null) {
                            throw FormatException.getFormatInstance();
                        }
                        r17 = r16;
                        r15 = r17;
                        if (mode == Mode.TERMINATOR) {
                            String string5 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string5, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                        break;
                    case HANZI:
                        int bits3 = bitSource.readBits(4);
                        int bits4 = bitSource.readBits(mode.getCharacterCountBits(version));
                        r17 = r16;
                        if (bits3 == i) {
                            decodeHanziSegment(bitSource, sb, bits4);
                            r17 = r16;
                        }
                        r15 = r17;
                        if (mode == Mode.TERMINATOR) {
                            String string6 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string6, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                    default:
                        int bits5 = bitSource.readBits(mode.getCharacterCountBits(version));
                        int i3 = C10121.$SwitchMap$com$google$zxing$qrcode$decoder$Mode[mode.ordinal()];
                        if (i3 == i) {
                            decodeNumericSegment(bitSource, sb, bits5);
                            r15 = r16;
                        } else if (i3 == 2) {
                            decodeAlphanumericSegment(bitSource, sb, bits5, r16);
                            r15 = r16;
                        } else if (i3 == 3) {
                            decodeByteSegment(bitSource, sb, bits5, characterSetECIByValue, arrayList2, map);
                            r15 = r16;
                        } else if (i3 == 4) {
                            decodeKanjiSegment(bitSource, sb, bits5);
                            r17 = r16;
                            r15 = r17;
                        } else {
                            throw FormatException.getFormatInstance();
                        }
                        if (mode == Mode.TERMINATOR) {
                            String string7 = sb.toString();
                            if (arrayList2.isEmpty()) {
                                arrayList = null;
                            } else {
                                arrayList = arrayList2;
                            }
                            if (errorCorrectionLevel == null) {
                                string = null;
                            } else {
                                string = errorCorrectionLevel.toString();
                            }
                            return new DecoderResult(bArr, string7, arrayList, string, i2, bits);
                        }
                        i = 1;
                        r16 = r15;
                        break;
                }
            } catch (IllegalArgumentException unused) {
                throw FormatException.getFormatInstance();
            }
        }
    }

    private static void decodeHanziSegment(BitSource bitSource, StringBuilder sb, int i) throws FormatException {
        if (i * 13 > bitSource.available()) {
            throw FormatException.getFormatInstance();
        }
        byte[] bArr = new byte[i * 2];
        int i2 = 0;
        while (i > 0) {
            int bits = bitSource.readBits(13);
            int i3 = (bits % 96) | ((bits / 96) << 8);
            int i4 = i3 + (i3 < 959 ? 41377 : 42657);
            bArr[i2] = (byte) (i4 >> 8);
            bArr[i2 + 1] = (byte) i4;
            i2 += 2;
            i--;
        }
        try {
            sb.append(new String(bArr, StringUtils.GB2312));
        } catch (UnsupportedEncodingException unused) {
            throw FormatException.getFormatInstance();
        }
    }

    private static void decodeKanjiSegment(BitSource bitSource, StringBuilder sb, int i) throws FormatException {
        if (i * 13 > bitSource.available()) {
            throw FormatException.getFormatInstance();
        }
        byte[] bArr = new byte[i * 2];
        int i2 = 0;
        while (i > 0) {
            int bits = bitSource.readBits(13);
            int i3 = (bits % 192) | ((bits / 192) << 8);
            int i4 = i3 + (i3 < 7936 ? 33088 : 49472);
            bArr[i2] = (byte) (i4 >> 8);
            bArr[i2 + 1] = (byte) i4;
            i2 += 2;
            i--;
        }
        try {
            sb.append(new String(bArr, StringUtils.SHIFT_JIS));
        } catch (UnsupportedEncodingException unused) {
            throw FormatException.getFormatInstance();
        }
    }

    private static void decodeByteSegment(BitSource bitSource, StringBuilder sb, int i, CharacterSetECI characterSetECI, Collection<byte[]> collection, Map<DecodeHintType, ?> map) throws FormatException {
        String strName;
        if ((i << 3) > bitSource.available()) {
            throw FormatException.getFormatInstance();
        }
        byte[] bArr = new byte[i];
        for (int i2 = 0; i2 < i; i2++) {
            bArr[i2] = (byte) bitSource.readBits(8);
        }
        if (characterSetECI == null) {
            strName = StringUtils.guessEncoding(bArr, map);
        } else {
            strName = characterSetECI.name();
        }
        try {
            sb.append(new String(bArr, strName));
            collection.add(bArr);
        } catch (UnsupportedEncodingException unused) {
            throw FormatException.getFormatInstance();
        }
    }

    private static char toAlphaNumericChar(int i) throws FormatException {
        char[] cArr = ALPHANUMERIC_CHARS;
        if (i >= cArr.length) {
            throw FormatException.getFormatInstance();
        }
        return cArr[i];
    }

    private static void decodeAlphanumericSegment(BitSource bitSource, StringBuilder sb, int i, boolean z) throws FormatException {
        while (i > 1) {
            if (bitSource.available() < 11) {
                throw FormatException.getFormatInstance();
            }
            int bits = bitSource.readBits(11);
            sb.append(toAlphaNumericChar(bits / 45));
            sb.append(toAlphaNumericChar(bits % 45));
            i -= 2;
        }
        if (i == 1) {
            if (bitSource.available() < 6) {
                throw FormatException.getFormatInstance();
            }
            sb.append(toAlphaNumericChar(bitSource.readBits(6)));
        }
        if (z) {
            for (int length = sb.length(); length < sb.length(); length++) {
                if (sb.charAt(length) == '%') {
                    if (length < sb.length() - 1) {
                        int i2 = length + 1;
                        if (sb.charAt(i2) == '%') {
                            sb.deleteCharAt(i2);
                        } else {
                            sb.setCharAt(length, (char) 29);
                        }
                    } else {
                        sb.setCharAt(length, (char) 29);
                    }
                }
            }
        }
    }

    private static void decodeNumericSegment(BitSource bitSource, StringBuilder sb, int i) throws FormatException {
        while (i >= 3) {
            if (bitSource.available() < 10) {
                throw FormatException.getFormatInstance();
            }
            int bits = bitSource.readBits(10);
            if (bits >= 1000) {
                throw FormatException.getFormatInstance();
            }
            sb.append(toAlphaNumericChar(bits / 100));
            sb.append(toAlphaNumericChar((bits / 10) % 10));
            sb.append(toAlphaNumericChar(bits % 10));
            i -= 3;
        }
        if (i == 2) {
            if (bitSource.available() < 7) {
                throw FormatException.getFormatInstance();
            }
            int bits2 = bitSource.readBits(7);
            if (bits2 >= 100) {
                throw FormatException.getFormatInstance();
            }
            sb.append(toAlphaNumericChar(bits2 / 10));
            sb.append(toAlphaNumericChar(bits2 % 10));
            return;
        }
        if (i == 1) {
            if (bitSource.available() < 4) {
                throw FormatException.getFormatInstance();
            }
            int bits3 = bitSource.readBits(4);
            if (bits3 >= 10) {
                throw FormatException.getFormatInstance();
            }
            sb.append(toAlphaNumericChar(bits3));
        }
    }

    private static int parseECIValue(BitSource bitSource) throws FormatException {
        int bits = bitSource.readBits(8);
        if ((bits & 128) == 0) {
            return bits & 127;
        }
        if ((bits & 192) == 128) {
            return bitSource.readBits(8) | ((bits & 63) << 8);
        }
        if ((bits & 224) == 192) {
            return bitSource.readBits(16) | ((bits & 31) << 16);
        }
        throw FormatException.getFormatInstance();
    }
}
