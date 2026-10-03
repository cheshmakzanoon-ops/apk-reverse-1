package net.aihelp.p007ui.adapter;

import android.content.Context;
import androidx.fragment.app.Fragment;
import java.util.Iterator;
import java.util.List;
import net.aihelp.core.p004ui.adapter.MultiItemTypeAdapter;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentAnswerAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentFaqAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentFileAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentImageAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentRichTextAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentTextAdapter;
import net.aihelp.p007ui.adapter.p008cs.agent.AgentVideoAdapter;
import net.aihelp.p007ui.adapter.p008cs.other.ErrorBoundaryAdapter;
import net.aihelp.p007ui.adapter.p008cs.other.LoadingAdapter;
import net.aihelp.p007ui.adapter.p008cs.other.TimeMsgAdapter;
import net.aihelp.p007ui.adapter.p008cs.user.UserEvaluateFaqAdapter;
import net.aihelp.p007ui.adapter.p008cs.user.UserFileAdapter;
import net.aihelp.p007ui.adapter.p008cs.user.UserImageAdapter;
import net.aihelp.p007ui.adapter.p008cs.user.UserTextAdapter;
import net.aihelp.p007ui.adapter.p008cs.user.UserVideoAdapter;
import net.aihelp.utils.ListUtil;

public class MessageListAdapter extends MultiItemTypeAdapter<Message> {
    private final AgentTextAdapter adminAdapter;
    private final AgentFaqAdapter agentFaqAdapter;
    private final AgentRichTextAdapter agentRichTextAdapter;
    private final AgentAnswerAdapter answerFaqAdapter;
    private StringBuilder timestampTracker;
    private final UserTextAdapter userAdapter;
    private final UserFileAdapter userFileAdapter;
    private final UserImageAdapter userImageAdapter;
    private final UserVideoAdapter userVideoAdapter;

    private interface OnTextClickedListener {
        void onBotAnswerSelected(Message message);

        void onRetrySendingMessage(int i, Message message);

        void onUrlClicked(boolean z, String str);
    }

    public MessageListAdapter(Context context, Fragment fragment) {
        super(context);
        this.timestampTracker = new StringBuilder();
        AgentTextAdapter agentTextAdapter = new AgentTextAdapter(context);
        this.adminAdapter = agentTextAdapter;
        addItemViewDelegate(agentTextAdapter);
        AgentRichTextAdapter agentRichTextAdapter = new AgentRichTextAdapter(context, fragment);
        this.agentRichTextAdapter = agentRichTextAdapter;
        addItemViewDelegate(agentRichTextAdapter);
        AgentFaqAdapter agentFaqAdapter = new AgentFaqAdapter(context);
        this.agentFaqAdapter = agentFaqAdapter;
        addItemViewDelegate(agentFaqAdapter);
        AgentAnswerAdapter agentAnswerAdapter = new AgentAnswerAdapter(context);
        this.answerFaqAdapter = agentAnswerAdapter;
        addItemViewDelegate(agentAnswerAdapter);
        addItemViewDelegate(new AgentImageAdapter(context, fragment));
        addItemViewDelegate(new AgentVideoAdapter(context, fragment));
        addItemViewDelegate(new AgentFileAdapter(context, fragment));
        UserTextAdapter userTextAdapter = new UserTextAdapter(context);
        this.userAdapter = userTextAdapter;
        addItemViewDelegate(userTextAdapter);
        UserImageAdapter userImageAdapter = new UserImageAdapter(context, fragment);
        this.userImageAdapter = userImageAdapter;
        addItemViewDelegate(userImageAdapter);
        UserVideoAdapter userVideoAdapter = new UserVideoAdapter(context, fragment);
        this.userVideoAdapter = userVideoAdapter;
        addItemViewDelegate(userVideoAdapter);
        addItemViewDelegate(new UserEvaluateFaqAdapter(context));
        UserFileAdapter userFileAdapter = new UserFileAdapter(context, fragment);
        this.userFileAdapter = userFileAdapter;
        addItemViewDelegate(userFileAdapter);
        addItemViewDelegate(new TimeMsgAdapter(context));
        addItemViewDelegate(new LoadingAdapter(context));
        addItemViewDelegate(-1, new ErrorBoundaryAdapter(context));
    }

    public void insertHistoryConversation(List<Message> list) {
        this.mDatas.addAll(0, list);
        notifyDataSetChanged();
    }

    public void updateAgentTypingStatus(boolean z) {
        if (z) {
            update(Message.getAgentTypingMsg());
            return;
        }
        for (int itemCount = getItemCount() - 1; itemCount >= 0; itemCount--) {
            if (((Message) this.mDatas.get(itemCount)).getMsgType() == 2) {
                AIHelpEventTracker.getInstance().calculateDurationForWaiting();
                remove(itemCount);
                return;
            }
        }
    }

    @Override
    public void update(Message message) {
        if (isMessageAlreadyInserted(message)) {
            return;
        }
        super.update(message);
    }

    @Override
    public void update(List<Message> list, Boolean bool) {
        if (ListUtil.isListEmpty(list)) {
            return;
        }
        if (bool.booleanValue()) {
            this.timestampTracker = new StringBuilder();
        }
        Iterator<Message> it = list.iterator();
        while (it.hasNext()) {
            if (isMessageAlreadyInserted(it.next())) {
                it.remove();
            }
        }
        super.update(list, bool);
    }

    private boolean isMessageAlreadyInserted(Message message) {
        if (this.timestampTracker == null) {
            this.timestampTracker = new StringBuilder();
        }
        String strValueOf = String.valueOf(message.getTimestamp());
        if (this.timestampTracker.toString().contains(strValueOf)) {
            return true;
        }
        this.timestampTracker.append(String.format("%s,", strValueOf));
        return false;
    }

    public void setOnClickedListener(OnClickedListenerWrapper onClickedListenerWrapper) {
        AgentTextAdapter agentTextAdapter = this.adminAdapter;
        if (agentTextAdapter != null) {
            agentTextAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        AgentRichTextAdapter agentRichTextAdapter = this.agentRichTextAdapter;
        if (agentRichTextAdapter != null) {
            agentRichTextAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        AgentFaqAdapter agentFaqAdapter = this.agentFaqAdapter;
        if (agentFaqAdapter != null) {
            agentFaqAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        AgentAnswerAdapter agentAnswerAdapter = this.answerFaqAdapter;
        if (agentAnswerAdapter != null) {
            agentAnswerAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        UserTextAdapter userTextAdapter = this.userAdapter;
        if (userTextAdapter != null) {
            userTextAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        UserImageAdapter userImageAdapter = this.userImageAdapter;
        if (userImageAdapter != null) {
            userImageAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        UserVideoAdapter userVideoAdapter = this.userVideoAdapter;
        if (userVideoAdapter != null) {
            userVideoAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
        UserFileAdapter userFileAdapter = this.userFileAdapter;
        if (userFileAdapter != null) {
            userFileAdapter.setOnClickedListenerWrapper(onClickedListenerWrapper);
        }
    }

    public static class OnClickedListenerWrapper implements OnTextClickedListener {
        @Override
        public void onBotAnswerSelected(Message message) {
        }

        @Override
        public void onRetrySendingMessage(int i, Message message) {
        }

        @Override
        public void onUrlClicked(boolean z, String str) {
            if (z) {
                AIHelpEventTracker.getInstance().onFormClicked(str);
            }
        }
    }
}
