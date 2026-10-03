package net.aihelp.p007ui;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.p004ui.BaseFragment;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.data.event.FatalErrorEvent;
import net.aihelp.data.event.LoadingElvaEvent;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.event.PageHoppingEvent;
import net.aihelp.data.event.SearchViewVisibilityChangeEvent;
import net.aihelp.data.event.UpdateTitleEvent;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.faq.BaseFaqFragment;
import net.aihelp.p007ui.faq.FaqContentFragment;
import net.aihelp.p007ui.faq.FaqHomeFragment;
import net.aihelp.p007ui.faq.FaqSearchFragment;
import net.aihelp.p007ui.faq.IFaqEventListener;
import net.aihelp.p007ui.faq.IFaqParentView;
import net.aihelp.p007ui.helper.BreakReleaseHelper;
import net.aihelp.p007ui.helper.FragmentHelper;
import net.aihelp.p007ui.helper.SupportHelper;
import net.aihelp.p007ui.p009cs.BaseCSFragment;
import net.aihelp.p007ui.p009cs.IntentUrlFragment;
import net.aihelp.p007ui.widget.AIHelpFakeSearch;
import net.aihelp.p007ui.widget.AIHelpMsgView;
import net.aihelp.p007ui.widget.AIHelpSearchView;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class SupportFragment extends BaseFragment implements View.OnClickListener, IFaqParentView {
    private AIHelpFakeSearch fakeSearchLand;
    private LinearLayout fakeSearchPort;
    private ImageView ivBack;
    private ImageView ivLoading;
    private ImageView ivTitle;
    private ObjectAnimator loadingAnimator;
    private SupportHelper mSupportHelper;
    private AIHelpMsgView msgView;
    private AIHelpSearchView searchView;
    private TextView tvLogo;
    private TextView tvTitle;

    @Override
    protected boolean isBindEventBus() {
        return true;
    }

    public static SupportFragment getInstance(Bundle bundle) {
        SupportFragment supportFragment = new SupportFragment();
        supportFragment.setArguments(bundle);
        return supportFragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (this.mSupportHelper == null) {
            this.mSupportHelper = new SupportHelper(context, getRetainedChildFragmentManager(), getArguments());
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        this.mSupportHelper.start();
    }

    @Override
    protected void getBundleBeforeDataPrepared(Bundle bundle) {
        if (shouldLocalizeFAQ(bundle)) {
            LocalizeHelper.getLocalizeDataFromUrl(1001);
        }
    }

    private boolean shouldLocalizeFAQ(Bundle bundle) {
        int i = bundle.getInt(IntentValues.SUPPORT_MODE, 0);
        return i == 5 || i == 1 || i == 2;
    }

    @Override
    protected void initEventAndData(View view) {
        ((RelativeLayout) get("aihelp_rl_navigation")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.navigationBarBackground, CustomConfig.CommonSetting.navigationBarAlpha));
        this.ivBack = get("aihelp_iv_back");
        this.ivLoading = get("aihelp_iv_loading");
        this.ivTitle = (ImageView) get("aihelp_iv_title");
        this.tvTitle = (TextView) get("aihelp_tv_title");
        this.msgView = (AIHelpMsgView) get("aihelp_msg_view");
        this.searchView = (AIHelpSearchView) get("aihelp_search_view");
        LinearLayout linearLayout = (LinearLayout) get("aihelp_fake_search_port");
        this.fakeSearchPort = linearLayout;
        linearLayout.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.navigationBarBackground, CustomConfig.CommonSetting.navigationBarAlpha));
        this.fakeSearchLand = (AIHelpFakeSearch) get("aihelp_fake_search_land");
        Styles.reRenderImageView(this.ivBack, "aihelp_svg_ic_back", true);
        Styles.reRenderImageView(this.ivLoading, "aihelp_svg_ic_loading");
        this.msgView.setOnClickListener(this);
        this.ivBack.setOnClickListener(this);
        this.tvTitle.setOnClickListener(new BreakReleaseHelper());
        this.tvTitle.setTextColor(Styles.getColor(CustomConfig.CommonSetting.textColor));
        TextView textView = this.tvTitle;
        textView.setMaxWidth(Styles.getScreenWidth(textView.getContext()) / 2);
        this.fakeSearchPort.setOnClickListener(this);
        this.fakeSearchLand.setOnClickListener(this);
        updateTitleBarAccordingToSearchStatus(false);
        TextView textView2 = (TextView) get("aihelp_logo");
        this.tvLogo = textView2;
        textView2.setTextColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 1.0d));
        this.tvLogo.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha));
        ObjectAnimator objectAnimatorOfFloat = ObjectAnimator.ofFloat(this.ivLoading, "rotation", 0.0f, 360.0f);
        this.loadingAnimator = objectAnimatorOfFloat;
        objectAnimatorOfFloat.setDuration(1000L);
        this.loadingAnimator.setInterpolator(new LinearInterpolator());
        this.loadingAnimator.setRepeatCount(-1);
        this.searchView.setupSearchView(new AIHelpSearchView.OnAIHelpSearchViewListener() {
            @Override
            public void onFocusChanged() {
            }

            @Override
            public void onInputCanceled() {
                FragmentManager childFragmentManager = SupportFragment.this.getChildFragmentManager();
                if (childFragmentManager.getBackStackEntryCount() > 0) {
                    childFragmentManager.popBackStack();
                }
                SupportFragment.this.updateTitleBarAccordingToSearchStatus(false);
            }
        }, getFaqEventListener());
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_support");
    }

    @Override
    public void onEventComing(EventCenter eventCenter) {
        Fragment topMostFragment = FragmentHelper.getTopMostFragment(getRetainedChildFragmentManager());
        if (eventCenter instanceof LoadingElvaEvent) {
            if (eventCenter.getCode() == 1003) {
                if (this.loadingAnimator.isRunning() || !shouldShowLoading(topMostFragment)) {
                    return;
                }
                this.ivLoading.setVisibility(0);
                this.loadingAnimator.start();
            } else {
                this.ivLoading.setVisibility(8);
                this.loadingAnimator.cancel();
            }
        }
        boolean z = true;
        if ((eventCenter instanceof PageHoppingEvent) && eventCenter.getCode() == 1009) {
            this.mSupportHelper.onIntentToFillForm(((PageHoppingEvent) eventCenter).getEvent(), true);
        }
        if (eventCenter instanceof UpdateTitleEvent) {
            TextView textView = this.tvLogo;
            if (textView != null) {
                textView.setVisibility(topMostFragment instanceof BaseCSFragment ? 8 : 0);
            }
            UpdateTitleEvent updateTitleEvent = (UpdateTitleEvent) eventCenter;
            if (updateTitleEvent.getIcon() != null) {
                boolean z2 = (topMostFragment instanceof BaseCSFragment) && CustomConfig.CustomerService.isCsTitleIconVisible;
                boolean z3 = (topMostFragment instanceof BaseFaqFragment) && CustomConfig.HelpCenter.isFaqTitleIconVisible;
                ImageView imageView = this.ivTitle;
                String icon = updateTitleEvent.getIcon();
                if (!z2 && !z3) {
                    z = false;
                }
                Styles.loadIcon(imageView, icon, z);
            }
            if (updateTitleEvent.getTitle() != null) {
                this.tvTitle.setText(updateTitleEvent.getTitle());
            }
        }
        if (eventCenter instanceof SearchViewVisibilityChangeEvent) {
            updateTitleBarAccordingToSearchStatus(((Boolean) eventCenter.getEvent()).booleanValue());
        }
        if (eventCenter instanceof OrientationChangeEvent) {
            TextView textView2 = this.tvTitle;
            textView2.setMaxWidth(Styles.getScreenWidth(textView2.getContext()) / 2);
            updateTitleBarAccordingToSearchStatus(topMostFragment instanceof FaqSearchFragment);
        }
        if (!(eventCenter instanceof FatalErrorEvent) || getActivity() == null || getActivity().isFinishing()) {
            return;
        }
        Toast.makeText(getActivity().getApplicationContext(), "Oops! Something went wrong", 0).show();
        AIHelpMqtt.getInstance().onFaqDestroy();
        AIHelpMqtt.getInstance().disconnect();
        Const.IS_SDK_SHOWING = false;
        getActivity().finish();
    }

    private boolean shouldShowLoading(Fragment fragment) {
        if (fragment != null) {
            return "CustomerServiceFragment".equals(fragment.getClass().getSimpleName());
        }
        return false;
    }

    public boolean onBackPressed() {
        Fragment topMostFragment = FragmentHelper.getTopMostFragment(getRetainedChildFragmentManager());
        if (topMostFragment == null) {
            return false;
        }
        String simpleName = topMostFragment.getClass().getSimpleName();
        if ("FaqContentFragment".equals(simpleName)) {
            return ((FaqContentFragment) topMostFragment).onBackPressed();
        }
        if ("IntentUrlFragment".equals(simpleName)) {
            return ((IntentUrlFragment) topMostFragment).onBackPressed();
        }
        if (!"FaqSearchFragment".equals(simpleName)) {
            return true;
        }
        SoftInputUtil.hideSoftInput(getContext(), this.searchView);
        return true;
    }

    @Override
    public void onClick(View view) {
        if (FastClickValidator.validate(0.5f) && Const.isNestedFragmentOnResume) {
            if (view.getId() == ResResolver.getViewId("aihelp_iv_back") && getActivity() != null) {
                getActivity().onBackPressed();
            }
            if (view.getId() == ResResolver.getViewId("aihelp_fake_search_port") || view.getId() == ResResolver.getViewId("aihelp_fake_search_land")) {
                this.mSupportHelper.onIntentToSearch(getArguments());
                this.searchView.autoFocus();
                AIHelpEventTracker.getInstance().clickSearch();
            }
        }
    }

    public void updateTitleBarAccordingToSearchStatus(boolean z) {
        ViewGroup viewGroup = (ViewGroup) this.ivTitle.getParent();
        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) viewGroup.getLayoutParams();
        Fragment topMostFragment = FragmentHelper.getTopMostFragment(getRetainedChildFragmentManager());
        if (topMostFragment instanceof BaseFaqFragment) {
            this.ivTitle.setVisibility((!CustomConfig.HelpCenter.isFaqTitleIconVisible || z) ? 8 : 0);
            this.tvTitle.setVisibility(!z ? 0 : 8);
            if (CustomConfig.HelpCenter.isFaqSearchVisible) {
                boolean zEquals = FaqHomeFragment.class.getName().equals(topMostFragment.getClass().getName());
                this.fakeSearchPort.setVisibility((!zEquals || Styles.isLandscape() || z) ? 8 : 0);
                this.fakeSearchLand.setVisibility((zEquals && Styles.isLandscape() && !z) ? 0 : 8);
                this.searchView.setVisibility(z ? 0 : 8);
            }
            layoutParams.addRule(17, ResResolver.getViewId("aihelp_iv_back"));
            layoutParams.addRule(1, ResResolver.getViewId("aihelp_iv_back"));
            viewGroup.setLayoutParams(layoutParams);
        }
        if (topMostFragment instanceof BaseCSFragment) {
            this.ivTitle.setVisibility(CustomConfig.CustomerService.isCsTitleIconVisible ? 0 : 8);
            this.tvTitle.setVisibility(0);
            this.fakeSearchPort.setVisibility(8);
            this.fakeSearchLand.setVisibility(8);
            this.searchView.setVisibility(8);
            layoutParams.removeRule(1);
            layoutParams.removeRule(17);
            viewGroup.setLayoutParams(layoutParams);
        }
    }

    @Override
    public IFaqEventListener getFaqEventListener() {
        return this.mSupportHelper;
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
    }

    public void onDestroy() {
        super.onDestroy();
        ObjectAnimator objectAnimator = this.loadingAnimator;
        if (objectAnimator != null) {
            objectAnimator.cancel();
            this.loadingAnimator = null;
        }
        AIHelpMqtt.getInstance().onFaqDestroy();
    }
}
