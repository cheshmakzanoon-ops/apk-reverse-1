package net.aihelp.data.localize;

import android.text.TextUtils;
import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.localize.config.BusinessLogicHelper;
import net.aihelp.data.localize.config.ProcessEntranceHelper;
import net.aihelp.data.localize.config.StyleSheetHelper;
import net.aihelp.data.localize.config.TextHelper;
import net.aihelp.data.localize.config.UploadLimitHelper;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.localize.data.LocaleStringHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.track.ResourceLoadTracker;
import net.aihelp.init.InitHelper;
import net.aihelp.utils.FileUtil;

public class LocalizeHelper {
    public static final int FLAG_BUSINESS_LOGIC = 1007;
    public static final int FLAG_FAQ_HOT_TOPIC = 1009;
    public static final int FLAG_FAQ_SECTION = 1001;
    public static final int FLAG_LOCALE = 1005;
    public static final int FLAG_PROCESS = 1010;
    public static final int FLAG_STYLE_SHEET = 1006;
    public static final int FLAG_TEXT = 1011;
    public static final int FLAG_UPLOAD_LIMIT = 1012;

    public static void resetLocalizeData() {
        FaqHelper.INSTANCE.reset();
        LocaleStringHelper.INSTANCE.reset();
        TextHelper.INSTANCE.reset();
        ProcessEntranceHelper.INSTANCE.reset();
        UploadLimitHelper.INSTANCE.reset();
    }

    public static List<Integer> getLocalizeResourceList(List<Integer> list) {
        int[] iArr = {1005, 1006, 1007, 1009, FLAG_TEXT, FLAG_UPLOAD_LIMIT, FLAG_PROCESS};
        for (int i = 0; i < 7; i++) {
            int i2 = iArr[i];
            if (LocalizeUtil.isAlreadyLocalized(i2)) {
                prepareDataSourceByMode(i2);
            } else {
                list.add(Integer.valueOf(i2));
            }
        }
        return list;
    }

    public static void goFetchLocalizeData() {
        ApiExecutorFactory.getHandlerExecutor().runAsync(new Runnable() {
            @Override
            public void run() {
                ArrayList arrayList = new ArrayList();
                if (LocalizeUtil.isAlreadyLocalized(1001)) {
                    FaqHelper.INSTANCE.prepareDataSource();
                } else if (Const.TOGGLE_LOCALIZE_VIA_INIT) {
                    arrayList.add(1001);
                }
                List<Integer> localizeResourceList = LocalizeHelper.getLocalizeResourceList(arrayList);
                ResourceLoadTracker.getInstance().onResourceRequested(localizeResourceList.size());
                for (int i = 0; i < localizeResourceList.size(); i++) {
                    LocalizeHelper.getLocalizeDataFromUrl(localizeResourceList.get(i).intValue());
                }
            }
        });
    }

    public static void getLocalizeDataFromUrl(final int i) {
        if (i == 1001 && FaqHelper.isFaqDataAlreadyPrepared()) {
            return;
        }
        AIHelpRequest.getInstance().requestDownloadFile(i, new ReqCallback<String>() {
            @Override
            public void onAsyncReqSuccess(String str) {
                ResourceLoadTracker.getInstance().onResourceRetrieved(i, true);
                LocalizeHelper.prepareDataSourceByMode(i);
            }

            @Override
            public void onAsyncFailure(String str, int i2, String str2) {
                ResourceLoadTracker.getInstance().onResourceRetrieved(i, false);
                int i3 = i;
                if (i3 == 1001) {
                    LocalizeHelper.getDataAfterLocalizeFailed();
                } else {
                    if (i3 != 1010) {
                        return;
                    }
                    if (TextUtils.isEmpty(str)) {
                        str2 = "Failed downloading custom entrance configuration, please checkout your configuration in AIHelp Dashboard and re-publish.";
                    }
                    InitHelper.getInstance().onAIHelpInitializedCallback(false, str2);
                }
            }
        });
    }

    public static void prepareDataSourceByMode(int i) {
        switch (i) {
            case 1001:
                FaqHelper.INSTANCE.prepareDataSource();
                break;
            case 1005:
                LocaleStringHelper.INSTANCE.prepareDataSource();
                break;
            case 1006:
                StyleSheetHelper.INSTANCE.prepareDataSource();
                break;
            case 1007:
                BusinessLogicHelper.INSTANCE.prepareDataSource();
                break;
            case 1009:
                FaqHelper.INSTANCE.prepareNotificationAndHotTopics();
                break;
            case FLAG_PROCESS:
                ProcessEntranceHelper.INSTANCE.prepareDataSource();
                break;
            case FLAG_TEXT:
                TextHelper.INSTANCE.prepareDataSource();
                break;
            case FLAG_UPLOAD_LIMIT:
                UploadLimitHelper.INSTANCE.prepareDataSource();
                break;
        }
    }

    public static void getDataAfterLocalizeFailed() {
        AIHelpRequest.getInstance().requestGetByAsync(API.FAQ_URL, null, new ReqCallback<String>() {
            @Override
            public void onAsyncReqSuccess(String str) {
                try {
                    if (TextUtils.isEmpty(str) || !FileUtil.writeFileToDisk(new ByteArrayInputStream(str.getBytes()), LocalizeUtil.getFileLocation(1001))) {
                        return;
                    }
                    FaqHelper.INSTANCE.prepareDataSource();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
