package com.appsflyer.internal;

import android.util.Base64;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Charsets;
import kotlin.text.Regex;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\u0018\u0000 \u00162\u00020\u0001:\u0001\u0016B\u0017\u0012\u0006\u0010\u0012\u001a\u00020\t\u0012\u0006\u0010\u0013\u001a\u00020\u000f¢\u0006\u0004\b\u0014\u0010\u0015R\u0013\u0010\u0005\u001a\u00020\u0002X\u0083\u0080\u0002¢\u0006\u0006\n\u0004\b\u0003\u0010\u0004R\u0013\u0010\u0006\u001a\u00020\u0002X\u0083\u0080\u0002¢\u0006\u0006\n\u0004\b\u0005\u0010\u0004R\u0011\u0010\b\u001a\u00020\u00028G¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0007R\u0014\u0010\f\u001a\u00020\t8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\n\u0010\u000bR\u0014\u0010\n\u001a\u00020\r8CX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000eR\u0014\u0010\u0003\u001a\u00020\u000f8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\f\u0010\u0010R\u0011\u0010\u0011\u001a\u00020\u00028G¢\u0006\u0006\u001a\u0004\b\f\u0010\u0007"}, d2 = {"Lcom/appsflyer/internal/AFe1jSDK;", "", "", "registerClient", "Lkotlin/Lazy;", "valueOf", "AFInAppEventParameterName", "()Ljava/lang/String;", "AFKeystoreWrapper", "Lcom/appsflyer/internal/AFd1rSDK;", "values", "Lcom/appsflyer/internal/AFd1rSDK;", "AFInAppEventType", "", "()Z", "Lcom/appsflyer/internal/AFd1xSDK;", "Lcom/appsflyer/internal/AFd1xSDK;", "AFLogger", "p0", "p1", "<init>", "(Lcom/appsflyer/internal/AFd1rSDK;Lcom/appsflyer/internal/AFd1xSDK;)V", "AFa1zSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFe1jSDK {
    private static AFe1gSDK AFLogger;

    private final AFd1xSDK registerClient;

    private final Lazy valueOf;

    public final Lazy AFInAppEventParameterName;

    private final AFd1rSDK AFInAppEventType;

    public static final Companion INSTANCE = new Companion(null);
    public static String AFKeystoreWrapper = "https://%scdn-%ssettings.%s/android/v1/%s/settings";
    public static String AFInAppEventParameterName = "https://%scdn-%stestsettings.%s/android/v1/%s/settings";
    private static final List<String> unregisterClient = CollectionsKt.listOf(new String[]{"googleplay", "playstore", "googleplaystore"});

    public class AFa1tSDK {
        public static final int[] values;

        static {
            int[] iArr = new int[AFe1iSDK.values().length];
            iArr[AFe1iSDK.DEFAULT.ordinal()] = 1;
            iArr[AFe1iSDK.API.ordinal()] = 2;
            iArr[AFe1iSDK.RC.ordinal()] = 3;
            values = iArr;
        }
    }

    public static final void AFInAppEventParameterName(AFe1gSDK aFe1gSDK) {
        Companion.AFInAppEventParameterName(aFe1gSDK);
    }

    public AFe1jSDK(AFd1rSDK aFd1rSDK, AFd1xSDK aFd1xSDK) {
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(aFd1xSDK, "");
        this.AFInAppEventType = aFd1rSDK;
        this.registerClient = aFd1xSDK;
        this.valueOf = LazyKt.lazy(new Function0<String>() {
            {
                super(0);
            }

            public final String invoke() {
                String strAFInAppEventType = AFb1vSDK.AFInAppEventType(AFe1jSDK.this.registerClient, AFe1jSDK.this.AFInAppEventType.values());
                String str = strAFInAppEventType;
                if (str != null && !StringsKt.isBlank(str)) {
                    String string = StringsKt.trim(str).toString();
                    Companion companion = AFe1jSDK.INSTANCE;
                    List<String> listAFKeystoreWrapper = Companion.AFKeystoreWrapper();
                    Locale locale = Locale.getDefault();
                    Intrinsics.checkNotNullExpressionValue(locale, "");
                    String lowerCase = string.toLowerCase(locale);
                    Intrinsics.checkNotNullExpressionValue(lowerCase, "");
                    if (!listAFKeystoreWrapper.contains(lowerCase)) {
                        strAFInAppEventType = "-".concat(String.valueOf(string));
                    } else {
                        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                        String str2 = String.format("AF detected using redundant Google-Play channel for attribution - %s. Using without channel postfix.", Arrays.copyOf(new Object[]{string}, 1));
                        Intrinsics.checkNotNullExpressionValue(str2, "");
                        AFLogger.afWarnLog(str2);
                        strAFInAppEventType = "";
                    }
                }
                return StringsKt.trim(strAFInAppEventType != null ? strAFInAppEventType : "").toString();
            }
        });
        this.AFInAppEventParameterName = LazyKt.lazy(new Function0<String>() {
            {
                super(0);
            }

            public final String invoke() {
                String packageName = AFe1jSDK.this.AFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName();
                Intrinsics.checkNotNullExpressionValue(packageName, "");
                return AFe1jSDK.AFKeystoreWrapper(packageName, AFe1jSDK.AFInAppEventParameterName(AFe1jSDK.this));
            }
        });
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u0011\u0010\u0012R \u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00030\u00028\u0007X\u0087\u0004¢\u0006\f\n\u0004\b\u0004\u0010\u0005\u001a\u0004\b\u0006\u0010\u0007R\u0012\u0010\n\u001a\u00020\u0003X\u0087\u0002¢\u0006\u0006\n\u0004\b\u0006\u0010\tR\u0012\u0010\f\u001a\u00020\u0003X\u0087\u0002¢\u0006\u0006\n\u0004\b\u000b\u0010\tR\u001c\u0010\u000b\u001a\u0004\u0018\u00010\r@\u0007X\u0087\n¢\u0006\f\n\u0004\b\u000e\u0010\u000f\"\u0004\b\u000b\u0010\u0010"}, d2 = {"Lcom/appsflyer/internal/AFe1jSDK$AFa1zSDK;", "", "", "", "unregisterClient", "Ljava/util/List;", "AFKeystoreWrapper", "()Ljava/util/List;", "valueOf", "Ljava/lang/String;", "values", "AFInAppEventParameterName", "AFInAppEventType", "Lcom/appsflyer/internal/AFe1gSDK;", "AFLogger", "Lcom/appsflyer/internal/AFe1gSDK;", "(Lcom/appsflyer/internal/AFe1gSDK;)V", "<init>", "()V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public static List<String> AFKeystoreWrapper() {
            return AFe1jSDK.unregisterClient;
        }

        public static void AFInAppEventParameterName(AFe1gSDK aFe1gSDK) {
            AFe1jSDK.AFLogger = aFe1gSDK;
        }
    }

    public static boolean values() {
        return AFLogger == null;
    }

    public final String AFInAppEventType() {
        AFe1iSDK aFe1iSDK;
        if (values()) {
            aFe1iSDK = AFe1iSDK.DEFAULT;
        } else {
            aFe1iSDK = AFe1iSDK.API;
        }
        int i = AFa1tSDK.values[aFe1iSDK.ordinal()];
        if (i == 1) {
            return (String) this.AFInAppEventParameterName.getValue();
        }
        if (i != 2) {
            if (i == 3) {
                return "";
            }
            throw new NoWhenBranchMatchedException();
        }
        AFe1gSDK aFe1gSDK = AFLogger;
        String str = aFe1gSDK != null ? aFe1gSDK.values : null;
        return str == null ? "" : str;
    }

    public final String valueOf() {
        AFe1iSDK aFe1iSDK;
        if (values()) {
            aFe1iSDK = AFe1iSDK.DEFAULT;
        } else {
            aFe1iSDK = AFe1iSDK.API;
        }
        int i = AFa1tSDK.values[aFe1iSDK.ordinal()];
        if (i == 1) {
            return "appsflyersdk.com";
        }
        if (i != 2) {
            if (i == 3) {
                return "";
            }
            throw new NoWhenBranchMatchedException();
        }
        AFe1gSDK aFe1gSDK = AFLogger;
        String str = aFe1gSDK != null ? aFe1gSDK.AFKeystoreWrapper : null;
        return str == null ? "" : str;
    }

    public static final String AFKeystoreWrapper(String str, String str2) throws NoSuchAlgorithmException {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        sb2.append(str);
        sb2.append(str2);
        String string = sb2.toString();
        Intrinsics.checkNotNullParameter(string, "");
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        byte[] bytes = string.getBytes(Charsets.UTF_8);
        Intrinsics.checkNotNullExpressionValue(bytes, "");
        byte[] bArrDigest = messageDigest.digest(bytes);
        Intrinsics.checkNotNullExpressionValue(bArrDigest, "");
        String strEncodeToString = Base64.encodeToString(bArrDigest, 2);
        Intrinsics.checkNotNullExpressionValue(strEncodeToString, "");
        String lowerCase = strEncodeToString.toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "");
        String strSubstring = new Regex("[^\\w]+").replace(lowerCase, "").substring(0, 6);
        Intrinsics.checkNotNullExpressionValue(strSubstring, "");
        sb.append(strSubstring);
        sb.append('-');
        return sb.toString();
    }

    public static final String AFInAppEventParameterName(AFe1jSDK aFe1jSDK) {
        return (String) aFe1jSDK.valueOf.getValue();
    }
}
