package androidx.compose.p002ui.graphics;

import androidx.compose.foundation.text.input.internal.PartialGapBuffer;
import androidx.compose.p002ui.graphics.colorspace.ColorModel;
import androidx.compose.p002ui.graphics.colorspace.ColorSpace;
import androidx.compose.p002ui.graphics.colorspace.ColorSpaces;
import androidx.compose.p002ui.graphics.colorspace.DoubleFunction;
import androidx.compose.p002ui.graphics.colorspace.Rgb;
import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;
import kotlin.ULong;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000F\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0013\n\u0002\u0010\u0014\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a9\u0010\u000f\u001a\u00020\u00072\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u00112\b\b\u0002\u0010\u0014\u001a\u00020\u00112\b\b\u0002\u0010\u0015\u001a\u00020\u0016H\u0007¢\u0006\u0002\u0010\u0017\u001a\u0017\u0010\u000f\u001a\u00020\u00072\b\b\u0001\u0010\u0018\u001a\u00020\u0019H\u0007¢\u0006\u0002\u0010\u001a\u001a5\u0010\u000f\u001a\u00020\u00072\b\b\u0001\u0010\u0010\u001a\u00020\u00192\b\b\u0001\u0010\u0012\u001a\u00020\u00192\b\b\u0001\u0010\u0013\u001a\u00020\u00192\b\b\u0003\u0010\u0014\u001a\u00020\u0019H\u0007¢\u0006\u0002\u0010\u001b\u001a\u0015\u0010\u000f\u001a\u00020\u00072\u0006\u0010\u0018\u001a\u00020\u001cH\u0007¢\u0006\u0002\u0010\u001d\u001a9\u0010\u001e\u001a\u00020\u00072\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u00112\b\b\u0002\u0010\u0014\u001a\u00020\u00112\b\b\u0002\u0010\u0015\u001a\u00020\u0016H\u0001¢\u0006\u0002\u0010\u0017\u001a1\u0010\u001f\u001a\u00020\u00112\u0006\u0010 \u001a\u00020\u00112\u0006\u0010!\u001a\u00020\u00112\u0006\u0010\"\u001a\u00020\u00112\u0006\u0010#\u001a\u00020\u00112\u0006\u0010$\u001a\u00020\u0011H\u0082\b\u001a,\u0010%\u001a\u00020\u00072\u0006\u0010&\u001a\u00020\u00072\u0006\u0010'\u001a\u00020\u00072\b\b\u0001\u0010(\u001a\u00020\u0011H\u0007ø\u0001\u0000¢\u0006\u0004\b)\u0010*\u001a\u001e\u0010+\u001a\u00020\u0007*\u00020\u00072\u0006\u0010,\u001a\u00020\u0007H\u0007ø\u0001\u0000¢\u0006\u0004\b-\u0010.\u001a\u0016\u0010/\u001a\u000200*\u00020\u0007H\u0003ø\u0001\u0000¢\u0006\u0004\b1\u00102\u001a\u0016\u00103\u001a\u00020\u0011*\u00020\u0007H\u0007ø\u0001\u0000¢\u0006\u0004\b4\u00105\u001a%\u00106\u001a\u00020\u0007*\u00020\u00072\f\u00107\u001a\b\u0012\u0004\u0012\u00020\u000708H\u0086\bø\u0001\u0000¢\u0006\u0004\b9\u0010:\u001a\u0016\u0010;\u001a\u00020\u0019*\u00020\u0007H\u0007ø\u0001\u0000¢\u0006\u0004\b<\u0010=\"\u0018\u0010\u0000\u001a\u00020\u00018\u0000X\u0081T¢\u0006\n\n\u0002\u0010\u0004\u0012\u0004\b\u0002\u0010\u0003\"\u001f\u0010\u0005\u001a\u00020\u0006*\u00020\u00078Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\b\u0010\t\u001a\u0004\b\n\u0010\u000b\"\u001f\u0010\f\u001a\u00020\u0006*\u00020\u00078Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\r\u0010\t\u001a\u0004\b\u000e\u0010\u000b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006>"}, d2 = {"UnspecifiedColor", "Lkotlin/ULong;", "getUnspecifiedColor$annotations", "()V", "J", "isSpecified", "", "Landroidx/compose/ui/graphics/Color;", "isSpecified-8_81llA$annotations", "(J)V", "isSpecified-8_81llA", "(J)Z", "isUnspecified", "isUnspecified-8_81llA$annotations", "isUnspecified-8_81llA", "Color", "red", "", "green", "blue", "alpha", "colorSpace", "Landroidx/compose/ui/graphics/colorspace/ColorSpace;", "(FFFFLandroidx/compose/ui/graphics/colorspace/ColorSpace;)J", "color", "", "(I)J", "(IIII)J", "", "(J)J", "UncheckedColor", "compositeComponent", "fgC", "bgC", "fgA", "bgA", "a", "lerp", "start", "stop", "fraction", "lerp-jxsXWHM", "(JJF)J", "compositeOver", "background", "compositeOver--OWjLjI", "(JJ)J", "getComponents", "", "getComponents-8_81llA", "(J)[F", "luminance", "luminance-8_81llA", "(J)F", "takeOrElse", "block", "Lkotlin/Function0;", "takeOrElse-DxMtmZc", "(JLkotlin/jvm/functions/Function0;)J", "toArgb", "toArgb-8_81llA", "(J)I", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ColorKt {
    public static final long UnspecifiedColor = 16;

    private static final float compositeComponent(float f, float f2, float f3, float f4, float f5) {
        if (f5 == 0.0f) {
            return 0.0f;
        }
        return ((f * f3) + ((f2 * f4) * (1.0f - f3))) / f5;
    }

    public static void getUnspecifiedColor$annotations() {
    }

    public static final boolean m4637isSpecified8_81llA(long j) {
        return j != 16;
    }

    public static void m4638isSpecified8_81llA$annotations(long j) {
    }

    public static final boolean m4639isUnspecified8_81llA(long j) {
        return j == 16;
    }

    public static void m4640isUnspecified8_81llA$annotations(long j) {
    }

    public static long Color$default(float f, float f2, float f3, float f4, ColorSpace colorSpace, int i, Object obj) {
        if ((i & 8) != 0) {
            f4 = 1.0f;
        }
        if ((i & 16) != 0) {
            colorSpace = ColorSpaces.INSTANCE.getSrgb();
        }
        return Color(f, f2, f3, f4, colorSpace);
    }

    public static final long Color(float f, float f2, float f3, float f4, ColorSpace colorSpace) {
        int i;
        int i2;
        int i3;
        float minValue;
        float maxValue;
        int iFloatToRawIntBits;
        int i4;
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        float minValue2;
        float maxValue2;
        int iFloatToRawIntBits2;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        int i19;
        float f5;
        if (colorSpace.getIsSrgb()) {
            float f6 = f4 < 0.0f ? 0.0f : f4;
            if (f6 > 1.0f) {
                f6 = 1.0f;
            }
            int i20 = ((int) ((f6 * 255.0f) + 0.5f)) << 24;
            float f7 = f < 0.0f ? 0.0f : f;
            if (f7 > 1.0f) {
                f7 = 1.0f;
            }
            int i21 = i20 | (((int) ((f7 * 255.0f) + 0.5f)) << 16);
            float f8 = f2 < 0.0f ? 0.0f : f2;
            if (f8 > 1.0f) {
                f8 = 1.0f;
            }
            int i22 = i21 | (((int) ((f8 * 255.0f) + 0.5f)) << 8);
            f5 = f3 >= 0.0f ? f3 : 0.0f;
            return Color.m4586constructorimpl(ULong.constructor-impl(ULong.constructor-impl(i22 | ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 255.0f) + 0.5f))) << 32));
        }
        if (!(colorSpace.getComponentCount() == 3)) {
            InlineClassHelperKt.throwIllegalArgumentException("Color only works with ColorSpaces with 3 components");
        }
        int id$ui_graphics_release = colorSpace.getId();
        if (!(id$ui_graphics_release != -1)) {
            InlineClassHelperKt.throwIllegalArgumentException("Unknown color space, please use a color space in ColorSpaces");
        }
        float minValue3 = colorSpace.getMinValue(0);
        float maxValue3 = colorSpace.getMaxValue(0);
        if (f >= minValue3) {
            minValue3 = f;
        }
        if (minValue3 <= maxValue3) {
            maxValue3 = minValue3;
        }
        int iFloatToRawIntBits3 = Float.floatToRawIntBits(maxValue3);
        int i23 = iFloatToRawIntBits3 >>> 31;
        int i24 = (iFloatToRawIntBits3 >>> 23) & PartialGapBuffer.BUF_SIZE;
        int i25 = iFloatToRawIntBits3 & 8388607;
        int i26 = Fields.RotationY;
        int i27 = 31;
        if (i24 == 255) {
            i2 = i25 != 0 ? 512 : 0;
            i = 31;
        } else {
            i = i24 - 112;
            if (i >= 31) {
                i = 49;
                i2 = 0;
            } else {
                if (i > 0) {
                    int i28 = i25 >> 13;
                    if ((iFloatToRawIntBits3 & Fields.TransformOrigin) != 0) {
                        i3 = (((i << 10) | i28) + 1) | (i23 << 15);
                    } else {
                        i2 = i28;
                    }
                    short s = (short) i3;
                    minValue = colorSpace.getMinValue(1);
                    maxValue = colorSpace.getMaxValue(1);
                    if (f2 >= minValue) {
                        minValue = f2;
                    }
                    if (minValue <= maxValue) {
                        maxValue = minValue;
                    }
                    iFloatToRawIntBits = Float.floatToRawIntBits(maxValue);
                    i4 = iFloatToRawIntBits >>> 31;
                    i5 = (iFloatToRawIntBits >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i6 = iFloatToRawIntBits & 8388607;
                    if (i5 == 255) {
                        if (i6 != 0) {
                            i9 = 512;
                        } else {
                            i9 = 0;
                        }
                        i7 = 31;
                    } else {
                        i7 = i5 - 112;
                        if (i7 >= 31) {
                            i7 = 49;
                            i9 = 0;
                        } else {
                            if (i7 <= 0) {
                                i8 = i6 >> 13;
                                if ((iFloatToRawIntBits & Fields.TransformOrigin) != 0) {
                                    i10 = (((i7 << 10) | i8) + 1) | (i4 << 15);
                                } else {
                                    i9 = i8;
                                }
                                short s2 = (short) i10;
                                minValue2 = colorSpace.getMinValue(2);
                                maxValue2 = colorSpace.getMaxValue(2);
                                if (f3 >= minValue2) {
                                    minValue2 = f3;
                                }
                                if (minValue2 <= maxValue2) {
                                    maxValue2 = minValue2;
                                }
                                iFloatToRawIntBits2 = Float.floatToRawIntBits(maxValue2);
                                i12 = iFloatToRawIntBits2 >>> 31;
                                i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                                i14 = 8388607 & iFloatToRawIntBits2;
                                if (i13 == 255) {
                                    if (i14 == 0) {
                                        i26 = 0;
                                    }
                                    i17 = i26;
                                } else {
                                    i15 = i13 - 112;
                                    if (i15 >= 31) {
                                        i27 = 49;
                                    } else {
                                        if (i15 <= 0) {
                                            i16 = i14 >> 13;
                                            if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                                i18 = (((i15 << 10) | i16) + 1) | (i12 << 15);
                                            } else {
                                                i17 = i16;
                                                i27 = i15;
                                            }
                                            short s3 = (short) i18;
                                            f5 = f4 >= 0.0f ? f4 : 0.0f;
                                            return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s) & 65535) << 48) | ((((long) s2) & 65535) << 32) | ((65535 & ((long) s3)) << 16)));
                                        }
                                        if (i15 >= -10) {
                                            i19 = (i14 | 8388608) >> (1 - i15);
                                            if ((i19 & Fields.TransformOrigin) != 0) {
                                                i19 += Fields.Shape;
                                            }
                                            i17 = i19 >> 13;
                                            i27 = 0;
                                        } else {
                                            i27 = 0;
                                        }
                                    }
                                    i17 = 0;
                                }
                                i18 = (i12 << 15) | (i27 << 10) | i17;
                                short s4 = (short) i18;
                                if (f4 >= 0.0f) {
                                }
                                return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s) & 65535) << 48) | ((((long) s2) & 65535) << 32) | ((65535 & ((long) s4)) << 16)));
                            }
                            if (i7 >= -10) {
                                i11 = (i6 | 8388608) >> (1 - i7);
                                if ((i11 & Fields.TransformOrigin) != 0) {
                                    i11 += Fields.Shape;
                                }
                                i9 = i11 >> 13;
                            } else {
                                i9 = 0;
                            }
                            i7 = 0;
                        }
                    }
                    i10 = i9 | (i4 << 15) | (i7 << 10);
                    short s5 = (short) i10;
                    minValue2 = colorSpace.getMinValue(2);
                    maxValue2 = colorSpace.getMaxValue(2);
                    if (f3 >= minValue2) {
                        minValue2 = f3;
                    }
                    if (minValue2 <= maxValue2) {
                        maxValue2 = minValue2;
                    }
                    iFloatToRawIntBits2 = Float.floatToRawIntBits(maxValue2);
                    i12 = iFloatToRawIntBits2 >>> 31;
                    i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i14 = 8388607 & iFloatToRawIntBits2;
                    if (i13 == 255) {
                        if (i14 == 0) {
                            i26 = 0;
                        }
                        i17 = i26;
                    } else {
                        i15 = i13 - 112;
                        if (i15 >= 31) {
                            i27 = 49;
                        } else {
                            if (i15 <= 0) {
                                i16 = i14 >> 13;
                                if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                    i18 = (((i15 << 10) | i16) + 1) | (i12 << 15);
                                } else {
                                    i17 = i16;
                                    i27 = i15;
                                }
                                short s6 = (short) i18;
                                if (f4 >= 0.0f) {
                                }
                                return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s) & 65535) << 48) | ((((long) s5) & 65535) << 32) | ((65535 & ((long) s6)) << 16)));
                            }
                            if (i15 >= -10) {
                                i19 = (i14 | 8388608) >> (1 - i15);
                                if ((i19 & Fields.TransformOrigin) != 0) {
                                    i19 += Fields.Shape;
                                }
                                i17 = i19 >> 13;
                                i27 = 0;
                            } else {
                                i27 = 0;
                            }
                        }
                        i17 = 0;
                    }
                    i18 = (i12 << 15) | (i27 << 10) | i17;
                    short s7 = (short) i18;
                    if (f4 >= 0.0f) {
                    }
                    return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s) & 65535) << 48) | ((((long) s5) & 65535) << 32) | ((65535 & ((long) s7)) << 16)));
                }
                if (i >= -10) {
                    int i29 = (i25 | 8388608) >> (1 - i);
                    if ((i29 & Fields.TransformOrigin) != 0) {
                        i29 += Fields.Shape;
                    }
                    i2 = i29 >> 13;
                } else {
                    i2 = 0;
                }
                i = 0;
            }
        }
        i3 = i2 | (i23 << 15) | (i << 10);
        short s8 = (short) i3;
        minValue = colorSpace.getMinValue(1);
        maxValue = colorSpace.getMaxValue(1);
        if (f2 >= minValue) {
            minValue = f2;
        }
        if (minValue <= maxValue) {
            maxValue = minValue;
        }
        iFloatToRawIntBits = Float.floatToRawIntBits(maxValue);
        i4 = iFloatToRawIntBits >>> 31;
        i5 = (iFloatToRawIntBits >>> 23) & PartialGapBuffer.BUF_SIZE;
        i6 = iFloatToRawIntBits & 8388607;
        if (i5 == 255) {
            if (i6 != 0) {
                i9 = 512;
            } else {
                i9 = 0;
            }
            i7 = 31;
        } else {
            i7 = i5 - 112;
            if (i7 >= 31) {
                i7 = 49;
                i9 = 0;
            } else {
                if (i7 <= 0) {
                    i8 = i6 >> 13;
                    if ((iFloatToRawIntBits & Fields.TransformOrigin) != 0) {
                        i10 = (((i7 << 10) | i8) + 1) | (i4 << 15);
                    } else {
                        i9 = i8;
                    }
                    short s9 = (short) i10;
                    minValue2 = colorSpace.getMinValue(2);
                    maxValue2 = colorSpace.getMaxValue(2);
                    if (f3 >= minValue2) {
                        minValue2 = f3;
                    }
                    if (minValue2 <= maxValue2) {
                        maxValue2 = minValue2;
                    }
                    iFloatToRawIntBits2 = Float.floatToRawIntBits(maxValue2);
                    i12 = iFloatToRawIntBits2 >>> 31;
                    i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i14 = 8388607 & iFloatToRawIntBits2;
                    if (i13 == 255) {
                        if (i14 == 0) {
                            i26 = 0;
                        }
                        i17 = i26;
                    } else {
                        i15 = i13 - 112;
                        if (i15 >= 31) {
                            i27 = 49;
                        } else {
                            if (i15 <= 0) {
                                i16 = i14 >> 13;
                                if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                    i18 = (((i15 << 10) | i16) + 1) | (i12 << 15);
                                } else {
                                    i17 = i16;
                                    i27 = i15;
                                }
                                short s10 = (short) i18;
                                if (f4 >= 0.0f) {
                                }
                                return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s8) & 65535) << 48) | ((((long) s9) & 65535) << 32) | ((65535 & ((long) s10)) << 16)));
                            }
                            if (i15 >= -10) {
                                i19 = (i14 | 8388608) >> (1 - i15);
                                if ((i19 & Fields.TransformOrigin) != 0) {
                                    i19 += Fields.Shape;
                                }
                                i17 = i19 >> 13;
                                i27 = 0;
                            } else {
                                i27 = 0;
                            }
                        }
                        i17 = 0;
                    }
                    i18 = (i12 << 15) | (i27 << 10) | i17;
                    short s11 = (short) i18;
                    if (f4 >= 0.0f) {
                    }
                    return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s8) & 65535) << 48) | ((((long) s9) & 65535) << 32) | ((65535 & ((long) s11)) << 16)));
                }
                if (i7 >= -10) {
                    i11 = (i6 | 8388608) >> (1 - i7);
                    if ((i11 & Fields.TransformOrigin) != 0) {
                        i11 += Fields.Shape;
                    }
                    i9 = i11 >> 13;
                } else {
                    i9 = 0;
                }
                i7 = 0;
            }
        }
        i10 = i9 | (i4 << 15) | (i7 << 10);
        short s12 = (short) i10;
        minValue2 = colorSpace.getMinValue(2);
        maxValue2 = colorSpace.getMaxValue(2);
        if (f3 >= minValue2) {
            minValue2 = f3;
        }
        if (minValue2 <= maxValue2) {
            maxValue2 = minValue2;
        }
        iFloatToRawIntBits2 = Float.floatToRawIntBits(maxValue2);
        i12 = iFloatToRawIntBits2 >>> 31;
        i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
        i14 = 8388607 & iFloatToRawIntBits2;
        if (i13 == 255) {
            if (i14 == 0) {
                i26 = 0;
            }
            i17 = i26;
        } else {
            i15 = i13 - 112;
            if (i15 >= 31) {
                i27 = 49;
            } else {
                if (i15 <= 0) {
                    i16 = i14 >> 13;
                    if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                        i18 = (((i15 << 10) | i16) + 1) | (i12 << 15);
                    } else {
                        i17 = i16;
                        i27 = i15;
                    }
                    short s13 = (short) i18;
                    if (f4 >= 0.0f) {
                    }
                    return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s8) & 65535) << 48) | ((((long) s12) & 65535) << 32) | ((65535 & ((long) s13)) << 16)));
                }
                if (i15 >= -10) {
                    i19 = (i14 | 8388608) >> (1 - i15);
                    if ((i19 & Fields.TransformOrigin) != 0) {
                        i19 += Fields.Shape;
                    }
                    i17 = i19 >> 13;
                    i27 = 0;
                } else {
                    i27 = 0;
                }
            }
            i17 = 0;
        }
        i18 = (i12 << 15) | (i27 << 10) | i17;
        short s14 = (short) i18;
        if (f4 >= 0.0f) {
        }
        return Color.m4586constructorimpl(ULong.constructor-impl((((long) id$ui_graphics_release) & 63) | ((((long) ((int) (((f5 <= 1.0f ? f5 : 1.0f) * 1023.0f) + 0.5f))) & 1023) << 6) | ((((long) s8) & 65535) << 48) | ((((long) s12) & 65535) << 32) | ((65535 & ((long) s14)) << 16)));
    }

    public static long UncheckedColor$default(float f, float f2, float f3, float f4, ColorSpace colorSpace, int i, Object obj) {
        if ((i & 8) != 0) {
            f4 = 1.0f;
        }
        if ((i & 16) != 0) {
            colorSpace = ColorSpaces.INSTANCE.getSrgb();
        }
        return UncheckedColor(f, f2, f3, f4, colorSpace);
    }

    public static final long UncheckedColor(float f, float f2, float f3, float f4, ColorSpace colorSpace) {
        int i;
        int i2;
        int i3;
        int iFloatToRawIntBits;
        int i4;
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int iFloatToRawIntBits2;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        if (colorSpace.getIsSrgb()) {
            return Color.m4586constructorimpl(ULong.constructor-impl(ULong.constructor-impl((((((int) ((f4 * 255.0f) + 0.5f)) << 24) | (((int) ((f * 255.0f) + 0.5f)) << 16)) | (((int) ((f2 * 255.0f) + 0.5f)) << 8)) | ((int) ((255.0f * f3) + 0.5f))) << 32));
        }
        int iFloatToRawIntBits3 = Float.floatToRawIntBits(f);
        int i19 = iFloatToRawIntBits3 >>> 31;
        int i20 = (iFloatToRawIntBits3 >>> 23) & PartialGapBuffer.BUF_SIZE;
        int i21 = iFloatToRawIntBits3 & 8388607;
        int i22 = 49;
        int i23 = 0;
        if (i20 == 255) {
            i2 = i21 != 0 ? Fields.RotationY : 0;
            i = 31;
        } else {
            i = i20 - 112;
            if (i >= 31) {
                i = 49;
                i2 = 0;
            } else {
                if (i > 0) {
                    int i24 = i21 >> 13;
                    if ((iFloatToRawIntBits3 & Fields.TransformOrigin) != 0) {
                        i3 = (((i << 10) | i24) + 1) | (i19 << 15);
                    } else {
                        i2 = i24;
                    }
                    short s = (short) i3;
                    iFloatToRawIntBits = Float.floatToRawIntBits(f2);
                    i4 = iFloatToRawIntBits >>> 31;
                    i5 = (iFloatToRawIntBits >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i6 = iFloatToRawIntBits & 8388607;
                    if (i5 == 255) {
                        if (i6 != 0) {
                            i9 = Fields.RotationY;
                        } else {
                            i9 = 0;
                        }
                        i7 = 31;
                    } else {
                        i7 = i5 - 112;
                        if (i7 >= 31) {
                            i7 = 49;
                            i9 = 0;
                        } else {
                            if (i7 <= 0) {
                                i8 = i6 >> 13;
                                if ((iFloatToRawIntBits & Fields.TransformOrigin) != 0) {
                                    i10 = (((i7 << 10) | i8) + 1) | (i4 << 15);
                                } else {
                                    i9 = i8;
                                }
                                short s2 = (short) i10;
                                iFloatToRawIntBits2 = Float.floatToRawIntBits(f3);
                                i12 = iFloatToRawIntBits2 >>> 31;
                                i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                                i14 = 8388607 & iFloatToRawIntBits2;
                                if (i13 == 255) {
                                    i15 = i13 - 112;
                                    if (i15 < 31) {
                                        if (i15 <= 0) {
                                            i23 = i14 >> 13;
                                            if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                                i16 = (((i15 << 10) | i23) + 1) | (i12 << 15);
                                            } else {
                                                i22 = i15;
                                            }
                                        } else if (i15 >= -10) {
                                            i17 = (i14 | 8388608) >> (1 - i15);
                                            if ((i17 & Fields.TransformOrigin) != 0) {
                                                i17 += Fields.Shape;
                                            }
                                            i22 = 0;
                                            i23 = i17 >> 13;
                                        } else {
                                            i22 = 0;
                                        }
                                    }
                                    return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s2) & 65535) << 32) | ((((long) s) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                                }
                                if (i14 != 0) {
                                    i18 = Fields.RotationY;
                                } else {
                                    i18 = 0;
                                }
                                i23 = i18;
                                i22 = 31;
                                i16 = (i12 << 15) | (i22 << 10) | i23;
                                return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s2) & 65535) << 32) | ((((long) s) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                            }
                            if (i7 >= -10) {
                                i11 = (i6 | 8388608) >> (1 - i7);
                                if ((i11 & Fields.TransformOrigin) != 0) {
                                    i11 += Fields.Shape;
                                }
                                i9 = i11 >> 13;
                                i7 = 0;
                            } else {
                                i9 = 0;
                                i7 = 0;
                            }
                        }
                    }
                    i10 = i9 | (i4 << 15) | (i7 << 10);
                    short s3 = (short) i10;
                    iFloatToRawIntBits2 = Float.floatToRawIntBits(f3);
                    i12 = iFloatToRawIntBits2 >>> 31;
                    i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i14 = 8388607 & iFloatToRawIntBits2;
                    if (i13 == 255) {
                        i15 = i13 - 112;
                        if (i15 < 31) {
                            if (i15 <= 0) {
                                i23 = i14 >> 13;
                                if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                    i16 = (((i15 << 10) | i23) + 1) | (i12 << 15);
                                } else {
                                    i22 = i15;
                                }
                            } else if (i15 >= -10) {
                                i17 = (i14 | 8388608) >> (1 - i15);
                                if ((i17 & Fields.TransformOrigin) != 0) {
                                    i17 += Fields.Shape;
                                }
                                i22 = 0;
                                i23 = i17 >> 13;
                            } else {
                                i22 = 0;
                            }
                        }
                        return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s3) & 65535) << 32) | ((((long) s) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                    }
                    if (i14 != 0) {
                        i18 = Fields.RotationY;
                    } else {
                        i18 = 0;
                    }
                    i23 = i18;
                    i22 = 31;
                    i16 = (i12 << 15) | (i22 << 10) | i23;
                    return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s3) & 65535) << 32) | ((((long) s) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                }
                if (i >= -10) {
                    int i25 = (i21 | 8388608) >> (1 - i);
                    if ((i25 & Fields.TransformOrigin) != 0) {
                        i25 += Fields.Shape;
                    }
                    i2 = i25 >> 13;
                    i = 0;
                } else {
                    i2 = 0;
                    i = 0;
                }
            }
        }
        i3 = i2 | (i19 << 15) | (i << 10);
        short s4 = (short) i3;
        iFloatToRawIntBits = Float.floatToRawIntBits(f2);
        i4 = iFloatToRawIntBits >>> 31;
        i5 = (iFloatToRawIntBits >>> 23) & PartialGapBuffer.BUF_SIZE;
        i6 = iFloatToRawIntBits & 8388607;
        if (i5 == 255) {
            if (i6 != 0) {
                i9 = Fields.RotationY;
            } else {
                i9 = 0;
            }
            i7 = 31;
        } else {
            i7 = i5 - 112;
            if (i7 >= 31) {
                i7 = 49;
                i9 = 0;
            } else {
                if (i7 <= 0) {
                    i8 = i6 >> 13;
                    if ((iFloatToRawIntBits & Fields.TransformOrigin) != 0) {
                        i10 = (((i7 << 10) | i8) + 1) | (i4 << 15);
                    } else {
                        i9 = i8;
                    }
                    short s5 = (short) i10;
                    iFloatToRawIntBits2 = Float.floatToRawIntBits(f3);
                    i12 = iFloatToRawIntBits2 >>> 31;
                    i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
                    i14 = 8388607 & iFloatToRawIntBits2;
                    if (i13 == 255) {
                        i15 = i13 - 112;
                        if (i15 < 31) {
                            if (i15 <= 0) {
                                i23 = i14 >> 13;
                                if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                                    i16 = (((i15 << 10) | i23) + 1) | (i12 << 15);
                                } else {
                                    i22 = i15;
                                }
                            } else if (i15 >= -10) {
                                i17 = (i14 | 8388608) >> (1 - i15);
                                if ((i17 & Fields.TransformOrigin) != 0) {
                                    i17 += Fields.Shape;
                                }
                                i22 = 0;
                                i23 = i17 >> 13;
                            } else {
                                i22 = 0;
                            }
                        }
                        return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s5) & 65535) << 32) | ((((long) s4) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                    }
                    if (i14 != 0) {
                        i18 = Fields.RotationY;
                    } else {
                        i18 = 0;
                    }
                    i23 = i18;
                    i22 = 31;
                    i16 = (i12 << 15) | (i22 << 10) | i23;
                    return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s5) & 65535) << 32) | ((((long) s4) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
                }
                if (i7 >= -10) {
                    i11 = (i6 | 8388608) >> (1 - i7);
                    if ((i11 & Fields.TransformOrigin) != 0) {
                        i11 += Fields.Shape;
                    }
                    i9 = i11 >> 13;
                    i7 = 0;
                } else {
                    i9 = 0;
                    i7 = 0;
                }
            }
        }
        i10 = i9 | (i4 << 15) | (i7 << 10);
        short s6 = (short) i10;
        iFloatToRawIntBits2 = Float.floatToRawIntBits(f3);
        i12 = iFloatToRawIntBits2 >>> 31;
        i13 = (iFloatToRawIntBits2 >>> 23) & PartialGapBuffer.BUF_SIZE;
        i14 = 8388607 & iFloatToRawIntBits2;
        if (i13 == 255) {
            i15 = i13 - 112;
            if (i15 < 31) {
                if (i15 <= 0) {
                    i23 = i14 >> 13;
                    if ((iFloatToRawIntBits2 & Fields.TransformOrigin) != 0) {
                        i16 = (((i15 << 10) | i23) + 1) | (i12 << 15);
                    } else {
                        i22 = i15;
                    }
                } else if (i15 >= -10) {
                    i17 = (i14 | 8388608) >> (1 - i15);
                    if ((i17 & Fields.TransformOrigin) != 0) {
                        i17 += Fields.Shape;
                    }
                    i22 = 0;
                    i23 = i17 >> 13;
                } else {
                    i22 = 0;
                }
            }
            return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s6) & 65535) << 32) | ((((long) s4) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
        }
        if (i14 != 0) {
            i18 = Fields.RotationY;
        } else {
            i18 = 0;
        }
        i23 = i18;
        i22 = 31;
        i16 = (i12 << 15) | (i22 << 10) | i23;
        return Color.m4586constructorimpl(ULong.constructor-impl(((((long) s6) & 65535) << 32) | ((((long) s4) & 65535) << 48) | ((((long) ((short) i16)) & 65535) << 16) | ((((long) ((int) ((Math.max(0.0f, Math.min(f4, 1.0f)) * 1023.0f) + 0.5f))) & 1023) << 6) | (((long) colorSpace.getId()) & 63)));
    }

    public static final long Color(int i) {
        return Color.m4586constructorimpl(ULong.constructor-impl(ULong.constructor-impl(i) << 32));
    }

    public static final long Color(long j) {
        return Color.m4586constructorimpl(ULong.constructor-impl(j << 32));
    }

    public static long Color$default(int i, int i2, int i3, int i4, int i5, Object obj) {
        if ((i5 & 8) != 0) {
            i4 = PartialGapBuffer.BUF_SIZE;
        }
        return Color(i, i2, i3, i4);
    }

    public static final long Color(int i, int i2, int i3, int i4) {
        return Color(((i & PartialGapBuffer.BUF_SIZE) << 16) | ((i4 & PartialGapBuffer.BUF_SIZE) << 24) | ((i2 & PartialGapBuffer.BUF_SIZE) << 8) | (i3 & PartialGapBuffer.BUF_SIZE));
    }

    public static final long m4641lerpjxsXWHM(long j, long j2, float f) {
        ColorSpace oklab = ColorSpaces.INSTANCE.getOklab();
        long jM4587convertvNxB06k = Color.m4587convertvNxB06k(j, oklab);
        long jM4587convertvNxB06k2 = Color.m4587convertvNxB06k(j2, oklab);
        float fM4592getAlphaimpl = Color.m4592getAlphaimpl(jM4587convertvNxB06k);
        float fM4596getRedimpl = Color.m4596getRedimpl(jM4587convertvNxB06k);
        float fM4595getGreenimpl = Color.m4595getGreenimpl(jM4587convertvNxB06k);
        float fM4593getBlueimpl = Color.m4593getBlueimpl(jM4587convertvNxB06k);
        float fM4592getAlphaimpl2 = Color.m4592getAlphaimpl(jM4587convertvNxB06k2);
        float fM4596getRedimpl2 = Color.m4596getRedimpl(jM4587convertvNxB06k2);
        float fM4595getGreenimpl2 = Color.m4595getGreenimpl(jM4587convertvNxB06k2);
        float fM4593getBlueimpl2 = Color.m4593getBlueimpl(jM4587convertvNxB06k2);
        if (f < 0.0f) {
            f = 0.0f;
        }
        if (f > 1.0f) {
            f = 1.0f;
        }
        return Color.m4587convertvNxB06k(UncheckedColor(MathHelpersKt.lerp(fM4596getRedimpl, fM4596getRedimpl2, f), MathHelpersKt.lerp(fM4595getGreenimpl, fM4595getGreenimpl2, f), MathHelpersKt.lerp(fM4593getBlueimpl, fM4593getBlueimpl2, f), MathHelpersKt.lerp(fM4592getAlphaimpl, fM4592getAlphaimpl2, f), oklab), Color.m4594getColorSpaceimpl(j2));
    }

    public static final long m4635compositeOverOWjLjI(long j, long j2) {
        long jM4587convertvNxB06k = Color.m4587convertvNxB06k(j, Color.m4594getColorSpaceimpl(j2));
        float fM4592getAlphaimpl = Color.m4592getAlphaimpl(j2);
        float fM4592getAlphaimpl2 = Color.m4592getAlphaimpl(jM4587convertvNxB06k);
        float f = 1.0f - fM4592getAlphaimpl2;
        float f2 = (fM4592getAlphaimpl * f) + fM4592getAlphaimpl2;
        return UncheckedColor(f2 == 0.0f ? 0.0f : ((Color.m4596getRedimpl(jM4587convertvNxB06k) * fM4592getAlphaimpl2) + ((Color.m4596getRedimpl(j2) * fM4592getAlphaimpl) * f)) / f2, f2 == 0.0f ? 0.0f : ((Color.m4595getGreenimpl(jM4587convertvNxB06k) * fM4592getAlphaimpl2) + ((Color.m4595getGreenimpl(j2) * fM4592getAlphaimpl) * f)) / f2, f2 != 0.0f ? ((Color.m4593getBlueimpl(jM4587convertvNxB06k) * fM4592getAlphaimpl2) + ((Color.m4593getBlueimpl(j2) * fM4592getAlphaimpl) * f)) / f2 : 0.0f, f2, Color.m4594getColorSpaceimpl(j2));
    }

    private static final float[] m4636getComponents8_81llA(long j) {
        return new float[]{Color.m4596getRedimpl(j), Color.m4595getGreenimpl(j), Color.m4593getBlueimpl(j), Color.m4592getAlphaimpl(j)};
    }

    public static final float m4642luminance8_81llA(long j) {
        ColorSpace colorSpaceM4594getColorSpaceimpl = Color.m4594getColorSpaceimpl(j);
        if (!ColorModel.m5017equalsimpl0(colorSpaceM4594getColorSpaceimpl.getModel(), ColorModel.INSTANCE.m5024getRgbxdoWZVw())) {
            InlineClassHelperKt.throwIllegalArgumentException("The specified color must be encoded in an RGB color space. The supplied color space is " + ((Object) ColorModel.m5020toStringimpl(colorSpaceM4594getColorSpaceimpl.getModel())));
        }
        Intrinsics.checkNotNull(colorSpaceM4594getColorSpaceimpl, "null cannot be cast to non-null type androidx.compose.ui.graphics.colorspace.Rgb");
        DoubleFunction eotfFunc$ui_graphics_release = ((Rgb) colorSpaceM4594getColorSpaceimpl).getEotfFunc();
        float fInvoke = (float) ((eotfFunc$ui_graphics_release.invoke(Color.m4596getRedimpl(j)) * 0.2126d) + (eotfFunc$ui_graphics_release.invoke(Color.m4595getGreenimpl(j)) * 0.7152d) + (eotfFunc$ui_graphics_release.invoke(Color.m4593getBlueimpl(j)) * 0.0722d));
        if (fInvoke < 0.0f) {
            fInvoke = 0.0f;
        }
        if (fInvoke > 1.0f) {
            return 1.0f;
        }
        return fInvoke;
    }

    public static final int m4644toArgb8_81llA(long j) {
        return (int) ULong.constructor-impl(Color.m4587convertvNxB06k(j, ColorSpaces.INSTANCE.getSrgb()) >>> 32);
    }

    public static final long m4643takeOrElseDxMtmZc(long j, Function0<Color> function0) {
        return j != 16 ? j : ((Color) function0.invoke()).m4600unboximpl();
    }
}
