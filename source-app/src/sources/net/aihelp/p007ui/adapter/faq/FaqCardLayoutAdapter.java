package net.aihelp.p007ui.adapter.faq;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.p007ui.faq.BaseFaqFragment;
import net.aihelp.p007ui.faq.IFaqEventListener;
import net.aihelp.p007ui.widget.AIHelpServiceEntrance;
import net.aihelp.p007ui.wrapper.FaqSelectedListenerWrapper;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FaqCardLayoutAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private static final int VIEW_TYPE_CS_ENTRANCE = 1;
    private Bundle bundle;
    private final Context context;
    private IFaqEventListener faqEventListener;
    private BaseFaqFragment faqFragment;
    private final boolean isFooterVisible;
    private boolean isGridLayout;
    private final List<FaqListEntity> mDataSources;
    private FaqSelectedListenerWrapper mListener;

    public void setup(Bundle bundle, IFaqEventListener iFaqEventListener, BaseFaqFragment baseFaqFragment) {
        this.bundle = bundle;
        this.faqEventListener = iFaqEventListener;
        this.faqFragment = baseFaqFragment;
    }

    public FaqCardLayoutAdapter(Context context) {
        this(context, false);
    }

    public FaqCardLayoutAdapter(Context context, boolean z) {
        this.mDataSources = new ArrayList();
        this.context = context;
        this.isFooterVisible = z;
    }

    public void update(List<FaqListEntity> list) {
        this.mDataSources.clear();
        if (!ListUtil.isListEmpty(list)) {
            this.mDataSources.addAll(list);
        }
        notifyDataSetChanged();
    }

    public void setOnFaqSelectedListener(FaqSelectedListenerWrapper faqSelectedListenerWrapper) {
        this.mListener = faqSelectedListenerWrapper;
    }

    public int getItemViewType(int i) {
        if (this.isFooterVisible && i == getItemCount() - 1) {
            return 1;
        }
        return super.getItemViewType(i);
    }

    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        if (i == 1) {
            return new CSEntranceViewHolder(LayoutInflater.from(this.context).inflate(ResResolver.getLayoutId("aihelp_ada_faq_cs_entrance"), viewGroup, false));
        }
        View viewInflate = LayoutInflater.from(this.context).inflate(ResResolver.getLayoutId(this.isGridLayout ? "aihelp_ada_faq_grid_list" : "aihelp_ada_faq_linear_list"), viewGroup, false);
        viewInflate.setBackground(Styles.getClickableDrawableForList());
        return new ItemViewHolder(viewInflate);
    }

    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int i) {
        if (viewHolder instanceof ItemViewHolder) {
            final FaqListEntity faqListEntity = this.mDataSources.get(i);
            int displayType = faqListEntity.getDisplayType();
            if (displayType == 1) {
                convertFaqHomeList(viewHolder, faqListEntity);
            } else if (displayType == 2 || displayType == 3) {
                convertFaqSectionOrQuestionList(viewHolder, faqListEntity);
            } else if (displayType == 4) {
                convertSearchMatchingList(viewHolder, faqListEntity);
            } else if (displayType == 6) {
                convertFaqHomeList(viewHolder, faqListEntity);
            }
            viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (FaqCardLayoutAdapter.this.mListener != null) {
                        switch (faqListEntity.getDisplayType()) {
                            case 1:
                            case 2:
                                FaqCardLayoutAdapter.this.mListener.onIntentToSubSectionOrQuestionList(faqListEntity);
                                break;
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                                FaqCardLayoutAdapter.this.mListener.onIntentToQuestionContent(faqListEntity);
                                break;
                        }
                    }
                }
            });
        }
        if (viewHolder instanceof CSEntranceViewHolder) {
            ((CSEntranceViewHolder) viewHolder).csService.setup(this.bundle, this.faqEventListener, this.faqFragment);
        }
    }

    private void convertFaqHomeList(RecyclerView.ViewHolder viewHolder, FaqListEntity faqListEntity) {
        ItemViewHolder itemViewHolder = (ItemViewHolder) viewHolder;
        boolean z = faqListEntity.getDisplayType() == 6 && CustomConfig.HelpCenter.isFaqHotTopicItemIconVisible;
        boolean z2 = faqListEntity.getDisplayType() == 1 && CustomConfig.HelpCenter.isFaqSectionItemIconVisible;
        if (z || z2) {
            itemViewHolder.ivTitle.setVisibility(0);
            if (!TextUtils.isEmpty(faqListEntity.getIconUrl())) {
                Styles.loadIcon(itemViewHolder.ivTitle, faqListEntity.getIconUrl());
            }
        }
        itemViewHolder.tvTitle.setText(faqListEntity.getTitle());
        itemViewHolder.tvTitle.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
        itemViewHolder.tvTitle.setTextSize(15.0f);
    }

    private void convertFaqSectionOrQuestionList(RecyclerView.ViewHolder viewHolder, FaqListEntity faqListEntity) {
        ItemViewHolder itemViewHolder = (ItemViewHolder) viewHolder;
        itemViewHolder.ivTitle.setVisibility(8);
        itemViewHolder.tvTitle.setText(faqListEntity.getTitle());
        itemViewHolder.tvTitle.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
        itemViewHolder.tvTitle.setTextSize(15.0f);
    }

    private void convertSearchMatchingList(RecyclerView.ViewHolder viewHolder, FaqListEntity faqListEntity) {
        try {
            ItemViewHolder itemViewHolder = (ItemViewHolder) viewHolder;
            itemViewHolder.ivTitle.setVisibility(8);
            itemViewHolder.tvTitle.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
            itemViewHolder.tvTitle.setTextSize(15.0f);
            String query = faqListEntity.getQuery();
            String title = faqListEntity.getTitle();
            if (!TextUtils.isEmpty(query)) {
                String lowerCase = query.toLowerCase();
                String lowerCase2 = title.toLowerCase();
                int color = Color.parseColor(CustomConfig.CommonSetting.highlightedColor);
                SpannableString spannableString = new SpannableString(title);
                for (int iIndexOf = TextUtils.indexOf(lowerCase2, lowerCase, 0); iIndexOf >= 0; iIndexOf = TextUtils.indexOf(lowerCase2, lowerCase, iIndexOf + lowerCase.length())) {
                    spannableString.setSpan(new ForegroundColorSpan(color), iIndexOf, Math.min(lowerCase.length() + iIndexOf, lowerCase2.length()), 33);
                }
                itemViewHolder.tvTitle.setText(spannableString);
                return;
            }
            itemViewHolder.tvTitle.setText(title);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onAttachedToRecyclerView(RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
        this.isGridLayout = recyclerView.getLayoutManager() instanceof GridLayoutManager;
    }

    public int getItemCount() {
        if (this.isFooterVisible) {
            return this.mDataSources.size() + 1;
        }
        return this.mDataSources.size();
    }

    public static class ItemViewHolder extends RecyclerView.ViewHolder {
        ImageView ivTitle;
        TextView tvTitle;

        public ItemViewHolder(View view) {
            super(view);
            this.ivTitle = (ImageView) view.findViewById(ResResolver.getViewId("aihelp_iv_title"));
            this.tvTitle = (TextView) view.findViewById(ResResolver.getViewId("aihelp_tv_title"));
        }
    }

    public static class CSEntranceViewHolder extends RecyclerView.ViewHolder {
        AIHelpServiceEntrance csService;

        public CSEntranceViewHolder(View view) {
            super(view);
            this.csService = (AIHelpServiceEntrance) view.findViewById(ResResolver.getViewId("aihelp_cs_entrance"));
        }
    }
}
