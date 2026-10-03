package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import androidx.appcompat.widget.AppCompatImageView;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpMsgView extends RelativeLayout {
    private AppCompatImageView ivRight;
    private View unreadDot;

    public AIHelpMsgView(Context context) {
        this(context, null);
    }

    public AIHelpMsgView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpMsgView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View viewInflate = View.inflate(context, ResResolver.getLayoutId("aihelp_layout_msg_view"), this);
        this.ivRight = viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_right"));
        this.unreadDot = viewInflate.findViewById(ResResolver.getViewId("aihelp_v_unread_status"));
    }

    protected int dip2px(Context context, double d) {
        return (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
    }

    public void updateImageResource(int i, String str) {
        this.unreadDot.setVisibility(i == 1007 ? 0 : 8);
        if (i == 1005) {
            Styles.reRenderImageView(this.ivRight, str);
        } else {
            Styles.reRenderImageView(this.ivRight, str);
        }
    }
}
