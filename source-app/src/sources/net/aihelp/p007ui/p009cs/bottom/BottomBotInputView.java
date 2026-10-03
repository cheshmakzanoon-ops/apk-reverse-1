package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.p009cs.IServiceEventListener;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;

public class BottomBotInputView extends BottomBaseView implements View.OnClickListener {
    private int inputType;
    private final TextView tvHint;

    public BottomBotInputView(Context context) {
        super(context);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_input_for_bot"), this);
        this.tvHint = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_hint"));
        prepareInputView();
    }

    @Override
    public void onClick(View view) {
        if (this.etInput != null && AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_send")) {
            String strTrim = this.etInput.getText().toString().trim();
            int i = this.inputType;
            if (i == 2) {
                if (!Pattern.compile("[0-9]*").matcher(strTrim).matches()) {
                    updateInputValidator(ResResolver.getString("aihelp_enter_number"), true);
                    return;
                }
            } else if (i == 32 && !Pattern.compile("^([A-Za-z0-9_\\-.])+@([A-Za-z0-9_\\-.])+\\.([A-Za-z]{2,4})$").matcher(strTrim).matches()) {
                updateInputValidator(ResResolver.getString("aihelp_enter_email_address"), true);
                return;
            }
            if (this.mListener != null) {
                this.etInput.setText("");
                SoftInputUtil.hideSoftInput(getContext(), this.etInput);
                UserMessage userTextMsg = Message.getUserTextMsg(strTrim);
                userTextMsg.setRequestParams(strTrim, 1, 1);
                this.mListener.onUserAction(userTextMsg);
                AIHelpEventTracker.getInstance().onUserInput();
            }
        }
    }

    private void updateInputValidator(String str, boolean z) {
        this.tvHint.setVisibility(z ? 0 : 8);
        this.tvHint.setText(str);
    }

    @Override
    public void setBottomViewEventListener(Bundle bundle, RPAStep rPAStep, IServiceEventListener iServiceEventListener) {
        super.setBottomViewEventListener(bundle, rPAStep, iServiceEventListener);
        if (this.etInput != null) {
            int nextStep = rPAStep.getNextStep();
            if (nextStep == 1) {
                this.inputType = 1;
                this.etInput.setHint(CustomConfig.CustomerService.csInputHint);
            } else if (nextStep == 2) {
                this.inputType = 32;
                this.etInput.setHint(ResResolver.getString("aihelp_enter_email_address"));
            } else {
                if (nextStep != 3) {
                    return;
                }
                this.inputType = 2;
                this.etInput.setHint(ResResolver.getString("aihelp_enter_number"));
            }
        }
    }
}
