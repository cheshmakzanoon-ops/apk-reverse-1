package zendesk.p026ui.android.conversation.actionbutton;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00192\u00020\u0001:\u0002\u0018\u0019B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0017\u001a\u00020\u0004R&\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR&\u0010\f\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000bR,\u0010\u000e\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\u0013\u001a\u00020\u0014X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016¨\u0006\u001a"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering$Builder;", "(Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering$Builder;)V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "state", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActionButtonRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ActionButtonRendering";
    private final Function2<String, String, Unit> onActionButtonClicked;
    private final Function2<String, String, Unit> onPostbackButtonClicked;
    private final Function3<String, MessageActionSize, String, Unit> onWebViewActionButtonClicked;
    private final ActionButtonState state;

    public ActionButtonRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onActionButtonClicked = builder.getOnActionButtonClicked$zendesk_ui_ui_android();
        this.onPostbackButtonClicked = builder.getOnPostbackButtonClicked$zendesk_ui_ui_android();
        this.onWebViewActionButtonClicked = builder.getOnWebViewActionButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
        return this.onActionButtonClicked;
    }

    public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
        return this.onPostbackButtonClicked;
    }

    public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
        return this.onWebViewActionButtonClicked;
    }

    public final ActionButtonState getState() {
        return this.state;
    }

    public ActionButtonRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u001e\u001a\u00020\u0003J \u0010\u0006\u001a\u00020\u00002\u0018\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J \u0010\u000e\u001a\u00020\u00002\u0018\u0010\u000e\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J&\u0010\u0011\u001a\u00020\u00002\u001e\u0010\u0011\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0012J\u001a\u0010\u0018\u001a\u00020\u00002\u0012\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00190 R,\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR,\u0010\u000e\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u000b\"\u0004\b\u0010\u0010\rR2\u0010\u0011\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u001a\u0010\u0018\u001a\u00020\u0019X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u001b\"\u0004\b\u001c\u0010\u001d¨\u0006!"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering;", "(Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering;)V", "()V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "setOnActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function2;)V", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "setOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "setOnWebViewActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function3;)V", "state", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/actionbutton/ActionButtonState;)V", "build", "stateUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function2<? super String, ? super String, Unit> onActionButtonClicked;
        private Function2<? super String, ? super String, Unit> onPostbackButtonClicked;
        private Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewActionButtonClicked;
        private ActionButtonState state;

        public Builder() {
            this.onActionButtonClicked = new Function2<String, String, Unit>() {
                @Override
                public Unit invoke(String str, String str2) {
                    invoke2(str, str2);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String str, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
                    Logger.m225w("ActionButtonRendering", "ActionButtonRendering#onActionButtonClicked == null", new Object[0]);
                }
            };
            this.onWebViewActionButtonClicked = new Function3<String, MessageActionSize, String, Unit>() {
                @Override
                public Unit invoke(String str, MessageActionSize messageActionSize, String str2) {
                    invoke2(str, messageActionSize, str2);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String str, MessageActionSize messageActionSize, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(messageActionSize, "<anonymous parameter 1>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 2>");
                    Logger.m225w("ActionButtonRendering", "ActionButtonRendering#onWebViewActionButtonClicked == null", new Object[0]);
                }
            };
            this.onPostbackButtonClicked = new Function2<String, String, Unit>() {
                public final void invoke2(String str, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
                }

                @Override
                public Unit invoke(String str, String str2) {
                    invoke2(str, str2);
                    return Unit.INSTANCE;
                }
            };
            this.state = new ActionButtonState(null, null, false, null, null, null, null, false, null, null, 1023, null);
        }

        public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
            return this.onActionButtonClicked;
        }

        public final void setOnActionButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onActionButtonClicked = function2;
        }

        public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
            return this.onWebViewActionButtonClicked;
        }

        public final void setOnWebViewActionButtonClicked$zendesk_ui_ui_android(Function3<? super String, ? super MessageActionSize, ? super String, Unit> function3) {
            Intrinsics.checkNotNullParameter(function3, "<set-?>");
            this.onWebViewActionButtonClicked = function3;
        }

        public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
            return this.onPostbackButtonClicked;
        }

        public final void setOnPostbackButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onPostbackButtonClicked = function2;
        }

        public final ActionButtonState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ActionButtonState actionButtonState) {
            Intrinsics.checkNotNullParameter(actionButtonState, "<set-?>");
            this.state = actionButtonState;
        }

        public Builder(ActionButtonRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onActionButtonClicked = rendering.getOnActionButtonClicked$zendesk_ui_ui_android();
            this.onPostbackButtonClicked = rendering.getOnPostbackButtonClicked$zendesk_ui_ui_android();
            this.onWebViewActionButtonClicked = rendering.getOnWebViewActionButtonClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(ActionButtonRendering actionButtonRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ActionButtonRendering() : actionButtonRendering);
        }

        public final Builder onActionButtonClicked(Function2<? super String, ? super String, Unit> onActionButtonClicked) {
            Intrinsics.checkNotNullParameter(onActionButtonClicked, "onActionButtonClicked");
            this.onActionButtonClicked = onActionButtonClicked;
            return this;
        }

        public final Builder onPostbackButtonClicked(Function2<? super String, ? super String, Unit> onPostbackButtonClicked) {
            Intrinsics.checkNotNullParameter(onPostbackButtonClicked, "onPostbackButtonClicked");
            this.onPostbackButtonClicked = onPostbackButtonClicked;
            return this;
        }

        public final Builder onWebViewActionButtonClicked(Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewActionButtonClicked) {
            Intrinsics.checkNotNullParameter(onWebViewActionButtonClicked, "onWebViewActionButtonClicked");
            this.onWebViewActionButtonClicked = onWebViewActionButtonClicked;
            return this;
        }

        public final Builder state(Function1<? super ActionButtonState, ActionButtonState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ActionButtonRendering build() {
            return new ActionButtonRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/actionbutton/ActionButtonRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
