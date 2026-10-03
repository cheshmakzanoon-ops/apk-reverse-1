package androidx.compose.foundation.contextmenu;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B\u0007\b\u0000¢\u0006\u0002\u0010\u0002J\u0017\u0010\f\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\u0006H\u0001¢\u0006\u0004\b\r\u0010\u000eJ\r\u0010\u000f\u001a\u00020\nH\u0000¢\u0006\u0002\b\u0010Jl\u0010\u0011\u001a\u00020\n2\u0011\u0010\u0012\u001a\r\u0012\u0004\u0012\u00020\u00140\u0013¢\u0006\u0002\b\u000b2\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\u00182*\b\u0002\u0010\u0019\u001a$\u0012\u0013\u0012\u00110\u001a¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u001b\u0012\u0004\u0012\u00020\n\u0018\u00010\u0005¢\u0006\u0002\b\u000b2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\n0\u0013¢\u0006\u0002\u0010\u001dR4\u0010\u0003\u001a(\u0012$\u0012\"\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\t\u0012\u0004\u0012\u00020\n0\u0005¢\u0006\u0002\b\u000b0\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001e"}, d2 = {"Landroidx/compose/foundation/contextmenu/ContextMenuScope;", "", "()V", "composables", "Landroidx/compose/runtime/snapshots/SnapshotStateList;", "Lkotlin/Function1;", "Landroidx/compose/foundation/contextmenu/ContextMenuColors;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "colors", "", "Landroidx/compose/runtime/Composable;", "Content", "Content$foundation_release", "(Landroidx/compose/foundation/contextmenu/ContextMenuColors;Landroidx/compose/runtime/Composer;I)V", "clear", "clear$foundation_release", "item", "label", "Lkotlin/Function0;", "", "modifier", "Landroidx/compose/ui/Modifier;", "enabled", "", "leadingIcon", "Landroidx/compose/ui/graphics/Color;", "iconColor", "onClick", "(Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/Modifier;ZLkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function0;)V", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ContextMenuScope {
    public static final int $stable = 0;
    private final SnapshotStateList<Function3<ContextMenuColors, Composer, Integer, Unit>> composables = SnapshotStateKt.mutableStateListOf();

    public final void Content$foundation_release(final ContextMenuColors contextMenuColors, Composer composer, final int i) {
        Composer composerStartRestartGroup = composer.startRestartGroup(1320309496);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Content)*234@8533L18:ContextMenuUi.android.kt#3xeu6s");
        int i2 = (i & 6) == 0 ? (composerStartRestartGroup.changed(contextMenuColors) ? 4 : 2) | i : i;
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(this) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1320309496, i2, -1, "androidx.compose.foundation.contextmenu.ContextMenuScope.Content (ContextMenuUi.android.kt:233)");
            }
            SnapshotStateList<Function3<ContextMenuColors, Composer, Integer, Unit>> snapshotStateList = this.composables;
            int size = snapshotStateList.size();
            for (int i3 = 0; i3 < size; i3++) {
                snapshotStateList.get(i3).invoke(contextMenuColors, composerStartRestartGroup, Integer.valueOf(i2 & 14));
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    this.$tmp0_rcvr.Content$foundation_release(contextMenuColors, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public final void clear$foundation_release() {
        this.composables.clear();
    }

    public static void item$default(ContextMenuScope contextMenuScope, Function2 function2, Modifier modifier, boolean z, Function3 function3, Function0 function0, int i, Object obj) {
        if ((i & 2) != 0) {
            modifier = Modifier.INSTANCE;
        }
        Modifier modifier2 = modifier;
        if ((i & 4) != 0) {
            z = true;
        }
        boolean z2 = z;
        if ((i & 8) != 0) {
            function3 = null;
        }
        contextMenuScope.item(function2, modifier2, z2, function3, function0);
    }

    public final void item(final Function2<? super Composer, ? super Integer, String> label, final Modifier modifier, final boolean enabled, final Function3<? super Color, ? super Composer, ? super Integer, Unit> leadingIcon, final Function0<Unit> onClick) {
        this.composables.add(ComposableLambdaKt.composableLambdaInstance(262103052, true, new Function3<ContextMenuColors, Composer, Integer, Unit>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                invoke((ContextMenuColors) obj, (Composer) obj2, ((Number) obj3).intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(ContextMenuColors contextMenuColors, Composer composer, int i) {
                ComposerKt.sourceInformation(composer, "C275@10323L7,277@10419L251:ContextMenuUi.android.kt#3xeu6s");
                if ((i & 6) == 0) {
                    i |= composer.changed(contextMenuColors) ? 4 : 2;
                }
                if ((i & 19) != 18 || !composer.getSkipping()) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(262103052, i, -1, "androidx.compose.foundation.contextmenu.ContextMenuScope.item.<anonymous> (ContextMenuUi.android.kt:275)");
                    }
                    String str = (String) label.invoke(composer, 0);
                    if (StringsKt.isBlank(str)) {
                        throw new IllegalStateException("Label must not be blank".toString());
                    }
                    ContextMenuUi_androidKt.ContextMenuItem(str, enabled, contextMenuColors, modifier, leadingIcon, onClick, composer, (i << 6) & 896, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                        return;
                    }
                    return;
                }
                composer.skipToGroupEnd();
            }
        }));
    }
}
