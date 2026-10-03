package zendesk.android.internal;

import android.content.Context;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import net.aihelp.core.p004ui.loading.indicator.LoadingIndicatorView;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.p013di.ZendeskComponent;
import zendesk.android.internal.p013di.ZendeskInitializedModule;
import zendesk.android.internal.usercolors.UserColorsPersistenceKt;
import zendesk.android.internal.usercolors.UserColorsRepository;
import zendesk.android.internal.usercolors.UserColorsSchemePersistence;
import zendesk.android.internal.usercolors.UserColorsStorage;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.MessagingFactory;
import zendesk.android.messaging.internal.NotEnabledMessaging;
import zendesk.android.messaging.model.ColorThemeKt;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.MessagingSettingsKt;
import zendesk.android.messaging.model.UserColors;
import zendesk.android.settings.internal.SettingsRepository;
import zendesk.android.settings.internal.model.SettingsDto;
import zendesk.android.settings.internal.model.SettingsDtoKt;
import zendesk.android.settings.internal.model.SunCoConfigDto;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.model.Config;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000x\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J6\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u00042\u0006\u0010\u0007\u001a\u00020\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\u0006\u0010\u000b\u001a\u00020\fH\u0086@¢\u0006\u0002\u0010\rJ.\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0014\u001a\u00020\u0015H\u0082@¢\u0006\u0002\u0010\u0016JP\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001a2\b\u0010\t\u001a\u0004\u0018\u00010\n2\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u001b\u001a\u00020\u000f2\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010\u000b\u001a\u00020\fH\u0082@¢\u0006\u0002\u0010 J>\u0010!\u001a\u0004\u0018\u00010\"2\u0006\u0010#\u001a\u00020$2\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\u0010%\u001a\u0004\u0018\u00010&2\b\u0010'\u001a\u0004\u0018\u00010&2\u0006\u0010\u000b\u001a\u00020\fH\u0082@¢\u0006\u0002\u0010(¨\u0006)"}, m18d2 = {"Lzendesk/android/internal/ZendeskFactory;", "", "()V", "create", "Lzendesk/android/ZendeskResult;", "Lzendesk/android/Zendesk;", "", "zendeskComponent", "Lzendesk/android/internal/di/ZendeskComponent;", "messagingFactory", "Lzendesk/android/messaging/MessagingFactory;", "restoreSession", "", "(Lzendesk/android/internal/di/ZendeskComponent;Lzendesk/android/messaging/MessagingFactory;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "initialiseConversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "sunCoConfigDto", "Lzendesk/android/settings/internal/model/SunCoConfigDto;", "integrationId", "", "scope", "Lkotlinx/coroutines/CoroutineScope;", "(Lzendesk/android/settings/internal/model/SunCoConfigDto;Ljava/lang/String;Lzendesk/android/internal/di/ZendeskComponent;Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "initialiseNativeMessaging", "Lzendesk/android/messaging/Messaging;", "settings", "Lzendesk/android/settings/internal/model/SettingsDto;", "conversationKit", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "(Lzendesk/android/settings/internal/model/SettingsDto;Lzendesk/android/messaging/MessagingFactory;Lzendesk/android/internal/di/ZendeskComponent;Lzendesk/conversationkit/android/ConversationKit;Lkotlinx/coroutines/CoroutineScope;Lzendesk/core/android/internal/app/FeatureFlagManager;Lzendesk/android/messaging/model/MessagingSettings;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resolveUserColors", "Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "context", "Landroid/content/Context;", MessagingComponentKt.USER_LIGHT_COLORS, "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_DARK_COLORS, "(Landroid/content/Context;Ljava/lang/String;Lzendesk/android/messaging/model/UserColors;Lzendesk/android/messaging/model/UserColors;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskFactory {
    public static final ZendeskFactory INSTANCE = new ZendeskFactory();

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory", m37f = "ZendeskFactory.kt", m38i = {0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2}, m39l = {LoadingIndicatorView.DEFAULT_SIZE, 55, 72}, m40m = "create", m41n = {"this", "zendeskComponent", "messagingFactory", "scope", "restoreSession", "this", "zendeskComponent", "messagingFactory", "scope", "settings", "featureFlagManager", "restoreSession", "zendeskComponent", "featureFlagManager", "conversationKit", "messagingSettings"}, m42s = {"L$0", "L$1", "L$2", "L$3", "Z$0", "L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "Z$0", "L$0", "L$1", "L$2", "L$3"})
    static final class C09451 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        boolean Z$0;
        int label;
        Object result;

        C09451(Continuation<? super C09451> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ZendeskFactory.this.create(null, null, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory", m37f = "ZendeskFactory.kt", m38i = {0, 0}, m39l = {150}, m40m = "initialiseConversationKit", m41n = {"zendeskComponent", "scope"}, m42s = {"L$0", "L$1"})
    static final class C09461 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09461(Continuation<? super C09461> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ZendeskFactory.this.initialiseConversationKit(null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory", m37f = "ZendeskFactory.kt", m38i = {0, 0, 0, 0, 0, 0}, m39l = {114}, m40m = "initialiseNativeMessaging", m41n = {"messagingFactory", "zendeskComponent", "conversationKit", "scope", "featureFlagManager", "messagingSettings"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5"})
    static final class C09471 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;

        C09471(Continuation<? super C09471> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ZendeskFactory.this.initialiseNativeMessaging(null, null, null, null, null, null, null, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory", m37f = "ZendeskFactory.kt", m38i = {1}, m39l = {193, 195, 199}, m40m = "resolveUserColors", m41n = {"userColorsRepository"}, m42s = {"L$0"})
    static final class C09481 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09481(Continuation<? super C09481> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ZendeskFactory.this.resolveUserColors(null, null, null, null, false, this);
        }
    }

    private ZendeskFactory() {
    }

    public static Object create$default(ZendeskFactory zendeskFactory, ZendeskComponent zendeskComponent, MessagingFactory messagingFactory, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 2) != 0) {
            messagingFactory = null;
        }
        return zendeskFactory.create(zendeskComponent, messagingFactory, z, continuation);
    }

    public final Object create(ZendeskComponent zendeskComponent, MessagingFactory messagingFactory, boolean z, Continuation<? super ZendeskResult<Zendesk, ? extends Throwable>> continuation) throws Throwable {
        C09451 c09451;
        Object objFetchSettings$zendesk_zendesk_android;
        CoroutineScope coroutineScope;
        ZendeskFactory zendeskFactory;
        ZendeskComponent zendeskComponent2;
        MessagingFactory messagingFactory2;
        boolean z2;
        MessagingFactory messagingFactory3;
        CoroutineScope coroutineScope2;
        SettingsDto settingsDto;
        FeatureFlagManager featureFlagManager;
        ZendeskComponent zendeskComponent3;
        ZendeskFactory zendeskFactory2;
        ConversationKit conversationKit;
        MessagingSettings messagingSettings;
        Object objInitialiseNativeMessaging;
        FeatureFlagManager featureFlagManager2;
        ZendeskComponent zendeskComponent4;
        MessagingSettings messagingSettings2;
        ConversationKit conversationKit2;
        if (continuation instanceof C09451) {
            c09451 = (C09451) continuation;
            if ((c09451.label & Integer.MIN_VALUE) != 0) {
                c09451.label -= Integer.MIN_VALUE;
            } else {
                c09451 = new C09451(continuation);
            }
        } else {
            c09451 = new C09451(continuation);
        }
        C09451 c09452 = c09451;
        Object obj = c09452.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09452.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    boolean z3 = c09452.Z$0;
                    CoroutineScope coroutineScope3 = (CoroutineScope) c09452.L$3;
                    MessagingFactory messagingFactory4 = (MessagingFactory) c09452.L$2;
                    ZendeskComponent zendeskComponent5 = (ZendeskComponent) c09452.L$1;
                    ZendeskFactory zendeskFactory3 = (ZendeskFactory) c09452.L$0;
                    ResultKt.throwOnFailure(obj);
                    z2 = z3;
                    coroutineScope = coroutineScope3;
                    messagingFactory2 = messagingFactory4;
                    zendeskFactory = zendeskFactory3;
                    objFetchSettings$zendesk_zendesk_android = obj;
                    zendeskComponent2 = zendeskComponent5;
                } else if (i == 2) {
                    boolean z4 = c09452.Z$0;
                    FeatureFlagManager featureFlagManager3 = (FeatureFlagManager) c09452.L$5;
                    SettingsDto settingsDto2 = (SettingsDto) c09452.L$4;
                    CoroutineScope coroutineScope4 = (CoroutineScope) c09452.L$3;
                    MessagingFactory messagingFactory5 = (MessagingFactory) c09452.L$2;
                    ZendeskComponent zendeskComponent6 = (ZendeskComponent) c09452.L$1;
                    ZendeskFactory zendeskFactory4 = (ZendeskFactory) c09452.L$0;
                    ResultKt.throwOnFailure(obj);
                    z2 = z4;
                    featureFlagManager = featureFlagManager3;
                    settingsDto = settingsDto2;
                    messagingFactory3 = messagingFactory5;
                    zendeskComponent3 = zendeskComponent6;
                    zendeskFactory2 = zendeskFactory4;
                    coroutineScope2 = coroutineScope4;
                    conversationKit = (ConversationKit) obj;
                    messagingSettings = MessagingSettingsKt.toMessagingSettings(settingsDto.getNativeMessaging(), ColorThemeKt.toColorTheme(settingsDto.getLightTheme()), ColorThemeKt.toColorTheme(settingsDto.getDarkTheme()), SettingsDtoKt.canUserCreateMoreConversations(settingsDto), SettingsDtoKt.isMultiConversationsEnabled(settingsDto), settingsDto.isAttachmentsEnabled(), settingsDto.getIdentifier(), SettingsDtoKt.canUserSeeConversationList(settingsDto));
                    c09452.L$0 = zendeskComponent3;
                    c09452.L$1 = featureFlagManager;
                    c09452.L$2 = conversationKit;
                    c09452.L$3 = messagingSettings;
                    c09452.L$4 = null;
                    c09452.L$5 = null;
                    c09452.label = 3;
                    objInitialiseNativeMessaging = zendeskFactory2.initialiseNativeMessaging(settingsDto, messagingFactory3, zendeskComponent3, conversationKit, coroutineScope2, featureFlagManager, messagingSettings, z2, c09452);
                    if (objInitialiseNativeMessaging == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    featureFlagManager2 = featureFlagManager;
                    zendeskComponent4 = zendeskComponent3;
                    messagingSettings2 = messagingSettings;
                    conversationKit2 = conversationKit;
                    obj = objInitialiseNativeMessaging;
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    messagingSettings2 = (MessagingSettings) c09452.L$3;
                    conversationKit2 = (ConversationKit) c09452.L$2;
                    featureFlagManager2 = (FeatureFlagManager) c09452.L$1;
                    zendeskComponent4 = (ZendeskComponent) c09452.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                return new ZendeskResult.Success(zendeskComponent4.getZendeskInitializedComponent().zendeskInitializedModule(new ZendeskInitializedModule(conversationKit2, (Messaging) obj, featureFlagManager2, messagingSettings2)).build().zendesk());
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScopeMainScope = zendeskComponent.mainScope();
            SettingsRepository settingsRepository = zendeskComponent.settingsRepository();
            c09452.L$0 = this;
            c09452.L$1 = zendeskComponent;
            c09452.L$2 = messagingFactory;
            c09452.L$3 = coroutineScopeMainScope;
            c09452.Z$0 = z;
            c09452.label = 1;
            objFetchSettings$zendesk_zendesk_android = settingsRepository.fetchSettings$zendesk_zendesk_android(c09452);
            if (objFetchSettings$zendesk_zendesk_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            coroutineScope = coroutineScopeMainScope;
            zendeskFactory = this;
            zendeskComponent2 = zendeskComponent;
            messagingFactory2 = messagingFactory;
            z2 = z;
            ZendeskResult zendeskResult = (ZendeskResult) objFetchSettings$zendesk_zendesk_android;
            if (zendeskResult instanceof ZendeskResult.Failure) {
                return new ZendeskResult.Failure(((ZendeskResult.Failure) zendeskResult).getError());
            }
            if (!(zendeskResult instanceof ZendeskResult.Success)) {
                throw new NoWhenBranchMatchedException();
            }
            SettingsDto settingsDto3 = (SettingsDto) ((ZendeskResult.Success) zendeskResult).getValue();
            FeatureFlagManager featureFlagManager4 = new FeatureFlagManager(false, false, false, 7, null);
            if (settingsDto3.getSunCoConfigDto() == null || settingsDto3.getNativeMessaging().getIntegrationId() == null) {
                return new ZendeskResult.Failure(ZendeskError.MissingConfiguration.INSTANCE);
            }
            SunCoConfigDto sunCoConfigDto = settingsDto3.getSunCoConfigDto();
            String integrationId = settingsDto3.getNativeMessaging().getIntegrationId();
            c09452.L$0 = zendeskFactory;
            c09452.L$1 = zendeskComponent2;
            c09452.L$2 = messagingFactory2;
            c09452.L$3 = coroutineScope;
            c09452.L$4 = settingsDto3;
            c09452.L$5 = featureFlagManager4;
            c09452.Z$0 = z2;
            c09452.label = 2;
            Object objInitialiseConversationKit = zendeskFactory.initialiseConversationKit(sunCoConfigDto, integrationId, zendeskComponent2, coroutineScope, c09452);
            if (objInitialiseConversationKit == coroutine_suspended) {
                return coroutine_suspended;
            }
            messagingFactory3 = messagingFactory2;
            coroutineScope2 = coroutineScope;
            settingsDto = settingsDto3;
            featureFlagManager = featureFlagManager4;
            ZendeskFactory zendeskFactory5 = zendeskFactory;
            zendeskComponent3 = zendeskComponent2;
            obj = objInitialiseConversationKit;
            zendeskFactory2 = zendeskFactory5;
            conversationKit = (ConversationKit) obj;
            messagingSettings = MessagingSettingsKt.toMessagingSettings(settingsDto.getNativeMessaging(), ColorThemeKt.toColorTheme(settingsDto.getLightTheme()), ColorThemeKt.toColorTheme(settingsDto.getDarkTheme()), SettingsDtoKt.canUserCreateMoreConversations(settingsDto), SettingsDtoKt.isMultiConversationsEnabled(settingsDto), settingsDto.isAttachmentsEnabled(), settingsDto.getIdentifier(), SettingsDtoKt.canUserSeeConversationList(settingsDto));
            c09452.L$0 = zendeskComponent3;
            c09452.L$1 = featureFlagManager;
            c09452.L$2 = conversationKit;
            c09452.L$3 = messagingSettings;
            c09452.L$4 = null;
            c09452.L$5 = null;
            c09452.label = 3;
            objInitialiseNativeMessaging = zendeskFactory2.initialiseNativeMessaging(settingsDto, messagingFactory3, zendeskComponent3, conversationKit, coroutineScope2, featureFlagManager, messagingSettings, z2, c09452);
            if (objInitialiseNativeMessaging == coroutine_suspended) {
                return coroutine_suspended;
            }
            featureFlagManager2 = featureFlagManager;
            zendeskComponent4 = zendeskComponent3;
            messagingSettings2 = messagingSettings;
            conversationKit2 = conversationKit;
            obj = objInitialiseNativeMessaging;
            return new ZendeskResult.Success(zendeskComponent4.getZendeskInitializedComponent().zendeskInitializedModule(new ZendeskInitializedModule(conversationKit2, (Messaging) obj, featureFlagManager2, messagingSettings2)).build().zendesk());
        } catch (Exception e) {
            return new ZendeskResult.Failure(e);
        }
    }

    public final Object initialiseNativeMessaging(SettingsDto settingsDto, MessagingFactory messagingFactory, ZendeskComponent zendeskComponent, ConversationKit conversationKit, CoroutineScope coroutineScope, FeatureFlagManager featureFlagManager, MessagingSettings messagingSettings, boolean z, Continuation<? super Messaging> continuation) throws Throwable {
        C09471 c09471;
        ZendeskComponent zendeskComponent2;
        MessagingFactory messagingFactory2;
        ConversationKit conversationKit2;
        CoroutineScope coroutineScope2;
        FeatureFlagManager featureFlagManager2;
        MessagingSettings messagingSettings2;
        if (continuation instanceof C09471) {
            c09471 = (C09471) continuation;
            if ((c09471.label & Integer.MIN_VALUE) != 0) {
                c09471.label -= Integer.MIN_VALUE;
            } else {
                c09471 = new C09471(continuation);
            }
        } else {
            c09471 = new C09471(continuation);
        }
        C09471 c09472 = c09471;
        Object objResolveUserColors = c09472.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09472.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objResolveUserColors);
            if (settingsDto.getNativeMessaging().getEnabled() && messagingFactory != null) {
                Context context = zendeskComponent.context();
                String integrationId = messagingSettings.getIntegrationId();
                UserColors userLightColors = messagingFactory.getUserLightColors();
                UserColors userDarkColors = messagingFactory.getUserDarkColors();
                c09472.L$0 = messagingFactory;
                zendeskComponent2 = zendeskComponent;
                c09472.L$1 = zendeskComponent2;
                c09472.L$2 = conversationKit;
                c09472.L$3 = coroutineScope;
                c09472.L$4 = featureFlagManager;
                c09472.L$5 = messagingSettings;
                c09472.label = 1;
                objResolveUserColors = resolveUserColors(context, integrationId, userLightColors, userDarkColors, z, c09472);
                if (objResolveUserColors == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messagingFactory2 = messagingFactory;
                conversationKit2 = conversationKit;
                coroutineScope2 = coroutineScope;
                featureFlagManager2 = featureFlagManager;
                messagingSettings2 = messagingSettings;
            } else {
                return NotEnabledMessaging.INSTANCE;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            MessagingSettings messagingSettings3 = (MessagingSettings) c09472.L$5;
            FeatureFlagManager featureFlagManager3 = (FeatureFlagManager) c09472.L$4;
            CoroutineScope coroutineScope3 = (CoroutineScope) c09472.L$3;
            ConversationKit conversationKit3 = (ConversationKit) c09472.L$2;
            ZendeskComponent zendeskComponent3 = (ZendeskComponent) c09472.L$1;
            messagingFactory2 = (MessagingFactory) c09472.L$0;
            ResultKt.throwOnFailure(objResolveUserColors);
            messagingSettings2 = messagingSettings3;
            featureFlagManager2 = featureFlagManager3;
            coroutineScope2 = coroutineScope3;
            conversationKit2 = conversationKit3;
            zendeskComponent2 = zendeskComponent3;
        }
        UserColorsSchemePersistence userColorsSchemePersistence = (UserColorsSchemePersistence) objResolveUserColors;
        return messagingFactory2.create(new MessagingFactory.CreateParams(zendeskComponent2.context(), zendeskComponent2.componentData().getChannelKey(), zendeskComponent2.componentData().getBaseUrl(), conversationKit2, messagingSettings2, coroutineScope2, new ZendeskFactory$initialiseNativeMessaging$messaging$1(zendeskComponent2, null), featureFlagManager2, UserColorsPersistenceKt.toUserColors(userColorsSchemePersistence != null ? userColorsSchemePersistence.getLight() : null), UserColorsPersistenceKt.toUserColors(userColorsSchemePersistence != null ? userColorsSchemePersistence.getDark() : null)));
    }

    public final Object initialiseConversationKit(SunCoConfigDto sunCoConfigDto, String str, final ZendeskComponent zendeskComponent, final CoroutineScope coroutineScope, Continuation<? super ConversationKit> continuation) throws Throwable {
        C09461 c09461;
        if (continuation instanceof C09461) {
            c09461 = (C09461) continuation;
            if ((c09461.label & Integer.MIN_VALUE) != 0) {
                c09461.label -= Integer.MIN_VALUE;
            } else {
                c09461 = new C09461(continuation);
            }
        } else {
            c09461 = new C09461(continuation);
        }
        Object objCreateConversationKit$zendesk_zendesk_android = c09461.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09461.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objCreateConversationKit$zendesk_zendesk_android);
            ConversationKitProvider conversationKitProvider = ConversationKitProvider.INSTANCE;
            Config conversationKitConfig$zendesk_zendesk_android = ConversationKitProvider.INSTANCE.toConversationKitConfig$zendesk_zendesk_android(sunCoConfigDto, zendeskComponent.componentData().getBaseUrl());
            Context context = zendeskComponent.context();
            c09461.L$0 = zendeskComponent;
            c09461.L$1 = coroutineScope;
            c09461.label = 1;
            objCreateConversationKit$zendesk_zendesk_android = conversationKitProvider.createConversationKit$zendesk_zendesk_android(conversationKitConfig$zendesk_zendesk_android, str, context, c09461);
            if (objCreateConversationKit$zendesk_zendesk_android == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            coroutineScope = (CoroutineScope) c09461.L$1;
            zendeskComponent = (ZendeskComponent) c09461.L$0;
            ResultKt.throwOnFailure(objCreateConversationKit$zendesk_zendesk_android);
        }
        ConversationKit conversationKit = (ConversationKit) objCreateConversationKit$zendesk_zendesk_android;
        conversationKit.addEventListener(new ConversationKitEventListener() {
            @Override
            public final void onEvent(ConversationKitEvent conversationKitEvent) {
                ZendeskFactory.initialiseConversationKit$lambda$0(coroutineScope, zendeskComponent, conversationKitEvent);
            }
        });
        return conversationKit;
    }

    public static final void initialiseConversationKit$lambda$0(CoroutineScope scope, ZendeskComponent zendeskComponent, ConversationKitEvent conversationKitEvent) {
        Intrinsics.checkNotNullParameter(scope, "$scope");
        Intrinsics.checkNotNullParameter(zendeskComponent, "$zendeskComponent");
        Intrinsics.checkNotNullParameter(conversationKitEvent, "conversationKitEvent");
        if (conversationKitEvent instanceof ConversationKitEvent.UserAccessRevoked) {
            BuildersKt__Builders_commonKt.launch$default(scope, null, null, new ZendeskFactory$initialiseConversationKit$2$1(conversationKitEvent, zendeskComponent, null), 3, null);
        }
    }

    public final Object resolveUserColors(Context context, String str, UserColors userColors, UserColors userColors2, boolean z, Continuation<? super UserColorsSchemePersistence> continuation) throws Throwable {
        C09481 c09481;
        UserColorsRepository userColorsRepository;
        if (continuation instanceof C09481) {
            c09481 = (C09481) continuation;
            if ((c09481.label & Integer.MIN_VALUE) != 0) {
                c09481.label -= Integer.MIN_VALUE;
            } else {
                c09481 = new C09481(continuation);
            }
        } else {
            c09481 = new C09481(continuation);
        }
        Object userColors3 = c09481.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09481.label;
        if (i == 0) {
            ResultKt.throwOnFailure(userColors3);
            userColorsRepository = new UserColorsRepository(new UserColorsStorage(UserColorsStorage.StorageProvider.INSTANCE.createStorage(context, str)));
            if (z) {
                c09481.label = 1;
                userColors3 = userColorsRepository.getUserColors(c09481);
                return userColors3 == coroutine_suspended ? coroutine_suspended : userColors3;
            }
            c09481.L$0 = userColorsRepository;
            c09481.label = 2;
            if (userColorsRepository.updateUserColors(userColors, userColors2, c09481) == coroutine_suspended) {
                return coroutine_suspended;
            }
            c09481.L$0 = null;
            c09481.label = 3;
            userColors3 = userColorsRepository.getUserColors(c09481);
            if (userColors3 == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i == 1) {
                ResultKt.throwOnFailure(userColors3);
            }
            if (i == 2) {
                userColorsRepository = (UserColorsRepository) c09481.L$0;
                ResultKt.throwOnFailure(userColors3);
                c09481.L$0 = null;
                c09481.label = 3;
                userColors3 = userColorsRepository.getUserColors(c09481);
                if (userColors3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(userColors3);
            }
        }
        return userColors3;
    }
}
