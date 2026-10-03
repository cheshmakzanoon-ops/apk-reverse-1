package androidx.compose.animation;

import androidx.autofill.HintConstants;
import androidx.collection.MutableScatterMap;
import androidx.collection.ScatterMapKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.Transition;
import androidx.compose.animation.core.TweenSpec;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import java.util.Iterator;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000@\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\u001aN\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u0002H\u00022\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0017\u0010\t\u001a\u0013\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u00020\u00010\n¢\u0006\u0002\b\u000bH\u0007¢\u0006\u0002\u0010\f\u001aX\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u0002H\u00022\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\b\b\u0002\u0010\r\u001a\u00020\u000e2\u0017\u0010\t\u001a\u0013\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u00020\u00010\n¢\u0006\u0002\b\u000bH\u0007¢\u0006\u0002\u0010\u000f\u001a\u0086\u0001\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00102\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072%\b\u0002\u0010\u0011\u001a\u001f\u0012\u0013\u0012\u0011H\u0002¢\u0006\f\b\u0012\u0012\b\b\u0013\u0012\u0004\b\b(\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00140\n2&\u0010\t\u001a\"\u0012\u0013\u0012\u0011H\u0002¢\u0006\f\b\u0012\u0012\b\b\u0013\u0012\u0004\b\b(\u0003\u0012\u0004\u0012\u00020\u00010\n¢\u0006\u0002\b\u000bH\u0007¢\u0006\u0002\u0010\u0015¨\u0006\u0016²\u0006\u0010\u0010\u0017\u001a\u00020\b\"\u0004\b\u0000\u0010\u0002X\u008a\u0084\u0002"}, d2 = {"Crossfade", "", "T", "targetState", "modifier", "Landroidx/compose/ui/Modifier;", "animationSpec", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "", "content", "Lkotlin/Function1;", "Landroidx/compose/runtime/Composable;", "(Ljava/lang/Object;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/core/FiniteAnimationSpec;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "label", "", "(Ljava/lang/Object;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/core/FiniteAnimationSpec;Ljava/lang/String;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "Landroidx/compose/animation/core/Transition;", "contentKey", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "", "(Landroidx/compose/animation/core/Transition;Landroidx/compose/ui/Modifier;Landroidx/compose/animation/core/FiniteAnimationSpec;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "animation_release", "alpha"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CrossfadeKt {
    public static final <T> void Crossfade(final T t, Modifier modifier, FiniteAnimationSpec<Float> finiteAnimationSpec, String str, final Function3<? super T, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        FiniteAnimationSpec<Float> finiteAnimationSpec2;
        int i5;
        int i6;
        String str2;
        int i7;
        int i8;
        Modifier.Companion companion;
        FiniteAnimationSpec<Float> finiteAnimationSpecTween$default;
        String str3;
        final FiniteAnimationSpec<Float> finiteAnimationSpec3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-310686752);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Crossfade)P(4,3!1,2)56@2327L36,57@2379L53:Crossfade.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(t) : composerStartRestartGroup.changedInstance(t) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i9 = i2 & 2;
        if (i9 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    finiteAnimationSpec2 = finiteAnimationSpec;
                    if (composerStartRestartGroup.changedInstance(finiteAnimationSpec2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        str2 = str;
                        if (composerStartRestartGroup.changed(str2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 16) != 0) {
                        i3 |= 24576;
                    } else if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = Fields.Clip;
                        } else {
                            i8 = Fields.Shape;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                        } else {
                            finiteAnimationSpecTween$default = finiteAnimationSpec2;
                        }
                        if (i6 != 0) {
                            str3 = "Crossfade";
                        } else {
                            str3 = str2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                        }
                        int i10 = i3 & 58352;
                        String str4 = str3;
                        Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i10, 4);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        str2 = str4;
                        finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        companion = modifier2;
                        finiteAnimationSpec3 = finiteAnimationSpec2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = companion;
                        final String str5 = str2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                CrossfadeKt.Crossfade(t, modifier3, finiteAnimationSpec3, str5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                str2 = str;
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i11 = i3 & 58352;
                    String str6 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i11, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str6;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i12 = i3 & 58352;
                    String str7 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i12, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str7;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = companion;
                    final String str8 = str2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            CrossfadeKt.Crossfade(t, modifier4, finiteAnimationSpec3, str8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            finiteAnimationSpec2 = finiteAnimationSpec;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i13 = i3 & 58352;
                    String str9 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i13, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str9;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i14 = i3 & 58352;
                    String str10 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i14, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str10;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = companion;
                    final String str11 = str2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            CrossfadeKt.Crossfade(t, modifier5, finiteAnimationSpec3, str11, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            str2 = str;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i15 = i3 & 58352;
                String str12 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i15, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str12;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i16 = i3 & 58352;
                String str13 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i16, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str13;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = companion;
                final String str14 = str2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i17) {
                        CrossfadeKt.Crossfade(t, modifier6, finiteAnimationSpec3, str14, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                finiteAnimationSpec2 = finiteAnimationSpec;
                if (composerStartRestartGroup.changedInstance(finiteAnimationSpec2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    str2 = str;
                    if (composerStartRestartGroup.changed(str2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i17 = i3 & 58352;
                    String str15 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i17, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str15;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        finiteAnimationSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        str3 = "Crossfade";
                    } else {
                        str3 = str2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                    }
                    int i18 = i3 & 58352;
                    String str16 = str3;
                    Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i18, 4);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    str2 = str16;
                    finiteAnimationSpec3 = finiteAnimationSpecTween$default;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = companion;
                    final String str17 = str2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i19) {
                            CrossfadeKt.Crossfade(t, modifier7, finiteAnimationSpec3, str17, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            str2 = str;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i19 = i3 & 58352;
                String str18 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i19, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str18;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i110 = i3 & 58352;
                String str19 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i110, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str19;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = companion;
                final String str110 = str2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        CrossfadeKt.Crossfade(t, modifier8, finiteAnimationSpec3, str110, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        finiteAnimationSpec2 = finiteAnimationSpec;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                str2 = str;
                if (composerStartRestartGroup.changed(str2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i111 = i3 & 58352;
                String str111 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i111, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str111;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    finiteAnimationSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    str3 = "Crossfade";
                } else {
                    str3 = str2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
                }
                int i112 = i3 & 58352;
                String str112 = str3;
                Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i112, 4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                str2 = str112;
                finiteAnimationSpec3 = finiteAnimationSpecTween$default;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = companion;
                final String str113 = str2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        CrossfadeKt.Crossfade(t, modifier9, finiteAnimationSpec3, str113, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        str2 = str;
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i8 = Fields.Clip;
            } else {
                i8 = Fields.Shape;
            }
            i3 |= i8;
        }
        if ((i3 & 9363) == 9362) {
            if (i9 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
            } else {
                finiteAnimationSpecTween$default = finiteAnimationSpec2;
            }
            if (i6 != 0) {
                str3 = "Crossfade";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
            }
            int i113 = i3 & 58352;
            String str114 = str3;
            Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i113, 4);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            str2 = str114;
            finiteAnimationSpec3 = finiteAnimationSpecTween$default;
        } else {
            if (i9 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (i4 != 0) {
                finiteAnimationSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
            } else {
                finiteAnimationSpecTween$default = finiteAnimationSpec2;
            }
            if (i6 != 0) {
                str3 = "Crossfade";
            } else {
                str3 = str2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-310686752, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:55)");
            }
            int i114 = i3 & 58352;
            String str115 = str3;
            Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(t, str3, composerStartRestartGroup, (i3 & 14) | ((i3 >> 6) & 112), 0), companion, finiteAnimationSpecTween$default, (Function1) null, function3, composerStartRestartGroup, i114, 4);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            str2 = str115;
            finiteAnimationSpec3 = finiteAnimationSpecTween$default;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = companion;
            final String str116 = str2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i115) {
                    CrossfadeKt.Crossfade(t, modifier10, finiteAnimationSpec3, str116, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Crossfade API now has a new label parameter added.")
    public static final void Crossfade(final Object obj, Modifier modifier, FiniteAnimationSpec finiteAnimationSpec, final Function3 function3, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(523603005);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Crossfade)P(3,2)72@2790L29,73@2835L53:Crossfade.kt#xbi5r1");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = ((i & 8) == 0 ? composerStartRestartGroup.changed(obj) : composerStartRestartGroup.changedInstance(obj) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i4 = i2 & 2;
        if (i4 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
        }
        int i5 = i2 & 4;
        if (i5 != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(finiteAnimationSpec) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 1171) != 1170 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (i5 != 0) {
                finiteAnimationSpec = AnimationSpecKt.tween$default(0, 0, null, 7, null);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(523603005, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:71)");
            }
            Crossfade(androidx.compose.animation.core.TransitionKt.updateTransition(obj, (String) null, composerStartRestartGroup, i3 & 14, 2), modifier, (FiniteAnimationSpec<Float>) finiteAnimationSpec, (Function1) null, function3, composerStartRestartGroup, (i3 & 1008) | ((i3 << 3) & 57344), 4);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final Modifier modifier2 = modifier;
        final FiniteAnimationSpec finiteAnimationSpec2 = finiteAnimationSpec;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i6) {
                    CrossfadeKt.Crossfade(obj, modifier2, finiteAnimationSpec2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final <T> void Crossfade(final Transition<T> transition, Modifier modifier, FiniteAnimationSpec<Float> finiteAnimationSpec, Function1<? super T, ? extends Object> function1, final Function3<? super T, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        FiniteAnimationSpec<Float> finiteAnimationSpec2;
        int i5;
        int i6;
        Function1<? super T, ? extends Object> function2;
        int i7;
        int i8;
        TweenSpec tweenSpecTween$default;
        C02403 c02403;
        Object objRememberedValue;
        Object obj;
        SnapshotStateList snapshotStateList;
        Object objRememberedValue2;
        MutableScatterMap mutableScatterMap;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        SnapshotStateList snapshotStateList2;
        int size;
        int i9;
        final FiniteAnimationSpec<Float> finiteAnimationSpec3;
        final Function1<? super T, ? extends Object> function4;
        Function2 function5;
        SnapshotStateList snapshotStateList3;
        Iterator<T> it;
        int i10;
        int i11;
        int size2;
        int i12;
        boolean z;
        Object objRememberedValue3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        final Transition<T> transition2 = transition;
        Composer composerStartRestartGroup = composer.startRestartGroup(679005231);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Crossfade)P(3!1,2)104@4422L64,105@4508L61,137@5785L159:Crossfade.kt#xbi5r1");
        if ((i2 & Integer.MIN_VALUE) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(transition2) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 1;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 2;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    finiteAnimationSpec2 = finiteAnimationSpec;
                    if (composerStartRestartGroup.changedInstance(finiteAnimationSpec2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 4;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        function2 = function1;
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 8) != 0) {
                        i3 |= 24576;
                    } else if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = Fields.Clip;
                        } else {
                            i8 = Fields.Shape;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                        } else {
                            tweenSpecTween$default = finiteAnimationSpec2;
                        }
                        if (i6 != 0) {
                            c02403 = new Function1<T, T>() {
                                public final T invoke(T t) {
                                    return t;
                                }
                            };
                        } else {
                            c02403 = function2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        obj = objRememberedValue;
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            SnapshotStateList snapshotStateListMutableStateListOf = SnapshotStateKt.mutableStateListOf();
                            snapshotStateListMutableStateListOf.add(transition.getCurrentState());
                            composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf);
                            obj = snapshotStateListMutableStateListOf;
                        }
                        snapshotStateList = (SnapshotStateList) obj;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                            composerStartRestartGroup.startReplaceGroup(860660313);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "");
                            if (snapshotStateList.size() == 1 || !Intrinsics.areEqual(snapshotStateList.get(0), transition.getTargetState())) {
                                composerStartRestartGroup.startReplaceGroup(860794667);
                                ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                                SnapshotStateList snapshotStateList4 = snapshotStateList;
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                                if ((i3 & 14) == 4) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                                if (!z || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                        {
                                            super(1);
                                        }

                                        public final Boolean m331invoke(T t) {
                                            return Boolean.valueOf(!Intrinsics.areEqual(t, transition2.getTargetState()));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                CollectionsKt.removeAll(snapshotStateList4, (Function1) objRememberedValue3);
                                mutableScatterMap.clear();
                                composerStartRestartGroup.endReplaceGroup();
                            } else {
                                composerStartRestartGroup.startReplaceGroup(860984945);
                                composerStartRestartGroup.endReplaceGroup();
                            }
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860990897);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (!mutableScatterMap.contains(transition.getTargetState())) {
                            composerStartRestartGroup.startReplaceGroup(861052122);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                            snapshotStateList3 = snapshotStateList;
                            it = snapshotStateList3.iterator();
                            i10 = 0;
                            while (true) {
                                if (!it.hasNext()) {
                                    i11 = -1;
                                    i10 = -1;
                                    break;
                                } else {
                                    if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                        i11 = -1;
                                        break;
                                    }
                                    i10++;
                                }
                            }
                            if (i10 == i11) {
                                snapshotStateList.add(transition.getTargetState());
                            } else {
                                snapshotStateList.set(i10, transition.getTargetState());
                            }
                            mutableScatterMap.clear();
                            size2 = snapshotStateList3.size();
                            i12 = 0;
                            while (i12 < size2) {
                                T t = snapshotStateList3.get(i12);
                                mutableScatterMap.set(t, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t, function3), composerStartRestartGroup, 54));
                                i12++;
                                transition2 = transition;
                                snapshotStateList3 = snapshotStateList3;
                            }
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(861812273);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                        composerStartRestartGroup.startReplaceGroup(-187482432);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        snapshotStateList2 = snapshotStateList;
                        size = snapshotStateList2.size();
                        for (i9 = 0; i9 < size; i9++) {
                            T t2 = snapshotStateList2.get(i9);
                            composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t2));
                            ComposerKt.sourceInformation(composerStartRestartGroup, "");
                            function5 = (Function2) mutableScatterMap.get(t2);
                            if (function5 == null) {
                                composerStartRestartGroup.startReplaceGroup(821713034);
                                composerStartRestartGroup.endReplaceGroup();
                            } else {
                                composerStartRestartGroup.startReplaceGroup(-1081871785);
                                ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                                function5.invoke(composerStartRestartGroup, 0);
                                composerStartRestartGroup.endReplaceGroup();
                            }
                            composerStartRestartGroup.endMovableGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        finiteAnimationSpec3 = tweenSpecTween$default;
                        function4 = c02403;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        finiteAnimationSpec3 = finiteAnimationSpec2;
                        function4 = function2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                CrossfadeKt.Crossfade(transition, modifier3, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                function2 = function1;
                if ((i2 & 8) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t3) {
                                return t3;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf2 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf2.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf2);
                        obj = snapshotStateListMutableStateListOf2;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList5 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t3) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t3, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t3) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t3, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList5, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList6 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t3) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t3, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t3) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t3, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList6, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t3 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t3, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t3, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t4 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t4));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t4);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t5) {
                                return t5;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf3 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf3.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf3);
                        obj = snapshotStateListMutableStateListOf3;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList7 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t5) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t5, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t5) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t5, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList7, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList8 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t5) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t5, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t5) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t5, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList8, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t5 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t5, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t5, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t6 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t6));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t6);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            CrossfadeKt.Crossfade(transition, modifier4, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            finiteAnimationSpec2 = finiteAnimationSpec;
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function2 = function1;
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 8) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t7) {
                                return t7;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf4 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf4.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf4);
                        obj = snapshotStateListMutableStateListOf4;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList9 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t7) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t7, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t7) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t7, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList9, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList10 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t7) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t7, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t7) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t7, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList10, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t7 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t7, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t7, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance4 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t8 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t8));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t8);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t9) {
                                return t9;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf5 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf5.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf5);
                        obj = snapshotStateListMutableStateListOf5;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList11 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t9) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t9, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t9) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t9, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList11, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList12 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t9) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t9, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t9) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t9, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList12, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t9 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t9, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t9, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap5, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier5, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance5 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t10 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t10));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t10);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            CrossfadeKt.Crossfade(transition, modifier5, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function2 = function1;
            if ((i2 & 8) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t11) {
                            return t11;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf6 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf6.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf6);
                    obj = snapshotStateListMutableStateListOf6;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList13 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t11) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t11, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t11) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t11, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList13, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList14 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t11) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t11, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t11) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t11, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList14, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t11 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t11, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t11, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap6, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier6, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance6 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t12 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t12));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t12);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t13) {
                            return t13;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf7 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf7.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf7);
                    obj = snapshotStateListMutableStateListOf7;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList15 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t13) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t13, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t13) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t13, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList15, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList16 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t13) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t13, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t13) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t13, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList16, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t13 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t13, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t13, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap7, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier7, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance7 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t14 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t14));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t14);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        CrossfadeKt.Crossfade(transition, modifier6, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 2;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                finiteAnimationSpec2 = finiteAnimationSpec;
                if (composerStartRestartGroup.changedInstance(finiteAnimationSpec2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 4;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function2 = function1;
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 8) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t15) {
                                return t15;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf8 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf8.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf8);
                        obj = snapshotStateListMutableStateListOf8;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList17 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t15) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t15, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t15) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t15, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList17, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList18 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t15) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t15, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t15) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t15, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList18, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t15 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t15, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t15, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap8, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier8, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance8 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t16 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t16));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t16);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                    } else {
                        tweenSpecTween$default = finiteAnimationSpec2;
                    }
                    if (i6 != 0) {
                        c02403 = new Function1<T, T>() {
                            public final T invoke(T t17) {
                                return t17;
                            }
                        };
                    } else {
                        c02403 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    obj = objRememberedValue;
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        SnapshotStateList snapshotStateListMutableStateListOf9 = SnapshotStateKt.mutableStateListOf();
                        snapshotStateListMutableStateListOf9.add(transition.getCurrentState());
                        composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf9);
                        obj = snapshotStateListMutableStateListOf9;
                    }
                    snapshotStateList = (SnapshotStateList) obj;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(860660313);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        if (snapshotStateList.size() == 1) {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList19 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t17) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t17, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t17) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t17, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList19, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(860794667);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                            SnapshotStateList snapshotStateList110 = snapshotStateList;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                            if ((i3 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t17) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t17, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            } else {
                                objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                    {
                                        super(1);
                                    }

                                    public final Boolean m331invoke(T t17) {
                                        return Boolean.valueOf(!Intrinsics.areEqual(t17, transition2.getTargetState()));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CollectionsKt.removeAll(snapshotStateList110, (Function1) objRememberedValue3);
                            mutableScatterMap.clear();
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860990897);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (!mutableScatterMap.contains(transition.getTargetState())) {
                        composerStartRestartGroup.startReplaceGroup(861052122);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                        snapshotStateList3 = snapshotStateList;
                        it = snapshotStateList3.iterator();
                        i10 = 0;
                        while (true) {
                            if (!it.hasNext()) {
                                i11 = -1;
                                i10 = -1;
                                break;
                            } else {
                                if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                    i11 = -1;
                                    break;
                                }
                                i10++;
                            }
                        }
                        if (i10 == i11) {
                            snapshotStateList.add(transition.getTargetState());
                        } else {
                            snapshotStateList.set(i10, transition.getTargetState());
                        }
                        mutableScatterMap.clear();
                        size2 = snapshotStateList3.size();
                        i12 = 0;
                        while (i12 < size2) {
                            T t17 = snapshotStateList3.get(i12);
                            mutableScatterMap.set(t17, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t17, function3), composerStartRestartGroup, 54));
                            i12++;
                            transition2 = transition;
                            snapshotStateList3 = snapshotStateList3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(861812273);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap9, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier9, ComposeUiNode.INSTANCE.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance9 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                    composerStartRestartGroup.startReplaceGroup(-187482432);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    snapshotStateList2 = snapshotStateList;
                    size = snapshotStateList2.size();
                    while (i9 < size) {
                        T t18 = snapshotStateList2.get(i9);
                        composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t18));
                        ComposerKt.sourceInformation(composerStartRestartGroup, "");
                        function5 = (Function2) mutableScatterMap.get(t18);
                        if (function5 == null) {
                            composerStartRestartGroup.startReplaceGroup(821713034);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(-1081871785);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                            function5.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        composerStartRestartGroup.endMovableGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    finiteAnimationSpec3 = tweenSpecTween$default;
                    function4 = c02403;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            CrossfadeKt.Crossfade(transition, modifier7, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function2 = function1;
            if ((i2 & 8) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t19) {
                            return t19;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf10 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf10.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf10);
                    obj = snapshotStateListMutableStateListOf10;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList111 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t19) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t19, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t19) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t19, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList111, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList112 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t19) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t19, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t19) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t19, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList112, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t19 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t19, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t19, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap10, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier10, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance10 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t110 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t110));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t110);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t111) {
                            return t111;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf11 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf11.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf11);
                    obj = snapshotStateListMutableStateListOf11;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList113 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t111) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t111, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t111) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t111, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList113, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList114 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t111) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t111, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t111) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t111, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList114, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t111 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t111, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t111, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap11, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier11, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance11 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t112 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t112));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t112);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        CrossfadeKt.Crossfade(transition, modifier8, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        finiteAnimationSpec2 = finiteAnimationSpec;
        i6 = i2 & 4;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                function2 = function1;
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            if ((i2 & 8) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t113) {
                            return t113;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf12 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf12.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf12);
                    obj = snapshotStateListMutableStateListOf12;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList115 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t113) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t113, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t113) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t113, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList115, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList116 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t113) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t113, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t113) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t113, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList116, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t113 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t113, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t113, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap12, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier12, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance12 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t114 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t114));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t114);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
                } else {
                    tweenSpecTween$default = finiteAnimationSpec2;
                }
                if (i6 != 0) {
                    c02403 = new Function1<T, T>() {
                        public final T invoke(T t115) {
                            return t115;
                        }
                    };
                } else {
                    c02403 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                obj = objRememberedValue;
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    SnapshotStateList snapshotStateListMutableStateListOf13 = SnapshotStateKt.mutableStateListOf();
                    snapshotStateListMutableStateListOf13.add(transition.getCurrentState());
                    composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf13);
                    obj = snapshotStateListMutableStateListOf13;
                }
                snapshotStateList = (SnapshotStateList) obj;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableScatterMap = (MutableScatterMap) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(860660313);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    if (snapshotStateList.size() == 1) {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList117 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t115) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t115, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t115) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t115, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList117, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(860794667);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                        SnapshotStateList snapshotStateList118 = snapshotStateList;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                        if ((i3 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t115) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t115, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean m331invoke(T t115) {
                                    return Boolean.valueOf(!Intrinsics.areEqual(t115, transition2.getTargetState()));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CollectionsKt.removeAll(snapshotStateList118, (Function1) objRememberedValue3);
                        mutableScatterMap.clear();
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860990897);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (!mutableScatterMap.contains(transition.getTargetState())) {
                    composerStartRestartGroup.startReplaceGroup(861052122);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                    snapshotStateList3 = snapshotStateList;
                    it = snapshotStateList3.iterator();
                    i10 = 0;
                    while (true) {
                        if (!it.hasNext()) {
                            i11 = -1;
                            i10 = -1;
                            break;
                        } else {
                            if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                                i11 = -1;
                                break;
                            }
                            i10++;
                        }
                    }
                    if (i10 == i11) {
                        snapshotStateList.add(transition.getTargetState());
                    } else {
                        snapshotStateList.set(i10, transition.getTargetState());
                    }
                    mutableScatterMap.clear();
                    size2 = snapshotStateList3.size();
                    i12 = 0;
                    while (i12 < size2) {
                        T t115 = snapshotStateList3.get(i12);
                        mutableScatterMap.set(t115, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t115, function3), composerStartRestartGroup, 54));
                        i12++;
                        transition2 = transition;
                        snapshotStateList3 = snapshotStateList3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(861812273);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap13, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier13, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance13 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
                composerStartRestartGroup.startReplaceGroup(-187482432);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                snapshotStateList2 = snapshotStateList;
                size = snapshotStateList2.size();
                while (i9 < size) {
                    T t116 = snapshotStateList2.get(i9);
                    composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t116));
                    ComposerKt.sourceInformation(composerStartRestartGroup, "");
                    function5 = (Function2) mutableScatterMap.get(t116);
                    if (function5 == null) {
                        composerStartRestartGroup.startReplaceGroup(821713034);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-1081871785);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                        function5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                finiteAnimationSpec3 = tweenSpecTween$default;
                function4 = c02403;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        CrossfadeKt.Crossfade(transition, modifier9, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function2 = function1;
        if ((i2 & 8) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i8 = Fields.Clip;
            } else {
                i8 = Fields.Shape;
            }
            i3 |= i8;
        }
        if ((i3 & 9363) == 9362) {
            if (i13 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i4 != 0) {
                tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
            } else {
                tweenSpecTween$default = finiteAnimationSpec2;
            }
            if (i6 != 0) {
                c02403 = new Function1<T, T>() {
                    public final T invoke(T t117) {
                        return t117;
                    }
                };
            } else {
                c02403 = function2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            obj = objRememberedValue;
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                SnapshotStateList snapshotStateListMutableStateListOf14 = SnapshotStateKt.mutableStateListOf();
                snapshotStateListMutableStateListOf14.add(transition.getCurrentState());
                composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf14);
                obj = snapshotStateListMutableStateListOf14;
            }
            snapshotStateList = (SnapshotStateList) obj;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            mutableScatterMap = (MutableScatterMap) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                composerStartRestartGroup.startReplaceGroup(860660313);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                if (snapshotStateList.size() == 1) {
                    composerStartRestartGroup.startReplaceGroup(860794667);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                    SnapshotStateList snapshotStateList119 = snapshotStateList;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t117) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t117, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t117) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t117, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CollectionsKt.removeAll(snapshotStateList119, (Function1) objRememberedValue3);
                    mutableScatterMap.clear();
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860794667);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                    SnapshotStateList snapshotStateList1110 = snapshotStateList;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t117) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t117, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t117) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t117, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CollectionsKt.removeAll(snapshotStateList1110, (Function1) objRememberedValue3);
                    mutableScatterMap.clear();
                    composerStartRestartGroup.endReplaceGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(860990897);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (!mutableScatterMap.contains(transition.getTargetState())) {
                composerStartRestartGroup.startReplaceGroup(861052122);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                snapshotStateList3 = snapshotStateList;
                it = snapshotStateList3.iterator();
                i10 = 0;
                while (true) {
                    if (!it.hasNext()) {
                        i11 = -1;
                        i10 = -1;
                        break;
                    } else {
                        if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                            i11 = -1;
                            break;
                        }
                        i10++;
                    }
                }
                if (i10 == i11) {
                    snapshotStateList.add(transition.getTargetState());
                } else {
                    snapshotStateList.set(i10, transition.getTargetState());
                }
                mutableScatterMap.clear();
                size2 = snapshotStateList3.size();
                i12 = 0;
                while (i12 < size2) {
                    T t117 = snapshotStateList3.get(i12);
                    mutableScatterMap.set(t117, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t117, function3), composerStartRestartGroup, 54));
                    i12++;
                    transition2 = transition;
                    snapshotStateList3 = snapshotStateList3;
                }
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(861812273);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap14, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier14, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance14 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
            composerStartRestartGroup.startReplaceGroup(-187482432);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            snapshotStateList2 = snapshotStateList;
            size = snapshotStateList2.size();
            while (i9 < size) {
                T t118 = snapshotStateList2.get(i9);
                composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t118));
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                function5 = (Function2) mutableScatterMap.get(t118);
                if (function5 == null) {
                    composerStartRestartGroup.startReplaceGroup(821713034);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-1081871785);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                    function5.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                }
                composerStartRestartGroup.endMovableGroup();
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            finiteAnimationSpec3 = tweenSpecTween$default;
            function4 = c02403;
        } else {
            if (i13 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i4 != 0) {
                tweenSpecTween$default = AnimationSpecKt.tween$default(0, 0, null, 7, null);
            } else {
                tweenSpecTween$default = finiteAnimationSpec2;
            }
            if (i6 != 0) {
                c02403 = new Function1<T, T>() {
                    public final T invoke(T t119) {
                        return t119;
                    }
                };
            } else {
                c02403 = function2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(679005231, i3, -1, "androidx.compose.animation.Crossfade (Crossfade.kt:103)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274683025, "CC(remember):Crossfade.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            obj = objRememberedValue;
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                SnapshotStateList snapshotStateListMutableStateListOf15 = SnapshotStateKt.mutableStateListOf();
                snapshotStateListMutableStateListOf15.add(transition.getCurrentState());
                composerStartRestartGroup.updateRememberedValue(snapshotStateListMutableStateListOf15);
                obj = snapshotStateListMutableStateListOf15;
            }
            snapshotStateList = (SnapshotStateList) obj;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274685774, "CC(remember):Crossfade.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = ScatterMapKt.mutableScatterMapOf();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            mutableScatterMap = (MutableScatterMap) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (Intrinsics.areEqual(transition.getCurrentState(), transition.getTargetState())) {
                composerStartRestartGroup.startReplaceGroup(860660313);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                if (snapshotStateList.size() == 1) {
                    composerStartRestartGroup.startReplaceGroup(860794667);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                    SnapshotStateList snapshotStateList1111 = snapshotStateList;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t119) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t119, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t119) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t119, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CollectionsKt.removeAll(snapshotStateList1111, (Function1) objRememberedValue3);
                    mutableScatterMap.clear();
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(860794667);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "110@4883L21");
                    SnapshotStateList snapshotStateList1112 = snapshotStateList;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1274697734, "CC(remember):Crossfade.kt#9igjgp");
                    if ((i3 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t119) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t119, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<T, Boolean>() {
                            {
                                super(1);
                            }

                            public final Boolean m331invoke(T t119) {
                                return Boolean.valueOf(!Intrinsics.areEqual(t119, transition2.getTargetState()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CollectionsKt.removeAll(snapshotStateList1112, (Function1) objRememberedValue3);
                    mutableScatterMap.clear();
                    composerStartRestartGroup.endReplaceGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(860990897);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (!mutableScatterMap.contains(transition.getTargetState())) {
                composerStartRestartGroup.startReplaceGroup(861052122);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*126@5458L305");
                snapshotStateList3 = snapshotStateList;
                it = snapshotStateList3.iterator();
                i10 = 0;
                while (true) {
                    if (!it.hasNext()) {
                        i11 = -1;
                        i10 = -1;
                        break;
                    } else {
                        if (Intrinsics.areEqual(c02403.invoke(it.next()), c02403.invoke(transition.getTargetState()))) {
                            i11 = -1;
                            break;
                        }
                        i10++;
                    }
                }
                if (i10 == i11) {
                    snapshotStateList.add(transition.getTargetState());
                } else {
                    snapshotStateList.set(i10, transition.getTargetState());
                }
                mutableScatterMap.clear();
                size2 = snapshotStateList3.size();
                i12 = 0;
                while (i12 < size2) {
                    T t119 = snapshotStateList3.get(i12);
                    mutableScatterMap.set(t119, ComposableLambdaKt.rememberComposableLambda(-1426421288, true, new CrossfadeKt$Crossfade$5$1(transition2, tweenSpecTween$default, t119, function3), composerStartRestartGroup, 54));
                    i12++;
                    transition2 = transition;
                    snapshotStateList3 = snapshotStateList3;
                }
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(861812273);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier2);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap15, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier15, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance15 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1517004430, "C:Crossfade.kt#xbi5r1");
            composerStartRestartGroup.startReplaceGroup(-187482432);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            snapshotStateList2 = snapshotStateList;
            size = snapshotStateList2.size();
            while (i9 < size) {
                T t1110 = snapshotStateList2.get(i9);
                composerStartRestartGroup.startMovableGroup(-1081873445, c02403.invoke(t1110));
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                function5 = (Function2) mutableScatterMap.get(t1110);
                if (function5 == null) {
                    composerStartRestartGroup.startReplaceGroup(821713034);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-1081871785);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "140@5906L8");
                    function5.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                }
                composerStartRestartGroup.endMovableGroup();
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            finiteAnimationSpec3 = tweenSpecTween$default;
            function4 = c02403;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = modifier2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    CrossfadeKt.Crossfade(transition, modifier10, finiteAnimationSpec3, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
