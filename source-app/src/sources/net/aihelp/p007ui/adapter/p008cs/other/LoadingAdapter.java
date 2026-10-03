package net.aihelp.p007ui.adapter.p008cs.other;

import android.content.Context;
import android.widget.LinearLayout;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.utils.ResResolver;

public class LoadingAdapter extends BaseMsgAdapter {
    public LoadingAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_typing");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 2;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        ((LinearLayout) viewHolder.getView(getViewId("aihelp_typing_container"))).setBackground(getAdminBackgroundDrawable(this.isCurrentRtl));
    }
}
