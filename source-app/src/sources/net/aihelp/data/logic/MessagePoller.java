package net.aihelp.data.logic;

import androidx.fragment.app.Fragment;
import java.lang.ref.WeakReference;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import net.aihelp.common.API;
import net.aihelp.common.SpKeys;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.mqtt.config.MqttConfig;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.p007ui.p009cs.CustomerServiceFragment;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.p009cs.util.rpa.helper.ResponseHelper;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.SpUtil;
import org.json.JSONObject;

public enum MessagePoller {
    INSTANCE;

    public static final int POLL_SOURCE_FAILURE = 2;
    public static final int POLL_SOURCE_LOGIN = 1;
    public static final int POLL_SOURCE_RECONNECT = 3;
    public static final int POLL_SOURCE_SCHEDULER = 4;
    private WeakReference<CustomerServiceFragment> csFragment;
    private ScheduledFuture<?> newMessageFetcher;

    public void startMessagePolling(Fragment fragment) {
        if (fragment instanceof CustomerServiceFragment) {
            this.csFragment = new WeakReference<>((CustomerServiceFragment) fragment);
        }
        if (SpUtil.getInstance().getBoolean(SpKeys.TOGGLE_LOG)) {
            TicketStatusTracker.ticketPollInterval = 10;
        }
        if (this.newMessageFetcher == null) {
            this.newMessageFetcher = Executors.newScheduledThreadPool(1).scheduleAtFixedRate(new Runnable() {
                @Override
                public void run() {
                    if (MqttConfig.getInstance().isConnected()) {
                        return;
                    }
                    MessagePoller.this.fetchMessagesSinceLatest(4);
                }
            }, TicketStatusTracker.ticketPollInterval, TicketStatusTracker.ticketPollInterval, TimeUnit.SECONDS);
        }
    }

    public void stopMessagePolling() {
        ScheduledFuture<?> scheduledFuture = this.newMessageFetcher;
        if (scheduledFuture != null) {
            scheduledFuture.cancel(true);
            this.newMessageFetcher = null;
        }
    }

    public void fetchMessagesSinceLatest(int i) {
        try {
            WeakReference<CustomerServiceFragment> weakReference = this.csFragment;
            if (weakReference == null || weakReference.get() == null) {
                return;
            }
            final CustomerServiceFragment customerServiceFragment = this.csFragment.get();
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("messageTime", customerServiceFragment.getLastAgentMessageTimestamp());
            jSONObject.put("pollSource", i);
            AIHelpRequest.getInstance().requestGetByAsync(API.POLL_MESSAGE_AFTER_MQTT_DISCONNECT, jSONObject, new ReqCallback<String>() {
                @Override
                public void onReqSuccess(String str) {
                    List<Message> pollResponse = ResponseHelper.getPollResponse(str);
                    Message rPAMessage = ResponseHelper.getRPAMessage(str);
                    RPAStep rPAStep = ResponseHelper.getRPAStep(str);
                    if (TicketStatusTracker.isTicketFinished) {
                        rPAStep = new RPAStep();
                        if (TicketStatusTracker.isTicketWaitForAskingResolveStatus || TicketStatusTracker.isTicketWaitForRating) {
                            rPAStep.setNextStep(101);
                        } else {
                            rPAStep.setNextStep(102);
                        }
                    } else if (TicketStatusTracker.isTicketActive && TicketStatusTracker.isTicketServingByAgent()) {
                        rPAStep.setNextStep(100);
                    } else if (TicketStatusTracker.isTicketRejected) {
                        rPAStep.setNextStep(102);
                    }
                    if (!ListUtil.isListEmpty(pollResponse)) {
                        customerServiceFragment.updateChatList(pollResponse, false);
                    }
                    if (TicketStatusTracker.isTicketServingByAnswerBot()) {
                        return;
                    }
                    customerServiceFragment.updateBottomLayout(rPAMessage, rPAStep, false);
                }
            });
        } catch (Exception unused) {
        }
    }
}
