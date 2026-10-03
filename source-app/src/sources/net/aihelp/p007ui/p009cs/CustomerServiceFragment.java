package net.aihelp.p007ui.p009cs;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.net.monitor.NetworkMonitor;
import net.aihelp.core.net.monitor.NetworkState;
import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.config.MqttConfig;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.core.util.permission.IPermissionCallback;
import net.aihelp.core.util.permission.Permission;
import net.aihelp.data.attachment.AttachmentPicker;
import net.aihelp.data.event.PageHoppingEvent;
import net.aihelp.data.logic.CustomerServicePresenter;
import net.aihelp.data.logic.MessagePoller;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.MessageListAdapter;
import net.aihelp.p007ui.p009cs.bottom.BottomActionPickerView;
import net.aihelp.p007ui.p009cs.bottom.BottomAttachmentView;
import net.aihelp.p007ui.p009cs.bottom.BottomBaseView;
import net.aihelp.p007ui.p009cs.bottom.BottomBotInputView;
import net.aihelp.p007ui.p009cs.bottom.BottomDatePickerView;
import net.aihelp.p007ui.p009cs.bottom.BottomEvaluateFaqView;
import net.aihelp.p007ui.p009cs.bottom.BottomEvaluateServiceView;
import net.aihelp.p007ui.p009cs.bottom.BottomFillFormView;
import net.aihelp.p007ui.p009cs.bottom.BottomManualInputView;
import net.aihelp.p007ui.p009cs.bottom.BottomNewConversationView;
import net.aihelp.p007ui.p009cs.bottom.BottomSelfServiceView;
import net.aihelp.p007ui.p009cs.middle.MiddleHandlerView;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.p009cs.util.rpa.factory.UserMessageFactory;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import net.aihelp.utils.ToastUtil;

public class CustomerServiceFragment extends BaseCSFragment<CustomerServicePresenter> implements IServiceEventListener {
    private BottomBaseView bottomBaseView = null;
    private boolean isTicketAlreadyFinished;
    private RPAStep mCurrentStep;
    private MiddleHandlerView mHandlerView;
    private SwipeRefreshLayout mRefreshLayout;
    private boolean shouldRefreshSkipView;

    @Override
    public Fragment getHostFragment() {
        return this;
    }

    public static CustomerServiceFragment newInstance(Bundle bundle) {
        CustomerServiceFragment customerServiceFragment = new CustomerServiceFragment();
        customerServiceFragment.setArguments(bundle);
        return customerServiceFragment;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (this.shouldRefreshSkipView) {
            scrollRecyclerViewToEnd();
            this.mHandlerView.updateViewVisibility(this.mCurrentStep);
        }
    }

    @Override
    protected void initEventAndData(View view) {
        super.initEventAndData(view);
        MiddleHandlerView middleHandlerView = (MiddleHandlerView) get("aihelp_middle_view");
        this.mHandlerView = middleHandlerView;
        middleHandlerView.setServiceEventListener(this);
        SwipeRefreshLayout swipeRefreshLayout = get("aihelp_refresh_layout");
        this.mRefreshLayout = swipeRefreshLayout;
        swipeRefreshLayout.setEnabled(CustomConfig.CustomerService.isHistoryChatEnable);
        this.mRefreshLayout.setColorSchemeColors(new int[]{Styles.getColor(CustomConfig.CommonSetting.interactElementTextColor)});
        if (CustomConfig.CustomerService.isHistoryChatEnable) {
            this.mRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
                public void onRefresh() {
                    ((CustomerServicePresenter) CustomerServiceFragment.this.mPresenter).getLastConversation();
                }
            });
        }
        this.mAdapter.setOnClickedListener(new MessageListAdapter.OnClickedListenerWrapper() {
            @Override
            public void onUrlClicked(boolean z, String str) {
                super.onUrlClicked(z, str);
                Bundle bundle = new Bundle();
                bundle.putString(IntentValues.INTENT_URL, str);
                EventBus.getDefault().post(new PageHoppingEvent(1009, bundle));
            }

            @Override
            public void onBotAnswerSelected(Message message) {
                CustomerServiceFragment.this.onUserAction(message);
            }

            @Override
            public void onRetrySendingMessage(int i, Message message) {
                if (AppInfoUtil.validateNetwork(CustomerServiceFragment.this.getContext())) {
                    if (CustomerServiceFragment.this.isTicketAlreadyFinished) {
                        ToastUtil.INSTANCE.makeRawToast(CustomerServiceFragment.this.getContext(), ResResolver.getString("aihelp_ticket_closed"));
                        return;
                    }
                    if (message.getMsgStatus() != 3) {
                        CustomerServiceFragment.this.mAdapter.remove(i);
                    }
                    CustomerServiceFragment.this.onUserAction(message);
                }
            }
        });
        this.mqttCallback.showMqttLoading();
        ((CustomerServicePresenter) this.mPresenter).requestLogin();
        ((CustomerServicePresenter) this.mPresenter).refreshUnreadMessageCount();
    }

    public void prepareMqtt(int i) {
        this.mqttCallback.updateHostView(this);
        ((CustomerServicePresenter) this.mPresenter).prepareMqtt(this.mqttCallback, i);
    }

    public void onLogin(List<Message> list, Message message, RPAStep rPAStep) {
        updateChatList(list, true);
        updateBottomLayout(message, rPAStep);
        MessagePoller.INSTANCE.startMessagePolling(this);
        prepareMqtt(1);
    }

    public void onFormSubmitted(String str) {
        this.shouldRefreshSkipView = true;
        updateChatList(UserMessageFactory.getUserFormMsgList(str), false);
        if (TicketStatusTracker.isTicketActive || (this.bottomContainer.getChildAt(0) instanceof BottomManualInputView)) {
            return;
        }
        RPAStep rPAStep = new RPAStep();
        rPAStep.setNextStep(100);
        updateBottomLayout(new Message(), rPAStep);
    }

    public void onLastConversationRetrieved(List<Message> list) {
        this.mRefreshLayout.setRefreshing(false);
        if (ListUtil.isListEmpty(list)) {
            return;
        }
        this.mAdapter.insertHistoryConversation(list);
        LinearLayoutManager layoutManager = this.rvMsgList.getLayoutManager();
        if (layoutManager instanceof LinearLayoutManager) {
            this.rvMsgList.scrollToPosition((list.size() - 1) + layoutManager.findLastVisibleItemPosition());
            this.rvMsgList.smoothScrollBy(0, -100);
        }
    }

    public void onTicketFinishedOrRejected() {
        this.isTicketAlreadyFinished = true;
        RPAStep rPAStep = new RPAStep();
        if (TicketStatusTracker.isTicketFinished) {
            if (TicketStatusTracker.isTicketWaitForAskingResolveStatus || TicketStatusTracker.isTicketWaitForRating) {
                rPAStep.setNextStep(101);
            } else {
                rPAStep.setNextStep(102);
            }
        } else if (TicketStatusTracker.isTicketRejected) {
            rPAStep.setNextStep(102);
        }
        updateBottomLayout(new Message(), rPAStep);
        this.mHandlerView.setVisibility(8);
        this.mAdapter.updateAgentTypingStatus(false);
    }

    public void onTicketAssignStatusChanged() {
        this.shouldRefreshSkipView = true;
        this.mHandlerView.updateViewVisibility(null);
    }

    @Override
    public void onUserAction(Message message) {
        this.mHandlerView.setVisibility(8);
        if (!(message instanceof FileMessage) || message.getMsgStatus() == 2) {
            updateChatList(message);
        } else {
            updateMessageStatus(message.getMsgStatus() == 1, message.getTimestamp(), message.getTimestamp());
        }
        if (message.getMsgStatus() == 1) {
            ((CustomerServicePresenter) this.mPresenter).chatWithSupport(message.getTimestamp(), message.getRequestParams());
        }
        if (message.isDuringRPAProcedure()) {
            this.bottomContainer.removeAllViews();
        }
    }

    @Override
    public void onUserGoBack() {
        this.mHandlerView.setVisibility(8);
        this.bottomContainer.removeAllViews();
        ((CustomerServicePresenter) this.mPresenter).goBackToPreviousStep();
    }

    @Override
    public void onTicketFinished(int i) {
        this.isTicketAlreadyFinished = true;
        RPAStep rPAStep = new RPAStep();
        rPAStep.setNextStep(i);
        updateBottomLayout(new Message(), rPAStep);
    }

    @Override
    public void onNewConversationStarted() {
        this.isTicketAlreadyFinished = false;
        ((CustomerServicePresenter) this.mPresenter).logout();
        ((CustomerServicePresenter) this.mPresenter).requestLogin();
    }

    public void updateMessageStatus(boolean z, long j, long j2) {
        for (int size = this.mAdapter.getDataList().size() - 1; size >= 0; size--) {
            Message message = this.mAdapter.getDataList().get(size);
            if (message.getTimestamp() == j) {
                message.setTimestamp(j2);
                message.setMsgStatus(z ? 1 : 3);
                this.mAdapter.notifyItemChanged(size);
                if (z) {
                    return;
                }
                this.mAdapter.updateAgentTypingStatus(false);
                return;
            }
        }
    }

    public void notifyMessageWithdrawn(long j, long j2) {
        for (int size = this.mAdapter.getDataList().size() - 1; size >= 0; size--) {
            Message message = this.mAdapter.getDataList().get(size);
            if (message.getTimestamp() >= j && message.getTimestamp() <= j2) {
                this.mAdapter.remove(size);
                ((CustomerServicePresenter) this.mPresenter).updateCachedUnreadMessageCount(message.isAgentMessage(), true);
                if (j == j2) {
                    return;
                }
            }
        }
    }

    public void notifyMessageWithdrawn(long j) {
        notifyMessageWithdrawn(j, j);
    }

    @Override
    public void updateChatList(Message message) {
        super.updateChatList(message);
        updateCacheUnreadMessageCount(message);
    }

    @Override
    public void updateChatList(List<Message> list, boolean z) {
        super.updateChatList(list, z);
        if (z) {
            return;
        }
        for (int i = 0; i < list.size(); i++) {
            updateCacheUnreadMessageCount(list.get(i));
        }
    }

    private void updateCacheUnreadMessageCount(Message message) {
        if (message != null) {
            ((CustomerServicePresenter) this.mPresenter).updateCachedUnreadMessageCount(message.isAgentMessage(), false);
        }
    }

    @Override
    @NetworkMonitor
    public void onNetworkStateChanged(NetworkState networkState) {
        if (networkState == NetworkState.NONE || MqttConfig.getInstance().isConnected()) {
            return;
        }
        AIHelpMqtt.getInstance().prepare(this.mqttCallback, 2);
    }

    public void updateBottomLayout(Message message, RPAStep rPAStep) {
        updateBottomLayout(message, rPAStep, true);
    }

    public void updateBottomLayout(Message message, RPAStep rPAStep, boolean z) {
        List<Faq.FaqData> faqDataList;
        this.mHandlerView.updateViewVisibility(rPAStep);
        this.mCurrentStep = rPAStep;
        this.bottomBaseView = null;
        Bundle bundle = new Bundle();
        int nextStep = rPAStep.getNextStep();
        switch (nextStep) {
            case 1:
            case 2:
            case 3:
                this.bottomBaseView = new BottomBotInputView(getContext());
                break;
            case 4:
                this.bottomBaseView = new BottomActionPickerView(getContext());
                break;
            case 5:
                this.bottomBaseView = new BottomDatePickerView(getContext());
                break;
            case 6:
                this.bottomBaseView = new BottomAttachmentView(getContext());
                break;
            case 7:
                if (!(message instanceof BotMessage)) {
                    this.bottomBaseView = new BottomBotInputView(getContext());
                } else {
                    BotMessage botMessage = (BotMessage) message;
                    if (botMessage.hasFormUrl()) {
                        bundle.putString(IntentValues.INTENT_URL, botMessage.getFormUrl().getLink());
                        this.bottomBaseView = new BottomFillFormView(getContext());
                    } else {
                        this.bottomBaseView = new BottomBotInputView(getContext());
                    }
                }
                break;
            case 8:
                if (!(message instanceof BotMessage)) {
                    this.bottomBaseView = new BottomBotInputView(getContext());
                } else {
                    BotMessage botMessage2 = (BotMessage) message;
                    if (botMessage2.hasSelfService()) {
                        bundle.putParcelable(IntentValues.BOTTOM_SELF_SERVICE, botMessage2.getSelfService());
                        this.bottomBaseView = new BottomSelfServiceView(getContext());
                    } else {
                        this.bottomBaseView = new BottomBotInputView(getContext());
                    }
                }
                break;
            case 9:
                if (message instanceof BotMessage) {
                    BotMessage botMessage3 = (BotMessage) message;
                    if (botMessage3.hasFaq() && (faqDataList = botMessage3.getFaq().getFaqDataList()) != null && faqDataList.size() == 1) {
                        bundle.putLong(IntentValues.BOTTOM_FAQ_CONTENT_ID, faqDataList.get(0).getContentId());
                    }
                }
                this.bottomBaseView = new BottomEvaluateFaqView(getContext());
                break;
            default:
                switch (nextStep) {
                    case 100:
                        bundle.putBoolean(IntentValues.BOTTOM_TICKET_FINISHED, this.isTicketAlreadyFinished);
                        bundle.putBoolean(IntentValues.BOTTOM_DURING_PROCEDURE, false);
                        this.bottomBaseView = new BottomManualInputView(getContext());
                        break;
                    case 101:
                        this.bottomBaseView = new BottomEvaluateServiceView(getContext());
                        break;
                    case 102:
                        this.bottomBaseView = new BottomNewConversationView(getContext());
                        break;
                }
                break;
        }
        BottomBaseView bottomBaseView = this.bottomBaseView;
        if (bottomBaseView != null && !isBottomViewAlreadyAdded(bottomBaseView, bundle, rPAStep)) {
            if (TicketStatusTracker.isTicketServingByRPA() || TicketStatusTracker.isTicketServingByAgent()) {
                this.mAdapter.updateAgentTypingStatus(false);
            }
            this.bottomBaseView.setBottomViewEventListener(bundle, rPAStep, this);
            this.bottomBaseView.setActivity(getActivity());
            this.bottomContainer.removeAllViews();
            this.bottomContainer.addView(this.bottomBaseView);
        }
        if (z) {
            scrollRecyclerViewToEnd();
        }
    }

    private boolean isBottomViewAlreadyAdded(BottomBaseView bottomBaseView, Bundle bundle, RPAStep rPAStep) {
        if (bottomBaseView != null) {
            String simpleName = bottomBaseView.getClass().getSimpleName();
            BottomBaseView bottomBaseView2 = (BottomBaseView) this.bottomContainer.getChildAt(0);
            if (bottomBaseView2 != null && simpleName.equals(bottomBaseView2.getClass().getSimpleName())) {
                bottomBaseView2.setBottomViewEventListener(bundle, rPAStep, this);
                this.bottomBaseView = bottomBaseView2;
                return true;
            }
        }
        return false;
    }

    public long getLastAgentMessageTimestamp() {
        List<Message> dataList = this.mAdapter.getDataList();
        for (int size = dataList.size() - 1; size >= 0; size--) {
            Message message = dataList.get(size);
            if (message.isAgentMessage()) {
                return message.getTimestamp();
            }
        }
        return System.currentTimeMillis();
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_customer_service");
    }

    @Override
    protected int getLoadingTargetViewId() {
        return ResResolver.getViewId("aihelp_customer_service_root");
    }

    @Override
    public void scrollToBottom() {
        scrollRecyclerViewToEnd();
    }

    @Override
    public void scrollBy(int i) {
        this.rvMsgList.scrollBy(0, i);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (this.mPresenter != 0) {
            ((CustomerServicePresenter) this.mPresenter).logout();
        }
        AIHelpMqtt.getInstance().disconnect();
        MessagePoller.INSTANCE.stopMessagePolling();
        AIHelpEventTracker.getInstance().calculateDurationInCustomerService();
    }

    @Override
    public void onMiddleHandlerViewVisibilityChanged() {
        MiddleHandlerView middleHandlerView = this.mHandlerView;
        int iDpToPx = Styles.dpToPx(getContext(), middleHandlerView != null && middleHandlerView.isVisible() ? 45.0f : 0.0f);
        ViewGroup.LayoutParams layoutParams = this.mRefreshLayout.getLayoutParams();
        if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
            if (marginLayoutParams.bottomMargin != iDpToPx) {
                marginLayoutParams.bottomMargin = iDpToPx;
                this.mRefreshLayout.setLayoutParams(marginLayoutParams);
                scrollRecyclerViewToEnd();
            }
        }
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        AIHelpPermissions.getInstance().onRequestPermissionsResult(strArr, iArr);
    }

    static class C07345 {
        static final int[] $SwitchMap$net$aihelp$core$util$permission$Permission$Result;

        static {
            int[] iArr = new int[Permission.Result.values().length];
            $SwitchMap$net$aihelp$core$util$permission$Permission$Result = iArr;
            try {
                iArr[Permission.Result.GRANTED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.NONE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.DENIED.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.RATIONAL.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.GO_SETTING.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
        }
    }

    @Permission(requestCode = 1000)
    public void onPermissionRequested(Permission.Result result, final IPermissionCallback iPermissionCallback, int i) {
        int i2 = C07345.$SwitchMap$net$aihelp$core$util$permission$Permission$Result[result.ordinal()];
        if (i2 == 1 || i2 == 2) {
            AttachmentPicker.INSTANCE.setPickerHost(this).setAttachmentPickerListener(this.bottomBaseView).launchPicker(i);
            return;
        }
        if (i2 == 3) {
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_denied"), 0);
        } else if (i2 == 4) {
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_denied"), ResResolver.getString("aihelp_yes"), 0, new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    iPermissionCallback.onPermissionRational();
                }
            });
        } else {
            if (i2 != 5) {
                return;
            }
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_ignored"), ResResolver.getString("aihelp_permission_settings"), 0, new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    iPermissionCallback.onPermissionIgnored();
                }
            });
        }
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
        AttachmentPicker.INSTANCE.onAttachmentRequestResult(i, i2, intent);
    }
}
