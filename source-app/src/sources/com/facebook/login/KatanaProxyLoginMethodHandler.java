package com.facebook.login;

import android.content.Context;
import android.content.Intent;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.internal.CustomTabUtils;
import com.facebook.internal.NativeProtocol;
import com.facebook.share.internal.ShareConstants;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0016\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\b\u0010\f\u001a\u00020\rH\u0016J\b\u0010\u000e\u001a\u00020\u000fH\u0016J\u0010\u0010\u0010\u001a\u00020\r2\u0006\u0010\u0011\u001a\u00020\u0012H\u0016R\u0014\u0010\b\u001a\u00020\tX\u0096D¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0014"}, d2 = {"Lcom/facebook/login/KatanaProxyLoginMethodHandler;", "Lcom/facebook/login/NativeAppLoginMethodHandler;", "loginClient", "Lcom/facebook/login/LoginClient;", "(Lcom/facebook/login/LoginClient;)V", ShareConstants.FEED_SOURCE_PARAM, "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "nameForLogging", "", "getNameForLogging", "()Ljava/lang/String;", "describeContents", "", "shouldKeepTrackOfMultipleIntents", "", "tryAuthorize", "request", "Lcom/facebook/login/LoginClient$Request;", "Companion", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class KatanaProxyLoginMethodHandler extends NativeAppLoginMethodHandler {
    private final String nameForLogging;
    public static final Parcelable.Creator<KatanaProxyLoginMethodHandler> CREATOR = new Parcelable.Creator<KatanaProxyLoginMethodHandler>() {
        @Override
        public KatanaProxyLoginMethodHandler createFromParcel(Parcel source) {
            Intrinsics.checkNotNullParameter(source, ShareConstants.FEED_SOURCE_PARAM);
            return new KatanaProxyLoginMethodHandler(source);
        }

        @Override
        public KatanaProxyLoginMethodHandler[] newArray(int size) {
            return new KatanaProxyLoginMethodHandler[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public boolean shouldKeepTrackOfMultipleIntents() {
        return true;
    }

    public KatanaProxyLoginMethodHandler(LoginClient loginClient) {
        super(loginClient);
        Intrinsics.checkNotNullParameter(loginClient, "loginClient");
        this.nameForLogging = "katana_proxy_auth";
    }

    @Override
    public String getNameForLogging() {
        return this.nameForLogging;
    }

    @Override
    public int tryAuthorize(LoginClient.Request request) {
        boolean z;
        Intrinsics.checkNotNullParameter(request, "request");
        LoginBehavior loginBehavior = request.getLoginBehavior();
        if (FacebookSdk.ignoreAppSwitchToLoggedOut) {
            CustomTabUtils customTabUtils = CustomTabUtils.INSTANCE;
            if (CustomTabUtils.getChromePackage() == null || !loginBehavior.getAllowsCustomTabAuth()) {
                z = false;
            } else {
                z = true;
            }
        } else {
            z = false;
        }
        String e2e = LoginClient.INSTANCE.getE2E();
        NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
        Context context = (Context) getLoginClient().getActivity();
        String applicationId = request.getApplicationId();
        Set<String> permissions = request.getPermissions();
        boolean zIsRerequest = request.getIsRerequest();
        boolean zHasPublishPermission = request.hasPublishPermission();
        DefaultAudience defaultAudience = request.getDefaultAudience();
        if (defaultAudience == null) {
            defaultAudience = DefaultAudience.NONE;
        }
        DefaultAudience defaultAudience2 = defaultAudience;
        String clientState = getClientState(request.getAuthId());
        String authType = request.getAuthType();
        String messengerPageId = request.getMessengerPageId();
        boolean resetMessengerState = request.getResetMessengerState();
        boolean zIsFamilyLogin = request.getIsFamilyLogin();
        boolean zShouldSkipAccountDeduplication = request.getShouldSkipAccountDeduplication();
        String nonce = request.getNonce();
        String codeChallenge = request.getCodeChallenge();
        CodeChallengeMethod codeChallengeMethod = request.getCodeChallengeMethod();
        List<Intent> listCreateProxyAuthIntents = NativeProtocol.createProxyAuthIntents(context, applicationId, permissions, e2e, zIsRerequest, zHasPublishPermission, defaultAudience2, clientState, authType, z, messengerPageId, resetMessengerState, zIsFamilyLogin, zShouldSkipAccountDeduplication, nonce, codeChallenge, codeChallengeMethod == null ? null : codeChallengeMethod.name());
        addLoggingExtra("e2e", e2e);
        Iterator<Intent> it = listCreateProxyAuthIntents.iterator();
        int i = 0;
        while (it.hasNext()) {
            i++;
            if (tryIntent(it.next(), LoginClient.INSTANCE.getLoginRequestCode())) {
                return i;
            }
        }
        return 0;
    }

    public KatanaProxyLoginMethodHandler(Parcel parcel) {
        super(parcel);
        Intrinsics.checkNotNullParameter(parcel, ShareConstants.FEED_SOURCE_PARAM);
        this.nameForLogging = "katana_proxy_auth";
    }
}
