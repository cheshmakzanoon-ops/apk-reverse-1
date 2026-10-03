package net.aihelp.core.p004ui.loading.helper;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;
import net.aihelp.utils.ResResolver;

public class VaryViewHelperController {
    private final VaryViewHelper helper;
    private Context mContext;

    public VaryViewHelperController(View view) {
        this(new VaryViewHelper(view));
        this.mContext = view.getContext();
    }

    private VaryViewHelperController(VaryViewHelper varyViewHelper) {
        this.helper = varyViewHelper;
    }

    public void showLoading(String str) {
        View viewInflate = this.helper.inflate(ResResolver.getLayoutId("aihelp_layout_progress_loading"));
        TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_loading_msg"));
        if (TextUtils.isEmpty(str)) {
            str = ResResolver.getString("aihelp_faq_fetching_faqs");
        }
        textView.setText(str);
        this.helper.showLayout(viewInflate);
    }

    public void showEmpty(int... iArr) {
        if (iArr == null || iArr.length <= 0) {
            return;
        }
        this.helper.showLayout(this.helper.inflate(iArr[0]));
    }

    public void showEmpty(View view) {
        if (view != null) {
            this.helper.showLayout(view);
        }
    }

    public void showNetworkError() {
        View viewInflate = this.helper.inflate(ResResolver.getLayoutId("aihelp_layout_network_err"));
        ((TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_title"))).setText(ResResolver.getString("aihelp_network_error_msg"));
        ((TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_sub_title"))).setText(ResResolver.getString("aihelp_network_no_connect"));
        this.helper.showLayout(viewInflate);
    }

    public void restore() {
        this.helper.restoreView();
    }
}
