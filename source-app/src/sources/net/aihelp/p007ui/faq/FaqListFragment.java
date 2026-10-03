package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.view.View;
import android.widget.RelativeLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.Iterator;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.data.localize.config.ProcessEntranceHelper;
import net.aihelp.data.logic.FaqPresenter;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.faq.FaqCardLayoutAdapter;
import net.aihelp.p007ui.wrapper.FaqSelectedListenerWrapper;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FaqListFragment extends BaseFaqFragment<FaqPresenter> {
    private String currentSectionId;
    private FaqCardLayoutAdapter mAdapter;

    public static FaqListFragment newInstance(Bundle bundle) {
        FaqListFragment faqListFragment = new FaqListFragment();
        faqListFragment.setArguments(bundle);
        return faqListFragment;
    }

    @Override
    protected void getBundleBeforeDataPrepared(Bundle bundle) {
        super.getBundleBeforeDataPrepared(bundle);
        this.currentSectionId = bundle.getString(IntentValues.SECTION_ID);
    }

    @Override
    protected void initEventAndData(View view) {
        ((RelativeLayout) get("aihelp_rl_search")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha));
        RecyclerView recyclerView = get("aihelp_rv_faq_search");
        recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
        FaqCardLayoutAdapter faqCardLayoutAdapter = new FaqCardLayoutAdapter(getContext(), true);
        this.mAdapter = faqCardLayoutAdapter;
        faqCardLayoutAdapter.setup(getMergedBundle(), getFaqFlowListener(), this);
        this.mAdapter.setOnFaqSelectedListener(new FaqSelectedListenerWrapper() {
            final Bundle bundle;

            {
                this.bundle = FaqListFragment.this.getMergedBundle();
            }

            @Override
            public void onIntentToSubSectionOrQuestionList(FaqListEntity faqListEntity) {
                this.bundle.putString(IntentValues.SECTION_ID, faqListEntity.getId());
                this.bundle.putString(IntentValues.SECTION_NAME, faqListEntity.getTitle());
                this.bundle.putString(IntentValues.SECTION_ICON, faqListEntity.getIconUrl());
                FaqListFragment.this.getFaqFlowListener().onIntentToQuestionList(this.bundle, true);
                FaqListFragment.this.handleTrackLogic(faqListEntity);
            }

            @Override
            public void onIntentToQuestionContent(FaqListEntity faqListEntity) {
                this.bundle.putString(IntentValues.SECTION_ID, FaqListFragment.this.currentSectionId);
                this.bundle.putString(IntentValues.SECTION_NAME, FaqListFragment.this.titleText);
                this.bundle.putString(IntentValues.SECTION_ICON, FaqListFragment.this.titleIcon);
                this.bundle.putString(IntentValues.FAQ_MAIN_ID, faqListEntity.getId());
                FaqListFragment.this.getFaqFlowListener().onIntentToQuestionContent(this.bundle, true);
            }
        });
        recyclerView.setAdapter(this.mAdapter);
        if (this.intentMode == 3) {
            ((FaqPresenter) this.mPresenter).prepareFAQNotification();
        }
    }

    @Override
    protected void getBundleAfterDataPrepared(Bundle bundle) {
        ((FaqPresenter) this.mPresenter).goFetchFAQDataSource(bundle.getString(IntentValues.SECTION_ID));
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_search_faq");
    }

    @Override
    protected int getLoadingTargetViewId() {
        return ResResolver.getViewId("aihelp_rv_faq_search");
    }

    @Override
    public void refreshList(List<FaqListEntity> list) {
        if (this.intentMode == -1 && !ListUtil.isListEmpty(list)) {
            Iterator<FaqListEntity> it = list.iterator();
            while (it.hasNext()) {
                if (it.next().isHidden()) {
                    it.remove();
                }
            }
        }
        if (!ListUtil.isListEmpty(list)) {
            FaqListEntity faqListEntity = list.get(0);
            if (faqListEntity != null) {
                this.titleText = faqListEntity.getSectionName();
            }
            this.mAdapter.update(list);
            return;
        }
        showEmpty(new int[0]);
    }

    public void handleTrackLogic(FaqListEntity faqListEntity) {
        ProcessEntity currentProcess = ProcessEntranceHelper.INSTANCE.getCurrentProcess();
        if (currentProcess != null && currentProcess.getIntent() == 2 && currentProcess.getSectionId().equals(this.currentSectionId)) {
            AIHelpEventTracker.getInstance().clickSection(faqListEntity.getId(), faqListEntity.getTitle());
        }
    }
}
