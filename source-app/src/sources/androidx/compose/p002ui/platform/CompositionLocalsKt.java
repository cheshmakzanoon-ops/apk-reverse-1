package androidx.compose.p002ui.platform;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.autofill.Autofill;
import androidx.compose.p002ui.autofill.AutofillTree;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.hapticfeedback.HapticFeedback;
import androidx.compose.p002ui.input.InputModeManager;
import androidx.compose.p002ui.input.pointer.PointerIconService;
import androidx.compose.p002ui.node.Owner;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.ui.text.font.Font;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.input.TextInputService;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Deprecated;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000Ô\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0001\n\u0000\n\u0002\u0010\u000e\n\u0000\u001a0\u0010G\u001a\u00020H2\u0006\u0010I\u001a\u00020J2\u0006\u0010K\u001a\u00020?2\u0011\u0010L\u001a\r\u0012\u0004\u0012\u00020H0M¢\u0006\u0002\bNH\u0001¢\u0006\u0002\u0010O\u001a\u0010\u0010P\u001a\u00020Q2\u0006\u0010R\u001a\u00020SH\u0002\"\u0019\u0010\u0000\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\"$\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u00018GX\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0007\u0010\b\u001a\u0004\b\t\u0010\u0004\"\"\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u000b0\u00018GX\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\f\u0010\b\u001a\u0004\b\r\u0010\u0004\"\u0017\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u000f0\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0004\"\u0017\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00120\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0004\"\u0017\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00150\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0004\"\u0017\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00180\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0004\"\"\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u001b0\u00018GX\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\b\u001a\u0004\b\u001d\u0010\u0004\"\u0017\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u001f0\u0001¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0004\"\u0017\u0010!\u001a\b\u0012\u0004\u0012\u00020\"0\u0001¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u0004\"\u0017\u0010$\u001a\b\u0012\u0004\u0012\u00020%0\u0001¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u0004\"\u0017\u0010'\u001a\b\u0012\u0004\u0012\u00020(0\u0001¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u0004\"\u001c\u0010*\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010+0\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b,\u0010\u0004\"\u001a\u0010-\u001a\b\u0012\u0004\u0012\u00020.0\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b/\u0010\u0004\"\u0017\u00100\u001a\b\u0012\u0004\u0012\u00020.018F¢\u0006\u0006\u001a\u0004\b2\u00103\"\u0019\u00104\u001a\n\u0012\u0006\u0012\u0004\u0018\u0001050\u0001¢\u0006\b\n\u0000\u001a\u0004\b6\u0010\u0004\"$\u00107\u001a\n\u0012\u0006\u0012\u0004\u0018\u0001080\u00018\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b9\u0010\b\u001a\u0004\b:\u0010\u0004\"\u0017\u0010;\u001a\b\u0012\u0004\u0012\u00020<0\u0001¢\u0006\b\n\u0000\u001a\u0004\b=\u0010\u0004\"\u0017\u0010>\u001a\b\u0012\u0004\u0012\u00020?0\u0001¢\u0006\b\n\u0000\u001a\u0004\b@\u0010\u0004\"\u0017\u0010A\u001a\b\u0012\u0004\u0012\u00020B0\u0001¢\u0006\b\n\u0000\u001a\u0004\bC\u0010\u0004\"\u0017\u0010D\u001a\b\u0012\u0004\u0012\u00020E0\u0001¢\u0006\b\n\u0000\u001a\u0004\bF\u0010\u0004¨\u0006T"}, d2 = {"LocalAccessibilityManager", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "Landroidx/compose/ui/platform/AccessibilityManager;", "getLocalAccessibilityManager", "()Landroidx/compose/runtime/ProvidableCompositionLocal;", "LocalAutofill", "Landroidx/compose/ui/autofill/Autofill;", "getLocalAutofill$annotations", "()V", "getLocalAutofill", "LocalAutofillTree", "Landroidx/compose/ui/autofill/AutofillTree;", "getLocalAutofillTree$annotations", "getLocalAutofillTree", "LocalClipboardManager", "Landroidx/compose/ui/platform/ClipboardManager;", "getLocalClipboardManager", "LocalDensity", "Landroidx/compose/ui/unit/Density;", "getLocalDensity", "LocalFocusManager", "Landroidx/compose/ui/focus/FocusManager;", "getLocalFocusManager", "LocalFontFamilyResolver", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "getLocalFontFamilyResolver", "LocalFontLoader", "Landroidx/compose/ui/text/font/Font$ResourceLoader;", "getLocalFontLoader$annotations", "getLocalFontLoader", "LocalGraphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "getLocalGraphicsContext", "LocalHapticFeedback", "Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "getLocalHapticFeedback", "LocalInputModeManager", "Landroidx/compose/ui/input/InputModeManager;", "getLocalInputModeManager", "LocalLayoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLocalLayoutDirection", "LocalPointerIconService", "Landroidx/compose/ui/input/pointer/PointerIconService;", "getLocalPointerIconService", "LocalProvidableScrollCaptureInProgress", "", "getLocalProvidableScrollCaptureInProgress", "LocalScrollCaptureInProgress", "Landroidx/compose/runtime/CompositionLocal;", "getLocalScrollCaptureInProgress", "()Landroidx/compose/runtime/CompositionLocal;", "LocalSoftwareKeyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "getLocalSoftwareKeyboardController", "LocalTextInputService", "Landroidx/compose/ui/text/input/TextInputService;", "getLocalTextInputService$annotations", "getLocalTextInputService", "LocalTextToolbar", "Landroidx/compose/ui/platform/TextToolbar;", "getLocalTextToolbar", "LocalUriHandler", "Landroidx/compose/ui/platform/UriHandler;", "getLocalUriHandler", "LocalViewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getLocalViewConfiguration", "LocalWindowInfo", "Landroidx/compose/ui/platform/WindowInfo;", "getLocalWindowInfo", "ProvideCommonCompositionLocals", "", "owner", "Landroidx/compose/ui/node/Owner;", "uriHandler", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/ui/node/Owner;Landroidx/compose/ui/platform/UriHandler;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "noLocalProvidedFor", "", HintConstants.AUTOFILL_HINT_NAME, "", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CompositionLocalsKt {
    private static final ProvidableCompositionLocal<AccessibilityManager> LocalAccessibilityManager = CompositionLocalKt.staticCompositionLocalOf(new Function0<AccessibilityManager>() {
        public final AccessibilityManager m6501invoke() {
            return null;
        }
    });
    private static final ProvidableCompositionLocal<Autofill> LocalAutofill = CompositionLocalKt.staticCompositionLocalOf(new Function0<Autofill>() {
        public final Autofill m6502invoke() {
            return null;
        }
    });
    private static final ProvidableCompositionLocal<AutofillTree> LocalAutofillTree = CompositionLocalKt.staticCompositionLocalOf(new Function0<AutofillTree>() {
        public final AutofillTree m6503invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalAutofillTree");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<ClipboardManager> LocalClipboardManager = CompositionLocalKt.staticCompositionLocalOf(new Function0<ClipboardManager>() {
        public final ClipboardManager m6504invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalClipboardManager");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<GraphicsContext> LocalGraphicsContext = CompositionLocalKt.staticCompositionLocalOf(new Function0<GraphicsContext>() {
        public final GraphicsContext m6509invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalGraphicsContext");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<Density> LocalDensity = CompositionLocalKt.staticCompositionLocalOf(new Function0<Density>() {
        public final Density m6505invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalDensity");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<FocusManager> LocalFocusManager = CompositionLocalKt.staticCompositionLocalOf(new Function0<FocusManager>() {
        public final FocusManager m6506invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalFocusManager");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<Font.ResourceLoader> LocalFontLoader = CompositionLocalKt.staticCompositionLocalOf(new Function0<Font.ResourceLoader>() {
        public final Font.ResourceLoader m6508invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalFontLoader");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<FontFamily.Resolver> LocalFontFamilyResolver = CompositionLocalKt.staticCompositionLocalOf(new Function0<FontFamily.Resolver>() {
        public final FontFamily.Resolver m6507invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalFontFamilyResolver");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<HapticFeedback> LocalHapticFeedback = CompositionLocalKt.staticCompositionLocalOf(new Function0<HapticFeedback>() {
        public final HapticFeedback m6510invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalHapticFeedback");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<InputModeManager> LocalInputModeManager = CompositionLocalKt.staticCompositionLocalOf(new Function0<InputModeManager>() {
        public final InputModeManager m6511invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalInputManager");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<LayoutDirection> LocalLayoutDirection = CompositionLocalKt.staticCompositionLocalOf(new Function0<LayoutDirection>() {
        public final LayoutDirection m6512invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalLayoutDirection");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<TextInputService> LocalTextInputService = CompositionLocalKt.staticCompositionLocalOf(new Function0<TextInputService>() {
        public final TextInputService m6516invoke() {
            return null;
        }
    });
    private static final ProvidableCompositionLocal<SoftwareKeyboardController> LocalSoftwareKeyboardController = CompositionLocalKt.staticCompositionLocalOf(new Function0<SoftwareKeyboardController>() {
        public final SoftwareKeyboardController m6515invoke() {
            return null;
        }
    });
    private static final ProvidableCompositionLocal<TextToolbar> LocalTextToolbar = CompositionLocalKt.staticCompositionLocalOf(new Function0<TextToolbar>() {
        public final TextToolbar m6517invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalTextToolbar");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<UriHandler> LocalUriHandler = CompositionLocalKt.staticCompositionLocalOf(new Function0<UriHandler>() {
        public final UriHandler m6518invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalUriHandler");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<ViewConfiguration> LocalViewConfiguration = CompositionLocalKt.staticCompositionLocalOf(new Function0<ViewConfiguration>() {
        public final ViewConfiguration m6519invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalViewConfiguration");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<WindowInfo> LocalWindowInfo = CompositionLocalKt.staticCompositionLocalOf(new Function0<WindowInfo>() {
        public final WindowInfo m6520invoke() throws KotlinNothingValueException {
            CompositionLocalsKt.noLocalProvidedFor("LocalWindowInfo");
            throw new KotlinNothingValueException();
        }
    });
    private static final ProvidableCompositionLocal<PointerIconService> LocalPointerIconService = CompositionLocalKt.staticCompositionLocalOf(new Function0<PointerIconService>() {
        public final PointerIconService m6513invoke() {
            return null;
        }
    });
    private static final ProvidableCompositionLocal<Boolean> LocalProvidableScrollCaptureInProgress = CompositionLocalKt.compositionLocalOf$default(null, new Function0<Boolean>() {
        public final Boolean m6514invoke() {
            return false;
        }
    }, 1, null);

    public static void getLocalAutofill$annotations() {
    }

    public static void getLocalAutofillTree$annotations() {
    }

    @Deprecated(message = "LocalFontLoader is replaced with LocalFontFamilyResolver", replaceWith = @ReplaceWith(expression = "LocalFontFamilyResolver", imports = {}))
    public static void getLocalFontLoader$annotations() {
    }

    @Deprecated(message = "Use PlatformTextInputModifierNode instead.")
    public static void getLocalTextInputService$annotations() {
    }

    public static final ProvidableCompositionLocal<AccessibilityManager> getLocalAccessibilityManager() {
        return LocalAccessibilityManager;
    }

    public static final ProvidableCompositionLocal<Autofill> getLocalAutofill() {
        return LocalAutofill;
    }

    public static final ProvidableCompositionLocal<AutofillTree> getLocalAutofillTree() {
        return LocalAutofillTree;
    }

    public static final ProvidableCompositionLocal<ClipboardManager> getLocalClipboardManager() {
        return LocalClipboardManager;
    }

    public static final ProvidableCompositionLocal<GraphicsContext> getLocalGraphicsContext() {
        return LocalGraphicsContext;
    }

    public static final ProvidableCompositionLocal<Density> getLocalDensity() {
        return LocalDensity;
    }

    public static final ProvidableCompositionLocal<FocusManager> getLocalFocusManager() {
        return LocalFocusManager;
    }

    public static final ProvidableCompositionLocal<Font.ResourceLoader> getLocalFontLoader() {
        return LocalFontLoader;
    }

    public static final ProvidableCompositionLocal<FontFamily.Resolver> getLocalFontFamilyResolver() {
        return LocalFontFamilyResolver;
    }

    public static final ProvidableCompositionLocal<HapticFeedback> getLocalHapticFeedback() {
        return LocalHapticFeedback;
    }

    public static final ProvidableCompositionLocal<InputModeManager> getLocalInputModeManager() {
        return LocalInputModeManager;
    }

    public static final ProvidableCompositionLocal<LayoutDirection> getLocalLayoutDirection() {
        return LocalLayoutDirection;
    }

    public static final ProvidableCompositionLocal<TextInputService> getLocalTextInputService() {
        return LocalTextInputService;
    }

    public static final ProvidableCompositionLocal<SoftwareKeyboardController> getLocalSoftwareKeyboardController() {
        return LocalSoftwareKeyboardController;
    }

    public static final ProvidableCompositionLocal<TextToolbar> getLocalTextToolbar() {
        return LocalTextToolbar;
    }

    public static final ProvidableCompositionLocal<UriHandler> getLocalUriHandler() {
        return LocalUriHandler;
    }

    public static final ProvidableCompositionLocal<ViewConfiguration> getLocalViewConfiguration() {
        return LocalViewConfiguration;
    }

    public static final ProvidableCompositionLocal<WindowInfo> getLocalWindowInfo() {
        return LocalWindowInfo;
    }

    public static final ProvidableCompositionLocal<PointerIconService> getLocalPointerIconService() {
        return LocalPointerIconService;
    }

    public static final ProvidableCompositionLocal<Boolean> getLocalProvidableScrollCaptureInProgress() {
        return LocalProvidableScrollCaptureInProgress;
    }

    public static final CompositionLocal<Boolean> getLocalScrollCaptureInProgress() {
        return LocalProvidableScrollCaptureInProgress;
    }

    public static final void ProvideCommonCompositionLocals(final Owner owner, final UriHandler uriHandler, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(874662829);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ProvideCommonCompositionLocals)P(1,2)215@7394L1256:CompositionLocals.kt#itgzvw");
        if ((i & 6) == 0) {
            i2 = ((i & 8) == 0 ? composerStartRestartGroup.changed(owner) : composerStartRestartGroup.changedInstance(owner) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= (i & 64) == 0 ? composerStartRestartGroup.changed(uriHandler) : composerStartRestartGroup.changedInstance(uriHandler) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(874662829, i2, -1, "androidx.compose.ui.platform.ProvideCommonCompositionLocals (CompositionLocals.kt:214)");
            }
            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{LocalAccessibilityManager.provides(owner.getAccessibilityManager()), LocalAutofill.provides(owner.getAutofill()), LocalAutofillTree.provides(owner.getAutofillTree()), LocalClipboardManager.provides(owner.getClipboardManager()), LocalDensity.provides(owner.getDensity()), LocalFocusManager.provides(owner.getFocusOwner()), LocalFontLoader.providesDefault(owner.getFontLoader()), LocalFontFamilyResolver.providesDefault(owner.getFontFamilyResolver()), LocalHapticFeedback.provides(owner.getHapticFeedBack()), LocalInputModeManager.provides(owner.getInputModeManager()), LocalLayoutDirection.provides(owner.getLayoutDirection()), LocalTextInputService.provides(owner.getTextInputService()), LocalSoftwareKeyboardController.provides(owner.getSoftwareKeyboardController()), LocalTextToolbar.provides(owner.getTextToolbar()), LocalUriHandler.provides(uriHandler), LocalViewConfiguration.provides(owner.getViewConfiguration()), LocalWindowInfo.provides(owner.getWindowInfo()), LocalPointerIconService.provides(owner.getPointerIconService()), LocalGraphicsContext.provides(owner.getGraphicsContext())}, function2, composerStartRestartGroup, ((i2 >> 3) & 112) | ProvidedValue.$stable);
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
                    CompositionLocalsKt.ProvideCommonCompositionLocals(owner, uriHandler, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final Void noLocalProvidedFor(String str) {
        throw new IllegalStateException(("CompositionLocal " + str + " not present").toString());
    }
}
