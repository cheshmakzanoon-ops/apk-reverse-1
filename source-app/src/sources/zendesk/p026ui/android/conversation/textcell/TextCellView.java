package zendesk.p026ui.android.conversation.textcell;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.text.SpannableString;
import android.text.style.URLSpan;
import android.util.AttributeSet;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.PopupMenu;
import android.widget.TextView;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.ColorKt;
import androidx.compose.ui.platform.ComposeView;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;
import zendesk.p026ui.android.conversation.actionbutton.ActionButtonRendering;
import zendesk.p026ui.android.conversation.actionbutton.ActionButtonState;
import zendesk.p026ui.android.conversation.actionbutton.ActionButtonView;
import zendesk.p026ui.android.conversation.aidisclaimer.AiDisclaimerKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000r\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"H\u0002J\u0010\u0010#\u001a\u00020\u00112\u0006\u0010\u0004\u001a\u00020\u0005H\u0002J\b\u0010$\u001a\u00020%H\u0002J\u001c\u0010&\u001a\u00020%2\u0012\u0010'\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030(H\u0016J\b\u0010)\u001a\u00020%H\u0002J\b\u0010*\u001a\u00020%H\u0002J\u0015\u0010+\u001a\u00020%2\u0006\u0010,\u001a\u00020\tH\u0000¢\u0006\u0002\b-J\b\u0010.\u001a\u00020%H\u0002J\u0010\u0010/\u001a\u00020%2\u0006\u00100\u001a\u00020\tH\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00180\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00180\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001e\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000¨\u00061"}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/textcell/TextCellRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "actionButtonsContainer", "Landroid/widget/LinearLayout;", "aiBorderView", "Landroid/view/View;", "aiDisclaimerComposeView", "Landroidx/compose/ui/platform/ComposeView;", "aiDisclaimerDefaultImageColor", "aiDisclaimerDefaultTextColor", "aiDisclaimerIconAlpha", "", "aiDisclaimerImageColorState", "Landroidx/compose/runtime/MutableState;", "Landroidx/compose/ui/graphics/Color;", "aiDisclaimerTextAlpha", "aiDisclaimerTextColorState", "messageTextView", "Landroid/widget/TextView;", "rendering", "textCellViewContainer", "buildActionButtonView", "Lzendesk/ui/android/conversation/actionbutton/ActionButtonView;", "actionButton", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "createAiDisclaimerComposeView", "prepareClickableElements", "", "render", "renderingUpdate", "Lkotlin/Function1;", "renderActionButtons", "renderAiDisclaimer", "setMessageTextGravity", "gravity", "setMessageTextGravity$zendesk_ui_ui_android", "setupMessageBackground", "updateFocusedBackgroundState", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TextCellView extends FrameLayout implements Renderer<TextCellRendering> {
    public static final int $stable = 8;
    private final LinearLayout actionButtonsContainer;
    private final View aiBorderView;
    private final ComposeView aiDisclaimerComposeView;
    private final int aiDisclaimerDefaultImageColor;
    private final int aiDisclaimerDefaultTextColor;
    private final float aiDisclaimerIconAlpha;
    private final MutableState<Color> aiDisclaimerImageColorState;
    private final float aiDisclaimerTextAlpha;
    private final MutableState<Color> aiDisclaimerTextColorState;
    private final TextView messageTextView;
    private TextCellRendering rendering;
    private final LinearLayout textCellViewContainer;

    public TextCellView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TextCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TextCellView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public TextCellView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public TextCellView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new TextCellRendering();
        int iResolveColorAttr = ColorExtKt.resolveColorAttr(context, R.attr.aiDisclaimerTextColor);
        this.aiDisclaimerDefaultTextColor = iResolveColorAttr;
        int iResolveColorAttr2 = ColorExtKt.resolveColorAttr(context, R.attr.aiDisclaimerTextColor);
        this.aiDisclaimerDefaultImageColor = iResolveColorAttr2;
        this.aiDisclaimerTextAlpha = ResourcesCompat.getFloat(context.getResources(), R.dimen.zuia_ai_disclaimer_text_alpha);
        this.aiDisclaimerIconAlpha = ResourcesCompat.getFloat(context.getResources(), R.dimen.zuia_ai_disclaimer_icon_alpha);
        this.aiDisclaimerTextColorState = SnapshotStateKt.mutableStateOf$default(Color.box-impl(ColorKt.Color(iResolveColorAttr)), (SnapshotMutationPolicy) null, 2, (Object) null);
        this.aiDisclaimerImageColorState = SnapshotStateKt.mutableStateOf$default(Color.box-impl(ColorKt.Color(iResolveColorAttr2)), (SnapshotMutationPolicy) null, 2, (Object) null);
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_TextCellStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_text_cell, this);
        View viewFindViewById = findViewById(R.id.zuia_message_text);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.messageTextView = (TextView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_action_buttons_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.actionButtonsContainer = (LinearLayout) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_ai_border_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.aiBorderView = viewFindViewById3;
        View viewCreateAiDisclaimerComposeView = createAiDisclaimerComposeView(context);
        this.aiDisclaimerComposeView = viewCreateAiDisclaimerComposeView;
        View viewFindViewById4 = findViewById(R.id.zuia_text_cell_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        LinearLayout linearLayout = (LinearLayout) viewFindViewById4;
        this.textCellViewContainer = linearLayout;
        linearLayout.addView(viewCreateAiDisclaimerComposeView);
        render(new Function1<TextCellRendering, TextCellRendering>() {
            @Override
            public final TextCellRendering invoke(TextCellRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    private final ComposeView createAiDisclaimerComposeView(Context context) {
        View composeView = new ComposeView(context, (AttributeSet) null, 0, 6, (DefaultConstructorMarker) null);
        composeView.setId(FrameLayout.generateViewId());
        composeView.setVisibility(this.rendering.getState().getAiGenerated$zendesk_ui_ui_android() ? 0 : 8);
        composeView.setLayoutParams(new LinearLayout.LayoutParams(-2, -2));
        composeView.setContent(ComposableLambdaKt.composableLambdaInstance(380514657, true, new Function2<Composer, Integer, Unit>() {
            {
                super(2);
            }

            @Override
            public Unit invoke(Composer composer, Integer num) {
                invoke(composer, num.intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(Composer composer, int i) {
                if ((i & 11) != 2 || !composer.getSkipping()) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(380514657, i, -1, "zendesk.ui.android.conversation.textcell.TextCellView.createAiDisclaimerComposeView.<anonymous>.<anonymous> (TextCellView.kt:97)");
                    }
                    AiDisclaimerKt.m2129AiDisclaimervc5YOHI(Color.copy-wmQWz5c$default(((Color) this.this$0.aiDisclaimerTextColorState.getValue()).unbox-impl(), this.this$0.aiDisclaimerTextAlpha, 0.0f, 0.0f, 0.0f, 14, (Object) null), Color.copy-wmQWz5c$default(((Color) this.this$0.aiDisclaimerTextColorState.getValue()).unbox-impl(), this.this$0.aiDisclaimerTextAlpha, 0.0f, 0.0f, 0.0f, 14, (Object) null), null, null, null, composer, 0, 28);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                        return;
                    }
                    return;
                }
                composer.skipToGroupEnd();
            }
        }));
        return composeView;
    }

    public void render(Function1<? super TextCellRendering, TextCellRendering> renderingUpdate) {
        int iResolveColorAttr;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        TextCellState state = this.rendering.getState();
        TextCellRendering textCellRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = textCellRenderingInvoke;
        if (Intrinsics.areEqual(state, textCellRenderingInvoke.getState())) {
            return;
        }
        this.messageTextView.setVisibility(this.rendering.getState().getMessageText$zendesk_ui_ui_android().length() > 0 ? 0 : 8);
        if (this.messageTextView.getVisibility() == 0) {
            this.messageTextView.setText(this.rendering.getState().getMessageText$zendesk_ui_ui_android());
        }
        Integer textColor$zendesk_ui_ui_android = this.rendering.getState().getTextColor$zendesk_ui_ui_android();
        if (textColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr = textColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            iResolveColorAttr = ColorExtKt.resolveColorAttr(context, android.R.attr.textColor);
        }
        setupMessageBackground();
        this.messageTextView.setTextColor(iResolveColorAttr);
        this.messageTextView.setLinkTextColor(iResolveColorAttr);
        updateFocusedBackgroundState(iResolveColorAttr);
        this.messageTextView.setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener(600L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                if (TextCellView.this.messageTextView.getSelectionStart() == -1 && TextCellView.this.messageTextView.getSelectionEnd() == -1) {
                    TextCellView.this.rendering.getOnCellClicked$zendesk_ui_ui_android().invoke(TextCellView.this.messageTextView.getText().toString());
                }
            }
        }));
        this.messageTextView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public final boolean onLongClick(View view) {
                return TextCellView.render$lambda$2(this.f$0, view);
            }
        });
        prepareClickableElements();
        renderActionButtons();
        renderAiDisclaimer();
    }

    public static final boolean render$lambda$2(final TextCellView this$0, View view) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNull(view);
        PopupMenu popupMenuCreateCellContextualMenu = ViewKt.createCellContextualMenu(view, this$0.rendering.getState().getContextualMenuOptions$zendesk_ui_ui_android());
        popupMenuCreateCellContextualMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
            @Override
            public final boolean onMenuItemClick(MenuItem menuItem) {
                return TextCellView.render$lambda$2$lambda$1(this.f$0, menuItem);
            }
        });
        popupMenuCreateCellContextualMenu.show();
        return true;
    }

    public static final boolean render$lambda$2$lambda$1(TextCellView this$0, MenuItem menuItem) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (menuItem.getItemId() != R.id.zuia_cell_menu_copy) {
            return true;
        }
        this$0.rendering.getOnCopyTextMenuItemClicked$zendesk_ui_ui_android().invoke(this$0.messageTextView.getText().toString());
        return true;
    }

    private final void renderAiDisclaimer() {
        TextCellState state = this.rendering.getState();
        this.aiBorderView.setVisibility(state.getAiGenerated$zendesk_ui_ui_android() ? 0 : 8);
        this.aiDisclaimerComposeView.setVisibility(state.getAiGenerated$zendesk_ui_ui_android() ? 0 : 8);
        if (state.getAiGenerated$zendesk_ui_ui_android()) {
            View view = this.aiBorderView;
            Integer aiDisclaimerBorderColor$zendesk_ui_ui_android = state.getAiDisclaimerBorderColor$zendesk_ui_ui_android();
            view.setBackgroundColor(aiDisclaimerBorderColor$zendesk_ui_ui_android != null ? aiDisclaimerBorderColor$zendesk_ui_ui_android.intValue() : this.aiDisclaimerDefaultTextColor);
            MutableState<Color> mutableState = this.aiDisclaimerTextColorState;
            Integer aiDisclaimerTextColor$zendesk_ui_ui_android = state.getAiDisclaimerTextColor$zendesk_ui_ui_android();
            mutableState.setValue(Color.box-impl(Color.copy-wmQWz5c$default(ColorKt.Color(aiDisclaimerTextColor$zendesk_ui_ui_android != null ? aiDisclaimerTextColor$zendesk_ui_ui_android.intValue() : this.aiDisclaimerDefaultTextColor), this.aiDisclaimerTextAlpha, 0.0f, 0.0f, 0.0f, 14, (Object) null)));
            MutableState<Color> mutableState2 = this.aiDisclaimerImageColorState;
            Integer aiDisclaimerImageColor$zendesk_ui_ui_android = state.getAiDisclaimerImageColor$zendesk_ui_ui_android();
            mutableState2.setValue(Color.box-impl(Color.copy-wmQWz5c$default(ColorKt.Color(aiDisclaimerImageColor$zendesk_ui_ui_android != null ? aiDisclaimerImageColor$zendesk_ui_ui_android.intValue() : this.aiDisclaimerDefaultImageColor), this.aiDisclaimerIconAlpha, 0.0f, 0.0f, 0.0f, 14, (Object) null)));
            this.messageTextView.setContentDescription(((Object) this.messageTextView.getText()) + ". " + getResources().getString(R.string.zuia_generated_by_ai));
        }
    }

    private final void renderActionButtons() {
        this.actionButtonsContainer.removeAllViews();
        List<ActionButton> actions$zendesk_ui_ui_android = this.rendering.getState().getActions$zendesk_ui_ui_android();
        if (actions$zendesk_ui_ui_android != null) {
            for (ActionButton actionButton : actions$zendesk_ui_ui_android) {
                LinearLayout linearLayout = this.actionButtonsContainer;
                View view = (View) buildActionButtonView(actionButton);
                LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
                layoutParams.setMargins(getResources().getDimensionPixelSize(R.dimen.zuia_spacing_medium), (this.messageTextView.getVisibility() == 8 && this.actionButtonsContainer.getChildCount() == 0) ? getResources().getDimensionPixelSize(R.dimen.zuia_spacing_small) : 0, getResources().getDimensionPixelSize(R.dimen.zuia_spacing_medium), getResources().getDimensionPixelSize(R.dimen.zuia_spacing_small));
                Unit unit = Unit.INSTANCE;
                linearLayout.addView(view, layoutParams);
            }
        }
    }

    private final ActionButtonView buildActionButtonView(final ActionButton actionButton) {
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ActionButtonView actionButtonView = new ActionButtonView(context, null, 0, 6, null);
        actionButtonView.render(new Function1<ActionButtonRendering, ActionButtonRendering>() {
            {
                super(1);
            }

            @Override
            public final ActionButtonRendering invoke(ActionButtonRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                ActionButtonRendering.Builder builder = it.toBuilder();
                final ActionButton actionButton2 = actionButton;
                final TextCellView textCellView = this.this$0;
                return builder.state(new Function1<ActionButtonState, ActionButtonState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ActionButtonState invoke(ActionButtonState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        String text = actionButton2.getText();
                        Integer actionTextColor$zendesk_ui_ui_android = actionButton2.isSupported() ? textCellView.rendering.getState().getActionTextColor$zendesk_ui_ui_android() : textCellView.rendering.getState().getDisabledTextColor$zendesk_ui_ui_android();
                        return ActionButtonState.copy$default(state, text, actionButton2.getUri(), actionButton2.isSupported(), actionButton2.getUrlSource(), actionButton2.isSupported() ? textCellView.rendering.getState().getActionColor$zendesk_ui_ui_android() : textCellView.rendering.getState().getDisabledColor$zendesk_ui_ui_android(), actionTextColor$zendesk_ui_ui_android, actionButton2.getActionId(), actionButton2.isLoading(), actionButton2.getSize(), null, 512, null);
                    }
                }).onActionButtonClicked(this.this$0.rendering.getOnActionButtonClicked$zendesk_ui_ui_android()).onPostbackButtonClicked(this.this$0.rendering.getOnPostbackButtonClicked$zendesk_ui_ui_android()).onWebViewActionButtonClicked(this.this$0.rendering.getOnWebViewActionButtonClicked$zendesk_ui_ui_android()).build();
            }
        });
        return actionButtonView;
    }

    private final void updateFocusedBackgroundState(final int textColor) {
        this.messageTextView.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                TextCellView.updateFocusedBackgroundState$lambda$9(this.f$0, textColor, view, z);
            }
        });
    }

    public static final void updateFocusedBackgroundState$lambda$9(TextCellView this$0, int i, View view, boolean z) {
        GradientDrawable gradientDrawableAddBorderToDrawable;
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (z) {
            Integer backgroundDrawable$zendesk_ui_ui_android = this$0.rendering.getState().getBackgroundDrawable$zendesk_ui_ui_android();
            if (backgroundDrawable$zendesk_ui_ui_android != null) {
                gradientDrawableAddBorderToDrawable = ViewKt.addBorderToDrawable(this$0.messageTextView, backgroundDrawable$zendesk_ui_ui_android.intValue(), R.dimen.zuia_divider_size, i);
            } else {
                gradientDrawableAddBorderToDrawable = null;
            }
            Integer backgroundColor$zendesk_ui_ui_android = this$0.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
            if (backgroundColor$zendesk_ui_ui_android != null) {
                int iIntValue = backgroundColor$zendesk_ui_ui_android.intValue();
                if (gradientDrawableAddBorderToDrawable != null) {
                    gradientDrawableAddBorderToDrawable.setColor(iIntValue);
                }
            }
            this$0.messageTextView.setBackground(gradientDrawableAddBorderToDrawable);
            return;
        }
        this$0.setupMessageBackground();
    }

    private final void setupMessageBackground() {
        Integer backgroundDrawable$zendesk_ui_ui_android = this.rendering.getState().getBackgroundDrawable$zendesk_ui_ui_android();
        if (backgroundDrawable$zendesk_ui_ui_android != null) {
            Drawable drawable = ContextCompat.getDrawable(getContext(), backgroundDrawable$zendesk_ui_ui_android.intValue());
            GradientDrawable gradientDrawable = drawable instanceof GradientDrawable ? (GradientDrawable) drawable : null;
            if (gradientDrawable != null) {
                gradientDrawable.mutate();
            }
            Integer backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
            if (backgroundColor$zendesk_ui_ui_android != null) {
                int iIntValue = backgroundColor$zendesk_ui_ui_android.intValue();
                if (gradientDrawable != null) {
                    gradientDrawable.setColor(iIntValue);
                }
            }
            setBackground(gradientDrawable);
        }
    }

    public final void setMessageTextGravity$zendesk_ui_ui_android(int gravity) {
        TextView textView = this.messageTextView;
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        layoutParams.gravity = gravity;
        textView.setLayoutParams(layoutParams);
    }

    private final void prepareClickableElements() {
        CharSequence text = this.messageTextView.getText();
        SpannableString spannableString = text instanceof SpannableString ? (SpannableString) text : null;
        if (spannableString != null) {
            URLSpan[] uRLSpanArr = (URLSpan[]) spannableString.getSpans(0, spannableString.length(), URLSpan.class);
            Intrinsics.checkNotNull(uRLSpanArr);
            for (URLSpan uRLSpan : uRLSpanArr) {
                int spanStart = spannableString.getSpanStart(uRLSpan);
                int spanEnd = spannableString.getSpanEnd(uRLSpan);
                spannableString.removeSpan(uRLSpan);
                final String url = uRLSpan.getURL();
                spannableString.setSpan(new URLSpan(url) {
                    @Override
                    public void onClick(View widget) {
                        Unit unit;
                        Intrinsics.checkNotNullParameter(widget, "widget");
                        Function1<String, Unit> onCellTextClicked$zendesk_ui_ui_android = this.this$0.rendering.getOnCellTextClicked$zendesk_ui_ui_android();
                        if (onCellTextClicked$zendesk_ui_ui_android != null) {
                            String url2 = getURL();
                            Intrinsics.checkNotNullExpressionValue(url2, "getURL(...)");
                            onCellTextClicked$zendesk_ui_ui_android.invoke(url2);
                            unit = Unit.INSTANCE;
                        } else {
                            unit = null;
                        }
                        if (unit == null) {
                            super.onClick(widget);
                        }
                    }
                }, spanStart, spanEnd, 0);
            }
        }
    }
}
