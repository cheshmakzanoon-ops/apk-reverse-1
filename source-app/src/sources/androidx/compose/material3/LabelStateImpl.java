package androidx.compose.material3;

import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.foundation.MutatePriority;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0002\u0018\u00002\u00020\u0001B\u0019\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\b\u0010\u000b\u001a\u00020\fH\u0016J\b\u0010\r\u001a\u00020\fH\u0016J\u0016\u0010\u000e\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\u0010H\u0096@¢\u0006\u0002\u0010\u0011R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0004\u0010\u0006R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0006R\u001a\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00030\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0012"}, d2 = {"Landroidx/compose/material3/LabelStateImpl;", "Landroidx/compose/material3/TooltipState;", "isVisible", "", "isPersistent", "(ZZ)V", "()Z", "transition", "Landroidx/compose/animation/core/MutableTransitionState;", "getTransition", "()Landroidx/compose/animation/core/MutableTransitionState;", "dismiss", "", "onDispose", "show", "mutatePriority", "Landroidx/compose/foundation/MutatePriority;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class LabelStateImpl implements TooltipState {
    private final boolean isPersistent;
    private final boolean isVisible;
    private final MutableTransitionState<Boolean> transition;

    public LabelStateImpl() {
        boolean z = false;
        this(z, z, 3, null);
    }

    @Override
    public void dismiss() {
    }

    @Override
    public void onDispose() {
    }

    public LabelStateImpl(boolean z, boolean z2) {
        this.isVisible = z;
        this.isPersistent = z2;
        this.transition = new MutableTransitionState<>(false);
    }

    public LabelStateImpl(boolean z, boolean z2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? true : z, (i & 2) != 0 ? true : z2);
    }

    @Override
    public boolean getIsVisible() {
        return this.isVisible;
    }

    @Override
    public boolean getIsPersistent() {
        return this.isPersistent;
    }

    @Override
    public MutableTransitionState<Boolean> getTransition() {
        return this.transition;
    }

    @Override
    public Object show(MutatePriority mutatePriority, Continuation<? super Unit> continuation) {
        return Unit.INSTANCE;
    }
}
