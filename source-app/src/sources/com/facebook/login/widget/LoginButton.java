package com.facebook.login.widget;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Build;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.ActivityResultRegistryOwner;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookButtonBase;
import com.facebook.FacebookCallback;
import com.facebook.FacebookSdk;
import com.facebook.Profile;
import com.facebook.appevents.InternalAppEventsLogger;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import com.facebook.common.C0913R;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.AnalyticsEvents;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.FetchedAppSettings;
import com.facebook.internal.FetchedAppSettingsManager;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.Utility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.login.C0949R;
import com.facebook.login.DefaultAudience;
import com.facebook.login.LoginBehavior;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.LoginTargetApp;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import kotlin.Deprecated;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;

@Metadata(d1 = {"\u0000à\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u001e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0011\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0016\u0018\u0000 ©\u00012\u00020\u0001:\b©\u0001ª\u0001«\u0001¬\u0001B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0019\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0007B!\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nB9\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\u0006\u0010\u000b\u001a\u00020\t\u0012\u0006\u0010\f\u001a\u00020\t\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u000f\u001a\u00020\u000e¢\u0006\u0002\u0010\u0010J\b\u0010|\u001a\u00020}H\u0003J\u0006\u0010~\u001a\u00020}J*\u0010\u007f\u001a\u00020}2\u0006\u0010\u0002\u001a\u00020\u00032\b\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u000b\u001a\u00020\t2\u0006\u0010\f\u001a\u00020\tH\u0015J\u0007\u0010\u0080\u0001\u001a\u00020}J\u0012\u0010\u0081\u0001\u001a\u00020}2\u0007\u0010\u0082\u0001\u001a\u00020\u000eH\u0003J\u0012\u0010\u0083\u0001\u001a\u00020\t2\u0007\u0010\u0084\u0001\u001a\u00020\tH\u0005J\u0012\u0010\u0085\u0001\u001a\u00020\t2\u0007\u0010\u0086\u0001\u001a\u00020\u000eH\u0003J\t\u0010\u0087\u0001\u001a\u00020}H\u0015J\t\u0010\u0088\u0001\u001a\u00020}H\u0015J\u0013\u0010\u0089\u0001\u001a\u00020}2\b\u0010\u008a\u0001\u001a\u00030\u008b\u0001H\u0015J6\u0010\u008c\u0001\u001a\u00020}2\u0007\u0010\u008d\u0001\u001a\u00020\"2\u0007\u0010\u008e\u0001\u001a\u00020\t2\u0007\u0010\u008f\u0001\u001a\u00020\t2\u0007\u0010\u0090\u0001\u001a\u00020\t2\u0007\u0010\u0091\u0001\u001a\u00020\tH\u0015J\u001b\u0010\u0092\u0001\u001a\u00020}2\u0007\u0010\u0084\u0001\u001a\u00020\t2\u0007\u0010\u0093\u0001\u001a\u00020\tH\u0015J\u001c\u0010\u0094\u0001\u001a\u00020}2\b\u0010\u0095\u0001\u001a\u00030\u0096\u00012\u0007\u0010\u0097\u0001\u001a\u00020\tH\u0015J+\u0010\u0098\u0001\u001a\u00020}2\u0006\u0010\u0002\u001a\u00020\u00032\b\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u000b\u001a\u00020\t2\u0006\u0010\f\u001a\u00020\tH\u0005J \u0010\u0099\u0001\u001a\u00020}2\u0006\u0010\u001e\u001a\u00020\u001d2\u000f\u0010\u009a\u0001\u001a\n\u0012\u0005\u0012\u00030\u009c\u00010\u009b\u0001J\t\u0010\u009d\u0001\u001a\u00020}H\u0005J\t\u0010\u009e\u0001\u001a\u00020}H\u0005J\t\u0010\u009f\u0001\u001a\u00020}H\u0005J\t\u0010 \u0001\u001a\u00020}H\u0005J%\u0010Z\u001a\u00020}2\u0017\u0010W\u001a\r\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u000e0¡\u0001\"\u0004\u0018\u00010\u000e¢\u0006\u0003\u0010¢\u0001J(\u0010£\u0001\u001a\u00020}2\u0017\u0010W\u001a\r\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u000e0¡\u0001\"\u0004\u0018\u00010\u000eH\u0007¢\u0006\u0003\u0010¢\u0001J\u0017\u0010£\u0001\u001a\u00020}2\f\u0010W\u001a\b\u0012\u0004\u0012\u00020\u000e0VH\u0007J(\u0010¤\u0001\u001a\u00020}2\u0017\u0010W\u001a\r\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u000e0¡\u0001\"\u0004\u0018\u00010\u000eH\u0007¢\u0006\u0003\u0010¢\u0001J\u0017\u0010¤\u0001\u001a\u00020}2\f\u0010W\u001a\b\u0012\u0004\u0012\u00020\u000e0VH\u0007J\u0015\u0010¥\u0001\u001a\u00020}2\n\u0010¦\u0001\u001a\u0005\u0018\u00010§\u0001H\u0003J\u000f\u0010¨\u0001\u001a\u00020}2\u0006\u0010\u001e\u001a\u00020\u001dR\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010\u0013\u001a\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000e0\u0015\u0018\u00010\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\u0017\u001a\u00020\u000e2\u0006\u0010\u0016\u001a\u00020\u000e8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR\"\u0010\u001e\u001a\u0004\u0018\u00010\u001d2\b\u0010\u001c\u001a\u0004\u0018\u00010\u001d@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u000e\u0010!\u001a\u00020\"X\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010#\u001a\u0004\u0018\u00010$X\u0082\u000e¢\u0006\u0004\n\u0002\u0010%R\u000e\u0010&\u001a\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010(\u001a\u00020'2\u0006\u0010\u0016\u001a\u00020'8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b)\u0010*\"\u0004\b+\u0010,R\u0014\u0010-\u001a\u00020\t8UX\u0094\u0004¢\u0006\u0006\u001a\u0004\b.\u0010/R\u0014\u00100\u001a\u00020\t8TX\u0094\u0004¢\u0006\u0006\u001a\u0004\b1\u0010/R\u0011\u00102\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b3\u0010\u0019R$\u00105\u001a\u0002042\u0006\u0010\u0016\u001a\u0002048F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b6\u00107\"\u0004\b8\u00109R\u0014\u0010:\u001a\u00020\t8EX\u0084\u0004¢\u0006\u0006\u001a\u0004\b;\u0010/R \u0010<\u001a\b\u0012\u0004\u0012\u00020>0=X\u0084\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b?\u0010@\"\u0004\bA\u0010BR$\u0010D\u001a\u00020C2\u0006\u0010\u0016\u001a\u00020C8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bE\u0010F\"\u0004\bG\u0010HR(\u0010I\u001a\u0004\u0018\u00010\u000e2\b\u0010\u0016\u001a\u0004\u0018\u00010\u000e@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bJ\u0010\u0019\"\u0004\bK\u0010\u001bR(\u0010L\u001a\u0004\u0018\u00010\u000e2\b\u0010\u0016\u001a\u0004\u0018\u00010\u000e@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bM\u0010\u0019\"\u0004\bN\u0010\u001bR(\u0010O\u001a\u0004\u0018\u00010\u000e2\b\u0010\u0016\u001a\u0004\u0018\u00010\u000e8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bP\u0010\u0019\"\u0004\bQ\u0010\u001bR\u0018\u0010R\u001a\u00060SR\u00020\u00008TX\u0094\u0004¢\u0006\u0006\u001a\u0004\bT\u0010UR0\u0010W\u001a\b\u0012\u0004\u0012\u00020\u000e0V2\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u000e0V8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bX\u0010Y\"\u0004\bZ\u0010[R\u0014\u0010\\\u001a\u00020]X\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b^\u0010_R$\u0010`\u001a\u00020\"2\u0006\u0010\u0016\u001a\u00020\"8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\ba\u0010b\"\u0004\bc\u0010dR\u0011\u0010e\u001a\u00020\"8F¢\u0006\u0006\u001a\u0004\bf\u0010bR\u000e\u0010g\u001a\u00020\"X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010h\u001a\u00020iX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bj\u0010k\"\u0004\bl\u0010mR\u001a\u0010n\u001a\u00020oX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bp\u0010q\"\u0004\br\u0010sR\u0010\u0010t\u001a\u0004\u0018\u00010uX\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010v\u001a\u00020wX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bx\u0010y\"\u0004\bz\u0010{¨\u0006\u00ad\u0001"}, d2 = {"Lcom/facebook/login/widget/LoginButton;", "Lcom/facebook/FacebookButtonBase;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "attrs", "Landroid/util/AttributeSet;", "(Landroid/content/Context;Landroid/util/AttributeSet;)V", "defStyle", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "defStyleAttr", "defStyleRes", "analyticsButtonCreatedEventName", "", "analyticsButtonTappedEventName", "(Landroid/content/Context;Landroid/util/AttributeSet;IILjava/lang/String;Ljava/lang/String;)V", "accessTokenTracker", "Lcom/facebook/AccessTokenTracker;", "androidXLoginCaller", "Landroidx/activity/result/ActivityResultLauncher;", "", SDKConstants.PARAM_VALUE, "authType", "getAuthType", "()Ljava/lang/String;", "setAuthType", "(Ljava/lang/String;)V", "<set-?>", "Lcom/facebook/CallbackManager;", "callbackManager", "getCallbackManager", "()Lcom/facebook/CallbackManager;", "confirmLogout", "", "customButtonRadius", "", "Ljava/lang/Float;", "customButtonTransparency", "Lcom/facebook/login/DefaultAudience;", "defaultAudience", "getDefaultAudience", "()Lcom/facebook/login/DefaultAudience;", "setDefaultAudience", "(Lcom/facebook/login/DefaultAudience;)V", "defaultRequestCode", "getDefaultRequestCode", "()I", "defaultStyleResource", "getDefaultStyleResource", "loggerID", "getLoggerID", "Lcom/facebook/login/LoginBehavior;", "loginBehavior", "getLoginBehavior", "()Lcom/facebook/login/LoginBehavior;", "setLoginBehavior", "(Lcom/facebook/login/LoginBehavior;)V", "loginButtonContinueLabel", "getLoginButtonContinueLabel", "loginManagerLazy", "Lkotlin/Lazy;", "Lcom/facebook/login/LoginManager;", "getLoginManagerLazy", "()Lkotlin/Lazy;", "setLoginManagerLazy", "(Lkotlin/Lazy;)V", "Lcom/facebook/login/LoginTargetApp;", "loginTargetApp", "getLoginTargetApp", "()Lcom/facebook/login/LoginTargetApp;", "setLoginTargetApp", "(Lcom/facebook/login/LoginTargetApp;)V", "loginText", "getLoginText", "setLoginText", "logoutText", "getLogoutText", "setLogoutText", "messengerPageId", "getMessengerPageId", "setMessengerPageId", "newLoginClickListener", "Lcom/facebook/login/widget/LoginButton$LoginClickListener;", "getNewLoginClickListener", "()Lcom/facebook/login/widget/LoginButton$LoginClickListener;", "", "permissions", "getPermissions", "()Ljava/util/List;", "setPermissions", "(Ljava/util/List;)V", "properties", "Lcom/facebook/login/widget/LoginButton$LoginButtonProperties;", "getProperties", "()Lcom/facebook/login/widget/LoginButton$LoginButtonProperties;", "resetMessengerState", "getResetMessengerState", "()Z", "setResetMessengerState", "(Z)V", "shouldSkipAccountDeduplication", "getShouldSkipAccountDeduplication", "toolTipChecked", "toolTipDisplayTime", "", "getToolTipDisplayTime", "()J", "setToolTipDisplayTime", "(J)V", "toolTipMode", "Lcom/facebook/login/widget/LoginButton$ToolTipMode;", "getToolTipMode", "()Lcom/facebook/login/widget/LoginButton$ToolTipMode;", "setToolTipMode", "(Lcom/facebook/login/widget/LoginButton$ToolTipMode;)V", "toolTipPopup", "Lcom/facebook/login/widget/ToolTipPopup;", "toolTipStyle", "Lcom/facebook/login/widget/ToolTipPopup$Style;", "getToolTipStyle", "()Lcom/facebook/login/widget/ToolTipPopup$Style;", "setToolTipStyle", "(Lcom/facebook/login/widget/ToolTipPopup$Style;)V", "checkToolTipSettings", "", "clearPermissions", "configureButton", "dismissToolTip", "displayToolTip", "toolTipString", "getLoginButtonWidth", "widthMeasureSpec", "measureButtonWidth", "text", "onAttachedToWindow", "onDetachedFromWindow", "onDraw", "canvas", "Landroid/graphics/Canvas;", "onLayout", "changed", ViewHierarchyConstants.DIMENSION_LEFT_KEY, ViewHierarchyConstants.DIMENSION_TOP_KEY, "right", "bottom", "onMeasure", "heightMeasureSpec", "onVisibilityChanged", "changedView", "Landroid/view/View;", "visibility", "parseLoginButtonAttributes", "registerCallback", "callback", "Lcom/facebook/FacebookCallback;", "Lcom/facebook/login/LoginResult;", "setButtonIcon", "setButtonRadius", "setButtonText", "setButtonTransparency", "", "([Ljava/lang/String;)V", "setPublishPermissions", "setReadPermissions", "showToolTipPerSettings", "settings", "Lcom/facebook/internal/FetchedAppSettings;", "unregisterCallback", "Companion", "LoginButtonProperties", "LoginClickListener", "ToolTipMode", "facebook-login_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public class LoginButton extends FacebookButtonBase {
    private static final int MAX_BUTTON_TRANSPARENCY = 255;
    private static final int MIN_BUTTON_TRANSPARENCY = 0;
    private AccessTokenTracker accessTokenTracker;
    private ActivityResultLauncher<Collection<String>> androidXLoginCaller;
    private CallbackManager callbackManager;
    private boolean confirmLogout;
    private Float customButtonRadius;
    private int customButtonTransparency;
    private final String loggerID;
    private Lazy<? extends LoginManager> loginManagerLazy;
    private String loginText;
    private String logoutText;
    private final LoginButtonProperties properties;
    private boolean toolTipChecked;
    private long toolTipDisplayTime;
    private ToolTipMode toolTipMode;
    private ToolTipPopup toolTipPopup;
    private ToolTipPopup.Style toolTipStyle;
    private static final String TAG = LoginButton.class.getName();

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ToolTipMode.values().length];
            iArr[ToolTipMode.AUTOMATIC.ordinal()] = 1;
            iArr[ToolTipMode.DISPLAY_ALWAYS.ordinal()] = 2;
            iArr[ToolTipMode.NEVER_DISPLAY.ordinal()] = 3;
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final void m2568onAttachedToWindow$lambda0(CallbackManager.ActivityResultParameters activityResultParameters) {
    }

    protected LoginButton(Context context, AttributeSet attributeSet, int i, int i2, String str, String str2) {
        super(context, attributeSet, i, i2, str, str2);
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(str, "analyticsButtonCreatedEventName");
        Intrinsics.checkNotNullParameter(str2, "analyticsButtonTappedEventName");
        this.properties = new LoginButtonProperties();
        this.toolTipStyle = ToolTipPopup.Style.BLUE;
        this.toolTipMode = ToolTipMode.INSTANCE.getDEFAULT();
        this.toolTipDisplayTime = ToolTipPopup.DEFAULT_POPUP_DISPLAY_TIME;
        this.loginManagerLazy = LazyKt.lazy(new Function0<LoginManager>() {
            public final LoginManager m2570invoke() {
                return LoginManager.INSTANCE.getInstance();
            }
        });
        this.customButtonTransparency = 255;
        String string = UUID.randomUUID().toString();
        Intrinsics.checkNotNullExpressionValue(string, "randomUUID().toString()");
        this.loggerID = string;
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\t\b\u0086\u0001\u0018\u0000 \r2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\rB\u0017\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\t\u001a\u00020\u0003H\u0016R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000j\u0002\b\nj\u0002\b\u000bj\u0002\b\f¨\u0006\u000e"}, d2 = {"Lcom/facebook/login/widget/LoginButton$ToolTipMode;", "", "stringValue", "", "intValue", "", "(Ljava/lang/String;ILjava/lang/String;I)V", "getIntValue", "()I", "toString", "AUTOMATIC", "DISPLAY_ALWAYS", "NEVER_DISPLAY", "Companion", "facebook-login_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class ToolTipMode {
        AUTOMATIC(AnalyticsEvents.PARAMETER_SHARE_DIALOG_SHOW_AUTOMATIC, 0),
        DISPLAY_ALWAYS("display_always", 1),
        NEVER_DISPLAY("never_display", 2);

        private static final ToolTipMode DEFAULT = new ToolTipMode(AnalyticsEvents.PARAMETER_SHARE_DIALOG_SHOW_AUTOMATIC, 0);
        private final int intValue;
        private final String stringValue;

        public static final Companion INSTANCE = new Companion(null);

        private ToolTipMode(String str, int i) {
            super(str, i);
            this.stringValue = str;
            this.intValue = i;
        }

        public final int getIntValue() {
            return this.intValue;
        }

        static {
        }

        @Override
        public String toString() {
            return this.stringValue;
        }

        @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0007\u001a\u0004\u0018\u00010\u00042\u0006\u0010\b\u001a\u00020\tR\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\n"}, d2 = {"Lcom/facebook/login/widget/LoginButton$ToolTipMode$Companion;", "", "()V", "DEFAULT", "Lcom/facebook/login/widget/LoginButton$ToolTipMode;", "getDEFAULT", "()Lcom/facebook/login/widget/LoginButton$ToolTipMode;", "fromInt", "enumValue", "", "facebook-login_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final ToolTipMode getDEFAULT() {
                return ToolTipMode.DEFAULT;
            }

            public final ToolTipMode fromInt(int enumValue) {
                for (ToolTipMode toolTipMode : ToolTipMode.values()) {
                    if (toolTipMode.getIntValue() == enumValue) {
                        return toolTipMode;
                    }
                }
                return null;
            }
        }

        public static ToolTipMode valueOf(String str) {
            Intrinsics.checkNotNullParameter(str, SDKConstants.PARAM_VALUE);
            return (ToolTipMode) Enum.valueOf(ToolTipMode.class, str);
        }

        public static ToolTipMode[] values() {
            ToolTipMode[] toolTipModeArr = $VALUES;
            return (ToolTipMode[]) Arrays.copyOf(toolTipModeArr, toolTipModeArr.length);
        }
    }

    public final String getLoginText() {
        return this.loginText;
    }

    public final void setLoginText(String str) {
        this.loginText = str;
        setButtonText();
    }

    public final String getLogoutText() {
        return this.logoutText;
    }

    public final void setLogoutText(String str) {
        this.logoutText = str;
        setButtonText();
    }

    protected final LoginButtonProperties getProperties() {
        return this.properties;
    }

    public final ToolTipPopup.Style getToolTipStyle() {
        return this.toolTipStyle;
    }

    public final void setToolTipStyle(ToolTipPopup.Style style) {
        Intrinsics.checkNotNullParameter(style, "<set-?>");
        this.toolTipStyle = style;
    }

    public final ToolTipMode getToolTipMode() {
        return this.toolTipMode;
    }

    public final void setToolTipMode(ToolTipMode toolTipMode) {
        Intrinsics.checkNotNullParameter(toolTipMode, "<set-?>");
        this.toolTipMode = toolTipMode;
    }

    public final long getToolTipDisplayTime() {
        return this.toolTipDisplayTime;
    }

    public final void setToolTipDisplayTime(long j) {
        this.toolTipDisplayTime = j;
    }

    protected final Lazy<LoginManager> getLoginManagerLazy() {
        return this.loginManagerLazy;
    }

    protected final void setLoginManagerLazy(Lazy<? extends LoginManager> lazy) {
        Intrinsics.checkNotNullParameter(lazy, "<set-?>");
        this.loginManagerLazy = lazy;
    }

    public final String getLoggerID() {
        return this.loggerID;
    }

    public final CallbackManager getCallbackManager() {
        return this.callbackManager;
    }

    @Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010 \n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\t\n\u0002\u0010\u0002\n\u0000\b\u0016\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0006\u0010.\u001a\u00020/R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\t\u001a\u00020\nX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\u0010X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R\u001a\u0010\u0015\u001a\u00020\u0016X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR\u001c\u0010\u001b\u001a\u0004\u0018\u00010\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u0006\"\u0004\b\u001d\u0010\bR \u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00040\u001fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u001a\u0010$\u001a\u00020%X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010'\"\u0004\b(\u0010)R$\u0010+\u001a\u00020%2\u0006\u0010*\u001a\u00020%@DX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b,\u0010'\"\u0004\b-\u0010)¨\u00060"}, d2 = {"Lcom/facebook/login/widget/LoginButton$LoginButtonProperties;", "", "()V", "authType", "", "getAuthType", "()Ljava/lang/String;", "setAuthType", "(Ljava/lang/String;)V", "defaultAudience", "Lcom/facebook/login/DefaultAudience;", "getDefaultAudience", "()Lcom/facebook/login/DefaultAudience;", "setDefaultAudience", "(Lcom/facebook/login/DefaultAudience;)V", "loginBehavior", "Lcom/facebook/login/LoginBehavior;", "getLoginBehavior", "()Lcom/facebook/login/LoginBehavior;", "setLoginBehavior", "(Lcom/facebook/login/LoginBehavior;)V", "loginTargetApp", "Lcom/facebook/login/LoginTargetApp;", "getLoginTargetApp", "()Lcom/facebook/login/LoginTargetApp;", "setLoginTargetApp", "(Lcom/facebook/login/LoginTargetApp;)V", "messengerPageId", "getMessengerPageId", "setMessengerPageId", "permissions", "", "getPermissions", "()Ljava/util/List;", "setPermissions", "(Ljava/util/List;)V", "resetMessengerState", "", "getResetMessengerState", "()Z", "setResetMessengerState", "(Z)V", "<set-?>", "shouldSkipAccountDeduplication", "getShouldSkipAccountDeduplication", "setShouldSkipAccountDeduplication", "clearPermissions", "", "facebook-login_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static class LoginButtonProperties {
        private String messengerPageId;
        private boolean resetMessengerState;
        private boolean shouldSkipAccountDeduplication;
        private DefaultAudience defaultAudience = DefaultAudience.FRIENDS;
        private List<String> permissions = CollectionsKt.emptyList();
        private LoginBehavior loginBehavior = LoginBehavior.NATIVE_WITH_FALLBACK;
        private String authType = ServerProtocol.DIALOG_REREQUEST_AUTH_TYPE;
        private LoginTargetApp loginTargetApp = LoginTargetApp.FACEBOOK;

        public final DefaultAudience getDefaultAudience() {
            return this.defaultAudience;
        }

        public final void setDefaultAudience(DefaultAudience defaultAudience) {
            Intrinsics.checkNotNullParameter(defaultAudience, "<set-?>");
            this.defaultAudience = defaultAudience;
        }

        public final List<String> getPermissions() {
            return this.permissions;
        }

        public final void setPermissions(List<String> list) {
            Intrinsics.checkNotNullParameter(list, "<set-?>");
            this.permissions = list;
        }

        public final LoginBehavior getLoginBehavior() {
            return this.loginBehavior;
        }

        public final void setLoginBehavior(LoginBehavior loginBehavior) {
            Intrinsics.checkNotNullParameter(loginBehavior, "<set-?>");
            this.loginBehavior = loginBehavior;
        }

        public final String getAuthType() {
            return this.authType;
        }

        public final void setAuthType(String str) {
            Intrinsics.checkNotNullParameter(str, "<set-?>");
            this.authType = str;
        }

        public final LoginTargetApp getLoginTargetApp() {
            return this.loginTargetApp;
        }

        public final void setLoginTargetApp(LoginTargetApp loginTargetApp) {
            Intrinsics.checkNotNullParameter(loginTargetApp, "<set-?>");
            this.loginTargetApp = loginTargetApp;
        }

        public final boolean getShouldSkipAccountDeduplication() {
            return this.shouldSkipAccountDeduplication;
        }

        protected final void setShouldSkipAccountDeduplication(boolean z) {
            this.shouldSkipAccountDeduplication = z;
        }

        public final String getMessengerPageId() {
            return this.messengerPageId;
        }

        public final void setMessengerPageId(String str) {
            this.messengerPageId = str;
        }

        public final boolean getResetMessengerState() {
            return this.resetMessengerState;
        }

        public final void setResetMessengerState(boolean z) {
            this.resetMessengerState = z;
        }

        public final void clearPermissions() {
            this.permissions = CollectionsKt.emptyList();
        }
    }

    public LoginButton(Context context) {
        this(context, null, 0, 0, AnalyticsEvents.EVENT_LOGIN_BUTTON_CREATE, AnalyticsEvents.EVENT_LOGIN_BUTTON_DID_TAP);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoginButton(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, AnalyticsEvents.EVENT_LOGIN_BUTTON_CREATE, AnalyticsEvents.EVENT_LOGIN_BUTTON_DID_TAP);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public LoginButton(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, AnalyticsEvents.EVENT_LOGIN_BUTTON_CREATE, AnalyticsEvents.EVENT_LOGIN_BUTTON_DID_TAP);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public final DefaultAudience getDefaultAudience() {
        return this.properties.getDefaultAudience();
    }

    public final void setDefaultAudience(DefaultAudience defaultAudience) {
        Intrinsics.checkNotNullParameter(defaultAudience, SDKConstants.PARAM_VALUE);
        this.properties.setDefaultAudience(defaultAudience);
    }

    @Deprecated(message = "Use setPermissions instead", replaceWith = @ReplaceWith(expression = "setPermissions", imports = {}))
    public final void setReadPermissions(List<String> permissions) {
        Intrinsics.checkNotNullParameter(permissions, "permissions");
        this.properties.setPermissions(permissions);
    }

    @Deprecated(message = "Use setPermissions instead", replaceWith = @ReplaceWith(expression = "setPermissions", imports = {}))
    public final void setReadPermissions(String... permissions) {
        Intrinsics.checkNotNullParameter(permissions, "permissions");
        this.properties.setPermissions(CollectionsKt.listOfNotNull(Arrays.copyOf(permissions, permissions.length)));
    }

    public final void setPermissions(String... permissions) {
        Intrinsics.checkNotNullParameter(permissions, "permissions");
        this.properties.setPermissions(CollectionsKt.listOfNotNull(Arrays.copyOf(permissions, permissions.length)));
    }

    @Deprecated(message = "Use setPermissions instead", replaceWith = @ReplaceWith(expression = "setPermissions", imports = {}))
    public final void setPublishPermissions(List<String> permissions) {
        Intrinsics.checkNotNullParameter(permissions, "permissions");
        this.properties.setPermissions(permissions);
    }

    @Deprecated(message = "Use setPermissions instead", replaceWith = @ReplaceWith(expression = "setPermissions", imports = {}))
    public final void setPublishPermissions(String... permissions) {
        Intrinsics.checkNotNullParameter(permissions, "permissions");
        this.properties.setPermissions(CollectionsKt.listOfNotNull(Arrays.copyOf(permissions, permissions.length)));
    }

    public final void clearPermissions() {
        this.properties.clearPermissions();
    }

    public final LoginBehavior getLoginBehavior() {
        return this.properties.getLoginBehavior();
    }

    public final void setLoginBehavior(LoginBehavior loginBehavior) {
        Intrinsics.checkNotNullParameter(loginBehavior, SDKConstants.PARAM_VALUE);
        this.properties.setLoginBehavior(loginBehavior);
    }

    public final LoginTargetApp getLoginTargetApp() {
        return this.properties.getLoginTargetApp();
    }

    public final void setLoginTargetApp(LoginTargetApp loginTargetApp) {
        Intrinsics.checkNotNullParameter(loginTargetApp, SDKConstants.PARAM_VALUE);
        this.properties.setLoginTargetApp(loginTargetApp);
    }

    public final String getAuthType() {
        return this.properties.getAuthType();
    }

    public final void setAuthType(String str) {
        Intrinsics.checkNotNullParameter(str, SDKConstants.PARAM_VALUE);
        this.properties.setAuthType(str);
    }

    public final String getMessengerPageId() {
        return this.properties.getMessengerPageId();
    }

    public final void setMessengerPageId(String str) {
        this.properties.setMessengerPageId(str);
    }

    public final boolean getResetMessengerState() {
        return this.properties.getResetMessengerState();
    }

    public final void setResetMessengerState(boolean z) {
        this.properties.setResetMessengerState(z);
    }

    public final boolean getShouldSkipAccountDeduplication() {
        return this.properties.getShouldSkipAccountDeduplication();
    }

    public final void dismissToolTip() {
        ToolTipPopup toolTipPopup = this.toolTipPopup;
        if (toolTipPopup != null) {
            toolTipPopup.dismiss();
        }
        this.toolTipPopup = null;
    }

    public final void registerCallback(CallbackManager callbackManager, FacebookCallback<LoginResult> callback) {
        Intrinsics.checkNotNullParameter(callbackManager, "callbackManager");
        Intrinsics.checkNotNullParameter(callback, "callback");
        ((LoginManager) this.loginManagerLazy.getValue()).registerCallback(callbackManager, callback);
        CallbackManager callbackManager2 = this.callbackManager;
        if (callbackManager2 == null) {
            this.callbackManager = callbackManager;
        } else if (callbackManager2 != callbackManager) {
            Log.w(TAG, "You're registering a callback on the one Facebook login button with two different callback managers. It's almost wrong and may cause unexpected results. Only the first callback manager will be used for handling activity result with androidx.");
        }
    }

    public final void unregisterCallback(CallbackManager callbackManager) {
        Intrinsics.checkNotNullParameter(callbackManager, "callbackManager");
        ((LoginManager) this.loginManagerLazy.getValue()).unregisterCallback(callbackManager);
    }

    protected final int getLoginButtonContinueLabel() {
        return C0949R.string.com_facebook_loginview_log_in_button_continue;
    }

    @Override
    protected void onAttachedToWindow() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            super.onAttachedToWindow();
            if (getContext() instanceof ActivityResultRegistryOwner) {
                ActivityResultRegistryOwner context = getContext();
                if (context == null) {
                    throw new NullPointerException("null cannot be cast to non-null type androidx.activity.result.ActivityResultRegistryOwner");
                }
                this.androidXLoginCaller = context.getActivityResultRegistry().register("facebook-login", ((LoginManager) this.loginManagerLazy.getValue()).createLogInActivityResultContract(this.callbackManager, this.loggerID), new ActivityResultCallback() {
                    public final void onActivityResult(Object obj) {
                        LoginButton.m2568onAttachedToWindow$lambda0((CallbackManager.ActivityResultParameters) obj);
                    }
                });
            }
            AccessTokenTracker accessTokenTracker = this.accessTokenTracker;
            if (accessTokenTracker != null && accessTokenTracker.getIsTracking()) {
                accessTokenTracker.startTracking();
                setButtonText();
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(canvas, "canvas");
            super.onDraw(canvas);
            if (this.toolTipChecked || isInEditMode()) {
                return;
            }
            this.toolTipChecked = true;
            checkToolTipSettings();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void showToolTipPerSettings(FetchedAppSettings settings) {
        if (CrashShieldHandler.isObjectCrashing(this) || settings == null) {
            return;
        }
        try {
            if (settings.getNuxEnabled() && getVisibility() == 0) {
                displayToolTip(settings.getNuxContent());
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void displayToolTip(String toolTipString) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            ToolTipPopup toolTipPopup = new ToolTipPopup(toolTipString, this);
            toolTipPopup.setStyle(this.toolTipStyle);
            toolTipPopup.setNuxDisplayTime(this.toolTipDisplayTime);
            toolTipPopup.show();
            this.toolTipPopup = toolTipPopup;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void checkToolTipSettings() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            int i = WhenMappings.$EnumSwitchMapping$0[this.toolTipMode.ordinal()];
            if (i == 1) {
                Utility utility = Utility.INSTANCE;
                final String metadataApplicationId = Utility.getMetadataApplicationId(getContext());
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                FacebookSdk.getExecutor().execute(new Runnable() {
                    @Override
                    public final void run() {
                        LoginButton.m2566checkToolTipSettings$lambda3(metadataApplicationId, this);
                    }
                });
                return;
            }
            if (i != 2) {
                return;
            }
            String string = getResources().getString(C0949R.string.com_facebook_tooltip_default);
            Intrinsics.checkNotNullExpressionValue(string, "resources.getString(R.string.com_facebook_tooltip_default)");
            displayToolTip(string);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    public static final void m2566checkToolTipSettings$lambda3(String str, final LoginButton loginButton) {
        Intrinsics.checkNotNullParameter(str, "$appId");
        Intrinsics.checkNotNullParameter(loginButton, "this$0");
        FetchedAppSettingsManager fetchedAppSettingsManager = FetchedAppSettingsManager.INSTANCE;
        final FetchedAppSettings fetchedAppSettingsQueryAppSettings = FetchedAppSettingsManager.queryAppSettings(str, false);
        loginButton.getActivity().runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                LoginButton.m2567checkToolTipSettings$lambda3$lambda2(this.f$0, fetchedAppSettingsQueryAppSettings);
            }
        });
    }

    public static final void m2567checkToolTipSettings$lambda3$lambda2(LoginButton loginButton, FetchedAppSettings fetchedAppSettings) {
        Intrinsics.checkNotNullParameter(loginButton, "this$0");
        loginButton.showToolTipPerSettings(fetchedAppSettings);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            super.onLayout(changed, left, top, right, bottom);
            setButtonText();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            super.onDetachedFromWindow();
            ActivityResultLauncher<Collection<String>> activityResultLauncher = this.androidXLoginCaller;
            if (activityResultLauncher != null) {
                activityResultLauncher.unregister();
            }
            AccessTokenTracker accessTokenTracker = this.accessTokenTracker;
            if (accessTokenTracker != null) {
                accessTokenTracker.stopTracking();
            }
            dismissToolTip();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    @Override
    protected void onVisibilityChanged(View changedView, int visibility) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(changedView, "changedView");
            super.onVisibilityChanged(changedView, visibility);
            if (visibility != 0) {
                dismissToolTip();
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    public final List<String> getPermissions() {
        return this.properties.getPermissions();
    }

    public final void setPermissions(List<String> list) {
        Intrinsics.checkNotNullParameter(list, SDKConstants.PARAM_VALUE);
        this.properties.setPermissions(list);
    }

    @Override
    protected void configureButton(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(context, "context");
            super.configureButton(context, attrs, defStyleAttr, defStyleRes);
            setInternalOnClickListener(getNewLoginClickListener());
            parseLoginButtonAttributes(context, attrs, defStyleAttr, defStyleRes);
            if (isInEditMode()) {
                setBackgroundColor(getResources().getColor(C0913R.color.com_facebook_blue));
                setLoginText("Continue with Facebook");
            } else {
                this.accessTokenTracker = new AccessTokenTracker() {
                    @Override
                    protected void onCurrentAccessTokenChanged(AccessToken oldAccessToken, AccessToken currentAccessToken) {
                        LoginButton.this.setButtonText();
                        LoginButton.this.setButtonIcon();
                    }
                };
            }
            setButtonText();
            setButtonRadius();
            setButtonTransparency();
            setButtonIcon();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    protected LoginClickListener getNewLoginClickListener() {
        return new LoginClickListener(this);
    }

    @Override
    protected int getDefaultStyleResource() {
        return C0949R.style.com_facebook_loginview_default_style;
    }

    protected final void parseLoginButtonAttributes(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(context, "context");
            this.toolTipMode = ToolTipMode.INSTANCE.getDEFAULT();
            TypedArray typedArrayObtainStyledAttributes = context.getTheme().obtainStyledAttributes(attrs, C0949R.styleable.com_facebook_login_view, defStyleAttr, defStyleRes);
            Intrinsics.checkNotNullExpressionValue(typedArrayObtainStyledAttributes, "context\n            .theme\n            .obtainStyledAttributes(\n                attrs, R.styleable.com_facebook_login_view, defStyleAttr, defStyleRes)");
            try {
                this.confirmLogout = typedArrayObtainStyledAttributes.getBoolean(C0949R.styleable.com_facebook_login_view_com_facebook_confirm_logout, true);
                setLoginText(typedArrayObtainStyledAttributes.getString(C0949R.styleable.com_facebook_login_view_com_facebook_login_text));
                setLogoutText(typedArrayObtainStyledAttributes.getString(C0949R.styleable.com_facebook_login_view_com_facebook_logout_text));
                ToolTipMode toolTipModeFromInt = ToolTipMode.INSTANCE.fromInt(typedArrayObtainStyledAttributes.getInt(C0949R.styleable.com_facebook_login_view_com_facebook_tooltip_mode, ToolTipMode.INSTANCE.getDEFAULT().getIntValue()));
                if (toolTipModeFromInt == null) {
                    toolTipModeFromInt = ToolTipMode.INSTANCE.getDEFAULT();
                }
                this.toolTipMode = toolTipModeFromInt;
                if (typedArrayObtainStyledAttributes.hasValue(C0949R.styleable.com_facebook_login_view_com_facebook_login_button_radius)) {
                    this.customButtonRadius = Float.valueOf(typedArrayObtainStyledAttributes.getDimension(C0949R.styleable.com_facebook_login_view_com_facebook_login_button_radius, 0.0f));
                }
                int integer = typedArrayObtainStyledAttributes.getInteger(C0949R.styleable.com_facebook_login_view_com_facebook_login_button_transparency, 255);
                this.customButtonTransparency = integer;
                int iMax = Math.max(0, integer);
                this.customButtonTransparency = iMax;
                this.customButtonTransparency = Math.min(255, iMax);
            } finally {
                typedArrayObtainStyledAttributes.recycle();
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Paint.FontMetrics fontMetrics = getPaint().getFontMetrics();
            int compoundPaddingTop = getCompoundPaddingTop() + ((int) Math.ceil(Math.abs(fontMetrics.top) + Math.abs(fontMetrics.bottom))) + getCompoundPaddingBottom();
            Resources resources = getResources();
            int loginButtonWidth = getLoginButtonWidth(widthMeasureSpec);
            String string = this.logoutText;
            if (string == null) {
                string = resources.getString(C0949R.string.com_facebook_loginview_log_out_button);
                Intrinsics.checkNotNullExpressionValue(string, "resources.getString(R.string.com_facebook_loginview_log_out_button)");
            }
            setMeasuredDimension(Button.resolveSize(Math.max(loginButtonWidth, measureButtonWidth(string)), widthMeasureSpec), compoundPaddingTop);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    protected final int getLoginButtonWidth(int widthMeasureSpec) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return 0;
        }
        try {
            Resources resources = getResources();
            String string = this.loginText;
            if (string == null) {
                string = resources.getString(C0949R.string.com_facebook_loginview_log_in_button_continue);
                int iMeasureButtonWidth = measureButtonWidth(string);
                if (Button.resolveSize(iMeasureButtonWidth, widthMeasureSpec) < iMeasureButtonWidth) {
                    string = resources.getString(C0949R.string.com_facebook_loginview_log_in_button);
                }
            }
            return measureButtonWidth(string);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return 0;
        }
    }

    private final int measureButtonWidth(String text) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return 0;
        }
        try {
            return getCompoundPaddingLeft() + getCompoundDrawablePadding() + measureTextWidth(text) + getCompoundPaddingRight();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return 0;
        }
    }

    protected final void setButtonText() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Resources resources = getResources();
            if (!isInEditMode() && AccessToken.INSTANCE.isCurrentAccessTokenActive()) {
                String str = this.logoutText;
                setText(str == null ? resources.getString(C0949R.string.com_facebook_loginview_log_out_button) : str);
                return;
            }
            String str2 = this.loginText;
            if (str2 != null) {
                setText(str2);
                return;
            }
            String string = resources.getString(getLoginButtonContinueLabel());
            Intrinsics.checkNotNullExpressionValue(string, "resources.getString(loginButtonContinueLabel)");
            int width = getWidth();
            if (width != 0 && measureButtonWidth(string) > width) {
                string = resources.getString(C0949R.string.com_facebook_loginview_log_in_button);
                Intrinsics.checkNotNullExpressionValue(string, "resources.getString(R.string.com_facebook_loginview_log_in_button)");
            }
            setText(string);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    protected final void setButtonIcon() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            setCompoundDrawablesWithIntrinsicBounds(AppCompatResources.getDrawable(getContext(), C0913R.drawable.com_facebook_button_icon), (Drawable) null, (Drawable) null, (Drawable) null);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    protected final void setButtonRadius() {
        int stateCount;
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Float f = this.customButtonRadius;
            if (f == null) {
                return;
            }
            float fFloatValue = f.floatValue();
            Drawable background = getBackground();
            if (Build.VERSION.SDK_INT >= 29 && (background instanceof StateListDrawable) && (stateCount = ((StateListDrawable) background).getStateCount()) > 0) {
                int i = 0;
                while (true) {
                    int i2 = i + 1;
                    Drawable stateDrawable = ((StateListDrawable) background).getStateDrawable(i);
                    GradientDrawable gradientDrawable = stateDrawable instanceof GradientDrawable ? (GradientDrawable) stateDrawable : null;
                    if (gradientDrawable != null) {
                        gradientDrawable.setCornerRadius(fFloatValue);
                    }
                    if (i2 >= stateCount) {
                        break;
                    } else {
                        i = i2;
                    }
                }
            }
            if (background instanceof GradientDrawable) {
                ((GradientDrawable) background).setCornerRadius(fFloatValue);
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    protected final void setButtonTransparency() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            getBackground().setAlpha(this.customButtonTransparency);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    @Override
    protected int getDefaultRequestCode() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return 0;
        }
        try {
            return CallbackManagerImpl.RequestCodeOffset.Login.toRequestCode();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
            return 0;
        }
    }

    @Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0095\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\b\u0010\n\u001a\u00020\u000bH\u0014J\u0010\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0016J\b\u0010\u0010\u001a\u00020\rH\u0004J\u0010\u0010\u0011\u001a\u00020\r2\u0006\u0010\u0012\u001a\u00020\u0013H\u0004R\u0014\u0010\u0003\u001a\u00020\u00048DX\u0084\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0005R\u0014\u0010\u0006\u001a\u00020\u00078DX\u0084\u0004¢\u0006\u0006\u001a\u0004\b\b\u0010\t¨\u0006\u0014"}, d2 = {"Lcom/facebook/login/widget/LoginButton$LoginClickListener;", "Landroid/view/View$OnClickListener;", "(Lcom/facebook/login/widget/LoginButton;)V", "isFamilyLogin", "", "()Z", "loginTargetApp", "Lcom/facebook/login/LoginTargetApp;", "getLoginTargetApp", "()Lcom/facebook/login/LoginTargetApp;", "getLoginManager", "Lcom/facebook/login/LoginManager;", "onClick", "", "v", "Landroid/view/View;", "performLogin", "performLogout", "context", "Landroid/content/Context;", "facebook-login_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    protected class LoginClickListener implements View.OnClickListener {
        final LoginButton this$0;

        protected final boolean isFamilyLogin() {
            CrashShieldHandler.isObjectCrashing(this);
            return false;
        }

        public LoginClickListener(LoginButton loginButton) {
            Intrinsics.checkNotNullParameter(loginButton, "this$0");
            this.this$0 = loginButton;
        }

        @Override
        public void onClick(View v) {
            if (CrashShieldHandler.isObjectCrashing(this)) {
                return;
            }
            try {
                Intrinsics.checkNotNullParameter(v, "v");
                this.this$0.callExternalOnClickListener(v);
                AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
                boolean zIsCurrentAccessTokenActive = AccessToken.INSTANCE.isCurrentAccessTokenActive();
                if (zIsCurrentAccessTokenActive) {
                    Context context = this.this$0.getContext();
                    Intrinsics.checkNotNullExpressionValue(context, "context");
                    performLogout(context);
                } else {
                    performLogin();
                }
                InternalAppEventsLogger internalAppEventsLogger = new InternalAppEventsLogger(this.this$0.getContext());
                Bundle bundle = new Bundle();
                int i = 0;
                if (currentAccessToken == null) {
                    i = 1;
                }
                bundle.putInt("logging_in", i);
                bundle.putInt("access_token_expired", zIsCurrentAccessTokenActive ? 1 : 0);
                internalAppEventsLogger.logEventImplicitly(AnalyticsEvents.EVENT_LOGIN_VIEW_USAGE, bundle);
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
            }
        }

        protected final void performLogin() {
            if (CrashShieldHandler.isObjectCrashing(this)) {
                return;
            }
            try {
                LoginManager loginManager = getLoginManager();
                ActivityResultLauncher activityResultLauncher = this.this$0.androidXLoginCaller;
                if (activityResultLauncher != null) {
                    LoginManager.FacebookLoginActivityResultContract facebookLoginActivityResultContract = (LoginManager.FacebookLoginActivityResultContract) activityResultLauncher.getContract();
                    CallbackManagerImpl callbackManager = this.this$0.getCallbackManager();
                    if (callbackManager == null) {
                        callbackManager = new CallbackManagerImpl();
                    }
                    facebookLoginActivityResultContract.setCallbackManager(callbackManager);
                    activityResultLauncher.launch(this.this$0.getProperties().getPermissions());
                    return;
                }
                if (this.this$0.getFragment() != null) {
                    Fragment fragment = this.this$0.getFragment();
                    if (fragment == null) {
                        return;
                    }
                    LoginButton loginButton = this.this$0;
                    loginManager.logIn(fragment, loginButton.getProperties().getPermissions(), loginButton.getLoggerID());
                    return;
                }
                if (this.this$0.getNativeFragment() == null) {
                    loginManager.logIn(this.this$0.getActivity(), this.this$0.getProperties().getPermissions(), this.this$0.getLoggerID());
                    return;
                }
                android.app.Fragment nativeFragment = this.this$0.getNativeFragment();
                if (nativeFragment == null) {
                    return;
                }
                LoginButton loginButton2 = this.this$0;
                loginManager.logIn(nativeFragment, loginButton2.getProperties().getPermissions(), loginButton2.getLoggerID());
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
            }
        }

        protected final void performLogout(Context context) {
            String string;
            if (CrashShieldHandler.isObjectCrashing(this)) {
                return;
            }
            try {
                Intrinsics.checkNotNullParameter(context, "context");
                final LoginManager loginManager = getLoginManager();
                if (this.this$0.confirmLogout) {
                    String string2 = this.this$0.getResources().getString(C0949R.string.com_facebook_loginview_log_out_action);
                    Intrinsics.checkNotNullExpressionValue(string2, "resources.getString(R.string.com_facebook_loginview_log_out_action)");
                    String string3 = this.this$0.getResources().getString(C0949R.string.com_facebook_loginview_cancel_action);
                    Intrinsics.checkNotNullExpressionValue(string3, "resources.getString(R.string.com_facebook_loginview_cancel_action)");
                    Profile currentProfile = Profile.INSTANCE.getCurrentProfile();
                    if ((currentProfile == null ? null : currentProfile.getName()) != null) {
                        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                        String string4 = this.this$0.getResources().getString(C0949R.string.com_facebook_loginview_logged_in_as);
                        Intrinsics.checkNotNullExpressionValue(string4, "resources.getString(R.string.com_facebook_loginview_logged_in_as)");
                        string = String.format(string4, Arrays.copyOf(new Object[]{currentProfile.getName()}, 1));
                        Intrinsics.checkNotNullExpressionValue(string, "java.lang.String.format(format, *args)");
                    } else {
                        string = this.this$0.getResources().getString(C0949R.string.com_facebook_loginview_logged_in_using_facebook);
                        Intrinsics.checkNotNullExpressionValue(string, "{\n          resources.getString(R.string.com_facebook_loginview_logged_in_using_facebook)\n        }");
                    }
                    AlertDialog.Builder builder = new AlertDialog.Builder(context);
                    builder.setMessage(string).setCancelable(true).setPositiveButton(string2, new DialogInterface.OnClickListener() {
                        @Override
                        public final void onClick(DialogInterface dialogInterface, int i) {
                            LoginButton.LoginClickListener.m2569performLogout$lambda2(loginManager, dialogInterface, i);
                        }
                    }).setNegativeButton(string3, (DialogInterface.OnClickListener) null);
                    builder.create().show();
                    return;
                }
                loginManager.logOut();
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
            }
        }

        public static final void m2569performLogout$lambda2(LoginManager loginManager, DialogInterface dialogInterface, int i) {
            if (CrashShieldHandler.isObjectCrashing(LoginClickListener.class)) {
                return;
            }
            try {
                Intrinsics.checkNotNullParameter(loginManager, "$loginManager");
                loginManager.logOut();
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, LoginClickListener.class);
            }
        }

        protected LoginManager getLoginManager() {
            if (CrashShieldHandler.isObjectCrashing(this)) {
                return null;
            }
            try {
                LoginManager companion = LoginManager.INSTANCE.getInstance();
                companion.setDefaultAudience(this.this$0.getDefaultAudience());
                companion.setLoginBehavior(this.this$0.getLoginBehavior());
                companion.setLoginTargetApp(getLoginTargetApp());
                companion.setAuthType(this.this$0.getAuthType());
                companion.setFamilyLogin(isFamilyLogin());
                companion.setShouldSkipAccountDeduplication(this.this$0.getShouldSkipAccountDeduplication());
                companion.setMessengerPageId(this.this$0.getMessengerPageId());
                companion.setResetMessengerState(this.this$0.getResetMessengerState());
                return companion;
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
                return null;
            }
        }

        protected final LoginTargetApp getLoginTargetApp() {
            if (CrashShieldHandler.isObjectCrashing(this)) {
                return null;
            }
            try {
                return LoginTargetApp.FACEBOOK;
            } catch (Throwable th) {
                CrashShieldHandler.handleThrowable(th, this);
                return null;
            }
        }
    }
}
