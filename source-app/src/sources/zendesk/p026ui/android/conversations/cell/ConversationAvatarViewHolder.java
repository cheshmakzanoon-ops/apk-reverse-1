package zendesk.p026ui.android.conversations.cell;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.view.View;
import android.widget.ImageView;
import androidx.core.content.res.ResourcesCompat;
import coil.ImageLoader;
import coil.request.Disposable;
import coil.request.ImageRequest;
import coil.transform.CircleCropTransformation;
import coil.transform.Transformation;
import com.google.android.material.imageview.ShapeableImageView;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarMask;
import zendesk.p026ui.android.internal.ImageLoaderFactory;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0017\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fH\u0000¢\u0006\u0002\b\rJ\r\u0010\u000e\u001a\u00020\nH\u0000¢\u0006\u0002\b\u000fJ\u0016\u0010\u0010\u001a\u0004\u0018\u00010\u0011*\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u0013H\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationAvatarViewHolder;", "", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "avatarImageView", "Lcom/google/android/material/imageview/ShapeableImageView;", "imageLoaderDisposable", "Lcoil/request/Disposable;", "onBind", "", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "onBind$zendesk_ui_ui_android", "onUnbind", "onUnbind$zendesk_ui_ui_android", "getFallbackDrawable", "Landroid/graphics/drawable/Drawable;", "resources", "Landroid/content/res/Resources;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationAvatarViewHolder {
    public static final int $stable = 8;
    private final ShapeableImageView avatarImageView;
    private Disposable imageLoaderDisposable;

    public ConversationAvatarViewHolder(View view) {
        Intrinsics.checkNotNullParameter(view, "view");
        ShapeableImageView shapeableImageViewFindViewById = view.findViewById(R.id.zuia_conversation_avatar_image_view);
        Intrinsics.checkNotNullExpressionValue(shapeableImageViewFindViewById, "findViewById(...)");
        this.avatarImageView = shapeableImageViewFindViewById;
    }

    public final void onBind$zendesk_ui_ui_android(AvatarImageState avatarImageState) {
        ImageView imageView = this.avatarImageView;
        Resources resources = imageView.getContext().getResources();
        Disposable disposable = this.imageLoaderDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
        Uri uri = avatarImageState != null ? avatarImageState.getUri() : null;
        if (uri == null) {
            imageView.setBackground((Drawable) null);
        }
        ImageLoaderFactory imageLoaderFactory = ImageLoaderFactory.INSTANCE;
        Context context = imageView.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ImageLoader imageLoader = imageLoaderFactory.getImageLoader(context);
        Context context2 = imageView.getContext();
        Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
        ImageRequest.Builder builderData = new ImageRequest.Builder(context2).data(uri);
        Intrinsics.checkNotNull(resources);
        ImageRequest.Builder builderTarget = builderData.error(getFallbackDrawable(imageView, resources)).fallback(getFallbackDrawable(imageView, resources)).placeholder(getFallbackDrawable(imageView, resources)).target(imageView);
        if ((avatarImageState != null ? avatarImageState.getMask() : null) == AvatarMask.CIRCLE) {
            builderTarget.transformations(new Transformation[]{new CircleCropTransformation()});
        }
        this.imageLoaderDisposable = imageLoader.enqueue(builderTarget.build());
    }

    public final void onUnbind$zendesk_ui_ui_android() {
        Disposable disposable = this.imageLoaderDisposable;
        if (disposable != null) {
            disposable.dispose();
        }
    }

    private final Drawable getFallbackDrawable(ShapeableImageView shapeableImageView, Resources resources) {
        return ResourcesCompat.getDrawable(resources, R.drawable.zuia_conversation_avatar_default, shapeableImageView.getContext().getTheme());
    }
}
