package androidx.compose.p002ui.modifier;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u001a\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\u001a%\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0017\u0010\u0002\u001a\u0013\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\u0002\b\u0006H\u0007¨\u0006\u0007"}, d2 = {"modifierLocalConsumer", "Landroidx/compose/ui/Modifier;", "consumer", "Lkotlin/Function1;", "Landroidx/compose/ui/modifier/ModifierLocalReadScope;", "", "Lkotlin/ExtensionFunctionType;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ModifierLocalConsumerKt {
    public static final Modifier modifierLocalConsumer(Modifier modifier, final Function1<? super ModifierLocalReadScope, Unit> function1) {
        return modifier.then(new ModifierLocalConsumerImpl(function1, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("modifierLocalConsumer");
                inspectorInfo.getProperties().set("consumer", function1);
            }
        } : InspectableValueKt.getNoInspectorInfo()));
    }
}
