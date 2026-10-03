package zendesk.messaging.android.internal.p023di;

import android.content.Context;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.internal.DoubleCheck;
import dagger.internal.InstanceFactory;
import dagger.internal.Preconditions;
import dagger.internal.Provider;
import j$.time.LocalDateTime;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;
import zendesk.android.ZendeskCredentials;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_DefaultDispatcherFactory;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_MainDispatcherFactory;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule_PersistenceDispatcherFactory;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule_ProvideJsonFactory;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider_Factory;
import zendesk.guidekit.android.GuideKit;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.ConversationTitleProvider_Factory;
import zendesk.messaging.android.internal.MessagingEntryPointHandler;
import zendesk.messaging.android.internal.NewMessagesDividerHandler;
import zendesk.messaging.android.internal.UploadFileResourceProvider;
import zendesk.messaging.android.internal.conversationscreen.ConversationFragment;
import zendesk.messaging.android.internal.conversationscreen.ConversationFragment_MembersInjector;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity;
import zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity_MembersInjector;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;
import zendesk.messaging.android.internal.conversationscreen.MessageLogEntryMapper;
import zendesk.messaging.android.internal.conversationscreen.MessageLogLabelProvider;
import zendesk.messaging.android.internal.conversationscreen.MessageLogTimestampFormatter;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorageSerializer;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorageSerializer_Factory;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment_MembersInjector;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionViewModelFactory;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di.C1387x7b31e151;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di.ConversationExtensionFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di.ConversationExtensionModule;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment_MembersInjector;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModelFactory;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.C1434x2c061edf;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideArticleFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideArticleViewerModule;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideKitModule;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideKitModule_ProvidesGuideKitFactory;
import zendesk.messaging.android.internal.conversationscreen.p020di.C1419xb55511cb;
import zendesk.messaging.android.internal.conversationscreen.p020di.ConversationFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.p020di.ConversationScreenModule;
import zendesk.messaging.android.internal.conversationscreen.p020di.ConversationScreenModule_ProvidesResourceProviderFactory;
import zendesk.messaging.android.internal.conversationscreen.p020di.ImageViewerComponent;
import zendesk.messaging.android.internal.conversationscreen.p020di.MessageLogModule;
import zendesk.messaging.android.internal.conversationscreen.p020di.MessageLogModule_ProvidesMessageContainerFactoryFactory;
import zendesk.messaging.android.internal.conversationscreen.p020di.MessageLogModule_ProvidesMessageLogLabelProviderFactory;
import zendesk.messaging.android.internal.conversationscreen.p020di.MessageLogModule_ProvidesMessageLogTimestampFormatterFactory;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment_MembersInjector;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogEntryMapper;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogEntryMapper_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogTimestampFormatter;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogTimestampFormatter_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListInMemoryCache_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIO;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOImpl;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOImpl_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageSerializer;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageSerializer_Factory;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.C1498x46816fb6;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.C1499x2a018d1c;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.C1500xe64db575;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.ConversationListFragmentComponent;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.ConversationsListLocalStorageModule;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.ConversationsListScreenModule;
import zendesk.messaging.android.internal.messagingscreen.BackNavigationResolver;
import zendesk.messaging.android.internal.messagingscreen.MessagingActivity;
import zendesk.messaging.android.internal.messagingscreen.MessagingActivity_MembersInjector;
import zendesk.messaging.android.internal.messagingscreen.MessagingNavigator;
import zendesk.messaging.android.internal.messagingscreen.MessagingScreenViewModelFactory;
import zendesk.messaging.android.internal.messagingscreen.p024di.MessagingNavigatorModule;
import zendesk.messaging.android.internal.messagingscreen.p024di.MessagingNavigatorModule_ProvideFragmentManagerFactory;
import zendesk.messaging.android.internal.rest.HeaderFactory;
import zendesk.messaging.android.internal.rest.HeaderFactory_Factory;
import zendesk.messaging.android.internal.rest.NetworkModule;
import zendesk.messaging.android.internal.rest.NetworkModule_OkHttpClientFactory;
import zendesk.messaging.android.internal.rest.NetworkModule_ProvideKotlinSerializationFactory;
import zendesk.messaging.android.internal.rest.NetworkModule_RetrofitFactory;
import zendesk.messaging.android.internal.validation.ConversationFieldManager;
import zendesk.messaging.android.internal.validation.ConversationFieldRepository;
import zendesk.messaging.android.internal.validation.ConversationFieldService;
import zendesk.messaging.android.internal.validation.ConversationFieldValidator;
import zendesk.messaging.android.internal.validation.ValidationRules;
import zendesk.messaging.android.internal.validation.p025di.ConversationFieldModule;
import zendesk.messaging.android.internal.validation.p025di.ConversationFieldModule_ProvideConversationFieldServiceFactory;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageType;

public final class DaggerMessagingComponent {
    private DaggerMessagingComponent() {
    }

    public static MessagingComponent.Factory factory() {
        return new Factory();
    }

    private static final class Factory implements MessagingComponent.Factory {
        private Factory() {
        }

        @Override
        public MessagingComponent create(Context context, ZendeskCredentials zendeskCredentials, String str, MessagingSettings messagingSettings, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?> function2, CoroutineScope coroutineScope, UserColors userColors, UserColors userColors2, FeatureFlagManager featureFlagManager, Function0<LocalDateTime> function0, Function0<String> function1) {
            Preconditions.checkNotNull(context);
            Preconditions.checkNotNull(zendeskCredentials);
            Preconditions.checkNotNull(str);
            Preconditions.checkNotNull(messagingSettings);
            Preconditions.checkNotNull(conversationKit);
            Preconditions.checkNotNull(function2);
            Preconditions.checkNotNull(coroutineScope);
            Preconditions.checkNotNull(userColors);
            Preconditions.checkNotNull(userColors2);
            Preconditions.checkNotNull(featureFlagManager);
            Preconditions.checkNotNull(function0);
            Preconditions.checkNotNull(function1);
            return new MessagingComponentImpl(new StorageModule(), new NetworkModule(), new ConversationFieldModule(), new CoroutineDispatchersModule(), new GuideKitModule(), new GuideArticleViewerModule(), new MessagingDateFormatModule(), context, zendeskCredentials, str, messagingSettings, conversationKit, function2, coroutineScope, userColors, userColors2, featureFlagManager, function0, function1);
        }
    }

    private static final class MessagingActivityComponentFactory implements MessagingActivityComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private MessagingActivityComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public MessagingActivityComponent create(AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            Preconditions.checkNotNull(appCompatActivity);
            Preconditions.checkNotNull(savedStateRegistryOwner);
            return new MessagingActivityComponentImpl(this.messagingComponentImpl, new MessagingScreenModule(), new MessagingNavigatorModule(), appCompatActivity, savedStateRegistryOwner, bundle);
        }
    }

    private static final class ImageViewerComponentFactory implements ImageViewerComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private ImageViewerComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public ImageViewerComponent create(AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            Preconditions.checkNotNull(appCompatActivity);
            Preconditions.checkNotNull(savedStateRegistryOwner);
            return new ImageViewerComponentImpl(this.messagingComponentImpl, new ConversationScreenModule(), new MessageLogModule(), appCompatActivity, savedStateRegistryOwner, bundle);
        }
    }

    private static final class ConversationFragmentComponentFactory implements ConversationFragmentComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private ConversationFragmentComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public ConversationFragmentComponent create(AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            Preconditions.checkNotNull(appCompatActivity);
            Preconditions.checkNotNull(savedStateRegistryOwner);
            return new ConversationFragmentComponentImpl(this.messagingComponentImpl, new ConversationScreenModule(), new MessageLogModule(), new MessagingNavigatorModule(), appCompatActivity, savedStateRegistryOwner, bundle);
        }
    }

    private static final class ConversationListFragmentComponentFactory implements ConversationListFragmentComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private ConversationListFragmentComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public ConversationListFragmentComponent create(AppCompatActivity appCompatActivity) {
            Preconditions.checkNotNull(appCompatActivity);
            return new ConversationListFragmentComponentImpl(this.messagingComponentImpl, new ConversationsListScreenModule(), new ConversationsListLocalStorageModule(), new MessagingNavigatorModule(), appCompatActivity);
        }
    }

    private static final class GuideArticleFragmentComponentFactory implements GuideArticleFragmentComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private GuideArticleFragmentComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public GuideArticleFragmentComponent create(SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            Preconditions.checkNotNull(savedStateRegistryOwner);
            return new GuideArticleFragmentComponentImpl(this.messagingComponentImpl, savedStateRegistryOwner, bundle);
        }
    }

    private static final class ConversationExtensionFragmentComponentFactory implements ConversationExtensionFragmentComponent.Factory {
        private final MessagingComponentImpl messagingComponentImpl;

        private ConversationExtensionFragmentComponentFactory(MessagingComponentImpl messagingComponentImpl) {
            this.messagingComponentImpl = messagingComponentImpl;
        }

        @Override
        public ConversationExtensionFragmentComponent create(SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            Preconditions.checkNotNull(savedStateRegistryOwner);
            return new ConversationExtensionFragmentComponentImpl(this.messagingComponentImpl, new ConversationExtensionModule(), savedStateRegistryOwner, bundle);
        }
    }

    private static final class MessagingActivityComponentImpl implements MessagingActivityComponent {
        private final AppCompatActivity activity;
        private final Bundle defaultArgs;
        private final MessagingActivityComponentImpl messagingActivityComponentImpl;
        private final MessagingComponentImpl messagingComponentImpl;
        private final MessagingNavigatorModule messagingNavigatorModule;
        private final MessagingScreenModule messagingScreenModule;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        private MessagingActivityComponentImpl(MessagingComponentImpl messagingComponentImpl, MessagingScreenModule messagingScreenModule, MessagingNavigatorModule messagingNavigatorModule, AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            this.messagingActivityComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.messagingScreenModule = messagingScreenModule;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
            this.defaultArgs = bundle;
            this.messagingNavigatorModule = messagingNavigatorModule;
            this.activity = appCompatActivity;
        }

        private MessagingEntryPointHandler messagingEntryPointHandler() {
            return new MessagingEntryPointHandler(this.messagingComponentImpl.conversationKit, this.messagingComponentImpl.messagingSettings);
        }

        private MessagingScreenViewModelFactory messagingScreenViewModelFactory() {
            return C1508xd9909ee9.providesMessagingScreenViewModelFactory(this.messagingScreenModule, messagingEntryPointHandler(), this.savedStateRegistryOwner, this.defaultArgs);
        }

        private FragmentManager fragmentManager() {
            return MessagingNavigatorModule_ProvideFragmentManagerFactory.provideFragmentManager(this.messagingNavigatorModule, this.activity);
        }

        private MessagingNavigator messagingNavigator() {
            return new MessagingNavigator(fragmentManager(), this.messagingNavigatorModule.provideFragmentContainerId());
        }

        @Override
        public void inject(MessagingActivity messagingActivity) {
            injectMessagingActivity(messagingActivity);
        }

        private MessagingActivity injectMessagingActivity(MessagingActivity messagingActivity) {
            MessagingActivity_MembersInjector.injectMessagingSettings(messagingActivity, this.messagingComponentImpl.messagingSettings);
            MessagingActivity_MembersInjector.injectUserDarkColors(messagingActivity, this.messagingComponentImpl.userDarkColors);
            MessagingActivity_MembersInjector.injectUserLightColors(messagingActivity, this.messagingComponentImpl.userLightColors);
            MessagingActivity_MembersInjector.injectMessagingScreenViewModelFactory(messagingActivity, messagingScreenViewModelFactory());
            MessagingActivity_MembersInjector.injectMessagingNavigator(messagingActivity, messagingNavigator());
            return messagingActivity;
        }
    }

    private static final class ImageViewerComponentImpl implements ImageViewerComponent {
        private final AppCompatActivity activity;
        private final ConversationScreenModule conversationScreenModule;
        private final Bundle defaultArgs;
        private final ImageViewerComponentImpl imageViewerComponentImpl;
        private final MessageLogModule messageLogModule;
        private final MessagingComponentImpl messagingComponentImpl;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        private ImageViewerComponentImpl(MessagingComponentImpl messagingComponentImpl, ConversationScreenModule conversationScreenModule, MessageLogModule messageLogModule, AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            this.imageViewerComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.conversationScreenModule = conversationScreenModule;
            this.messageLogModule = messageLogModule;
            this.activity = appCompatActivity;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
            this.defaultArgs = bundle;
        }

        private MessageLogLabelProvider messageLogLabelProvider() {
            return MessageLogModule_ProvidesMessageLogLabelProviderFactory.providesMessageLogLabelProvider(this.messageLogModule, this.activity);
        }

        private MessageLogTimestampFormatter messageLogTimestampFormatter() {
            return MessageLogModule_ProvidesMessageLogTimestampFormatterFactory.providesMessageLogTimestampFormatter(this.messageLogModule, this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider());
        }

        private MessageContainerFactory messageContainerFactory() {
            return MessageLogModule_ProvidesMessageContainerFactoryFactory.providesMessageContainerFactory(this.messageLogModule, messageLogLabelProvider(), messageLogTimestampFormatter());
        }

        private MessageLogEntryMapper messageLogEntryMapper() {
            return new MessageLogEntryMapper(messageContainerFactory(), messageLogLabelProvider(), messageLogTimestampFormatter(), this.messagingComponentImpl.currentTimeProvider, this.messagingComponentImpl.idProvider, CoroutineDispatchersModule_DefaultDispatcherFactory.defaultDispatcher(this.messagingComponentImpl.coroutineDispatchersModule));
        }

        private UploadFileResourceProvider uploadFileResourceProvider() {
            return ConversationScreenModule_ProvidesResourceProviderFactory.providesResourceProvider(this.conversationScreenModule, this.messagingComponentImpl.context);
        }

        private MessagingStorage messagingStorage() {
            return new MessagingStorage(CoroutineDispatchersModule_PersistenceDispatcherFactory.persistenceDispatcher(this.messagingComponentImpl.coroutineDispatchersModule), (Storage) this.messagingComponentImpl.providesStorageProvider.get());
        }

        private ConversationScreenRepository conversationScreenRepository() {
            return new ConversationScreenRepository(this.messagingComponentImpl.conversationKit, messagingStorage(), CoroutineDispatchersModule_DefaultDispatcherFactory.defaultDispatcher(this.messagingComponentImpl.coroutineDispatchersModule));
        }

        private ConversationLogTimestampFormatter conversationLogTimestampFormatter() {
            return new ConversationLogTimestampFormatter(this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider(), this.messagingComponentImpl.namedBoolean());
        }

        private ConversationTitleProvider conversationTitleProvider() {
            return new ConversationTitleProvider(this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider(), conversationLogTimestampFormatter(), this.messagingComponentImpl.namedBoolean());
        }

        private ConversationScreenViewModelFactory conversationScreenViewModelFactory() {
            return C1419xb55511cb.providesConversationViewModelFactory(this.conversationScreenModule, this.messagingComponentImpl.messagingSettings, messageLogEntryMapper(), new NewMessagesDividerHandler(), this.activity, this.savedStateRegistryOwner, this.defaultArgs, this.messagingComponentImpl.coroutineScope, uploadFileResourceProvider(), conversationScreenRepository(), conversationTitleProvider(), this.messagingComponentImpl.featureFlagManager, this.messagingComponentImpl.conversationKit);
        }

        @Override
        public void inject(ImageViewerActivity imageViewerActivity) {
            injectImageViewerActivity(imageViewerActivity);
        }

        private ImageViewerActivity injectImageViewerActivity(ImageViewerActivity imageViewerActivity) {
            ImageViewerActivity_MembersInjector.injectConversationScreenViewModelFactory(imageViewerActivity, conversationScreenViewModelFactory());
            ImageViewerActivity_MembersInjector.injectMessagingSettings(imageViewerActivity, this.messagingComponentImpl.messagingSettings);
            ImageViewerActivity_MembersInjector.injectUserDarkColors(imageViewerActivity, this.messagingComponentImpl.userDarkColors);
            ImageViewerActivity_MembersInjector.injectUserLightColors(imageViewerActivity, this.messagingComponentImpl.userLightColors);
            ImageViewerActivity_MembersInjector.injectFeatureFlagManager(imageViewerActivity, this.messagingComponentImpl.featureFlagManager);
            return imageViewerActivity;
        }
    }

    private static final class ConversationFragmentComponentImpl implements ConversationFragmentComponent {
        private final AppCompatActivity activity;
        private final ConversationFragmentComponentImpl conversationFragmentComponentImpl;
        private final ConversationScreenModule conversationScreenModule;
        private final Bundle defaultArgs;
        private final MessageLogModule messageLogModule;
        private final MessagingComponentImpl messagingComponentImpl;
        private final MessagingNavigatorModule messagingNavigatorModule;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        private ConversationFragmentComponentImpl(MessagingComponentImpl messagingComponentImpl, ConversationScreenModule conversationScreenModule, MessageLogModule messageLogModule, MessagingNavigatorModule messagingNavigatorModule, AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            this.conversationFragmentComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.conversationScreenModule = conversationScreenModule;
            this.messageLogModule = messageLogModule;
            this.activity = appCompatActivity;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
            this.defaultArgs = bundle;
            this.messagingNavigatorModule = messagingNavigatorModule;
        }

        private MessageLogLabelProvider messageLogLabelProvider() {
            return MessageLogModule_ProvidesMessageLogLabelProviderFactory.providesMessageLogLabelProvider(this.messageLogModule, this.activity);
        }

        private MessageLogTimestampFormatter messageLogTimestampFormatter() {
            return MessageLogModule_ProvidesMessageLogTimestampFormatterFactory.providesMessageLogTimestampFormatter(this.messageLogModule, this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider());
        }

        private MessageContainerFactory messageContainerFactory() {
            return MessageLogModule_ProvidesMessageContainerFactoryFactory.providesMessageContainerFactory(this.messageLogModule, messageLogLabelProvider(), messageLogTimestampFormatter());
        }

        private MessageLogEntryMapper messageLogEntryMapper() {
            return new MessageLogEntryMapper(messageContainerFactory(), messageLogLabelProvider(), messageLogTimestampFormatter(), this.messagingComponentImpl.currentTimeProvider, this.messagingComponentImpl.idProvider, CoroutineDispatchersModule_DefaultDispatcherFactory.defaultDispatcher(this.messagingComponentImpl.coroutineDispatchersModule));
        }

        private UploadFileResourceProvider uploadFileResourceProvider() {
            return ConversationScreenModule_ProvidesResourceProviderFactory.providesResourceProvider(this.conversationScreenModule, this.messagingComponentImpl.context);
        }

        private MessagingStorage messagingStorage() {
            return new MessagingStorage(CoroutineDispatchersModule_PersistenceDispatcherFactory.persistenceDispatcher(this.messagingComponentImpl.coroutineDispatchersModule), (Storage) this.messagingComponentImpl.providesStorageProvider.get());
        }

        private ConversationScreenRepository conversationScreenRepository() {
            return new ConversationScreenRepository(this.messagingComponentImpl.conversationKit, messagingStorage(), CoroutineDispatchersModule_DefaultDispatcherFactory.defaultDispatcher(this.messagingComponentImpl.coroutineDispatchersModule));
        }

        private ConversationLogTimestampFormatter conversationLogTimestampFormatter() {
            return new ConversationLogTimestampFormatter(this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider(), this.messagingComponentImpl.namedBoolean());
        }

        private ConversationTitleProvider conversationTitleProvider() {
            return new ConversationTitleProvider(this.messagingComponentImpl.context, this.messagingComponentImpl.localeProvider(), conversationLogTimestampFormatter(), this.messagingComponentImpl.namedBoolean());
        }

        private ConversationScreenViewModelFactory conversationScreenViewModelFactory() {
            return C1419xb55511cb.providesConversationViewModelFactory(this.conversationScreenModule, this.messagingComponentImpl.messagingSettings, messageLogEntryMapper(), new NewMessagesDividerHandler(), this.activity, this.savedStateRegistryOwner, this.defaultArgs, this.messagingComponentImpl.coroutineScope, uploadFileResourceProvider(), conversationScreenRepository(), conversationTitleProvider(), this.messagingComponentImpl.featureFlagManager, this.messagingComponentImpl.conversationKit);
        }

        private FragmentManager fragmentManager() {
            return MessagingNavigatorModule_ProvideFragmentManagerFactory.provideFragmentManager(this.messagingNavigatorModule, this.activity);
        }

        private MessagingNavigator messagingNavigator() {
            return new MessagingNavigator(fragmentManager(), this.messagingNavigatorModule.provideFragmentContainerId());
        }

        private BackNavigationResolver backNavigationResolver() {
            return new BackNavigationResolver(this.messagingComponentImpl.conversationKit, this.messagingComponentImpl.messagingSettings);
        }

        @Override
        public void inject(ConversationFragment conversationFragment) {
            injectConversationFragment(conversationFragment);
        }

        private ConversationFragment injectConversationFragment(ConversationFragment conversationFragment) {
            ConversationFragment_MembersInjector.injectConversationScreenViewModelFactory(conversationFragment, conversationScreenViewModelFactory());
            ConversationFragment_MembersInjector.injectMessagingSettings(conversationFragment, this.messagingComponentImpl.messagingSettings);
            ConversationFragment_MembersInjector.injectUserDarkColors(conversationFragment, this.messagingComponentImpl.userDarkColors);
            ConversationFragment_MembersInjector.injectUserLightColors(conversationFragment, this.messagingComponentImpl.userLightColors);
            ConversationFragment_MembersInjector.injectGuideKit(conversationFragment, (GuideKit) this.messagingComponentImpl.providesGuideKitProvider.get());
            ConversationFragment_MembersInjector.injectMessagingNavigator(conversationFragment, messagingNavigator());
            ConversationFragment_MembersInjector.injectBackNavigationResolver(conversationFragment, backNavigationResolver());
            ConversationFragment_MembersInjector.injectFeatureFlagManager(conversationFragment, this.messagingComponentImpl.featureFlagManager);
            return conversationFragment;
        }
    }

    private static final class ConversationListFragmentComponentImpl implements ConversationListFragmentComponent {
        private final AppCompatActivity activity;
        private Provider<AppCompatActivity> activityProvider;
        private final ConversationListFragmentComponentImpl conversationListFragmentComponentImpl;
        private Provider<ConversationLogEntryMapper> conversationLogEntryMapperProvider;
        private Provider<ConversationLogTimestampFormatter> conversationLogTimestampFormatterProvider;
        private Provider<ConversationTitleProvider> conversationTitleProvider;
        private Provider<ConversationsListLocalStorageIOImpl> conversationsListLocalStorageIOImplProvider;
        private Provider<ConversationsListLocalStorageSerializer> conversationsListLocalStorageSerializerProvider;
        private Provider<ConversationsListRepository> conversationsListRepositoryProvider;
        private final MessagingComponentImpl messagingComponentImpl;
        private final MessagingNavigatorModule messagingNavigatorModule;
        private Provider<ConversationsListLocalStorageIO> providesConversationsListLocalStorageProvider;
        private Provider<ConversationsListScreenViewModelFactory> providesConversationsListScreenViewModelProvider;
        private Provider<Storage> providesConversationsListStorageProvider;
        private Provider<StorageType> providesConversationsListStorageTypeProvider;

        private ConversationListFragmentComponentImpl(MessagingComponentImpl messagingComponentImpl, ConversationsListScreenModule conversationsListScreenModule, ConversationsListLocalStorageModule conversationsListLocalStorageModule, MessagingNavigatorModule messagingNavigatorModule, AppCompatActivity appCompatActivity) {
            this.conversationListFragmentComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.messagingNavigatorModule = messagingNavigatorModule;
            this.activity = appCompatActivity;
            initialize(conversationsListScreenModule, conversationsListLocalStorageModule, messagingNavigatorModule, appCompatActivity);
        }

        private FragmentManager fragmentManager() {
            return MessagingNavigatorModule_ProvideFragmentManagerFactory.provideFragmentManager(this.messagingNavigatorModule, this.activity);
        }

        private MessagingNavigator messagingNavigator() {
            return new MessagingNavigator(fragmentManager(), this.messagingNavigatorModule.provideFragmentContainerId());
        }

        private void initialize(ConversationsListScreenModule conversationsListScreenModule, ConversationsListLocalStorageModule conversationsListLocalStorageModule, MessagingNavigatorModule messagingNavigatorModule, AppCompatActivity appCompatActivity) {
            this.activityProvider = InstanceFactory.create(appCompatActivity);
            this.conversationLogTimestampFormatterProvider = ConversationLogTimestampFormatter_Factory.create(this.messagingComponentImpl.contextProvider, this.messagingComponentImpl.localeProvider, this.messagingComponentImpl.providesIs24HoursProvider);
            ConversationsListLocalStorageSerializer_Factory conversationsListLocalStorageSerializer_FactoryCreate = ConversationsListLocalStorageSerializer_Factory.create(KotlinxSerializationModule_ProvideJsonFactory.create());
            this.conversationsListLocalStorageSerializerProvider = conversationsListLocalStorageSerializer_FactoryCreate;
            this.providesConversationsListStorageTypeProvider = DoubleCheck.provider(C1499x2a018d1c.create(conversationsListLocalStorageModule, conversationsListLocalStorageSerializer_FactoryCreate));
            this.providesConversationsListStorageProvider = DoubleCheck.provider(C1498x46816fb6.create(conversationsListLocalStorageModule, this.messagingComponentImpl.contextProvider, this.providesConversationsListStorageTypeProvider, this.messagingComponentImpl.messagingSettingsProvider));
            ConversationsListLocalStorageIOImpl_Factory conversationsListLocalStorageIOImpl_FactoryCreate = ConversationsListLocalStorageIOImpl_Factory.create(this.messagingComponentImpl.persistenceDispatcherProvider, this.providesConversationsListStorageProvider);
            this.conversationsListLocalStorageIOImplProvider = conversationsListLocalStorageIOImpl_FactoryCreate;
            this.providesConversationsListLocalStorageProvider = DoubleCheck.provider(conversationsListLocalStorageIOImpl_FactoryCreate);
            this.conversationTitleProvider = ConversationTitleProvider_Factory.create(this.messagingComponentImpl.contextProvider, this.messagingComponentImpl.localeProvider, this.conversationLogTimestampFormatterProvider, this.messagingComponentImpl.providesIs24HoursProvider);
            this.conversationLogEntryMapperProvider = ConversationLogEntryMapper_Factory.create(this.messagingComponentImpl.contextProvider, this.conversationLogTimestampFormatterProvider, this.messagingComponentImpl.messagingSettingsProvider, this.providesConversationsListLocalStorageProvider, this.conversationTitleProvider);
            this.conversationsListRepositoryProvider = ConversationsListRepository_Factory.create(this.messagingComponentImpl.conversationKitProvider, this.messagingComponentImpl.defaultDispatcherProvider, this.conversationLogEntryMapperProvider, ConversationsListInMemoryCache_Factory.create());
            this.providesConversationsListScreenViewModelProvider = DoubleCheck.provider(C1500xe64db575.create(conversationsListScreenModule, this.messagingComponentImpl.messagingSettingsProvider, this.messagingComponentImpl.conversationKitProvider, this.activityProvider, this.conversationsListRepositoryProvider));
        }

        @Override
        public void inject(ConversationListFragment conversationListFragment) {
            injectConversationListFragment(conversationListFragment);
        }

        private ConversationListFragment injectConversationListFragment(ConversationListFragment conversationListFragment) {
            ConversationListFragment_MembersInjector.injectConversationsListScreenViewModelFactory(conversationListFragment, this.providesConversationsListScreenViewModelProvider.get());
            ConversationListFragment_MembersInjector.injectMessagingSettings(conversationListFragment, this.messagingComponentImpl.messagingSettings);
            ConversationListFragment_MembersInjector.injectUserDarkColors(conversationListFragment, this.messagingComponentImpl.userDarkColors);
            ConversationListFragment_MembersInjector.injectUserLightColors(conversationListFragment, this.messagingComponentImpl.userLightColors);
            ConversationListFragment_MembersInjector.injectFeatureFlagManager(conversationListFragment, this.messagingComponentImpl.featureFlagManager);
            ConversationListFragment_MembersInjector.injectMessagingNavigator(conversationListFragment, messagingNavigator());
            return conversationListFragment;
        }
    }

    private static final class GuideArticleFragmentComponentImpl implements GuideArticleFragmentComponent {
        private final Bundle defaultArgs;
        private final GuideArticleFragmentComponentImpl guideArticleFragmentComponentImpl;
        private final MessagingComponentImpl messagingComponentImpl;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        private GuideArticleFragmentComponentImpl(MessagingComponentImpl messagingComponentImpl, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            this.guideArticleFragmentComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
            this.defaultArgs = bundle;
        }

        private GuideArticleViewerViewModelFactory guideArticleViewerViewModelFactory() {
            return C1434x2c061edf.providesGuideArticleViewerViewModelFactory(this.messagingComponentImpl.guideArticleViewerModule, (GuideKit) this.messagingComponentImpl.providesGuideKitProvider.get(), this.savedStateRegistryOwner, this.defaultArgs);
        }

        @Override
        public void inject(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment) {
            injectGuideArticleViewerBottomSheetFragment(guideArticleViewerBottomSheetFragment);
        }

        private GuideArticleViewerBottomSheetFragment injectGuideArticleViewerBottomSheetFragment(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment) {
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectGuideKit(guideArticleViewerBottomSheetFragment, (GuideKit) this.messagingComponentImpl.providesGuideKitProvider.get());
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectGuideArticleViewerViewModelFactory(guideArticleViewerBottomSheetFragment, guideArticleViewerViewModelFactory());
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectUserDarkColors(guideArticleViewerBottomSheetFragment, this.messagingComponentImpl.userDarkColors);
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectUserLightColors(guideArticleViewerBottomSheetFragment, this.messagingComponentImpl.userLightColors);
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectBaseUrl(guideArticleViewerBottomSheetFragment, this.messagingComponentImpl.baseUrl);
            GuideArticleViewerBottomSheetFragment_MembersInjector.injectMessagingSettings(guideArticleViewerBottomSheetFragment, this.messagingComponentImpl.messagingSettings);
            return guideArticleViewerBottomSheetFragment;
        }
    }

    private static final class ConversationExtensionFragmentComponentImpl implements ConversationExtensionFragmentComponent {
        private final ConversationExtensionFragmentComponentImpl conversationExtensionFragmentComponentImpl;
        private final ConversationExtensionModule conversationExtensionModule;
        private final Bundle defaultArgs;
        private final MessagingComponentImpl messagingComponentImpl;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        private ConversationExtensionFragmentComponentImpl(MessagingComponentImpl messagingComponentImpl, ConversationExtensionModule conversationExtensionModule, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
            this.conversationExtensionFragmentComponentImpl = this;
            this.messagingComponentImpl = messagingComponentImpl;
            this.conversationExtensionModule = conversationExtensionModule;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
            this.defaultArgs = bundle;
        }

        private ConversationExtensionViewModelFactory conversationExtensionViewModelFactory() {
            return C1387x7b31e151.providesConversationExtensionViewModelFactory(this.conversationExtensionModule, this.savedStateRegistryOwner, this.defaultArgs);
        }

        @Override
        public void inject(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment) {
            injectConversationExtensionBottomSheetFragment(conversationExtensionBottomSheetFragment);
        }

        private ConversationExtensionBottomSheetFragment injectConversationExtensionBottomSheetFragment(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment) {
            ConversationExtensionBottomSheetFragment_MembersInjector.injectConversationExtensionViewModelFactory(conversationExtensionBottomSheetFragment, conversationExtensionViewModelFactory());
            ConversationExtensionBottomSheetFragment_MembersInjector.injectUserDarkColors(conversationExtensionBottomSheetFragment, this.messagingComponentImpl.userDarkColors);
            ConversationExtensionBottomSheetFragment_MembersInjector.injectUserLightColors(conversationExtensionBottomSheetFragment, this.messagingComponentImpl.userLightColors);
            ConversationExtensionBottomSheetFragment_MembersInjector.injectMessagingSettings(conversationExtensionBottomSheetFragment, this.messagingComponentImpl.messagingSettings);
            ConversationExtensionBottomSheetFragment_MembersInjector.injectFeatureFlagManager(conversationExtensionBottomSheetFragment, this.messagingComponentImpl.featureFlagManager);
            return conversationExtensionBottomSheetFragment;
        }
    }

    private static final class MessagingComponentImpl implements MessagingComponent {
        private final String baseUrl;
        private Provider<String> baseUrlProvider;
        private final Context context;
        private Provider<Context> contextProvider;
        private final ConversationFieldModule conversationFieldModule;
        private final ConversationKit conversationKit;
        private Provider<ConversationKit> conversationKitProvider;
        private final CoroutineDispatchersModule coroutineDispatchersModule;
        private final CoroutineScope coroutineScope;
        private Provider<CoroutineScope> coroutineScopeProvider;
        private final Function0<LocalDateTime> currentTimeProvider;
        private Provider<CoroutineDispatcher> defaultDispatcherProvider;
        private final Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?> dispatchEvent;
        private final FeatureFlagManager featureFlagManager;
        private final GuideArticleViewerModule guideArticleViewerModule;
        private Provider<HeaderFactory> headerFactoryProvider;
        private final Function0<String> idProvider;
        private Provider<LocaleProvider> localeProvider;
        private final MessagingComponentImpl messagingComponentImpl;
        private final MessagingDateFormatModule messagingDateFormatModule;
        private final MessagingSettings messagingSettings;
        private Provider<MessagingSettings> messagingSettingsProvider;
        private Provider<MessagingStorageSerializer> messagingStorageSerializerProvider;
        private Provider<OkHttpClient> okHttpClientProvider;
        private Provider<CoroutineDispatcher> persistenceDispatcherProvider;
        private Provider<Converter.Factory> provideKotlinSerializationProvider;
        private Provider<GuideKit> providesGuideKitProvider;
        private Provider<String> providesIdentifierProvider;
        private Provider<Boolean> providesIs24HoursProvider;
        private Provider<Storage> providesStorageProvider;
        private Provider<StorageType> providesStorageTypeProvider;
        private Provider<Retrofit> retrofitProvider;
        private final UserColors userDarkColors;
        private final UserColors userLightColors;

        private MessagingComponentImpl(StorageModule storageModule, NetworkModule networkModule, ConversationFieldModule conversationFieldModule, CoroutineDispatchersModule coroutineDispatchersModule, GuideKitModule guideKitModule, GuideArticleViewerModule guideArticleViewerModule, MessagingDateFormatModule messagingDateFormatModule, Context context, ZendeskCredentials zendeskCredentials, String str, MessagingSettings messagingSettings, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?> function2, CoroutineScope coroutineScope, UserColors userColors, UserColors userColors2, FeatureFlagManager featureFlagManager, Function0<LocalDateTime> function0, Function0<String> function1) {
            this.messagingComponentImpl = this;
            this.conversationFieldModule = conversationFieldModule;
            this.conversationKit = conversationKit;
            this.dispatchEvent = function2;
            this.featureFlagManager = featureFlagManager;
            this.coroutineDispatchersModule = coroutineDispatchersModule;
            this.messagingSettings = messagingSettings;
            this.userDarkColors = userColors2;
            this.userLightColors = userColors;
            this.context = context;
            this.currentTimeProvider = function0;
            this.idProvider = function1;
            this.coroutineScope = coroutineScope;
            this.messagingDateFormatModule = messagingDateFormatModule;
            this.guideArticleViewerModule = guideArticleViewerModule;
            this.baseUrl = str;
            initialize(storageModule, networkModule, conversationFieldModule, coroutineDispatchersModule, guideKitModule, guideArticleViewerModule, messagingDateFormatModule, context, zendeskCredentials, str, messagingSettings, conversationKit, function2, coroutineScope, userColors, userColors2, featureFlagManager, function0, function1);
        }

        private ConversationFieldService conversationFieldService() {
            return ConversationFieldModule_ProvideConversationFieldServiceFactory.provideConversationFieldService(this.conversationFieldModule, this.retrofitProvider.get());
        }

        private ConversationFieldRepository conversationFieldRepository() {
            return new ConversationFieldRepository(conversationFieldService());
        }

        private ConversationFieldValidator conversationFieldValidator() {
            return new ConversationFieldValidator(new ValidationRules(), conversationFieldRepository());
        }

        public LocaleProvider localeProvider() {
            return new LocaleProvider(this.context);
        }

        public boolean namedBoolean() {
            return this.messagingDateFormatModule.providesIs24Hours(this.context);
        }

        private void initialize(StorageModule storageModule, NetworkModule networkModule, ConversationFieldModule conversationFieldModule, CoroutineDispatchersModule coroutineDispatchersModule, GuideKitModule guideKitModule, GuideArticleViewerModule guideArticleViewerModule, MessagingDateFormatModule messagingDateFormatModule, Context context, ZendeskCredentials zendeskCredentials, String str, MessagingSettings messagingSettings, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?> function2, CoroutineScope coroutineScope, UserColors userColors, UserColors userColors2, FeatureFlagManager featureFlagManager, Function0<LocalDateTime> function0, Function0<String> function1) {
            this.baseUrlProvider = InstanceFactory.create(str);
            dagger.internal.Factory factoryCreate = InstanceFactory.create(context);
            this.contextProvider = factoryCreate;
            LocaleProvider_Factory localeProvider_FactoryCreate = LocaleProvider_Factory.create(factoryCreate);
            this.localeProvider = localeProvider_FactoryCreate;
            HeaderFactory_Factory headerFactory_FactoryCreate = HeaderFactory_Factory.create(localeProvider_FactoryCreate);
            this.headerFactoryProvider = headerFactory_FactoryCreate;
            this.okHttpClientProvider = DoubleCheck.provider(NetworkModule_OkHttpClientFactory.create(networkModule, headerFactory_FactoryCreate));
            Provider<Converter.Factory> provider = DoubleCheck.provider(NetworkModule_ProvideKotlinSerializationFactory.create(networkModule, KotlinxSerializationModule_ProvideJsonFactory.create()));
            this.provideKotlinSerializationProvider = provider;
            this.retrofitProvider = DoubleCheck.provider(NetworkModule_RetrofitFactory.create(networkModule, this.baseUrlProvider, this.okHttpClientProvider, provider));
            MessagingStorageSerializer_Factory messagingStorageSerializer_FactoryCreate = MessagingStorageSerializer_Factory.create(KotlinxSerializationModule_ProvideJsonFactory.create());
            this.messagingStorageSerializerProvider = messagingStorageSerializer_FactoryCreate;
            this.providesStorageTypeProvider = DoubleCheck.provider(StorageModule_ProvidesStorageTypeFactory.create(storageModule, messagingStorageSerializer_FactoryCreate));
            dagger.internal.Factory factoryCreate2 = InstanceFactory.create(messagingSettings);
            this.messagingSettingsProvider = factoryCreate2;
            Provider<String> provider2 = DoubleCheck.provider(StorageModule_ProvidesIdentifierFactory.create(storageModule, factoryCreate2));
            this.providesIdentifierProvider = provider2;
            this.providesStorageProvider = DoubleCheck.provider(StorageModule_ProvidesStorageFactory.create(storageModule, this.contextProvider, this.providesStorageTypeProvider, provider2));
            dagger.internal.Factory factoryCreate3 = InstanceFactory.create(coroutineScope);
            this.coroutineScopeProvider = factoryCreate3;
            this.providesGuideKitProvider = DoubleCheck.provider(GuideKitModule_ProvidesGuideKitFactory.create(guideKitModule, this.contextProvider, this.baseUrlProvider, this.messagingSettingsProvider, factoryCreate3));
            this.conversationKitProvider = InstanceFactory.create(conversationKit);
            this.defaultDispatcherProvider = CoroutineDispatchersModule_DefaultDispatcherFactory.create(coroutineDispatchersModule);
            this.providesIs24HoursProvider = MessagingDateFormatModule_ProvidesIs24HoursFactory.create(messagingDateFormatModule, this.contextProvider);
            this.persistenceDispatcherProvider = CoroutineDispatchersModule_PersistenceDispatcherFactory.create(coroutineDispatchersModule);
        }

        @Override
        public MessagingActivityComponent.Factory messagingActivityComponent() {
            return new MessagingActivityComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public ImageViewerComponent.Factory imageViewerActivityComponent() {
            return new ImageViewerComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public ConversationFragmentComponent.Factory conversationFragmentComponent() {
            return new ConversationFragmentComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public ConversationListFragmentComponent.Factory conversationListFragmentComponent() {
            return new ConversationListFragmentComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public ConversationFieldManager conversationFieldManager() {
            return new ConversationFieldManager(conversationFieldValidator(), this.conversationKit, this.dispatchEvent, this.featureFlagManager);
        }

        @Override
        public GuideArticleFragmentComponent.Factory guideArticleFragmentComponent() {
            return new GuideArticleFragmentComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public ConversationExtensionFragmentComponent.Factory conversationExtensionFragmentComponent() {
            return new ConversationExtensionFragmentComponentFactory(this.messagingComponentImpl);
        }

        @Override
        public CoroutineDispatcher mainDispatcher() {
            return CoroutineDispatchersModule_MainDispatcherFactory.mainDispatcher(this.coroutineDispatchersModule);
        }
    }
}
