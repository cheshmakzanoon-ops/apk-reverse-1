package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.View;
import android.widget.TextView;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.p007ui.p009cs.IServiceEventListener;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.p007ui.widget.AIHelpFlowLayout;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class BottomActionPickerView extends BottomBaseView implements AIHelpFlowLayout.OnLabelClickedListener, View.OnClickListener {
    private final AIHelpFlowLayout actionList;
    private final AIHelpButton tvSkip;

    public BottomActionPickerView(Context context) {
        this(context, null);
    }

    public BottomActionPickerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public BottomActionPickerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_action_picker"), this);
        Styles.reRenderTextView((TextView) findViewById(ResResolver.getViewId("aihelp_tv_hint")), ResResolver.getString("aihelp_select_option"));
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_tv_skip_action_picker"));
        this.tvSkip = aIHelpButton;
        aIHelpButton.setOnClickListener(this);
        AIHelpFlowLayout aIHelpFlowLayout = (AIHelpFlowLayout) findViewById(ResResolver.getViewId("aihelp_fl_actions"));
        this.actionList = aIHelpFlowLayout;
        aIHelpFlowLayout.setOnLabelClickedListener(this);
    }

    @Override
    public void onLabelClicked(RPAStep.Action action) {
        if (!AppInfoUtil.validateNetwork(getContext()) || this.mListener == null || action == null) {
            return;
        }
        String id = action.getId();
        String content = action.getContent();
        UserMessage userTextMsg = Message.getUserTextMsg(content);
        userTextMsg.setRequestParams(content, false, 2, id, 2);
        this.mListener.onUserAction(userTextMsg);
    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        if (!AppInfoUtil.validateNetwork(getContext()) || view.getId() != ResResolver.getViewId("aihelp_tv_skip_action_picker") || this.tvSkip == null || this.mListener == null) {
            return;
        }
        String string = this.tvSkip.getText().toString();
        UserMessage userTextMsg = Message.getUserTextMsg(string);
        userTextMsg.setRequestParams(string, true, 2, "", 7);
        this.mListener.onUserAction(userTextMsg);
        this.tvSkip.setVisibility(8);
    }

    @Override
    public void setBottomViewEventListener(Bundle bundle, RPAStep rPAStep, IServiceEventListener iServiceEventListener) {
        super.setBottomViewEventListener(bundle, rPAStep, iServiceEventListener);
        this.tvSkip.setVisibility(rPAStep.isEnableSkip() ? 0 : 8);
        this.tvSkip.setText(rPAStep.getSkipHint());
        this.actionList.update(rPAStep.getActionList(), false);
    }
}
