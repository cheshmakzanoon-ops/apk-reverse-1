package androidx.compose.material3.carousel;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.pager.PageSize;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.unit.Density;
import kotlin.Metadata;
import kotlin.jvm.functions.Function2;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001BM\u00126\u0010\u0002\u001a2\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\b\u0012\u0004\u0012\u00020\t0\u0003\u0012\u0006\u0010\n\u001a\u00020\u0004\u0012\u0006\u0010\u000b\u001a\u00020\u0004¢\u0006\u0002\u0010\fJ\u001c\u0010\u0018\u001a\u00020\u0019*\u00020\u001a2\u0006\u0010\u0007\u001a\u00020\u00192\u0006\u0010\u001b\u001a\u00020\u0019H\u0016R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R>\u0010\u0002\u001a2\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\b\u0012\u0004\u0012\u00020\t0\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\r\u001a\u00020\u000e8F¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010R+\u0010\u0012\u001a\u00020\u000e2\u0006\u0010\u0011\u001a\u00020\u000e8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0016\u0010\u0017\u001a\u0004\b\u0013\u0010\u0010\"\u0004\b\u0014\u0010\u0015¨\u0006\u001c"}, d2 = {"Landroidx/compose/material3/carousel/CarouselPageSize;", "Landroidx/compose/foundation/pager/PageSize;", "keylineList", "Lkotlin/Function2;", "", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "availableSpace", "itemSpacing", "Landroidx/compose/material3/carousel/KeylineList;", "beforeContentPadding", "afterContentPadding", "(Lkotlin/jvm/functions/Function2;FF)V", "strategy", "Landroidx/compose/material3/carousel/Strategy;", "getStrategy", "()Landroidx/compose/material3/carousel/Strategy;", "<set-?>", "strategyState", "getStrategyState", "setStrategyState", "(Landroidx/compose/material3/carousel/Strategy;)V", "strategyState$delegate", "Landroidx/compose/runtime/MutableState;", "calculateMainAxisPageSize", "", "Landroidx/compose/ui/unit/Density;", "pageSpacing", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CarouselPageSize implements PageSize {
    public static final int $stable = 0;
    private final float afterContentPadding;
    private final float beforeContentPadding;
    private final Function2<Float, Float, KeylineList> keylineList;

    private final MutableState strategyState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Strategy.INSTANCE.getEmpty(), null, 2, null);

    public CarouselPageSize(Function2<? super Float, ? super Float, KeylineList> function2, float f, float f2) {
        this.keylineList = function2;
        this.beforeContentPadding = f;
        this.afterContentPadding = f2;
    }

    private final Strategy getStrategyState() {
        return (Strategy) this.strategyState.getValue();
    }

    private final void setStrategyState(Strategy strategy) {
        this.strategyState.setValue(strategy);
    }

    public final Strategy getStrategy() {
        return getStrategyState();
    }

    @Override
    public int calculateMainAxisPageSize(Density density, int i, int i2) {
        float f = i;
        float f2 = i2;
        setStrategyState(new Strategy((KeylineList) this.keylineList.invoke(Float.valueOf(f), Float.valueOf(f2)), f, f2, this.beforeContentPadding, this.afterContentPadding));
        return getStrategy().getIsValid() ? MathKt.roundToInt(getStrategy().getItemMainAxisSize()) : i;
    }
}
