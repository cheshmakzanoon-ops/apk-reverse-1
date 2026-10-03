package androidx.compose.p002ui.input.nestedscroll;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;

@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\bf\u0018\u00002\u00020\u0001J#\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0003H\u0096@ø\u0001\u0000¢\u0006\u0004\b\u0006\u0010\u0007J*\u0010\b\u001a\u00020\t2\u0006\u0010\u0004\u001a\u00020\t2\u0006\u0010\u0005\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\f\u0010\rJ\u001b\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0003H\u0096@ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010J\"\u0010\u0011\u001a\u00020\t2\u0006\u0010\u0005\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0013ø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006\u0014À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "", "onPostFling", "Landroidx/compose/ui/unit/Velocity;", "consumed", "available", "onPostFling-RZ2iAVY", "(JJLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPostScroll", "Landroidx/compose/ui/geometry/Offset;", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "onPostScroll-DzOQY0M", "(JJI)J", "onPreFling", "onPreFling-QWom1Mo", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPreScroll", "onPreScroll-OzD1aCk", "(JI)J", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface NestedScrollConnection {
    Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation<? super Velocity> continuation);

    long mo829onPostScrollDzOQY0M(long consumed, long available, int source);

    Object mo830onPreFlingQWom1Mo(long j, Continuation<? super Velocity> continuation);

    long mo831onPreScrollOzD1aCk(long available, int source);

    public final class CC {
        public static long m5708$default$onPreScrollOzD1aCk(NestedScrollConnection _this, long j, int i) {
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }

        public static long m5706$default$onPostScrollDzOQY0M(NestedScrollConnection _this, long j, long j2, int i) {
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }

        public static Object m5714onPreFlingQWom1Mo$suspendImpl(NestedScrollConnection nestedScrollConnection, long j, Continuation<? super Velocity> continuation) {
            return Velocity.box-impl(Velocity.Companion.getZero-9UxMQ8M());
        }

        public static Object m5713onPostFlingRZ2iAVY$suspendImpl(NestedScrollConnection nestedScrollConnection, long j, long j2, Continuation<? super Velocity> continuation) {
            return Velocity.box-impl(Velocity.Companion.getZero-9UxMQ8M());
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static long m5718onPreScrollOzD1aCk(NestedScrollConnection nestedScrollConnection, long j, int i) {
            return CC.m5708$default$onPreScrollOzD1aCk(nestedScrollConnection, j, i);
        }

        @Deprecated
        public static long m5716onPostScrollDzOQY0M(NestedScrollConnection nestedScrollConnection, long j, long j2, int i) {
            return CC.m5706$default$onPostScrollDzOQY0M(nestedScrollConnection, j, j2, i);
        }

        @Deprecated
        public static Object m5717onPreFlingQWom1Mo(NestedScrollConnection nestedScrollConnection, long j, Continuation<? super Velocity> continuation) {
            return CC.m5714onPreFlingQWom1Mo$suspendImpl(nestedScrollConnection, j, continuation);
        }

        @Deprecated
        public static Object m5715onPostFlingRZ2iAVY(NestedScrollConnection nestedScrollConnection, long j, long j2, Continuation<? super Velocity> continuation) {
            return CC.m5713onPostFlingRZ2iAVY$suspendImpl(nestedScrollConnection, j, j2, continuation);
        }
    }
}
