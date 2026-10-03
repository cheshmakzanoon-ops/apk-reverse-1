package net.aihelp.data.logic;

import android.os.Handler;
import android.os.Message;
import net.aihelp.common.Const;
import net.aihelp.common.SpKeys;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.TLog;
import zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents;

public class UnreadMessagePoller extends Handler {
    private static final int POLL_UNREAD_MESSAGE = 100;

    public void start() {
        stop();
        sendEmptyMessage(100);
    }

    public void stop() {
        removeCallbacksAndMessages(null);
    }

    @Override
    public void handleMessage(Message message) {
        if (isPollingEnable()) {
            fetchUnreadMessageCount();
        }
        sendEmptyMessageDelayed(100, getPollingLimit());
    }

    private void fetchUnreadMessageCount() {
        if (interceptFetchRequest()) {
            return;
        }
        UnreadFetchHelper.fetchUnreadMessageCount(new UnreadFetchHelper.Callback() {
            @Override
            public void onFetched(int i, int i2) {
                UnreadFetchHelper.onMessageCountArrived(i2);
            }
        });
    }

    private boolean interceptFetchRequest() {
        if (Const.IS_SDK_SHOWING) {
            TLog.m139d("AIHelp", "AIHelp session is visible to user, do not need fetch for unread messages.");
            return true;
        }
        if (!Const.TOGGLE_FETCH_MESSAGE) {
            TLog.m139d("AIHelp", String.format("Current user(%s) does not have any active tickets at present.", UserProfile.USER_ID));
            return true;
        }
        if (UserProfile.USER_ID.equals(DeviceUuidFactory.m137id(AIHelpContext.getInstance().getContext()))) {
            TLog.m139d("AIHelp", "The userId you're using for unread message polling is AIHelp's generated deviceId, please verify if this is what you want.");
        }
        return false;
    }

    private long getPollingLimit() {
        if (SpUtil.getInstance().getBoolean(SpKeys.TOGGLE_LOG)) {
            return ConversationTypingEvents.TIME_INTERVAL_IN_MILLIS;
        }
        if (isPollingEnable()) {
            return ((long) Const.LIMIT_CHECKING_UNREAD) * 1000;
        }
        return 300000L;
    }

    private boolean isPollingEnable() {
        return Const.TOGGLE_OPEN_UNREAD_MSG && Const.LIMIT_CHECKING_UNREAD > 0;
    }
}
