package net.aihelp.p007ui.adapter.p008cs.user;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.appcompat.widget.AppCompatImageButton;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.widget.AIHelpMovementMethod;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class UserTextAdapter extends BaseMsgAdapter {
    public UserTextAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_user");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 10;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csUserPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_user");
        TextView textView = (TextView) viewHolder.getView(getViewId("aihelp_user_message_text"));
        textView.setText(getUrlSupportedText(message.getContent(), CustomConfig.CommonSetting.highlightedColor));
        textView.setTextColor(-1);
        textView.setMovementMethod(new AIHelpMovementMethod());
        textView.setMaxWidth(Math.max(getRightfulMaxWidth(viewHolder), dip2px(this.mContext, 200.0d)));
        textView.setBackground(getUserBackgroundDrawable(this.isCurrentRtl));
        AppCompatImageButton view = viewHolder.getView(getViewId("aihelp_iv_msg_retry"));
        int msgStatus = message.getMsgStatus();
        if (msgStatus == 1 || msgStatus == 2) {
            view.setVisibility(8);
        } else {
            if (msgStatus != 3) {
                return;
            }
            view.setVisibility(0);
            view.setImageResource(ResResolver.getDrawableId("aihelp_svg_iv_msg_retry"));
            view.setOnClickListener(getRetryListener(i, message));
        }
    }

    private int getRightfulMaxWidth(ViewHolder viewHolder) {
        return Styles.getScreenWidth(this.mContext) - (((dip2px(this.mContext, 39.0d) + ((ViewGroup.MarginLayoutParams) ((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait"))).getLayoutParams()).rightMargin) + ((ViewGroup.MarginLayoutParams) ((TextView) viewHolder.getView(getViewId("aihelp_user_message_text"))).getLayoutParams()).rightMargin) * 2);
    }

    private Drawable getUserBackgroundDrawable(boolean z) {
        int color = Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor);
        if (z) {
            return Styles.getDrawableWithCorner(color, 0, 15, 15, 15);
        }
        return Styles.getDrawableWithCorner(color, 15, 0, 15, 15);
    }
}
