package zendesk.p026ui.android.conversation.waittimebanner;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.graphics.Color;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Lambda;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001H\u000b¢\u0006\u0004\b\u0002\u0010\u0003"}, m18d2 = {"<anonymous>", "", "invoke", "(Landroidx/compose/runtime/Composer;I)V"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
final class WaitTimeBannerView$composeView$1$1 extends Lambda implements Function2<Composer, Integer, Unit> {
    final WaitTimeBannerView this$0;

    WaitTimeBannerView$composeView$1$1(WaitTimeBannerView waitTimeBannerView) {
        super(2);
        this.this$0 = waitTimeBannerView;
    }

    @Override
    public Unit invoke(Composer composer, Integer num) {
        invoke(composer, num.intValue());
        return Unit.INSTANCE;
    }

    private static final boolean invoke$lambda$0(MutableState<Boolean> mutableState) {
        return ((Boolean) ((State) mutableState).getValue()).booleanValue();
    }

    public static final void invoke$lambda$1(MutableState<Boolean> mutableState, boolean z) {
        mutableState.setValue(Boolean.valueOf(z));
    }

    public final void invoke(Composer composer, int i) {
        if ((i & 11) != 2 || !composer.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(219617718, i, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBannerView.<anonymous>.<anonymous> (WaitTimeBannerView.kt:55)");
            }
            final MutableState mutableState = (MutableState) RememberSaveableKt.rememberSaveable(new Object[0], (Saver) null, (String) null, new Function0<MutableState<Boolean>>() {
                @Override
                public final MutableState<Boolean> invoke() {
                    return SnapshotStateKt.mutableStateOf$default(false, (SnapshotMutationPolicy) null, 2, (Object) null);
                }
            }, composer, 3080, 6);
            WaitTimeBannerType waitTimeBannerType = (WaitTimeBannerType) this.this$0.bannerType.getValue();
            long j = ((Color) this.this$0.onBackgroundColor.getValue()).unbox-impl();
            long j2 = ((Color) this.this$0.onBackgroundColor.getValue()).unbox-impl();
            long j3 = ((Color) this.this$0.onBackgroundColor.getValue()).unbox-impl();
            long j4 = ((Color) this.this$0.onBackgroundColor.getValue()).unbox-impl();
            long j5 = ((Color) this.this$0.focusedBorderColor.getValue()).unbox-impl();
            boolean zInvoke$lambda$0 = invoke$lambda$0(mutableState);
            composer.startReplaceGroup(-744206085);
            boolean zChanged = composer.changed(mutableState);
            Object objRememberedValue = composer.rememberedValue();
            if (zChanged || objRememberedValue == Composer.Companion.getEmpty()) {
                objRememberedValue = (Function1) new Function1<Boolean, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z) {
                        WaitTimeBannerView$composeView$1$1.invoke$lambda$1(mutableState, z);
                    }
                };
                composer.updateRememberedValue(objRememberedValue);
            }
            composer.endReplaceGroup();
            WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(waitTimeBannerType, j, j4, j5, j2, j3, zInvoke$lambda$0, (Function1) objRememberedValue, null, composer, 0, 256);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
                return;
            }
            return;
        }
        composer.skipToGroupEnd();
    }
}
