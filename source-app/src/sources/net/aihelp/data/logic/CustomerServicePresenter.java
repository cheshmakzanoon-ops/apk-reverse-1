package net.aihelp.data.logic;

import android.content.Context;
import java.util.List;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.core.mvp.AbsPresenter;
import net.aihelp.core.mvp.IRepository;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.callback.IMqttCallback;
import net.aihelp.core.net.mqtt.config.MqttConfig;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.p009cs.CustomerServiceFragment;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.p009cs.util.rpa.helper.HistoryHelper;
import net.aihelp.p007ui.p009cs.util.rpa.helper.ResponseHelper;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.UploadFileHelper;
import org.json.JSONObject;

public class CustomerServicePresenter extends AbsPresenter<CustomerServiceFragment, IRepository> {
    public CustomerServicePresenter(Context context) {
        super(context, 5);
    }

    public void prepareMqtt(IMqttCallback iMqttCallback, int i) {
        AIHelpMqtt.getInstance().prepare(iMqttCallback, i);
    }

    public void requestLogin() {
        post(API.LOGIN, ResponseHelper.getLoginParams(), new ReqCallback<String>() {
            @Override
            public void onReqSuccess(String str) {
                CustomerServicePresenter.this.mRetryHandler.removeCallbacksAndMessages(null);
                List<Message> loginResponse = ResponseHelper.getLoginResponse(str);
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
                ((CustomerServiceFragment) CustomerServicePresenter.this.mView).onLogin(loginResponse, rPAMessage, rPAStep);
            }

            @Override
            public void onFailure(String str, int i, String str2) {
                CustomerServicePresenter.this.mRetryHandler.handleRetryRequest(i, str2);
            }
        });
    }

    public void logout() {
        post(API.LOGOUT, null, null);
    }

    public void chatWithSupport(final long j, JSONObject jSONObject) {
        try {
            AIHelpEventTracker.getInstance().setWhenMessageSent();
            post(API.SEND_MESSAGE, jSONObject, new ReqCallback<String>() {
                @Override
                public void onReqSuccess(String str) {
                    ResponseHelper.notifyMqttPush(str);
                    Message rPAMessage = ResponseHelper.getRPAMessage(str);
                    RPAStep rPAStep = ResponseHelper.getRPAStep(str);
                    ((CustomerServiceFragment) CustomerServicePresenter.this.mView).updateMessageStatus(true, j, rPAMessage.getTimestamp() - 1);
                    if (rPAStep.isEnableUpload()) {
                        UploadFileHelper.INSTANCE.tryUploadLog(true);
                    } else {
                        if (rPAMessage.isNormalMessage()) {
                            ((CustomerServiceFragment) CustomerServicePresenter.this.mView).updateChatList(rPAMessage);
                        }
                        if (rPAStep.getNextStep() != 104) {
                            ((CustomerServiceFragment) CustomerServicePresenter.this.mView).updateBottomLayout(rPAMessage, rPAStep);
                        }
                    }
                    if (MqttConfig.getInstance().isConnected()) {
                        return;
                    }
                    ApiExecutorFactory.getHandlerExecutor().runAsyncDelayed(new Runnable() {
                        @Override
                        public void run() {
                            ((CustomerServiceFragment) CustomerServicePresenter.this.mView).prepareMqtt(2);
                        }
                    }, 2000L);
                }

                @Override
                public void onFailure(String str, int i, String str2) {
                    CustomerServiceFragment customerServiceFragment = (CustomerServiceFragment) CustomerServicePresenter.this.mView;
                    long j2 = j;
                    customerServiceFragment.updateMessageStatus(false, j2, j2);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void goBackToPreviousStep() {
        get(API.PREVIOUS_STEP, null, new ReqCallback<String>() {
            @Override
            public void onReqSuccess(String str) {
                CustomerServicePresenter.this.cleanMsgListAfterGoBackToPreviousStep(str);
                Message rPAMessage = ResponseHelper.getRPAMessage(str);
                RPAStep rPAStep = ResponseHelper.getRPAStep(str);
                if (rPAStep.isEnableUpload()) {
                    UploadFileHelper.INSTANCE.tryUploadLog(true);
                } else if (rPAStep.getNextStep() != 104) {
                    ((CustomerServiceFragment) CustomerServicePresenter.this.mView).updateBottomLayout(rPAMessage, rPAStep);
                }
            }
        });
    }

    public void cleanMsgListAfterGoBackToPreviousStep(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            ((CustomerServiceFragment) this.mView).notifyMessageWithdrawn(jSONObject.optLong("startTime"), jSONObject.optLong("endTime"));
        } catch (Exception unused) {
        }
    }

    public void getLastConversation() {
        if (!AppInfoUtil.validateNetwork(this.mContext)) {
            ((CustomerServiceFragment) this.mView).onLastConversationRetrieved(null);
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("userId", UserProfile.USER_ID);
            jSONObject.put("messageTime", TicketStatusTracker.firstMessageTimeStampInList);
            jSONObject.put("language", Const.ORIGINAL_LANGUAGE);
            jSONObject.put("pageSize", 20);
            get(API.GET_LAST_CONVERSATION, jSONObject, new ReqCallback<String>() {
                @Override
                public void onReqSuccess(String str) {
                    List<Message> historyList = HistoryHelper.getHistoryList(str, 2);
                    TicketStatusTracker.setFirstMessageTimeStampInList(historyList);
                    ((CustomerServiceFragment) CustomerServicePresenter.this.mView).onLastConversationRetrieved(historyList);
                }

                @Override
                public void onFailure(String str, int i, String str2) {
                    ((CustomerServiceFragment) CustomerServicePresenter.this.mView).onLastConversationRetrieved(null);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void refreshUnreadMessageCount() {
        TicketStatusTracker.hasUnreadMsg = false;
        UnreadFetchHelper.fetchUnreadMessageCount(new UnreadFetchHelper.Callback() {
            @Override
            public void onFetched(int i, int i2) {
                CustomerServicePresenter.this.mSp.put(Const.UNREAD_MESSAGE_TOKEN, Integer.valueOf(i));
                if (Const.TOGGLE_OPEN_UNREAD_MSG) {
                    UnreadFetchHelper.onMessageCountArrived(0);
                }
            }
        });
    }

    public void updateCachedUnreadMessageCount(boolean z, boolean z2) {
        if (z) {
            int i = this.mSp.getInt(Const.UNREAD_MESSAGE_TOKEN, 0);
            this.mSp.put(Const.UNREAD_MESSAGE_TOKEN, Integer.valueOf(z2 ? i - 1 : i + 1));
        }
    }

    @Override
    public void onRetryRequest() {
        requestLogin();
    }
}
