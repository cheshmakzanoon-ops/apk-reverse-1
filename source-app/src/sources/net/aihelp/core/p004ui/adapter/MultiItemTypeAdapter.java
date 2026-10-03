package net.aihelp.core.p004ui.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class MultiItemTypeAdapter<T> extends RecyclerView.Adapter<ViewHolder> {
    protected Context mContext;
    protected List<T> mDatas = new ArrayList();
    protected ItemViewDelegateManager<T> mItemViewDelegateManager = new ItemViewDelegateManager<>();
    protected OnItemClickListener mOnItemClickListener;

    public interface OnItemClickListener {
        void onItemClick(View view, RecyclerView.ViewHolder viewHolder, int i);

        boolean onItemLongClick(View view, RecyclerView.ViewHolder viewHolder, int i);
    }

    protected boolean isEnabled(int i) {
        return true;
    }

    public void onViewHolderCreated(ViewHolder viewHolder, View view) {
    }

    public MultiItemTypeAdapter(Context context) {
        this.mContext = context;
    }

    public int getItemViewType(int i) {
        return !useItemViewDelegateManager() ? super.getItemViewType(i) : this.mItemViewDelegateManager.getItemViewType(this.mDatas.get(i), i);
    }

    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        ViewHolder viewHolderCreateViewHolder = ViewHolder.createViewHolder(this.mContext, viewGroup, this.mItemViewDelegateManager.getItemViewDelegate(i).getItemViewLayoutId());
        onViewHolderCreated(viewHolderCreateViewHolder, viewHolderCreateViewHolder.getConvertView());
        setListener(viewGroup, viewHolderCreateViewHolder, i);
        return viewHolderCreateViewHolder;
    }

    public void convert(ViewHolder viewHolder, T t) {
        this.mItemViewDelegateManager.convert(viewHolder, t, viewHolder.getAdapterPosition());
    }

    protected void setListener(ViewGroup viewGroup, final ViewHolder viewHolder, int i) {
        if (isEnabled(i)) {
            viewHolder.getConvertView().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (MultiItemTypeAdapter.this.mOnItemClickListener != null) {
                        MultiItemTypeAdapter.this.mOnItemClickListener.onItemClick(view, viewHolder, viewHolder.getAdapterPosition());
                    }
                }
            });
            viewHolder.getConvertView().setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View view) {
                    if (MultiItemTypeAdapter.this.mOnItemClickListener == null) {
                        return false;
                    }
                    return MultiItemTypeAdapter.this.mOnItemClickListener.onItemLongClick(view, viewHolder, viewHolder.getAdapterPosition());
                }
            });
        }
    }

    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        convert(viewHolder, this.mDatas.get(i));
    }

    public int getItemCount() {
        return this.mDatas.size();
    }

    protected void addItemViewDelegate(ItemViewDelegate<T> itemViewDelegate) {
        this.mItemViewDelegateManager.addDelegate(itemViewDelegate);
    }

    protected MultiItemTypeAdapter addItemViewDelegate(int i, ItemViewDelegate<T> itemViewDelegate) {
        this.mItemViewDelegateManager.addDelegate(i, itemViewDelegate);
        return this;
    }

    protected MultiItemTypeAdapter removeItemViewDelegate(int i) {
        this.mItemViewDelegateManager.removeDelegate(i);
        return this;
    }

    private boolean useItemViewDelegateManager() {
        return this.mItemViewDelegateManager.getItemViewDelegateCount() > 0;
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.mOnItemClickListener = onItemClickListener;
    }

    public void update(List<T> list, Boolean bool) {
        if (bool.booleanValue()) {
            clear();
        }
        update((List) list);
    }

    public void update(T t) {
        if (t != null) {
            this.mDatas.add(t);
        }
        notifyDataSetChanged();
    }

    public void update(List<T> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        this.mDatas.addAll(list);
        notifyDataSetChanged();
    }

    public void clear() {
        this.mDatas.clear();
        notifyDataSetChanged();
    }

    public void remove(int i) {
        List<T> list = this.mDatas;
        if (list == null || list.size() <= 0) {
            return;
        }
        this.mDatas.remove(i);
        notifyDataSetChanged();
    }

    public List<T> getDataList() {
        return this.mDatas;
    }

    public void setDataList(Collection<T> collection) {
        this.mDatas.clear();
        this.mDatas.addAll(collection);
        notifyDataSetChanged();
        this.mItemViewDelegateManager.notifyDataSetChanged(this.mDatas);
    }
}
