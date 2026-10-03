package zendesk.p026ui.android.conversation.conversationextension;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 &2\u00020\u0001:\u0002%&B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010$\u001a\u00020\u0004R\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u001a\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\nR\u001a\u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\nR\u001a\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\nR/\u0010\u0011\u001a\u001d\u0012\u0013\u0012\u00110\u0013¢\u0006\f\b\u0014\u0012\b\b\u0015\u0012\u0004\b\b(\u0016\u0012\u0004\u0012\u00020\b0\u0012X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u001a\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\nR1\u0010\u001b\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0013¢\u0006\f\b\u0014\u0012\b\b\u0015\u0012\u0004\b\b(\u001c\u0012\u0004\u0012\u00020\b0\u0012X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0018R\u001a\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\nR\u0014\u0010 \u001a\u00020!X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#¨\u0006'"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering$Builder;", "(Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering$Builder;)V", "onBackButtonClicked", "Lkotlin/Function0;", "", "getOnBackButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "onCloseButtonClicked", "getOnCloseButtonClicked$zendesk_ui_ui_android", "onPageLoadingComplete", "getOnPageLoadingComplete$zendesk_ui_ui_android", "onRetryButtonClicked", "getOnRetryButtonClicked$zendesk_ui_ui_android", "onUrlUpdated", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", "name", "url", "getOnUrlUpdated$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "onWebSdkClose", "getOnWebSdkClose$zendesk_ui_ui_android", "onWebSdkUpdateTitle", "title", "getOnWebSdkUpdateTitle$zendesk_ui_ui_android", "onWebViewError", "getOnWebViewError$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationExtensionRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConversationExtensionRendering";
    private final Function0<Unit> onBackButtonClicked;
    private final Function0<Unit> onCloseButtonClicked;
    private final Function0<Unit> onPageLoadingComplete;
    private final Function0<Unit> onRetryButtonClicked;
    private final Function1<String, Unit> onUrlUpdated;
    private final Function0<Unit> onWebSdkClose;
    private final Function1<String, Unit> onWebSdkUpdateTitle;
    private final Function0<Unit> onWebViewError;
    private final ConversationExtensionState state;

    public ConversationExtensionRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onRetryButtonClicked = builder.getOnRetryButtonClicked$zendesk_ui_ui_android();
        this.onCloseButtonClicked = builder.getOnCloseButtonClicked$zendesk_ui_ui_android();
        this.onWebSdkClose = builder.getOnWebSdkClose$zendesk_ui_ui_android();
        this.onWebSdkUpdateTitle = builder.getOnWebSdkUpdateTitle$zendesk_ui_ui_android();
        this.onWebViewError = builder.getOnWebViewError$zendesk_ui_ui_android();
        this.onUrlUpdated = builder.getOnUrlUpdated$zendesk_ui_ui_android();
        this.onPageLoadingComplete = builder.getOnPageLoadingComplete$zendesk_ui_ui_android();
        this.onBackButtonClicked = builder.getOnBackButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnRetryButtonClicked$zendesk_ui_ui_android() {
        return this.onRetryButtonClicked;
    }

    public final Function0<Unit> getOnCloseButtonClicked$zendesk_ui_ui_android() {
        return this.onCloseButtonClicked;
    }

    public final Function0<Unit> getOnWebSdkClose$zendesk_ui_ui_android() {
        return this.onWebSdkClose;
    }

    public final Function1<String, Unit> getOnWebSdkUpdateTitle$zendesk_ui_ui_android() {
        return this.onWebSdkUpdateTitle;
    }

    public final Function0<Unit> getOnWebViewError$zendesk_ui_ui_android() {
        return this.onWebViewError;
    }

    public final Function1<String, Unit> getOnUrlUpdated$zendesk_ui_ui_android() {
        return this.onUrlUpdated;
    }

    public final Function0<Unit> getOnPageLoadingComplete$zendesk_ui_ui_android() {
        return this.onPageLoadingComplete;
    }

    public final Function0<Unit> getOnBackButtonClicked$zendesk_ui_ui_android() {
        return this.onBackButtonClicked;
    }

    public final ConversationExtensionState getState() {
        return this.state;
    }

    public ConversationExtensionRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u00100\u001a\u00020\u0003J\u0014\u0010\u0006\u001a\u00020\u00002\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0014\u0010\r\u001a\u00020\u00002\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0014\u0010\u0010\u001a\u00020\u00002\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u0014\u0010\u0013\u001a\u00020\u00002\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J)\u0010\u0016\u001a\u00020\u00002!\u0010\u0016\u001a\u001d\u0012\u0013\u0012\u00110\u0018¢\u0006\f\b\u0019\u0012\b\b\u001a\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\b0\u0017J\u0014\u0010 \u001a\u00020\u00002\f\u0010 \u001a\b\u0012\u0004\u0012\u00020\b0\u0007J+\u0010#\u001a\u00020\u00002#\u0010#\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0018¢\u0006\f\b\u0019\u0012\b\b\u001a\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\b0\u0017J\u0014\u0010'\u001a\u00020\u00002\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\b0\u0007J\u001a\u0010*\u001a\u00020\u00002\u0012\u00101\u001a\u000e\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020+0\u0017R \u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR \u0010\r\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\n\"\u0004\b\u000f\u0010\fR \u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\n\"\u0004\b\u0012\u0010\fR \u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\n\"\u0004\b\u0015\u0010\fR5\u0010\u0016\u001a\u001d\u0012\u0013\u0012\u00110\u0018¢\u0006\f\b\u0019\u0012\b\b\u001a\u0012\u0004\b\b(\u001b\u0012\u0004\u0012\u00020\b0\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR \u0010 \u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\n\"\u0004\b\"\u0010\fR7\u0010#\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0018¢\u0006\f\b\u0019\u0012\b\b\u001a\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\b0\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010\u001d\"\u0004\b&\u0010\u001fR \u0010'\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b(\u0010\n\"\u0004\b)\u0010\fR\u001a\u0010*\u001a\u00020+X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b,\u0010-\"\u0004\b.\u0010/¨\u00062"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering;", "(Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering;)V", "()V", "onBackButtonClicked", "Lkotlin/Function0;", "", "getOnBackButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnBackButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "onCloseButtonClicked", "getOnCloseButtonClicked$zendesk_ui_ui_android", "setOnCloseButtonClicked$zendesk_ui_ui_android", "onPageLoadingComplete", "getOnPageLoadingComplete$zendesk_ui_ui_android", "setOnPageLoadingComplete$zendesk_ui_ui_android", "onRetryButtonClicked", "getOnRetryButtonClicked$zendesk_ui_ui_android", "setOnRetryButtonClicked$zendesk_ui_ui_android", "onUrlUpdated", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", "name", "url", "getOnUrlUpdated$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnUrlUpdated$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "onWebSdkClose", "getOnWebSdkClose$zendesk_ui_ui_android", "setOnWebSdkClose$zendesk_ui_ui_android", "onWebSdkUpdateTitle", "title", "getOnWebSdkUpdateTitle$zendesk_ui_ui_android", "setOnWebSdkUpdateTitle$zendesk_ui_ui_android", "onWebViewError", "getOnWebViewError$zendesk_ui_ui_android", "setOnWebViewError$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionState;)V", "build", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function0<Unit> onBackButtonClicked;
        private Function0<Unit> onCloseButtonClicked;
        private Function0<Unit> onPageLoadingComplete;
        private Function0<Unit> onRetryButtonClicked;
        private Function1<? super String, Unit> onUrlUpdated;
        private Function0<Unit> onWebSdkClose;
        private Function1<? super String, Unit> onWebSdkUpdateTitle;
        private Function0<Unit> onWebViewError;
        private ConversationExtensionState state;

        public Builder() {
            this.onRetryButtonClicked = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onRetryButtonClicked == null", new Object[0]);
                }
            };
            this.onCloseButtonClicked = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onCloseButtonClicked == null", new Object[0]);
                }
            };
            this.onWebSdkClose = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onWebSdkClose == null", new Object[0]);
                }
            };
            this.onWebViewError = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onWebViewError == null", new Object[0]);
                }
            };
            this.onWebSdkUpdateTitle = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String str) {
                    Logger.m225w("ConversationExtensionRendering", "onWebSdkUpdateTitle == null", new Object[0]);
                }
            };
            this.onUrlUpdated = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("ConversationExtensionRendering", "onUrlUpdated == null", new Object[0]);
                }
            };
            this.onPageLoadingComplete = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onPageLoadingComplete == null", new Object[0]);
                }
            };
            this.onBackButtonClicked = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ConversationExtensionRendering", "onBackButtonClicked == null", new Object[0]);
                }
            };
            this.state = new ConversationExtensionState(null, 0, 0, 0, 0, 0, 0, 0, 0, null, null, null, false, 8191, null);
        }

        public final Function0<Unit> getOnRetryButtonClicked$zendesk_ui_ui_android() {
            return this.onRetryButtonClicked;
        }

        public final void setOnRetryButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryButtonClicked = function0;
        }

        public final Function0<Unit> getOnCloseButtonClicked$zendesk_ui_ui_android() {
            return this.onCloseButtonClicked;
        }

        public final void setOnCloseButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onCloseButtonClicked = function0;
        }

        public final Function0<Unit> getOnWebSdkClose$zendesk_ui_ui_android() {
            return this.onWebSdkClose;
        }

        public final void setOnWebSdkClose$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onWebSdkClose = function0;
        }

        public final Function0<Unit> getOnWebViewError$zendesk_ui_ui_android() {
            return this.onWebViewError;
        }

        public final void setOnWebViewError$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onWebViewError = function0;
        }

        public final Function1<String, Unit> getOnWebSdkUpdateTitle$zendesk_ui_ui_android() {
            return this.onWebSdkUpdateTitle;
        }

        public final void setOnWebSdkUpdateTitle$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onWebSdkUpdateTitle = function1;
        }

        public final Function1<String, Unit> getOnUrlUpdated$zendesk_ui_ui_android() {
            return this.onUrlUpdated;
        }

        public final void setOnUrlUpdated$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onUrlUpdated = function1;
        }

        public final Function0<Unit> getOnPageLoadingComplete$zendesk_ui_ui_android() {
            return this.onPageLoadingComplete;
        }

        public final void setOnPageLoadingComplete$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onPageLoadingComplete = function0;
        }

        public final Function0<Unit> getOnBackButtonClicked$zendesk_ui_ui_android() {
            return this.onBackButtonClicked;
        }

        public final void setOnBackButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBackButtonClicked = function0;
        }

        public final ConversationExtensionState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ConversationExtensionState conversationExtensionState) {
            Intrinsics.checkNotNullParameter(conversationExtensionState, "<set-?>");
            this.state = conversationExtensionState;
        }

        public Builder(ConversationExtensionRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.state = rendering.getState();
        }

        public Builder(ConversationExtensionRendering conversationExtensionRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ConversationExtensionRendering() : conversationExtensionRendering);
        }

        public final Builder onRetryButtonClicked(Function0<Unit> onRetryButtonClicked) {
            Intrinsics.checkNotNullParameter(onRetryButtonClicked, "onRetryButtonClicked");
            this.onRetryButtonClicked = onRetryButtonClicked;
            return this;
        }

        public final Builder onCloseButtonClicked(Function0<Unit> onCloseButtonClicked) {
            Intrinsics.checkNotNullParameter(onCloseButtonClicked, "onCloseButtonClicked");
            this.onCloseButtonClicked = onCloseButtonClicked;
            return this;
        }

        public final Builder onWebSdkClose(Function0<Unit> onWebSdkClose) {
            Intrinsics.checkNotNullParameter(onWebSdkClose, "onWebSdkClose");
            this.onWebSdkClose = onWebSdkClose;
            return this;
        }

        public final Builder onWebViewError(Function0<Unit> onWebViewError) {
            Intrinsics.checkNotNullParameter(onWebViewError, "onWebViewError");
            this.onWebViewError = onWebViewError;
            return this;
        }

        public final Builder onWebSdkUpdateTitle(Function1<? super String, Unit> onWebSdkUpdateTitle) {
            Intrinsics.checkNotNullParameter(onWebSdkUpdateTitle, "onWebSdkUpdateTitle");
            this.onWebSdkUpdateTitle = onWebSdkUpdateTitle;
            return this;
        }

        public final Builder onUrlUpdated(Function1<? super String, Unit> onUrlUpdated) {
            Intrinsics.checkNotNullParameter(onUrlUpdated, "onUrlUpdated");
            this.onUrlUpdated = onUrlUpdated;
            return this;
        }

        public final Builder onPageLoadingComplete(Function0<Unit> onPageLoadingComplete) {
            Intrinsics.checkNotNullParameter(onPageLoadingComplete, "onPageLoadingComplete");
            this.onPageLoadingComplete = onPageLoadingComplete;
            return this;
        }

        public final Builder onBackButtonClicked(Function0<Unit> onBackButtonClicked) {
            Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
            this.onBackButtonClicked = onBackButtonClicked;
            return this;
        }

        public final Builder state(Function1<? super ConversationExtensionState, ConversationExtensionState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ConversationExtensionRendering build() {
            return new ConversationExtensionRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
