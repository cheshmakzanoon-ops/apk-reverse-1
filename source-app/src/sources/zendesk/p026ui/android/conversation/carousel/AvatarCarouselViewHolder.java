package zendesk.p026ui.android.conversation.carousel;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.avatar.AvatarImageRendering;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 \r2\u00020\u0001:\u0001\rB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/AvatarCarouselViewHolder;", "Lzendesk/ui/android/conversation/carousel/CarouselViewHolder;", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "avatarImageView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "bind", "", "rendering", "Lzendesk/ui/android/conversation/carousel/CarouselRendering;", "cellData", "Lzendesk/ui/android/conversation/carousel/CarouselCellData$Avatar;", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AvatarCarouselViewHolder extends CarouselViewHolder {
    private static float borderAlpha;
    private final AvatarImageView avatarImageView;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    public AvatarCarouselViewHolder(View view, DefaultConstructorMarker defaultConstructorMarker) {
        this(view);
    }

    private AvatarCarouselViewHolder(View view) {
        super(view);
        View viewFindViewById = view.findViewById(R.id.zuia_carousel_list_item_avatar);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.avatarImageView = (AvatarImageView) viewFindViewById;
    }

    public final void bind(CarouselRendering rendering, final CarouselCellData.Avatar cellData) {
        Intrinsics.checkNotNullParameter(rendering, "rendering");
        Intrinsics.checkNotNullParameter(cellData, "cellData");
        if (!rendering.getShowAvatar() || cellData.getAvatarImageState() == null) {
            return;
        }
        this.avatarImageView.render(new Function1<AvatarImageRendering, AvatarImageRendering>() {
            {
                super(1);
            }

            @Override
            public final AvatarImageRendering invoke(AvatarImageRendering avatarViewRendering) {
                Intrinsics.checkNotNullParameter(avatarViewRendering, "avatarViewRendering");
                AvatarImageRendering.Builder builder = avatarViewRendering.toBuilder();
                final CarouselCellData.Avatar avatar = cellData;
                return builder.state(new Function1<AvatarImageState, AvatarImageState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final AvatarImageState invoke(AvatarImageState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return avatar.getAvatarImageState();
                    }
                }).build();
            }
        });
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eR\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\b¨\u0006\u000f"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/AvatarCarouselViewHolder$Companion;", "", "()V", "borderAlpha", "", "getBorderAlpha", "()F", "setBorderAlpha", "(F)V", "create", "Lzendesk/ui/android/conversation/carousel/AvatarCarouselViewHolder;", "layoutInflater", "Landroid/view/LayoutInflater;", "parent", "Landroid/view/ViewGroup;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final float getBorderAlpha() {
            return AvatarCarouselViewHolder.borderAlpha;
        }

        public final void setBorderAlpha(float f) {
            AvatarCarouselViewHolder.borderAlpha = f;
        }

        public final AvatarCarouselViewHolder create(LayoutInflater layoutInflater, ViewGroup parent) {
            Intrinsics.checkNotNullParameter(layoutInflater, "layoutInflater");
            Intrinsics.checkNotNullParameter(parent, "parent");
            View viewInflate = layoutInflater.inflate(R.layout.zuia_view_carousel_item_avatar, parent, false);
            Intrinsics.checkNotNull(viewInflate);
            return new AvatarCarouselViewHolder(viewInflate, null);
        }
    }
}
