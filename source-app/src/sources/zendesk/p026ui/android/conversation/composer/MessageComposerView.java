package zendesk.p026ui.android.conversation.composer;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewPropertyAnimator;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.LinearInterpolator;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ThrottledAfterTextChangedKt;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\b\b\u0007\u0018\u0000 $2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001$B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0017\u001a\u00020\u00182\u0012\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u001aH\u0016J\u0010\u0010\u001b\u001a\u00020\u00182\u0006\u0010\u001c\u001a\u00020\u001dH\u0002J\b\u0010\u001e\u001a\u00020\u0018H\u0002J\u0010\u0010\u001f\u001a\u00020\u00182\u0006\u0010\u001c\u001a\u00020\u001dH\u0002J\u0010\u0010 \u001a\u00020\u00182\u0006\u0010\u001c\u001a\u00020\u001dH\u0016J\b\u0010!\u001a\u00020\u0018H\u0002J\b\u0010\"\u001a\u00020\u0018H\u0002J\b\u0010#\u001a\u00020\u0018H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0015\u001a\u0004\u0018\u00010\u0016X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006%"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/composer/MessageComposerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "attachButton", "Landroid/widget/ImageButton;", "composerContainer", "messageComposer", "Landroidx/constraintlayout/widget/ConstraintLayout;", "rendering", "sendButton", "textField", "Landroid/widget/EditText;", "viewPropertyAnimator", "Landroid/view/ViewPropertyAnimator;", "render", "", "renderingUpdate", "Lkotlin/Function1;", "renderAttachButton", "enabled", "", "renderAttachMenu", "renderSendButton", "setEnabled", "setupAttachButtonBackgroundState", "setupMessageComposerFocusedState", "setupSendButtonBackgroundState", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageComposerView extends FrameLayout implements Renderer<MessageComposerRendering> {
    private static final float ATTACHMENT_ALPHA = 0.85f;
    private static final int COMPOSER_MAX_LINES = 5;
    private static final long SEND_BUTTON_HIDE_OPACITY_ANIMATION_DURATION = 200;
    private static final long SEND_BUTTON_HIDE_TRANSLATION_ANIMATION_DURATION = 300;
    private static final long SEND_BUTTON_SHOW_OPACITY_ANIMATION_DELAY = 100;
    private static final long SEND_BUTTON_SHOW_OPACITY_ANIMATION_DURATION = 200;
    private static final long SEND_BUTTON_SHOW_TRANSLATION_ANIMATION_DURATION = 300;
    private final ImageButton attachButton;
    private final FrameLayout composerContainer;
    private final ConstraintLayout messageComposer;
    private MessageComposerRendering rendering;
    private final ImageButton sendButton;
    private final EditText textField;
    private ViewPropertyAnimator viewPropertyAnimator;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public MessageComposerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageComposerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageComposerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageComposerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public MessageComposerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new MessageComposerRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_MessageComposer, false);
        FrameLayout.inflate(context, R.layout.zuia_view_message_composer, this);
        View viewFindViewById = findViewById(R.id.zuia_composer_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.composerContainer = (FrameLayout) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_attach_button);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.attachButton = (ImageButton) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_text_field);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        EditText editText = (EditText) viewFindViewById3;
        this.textField = editText;
        View viewFindViewById4 = findViewById(R.id.zuia_send_button);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.sendButton = (ImageButton) viewFindViewById4;
        ConstraintLayout constraintLayoutFindViewById = findViewById(R.id.zuia_message_composer_view);
        Intrinsics.checkNotNullExpressionValue(constraintLayoutFindViewById, "findViewById(...)");
        this.messageComposer = constraintLayoutFindViewById;
        context.getTheme().resolveAttribute(com.google.android.material.R.attr.colorOnSurface, new TypedValue(), true);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void afterTextChanged(Editable s) {
            }

            @Override
            public void beforeTextChanged(CharSequence text, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence text, int start, int before, int count) {
                if (text == null || !(!StringsKt.isBlank(text))) {
                    return;
                }
                this.this$0.rendering.getOnTyping$zendesk_ui_ui_android().invoke();
            }
        });
        editText.addTextChangedListener(ThrottledAfterTextChangedKt.throttledAfterTextChangedListener$default(0L, new Function1<Editable, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Editable editable) {
                invoke2(editable);
                return Unit.INSTANCE;
            }

            public final void invoke2(Editable editable) {
                if (editable != null && (!StringsKt.isBlank(editable))) {
                    MessageComposerView.this.renderSendButton(true);
                }
                MessageComposerView.this.rendering.getOnTextChanged$zendesk_ui_ui_android().invoke(StringsKt.trim((CharSequence) String.valueOf(editable)).toString());
            }
        }, 1, null));
        render(new Function1<MessageComposerRendering, MessageComposerRendering>() {
            @Override
            public final MessageComposerRendering invoke(MessageComposerRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super MessageComposerRendering, MessageComposerRendering> renderingUpdate) {
        InputFilter.LengthFilter[] lengthFilterArr;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        MessageComposerRendering messageComposerRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = messageComposerRenderingInvoke;
        setEnabled(messageComposerRenderingInvoke.getState().getEnabled$zendesk_ui_ui_android());
        ViewKt.outlinedBoxBackground$default(this.composerContainer, ColorExtKt.adjustAlpha(this.rendering.getState().getBorderColor$zendesk_ui_ui_android(), 0.55f), getResources().getDimension(R.dimen.zuia_message_composer_radius), 0.0f, 0, 12, null);
        EditText editText = this.textField;
        if (this.rendering.getState().getInputMaxLength$zendesk_ui_ui_android() >= 0) {
            lengthFilterArr = new InputFilter.LengthFilter[]{new InputFilter.LengthFilter(this.rendering.getState().getInputMaxLength$zendesk_ui_ui_android())};
        } else {
            lengthFilterArr = new InputFilter[0];
        }
        editText.setFilters(lengthFilterArr);
        this.attachButton.setColorFilter(ColorExtKt.adjustAlpha(this.rendering.getState().getAttachButtonColor$zendesk_ui_ui_android(), ATTACHMENT_ALPHA), PorterDuff.Mode.SRC_IN);
        this.sendButton.setColorFilter(this.rendering.getState().getSendButtonColor$zendesk_ui_ui_android());
        this.sendButton.setContentDescription(getResources().getString(R.string.zuia_send_button_accessibility_label));
        this.sendButton.setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                MessageComposerView.this.rendering.getOnSendButtonClicked$zendesk_ui_ui_android().invoke(StringsKt.trim((CharSequence) MessageComposerView.this.textField.getText().toString()).toString());
                MessageComposerView.this.textField.setText((CharSequence) null);
            }
        }, 1, null));
        setupAttachButtonBackgroundState();
        this.messageComposer.setVisibility(this.rendering.getState().getVisibility$zendesk_ui_ui_android());
        this.attachButton.setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                MessageComposerView.this.renderAttachMenu();
            }
        }, 1, null));
        String composerText$zendesk_ui_ui_android = this.rendering.getState().getComposerText$zendesk_ui_ui_android();
        if (composerText$zendesk_ui_ui_android.length() > 0) {
            this.textField.setText(composerText$zendesk_ui_ui_android);
        }
        if (this.textField.hasFocus()) {
            EditText editText2 = this.textField;
            editText2.setSelection(editText2.getText().toString().length());
        }
        this.textField.setHintTextColor(ColorExtKt.adjustAlpha(this.rendering.getState().getTextColor$zendesk_ui_ui_android(), 0.55f));
        this.textField.setTextColor(this.rendering.getState().getTextColor$zendesk_ui_ui_android());
        setupMessageComposerFocusedState();
    }

    private final void setupMessageComposerFocusedState() {
        this.textField.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                MessageComposerView.setupMessageComposerFocusedState$lambda$2(this.f$0, view, z);
            }
        });
        this.sendButton.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                MessageComposerView.setupMessageComposerFocusedState$lambda$3(this.f$0, view, z);
            }
        });
    }

    public static final void setupMessageComposerFocusedState$lambda$2(MessageComposerView this$0, View view, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.textField.hasFocus()) {
            this$0.renderSendButton(true);
            return;
        }
        if (this$0.sendButton.hasFocus()) {
            return;
        }
        Editable text = this$0.textField.getText();
        if (text == null || StringsKt.isBlank(text)) {
            this$0.renderSendButton(false);
        }
    }

    public static final void setupMessageComposerFocusedState$lambda$3(MessageComposerView this$0, View view, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.sendButton.hasFocus()) {
            this$0.renderSendButton(true);
            return;
        }
        if (this$0.textField.hasFocus()) {
            return;
        }
        Editable text = this$0.textField.getText();
        if (text == null || StringsKt.isBlank(text)) {
            this$0.renderSendButton(false);
        }
    }

    private final void setupAttachButtonBackgroundState() {
        int sendButtonColor$zendesk_ui_ui_android = this.rendering.getState().getSendButtonColor$zendesk_ui_ui_android();
        ImageButton imageButton = this.attachButton;
        int i = R.drawable.zuia_attachment_button_background;
        int i2 = R.dimen.zuia_attachment_button_stroke_width;
        Drawable background = this.attachButton.getBackground();
        Intrinsics.checkNotNullExpressionValue(background, "getBackground(...)");
        ViewKt.addAccessibilityFocusedState(imageButton, i, i2, sendButtonColor$zendesk_ui_ui_android, background);
    }

    @Override
    public void setEnabled(boolean enabled) {
        super.setEnabled(enabled);
        renderAttachButton(this.rendering.getState().getShowAttachment$zendesk_ui_ui_android());
        if (enabled) {
            this.textField.setEnabled(true);
            this.textField.setMaxLines(5);
            Editable text = this.textField.getText();
            Intrinsics.checkNotNullExpressionValue(text, "getText(...)");
            renderSendButton(!StringsKt.isBlank(text));
            return;
        }
        this.textField.setEnabled(false);
        this.textField.setMaxLines(1);
        renderSendButton(false);
    }

    public final void renderSendButton(boolean enabled) {
        final ImageButton imageButton = this.sendButton;
        if ((imageButton.getVisibility() == 0) == enabled) {
            return;
        }
        float height = (imageButton.getHeight() / 2.0f) * (this.sendButton.getLayoutDirection() == 1 ? -1 : 1);
        ViewPropertyAnimator viewPropertyAnimator = this.viewPropertyAnimator;
        if (viewPropertyAnimator != null) {
            viewPropertyAnimator.cancel();
        }
        if (enabled) {
            imageButton.setAlpha(0.0f);
            imageButton.setVisibility(0);
            imageButton.setTranslationX(height);
            ViewPropertyAnimator viewPropertyAnimatorWithEndAction = imageButton.animate().translationX(0.0f).setDuration(300L).setInterpolator(new DecelerateInterpolator()).withStartAction(new Runnable() {
                @Override
                public final void run() {
                    MessageComposerView.renderSendButton$lambda$10$lambda$4(imageButton);
                }
            }).withEndAction(new Runnable() {
                @Override
                public final void run() {
                    MessageComposerView.renderSendButton$lambda$10$lambda$5(imageButton, this);
                }
            });
            viewPropertyAnimatorWithEndAction.start();
            this.viewPropertyAnimator = viewPropertyAnimatorWithEndAction;
        } else {
            imageButton.setTranslationX(0.0f);
            ViewPropertyAnimator viewPropertyAnimatorWithEndAction2 = imageButton.animate().translationX(height).setDuration(300L).setInterpolator(new AccelerateInterpolator()).withStartAction(new Runnable() {
                @Override
                public final void run() {
                    MessageComposerView.renderSendButton$lambda$10$lambda$7(imageButton);
                }
            }).withEndAction(new Runnable() {
                @Override
                public final void run() {
                    MessageComposerView.renderSendButton$lambda$10$lambda$8(imageButton, this);
                }
            });
            viewPropertyAnimatorWithEndAction2.start();
            this.viewPropertyAnimator = viewPropertyAnimatorWithEndAction2;
        }
        setupSendButtonBackgroundState();
    }

    public static final void renderSendButton$lambda$10$lambda$4(ImageButton this_apply) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        this_apply.animate().alpha(1.0f).setStartDelay(SEND_BUTTON_SHOW_OPACITY_ANIMATION_DELAY).setDuration(200L).setInterpolator(new LinearInterpolator()).start();
    }

    public static final void renderSendButton$lambda$10$lambda$5(ImageButton this_apply, MessageComposerView this$0) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this_apply.setVisibility(0);
        this$0.viewPropertyAnimator = null;
    }

    public static final void renderSendButton$lambda$10$lambda$7(ImageButton this_apply) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        this_apply.animate().alpha(0.0f).setDuration(200L).start();
    }

    public static final void renderSendButton$lambda$10$lambda$8(ImageButton this_apply, MessageComposerView this$0) {
        Intrinsics.checkNotNullParameter(this_apply, "$this_apply");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this_apply.setVisibility(8);
        this$0.viewPropertyAnimator = null;
    }

    private final void setupSendButtonBackgroundState() {
        ViewKt.addAccessibilityFocusedState$default(this.sendButton, R.drawable.zuia_attachment_button_background, R.dimen.zuia_attachment_button_stroke_width, this.rendering.getState().getSendButtonColor$zendesk_ui_ui_android(), null, 8, null);
    }

    private final void renderAttachButton(boolean enabled) {
        ImageButton imageButton = this.attachButton;
        imageButton.setEnabled(enabled);
        imageButton.setVisibility(enabled && (this.rendering.getState().getGallerySupported$zendesk_ui_ui_android() || this.rendering.getState().getCameraSupported$zendesk_ui_ui_android()) ? 0 : 8);
    }

    public final void renderAttachMenu() {
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        MessageComposerAttachmentMenu messageComposerAttachmentMenu = new MessageComposerAttachmentMenu(context);
        messageComposerAttachmentMenu.setGallerySupported(this.rendering.getState().getGallerySupported$zendesk_ui_ui_android());
        messageComposerAttachmentMenu.setCameraSupported(this.rendering.getState().getCameraSupported$zendesk_ui_ui_android());
        final BottomSheetDialog bottomSheetDialog = new BottomSheetDialog(getContext());
        messageComposerAttachmentMenu.setOnItemClickListener(new Function1<Integer, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Integer num) {
                invoke(num.intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(int i) {
                MessageComposerView.this.rendering.getOnAttachButtonClicked$zendesk_ui_ui_android().invoke(Integer.valueOf(i));
                bottomSheetDialog.dismiss();
            }
        });
        bottomSheetDialog.getBehavior().setState(3);
        bottomSheetDialog.getBehavior().setSkipCollapsed(true);
        bottomSheetDialog.setContentView(messageComposerAttachmentMenu);
        bottomSheetDialog.show();
    }

    @Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\t\n\u0002\b\u0005\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerView$Companion;", "", "()V", "ATTACHMENT_ALPHA", "", "COMPOSER_MAX_LINES", "", "SEND_BUTTON_HIDE_OPACITY_ANIMATION_DURATION", "", "SEND_BUTTON_HIDE_TRANSLATION_ANIMATION_DURATION", "SEND_BUTTON_SHOW_OPACITY_ANIMATION_DELAY", "SEND_BUTTON_SHOW_OPACITY_ANIMATION_DURATION", "SEND_BUTTON_SHOW_TRANSLATION_ANIMATION_DURATION", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
