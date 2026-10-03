package net.aihelp.p007ui.adapter.p008cs.other;

import android.content.Context;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.utils.DateFormatUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class TimeMsgAdapter extends BaseMsgAdapter {
    public TimeMsgAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_hint");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 1;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        TextView textView = (TextView) viewHolder.getConvertView();
        textView.setText(DateFormatUtil.getProperDate(this.mContext.getResources(), Long.parseLong(message.getContent())));
        textView.setTextColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.699999988079071d));
    }
}
