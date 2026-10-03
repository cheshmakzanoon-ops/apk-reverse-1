package kotlinx.serialization.internal;

import java.util.Arrays;
import kotlin.Metadata;
import kotlin.UIntArray;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;
import kotlinx.serialization.ExperimentalSerializationApi;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\b\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0002\u0010\u0004J\u001a\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0000ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011J\u0015\u0010\u0012\u001a\u00020\u0002H\u0010ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u0015\u0010\u0015\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\bH\u0010¢\u0006\u0002\b\u0017R\u0016\u0010\u0005\u001a\u00020\u0002X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0006R\u001e\u0010\t\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b@RX\u0090\u000e¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0018"}, m18d2 = {"Lkotlinx/serialization/internal/UIntArrayBuilder;", "Lkotlinx/serialization/internal/PrimitiveArrayBuilder;", "Lkotlin/UIntArray;", "bufferWithData", "([ILkotlin/jvm/internal/DefaultConstructorMarker;)V", "buffer", "[I", "<set-?>", "", "position", "getPosition$kotlinx_serialization_core", "()I", "append", "", "c", "Lkotlin/UInt;", "append-WZ4Q5Ns$kotlinx_serialization_core", "(I)V", "build", "build--hP7Qyg$kotlinx_serialization_core", "()[I", "ensureCapacity", "requiredCapacity", "ensureCapacity$kotlinx_serialization_core", "kotlinx-serialization-core"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@ExperimentalSerializationApi
public final class UIntArrayBuilder extends PrimitiveArrayBuilder<UIntArray> {
    private int[] buffer;
    private int position;

    public UIntArrayBuilder(int[] iArr, DefaultConstructorMarker defaultConstructorMarker) {
        this(iArr);
    }

    @Override
    public UIntArray build$kotlinx_serialization_core() {
        return UIntArray.m444boximpl(m1905buildhP7Qyg$kotlinx_serialization_core());
    }

    private UIntArrayBuilder(int[] bufferWithData) {
        Intrinsics.checkNotNullParameter(bufferWithData, "bufferWithData");
        this.buffer = bufferWithData;
        this.position = UIntArray.m452getSizeimpl(bufferWithData);
        ensureCapacity$kotlinx_serialization_core(10);
    }

    @Override
    public int getPosition() {
        return this.position;
    }

    @Override
    public void ensureCapacity$kotlinx_serialization_core(int requiredCapacity) {
        if (UIntArray.m452getSizeimpl(this.buffer) < requiredCapacity) {
            int[] iArr = this.buffer;
            int[] iArrCopyOf = Arrays.copyOf(iArr, RangesKt.coerceAtLeast(requiredCapacity, UIntArray.m452getSizeimpl(iArr) * 2));
            Intrinsics.checkNotNullExpressionValue(iArrCopyOf, "copyOf(...)");
            this.buffer = UIntArray.m446constructorimpl(iArrCopyOf);
        }
    }

    public final void m1904appendWZ4Q5Ns$kotlinx_serialization_core(int c) {
        PrimitiveArrayBuilder.ensureCapacity$kotlinx_serialization_core$default(this, 0, 1, null);
        int[] iArr = this.buffer;
        int position = getPosition();
        this.position = position + 1;
        UIntArray.m456setVXSXFK8(iArr, position, c);
    }

    public int[] m1905buildhP7Qyg$kotlinx_serialization_core() {
        int[] iArrCopyOf = Arrays.copyOf(this.buffer, getPosition());
        Intrinsics.checkNotNullExpressionValue(iArrCopyOf, "copyOf(...)");
        return UIntArray.m446constructorimpl(iArrCopyOf);
    }
}
