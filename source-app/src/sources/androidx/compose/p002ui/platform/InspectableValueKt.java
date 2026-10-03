package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.Modifier;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a5\u0010\f\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u00042\u0019\b\u0004\u0010\r\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u0004H\u0086\b\u001aA\u0010\u000e\u001a\u00020\u000f*\u00020\u000f2\u0019\b\b\u0010\u0010\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u00042\u0017\u0010\u0011\u001a\u0013\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0\u0001¢\u0006\u0002\b\u0004H\u0087\b\u001a-\u0010\u0012\u001a\u00020\u000f*\u00020\u000f2\u0017\u0010\u0010\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u00042\u0006\u0010\u0013\u001a\u00020\u000fH\u0001\"\"\u0010\u0000\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u001a\u0010\u0007\u001a\u00020\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\t\"\u0004\b\n\u0010\u000b¨\u0006\u0014"}, d2 = {"NoInspectorInfo", "Lkotlin/Function1;", "Landroidx/compose/ui/platform/InspectorInfo;", "", "Lkotlin/ExtensionFunctionType;", "getNoInspectorInfo", "()Lkotlin/jvm/functions/Function1;", "isDebugInspectorInfoEnabled", "", "()Z", "setDebugInspectorInfoEnabled", "(Z)V", "debugInspectorInfo", "definitions", "inspectable", "Landroidx/compose/ui/Modifier;", "inspectorInfo", "factory", "inspectableWrapper", "wrapped", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class InspectableValueKt {
    private static final Function1<InspectorInfo, Unit> NoInspectorInfo = new Function1<InspectorInfo, Unit>() {
        public final void invoke(InspectorInfo inspectorInfo) {
        }

        public Object invoke(Object obj) {
            invoke((InspectorInfo) obj);
            return Unit.INSTANCE;
        }
    };
    private static boolean isDebugInspectorInfoEnabled;

    public static final Function1<InspectorInfo, Unit> getNoInspectorInfo() {
        return NoInspectorInfo;
    }

    public static final boolean isDebugInspectorInfoEnabled() {
        return isDebugInspectorInfoEnabled;
    }

    public static final void setDebugInspectorInfoEnabled(boolean z) {
        isDebugInspectorInfoEnabled = z;
    }

    public static final Function1<InspectorInfo, Unit> debugInspectorInfo(final Function1<? super InspectorInfo, Unit> function1) {
        return isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                function1.invoke(inspectorInfo);
            }
        } : getNoInspectorInfo();
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "This API will create more invalidations of your modifier than necessary, so it's use is discouraged. Implementing the inspectableProperties method on ModifierNodeElement is the recommended zero-cost alternative to exposing properties on a Modifier to tooling.")
    public static final Modifier inspectable(Modifier modifier, Function1<? super InspectorInfo, Unit> function1, Function1<? super Modifier, ? extends Modifier> function2) {
        return inspectableWrapper(modifier, function1, (Modifier) function2.invoke(Modifier.INSTANCE));
    }

    public static final Modifier inspectableWrapper(Modifier modifier, Function1<? super InspectorInfo, Unit> function1, Modifier modifier2) {
        InspectableModifier inspectableModifier = new InspectableModifier(function1);
        return modifier.then(inspectableModifier).then(modifier2).then(inspectableModifier.getEnd());
    }
}
