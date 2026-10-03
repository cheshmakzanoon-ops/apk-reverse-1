package net.aihelp.core.p004ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import java.util.Collection;
import java.util.List;

public abstract class CommonAdapter<T> extends MultiItemTypeAdapter<T> {
    protected Context mContext;
    protected LayoutInflater mInflater;
    protected int mLayoutId;

    protected abstract void convert(ViewHolder viewHolder, T t, int i);

    protected abstract int itemLayoutId();

    public CommonAdapter(Context context) {
        super(context);
        this.mContext = context;
        this.mInflater = LayoutInflater.from(context);
        addItemViewDelegate(new ItemViewDelegate<T>() {
            @Override
            public boolean isForViewType(T t, int i) {
                return true;
            }

            @Override
            public void onDataSourceUpdated(List<T> list) {
            }

            @Override
            public int getItemViewLayoutId() {
                return CommonAdapter.this.itemLayoutId();
            }

            @Override
            public void convert(ViewHolder viewHolder, T t, int i) {
                CommonAdapter.this.convert(viewHolder, t, i);
            }
        });
    }

    @Override
    public void remove(int i) {
        if (this.mDatas == null || this.mDatas.size() <= 0) {
            return;
        }
        this.mDatas.remove(i);
        int i2 = i - 1;
        notifyItemRemoved(i2);
        if (i != this.mDatas.size()) {
            notifyItemRangeChanged(i2, getItemCount() - i);
        }
    }

    @Override
    public List<T> getDataList() {
        return this.mDatas;
    }

    @Override
    public void setDataList(Collection<T> collection) {
        this.mDatas.clear();
        this.mDatas.addAll(collection);
        notifyDataSetChanged();
    }
}
