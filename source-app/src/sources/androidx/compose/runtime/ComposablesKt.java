package androidx.compose.runtime;

import kotlin.Metadata;
import kotlin.NotImplementedError;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000v\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\\\u0010\u0012\u001a\u00020\u0013\"\b\b\u0000\u0010\u0014*\u00020\u0015\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001eH\u0087\b¢\u0006\u0002\u0010\u001f\u001ak\u0010\u0012\u001a\u00020\u0013\"\u0004\b\u0000\u0010\u0014\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001e2\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010\"\u001a\u0091\u0001\u0010\u0012\u001a\u00020\u0013\"\u0004\b\u0000\u0010\u0014\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001e2$\b\b\u0010#\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140$\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b!¢\u0006\u0002\b\u001e2\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010%\u001a\\\u0010&\u001a\u00020\u0013\"\b\b\u0000\u0010\u0014*\u00020\u0015\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001eH\u0087\b¢\u0006\u0002\u0010\u001f\u001ak\u0010&\u001a\u00020\u0013\"\u0004\b\u0000\u0010\u0014\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001e2\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010\"\u001a\u0091\u0001\u0010&\u001a\u00020\u0013\"\u0004\b\u0000\u0010\u0014\"\u000e\b\u0001\u0010\u0016\u0018\u0001*\u0006\u0012\u0002\b\u00030\u00172\u000e\b\b\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00140\u00192\"\u0010\u001a\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140\u001c\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b\u001d¢\u0006\u0002\b\u001e2$\b\b\u0010#\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00140$\u0012\u0004\u0012\u00020\u00130\u001b¢\u0006\u0002\b!¢\u0006\u0002\b\u001e2\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010%\u001a+\u0010'\u001a\u00020\u00132\b\u0010(\u001a\u0004\u0018\u00010\u00152\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010)\u001a+\u0010*\u001a\u00020\u00132\u0006\u0010+\u001a\u00020,2\u0013\b\u0004\u0010 \u001a\r\u0012\u0004\u0012\u00020\u00130\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u0010-\u001a\b\u0010.\u001a\u00020\u0013H\u0001\u001a?\u0010(\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\u0016\u0010/\u001a\f\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u001500\"\u0004\u0018\u00010\u00152\u0011\u00101\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b!H\u0087\b¢\u0006\u0002\u00102\u001a)\u00103\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\u0013\b\u0004\u00104\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b\u001dH\u0087\b¢\u0006\u0002\u00105\u001a3\u00103\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\b\u00106\u001a\u0004\u0018\u00010\u00152\u0013\b\u0004\u00104\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b\u001dH\u0087\b¢\u0006\u0002\u00107\u001a=\u00103\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\b\u00106\u001a\u0004\u0018\u00010\u00152\b\u00108\u001a\u0004\u0018\u00010\u00152\u0013\b\u0004\u00104\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b\u001dH\u0087\b¢\u0006\u0002\u00109\u001aG\u00103\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\b\u00106\u001a\u0004\u0018\u00010\u00152\b\u00108\u001a\u0004\u0018\u00010\u00152\b\u0010:\u001a\u0004\u0018\u00010\u00152\u0013\b\u0004\u00104\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b\u001dH\u0087\b¢\u0006\u0002\u0010;\u001aA\u00103\u001a\u0002H\u0014\"\u0004\b\u0000\u0010\u00142\u0016\u0010/\u001a\f\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u001500\"\u0004\u0018\u00010\u00152\u0013\b\u0004\u00104\u001a\r\u0012\u0004\u0012\u0002H\u00140\u0019¢\u0006\u0002\b\u001dH\u0087\b¢\u0006\u0002\u0010<\u001a\r\u0010=\u001a\u00020>H\u0007¢\u0006\u0002\u0010?\"\u0011\u0010\u0000\u001a\u00020\u00018G¢\u0006\u0006\u001a\u0004\b\u0002\u0010\u0003\"\u0011\u0010\u0004\u001a\u00020\u00058G¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007\"\u0017\u0010\b\u001a\u00020\t8G¢\u0006\f\u0012\u0004\b\n\u0010\u000b\u001a\u0004\b\f\u0010\r\"\u0011\u0010\u000e\u001a\u00020\u000f8G¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011¨\u0006@"}, d2 = {"currentComposer", "Landroidx/compose/runtime/Composer;", "getCurrentComposer", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/Composer;", "currentCompositeKeyHash", "", "getCurrentCompositeKeyHash", "(Landroidx/compose/runtime/Composer;I)I", "currentCompositionLocalContext", "Landroidx/compose/runtime/CompositionLocalContext;", "getCurrentCompositionLocalContext$annotations", "()V", "getCurrentCompositionLocalContext", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/CompositionLocalContext;", "currentRecomposeScope", "Landroidx/compose/runtime/RecomposeScope;", "getCurrentRecomposeScope", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/RecomposeScope;", "ComposeNode", "", "T", "", "E", "Landroidx/compose/runtime/Applier;", "factory", "Lkotlin/Function0;", "update", "Lkotlin/Function1;", "Landroidx/compose/runtime/Updater;", "Landroidx/compose/runtime/DisallowComposableCalls;", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;I)V", "content", "Landroidx/compose/runtime/Composable;", "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "skippableUpdate", "Landroidx/compose/runtime/SkippableUpdater;", "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "ReusableComposeNode", "ReusableContent", "key", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "ReusableContentHost", "active", "", "(ZLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "invalidApplier", "keys", "", "block", "([Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "remember", "calculation", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "key1", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "key2", "(Ljava/lang/Object;Ljava/lang/Object;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "key3", "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "([Ljava/lang/Object;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;I)Ljava/lang/Object;", "rememberCompositionContext", "Landroidx/compose/runtime/CompositionContext;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/CompositionContext;", "runtime_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ComposablesKt {
    public static void getCurrentCompositionLocalContext$annotations() {
    }

    public static final <T> T remember(Function0<? extends T> function0, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -492369756, "CC(remember):Composables.kt#9igjgp");
        T t = (T) composer.rememberedValue();
        if (t == Composer.INSTANCE.getEmpty()) {
            t = (T) function0.invoke();
            composer.updateRememberedValue(t);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final <T> T remember(Object obj, Function0<? extends T> function0, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1157296644, "CC(remember)P(1):Composables.kt#9igjgp");
        boolean zChanged = composer.changed(obj);
        T t = (T) composer.rememberedValue();
        if (zChanged || t == Composer.INSTANCE.getEmpty()) {
            t = (T) function0.invoke();
            composer.updateRememberedValue(t);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final <T> T remember(Object obj, Object obj2, Function0<? extends T> function0, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 511388516, "CC(remember)P(1,2):Composables.kt#9igjgp");
        boolean zChanged = composer.changed(obj) | composer.changed(obj2);
        T t = (T) composer.rememberedValue();
        if (zChanged || t == Composer.INSTANCE.getEmpty()) {
            t = (T) function0.invoke();
            composer.updateRememberedValue(t);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final <T> T remember(Object obj, Object obj2, Object obj3, Function0<? extends T> function0, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1618982084, "CC(remember)P(1,2,3):Composables.kt#9igjgp");
        boolean zChanged = composer.changed(obj) | composer.changed(obj2) | composer.changed(obj3);
        T t = (T) composer.rememberedValue();
        if (zChanged || t == Composer.INSTANCE.getEmpty()) {
            t = (T) function0.invoke();
            composer.updateRememberedValue(t);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final <T> T remember(Object[] objArr, Function0<? extends T> function0, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -568225417, "CC(remember)P(1):Composables.kt#9igjgp");
        boolean zChanged = false;
        for (Object obj : objArr) {
            zChanged |= composer.changed(obj);
        }
        T t = (T) composer.rememberedValue();
        if (zChanged || t == Composer.INSTANCE.getEmpty()) {
            t = (T) function0.invoke();
            composer.updateRememberedValue(t);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final <T> T key(Object[] objArr, Function2<? super Composer, ? super Integer, ? extends T> function2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -11941951, "CC(key)P(1)132@4789L7:Composables.kt#9igjgp");
        T t = (T) function2.invoke(composer, Integer.valueOf((i >> 3) & 14));
        ComposerKt.sourceInformationMarkerEnd(composer);
        return t;
    }

    public static final void ReusableContent(Object obj, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 444418301, "CC(ReusableContent)P(1)149@5444L9:Composables.kt#9igjgp");
        composer.startReusableGroup(ComposerKt.reuseKey, obj);
        function2.invoke(composer, Integer.valueOf((i >> 3) & 14));
        composer.endReusableGroup();
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    public static final void ReusableContentHost(boolean z, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        composer.startReusableGroup(ComposerKt.reuseKey, Boolean.valueOf(z));
        boolean zChanged = composer.changed(z);
        composer.startReplaceGroup(-869707859);
        ComposerKt.sourceInformation(composer, "175@6712L9");
        if (z) {
            function2.invoke(composer, Integer.valueOf((i >> 3) & 14));
        } else {
            composer.deactivateToEndGroup(zChanged);
        }
        composer.endReplaceGroup();
        composer.endReusableGroup();
    }

    public static final Composer getCurrentComposer(Composer composer, int i) throws NotImplementedError {
        ComposerKt.sourceInformationMarkerStart(composer, -554250212, "C:Composables.kt#9igjgp");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-554250212, i, -1, "androidx.compose.runtime.<get-currentComposer> (Composables.kt:187)");
        }
        throw new NotImplementedError("Implemented as an intrinsic");
    }

    public static final RecomposeScope getCurrentRecomposeScope(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 394957799, "C:Composables.kt#9igjgp");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(394957799, i, -1, "androidx.compose.runtime.<get-currentRecomposeScope> (Composables.kt:196)");
        }
        RecomposeScope recomposeScope = composer.getRecomposeScope();
        if (recomposeScope == null) {
            throw new IllegalStateException("no recompose scope found".toString());
        }
        composer.recordUsed(recomposeScope);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return recomposeScope;
    }

    public static final CompositionLocalContext getCurrentCompositionLocalContext(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -43352356, "C:Composables.kt#9igjgp");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-43352356, i, -1, "androidx.compose.runtime.<get-currentCompositionLocalContext> (Composables.kt:211)");
        }
        CompositionLocalContext compositionLocalContext = new CompositionLocalContext(composer.buildContext().getCompositionLocalScope$runtime_release());
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return compositionLocalContext;
    }

    public static final int getCurrentCompositeKeyHash(Composer composer, int i) {
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(524444915, i, -1, "androidx.compose.runtime.<get-currentCompositeKeyHash> (Composables.kt:228)");
        }
        int compoundKeyHash = composer.getCompoundKeyHash();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        return compoundKeyHash;
    }

    public static final <T, E extends Applier<?>> void ComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        composer.endNode();
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    public static final <T, E extends Applier<?>> void ReusableComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startReusableNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        composer.endNode();
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    public static final <T, E extends Applier<?>> void ComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -548224868, "CC(ComposeNode)P(1,2)336@12596L9:Composables.kt#9igjgp");
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        function2.invoke(composer, Integer.valueOf((i >> 6) & 14));
        composer.endNode();
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    public static final <T, E extends Applier<?>> void ReusableComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startReusableNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        function2.invoke(composer, Integer.valueOf((i >> 6) & 14));
        composer.endNode();
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    public static final <T, E extends Applier<?>> void ComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Function3<? super SkippableUpdater<T>, ? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        function3.invoke(SkippableUpdater.m4025boximpl(SkippableUpdater.m4026constructorimpl(composer)), composer, Integer.valueOf((i >> 3) & 112));
        composer.startReplaceableGroup(2058660585);
        function2.invoke(composer, Integer.valueOf((i >> 9) & 14));
        composer.endReplaceableGroup();
        composer.endNode();
    }

    public static final <T, E extends Applier<?>> void ReusableComposeNode(Function0<? extends T> function0, Function1<? super Updater<T>, Unit> function1, Function3<? super SkippableUpdater<T>, ? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        Applier<?> applier = composer.getApplier();
        Intrinsics.reifiedOperationMarker(3, "E");
        if (!(applier instanceof Applier)) {
            invalidApplier();
        }
        composer.startReusableNode();
        if (composer.getInserting()) {
            composer.createNode(function0);
        } else {
            composer.useNode();
        }
        function1.invoke(Updater.m4036boximpl(Updater.m4037constructorimpl(composer)));
        function3.invoke(SkippableUpdater.m4025boximpl(SkippableUpdater.m4026constructorimpl(composer)), composer, Integer.valueOf((i >> 3) & 112));
        composer.startReplaceableGroup(2058660585);
        function2.invoke(composer, Integer.valueOf((i >> 9) & 14));
        composer.endReplaceableGroup();
        composer.endNode();
    }

    public static final void invalidApplier() {
        throw new IllegalStateException("Invalid applier".toString());
    }

    public static final CompositionContext rememberCompositionContext(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1165786124, "C(rememberCompositionContext):Composables.kt#9igjgp");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1165786124, i, -1, "androidx.compose.runtime.rememberCompositionContext (Composables.kt:484)");
        }
        CompositionContext compositionContextBuildContext = composer.buildContext();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return compositionContextBuildContext;
    }
}
