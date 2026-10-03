package androidx.compose.foundation.text.input.internal;

import android.os.Build;
import android.os.CancellationSignal;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.HandwritingGesture;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.PreviewableHandwritingGesture;
import androidx.compose.foundation.content.TransferableContent;
import androidx.compose.foundation.content.internal.ReceiveContentConfiguration;
import androidx.compose.foundation.text.input.InputTransformation;
import androidx.compose.foundation.text.input.TextFieldCharSequence;
import androidx.compose.foundation.text.input.TextFieldState;
import androidx.compose.foundation.text.input.internal.undo.TextFieldEditUndoBehavior;
import androidx.compose.p002ui.platform.PlatformTextInputMethodRequest;
import androidx.compose.p002ui.platform.PlatformTextInputSession;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.input.ImeAction;
import androidx.compose.ui.text.input.ImeOptions;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.flow.MutableSharedFlow;

@Metadata(d1 = {"\u0000d\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0001\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a \u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\u00022\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00020\rH\u0002\u001al\u0010\u000e\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0014\u0010\u0019\u001a\u0010\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\n\u0018\u00010\u001a2\u0006\u0010\u001c\u001a\u00020\u001d2\u000e\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\n\u0018\u00010\u001f2\b\u0010 \u001a\u0004\u0018\u00010!H\u0081@¢\u0006\u0002\u0010\"\u001ah\u0010\u000e\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0014\u0010\u0019\u001a\u0010\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\n\u0018\u00010\u001a2\u0010\b\u0002\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\n\u0018\u00010\u001f2\n\b\u0002\u0010 \u001a\u0004\u0018\u00010!H\u0080@¢\u0006\u0002\u0010#\"\u0016\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0003\"\u0016\u0010\u0004\u001a\u00020\u00058\u0000X\u0081T¢\u0006\b\n\u0000\u0012\u0004\b\u0006\u0010\u0007\"\u000e\u0010\b\u001a\u00020\u0002X\u0082T¢\u0006\u0002\n\u0000¨\u0006$"}, d2 = {"ALL_MIME_TYPES", "", "", "[Ljava/lang/String;", "TIA_DEBUG", "", "getTIA_DEBUG$annotations", "()V", "TIA_TAG", "logDebug", "", "tag", "content", "Lkotlin/Function0;", "platformSpecificTextInputSession", "", "Landroidx/compose/ui/platform/PlatformTextInputSession;", "state", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "layoutState", "Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "imeOptions", "Landroidx/compose/ui/text/input/ImeOptions;", "receiveContentConfiguration", "Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;", "onImeAction", "Lkotlin/Function1;", "Landroidx/compose/ui/text/input/ImeAction;", "composeImm", "Landroidx/compose/foundation/text/input/internal/ComposeInputMethodManager;", "stylusHandwritingTrigger", "Lkotlinx/coroutines/flow/MutableSharedFlow;", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "(Landroidx/compose/ui/platform/PlatformTextInputSession;Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/TextLayoutState;Landroidx/compose/ui/text/input/ImeOptions;Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;Lkotlin/jvm/functions/Function1;Landroidx/compose/foundation/text/input/internal/ComposeInputMethodManager;Lkotlinx/coroutines/flow/MutableSharedFlow;Landroidx/compose/ui/platform/ViewConfiguration;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "(Landroidx/compose/ui/platform/PlatformTextInputSession;Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/TextLayoutState;Landroidx/compose/ui/text/input/ImeOptions;Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;Lkotlin/jvm/functions/Function1;Lkotlinx/coroutines/flow/MutableSharedFlow;Landroidx/compose/ui/platform/ViewConfiguration;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidTextInputSession_androidKt {
    private static final String[] ALL_MIME_TYPES = {"*/*", "image/*", "video/*"};
    public static final boolean TIA_DEBUG = false;
    private static final String TIA_TAG = "AndroidTextInputSession";

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.AndroidTextInputSession_androidKt", f = "AndroidTextInputSession.android.kt", i = {}, l = {59}, m = "platformSpecificTextInputSession", n = {}, s = {})
    static final class C08691 extends ContinuationImpl {
        int label;
        Object result;

        C08691(Continuation<? super C08691> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AndroidTextInputSession_androidKt.platformSpecificTextInputSession(null, null, null, null, null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.AndroidTextInputSession_androidKt", f = "AndroidTextInputSession.android.kt", i = {}, l = {82}, m = "platformSpecificTextInputSession", n = {}, s = {})
    static final class C08702 extends ContinuationImpl {
        int label;
        Object result;

        C08702(Continuation<? super C08702> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AndroidTextInputSession_androidKt.platformSpecificTextInputSession(null, null, null, null, null, null, null, null, null, (Continuation) this);
        }
    }

    public static void getTIA_DEBUG$annotations() {
    }

    private static final void logDebug(String str, Function0<String> function0) {
    }

    public static final Object platformSpecificTextInputSession(PlatformTextInputSession platformTextInputSession, TransformedTextFieldState transformedTextFieldState, TextLayoutState textLayoutState, ImeOptions imeOptions, ReceiveContentConfiguration receiveContentConfiguration, Function1<? super ImeAction, Unit> function1, MutableSharedFlow<Unit> mutableSharedFlow, ViewConfiguration viewConfiguration, Continuation<?> continuation) throws KotlinNothingValueException {
        C08691 c08691;
        if (continuation instanceof C08691) {
            c08691 = (C08691) continuation;
            if ((c08691.label & Integer.MIN_VALUE) != 0) {
                c08691.label -= Integer.MIN_VALUE;
            } else {
                c08691 = new C08691(continuation);
            }
        } else {
            c08691 = new C08691(continuation);
        }
        C08691 c08692 = c08691;
        Object obj = c08692.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08692.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ComposeInputMethodManager ComposeInputMethodManager = ComposeInputMethodManager_androidKt.ComposeInputMethodManager(platformTextInputSession.getView());
            c08692.label = 1;
            if (platformSpecificTextInputSession(platformTextInputSession, transformedTextFieldState, textLayoutState, imeOptions, receiveContentConfiguration, function1, ComposeInputMethodManager, mutableSharedFlow, viewConfiguration, c08692) == coroutine_suspended) {
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

    public static final Object platformSpecificTextInputSession(PlatformTextInputSession platformTextInputSession, TransformedTextFieldState transformedTextFieldState, TextLayoutState textLayoutState, ImeOptions imeOptions, ReceiveContentConfiguration receiveContentConfiguration, Function1<? super ImeAction, Unit> function1, ComposeInputMethodManager composeInputMethodManager, MutableSharedFlow<Unit> mutableSharedFlow, ViewConfiguration viewConfiguration, Continuation<?> continuation) throws KotlinNothingValueException {
        C08702 c08702;
        if (continuation instanceof C08702) {
            c08702 = (C08702) continuation;
            if ((c08702.label & Integer.MIN_VALUE) != 0) {
                c08702.label -= Integer.MIN_VALUE;
            } else {
                c08702 = new C08702(continuation);
            }
        } else {
            c08702 = new C08702(continuation);
        }
        Object obj = c08702.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08702.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            C08713 c08713 = new C08713(mutableSharedFlow, transformedTextFieldState, textLayoutState, composeInputMethodManager, platformTextInputSession, imeOptions, receiveContentConfiguration, function1, viewConfiguration, null);
            c08702.label = 1;
            if (CoroutineScopeKt.coroutineScope(c08713, c08702) == coroutine_suspended) {
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

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0001\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.AndroidTextInputSession_androidKt$platformSpecificTextInputSession$3", f = "AndroidTextInputSession.android.kt", i = {}, l = {129}, m = "invokeSuspend", n = {}, s = {})
    static final class C08713 extends SuspendLambda implements Function2<CoroutineScope, Continuation<?>, Object> {
        final ComposeInputMethodManager $composeImm;
        final ImeOptions $imeOptions;
        final TextLayoutState $layoutState;
        final Function1<ImeAction, Unit> $onImeAction;
        final ReceiveContentConfiguration $receiveContentConfiguration;
        final TransformedTextFieldState $state;
        final MutableSharedFlow<Unit> $stylusHandwritingTrigger;
        final PlatformTextInputSession $this_platformSpecificTextInputSession;
        final ViewConfiguration $viewConfiguration;
        private Object L$0;
        int label;

        C08713(MutableSharedFlow<Unit> mutableSharedFlow, TransformedTextFieldState transformedTextFieldState, TextLayoutState textLayoutState, ComposeInputMethodManager composeInputMethodManager, PlatformTextInputSession platformTextInputSession, ImeOptions imeOptions, ReceiveContentConfiguration receiveContentConfiguration, Function1<? super ImeAction, Unit> function1, ViewConfiguration viewConfiguration, Continuation<? super C08713> continuation) {
            super(2, continuation);
            this.$stylusHandwritingTrigger = mutableSharedFlow;
            this.$state = transformedTextFieldState;
            this.$layoutState = textLayoutState;
            this.$composeImm = composeInputMethodManager;
            this.$this_platformSpecificTextInputSession = platformTextInputSession;
            this.$imeOptions = imeOptions;
            this.$receiveContentConfiguration = receiveContentConfiguration;
            this.$onImeAction = function1;
            this.$viewConfiguration = viewConfiguration;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c08713 = new C08713(this.$stylusHandwritingTrigger, this.$state, this.$layoutState, this.$composeImm, this.$this_platformSpecificTextInputSession, this.$imeOptions, this.$receiveContentConfiguration, this.$onImeAction, this.$viewConfiguration, continuation);
            c08713.L$0 = obj;
            return c08713;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<?> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.AndroidTextInputSession_androidKt$platformSpecificTextInputSession$3$1", f = "AndroidTextInputSession.android.kt", i = {}, l = {84}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final ComposeInputMethodManager $composeImm;
            final TransformedTextFieldState $state;
            int label;

            AnonymousClass1(TransformedTextFieldState transformedTextFieldState, ComposeInputMethodManager composeInputMethodManager, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$state = transformedTextFieldState;
                this.$composeImm = composeInputMethodManager;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.$state, this.$composeImm, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    TransformedTextFieldState transformedTextFieldState = this.$state;
                    final ComposeInputMethodManager composeInputMethodManager = this.$composeImm;
                    this.label = 1;
                    if (transformedTextFieldState.collectImeNotifications(new TextFieldState.NotifyImeListener() {
                        @Override
                        public final void onChange(TextFieldCharSequence textFieldCharSequence, TextFieldCharSequence textFieldCharSequence2, boolean z) {
                            AndroidTextInputSession_androidKt.C08713.AnonymousClass1.invokeSuspend$lambda$0(composeInputMethodManager, textFieldCharSequence, textFieldCharSequence2, z);
                        }
                    }, (Continuation) this) == coroutine_suspended) {
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

            public static final void invokeSuspend$lambda$0(ComposeInputMethodManager composeInputMethodManager, TextFieldCharSequence textFieldCharSequence, TextFieldCharSequence textFieldCharSequence2, boolean z) {
                long selection = textFieldCharSequence.getSelection();
                long selection2 = textFieldCharSequence2.getSelection();
                TextRange composition = textFieldCharSequence.getComposition();
                TextRange composition2 = textFieldCharSequence2.getComposition();
                if (z && textFieldCharSequence.getComposition() != null && !textFieldCharSequence.contentEquals(textFieldCharSequence2)) {
                    composeInputMethodManager.restartInput();
                } else {
                    if (TextRange.equals-impl0(selection, selection2) && Intrinsics.areEqual(composition, composition2)) {
                        return;
                    }
                    composeInputMethodManager.updateSelection(TextRange.getMin-impl(selection2), TextRange.getMax-impl(selection2), composition2 != null ? TextRange.getMin-impl(composition2.unbox-impl()) : -1, composition2 != null ? TextRange.getMax-impl(composition2.unbox-impl()) : -1);
                }
            }
        }

        public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass1(this.$state, this.$composeImm, null), 1, (Object) null);
                MutableSharedFlow<Unit> mutableSharedFlow = this.$stylusHandwritingTrigger;
                if (mutableSharedFlow != null) {
                    BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C0874x2b7eadeb(mutableSharedFlow, this.$composeImm, null), 3, (Object) null);
                }
                final CursorAnchorInfoController cursorAnchorInfoController = new CursorAnchorInfoController(this.$state, this.$layoutState, this.$composeImm, coroutineScope);
                PlatformTextInputSession platformTextInputSession = this.$this_platformSpecificTextInputSession;
                final TransformedTextFieldState transformedTextFieldState = this.$state;
                final ImeOptions imeOptions = this.$imeOptions;
                final ReceiveContentConfiguration receiveContentConfiguration = this.$receiveContentConfiguration;
                final ComposeInputMethodManager composeInputMethodManager = this.$composeImm;
                final Function1<ImeAction, Unit> function1 = this.$onImeAction;
                final TextLayoutState textLayoutState = this.$layoutState;
                final ViewConfiguration viewConfiguration = this.$viewConfiguration;
                this.label = 1;
                if (platformTextInputSession.startInputMethod(new PlatformTextInputMethodRequest() {
                    @Override
                    public final InputConnection createInputConnection(EditorInfo editorInfo) {
                        return AndroidTextInputSession_androidKt.C08713.invokeSuspend$lambda$2(transformedTextFieldState, imeOptions, receiveContentConfiguration, composeInputMethodManager, function1, cursorAnchorInfoController, textLayoutState, viewConfiguration, editorInfo);
                    }
                }, (Continuation) this) == coroutine_suspended) {
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

        public static final InputConnection invokeSuspend$lambda$2(final TransformedTextFieldState transformedTextFieldState, ImeOptions imeOptions, final ReceiveContentConfiguration receiveContentConfiguration, final ComposeInputMethodManager composeInputMethodManager, final Function1 function1, final CursorAnchorInfoController cursorAnchorInfoController, final TextLayoutState textLayoutState, final ViewConfiguration viewConfiguration, EditorInfo editorInfo) {
            AndroidTextInputSession_androidKt.logDebug$default(null, new Function0<String>() {
                {
                    super(0);
                }

                public final String invoke() {
                    return "createInputConnection(value=\"" + ((Object) transformedTextFieldState.getVisualText()) + "\")";
                }
            }, 1, null);
            TextInputSession textInputSession = new TextInputSession() {
                @Override
                public TextFieldCharSequence getText() {
                    return transformedTextFieldState.getVisualText();
                }

                @Override
                public void requestEdit(Function1<? super EditingBuffer, Unit> block) {
                    TransformedTextFieldState transformedTextFieldState2 = transformedTextFieldState;
                    TextFieldState textFieldState = transformedTextFieldState2.textFieldState;
                    InputTransformation inputTransformation = transformedTextFieldState2.inputTransformation;
                    TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
                    textFieldState.getMainBuffer().getChangeTracker().clearChanges();
                    block.invoke(textFieldState.getMainBuffer());
                    textFieldState.commitEditAsUser(inputTransformation, false, textFieldEditUndoBehavior);
                }

                @Override
                public void sendKeyEvent(KeyEvent keyEvent) {
                    composeInputMethodManager.sendKeyEvent(keyEvent);
                }

                @Override
                public void mo1610onImeActionKlQnJC8(int imeAction) {
                    Function1<ImeAction, Unit> function2 = function1;
                    if (function2 != null) {
                        function2.invoke(ImeAction.box-impl(imeAction));
                    }
                }

                @Override
                public boolean onCommitContent(TransferableContent transferableContent) {
                    ReceiveContentConfiguration receiveContentConfiguration2 = receiveContentConfiguration;
                    if (receiveContentConfiguration2 != null) {
                        return receiveContentConfiguration2.onCommitContent(transferableContent);
                    }
                    return false;
                }

                @Override
                public void requestCursorUpdates(int cursorUpdateMode) {
                    cursorAnchorInfoController.requestUpdates(cursorUpdateMode);
                }

                @Override
                public int performHandwritingGesture(HandwritingGesture gesture) {
                    if (Build.VERSION.SDK_INT >= 34) {
                        return HandwritingGestureApi34.INSTANCE.performHandwritingGesture$foundation_release(transformedTextFieldState, gesture, textLayoutState, viewConfiguration);
                    }
                    return 2;
                }

                @Override
                public boolean previewHandwritingGesture(PreviewableHandwritingGesture gesture, CancellationSignal cancellationSignal) {
                    if (Build.VERSION.SDK_INT >= 34) {
                        return HandwritingGestureApi34.INSTANCE.previewHandwritingGesture$foundation_release(transformedTextFieldState, gesture, textLayoutState, cancellationSignal);
                    }
                    return false;
                }
            };
            EditorInfo_androidKt.m1620updatepLxbY9I(editorInfo, transformedTextFieldState.getVisualText(), transformedTextFieldState.getVisualText().getSelection(), imeOptions, receiveContentConfiguration != null ? AndroidTextInputSession_androidKt.ALL_MIME_TYPES : null);
            return new StatelessInputConnection(textInputSession, editorInfo);
        }
    }

    static void logDebug$default(String str, Function0 function0, int i, Object obj) {
        if ((i & 1) != 0) {
            str = TIA_TAG;
        }
        logDebug(str, function0);
    }
}
