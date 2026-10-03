package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.Owner;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000N\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0001\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a(\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0011\u0010\u0007\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\tH\u0007¢\u0006\u0002\u0010\n\u001a;\u0010\u000b\u001a\u00020\f*\u00020\r2'\u0010\u000e\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u0011\u0012\u0006\u0012\u0004\u0018\u00010\u00120\u000f¢\u0006\u0002\b\u0013H\u0086@¢\u0006\u0002\u0010\u0014\u001aE\u0010\u0015\u001a\u00020\f*\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u00022'\u0010\u0018\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u0011\u0012\u0006\u0012\u0004\u0018\u00010\u00120\u000f¢\u0006\u0002\b\u0013H\u0082@¢\u0006\u0002\u0010\u0019\"\u0016\u0010\u0000\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, d2 = {"LocalChainedPlatformTextInputInterceptor", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "Landroidx/compose/ui/platform/ChainedPlatformTextInputInterceptor;", "InterceptPlatformTextInput", "", "interceptor", "Landroidx/compose/ui/platform/PlatformTextInputInterceptor;", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/ui/platform/PlatformTextInputInterceptor;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "establishTextInputSession", "", "Landroidx/compose/ui/platform/PlatformTextInputModifierNode;", "block", "Lkotlin/Function2;", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/platform/PlatformTextInputModifierNode;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "interceptedTextInputSession", "Landroidx/compose/ui/node/Owner;", "chainedInterceptor", "session", "(Landroidx/compose/ui/node/Owner;Landroidx/compose/ui/platform/ChainedPlatformTextInputInterceptor;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PlatformTextInputModifierNodeKt {
    private static final ProvidableCompositionLocal<ChainedPlatformTextInputInterceptor> LocalChainedPlatformTextInputInterceptor = CompositionLocalKt.staticCompositionLocalOf(new Function0<ChainedPlatformTextInputInterceptor>() {
        public final ChainedPlatformTextInputInterceptor m6573invoke() {
            return null;
        }
    });

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.PlatformTextInputModifierNodeKt", f = "PlatformTextInputModifierNode.kt", i = {}, l = {143}, m = "establishTextInputSession", n = {}, s = {})
    static final class C17451 extends ContinuationImpl {
        int label;
        Object result;

        C17451(Continuation<? super C17451> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PlatformTextInputModifierNodeKt.establishTextInputSession(null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.PlatformTextInputModifierNodeKt", f = "PlatformTextInputModifierNode.kt", i = {}, l = {194, 196}, m = "interceptedTextInputSession", n = {}, s = {})
    static final class C17461 extends ContinuationImpl {
        int label;
        Object result;

        C17461(Continuation<? super C17461> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PlatformTextInputModifierNodeKt.interceptedTextInputSession(null, null, null, (Continuation) this);
        }
    }

    public static final Object establishTextInputSession(PlatformTextInputModifierNode platformTextInputModifierNode, Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, Continuation<?> continuation) throws KotlinNothingValueException {
        C17451 c17451;
        if (continuation instanceof C17451) {
            c17451 = (C17451) continuation;
            if ((c17451.label & Integer.MIN_VALUE) != 0) {
                c17451.label -= Integer.MIN_VALUE;
            } else {
                c17451 = new C17451(continuation);
            }
        } else {
            c17451 = new C17451(continuation);
        }
        Object obj = c17451.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c17451.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!platformTextInputModifierNode.getNode().getIsAttached()) {
                throw new IllegalArgumentException("establishTextInputSession called from an unattached node".toString());
            }
            PlatformTextInputModifierNode platformTextInputModifierNode2 = platformTextInputModifierNode;
            Owner ownerRequireOwner = DelegatableNodeKt.requireOwner(platformTextInputModifierNode2);
            ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor = (ChainedPlatformTextInputInterceptor) DelegatableNodeKt.requireLayoutNode(platformTextInputModifierNode2).getCompositionLocalMap().get(LocalChainedPlatformTextInputInterceptor);
            c17451.label = 1;
            if (interceptedTextInputSession(ownerRequireOwner, chainedPlatformTextInputInterceptor, function2, c17451) == coroutine_suspended) {
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

    public static final void InterceptPlatformTextInput(final PlatformTextInputInterceptor platformTextInputInterceptor, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(1315007550);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(InterceptPlatformTextInput)P(1)163@7651L7,168@8038L89,176@8348L135:PlatformTextInputModifierNode.kt#itgzvw");
        if ((i & 6) == 0) {
            i2 = ((i & 8) == 0 ? composerStartRestartGroup.changed(platformTextInputInterceptor) : composerStartRestartGroup.changedInstance(platformTextInputInterceptor) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1315007550, i2, -1, "androidx.compose.ui.platform.InterceptPlatformTextInput (PlatformTextInputModifierNode.kt:162)");
            }
            ProvidableCompositionLocal<ChainedPlatformTextInputInterceptor> providableCompositionLocal = LocalChainedPlatformTextInputInterceptor;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composerStartRestartGroup.consume(providableCompositionLocal);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor = (ChainedPlatformTextInputInterceptor) objConsume;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1708127741, "CC(remember):PlatformTextInputModifierNode.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(chainedPlatformTextInputInterceptor);
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new ChainedPlatformTextInputInterceptor(platformTextInputInterceptor, chainedPlatformTextInputInterceptor);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor2 = (ChainedPlatformTextInputInterceptor) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            chainedPlatformTextInputInterceptor2.updateInterceptor(platformTextInputInterceptor);
            CompositionLocalKt.CompositionLocalProvider(providableCompositionLocal.provides(chainedPlatformTextInputInterceptor2), function2, composerStartRestartGroup, (i2 & 112) | ProvidedValue.$stable);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    PlatformTextInputModifierNodeKt.InterceptPlatformTextInput(platformTextInputInterceptor, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final Object interceptedTextInputSession(Owner owner, ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor, Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, Continuation<?> continuation) throws KotlinNothingValueException {
        C17461 c17461;
        if (continuation instanceof C17461) {
            c17461 = (C17461) continuation;
            if ((c17461.label & Integer.MIN_VALUE) != 0) {
                c17461.label -= Integer.MIN_VALUE;
            } else {
                c17461 = new C17461(continuation);
            }
        } else {
            c17461 = new C17461(continuation);
        }
        Object obj = c17461.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c17461.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(obj);
                throw new KotlinNothingValueException();
            }
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            throw new KotlinNothingValueException();
        }
        ResultKt.throwOnFailure(obj);
        if (chainedPlatformTextInputInterceptor == null) {
            c17461.label = 1;
            if (owner.textInputSession(function2, c17461) == coroutine_suspended) {
                return coroutine_suspended;
            }
            throw new KotlinNothingValueException();
        }
        c17461.label = 2;
        if (chainedPlatformTextInputInterceptor.textInputSession(owner, function2, c17461) == coroutine_suspended) {
            return coroutine_suspended;
        }
        throw new KotlinNothingValueException();
    }
}
