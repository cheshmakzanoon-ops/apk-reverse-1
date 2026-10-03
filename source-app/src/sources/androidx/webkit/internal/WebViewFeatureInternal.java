package androidx.webkit.internal;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Build;
import androidx.webkit.WebViewCompat;
import androidx.webkit.WebViewFeature;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WebViewFeatureInternal {
    public static final ApiFeature.C0689M VISUAL_STATE_CALLBACK = new ApiFeature.C0689M(WebViewFeature.VISUAL_STATE_CALLBACK, WebViewFeature.VISUAL_STATE_CALLBACK);
    public static final ApiFeature.C0689M OFF_SCREEN_PRERASTER = new ApiFeature.C0689M(WebViewFeature.OFF_SCREEN_PRERASTER, WebViewFeature.OFF_SCREEN_PRERASTER);
    public static final ApiFeature.C0691O SAFE_BROWSING_ENABLE = new ApiFeature.C0691O(WebViewFeature.SAFE_BROWSING_ENABLE, WebViewFeature.SAFE_BROWSING_ENABLE);
    public static final ApiFeature.C0690N DISABLED_ACTION_MODE_MENU_ITEMS = new ApiFeature.C0690N(WebViewFeature.DISABLED_ACTION_MODE_MENU_ITEMS, WebViewFeature.DISABLED_ACTION_MODE_MENU_ITEMS);
    public static final ApiFeature.O_MR1 START_SAFE_BROWSING = new ApiFeature.O_MR1(WebViewFeature.START_SAFE_BROWSING, WebViewFeature.START_SAFE_BROWSING);

    @Deprecated
    public static final ApiFeature.O_MR1 SAFE_BROWSING_ALLOWLIST_DEPRECATED_TO_DEPRECATED = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_WHITELIST, WebViewFeature.SAFE_BROWSING_WHITELIST);

    @Deprecated
    public static final ApiFeature.O_MR1 SAFE_BROWSING_ALLOWLIST_DEPRECATED_TO_PREFERRED = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_WHITELIST, WebViewFeature.SAFE_BROWSING_ALLOWLIST);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_ALLOWLIST_PREFERRED_TO_DEPRECATED = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_ALLOWLIST, WebViewFeature.SAFE_BROWSING_WHITELIST);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_ALLOWLIST_PREFERRED_TO_PREFERRED = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_ALLOWLIST, WebViewFeature.SAFE_BROWSING_ALLOWLIST);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_PRIVACY_POLICY_URL = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_PRIVACY_POLICY_URL, WebViewFeature.SAFE_BROWSING_PRIVACY_POLICY_URL);
    public static final ApiFeature.C0690N SERVICE_WORKER_BASIC_USAGE = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_BASIC_USAGE, WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    public static final ApiFeature.C0690N SERVICE_WORKER_CACHE_MODE = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_CACHE_MODE, WebViewFeature.SERVICE_WORKER_CACHE_MODE);
    public static final ApiFeature.C0690N SERVICE_WORKER_CONTENT_ACCESS = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_CONTENT_ACCESS, WebViewFeature.SERVICE_WORKER_CONTENT_ACCESS);
    public static final ApiFeature.C0690N SERVICE_WORKER_FILE_ACCESS = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_FILE_ACCESS, WebViewFeature.SERVICE_WORKER_FILE_ACCESS);
    public static final ApiFeature.C0690N SERVICE_WORKER_BLOCK_NETWORK_LOADS = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_BLOCK_NETWORK_LOADS, WebViewFeature.SERVICE_WORKER_BLOCK_NETWORK_LOADS);
    public static final ApiFeature.C0690N SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST = new ApiFeature.C0690N(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST, WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    public static final ApiFeature.C0689M RECEIVE_WEB_RESOURCE_ERROR = new ApiFeature.C0689M(WebViewFeature.RECEIVE_WEB_RESOURCE_ERROR, WebViewFeature.RECEIVE_WEB_RESOURCE_ERROR);
    public static final ApiFeature.C0689M RECEIVE_HTTP_ERROR = new ApiFeature.C0689M(WebViewFeature.RECEIVE_HTTP_ERROR, WebViewFeature.RECEIVE_HTTP_ERROR);
    public static final ApiFeature.C0690N SHOULD_OVERRIDE_WITH_REDIRECTS = new ApiFeature.C0690N(WebViewFeature.SHOULD_OVERRIDE_WITH_REDIRECTS, WebViewFeature.SHOULD_OVERRIDE_WITH_REDIRECTS);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_HIT = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_HIT, WebViewFeature.SAFE_BROWSING_HIT);
    public static final ApiFeature.C0690N WEB_RESOURCE_REQUEST_IS_REDIRECT = new ApiFeature.C0690N(WebViewFeature.WEB_RESOURCE_REQUEST_IS_REDIRECT, WebViewFeature.WEB_RESOURCE_REQUEST_IS_REDIRECT);
    public static final ApiFeature.C0689M WEB_RESOURCE_ERROR_GET_DESCRIPTION = new ApiFeature.C0689M(WebViewFeature.WEB_RESOURCE_ERROR_GET_DESCRIPTION, WebViewFeature.WEB_RESOURCE_ERROR_GET_DESCRIPTION);
    public static final ApiFeature.C0689M WEB_RESOURCE_ERROR_GET_CODE = new ApiFeature.C0689M(WebViewFeature.WEB_RESOURCE_ERROR_GET_CODE, WebViewFeature.WEB_RESOURCE_ERROR_GET_CODE);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY, WebViewFeature.SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_RESPONSE_PROCEED = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_RESPONSE_PROCEED, WebViewFeature.SAFE_BROWSING_RESPONSE_PROCEED);
    public static final ApiFeature.O_MR1 SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL = new ApiFeature.O_MR1(WebViewFeature.SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL, WebViewFeature.SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL);
    public static final ApiFeature.C0689M WEB_MESSAGE_PORT_POST_MESSAGE = new ApiFeature.C0689M(WebViewFeature.WEB_MESSAGE_PORT_POST_MESSAGE, WebViewFeature.WEB_MESSAGE_PORT_POST_MESSAGE);
    public static final ApiFeature.C0689M WEB_MESSAGE_PORT_CLOSE = new ApiFeature.C0689M(WebViewFeature.WEB_MESSAGE_PORT_CLOSE, WebViewFeature.WEB_MESSAGE_PORT_CLOSE);
    public static final ApiFeature.NoFramework WEB_MESSAGE_ARRAY_BUFFER = new ApiFeature.NoFramework(WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER, WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER);
    public static final ApiFeature.C0689M WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK = new ApiFeature.C0689M(WebViewFeature.WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK, WebViewFeature.WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK);
    public static final ApiFeature.C0689M CREATE_WEB_MESSAGE_CHANNEL = new ApiFeature.C0689M(WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL, WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL);
    public static final ApiFeature.C0689M POST_WEB_MESSAGE = new ApiFeature.C0689M(WebViewFeature.POST_WEB_MESSAGE, WebViewFeature.POST_WEB_MESSAGE);
    public static final ApiFeature.C0689M WEB_MESSAGE_CALLBACK_ON_MESSAGE = new ApiFeature.C0689M(WebViewFeature.WEB_MESSAGE_CALLBACK_ON_MESSAGE, WebViewFeature.WEB_MESSAGE_CALLBACK_ON_MESSAGE);
    public static final ApiFeature.C0691O GET_WEB_VIEW_CLIENT = new ApiFeature.C0691O(WebViewFeature.GET_WEB_VIEW_CLIENT, WebViewFeature.GET_WEB_VIEW_CLIENT);
    public static final ApiFeature.C0691O GET_WEB_CHROME_CLIENT = new ApiFeature.C0691O(WebViewFeature.GET_WEB_CHROME_CLIENT, WebViewFeature.GET_WEB_CHROME_CLIENT);
    public static final ApiFeature.C0693Q GET_WEB_VIEW_RENDERER = new ApiFeature.C0693Q(WebViewFeature.GET_WEB_VIEW_RENDERER, WebViewFeature.GET_WEB_VIEW_RENDERER);
    public static final ApiFeature.C0693Q WEB_VIEW_RENDERER_TERMINATE = new ApiFeature.C0693Q(WebViewFeature.WEB_VIEW_RENDERER_TERMINATE, WebViewFeature.WEB_VIEW_RENDERER_TERMINATE);
    public static final ApiFeature.C0692P TRACING_CONTROLLER_BASIC_USAGE = new ApiFeature.C0692P(WebViewFeature.TRACING_CONTROLLER_BASIC_USAGE, WebViewFeature.TRACING_CONTROLLER_BASIC_USAGE);
    public static final StartupApiFeature.C0698P STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX = new StartupApiFeature.C0698P("STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX", "STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX");
    public static final StartupApiFeature.NoFramework STARTUP_FEATURE_SET_DIRECTORY_BASE_PATH = new StartupApiFeature.NoFramework(WebViewFeature.STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS, StartupFeatures.STARTUP_FEATURE_SET_DIRECTORY_BASE_PATH);
    public static final ApiFeature.C0693Q WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE = new ApiFeature.C0693Q(WebViewFeature.WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE, WebViewFeature.WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE);
    public static final ApiFeature.C0694T ALGORITHMIC_DARKENING = new ApiFeature.C0694T(WebViewFeature.ALGORITHMIC_DARKENING, WebViewFeature.ALGORITHMIC_DARKENING) {
        private final Pattern mVersionPattern = Pattern.compile("\\A\\d+");

        @Override
        public boolean isSupportedByWebView() {
            boolean zIsSupportedByWebView = super.isSupportedByWebView();
            if (!zIsSupportedByWebView || Build.VERSION.SDK_INT >= 29) {
                return zIsSupportedByWebView;
            }
            PackageInfo currentLoadedWebViewPackage = WebViewCompat.getCurrentLoadedWebViewPackage();
            if (currentLoadedWebViewPackage == null) {
                return false;
            }
            Matcher matcher = this.mVersionPattern.matcher(currentLoadedWebViewPackage.versionName);
            return matcher.find() && Integer.parseInt(currentLoadedWebViewPackage.versionName.substring(matcher.start(), matcher.end())) >= 105;
        }
    };
    public static final ApiFeature.NoFramework PROXY_OVERRIDE = new ApiFeature.NoFramework(WebViewFeature.PROXY_OVERRIDE, "PROXY_OVERRIDE:3");
    public static final ApiFeature.NoFramework MULTI_PROCESS = new ApiFeature.NoFramework(WebViewFeature.MULTI_PROCESS, "MULTI_PROCESS_QUERY");
    public static final ApiFeature.C0693Q FORCE_DARK = new ApiFeature.C0693Q(WebViewFeature.FORCE_DARK, WebViewFeature.FORCE_DARK);
    public static final ApiFeature.NoFramework FORCE_DARK_STRATEGY = new ApiFeature.NoFramework(WebViewFeature.FORCE_DARK_STRATEGY, "FORCE_DARK_BEHAVIOR");
    public static final ApiFeature.NoFramework WEB_MESSAGE_LISTENER = new ApiFeature.NoFramework(WebViewFeature.WEB_MESSAGE_LISTENER, WebViewFeature.WEB_MESSAGE_LISTENER);
    public static final ApiFeature.NoFramework DOCUMENT_START_SCRIPT = new ApiFeature.NoFramework(WebViewFeature.DOCUMENT_START_SCRIPT, "DOCUMENT_START_SCRIPT:1");
    public static final ApiFeature.NoFramework PROXY_OVERRIDE_REVERSE_BYPASS = new ApiFeature.NoFramework(WebViewFeature.PROXY_OVERRIDE_REVERSE_BYPASS, WebViewFeature.PROXY_OVERRIDE_REVERSE_BYPASS);
    public static final ApiFeature.NoFramework GET_VARIATIONS_HEADER = new ApiFeature.NoFramework(WebViewFeature.GET_VARIATIONS_HEADER, WebViewFeature.GET_VARIATIONS_HEADER);
    public static final ApiFeature.NoFramework ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY = new ApiFeature.NoFramework(WebViewFeature.ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY, WebViewFeature.ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY);
    public static final ApiFeature.NoFramework GET_COOKIE_INFO = new ApiFeature.NoFramework(WebViewFeature.GET_COOKIE_INFO, WebViewFeature.GET_COOKIE_INFO);
    public static final ApiFeature.NoFramework REQUESTED_WITH_HEADER_ALLOW_LIST = new ApiFeature.NoFramework(WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST, WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST);
    public static final ApiFeature.NoFramework USER_AGENT_METADATA = new ApiFeature.NoFramework(WebViewFeature.USER_AGENT_METADATA, WebViewFeature.USER_AGENT_METADATA);
    public static final ApiFeature.NoFramework MULTI_PROFILE = new ApiFeature.NoFramework(WebViewFeature.MULTI_PROFILE, WebViewFeature.MULTI_PROFILE) {
        @Override
        public boolean isSupportedByWebView() {
            if (super.isSupportedByWebView() && WebViewFeature.isFeatureSupported(WebViewFeature.MULTI_PROCESS)) {
                return WebViewCompat.isMultiProcessEnabled();
            }
            return false;
        }
    };
    public static final ApiFeature.NoFramework ATTRIBUTION_REGISTRATION_BEHAVIOR = new ApiFeature.NoFramework(WebViewFeature.ATTRIBUTION_REGISTRATION_BEHAVIOR, "ATTRIBUTION_BEHAVIOR");
    public static final ApiFeature.NoFramework WEBVIEW_MEDIA_INTEGRITY_API_STATUS = new ApiFeature.NoFramework(WebViewFeature.WEBVIEW_MEDIA_INTEGRITY_API_STATUS, "WEBVIEW_INTEGRITY_API_STATUS");
    public static final ApiFeature.NoFramework MUTE_AUDIO = new ApiFeature.NoFramework(WebViewFeature.MUTE_AUDIO, WebViewFeature.MUTE_AUDIO);
    public static final ApiFeature.NoFramework WEB_AUTHENTICATION = new ApiFeature.NoFramework(WebViewFeature.WEB_AUTHENTICATION, WebViewFeature.WEB_AUTHENTICATION);
    public static final ApiFeature.NoFramework SPECULATIVE_LOADING = new ApiFeature.NoFramework(WebViewFeature.SPECULATIVE_LOADING, "SPECULATIVE_LOADING");
    public static final ApiFeature.NoFramework BACK_FORWARD_CACHE = new ApiFeature.NoFramework(WebViewFeature.BACK_FORWARD_CACHE, WebViewFeature.BACK_FORWARD_CACHE);

    private WebViewFeatureInternal() {
    }

    public static boolean isSupported(String str) {
        return isSupported(str, ApiFeature.values());
    }

    public static boolean isStartupFeatureSupported(String str, Context context) {
        return isStartupFeatureSupported(str, StartupApiFeature.values(), context);
    }

    public static <T extends ConditionallySupportedFeature> boolean isSupported(String str, Collection<T> collection) {
        HashSet hashSet = new HashSet();
        for (T t : collection) {
            if (t.getPublicFeatureName().equals(str)) {
                hashSet.add(t);
            }
        }
        if (hashSet.isEmpty()) {
            throw new RuntimeException("Unknown feature " + str);
        }
        Iterator it = hashSet.iterator();
        while (it.hasNext()) {
            if (((ConditionallySupportedFeature) it.next()).isSupported()) {
                return true;
            }
        }
        return false;
    }

    public static boolean isStartupFeatureSupported(String str, Collection<StartupApiFeature> collection, Context context) {
        HashSet hashSet = new HashSet();
        for (StartupApiFeature startupApiFeature : collection) {
            if (startupApiFeature.getPublicFeatureName().equals(str)) {
                hashSet.add(startupApiFeature);
            }
        }
        if (hashSet.isEmpty()) {
            throw new RuntimeException("Unknown feature " + str);
        }
        Iterator it = hashSet.iterator();
        while (it.hasNext()) {
            if (((StartupApiFeature) it.next()).isSupported(context)) {
                return true;
            }
        }
        return false;
    }

    public static UnsupportedOperationException getUnsupportedOperationException() {
        return new UnsupportedOperationException("This method is not supported by the current version of the framework and the current WebView APK");
    }
}
