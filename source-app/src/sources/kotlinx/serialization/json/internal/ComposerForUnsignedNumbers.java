package kotlinx.serialization.json.internal;

import kotlin.Metadata;
import kotlin.UByte;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.UInt;
import kotlin.ULong;
import kotlin.UShort;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0005\n\u0002\u0010\b\n\u0002\u0010\t\n\u0002\u0010\n\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0016J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u000bH\u0016J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\fH\u0016J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\rH\u0016R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lkotlinx/serialization/json/internal/ComposerForUnsignedNumbers;", "Lkotlinx/serialization/json/internal/Composer;", "writer", "Lkotlinx/serialization/json/internal/InternalJsonWriter;", "forceQuoting", "", "(Lkotlinx/serialization/json/internal/InternalJsonWriter;Z)V", "print", "", "v", "", "", "", "", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ComposerForUnsignedNumbers extends Composer {
    private final boolean forceQuoting;

    public ComposerForUnsignedNumbers(InternalJsonWriter writer, boolean z) {
        super(writer);
        Intrinsics.checkNotNullParameter(writer, "writer");
        this.forceQuoting = z;
    }

    @Override
    public void print(int v) {
        boolean z = this.forceQuoting;
        int iM391constructorimpl = UInt.m391constructorimpl(v);
        if (z) {
            printQuoted(UByte$$ExternalSyntheticBackport0.m33m(iM391constructorimpl, 10));
        } else {
            print(UByte$$ExternalSyntheticBackport0.m33m(iM391constructorimpl, 10));
        }
    }

    @Override
    public void print(long v) {
        boolean z = this.forceQuoting;
        long jM470constructorimpl = ULong.m470constructorimpl(v);
        if (z) {
            printQuoted(UByte$$ExternalSyntheticBackport0.m$2(jM470constructorimpl, 10));
        } else {
            print(UByte$$ExternalSyntheticBackport0.m$2(jM470constructorimpl, 10));
        }
    }

    @Override
    public void print(byte v) {
        boolean z = this.forceQuoting;
        String strM358toStringimpl = UByte.m358toStringimpl(UByte.m314constructorimpl(v));
        if (z) {
            printQuoted(strM358toStringimpl);
        } else {
            print(strM358toStringimpl);
        }
    }

    @Override
    public void print(short v) {
        boolean z = this.forceQuoting;
        String strM621toStringimpl = UShort.m621toStringimpl(UShort.m577constructorimpl(v));
        if (z) {
            printQuoted(strM621toStringimpl);
        } else {
            print(strM621toStringimpl);
        }
    }
}
