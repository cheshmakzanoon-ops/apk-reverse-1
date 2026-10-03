package androidx.webkit.internal;

import android.os.Build;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import org.chromium.support_lib_boundary.util.BoundaryInterfaceReflectionUtil;

public abstract class ApiFeature implements ConditionallySupportedFeature {
    private static final Set<ApiFeature> sValues = new HashSet();
    private final String mInternalFeatureValue;
    private final String mPublicFeatureValue;

    public abstract boolean isSupportedByFramework();

    ApiFeature(String str, String str2) {
        this.mPublicFeatureValue = str;
        this.mInternalFeatureValue = str2;
        sValues.add(this);
    }

    @Override
    public String getPublicFeatureName() {
        return this.mPublicFeatureValue;
    }

    @Override
    public boolean isSupported() {
        return isSupportedByFramework() || isSupportedByWebView();
    }

    public boolean isSupportedByWebView() {
        return BoundaryInterfaceReflectionUtil.containsFeature(LAZY_HOLDER.WEBVIEW_APK_FEATURES, this.mInternalFeatureValue);
    }

    public static Set<ApiFeature> values() {
        return Collections.unmodifiableSet(sValues);
    }

    public static Set<String> getWebViewApkFeaturesForTesting() {
        return LAZY_HOLDER.WEBVIEW_APK_FEATURES;
    }

    private static class LAZY_HOLDER {
        static final Set<String> WEBVIEW_APK_FEATURES = new HashSet(Arrays.asList(WebViewGlueCommunicator.getFactory().getWebViewFeatures()));

        private LAZY_HOLDER() {
        }
    }

    public static class NoFramework extends ApiFeature {
        @Override
        public final boolean isSupportedByFramework() {
            return false;
        }

        NoFramework(String str, String str2) {
            super(str, str2);
        }
    }

    public static class C0689M extends ApiFeature {
        @Override
        public final boolean isSupportedByFramework() {
            return true;
        }

        C0689M(String str, String str2) {
            super(str, str2);
        }
    }

    public static class C0690N extends ApiFeature {
        C0690N(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 24;
        }
    }

    public static class C0691O extends ApiFeature {
        C0691O(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 26;
        }
    }

    public static class O_MR1 extends ApiFeature {
        O_MR1(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 27;
        }
    }

    public static class C0692P extends ApiFeature {
        C0692P(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 28;
        }
    }

    public static class C0693Q extends ApiFeature {
        C0693Q(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 29;
        }
    }

    public static class C0694T extends ApiFeature {
        C0694T(String str, String str2) {
            super(str, str2);
        }

        @Override
        public final boolean isSupportedByFramework() {
            return Build.VERSION.SDK_INT >= 33;
        }
    }
}
