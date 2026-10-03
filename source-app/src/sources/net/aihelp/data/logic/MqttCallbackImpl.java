package net.aihelp.data.logic;

import androidx.fragment.app.Fragment;
import java.lang.ref.WeakReference;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.core.net.mqtt.callback.IMqttCallback;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.LoadingElvaEvent;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.faq.BaseFaqFragment;
import net.aihelp.p007ui.p009cs.CustomerServiceFragment;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.p009cs.util.rpa.helper.ResponseHelper;
import net.aihelp.utils.UploadFileHelper;
import org.json.JSONObject;
import zendesk.faye.internal.Bayeux;

public class MqttCallbackImpl implements IMqttCallback {
    public static final int NOTIFICATION_TYPE_ASSIGN_CHANGE = 1;
    private WeakReference<CustomerServiceFragment> csFragment;
    private WeakReference<BaseFaqFragment> faqFragment;

    @Override
    public void onMqttConnected() {
    }

    @Override
    public void updateHostView(Fragment fragment) {
        if (fragment instanceof CustomerServiceFragment) {
            this.csFragment = new WeakReference<>((CustomerServiceFragment) fragment);
        } else if (fragment instanceof BaseFaqFragment) {
            this.faqFragment = new WeakReference<>((BaseFaqFragment) fragment);
        }
    }

    @Override
    public void onMqttResponse(String str, String str2) {
        try {
            JSONObject jSONObject = new JSONObject(str2);
            boolean z = jSONObject.has("code") && jSONObject.optInt("code") != 200;
            boolean zHas = jSONObject.has("errorCode");
            if (!z && !zHas) {
                switch (str) {
                    case "pushWithdraw":
                        WeakReference<CustomerServiceFragment> weakReference = this.csFragment;
                        if (weakReference != null && weakReference.get() != null) {
                            this.csFragment.get().notifyMessageWithdrawn(new JSONObject(str2).optLong("withdrawkey", 0L));
                            break;
                        }
                        break;
                    case "pushChat":
                        WeakReference<CustomerServiceFragment> weakReference2 = this.csFragment;
                        if (weakReference2 != null && weakReference2.get() != null) {
                            Message rPAMessage = ResponseHelper.getRPAMessage(str2);
                            RPAStep rPAStep = ResponseHelper.getRPAStep(str2);
                            if (rPAStep.isEnableUpload()) {
                                UploadFileHelper.INSTANCE.tryUploadLog(true);
                            } else {
                                if (rPAMessage.isNormalMessage()) {
                                    this.csFragment.get().updateChatList(rPAMessage);
                                }
                                if (rPAStep.getNextStep() != 104) {
                                    this.csFragment.get().updateBottomLayout(rPAMessage, rPAStep);
                                }
                            }
                            ResponseHelper.notifyMqttPush("");
                            break;
                        }
                        break;
                    case "pushOverflagChat":
                        TicketStatusTracker.isTicketFinished = true;
                        TicketStatusTracker.isTicketWaitForAskingResolveStatus = jSONObject.optBoolean("isShowResolve");
                        TicketStatusTracker.isTicketWaitForRating = CustomConfig.CustomerService.isTicketRatingEnable;
                        TicketStatusTracker.isAppRatable = "yes".equals(jSONObject.optString("storeReview"));
                        WeakReference<CustomerServiceFragment> weakReference3 = this.csFragment;
                        if (weakReference3 != null && weakReference3.get() != null) {
                            this.csFragment.get().onTicketFinishedOrRejected();
                            break;
                        }
                        break;
                    case "ticketRejected":
                        TicketStatusTracker.isTicketRejected = true;
                        WeakReference<CustomerServiceFragment> weakReference4 = this.csFragment;
                        if (weakReference4 != null && weakReference4.get() != null) {
                            this.csFragment.get().onTicketFinishedOrRejected();
                            break;
                        }
                        break;
                    case "pushFormChat":
                        WeakReference<CustomerServiceFragment> weakReference5 = this.csFragment;
                        if (weakReference5 != null && weakReference5.get() != null) {
                            this.csFragment.get().onFormSubmitted(jSONObject.optString("msg"));
                        }
                        AIHelpEventTracker.getInstance().onFormSubmitted(jSONObject.optString("formId"));
                        if (Const.sSpecificFormSubmittedListener != null && jSONObject.getBoolean("isSpecificForm")) {
                            Const.sSpecificFormSubmittedListener.onFormSubmitted();
                            break;
                        }
                        break;
                    case "pushSdkMessage":
                        WeakReference<BaseFaqFragment> weakReference6 = this.faqFragment;
                        if (weakReference6 != null && weakReference6.get() != null) {
                            this.faqFragment.get().showEntranceWithNotification(true, true);
                            break;
                        }
                        break;
                    case "pushNotification":
                        if (!TicketStatusTracker.isTicketFinished && !TicketStatusTracker.isTicketRejected) {
                            preparePushNotifications(str2);
                            break;
                        }
                        break;
                    default:
                        break;
                }
            }
        } catch (Exception unused) {
        }
    }

    private void preparePushNotifications(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            int iOptInt = jSONObject.optInt("type");
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONObject, Bayeux.KEY_DATA);
            if (iOptInt == 1) {
                TicketStatusTracker.ticketAssignType = jsonObject.optInt("assignType");
                WeakReference<CustomerServiceFragment> weakReference = this.csFragment;
                if (weakReference == null || weakReference.get() == null) {
                    return;
                }
                if (TicketStatusTracker.isTicketServingByAgent()) {
                    RPAStep rPAStep = new RPAStep();
                    rPAStep.setNextStep(100);
                    this.csFragment.get().updateBottomLayout(new Message(), rPAStep);
                }
                this.csFragment.get().onTicketAssignStatusChanged();
            }
        } catch (Exception unused) {
        }
    }

    @Override
    public void onMqttDisconnected() {
        showMqttLoading();
        WeakReference<CustomerServiceFragment> weakReference = this.csFragment;
        if (weakReference == null || weakReference.get() == null || !this.csFragment.get().isVisible()) {
            return;
        }
        this.csFragment.get().prepareMqtt(2);
    }

    @Override
    public void onMqttFailure() {
        MessagePoller.INSTANCE.fetchMessagesSinceLatest(2);
    }

    @Override
    public void onMqttSubscribed(int i) {
        MessagePoller.INSTANCE.fetchMessagesSinceLatest(i != 1 ? 3 : 1);
    }

    @Override
    public void showMqttLoading() {
        EventBus.getDefault().post(new LoadingElvaEvent(1003));
    }

    @Override
    public void dismissMqttLoading() {
        EventBus.getDefault().post(new LoadingElvaEvent(1004));
    }

    private static final class LazyHolder {
        static final MqttCallbackImpl INSTANCE = new MqttCallbackImpl();

        private LazyHolder() {
        }
    }

    private MqttCallbackImpl() {
    }

    public static IMqttCallback getInstance() {
        return LazyHolder.INSTANCE;
    }
}
