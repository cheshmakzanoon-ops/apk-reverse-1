package net.aihelp.p007ui.err;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import net.aihelp.core.p004ui.BaseFragment;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.UpdateTitleEvent;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FaqErrorFragment extends BaseFragment {
    @Override
    protected void getBundleAfterDataPrepared(Bundle bundle) {
    }

    public static FaqErrorFragment newInstance(Bundle bundle) {
        FaqErrorFragment faqErrorFragment = new FaqErrorFragment();
        faqErrorFragment.setArguments(bundle);
        return faqErrorFragment;
    }

    @Override
    protected void initEventAndData(View view) {
        EventBus.getDefault().post(new UpdateTitleEvent(0, "", "Not Found"));
        ImageView imageView = (ImageView) view.findViewById(ResResolver.getViewId("aihelp_iv_empty"));
        TextView textView = (TextView) view.findViewById(ResResolver.getViewId("aihelp_tv_empty"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_empty");
        Styles.reRenderTextView(textView, "entrance id not found");
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_layout_list_empty");
    }
}
