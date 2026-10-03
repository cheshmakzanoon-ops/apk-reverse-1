package zendesk.p026ui.android.conversation.imagerviewer;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import coil.ImageLoader;
import coil.memory.MemoryCache;
import coil.request.Disposable;
import coil.request.ImageRequest;
import cz.msebera.android.httpclient.HttpStatus;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.xml.InsetType;
import zendesk.core.p017ui.android.internal.xml.SystemWindowInsetsKt;
import zendesk.p026ui.android.conversation.header.ConversationHeaderRendering;
import zendesk.p026ui.android.conversation.header.ConversationHeaderState;
import zendesk.p026ui.android.conversation.header.ConversationHeaderView;
import zendesk.p026ui.android.internal.ImageLoaderFactory;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u0017\u001a\u00020\u0018H\u0014J\u001c\u0010\u0019\u001a\u00020\u00182\u0012\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u000fH\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u000e\u001a\u0018\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00100\u000fj\b\u0012\u0004\u0012\u00020\u0010`\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversation/imagerviewer/ImageViewerView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "headerView", "Lzendesk/ui/android/conversation/header/ConversationHeaderView;", "headerViewRenderingUpdate", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/header/ConversationHeaderRendering;", "Lzendesk/ui/android/conversation/imagerviewer/RenderingUpdate;", "imageLoaderDisposable", "Lcoil/request/Disposable;", "imageView", "Landroid/widget/ImageView;", "rendering", "onDetachedFromWindow", "", "render", "renderingUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerView extends FrameLayout implements Renderer<ImageViewerRendering> {
    public static final int $stable = 8;
    private final ConversationHeaderView headerView;
    private final Function1<ConversationHeaderRendering, ConversationHeaderRendering> headerViewRenderingUpdate;
    private Disposable imageLoaderDisposable;
    private final ImageView imageView;
    private ImageViewerRendering rendering;

    public ImageViewerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ImageViewerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ImageViewerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ImageViewerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ImageViewerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ImageViewerRendering();
        this.headerViewRenderingUpdate = new Function1<ConversationHeaderRendering, ConversationHeaderRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationHeaderRendering invoke(ConversationHeaderRendering conversationHeaderRendering) {
                Intrinsics.checkNotNullParameter(conversationHeaderRendering, "conversationHeaderRendering");
                ConversationHeaderRendering.Builder builder = conversationHeaderRendering.toBuilder();
                final ImageViewerView imageViewerView = this.this$0;
                ConversationHeaderRendering.Builder builderState = builder.state(new Function1<ConversationHeaderState, ConversationHeaderState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ConversationHeaderState invoke(ConversationHeaderState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy((HttpStatus.SC_MULTI_STATUS & 1) != 0 ? state.title : null, (HttpStatus.SC_MULTI_STATUS & 2) != 0 ? state.description : null, (HttpStatus.SC_MULTI_STATUS & 4) != 0 ? state.imageUrl : null, (HttpStatus.SC_MULTI_STATUS & 8) != 0 ? state.accessibilityTitle : null, (HttpStatus.SC_MULTI_STATUS & 16) != 0 ? state.backgroundColor : imageViewerView.rendering.getState().getToolbarColor$zendesk_ui_ui_android(), (HttpStatus.SC_MULTI_STATUS & 32) != 0 ? state.statusBarColor : imageViewerView.rendering.getState().getStatusBarColor$zendesk_ui_ui_android(), (HttpStatus.SC_MULTI_STATUS & 64) != 0 ? state.titleColor : null, (HttpStatus.SC_MULTI_STATUS & 128) != 0 ? state.backButtonColor : null);
                    }
                });
                final ImageViewerView imageViewerView2 = this.this$0;
                return builderState.onBackButtonClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        imageViewerView2.rendering.getOnBackButtonClicked$zendesk_ui_ui_android().invoke();
                    }
                }).build();
            }
        };
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_ConversationHeader, false);
        FrameLayout.inflate(context, R.layout.zuia_view_image_viewer, this);
        View viewFindViewById = findViewById(R.id.zuia_header_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.headerView = (ConversationHeaderView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_image_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.imageView = (ImageView) viewFindViewById2;
        render(new Function1<ImageViewerRendering, ImageViewerRendering>() {
            @Override
            public final ImageViewerRendering invoke(ImageViewerRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ImageViewerRendering, ImageViewerRendering> renderingUpdate) {
        MemoryCache.Value value;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        SystemWindowInsetsKt.applyWindowInsets(this, InsetType.BOTTOM, InsetType.HORIZONTAL);
        this.headerView.render(this.headerViewRenderingUpdate);
        String uri$zendesk_ui_ui_android = this.rendering.getState().getUri$zendesk_ui_ui_android();
        if (uri$zendesk_ui_ui_android != null) {
            ImageLoaderFactory imageLoaderFactory = ImageLoaderFactory.INSTANCE;
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            ImageLoader imageLoader = imageLoaderFactory.getImageLoader(context);
            MemoryCache memoryCache = imageLoader.getMemoryCache();
            Bitmap bitmap = (memoryCache == null || (value = memoryCache.get(new MemoryCache.Key(uri$zendesk_ui_ui_android, (Map) null, 2, (DefaultConstructorMarker) null))) == null) ? null : value.getBitmap();
            if (bitmap != null) {
                this.imageView.setImageBitmap(bitmap);
                return;
            }
            Context context2 = getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            ImageRequest.Builder builderTarget = new ImageRequest.Builder(context2).data(uri$zendesk_ui_ui_android).memoryCacheKey(new MemoryCache.Key(uri$zendesk_ui_ui_android, (Map) null, 2, (DefaultConstructorMarker) null)).target(this.imageView);
            String authorizationToken$zendesk_ui_ui_android = this.rendering.getState().getAuthorizationToken$zendesk_ui_ui_android();
            if (authorizationToken$zendesk_ui_ui_android != null) {
                builderTarget.addHeader("Authorization", authorizationToken$zendesk_ui_ui_android);
            }
            this.imageLoaderDisposable = imageLoader.enqueue(builderTarget.build());
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Disposable disposable = this.imageLoaderDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }
}
