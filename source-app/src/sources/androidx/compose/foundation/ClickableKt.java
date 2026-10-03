package androidx.compose.foundation;

import androidx.compose.foundation.gestures.ScrollableContainerNode;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.key.Key;
import androidx.compose.p002ui.input.key.KeyEvent;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import androidx.compose.p002ui.input.key.KeyInputModifierKt;
import androidx.compose.p002ui.node.TraversableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.State;
import java.util.Map;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000r\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001ax\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u000e\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\u000e\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\b\u0010\t\u001a\u0004\u0018\u00010\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\u00062\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011H\u0007ø\u0001\u0000¢\u0006\u0002\b\u0012\u001aV\u0010\u0013\u001a\u00020\u0014*\u00020\u00142\b\u0010\t\u001a\u0004\u0018\u00010\n2\b\u0010\u0015\u001a\u0004\u0018\u00010\u00162\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003ø\u0001\u0000¢\u0006\u0002\b\u0017\u001aB\u0010\u0013\u001a\u00020\u0014*\u00020\u00142\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003ø\u0001\u0000¢\u0006\u0002\b\u0018\u001aA\u0010\u0019\u001a\u00020\u0014*\u00020\u00142\b\u0010\t\u001a\u0004\u0018\u00010\n2\b\u0010\u0015\u001a\u0004\u0018\u00010\u00162\u001e\b\u0004\u0010\u001a\u001a\u0018\u0012\u0006\u0012\u0004\u0018\u00010\n\u0012\u0006\u0012\u0004\u0018\u00010\f\u0012\u0004\u0012\u00020\u00140\u001bH\u0080\b\u001a\u0088\u0001\u0010\u001c\u001a\u00020\u0014*\u00020\u00142\b\u0010\t\u001a\u0004\u0018\u00010\n2\b\u0010\u0015\u001a\u0004\u0018\u00010\u00162\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\u0010\b\u0002\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0007ø\u0001\u0000¢\u0006\u0002\b\u001d\u001at\u0010\u001c\u001a\u00020\u0014*\u00020\u00142\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\u0010\b\u0002\u0010\b\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0007ø\u0001\u0000¢\u0006\u0002\b\u001e\u001a\u009e\u0001\u0010\u001f\u001a\u00020\u0014*\u00020\u00142\u0006\u0010\t\u001a\u00020\n2\b\u0010\u0015\u001a\u0004\u0018\u00010\u00162\u0006\u0010 \u001a\u00020!2\u0012\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%0#2\f\u0010&\u001a\b\u0012\u0004\u0012\u00020(0'2\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u00032\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u0000ø\u0001\u0000¢\u0006\u0002\b)\u001a\f\u0010*\u001a\u00020\u000e*\u00020+H\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006,"}, d2 = {"CombinedClickableNode", "Landroidx/compose/foundation/CombinedClickableNode;", "onClick", "Lkotlin/Function0;", "", "onLongClickLabel", "", "onLongClick", "onDoubleClick", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "indicationNodeFactory", "Landroidx/compose/foundation/IndicationNodeFactory;", "enabled", "", "onClickLabel", "role", "Landroidx/compose/ui/semantics/Role;", "CombinedClickableNode-nSzSaCc", "clickable", "Landroidx/compose/ui/Modifier;", "indication", "Landroidx/compose/foundation/Indication;", "clickable-O2vRcR0", "clickable-XHw0xAI", "clickableWithIndicationIfNeeded", "createClickable", "Lkotlin/Function2;", "combinedClickable", "combinedClickable-XVZzFYc", "combinedClickable-cJG_KMw", "genericClickableWithoutGesture", "indicationScope", "Lkotlinx/coroutines/CoroutineScope;", "currentKeyPressInteractions", "", "Landroidx/compose/ui/input/key/Key;", "Landroidx/compose/foundation/interaction/PressInteraction$Press;", "keyClickOffset", "Landroidx/compose/runtime/State;", "Landroidx/compose/ui/geometry/Offset;", "genericClickableWithoutGesture-Kqv-Bsg", "hasScrollableContainer", "Landroidx/compose/ui/node/TraversableNode;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ClickableKt {
    public static Modifier m555clickableXHw0xAI$default(Modifier modifier, boolean z, String str, Role role, Function0 function0, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        if ((i & 2) != 0) {
            str = null;
        }
        if ((i & 4) != 0) {
            role = null;
        }
        return m554clickableXHw0xAI(modifier, z, str, role, function0);
    }

    public static Modifier m553clickableO2vRcR0$default(Modifier modifier, MutableInteractionSource mutableInteractionSource, Indication indication, boolean z, String str, Role role, Function0 function0, int i, Object obj) {
        if ((i & 4) != 0) {
            z = true;
        }
        return m552clickableO2vRcR0(modifier, mutableInteractionSource, indication, z, (i & 8) != 0 ? null : str, (i & 16) != 0 ? null : role, function0);
    }

    public static final Modifier clickableWithIndicationIfNeeded(Modifier modifier, MutableInteractionSource mutableInteractionSource, final Indication indication, final Function2<? super MutableInteractionSource, ? super IndicationNodeFactory, ? extends Modifier> function2) {
        Modifier modifierComposed$default;
        if (indication instanceof IndicationNodeFactory) {
            modifierComposed$default = (Modifier) function2.invoke(mutableInteractionSource, indication);
        } else if (indication == null) {
            modifierComposed$default = (Modifier) function2.invoke(mutableInteractionSource, (Object) null);
        } else if (mutableInteractionSource != null) {
            modifierComposed$default = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource, indication).then((Modifier) function2.invoke(mutableInteractionSource, (Object) null));
        } else {
            modifierComposed$default = ComposedModifierKt.composed$default(Modifier.INSTANCE, null, new Function3<Modifier, Composer, Integer, Modifier>() {
                {
                    super(3);
                }

                public Object invoke(Object obj, Object obj2, Object obj3) {
                    return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
                }

                public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                    composer.startReplaceGroup(-1525724089);
                    ComposerKt.sourceInformation(composer, "C375@17877L39:Clickable.kt#71ulvw");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1525724089, i, -1, "androidx.compose.foundation.clickableWithIndicationIfNeeded.<anonymous> (Clickable.kt:375)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composer, -442650590, "CC(remember):Clickable.kt#9igjgp");
                    Object objRememberedValue = composer.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composer.updateRememberedValue(objRememberedValue);
                    }
                    MutableInteractionSource mutableInteractionSource2 = (MutableInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    Modifier modifierThen = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource2, indication).then((Modifier) function2.invoke(mutableInteractionSource2, (Object) null));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer.endReplaceGroup();
                    return modifierThen;
                }
            }, 1, null);
        }
        return modifier.then(modifierComposed$default);
    }

    private static final Modifier m81x508bcb74(Modifier modifier, final boolean z, final Map<Key, PressInteraction.Press> map, final State<Offset> state, final CoroutineScope coroutineScope, final Function0<Unit> function0, final MutableInteractionSource mutableInteractionSource) {
        return KeyInputModifierKt.onKeyEvent(modifier, new Function1<KeyEvent, Boolean>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                return m562invokeZmokQxo(((KeyEvent) obj).m5686unboximpl());
            }

            public final Boolean m562invokeZmokQxo(android.view.KeyEvent keyEvent) {
                boolean z2 = true;
                if (z && Clickable_androidKt.m571isPressZmokQxo(keyEvent)) {
                    if (map.containsKey(Key.m5386boximpl(KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent)))) {
                        z2 = false;
                    } else {
                        PressInteraction.Press press = new PressInteraction.Press(state.getValue().getPackedValue(), null);
                        map.put(Key.m5386boximpl(KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent)), press);
                        BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass1(mutableInteractionSource, press, null), 3, (Object) null);
                    }
                } else if (z && Clickable_androidKt.m569isClickZmokQxo(keyEvent)) {
                    PressInteraction.Press pressRemove = map.remove(Key.m5386boximpl(KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent)));
                    if (pressRemove != null) {
                        BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C0368x8f00ca0b(mutableInteractionSource, pressRemove, null), 3, (Object) null);
                    }
                    function0.invoke();
                } else {
                    z2 = false;
                }
                return Boolean.valueOf(z2);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.ClickableKt$genericClickableWithoutGesture$detectPressAndClickFromKey$1$1", f = "Clickable.kt", i = {}, l = {434}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final MutableInteractionSource $interactionSource;
                final PressInteraction.Press $press;
                int label;

                AnonymousClass1(MutableInteractionSource mutableInteractionSource, PressInteraction.Press press, Continuation<? super AnonymousClass1> continuation) {
                    super(2, continuation);
                    this.$interactionSource = mutableInteractionSource;
                    this.$press = press;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass1(this.$interactionSource, this.$press, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        if (this.$interactionSource.emit(this.$press, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
            }
        });
    }

    public static final Modifier m560genericClickableWithoutGestureKqvBsg(Modifier modifier, MutableInteractionSource mutableInteractionSource, Indication indication, CoroutineScope coroutineScope, Map<Key, PressInteraction.Press> map, State<Offset> state, boolean z, String str, Role role, String str2, Function0<Unit> function0, Function0<Unit> function1) {
        return modifier.then(FocusableKt.focusableInNonTouchMode(HoverableKt.hoverable(IndicationKt.indication(m81x508bcb74(new ClickableSemanticsElement(z, role, str2, function0, str, function1, null), z, map, state, coroutineScope, function1, mutableInteractionSource), mutableInteractionSource, indication), mutableInteractionSource, z), z, mutableInteractionSource));
    }

    public static final CombinedClickableNode m551CombinedClickableNodenSzSaCc(Function0<Unit> function0, String str, Function0<Unit> function1, Function0<Unit> function2, MutableInteractionSource mutableInteractionSource, IndicationNodeFactory indicationNodeFactory, boolean z, String str2, Role role) {
        return new CombinedClickableNodeImpl(function0, str, function1, function2, mutableInteractionSource, indicationNodeFactory, z, str2, role, null);
    }

    public static final boolean hasScrollableContainer(TraversableNode traversableNode) throws KotlinNothingValueException {
        final Ref.BooleanRef booleanRef = new Ref.BooleanRef();
        TraversableNodeKt.traverseAncestors(traversableNode, ScrollableContainerNode.INSTANCE, new Function1<TraversableNode, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(TraversableNode traversableNode2) {
                boolean z;
                Ref.BooleanRef booleanRef2 = booleanRef;
                if (booleanRef2.element) {
                    z = true;
                } else {
                    Intrinsics.checkNotNull(traversableNode2, "null cannot be cast to non-null type androidx.compose.foundation.gestures.ScrollableContainerNode");
                    if (((ScrollableContainerNode) traversableNode2).getEnabled()) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                booleanRef2.element = z;
                return Boolean.valueOf(!booleanRef.element);
            }
        });
        return booleanRef.element;
    }

    public static final Modifier m554clickableXHw0xAI(Modifier modifier, final boolean z, final String str, final Role role, final Function0<Unit> function0) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("clickable");
                inspectorInfo.getProperties().set("enabled", Boolean.valueOf(z));
                inspectorInfo.getProperties().set("onClickLabel", str);
                inspectorInfo.getProperties().set("role", role);
                inspectorInfo.getProperties().set("onClick", function0);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                MutableInteractionSource mutableInteractionSource;
                composer.startReplaceGroup(-756081143);
                ComposerKt.sourceInformation(composer, "C112@5124L7:Clickable.kt#71ulvw");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-756081143, i, -1, "androidx.compose.foundation.clickable.<anonymous> (Clickable.kt:112)");
                }
                ProvidableCompositionLocal<Indication> localIndication = IndicationKt.getLocalIndication();
                ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume = composer.consume(localIndication);
                ComposerKt.sourceInformationMarkerEnd(composer);
                Indication indication = (Indication) objConsume;
                if (indication instanceof IndicationNodeFactory) {
                    composer.startReplaceGroup(617140216);
                    composer.endReplaceGroup();
                    mutableInteractionSource = null;
                } else {
                    composer.startReplaceGroup(617248189);
                    ComposerKt.sourceInformation(composer, "119@5488L39");
                    ComposerKt.sourceInformationMarkerStart(composer, 1266842702, "CC(remember):Clickable.kt#9igjgp");
                    Object objRememberedValue = composer.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composer.updateRememberedValue(objRememberedValue);
                    }
                    mutableInteractionSource = (MutableInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    composer.endReplaceGroup();
                }
                Modifier modifierM552clickableO2vRcR0 = ClickableKt.m552clickableO2vRcR0(Modifier.INSTANCE, mutableInteractionSource, indication, z, str, role, function0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifierM552clickableO2vRcR0;
            }
        });
    }

    public static final Modifier m552clickableO2vRcR0(Modifier modifier, MutableInteractionSource mutableInteractionSource, final Indication indication, final boolean z, final String str, final Role role, final Function0<Unit> function0) {
        ClickableElement clickableElementComposed$default;
        ClickableElement clickableElement;
        if (indication instanceof IndicationNodeFactory) {
            clickableElement = new ClickableElement(mutableInteractionSource, (IndicationNodeFactory) indication, z, str, role, function0, null);
        } else {
            if (indication == null) {
                clickableElement = new ClickableElement(mutableInteractionSource, null, z, str, role, function0, null);
            } else if (mutableInteractionSource != null) {
                clickableElementComposed$default = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource, indication).then(new ClickableElement(mutableInteractionSource, null, z, str, role, function0, null));
            } else {
                clickableElementComposed$default = ComposedModifierKt.composed$default(Modifier.INSTANCE, null, new Function3<Modifier, Composer, Integer, Modifier>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
                    }

                    public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                        composer.startReplaceGroup(-1525724089);
                        ComposerKt.sourceInformation(composer, "C375@17877L39:Clickable.kt#71ulvw");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1525724089, i, -1, "androidx.compose.foundation.clickableWithIndicationIfNeeded.<anonymous> (Clickable.kt:375)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer, -442650590, "CC(remember):Clickable.kt#9igjgp");
                        Object objRememberedValue = composer.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                            composer.updateRememberedValue(objRememberedValue);
                        }
                        MutableInteractionSource mutableInteractionSource2 = (MutableInteractionSource) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composer);
                        Modifier modifierThen = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource2, indication).then(new ClickableElement(mutableInteractionSource2, null, z, str, role, function0, null));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer.endReplaceGroup();
                        return modifierThen;
                    }
                }, 1, null);
            }
            return modifier.then(clickableElementComposed$default);
        }
        clickableElementComposed$default = clickableElement;
        return modifier.then(clickableElementComposed$default);
    }

    public static final Modifier m558combinedClickablecJG_KMw(Modifier modifier, final boolean z, final String str, final Role role, final String str2, final Function0<Unit> function0, final Function0<Unit> function1, final Function0<Unit> function2) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("combinedClickable");
                inspectorInfo.getProperties().set("enabled", Boolean.valueOf(z));
                inspectorInfo.getProperties().set("onClickLabel", str);
                inspectorInfo.getProperties().set("role", role);
                inspectorInfo.getProperties().set("onClick", function2);
                inspectorInfo.getProperties().set("onDoubleClick", function1);
                inspectorInfo.getProperties().set("onLongClick", function0);
                inspectorInfo.getProperties().set("onLongClickLabel", str2);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                MutableInteractionSource mutableInteractionSource;
                composer.startReplaceGroup(1969174843);
                ComposerKt.sourceInformation(composer, "C252@11777L7:Clickable.kt#71ulvw");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1969174843, i, -1, "androidx.compose.foundation.combinedClickable.<anonymous> (Clickable.kt:252)");
                }
                ProvidableCompositionLocal<Indication> localIndication = IndicationKt.getLocalIndication();
                ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume = composer.consume(localIndication);
                ComposerKt.sourceInformationMarkerEnd(composer);
                Indication indication = (Indication) objConsume;
                if (indication instanceof IndicationNodeFactory) {
                    composer.startReplaceGroup(-1726989699);
                    composer.endReplaceGroup();
                    mutableInteractionSource = null;
                } else {
                    composer.startReplaceGroup(-1726881726);
                    ComposerKt.sourceInformation(composer, "259@12141L39");
                    ComposerKt.sourceInformationMarkerStart(composer, -1995363031, "CC(remember):Clickable.kt#9igjgp");
                    Object objRememberedValue = composer.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composer.updateRememberedValue(objRememberedValue);
                    }
                    mutableInteractionSource = (MutableInteractionSource) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composer);
                    composer.endReplaceGroup();
                }
                Modifier modifierM556combinedClickableXVZzFYc = ClickableKt.m556combinedClickableXVZzFYc(Modifier.INSTANCE, mutableInteractionSource, indication, z, str, role, str2, function0, function1, function2);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceGroup();
                return modifierM556combinedClickableXVZzFYc;
            }
        });
    }

    public static final Modifier m556combinedClickableXVZzFYc(Modifier modifier, MutableInteractionSource mutableInteractionSource, final Indication indication, final boolean z, final String str, final Role role, final String str2, final Function0<Unit> function0, final Function0<Unit> function1, final Function0<Unit> function2) {
        CombinedClickableElement combinedClickableElementComposed$default;
        CombinedClickableElement combinedClickableElement;
        if (indication instanceof IndicationNodeFactory) {
            combinedClickableElement = new CombinedClickableElement(mutableInteractionSource, (IndicationNodeFactory) indication, z, str, role, function2, str2, function0, function1, null);
        } else {
            if (indication == null) {
                combinedClickableElement = new CombinedClickableElement(mutableInteractionSource, null, z, str, role, function2, str2, function0, function1, null);
            } else if (mutableInteractionSource != null) {
                combinedClickableElementComposed$default = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource, indication).then(new CombinedClickableElement(mutableInteractionSource, null, z, str, role, function2, str2, function0, function1, null));
            } else {
                combinedClickableElementComposed$default = ComposedModifierKt.composed$default(Modifier.INSTANCE, null, new Function3<Modifier, Composer, Integer, Modifier>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
                    }

                    public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                        composer.startReplaceGroup(-1525724089);
                        ComposerKt.sourceInformation(composer, "C375@17877L39:Clickable.kt#71ulvw");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1525724089, i, -1, "androidx.compose.foundation.clickableWithIndicationIfNeeded.<anonymous> (Clickable.kt:375)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer, -442650590, "CC(remember):Clickable.kt#9igjgp");
                        Object objRememberedValue = composer.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                            composer.updateRememberedValue(objRememberedValue);
                        }
                        MutableInteractionSource mutableInteractionSource2 = (MutableInteractionSource) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composer);
                        Modifier modifierThen = IndicationKt.indication(Modifier.INSTANCE, mutableInteractionSource2, indication).then(new CombinedClickableElement(mutableInteractionSource2, null, z, str, role, function2, str2, function0, function1, null));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer.endReplaceGroup();
                        return modifierThen;
                    }
                }, 1, null);
            }
            return modifier.then(combinedClickableElementComposed$default);
        }
        combinedClickableElementComposed$default = combinedClickableElement;
        return modifier.then(combinedClickableElementComposed$default);
    }
}
