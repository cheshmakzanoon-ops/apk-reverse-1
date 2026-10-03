package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u000b\n\u0000\u001a \u0010\u0000\u001a\u00020\u0001*\u00020\u00012\b\b\u0001\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005H\u0007¨\u0006\u0006"}, d2 = {"aspectRatio", "Landroidx/compose/ui/Modifier;", "ratio", "", "matchHeightConstraintsFirst", "", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AspectRatioKt {
    public static Modifier aspectRatio$default(Modifier modifier, float f, boolean z, int i, Object obj) {
        if ((i & 2) != 0) {
            z = false;
        }
        return aspectRatio(modifier, f, z);
    }

    public static final Modifier aspectRatio(Modifier modifier, final float f, final boolean z) {
        return modifier.then(new AspectRatioElement(f, z, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("aspectRatio");
                inspectorInfo.getProperties().set("ratio", Float.valueOf(f));
                inspectorInfo.getProperties().set("matchHeightConstraintsFirst", Boolean.valueOf(z));
            }
        } : InspectableValueKt.getNoInspectorInfo()));
    }
}
