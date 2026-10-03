package zendesk.p026ui.android.conversation.carousel;

import android.content.Context;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\r\u001a\u00020\nH\u0016J\u0010\u0010\u000e\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00020\u0010H\u0016J\u0015\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u000b\u001a\u00020\fH\u0000¢\u0006\u0002\b\u0013J\u0015\u0010\u0014\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\nH\u0000¢\u0006\u0002\b\u0016R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\t\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselLayoutManager;", "Landroidx/recyclerview/widget/LinearLayoutManager;", "context", "Landroid/content/Context;", "adapter", "Lzendesk/ui/android/conversation/carousel/CarouselRecyclerViewAdapter;", "(Landroid/content/Context;Lzendesk/ui/android/conversation/carousel/CarouselRecyclerViewAdapter;)V", "getAdapter", "()Lzendesk/ui/android/conversation/carousel/CarouselRecyclerViewAdapter;", "isScrollEnabled", "", "margin", "", "canScrollHorizontally", "checkLayoutParams", "lp", "Landroidx/recyclerview/widget/RecyclerView$LayoutParams;", "setItemMargin", "", "setItemMargin$zendesk_ui_ui_android", "setScroll", "scrollEnabled", "setScroll$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class CarouselLayoutManager extends LinearLayoutManager {
    public static final int $stable = 8;
    private final CarouselRecyclerViewAdapter adapter;
    private boolean isScrollEnabled;
    private int margin;

    public final CarouselRecyclerViewAdapter getAdapter() {
        return this.adapter;
    }

    public CarouselLayoutManager(Context context, CarouselRecyclerViewAdapter adapter) {
        super(context, 0, false);
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(adapter, "adapter");
        this.adapter = adapter;
        this.isScrollEnabled = true;
    }

    public boolean checkLayoutParams(RecyclerView.LayoutParams lp) {
        int viewAdapterPosition;
        Intrinsics.checkNotNullParameter(lp, "lp");
        try {
            viewAdapterPosition = lp.getViewAdapterPosition();
        } catch (Exception unused) {
            viewAdapterPosition = -1;
        }
        if (this.adapter.getItemViewType(viewAdapterPosition) != CarouselViewType.AVATAR.ordinal()) {
            lp.width = getWidth() - this.margin;
            return true;
        }
        lp.width = -2;
        return true;
    }

    public boolean getIsScrollEnabled() {
        return this.isScrollEnabled;
    }

    public final void setScroll$zendesk_ui_ui_android(boolean scrollEnabled) {
        this.isScrollEnabled = scrollEnabled;
    }

    public final void setItemMargin$zendesk_ui_ui_android(int margin) {
        this.margin = margin;
    }
}
