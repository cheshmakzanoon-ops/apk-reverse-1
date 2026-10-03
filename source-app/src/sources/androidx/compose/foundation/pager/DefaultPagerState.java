package androidx.compose.foundation.pager;

import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.saveable.ListSaverKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.runtime.saveable.SaverScope;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0002\u0018\u0000 \u00122\u00020\u0001:\u0001\u0012B#\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00030\u0007¢\u0006\u0002\u0010\bR\u0014\u0010\t\u001a\u00020\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR&\u0010\f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00030\u00070\rX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011¨\u0006\u0013"}, d2 = {"Landroidx/compose/foundation/pager/DefaultPagerState;", "Landroidx/compose/foundation/pager/PagerState;", "currentPage", "", "currentPageOffsetFraction", "", "updatedPageCount", "Lkotlin/Function0;", "(IFLkotlin/jvm/functions/Function0;)V", "pageCount", "getPageCount", "()I", "pageCountState", "Landroidx/compose/runtime/MutableState;", "getPageCountState", "()Landroidx/compose/runtime/MutableState;", "setPageCountState", "(Landroidx/compose/runtime/MutableState;)V", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DefaultPagerState extends PagerState {

    public static final Companion INSTANCE = new Companion(null);
    private static final Saver<DefaultPagerState, ?> Saver = ListSaverKt.listSaver(new Function2<SaverScope, DefaultPagerState, List<? extends Object>>() {
        public final List<Object> invoke(SaverScope saverScope, DefaultPagerState defaultPagerState) {
            return CollectionsKt.listOf(new Object[]{Integer.valueOf(defaultPagerState.getCurrentPage()), Float.valueOf(RangesKt.coerceIn(defaultPagerState.getCurrentPageOffsetFraction(), -0.5f, 0.5f)), Integer.valueOf(defaultPagerState.getPageCount())});
        }
    }, new Function1<List, DefaultPagerState>() {
        public final DefaultPagerState invoke(final List<? extends Object> list) {
            Object obj = list.get(0);
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.Int");
            int iIntValue = ((Integer) obj).intValue();
            Object obj2 = list.get(1);
            Intrinsics.checkNotNull(obj2, "null cannot be cast to non-null type kotlin.Float");
            return new DefaultPagerState(iIntValue, ((Float) obj2).floatValue(), new Function0<Integer>() {
                {
                    super(0);
                }

                public final Integer m1317invoke() {
                    Object obj3 = list.get(2);
                    Intrinsics.checkNotNull(obj3, "null cannot be cast to non-null type kotlin.Int");
                    return (Integer) obj3;
                }
            });
        }
    });
    private MutableState<Function0<Integer>> pageCountState;

    public DefaultPagerState(int i, float f, Function0<Integer> function0) {
        super(i, f);
        this.pageCountState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(function0, null, 2, null);
    }

    public final MutableState<Function0<Integer>> getPageCountState() {
        return this.pageCountState;
    }

    public final void setPageCountState(MutableState<Function0<Integer>> mutableState) {
        this.pageCountState = mutableState;
    }

    @Override
    public int getPageCount() {
        return ((Number) this.pageCountState.getValue().invoke()).intValue();
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001b\u0010\u0003\u001a\f\u0012\u0004\u0012\u00020\u0005\u0012\u0002\b\u00030\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, d2 = {"Landroidx/compose/foundation/pager/DefaultPagerState$Companion;", "", "()V", "Saver", "Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/foundation/pager/DefaultPagerState;", "getSaver", "()Landroidx/compose/runtime/saveable/Saver;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Saver<DefaultPagerState, ?> getSaver() {
            return DefaultPagerState.Saver;
        }
    }
}
