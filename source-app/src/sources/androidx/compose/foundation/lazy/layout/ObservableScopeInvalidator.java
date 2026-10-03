package androidx.compose.foundation.lazy.layout;

import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0081@\u0018\u00002\u00020\u0001B\u0017\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0004\b\u0005\u0010\u0006J\r\u0010\u0007\u001a\u00020\u0004¢\u0006\u0004\b\b\u0010\tJ\u001a\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\r\u0010\u000eJ\u0010\u0010\u000f\u001a\u00020\u0010HÖ\u0001¢\u0006\u0004\b\u0011\u0010\u0012J\r\u0010\u0013\u001a\u00020\u0004¢\u0006\u0004\b\u0014\u0010\tJ\u0010\u0010\u0015\u001a\u00020\u0016HÖ\u0001¢\u0006\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\b\u0012\u0004\u0012\u00020\u00040\u0003¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "", "state", "Landroidx/compose/runtime/MutableState;", "", "constructor-impl", "(Landroidx/compose/runtime/MutableState;)Landroidx/compose/runtime/MutableState;", "attachToScope", "attachToScope-impl", "(Landroidx/compose/runtime/MutableState;)V", "equals", "", "other", "equals-impl", "(Landroidx/compose/runtime/MutableState;Ljava/lang/Object;)Z", "hashCode", "", "hashCode-impl", "(Landroidx/compose/runtime/MutableState;)I", "invalidateScope", "invalidateScope-impl", "toString", "", "toString-impl", "(Landroidx/compose/runtime/MutableState;)Ljava/lang/String;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class ObservableScopeInvalidator {
    private final MutableState<Unit> state;

    public static final ObservableScopeInvalidator m1252boximpl(MutableState mutableState) {
        return new ObservableScopeInvalidator(mutableState);
    }

    public static MutableState<Unit> m1253constructorimpl(MutableState<Unit> mutableState) {
        return mutableState;
    }

    public static boolean m1255equalsimpl(MutableState<Unit> mutableState, Object obj) {
        return (obj instanceof ObservableScopeInvalidator) && Intrinsics.areEqual(mutableState, ((ObservableScopeInvalidator) obj).getState());
    }

    public static final boolean m1256equalsimpl0(MutableState<Unit> mutableState, MutableState<Unit> mutableState2) {
        return Intrinsics.areEqual(mutableState, mutableState2);
    }

    public static int m1257hashCodeimpl(MutableState<Unit> mutableState) {
        return mutableState.hashCode();
    }

    public static String m1259toStringimpl(MutableState<Unit> mutableState) {
        return "ObservableScopeInvalidator(state=" + mutableState + ')';
    }

    public boolean equals(Object obj) {
        return m1255equalsimpl(this.state, obj);
    }

    public int hashCode() {
        return m1257hashCodeimpl(this.state);
    }

    public String toString() {
        return m1259toStringimpl(this.state);
    }

    public final MutableState getState() {
        return this.state;
    }

    private ObservableScopeInvalidator(MutableState mutableState) {
        this.state = mutableState;
    }

    public static MutableState m1254constructorimpl$default(MutableState mutableState, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 1) != 0) {
            mutableState = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
        }
        return m1253constructorimpl(mutableState);
    }

    public static final void m1251attachToScopeimpl(MutableState<Unit> mutableState) {
        mutableState.getValue();
    }

    public static final void m1258invalidateScopeimpl(MutableState<Unit> mutableState) {
        mutableState.setValue(Unit.INSTANCE);
    }
}
