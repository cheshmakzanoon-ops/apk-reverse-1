package zendesk.p026ui.android.conversation.quickreply;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.util.StateSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.core.content.ContextCompat;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001\u001fB/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0016\u0010\u0010\u001a\u00020\u00112\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00140\u0013H\u0014J\u0016\u0010\u0015\u001a\u00020\u00112\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00140\u0013H\u0014J\u0010\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0014H\u0014J\b\u0010\u0018\u001a\u00020\u0014H\u0014J\u001c\u0010\u0019\u001a\u00020\u00112\u0012\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u001bH\u0016J\u0018\u0010\u001c\u001a\u00020\u00112\u0006\u0010\u001d\u001a\u00020\t2\u0006\u0010\u001e\u001a\u00020\tH\u0002R\u000e\u0010\f\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006 "}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "quickReplyOptionContainer", "quickReplyOptionTextView", "Landroid/widget/TextView;", "rendering", "dispatchRestoreInstanceState", "", "container", "Landroid/util/SparseArray;", "Landroid/os/Parcelable;", "dispatchSaveInstanceState", "onRestoreInstanceState", "state", "onSaveInstanceState", "render", "renderingUpdate", "Lkotlin/Function1;", "setupQuickReplyStateBackground", "tappedBackgroundColor", "untappedBackgroundColor", "SavedState", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class QuickReplyOptionView extends FrameLayout implements Renderer<QuickReplyOptionRendering> {
    public static final int $stable = 8;
    private final FrameLayout quickReplyOptionContainer;
    private final TextView quickReplyOptionTextView;
    private QuickReplyOptionRendering rendering;

    public QuickReplyOptionView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyOptionView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyOptionView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyOptionView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public QuickReplyOptionView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new QuickReplyOptionRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_QuickReplyOption, false);
        FrameLayout.inflate(context, R.layout.zuia_view_quick_reply_option, this);
        View viewFindViewById = findViewById(R.id.zuia_quick_reply_options_view_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.quickReplyOptionContainer = (FrameLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_quick_reply_options_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.quickReplyOptionTextView = (TextView) viewFindViewById2;
        render(new Function1<QuickReplyOptionRendering, QuickReplyOptionRendering>() {
            @Override
            public final QuickReplyOptionRendering invoke(QuickReplyOptionRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super QuickReplyOptionRendering, QuickReplyOptionRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        QuickReplyOptionState state = this.rendering.getState();
        QuickReplyOptionRendering quickReplyOptionRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = quickReplyOptionRenderingInvoke;
        if (Intrinsics.areEqual(state, quickReplyOptionRenderingInvoke.getState())) {
            return;
        }
        final int color$zendesk_ui_ui_android = this.rendering.getState().getColor$zendesk_ui_ui_android();
        final int backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
        setupQuickReplyStateBackground(color$zendesk_ui_ui_android, backgroundColor$zendesk_ui_ui_android);
        this.quickReplyOptionTextView.setText(this.rendering.getState().getText$zendesk_ui_ui_android());
        this.quickReplyOptionTextView.setTextColor(color$zendesk_ui_ui_android);
        this.quickReplyOptionContainer.setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                Function2<String, String, Unit> onOptionClicked$zendesk_ui_ui_android = QuickReplyOptionView.this.rendering.getOnOptionClicked$zendesk_ui_ui_android();
                if (onOptionClicked$zendesk_ui_ui_android != null) {
                    QuickReplyOptionView quickReplyOptionView = QuickReplyOptionView.this;
                    onOptionClicked$zendesk_ui_ui_android.invoke(quickReplyOptionView.rendering.getState().getId$zendesk_ui_ui_android(), quickReplyOptionView.rendering.getState().getText$zendesk_ui_ui_android());
                    quickReplyOptionView.setSelected(true);
                    quickReplyOptionView.render(new Function1<QuickReplyOptionRendering, QuickReplyOptionRendering>() {
                        @Override
                        public final QuickReplyOptionRendering invoke(QuickReplyOptionRendering it) {
                            Intrinsics.checkNotNullParameter(it, "it");
                            return it;
                        }
                    });
                }
            }
        }, 1, null));
        this.quickReplyOptionContainer.setContentDescription(((Object) this.quickReplyOptionTextView.getText()) + ". " + getResources().getString(R.string.zuia_quick_reply_button_accessibility_label));
        this.quickReplyOptionContainer.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                QuickReplyOptionView.render$lambda$0(this.f$0, color$zendesk_ui_ui_android, backgroundColor$zendesk_ui_ui_android, view, z);
            }
        });
    }

    public static final void render$lambda$0(QuickReplyOptionView this$0, int i, int i2, View view, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (z) {
            Drawable drawable = ContextCompat.getDrawable(this$0.getContext(), R.drawable.zuia_quick_reply_option_background);
            Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
            GradientDrawable gradientDrawable = (GradientDrawable) drawable;
            gradientDrawable.mutate();
            gradientDrawable.setStroke(this$0.getResources().getDimensionPixelSize(R.dimen.zuia_message_composer_stroke_width), i);
            this$0.quickReplyOptionTextView.setBackground(gradientDrawable);
            return;
        }
        this$0.setupQuickReplyStateBackground(i, i2);
    }

    private final void setupQuickReplyStateBackground(int tappedBackgroundColor, int untappedBackgroundColor) {
        StateListDrawable stateListDrawable = new StateListDrawable();
        Drawable drawable = ContextCompat.getDrawable(getContext(), R.drawable.zuia_quick_reply_option_background);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        GradientDrawable gradientDrawable = (GradientDrawable) drawable;
        gradientDrawable.setColor(ColorExtKt.adjustAlpha(tappedBackgroundColor, 0.3f));
        gradientDrawable.setStroke(getResources().getDimensionPixelSize(R.dimen.zuia_quick_reply_options_width), tappedBackgroundColor);
        StateListDrawable stateListDrawable2 = gradientDrawable;
        stateListDrawable.addState(new int[]{android.R.attr.state_checked}, stateListDrawable2);
        stateListDrawable.addState(new int[]{android.R.attr.state_pressed}, stateListDrawable2);
        Drawable drawable2 = ContextCompat.getDrawable(getContext(), R.drawable.zuia_quick_reply_option_background);
        Intrinsics.checkNotNull(drawable2, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        GradientDrawable gradientDrawable2 = (GradientDrawable) drawable2;
        gradientDrawable2.setColor(untappedBackgroundColor);
        gradientDrawable2.setStroke(getResources().getDimensionPixelSize(R.dimen.zuia_quick_reply_options_width), tappedBackgroundColor);
        stateListDrawable.addState(StateSet.WILD_CARD, gradientDrawable2);
        TextView textView = this.quickReplyOptionTextView;
        if (isSelected()) {
            this.quickReplyOptionContainer.setEnabled(false);
        } else {
            this.quickReplyOptionContainer.setEnabled(true);
            stateListDrawable2 = stateListDrawable;
        }
        textView.setBackground(stateListDrawable2);
    }

    @Override
    protected Parcelable onSaveInstanceState() {
        SavedState savedState = new SavedState(super.onSaveInstanceState());
        savedState.setSelected$zendesk_ui_ui_android(String.valueOf(isSelected()));
        return savedState;
    }

    @Override
    protected void onRestoreInstanceState(Parcelable state) {
        Intrinsics.checkNotNullParameter(state, "state");
        if (state instanceof SavedState) {
            SavedState savedState = (SavedState) state;
            super.onRestoreInstanceState(savedState.getSuperState());
            setSelected(Boolean.parseBoolean(savedState.getIsSelected()));
            render(new Function1<QuickReplyOptionRendering, QuickReplyOptionRendering>() {
                @Override
                public final QuickReplyOptionRendering invoke(QuickReplyOptionRendering it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    return it;
                }
            });
            return;
        }
        super.onRestoreInstanceState(state);
    }

    @Override
    protected void dispatchSaveInstanceState(SparseArray<Parcelable> container) {
        Intrinsics.checkNotNullParameter(container, "container");
        dispatchFreezeSelfOnly(container);
    }

    @Override
    protected void dispatchRestoreInstanceState(SparseArray<Parcelable> container) {
        Intrinsics.checkNotNullParameter(container, "container");
        dispatchThawSelfOnly(container);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0000\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0011\b\u0016\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0016\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u0018\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00062\u0006\u0010\u0011\u001a\u00020\u0012H\u0016R\u001c\u0010\b\u001a\u0004\u0018\u00010\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\r¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionView$SavedState;", "Landroid/view/View$BaseSavedState;", "superState", "Landroid/os/Parcelable;", "(Landroid/os/Parcelable;)V", "source", "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "isSelected", "", "isSelected$zendesk_ui_ui_android", "()Ljava/lang/String;", "setSelected$zendesk_ui_ui_android", "(Ljava/lang/String;)V", "writeToParcel", "", "out", "flags", "", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SavedState extends View.BaseSavedState {
        private String isSelected;

        public static final Companion INSTANCE = new Companion(null);
        public static final int $stable = 8;
        public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.Creator<SavedState>() {
            @Override
            public QuickReplyOptionView.SavedState createFromParcel(Parcel source) {
                Intrinsics.checkNotNullParameter(source, "source");
                return new QuickReplyOptionView.SavedState(source);
            }

            @Override
            public QuickReplyOptionView.SavedState[] newArray(int size) {
                return new QuickReplyOptionView.SavedState[size];
            }
        };

        public final String getIsSelected() {
            return this.isSelected;
        }

        public final void setSelected$zendesk_ui_ui_android(String str) {
            this.isSelected = str;
        }

        public SavedState(Parcelable parcelable) {
            super(parcelable);
            this.isSelected = "false";
        }

        public SavedState(Parcel source) {
            super(source);
            Intrinsics.checkNotNullParameter(source, "source");
            this.isSelected = "false";
            this.isSelected = source.readString();
        }

        @Override
        public void writeToParcel(Parcel out, int flags) {
            Intrinsics.checkNotNullParameter(out, "out");
            super.writeToParcel(out, flags);
            out.writeString(this.isSelected);
        }

        @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001c\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048\u0006X\u0087\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0006\u0010\u0002¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionView$SavedState$Companion;", "", "()V", "CREATOR", "Landroid/os/Parcelable$Creator;", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionView$SavedState;", "getCREATOR$annotations", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            public static void getCREATOR$annotations() {
            }

            private Companion() {
            }
        }
    }
}
