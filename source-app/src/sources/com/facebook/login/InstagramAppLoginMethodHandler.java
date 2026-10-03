package com.facebook.login;

import android.content.Context;
import android.content.Intent;
import android.os.Parcel;
import android.os.Parcelable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.FragmentActivity;
import com.facebook.AccessTokenSource;
import com.facebook.FacebookSdk;
import com.facebook.internal.NativeProtocol;
import com.facebook.share.internal.ShareConstants;
import java.util.Set;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 \u00192\u00020\u0001:\u0001\u0019B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0016\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\b\u0010\u0010\u001a\u00020\u0011H\u0016J\u0010\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u0014H\u0016J\u0018\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u0018\u001a\u00020\u0011H\u0016R\u0014\u0010\b\u001a\u00020\tX\u0096D¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\f\u001a\u00020\rX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001a"}, d2 = {"Lcom/facebook/login/InstagramAppLoginMethodHandler;", "Lcom/facebook/login/NativeAppLoginMethodHandler;", "loginClient", "Lcom/facebook/login/LoginClient;", "(Lcom/facebook/login/LoginClient;)V", ShareConstants.FEED_SOURCE_PARAM, "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "nameForLogging", "", "getNameForLogging", "()Ljava/lang/String;", "tokenSource", "Lcom/facebook/AccessTokenSource;", "getTokenSource", "()Lcom/facebook/AccessTokenSource;", "describeContents", "", "tryAuthorize", "request", "Lcom/facebook/login/LoginClient$Request;", "writeToParcel", "", "dest", "flags", "Companion", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class InstagramAppLoginMethodHandler extends NativeAppLoginMethodHandler {
    private final String nameForLogging;
    private final AccessTokenSource tokenSource;
    public static final Parcelable.Creator<InstagramAppLoginMethodHandler> CREATOR = new Parcelable.Creator<InstagramAppLoginMethodHandler>() {
        @Override
        public InstagramAppLoginMethodHandler createFromParcel(Parcel source) {
            Intrinsics.checkNotNullParameter(source, ShareConstants.FEED_SOURCE_PARAM);
            return new InstagramAppLoginMethodHandler(source);
        }

        @Override
        public InstagramAppLoginMethodHandler[] newArray(int size) {
            return new InstagramAppLoginMethodHandler[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    public InstagramAppLoginMethodHandler(LoginClient loginClient) {
        super(loginClient);
        Intrinsics.checkNotNullParameter(loginClient, "loginClient");
        this.nameForLogging = "instagram_login";
        this.tokenSource = AccessTokenSource.INSTAGRAM_APPLICATION_WEB;
    }

    @Override
    public String getNameForLogging() {
        return this.nameForLogging;
    }

    @Override
    public AccessTokenSource getTokenSource() {
        return this.tokenSource;
    }

    @Override
    public int tryAuthorize(LoginClient.Request request) {
        Context applicationContext;
        Intrinsics.checkNotNullParameter(request, "request");
        String e2e = LoginClient.INSTANCE.getE2E();
        NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
        FragmentActivity activity = getLoginClient().getActivity();
        if (activity == null) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            applicationContext = FacebookSdk.getApplicationContext();
        } else {
            applicationContext = (Context) activity;
        }
        String applicationId = request.getApplicationId();
        Set<String> permissions = request.getPermissions();
        boolean zIsRerequest = request.getIsRerequest();
        boolean zHasPublishPermission = request.hasPublishPermission();
        DefaultAudience defaultAudience = request.getDefaultAudience();
        if (defaultAudience == null) {
            defaultAudience = DefaultAudience.NONE;
        }
        Intent intentCreateInstagramIntent = NativeProtocol.createInstagramIntent(applicationContext, applicationId, permissions, e2e, zIsRerequest, zHasPublishPermission, defaultAudience, getClientState(request.getAuthId()), request.getAuthType(), request.getMessengerPageId(), request.getResetMessengerState(), request.getIsFamilyLogin(), request.getShouldSkipAccountDeduplication());
        addLoggingExtra("e2e", e2e);
        return tryIntent(intentCreateInstagramIntent, LoginClient.INSTANCE.getLoginRequestCode()) ? 1 : 0;
    }

    public InstagramAppLoginMethodHandler(Parcel parcel) {
        super(parcel);
        Intrinsics.checkNotNullParameter(parcel, ShareConstants.FEED_SOURCE_PARAM);
        this.nameForLogging = "instagram_login";
        this.tokenSource = AccessTokenSource.INSTAGRAM_APPLICATION_WEB;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        Intrinsics.checkNotNullParameter(dest, "dest");
        super.writeToParcel(dest, flags);
    }
}
