package androidx.collection.internal;

import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u001a\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\u001a-\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005H\u0080\bø\u0001\u0000\u0082\u0002\b\n\u0006\b\u0000\u001a\u0002\u0010\u0001\u001a-\u0010\u0007\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005H\u0080\bø\u0001\u0000\u0082\u0002\b\n\u0006\b\u0000\u001a\u0002\u0010\u0001\u001a\u0010\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u0006H\u0000\u001a\u0010\u0010\n\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u0006H\u0000\u0082\u0002\u0007\n\u0005\b\u009920\u0001¨\u0006\u000b"}, d2 = {"checkPrecondition", "", "value", "", "lazyMessage", "Lkotlin/Function0;", "", "requirePrecondition", "throwIllegalArgumentException", "message", "throwIllegalStateException", "collection"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class RuntimeHelpersKt {
    public static final void throwIllegalStateException(String str) {
        Intrinsics.checkNotNullParameter(str, "message");
        throw new IllegalStateException(str);
    }

    public static final void checkPrecondition(boolean z, Function0<String> function0) {
        Intrinsics.checkNotNullParameter(function0, "lazyMessage");
        if (z) {
            return;
        }
        throwIllegalStateException((String) function0.invoke());
    }

    public static final void throwIllegalArgumentException(String str) {
        Intrinsics.checkNotNullParameter(str, "message");
        throw new IllegalArgumentException(str);
    }

    public static final void requirePrecondition(boolean z, Function0<String> function0) {
        Intrinsics.checkNotNullParameter(function0, "lazyMessage");
        if (z) {
            return;
        }
        throwIllegalArgumentException((String) function0.invoke());
    }
}
