package zendesk.p026ui.android.conversation.header;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.OvalShape;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.View;
import android.view.Window;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.TextView;
import coil.ImageLoader;
import coil.request.Disposable;
import coil.request.ImageRequest;
import coil.target.Target;
import coil.transform.CircleCropTransformation;
import coil.transform.Transformation;
import com.google.android.material.appbar.MaterialToolbar;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.xml.InsetType;
import zendesk.core.p017ui.android.internal.xml.SystemWindowInsetsKt;
import zendesk.p026ui.android.internal.ImageLoaderFactory;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0002J\u0018\u0010\u0015\u001a\u00020\u00122\u0006\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J\u0010\u0010\u001a\u001a\u00020\u00122\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J\b\u0010\u001b\u001a\u00020\u0012H\u0014J\u001c\u0010\u001c\u001a\u00020\u00122\u0012\u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u001eH\u0016J\u000e\u0010\u001f\u001a\u0004\u0018\u00010 *\u00020!H\u0002R\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\""}, m18d2 = {"Lzendesk/ui/android/conversation/header/ConversationHeaderView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/header/ConversationHeaderRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "imageLoaderDisposable", "Lcoil/request/Disposable;", "rendering", "toolbar", "Lcom/google/android/material/appbar/MaterialToolbar;", "addAccessibilityFocusStateForNavigationButton", "", "button", "Landroid/widget/ImageButton;", "addContentDescriptionToHeader", "headerTitle", "Landroid/widget/TextView;", "state", "Lzendesk/ui/android/conversation/header/ConversationHeaderState;", "configureToolbarAccessibility", "onDetachedFromWindow", "render", "renderingUpdate", "Lkotlin/Function1;", "getActivity", "Landroid/app/Activity;", "Landroid/view/View;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationHeaderView extends FrameLayout implements Renderer<ConversationHeaderRendering> {
    public static final int $stable = 8;
    private Disposable imageLoaderDisposable;
    private ConversationHeaderRendering rendering;
    private final MaterialToolbar toolbar;

    public ConversationHeaderView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationHeaderView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationHeaderView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationHeaderView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConversationHeaderView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ConversationHeaderRendering();
        FrameLayout.inflate(context, R.layout.zuia_view_conversation_header, this);
        MaterialToolbar materialToolbarFindViewById = findViewById(R.id.zuia_conversation_header_toolbar);
        Intrinsics.checkNotNullExpressionValue(materialToolbarFindViewById, "findViewById(...)");
        this.toolbar = materialToolbarFindViewById;
        render(new Function1<ConversationHeaderRendering, ConversationHeaderRendering>() {
            @Override
            public final ConversationHeaderRendering invoke(ConversationHeaderRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ConversationHeaderRendering, ConversationHeaderRendering> renderingUpdate) {
        Unit unit;
        Unit unit2;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        final MaterialToolbar materialToolbar = this.toolbar;
        View view = (View) materialToolbar;
        SystemWindowInsetsKt.applyWindowInsets(view, InsetType.TOP, InsetType.HORIZONTAL);
        final Function0<Unit> onBackButtonClicked$zendesk_ui_ui_android = this.rendering.getOnBackButtonClicked$zendesk_ui_ui_android();
        if (onBackButtonClicked$zendesk_ui_ui_android != null) {
            materialToolbar.setTitleMarginStart(materialToolbar.getResources().getDimensionPixelSize(R.dimen.zuia_header_logo_content_insert));
            materialToolbar.setNavigationIcon(R.drawable.zuia_ic_arrow_back);
            Integer backButtonColor$zendesk_ui_ui_android = this.rendering.getState().getBackButtonColor$zendesk_ui_ui_android();
            if (backButtonColor$zendesk_ui_ui_android != null) {
                int iIntValue = backButtonColor$zendesk_ui_ui_android.intValue();
                Drawable navigationIcon = materialToolbar.getNavigationIcon();
                if (navigationIcon != null) {
                    navigationIcon.setColorFilter(new PorterDuffColorFilter(iIntValue, PorterDuff.Mode.SRC_ATOP));
                }
            }
            materialToolbar.setNavigationContentDescription(materialToolbar.getResources().getString(R.string.zuia_back_button_accessibility_label));
            materialToolbar.setNavigationOnClickListener(new View.OnClickListener() {
                @Override
                public final void onClick(View view2) {
                    ConversationHeaderView.render$lambda$10$lambda$2$lambda$1(onBackButtonClicked$zendesk_ui_ui_android, view2);
                }
            });
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            materialToolbar.setTitleMarginStart(materialToolbar.getResources().getDimensionPixelSize(R.dimen.zuia_header_logo_margin));
            materialToolbar.setNavigationOnClickListener((View.OnClickListener) null);
        }
        Integer backgroundColor$zendesk_ui_ui_android = this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
        if (backgroundColor$zendesk_ui_ui_android != null) {
            materialToolbar.setBackground(new ColorDrawable(backgroundColor$zendesk_ui_ui_android.intValue()));
        }
        Integer statusBarColor$zendesk_ui_ui_android = this.rendering.getState().getStatusBarColor$zendesk_ui_ui_android();
        if (statusBarColor$zendesk_ui_ui_android != null) {
            int iIntValue2 = statusBarColor$zendesk_ui_ui_android.intValue();
            Activity activity = getActivity(view);
            Window window = activity != null ? activity.getWindow() : null;
            if (window != null) {
                window.setStatusBarColor(iIntValue2);
            }
        }
        Integer titleColor$zendesk_ui_ui_android = this.rendering.getState().getTitleColor$zendesk_ui_ui_android();
        if (titleColor$zendesk_ui_ui_android != null) {
            int iIntValue3 = titleColor$zendesk_ui_ui_android.intValue();
            materialToolbar.setTitleTextColor(iIntValue3);
            materialToolbar.setSubtitleTextColor(iIntValue3);
        }
        materialToolbar.setTitle(this.rendering.getState().getTitle$zendesk_ui_ui_android());
        materialToolbar.setSubtitle(this.rendering.getState().getDescription$zendesk_ui_ui_android());
        configureToolbarAccessibility(this.rendering.getState());
        Uri imageUrl$zendesk_ui_ui_android = this.rendering.getState().getImageUrl$zendesk_ui_ui_android();
        if (imageUrl$zendesk_ui_ui_android != null) {
            int dimensionPixelSize = materialToolbar.getResources().getDimensionPixelSize(R.dimen.zuia_avatar_image_size);
            ImageLoaderFactory imageLoaderFactory = ImageLoaderFactory.INSTANCE;
            Context context = materialToolbar.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            ImageLoader imageLoader = imageLoaderFactory.getImageLoader(context);
            Context context2 = materialToolbar.getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            this.imageLoaderDisposable = imageLoader.enqueue(new ImageRequest.Builder(context2).data(imageUrl$zendesk_ui_ui_android).size(dimensionPixelSize).transformations(new Transformation[]{new CircleCropTransformation()}).target(new Target() {
                public void onError(Drawable error) {
                }

                public void onStart(Drawable placeholder) {
                }

                public void onSuccess(Drawable result) {
                    materialToolbar.setLogo(result);
                    MaterialToolbar materialToolbar2 = materialToolbar;
                    materialToolbar2.setLogoDescription(materialToolbar2.getContext().getString(R.string.zuia_conversation_header_logo));
                }
            }).build());
            unit2 = Unit.INSTANCE;
        } else {
            unit2 = null;
        }
        if (unit2 == null) {
            materialToolbar.setLogo((Drawable) null);
        }
    }

    public static final void render$lambda$10$lambda$2$lambda$1(Function0 onBackButtonClicked, View view) {
        Intrinsics.checkNotNullParameter(onBackButtonClicked, "$onBackButtonClicked");
        onBackButtonClicked.invoke();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Disposable disposable = this.imageLoaderDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }

    private final Activity getActivity(View view) {
        Context context = view.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
            context = ((ContextWrapper) context).getBaseContext();
            Intrinsics.checkNotNullExpressionValue(context, "getBaseContext(...)");
        }
        return null;
    }

    private final void configureToolbarAccessibility(ConversationHeaderState state) {
        TextView textView;
        int childCount = this.toolbar.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = this.toolbar.getChildAt(i);
            Intrinsics.checkNotNullExpressionValue(childAt, "getChildAt(...)");
            if (childAt instanceof ImageButton) {
                ImageButton imageButton = (ImageButton) childAt;
                if (Intrinsics.areEqual(imageButton.getDrawable(), this.toolbar.getNavigationIcon())) {
                    addAccessibilityFocusStateForNavigationButton(imageButton);
                } else if (childAt instanceof TextView) {
                    textView = (TextView) childAt;
                    if (textView.getText().equals(this.toolbar.getTitle())) {
                        addContentDescriptionToHeader(textView, state);
                    }
                }
            } else if (childAt instanceof TextView) {
                textView = (TextView) childAt;
                if (textView.getText().equals(this.toolbar.getTitle())) {
                    addContentDescriptionToHeader(textView, state);
                }
            }
        }
    }

    private final void addAccessibilityFocusStateForNavigationButton(final ImageButton button) {
        button.setAccessibilityDelegate(new View.AccessibilityDelegate() {
            @Override
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfo info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                info.setEnabled(host.isEnabled());
                if (info.isAccessibilityFocused()) {
                    ShapeDrawable shapeDrawable = new ShapeDrawable(new OvalShape());
                    shapeDrawable.getPaint().setStyle(Paint.Style.STROKE);
                    shapeDrawable.getPaint().setStrokeWidth(ConversationHeaderView.this.getResources().getDimensionPixelSize(R.dimen.zuia_ic_back_arrow_focus_highlight_width));
                    Integer titleColor$zendesk_ui_ui_android = ConversationHeaderView.this.rendering.getState().getTitleColor$zendesk_ui_ui_android();
                    if (titleColor$zendesk_ui_ui_android != null) {
                        shapeDrawable.getPaint().setColor(titleColor$zendesk_ui_ui_android.intValue());
                    }
                    button.setBackground(shapeDrawable);
                    return;
                }
                ImageButton imageButton = button;
                Integer backgroundColor$zendesk_ui_ui_android = ConversationHeaderView.this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android();
                imageButton.setBackground(backgroundColor$zendesk_ui_ui_android != null ? new ColorDrawable(backgroundColor$zendesk_ui_ui_android.intValue()) : null);
            }
        });
    }

    private final void addContentDescriptionToHeader(TextView headerTitle, ConversationHeaderState state) {
        headerTitle.setContentDescription(state.getAccessibilityTitle$zendesk_ui_ui_android());
    }
}
