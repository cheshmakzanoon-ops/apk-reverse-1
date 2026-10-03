package net.aihelp.p007ui.adapter;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import net.aihelp.core.p004ui.adapter.CommonAdapter;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.config.IntentEntity;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class SmartIntentAdapter extends CommonAdapter<IntentEntity> {
    private final OnIntentSelectedListener mListener;

    public interface OnIntentSelectedListener {
        void onIntentSelected(IntentEntity intentEntity, boolean z);
    }

    public SmartIntentAdapter(Context context, OnIntentSelectedListener onIntentSelectedListener) {
        super(context);
        this.mListener = onIntentSelectedListener;
    }

    @Override
    protected int itemLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_smart_intent");
    }

    @Override
    public void convert(ViewHolder viewHolder, final IntentEntity intentEntity, int i) {
        Styles.reRenderTextView((TextView) viewHolder.getView(ResResolver.getViewId("aihelp_tv_title")), intentEntity.getIntentName());
        final boolean z = !ListUtil.isListEmpty(intentEntity.getIntentList());
        viewHolder.setVisible(ResResolver.getViewId("aihelp_iv_next"), z);
        viewHolder.getConvertView().setBackground(Styles.getClickableDrawableForList());
        viewHolder.getConvertView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (SmartIntentAdapter.this.mListener == null || !FastClickValidator.validate(0.5f)) {
                    return;
                }
                SmartIntentAdapter.this.mListener.onIntentSelected(intentEntity, z);
            }
        });
    }
}
