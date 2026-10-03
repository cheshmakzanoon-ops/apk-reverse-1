package androidx.compose.p000ui.window;

import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import androidx.compose.p000ui.unit.IntOffsetKt;
import androidx.compose.p000ui.unit.IntRect;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.layout.IntrinsicMeasureScope;
import androidx.compose.ui.layout.Measurable;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.layout.MeasureResult;
import androidx.compose.ui.layout.MeasureScope;
import androidx.compose.ui.layout.Placeable;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000l\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001aU\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0010\b\u0002\u0010\r\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\u0011\u0010\u0011\u001a\r\u0012\u0004\u0012\u00020\b0\u000e¢\u0006\u0002\b\u0012H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014\u001aD\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0015\u001a\u00020\u00162\u0010\b\u0002\u0010\r\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\u0011\u0010\u0011\u001a\r\u0012\u0004\u0012\u00020\b0\u000e¢\u0006\u0002\b\u0012H\u0007¢\u0006\u0002\u0010\u0017\u001a(\u0010\u0018\u001a\u00020\b2\u0006\u0010\u0019\u001a\u00020\u00022\u0011\u0010\u0011\u001a\r\u0012\u0004\u0012\u00020\b0\u000e¢\u0006\u0002\b\u0012H\u0001¢\u0006\u0002\u0010\u001a\u001a+\u0010\u001b\u001a\u00020\b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0013\b\b\u0010\u0011\u001a\r\u0012\u0004\u0012\u00020\b0\u000e¢\u0006\u0002\b\u0012H\u0083\b¢\u0006\u0002\u0010\u001e\u001a \u0010\u001f\u001a\u00020\u00062\u0006\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020!H\u0002\u001a\u001c\u0010%\u001a\u00020!2\u0006\u0010&\u001a\u00020'2\n\b\u0002\u0010(\u001a\u0004\u0018\u00010\u0002H\u0007\u001a\u0014\u0010)\u001a\u00020\u0006*\u00020\u00102\u0006\u0010*\u001a\u00020!H\u0002\u001a\f\u0010+\u001a\u00020!*\u00020'H\u0000\u001a\f\u0010,\u001a\u00020-*\u00020.H\u0002\"\u001a\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006/²\u0006\u0015\u00100\u001a\r\u0012\u0004\u0012\u00020\b0\u000e¢\u0006\u0002\b\u0012X\u008a\u0084\u0002"}, d2 = {"LocalPopupTestTag", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "", "getLocalPopupTestTag", "()Landroidx/compose/runtime/ProvidableCompositionLocal;", "PopupPropertiesBaseFlags", "", "Popup", "", "alignment", "Landroidx/compose/ui/Alignment;", TypedValues.CycleType.S_WAVE_OFFSET, "Landroidx/compose/ui/unit/IntOffset;", "onDismissRequest", "Lkotlin/Function0;", "properties", "Landroidx/compose/ui/window/PopupProperties;", "content", "Landroidx/compose/runtime/Composable;", "Popup-K5zGePQ", "(Landroidx/compose/ui/Alignment;JLkotlin/jvm/functions/Function0;Landroidx/compose/ui/window/PopupProperties;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "popupPositionProvider", "Landroidx/compose/ui/window/PopupPositionProvider;", "(Landroidx/compose/ui/window/PopupPositionProvider;Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/window/PopupProperties;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "PopupTestTag", "tag", "(Ljava/lang/String;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "SimpleStack", "modifier", "Landroidx/compose/ui/Modifier;", "(Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "createFlags", "focusable", "", "securePolicy", "Landroidx/compose/ui/window/SecureFlagPolicy;", "clippingEnabled", "isPopupLayout", ViewHierarchyConstants.VIEW_KEY, "Landroid/view/View;", "testTag", "flagsWithSecureFlagInherited", "isParentFlagSecureEnabled", "isFlagSecureEnabled", "toIntBounds", "Landroidx/compose/ui/unit/IntRect;", "Landroid/graphics/Rect;", "ui_release", "currentContent"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidPopup_androidKt {
    private static final ProvidableCompositionLocal<String> LocalPopupTestTag = CompositionLocalKt.compositionLocalOf$default((SnapshotMutationPolicy) null, new Function0<String>() {
        public final String invoke() {
            return "DEFAULT_TEST_TAG";
        }
    }, 1, (Object) null);
    private static final int PopupPropertiesBaseFlags = 262144;

    public static final void m2114PopupK5zGePQ(Alignment alignment, long j, Function0<Unit> function0, PopupProperties popupProperties, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        Alignment alignment2;
        int i3;
        long jIntOffset;
        int i4;
        Function0<Unit> function1;
        int i5;
        int i6;
        PopupProperties popupProperties2;
        int i7;
        int i8;
        Alignment topStart;
        DefaultConstructorMarker defaultConstructorMarker;
        Function0<Unit> function3;
        PopupProperties popupProperties3;
        boolean z;
        boolean z2;
        Object objRememberedValue;
        final Function0<Unit> function4;
        final PopupProperties popupProperties4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(295309329);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Popup)P(!1,2:c#ui.unit.IntOffset,3,4)269@12290L128,276@12424L165:AndroidPopup.android.kt#2oxthz");
        int i9 = i2 & 1;
        if (i9 != 0) {
            i3 = i | 6;
            alignment2 = alignment;
        } else if ((i & 6) == 0) {
            alignment2 = alignment;
            i3 = (composerStartRestartGroup.changed(alignment2) ? 4 : 2) | i;
        } else {
            alignment2 = alignment;
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                jIntOffset = j;
                i3 |= composerStartRestartGroup.changed(jIntOffset) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    function1 = function0;
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i5 = 256;
                    } else {
                        i5 = 128;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        popupProperties2 = popupProperties;
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i7 = 2048;
                        } else {
                            i7 = 1024;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 16) != 0) {
                        if ((i & 24576) == 0) {
                            if (composerStartRestartGroup.changedInstance(function2)) {
                                i8 = 16384;
                            } else {
                                i8 = 8192;
                            }
                            i3 |= i8;
                        }
                        if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                            if (i9 != 0) {
                                topStart = Alignment.Companion.getTopStart();
                            } else {
                                topStart = alignment2;
                            }
                            if (i10 != 0) {
                                jIntOffset = IntOffsetKt.IntOffset(0, 0);
                            }
                            defaultConstructorMarker = null;
                            if (i4 != 0) {
                                function3 = null;
                            } else {
                                function3 = function1;
                            }
                            if (i6 != 0) {
                                popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                            } else {
                                popupProperties3 = popupProperties2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            z2 = z | ((i3 & 112) == 32);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z2 || objRememberedValue == Composer.Companion.getEmpty()) {
                                objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            long j2 = jIntOffset;
                            Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            jIntOffset = j2;
                            function4 = function3;
                            popupProperties4 = popupProperties3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            topStart = alignment2;
                            function4 = function1;
                            popupProperties4 = popupProperties2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Alignment alignment3 = topStart;
                            final long j3 = jIntOffset;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11) {
                                    AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment3, j3, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    if ((i3 & 9363) == 9362) {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j4 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j4;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    } else {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j5 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j5;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Alignment alignment4 = topStart;
                        final long j6 = jIntOffset;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment4, j6, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                popupProperties2 = popupProperties;
                if ((i2 & 16) != 0) {
                    if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i8 = 16384;
                        } else {
                            i8 = 8192;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j7 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j7;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    } else {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j8 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j8;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Alignment alignment5 = topStart;
                        final long j9 = jIntOffset;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment5, j9, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j10 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j10;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j11 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j11;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment6 = topStart;
                    final long j12 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment6, j12, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            function1 = function0;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i7 = 2048;
                    } else {
                        i7 = 1024;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i8 = 16384;
                        } else {
                            i8 = 8192;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j13 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j13;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    } else {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j14 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j14;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Alignment alignment7 = topStart;
                        final long j15 = jIntOffset;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment7, j15, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j16 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j16;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j17 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j17;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment8 = topStart;
                    final long j18 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment8, j18, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            popupProperties2 = popupProperties;
            if ((i2 & 16) != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = 16384;
                    } else {
                        i8 = 8192;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j19 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j19;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j110 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j110;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment9 = topStart;
                    final long j111 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment9, j111, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j112 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j112;
                function4 = function3;
                popupProperties4 = popupProperties3;
            } else {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j113 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j113;
                function4 = function3;
                popupProperties4 = popupProperties3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Alignment alignment10 = topStart;
                final long j114 = jIntOffset;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment10, j114, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        jIntOffset = j;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                function1 = function0;
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i5 = 256;
                } else {
                    i5 = 128;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i7 = 2048;
                    } else {
                        i7 = 1024;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i8 = 16384;
                        } else {
                            i8 = 8192;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j115 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j115;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    } else {
                        if (i9 != 0) {
                            topStart = Alignment.Companion.getTopStart();
                        } else {
                            topStart = alignment2;
                        }
                        if (i10 != 0) {
                            jIntOffset = IntOffsetKt.IntOffset(0, 0);
                        }
                        defaultConstructorMarker = null;
                        if (i4 != 0) {
                            function3 = null;
                        } else {
                            function3 = function1;
                        }
                        if (i6 != 0) {
                            popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z | ((i3 & 112) == 32);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        long j116 = jIntOffset;
                        Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        jIntOffset = j116;
                        function4 = function3;
                        popupProperties4 = popupProperties3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Alignment alignment11 = topStart;
                        final long j117 = jIntOffset;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment11, j117, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j118 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j118;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j119 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j119;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment12 = topStart;
                    final long j1110 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment12, j1110, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            popupProperties2 = popupProperties;
            if ((i2 & 16) != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = 16384;
                    } else {
                        i8 = 8192;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j1111 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j1111;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j1112 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j1112;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment13 = topStart;
                    final long j1113 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment13, j1113, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j1114 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j1114;
                function4 = function3;
                popupProperties4 = popupProperties3;
            } else {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j1115 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j1115;
                function4 = function3;
                popupProperties4 = popupProperties3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Alignment alignment14 = topStart;
                final long j1116 = jIntOffset;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment14, j1116, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        function1 = function0;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                popupProperties2 = popupProperties;
                if (composerStartRestartGroup.changed(popupProperties2)) {
                    i7 = 2048;
                } else {
                    i7 = 1024;
                }
                i3 |= i7;
            }
            if ((i2 & 16) != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = 16384;
                    } else {
                        i8 = 8192;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j1117 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j1117;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                } else {
                    if (i9 != 0) {
                        topStart = Alignment.Companion.getTopStart();
                    } else {
                        topStart = alignment2;
                    }
                    if (i10 != 0) {
                        jIntOffset = IntOffsetKt.IntOffset(0, 0);
                    }
                    defaultConstructorMarker = null;
                    if (i4 != 0) {
                        function3 = null;
                    } else {
                        function3 = function1;
                    }
                    if (i6 != 0) {
                        popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z | ((i3 & 112) == 32);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    long j1118 = jIntOffset;
                    Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    jIntOffset = j1118;
                    function4 = function3;
                    popupProperties4 = popupProperties3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Alignment alignment15 = topStart;
                    final long j1119 = jIntOffset;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment15, j1119, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j11110 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j11110;
                function4 = function3;
                popupProperties4 = popupProperties3;
            } else {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j11111 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j11111;
                function4 = function3;
                popupProperties4 = popupProperties3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Alignment alignment16 = topStart;
                final long j11112 = jIntOffset;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment16, j11112, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        popupProperties2 = popupProperties;
        if ((i2 & 16) != 0) {
            if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i8 = 16384;
                } else {
                    i8 = 8192;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j11113 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j11113;
                function4 = function3;
                popupProperties4 = popupProperties3;
            } else {
                if (i9 != 0) {
                    topStart = Alignment.Companion.getTopStart();
                } else {
                    topStart = alignment2;
                }
                if (i10 != 0) {
                    jIntOffset = IntOffsetKt.IntOffset(0, 0);
                }
                defaultConstructorMarker = null;
                if (i4 != 0) {
                    function3 = null;
                } else {
                    function3 = function1;
                }
                if (i6 != 0) {
                    popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                z2 = z | ((i3 & 112) == 32);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                long j11114 = jIntOffset;
                Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                jIntOffset = j11114;
                function4 = function3;
                popupProperties4 = popupProperties3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Alignment alignment17 = topStart;
                final long j11115 = jIntOffset;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment17, j11115, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        if ((i3 & 9363) == 9362) {
            if (i9 != 0) {
                topStart = Alignment.Companion.getTopStart();
            } else {
                topStart = alignment2;
            }
            if (i10 != 0) {
                jIntOffset = IntOffsetKt.IntOffset(0, 0);
            }
            defaultConstructorMarker = null;
            if (i4 != 0) {
                function3 = null;
            } else {
                function3 = function1;
            }
            if (i6 != 0) {
                popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
            } else {
                popupProperties3 = popupProperties2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
            if ((i3 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            z2 = z | ((i3 & 112) == 32);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            long j11116 = jIntOffset;
            Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            jIntOffset = j11116;
            function4 = function3;
            popupProperties4 = popupProperties3;
        } else {
            if (i9 != 0) {
                topStart = Alignment.Companion.getTopStart();
            } else {
                topStart = alignment2;
            }
            if (i10 != 0) {
                jIntOffset = IntOffsetKt.IntOffset(0, 0);
            }
            defaultConstructorMarker = null;
            if (i4 != 0) {
                function3 = null;
            } else {
                function3 = function1;
            }
            if (i6 != 0) {
                popupProperties3 = new PopupProperties(false, false, false, false, 15, (DefaultConstructorMarker) null);
            } else {
                popupProperties3 = popupProperties2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(295309329, i3, -1, "androidx.compose.ui.window.Popup (AndroidPopup.android.kt:268)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1370836537, "CC(remember):AndroidPopup.android.kt#9igjgp");
            if ((i3 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            z2 = z | ((i3 & 112) == 32);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new AlignmentOffsetPositionProvider(topStart, jIntOffset, defaultConstructorMarker);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            long j11117 = jIntOffset;
            Popup((AlignmentOffsetPositionProvider) objRememberedValue, function3, popupProperties3, function2, composerStartRestartGroup, (i3 >> 3) & 8176, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            jIntOffset = j11117;
            function4 = function3;
            popupProperties4 = popupProperties3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Alignment alignment18 = topStart;
            final long j11118 = jIntOffset;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) {
                    AndroidPopup_androidKt.m2114PopupK5zGePQ(alignment18, j11118, function4, popupProperties4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void Popup(androidx.compose.p000ui.window.PopupPositionProvider r35, kotlin.jvm.functions.Function0<kotlin.Unit> r36, androidx.compose.p000ui.window.PopupProperties r37, kotlin.jvm.functions.Function2<? super androidx.compose.runtime.Composer, ? super java.lang.Integer, kotlin.Unit> r38, androidx.compose.runtime.Composer r39, int r40, int r41) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p000ui.window.AndroidPopup_androidKt.Popup(androidx.compose.ui.window.PopupPositionProvider, kotlin.jvm.functions.Function0, androidx.compose.ui.window.PopupProperties, kotlin.jvm.functions.Function2, androidx.compose.runtime.Composer, int, int):void");
    }

    public static final int createFlags(boolean z, SecureFlagPolicy secureFlagPolicy, boolean z2) {
        int i = !z ? 262152 : 262144;
        if (secureFlagPolicy == SecureFlagPolicy.SecureOn) {
            i |= 8192;
        }
        return !z2 ? i | 512 : i;
    }

    public static final ProvidableCompositionLocal<String> getLocalPopupTestTag() {
        return LocalPopupTestTag;
    }

    public static final void PopupTestTag(final String str, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-498879600);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(PopupTestTag)P(1)429@18089L75:AndroidPopup.android.kt#2oxthz");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(str) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-498879600, i2, -1, "androidx.compose.ui.window.PopupTestTag (AndroidPopup.android.kt:428)");
            }
            CompositionLocalKt.CompositionLocalProvider(LocalPopupTestTag.provides(str), function2, composerStartRestartGroup, (i2 & 112) | ProvidedValue.$stable);
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
                    AndroidPopup_androidKt.PopupTestTag(str, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    private static final void SimpleStack(Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1406149896, "CC(SimpleStack)P(1)437@18427L979:AndroidPopup.android.kt#2oxthz");
        C00501 c00501 = C00501.INSTANCE;
        int i2 = ((i << 3) & 112) | ((i >> 3) & 14) | 384;
        ComposerKt.sourceInformationMarkerStart(composer, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer, 0);
        CompositionLocalMap currentCompositionLocalMap = composer.getCurrentCompositionLocalMap();
        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer, modifier);
        Function0 constructor = ComposeUiNode.Companion.getConstructor();
        int i3 = ((i2 << 6) & 896) | 6;
        ComposerKt.sourceInformationMarkerStart(composer, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
        if (!(composer.getApplier() instanceof Applier)) {
            ComposablesKt.invalidApplier();
        }
        composer.startReusableNode();
        if (composer.getInserting()) {
            composer.createNode(constructor);
        } else {
            composer.useNode();
        }
        Composer composer2 = Updater.constructor-impl(composer);
        Updater.set-impl(composer2, c00501, ComposeUiNode.Companion.getSetMeasurePolicy());
        Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
        Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
        if (composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
            composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
            composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
        }
        Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
        function2.invoke(composer, Integer.valueOf((i3 >> 6) & 14));
        composer.endNode();
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerEnd(composer);
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\n¢\u0006\u0004\b\b\u0010\t"}, d2 = {"<anonymous>", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;"}, k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class C00501 implements MeasurePolicy {
        public static final C00501 INSTANCE = new C00501();

        public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
            return MeasurePolicy.-CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i);
        }

        public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
            return MeasurePolicy.-CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i);
        }

        public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
            return MeasurePolicy.-CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i);
        }

        public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
            return MeasurePolicy.-CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i);
        }

        public final MeasureResult m2120measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
            int i;
            int i2;
            int size = list.size();
            if (size == 0) {
                return MeasureScope.-CC.layout$default(measureScope, 0, 0, (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                    public final void invoke(Placeable.PlacementScope placementScope) {
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }
                }, 4, (Object) null);
            }
            int i3 = 0;
            if (size == 1) {
                final Placeable placeable = list.get(0).measure-BRTryo0(j);
                return MeasureScope.-CC.layout$default(measureScope, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable.PlacementScope placementScope) {
                        Placeable.PlacementScope.placeRelative$default(placementScope, placeable, 0, 0, 0.0f, 4, (Object) null);
                    }
                }, 4, (Object) null);
            }
            ArrayList arrayList = new ArrayList(list.size());
            int size2 = list.size();
            for (int i4 = 0; i4 < size2; i4++) {
                arrayList.add(list.get(i4).measure-BRTryo0(j));
            }
            final ArrayList arrayList2 = arrayList;
            int lastIndex = CollectionsKt.getLastIndex(arrayList2);
            if (lastIndex >= 0) {
                int iMax = 0;
                int iMax2 = 0;
                while (true) {
                    Placeable placeable2 = (Placeable) arrayList2.get(i3);
                    iMax = Math.max(iMax, placeable2.getWidth());
                    iMax2 = Math.max(iMax2, placeable2.getHeight());
                    if (i3 == lastIndex) {
                        break;
                    }
                    i3++;
                }
                i = iMax;
                i2 = iMax2;
            } else {
                i = 0;
                i2 = 0;
            }
            return MeasureScope.-CC.layout$default(measureScope, i, i2, (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Placeable.PlacementScope placementScope) {
                    int lastIndex2 = CollectionsKt.getLastIndex(arrayList2);
                    if (lastIndex2 < 0) {
                        return;
                    }
                    int i5 = 0;
                    while (true) {
                        Placeable.PlacementScope.placeRelative$default(placementScope, arrayList2.get(i5), 0, 0, 0.0f, 4, (Object) null);
                        if (i5 == lastIndex2) {
                            return;
                        } else {
                            i5++;
                        }
                    }
                }
            }, 4, (Object) null);
        }
    }

    public static final boolean isFlagSecureEnabled(View view) {
        ViewGroup.LayoutParams layoutParams = view.getRootView().getLayoutParams();
        WindowManager.LayoutParams layoutParams2 = layoutParams instanceof WindowManager.LayoutParams ? (WindowManager.LayoutParams) layoutParams : null;
        return (layoutParams2 == null || (layoutParams2.flags & 8192) == 0) ? false : true;
    }

    public static final int flagsWithSecureFlagInherited(PopupProperties popupProperties, boolean z) {
        if (popupProperties.getInheritSecurePolicy() && z) {
            return popupProperties.getFlags() | 8192;
        }
        if (popupProperties.getInheritSecurePolicy() && !z) {
            return popupProperties.getFlags() & (-8193);
        }
        return popupProperties.getFlags();
    }

    public static final IntRect toIntBounds(Rect rect) {
        return new IntRect(rect.left, rect.top, rect.right, rect.bottom);
    }

    public static boolean isPopupLayout$default(View view, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            str = null;
        }
        return isPopupLayout(view, str);
    }

    public static final boolean isPopupLayout(View view, String str) {
        return (view instanceof PopupLayout) && (str == null || Intrinsics.areEqual(str, ((PopupLayout) view).getTestTag()));
    }

    public static final Function2<Composer, Integer, Unit> Popup$lambda$1(State<? extends Function2<? super Composer, ? super Integer, Unit>> state) {
        return (Function2) state.getValue();
    }
}
