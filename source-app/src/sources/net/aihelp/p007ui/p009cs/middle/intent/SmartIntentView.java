package net.aihelp.p007ui.p009cs.middle.intent;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.localize.config.ProcessEntranceHelper;
import net.aihelp.data.model.config.IntentEntity;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.SmartIntentAdapter;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class SmartIntentView extends LinearLayout implements View.OnClickListener, SmartIntentAdapter.OnIntentSelectedListener {
    private ProcessEntity currentProcess;
    private IOnIntentViewEventListener intentViewEventListener;
    private boolean isDismissed;
    private final SmartIntentAdapter subIntentAdapter;
    private final SmartIntentScrollView svIntent;
    private final AIHelpButton tvIntent;

    public void setOnIntentViewEventListener(IOnIntentViewEventListener iOnIntentViewEventListener) {
        this.intentViewEventListener = iOnIntentViewEventListener;
    }

    public SmartIntentView(Context context) {
        this(context, null);
    }

    public SmartIntentView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public SmartIntentView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_smart_intent_view"), this);
        SmartIntentScrollView smartIntentScrollView = (SmartIntentScrollView) findViewById(ResResolver.getViewId("aihelp_intent_scroll"));
        this.svIntent = smartIntentScrollView;
        smartIntentScrollView.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, Math.min(CustomConfig.CommonSetting.upperBackgroundAlpha + 0.6d, 0.8d)));
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_tv_intent"));
        this.tvIntent = aIHelpButton;
        aIHelpButton.setMaxWidth((int) (Styles.getScreenWidth(getContext()) * 0.6f));
        aIHelpButton.setOnClickListener(this);
        View viewFindViewById = findViewById(ResResolver.getViewId("aihelp_v_divider_root"));
        View viewFindViewById2 = findViewById(ResResolver.getViewId("aihelp_v_divider_sub"));
        viewFindViewById.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d));
        viewFindViewById2.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d));
        this.subIntentAdapter = new SmartIntentAdapter(getContext(), this);
        setVisibility(8);
    }

    public void updateViewVisibility() {
        ProcessEntity currentProcess = ProcessEntranceHelper.INSTANCE.getCurrentProcess();
        this.currentProcess = currentProcess;
        if (this.tvIntent == null || this.svIntent == null || ListUtil.isListEmpty(currentProcess.getSmartIntentList())) {
            setVisibility(8);
            return;
        }
        this.tvIntent.setText(this.currentProcess.getSmartIntentName());
        this.tvIntent.setMaxWidth((int) (Styles.getScreenWidth(getContext()) * 0.6f));
        if (TicketStatusTracker.isTicketServingByAgent() || TicketStatusTracker.isTicketServingByRPA() || TicketStatusTracker.isTicketFinished || TicketStatusTracker.isTicketRejected) {
            setVisibility(8);
            showIntentEntrance(8);
            this.svIntent.setVisibility(8);
            return;
        }
        if (TicketStatusTracker.isTicketServingByAnswerBot()) {
            if (TicketStatusTracker.isTicketActive) {
                ProcessEntity processEntity = this.currentProcess;
                if (processEntity != null && processEntity.isEnableInteraction() && !ListUtil.isListEmpty(this.currentProcess.getSmartIntentList())) {
                    setVisibility(0);
                    showIntentEntrance(0);
                    this.svIntent.setVisibility(8);
                    return;
                } else {
                    setVisibility(8);
                    showIntentEntrance(8);
                    this.svIntent.setVisibility(8);
                    return;
                }
            }
            ProcessEntity processEntity2 = this.currentProcess;
            if (processEntity2 != null && processEntity2.isEnableInteraction()) {
                if (Styles.isLandscape() || isIntentListFolded()) {
                    setVisibility(0);
                    showIntentEntrance(0);
                    this.svIntent.setVisibility(8);
                    return;
                }
                showRootIntents();
                return;
            }
            if (this.isDismissed) {
                return;
            }
            showRootIntents();
        }
    }

    private void showIntentEntrance(int i) {
        if (i == 8) {
            this.tvIntent.setVisibility(8);
        } else {
            if (TextUtils.isEmpty(this.currentProcess.getSmartIntentName())) {
                return;
            }
            if (TextUtils.isEmpty(this.tvIntent.getText())) {
                this.tvIntent.setText(this.currentProcess.getSmartIntentName());
                this.tvIntent.setMaxWidth((int) (Styles.getScreenWidth(getContext()) * 0.6f));
            }
            this.tvIntent.setVisibility(0);
        }
    }

    public void showRootIntents() {
        ProcessEntity processEntity = this.currentProcess;
        if (processEntity != null) {
            List<IntentEntity> smartIntentList = processEntity.getSmartIntentList();
            if (!ListUtil.isListEmpty(smartIntentList)) {
                setVisibility(0);
                this.subIntentAdapter.clear();
                showIntentEntrance(8);
                this.svIntent.setVisibility(0);
                this.svIntent.scrollIntentTo(0);
                Styles.reRenderTextView((TextView) findViewById(ResResolver.getViewId("aihelp_tv_root_title")), ResResolver.getString("aihelp_select_option"));
                RecyclerView recyclerViewFindViewById = findViewById(ResResolver.getViewId("aihelp_rv_root_intent"));
                recyclerViewFindViewById.setLayoutManager(new LinearLayoutManager(getContext()));
                SmartIntentAdapter smartIntentAdapter = new SmartIntentAdapter(getContext(), this);
                recyclerViewFindViewById.setAdapter(smartIntentAdapter);
                smartIntentAdapter.update((List) smartIntentList);
                ImageView imageView = (ImageView) findViewById(ResResolver.getViewId("aihelp_iv_root_close"));
                Styles.reRenderImageView(imageView, "aihelp_svg_ic_close_dialog");
                imageView.setOnClickListener(this);
                return;
            }
            setVisibility(8);
        }
    }

    public void showSubIntents(IntentEntity intentEntity) {
        ImageView imageView = (ImageView) findViewById(ResResolver.getViewId("aihelp_iv_sub_back"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_back");
        imageView.setOnClickListener(this);
        TextView textView = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_sub_title"));
        Styles.reRenderTextView(textView, intentEntity.getIntentName(), Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor));
        textView.setOnClickListener(this);
        RecyclerView recyclerViewFindViewById = findViewById(ResResolver.getViewId("aihelp_rv_sub_intent"));
        recyclerViewFindViewById.setLayoutManager(new LinearLayoutManager(getContext()));
        recyclerViewFindViewById.setAdapter(this.subIntentAdapter);
        this.subIntentAdapter.update((List) intentEntity.getIntentList());
        ImageView imageView2 = (ImageView) findViewById(ResResolver.getViewId("aihelp_iv_sub_close"));
        Styles.reRenderImageView(imageView2, "aihelp_svg_ic_close_dialog");
        imageView2.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        ProcessEntity processEntity;
        if (view.getId() == ResResolver.getViewId("aihelp_tv_intent")) {
            showRootIntents();
        }
        if ((view.getId() == ResResolver.getViewId("aihelp_iv_root_close") || view.getId() == ResResolver.getViewId("aihelp_iv_sub_close")) && (processEntity = this.currentProcess) != null) {
            if (processEntity.isEnableInteraction()) {
                showIntentEntrance(0);
            } else {
                setVisibility(8);
                showIntentEntrance(8);
                this.isDismissed = true;
            }
            this.svIntent.setVisibility(8);
            this.subIntentAdapter.clear();
            this.svIntent.scrollIntentTo(0);
            IOnIntentViewEventListener iOnIntentViewEventListener = this.intentViewEventListener;
            if (iOnIntentViewEventListener != null) {
                iOnIntentViewEventListener.onIntentViewVisibilityChanged(0);
            }
        }
        if (view.getId() == ResResolver.getViewId("aihelp_iv_sub_back") || view.getId() == ResResolver.getViewId("aihelp_tv_sub_title")) {
            this.subIntentAdapter.clear();
            this.svIntent.scrollIntentTo(0);
        }
    }

    @Override
    public void onIntentSelected(IntentEntity intentEntity, boolean z) {
        if (z) {
            showSubIntents(intentEntity);
            this.svIntent.scrollIntentTo(Integer.MAX_VALUE);
        } else {
            if (this.intentViewEventListener == null || intentEntity == null) {
                return;
            }
            SoftInputUtil.hideSoftInput(getContext(), this.svIntent);
            this.intentViewEventListener.onIntentSelected(intentEntity);
            AIHelpEventTracker.getInstance().selectSmartIntent(String.valueOf(intentEntity.getIntentId()));
            this.svIntent.setVisibility(8);
        }
    }

    @Override
    public void setVisibility(int i) {
        super.setVisibility(i);
        IOnIntentViewEventListener iOnIntentViewEventListener = this.intentViewEventListener;
        if (iOnIntentViewEventListener != null) {
            iOnIntentViewEventListener.onIntentViewVisibilityChanged(i);
        }
    }

    public boolean isIntentListFolded() {
        ProcessEntity processEntity = this.currentProcess;
        return processEntity != null && processEntity.isEnableInteraction() && this.svIntent.getVisibility() == 8 && this.tvIntent.getVisibility() == 0;
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(EventCenter eventCenter) {
        if (eventCenter instanceof OrientationChangeEvent) {
            post(new Runnable() {
                @Override
                public void run() {
                    SmartIntentView.this.updateViewVisibility();
                }
            });
        }
    }
}
