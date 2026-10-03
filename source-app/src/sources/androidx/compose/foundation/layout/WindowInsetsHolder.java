package androidx.compose.foundation.layout;

import android.view.View;
import androidx.autofill.HintConstants;
import androidx.compose.p002ui.C1597R;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.core.graphics.Insets;
import androidx.core.view.DisplayCutoutCompat;
import androidx.core.view.OnApplyWindowInsetsListener;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsAnimationCompat;
import androidx.core.view.WindowInsetsCompat;
import java.util.WeakHashMap;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0010\u0002\n\u0002\b\b\b\u0000\u0018\u0000 E2\u00020\u0001:\u0001EB\u0019\b\u0002\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010=\u001a\u00020>2\u0006\u0010\u0004\u001a\u00020\u0005J\u000e\u0010?\u001a\u00020>2\u0006\u0010\u0004\u001a\u00020\u0005J\u0018\u0010@\u001a\u00020>2\u0006\u0010A\u001a\u00020\u00032\b\b\u0002\u0010B\u001a\u00020\bJ\u000e\u0010C\u001a\u00020>2\u0006\u0010A\u001a\u00020\u0003J\u000e\u0010D\u001a\u00020>2\u0006\u0010A\u001a\u00020\u0003R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\u0011\u001a\u00020\u0012¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0015\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\fR\u0011\u0010\u0017\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\fR\u0011\u0010\u0019\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0010R\u0011\u0010\u001b\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0010R\u000e\u0010\u001d\u001a\u00020\u001eX\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u001f\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b \u0010\fR\u0011\u0010!\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\fR\u0011\u0010#\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0010R\u0011\u0010%\u001a\u00020&¢\u0006\b\n\u0000\u001a\u0004\b'\u0010(R\u0011\u0010)\u001a\u00020&¢\u0006\b\n\u0000\u001a\u0004\b*\u0010(R\u0011\u0010+\u001a\u00020&¢\u0006\b\n\u0000\u001a\u0004\b,\u0010(R\u0011\u0010-\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b.\u0010\fR\u0011\u0010/\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b0\u0010\u0010R\u0011\u00101\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b2\u0010\fR\u0011\u00103\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b4\u0010\u0010R\u0011\u00105\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b6\u0010\fR\u0011\u00107\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b8\u0010\fR\u0011\u00109\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b:\u0010\u0010R\u0011\u0010;\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b<\u0010\u0010¨\u0006F"}, d2 = {"Landroidx/compose/foundation/layout/WindowInsetsHolder;", "", "insets", "Landroidx/core/view/WindowInsetsCompat;", "view", "Landroid/view/View;", "(Landroidx/core/view/WindowInsetsCompat;Landroid/view/View;)V", "accessCount", "", "captionBar", "Landroidx/compose/foundation/layout/AndroidWindowInsets;", "getCaptionBar", "()Landroidx/compose/foundation/layout/AndroidWindowInsets;", "captionBarIgnoringVisibility", "Landroidx/compose/foundation/layout/ValueInsets;", "getCaptionBarIgnoringVisibility", "()Landroidx/compose/foundation/layout/ValueInsets;", "consumes", "", "getConsumes", "()Z", "displayCutout", "getDisplayCutout", "ime", "getIme", "imeAnimationSource", "getImeAnimationSource", "imeAnimationTarget", "getImeAnimationTarget", "insetsListener", "Landroidx/compose/foundation/layout/InsetsListener;", "mandatorySystemGestures", "getMandatorySystemGestures", "navigationBars", "getNavigationBars", "navigationBarsIgnoringVisibility", "getNavigationBarsIgnoringVisibility", "safeContent", "Landroidx/compose/foundation/layout/WindowInsets;", "getSafeContent", "()Landroidx/compose/foundation/layout/WindowInsets;", "safeDrawing", "getSafeDrawing", "safeGestures", "getSafeGestures", "statusBars", "getStatusBars", "statusBarsIgnoringVisibility", "getStatusBarsIgnoringVisibility", "systemBars", "getSystemBars", "systemBarsIgnoringVisibility", "getSystemBarsIgnoringVisibility", "systemGestures", "getSystemGestures", "tappableElement", "getTappableElement", "tappableElementIgnoringVisibility", "getTappableElementIgnoringVisibility", "waterfall", "getWaterfall", "decrementAccessors", "", "incrementAccessors", "update", "windowInsets", "types", "updateImeAnimationSource", "updateImeAnimationTarget", "Companion", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class WindowInsetsHolder {
    private static boolean testInsets;
    private int accessCount;
    private final AndroidWindowInsets captionBar;
    private final ValueInsets captionBarIgnoringVisibility;
    private final boolean consumes;
    private final AndroidWindowInsets displayCutout;
    private final AndroidWindowInsets ime;
    private final ValueInsets imeAnimationSource;
    private final ValueInsets imeAnimationTarget;
    private final InsetsListener insetsListener;
    private final AndroidWindowInsets mandatorySystemGestures;
    private final AndroidWindowInsets navigationBars;
    private final ValueInsets navigationBarsIgnoringVisibility;
    private final WindowInsets safeContent;
    private final WindowInsets safeDrawing;
    private final WindowInsets safeGestures;
    private final AndroidWindowInsets statusBars;
    private final ValueInsets statusBarsIgnoringVisibility;
    private final AndroidWindowInsets systemBars;
    private final ValueInsets systemBarsIgnoringVisibility;
    private final AndroidWindowInsets systemGestures;
    private final AndroidWindowInsets tappableElement;
    private final ValueInsets tappableElementIgnoringVisibility;
    private final ValueInsets waterfall;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final WeakHashMap<View, WindowInsetsHolder> viewMap = new WeakHashMap<>();

    public WindowInsetsHolder(WindowInsetsCompat windowInsetsCompat, View view, DefaultConstructorMarker defaultConstructorMarker) {
        this(windowInsetsCompat, view);
    }

    private WindowInsetsHolder(WindowInsetsCompat windowInsetsCompat, View view) {
        DisplayCutoutCompat displayCutout;
        Insets waterfallInsets;
        Companion companion = INSTANCE;
        this.captionBar = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.captionBar(), "captionBar");
        AndroidWindowInsets androidWindowInsetsSystemInsets = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.displayCutout(), "displayCutout");
        this.displayCutout = androidWindowInsetsSystemInsets;
        AndroidWindowInsets androidWindowInsetsSystemInsets2 = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.ime(), "ime");
        this.ime = androidWindowInsetsSystemInsets2;
        AndroidWindowInsets androidWindowInsetsSystemInsets3 = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.mandatorySystemGestures(), "mandatorySystemGestures");
        this.mandatorySystemGestures = androidWindowInsetsSystemInsets3;
        this.navigationBars = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.navigationBars(), "navigationBars");
        this.statusBars = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.statusBars(), "statusBars");
        AndroidWindowInsets androidWindowInsetsSystemInsets4 = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.systemBars(), "systemBars");
        this.systemBars = androidWindowInsetsSystemInsets4;
        AndroidWindowInsets androidWindowInsetsSystemInsets5 = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.systemGestures(), "systemGestures");
        this.systemGestures = androidWindowInsetsSystemInsets5;
        AndroidWindowInsets androidWindowInsetsSystemInsets6 = companion.systemInsets(windowInsetsCompat, WindowInsetsCompat.Type.tappableElement(), "tappableElement");
        this.tappableElement = androidWindowInsetsSystemInsets6;
        ValueInsets ValueInsets = WindowInsets_androidKt.ValueInsets((windowInsetsCompat == null || (displayCutout = windowInsetsCompat.getDisplayCutout()) == null || (waterfallInsets = displayCutout.getWaterfallInsets()) == null) ? Insets.NONE : waterfallInsets, "waterfall");
        this.waterfall = ValueInsets;
        WindowInsets windowInsetsUnion = WindowInsetsKt.union(WindowInsetsKt.union(androidWindowInsetsSystemInsets4, androidWindowInsetsSystemInsets2), androidWindowInsetsSystemInsets);
        this.safeDrawing = windowInsetsUnion;
        WindowInsets windowInsetsUnion2 = WindowInsetsKt.union(WindowInsetsKt.union(WindowInsetsKt.union(androidWindowInsetsSystemInsets6, androidWindowInsetsSystemInsets3), androidWindowInsetsSystemInsets5), ValueInsets);
        this.safeGestures = windowInsetsUnion2;
        this.safeContent = WindowInsetsKt.union(windowInsetsUnion, windowInsetsUnion2);
        this.captionBarIgnoringVisibility = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.captionBar(), "captionBarIgnoringVisibility");
        this.navigationBarsIgnoringVisibility = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.navigationBars(), "navigationBarsIgnoringVisibility");
        this.statusBarsIgnoringVisibility = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.statusBars(), "statusBarsIgnoringVisibility");
        this.systemBarsIgnoringVisibility = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.systemBars(), "systemBarsIgnoringVisibility");
        this.tappableElementIgnoringVisibility = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.tappableElement(), "tappableElementIgnoringVisibility");
        this.imeAnimationTarget = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.ime(), "imeAnimationTarget");
        this.imeAnimationSource = companion.valueInsetsIgnoringVisibility(windowInsetsCompat, WindowInsetsCompat.Type.ime(), "imeAnimationSource");
        Object parent = view.getParent();
        View view2 = parent instanceof View ? (View) parent : null;
        Object tag = view2 != null ? view2.getTag(C1597R.id.consume_window_insets_tag) : null;
        Boolean bool = tag instanceof Boolean ? (Boolean) tag : null;
        this.consumes = bool != null ? bool.booleanValue() : true;
        this.insetsListener = new InsetsListener(this);
    }

    public final AndroidWindowInsets getCaptionBar() {
        return this.captionBar;
    }

    public final AndroidWindowInsets getDisplayCutout() {
        return this.displayCutout;
    }

    public final AndroidWindowInsets getIme() {
        return this.ime;
    }

    public final AndroidWindowInsets getMandatorySystemGestures() {
        return this.mandatorySystemGestures;
    }

    public final AndroidWindowInsets getNavigationBars() {
        return this.navigationBars;
    }

    public final AndroidWindowInsets getStatusBars() {
        return this.statusBars;
    }

    public final AndroidWindowInsets getSystemBars() {
        return this.systemBars;
    }

    public final AndroidWindowInsets getSystemGestures() {
        return this.systemGestures;
    }

    public final AndroidWindowInsets getTappableElement() {
        return this.tappableElement;
    }

    public final ValueInsets getWaterfall() {
        return this.waterfall;
    }

    public final WindowInsets getSafeDrawing() {
        return this.safeDrawing;
    }

    public final WindowInsets getSafeGestures() {
        return this.safeGestures;
    }

    public final WindowInsets getSafeContent() {
        return this.safeContent;
    }

    public final ValueInsets getCaptionBarIgnoringVisibility() {
        return this.captionBarIgnoringVisibility;
    }

    public final ValueInsets getNavigationBarsIgnoringVisibility() {
        return this.navigationBarsIgnoringVisibility;
    }

    public final ValueInsets getStatusBarsIgnoringVisibility() {
        return this.statusBarsIgnoringVisibility;
    }

    public final ValueInsets getSystemBarsIgnoringVisibility() {
        return this.systemBarsIgnoringVisibility;
    }

    public final ValueInsets getTappableElementIgnoringVisibility() {
        return this.tappableElementIgnoringVisibility;
    }

    public final ValueInsets getImeAnimationTarget() {
        return this.imeAnimationTarget;
    }

    public final ValueInsets getImeAnimationSource() {
        return this.imeAnimationSource;
    }

    public final boolean getConsumes() {
        return this.consumes;
    }

    public final void incrementAccessors(View view) {
        if (this.accessCount == 0) {
            ViewCompat.setOnApplyWindowInsetsListener(view, this.insetsListener);
            if (view.isAttachedToWindow()) {
                view.requestApplyInsets();
            }
            view.addOnAttachStateChangeListener(this.insetsListener);
            ViewCompat.setWindowInsetsAnimationCallback(view, this.insetsListener);
        }
        this.accessCount++;
    }

    public final void decrementAccessors(View view) {
        int i = this.accessCount - 1;
        this.accessCount = i;
        if (i == 0) {
            ViewCompat.setOnApplyWindowInsetsListener(view, (OnApplyWindowInsetsListener) null);
            ViewCompat.setWindowInsetsAnimationCallback(view, (WindowInsetsAnimationCompat.Callback) null);
            view.removeOnAttachStateChangeListener(this.insetsListener);
        }
    }

    public static void update$default(WindowInsetsHolder windowInsetsHolder, WindowInsetsCompat windowInsetsCompat, int i, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            i = 0;
        }
        windowInsetsHolder.update(windowInsetsCompat, i);
    }

    public final void update(WindowInsetsCompat windowInsets, int types) {
        if (testInsets) {
            android.view.WindowInsets windowInsets2 = windowInsets.toWindowInsets();
            Intrinsics.checkNotNull(windowInsets2);
            windowInsets = WindowInsetsCompat.toWindowInsetsCompat(windowInsets2);
        }
        this.captionBar.update$foundation_layout_release(windowInsets, types);
        this.ime.update$foundation_layout_release(windowInsets, types);
        this.displayCutout.update$foundation_layout_release(windowInsets, types);
        this.navigationBars.update$foundation_layout_release(windowInsets, types);
        this.statusBars.update$foundation_layout_release(windowInsets, types);
        this.systemBars.update$foundation_layout_release(windowInsets, types);
        this.systemGestures.update$foundation_layout_release(windowInsets, types);
        this.tappableElement.update$foundation_layout_release(windowInsets, types);
        this.mandatorySystemGestures.update$foundation_layout_release(windowInsets, types);
        if (types == 0) {
            this.captionBarIgnoringVisibility.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.captionBar())));
            this.navigationBarsIgnoringVisibility.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.navigationBars())));
            this.statusBarsIgnoringVisibility.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.statusBars())));
            this.systemBarsIgnoringVisibility.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.systemBars())));
            this.tappableElementIgnoringVisibility.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsetsIgnoringVisibility(WindowInsetsCompat.Type.tappableElement())));
            DisplayCutoutCompat displayCutout = windowInsets.getDisplayCutout();
            if (displayCutout != null) {
                this.waterfall.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(displayCutout.getWaterfallInsets()));
            }
        }
        Snapshot.INSTANCE.sendApplyNotifications();
    }

    public final void updateImeAnimationSource(WindowInsetsCompat windowInsets) {
        this.imeAnimationSource.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsets(WindowInsetsCompat.Type.ime())));
    }

    public final void updateImeAnimationTarget(WindowInsetsCompat windowInsets) {
        this.imeAnimationTarget.setValue$foundation_layout_release(WindowInsets_androidKt.toInsetsValues(windowInsets.getInsets(WindowInsetsCompat.Type.ime())));
    }

    @Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\t\u001a\u00020\bH\u0007¢\u0006\u0002\u0010\nJ\u0010\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\u0007H\u0002J\u0010\u0010\r\u001a\u00020\u000e2\u0006\u0010\u0003\u001a\u00020\u0004H\u0007J\"\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0002J\"\u0010\u0017\u001a\u00020\u00182\b\u0010\u0011\u001a\u0004\u0018\u00010\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/layout/WindowInsetsHolder$Companion;", "", "()V", "testInsets", "", "viewMap", "Ljava/util/WeakHashMap;", "Landroid/view/View;", "Landroidx/compose/foundation/layout/WindowInsetsHolder;", "current", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/layout/WindowInsetsHolder;", "getOrCreateFor", "view", "setUseTestInsets", "", "systemInsets", "Landroidx/compose/foundation/layout/AndroidWindowInsets;", "windowInsets", "Landroidx/core/view/WindowInsetsCompat;", "type", "", HintConstants.AUTOFILL_HINT_NAME, "", "valueInsetsIgnoringVisibility", "Landroidx/compose/foundation/layout/ValueInsets;", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final void setUseTestInsets(boolean testInsets) {
            WindowInsetsHolder.testInsets = testInsets;
        }

        public final WindowInsetsHolder current(Composer composer, int i) {
            ComposerKt.sourceInformationMarkerStart(composer, -1366542614, "C(current)627@22834L7,630@22926L161,630@22901L186:WindowInsets.android.kt#2w3rfo");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1366542614, i, -1, "androidx.compose.foundation.layout.WindowInsetsHolder.Companion.current (WindowInsets.android.kt:626)");
            }
            ProvidableCompositionLocal<View> localView = AndroidCompositionLocals_androidKt.getLocalView();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localView);
            ComposerKt.sourceInformationMarkerEnd(composer);
            final View view = (View) objConsume;
            final WindowInsetsHolder orCreateFor = getOrCreateFor(view);
            ComposerKt.sourceInformationMarkerStart(composer, 334587174, "CC(remember):WindowInsets.android.kt#9igjgp");
            boolean zChangedInstance = composer.changedInstance(orCreateFor) | composer.changedInstance(view);
            Object objRememberedValue = composer.rememberedValue();
            if (zChangedInstance || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        orCreateFor.incrementAccessors(view);
                        final WindowInsetsHolder windowInsetsHolder = orCreateFor;
                        final View view2 = view;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                windowInsetsHolder.decrementAccessors(view2);
                            }
                        };
                    }
                };
                composer.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            EffectsKt.DisposableEffect(orCreateFor, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue, composer, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            return orCreateFor;
        }

        private final WindowInsetsHolder getOrCreateFor(View view) {
            WindowInsetsHolder windowInsetsHolder;
            synchronized (WindowInsetsHolder.viewMap) {
                WeakHashMap weakHashMap = WindowInsetsHolder.viewMap;
                Object windowInsetsHolder2 = weakHashMap.get(view);
                if (windowInsetsHolder2 == null) {
                    WindowInsetsCompat windowInsetsCompat = null;
                    windowInsetsHolder2 = new WindowInsetsHolder(windowInsetsCompat, view, windowInsetsCompat);
                    weakHashMap.put(view, windowInsetsHolder2);
                }
                windowInsetsHolder = (WindowInsetsHolder) windowInsetsHolder2;
            }
            return windowInsetsHolder;
        }

        public final AndroidWindowInsets systemInsets(WindowInsetsCompat windowInsets, int type, String name) {
            AndroidWindowInsets androidWindowInsets = new AndroidWindowInsets(type, name);
            if (windowInsets != null) {
                androidWindowInsets.update$foundation_layout_release(windowInsets, type);
            }
            return androidWindowInsets;
        }

        public final ValueInsets valueInsetsIgnoringVisibility(WindowInsetsCompat windowInsets, int type, String name) {
            Insets insetsIgnoringVisibility;
            if (windowInsets == null || (insetsIgnoringVisibility = windowInsets.getInsetsIgnoringVisibility(type)) == null) {
                insetsIgnoringVisibility = Insets.NONE;
            }
            return WindowInsets_androidKt.ValueInsets(insetsIgnoringVisibility, name);
        }
    }
}
