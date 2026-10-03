package androidx.compose.foundation.lazy.grid;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.lazy.layout.LazyLayoutIntervalContent;
import androidx.compose.foundation.lazy.layout.MutableIntervalList;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 *2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001*B\u001e\u0012\u0017\u0010\u0004\u001a\u0013\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\u0002\b\u0007¢\u0006\u0002\u0010\bJZ\u0010\u0017\u001a\u00020\u00062\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\u0019\u0010\u001a\u001a\u0015\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u001c\u0018\u00010\u0005¢\u0006\u0002\b\u00072\b\u0010\u001d\u001a\u0004\u0018\u00010\u00192\u001c\u0010\u0004\u001a\u0018\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\u0002\b\u001f¢\u0006\u0002\b\u0007H\u0016¢\u0006\u0002\u0010 J³\u0001\u0010!\u001a\u00020\u00062\u0006\u0010\"\u001a\u00020#2#\u0010\u0018\u001a\u001f\u0012\u0013\u0012\u00110#¢\u0006\f\b$\u0012\b\b%\u0012\u0004\b\b(&\u0012\u0004\u0012\u00020\u0019\u0018\u00010\u00052\u001f\u0010\u001a\u001a\u001b\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u001c\u0018\u00010'¢\u0006\u0002\b\u00072#\u0010\u001d\u001a\u001f\u0012\u0013\u0012\u00110#¢\u0006\f\b$\u0012\b\b%\u0012\u0004\b\b(&\u0012\u0006\u0012\u0004\u0018\u00010\u00190\u000521\u0010(\u001a-\u0012\u0004\u0012\u00020\u001e\u0012\u0013\u0012\u00110#¢\u0006\f\b$\u0012\b\b%\u0012\u0004\b\b(&\u0012\u0004\u0012\u00020\u00060'¢\u0006\u0002\b\u001f¢\u0006\u0002\b\u0007H\u0016¢\u0006\u0002\u0010)R\u001a\u0010\t\u001a\u00020\nX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0010X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\u0013\u001a\u00020\u0014X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016¨\u0006+"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridIntervalContent;", "Landroidx/compose/foundation/lazy/grid/LazyGridScope;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutIntervalContent;", "Landroidx/compose/foundation/lazy/grid/LazyGridInterval;", "content", "Lkotlin/Function1;", "", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function1;)V", "hasCustomSpans", "", "getHasCustomSpans$foundation_release", "()Z", "setHasCustomSpans$foundation_release", "(Z)V", "intervals", "Landroidx/compose/foundation/lazy/layout/MutableIntervalList;", "getIntervals", "()Landroidx/compose/foundation/lazy/layout/MutableIntervalList;", "spanLayoutProvider", "Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider;", "getSpanLayoutProvider$foundation_release", "()Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider;", "item", "key", "", "span", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "contentType", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "Landroidx/compose/runtime/Composable;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Ljava/lang/Object;Lkotlin/jvm/functions/Function3;)V", "items", "count", "", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "index", "Lkotlin/Function2;", "itemContent", "(ILkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;)V", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyGridIntervalContent extends LazyLayoutIntervalContent<LazyGridInterval> implements LazyGridScope {
    private boolean hasCustomSpans;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;
    private static final Function2<LazyGridItemSpanScope, Integer, GridItemSpan> DefaultSpan = new Function2<LazyGridItemSpanScope, Integer, GridItemSpan>() {
        public Object invoke(Object obj, Object obj2) {
            return GridItemSpan.m1160boximpl(m1177invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
        }

        public final long m1177invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
            return LazyGridSpanKt.GridItemSpan(1);
        }
    };
    private final LazyGridSpanLayoutProvider spanLayoutProvider = new LazyGridSpanLayoutProvider(this);
    private final MutableIntervalList<LazyGridInterval> intervals = new MutableIntervalList<>();

    public LazyGridIntervalContent(Function1<? super LazyGridScope, Unit> function1) {
        function1.invoke(this);
    }

    public final LazyGridSpanLayoutProvider getSpanLayoutProvider() {
        return this.spanLayoutProvider;
    }

    @Override
    public MutableIntervalList<LazyGridInterval> getIntervals() {
        return this.intervals;
    }

    public final boolean getHasCustomSpans() {
        return this.hasCustomSpans;
    }

    public final void setHasCustomSpans$foundation_release(boolean z) {
        this.hasCustomSpans = z;
    }

    @Override
    public void item(final Object key, final Function1<? super LazyGridItemSpanScope, GridItemSpan> span, final Object contentType, final Function3<? super LazyGridItemScope, ? super Composer, ? super Integer, Unit> content) {
        getIntervals().addInterval(1, new LazyGridInterval(key != null ? new Function1<Integer, Object>() {
            {
                super(1);
            }

            public final Object invoke(int i) {
                return key;
            }

            public Object invoke(Object obj) {
                return invoke(((Number) obj).intValue());
            }
        } : null, span != null ? new Function2<LazyGridItemSpanScope, Integer, GridItemSpan>() {
            {
                super(2);
            }

            public Object invoke(Object obj, Object obj2) {
                return GridItemSpan.m1160boximpl(m1178invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
            }

            public final long m1178invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
                return ((GridItemSpan) span.invoke(lazyGridItemSpanScope)).getPackedValue();
            }
        } : DefaultSpan, new Function1<Integer, Object>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                return invoke(((Number) obj).intValue());
            }

            public final Object invoke(int i) {
                return contentType;
            }
        }, ComposableLambdaKt.composableLambdaInstance(-34608120, true, new Function4<LazyGridItemScope, Integer, Composer, Integer, Unit>() {
            {
                super(4);
            }

            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                invoke((LazyGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(LazyGridItemScope lazyGridItemScope, int i, Composer composer, int i2) {
                ComposerKt.sourceInformation(composer, "C49@1790L9:LazyGridIntervalContent.kt#7791vq");
                if ((i2 & 6) == 0) {
                    i2 |= composer.changed(lazyGridItemScope) ? 4 : 2;
                }
                if ((i2 & 131) == 130 && composer.getSkipping()) {
                    composer.skipToGroupEnd();
                    return;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-34608120, i2, -1, "androidx.compose.foundation.lazy.grid.LazyGridIntervalContent.item.<anonymous> (LazyGridIntervalContent.kt:49)");
                }
                content.invoke(lazyGridItemScope, composer, Integer.valueOf(i2 & 14));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
        })));
        if (span != null) {
            this.hasCustomSpans = true;
        }
    }

    @Override
    public void items(int count, Function1<? super Integer, ? extends Object> key, Function2<? super LazyGridItemSpanScope, ? super Integer, GridItemSpan> span, Function1<? super Integer, ? extends Object> contentType, Function4<? super LazyGridItemScope, ? super Integer, ? super Composer, ? super Integer, Unit> itemContent) {
        getIntervals().addInterval(count, new LazyGridInterval(key, span == null ? DefaultSpan : span, contentType, itemContent));
        if (span != null) {
            this.hasCustomSpans = true;
        }
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R(\u0010\u0003\u001a\u0019\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0004¢\u0006\u0002\b\b¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u000b"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridIntervalContent$Companion;", "", "()V", "DefaultSpan", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "Lkotlin/ExtensionFunctionType;", "getDefaultSpan", "()Lkotlin/jvm/functions/Function2;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Function2<LazyGridItemSpanScope, Integer, GridItemSpan> getDefaultSpan() {
            return LazyGridIntervalContent.DefaultSpan;
        }
    }
}
