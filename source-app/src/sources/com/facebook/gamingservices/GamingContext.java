package com.facebook.gamingservices;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.GraphResponse;
import com.facebook.gamingservices.cloudgaming.CloudGameLoginHandler;
import com.facebook.gamingservices.cloudgaming.DaemonRequest;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u0000 \u000f2\u00020\u0001:\u0001\u000fB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\f\u001a\u00020\rHÖ\u0001J\t\u0010\u000e\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, d2 = {"Lcom/facebook/gamingservices/GamingContext;", "", "contextID", "", "(Ljava/lang/String;)V", "getContextID", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "hashCode", "", "toString", "Companion", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class GamingContext {

    public static final Companion INSTANCE = new Companion(null);
    private static final int DEFAULT_TIMEOUT = 5;
    private static GamingContext currentContext;
    private final String contextID;

    public static GamingContext copy$default(GamingContext gamingContext, String str, int i, Object obj) {
        if ((i & 1) != 0) {
            str = gamingContext.contextID;
        }
        return gamingContext.copy(str);
    }

    @JvmStatic
    public static final GamingContext getCurrentGamingContext() {
        return INSTANCE.getCurrentGamingContext();
    }

    @JvmStatic
    public static final void setCurrentGamingContext(GamingContext gamingContext) {
        INSTANCE.setCurrentGamingContext(gamingContext);
    }

    public final String getContextID() {
        return this.contextID;
    }

    public final GamingContext copy(String contextID) {
        Intrinsics.checkNotNullParameter(contextID, "contextID");
        return new GamingContext(contextID);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        return (other instanceof GamingContext) && Intrinsics.areEqual(this.contextID, ((GamingContext) other).contextID);
    }

    public int hashCode() {
        return this.contextID.hashCode();
    }

    public String toString() {
        return "GamingContext(contextID=" + this.contextID + ')';
    }

    public GamingContext(String str) {
        Intrinsics.checkNotNullParameter(str, "contextID");
        this.contextID = str;
    }

    public final String getContextID() {
        return this.contextID;
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\n\u0010\u0007\u001a\u0004\u0018\u00010\u0006H\u0007J\u0010\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0006H\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000b"}, d2 = {"Lcom/facebook/gamingservices/GamingContext$Companion;", "", "()V", "DEFAULT_TIMEOUT", "", "currentContext", "Lcom/facebook/gamingservices/GamingContext;", "getCurrentGamingContext", "setCurrentGamingContext", "", "ctx", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final GamingContext getCurrentGamingContext() {
            JSONObject graphObject;
            if (!CloudGameLoginHandler.isRunningInCloud()) {
                return GamingContext.currentContext;
            }
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            GraphResponse graphResponseExecuteAndWait = DaemonRequest.executeAndWait(FacebookSdk.getApplicationContext(), null, SDKMessageEnum.CONTEXT_GET_ID, 5);
            String string = (graphResponseExecuteAndWait == null || (graphObject = graphResponseExecuteAndWait.getGraphObject()) == null) ? null : graphObject.getString("id");
            if (string == null) {
                return null;
            }
            return new GamingContext(string);
        }

        @JvmStatic
        public final void setCurrentGamingContext(GamingContext ctx) {
            Intrinsics.checkNotNullParameter(ctx, "ctx");
            if (CloudGameLoginHandler.isRunningInCloud()) {
                return;
            }
            GamingContext.currentContext = ctx;
        }
    }
}
