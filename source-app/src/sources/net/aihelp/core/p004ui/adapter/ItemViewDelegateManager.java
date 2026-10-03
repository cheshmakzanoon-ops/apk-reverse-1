package net.aihelp.core.p004ui.adapter;

import android.util.Log;
import androidx.collection.SparseArrayCompat;
import java.util.List;

public class ItemViewDelegateManager<T> {
    private SparseArrayCompat<ItemViewDelegate<T>> delegates = new SparseArrayCompat<>();

    int getItemViewDelegateCount() {
        return this.delegates.size();
    }

    void addDelegate(ItemViewDelegate<T> itemViewDelegate) {
        int size = this.delegates.size();
        if (itemViewDelegate != null) {
            this.delegates.put(size, itemViewDelegate);
        }
    }

    void addDelegate(int i, ItemViewDelegate<T> itemViewDelegate) {
        if (this.delegates.get(i) != null) {
            Log.e("AIHelp", "An ItemViewDelegate is already registered for the viewType = " + i + ". Already registered ItemViewDelegate is " + this.delegates.get(i));
            return;
        }
        this.delegates.put(i, itemViewDelegate);
    }

    public ItemViewDelegateManager<T> removeDelegate(ItemViewDelegate<T> itemViewDelegate) {
        int iIndexOfValue;
        if (itemViewDelegate != null && (iIndexOfValue = this.delegates.indexOfValue(itemViewDelegate)) >= 0) {
            this.delegates.removeAt(iIndexOfValue);
        }
        return this;
    }

    void removeDelegate(int i) {
        int iIndexOfKey = this.delegates.indexOfKey(i);
        if (iIndexOfKey >= 0) {
            this.delegates.removeAt(iIndexOfKey);
        }
    }

    int getItemViewType(T t, int i) {
        for (int size = this.delegates.size() - 1; size >= 0; size--) {
            if (((ItemViewDelegate) this.delegates.valueAt(size)).isForViewType(t, i)) {
                return this.delegates.keyAt(size);
            }
        }
        return -1;
    }

    public void convert(ViewHolder viewHolder, T t, int i) {
        int size = this.delegates.size();
        for (int i2 = 0; i2 < size; i2++) {
            ItemViewDelegate itemViewDelegate = (ItemViewDelegate) this.delegates.valueAt(i2);
            if (itemViewDelegate.isForViewType(t, i)) {
                itemViewDelegate.convert(viewHolder, t, i);
                return;
            }
        }
    }

    public void notifyDataSetChanged(List<T> list) {
        int size = this.delegates.size();
        for (int i = 0; i < size; i++) {
            ((ItemViewDelegate) this.delegates.valueAt(i)).onDataSourceUpdated(list);
        }
    }

    ItemViewDelegate getItemViewDelegate(int i) {
        return (ItemViewDelegate) this.delegates.get(i);
    }

    public int getItemViewLayoutId(int i) {
        return getItemViewDelegate(i).getItemViewLayoutId();
    }

    public int getItemViewType(ItemViewDelegate itemViewDelegate) {
        return this.delegates.indexOfValue(itemViewDelegate);
    }
}
