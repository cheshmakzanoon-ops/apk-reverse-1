package zendesk.messaging.android.internal.conversationscreen;

import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.StateFlow;
import zendesk.conversationkit.android.internal.extension.PrivateAttachmentUtilKt;
import zendesk.p026ui.android.conversation.imagerviewer.ImageViewerRendering;
import zendesk.p026ui.android.conversation.imagerviewer.ImageViewerState;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001BG\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u000e\u0010\b\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\t\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0010J\u000e\u0010\u0012\u001a\u00020\nH\u0086@¢\u0006\u0002\u0010\u0013R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\b\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0011¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ImageViewerScreenCoordinator;", "", "imageUri", "", "isPrivateAttachment", "", "toolbarColor", "", "onBackButtonClicked", "Lkotlin/Function0;", "", "imageViewerRenderer", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/imagerviewer/ImageViewerRendering;", "conversationScreenViewModel", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;", "(Ljava/lang/String;ZLjava/lang/Integer;Lkotlin/jvm/functions/Function0;Lzendesk/ui/android/Renderer;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;)V", "Ljava/lang/Integer;", "init", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerScreenCoordinator {
    private final ConversationScreenViewModel conversationScreenViewModel;
    private final String imageUri;
    private final Renderer<ImageViewerRendering> imageViewerRenderer;
    private final boolean isPrivateAttachment;
    private final Function0<Unit> onBackButtonClicked;
    private final Integer toolbarColor;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ImageViewerScreenCoordinator", m37f = "ImageViewerScreenCoordinator.kt", m38i = {}, m39l = {35}, m40m = "init", m41n = {}, m42s = {})
    static final class C13691 extends ContinuationImpl {
        int label;
        Object result;

        C13691(Continuation<? super C13691> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ImageViewerScreenCoordinator.this.init(this);
        }
    }

    public ImageViewerScreenCoordinator(String imageUri, boolean z, Integer num, Function0<Unit> onBackButtonClicked, Renderer<ImageViewerRendering> imageViewerRenderer, ConversationScreenViewModel conversationScreenViewModel) {
        Intrinsics.checkNotNullParameter(imageUri, "imageUri");
        Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
        Intrinsics.checkNotNullParameter(imageViewerRenderer, "imageViewerRenderer");
        Intrinsics.checkNotNullParameter(conversationScreenViewModel, "conversationScreenViewModel");
        this.imageUri = imageUri;
        this.isPrivateAttachment = z;
        this.toolbarColor = num;
        this.onBackButtonClicked = onBackButtonClicked;
        this.imageViewerRenderer = imageViewerRenderer;
        this.conversationScreenViewModel = conversationScreenViewModel;
    }

    public final Object init(Continuation<? super Unit> continuation) throws Throwable {
        C13691 c13691;
        if (continuation instanceof C13691) {
            c13691 = (C13691) continuation;
            if ((c13691.label & Integer.MIN_VALUE) != 0) {
                c13691.label -= Integer.MIN_VALUE;
            } else {
                c13691 = new C13691(continuation);
            }
        } else {
            c13691 = new C13691(continuation);
        }
        Object obj = c13691.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13691.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            StateFlow<ConversationScreenState> conversationScreenStateFlow = this.conversationScreenViewModel.getConversationScreenStateFlow();
            FlowCollector<? super ConversationScreenState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((ConversationScreenState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(final ConversationScreenState conversationScreenState, Continuation<? super Unit> continuation2) {
                    Renderer renderer = ImageViewerScreenCoordinator.this.imageViewerRenderer;
                    final ImageViewerScreenCoordinator imageViewerScreenCoordinator = ImageViewerScreenCoordinator.this;
                    renderer.render(new Function1<ImageViewerRendering, ImageViewerRendering>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ImageViewerRendering invoke(ImageViewerRendering currentRendering) {
                            Intrinsics.checkNotNullParameter(currentRendering, "currentRendering");
                            ImageViewerRendering.Builder builder = currentRendering.toBuilder();
                            final ImageViewerScreenCoordinator imageViewerScreenCoordinator2 = imageViewerScreenCoordinator;
                            final ConversationScreenState conversationScreenState2 = conversationScreenState;
                            ImageViewerRendering.Builder builderState = builder.state(new Function1<ImageViewerState, ImageViewerState>() {
                                {
                                    super(1);
                                }

                                @Override
                                public final ImageViewerState invoke(ImageViewerState imageViewerState) {
                                    Intrinsics.checkNotNullParameter(imageViewerState, "imageViewerState");
                                    return ImageViewerState.copy$default(imageViewerState, imageViewerScreenCoordinator2.imageUri, null, null, null, imageViewerScreenCoordinator2.toolbarColor, Integer.valueOf(conversationScreenState2.getMessagingTheme().getPrimaryColor()), PrivateAttachmentUtilKt.resolveAuthTokenForPrivateAttachment(conversationScreenState2.getAuthorizationToken(), imageViewerScreenCoordinator2.isPrivateAttachment), 14, null);
                                }
                            });
                            final ImageViewerScreenCoordinator imageViewerScreenCoordinator3 = imageViewerScreenCoordinator;
                            return builderState.onBackButtonClicked(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    imageViewerScreenCoordinator3.onBackButtonClicked.invoke();
                                }
                            }).build();
                        }
                    });
                    return Unit.INSTANCE;
                }
            };
            c13691.label = 1;
            if (conversationScreenStateFlow.collect(flowCollector, c13691) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }
}
