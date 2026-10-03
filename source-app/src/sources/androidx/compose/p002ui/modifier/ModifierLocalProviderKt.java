package androidx.compose.p002ui.modifier;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.p002ui.platform.InspectorValueInfo;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a.\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u0002H\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0007¨\u0006\u0007"}, d2 = {"modifierLocalProvider", "Landroidx/compose/ui/Modifier;", "T", "key", "Landroidx/compose/ui/modifier/ProvidableModifierLocal;", "value", "Lkotlin/Function0;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ModifierLocalProviderKt {

    @Metadata(d1 = {"\u0000\u0017\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u00012\u00020\u0002R\u001a\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u001b\u0010\u0007\u001a\u00028\u00008VX\u0096\u0084\u0002¢\u0006\f\n\u0004\b\n\u0010\u000b\u001a\u0004\b\b\u0010\t¨\u0006\f"}, d2 = {"androidx/compose/ui/modifier/ModifierLocalProviderKt$modifierLocalProvider$1", "Landroidx/compose/ui/modifier/ModifierLocalProvider;", "Landroidx/compose/ui/platform/InspectorValueInfo;", "key", "Landroidx/compose/ui/modifier/ProvidableModifierLocal;", "getKey", "()Landroidx/compose/ui/modifier/ProvidableModifierLocal;", "value", "getValue", "()Ljava/lang/Object;", "value$delegate", "Landroidx/compose/runtime/State;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class C16691<T> extends InspectorValueInfo implements ModifierLocalProvider<T> {
        private final ProvidableModifierLocal<T> key;

        private final State value;

        @Override
        public boolean all(Function1 function1) {
            return Modifier.Element.CC.$default$all(this, function1);
        }

        @Override
        public boolean any(Function1 function1) {
            return Modifier.Element.CC.$default$any(this, function1);
        }

        @Override
        public Object foldIn(Object obj, Function2 function2) {
            return Modifier.Element.CC.$default$foldIn(this, obj, function2);
        }

        @Override
        public Object foldOut(Object obj, Function2 function2) {
            return Modifier.Element.CC.$default$foldOut(this, obj, function2);
        }

        @Override
        public Modifier then(Modifier modifier) {
            return Modifier.CC.$default$then(this, modifier);
        }

        C16691(ProvidableModifierLocal<T> providableModifierLocal, Function0<? extends T> function0, Function1<? super InspectorInfo, Unit> function1) {
            super(function1);
            this.key = providableModifierLocal;
            this.value = SnapshotStateKt.derivedStateOf(function0);
        }

        @Override
        public ProvidableModifierLocal<T> getKey() {
            return this.key;
        }

        @Override
        public T getValue() {
            return (T) this.value.getValue();
        }
    }

    public static final <T> Modifier modifierLocalProvider(Modifier modifier, final ProvidableModifierLocal<T> providableModifierLocal, final Function0<? extends T> function0) {
        return modifier.then(new C16691(providableModifierLocal, function0, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("modifierLocalProvider");
                inspectorInfo.getProperties().set("key", providableModifierLocal);
                inspectorInfo.getProperties().set("value", function0);
            }
        } : InspectableValueKt.getNoInspectorInfo()));
    }
}
