package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.RelativeLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.data.logic.FaqPresenter;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.faq.FaqCardLayoutAdapter;
import net.aihelp.p007ui.wrapper.FaqSelectedListenerWrapper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class FaqSearchFragment extends BaseFaqFragment<FaqPresenter> {
    private Timer debounceTimer;
    private FaqCardLayoutAdapter mSearchAdapter;
    private RecyclerView rvSearchList;

    public static FaqSearchFragment newInstance(Bundle bundle) {
        FaqSearchFragment faqSearchFragment = new FaqSearchFragment();
        faqSearchFragment.setArguments(bundle);
        return faqSearchFragment;
    }

    @Override
    protected void initEventAndData(View view) {
        prepareRecyclerView();
    }

    private void prepareRecyclerView() {
        ((RelativeLayout) get("aihelp_rl_search")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha));
        RecyclerView recyclerView = get("aihelp_rv_faq_search");
        this.rvSearchList = recyclerView;
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        FaqCardLayoutAdapter faqCardLayoutAdapter = new FaqCardLayoutAdapter(getContext(), false);
        this.mSearchAdapter = faqCardLayoutAdapter;
        faqCardLayoutAdapter.setOnFaqSelectedListener(new FaqSelectedListenerWrapper() {
            @Override
            public void onIntentToQuestionContent(FaqListEntity faqListEntity) {
                SoftInputUtil.hideSoftInput(FaqSearchFragment.this.getContext(), FaqSearchFragment.this.rvSearchList);
                Bundle arguments = FaqSearchFragment.this.getArguments() != null ? FaqSearchFragment.this.getArguments() : new Bundle();
                arguments.putString(IntentValues.FAQ_MAIN_ID, faqListEntity.getId());
                arguments.putString(IntentValues.SEARCH_MATCH, faqListEntity.getQuery());
                FaqSearchFragment.this.getFaqFlowListener().onIntentToQuestionContent(arguments, true);
            }
        });
        this.rvSearchList.setAdapter(this.mSearchAdapter);
    }

    public void onQuery(String str) {
        ((FaqPresenter) this.mPresenter).goQueryFAQList(str);
        handleTrackLogicWithDebounce(str);
    }

    private void handleTrackLogicWithDebounce(final String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        Timer timer = this.debounceTimer;
        if (timer != null) {
            timer.cancel();
        }
        Timer timer2 = new Timer();
        this.debounceTimer = timer2;
        timer2.schedule(new TimerTask() {
            @Override
            public void run() {
                AIHelpEventTracker.getInstance().trackSearchQuery(str);
            }
        }, 5000L);
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_search_faq");
    }

    @Override
    public void refreshList(List<FaqListEntity> list) {
        if (isVisible()) {
            if (list != null && list.size() == 0) {
                showSearchEmpty();
            } else {
                restoreViewState();
            }
            this.mSearchAdapter.update(list);
        }
    }

    @Override
    protected int getLoadingTargetViewId() {
        return ResResolver.getViewId("aihelp_rv_faq_search");
    }

    public void onDestroy() {
        super.onDestroy();
        Timer timer = this.debounceTimer;
        if (timer != null) {
            timer.cancel();
        }
    }
}
