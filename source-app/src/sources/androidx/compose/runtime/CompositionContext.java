package androidx.compose.runtime;

import androidx.compose.runtime.tooling.CompositionData;
import java.util.Set;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000x\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010#\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\f\b'\u0018\u00002\u00020\u0001B\u0007\b\u0000¢\u0006\u0002\u0010\u0002J*\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001c2\u0011\u0010\u001d\u001a\r\u0012\u0004\u0012\u00020\u001a0\u001e¢\u0006\u0002\b\u001fH ¢\u0006\u0004\b \u0010!J\u0015\u0010\"\u001a\u00020\u001a2\u0006\u0010#\u001a\u00020$H ¢\u0006\u0002\b%J\r\u0010&\u001a\u00020\u001aH\u0010¢\u0006\u0002\b'J\r\u0010(\u001a\u00020)H\u0010¢\u0006\u0002\b*J\u0015\u0010+\u001a\u00020\u001a2\u0006\u0010#\u001a\u00020$H ¢\u0006\u0002\b,J\u0015\u0010-\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH ¢\u0006\u0002\b.J\u0015\u0010/\u001a\u00020\u001a2\u0006\u00100\u001a\u000201H ¢\u0006\u0002\b2J\u001d\u00103\u001a\u00020\u001a2\u0006\u0010#\u001a\u00020$2\u0006\u00104\u001a\u000205H ¢\u0006\u0002\b6J\u0017\u00107\u001a\u0004\u0018\u0001052\u0006\u0010#\u001a\u00020$H\u0010¢\u0006\u0002\b8J\u001b\u00109\u001a\u00020\u001a2\f\u0010:\u001a\b\u0012\u0004\u0012\u00020<0;H\u0010¢\u0006\u0002\b=J\u0015\u0010>\u001a\u00020\u001a2\u0006\u0010?\u001a\u00020@H\u0010¢\u0006\u0002\bAJ\u0015\u0010B\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH ¢\u0006\u0002\bCJ\u0015\u0010D\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH ¢\u0006\u0002\bEJ\r\u0010F\u001a\u00020\u001aH\u0010¢\u0006\u0002\bGJ\u0015\u0010H\u001a\u00020\u001a2\u0006\u0010?\u001a\u00020@H\u0010¢\u0006\u0002\bIJ\u0015\u0010J\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH ¢\u0006\u0002\bKR\u0012\u0010\u0003\u001a\u00020\u0004X \u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0012\u0010\u0007\u001a\u00020\u0004X \u0004¢\u0006\u0006\u001a\u0004\b\b\u0010\u0006R\u0012\u0010\t\u001a\u00020\u0004X \u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u0006R\u0012\u0010\u000b\u001a\u00020\fX \u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0012\u0010\u000f\u001a\u00020\u0010X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R\u0016\u0010\u0013\u001a\u0004\u0018\u00010\u00148PX\u0090\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0016R\u0012\u0010\u0017\u001a\u00020\u0010X \u0004¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0012¨\u0006L"}, d2 = {"Landroidx/compose/runtime/CompositionContext;", "", "()V", "collectingCallByInformation", "", "getCollectingCallByInformation$runtime_release", "()Z", "collectingParameterInformation", "getCollectingParameterInformation$runtime_release", "collectingSourceInformation", "getCollectingSourceInformation$runtime_release", "compoundHashKey", "", "getCompoundHashKey$runtime_release", "()I", "effectCoroutineContext", "Lkotlin/coroutines/CoroutineContext;", "getEffectCoroutineContext", "()Lkotlin/coroutines/CoroutineContext;", "observerHolder", "Landroidx/compose/runtime/CompositionObserverHolder;", "getObserverHolder$runtime_release", "()Landroidx/compose/runtime/CompositionObserverHolder;", "recomposeCoroutineContext", "getRecomposeCoroutineContext$runtime_release", "composeInitial", "", "composition", "Landroidx/compose/runtime/ControlledComposition;", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "composeInitial$runtime_release", "(Landroidx/compose/runtime/ControlledComposition;Lkotlin/jvm/functions/Function2;)V", "deletedMovableContent", "reference", "Landroidx/compose/runtime/MovableContentStateReference;", "deletedMovableContent$runtime_release", "doneComposing", "doneComposing$runtime_release", "getCompositionLocalScope", "Landroidx/compose/runtime/PersistentCompositionLocalMap;", "getCompositionLocalScope$runtime_release", "insertMovableContent", "insertMovableContent$runtime_release", "invalidate", "invalidate$runtime_release", "invalidateScope", "scope", "Landroidx/compose/runtime/RecomposeScopeImpl;", "invalidateScope$runtime_release", "movableContentStateReleased", "data", "Landroidx/compose/runtime/MovableContentState;", "movableContentStateReleased$runtime_release", "movableContentStateResolve", "movableContentStateResolve$runtime_release", "recordInspectionTable", "table", "", "Landroidx/compose/runtime/tooling/CompositionData;", "recordInspectionTable$runtime_release", "registerComposer", "composer", "Landroidx/compose/runtime/Composer;", "registerComposer$runtime_release", "registerComposition", "registerComposition$runtime_release", "reportRemovedComposition", "reportRemovedComposition$runtime_release", "startComposing", "startComposing$runtime_release", "unregisterComposer", "unregisterComposer$runtime_release", "unregisterComposition", "unregisterComposition$runtime_release", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class CompositionContext {
    public static final int $stable = 0;

    public abstract void composeInitial$runtime_release(ControlledComposition composition, Function2<? super Composer, ? super Integer, Unit> content);

    public abstract void deletedMovableContent$runtime_release(MovableContentStateReference reference);

    public void doneComposing$runtime_release() {
    }

    public abstract boolean getCollectingCallByInformation$runtime_release();

    public abstract boolean getCollectingParameterInformation$runtime_release();

    public abstract boolean getCollectingSourceInformation$runtime_release();

    public abstract int getCompoundHashKey$runtime_release();

    public abstract CoroutineContext getEffectCoroutineContext();

    public CompositionObserverHolder getObserverHolder$runtime_release() {
        return null;
    }

    public abstract CoroutineContext getRecomposeCoroutineContext$runtime_release();

    public abstract void insertMovableContent$runtime_release(MovableContentStateReference reference);

    public abstract void invalidate$runtime_release(ControlledComposition composition);

    public abstract void invalidateScope$runtime_release(RecomposeScopeImpl scope);

    public abstract void movableContentStateReleased$runtime_release(MovableContentStateReference reference, MovableContentState data);

    public MovableContentState movableContentStateResolve$runtime_release(MovableContentStateReference reference) {
        return null;
    }

    public void recordInspectionTable$runtime_release(Set<CompositionData> table) {
    }

    public void registerComposer$runtime_release(Composer composer) {
    }

    public abstract void registerComposition$runtime_release(ControlledComposition composition);

    public abstract void reportRemovedComposition$runtime_release(ControlledComposition composition);

    public void startComposing$runtime_release() {
    }

    public void unregisterComposer$runtime_release(Composer composer) {
    }

    public abstract void unregisterComposition$runtime_release(ControlledComposition composition);

    public PersistentCompositionLocalMap getCompositionLocalScope$runtime_release() {
        return CompositionContextKt.EmptyPersistentCompositionLocalMap;
    }
}
