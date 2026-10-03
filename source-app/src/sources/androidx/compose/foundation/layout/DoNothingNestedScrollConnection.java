package androidx.compose.foundation.layout;

import androidx.compose.p002ui.input.nestedscroll.NestedScrollConnection;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;

@Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÂ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Landroidx/compose/foundation/layout/DoNothingNestedScrollConnection;", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "()V", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DoNothingNestedScrollConnection implements NestedScrollConnection {
    public static final DoNothingNestedScrollConnection INSTANCE = new DoNothingNestedScrollConnection();

    @Override
    public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation continuation) {
        return NestedScrollConnection.CC.m5713onPostFlingRZ2iAVY$suspendImpl(this, j, j2, continuation);
    }

    @Override
    public long mo829onPostScrollDzOQY0M(long j, long j2, int i) {
        return NestedScrollConnection.CC.m5706$default$onPostScrollDzOQY0M(this, j, j2, i);
    }

    @Override
    public Object mo830onPreFlingQWom1Mo(long j, Continuation continuation) {
        return NestedScrollConnection.CC.m5714onPreFlingQWom1Mo$suspendImpl(this, j, continuation);
    }

    @Override
    public long mo831onPreScrollOzD1aCk(long j, int i) {
        return NestedScrollConnection.CC.m5708$default$onPreScrollOzD1aCk(this, j, i);
    }

    private DoNothingNestedScrollConnection() {
    }
}
