package net.aihelp.p007ui.p009cs.util.viewer;

import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.dialog.AlertDialog;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.p007ui.helper.WebViewInjector;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import net.aihelp.p007ui.webkit.AIHelpWebView;
import net.aihelp.p007ui.webkit.AIHelpWebViewClient;
import net.aihelp.p007ui.widget.AIHelpEvaluateButtonView;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import net.aihelp.utils.TLog;
import org.json.JSONObject;

public enum BotFaqViewer implements View.OnClickListener {
    INSTANCE;

    private AlertDialog faqAlertDialog = null;
    private AIHelpWebView mWebView = null;

    public interface OnFaqEvaluateListener {
        void onEvaluated(BotMessage botMessage, boolean z);
    }

    BotFaqViewer() {
    }

    public void show(Context context, final BotMessage botMessage, final Faq.FaqData faqData, final OnFaqEvaluateListener onFaqEvaluateListener) {
        String adjustedUrl = DomainSupportHelper.getAdjustedUrl(faqData.getFaqContent());
        if (!adjustedUrl.contains("isCustom=1")) {
            adjustedUrl = adjustedUrl + "&isCustom=1";
        }
        AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_elva_faq")).setGravity(80).fromBottom(true).setCancelableOntheOutside(true).setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                if (EventBus.getDefault().isRegistered(this)) {
                    EventBus.getDefault().unregister(BotFaqViewer.this);
                }
            }
        }).setWidthAndHeight(-1, 500).setHeightByDevice().create();
        this.faqAlertDialog = alertDialogCreate;
        ((RelativeLayout) alertDialogCreate.findViewById(ResResolver.getViewId("aihelp_rl_root"))).setBackgroundColor(Styles.getColor(CustomConfig.CommonSetting.upperBackgroundColor));
        final ImageView imageView = (ImageView) this.faqAlertDialog.findViewById(ResResolver.getViewId("aihelp_iv_back"));
        imageView.setOnClickListener(this);
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_back");
        ImageView imageView2 = (ImageView) this.faqAlertDialog.findViewById(ResResolver.getViewId("aihelp_iv_close"));
        imageView2.setOnClickListener(this);
        Styles.reRenderImageView(imageView2, "aihelp_svg_ic_close_dialog");
        AIHelpWebView aIHelpWebView = (AIHelpWebView) this.faqAlertDialog.findViewById(ResResolver.getViewId("aihelp_web_view"));
        this.mWebView = aIHelpWebView;
        aIHelpWebView.setBackgroundColor(0);
        final AIHelpWebProgress aIHelpWebProgress = (AIHelpWebProgress) this.faqAlertDialog.findViewById(ResResolver.getViewId("aihelp_progress_bar"));
        AIHelpWebViewClient aIHelpWebViewClient = new AIHelpWebViewClient(context, aIHelpWebProgress);
        aIHelpWebViewClient.setUrlLoadingListener(new AIHelpWebViewClient.ShouldOverrideUrlLoadingListener() {
            @Override
            public void handleUrlClick(boolean z) {
                imageView.setVisibility(0);
            }
        });
        this.mWebView.setWebViewClient(aIHelpWebViewClient);
        WebViewInjector.getInstance().setContext(context).inject(this.mWebView, aIHelpWebViewClient);
        this.mWebView.setWebChromeClient(new WebChromeClient() {
            boolean isFinishedAlready;

            @Override
            public void onProgressChanged(WebView webView, int i) {
                super.onProgressChanged(webView, i);
                aIHelpWebProgress.setProgress(i);
                if (i != 100 || this.isFinishedAlready) {
                    return;
                }
                webView.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (faqData.getFaqSource() == 2) {
                            BotFaqViewer.this.prepareEvaluateButtonView(botMessage, faqData, onFaqEvaluateListener);
                        }
                    }
                }, 500L);
                this.isFinishedAlready = true;
            }
        });
        if (!EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().register(this);
        }
        this.mWebView.loadUrl(adjustedUrl);
        this.faqAlertDialog.show();
        TLog.m138d("BotFaq: " + adjustedUrl);
    }

    public void prepareEvaluateButtonView(final BotMessage botMessage, final Faq.FaqData faqData, final OnFaqEvaluateListener onFaqEvaluateListener) {
        AIHelpEvaluateButtonView aIHelpEvaluateButtonView = (AIHelpEvaluateButtonView) this.faqAlertDialog.findViewById(ResResolver.getViewId("aihelp_evaluate_view"));
        aIHelpEvaluateButtonView.refreshViewState(botMessage.getUserFeedback());
        aIHelpEvaluateButtonView.setOnAIHelpEvaluateViewCallback(new AIHelpEvaluateButtonView.OnAIHelpEvaluateViewCallback() {
            @Override
            public void onEvaluated(boolean z) {
                botMessage.setUserFeedback(z ? 1 : 2);
                OnFaqEvaluateListener onFaqEvaluateListener2 = onFaqEvaluateListener;
                if (onFaqEvaluateListener2 != null) {
                    onFaqEvaluateListener2.onEvaluated(botMessage, z);
                }
            }

            @Override
            public JSONObject requestDataForFeedback() {
                JSONObject jSONObject = new JSONObject();
                try {
                    jSONObject.put("mainId", faqData.getMainId());
                    jSONObject.put("contentId", faqData.getContentId());
                    jSONObject.put("isClickDetail", faqData.isFaqViewed());
                    jSONObject.put("pointMessageId", String.valueOf(botMessage.getTimestamp()));
                } catch (Exception unused) {
                }
                return jSONObject;
            }
        });
    }

    @Override
    public void onClick(View view) {
        AIHelpWebView aIHelpWebView;
        AlertDialog alertDialog;
        if (view.getId() == ResResolver.getViewId("aihelp_iv_close") && (alertDialog = this.faqAlertDialog) != null) {
            alertDialog.dismiss();
        }
        if (view.getId() == ResResolver.getViewId("aihelp_iv_back") && (aIHelpWebView = this.mWebView) != null && aIHelpWebView.canGoBack()) {
            this.mWebView.goBack();
            if (this.mWebView.canGoBack()) {
                return;
            }
            view.setVisibility(8);
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(OrientationChangeEvent orientationChangeEvent) {
        AlertDialog alertDialog = this.faqAlertDialog;
        if (alertDialog == null || !alertDialog.isShowing()) {
            return;
        }
        this.faqAlertDialog.dismiss();
    }
}
