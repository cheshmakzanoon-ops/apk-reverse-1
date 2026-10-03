package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import androidx.recyclerview.widget.RecyclerView;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.HideAttachmentMenuEvent;
import net.aihelp.utils.KeyboardChangeHelper;
import net.aihelp.utils.SoftInputUtil;

public class AIHelpChatRecyclerView extends RecyclerView {
    public AIHelpChatRecyclerView(Context context) {
        super(context);
    }

    public AIHelpChatRecyclerView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public AIHelpChatRecyclerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        if (motionEvent.getAction() == 0) {
            EventBus.getDefault().post(new HideAttachmentMenuEvent());
            if (KeyboardChangeHelper.isKeyboardShown(this)) {
                SoftInputUtil.hideSoftInput(getContext(), this);
            }
        }
        return super.dispatchTouchEvent(motionEvent);
    }
}
