package net.aihelp.p007ui.adapter.p008cs.other;

import android.content.Context;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.utils.ResResolver;

public class ErrorBoundaryAdapter extends BaseMsgAdapter {
    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return false;
    }

    public ErrorBoundaryAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_error_boundary");
    }
}
