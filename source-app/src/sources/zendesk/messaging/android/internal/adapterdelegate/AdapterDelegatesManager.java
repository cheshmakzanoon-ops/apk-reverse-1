package zendesk.messaging.android.internal.adapterdelegate;

import android.view.View;
import android.view.ViewGroup;
import androidx.collection.SparseArrayCompat;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 \u001b*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0002\u001b\u001cB%\u0012\u001e\u0010\u0003\u001a\u0010\u0012\f\b\u0001\u0012\b\u0012\u0004\u0012\u00028\u00000\u00050\u0004\"\b\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\u0002\u0010\u0006J\u001c\u0010\b\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0002J\u0018\u0010\n\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010\u00052\u0006\u0010\u000b\u001a\u00020\fH\u0002J\u001b\u0010\r\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00028\u00002\u0006\u0010\u000f\u001a\u00020\f¢\u0006\u0002\u0010\u0010J5\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u000e\u001a\u00028\u00002\u0006\u0010\u000f\u001a\u00020\f2\u0006\u0010\u0013\u001a\u00020\u00142\u0010\b\u0002\u0010\u0015\u001a\n\u0012\u0004\u0012\u00020\u0002\u0018\u00010\u0016¢\u0006\u0002\u0010\u0017J\u0016\u0010\u0018\u001a\u00020\u00142\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u000b\u001a\u00020\fR\u001a\u0010\u0003\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00050\u0007X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001d"}, m18d2 = {"Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegatesManager;", "T", "", "delegates", "", "Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegate;", "([Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegate;)V", "Landroidx/collection/SparseArrayCompat;", "addDelegate", "delegate", "getDelegateForViewType", "viewType", "", "getItemViewType", "items", "position", "(Ljava/lang/Object;I)I", "onBindViewHolder", "", "holder", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "payloads", "", "(Ljava/lang/Object;ILandroidx/recyclerview/widget/RecyclerView$ViewHolder;Ljava/util/List;)V", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "Companion", "DefaultViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AdapterDelegatesManager<T> {
    private static final String LOG_TAG = "AdapterDelegatesManager";
    private SparseArrayCompat<AdapterDelegate<T>> delegates;
    private static final List<Object> PAYLOADS_EMPTY_LIST = CollectionsKt.emptyList();

    public AdapterDelegatesManager(AdapterDelegate<T>... delegates) {
        Intrinsics.checkNotNullParameter(delegates, "delegates");
        this.delegates = new SparseArrayCompat<>(0, 1, (DefaultConstructorMarker) null);
        for (AdapterDelegate<T> adapterDelegate : delegates) {
            addDelegate(adapterDelegate);
        }
    }

    private final AdapterDelegatesManager<T> addDelegate(AdapterDelegate<T> delegate) {
        int size = this.delegates.size();
        while (this.delegates.get(size) != null) {
            size++;
        }
        this.delegates.put(size, delegate);
        return this;
    }

    public final int getItemViewType(T items, int position) {
        if (items == null) {
            Logger.m219e(LOG_TAG, "Items data source is null!", new Object[0]);
        }
        int size = this.delegates.size();
        for (int i = 0; i < size; i++) {
            AdapterDelegate adapterDelegate = (AdapterDelegate) this.delegates.valueAt(i);
            if (adapterDelegate != null && adapterDelegate.isForViewType(items, position)) {
                return this.delegates.keyAt(i);
            }
        }
        Logger.m219e(LOG_TAG, items instanceof List ? "No AdapterDelegate added that matches item=" + String.valueOf(((List) items).get(position)) + " at position=" + position + " in data source" : "No AdapterDelegate added for item at position=" + position + ". items=" + items, new Object[0]);
        return 0;
    }

    public final RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolderOnCreateViewHolder;
        Intrinsics.checkNotNullParameter(parent, "parent");
        AdapterDelegate<T> delegateForViewType = getDelegateForViewType(viewType);
        return (delegateForViewType == null || (viewHolderOnCreateViewHolder = delegateForViewType.onCreateViewHolder(parent)) == null) ? new DefaultViewHolder(parent) : viewHolderOnCreateViewHolder;
    }

    public static void onBindViewHolder$default(AdapterDelegatesManager adapterDelegatesManager, Object obj, int i, RecyclerView.ViewHolder viewHolder, List list, int i2, Object obj2) {
        if ((i2 & 8) != 0) {
            list = PAYLOADS_EMPTY_LIST;
        }
        adapterDelegatesManager.onBindViewHolder(obj, i, viewHolder, list);
    }

    public final void onBindViewHolder(T items, int position, RecyclerView.ViewHolder holder, List<? extends Object> payloads) {
        Unit unit;
        Intrinsics.checkNotNullParameter(holder, "holder");
        AdapterDelegate<T> delegateForViewType = getDelegateForViewType(holder.getItemViewType());
        if (delegateForViewType != null) {
            if (payloads == null) {
                payloads = PAYLOADS_EMPTY_LIST;
            }
            delegateForViewType.onBindViewHolder(items, position, holder, payloads);
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            Logger.m219e(LOG_TAG, "No delegate found for item at position = " + position + " for viewType = " + holder.getItemViewType(), new Object[0]);
        }
    }

    private final AdapterDelegate<T> getDelegateForViewType(int viewType) {
        return (AdapterDelegate) this.delegates.get(viewType);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegatesManager$DefaultViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultViewHolder extends RecyclerView.ViewHolder {
        public DefaultViewHolder(View view) {
            super(view);
            Intrinsics.checkNotNullParameter(view, "view");
        }
    }
}
