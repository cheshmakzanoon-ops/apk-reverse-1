package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import net.aihelp.common.IntentValues;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import org.json.JSONException;
import org.json.JSONObject;

public class BottomEvaluateFaqView extends BottomBaseView {
    public BottomEvaluateFaqView(Context context) {
        this(context, null);
    }

    public BottomEvaluateFaqView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public BottomEvaluateFaqView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_evaluate_faq_view"), this);
        final AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_un_helpful"));
        aIHelpButton.setText(ResResolver.getString("aihelp_faq_unhelpful"));
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!AppInfoUtil.validateNetwork(BottomEvaluateFaqView.this.getContext()) || BottomEvaluateFaqView.this.mListener == null) {
                    return;
                }
                String string = aIHelpButton.getText().toString();
                UserMessage userTextMsg = Message.getUserTextMsg(string);
                userTextMsg.setRequestParams(BottomEvaluateFaqView.this.appendContentId(UserMessage.getRequestParams(string, false, 2, "unlike", 5)));
                BottomEvaluateFaqView.this.mListener.onUserAction(userTextMsg);
            }
        });
        final AIHelpButton aIHelpButton2 = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_helpful"));
        aIHelpButton2.setText(ResResolver.getString("aihelp_faq_helpful"));
        aIHelpButton2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!AppInfoUtil.validateNetwork(BottomEvaluateFaqView.this.getContext()) || BottomEvaluateFaqView.this.mListener == null) {
                    return;
                }
                String string = aIHelpButton2.getText().toString();
                UserMessage userTextMsg = Message.getUserTextMsg(string);
                userTextMsg.setRequestParams(BottomEvaluateFaqView.this.appendContentId(UserMessage.getRequestParams(string, false, 2, "like", 5)));
                BottomEvaluateFaqView.this.mListener.onUserAction(userTextMsg);
            }
        });
    }

    public JSONObject appendContentId(JSONObject jSONObject) {
        try {
            jSONObject.put("contentId", this.bundle.getLong(IntentValues.BOTTOM_FAQ_CONTENT_ID, 0L));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jSONObject;
    }
}
