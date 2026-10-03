package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.p007ui.p009cs.util.viewer.EvaluateViewer;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class BottomEvaluateServiceView extends BottomBaseView implements View.OnClickListener {
    public BottomEvaluateServiceView(Context context) {
        super(context);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_evaluate_service_view"), this);
        TextView textView = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_invite_rate"));
        Styles.reRenderTextView(textView, CustomConfig.CustomerService.csInviteEvaluate);
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_go_rate"));
        aIHelpButton.setText(ResResolver.getString("aihelp_rate_button"));
        aIHelpButton.setOnClickListener(this);
        SoftInputUtil.hideSoftInput(getContext(), textView);
    }

    @Override
    public void onClick(View view) {
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_go_rate")) {
            EvaluateViewer.getInstance().show(getContext(), new EvaluateViewer.OnConfirmEvaluateListener() {
                @Override
                public void onPostEvaluate() {
                    if (BottomEvaluateServiceView.this.mListener != null) {
                        BottomEvaluateServiceView.this.mListener.onTicketFinished(104);
                    }
                }

                @Override
                public void onAfterEvaluate() {
                    if (BottomEvaluateServiceView.this.mListener != null) {
                        BottomEvaluateServiceView.this.mListener.onTicketFinished(102);
                    }
                }
            });
        }
    }
}
