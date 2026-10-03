package androidx.compose.p002ui.graphics;

import android.graphics.BlendMode;
import android.graphics.PorterDuff;
import android.os.Build;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u0002ø\u0001\u0000¢\u0006\u0004\b\u0003\u0010\u0004\u001a\u0016\u0010\u0005\u001a\u00020\u0006*\u00020\u0002H\u0001ø\u0001\u0000¢\u0006\u0004\b\u0007\u0010\b\u001a\u0011\u0010\t\u001a\u00020\u0002*\u00020\u0006H\u0001¢\u0006\u0002\u0010\n\u001a\u0016\u0010\u000b\u001a\u00020\f*\u00020\u0002H\u0000ø\u0001\u0000¢\u0006\u0004\b\r\u0010\u000e\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u000f"}, d2 = {"isSupported", "", "Landroidx/compose/ui/graphics/BlendMode;", "isSupported-s9anfk8", "(I)Z", "toAndroidBlendMode", "Landroid/graphics/BlendMode;", "toAndroidBlendMode-s9anfk8", "(I)Landroid/graphics/BlendMode;", "toComposeBlendMode", "(Landroid/graphics/BlendMode;)I", "toPorterDuffMode", "Landroid/graphics/PorterDuff$Mode;", "toPorterDuffMode-s9anfk8", "(I)Landroid/graphics/PorterDuff$Mode;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidBlendMode_androidKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[BlendMode.values().length];
            try {
                iArr[BlendMode.CLEAR.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[BlendMode.SRC.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[BlendMode.DST.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[BlendMode.SRC_OVER.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[BlendMode.DST_OVER.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[BlendMode.SRC_IN.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[BlendMode.DST_IN.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr[BlendMode.SRC_OUT.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                iArr[BlendMode.DST_OUT.ordinal()] = 9;
            } catch (NoSuchFieldError unused9) {
            }
            try {
                iArr[BlendMode.SRC_ATOP.ordinal()] = 10;
            } catch (NoSuchFieldError unused10) {
            }
            try {
                iArr[BlendMode.DST_ATOP.ordinal()] = 11;
            } catch (NoSuchFieldError unused11) {
            }
            try {
                iArr[BlendMode.XOR.ordinal()] = 12;
            } catch (NoSuchFieldError unused12) {
            }
            try {
                iArr[BlendMode.PLUS.ordinal()] = 13;
            } catch (NoSuchFieldError unused13) {
            }
            try {
                iArr[BlendMode.MODULATE.ordinal()] = 14;
            } catch (NoSuchFieldError unused14) {
            }
            try {
                iArr[BlendMode.SCREEN.ordinal()] = 15;
            } catch (NoSuchFieldError unused15) {
            }
            try {
                iArr[BlendMode.OVERLAY.ordinal()] = 16;
            } catch (NoSuchFieldError unused16) {
            }
            try {
                iArr[BlendMode.DARKEN.ordinal()] = 17;
            } catch (NoSuchFieldError unused17) {
            }
            try {
                iArr[BlendMode.LIGHTEN.ordinal()] = 18;
            } catch (NoSuchFieldError unused18) {
            }
            try {
                iArr[BlendMode.COLOR_DODGE.ordinal()] = 19;
            } catch (NoSuchFieldError unused19) {
            }
            try {
                iArr[BlendMode.COLOR_BURN.ordinal()] = 20;
            } catch (NoSuchFieldError unused20) {
            }
            try {
                iArr[BlendMode.HARD_LIGHT.ordinal()] = 21;
            } catch (NoSuchFieldError unused21) {
            }
            try {
                iArr[BlendMode.SOFT_LIGHT.ordinal()] = 22;
            } catch (NoSuchFieldError unused22) {
            }
            try {
                iArr[BlendMode.DIFFERENCE.ordinal()] = 23;
            } catch (NoSuchFieldError unused23) {
            }
            try {
                iArr[BlendMode.EXCLUSION.ordinal()] = 24;
            } catch (NoSuchFieldError unused24) {
            }
            try {
                iArr[BlendMode.MULTIPLY.ordinal()] = 25;
            } catch (NoSuchFieldError unused25) {
            }
            try {
                iArr[BlendMode.HUE.ordinal()] = 26;
            } catch (NoSuchFieldError unused26) {
            }
            try {
                iArr[BlendMode.SATURATION.ordinal()] = 27;
            } catch (NoSuchFieldError unused27) {
            }
            try {
                iArr[BlendMode.COLOR.ordinal()] = 28;
            } catch (NoSuchFieldError unused28) {
            }
            try {
                iArr[BlendMode.LUMINOSITY.ordinal()] = 29;
            } catch (NoSuchFieldError unused29) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final boolean m4437isSupporteds9anfk8(int i) {
        return Build.VERSION.SDK_INT >= 29 || BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4532getSrcOver0nO6VwU()) || m4439toPorterDuffModes9anfk8(i) != PorterDuff.Mode.SRC_OVER;
    }

    public static final PorterDuff.Mode m4439toPorterDuffModes9anfk8(int i) {
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4505getClear0nO6VwU())) {
            return PorterDuff.Mode.CLEAR;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4528getSrc0nO6VwU())) {
            return PorterDuff.Mode.SRC;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4511getDst0nO6VwU())) {
            return PorterDuff.Mode.DST;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4532getSrcOver0nO6VwU())) {
            return PorterDuff.Mode.SRC_OVER;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4515getDstOver0nO6VwU())) {
            return PorterDuff.Mode.DST_OVER;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4530getSrcIn0nO6VwU())) {
            return PorterDuff.Mode.SRC_IN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4513getDstIn0nO6VwU())) {
            return PorterDuff.Mode.DST_IN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4531getSrcOut0nO6VwU())) {
            return PorterDuff.Mode.SRC_OUT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4514getDstOut0nO6VwU())) {
            return PorterDuff.Mode.DST_OUT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4529getSrcAtop0nO6VwU())) {
            return PorterDuff.Mode.SRC_ATOP;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4512getDstAtop0nO6VwU())) {
            return PorterDuff.Mode.DST_ATOP;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4533getXor0nO6VwU())) {
            return PorterDuff.Mode.XOR;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4524getPlus0nO6VwU())) {
            return PorterDuff.Mode.ADD;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4526getScreen0nO6VwU())) {
            return PorterDuff.Mode.SCREEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4523getOverlay0nO6VwU())) {
            return PorterDuff.Mode.OVERLAY;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4509getDarken0nO6VwU())) {
            return PorterDuff.Mode.DARKEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4519getLighten0nO6VwU())) {
            return PorterDuff.Mode.LIGHTEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4521getModulate0nO6VwU())) {
            return PorterDuff.Mode.MULTIPLY;
        }
        return PorterDuff.Mode.SRC_OVER;
    }

    public static final BlendMode m4438toAndroidBlendModes9anfk8(int i) {
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4505getClear0nO6VwU())) {
            return BlendMode.CLEAR;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4528getSrc0nO6VwU())) {
            return BlendMode.SRC;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4511getDst0nO6VwU())) {
            return BlendMode.DST;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4532getSrcOver0nO6VwU())) {
            return BlendMode.SRC_OVER;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4515getDstOver0nO6VwU())) {
            return BlendMode.DST_OVER;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4530getSrcIn0nO6VwU())) {
            return BlendMode.SRC_IN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4513getDstIn0nO6VwU())) {
            return BlendMode.DST_IN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4531getSrcOut0nO6VwU())) {
            return BlendMode.SRC_OUT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4514getDstOut0nO6VwU())) {
            return BlendMode.DST_OUT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4529getSrcAtop0nO6VwU())) {
            return BlendMode.SRC_ATOP;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4512getDstAtop0nO6VwU())) {
            return BlendMode.DST_ATOP;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4533getXor0nO6VwU())) {
            return BlendMode.XOR;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4524getPlus0nO6VwU())) {
            return BlendMode.PLUS;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4521getModulate0nO6VwU())) {
            return BlendMode.MODULATE;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4526getScreen0nO6VwU())) {
            return BlendMode.SCREEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4523getOverlay0nO6VwU())) {
            return BlendMode.OVERLAY;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4509getDarken0nO6VwU())) {
            return BlendMode.DARKEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4519getLighten0nO6VwU())) {
            return BlendMode.LIGHTEN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4508getColorDodge0nO6VwU())) {
            return BlendMode.COLOR_DODGE;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4507getColorBurn0nO6VwU())) {
            return BlendMode.COLOR_BURN;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4517getHardlight0nO6VwU())) {
            return BlendMode.HARD_LIGHT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4527getSoftlight0nO6VwU())) {
            return BlendMode.SOFT_LIGHT;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4510getDifference0nO6VwU())) {
            return BlendMode.DIFFERENCE;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4516getExclusion0nO6VwU())) {
            return BlendMode.EXCLUSION;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4522getMultiply0nO6VwU())) {
            return BlendMode.MULTIPLY;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4518getHue0nO6VwU())) {
            return BlendMode.HUE;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4525getSaturation0nO6VwU())) {
            return BlendMode.SATURATION;
        }
        if (BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4506getColor0nO6VwU())) {
            return BlendMode.COLOR;
        }
        return BlendMode.m4501equalsimpl0(i, BlendMode.INSTANCE.m4520getLuminosity0nO6VwU()) ? BlendMode.LUMINOSITY : BlendMode.SRC_OVER;
    }

    public static final int toComposeBlendMode(BlendMode blendMode) {
        switch (WhenMappings.$EnumSwitchMapping$0[blendMode.ordinal()]) {
            case 1:
                return BlendMode.INSTANCE.m4505getClear0nO6VwU();
            case 2:
                return BlendMode.INSTANCE.m4528getSrc0nO6VwU();
            case 3:
                return BlendMode.INSTANCE.m4511getDst0nO6VwU();
            case 4:
                return BlendMode.INSTANCE.m4532getSrcOver0nO6VwU();
            case 5:
                return BlendMode.INSTANCE.m4515getDstOver0nO6VwU();
            case 6:
                return BlendMode.INSTANCE.m4530getSrcIn0nO6VwU();
            case 7:
                return BlendMode.INSTANCE.m4513getDstIn0nO6VwU();
            case 8:
                return BlendMode.INSTANCE.m4531getSrcOut0nO6VwU();
            case 9:
                return BlendMode.INSTANCE.m4514getDstOut0nO6VwU();
            case 10:
                return BlendMode.INSTANCE.m4529getSrcAtop0nO6VwU();
            case 11:
                return BlendMode.INSTANCE.m4512getDstAtop0nO6VwU();
            case Matrix.TranslateX:
                return BlendMode.INSTANCE.m4533getXor0nO6VwU();
            case Matrix.TranslateY:
                return BlendMode.INSTANCE.m4524getPlus0nO6VwU();
            case Matrix.TranslateZ:
                return BlendMode.INSTANCE.m4521getModulate0nO6VwU();
            case 15:
                return BlendMode.INSTANCE.m4526getScreen0nO6VwU();
            case 16:
                return BlendMode.INSTANCE.m4523getOverlay0nO6VwU();
            case 17:
                return BlendMode.INSTANCE.m4509getDarken0nO6VwU();
            case 18:
                return BlendMode.INSTANCE.m4519getLighten0nO6VwU();
            case 19:
                return BlendMode.INSTANCE.m4508getColorDodge0nO6VwU();
            case 20:
                return BlendMode.INSTANCE.m4507getColorBurn0nO6VwU();
            case 21:
                return BlendMode.INSTANCE.m4517getHardlight0nO6VwU();
            case 22:
                return BlendMode.INSTANCE.m4527getSoftlight0nO6VwU();
            case 23:
                return BlendMode.INSTANCE.m4510getDifference0nO6VwU();
            case 24:
                return BlendMode.INSTANCE.m4516getExclusion0nO6VwU();
            case 25:
                return BlendMode.INSTANCE.m4522getMultiply0nO6VwU();
            case 26:
                return BlendMode.INSTANCE.m4518getHue0nO6VwU();
            case 27:
                return BlendMode.INSTANCE.m4525getSaturation0nO6VwU();
            case 28:
                return BlendMode.INSTANCE.m4506getColor0nO6VwU();
            case 29:
                return BlendMode.INSTANCE.m4520getLuminosity0nO6VwU();
            default:
                return BlendMode.INSTANCE.m4532getSrcOver0nO6VwU();
        }
    }
}
