package com.appsflyer.internal;

import android.util.Base64;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.UserDataStore;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import kotlin.text.StringsKt;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u000e\b\u0086\b\u0018\u0000 \u001a2\u00020\u0001:\u0001\u001aB)\u0012\u0006\u0010\u0002\u001a\u00020\f\u0012\u0006\u0010\u0015\u001a\u00020\f\u0012\u0006\u0010\u0016\u001a\u00020\f\u0012\b\b\u0002\u0010\u0017\u001a\u00020\u0006¢\u0006\u0004\b\u0018\u0010\u0019J\u001a\u0010\u0004\u001a\u00020\u00032\b\u0010\u0002\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u0010\u0010\u0007\u001a\u00020\u0006HÖ\u0001¢\u0006\u0004\b\u0007\u0010\bJ\u000f\u0010\n\u001a\u00020\tH\u0007¢\u0006\u0004\b\n\u0010\u000bJ\u0010\u0010\r\u001a\u00020\fH×\u0001¢\u0006\u0004\b\r\u0010\u000eR\u0012\u0010\u000f\u001a\u00020\u0006X\u0086\u0002¢\u0006\u0006\n\u0004\b\u000f\u0010\u0010R\u0011\u0010\u0013\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0011\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\u0014\u0010\u0012R\u0011\u0010\n\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\n\u0010\u0012"}, d2 = {"Lcom/appsflyer/internal/AFd1oSDK;", "", "p0", "", "equals", "(Ljava/lang/Object;)Z", "", "hashCode", "()I", "Lorg/json/JSONObject;", "AFInAppEventParameterName", "()Lorg/json/JSONObject;", "", "toString", "()Ljava/lang/String;", "values", "I", "valueOf", "Ljava/lang/String;", "AFInAppEventType", "AFKeystoreWrapper", "p1", "p2", "p3", "<init>", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V", "AFa1ySDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFd1oSDK {

    public static final Companion INSTANCE = new Companion(null);
    public final String AFInAppEventParameterName;

    public final String valueOf;

    final String AFInAppEventType;
    int values;

    public final boolean equals(Object p0) {
        if (this == p0) {
            return true;
        }
        if (!(p0 instanceof AFd1oSDK)) {
            return false;
        }
        AFd1oSDK aFd1oSDK = (AFd1oSDK) p0;
        return Intrinsics.areEqual(this.valueOf, aFd1oSDK.valueOf) && Intrinsics.areEqual(this.AFInAppEventType, aFd1oSDK.AFInAppEventType) && Intrinsics.areEqual(this.AFInAppEventParameterName, aFd1oSDK.AFInAppEventParameterName) && this.values == aFd1oSDK.values;
    }

    public final int hashCode() {
        return (((((this.valueOf.hashCode() * 31) + this.AFInAppEventType.hashCode()) * 31) + this.AFInAppEventParameterName.hashCode()) * 31) + this.values;
    }

    public final String toString() {
        StringBuilder sb = new StringBuilder("AFd1oSDK(valueOf=");
        sb.append(this.valueOf);
        sb.append(", AFInAppEventType=");
        sb.append(this.AFInAppEventType);
        sb.append(", AFInAppEventParameterName=");
        sb.append(this.AFInAppEventParameterName);
        sb.append(", values=");
        sb.append(this.values);
        sb.append(')');
        return sb.toString();
    }

    public AFd1oSDK(String str, String str2, String str3, int i) {
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(str2, "");
        Intrinsics.checkNotNullParameter(str3, "");
        this.valueOf = str;
        this.AFInAppEventType = str2;
        this.AFInAppEventParameterName = str3;
        this.values = i;
    }

    public AFd1oSDK(String str, String str2, String str3, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, str3, (i2 & 8) != 0 ? 1 : i);
    }

    @Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u000e\u0010\u000fJ1\u0010\b\u001a\u00020\u00072\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\u0016\u0010\u0006\u001a\f\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u00050\u0004\"\u0004\u0018\u00010\u0005H\u0002¢\u0006\u0004\b\b\u0010\tJ\u0019\u0010\u000b\u001a\u0004\u0018\u00010\n2\u0006\u0010\u0003\u001a\u00020\u0005H\u0007¢\u0006\u0004\b\u000b\u0010\fJ\u001b\u0010\b\u001a\u00020\u0005*\u00020\u00052\u0006\u0010\u0003\u001a\u00020\u0005H\u0002¢\u0006\u0004\b\b\u0010\r"}, d2 = {"Lcom/appsflyer/internal/AFd1oSDK$AFa1ySDK;", "", "", "p0", "", "", "p1", "", "AFInAppEventType", "(Ljava/lang/Integer;[Ljava/lang/String;)Z", "Lcom/appsflyer/internal/AFd1oSDK;", "AFKeystoreWrapper", "(Ljava/lang/String;)Lcom/appsflyer/internal/AFd1oSDK;", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "<init>", "()V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public static AFd1oSDK AFKeystoreWrapper(String p0) {
            Intrinsics.checkNotNullParameter(p0, "");
            List<String> listSplit$default = StringsKt.split$default(p0, new String[]{"\n"}, false, 0, 6, (Object) null);
            if (listSplit$default.size() != 4) {
                return null;
            }
            String strAFInAppEventType = null;
            String strAFInAppEventType2 = null;
            String strAFInAppEventType3 = null;
            Integer numValueOf = null;
            for (String str : listSplit$default) {
                if (StringsKt.startsWith$default(str, "label=", false, 2, (Object) null)) {
                    strAFInAppEventType = AFInAppEventType(str, "label=");
                } else if (StringsKt.startsWith$default(str, "hashName=", false, 2, (Object) null)) {
                    strAFInAppEventType2 = AFInAppEventType(str, "hashName=");
                } else if (StringsKt.startsWith$default(str, "stackTrace=", false, 2, (Object) null)) {
                    strAFInAppEventType3 = AFInAppEventType(str, "stackTrace=");
                } else {
                    if (!StringsKt.startsWith$default(str, "c=", false, 2, (Object) null)) {
                        break;
                    }
                    String strSubstring = str.substring(2);
                    Intrinsics.checkNotNullExpressionValue(strSubstring, "");
                    numValueOf = Integer.valueOf(Integer.parseInt(StringsKt.trim(strSubstring).toString()));
                }
            }
            if (AFInAppEventType(numValueOf, strAFInAppEventType, strAFInAppEventType2, strAFInAppEventType3)) {
                return null;
            }
            Intrinsics.checkNotNull(strAFInAppEventType);
            Intrinsics.checkNotNull(strAFInAppEventType2);
            Intrinsics.checkNotNull(strAFInAppEventType3);
            Intrinsics.checkNotNull(numValueOf);
            return new AFd1oSDK(strAFInAppEventType, strAFInAppEventType2, strAFInAppEventType3, numValueOf.intValue());
        }

        private static boolean AFInAppEventType(Integer p0, String... p1) {
            String str;
            boolean z = p0 == null;
            int length = p1.length;
            for (int i = 0; i < 3; i++) {
                z = z || (str = p1[i]) == null || str.length() == 0;
            }
            return z;
        }

        private static String AFInAppEventType(String str, String str2) {
            String strSubstring = str.substring(str2.length());
            Intrinsics.checkNotNullExpressionValue(strSubstring, "");
            String string = StringsKt.trim(strSubstring).toString();
            Intrinsics.checkNotNullParameter(string, "");
            byte[] bytes = string.getBytes(Charsets.UTF_8);
            Intrinsics.checkNotNullExpressionValue(bytes, "");
            Intrinsics.checkNotNullParameter(bytes, "");
            byte[] bArrDecode = Base64.decode(bytes, 2);
            Intrinsics.checkNotNullExpressionValue(bArrDecode, "");
            return new String(bArrDecode, Charsets.UTF_8);
        }
    }

    public final JSONObject AFInAppEventParameterName() throws JSONException {
        JSONObject jSONObject = new JSONObject();
        jSONObject.put("label", this.valueOf);
        jSONObject.put("hash_name", this.AFInAppEventType);
        jSONObject.put(UserDataStore.STATE, this.AFInAppEventParameterName);
        jSONObject.put("c", String.valueOf(this.values));
        return jSONObject;
    }
}
