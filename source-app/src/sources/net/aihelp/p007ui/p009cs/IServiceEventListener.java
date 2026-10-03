package net.aihelp.p007ui.p009cs;

import androidx.fragment.app.Fragment;
import net.aihelp.data.model.rpa.msg.base.Message;

public interface IServiceEventListener {
    Fragment getHostFragment();

    void onMiddleHandlerViewVisibilityChanged();

    void onNewConversationStarted();

    void onTicketFinished(int i);

    void onUserAction(Message message);

    void onUserGoBack();

    void scrollBy(int i);

    void scrollToBottom();
}
