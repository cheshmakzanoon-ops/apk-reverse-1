package net.aihelp.p007ui.adapter.p008cs.user;

import android.content.Context;
import android.widget.ImageView;
import androidx.appcompat.widget.AppCompatImageButton;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class UserEvaluateFaqAdapter extends BaseMsgAdapter {
    public UserEvaluateFaqAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_user_evaluate_faq");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 13;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csUserPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_user");
        ImageView imageView = (ImageView) viewHolder.getView(getViewId("aihelp_iv_un_helpful"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_un_helpful");
        imageView.setVisibility(":aihelp-faq-unhelpful:".equals(message.getContent()) ? 0 : 8);
        ImageView imageView2 = (ImageView) viewHolder.getView(getViewId("aihelp_iv_helpful"));
        Styles.reRenderImageView(imageView2, "aihelp_svg_ic_helpful");
        imageView2.setVisibility(":aihelp-faq-helpful:".equals(message.getContent()) ? 0 : 8);
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
}
