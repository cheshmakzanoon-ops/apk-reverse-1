package net.aihelp.p007ui.p009cs;

import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.mvp.IPresenter;
import net.aihelp.core.net.mqtt.callback.IMqttCallback;
import net.aihelp.core.p004ui.BaseFragment;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.SearchViewVisibilityChangeEvent;
import net.aihelp.data.event.SupportActionEvent;
import net.aihelp.data.event.UpdateTitleEvent;
import net.aihelp.data.logic.MqttCallbackImpl;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.MessageListAdapter;
import net.aihelp.p007ui.widget.AIHelpChatRecyclerView;
import net.aihelp.utils.KeyboardChangeHelper;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public abstract class BaseCSFragment<P extends IPresenter> extends BaseFragment<P> {
    ViewGroup bottomContainer;
    AppCompatImageButton btnSend;
    EditText etInput;
    private KeyboardChangeHelper helper;
    boolean isAlwaysShowSupportInElva;
    boolean isOperateBot;
    boolean isOperateHuman;
    MessageListAdapter mAdapter;
    private Message mTimeStampMsg;
    IMqttCallback mqttCallback;
    AIHelpChatRecyclerView rvMsgList;
    private String titleIcon;
    private String titleText;

    @Override
    protected boolean isBindEventBus() {
        return true;
    }

    protected void onTextChange(CharSequence charSequence) {
    }

    @Override
    protected void getBundleBeforeDataPrepared(Bundle bundle) {
        this.isOperateBot = bundle.getBoolean(IntentValues.BOT_EMBEDDED_IN_OPERATION, false);
        this.isOperateHuman = bundle.getBoolean(IntentValues.HUMAN_EMBEDDED_IN_OPERATION, false);
        this.titleIcon = CustomConfig.CustomerService.csNavigationBarTitleIcon;
        this.titleText = CustomConfig.CustomerService.csNavigationTitle;
    }

    @Override
    public void onResume() {
        super.onResume();
        EventBus.getDefault().post(new UpdateTitleEvent(1, this.titleIcon, this.titleText));
        EventBus.getDefault().post(new SearchViewVisibilityChangeEvent(false));
    }

    @Override
    protected void initEventAndData(View view) {
        EventBus.getDefault().post(new SupportActionEvent(1002));
        this.mqttCallback = MqttCallbackImpl.getInstance();
        ((ViewGroup) get("aihelp_chat_bottom_layout")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha));
        this.bottomContainer = (ViewGroup) get("aihelp_bottom_container");
        AIHelpChatRecyclerView aIHelpChatRecyclerView = (AIHelpChatRecyclerView) get("aihelp_rv_msg_list");
        this.rvMsgList = aIHelpChatRecyclerView;
        aIHelpChatRecyclerView.setBackgroundColor(0);
        MessageListAdapter messageListAdapter = new MessageListAdapter(getContext(), this);
        this.mAdapter = messageListAdapter;
        this.rvMsgList.setAdapter(messageListAdapter);
        final RecyclerView.LayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        this.rvMsgList.setLayoutManager(linearLayoutManager);
        KeyboardChangeHelper keyboardChangeHelper = new KeyboardChangeHelper(getView());
        this.helper = keyboardChangeHelper;
        keyboardChangeHelper.addListener();
        this.helper.addOnKeyboardShowListener(new KeyboardChangeHelper.OnKeyboardShowListener() {
            @Override
            public void onKeyboardShow() {
                if (!linearLayoutManager.getStackFromEnd() && linearLayoutManager.findFirstCompletelyVisibleItemPosition() > 0) {
                    linearLayoutManager.setStackFromEnd(true);
                }
                BaseCSFragment.this.scrollRecyclerViewToEnd();
            }

            @Override
            public void onKeyboardHide() {
                linearLayoutManager.setStackFromEnd(false);
                BaseCSFragment.this.scrollRecyclerViewToEnd();
            }
        });
    }

    public void updateChatList(Message message) {
        if (message.isEmptyMessage()) {
            return;
        }
        if (CustomConfig.CustomerService.isMessageTimestampVisible && (message.isUserMessage() || message.isAgentMessage())) {
            prepareTimeStamp(message.getTimestamp());
        }
        if (message.isUserMessage()) {
            this.mAdapter.update(message);
            if (message.isDuringRPAProcedure()) {
                this.mAdapter.updateAgentTypingStatus(true);
            }
        } else if (message.isAgentMessage()) {
            if (message.isDuringRPAProcedure()) {
                this.mAdapter.updateAgentTypingStatus(false);
            }
            this.mAdapter.update(message);
        }
        scrollRecyclerViewToEnd();
    }

    public void updateChatList(List<Message> list, boolean z) {
        if (!ListUtil.isListEmpty(list)) {
            for (int size = list.size() - 1; size >= 0; size--) {
                Message message = list.get(size);
                if (message != null && message.isTimeStampMessage()) {
                    this.mTimeStampMsg = message;
                    break;
                }
            }
            Message message2 = list.get(list.size() - 1);
            if (message2 != null && message2.isAgentMessage() && message2.isDuringRPAProcedure()) {
                this.mAdapter.updateAgentTypingStatus(false);
            }
        }
        this.mAdapter.update(list, Boolean.valueOf(z));
        scrollRecyclerViewToEnd();
    }

    protected void scrollRecyclerViewToEnd() {
        this.rvMsgList.post(new Runnable() {
            @Override
            public void run() {
                BaseCSFragment.this.rvMsgList.scrollToPosition(BaseCSFragment.this.mAdapter.getItemCount() - 1);
            }
        });
    }

    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        if (this.rvMsgList != null) {
            SoftInputUtil.hideSoftInput(getContext(), this.rvMsgList);
            this.rvMsgList.setBackgroundColor(0);
            MessageListAdapter messageListAdapter = this.mAdapter;
            if (messageListAdapter != null) {
                messageListAdapter.notifyDataSetChanged();
            }
        }
    }

    public void onDestroy() {
        super.onDestroy();
        KeyboardChangeHelper keyboardChangeHelper = this.helper;
        if (keyboardChangeHelper != null) {
            keyboardChangeHelper.removeListener();
        }
    }

    private void prepareTimeStamp(long j) {
        Message message = this.mTimeStampMsg;
        if (message == null || j - Long.parseLong(message.getContent()) > 300000) {
            Message message2 = new Message(1);
            this.mTimeStampMsg = message2;
            message2.setTimestamp(j - 1);
            this.mTimeStampMsg.setContent(String.valueOf(j));
            this.mAdapter.update(this.mTimeStampMsg);
        }
    }
}
