package net.aihelp.core.p004ui.adapter;

import java.util.List;

public interface ItemViewDelegate<T> {
    void convert(ViewHolder viewHolder, T t, int i);

    int getItemViewLayoutId();

    boolean isForViewType(T t, int i);

    void onDataSourceUpdated(List<T> list);
}
