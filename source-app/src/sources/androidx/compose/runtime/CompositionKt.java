package androidx.compose.runtime;

import androidx.collection.MutableIntList;
import java.util.List;
import kotlin.Metadata;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;

@Metadata(d1 = {"\u0000R\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010!\n\u0000\u001a\u001a\u0010\u000e\u001a\u00020\u000f2\n\u0010\u0010\u001a\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u0013\u001a$\u0010\u000e\u001a\u00020\u000f2\n\u0010\u0010\u001a\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0007\u001a\u00020\bH\u0007\u001a\u001c\u0010\u0014\u001a\u00020\t2\n\u0010\u0010\u001a\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0007\u001a$\u0010\u0014\u001a\u00020\t2\n\u0010\u0010\u001a\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0007\u001a\u00020\bH\u0007\u001a\u001a\u0010\u0015\u001a\u00020\u00162\n\u0010\u0010\u001a\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u0013\u001a'\u0010\u0017\u001a\u0004\u0018\u0001H\u0018\"\u0004\b\u0000\u0010\u0018*\u00020\u000f2\f\u0010\u0019\u001a\b\u0012\u0004\u0012\u0002H\u00180\u0001H\u0000¢\u0006\u0002\u0010\u001a\u001a\u001c\u0010\u001b\u001a\u00020\u001c*\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u001fH\u0002\u001a(\u0010\u001b\u001a\u00020\u001c\"\u0004\b\u0000\u0010\u0018*\b\u0012\u0004\u0012\u0002H\u00180!2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u001fH\u0002\"\u001a\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001e\u0010\u0007\u001a\u00020\b*\u00020\t8GX\u0087\u0004¢\u0006\f\u0012\u0004\b\n\u0010\u000b\u001a\u0004\b\f\u0010\r¨\u0006\""}, d2 = {"CompositionImplServiceKey", "Landroidx/compose/runtime/CompositionServiceKey;", "Landroidx/compose/runtime/CompositionImpl;", "getCompositionImplServiceKey", "()Landroidx/compose/runtime/CompositionServiceKey;", "PendingApplyNoModifications", "", "recomposeCoroutineContext", "Lkotlin/coroutines/CoroutineContext;", "Landroidx/compose/runtime/ControlledComposition;", "getRecomposeCoroutineContext$annotations", "(Landroidx/compose/runtime/ControlledComposition;)V", "getRecomposeCoroutineContext", "(Landroidx/compose/runtime/ControlledComposition;)Lkotlin/coroutines/CoroutineContext;", "Composition", "Landroidx/compose/runtime/Composition;", "applier", "Landroidx/compose/runtime/Applier;", "parent", "Landroidx/compose/runtime/CompositionContext;", "ControlledComposition", "ReusableComposition", "Landroidx/compose/runtime/ReusableComposition;", "getCompositionService", "T", "key", "(Landroidx/compose/runtime/Composition;Landroidx/compose/runtime/CompositionServiceKey;)Ljava/lang/Object;", "swap", "", "Landroidx/collection/MutableIntList;", "a", "", "b", "", "runtime_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CompositionKt {
    private static final Object PendingApplyNoModifications = new Object();
    private static final CompositionServiceKey<CompositionImpl> CompositionImplServiceKey = new CompositionServiceKey<CompositionImpl>() {
    };

    public static void getRecomposeCoroutineContext$annotations(ControlledComposition controlledComposition) {
    }

    public static final <T> T getCompositionService(Composition composition, CompositionServiceKey<T> compositionServiceKey) {
        CompositionServices compositionServices = composition instanceof CompositionServices ? (CompositionServices) composition : null;
        if (compositionServices != null) {
            return (T) compositionServices.getCompositionService(compositionServiceKey);
        }
        return null;
    }

    public static final CoroutineContext getRecomposeCoroutineContext(ControlledComposition controlledComposition) {
        CoroutineContext recomposeContext;
        CompositionImpl compositionImpl = controlledComposition instanceof CompositionImpl ? (CompositionImpl) controlledComposition : null;
        return (compositionImpl == null || (recomposeContext = compositionImpl.getRecomposeContext()) == null) ? EmptyCoroutineContext.INSTANCE : recomposeContext;
    }

    public static final Composition Composition(Applier<?> applier, CompositionContext compositionContext) {
        return new CompositionImpl(compositionContext, applier, null, 4, null);
    }

    public static final ReusableComposition ReusableComposition(Applier<?> applier, CompositionContext compositionContext) {
        return new CompositionImpl(compositionContext, applier, null, 4, null);
    }

    public static final ControlledComposition ControlledComposition(Applier<?> applier, CompositionContext compositionContext) {
        return new CompositionImpl(compositionContext, applier, null, 4, null);
    }

    public static final Composition Composition(Applier<?> applier, CompositionContext compositionContext, CoroutineContext coroutineContext) {
        return new CompositionImpl(compositionContext, applier, coroutineContext);
    }

    public static final ControlledComposition ControlledComposition(Applier<?> applier, CompositionContext compositionContext, CoroutineContext coroutineContext) {
        return new CompositionImpl(compositionContext, applier, coroutineContext);
    }

    public static final CompositionServiceKey<CompositionImpl> getCompositionImplServiceKey() {
        return CompositionImplServiceKey;
    }

    public static final <T> void swap(List<T> list, int i, int i2) {
        T t = list.get(i);
        list.set(i, list.get(i2));
        list.set(i2, t);
    }

    public static final void swap(MutableIntList mutableIntList, int i, int i2) {
        int i3 = mutableIntList.get(i);
        mutableIntList.set(i, mutableIntList.get(i2));
        mutableIntList.set(i2, i3);
    }
}
