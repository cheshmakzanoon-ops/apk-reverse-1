package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.FrameLayout;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.data.localize.config.ProcessEntranceHelper;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.logic.FaqPresenter;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.data.model.faq.FaqContentEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.helper.WebViewInjector;
import net.aihelp.p007ui.webkit.AIHelpWebChromeClient;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import net.aihelp.p007ui.webkit.AIHelpWebView;
import net.aihelp.p007ui.webkit.AIHelpWebViewClient;
import net.aihelp.p007ui.widget.AIHelpEvaluateView;
import net.aihelp.p007ui.widget.AIHelpServiceEntrance;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentView;

public class FaqContentFragment extends BaseFaqFragment<FaqPresenter> {
    private String currentSectionId;
    private AIHelpEvaluateView mEvaluateView;
    private AIHelpWebProgress mProgressBar;
    private AIHelpServiceEntrance mServiceEntrance;
    private AIHelpWebView mWebView;
    private boolean showEntranceAfterEvaluated;

    public static FaqContentFragment newInstance(Bundle bundle) {
        FaqContentFragment faqContentFragment = new FaqContentFragment();
        faqContentFragment.setArguments(bundle);
        return faqContentFragment;
    }

    @Override
    protected void getBundleBeforeDataPrepared(Bundle bundle) {
        super.getBundleBeforeDataPrepared(bundle);
        this.currentSectionId = bundle.getString(IntentValues.SECTION_ID, "");
    }

    @Override
    protected void initEventAndData(View view) {
        ((FrameLayout) get("aihelp_ll_root")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha));
        this.mProgressBar = (AIHelpWebProgress) get("aihelp_progress_bar");
        this.mEvaluateView = (AIHelpEvaluateView) get("aihelp_evaluate_faq");
        this.mServiceEntrance = (AIHelpServiceEntrance) get("aihelp_cs_entrance");
        AIHelpWebView aIHelpWebView = (AIHelpWebView) get("aihelp_web_view");
        this.mWebView = aIHelpWebView;
        aIHelpWebView.setBackgroundColor(0);
        AIHelpWebViewClient aIHelpWebViewClient = new AIHelpWebViewClient(getContext(), this.mProgressBar, true);
        this.mWebView.setWebViewClient(aIHelpWebViewClient);
        WebViewInjector.getInstance().setHostFragment(this).inject(this.mWebView, aIHelpWebViewClient);
        this.mWebView.setWebChromeClient(new AIHelpWebChromeClient(this, this.mProgressBar));
        if (this.intentMode == 4) {
            ((FaqPresenter) this.mPresenter).prepareFAQNotification();
        }
    }

    @Override
    protected void getBundleAfterDataPrepared(Bundle bundle) {
        String string = bundle.getString(IntentValues.SECTION_ID);
        String string2 = bundle.getString(IntentValues.FAQ_MAIN_ID);
        String string3 = bundle.getString(IntentValues.SEARCH_MATCH);
        ((FaqPresenter) this.mPresenter).goFetchQuestionContent(string, string2, string3);
        if (TextUtils.isEmpty(string) && TextUtils.isEmpty(string3)) {
            this.titleText = AppInfoUtil.getAppName(getContext());
        }
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_faq_content");
    }

    @Override
    protected int getLoadingTargetViewId() {
        return ResResolver.getViewId("aihelp_faq_content");
    }

    @Override
    public void refreshQuestionContent(final FaqContentEntity faqContentEntity) {
        if (faqContentEntity != null) {
            this.mEvaluateView.setFaqData(faqContentEntity.getFaqTitle(), faqContentEntity.getFaqMainId(), faqContentEntity.getFaqContentId());
            if (CustomConfig.CommonSetting.isEvaluationForAnswerPageEnable && ((FaqPresenter) this.mPresenter).shouldShowQuestionFooter(faqContentEntity.getFaqMainId(), faqContentEntity.getLastUpdateTime())) {
                this.mEvaluateView.setEvaluateState(1);
            } else {
                this.mEvaluateView.setEvaluateState(2);
            }
            this.mEvaluateView.setOnAIHelpEvaluateViewCallback(new AIHelpEvaluateView.OnAIHelpEvaluateViewCallback() {
                @Override
                public void onEvaluated(boolean z) {
                    if (!z && FaqContentFragment.this.getArguments() != null && FaqContentFragment.this.getArguments().getString(IntentValues.FAQ_SUPPORT_MOMENT, "").contains("4")) {
                        FaqContentFragment.this.mServiceEntrance.setVisibility(0);
                        FaqContentFragment.this.showEntranceAfterEvaluated = true;
                    }
                    FaqHelper.INSTANCE.afterFaqEvaluated(faqContentEntity.getFaqMainId(), faqContentEntity.getLastUpdateTime());
                }
            });
            String adjustedUrl = DomainSupportHelper.getAdjustedUrl(faqContentEntity.getFaqContent());
            int[] colorRGB = Styles.getColorRGB(CustomConfig.CommonSetting.textColor);
            this.mWebView.loadDataWithBaseURL(null, adjustedUrl.replace("<body>", String.format("<body style=\"background-color: transparent; %s\">", String.format("color: rgba(%s, %s, %s, %s)", Integer.valueOf(colorRGB[0]), Integer.valueOf(colorRGB[1]), Integer.valueOf(colorRGB[2]), 1))).replace("<div style='font-size:14px;color:#CCCCCC;'>", String.format("<div style='font-size:14px; %s'>", String.format("color: rgba(%s, %s, %s, %s)", Integer.valueOf(colorRGB[0]), Integer.valueOf(colorRGB[1]), Integer.valueOf(colorRGB[2]), Double.valueOf(0.3d)))).replaceAll("(?i)(\\.(mp4|mov))", "$1#t=0.01"), ArticleContentView.TYPE_TEXT_HTML, "utf-8", null);
            handleTrackLogic(faqContentEntity);
            return;
        }
        showEmpty(new int[0]);
    }

    private void handleTrackLogic(FaqContentEntity faqContentEntity) {
        String str = this.currentSectionId;
        str.hashCode();
        if (str.equals(FaqHelper.FAQ_HOT_TOPICS)) {
            AIHelpEventTracker.getInstance().clickHotTopic(faqContentEntity.getFaqMainId(), faqContentEntity.getFaqContentId(), faqContentEntity.getFaqTitle());
        } else if (str.equals(FaqHelper.FAQ_NOTIFICATION)) {
            AIHelpEventTracker.getInstance().clickNotification(faqContentEntity.getFaqMainId(), faqContentEntity.getFaqContentId(), faqContentEntity.getFaqTitle());
        } else {
            ProcessEntity currentProcess = ProcessEntranceHelper.INSTANCE.getCurrentProcess();
            if (currentProcess != null && currentProcess.getIntent() == 2 && currentProcess.getSectionId().equals(this.currentSectionId)) {
                AIHelpEventTracker.getInstance().clickFaq(faqContentEntity.getFaqMainId(), faqContentEntity.getFaqContentId(), faqContentEntity.getFaqTitle());
            }
        }
        AIHelpEventTracker.getInstance().checkedFAQ(faqContentEntity.getFaqMainId(), faqContentEntity.getFaqContentId(), faqContentEntity.getFaqTitle());
    }

    @Override
    public void onResume() {
        super.onResume();
        if (this.showEntranceAfterEvaluated) {
            this.mServiceEntrance.setVisibility(0);
        }
    }

    public void onStop() {
        super.onStop();
        this.mProgressBar.hide();
    }

    public boolean onBackPressed() {
        if (!this.mWebView.canGoBack()) {
            return true;
        }
        this.mWebView.goBack();
        return false;
    }
}
