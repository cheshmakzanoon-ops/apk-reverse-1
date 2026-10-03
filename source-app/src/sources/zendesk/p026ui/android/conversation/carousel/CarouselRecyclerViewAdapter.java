package zendesk.p026ui.android.conversation.carousel;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import coil.ImageLoader;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.faye.internal.Bayeux;
import zendesk.p026ui.android.internal.ImageLoaderFactory;

@Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\b\u0010\u0011\u001a\u00020\u0012H\u0016J\u0010\u0010\u0013\u001a\u00020\u00122\u0006\u0010\u0014\u001a\u00020\u0012H\u0016J\u0006\u0010\u0015\u001a\u00020\u0016J\u0018\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00022\u0006\u0010\u0014\u001a\u00020\u0012H\u0016J\u0018\u0010\u001a\u001a\u00020\u00022\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u0012H\u0016J\u000e\u0010\u001e\u001a\u00020\u00182\u0006\u0010\u001f\u001a\u00020 R\u001e\u0010\u0006\u001a\u0012\u0012\u0004\u0012\u00020\b0\u0007j\b\u0012\u0004\u0012\u00020\b`\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\f\u001a\n \u000e*\u0004\u0018\u00010\r0\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006!"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselRecyclerViewAdapter;", "Landroidx/recyclerview/widget/RecyclerView$Adapter;", "Lzendesk/ui/android/conversation/carousel/CarouselViewHolder;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", Bayeux.KEY_DATA, "Ljava/util/ArrayList;", "Lzendesk/ui/android/conversation/carousel/CarouselCellData;", "Lkotlin/collections/ArrayList;", "imageLoader", "Lcoil/ImageLoader;", "layoutInflater", "Landroid/view/LayoutInflater;", "kotlin.jvm.PlatformType", "rendering", "Lzendesk/ui/android/conversation/carousel/CarouselRendering;", "getItemCount", "", "getItemViewType", "position", "hasAvatar", "", "onBindViewHolder", "", "holder", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "viewType", "swapData", "state", "Lzendesk/ui/android/conversation/carousel/CarouselCellState;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class CarouselRecyclerViewAdapter extends RecyclerView.Adapter<CarouselViewHolder> {
    public static final int $stable = 8;
    private final ArrayList<CarouselCellData> data;
    private final ImageLoader imageLoader;
    private final LayoutInflater layoutInflater;
    private CarouselRendering rendering;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[CarouselViewType.values().length];
            try {
                iArr[CarouselViewType.ITEM.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[CarouselViewType.AVATAR.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public CarouselRecyclerViewAdapter(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.data = new ArrayList<>();
        this.rendering = new CarouselRendering(0, 0, 0, 0, 0, 0, 0, 0, 0, false, 0, 0, 4095, null);
        this.layoutInflater = LayoutInflater.from(context);
        this.imageLoader = ImageLoaderFactory.INSTANCE.getImageLoader(context);
    }

    public CarouselViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        int i = WhenMappings.$EnumSwitchMapping$0[CarouselViewType.values()[viewType].ordinal()];
        if (i == 1) {
            ArticleCarouselViewHolder.Companion companion = ArticleCarouselViewHolder.INSTANCE;
            LayoutInflater layoutInflater = this.layoutInflater;
            Intrinsics.checkNotNullExpressionValue(layoutInflater, "layoutInflater");
            return companion.create(layoutInflater, parent, this.imageLoader);
        }
        if (i != 2) {
            throw new NoWhenBranchMatchedException();
        }
        AvatarCarouselViewHolder.Companion companion2 = AvatarCarouselViewHolder.INSTANCE;
        LayoutInflater layoutInflater2 = this.layoutInflater;
        Intrinsics.checkNotNullExpressionValue(layoutInflater2, "layoutInflater");
        return companion2.create(layoutInflater2, parent);
    }

    public void onBindViewHolder(CarouselViewHolder holder, int position) {
        Intrinsics.checkNotNullParameter(holder, "holder");
        if (holder instanceof ArticleCarouselViewHolder) {
            CarouselRendering carouselRendering = this.rendering;
            CarouselCellData carouselCellData = this.data.get(position);
            Intrinsics.checkNotNull(carouselCellData, "null cannot be cast to non-null type zendesk.ui.android.conversation.carousel.CarouselCellData.Item");
            ((ArticleCarouselViewHolder) holder).bind(carouselRendering, (CarouselCellData.Item) carouselCellData);
            return;
        }
        if (holder instanceof AvatarCarouselViewHolder) {
            CarouselRendering carouselRendering2 = this.rendering;
            CarouselCellData carouselCellData2 = this.data.get(position);
            Intrinsics.checkNotNull(carouselCellData2, "null cannot be cast to non-null type zendesk.ui.android.conversation.carousel.CarouselCellData.Avatar");
            ((AvatarCarouselViewHolder) holder).bind(carouselRendering2, (CarouselCellData.Avatar) carouselCellData2);
        }
    }

    public int getItemCount() {
        return this.data.size();
    }

    public int getItemViewType(int position) {
        if (position == -1) {
            return -1;
        }
        return this.data.get(position).getCarouselViewType().ordinal();
    }

    public final void swapData(CarouselCellState state) {
        Intrinsics.checkNotNullParameter(state, "state");
        this.data.clear();
        this.data.addAll(state.getCellData());
        this.rendering = state.getRendering();
        notifyItemRangeChanged(0, this.data.size());
    }

    public final boolean hasAvatar() {
        return CollectionsKt.firstOrNull((List) this.data) instanceof CarouselCellData.Avatar;
    }
}
