package net.aihelp.data.logic;

import android.content.Context;
import android.text.TextUtils;
import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.core.mvp.AbsPresenter;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.mqtt.AIHelpMqtt;
import net.aihelp.core.net.mqtt.callback.IMqttCallback;
import net.aihelp.core.util.concurrent.ApiExecutor;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.local.FaqRepository;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.model.faq.FaqContentEntity;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.p007ui.faq.BaseFaqFragment;
import net.aihelp.p007ui.faq.FaqContentFragment;
import net.aihelp.p007ui.faq.FaqHomeFragment;
import net.aihelp.p007ui.faq.FaqListFragment;
import net.aihelp.utils.FileUtil;
import net.aihelp.utils.Styles;

public class FaqPresenter extends AbsPresenter<BaseFaqFragment, FaqRepository> {
    private static final ApiExecutor sApiExecutor = ApiExecutorFactory.getHandlerExecutor();

    public FaqPresenter(Context context) {
        super(context);
    }

    private void fetchFaqDataSourceOnDemand(final String str) {
        if (isNetworkAvailable()) {
            ((BaseFaqFragment) this.mView).showLoading();
            if (Pattern.compile(".+\\.(json)$").matcher(LocalizeUtil.getUrl(1001)).matches()) {
                AIHelpRequest.getInstance().requestDownloadFile(1001, new ReqCallback<String>() {
                    @Override
                    public void onAsyncReqSuccess(String str2) {
                        FaqHelper.INSTANCE.prepareDataSource(new Runnable() {
                            @Override
                            public void run() {
                                FaqPresenter.this.refreshFaqs(str);
                            }
                        });
                    }

                    @Override
                    public void onFailure(String str2, int i, String str3) {
                        FaqPresenter.this.getFaqFromApiAfterLocalizeFailed(str);
                    }
                });
                return;
            }
            return;
        }
        ((BaseFaqFragment) this.mView).showNetError();
    }

    public void getFaqFromApiAfterLocalizeFailed(final String str) {
        get(API.FAQ_URL, null, new ReqCallback<String>() {
            @Override
            public void onAsyncReqSuccess(String str2) {
                try {
                    if (!TextUtils.isEmpty(str2)) {
                        if (!FileUtil.writeFileToDisk(new ByteArrayInputStream(str2.getBytes()), LocalizeUtil.getFileLocation(1001))) {
                            ((BaseFaqFragment) FaqPresenter.this.mView).showEmpty(new int[0]);
                        } else {
                            FaqHelper.INSTANCE.prepareDataSource(new Runnable() {
                                @Override
                                public void run() {
                                    FaqPresenter.this.refreshFaqs(str);
                                }
                            });
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void refreshFaqs(String str) {
        if (this.mView == 0 || ((BaseFaqFragment) this.mView).isDetached()) {
            return;
        }
        ((BaseFaqFragment) this.mView).restoreViewState();
        if ((this.mView instanceof FaqHomeFragment) || (this.mView instanceof FaqListFragment)) {
            goFetchFAQDataSource(str);
        }
        if (this.mView instanceof FaqContentFragment) {
            goFetchQuestionContent(null, str, "");
        }
    }

    public void goFetchFAQDataSource(String str) {
        List<FaqListEntity> questionList;
        if (FaqHelper.isFaqDataAlreadyPrepared()) {
            if (TextUtils.isEmpty(str)) {
                questionList = FaqHelper.INSTANCE.getRootSections();
            } else if (((FaqRepository) this.mRepo).checkWhetherHasSubSection(str)) {
                questionList = FaqHelper.INSTANCE.getSubSections(str);
            } else {
                questionList = FaqHelper.INSTANCE.getQuestionList(str);
            }
            if (this.mView == 0 || ((BaseFaqFragment) this.mView).isDetached()) {
                return;
            }
            ((BaseFaqFragment) this.mView).refreshList(questionList, str);
            return;
        }
        fetchFaqDataSourceOnDemand(str);
    }

    public void goFetchQuestionContent(String str, String str2, String str3) {
        if (FaqHelper.isFaqDataAlreadyPrepared()) {
            FaqContentEntity faqById = FaqHelper.INSTANCE.getFaqById(str, str2);
            if (faqById != null) {
                FaqContentEntity fAQWithHighlightedSearchTerms = Styles.getFAQWithHighlightedSearchTerms(this.mContext, faqById, str3);
                if (this.mView == 0 || ((BaseFaqFragment) this.mView).isDetached()) {
                    return;
                }
                BaseFaqFragment baseFaqFragment = (BaseFaqFragment) this.mView;
                if (fAQWithHighlightedSearchTerms != null) {
                    faqById = fAQWithHighlightedSearchTerms;
                }
                baseFaqFragment.refreshQuestionContent(faqById);
                return;
            }
            ((BaseFaqFragment) this.mView).showEmpty(new int[0]);
            return;
        }
        fetchFaqDataSourceOnDemand(str2);
    }

    public void goQueryFAQList(final String str) {
        sApiExecutor.runAsync(new Runnable() {
            @Override
            public void run() {
                final ArrayList<FaqListEntity> matchedFaqList = (TextUtils.isEmpty(str) || FaqHelper.INSTANCE.getRawFlatFaqArray().length() == 0) ? null : ((FaqRepository) FaqPresenter.this.mRepo).getMatchedFaqList(str);
                FaqPresenter.sApiExecutor.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (FaqPresenter.this.mView == null || ((BaseFaqFragment) FaqPresenter.this.mView).isDetached()) {
                            return;
                        }
                        ((BaseFaqFragment) FaqPresenter.this.mView).refreshList(matchedFaqList);
                    }
                });
            }
        });
    }

    public void prepareFAQNotification() {
        if (Const.TOGGLE_OPEN_FAQ_NOTIFICATION) {
            IMqttCallback mqttCallbackImpl = MqttCallbackImpl.getInstance();
            mqttCallbackImpl.updateHostView(this.mView);
            AIHelpMqtt.getInstance().prepare(3, mqttCallbackImpl);
        }
        UnreadFetchHelper.fetchUnreadMessageCount(new UnreadFetchHelper.Callback() {
            @Override
            public void onFetched(int i, int i2) {
                if (i2 > 0) {
                    ((BaseFaqFragment) FaqPresenter.this.mView).showEntranceWithNotification(true, false);
                } else if (Const.TOGGLE_FETCH_MESSAGE) {
                    ((BaseFaqFragment) FaqPresenter.this.mView).showEntranceWithNotification(false, false);
                }
            }
        });
    }

    public boolean hasSubSection(String str) {
        return ((FaqRepository) this.mRepo).checkWhetherHasSubSection(str);
    }

    public boolean shouldShowQuestionFooter(String str, long j) {
        return ((FaqRepository) this.mRepo).shouldShowQuestionFooter(str, j);
    }
}
