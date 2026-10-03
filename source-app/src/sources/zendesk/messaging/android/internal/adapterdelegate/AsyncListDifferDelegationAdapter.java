package zendesk.messaging.android.internal.adapterdelegate;

import android.view.ViewGroup;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0010\u0018\u0000*\u0004\b\u0000\u0010\u00012\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u00020\u00030\u0002B)\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005\u0012\u0014\b\u0002\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\b0\u0007¢\u0006\u0002\u0010\tJ\u0010\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\rH\u0016J\u0018\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\rH\u0016J&\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\r2\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00130\bH\u0016J\u0018\u0010\u0014\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\rH\u0016R \u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\b0\u0007X\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/adapterdelegate/AsyncListDifferDelegationAdapter;", "T", "Landroidx/recyclerview/widget/ListAdapter;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "diffCallback", "Landroidx/recyclerview/widget/DiffUtil$ItemCallback;", "delegatesManager", "Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegatesManager;", "", "(Landroidx/recyclerview/widget/DiffUtil$ItemCallback;Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegatesManager;)V", "getDelegatesManager", "()Lzendesk/messaging/android/internal/adapterdelegate/AdapterDelegatesManager;", "getItemViewType", "", "position", "onBindViewHolder", "", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "viewType", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public class AsyncListDifferDelegationAdapter<T> extends ListAdapter<T, RecyclerView.ViewHolder> {
    private final AdapterDelegatesManager<List<T>> delegatesManager;

    public AsyncListDifferDelegationAdapter(DiffUtil.ItemCallback itemCallback, AdapterDelegatesManager adapterDelegatesManager, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(itemCallback, (i & 2) != 0 ? new AdapterDelegatesManager(new AdapterDelegate[0]) : adapterDelegatesManager);
    }

    protected final AdapterDelegatesManager<List<T>> getDelegatesManager() {
        return this.delegatesManager;
    }

    public AsyncListDifferDelegationAdapter(DiffUtil.ItemCallback<T> diffCallback, AdapterDelegatesManager<List<T>> delegatesManager) {
        super(diffCallback);
        Intrinsics.checkNotNullParameter(diffCallback, "diffCallback");
        Intrinsics.checkNotNullParameter(delegatesManager, "delegatesManager");
        this.delegatesManager = delegatesManager;
    }

    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        return this.delegatesManager.onCreateViewHolder(parent, viewType);
    }

    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        Intrinsics.checkNotNullParameter(holder, "holder");
        AdapterDelegatesManager<List<T>> adapterDelegatesManager = this.delegatesManager;
        List<T> currentList = getCurrentList();
        Intrinsics.checkNotNullExpressionValue(currentList, "getCurrentList(...)");
        adapterDelegatesManager.onBindViewHolder(currentList, position, holder, null);
    }

    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        AdapterDelegatesManager<List<T>> adapterDelegatesManager = this.delegatesManager;
        List<T> currentList = getCurrentList();
        Intrinsics.checkNotNullExpressionValue(currentList, "getCurrentList(...)");
        adapterDelegatesManager.onBindViewHolder(currentList, position, holder, payloads);
    }

    public int getItemViewType(int position) {
        AdapterDelegatesManager<List<T>> adapterDelegatesManager = this.delegatesManager;
        List<T> currentList = getCurrentList();
        Intrinsics.checkNotNullExpressionValue(currentList, "getCurrentList(...)");
        return adapterDelegatesManager.getItemViewType(currentList, position);
    }
}
