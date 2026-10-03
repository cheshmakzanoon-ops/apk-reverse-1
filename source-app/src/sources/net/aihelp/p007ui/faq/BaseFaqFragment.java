package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import java.util.Iterator;
import java.util.List;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.p004ui.BaseFragment;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.LoadingElvaEvent;
import net.aihelp.data.event.NewMessageArrivedEvent;
import net.aihelp.data.event.SearchViewVisibilityChangeEvent;
import net.aihelp.data.event.SupportActionEvent;
import net.aihelp.data.event.UpdateTitleEvent;
import net.aihelp.data.logic.FaqPresenter;
import net.aihelp.data.logic.MqttCallbackImpl;
import net.aihelp.data.model.faq.FaqContentEntity;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.widget.AIHelpServiceEntrance;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public abstract class BaseFaqFragment<T extends FaqPresenter> extends BaseFragment<T> implements View.OnClickListener {
    protected AIHelpServiceEntrance csEntrance;
    protected int intentMode;
    protected String titleIcon;
    protected String titleText;

    public void refreshList(List<FaqListEntity> list) {
    }

    public void refreshQuestionContent(FaqContentEntity faqContentEntity) {
    }

    @Override
    protected void getBundleBeforeDataPrepared(Bundle bundle) {
        this.intentMode = bundle.getInt(IntentValues.SUPPORT_MODE, -1);
        this.titleText = bundle.getString(IntentValues.SECTION_NAME);
        if (TextUtils.isEmpty(this.titleIcon)) {
            this.titleIcon = CustomConfig.HelpCenter.faqNavigationBarTitleIcon;
        }
        if (TextUtils.isEmpty(this.titleText)) {
            this.titleText = CustomConfig.HelpCenter.faqNavigationTitle;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (Const.TOGGLE_OPEN_FAQ_NOTIFICATION) {
            MqttCallbackImpl.getInstance().updateHostView(this);
        }
        EventBus.getDefault().post(new SupportActionEvent(1002));
        EventBus.getDefault().post(new LoadingElvaEvent(1004));
        EventBus.getDefault().post(new UpdateTitleEvent(0, this.titleIcon, this.titleText));
        EventBus.getDefault().post(new SearchViewVisibilityChangeEvent(this instanceof FaqSearchFragment));
        AIHelpServiceEntrance aIHelpServiceEntrance = (AIHelpServiceEntrance) get("aihelp_cs_entrance");
        this.csEntrance = aIHelpServiceEntrance;
        if (aIHelpServiceEntrance != null) {
            aIHelpServiceEntrance.setup(getMergedBundle(), getFaqFlowListener(), this);
        }
    }

    Bundle getMergedBundle() {
        Bundle bundle = new Bundle(getArguments());
        String[] strArr = {IntentValues.SECTION_ID, IntentValues.SUB_SECTION_ID, IntentValues.SECTION_ICON, IntentValues.FAQ_MAIN_ID};
        loop0: for (int i = 0; i < 4; i++) {
            String str = strArr[i];
            Iterator<String> it = bundle.keySet().iterator();
            while (it.hasNext()) {
                if (str.equals(it.next())) {
                    it.remove();
                    break loop0;
                }
            }
        }
        return bundle;
    }

    public void refreshList(List<FaqListEntity> list, String str) {
        refreshList(list);
    }

    void showSearchEmpty() {
        View viewInflate = View.inflate(getContext(), ResResolver.getLayoutId("aihelp_layout_list_empty"), null);
        ImageView imageView = (ImageView) viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_empty"));
        TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_empty"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_empty");
        Styles.reRenderTextView(textView, ResResolver.getString("aihelp_faq_search_empty"));
        super.showEmpty(viewInflate);
    }

    @Override
    public void showEmpty(int... iArr) {
        View viewInflate = View.inflate(getContext(), ResResolver.getLayoutId("aihelp_layout_list_empty"), null);
        ImageView imageView = (ImageView) viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_empty"));
        TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_empty"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_empty");
        Styles.reRenderTextView(textView, ResResolver.getString("aihelp_data_not_found_msg"));
        super.showEmpty(viewInflate);
    }

    public void showEntranceWithNotification(boolean z, boolean z2) {
        if (isVisible()) {
            if (z) {
                TicketStatusTracker.hasUnreadMsg = true;
            } else {
                TicketStatusTracker.isTicketActive = true;
            }
            AIHelpServiceEntrance aIHelpServiceEntrance = this.csEntrance;
            if (aIHelpServiceEntrance != null) {
                aIHelpServiceEntrance.updateViewVisibility(getMergedBundle(), this);
                if (!z || z2) {
                    return;
                }
                this.csEntrance.onIntentToCustomerService(getMergedBundle(), getFaqFlowListener(), this);
                return;
            }
            EventBus.getDefault().post(new NewMessageArrivedEvent());
        }
    }

    @Override
    public void onClick(View view) {
        Bundle arguments;
        if (view.getId() != ResResolver.getViewId("aihelp_cs_entrance") || (arguments = getArguments()) == null) {
            return;
        }
        getFaqFlowListener().onIntentToCustomerService(arguments, true);
    }
}
