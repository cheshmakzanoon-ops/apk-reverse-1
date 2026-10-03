package androidx.compose.animation;

import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.animation.core.Transition;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000l\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\u001a\u0091\u0001\u0010\u0006\u001a\u00020\u0007\"\u0004\b\u0000\u0010\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\b0\u00022\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00010\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0018\u0010\u0012\u001a\u0014\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00010\u00132\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u00152\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0001¢\u0006\u0002\u0010\u001a\u001aa\u0010\u001b\u001a\u00020\u00072\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00010\u001d2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010 \u001a[\u0010\u001b\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010!\u001ak\u0010\"\u001a\u00020\u0007\"\u0004\b\u0000\u0010\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\b0\u00022\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00010\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0001¢\u0006\u0002\u0010#\u001am\u0010\u001b\u001a\u00020\u0007\"\u0004\b\u0000\u0010\b*\b\u0012\u0004\u0012\u0002H\b0\u00022\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00010\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010$\u001ae\u0010\u001b\u001a\u00020\u0007*\u00020%2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00010\u001d2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010&\u001a_\u0010\u001b\u001a\u00020\u0007*\u00020%2\u0006\u0010\n\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010'\u001ae\u0010\u001b\u001a\u00020\u0007*\u00020(2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00010\u001d2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010)\u001a_\u0010\u001b\u001a\u00020\u0007*\u00020(2\u0006\u0010\n\u001a\u00020\u00012\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00070\u000b¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007¢\u0006\u0002\u0010*\u001a9\u0010+\u001a\u00020\u0003\"\u0004\b\u0000\u0010\b*\b\u0012\u0004\u0012\u0002H\b0\u00022\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00010\u000b2\u0006\u0010,\u001a\u0002H\bH\u0003¢\u0006\u0002\u0010-\"\u001e\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005¨\u0006.²\u0006\"\u0010/\u001a\u0014\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00010\u0013\"\u0004\b\u0000\u0010\bX\u008a\u0084\u0002²\u0006\u0010\u00100\u001a\u00020\u0001\"\u0004\b\u0000\u0010\bX\u008a\u0084\u0002"}, d2 = {"exitFinished", "", "Landroidx/compose/animation/core/Transition;", "Landroidx/compose/animation/EnterExitState;", "getExitFinished", "(Landroidx/compose/animation/core/Transition;)Z", "AnimatedEnterExitImpl", "", "T", "transition", "visible", "Lkotlin/Function1;", "modifier", "Landroidx/compose/ui/Modifier;", "enter", "Landroidx/compose/animation/EnterTransition;", "exit", "Landroidx/compose/animation/ExitTransition;", "shouldDisposeBlock", "Lkotlin/Function2;", "onLookaheadMeasured", "Landroidx/compose/animation/OnLookaheadMeasured;", "content", "Landroidx/compose/animation/AnimatedVisibilityScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/animation/core/Transition;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Lkotlin/jvm/functions/Function2;Landroidx/compose/animation/OnLookaheadMeasured;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "AnimatedVisibility", "visibleState", "Landroidx/compose/animation/core/MutableTransitionState;", "label", "", "(Landroidx/compose/animation/core/MutableTransitionState;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "(ZLandroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "AnimatedVisibilityImpl", "(Landroidx/compose/animation/core/Transition;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;I)V", "(Landroidx/compose/animation/core/Transition;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "Landroidx/compose/foundation/layout/ColumnScope;", "(Landroidx/compose/foundation/layout/ColumnScope;Landroidx/compose/animation/core/MutableTransitionState;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/foundation/layout/ColumnScope;ZLandroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "Landroidx/compose/foundation/layout/RowScope;", "(Landroidx/compose/foundation/layout/RowScope;Landroidx/compose/animation/core/MutableTransitionState;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/foundation/layout/RowScope;ZLandroidx/compose/ui/Modifier;Landroidx/compose/animation/EnterTransition;Landroidx/compose/animation/ExitTransition;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "targetEnterExit", "targetState", "(Landroidx/compose/animation/core/Transition;Lkotlin/jvm/functions/Function1;Ljava/lang/Object;Landroidx/compose/runtime/Composer;I)Landroidx/compose/animation/EnterExitState;", "animation_release", "shouldDisposeBlockUpdated", "shouldDisposeAfterExit"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AnimatedVisibilityKt {
    public static final void AnimatedVisibility(final boolean z, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        ExitTransition exitTransitionPlus;
        String str3;
        final String str4;
        final EnterTransition enterTransition3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(2088733774);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)132@6967L32,133@7004L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.Clip;
                            } else {
                                i9 = Fields.Shape;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 196608;
                        } else if ((i & 196608) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = Fields.RenderEffect;
                            } else {
                                i10 = 65536;
                            }
                            i3 |= i10;
                        }
                        if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                            }
                            int i12 = i3 << 3;
                            int i13 = (i12 & 57344) | (i12 & 896) | 48 | (i12 & 7168) | (i3 & 458752);
                            String str5 = str3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z2) {
                                    return Boolean.valueOf(z2);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i13);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            exitTransition2 = exitTransitionPlus;
                            str4 = str5;
                            enterTransition3 = enterTransitionPlus;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            companion = modifier2;
                            enterTransition3 = enterTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = companion;
                            final ExitTransition exitTransition3 = exitTransition2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i14) {
                                    AnimatedVisibilityKt.AnimatedVisibility(z, modifier3, enterTransition3, exitTransition3, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i14 = i3 << 3;
                        int i15 = (i14 & 57344) | (i14 & 896) | 48 | (i14 & 7168) | (i3 & 458752);
                        String str6 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i15);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str6;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i16 = i3 << 3;
                        int i17 = (i16 & 57344) | (i16 & 896) | 48 | (i16 & 7168) | (i3 & 458752);
                        String str7 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i17);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str7;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = companion;
                        final ExitTransition exitTransition4 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                AnimatedVisibilityKt.AnimatedVisibility(z, modifier4, enterTransition3, exitTransition4, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i18 = i3 << 3;
                        int i19 = (i18 & 57344) | (i18 & 896) | 48 | (i18 & 7168) | (i3 & 458752);
                        String str8 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i19);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str8;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i110 = i3 << 3;
                        int i111 = (i110 & 57344) | (i110 & 896) | 48 | (i110 & 7168) | (i3 & 458752);
                        String str9 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str9;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = companion;
                        final ExitTransition exitTransition5 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i112) {
                                AnimatedVisibilityKt.AnimatedVisibility(z, modifier5, enterTransition3, exitTransition5, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i112 = i3 << 3;
                    int i113 = (i112 & 57344) | (i112 & 896) | 48 | (i112 & 7168) | (i3 & 458752);
                    String str10 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str10;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i114 = i3 << 3;
                    int i115 = (i114 & 57344) | (i114 & 896) | 48 | (i114 & 7168) | (i3 & 458752);
                    String str11 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i115);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str11;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = companion;
                    final ExitTransition exitTransition6 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier6, enterTransition3, exitTransition6, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i116 = i3 << 3;
                        int i117 = (i116 & 57344) | (i116 & 896) | 48 | (i116 & 7168) | (i3 & 458752);
                        String str12 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i117);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str12;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i118 = i3 << 3;
                        int i119 = (i118 & 57344) | (i118 & 896) | 48 | (i118 & 7168) | (i3 & 458752);
                        String str13 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i119);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str13;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = companion;
                        final ExitTransition exitTransition7 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1110) {
                                AnimatedVisibilityKt.AnimatedVisibility(z, modifier7, enterTransition3, exitTransition7, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i1110 = i3 << 3;
                    int i1111 = (i1110 & 57344) | (i1110 & 896) | 48 | (i1110 & 7168) | (i3 & 458752);
                    String str14 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str14;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i1112 = i3 << 3;
                    int i1113 = (i1112 & 57344) | (i1112 & 896) | 48 | (i1112 & 7168) | (i3 & 458752);
                    String str15 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str15;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = companion;
                    final ExitTransition exitTransition8 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1114) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier8, enterTransition3, exitTransition8, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i1114 = i3 << 3;
                    int i1115 = (i1114 & 57344) | (i1114 & 896) | 48 | (i1114 & 7168) | (i3 & 458752);
                    String str16 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1115);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str16;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i1116 = i3 << 3;
                    int i1117 = (i1116 & 57344) | (i1116 & 896) | 48 | (i1116 & 7168) | (i3 & 458752);
                    String str17 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1117);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str17;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = companion;
                    final ExitTransition exitTransition9 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1118) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier9, enterTransition3, exitTransition9, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i1118 = i3 << 3;
                int i1119 = (i1118 & 57344) | (i1118 & 896) | 48 | (i1118 & 7168) | (i3 & 458752);
                String str18 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1119);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str18;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i11110 = i3 << 3;
                int i11111 = (i11110 & 57344) | (i11110 & 896) | 48 | (i11110 & 7168) | (i3 & 458752);
                String str19 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str19;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = companion;
                final ExitTransition exitTransition10 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11112) {
                        AnimatedVisibilityKt.AnimatedVisibility(z, modifier10, enterTransition3, exitTransition10, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i11112 = i3 << 3;
                        int i11113 = (i11112 & 57344) | (i11112 & 896) | 48 | (i11112 & 7168) | (i3 & 458752);
                        String str110 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11113);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str110;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                        }
                        int i11114 = i3 << 3;
                        int i11115 = (i11114 & 57344) | (i11114 & 896) | 48 | (i11114 & 7168) | (i3 & 458752);
                        String str111 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11115);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str111;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = companion;
                        final ExitTransition exitTransition11 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11116) {
                                AnimatedVisibilityKt.AnimatedVisibility(z, modifier11, enterTransition3, exitTransition11, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i11116 = i3 << 3;
                    int i11117 = (i11116 & 57344) | (i11116 & 896) | 48 | (i11116 & 7168) | (i3 & 458752);
                    String str112 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11117);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str112;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i11118 = i3 << 3;
                    int i11119 = (i11118 & 57344) | (i11118 & 896) | 48 | (i11118 & 7168) | (i3 & 458752);
                    String str113 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11119);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str113;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = companion;
                    final ExitTransition exitTransition12 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111110) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier12, enterTransition3, exitTransition12, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i111110 = i3 << 3;
                    int i111111 = (i111110 & 57344) | (i111110 & 896) | 48 | (i111110 & 7168) | (i3 & 458752);
                    String str114 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str114;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i111112 = i3 << 3;
                    int i111113 = (i111112 & 57344) | (i111112 & 896) | 48 | (i111112 & 7168) | (i3 & 458752);
                    String str115 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str115;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = companion;
                    final ExitTransition exitTransition13 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111114) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier13, enterTransition3, exitTransition13, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i111114 = i3 << 3;
                int i111115 = (i111114 & 57344) | (i111114 & 896) | 48 | (i111114 & 7168) | (i3 & 458752);
                String str116 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111115);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str116;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i111116 = i3 << 3;
                int i111117 = (i111116 & 57344) | (i111116 & 896) | 48 | (i111116 & 7168) | (i3 & 458752);
                String str117 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111117);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str117;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = companion;
                final ExitTransition exitTransition14 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111118) {
                        AnimatedVisibilityKt.AnimatedVisibility(z, modifier14, enterTransition3, exitTransition14, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i111118 = i3 << 3;
                    int i111119 = (i111118 & 57344) | (i111118 & 896) | 48 | (i111118 & 7168) | (i3 & 458752);
                    String str118 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111119);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str118;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                    }
                    int i1111110 = i3 << 3;
                    int i1111111 = (i1111110 & 57344) | (i1111110 & 896) | 48 | (i1111110 & 7168) | (i3 & 458752);
                    String str119 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str119;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = companion;
                    final ExitTransition exitTransition15 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111112) {
                            AnimatedVisibilityKt.AnimatedVisibility(z, modifier15, enterTransition3, exitTransition15, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i1111112 = i3 << 3;
                int i1111113 = (i1111112 & 57344) | (i1111112 & 896) | 48 | (i1111112 & 7168) | (i3 & 458752);
                String str1110 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111113);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1110;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i1111114 = i3 << 3;
                int i1111115 = (i1111114 & 57344) | (i1111114 & 896) | 48 | (i1111114 & 7168) | (i3 & 458752);
                String str1111 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111115);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1111;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = companion;
                final ExitTransition exitTransition16 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111116) {
                        AnimatedVisibilityKt.AnimatedVisibility(z, modifier16, enterTransition3, exitTransition16, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i1111116 = i3 << 3;
                int i1111117 = (i1111116 & 57344) | (i1111116 & 896) | 48 | (i1111116 & 7168) | (i3 & 458752);
                String str1112 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111117);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1112;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
                }
                int i1111118 = i3 << 3;
                int i1111119 = (i1111118 & 57344) | (i1111118 & 896) | 48 | (i1111118 & 7168) | (i3 & 458752);
                String str1113 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111119);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1113;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = companion;
                final ExitTransition exitTransition17 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111110) {
                        AnimatedVisibilityKt.AnimatedVisibility(z, modifier17, enterTransition3, exitTransition17, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = Fields.RenderEffect;
            } else {
                i10 = 65536;
            }
            i3 |= i10;
        }
        if ((74899 & i3) == 74898) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
            }
            int i11111110 = i3 << 3;
            int i11111111 = (i11111110 & 57344) | (i11111110 & 896) | 48 | (i11111110 & 7168) | (i3 & 458752);
            String str1114 = str3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111111);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            exitTransition2 = exitTransitionPlus;
            str4 = str1114;
            enterTransition3 = enterTransitionPlus;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2088733774, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:131)");
            }
            int i11111112 = i3 << 3;
            int i11111113 = (i11111112 & 57344) | (i11111112 & 896) | 48 | (i11111112 & 7168) | (i3 & 458752);
            String str1115 = str3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111113);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            exitTransition2 = exitTransitionPlus;
            str4 = str1115;
            enterTransition3 = enterTransitionPlus;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier18 = companion;
            final ExitTransition exitTransition18 = exitTransition2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111114) {
                    AnimatedVisibilityKt.AnimatedVisibility(z, modifier18, enterTransition3, exitTransition18, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void AnimatedVisibility(final RowScope rowScope, final boolean z, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        final ExitTransition exitTransitionPlus;
        String str3;
        final Modifier modifier3;
        final EnterTransition enterTransition3;
        final String str4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1741346906);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)207@11272L32,208@11309L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 48;
        } else if ((i & 48) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 32 : 16) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = 1048576;
                            } else {
                                i10 = 524288;
                            }
                            i3 |= i10;
                        }
                        if ((599185 & i3) == 599184 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                            }
                            int i12 = i3 >> 3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i12 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z2) {
                                    return Boolean.valueOf(z2);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i12 & 458752));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = companion;
                            enterTransition3 = enterTransitionPlus;
                            str4 = str3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            enterTransition3 = enterTransition2;
                            exitTransitionPlus = exitTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i13) {
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i13 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i13 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i13 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i14 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i14 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i14 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i15 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i15 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i15 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i16 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i16 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i16 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i17 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i17 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i17 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i18 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i18 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i18 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i19 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i19 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i19 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i110 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i110 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i113 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i113 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i114 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i114 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i115 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i115 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i116 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i116 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i117 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i117 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                        }
                        int i118 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i118 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i119) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i119 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i119 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i1110 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1110 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i1111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i1112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1113) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i1113 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1113 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i1114 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1114 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1115) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i1115 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1115 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                    }
                    int i1116 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1116 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i1117 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1117 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i1118 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1118 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1119) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i1119 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1119 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
                }
                int i11110 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11110 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 1048576;
            } else {
                i10 = 524288;
            }
            i3 |= i10;
        }
        if ((599185 & i3) == 599184) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
            }
            int i11111 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11111 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1741346906, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:206)");
            }
            int i11112 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11112 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11113) {
                    AnimatedVisibilityKt.AnimatedVisibility(rowScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void AnimatedVisibility(final ColumnScope columnScope, final boolean z, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        final ExitTransition exitTransitionPlus;
        String str3;
        final Modifier modifier3;
        final EnterTransition enterTransition3;
        final String str4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1766503102);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)280@15555L32,281@15592L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 48;
        } else if ((i & 48) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 32 : 16) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = 1048576;
                            } else {
                                i10 = 524288;
                            }
                            i3 |= i10;
                        }
                        if ((599185 & i3) == 599184 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                            }
                            int i12 = i3 >> 3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i12 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z2) {
                                    return Boolean.valueOf(z2);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i12 & 458752));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = companion;
                            enterTransition3 = enterTransitionPlus;
                            str4 = str3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            enterTransition3 = enterTransition2;
                            exitTransitionPlus = exitTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i13) {
                                    AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i13 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i13 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i13 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i14 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i14 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i14 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i15 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i15 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i15 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i16 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i16 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i16 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i17 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i17 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i17 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i18 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i18 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i18 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i19 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i19 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i19 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i110 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i110 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i113 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i113 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i114 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i114 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i115 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i115 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i116 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i116 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i117 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i117 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                        }
                        int i118 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z2) {
                                return Boolean.valueOf(z2);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i118 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i119) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i119 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i119 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i1110 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1110 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i1111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i1112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1113) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i1113 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1113 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i1114 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1114 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1115) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i1115 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1115 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                    }
                    int i1116 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z2) {
                            return Boolean.valueOf(z2);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1116 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i1117 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1117 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i1118 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1118 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1119) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i1119 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i1119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1119 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
                }
                int i11110 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z2) {
                        return Boolean.valueOf(z2);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11110 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 1048576;
            } else {
                i10 = 524288;
            }
            i3 |= i10;
        }
        if ((599185 & i3) == 599184) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
            }
            int i11111 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11111 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1766503102, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:279)");
            }
            int i11112 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.updateTransition(Boolean.valueOf(z), str3, composerStartRestartGroup, (i11112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z2) {
                    return Boolean.valueOf(z2);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11112 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11113) {
                    AnimatedVisibilityKt.AnimatedVisibility(columnScope, z, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void AnimatedVisibility(final MutableTransitionState<Boolean> mutableTransitionState, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        ExitTransition exitTransitionPlus;
        String str3;
        final String str4;
        final EnterTransition enterTransition3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-222898426);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)385@20955L39,386@20999L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(mutableTransitionState) : composerStartRestartGroup.changedInstance(mutableTransitionState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.Clip;
                            } else {
                                i9 = Fields.Shape;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 196608;
                        } else if ((i & 196608) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = Fields.RenderEffect;
                            } else {
                                i10 = 65536;
                            }
                            i3 |= i10;
                        }
                        if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                            }
                            int i12 = i3 << 3;
                            int i13 = (i12 & 57344) | (i12 & 896) | 48 | (i12 & 7168) | (i3 & 458752);
                            String str5 = str3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z) {
                                    return Boolean.valueOf(z);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i13);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            exitTransition2 = exitTransitionPlus;
                            str4 = str5;
                            enterTransition3 = enterTransitionPlus;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            companion = modifier2;
                            enterTransition3 = enterTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = companion;
                            final ExitTransition exitTransition3 = exitTransition2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i14) {
                                    AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier3, enterTransition3, exitTransition3, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i14 = i3 << 3;
                        int i15 = (i14 & 57344) | (i14 & 896) | 48 | (i14 & 7168) | (i3 & 458752);
                        String str6 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i15);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str6;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i16 = i3 << 3;
                        int i17 = (i16 & 57344) | (i16 & 896) | 48 | (i16 & 7168) | (i3 & 458752);
                        String str7 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i17);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str7;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = companion;
                        final ExitTransition exitTransition4 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier4, enterTransition3, exitTransition4, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i18 = i3 << 3;
                        int i19 = (i18 & 57344) | (i18 & 896) | 48 | (i18 & 7168) | (i3 & 458752);
                        String str8 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i19);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str8;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i110 = i3 << 3;
                        int i111 = (i110 & 57344) | (i110 & 896) | 48 | (i110 & 7168) | (i3 & 458752);
                        String str9 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str9;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = companion;
                        final ExitTransition exitTransition5 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i112) {
                                AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier5, enterTransition3, exitTransition5, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i112 = i3 << 3;
                    int i113 = (i112 & 57344) | (i112 & 896) | 48 | (i112 & 7168) | (i3 & 458752);
                    String str10 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str10;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i114 = i3 << 3;
                    int i115 = (i114 & 57344) | (i114 & 896) | 48 | (i114 & 7168) | (i3 & 458752);
                    String str11 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i115);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str11;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = companion;
                    final ExitTransition exitTransition6 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier6, enterTransition3, exitTransition6, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i116 = i3 << 3;
                        int i117 = (i116 & 57344) | (i116 & 896) | 48 | (i116 & 7168) | (i3 & 458752);
                        String str12 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i117);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str12;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i118 = i3 << 3;
                        int i119 = (i118 & 57344) | (i118 & 896) | 48 | (i118 & 7168) | (i3 & 458752);
                        String str13 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i119);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str13;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = companion;
                        final ExitTransition exitTransition7 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1110) {
                                AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier7, enterTransition3, exitTransition7, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i1110 = i3 << 3;
                    int i1111 = (i1110 & 57344) | (i1110 & 896) | 48 | (i1110 & 7168) | (i3 & 458752);
                    String str14 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str14;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i1112 = i3 << 3;
                    int i1113 = (i1112 & 57344) | (i1112 & 896) | 48 | (i1112 & 7168) | (i3 & 458752);
                    String str15 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str15;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = companion;
                    final ExitTransition exitTransition8 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1114) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier8, enterTransition3, exitTransition8, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i1114 = i3 << 3;
                    int i1115 = (i1114 & 57344) | (i1114 & 896) | 48 | (i1114 & 7168) | (i3 & 458752);
                    String str16 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1115);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str16;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i1116 = i3 << 3;
                    int i1117 = (i1116 & 57344) | (i1116 & 896) | 48 | (i1116 & 7168) | (i3 & 458752);
                    String str17 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1117);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str17;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = companion;
                    final ExitTransition exitTransition9 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1118) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier9, enterTransition3, exitTransition9, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i1118 = i3 << 3;
                int i1119 = (i1118 & 57344) | (i1118 & 896) | 48 | (i1118 & 7168) | (i3 & 458752);
                String str18 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1119);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str18;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i11110 = i3 << 3;
                int i11111 = (i11110 & 57344) | (i11110 & 896) | 48 | (i11110 & 7168) | (i3 & 458752);
                String str19 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str19;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = companion;
                final ExitTransition exitTransition10 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11112) {
                        AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier10, enterTransition3, exitTransition10, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i11112 = i3 << 3;
                        int i11113 = (i11112 & 57344) | (i11112 & 896) | 48 | (i11112 & 7168) | (i3 & 458752);
                        String str110 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11113);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str110;
                        enterTransition3 = enterTransitionPlus;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                        }
                        int i11114 = i3 << 3;
                        int i11115 = (i11114 & 57344) | (i11114 & 896) | 48 | (i11114 & 7168) | (i3 & 458752);
                        String str111 = str3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11115);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        exitTransition2 = exitTransitionPlus;
                        str4 = str111;
                        enterTransition3 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = companion;
                        final ExitTransition exitTransition11 = exitTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11116) {
                                AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier11, enterTransition3, exitTransition11, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i11116 = i3 << 3;
                    int i11117 = (i11116 & 57344) | (i11116 & 896) | 48 | (i11116 & 7168) | (i3 & 458752);
                    String str112 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11117);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str112;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i11118 = i3 << 3;
                    int i11119 = (i11118 & 57344) | (i11118 & 896) | 48 | (i11118 & 7168) | (i3 & 458752);
                    String str113 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11119);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str113;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = companion;
                    final ExitTransition exitTransition12 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111110) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier12, enterTransition3, exitTransition12, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i111110 = i3 << 3;
                    int i111111 = (i111110 & 57344) | (i111110 & 896) | 48 | (i111110 & 7168) | (i3 & 458752);
                    String str114 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str114;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i111112 = i3 << 3;
                    int i111113 = (i111112 & 57344) | (i111112 & 896) | 48 | (i111112 & 7168) | (i3 & 458752);
                    String str115 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111113);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str115;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = companion;
                    final ExitTransition exitTransition13 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111114) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier13, enterTransition3, exitTransition13, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i111114 = i3 << 3;
                int i111115 = (i111114 & 57344) | (i111114 & 896) | 48 | (i111114 & 7168) | (i3 & 458752);
                String str116 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111115);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str116;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i111116 = i3 << 3;
                int i111117 = (i111116 & 57344) | (i111116 & 896) | 48 | (i111116 & 7168) | (i3 & 458752);
                String str117 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111117);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str117;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = companion;
                final ExitTransition exitTransition14 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111118) {
                        AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier14, enterTransition3, exitTransition14, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i111118 = i3 << 3;
                    int i111119 = (i111118 & 57344) | (i111118 & 896) | 48 | (i111118 & 7168) | (i3 & 458752);
                    String str118 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i111119);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str118;
                    enterTransition3 = enterTransitionPlus;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                    }
                    int i1111110 = i3 << 3;
                    int i1111111 = (i1111110 & 57344) | (i1111110 & 896) | 48 | (i1111110 & 7168) | (i3 & 458752);
                    String str119 = str3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111111);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    exitTransition2 = exitTransitionPlus;
                    str4 = str119;
                    enterTransition3 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = companion;
                    final ExitTransition exitTransition15 = exitTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111112) {
                            AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier15, enterTransition3, exitTransition15, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i1111112 = i3 << 3;
                int i1111113 = (i1111112 & 57344) | (i1111112 & 896) | 48 | (i1111112 & 7168) | (i3 & 458752);
                String str1110 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111113);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1110;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i1111114 = i3 << 3;
                int i1111115 = (i1111114 & 57344) | (i1111114 & 896) | 48 | (i1111114 & 7168) | (i3 & 458752);
                String str1111 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111115);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1111;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = companion;
                final ExitTransition exitTransition16 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111116) {
                        AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier16, enterTransition3, exitTransition16, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i1111116 = i3 << 3;
                int i1111117 = (i1111116 & 57344) | (i1111116 & 896) | 48 | (i1111116 & 7168) | (i3 & 458752);
                String str1112 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111117);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1112;
                enterTransition3 = enterTransitionPlus;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
                }
                int i1111118 = i3 << 3;
                int i1111119 = (i1111118 & 57344) | (i1111118 & 896) | 48 | (i1111118 & 7168) | (i3 & 458752);
                String str1113 = str3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i1111119);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                exitTransition2 = exitTransitionPlus;
                str4 = str1113;
                enterTransition3 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = companion;
                final ExitTransition exitTransition17 = exitTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111110) {
                        AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier17, enterTransition3, exitTransition17, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = Fields.RenderEffect;
            } else {
                i10 = 65536;
            }
            i3 |= i10;
        }
        if ((74899 & i3) == 74898) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
            }
            int i11111110 = i3 << 3;
            int i11111111 = (i11111110 & 57344) | (i11111110 & 896) | 48 | (i11111110 & 7168) | (i3 & 458752);
            String str1114 = str3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111111);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            exitTransition2 = exitTransitionPlus;
            str4 = str1114;
            enterTransition3 = enterTransitionPlus;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-222898426, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:384)");
            }
            int i11111112 = i3 << 3;
            int i11111113 = (i11111112 & 57344) | (i11111112 & 896) | 48 | (i11111112 & 7168) | (i3 & 458752);
            String str1115 = str3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i3 & 14) | ((i3 >> 9) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, i11111113);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            exitTransition2 = exitTransitionPlus;
            str4 = str1115;
            enterTransition3 = enterTransitionPlus;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier18 = companion;
            final ExitTransition exitTransition18 = exitTransition2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111114) {
                    AnimatedVisibilityKt.AnimatedVisibility(mutableTransitionState, modifier18, enterTransition3, exitTransition18, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void AnimatedVisibility(final RowScope rowScope, final MutableTransitionState<Boolean> mutableTransitionState, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        final ExitTransition exitTransitionPlus;
        String str3;
        final Modifier modifier3;
        final EnterTransition enterTransition3;
        final String str4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(836509870);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)460@25318L39,461@25362L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 48;
        } else if ((i & 48) == 0) {
            i3 = ((i & 64) == 0 ? composerStartRestartGroup.changed(mutableTransitionState) : composerStartRestartGroup.changedInstance(mutableTransitionState) ? 32 : 16) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = 1048576;
                            } else {
                                i10 = 524288;
                            }
                            i3 |= i10;
                        }
                        if ((599185 & i3) == 599184 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                            }
                            int i12 = i3 >> 3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i12 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z) {
                                    return Boolean.valueOf(z);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i12 & 458752));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = companion;
                            enterTransition3 = enterTransitionPlus;
                            str4 = str3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            enterTransition3 = enterTransition2;
                            exitTransitionPlus = exitTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i13) {
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i13 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i13 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i13 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i14 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i14 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i14 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i15 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i15 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i15 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i16 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i16 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i16 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i17 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i17 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i17 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i18 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i18 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i18 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i19 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i19 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i19 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i110 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i110 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i113 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i113 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i114 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i114 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i115 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i115 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i116 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i116 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i117 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i117 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                        }
                        int i118 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i118 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i119) {
                                AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i119 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i119 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i1110 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1110 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i1111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i1112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1113) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i1113 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1113 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i1114 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1114 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1115) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i1115 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1115 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                    }
                    int i1116 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1116 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i1117 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1117 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i1118 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1118 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1119) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i1119 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1119 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
                }
                int i11110 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11110 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111) {
                        AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 1048576;
            } else {
                i10 = 524288;
            }
            i3 |= i10;
        }
        if ((599185 & i3) == 599184) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
            }
            int i11111 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11111 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.expandHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkHorizontally$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(836509870, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:459)");
            }
            int i11112 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11112 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11113) {
                    AnimatedVisibilityKt.AnimatedVisibility(rowScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void AnimatedVisibility(final ColumnScope columnScope, final MutableTransitionState<Boolean> mutableTransitionState, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, String str, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        EnterTransition enterTransition2;
        int i5;
        int i6;
        ExitTransition exitTransition2;
        int i7;
        int i8;
        String str2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        final ExitTransition exitTransitionPlus;
        String str3;
        final Modifier modifier3;
        final EnterTransition enterTransition3;
        final String str4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-850656618);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(5,4,1,2,3)536@29773L39,537@29817L84:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 48;
        } else if ((i & 48) == 0) {
            i3 = ((i & 64) == 0 ? composerStartRestartGroup.changed(mutableTransitionState) : composerStartRestartGroup.changedInstance(mutableTransitionState) ? 32 : 16) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            str2 = str;
                            if (composerStartRestartGroup.changed(str2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = 1048576;
                            } else {
                                i10 = 524288;
                            }
                            i3 |= i10;
                        }
                        if ((599185 & i3) == 599184 || !composerStartRestartGroup.getSkipping()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i4 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i6 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (i8 != 0) {
                                str3 = "AnimatedVisibility";
                            } else {
                                str3 = str2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                            }
                            int i12 = i3 >> 3;
                            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i12 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                                public final Boolean invoke(boolean z) {
                                    return Boolean.valueOf(z);
                                }

                                public Object invoke(Object obj) {
                                    return invoke(((Boolean) obj).booleanValue());
                                }
                            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i12 & 458752));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = companion;
                            enterTransition3 = enterTransitionPlus;
                            str4 = str3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            enterTransition3 = enterTransition2;
                            exitTransitionPlus = exitTransition2;
                            str4 = str2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i13) {
                                    AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    str2 = str;
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i13 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i13 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i13 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i14 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i14 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i14 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i15 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i15 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i15 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i16 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i16 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i16 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i17) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i17 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i17 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i17 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i18 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i18 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i18 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i19 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i19 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i19 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i110 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i110 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i113) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i113 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i113 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i114 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i114 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i115) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i115 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i115 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i116 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i116 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i117) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599185 & i3) == 599184) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i117 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i117 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i6 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (i8 != 0) {
                            str3 = "AnimatedVisibility";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                        }
                        int i118 = i3 >> 3;
                        AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                            public final Boolean invoke(boolean z) {
                                return Boolean.valueOf(z);
                            }

                            public Object invoke(Object obj) {
                                return invoke(((Boolean) obj).booleanValue());
                            }
                        }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i118 & 458752));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        enterTransition3 = enterTransitionPlus;
                        str4 = str3;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i119) {
                                AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                str2 = str;
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i119 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i119 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i1110 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1110 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i1111 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1111 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i1112 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1112 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1113) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i1113 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1113 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1113 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i1114 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1114 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1114 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1115) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        enterTransition2 = enterTransition;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599185 & i3) == 599184) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i1115 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1115 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1115 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i6 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (i8 != 0) {
                        str3 = "AnimatedVisibility";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                    }
                    int i1116 = i3 >> 3;
                    AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1116 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                        public final Boolean invoke(boolean z) {
                            return Boolean.valueOf(z);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Boolean) obj).booleanValue());
                        }
                    }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1116 & 458752));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    enterTransition3 = enterTransitionPlus;
                    str4 = str3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            str2 = str;
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i1117 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1117 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1117 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i1118 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1118 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1118 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1119) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        exitTransition2 = exitTransition;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599185 & i3) == 599184) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i1119 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i1119 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i1119 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i6 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (i8 != 0) {
                    str3 = "AnimatedVisibility";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
                }
                int i11110 = i3 >> 3;
                AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11110 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                    public final Boolean invoke(boolean z) {
                        return Boolean.valueOf(z);
                    }

                    public Object invoke(Object obj) {
                        return invoke(((Boolean) obj).booleanValue());
                    }
                }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11110 & 458752));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                enterTransition3 = enterTransitionPlus;
                str4 = str3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111) {
                        AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        str2 = str;
        if ((i2 & 32) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 1048576;
            } else {
                i10 = 524288;
            }
            i3 |= i10;
        }
        if ((599185 & i3) == 599184) {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
            }
            int i11111 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11111 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11111 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        } else {
            if (i11 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.expandVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i6 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkVertically$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (i8 != 0) {
                str3 = "AnimatedVisibility";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-850656618, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:535)");
            }
            int i11112 = i3 >> 3;
            AnimatedVisibilityImpl(androidx.compose.animation.core.TransitionKt.rememberTransition(mutableTransitionState, str3, composerStartRestartGroup, MutableTransitionState.$stable | (i11112 & 14) | ((i3 >> 12) & 112), 0), new Function1<Boolean, Boolean>() {
                public final Boolean invoke(boolean z) {
                    return Boolean.valueOf(z);
                }

                public Object invoke(Object obj) {
                    return invoke(((Boolean) obj).booleanValue());
                }
            }, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, (i3 & 57344) | (i3 & 896) | 48 | (i3 & 7168) | (i11112 & 458752));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            enterTransition3 = enterTransitionPlus;
            str4 = str3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11113) {
                    AnimatedVisibilityKt.AnimatedVisibility(columnScope, mutableTransitionState, modifier3, enterTransition3, exitTransitionPlus, str4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final <T> void AnimatedVisibility(final Transition<T> transition, final Function1<? super T, Boolean> function1, Modifier modifier, EnterTransition enterTransition, ExitTransition exitTransition, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        int i6;
        EnterTransition enterTransition2;
        int i7;
        int i8;
        ExitTransition exitTransition2;
        int i9;
        int i10;
        Modifier.Companion companion;
        EnterTransition enterTransitionPlus;
        ExitTransition exitTransitionPlus;
        final Modifier modifier3;
        final ExitTransition exitTransition3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1031950689);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibility)P(4,3,1,2)609@34120L79:AnimatedVisibility.kt#xbi5r1");
        if ((i2 & Integer.MIN_VALUE) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(transition) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 1) == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
            }
            i4 = i2 & 2;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 4;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        enterTransition2 = enterTransition;
                        if (composerStartRestartGroup.changed(enterTransition2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 8;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            exitTransition2 = exitTransition;
                            if (composerStartRestartGroup.changed(exitTransition2)) {
                                i9 = Fields.Clip;
                            } else {
                                i9 = Fields.Shape;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 16) != 0) {
                            i3 |= 196608;
                        } else if ((i & 196608) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = Fields.RenderEffect;
                            } else {
                                i10 = 65536;
                            }
                            i3 |= i10;
                        }
                        if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                            } else {
                                enterTransitionPlus = enterTransition2;
                            }
                            if (i8 != 0) {
                                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                            } else {
                                exitTransitionPlus = exitTransition2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                            }
                            AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = companion;
                            exitTransition3 = exitTransitionPlus;
                            enterTransition2 = enterTransitionPlus;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            exitTransition3 = exitTransition2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final EnterTransition enterTransition3 = enterTransition2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11) {
                                    AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition3, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    exitTransition2 = exitTransition;
                    if ((i2 & 16) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final EnterTransition enterTransition4 = enterTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition4, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                enterTransition2 = enterTransition;
                i8 = i2 & 8;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 16) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final EnterTransition enterTransition5 = enterTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition5, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition6 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition6, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 8;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 16) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final EnterTransition enterTransition7 = enterTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition7, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition8 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition8, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i8 = i2 & 8;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition9 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition9, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            if ((i2 & 16) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final EnterTransition enterTransition10 = enterTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition10, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 2;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    enterTransition2 = enterTransition;
                    if (composerStartRestartGroup.changed(enterTransition2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 8;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        exitTransition2 = exitTransition;
                        if (composerStartRestartGroup.changed(exitTransition2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 16) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                        } else {
                            enterTransitionPlus = enterTransition2;
                        }
                        if (i8 != 0) {
                            exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                        } else {
                            exitTransitionPlus = exitTransition2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                        }
                        AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = companion;
                        exitTransition3 = exitTransitionPlus;
                        enterTransition2 = enterTransitionPlus;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final EnterTransition enterTransition11 = enterTransition2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition11, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                exitTransition2 = exitTransition;
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition12 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition12, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            enterTransition2 = enterTransition;
            i8 = i2 & 8;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition13 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition13, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            if ((i2 & 16) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final EnterTransition enterTransition14 = enterTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition14, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i6 = i2 & 4;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                enterTransition2 = enterTransition;
                if (composerStartRestartGroup.changed(enterTransition2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            i8 = i2 & 8;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    exitTransition2 = exitTransition;
                    if (composerStartRestartGroup.changed(exitTransition2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                    } else {
                        enterTransitionPlus = enterTransition2;
                    }
                    if (i8 != 0) {
                        exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                    } else {
                        exitTransitionPlus = exitTransition2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                    }
                    AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = companion;
                    exitTransition3 = exitTransitionPlus;
                    enterTransition2 = enterTransitionPlus;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final EnterTransition enterTransition15 = enterTransition2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition15, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            exitTransition2 = exitTransition;
            if ((i2 & 16) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final EnterTransition enterTransition16 = enterTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition16, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        enterTransition2 = enterTransition;
        i8 = i2 & 8;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                exitTransition2 = exitTransition;
                if (composerStartRestartGroup.changed(exitTransition2)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i3 |= i9;
            }
            if ((i2 & 16) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
                } else {
                    enterTransitionPlus = enterTransition2;
                }
                if (i8 != 0) {
                    exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
                } else {
                    exitTransitionPlus = exitTransition2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
                }
                AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = companion;
                exitTransition3 = exitTransitionPlus;
                enterTransition2 = enterTransitionPlus;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final EnterTransition enterTransition17 = enterTransition2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition17, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        exitTransition2 = exitTransition;
        if ((i2 & 16) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = Fields.RenderEffect;
            } else {
                i10 = 65536;
            }
            i3 |= i10;
        }
        if ((74899 & i3) == 74898) {
            if (i4 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i6 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i8 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
            }
            AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            exitTransition3 = exitTransitionPlus;
            enterTransition2 = enterTransitionPlus;
        } else {
            if (i4 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i6 != 0) {
                enterTransitionPlus = EnterExitTransitionKt.fadeIn$default(null, 0.0f, 3, null).plus(EnterExitTransitionKt.expandIn$default(null, null, false, null, 15, null));
            } else {
                enterTransitionPlus = enterTransition2;
            }
            if (i8 != 0) {
                exitTransitionPlus = EnterExitTransitionKt.shrinkOut$default(null, null, false, null, 15, null).plus(EnterExitTransitionKt.fadeOut$default(null, 0.0f, 3, null));
            } else {
                exitTransitionPlus = exitTransition2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1031950689, i3, -1, "androidx.compose.animation.AnimatedVisibility (AnimatedVisibility.kt:609)");
            }
            AnimatedVisibilityImpl(transition, function1, companion, enterTransitionPlus, exitTransitionPlus, function3, composerStartRestartGroup, 524286 & i3);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = companion;
            exitTransition3 = exitTransitionPlus;
            enterTransition2 = enterTransitionPlus;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final EnterTransition enterTransition18 = enterTransition2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) {
                    AnimatedVisibilityKt.AnimatedVisibility(transition, function1, modifier3, enterTransition18, exitTransition3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final <T> void AnimatedVisibilityImpl(final Transition<T> transition, final Function1<? super T, Boolean> function1, final Modifier modifier, final EnterTransition enterTransition, final ExitTransition exitTransition, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(429978603);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedVisibilityImpl)P(4,5,3,1,2)697@38299L415,694@38181L703:AnimatedVisibility.kt#xbi5r1");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(transition) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changed(enterTransition) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changed(exitTransition) ? Fields.Clip : Fields.Shape;
        }
        if ((i & 196608) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RenderEffect : 65536;
        }
        if ((74899 & i2) != 74898 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(429978603, i2, -1, "androidx.compose.animation.AnimatedVisibilityImpl (AnimatedVisibility.kt:693)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 689212639, "CC(remember):AnimatedVisibility.kt#9igjgp");
            int i3 = i2 & 112;
            int i4 = i2 & 14;
            boolean z = (i3 == 32) | (i4 == 4);
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        return m326invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
                    }

                    public final MeasureResult m326invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                        long jIntSize;
                        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
                        if (measureScope.isLookingAhead() && !((Boolean) function1.invoke(transition.getTargetState())).booleanValue()) {
                            jIntSize = IntSize.Companion.getZero-YbymL2g();
                        } else {
                            jIntSize = IntSizeKt.IntSize(placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight());
                        }
                        return MeasureScope.CC.layout$default(measureScope, IntSize.getWidth-impl(jIntSize), IntSize.getHeight-impl(jIntSize), null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((Placeable.PlacementScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Placeable.PlacementScope placementScope) {
                                Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, 0, 0, 0.0f, 4, null);
                            }
                        }, 4, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AnimatedEnterExitImpl(transition, function1, LayoutModifierKt.layout(modifier, (Function3) objRememberedValue), enterTransition, exitTransition, new Function2<EnterExitState, EnterExitState, Boolean>() {
                public final Boolean invoke(EnterExitState enterExitState, EnterExitState enterExitState2) {
                    return Boolean.valueOf(enterExitState == enterExitState2 && enterExitState2 == EnterExitState.PostExit);
                }
            }, null, function3, composerStartRestartGroup, i3 | 196608 | i4 | (i2 & 7168) | (57344 & i2) | ((i2 << 6) & 29360128), 64);
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

                public final void invoke(Composer composer2, int i5) {
                    AnimatedVisibilityKt.AnimatedVisibilityImpl(transition, function1, modifier, enterTransition, exitTransition, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final <T> void AnimatedEnterExitImpl(final Transition<T> transition, final Function1<? super T, Boolean> function1, final Modifier modifier, final EnterTransition enterTransition, final ExitTransition exitTransition, final Function2<? super EnterExitState, ? super EnterExitState, Boolean> function2, OnLookaheadMeasured onLookaheadMeasured, final Function3<? super AnimatedVisibilityScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        final OnLookaheadMeasured onLookaheadMeasured2;
        Composer composer2;
        Modifier.Companion companionLayout;
        OnLookaheadMeasured onLookaheadMeasured3;
        OnLookaheadMeasured onLookaheadMeasured4 = onLookaheadMeasured;
        Composer composerStartRestartGroup = composer.startRestartGroup(-891967166);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AnimatedEnterExitImpl)P(6,7,3,1,2,5,4):AnimatedVisibility.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(transition) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changed(enterTransition) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            i3 |= composerStartRestartGroup.changed(exitTransition) ? Fields.Clip : Fields.Shape;
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.RenderEffect : 65536;
        }
        int i4 = i2 & 64;
        int i5 = 1572864;
        if (i4 != 0) {
            i3 |= i5;
        } else if ((i & 1572864) == 0) {
            i5 = (i & 2097152) == 0 ? composerStartRestartGroup.changed(onLookaheadMeasured4) : composerStartRestartGroup.changedInstance(onLookaheadMeasured4) ? 1048576 : 524288;
            i3 |= i5;
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? 8388608 : 4194304;
        }
        int i6 = i3;
        if ((4793491 & i6) != 4793490 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                onLookaheadMeasured4 = null;
            }
            OnLookaheadMeasured onLookaheadMeasured5 = onLookaheadMeasured4;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-891967166, i6, -1, "androidx.compose.animation.AnimatedEnterExitImpl (AnimatedVisibility.kt:737)");
            }
            if (((Boolean) function1.invoke(transition.getTargetState())).booleanValue() || ((Boolean) function1.invoke(transition.getCurrentState())).booleanValue() || transition.isSeeking() || transition.getHasInitialValueAnimations()) {
                composerStartRestartGroup.startReplaceGroup(1787977937);
                ComposerKt.sourceInformation(composerStartRestartGroup, "741@39659L116,745@39818L40,752@40073L399,747@39898L574");
                int i7 = i6 & 14;
                int i8 = i7 | 48;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1215497572, "CC(createChildTransition)1813@74138L36,1814@74198L74,1815@74295L39,1816@74346L63:Transition.kt#pdpnli");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 272027253, "CC(remember):Transition.kt#9igjgp");
                int i9 = i8 & 14;
                boolean z = true;
                boolean z2 = ((i9 ^ 6) > 4 && composerStartRestartGroup.changed(transition)) || (i8 & 6) == 4;
                Object objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z2 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = transition.getCurrentState();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (transition.isSeeking()) {
                    objRememberedValue = transition.getCurrentState();
                }
                composerStartRestartGroup.startReplaceGroup(-466616829);
                ComposerKt.sourceInformation(composerStartRestartGroup, "C742@39737L28:AnimatedVisibility.kt#xbi5r1");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-466616829, 0, -1, "androidx.compose.animation.AnimatedEnterExitImpl.<anonymous> (AnimatedVisibility.kt:742)");
                }
                int i10 = i6 & 126;
                EnterExitState enterExitStateTargetEnterExit = targetEnterExit(transition, function1, objRememberedValue, composerStartRestartGroup, i10);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composerStartRestartGroup.endReplaceGroup();
                T targetState = transition.getTargetState();
                composerStartRestartGroup.startReplaceGroup(-466616829);
                ComposerKt.sourceInformation(composerStartRestartGroup, "C742@39737L28:AnimatedVisibility.kt#xbi5r1");
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-466616829, 0, -1, "androidx.compose.animation.AnimatedEnterExitImpl.<anonymous> (AnimatedVisibility.kt:742)");
                }
                EnterExitState enterExitStateTargetEnterExit2 = targetEnterExit(transition, function1, targetState, composerStartRestartGroup, i10);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composerStartRestartGroup.endReplaceGroup();
                Transition transitionCreateChildTransitionInternal = androidx.compose.animation.core.TransitionKt.createChildTransitionInternal(transition, enterExitStateTargetEnterExit, enterExitStateTargetEnterExit2, "EnterExitTransition", composerStartRestartGroup, i9 | 3072);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                State stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function2, composerStartRestartGroup, (i6 >> 15) & 14);
                Object objInvoke = function2.invoke(transitionCreateChildTransitionInternal.getCurrentState(), transitionCreateChildTransitionInternal.getTargetState());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1581710007, "CC(remember):AnimatedVisibility.kt#9igjgp");
                boolean zChanged = composerStartRestartGroup.changed(transitionCreateChildTransitionInternal) | composerStartRestartGroup.changed(stateRememberUpdatedState);
                C0214xd7829780 c0214xd7829780RememberedValue = composerStartRestartGroup.rememberedValue();
                if (zChanged || c0214xd7829780RememberedValue == Composer.INSTANCE.getEmpty()) {
                    c0214xd7829780RememberedValue = new C0214xd7829780(transitionCreateChildTransitionInternal, stateRememberUpdatedState, null);
                    composerStartRestartGroup.updateRememberedValue(c0214xd7829780RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                State stateProduceState = SnapshotStateKt.produceState(objInvoke, (Function2) c0214xd7829780RememberedValue, composerStartRestartGroup, 0);
                if (!getExitFinished(transitionCreateChildTransitionInternal) || !AnimatedEnterExitImpl$lambda$4(stateProduceState)) {
                    composerStartRestartGroup.startReplaceGroup(1788869559);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "768@40570L69,773@40810L47,794@41913L50,769@40652L1325");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1581725581, "CC(remember):AnimatedVisibility.kt#9igjgp");
                    boolean z3 = i7 == 4;
                    Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (z3 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new AnimatedVisibilityScopeImpl(transitionCreateChildTransitionInternal);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    AnimatedVisibilityScopeImpl animatedVisibilityScopeImpl = (AnimatedVisibilityScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i11 = i6 >> 6;
                    int i12 = (i11 & 112) | 24576 | (i11 & 896);
                    onLookaheadMeasured2 = onLookaheadMeasured5;
                    composer2 = composerStartRestartGroup;
                    Modifier modifierCreateModifier = EnterExitTransitionKt.createModifier(transitionCreateChildTransitionInternal, enterTransition, exitTransition, null, "Built-in", composer2, i12, 4);
                    if (onLookaheadMeasured2 != null) {
                        composer2.startReplaceGroup(1789227361);
                        ComposerKt.sourceInformation(composer2, "775@40967L849");
                        Modifier.Companion companion = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, 1581739065, "CC(remember):AnimatedVisibility.kt#9igjgp");
                        if ((3670016 & i6) != 1048576 && ((i6 & 2097152) == 0 || !composer2.changedInstance(onLookaheadMeasured2))) {
                            z = false;
                        }
                        Object objRememberedValue3 = composer2.rememberedValue();
                        if (z || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = (Function3) new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    return m324invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
                                }

                                public final MeasureResult m324invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                                    final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
                                    OnLookaheadMeasured onLookaheadMeasured6 = onLookaheadMeasured2;
                                    if (measureScope.isLookingAhead()) {
                                        onLookaheadMeasured6.m359invokeozmzZPI(IntSizeKt.IntSize(placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight()));
                                    }
                                    return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight(), null, new Function1<Placeable.PlacementScope, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((Placeable.PlacementScope) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Placeable.PlacementScope placementScope) {
                                            Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, 0, 0, 0.0f, 4, null);
                                        }
                                    }, 4, null);
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        companionLayout = LayoutModifierKt.layout(companion, (Function3) objRememberedValue3);
                        composer2.endReplaceGroup();
                    } else {
                        composer2.startReplaceGroup(1581766416);
                        composer2.endReplaceGroup();
                        companionLayout = Modifier.INSTANCE;
                    }
                    Modifier modifierThen = modifier.then(modifierCreateModifier.then(companionLayout));
                    ComposerKt.sourceInformationMarkerStart(composer2, 1581768538, "CC(remember):AnimatedVisibility.kt#9igjgp");
                    Object objRememberedValue4 = composer2.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = new AnimatedEnterExitMeasurePolicy(animatedVisibilityScopeImpl);
                        composer2.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    AnimatedEnterExitMeasurePolicy animatedEnterExitMeasurePolicy = (AnimatedEnterExitMeasurePolicy) objRememberedValue4;
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierThen);
                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composer2.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composer2.startReusableNode();
                    if (composer2.getInserting()) {
                        composer2.createNode(constructor);
                    } else {
                        composer2.useNode();
                    }
                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                    Updater.m4044setimpl(composerM4037constructorimpl, animatedEnterExitMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composer2, 254461613, "C770@40694L9:AnimatedVisibility.kt#xbi5r1");
                    function3.invoke(animatedVisibilityScopeImpl, composer2, Integer.valueOf((i6 >> 18) & 112));
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1790256282);
                    composerStartRestartGroup.endReplaceGroup();
                    onLookaheadMeasured2 = onLookaheadMeasured5;
                    composer2 = composerStartRestartGroup;
                }
                composer2.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(1790262234);
                composerStartRestartGroup.endReplaceGroup();
                onLookaheadMeasured2 = onLookaheadMeasured5;
                composer2 = composerStartRestartGroup;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            onLookaheadMeasured3 = onLookaheadMeasured2;
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            onLookaheadMeasured3 = onLookaheadMeasured4;
            composer2 = composerStartRestartGroup;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final OnLookaheadMeasured onLookaheadMeasured6 = onLookaheadMeasured3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i13) {
                    AnimatedVisibilityKt.AnimatedEnterExitImpl(transition, function1, modifier, enterTransition, exitTransition, function2, onLookaheadMeasured6, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final boolean getExitFinished(Transition<EnterExitState> transition) {
        return transition.getCurrentState() == EnterExitState.PostExit && transition.getTargetState() == EnterExitState.PostExit;
    }

    private static final <T> EnterExitState targetEnterExit(Transition<T> transition, Function1<? super T, Boolean> function1, T t, Composer composer, int i) {
        EnterExitState enterExitState;
        ComposerKt.sourceInformationMarkerStart(composer, 361571134, "C(targetEnterExit)P(1):AnimatedVisibility.kt#xbi5r1");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(361571134, i, -1, "androidx.compose.animation.targetEnterExit (AnimatedVisibility.kt:855)");
        }
        composer.startMovableGroup(-902048200, transition);
        ComposerKt.sourceInformation(composer, "");
        if (transition.isSeeking()) {
            composer.startReplaceGroup(2101296683);
            composer.endReplaceGroup();
            if (((Boolean) function1.invoke(t)).booleanValue()) {
                enterExitState = EnterExitState.Visible;
            } else if (((Boolean) function1.invoke(transition.getCurrentState())).booleanValue()) {
                enterExitState = EnterExitState.PostExit;
            } else {
                enterExitState = EnterExitState.PreEnter;
            }
        } else {
            composer.startReplaceGroup(2101530516);
            ComposerKt.sourceInformation(composer, "868@44365L34");
            ComposerKt.sourceInformationMarkerStart(composer, -902039492, "CC(remember):AnimatedVisibility.kt#9igjgp");
            Object objRememberedValue = composer.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
                composer.updateRememberedValue(objRememberedValue);
            }
            MutableState mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composer);
            if (((Boolean) function1.invoke(transition.getCurrentState())).booleanValue()) {
                mutableState.setValue(true);
            }
            if (((Boolean) function1.invoke(t)).booleanValue()) {
                enterExitState = EnterExitState.Visible;
            } else if (((Boolean) mutableState.getValue()).booleanValue()) {
                enterExitState = EnterExitState.PostExit;
            } else {
                enterExitState = EnterExitState.PreEnter;
            }
            composer.endReplaceGroup();
        }
        composer.endMovableGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return enterExitState;
    }

    public static final Function2<EnterExitState, EnterExitState, Boolean> AnimatedEnterExitImpl$lambda$2(State<? extends Function2<? super EnterExitState, ? super EnterExitState, Boolean>> state) {
        return state.getValue();
    }

    private static final boolean AnimatedEnterExitImpl$lambda$4(State<Boolean> state) {
        return state.getValue().booleanValue();
    }
}
