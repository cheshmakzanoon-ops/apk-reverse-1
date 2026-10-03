package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.data.event.NetErrorEvent;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.logic.FaqPresenter;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.faq.FaqCardLayoutAdapter;
import net.aihelp.p007ui.widget.AIHelpFaqCardLayout;
import net.aihelp.p007ui.widget.AIHelpServiceEntrance;
import net.aihelp.p007ui.wrapper.FaqSelectedListenerWrapper;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FaqHomeFragment extends BaseFaqFragment<FaqPresenter> {
    LinearLayout llNotification;
    private LinearLayout llRootLayout;
    AIHelpFaqCardLayout rvCommonQuestions;
    AIHelpFaqCardLayout rvHotTopics;
    private boolean isNotificationEmpty = true;
    private boolean isHotTopicsEmpty = true;
    private boolean isSectionsEmpty = true;

    @Override
    protected boolean isBindEventBus() {
        return true;
    }

    public static FaqHomeFragment newInstance(Bundle bundle) {
        FaqHomeFragment faqHomeFragment = new FaqHomeFragment();
        faqHomeFragment.setArguments(bundle);
        return faqHomeFragment;
    }

    @Override
    protected void initEventAndData(View view) {
        this.llRootLayout = (LinearLayout) get("aihelp_ll_root");
        prepareScreenOrientationAndDataSource();
        ((FaqPresenter) this.mPresenter).prepareFAQNotification();
    }

    private void prepareScreenOrientationAndDataSource() {
        this.llRootLayout.removeAllViews();
        if (Styles.isLandscape()) {
            View.inflate(getContext(), ResResolver.getLayoutId("aihelp_layout_faq_home_land"), this.llRootLayout);
        } else {
            View.inflate(getContext(), ResResolver.getLayoutId("aihelp_layout_faq_home_port"), this.llRootLayout);
        }
        this.llNotification = (LinearLayout) get("aihelp_ll_notification");
        this.rvHotTopics = (AIHelpFaqCardLayout) get("aihelp_rv_hot_topics");
        this.rvCommonQuestions = (AIHelpFaqCardLayout) get("aihelp_rv_common_questions");
        prepareFlipperView(FaqHelper.INSTANCE.getQuestionList(FaqHelper.FAQ_NOTIFICATION));
        prepareHotTopics(FaqHelper.INSTANCE.getQuestionList(FaqHelper.FAQ_HOT_TOPICS));
        if (getArguments() != null) {
            ((FaqPresenter) this.mPresenter).goFetchFAQDataSource(getArguments().getString(IntentValues.SECTION_ID));
        }
    }

    private void prepareFlipperView(List<FaqListEntity> list) {
        LinearLayout linearLayout;
        if (!CustomConfig.HelpCenter.isFaqNotificationVisible || ListUtil.isListEmpty(list) || (linearLayout = this.llNotification) == null) {
            return;
        }
        linearLayout.setVisibility(0);
        if (CustomConfig.HelpCenter.isFaqNotificationIconVisible) {
            ImageView imageView = (ImageView) get("aihelp_iv_notification");
            imageView.setVisibility(0);
            Styles.loadIcon(imageView, CustomConfig.HelpCenter.faqNotificationIcon);
        }
        ViewFlipper viewFlipper = (ViewFlipper) get("aihelp_vf_notification");
        for (int i = 0; i < list.size(); i++) {
            viewFlipper.addView(getNotificationView(list.get(i)));
        }
        viewFlipper.startFlipping();
        viewFlipper.setFlipInterval(CustomConfig.HelpCenter.faqNotificationInterval * 1000);
        viewFlipper.setInAnimation(AnimationUtils.loadAnimation(getContext(), ResResolver.getAnimId("aihelp_push_up_in")));
        viewFlipper.setOutAnimation(AnimationUtils.loadAnimation(getContext(), ResResolver.getAnimId("aihelp_push_up_out")));
        this.isNotificationEmpty = false;
    }

    private void prepareHotTopics(List<FaqListEntity> list) {
        AIHelpFaqCardLayout aIHelpFaqCardLayout;
        if (!CustomConfig.HelpCenter.isFaqHotTopicVisible || ListUtil.isListEmpty(list) || (aIHelpFaqCardLayout = this.rvHotTopics) == null) {
            return;
        }
        aIHelpFaqCardLayout.setVisibility(0);
        FaqCardLayoutAdapter faqCardLayoutAdapter = new FaqCardLayoutAdapter(getContext());
        faqCardLayoutAdapter.setup(getMergedBundle(), getFaqFlowListener(), this);
        faqCardLayoutAdapter.setOnFaqSelectedListener(new FaqSelectedListenerWrapper() {
            final Bundle bundle;

            {
                this.bundle = FaqHomeFragment.this.getMergedBundle();
            }

            @Override
            public void onIntentToQuestionContent(FaqListEntity faqListEntity) {
                this.bundle.putString(IntentValues.SECTION_ID, FaqHelper.FAQ_HOT_TOPICS);
                this.bundle.putString(IntentValues.FAQ_MAIN_ID, faqListEntity.getId());
                FaqHomeFragment.this.getFaqFlowListener().onIntentToQuestionContent(this.bundle, true);
            }
        });
        this.rvHotTopics.updateTitleIcon(CustomConfig.HelpCenter.isFaqHotTopicTitleVisible && CustomConfig.HelpCenter.isFaqHotTopicTitleIconVisible, CustomConfig.HelpCenter.faqHotTopicTitleIcon);
        this.rvHotTopics.updateTitleText(CustomConfig.HelpCenter.isFaqHotTopicTitleVisible, CustomConfig.HelpCenter.faqHotTopicsTitle);
        this.rvHotTopics.setup(faqCardLayoutAdapter);
        faqCardLayoutAdapter.update(list);
        this.isHotTopicsEmpty = false;
    }

    private void prepareSectionList(List<FaqListEntity> list) {
        AIHelpFaqCardLayout aIHelpFaqCardLayout;
        if (ListUtil.isListEmpty(list) || (aIHelpFaqCardLayout = this.rvCommonQuestions) == null) {
            return;
        }
        aIHelpFaqCardLayout.setVisibility(0);
        FaqCardLayoutAdapter faqCardLayoutAdapter = new FaqCardLayoutAdapter(getContext(), Styles.isLandscape());
        faqCardLayoutAdapter.setup(getMergedBundle(), getFaqFlowListener(), this);
        faqCardLayoutAdapter.setOnFaqSelectedListener(new FaqSelectedListenerWrapper() {
            final Bundle bundle;

            {
                this.bundle = FaqHomeFragment.this.getMergedBundle();
            }

            @Override
            public void onIntentToSubSectionOrQuestionList(FaqListEntity faqListEntity) {
                this.bundle.putString(IntentValues.SECTION_ID, faqListEntity.getId());
                this.bundle.putString(IntentValues.SECTION_NAME, faqListEntity.getTitle());
                this.bundle.putString(IntentValues.SECTION_ICON, faqListEntity.getIconUrl());
                FaqHomeFragment.this.getFaqFlowListener().onIntentToQuestionList(this.bundle, true);
                AIHelpEventTracker.getInstance().clickSection(faqListEntity.getId(), faqListEntity.getSectionName());
            }
        });
        this.rvCommonQuestions.updateTitleIcon(CustomConfig.HelpCenter.isFaqSectionTitleVisible && CustomConfig.HelpCenter.isFaqSectionTitleIconVisible, CustomConfig.HelpCenter.faqSectionTitleIcon);
        this.rvCommonQuestions.updateTitleText(CustomConfig.HelpCenter.isFaqSectionTitleVisible, CustomConfig.HelpCenter.faqSectionTitle);
        this.rvCommonQuestions.setup(CustomConfig.HelpCenter.isFaqSectionDisplayAsList, faqCardLayoutAdapter);
        faqCardLayoutAdapter.update(list);
        this.isSectionsEmpty = false;
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_home_list");
    }

    @Override
    protected int getLoadingTargetViewId() {
        return ResResolver.getViewId("aihelp_main_content");
    }

    @Override
    public void refreshList(List<FaqListEntity> list, String str) {
        prepareSectionList(list);
        if (this.isNotificationEmpty && this.isHotTopicsEmpty && this.isSectionsEmpty) {
            showEmpty(new int[0]);
        }
    }

    private View getNotificationView(final FaqListEntity faqListEntity) {
        TextView textView = new TextView(getContext());
        textView.setText(faqListEntity.getTitle());
        textView.setTextSize(2, 14.0f);
        textView.setSingleLine();
        textView.setEllipsize(TextUtils.TruncateAt.END);
        textView.setTextColor(Styles.getClickableTextColor(CustomConfig.CommonSetting.highlightedColor));
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle mergedBundle = FaqHomeFragment.this.getMergedBundle();
                mergedBundle.putString(IntentValues.SECTION_ID, FaqHelper.FAQ_NOTIFICATION);
                mergedBundle.putString(IntentValues.FAQ_MAIN_ID, faqListEntity.getId());
                FaqHomeFragment.this.getFaqFlowListener().onIntentToQuestionContent(mergedBundle, true);
            }
        });
        return textView;
    }

    @Override
    public void showNetError() {
        super.showNetError();
        EventBus.getDefault().post(new NetErrorEvent());
    }

    @Override
    public void onEventComing(EventCenter eventCenter) {
        if (eventCenter instanceof OrientationChangeEvent) {
            prepareScreenOrientationAndDataSource();
            this.csEntrance = (AIHelpServiceEntrance) get("aihelp_cs_entrance");
            if (this.csEntrance != null) {
                this.csEntrance.setup(getMergedBundle(), getFaqFlowListener(), this);
            }
        }
    }
}
