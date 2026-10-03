package net.aihelp.p007ui.p009cs.middle;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.config.IntentEntity;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.p007ui.p009cs.IServiceEventListener;
import net.aihelp.p007ui.p009cs.middle.intent.IOnIntentViewEventListener;
import net.aihelp.p007ui.p009cs.middle.intent.SmartIntentView;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class MiddleHandlerView extends RelativeLayout implements View.OnClickListener, IOnIntentViewEventListener {
    private final SmartIntentView intentView;
    private IServiceEventListener serviceEventListener;
    private final AIHelpButton tvPrevStep;
    private final AIHelpButton tvSkip;

    public void setServiceEventListener(IServiceEventListener iServiceEventListener) {
        this.serviceEventListener = iServiceEventListener;
    }

    public MiddleHandlerView(Context context) {
        this(context, null);
    }

    public MiddleHandlerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public MiddleHandlerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_layout_middle_handler"), this);
        SmartIntentView smartIntentView = (SmartIntentView) findViewById(ResResolver.getViewId("aihelp_smart_intent"));
        this.intentView = smartIntentView;
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_tv_previous"));
        this.tvPrevStep = aIHelpButton;
        AIHelpButton aIHelpButton2 = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_tv_skip"));
        this.tvSkip = aIHelpButton2;
        aIHelpButton.setOnClickListener(this);
        aIHelpButton2.setOnClickListener(this);
        smartIntentView.setOnIntentViewEventListener(this);
    }

    @Override
    public void onClick(View view) {
        IServiceEventListener iServiceEventListener;
        if (AppInfoUtil.validateNetwork(getContext())) {
            if (view.getId() == ResResolver.getViewId("aihelp_tv_previous") && (iServiceEventListener = this.serviceEventListener) != null) {
                iServiceEventListener.onUserGoBack();
            }
            if (view.getId() != ResResolver.getViewId("aihelp_tv_skip") || this.serviceEventListener == null) {
                return;
            }
            String string = this.tvSkip.getText().toString();
            UserMessage userTextMsg = Message.getUserTextMsg(string);
            userTextMsg.setRequestParams(string, true, 2, "", 7);
            this.serviceEventListener.onUserAction(userTextMsg);
            this.tvSkip.setVisibility(8);
            notifyVisibilityChanged();
        }
    }

    public void updateViewVisibility(RPAStep rPAStep) {
        setVisibility(0);
        if (rPAStep != null && rPAStep.isEnableSkip() && rPAStep.getNextStep() != 4) {
            updateButtonStyle(this.tvSkip, rPAStep.getSkipHint());
        }
        if (rPAStep != null && rPAStep.isEnablePrevStep()) {
            updateButtonStyle(this.tvPrevStep, rPAStep.getPrevStepHint());
        } else {
            this.intentView.updateViewVisibility();
        }
        notifyVisibilityChanged();
    }

    @Override
    public void setVisibility(int i) {
        super.setVisibility(i);
        this.tvSkip.setVisibility(8);
        this.tvPrevStep.setVisibility(8);
        this.intentView.setVisibility(8);
        if (i != getVisibility()) {
            notifyVisibilityChanged();
        }
    }

    public void notifyVisibilityChanged() {
        IServiceEventListener iServiceEventListener = this.serviceEventListener;
        if (iServiceEventListener != null) {
            iServiceEventListener.onMiddleHandlerViewVisibilityChanged();
        }
    }

    public boolean isVisible() {
        return getVisibility() == 0 && (this.intentView.getVisibility() == 0 || this.tvPrevStep.getVisibility() == 0 || this.tvSkip.getVisibility() == 0);
    }

    @Override
    public void onIntentViewVisibilityChanged(int i) {
        notifyVisibilityChanged();
    }

    @Override
    public void onIntentSelected(IntentEntity intentEntity) {
        String intentName = intentEntity.getIntentName();
        String strValueOf = String.valueOf(intentEntity.getIntentId());
        UserMessage userTextMsg = Message.getUserTextMsg(intentName);
        userTextMsg.setRequestParams(intentName, false, 5, strValueOf, 8);
        IServiceEventListener iServiceEventListener = this.serviceEventListener;
        if (iServiceEventListener != null) {
            iServiceEventListener.onUserAction(userTextMsg);
        }
    }

    private void updateButtonStyle(AIHelpButton aIHelpButton, String str) {
        if (!TextUtils.isEmpty(str)) {
            aIHelpButton.setVisibility(0);
            aIHelpButton.setMaxWidth(Styles.getScreenWidth(getContext()) / 4);
            aIHelpButton.setBackground(Styles.getDrawable(Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor), 8));
            aIHelpButton.setText(str);
            return;
        }
        aIHelpButton.setVisibility(8);
    }
}
