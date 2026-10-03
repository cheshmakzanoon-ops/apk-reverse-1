package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;

public class BottomNewConversationView extends BottomBaseView {
    public BottomNewConversationView(Context context) {
        this(context, null);
    }

    public BottomNewConversationView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public BottomNewConversationView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_new_conversation"), this);
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_new_conversation"));
        aIHelpButton.setText(ResResolver.getString("aihelp_new_conversation"));
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!AppInfoUtil.validateNetwork(BottomNewConversationView.this.getContext()) || BottomNewConversationView.this.mListener == null) {
                    return;
                }
                BottomNewConversationView.this.mListener.onNewConversationStarted();
            }
        });
    }
}
