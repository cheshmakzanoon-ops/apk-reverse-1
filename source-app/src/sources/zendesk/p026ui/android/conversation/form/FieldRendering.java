package zendesk.p026ui.android.conversation.form;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0003\u0010\u0011\u0012B\u001f\b\u0004\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00028\u0000\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0016\u0010\u0005\u001a\u00028\u0000X\u0096\u0004¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f\u0082\u0001\u0003\u0013\u0014\u0015¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering;", "T", "", "state", "Lzendesk/ui/android/conversation/form/FieldState;", "normalizedState", "inputType", "", "(Lzendesk/ui/android/conversation/form/FieldState;Ljava/lang/Object;I)V", "getInputType", "()I", "getNormalizedState", "()Ljava/lang/Object;", "Ljava/lang/Object;", "getState", "()Lzendesk/ui/android/conversation/form/FieldState;", "Email", "Select", "Text", "Lzendesk/ui/android/conversation/form/FieldRendering$Email;", "Lzendesk/ui/android/conversation/form/FieldRendering$Select;", "Lzendesk/ui/android/conversation/form/FieldRendering$Text;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class FieldRendering<T> {
    public static final int $stable = 0;
    private final int inputType;
    private final T normalizedState;
    private final FieldState state;

    public FieldRendering(FieldState fieldState, Object obj, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(fieldState, obj, i);
    }

    private FieldRendering(FieldState fieldState, T t, int i) {
        this.state = fieldState;
        this.normalizedState = t;
        this.inputType = i;
    }

    public FieldState getState() {
        return this.state;
    }

    public T getNormalizedState() {
        return this.normalizedState;
    }

    public int getInputType() {
        return this.inputType;
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0016\n\u0002\u0010\u0000\n\u0002\b\u0004\b\u0087\b\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u0001(Bq\b\u0000\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006\u0012\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e¢\u0006\u0002\u0010\u000fJ\t\u0010\u0019\u001a\u00020\u0004HÆ\u0003J\u0015\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0003J\u001a\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b\u001cJ\u001a\u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006HÀ\u0003¢\u0006\u0002\b\u001eJ\u001a\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b J\t\u0010!\u001a\u00020\u000eHÆ\u0003J{\u0010\"\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u00062\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u00062\u0014\b\u0002\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u00062\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u00062\b\b\u0002\u0010\r\u001a\u00020\u000eHÆ\u0001J\u0013\u0010#\u001a\u00020\f2\b\u0010$\u001a\u0004\u0018\u00010%HÖ\u0003J\t\u0010&\u001a\u00020\u000eHÖ\u0001J\t\u0010'\u001a\u00020\tHÖ\u0001R\u0014\u0010\r\u001a\u00020\u000eX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R \u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R \u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0013R \u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0013R\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018¨\u0006)"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Text;", "T", "Lzendesk/ui/android/conversation/form/FieldRendering;", "state", "Lzendesk/ui/android/conversation/form/FieldState$Text;", "onStateChanged", "Lkotlin/Function1;", "", "onTextChanged", "", "normalize", "onFieldFocusChanged", "", "inputType", "", "(Lzendesk/ui/android/conversation/form/FieldState$Text;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;I)V", "getInputType", "()I", "getNormalize$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "getOnFieldFocusChanged$zendesk_ui_ui_android", "getOnStateChanged", "getOnTextChanged$zendesk_ui_ui_android", "getState", "()Lzendesk/ui/android/conversation/form/FieldState$Text;", "component1", "component2", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "copy", "equals", "other", "", "hashCode", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Text<T> extends FieldRendering<T> {
        public static final int $stable = 0;
        private final int inputType;
        private final Function1<FieldState.Text, T> normalize;
        private final Function1<Boolean, Unit> onFieldFocusChanged;
        private final Function1<FieldState.Text, Unit> onStateChanged;
        private final Function1<String, Unit> onTextChanged;
        private final FieldState.Text state;

        public static Text copy$default(Text text, FieldState.Text text2, Function1 function1, Function1 function2, Function1 function3, Function1 function4, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                text2 = text.state;
            }
            if ((i2 & 2) != 0) {
                function1 = text.onStateChanged;
            }
            Function1 function5 = function1;
            if ((i2 & 4) != 0) {
                function2 = text.onTextChanged;
            }
            Function1 function6 = function2;
            if ((i2 & 8) != 0) {
                function3 = text.normalize;
            }
            Function1 function7 = function3;
            if ((i2 & 16) != 0) {
                function4 = text.onFieldFocusChanged;
            }
            Function1 function8 = function4;
            if ((i2 & 32) != 0) {
                i = text.inputType;
            }
            return text.copy(text2, function5, function6, function7, function8, i);
        }

        public final FieldState.Text getState() {
            return this.state;
        }

        public final Function1<FieldState.Text, Unit> component2() {
            return this.onStateChanged;
        }

        public final Function1<String, Unit> component3$zendesk_ui_ui_android() {
            return this.onTextChanged;
        }

        public final Function1<FieldState.Text, T> component4$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> component5$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        public final int getInputType() {
            return this.inputType;
        }

        public final Text<T> copy(FieldState.Text state, Function1<? super FieldState.Text, Unit> onStateChanged, Function1<? super String, Unit> onTextChanged, Function1<? super FieldState.Text, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, int inputType) {
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onTextChanged, "onTextChanged");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            return new Text<>(state, onStateChanged, onTextChanged, normalize, onFieldFocusChanged, inputType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.state, text.state) && Intrinsics.areEqual(this.onStateChanged, text.onStateChanged) && Intrinsics.areEqual(this.onTextChanged, text.onTextChanged) && Intrinsics.areEqual(this.normalize, text.normalize) && Intrinsics.areEqual(this.onFieldFocusChanged, text.onFieldFocusChanged) && this.inputType == text.inputType;
        }

        public int hashCode() {
            return (((((((((this.state.hashCode() * 31) + this.onStateChanged.hashCode()) * 31) + this.onTextChanged.hashCode()) * 31) + this.normalize.hashCode()) * 31) + this.onFieldFocusChanged.hashCode()) * 31) + this.inputType;
        }

        public String toString() {
            return "Text(state=" + this.state + ", onStateChanged=" + this.onStateChanged + ", onTextChanged=" + this.onTextChanged + ", normalize=" + this.normalize + ", onFieldFocusChanged=" + this.onFieldFocusChanged + ", inputType=" + this.inputType + ')';
        }

        public Text(FieldState.Text text, Function1 function1, Function1 function2, Function1 function3, Function1 function4, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this((i2 & 1) != 0 ? new FieldState.Text(null, 0, 0, null, null, 0, 0, 0, 0, 511, null) : text, (i2 & 2) != 0 ? new Function1<FieldState.Text, Unit>() {
                public final void invoke2(FieldState.Text it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(FieldState.Text text2) {
                    invoke2(text2);
                    return Unit.INSTANCE;
                }
            } : function1, (i2 & 4) != 0 ? new Function1<String, Unit>() {
                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }
            } : function2, function3, (i2 & 16) != 0 ? new Function1<Boolean, Unit>() {
                public final void invoke(boolean z) {
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }
            } : function4, (i2 & 32) != 0 ? 8192 : i);
        }

        @Override
        public FieldState.Text getState() {
            return this.state;
        }

        public final Function1<FieldState.Text, Unit> getOnStateChanged() {
            return this.onStateChanged;
        }

        public final Function1<String, Unit> getOnTextChanged$zendesk_ui_ui_android() {
            return this.onTextChanged;
        }

        public final Function1<FieldState.Text, T> getNormalize$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> getOnFieldFocusChanged$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        @Override
        public int getInputType() {
            return this.inputType;
        }

        public Text(FieldState.Text state, Function1<? super FieldState.Text, Unit> onStateChanged, Function1<? super String, Unit> onTextChanged, Function1<? super FieldState.Text, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, int i) {
            super(state, normalize.invoke(state), i, null);
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onTextChanged, "onTextChanged");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            this.state = state;
            this.onStateChanged = onStateChanged;
            this.onTextChanged = onTextChanged;
            this.normalize = normalize;
            this.onFieldFocusChanged = onFieldFocusChanged;
            this.inputType = i;
        }

        @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0007\u0018\u0000*\u0004\b\u0002\u0010\u00012\u00020\u0002B\u0019\u0012\u0012\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00028\u00020\u0004¢\u0006\u0002\u0010\u0006J\f\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00020\bJ\u0014\u0010\n\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ \u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e0\u0004J \u0010\u000f\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u000e0\u0004J \u0010\u0010\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u000e0\u0004J \u0010\u0012\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u0004R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Text$Builder;", "T", "", "normalize", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/form/FieldState$Text;", "(Lkotlin/jvm/functions/Function1;)V", "rendering", "Lzendesk/ui/android/conversation/form/FieldRendering$Text;", "build", "inputType", "", "onFieldFocusChanged", "", "", "onStateChanged", "onTextChanged", "", "state", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder<T> {
            public static final int $stable = 8;
            private Text<T> rendering;

            public Builder(Function1<? super FieldState.Text, ? extends T> normalize) {
                Intrinsics.checkNotNullParameter(normalize, "normalize");
                this.rendering = new Text<>(null, null, null, normalize, null, 0, 55, null);
            }

            public final Builder<T> state(Function1<? super FieldState.Text, FieldState.Text> stateUpdate) {
                Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
                Text<T> text = this.rendering;
                this.rendering = Text.copy$default(text, stateUpdate.invoke(text.getState()), null, null, null, null, 0, 62, null);
                return this;
            }

            public final Builder<T> onStateChanged(Function1<? super FieldState.Text, Unit> onStateChanged) {
                Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
                this.rendering = Text.copy$default(this.rendering, null, onStateChanged, null, null, null, 0, 61, null);
                return this;
            }

            public final Builder<T> onFieldFocusChanged(Function1<? super Boolean, Unit> onFieldFocusChanged) {
                Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
                this.rendering = Text.copy$default(this.rendering, null, null, null, null, onFieldFocusChanged, 0, 47, null);
                return this;
            }

            public final Builder<T> onTextChanged(Function1<? super String, Unit> onTextChanged) {
                Intrinsics.checkNotNullParameter(onTextChanged, "onTextChanged");
                this.rendering = Text.copy$default(this.rendering, null, null, onTextChanged, null, null, 0, 59, null);
                return this;
            }

            public final Builder<T> inputType(int inputType) {
                this.rendering = Text.copy$default(this.rendering, null, null, null, null, null, inputType, 31, null);
                return this;
            }

            public final Text<T> build() {
                return this.rendering;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0016\n\u0002\u0010\u0000\n\u0002\b\u0004\b\u0087\b\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u0001(Bq\b\u0000\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006\u0012\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e¢\u0006\u0002\u0010\u000fJ\t\u0010\u0019\u001a\u00020\u0004HÆ\u0003J\u0015\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0003J\u001a\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b\u001cJ\u001a\u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006HÀ\u0003¢\u0006\u0002\b\u001eJ\u001a\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b J\t\u0010!\u001a\u00020\u000eHÆ\u0003J{\u0010\"\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u00062\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u00062\u0014\b\u0002\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u00062\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u00062\b\b\u0002\u0010\r\u001a\u00020\u000eHÆ\u0001J\u0013\u0010#\u001a\u00020\f2\b\u0010$\u001a\u0004\u0018\u00010%HÖ\u0003J\t\u0010&\u001a\u00020\u000eHÖ\u0001J\t\u0010'\u001a\u00020\tHÖ\u0001R\u0014\u0010\r\u001a\u00020\u000eX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R \u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R \u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R \u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0013R\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0013R\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018¨\u0006)"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Email;", "T", "Lzendesk/ui/android/conversation/form/FieldRendering;", "state", "Lzendesk/ui/android/conversation/form/FieldState$Email;", "onStateChanged", "Lkotlin/Function1;", "", "onEmailChanged", "", "normalize", "onFieldFocusChanged", "", "inputType", "", "(Lzendesk/ui/android/conversation/form/FieldState$Email;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;I)V", "getInputType", "()I", "getNormalize$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "getOnEmailChanged$zendesk_ui_ui_android", "getOnFieldFocusChanged$zendesk_ui_ui_android", "getOnStateChanged", "getState", "()Lzendesk/ui/android/conversation/form/FieldState$Email;", "component1", "component2", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "copy", "equals", "other", "", "hashCode", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Email<T> extends FieldRendering<T> {
        public static final int $stable = 0;
        private final int inputType;
        private final Function1<FieldState.Email, T> normalize;
        private final Function1<String, Unit> onEmailChanged;
        private final Function1<Boolean, Unit> onFieldFocusChanged;
        private final Function1<FieldState.Email, Unit> onStateChanged;
        private final FieldState.Email state;

        public static Email copy$default(Email email, FieldState.Email email2, Function1 function1, Function1 function2, Function1 function3, Function1 function4, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                email2 = email.state;
            }
            if ((i2 & 2) != 0) {
                function1 = email.onStateChanged;
            }
            Function1 function5 = function1;
            if ((i2 & 4) != 0) {
                function2 = email.onEmailChanged;
            }
            Function1 function6 = function2;
            if ((i2 & 8) != 0) {
                function3 = email.normalize;
            }
            Function1 function7 = function3;
            if ((i2 & 16) != 0) {
                function4 = email.onFieldFocusChanged;
            }
            Function1 function8 = function4;
            if ((i2 & 32) != 0) {
                i = email.inputType;
            }
            return email.copy(email2, function5, function6, function7, function8, i);
        }

        public final FieldState.Email getState() {
            return this.state;
        }

        public final Function1<FieldState.Email, Unit> component2() {
            return this.onStateChanged;
        }

        public final Function1<String, Unit> component3$zendesk_ui_ui_android() {
            return this.onEmailChanged;
        }

        public final Function1<FieldState.Email, T> component4$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> component5$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        public final int getInputType() {
            return this.inputType;
        }

        public final Email<T> copy(FieldState.Email state, Function1<? super FieldState.Email, Unit> onStateChanged, Function1<? super String, Unit> onEmailChanged, Function1<? super FieldState.Email, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, int inputType) {
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onEmailChanged, "onEmailChanged");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            return new Email<>(state, onStateChanged, onEmailChanged, normalize, onFieldFocusChanged, inputType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Email)) {
                return false;
            }
            Email email = (Email) other;
            return Intrinsics.areEqual(this.state, email.state) && Intrinsics.areEqual(this.onStateChanged, email.onStateChanged) && Intrinsics.areEqual(this.onEmailChanged, email.onEmailChanged) && Intrinsics.areEqual(this.normalize, email.normalize) && Intrinsics.areEqual(this.onFieldFocusChanged, email.onFieldFocusChanged) && this.inputType == email.inputType;
        }

        public int hashCode() {
            return (((((((((this.state.hashCode() * 31) + this.onStateChanged.hashCode()) * 31) + this.onEmailChanged.hashCode()) * 31) + this.normalize.hashCode()) * 31) + this.onFieldFocusChanged.hashCode()) * 31) + this.inputType;
        }

        public String toString() {
            return "Email(state=" + this.state + ", onStateChanged=" + this.onStateChanged + ", onEmailChanged=" + this.onEmailChanged + ", normalize=" + this.normalize + ", onFieldFocusChanged=" + this.onFieldFocusChanged + ", inputType=" + this.inputType + ')';
        }

        public Email(FieldState.Email email, Function1 function1, Function1 function2, Function1 function3, Function1 function4, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this((i2 & 1) != 0 ? new FieldState.Email(null, null, null, 0, 0, 0, 0, 127, null) : email, (i2 & 2) != 0 ? new Function1<FieldState.Email, Unit>() {
                public final void invoke2(FieldState.Email it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(FieldState.Email email2) {
                    invoke2(email2);
                    return Unit.INSTANCE;
                }
            } : function1, (i2 & 4) != 0 ? new Function1<String, Unit>() {
                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }
            } : function2, function3, (i2 & 16) != 0 ? new Function1<Boolean, Unit>() {
                public final void invoke(boolean z) {
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }
            } : function4, (i2 & 32) != 0 ? 33 : i);
        }

        @Override
        public FieldState.Email getState() {
            return this.state;
        }

        public final Function1<FieldState.Email, Unit> getOnStateChanged() {
            return this.onStateChanged;
        }

        public final Function1<String, Unit> getOnEmailChanged$zendesk_ui_ui_android() {
            return this.onEmailChanged;
        }

        public final Function1<FieldState.Email, T> getNormalize$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> getOnFieldFocusChanged$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        @Override
        public int getInputType() {
            return this.inputType;
        }

        public Email(FieldState.Email state, Function1<? super FieldState.Email, Unit> onStateChanged, Function1<? super String, Unit> onEmailChanged, Function1<? super FieldState.Email, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, int i) {
            super(state, normalize.invoke(state), i, null);
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onEmailChanged, "onEmailChanged");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            this.state = state;
            this.onStateChanged = onStateChanged;
            this.onEmailChanged = onEmailChanged;
            this.normalize = normalize;
            this.onFieldFocusChanged = onFieldFocusChanged;
            this.inputType = i;
        }

        @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0007\u0018\u0000*\u0004\b\u0002\u0010\u00012\u00020\u0002B\u0019\u0012\u0012\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00028\u00020\u0004¢\u0006\u0002\u0010\u0006J\f\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00020\bJ \u0010\n\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\f0\u0004J \u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f0\u0004J \u0010\u000e\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\f0\u0004J \u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u0004R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Email$Builder;", "T", "", "normalize", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/form/FieldState$Email;", "(Lkotlin/jvm/functions/Function1;)V", "rendering", "Lzendesk/ui/android/conversation/form/FieldRendering$Email;", "build", "onFieldFocusChanged", "", "", "onStateChanged", "onTextChanged", "onEmailChanged", "", "state", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder<T> {
            public static final int $stable = 8;
            private Email<T> rendering;

            public Builder(Function1<? super FieldState.Email, ? extends T> normalize) {
                Intrinsics.checkNotNullParameter(normalize, "normalize");
                this.rendering = new Email<>(null, null, null, normalize, null, 0, 55, null);
            }

            public final Builder<T> state(Function1<? super FieldState.Email, FieldState.Email> stateUpdate) {
                Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
                Email<T> email = this.rendering;
                this.rendering = Email.copy$default(email, stateUpdate.invoke(email.getState()), null, null, null, null, 0, 62, null);
                return this;
            }

            public final Builder<T> onStateChanged(Function1<? super FieldState.Email, Unit> onStateChanged) {
                Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
                this.rendering = Email.copy$default(this.rendering, null, onStateChanged, null, null, null, 0, 61, null);
                return this;
            }

            public final Builder<T> onFieldFocusChanged(Function1<? super Boolean, Unit> onFieldFocusChanged) {
                Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
                this.rendering = Email.copy$default(this.rendering, null, null, null, null, onFieldFocusChanged, 0, 47, null);
                return this;
            }

            public final Builder<T> onTextChanged(Function1<? super String, Unit> onEmailChanged) {
                Intrinsics.checkNotNullParameter(onEmailChanged, "onEmailChanged");
                this.rendering = Email.copy$default(this.rendering, null, null, onEmailChanged, null, null, 0, 59, null);
                return this;
            }

            public final Email<T> build() {
                return this.rendering;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u001a\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u00010B\u0087\u0001\b\u0000\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u001a\b\u0002\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006\u0012\u0014\b\u0002\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u000e\b\u0002\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00070\u000f\u0012\b\b\u0002\u0010\u0010\u001a\u00020\u0011¢\u0006\u0002\u0010\u0012J\t\u0010\u001e\u001a\u00020\u0004HÆ\u0003J\u0015\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0003J \u0010 \u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b!J\u001a\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006HÀ\u0003¢\u0006\u0002\b#J\u001a\u0010$\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00070\u0006HÀ\u0003¢\u0006\u0002\b%J\u0014\u0010&\u001a\b\u0012\u0004\u0012\u00020\u00070\u000fHÀ\u0003¢\u0006\u0002\b'J\t\u0010(\u001a\u00020\u0011HÆ\u0003J\u0091\u0001\u0010)\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u00062\u001a\b\u0002\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0004\u0012\u00020\u00070\u00062\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u00062\u0014\b\u0002\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00070\u00062\u000e\b\u0002\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00070\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u0011HÆ\u0001J\u0013\u0010*\u001a\u00020\r2\b\u0010+\u001a\u0004\u0018\u00010,HÖ\u0003J\t\u0010-\u001a\u00020\u0011HÖ\u0001J\t\u0010.\u001a\u00020/HÖ\u0001R\u0014\u0010\u0010\u001a\u00020\u0011X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R \u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00028\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u001a\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00070\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R \u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R&\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0004\u0012\u00020\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0016R\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001d¨\u00061"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Select;", "T", "Lzendesk/ui/android/conversation/form/FieldRendering;", "state", "Lzendesk/ui/android/conversation/form/FieldState$Select;", "onStateChanged", "Lkotlin/Function1;", "", "onSelected", "", "Lzendesk/ui/android/conversation/form/SelectOption;", "normalize", "onFieldFocusChanged", "", "onCheckMarkPressed", "Lkotlin/Function0;", "inputType", "", "(Lzendesk/ui/android/conversation/form/FieldState$Select;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;I)V", "getInputType", "()I", "getNormalize$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "getOnCheckMarkPressed$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "getOnFieldFocusChanged$zendesk_ui_ui_android", "getOnSelected$zendesk_ui_ui_android", "getOnStateChanged", "getState", "()Lzendesk/ui/android/conversation/form/FieldState$Select;", "component1", "component2", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "copy", "equals", "other", "", "hashCode", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Select<T> extends FieldRendering<T> {
        public static final int $stable = 8;
        private final int inputType;
        private final Function1<FieldState.Select, T> normalize;
        private final Function0<Unit> onCheckMarkPressed;
        private final Function1<Boolean, Unit> onFieldFocusChanged;
        private final Function1<List<SelectOption>, Unit> onSelected;
        private final Function1<FieldState.Select, Unit> onStateChanged;
        private final FieldState.Select state;

        public static Select copy$default(Select select, FieldState.Select select2, Function1 function1, Function1 function2, Function1 function3, Function1 function4, Function0 function0, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                select2 = select.state;
            }
            if ((i2 & 2) != 0) {
                function1 = select.onStateChanged;
            }
            Function1 function5 = function1;
            if ((i2 & 4) != 0) {
                function2 = select.onSelected;
            }
            Function1 function6 = function2;
            if ((i2 & 8) != 0) {
                function3 = select.normalize;
            }
            Function1 function7 = function3;
            if ((i2 & 16) != 0) {
                function4 = select.onFieldFocusChanged;
            }
            Function1 function8 = function4;
            if ((i2 & 32) != 0) {
                function0 = select.onCheckMarkPressed;
            }
            Function0 function9 = function0;
            if ((i2 & 64) != 0) {
                i = select.inputType;
            }
            return select.copy(select2, function5, function6, function7, function8, function9, i);
        }

        public final FieldState.Select getState() {
            return this.state;
        }

        public final Function1<FieldState.Select, Unit> component2() {
            return this.onStateChanged;
        }

        public final Function1<List<SelectOption>, Unit> component3$zendesk_ui_ui_android() {
            return this.onSelected;
        }

        public final Function1<FieldState.Select, T> component4$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> component5$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        public final Function0<Unit> component6$zendesk_ui_ui_android() {
            return this.onCheckMarkPressed;
        }

        public final int getInputType() {
            return this.inputType;
        }

        public final Select<T> copy(FieldState.Select state, Function1<? super FieldState.Select, Unit> onStateChanged, Function1<? super List<SelectOption>, Unit> onSelected, Function1<? super FieldState.Select, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, Function0<Unit> onCheckMarkPressed, int inputType) {
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onSelected, "onSelected");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            Intrinsics.checkNotNullParameter(onCheckMarkPressed, "onCheckMarkPressed");
            return new Select<>(state, onStateChanged, onSelected, normalize, onFieldFocusChanged, onCheckMarkPressed, inputType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Select)) {
                return false;
            }
            Select select = (Select) other;
            return Intrinsics.areEqual(this.state, select.state) && Intrinsics.areEqual(this.onStateChanged, select.onStateChanged) && Intrinsics.areEqual(this.onSelected, select.onSelected) && Intrinsics.areEqual(this.normalize, select.normalize) && Intrinsics.areEqual(this.onFieldFocusChanged, select.onFieldFocusChanged) && Intrinsics.areEqual(this.onCheckMarkPressed, select.onCheckMarkPressed) && this.inputType == select.inputType;
        }

        public int hashCode() {
            return (((((((((((this.state.hashCode() * 31) + this.onStateChanged.hashCode()) * 31) + this.onSelected.hashCode()) * 31) + this.normalize.hashCode()) * 31) + this.onFieldFocusChanged.hashCode()) * 31) + this.onCheckMarkPressed.hashCode()) * 31) + this.inputType;
        }

        public String toString() {
            return "Select(state=" + this.state + ", onStateChanged=" + this.onStateChanged + ", onSelected=" + this.onSelected + ", normalize=" + this.normalize + ", onFieldFocusChanged=" + this.onFieldFocusChanged + ", onCheckMarkPressed=" + this.onCheckMarkPressed + ", inputType=" + this.inputType + ')';
        }

        public Select(FieldState.Select select, Function1 function1, Function1 function2, Function1 function3, Function1 function4, Function0 function0, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this((i2 & 1) != 0 ? new FieldState.Select(null, null, null, null, 0, 0, 0, 0, 255, null) : select, (i2 & 2) != 0 ? new Function1<FieldState.Select, Unit>() {
                public final void invoke2(FieldState.Select it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(FieldState.Select select2) {
                    invoke2(select2);
                    return Unit.INSTANCE;
                }
            } : function1, (i2 & 4) != 0 ? new Function1<List<? extends SelectOption>, Unit>() {
                public final void invoke2(List<SelectOption> it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(List<? extends SelectOption> list) {
                    invoke2((List<SelectOption>) list);
                    return Unit.INSTANCE;
                }
            } : function2, function3, (i2 & 16) != 0 ? new Function1<Boolean, Unit>() {
                public final void invoke(boolean z) {
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }
            } : function4, (i2 & 32) != 0 ? new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            } : function0, (i2 & 64) != 0 ? 176 : i);
        }

        @Override
        public FieldState.Select getState() {
            return this.state;
        }

        public final Function1<FieldState.Select, Unit> getOnStateChanged() {
            return this.onStateChanged;
        }

        public final Function1<List<SelectOption>, Unit> getOnSelected$zendesk_ui_ui_android() {
            return this.onSelected;
        }

        public final Function1<FieldState.Select, T> getNormalize$zendesk_ui_ui_android() {
            return this.normalize;
        }

        public final Function1<Boolean, Unit> getOnFieldFocusChanged$zendesk_ui_ui_android() {
            return this.onFieldFocusChanged;
        }

        public final Function0<Unit> getOnCheckMarkPressed$zendesk_ui_ui_android() {
            return this.onCheckMarkPressed;
        }

        @Override
        public int getInputType() {
            return this.inputType;
        }

        public Select(FieldState.Select state, Function1<? super FieldState.Select, Unit> onStateChanged, Function1<? super List<SelectOption>, Unit> onSelected, Function1<? super FieldState.Select, ? extends T> normalize, Function1<? super Boolean, Unit> onFieldFocusChanged, Function0<Unit> onCheckMarkPressed, int i) {
            super(state, normalize.invoke(state), i, null);
            Intrinsics.checkNotNullParameter(state, "state");
            Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
            Intrinsics.checkNotNullParameter(onSelected, "onSelected");
            Intrinsics.checkNotNullParameter(normalize, "normalize");
            Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
            Intrinsics.checkNotNullParameter(onCheckMarkPressed, "onCheckMarkPressed");
            this.state = state;
            this.onStateChanged = onStateChanged;
            this.onSelected = onSelected;
            this.normalize = normalize;
            this.onFieldFocusChanged = onFieldFocusChanged;
            this.onCheckMarkPressed = onCheckMarkPressed;
            this.inputType = i;
        }

        @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u0000*\u0004\b\u0002\u0010\u00012\u00020\u0002B\u0019\u0012\u0012\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00028\u00020\u0004¢\u0006\u0002\u0010\u0006J\f\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00020\bJ \u0010\n\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\f0\u0004J&\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0018\u0010\r\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\u000e\u0012\u0004\u0012\u00020\f0\u0004J \u0010\u0010\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f0\u0004J \u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00020\u00002\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u0004R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldRendering$Select$Builder;", "T", "", "normalize", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/form/FieldState$Select;", "(Lkotlin/jvm/functions/Function1;)V", "rendering", "Lzendesk/ui/android/conversation/form/FieldRendering$Select;", "build", "onFieldFocusChanged", "", "", "onSelected", "", "Lzendesk/ui/android/conversation/form/SelectOption;", "onStateChanged", "state", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder<T> {
            public static final int $stable = 8;
            private Select<T> rendering;

            public Builder(Function1<? super FieldState.Select, ? extends T> normalize) {
                Intrinsics.checkNotNullParameter(normalize, "normalize");
                this.rendering = new Select<>(null, null, null, normalize, null, null, 0, 119, null);
            }

            public final Builder<T> state(Function1<? super FieldState.Select, FieldState.Select> stateUpdate) {
                Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
                Select<T> select = this.rendering;
                this.rendering = Select.copy$default(select, stateUpdate.invoke(select.getState()), null, null, null, null, null, 0, WebSocketProtocol.PAYLOAD_SHORT, null);
                return this;
            }

            public final Builder<T> onStateChanged(Function1<? super FieldState.Select, Unit> onStateChanged) {
                Intrinsics.checkNotNullParameter(onStateChanged, "onStateChanged");
                this.rendering = Select.copy$default(this.rendering, null, onStateChanged, null, null, null, null, 0, 125, null);
                return this;
            }

            public final Builder<T> onSelected(Function1<? super List<SelectOption>, Unit> onSelected) {
                Intrinsics.checkNotNullParameter(onSelected, "onSelected");
                this.rendering = Select.copy$default(this.rendering, null, null, onSelected, null, null, null, 0, 123, null);
                return this;
            }

            public final Builder<T> onFieldFocusChanged(Function1<? super Boolean, Unit> onFieldFocusChanged) {
                Intrinsics.checkNotNullParameter(onFieldFocusChanged, "onFieldFocusChanged");
                this.rendering = Select.copy$default(this.rendering, null, null, null, null, onFieldFocusChanged, null, 0, ConversationMsg.TYPE_ADMIN_TYPING, null);
                return this;
            }

            public final Select<T> build() {
                return this.rendering;
            }
        }
    }
}
