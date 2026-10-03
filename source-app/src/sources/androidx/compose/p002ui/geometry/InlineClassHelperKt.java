package androidx.compose.p002ui.geometry;

import kotlin.Metadata;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\"\n\u0000\n\u0002\u0010\t\n\u0002\b\b\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\u001a*\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000f0\u000eH\u0080\b\u0082\u0002\b\n\u0006\b\u0000\u001a\u0002\u0010\u0001\u001a\u0010\u0010\u0010\u001a\u00020\n2\u0006\u0010\u0011\u001a\u00020\u000fH\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0003\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0004\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0005\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0006\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0007\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\b\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"DualFirstNaN", "", "DualFloatInfinityBase", "DualFloatSignBit", "DualUnsignedFloatMask", "FloatInfinityBase", "Uint64High32", "Uint64Low32", "UnspecifiedPackedFloats", "checkPrecondition", "", "value", "", "lazyMessage", "Lkotlin/Function0;", "", "throwIllegalStateException", "message", "ui-geometry_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class InlineClassHelperKt {
    public static final long DualFirstNaN = 9187343246269874177L;
    public static final long DualFloatInfinityBase = 9187343241974906880L;
    public static final long DualFloatSignBit = -9223372034707292160L;
    public static final long DualUnsignedFloatMask = 9223372034707292159L;
    public static final long FloatInfinityBase = 2139095040;
    public static final long Uint64High32 = -9223372034707292160L;
    public static final long Uint64Low32 = 4294967297L;
    public static final long UnspecifiedPackedFloats = 9205357640488583168L;

    public static final void throwIllegalStateException(String str) {
        throw new IllegalStateException(str);
    }

    public static final void checkPrecondition(boolean z, Function0<String> function0) {
        if (z) {
            return;
        }
        throwIllegalStateException((String) function0.invoke());
    }
}
