package androidx.compose.material3.carousel;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.gestures.TargetedFlingBehavior;
import androidx.compose.foundation.gestures.snapping.SnapPosition;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.pager.PagerKt;
import androidx.compose.foundation.pager.PagerScope;
import androidx.compose.foundation.pager.PagerState;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.Outline;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.Iterator;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000z\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a»\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u000526\u0010\u0006\u001a2\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\f\u0012\u0004\u0012\u00020\r0\u00072\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\f\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u001621\u0010\u0017\u001a-\u0012\u0004\u0012\u00020\u0018\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0019\u0012\u0004\u0012\u00020\u00010\u0007¢\u0006\u0002\b\u001a¢\u0006\u0002\b\u001bH\u0001ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001d\u001a\u0091\u0001\u0010\u001e\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u001f\u001a\u00020\u00142\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\f\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010 \u001a\u00020\u00142\b\b\u0002\u0010!\u001a\u00020\u00142\b\b\u0002\u0010\u000e\u001a\u00020\u000f21\u0010\u0017\u001a-\u0012\u0004\u0012\u00020\u0018\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0019\u0012\u0004\u0012\u00020\u00010\u0007¢\u0006\u0002\b\u001a¢\u0006\u0002\b\u001bH\u0007ø\u0001\u0000¢\u0006\u0004\b\"\u0010#\u001a}\u0010$\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010%\u001a\u00020\u00142\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\f\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u000e\u001a\u00020\u000f21\u0010\u0017\u001a-\u0012\u0004\u0012\u00020\u0018\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0019\u0012\u0004\u0012\u00020\u00010\u0007¢\u0006\u0002\b\u001a¢\u0006\u0002\b\u001bH\u0007ø\u0001\u0000¢\u0006\u0004\b&\u0010'\u001a\u0018\u0010(\u001a\u00020\b2\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010)\u001a\u00020*H\u0000\u001a\u0018\u0010+\u001a\u00020\b2\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010)\u001a\u00020*H\u0001\u001a \u0010,\u001a\u00020\b2\u0006\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u00020.2\u0006\u00100\u001a\u00020\bH\u0002\u001a\u0019\u00101\u001a\u00020\b*\u00020\u000f2\u0006\u0010\u0004\u001a\u00020\u0005H\u0003¢\u0006\u0002\u00102\u001a\u0019\u00103\u001a\u00020\b*\u00020\u000f2\u0006\u0010\u0004\u001a\u00020\u0005H\u0003¢\u0006\u0002\u00102\u001a:\u00104\u001a\u00020\u0013*\u00020\u00132\u0006\u00105\u001a\u00020\u00112\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010)\u001a\b\u0012\u0004\u0012\u00020*062\u0006\u00107\u001a\u0002082\u0006\u00109\u001a\u00020:H\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006;"}, d2 = {"Carousel", "", "state", "Landroidx/compose/material3/carousel/CarouselState;", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "keylineList", "Lkotlin/Function2;", "", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "availableSpace", "itemSpacing", "Landroidx/compose/material3/carousel/KeylineList;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "maxNonFocalVisibleItemCount", "", "modifier", "Landroidx/compose/ui/Modifier;", "Landroidx/compose/ui/unit/Dp;", "flingBehavior", "Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "content", "Landroidx/compose/material3/carousel/CarouselItemScope;", "itemIndex", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "Carousel-V-95POc", "(Landroidx/compose/material3/carousel/CarouselState;Landroidx/compose/foundation/gestures/Orientation;Lkotlin/jvm/functions/Function2;Landroidx/compose/foundation/layout/PaddingValues;ILandroidx/compose/ui/Modifier;FLandroidx/compose/foundation/gestures/TargetedFlingBehavior;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)V", "HorizontalMultiBrowseCarousel", "preferredItemWidth", "minSmallItemWidth", "maxSmallItemWidth", "HorizontalMultiBrowseCarousel-zCIJ0Nk", "(Landroidx/compose/material3/carousel/CarouselState;FLandroidx/compose/ui/Modifier;FLandroidx/compose/foundation/gestures/TargetedFlingBehavior;FFLandroidx/compose/foundation/layout/PaddingValues;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)V", "HorizontalUncontainedCarousel", "itemWidth", "HorizontalUncontainedCarousel-9QcgTRs", "(Landroidx/compose/material3/carousel/CarouselState;FLandroidx/compose/ui/Modifier;FLandroidx/compose/foundation/gestures/TargetedFlingBehavior;Landroidx/compose/foundation/layout/PaddingValues;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)V", "calculateCurrentScrollOffset", "strategy", "Landroidx/compose/material3/carousel/Strategy;", "calculateMaxScrollOffset", "getProgress", "before", "Landroidx/compose/material3/carousel/Keyline;", "after", "unadjustedOffset", "calculateAfterContentPadding", "(Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/foundation/gestures/Orientation;Landroidx/compose/runtime/Composer;I)F", "calculateBeforeContentPadding", "carouselItem", "index", "Lkotlin/Function0;", "carouselItemInfo", "Landroidx/compose/material3/carousel/CarouselItemInfoImpl;", "clipShape", "Landroidx/compose/ui/graphics/Shape;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CarouselKt {
    public static final void m3227HorizontalMultiBrowseCarouselzCIJ0Nk(final CarouselState carouselState, final float f, Modifier modifier, float f2, TargetedFlingBehavior targetedFlingBehavior, float f3, float f4, PaddingValues paddingValues, final Function4<? super CarouselItemScope, ? super Integer, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        final float f5;
        int i5;
        final TargetedFlingBehavior targetedFlingBehavior2;
        int i6;
        float fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
        int i7;
        int i8;
        float fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
        int i9;
        int i10;
        PaddingValues paddingValues2;
        int i11;
        int i12;
        int i13;
        Modifier modifier2;
        float f6;
        boolean z;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        TargetedFlingBehavior targetedFlingBehavior3;
        final float f7;
        int i14;
        final float f8;
        final Density density;
        boolean z2;
        boolean z3;
        boolean z4;
        Object objRememberedValue;
        final float f9;
        final float f10;
        final Modifier modifier3;
        final PaddingValues paddingValues3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1825706865);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(HorizontalMultiBrowseCarousel)P(8,7:c#ui.unit.Dp,6,3:c#ui.unit.Dp,2,5:c#ui.unit.Dp,4:c#ui.unit.Dp,1)106@5374L41,112@5703L7,116@5816L554,113@5715L1048:Carousel.kt#dcf9yb");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(carouselState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(f) ? 32 : 16;
        }
        int i16 = i2 & 4;
        if (i16 == 0) {
            if ((i & 384) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    f5 = f2;
                    if (composerStartRestartGroup.changed(f5)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        targetedFlingBehavior2 = targetedFlingBehavior;
                        if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                            i15 = Fields.Clip;
                        }
                        i3 |= i15;
                    } else {
                        targetedFlingBehavior2 = targetedFlingBehavior;
                    }
                    i15 = Fields.Shape;
                    i3 |= i15;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
                        if (composerStartRestartGroup.changed(fM3224getMinSmallItemSizeD9Ej5fM$material3_release)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 1572864;
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                    } else {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                        if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                                i9 = 1048576;
                            } else {
                                i9 = 524288;
                            }
                            i3 |= i9;
                        }
                    }
                    i10 = i2 & Fields.SpotShadowColor;
                    if (i10 != 0) {
                        i3 |= 12582912;
                        paddingValues2 = paddingValues;
                    } else {
                        paddingValues2 = paddingValues;
                        if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues2)) {
                                i11 = 8388608;
                            } else {
                                i11 = 4194304;
                            }
                            i3 |= i11;
                        }
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changedInstance(function4)) {
                                i12 = 67108864;
                            } else {
                                i12 = 33554432;
                            }
                            i3 |= i12;
                        }
                        i13 = i3;
                        if ((i13 & 38347923) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 16) != 0) {
                                    i13 &= -57345;
                                }
                                modifier2 = modifier;
                                z = false;
                                f6 = f5;
                            } else {
                                if (i16 != 0) {
                                    modifier2 = Modifier.INSTANCE;
                                } else {
                                    modifier2 = modifier;
                                }
                                if (i4 != 0) {
                                    f6 = Dp.constructor-impl(0);
                                } else {
                                    f6 = f5;
                                }
                                if ((i2 & 16) != 0) {
                                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                    i13 &= -57345;
                                    targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior;
                                }
                                if (i6 != 0) {
                                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                                }
                                if (i8 != 0) {
                                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                                }
                                z = false;
                                if (i10 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                    targetedFlingBehavior3 = targetedFlingBehavior2;
                                }
                                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                                i14 = i13;
                                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                                }
                                ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                                Object objConsume = composerStartRestartGroup.consume(localDensity);
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                density = (Density) objConsume;
                                Orientation orientation = Orientation.Horizontal;
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composerStartRestartGroup.changed(density);
                                if ((i14 & 112) == 32) {
                                    z2 = true;
                                } else {
                                    z2 = z;
                                }
                                boolean zChangedInstance = zChanged | z2 | composerStartRestartGroup.changedInstance(carouselState);
                                if ((i14 & 458752) == 131072) {
                                    z3 = true;
                                } else {
                                    z3 = z;
                                }
                                z4 = zChangedInstance | z3 | ((3670016 & i14) != 1048576 ? z : true);
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (!z4 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                        }

                                        public final KeylineList invoke(float f11, float f12) {
                                            Density density2 = density;
                                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                Function2 function2 = (Function2) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                int i17 = i14 << 9;
                                m3226CarouselV95POc(carouselState, orientation, function2, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i17) | (3670016 & i17) | (i17 & 29360128) | (i14 & 234881024), 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                targetedFlingBehavior2 = targetedFlingBehavior3;
                                f9 = f8;
                                f10 = f7;
                                modifier3 = modifier2;
                                f5 = f6;
                                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            }
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                            i14 = i13;
                            f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                            }
                            ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            density = (Density) objConsume2;
                            Orientation orientation2 = Orientation.Horizontal;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged2 = composerStartRestartGroup.changed(density);
                            if ((i14 & 112) == 32) {
                                z2 = true;
                            } else {
                                z2 = z;
                            }
                            boolean zChangedInstance2 = zChanged2 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                            if ((i14 & 458752) == 131072) {
                                z3 = true;
                            } else {
                                z3 = z;
                            }
                            z4 = zChangedInstance2 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                    }

                                    public final KeylineList invoke(float f11, float f12) {
                                        Density density2 = density;
                                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                    }

                                    public final KeylineList invoke(float f11, float f12) {
                                        Density density2 = density;
                                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            Function2 function3 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i18 = i14 << 9;
                            m3226CarouselV95POc(carouselState, orientation2, function3, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i18) | (3670016 & i18) | (i18 & 29360128) | (i14 & 234881024), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            targetedFlingBehavior2 = targetedFlingBehavior3;
                            f9 = f8;
                            f10 = f7;
                            modifier3 = modifier2;
                            f5 = f6;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier;
                            paddingValues3 = paddingValues2;
                            f10 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                            f9 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
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
                                    CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 100663296;
                    i13 = i3;
                    if ((i13 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior2 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior2;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior3 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior3;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume3;
                        Orientation orientation3 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged3 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance3 = zChanged3 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance3 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function5 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i19 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation3, function5, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i19) | (3670016 & i19) | (i19 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior4 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior4;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior5 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior5;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume4;
                        Orientation orientation4 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged4 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance4 = zChanged4 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance4 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i110 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation4, function6, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i110) | (3670016 & i110) | (i110 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                                CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                } else {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 12582912;
                    paddingValues2 = paddingValues;
                } else {
                    paddingValues2 = paddingValues;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues2)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i3 |= i11;
                    }
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i12 = 67108864;
                        } else {
                            i12 = 33554432;
                        }
                        i3 |= i12;
                    }
                    i13 = i3;
                    if ((i13 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior6 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior6;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior7 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior7;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume5;
                        Orientation orientation5 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged5 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance5 = zChanged5 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance5 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function7 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i111 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation5, function7, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i111) | (3670016 & i111) | (i111 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior8 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior8;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior9 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior9;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume6;
                        Orientation orientation6 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged6 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance6 = zChanged6 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance6 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function8 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i112 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation6, function8, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i112) | (3670016 & i112) | (i112 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                                CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior10 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior10;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume7;
                    Orientation orientation7 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged7 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance7 = zChanged7 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance7 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function9 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i113 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation7, function9, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i113) | (3670016 & i113) | (i113 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior12 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior12;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior13 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior13;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume8;
                    Orientation orientation8 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged8 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance8 = zChanged8 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance8 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function10 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i114 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation8, function10, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i114) | (3670016 & i114) | (i114 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            f5 = f2;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                        i15 = Fields.Clip;
                    }
                    i3 |= i15;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                i15 = Fields.Shape;
                i3 |= i15;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
                    if (composerStartRestartGroup.changed(fM3224getMinSmallItemSizeD9Ej5fM$material3_release)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                } else {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 12582912;
                    paddingValues2 = paddingValues;
                } else {
                    paddingValues2 = paddingValues;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues2)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i3 |= i11;
                    }
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i12 = 67108864;
                        } else {
                            i12 = 33554432;
                        }
                        i3 |= i12;
                    }
                    i13 = i3;
                    if ((i13 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior14 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior14;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior15 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior15;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume9 = composerStartRestartGroup.consume(localDensity9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume9;
                        Orientation orientation9 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged9 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance9 = zChanged9 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance9 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function11 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i115 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation9, function11, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i115) | (3670016 & i115) | (i115 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior16 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior16;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior17 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior17;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume10 = composerStartRestartGroup.consume(localDensity10);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume10;
                        Orientation orientation10 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged10 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance10 = zChanged10 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance10 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function12 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i116 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation10, function12, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i116) | (3670016 & i116) | (i116 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                                CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior18 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior18;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior19 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior19;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11 = composerStartRestartGroup.consume(localDensity11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11;
                    Orientation orientation11 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged11 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance11 = zChanged11 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance11 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function13 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i117 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation11, function13, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i117) | (3670016 & i117) | (i117 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior110 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior110;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume12 = composerStartRestartGroup.consume(localDensity12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume12;
                    Orientation orientation12 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged12 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance12 = zChanged12 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance12 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function14 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i118 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation12, function14, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i118) | (3670016 & i118) | (i118 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
            } else {
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                paddingValues2 = paddingValues;
            } else {
                paddingValues2 = paddingValues;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                    i3 |= i12;
                }
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior112 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior112;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior113 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior113;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume13 = composerStartRestartGroup.consume(localDensity13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume13;
                    Orientation orientation13 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged13 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance13 = zChanged13 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance13 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function15 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i119 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation13, function15, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i119) | (3670016 & i119) | (i119 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior114 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior114;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior115 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior115;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume14 = composerStartRestartGroup.consume(localDensity14);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume14;
                    Orientation orientation14 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged14 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance14 = zChanged14 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance14 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function16 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i1110 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation14, function16, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1110) | (3670016 & i1110) | (i1110 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            i13 = i3;
            if ((i13 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior116 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior116;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior117 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior117;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume15 = composerStartRestartGroup.consume(localDensity15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume15;
                Orientation orientation15 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged15 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance15 = zChanged15 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance15 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function17 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i1111 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation15, function17, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1111) | (3670016 & i1111) | (i1111 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior118 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior118;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior119 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior119;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity16 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume16 = composerStartRestartGroup.consume(localDensity16);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume16;
                Orientation orientation16 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged16 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance16 = zChanged16 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance16 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function18 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i1112 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation16, function18, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1112) | (3670016 & i1112) | (i1112 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                        CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                f5 = f2;
                if (composerStartRestartGroup.changed(f5)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                        i15 = Fields.Clip;
                    }
                    i3 |= i15;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                i15 = Fields.Shape;
                i3 |= i15;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
                    if (composerStartRestartGroup.changed(fM3224getMinSmallItemSizeD9Ej5fM$material3_release)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                } else {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 12582912;
                    paddingValues2 = paddingValues;
                } else {
                    paddingValues2 = paddingValues;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues2)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i3 |= i11;
                    }
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i12 = 67108864;
                        } else {
                            i12 = 33554432;
                        }
                        i3 |= i12;
                    }
                    i13 = i3;
                    if ((i13 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1110 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1110;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1111 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1111;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity17 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume17 = composerStartRestartGroup.consume(localDensity17);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume17;
                        Orientation orientation17 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged17 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance17 = zChanged17 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance17 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function19 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i1113 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation17, function19, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1113) | (3670016 & i1113) | (i1113 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) == 0) {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1112 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1112;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            if (i16 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            } else {
                                modifier2 = modifier;
                            }
                            if (i4 != 0) {
                                f6 = Dp.constructor-impl(0);
                            } else {
                                f6 = f5;
                            }
                            if ((i2 & 16) != 0) {
                                TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1113 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                                i13 &= -57345;
                                targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1113;
                            }
                            if (i6 != 0) {
                                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                            }
                            if (i8 != 0) {
                                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                            }
                            z = false;
                            if (i10 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                            } else {
                                targetedFlingBehavior3 = targetedFlingBehavior2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        }
                        f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                        i14 = i13;
                        f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                        }
                        ProvidableCompositionLocal<Density> localDensity18 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume18 = composerStartRestartGroup.consume(localDensity18);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume18;
                        Orientation orientation18 = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged18 = composerStartRestartGroup.changed(density);
                        if ((i14 & 112) == 32) {
                            z2 = true;
                        } else {
                            z2 = z;
                        }
                        boolean zChangedInstance18 = zChanged18 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                        if ((i14 & 458752) == 131072) {
                            z3 = true;
                        } else {
                            z3 = z;
                        }
                        z4 = zChangedInstance18 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f11, float f12) {
                                    Density density2 = density;
                                    return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function110 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i1114 = i14 << 9;
                        m3226CarouselV95POc(carouselState, orientation18, function110, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1114) | (3670016 & i1114) | (i1114 & 29360128) | (i14 & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior2 = targetedFlingBehavior3;
                        f9 = f8;
                        f10 = f7;
                        modifier3 = modifier2;
                        f5 = f6;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                                CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 100663296;
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1114 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1114;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1115 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1115;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity19 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume19 = composerStartRestartGroup.consume(localDensity19);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume19;
                    Orientation orientation19 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged19 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance19 = zChanged19 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance19 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function111 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i1115 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation19, function111, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1115) | (3670016 & i1115) | (i1115 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1116 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1116;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1117 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1117;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity110 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume110 = composerStartRestartGroup.consume(localDensity110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume110;
                    Orientation orientation110 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged110 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance110 = zChanged110 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance110 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function112 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i1116 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation110, function112, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1116) | (3670016 & i1116) | (i1116 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
            } else {
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                paddingValues2 = paddingValues;
            } else {
                paddingValues2 = paddingValues;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                    i3 |= i12;
                }
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1118 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1118;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1119 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1119;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity111 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111 = composerStartRestartGroup.consume(localDensity111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume111;
                    Orientation orientation111 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged111 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance111 = zChanged111 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance111 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function113 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i1117 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation111, function113, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1117) | (3670016 & i1117) | (i1117 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11110 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11110;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11111 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11111;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity112 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume112 = composerStartRestartGroup.consume(localDensity112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume112;
                    Orientation orientation112 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged112 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance112 = zChanged112 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance112 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function114 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i1118 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation112, function114, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1118) | (3670016 & i1118) | (i1118 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            i13 = i3;
            if ((i13 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11112 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11112;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11113 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11113;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity113 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume113 = composerStartRestartGroup.consume(localDensity113);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume113;
                Orientation orientation113 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged113 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance113 = zChanged113 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance113 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function115 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i1119 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation113, function115, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i1119) | (3670016 & i1119) | (i1119 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11114 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11114;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11115 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11115;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity114 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume114 = composerStartRestartGroup.consume(localDensity114);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume114;
                Orientation orientation114 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged114 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance114 = zChanged114 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance114 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function116 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i11110 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation114, function116, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11110) | (3670016 & i11110) | (i11110 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                        CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        f5 = f2;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                targetedFlingBehavior2 = targetedFlingBehavior;
                if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                    i15 = Fields.Clip;
                }
                i3 |= i15;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            i15 = Fields.Shape;
            i3 |= i15;
        } else {
            targetedFlingBehavior2 = targetedFlingBehavior;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
                if (composerStartRestartGroup.changed(fM3224getMinSmallItemSizeD9Ej5fM$material3_release)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
            } else {
                fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                paddingValues2 = paddingValues;
            } else {
                paddingValues2 = paddingValues;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                    i3 |= i12;
                }
                i13 = i3;
                if ((i13 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11116 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11116;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11117 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11117;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity115 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume115 = composerStartRestartGroup.consume(localDensity115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume115;
                    Orientation orientation115 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged115 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance115 = zChanged115 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance115 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function117 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i11111 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation115, function117, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11111) | (3670016 & i11111) | (i11111 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) == 0) {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11118 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11118;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i16 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i4 != 0) {
                            f6 = Dp.constructor-impl(0);
                        } else {
                            f6 = f5;
                        }
                        if ((i2 & 16) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11119 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                            i13 &= -57345;
                            targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior11119;
                        }
                        if (i6 != 0) {
                            fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                        }
                        if (i8 != 0) {
                            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                        }
                        z = false;
                        if (i10 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                    i14 = i13;
                    f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                    }
                    ProvidableCompositionLocal<Density> localDensity116 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume116 = composerStartRestartGroup.consume(localDensity116);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume116;
                    Orientation orientation116 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged116 = composerStartRestartGroup.changed(density);
                    if ((i14 & 112) == 32) {
                        z2 = true;
                    } else {
                        z2 = z;
                    }
                    boolean zChangedInstance116 = zChanged116 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                    if ((i14 & 458752) == 131072) {
                        z3 = true;
                    } else {
                        z3 = z;
                    }
                    z4 = zChangedInstance116 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f11, float f12) {
                                Density density2 = density;
                                return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function118 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i11112 = i14 << 9;
                    m3226CarouselV95POc(carouselState, orientation116, function118, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11112) | (3670016 & i11112) | (i11112 & 29360128) | (i14 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f9 = f8;
                    f10 = f7;
                    modifier3 = modifier2;
                    f5 = f6;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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
                            CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 100663296;
            i13 = i3;
            if ((i13 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111110 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111110;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111111 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111111;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity117 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume117 = composerStartRestartGroup.consume(localDensity117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume117;
                Orientation orientation117 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged117 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance117 = zChanged117 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance117 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function119 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i11113 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation117, function119, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11113) | (3670016 & i11113) | (i11113 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111112 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111112;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111113 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111113;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity118 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume118 = composerStartRestartGroup.consume(localDensity118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume118;
                Orientation orientation118 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged118 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance118 = zChanged118 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance118 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function1110 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i11114 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation118, function1110, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11114) | (3670016 & i11114) | (i11114 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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

                    public final void invoke(Composer composer2, int i11115) {
                        CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = f3;
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
        } else {
            fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = f4;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(fM3223getMaxSmallItemSizeD9Ej5fM$material3_release)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
        }
        i10 = i2 & Fields.SpotShadowColor;
        if (i10 != 0) {
            i3 |= 12582912;
            paddingValues2 = paddingValues;
        } else {
            paddingValues2 = paddingValues;
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues2)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i3 |= i11;
            }
        }
        if ((i2 & Fields.RotationX) != 0) {
            if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i12 = 67108864;
                } else {
                    i12 = 33554432;
                }
                i3 |= i12;
            }
            i13 = i3;
            if ((i13 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111114 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111114;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111115 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111115;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity119 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume119 = composerStartRestartGroup.consume(localDensity119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume119;
                Orientation orientation119 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged119 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance119 = zChanged119 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance119 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function1111 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i11115 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation119, function1111, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11115) | (3670016 & i11115) | (i11115 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0) {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111116 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111116;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i16 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i4 != 0) {
                        f6 = Dp.constructor-impl(0);
                    } else {
                        f6 = f5;
                    }
                    if ((i2 & 16) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111117 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                        i13 &= -57345;
                        targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111117;
                    }
                    if (i6 != 0) {
                        fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                    }
                    if (i8 != 0) {
                        fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                    }
                    z = false;
                    if (i10 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
                i14 = i13;
                f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
                }
                ProvidableCompositionLocal<Density> localDensity1110 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1110 = composerStartRestartGroup.consume(localDensity1110);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume1110;
                Orientation orientation1110 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged1110 = composerStartRestartGroup.changed(density);
                if ((i14 & 112) == 32) {
                    z2 = true;
                } else {
                    z2 = z;
                }
                boolean zChangedInstance1110 = zChanged1110 | z2 | composerStartRestartGroup.changedInstance(carouselState);
                if ((i14 & 458752) == 131072) {
                    z3 = true;
                } else {
                    z3 = z;
                }
                z4 = zChangedInstance1110 | z3 | ((3670016 & i14) != 1048576 ? z : true);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f11, float f12) {
                            Density density2 = density;
                            return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function1112 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i11116 = i14 << 9;
                m3226CarouselV95POc(carouselState, orientation1110, function1112, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11116) | (3670016 & i11116) | (i11116 & 29360128) | (i14 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f9 = f8;
                f10 = f7;
                modifier3 = modifier2;
                f5 = f6;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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

                    public final void invoke(Composer composer2, int i11117) {
                        CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 100663296;
        i13 = i3;
        if ((i13 & 38347923) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i16 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i4 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f5;
                }
                if ((i2 & 16) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111118 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                    i13 &= -57345;
                    targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111118;
                }
                if (i6 != 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                }
                if (i8 != 0) {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                }
                z = false;
                if (i10 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            } else {
                if (i16 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i4 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f5;
                }
                if ((i2 & 16) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior111119 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                    i13 &= -57345;
                    targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior111119;
                }
                if (i6 != 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                }
                if (i8 != 0) {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                }
                z = false;
                if (i10 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            }
            f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
            i14 = i13;
            f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
            }
            ProvidableCompositionLocal<Density> localDensity1111 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111 = composerStartRestartGroup.consume(localDensity1111);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume1111;
            Orientation orientation1111 = Orientation.Horizontal;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
            boolean zChanged1111 = composerStartRestartGroup.changed(density);
            if ((i14 & 112) == 32) {
                z2 = true;
            } else {
                z2 = z;
            }
            boolean zChangedInstance1111 = zChanged1111 | z2 | composerStartRestartGroup.changedInstance(carouselState);
            if ((i14 & 458752) == 131072) {
                z3 = true;
            } else {
                z3 = z;
            }
            z4 = zChangedInstance1111 | z3 | ((3670016 & i14) != 1048576 ? z : true);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f11, float f12) {
                        Density density2 = density;
                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f11, float f12) {
                        Density density2 = density;
                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function2 function1113 = (Function2) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i11117 = i14 << 9;
            m3226CarouselV95POc(carouselState, orientation1111, function1113, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11117) | (3670016 & i11117) | (i11117 & 29360128) | (i14 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            targetedFlingBehavior2 = targetedFlingBehavior3;
            f9 = f8;
            f10 = f7;
            modifier3 = modifier2;
            f5 = f6;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i16 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i4 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f5;
                }
                if ((i2 & 16) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1111110 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                    i13 &= -57345;
                    targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1111110;
                }
                if (i6 != 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                }
                if (i8 != 0) {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                }
                z = false;
                if (i10 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            } else {
                if (i16 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i4 != 0) {
                    f6 = Dp.constructor-impl(0);
                } else {
                    f6 = f5;
                }
                if ((i2 & 16) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior1111111 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i13 & 14) | 384, 2);
                    i13 &= -57345;
                    targetedFlingBehavior2 = targetedFlingBehaviorSingleAdvanceFlingBehavior1111111;
                }
                if (i6 != 0) {
                    fM3224getMinSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release();
                }
                if (i8 != 0) {
                    fM3223getMaxSmallItemSizeD9Ej5fM$material3_release = CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release();
                }
                z = false;
                if (i10 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            }
            f7 = fM3223getMaxSmallItemSizeD9Ej5fM$material3_release;
            i14 = i13;
            f8 = fM3224getMinSmallItemSizeD9Ej5fM$material3_release;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1825706865, i14, -1, "androidx.compose.material3.carousel.HorizontalMultiBrowseCarousel (Carousel.kt:111)");
            }
            ProvidableCompositionLocal<Density> localDensity1112 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1112 = composerStartRestartGroup.consume(localDensity1112);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume1112;
            Orientation orientation1112 = Orientation.Horizontal;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1995157598, "CC(remember):Carousel.kt#9igjgp");
            boolean zChanged1112 = composerStartRestartGroup.changed(density);
            if ((i14 & 112) == 32) {
                z2 = true;
            } else {
                z2 = z;
            }
            boolean zChangedInstance1112 = zChanged1112 | z2 | composerStartRestartGroup.changedInstance(carouselState);
            if ((i14 & 458752) == 131072) {
                z3 = true;
            } else {
                z3 = z;
            }
            z4 = zChangedInstance1112 | z3 | ((3670016 & i14) != 1048576 ? z : true);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f11, float f12) {
                        Density density2 = density;
                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f11, float f12) {
                        Density density2 = density;
                        return KeylinesKt.multiBrowseKeylineList(density2, f11, density2.toPx-0680j_4(f), f12, ((Number) carouselState.getItemCountState().getValue().invoke()).intValue(), density2.toPx-0680j_4(f8), density2.toPx-0680j_4(f7));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function2 function1114 = (Function2) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i11118 = i14 << 9;
            m3226CarouselV95POc(carouselState, orientation1112, function1114, paddingValuesM1028PaddingValues0680j_4, 2, modifier2, f6, targetedFlingBehavior3, function4, composerStartRestartGroup, (i14 & 14) | 24624 | ((i14 >> 12) & 7168) | (458752 & i11118) | (3670016 & i11118) | (i11118 & 29360128) | (i14 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            targetedFlingBehavior2 = targetedFlingBehavior3;
            f9 = f8;
            f10 = f7;
            modifier3 = modifier2;
            f5 = f6;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
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

                public final void invoke(Composer composer2, int i11119) {
                    CarouselKt.m3227HorizontalMultiBrowseCarouselzCIJ0Nk(carouselState, f, modifier3, f5, targetedFlingBehavior2, f9, f10, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m3228HorizontalUncontainedCarousel9QcgTRs(final CarouselState carouselState, final float f, Modifier modifier, float f2, TargetedFlingBehavior targetedFlingBehavior, PaddingValues paddingValues, final Function4<? super CarouselItemScope, ? super Integer, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        float f3;
        int i5;
        TargetedFlingBehavior targetedFlingBehaviorNoSnapFlingBehavior;
        int i6;
        PaddingValues paddingValues2;
        int i7;
        int i8;
        boolean z;
        int i9;
        final float f4;
        TargetedFlingBehavior targetedFlingBehavior2;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        final Density density;
        boolean z2;
        Object objRememberedValue;
        final TargetedFlingBehavior targetedFlingBehavior3;
        final PaddingValues paddingValues3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        Composer composerStartRestartGroup = composer.startRestartGroup(529322840);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(HorizontalUncontainedCarousel)P(6,4:c#ui.unit.Dp,5,3:c#ui.unit.Dp,2,1)175@8483L21,179@8666L7,183@8779L337,180@8678L818:Carousel.kt#dcf9yb");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(carouselState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(f) ? 32 : 16;
        }
        int i11 = i2 & 4;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    f3 = f2;
                    if (composerStartRestartGroup.changed(f3)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                        if (composerStartRestartGroup.changed(targetedFlingBehaviorNoSnapFlingBehavior)) {
                            i10 = Fields.Clip;
                        }
                        i3 |= i10;
                    } else {
                        targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                    }
                    i10 = Fields.Shape;
                    i3 |= i10;
                } else {
                    targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        paddingValues2 = paddingValues;
                        if (composerStartRestartGroup.changed(paddingValues2)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 64) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = 1048576;
                        } else {
                            i8 = 524288;
                        }
                        i3 |= i8;
                    }
                    if ((599187 & i3) == 599186 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i11 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i4 != 0) {
                                f3 = Dp.constructor-impl(0);
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                            }
                            z = false;
                            if (i6 != 0) {
                                i9 = i3;
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                f4 = f3;
                                targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            } else {
                                i9 = i3;
                                f4 = f3;
                                targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            z = false;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                        }
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume;
                        Orientation orientation = Orientation.Horizontal;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged = composerStartRestartGroup.changed(density);
                        if ((i9 & 112) == 32) {
                            z = true;
                        }
                        z2 = z | zChanged;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z2 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                                }

                                public final KeylineList invoke(float f5, float f6) {
                                    Density density2 = density;
                                    return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function2 function2 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i12 = i9 << 9;
                        m3226CarouselV95POc(carouselState, orientation, function2, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i12) | (3670016 & i12) | (i12 & 29360128) | ((i9 << 6) & 234881024), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        f4 = f3;
                        targetedFlingBehavior3 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValues3 = paddingValues2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i13) {
                                CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier3, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                paddingValues2 = paddingValues;
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume2;
                    Orientation orientation2 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged2 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged2;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function3 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i13 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation2, function3, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i13) | (3670016 & i13) | (i13 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume3;
                    Orientation orientation3 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged3 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function5 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i14 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation3, function5, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i14) | (3670016 & i14) | (i14 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier4, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            f3 = f2;
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehaviorNoSnapFlingBehavior)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    paddingValues2 = paddingValues;
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume4;
                    Orientation orientation4 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged4 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged4;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i15 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation4, function6, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i15) | (3670016 & i15) | (i15 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume5;
                    Orientation orientation5 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged5 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged5;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function7 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i16 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation5, function7, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i16) | (3670016 & i16) | (i16 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier5, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            paddingValues2 = paddingValues;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume6;
                Orientation orientation6 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged6 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged6;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function8 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i17 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation6, function8, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i17) | (3670016 & i17) | (i17 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume7;
                Orientation orientation7 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged7 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged7;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function9 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i18 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation7, function9, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i18) | (3670016 & i18) | (i18 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier6, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                f3 = f2;
                if (composerStartRestartGroup.changed(f3)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehaviorNoSnapFlingBehavior)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    paddingValues2 = paddingValues;
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume8;
                    Orientation orientation8 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged8 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged8;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function10 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i19 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation8, function10, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i19) | (3670016 & i19) | (i19 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    } else {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i4 != 0) {
                            f3 = Dp.constructor-impl(0);
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                        }
                        z = false;
                        if (i6 != 0) {
                            i9 = i3;
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        } else {
                            i9 = i3;
                            f4 = f3;
                            targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                    }
                    ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composerStartRestartGroup.consume(localDensity9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume9;
                    Orientation orientation9 = Orientation.Horizontal;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                    boolean zChanged9 = composerStartRestartGroup.changed(density);
                    if ((i9 & 112) == 32) {
                        z = true;
                    }
                    z2 = z | zChanged9;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                            }

                            public final KeylineList invoke(float f5, float f6) {
                                Density density2 = density;
                                return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function2 function11 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i110 = i9 << 9;
                    m3226CarouselV95POc(carouselState, orientation9, function11, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i110) | (3670016 & i110) | (i110 & 29360128) | ((i9 << 6) & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier7, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            paddingValues2 = paddingValues;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localDensity10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume10;
                Orientation orientation10 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged10 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged10;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function12 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i111 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation10, function12, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i111) | (3670016 & i111) | (i111 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localDensity11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11;
                Orientation orientation11 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged11 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged11;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function13 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i112 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation11, function13, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i112) | (3670016 & i112) | (i112 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier8, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        f3 = f2;
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
                if (composerStartRestartGroup.changed(targetedFlingBehaviorNoSnapFlingBehavior)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            targetedFlingBehaviorNoSnapFlingBehavior = targetedFlingBehavior;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                paddingValues2 = paddingValues;
                if (composerStartRestartGroup.changed(paddingValues2)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localDensity12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume12;
                Orientation orientation12 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged12 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged12;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function14 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i113 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation12, function14, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i113) | (3670016 & i113) | (i113 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i4 != 0) {
                        f3 = Dp.constructor-impl(0);
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                    }
                    z = false;
                    if (i6 != 0) {
                        i9 = i3;
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    } else {
                        i9 = i3;
                        f4 = f3;
                        targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
                }
                ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localDensity13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume13;
                Orientation orientation13 = Orientation.Horizontal;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
                boolean zChanged13 = composerStartRestartGroup.changed(density);
                if ((i9 & 112) == 32) {
                    z = true;
                }
                z2 = z | zChanged13;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                        }

                        public final KeylineList invoke(float f5, float f6) {
                            Density density2 = density;
                            return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function2 function15 = (Function2) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i114 = i9 << 9;
                m3226CarouselV95POc(carouselState, orientation13, function15, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i114) | (3670016 & i114) | (i114 & 29360128) | ((i9 << 6) & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                targetedFlingBehavior3 = targetedFlingBehavior2;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier9, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        paddingValues2 = paddingValues;
        if ((i2 & 64) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i8 = 1048576;
            } else {
                i8 = 524288;
            }
            i3 |= i8;
        }
        if ((599187 & i3) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    f3 = Dp.constructor-impl(0);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                }
                z = false;
                if (i6 != 0) {
                    i9 = i3;
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                } else {
                    i9 = i3;
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            } else {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    f3 = Dp.constructor-impl(0);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                }
                z = false;
                if (i6 != 0) {
                    i9 = i3;
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                } else {
                    i9 = i3;
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
            }
            ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume14 = composerStartRestartGroup.consume(localDensity14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume14;
            Orientation orientation14 = Orientation.Horizontal;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
            boolean zChanged14 = composerStartRestartGroup.changed(density);
            if ((i9 & 112) == 32) {
                z = true;
            }
            z2 = z | zChanged14;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f5, float f6) {
                        Density density2 = density;
                        return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f5, float f6) {
                        Density density2 = density;
                        return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function2 function16 = (Function2) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i115 = i9 << 9;
            m3226CarouselV95POc(carouselState, orientation14, function16, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i115) | (3670016 & i115) | (i115 & 29360128) | ((i9 << 6) & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            targetedFlingBehavior3 = targetedFlingBehavior2;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    f3 = Dp.constructor-impl(0);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                }
                z = false;
                if (i6 != 0) {
                    i9 = i3;
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                } else {
                    i9 = i3;
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            } else {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i4 != 0) {
                    f3 = Dp.constructor-impl(0);
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    targetedFlingBehaviorNoSnapFlingBehavior = CarouselDefaults.INSTANCE.noSnapFlingBehavior(composerStartRestartGroup, 6);
                }
                z = false;
                if (i6 != 0) {
                    i9 = i3;
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                } else {
                    i9 = i3;
                    f4 = f3;
                    targetedFlingBehavior2 = targetedFlingBehaviorNoSnapFlingBehavior;
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(529322840, i9, -1, "androidx.compose.material3.carousel.HorizontalUncontainedCarousel (Carousel.kt:178)");
            }
            ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume15 = composerStartRestartGroup.consume(localDensity15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume15;
            Orientation orientation15 = Orientation.Horizontal;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1883505148, "CC(remember):Carousel.kt#9igjgp");
            boolean zChanged15 = composerStartRestartGroup.changed(density);
            if ((i9 & 112) == 32) {
                z = true;
            }
            z2 = z | zChanged15;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f5, float f6) {
                        Density density2 = density;
                        return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function2) new Function2<Float, Float, KeylineList>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke(((Number) obj).floatValue(), ((Number) obj2).floatValue());
                    }

                    public final KeylineList invoke(float f5, float f6) {
                        Density density2 = density;
                        return KeylinesKt.uncontainedKeylineList(density2, f5, density2.toPx-0680j_4(f), f6);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function2 function17 = (Function2) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i116 = i9 << 9;
            m3226CarouselV95POc(carouselState, orientation15, function17, paddingValuesM1028PaddingValues0680j_4, 0, modifier2, f4, targetedFlingBehavior2, function4, composerStartRestartGroup, (i9 & 14) | 24624 | ((i9 >> 6) & 7168) | (458752 & i116) | (3670016 & i116) | (i116 & 29360128) | ((i9 << 6) & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            targetedFlingBehavior3 = targetedFlingBehavior2;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = modifier2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    CarouselKt.m3228HorizontalUncontainedCarousel9QcgTRs(carouselState, f, modifier10, f4, targetedFlingBehavior3, paddingValues3, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m3226CarouselV95POc(final CarouselState carouselState, final Orientation orientation, final Function2<? super Float, ? super Float, KeylineList> function2, final PaddingValues paddingValues, final int i, Modifier modifier, float f, TargetedFlingBehavior targetedFlingBehavior, final Function4<? super CarouselItemScope, ? super Integer, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i2, final int i3) {
        int i4;
        int i5;
        float f2;
        int i6;
        TargetedFlingBehavior targetedFlingBehavior2;
        int i7;
        int i8;
        boolean z;
        Modifier modifier2;
        float f3;
        TargetedFlingBehavior targetedFlingBehavior3;
        Modifier modifier3;
        float fCalculateBeforeContentPadding;
        float fCalculateAfterContentPadding;
        Object objRememberedValue;
        final CarouselPageSize carouselPageSize;
        SnapPosition snapPositionKeylineSnapPosition;
        Composer composer2;
        Modifier modifier4;
        float f4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2035733443);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Carousel)P(8,7,4,1,5,6,3:c#ui.unit.Dp,2)239@11411L41,242@11572L42,243@11660L41,245@11729L118:Carousel.kt#dcf9yb");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(carouselState) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i3 & 2) != 0) {
            i4 |= 48;
        } else if ((i2 & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(orientation) ? 32 : 16;
        }
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i2 & 384) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function2) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 8) != 0) {
            i4 |= 3072;
        } else if ((i2 & 3072) == 0) {
            i4 |= composerStartRestartGroup.changed(paddingValues) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 16) != 0) {
            i4 |= 24576;
        } else if ((i2 & 24576) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? Fields.Clip : Fields.Shape;
        }
        int i9 = i3 & 32;
        if (i9 == 0) {
            if ((196608 & i2) == 0) {
                i4 |= composerStartRestartGroup.changed(modifier) ? Fields.RenderEffect : 65536;
            }
            i5 = i3 & 64;
            if (i5 != 0) {
                if ((1572864 & i2) == 0) {
                    f2 = f;
                    if (composerStartRestartGroup.changed(f2)) {
                        i6 = 1048576;
                    } else {
                        i6 = 524288;
                    }
                    i4 |= i6;
                }
                if ((i2 & 12582912) == 0) {
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        targetedFlingBehavior2 = targetedFlingBehavior;
                        int i10 = composerStartRestartGroup.changed(targetedFlingBehavior2) ? 8388608 : 4194304;
                        i4 |= i10;
                    } else {
                        targetedFlingBehavior2 = targetedFlingBehavior;
                    }
                    i4 |= i10;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    i4 |= 100663296;
                } else if ((i2 & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i7 = 67108864;
                    } else {
                        i7 = 33554432;
                    }
                    i4 |= i7;
                }
                i8 = i4;
                if ((38347923 & i8) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    z = false;
                    if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i9 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        } else {
                            modifier2 = modifier;
                        }
                        if (i5 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                            i8 &= -29360129;
                            targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior;
                        } else {
                            targetedFlingBehavior3 = targetedFlingBehavior2;
                        }
                        modifier3 = modifier2;
                        f2 = f3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            i8 &= -29360129;
                        }
                        modifier3 = modifier;
                        z = false;
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
                    }
                    int i11 = ((i8 >> 9) & 14) | (i8 & 112);
                    fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i11);
                    fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i11);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
                    if ((i8 & 896) == 256) {
                        z = true;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    carouselPageSize = (CarouselPageSize) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
                    if (orientation == Orientation.Horizontal) {
                        composerStartRestartGroup.startReplaceGroup(-1618653092);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                        composer2 = composerStartRestartGroup;
                        PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(PagerScope pagerScope, int i12, Composer composer3, int i13) {
                                ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(687111200, i13, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue2 = composer3.rememberedValue();
                                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = new CarouselItemInfoImpl();
                                    composer3.updateRememberedValue(objRememberedValue2);
                                }
                                final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue3 = composer3.rememberedValue();
                                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                    composer3.updateRememberedValue(objRememberedValue3);
                                }
                                CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue4 = composer3.rememberedValue();
                                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = new Shape() {
                                        @Override
                                        public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                            return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue4);
                                }
                                CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier.Companion companion = Modifier.INSTANCE;
                                CarouselState carouselState2 = carouselState;
                                ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composer3.changed(carouselPageSize);
                                final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                Object objRememberedValue5 = composer3.rememberedValue();
                                if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                        {
                                            super(0);
                                        }

                                        public final Strategy m3229invoke() {
                                            return carouselPageSize2.getStrategy();
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue5);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i12, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                                Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                                function5.invoke(carouselItemScopeImpl, Integer.valueOf(i12), composer3, Integer.valueOf(i13 & 112));
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                        composer2.endReplaceGroup();
                    } else {
                        composer2 = composerStartRestartGroup;
                        if (orientation == Orientation.Vertical) {
                            composer2.startReplaceGroup(-1616959128);
                            ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                            PagerState pagerState = carouselState.getPagerState();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume = composer2.consume(localLayoutDirection);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            float fCalculateStartPadding = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume);
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume2 = composer2.consume(localLayoutDirection2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            PagerKt.m1327VerticalPageroI3XNZo(pagerState, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume2), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                                {
                                    super(4);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                    invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(PagerScope pagerScope, int i12, Composer composer3, int i13) {
                                    ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-817308503, i13, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                                    }
                                    ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                                    Object objRememberedValue2 = composer3.rememberedValue();
                                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue2 = new CarouselItemInfoImpl();
                                        composer3.updateRememberedValue(objRememberedValue2);
                                    }
                                    final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                                    Object objRememberedValue3 = composer3.rememberedValue();
                                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                        composer3.updateRememberedValue(objRememberedValue3);
                                    }
                                    CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                                    Object objRememberedValue4 = composer3.rememberedValue();
                                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = new Shape() {
                                            @Override
                                            public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                                return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                            }
                                        };
                                        composer3.updateRememberedValue(objRememberedValue4);
                                    }
                                    CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    Modifier.Companion companion = Modifier.INSTANCE;
                                    CarouselState carouselState2 = carouselState;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                                    boolean zChanged = composer3.changed(carouselPageSize);
                                    final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                    Object objRememberedValue5 = composer3.rememberedValue();
                                    if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                            {
                                                super(0);
                                            }

                                            public final Strategy m3230invoke() {
                                                return carouselPageSize2.getStrategy();
                                            }
                                        };
                                        composer3.updateRememberedValue(objRememberedValue5);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i12, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                                    Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                                    function5.invoke(carouselItemScopeImpl, Integer.valueOf(i12), composer3, Integer.valueOf(i13 & 112));
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                            composer2.endReplaceGroup();
                        } else {
                            composer2.startReplaceGroup(-1615314857);
                            composer2.endReplaceGroup();
                        }
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    targetedFlingBehavior2 = targetedFlingBehavior3;
                    f4 = f2;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier4 = modifier;
                    f4 = f2;
                    composer2 = composerStartRestartGroup;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier4;
                    final float f5 = f4;
                    final TargetedFlingBehavior targetedFlingBehavior4 = targetedFlingBehavior2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i12) {
                            CarouselKt.m3226CarouselV95POc(carouselState, orientation, function2, paddingValues, i, modifier5, f5, targetedFlingBehavior4, function4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 1572864;
            f2 = f;
            if ((i2 & 12582912) == 0) {
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                    }
                    i4 |= i10;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                i4 |= i10;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            if ((i3 & Fields.RotationX) != 0) {
                i4 |= 100663296;
            } else if ((i2 & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i7 = 67108864;
                } else {
                    i7 = 33554432;
                }
                i4 |= i7;
            }
            i8 = i4;
            if ((38347923 & i8) == 38347922) {
                composerStartRestartGroup.startDefaults();
                z = false;
                if ((i2 & 1) != 0) {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior2 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior2;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                } else {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior3 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior3;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
                }
                int i12 = ((i8 >> 9) & 14) | (i8 & 112);
                fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i12);
                fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i12);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
                if ((i8 & 896) == 256) {
                    z = true;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                carouselPageSize = (CarouselPageSize) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
                if (orientation == Orientation.Horizontal) {
                    composerStartRestartGroup.startReplaceGroup(-1618653092);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                    composer2 = composerStartRestartGroup;
                    PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i13, Composer composer3, int i14) {
                            ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(687111200, i14, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3229invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i13, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i13), composer3, Integer.valueOf(i14 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    if (orientation == Orientation.Vertical) {
                        composer2.startReplaceGroup(-1616959128);
                        ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                        PagerState pagerState2 = carouselState.getPagerState();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume3 = composer2.consume(localLayoutDirection3);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        float fCalculateStartPadding2 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume3);
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume4 = composer2.consume(localLayoutDirection4);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        PagerKt.m1327VerticalPageroI3XNZo(pagerState2, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding2, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume4), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(PagerScope pagerScope, int i13, Composer composer3, int i14) {
                                ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-817308503, i14, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue2 = composer3.rememberedValue();
                                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = new CarouselItemInfoImpl();
                                    composer3.updateRememberedValue(objRememberedValue2);
                                }
                                final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue3 = composer3.rememberedValue();
                                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                    composer3.updateRememberedValue(objRememberedValue3);
                                }
                                CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue4 = composer3.rememberedValue();
                                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = new Shape() {
                                        @Override
                                        public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                            return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue4);
                                }
                                CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier.Companion companion = Modifier.INSTANCE;
                                CarouselState carouselState2 = carouselState;
                                ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composer3.changed(carouselPageSize);
                                final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                Object objRememberedValue5 = composer3.rememberedValue();
                                if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                        {
                                            super(0);
                                        }

                                        public final Strategy m3230invoke() {
                                            return carouselPageSize2.getStrategy();
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue5);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i13, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                                Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                                function5.invoke(carouselItemScopeImpl, Integer.valueOf(i13), composer3, Integer.valueOf(i14 & 112));
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                        composer2.endReplaceGroup();
                    } else {
                        composer2.startReplaceGroup(-1615314857);
                        composer2.endReplaceGroup();
                    }
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f4 = f2;
            } else {
                composerStartRestartGroup.startDefaults();
                z = false;
                if ((i2 & 1) != 0) {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior4 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior4;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                } else {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior5 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior5;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
                }
                int i13 = ((i8 >> 9) & 14) | (i8 & 112);
                fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i13);
                fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i13);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
                if ((i8 & 896) == 256) {
                    z = true;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                carouselPageSize = (CarouselPageSize) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
                if (orientation == Orientation.Horizontal) {
                    composerStartRestartGroup.startReplaceGroup(-1618653092);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                    composer2 = composerStartRestartGroup;
                    PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i14, Composer composer3, int i15) {
                            ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(687111200, i15, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3229invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i14, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i14), composer3, Integer.valueOf(i15 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    if (orientation == Orientation.Vertical) {
                        composer2.startReplaceGroup(-1616959128);
                        ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                        PagerState pagerState3 = carouselState.getPagerState();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume5 = composer2.consume(localLayoutDirection5);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        float fCalculateStartPadding3 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume5);
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume6 = composer2.consume(localLayoutDirection6);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        PagerKt.m1327VerticalPageroI3XNZo(pagerState3, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding3, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume6), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(PagerScope pagerScope, int i14, Composer composer3, int i15) {
                                ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-817308503, i15, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue2 = composer3.rememberedValue();
                                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = new CarouselItemInfoImpl();
                                    composer3.updateRememberedValue(objRememberedValue2);
                                }
                                final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue3 = composer3.rememberedValue();
                                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                    composer3.updateRememberedValue(objRememberedValue3);
                                }
                                CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue4 = composer3.rememberedValue();
                                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = new Shape() {
                                        @Override
                                        public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                            return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue4);
                                }
                                CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier.Companion companion = Modifier.INSTANCE;
                                CarouselState carouselState2 = carouselState;
                                ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composer3.changed(carouselPageSize);
                                final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                Object objRememberedValue5 = composer3.rememberedValue();
                                if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                        {
                                            super(0);
                                        }

                                        public final Strategy m3230invoke() {
                                            return carouselPageSize2.getStrategy();
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue5);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i14, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                                Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                                function5.invoke(carouselItemScopeImpl, Integer.valueOf(i14), composer3, Integer.valueOf(i15 & 112));
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                        composer2.endReplaceGroup();
                    } else {
                        composer2.startReplaceGroup(-1615314857);
                        composer2.endReplaceGroup();
                    }
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f4 = f2;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier4;
                final float f6 = f4;
                final TargetedFlingBehavior targetedFlingBehavior5 = targetedFlingBehavior2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i14) {
                        CarouselKt.m3226CarouselV95POc(carouselState, orientation, function2, paddingValues, i, modifier6, f6, targetedFlingBehavior5, function4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 196608;
        i5 = i3 & 64;
        if (i5 != 0) {
            if ((1572864 & i2) == 0) {
                f2 = f;
                if (composerStartRestartGroup.changed(f2)) {
                    i6 = 1048576;
                } else {
                    i6 = 524288;
                }
                i4 |= i6;
            }
            if ((i2 & 12582912) == 0) {
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                    if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                    }
                    i4 |= i10;
                } else {
                    targetedFlingBehavior2 = targetedFlingBehavior;
                }
                i4 |= i10;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            if ((i3 & Fields.RotationX) != 0) {
                i4 |= 100663296;
            } else if ((i2 & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i7 = 67108864;
                } else {
                    i7 = 33554432;
                }
                i4 |= i7;
            }
            i8 = i4;
            if ((38347923 & i8) == 38347922) {
                composerStartRestartGroup.startDefaults();
                z = false;
                if ((i2 & 1) != 0) {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior6 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior6;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                } else {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior7 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior7;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
                }
                int i14 = ((i8 >> 9) & 14) | (i8 & 112);
                fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i14);
                fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i14);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
                if ((i8 & 896) == 256) {
                    z = true;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                carouselPageSize = (CarouselPageSize) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
                if (orientation == Orientation.Horizontal) {
                    composerStartRestartGroup.startReplaceGroup(-1618653092);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                    composer2 = composerStartRestartGroup;
                    PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i15, Composer composer3, int i16) {
                            ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(687111200, i16, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3229invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i15, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i15), composer3, Integer.valueOf(i16 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    if (orientation == Orientation.Vertical) {
                        composer2.startReplaceGroup(-1616959128);
                        ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                        PagerState pagerState4 = carouselState.getPagerState();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume7 = composer2.consume(localLayoutDirection7);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        float fCalculateStartPadding4 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume7);
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume8 = composer2.consume(localLayoutDirection8);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        PagerKt.m1327VerticalPageroI3XNZo(pagerState4, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding4, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume8), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(PagerScope pagerScope, int i15, Composer composer3, int i16) {
                                ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-817308503, i16, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue2 = composer3.rememberedValue();
                                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = new CarouselItemInfoImpl();
                                    composer3.updateRememberedValue(objRememberedValue2);
                                }
                                final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue3 = composer3.rememberedValue();
                                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                    composer3.updateRememberedValue(objRememberedValue3);
                                }
                                CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue4 = composer3.rememberedValue();
                                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = new Shape() {
                                        @Override
                                        public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                            return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue4);
                                }
                                CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier.Companion companion = Modifier.INSTANCE;
                                CarouselState carouselState2 = carouselState;
                                ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composer3.changed(carouselPageSize);
                                final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                Object objRememberedValue5 = composer3.rememberedValue();
                                if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                        {
                                            super(0);
                                        }

                                        public final Strategy m3230invoke() {
                                            return carouselPageSize2.getStrategy();
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue5);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i15, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                                Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                                function5.invoke(carouselItemScopeImpl, Integer.valueOf(i15), composer3, Integer.valueOf(i16 & 112));
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                        composer2.endReplaceGroup();
                    } else {
                        composer2.startReplaceGroup(-1615314857);
                        composer2.endReplaceGroup();
                    }
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f4 = f2;
            } else {
                composerStartRestartGroup.startDefaults();
                z = false;
                if ((i2 & 1) != 0) {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior8 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior8;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                } else {
                    if (i9 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    } else {
                        modifier2 = modifier;
                    }
                    if (i5 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior9 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                        i8 &= -29360129;
                        targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior9;
                    } else {
                        targetedFlingBehavior3 = targetedFlingBehavior2;
                    }
                    modifier3 = modifier2;
                    f2 = f3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
                }
                int i15 = ((i8 >> 9) & 14) | (i8 & 112);
                fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i15);
                fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i15);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
                if ((i8 & 896) == 256) {
                    z = true;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                carouselPageSize = (CarouselPageSize) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
                if (orientation == Orientation.Horizontal) {
                    composerStartRestartGroup.startReplaceGroup(-1618653092);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                    composer2 = composerStartRestartGroup;
                    PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i16, Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(687111200, i17, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3229invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i16, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i16), composer3, Integer.valueOf(i17 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    if (orientation == Orientation.Vertical) {
                        composer2.startReplaceGroup(-1616959128);
                        ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                        PagerState pagerState5 = carouselState.getPagerState();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume9 = composer2.consume(localLayoutDirection9);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        float fCalculateStartPadding5 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume9);
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume10 = composer2.consume(localLayoutDirection10);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        PagerKt.m1327VerticalPageroI3XNZo(pagerState5, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding5, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume10), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(PagerScope pagerScope, int i16, Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-817308503, i17, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue2 = composer3.rememberedValue();
                                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = new CarouselItemInfoImpl();
                                    composer3.updateRememberedValue(objRememberedValue2);
                                }
                                final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue3 = composer3.rememberedValue();
                                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                    composer3.updateRememberedValue(objRememberedValue3);
                                }
                                CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                                Object objRememberedValue4 = composer3.rememberedValue();
                                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = new Shape() {
                                        @Override
                                        public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                            return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue4);
                                }
                                CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier.Companion companion = Modifier.INSTANCE;
                                CarouselState carouselState2 = carouselState;
                                ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                                boolean zChanged = composer3.changed(carouselPageSize);
                                final CarouselPageSize carouselPageSize2 = carouselPageSize;
                                Object objRememberedValue5 = composer3.rememberedValue();
                                if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                        {
                                            super(0);
                                        }

                                        public final Strategy m3230invoke() {
                                            return carouselPageSize2.getStrategy();
                                        }
                                    };
                                    composer3.updateRememberedValue(objRememberedValue5);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i16, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                                Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                                ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                                function5.invoke(carouselItemScopeImpl, Integer.valueOf(i16), composer3, Integer.valueOf(i17 & 112));
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                        composer2.endReplaceGroup();
                    } else {
                        composer2.startReplaceGroup(-1615314857);
                        composer2.endReplaceGroup();
                    }
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                targetedFlingBehavior2 = targetedFlingBehavior3;
                f4 = f2;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier7 = modifier4;
                final float f7 = f4;
                final TargetedFlingBehavior targetedFlingBehavior6 = targetedFlingBehavior2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i16) {
                        CarouselKt.m3226CarouselV95POc(carouselState, orientation, function2, paddingValues, i, modifier7, f7, targetedFlingBehavior6, function4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 1572864;
        f2 = f;
        if ((i2 & 12582912) == 0) {
            if ((i3 & Fields.SpotShadowColor) == 0) {
                targetedFlingBehavior2 = targetedFlingBehavior;
                if (composerStartRestartGroup.changed(targetedFlingBehavior2)) {
                }
                i4 |= i10;
            } else {
                targetedFlingBehavior2 = targetedFlingBehavior;
            }
            i4 |= i10;
        } else {
            targetedFlingBehavior2 = targetedFlingBehavior;
        }
        if ((i3 & Fields.RotationX) != 0) {
            i4 |= 100663296;
        } else if ((i2 & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i7 = 67108864;
            } else {
                i7 = 33554432;
            }
            i4 |= i7;
        }
        i8 = i4;
        if ((38347923 & i8) == 38347922) {
            composerStartRestartGroup.startDefaults();
            z = false;
            if ((i2 & 1) != 0) {
                if (i9 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i5 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior10 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                    i8 &= -29360129;
                    targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior10;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                }
                modifier3 = modifier2;
                f2 = f3;
            } else {
                if (i9 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i5 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior11 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                    i8 &= -29360129;
                    targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior11;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                }
                modifier3 = modifier2;
                f2 = f3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
            }
            int i16 = ((i8 >> 9) & 14) | (i8 & 112);
            fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i16);
            fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i16);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
            if ((i8 & 896) == 256) {
                z = true;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            carouselPageSize = (CarouselPageSize) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
            if (orientation == Orientation.Horizontal) {
                composerStartRestartGroup.startReplaceGroup(-1618653092);
                ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                composer2 = composerStartRestartGroup;
                PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                        invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PagerScope pagerScope, int i17, Composer composer3, int i18) {
                        ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(687111200, i18, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue2 = composer3.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = new CarouselItemInfoImpl();
                            composer3.updateRememberedValue(objRememberedValue2);
                        }
                        final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue3 = composer3.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                            composer3.updateRememberedValue(objRememberedValue3);
                        }
                        CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue4 = composer3.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = new Shape() {
                                @Override
                                public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                    return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue4);
                        }
                        CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        Modifier.Companion companion = Modifier.INSTANCE;
                        CarouselState carouselState2 = carouselState;
                        ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged = composer3.changed(carouselPageSize);
                        final CarouselPageSize carouselPageSize2 = carouselPageSize;
                        Object objRememberedValue5 = composer3.rememberedValue();
                        if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                {
                                    super(0);
                                }

                                public final Strategy m3229invoke() {
                                    return carouselPageSize2.getStrategy();
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i17, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                        Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer3.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer3.startReusableNode();
                        if (composer3.getInserting()) {
                            composer3.createNode(constructor);
                        } else {
                            composer3.useNode();
                        }
                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                        function5.invoke(carouselItemScopeImpl, Integer.valueOf(i17), composer3, Integer.valueOf(i18 & 112));
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        composer3.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                composer2.endReplaceGroup();
            } else {
                composer2 = composerStartRestartGroup;
                if (orientation == Orientation.Vertical) {
                    composer2.startReplaceGroup(-1616959128);
                    ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                    PagerState pagerState6 = carouselState.getPagerState();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11 = composer2.consume(localLayoutDirection11);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    float fCalculateStartPadding6 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume11);
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume12 = composer2.consume(localLayoutDirection12);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    PagerKt.m1327VerticalPageroI3XNZo(pagerState6, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding6, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume12), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i17, Composer composer3, int i18) {
                            ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-817308503, i18, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3230invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i17, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i17), composer3, Integer.valueOf(i18 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2.startReplaceGroup(-1615314857);
                    composer2.endReplaceGroup();
                }
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            targetedFlingBehavior2 = targetedFlingBehavior3;
            f4 = f2;
        } else {
            composerStartRestartGroup.startDefaults();
            z = false;
            if ((i2 & 1) != 0) {
                if (i9 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i5 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior12 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                    i8 &= -29360129;
                    targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior12;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                }
                modifier3 = modifier2;
                f2 = f3;
            } else {
                if (i9 != 0) {
                    modifier2 = Modifier.INSTANCE;
                } else {
                    modifier2 = modifier;
                }
                if (i5 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    TargetedFlingBehavior targetedFlingBehaviorSingleAdvanceFlingBehavior13 = CarouselDefaults.INSTANCE.singleAdvanceFlingBehavior(carouselState, null, composerStartRestartGroup, (i8 & 14) | 384, 2);
                    i8 &= -29360129;
                    targetedFlingBehavior3 = targetedFlingBehaviorSingleAdvanceFlingBehavior13;
                } else {
                    targetedFlingBehavior3 = targetedFlingBehavior2;
                }
                modifier3 = modifier2;
                f2 = f3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2035733443, i8, -1, "androidx.compose.material3.carousel.Carousel (Carousel.kt:241)");
            }
            int i17 = ((i8 >> 9) & 14) | (i8 & 112);
            fCalculateBeforeContentPadding = calculateBeforeContentPadding(paddingValues, orientation, composerStartRestartGroup, i17);
            fCalculateAfterContentPadding = calculateAfterContentPadding(paddingValues, orientation, composerStartRestartGroup, i17);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2025986753, "CC(remember):Carousel.kt#9igjgp");
            if ((i8 & 896) == 256) {
                z = true;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new CarouselPageSize(function2, fCalculateBeforeContentPadding, fCalculateAfterContentPadding);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            carouselPageSize = (CarouselPageSize) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            snapPositionKeylineSnapPosition = KeylineSnapPositionKt.KeylineSnapPosition(carouselPageSize);
            if (orientation == Orientation.Horizontal) {
                composerStartRestartGroup.startReplaceGroup(-1618653092);
                ComposerKt.sourceInformation(composerStartRestartGroup, "266@12589L1014,252@11960L1643");
                composer2 = composerStartRestartGroup;
                PagerKt.m1326HorizontalPageroI3XNZo(carouselState.getPagerState(), modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(0.0f, paddingValues.getTop(), 0.0f, paddingValues.getBottom(), 5, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(687111200, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                        invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PagerScope pagerScope, int i18, Composer composer3, int i19) {
                        ComposerKt.sourceInformation(composer3, "C267@12634L35,268@12694L63,269@12786L389,286@13376L21,281@13189L404:Carousel.kt#dcf9yb");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(687111200, i19, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:267)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer3, -685906675, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue2 = composer3.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = new CarouselItemInfoImpl();
                            composer3.updateRememberedValue(objRememberedValue2);
                        }
                        final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerStart(composer3, -685904727, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue3 = composer3.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                            composer3.updateRememberedValue(objRememberedValue3);
                        }
                        CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerStart(composer3, -685901457, "CC(remember):Carousel.kt#9igjgp");
                        Object objRememberedValue4 = composer3.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = new Shape() {
                                @Override
                                public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                    return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue4);
                        }
                        CarouselKt$Carousel$1$clipShape$1$1 carouselKt$Carousel$1$clipShape$1$1 = (CarouselKt$Carousel$1$clipShape$1$1) objRememberedValue4;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        Modifier.Companion companion = Modifier.INSTANCE;
                        CarouselState carouselState2 = carouselState;
                        ComposerKt.sourceInformationMarkerStart(composer3, -685882945, "CC(remember):Carousel.kt#9igjgp");
                        boolean zChanged = composer3.changed(carouselPageSize);
                        final CarouselPageSize carouselPageSize2 = carouselPageSize;
                        Object objRememberedValue5 = composer3.rememberedValue();
                        if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                {
                                    super(0);
                                }

                                public final Strategy m3229invoke() {
                                    return carouselPageSize2.getStrategy();
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i18, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$1$clipShape$1$1);
                        Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer3.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer3.startReusableNode();
                        if (composer3.getInserting()) {
                            composer3.createNode(constructor);
                        } else {
                            composer3.useNode();
                        }
                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer3, 1112607687, "C291@13566L13:Carousel.kt#dcf9yb");
                        function5.invoke(carouselItemScopeImpl, Integer.valueOf(i18), composer3, Integer.valueOf(i19 & 112));
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        composer3.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                composer2.endReplaceGroup();
            } else {
                composer2 = composerStartRestartGroup;
                if (orientation == Orientation.Vertical) {
                    composer2.startReplaceGroup(-1616959128);
                    ComposerKt.sourceInformation(composer2, "300@13962L7,301@14054L7,309@14347L1014,295@13666L1695");
                    PagerState pagerState7 = carouselState.getPagerState();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume13 = composer2.consume(localLayoutDirection13);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    float fCalculateStartPadding7 = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume13);
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume14 = composer2.consume(localLayoutDirection14);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    PagerKt.m1327VerticalPageroI3XNZo(pagerState7, modifier3, PaddingKt.m1032PaddingValuesa9UjIt4$default(fCalculateStartPadding7, 0.0f, PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume14), 0.0f, 10, null), carouselPageSize, i, f2, null, targetedFlingBehavior3, false, false, null, null, snapPositionKeylineSnapPosition, ComposableLambdaKt.rememberComposableLambda(-817308503, true, new Function4<PagerScope, Integer, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                            invoke((PagerScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PagerScope pagerScope, int i18, Composer composer3, int i19) {
                            ComposerKt.sourceInformation(composer3, "C310@14392L35,311@14452L63,312@14544L389,329@15134L21,324@14947L404:Carousel.kt#dcf9yb");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-817308503, i19, -1, "androidx.compose.material3.carousel.Carousel.<anonymous> (Carousel.kt:310)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer3, -685850419, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue2 = composer3.rememberedValue();
                            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = new CarouselItemInfoImpl();
                                composer3.updateRememberedValue(objRememberedValue2);
                            }
                            final CarouselItemInfoImpl carouselItemInfoImpl = (CarouselItemInfoImpl) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685848471, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue3 = composer3.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new CarouselItemScopeImpl(carouselItemInfoImpl);
                                composer3.updateRememberedValue(objRememberedValue3);
                            }
                            CarouselItemScopeImpl carouselItemScopeImpl = (CarouselItemScopeImpl) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerStart(composer3, -685845201, "CC(remember):Carousel.kt#9igjgp");
                            Object objRememberedValue4 = composer3.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new Shape() {
                                    @Override
                                    public Outline mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
                                        return new Outline.Rectangle(carouselItemInfoImpl.getMaskRect());
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue4);
                            }
                            CarouselKt$Carousel$2$clipShape$1$1 carouselKt$Carousel$2$clipShape$1$1 = (CarouselKt$Carousel$2$clipShape$1$1) objRememberedValue4;
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            CarouselState carouselState2 = carouselState;
                            ComposerKt.sourceInformationMarkerStart(composer3, -685826689, "CC(remember):Carousel.kt#9igjgp");
                            boolean zChanged = composer3.changed(carouselPageSize);
                            final CarouselPageSize carouselPageSize2 = carouselPageSize;
                            Object objRememberedValue5 = composer3.rememberedValue();
                            if (zChanged || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Strategy>() {
                                    {
                                        super(0);
                                    }

                                    public final Strategy m3230invoke() {
                                        return carouselPageSize2.getStrategy();
                                    }
                                };
                                composer3.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            Modifier modifierCarouselItem = CarouselKt.carouselItem(companion, i18, carouselState2, (Function0) objRememberedValue5, carouselItemInfoImpl, carouselKt$Carousel$2$clipShape$1$1);
                            Function4<CarouselItemScope, Integer, Composer, Integer, Unit> function5 = function4;
                            ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierCarouselItem);
                            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composer3.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composer3.startReusableNode();
                            if (composer3.getInserting()) {
                                composer3.createNode(constructor);
                            } else {
                                composer3.useNode();
                            }
                            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer3, 1114351623, "C334@15324L13:Carousel.kt#dcf9yb");
                            function5.invoke(carouselItemScopeImpl, Integer.valueOf(i18), composer3, Integer.valueOf(i19 & 112));
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            composer3.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            ComposerKt.sourceInformationMarkerEnd(composer3);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, ((i8 >> 12) & 112) | (57344 & i8) | ((i8 >> 3) & 458752) | (29360128 & i8), 3072, 3904);
                    composer2.endReplaceGroup();
                } else {
                    composer2.startReplaceGroup(-1615314857);
                    composer2.endReplaceGroup();
                }
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            targetedFlingBehavior2 = targetedFlingBehavior3;
            f4 = f2;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier8 = modifier4;
            final float f8 = f4;
            final TargetedFlingBehavior targetedFlingBehavior7 = targetedFlingBehavior2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i18) {
                    CarouselKt.m3226CarouselV95POc(carouselState, orientation, function2, paddingValues, i, modifier8, f8, targetedFlingBehavior7, function4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    private static final float calculateBeforeContentPadding(PaddingValues paddingValues, Orientation orientation, Composer composer, int i) {
        float fCalculateStartPadding;
        ComposerKt.sourceInformationMarkerStart(composer, 1896839347, "C(calculateBeforeContentPadding)*349@15698L7:Carousel.kt#dcf9yb");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1896839347, i, -1, "androidx.compose.material3.carousel.calculateBeforeContentPadding (Carousel.kt:341)");
        }
        composer.startReplaceGroup(295830617);
        ComposerKt.sourceInformation(composer, "346@15649L7");
        if (orientation == Orientation.Vertical) {
            fCalculateStartPadding = paddingValues.getTop();
        } else {
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localLayoutDirection);
            ComposerKt.sourceInformationMarkerEnd(composer);
            fCalculateStartPadding = PaddingKt.calculateStartPadding(paddingValues, (LayoutDirection) objConsume);
        }
        composer.endReplaceGroup();
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        float f = ((Density) objConsume2).toPx-0680j_4(fCalculateStartPadding);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return f;
    }

    private static final float calculateAfterContentPadding(PaddingValues paddingValues, Orientation orientation, Composer composer, int i) {
        float fCalculateEndPadding;
        ComposerKt.sourceInformationMarkerStart(composer, 1018496720, "C(calculateAfterContentPadding)*361@16056L7:Carousel.kt#dcf9yb");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1018496720, i, -1, "androidx.compose.material3.carousel.calculateAfterContentPadding (Carousel.kt:353)");
        }
        composer.startReplaceGroup(-587616383);
        ComposerKt.sourceInformation(composer, "358@16007L7");
        if (orientation == Orientation.Vertical) {
            fCalculateEndPadding = paddingValues.getBottom();
        } else {
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localLayoutDirection);
            ComposerKt.sourceInformationMarkerEnd(composer);
            fCalculateEndPadding = PaddingKt.calculateEndPadding(paddingValues, (LayoutDirection) objConsume);
        }
        composer.endReplaceGroup();
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        float f = ((Density) objConsume2).toPx-0680j_4(fCalculateEndPadding);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return f;
    }

    public static final Modifier carouselItem(Modifier modifier, final int i, final CarouselState carouselState, final Function0<Strategy> function0, final CarouselItemInfoImpl carouselItemInfoImpl, final Shape shape) {
        return LayoutModifierKt.layout(modifier, new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return m3231invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
            }

            public final MeasureResult m3231invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                long j2;
                final Strategy strategy = (Strategy) function0.invoke();
                if (!strategy.getIsValid()) {
                    return MeasureScope.CC.layout$default(measureScope, 0, 0, null, new Function1<Placeable.PlacementScope, Unit>() {
                        public final void invoke(Placeable.PlacementScope placementScope) {
                        }

                        public Object invoke(Object obj) {
                            invoke((Placeable.PlacementScope) obj);
                            return Unit.INSTANCE;
                        }
                    }, 4, null);
                }
                final boolean z = carouselState.getPagerState().getLayoutInfo().getOrientation() == Orientation.Vertical;
                final boolean z2 = measureScope.getLayoutDirection() == LayoutDirection.Rtl;
                float itemMainAxisSize = strategy.getItemMainAxisSize();
                if (z) {
                    j2 = Constraints.copy-Zbe2FdA(j, Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(j), MathKt.roundToInt(itemMainAxisSize), MathKt.roundToInt(itemMainAxisSize));
                } else {
                    j2 = Constraints.copy-Zbe2FdA(j, MathKt.roundToInt(itemMainAxisSize), MathKt.roundToInt(itemMainAxisSize), Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j));
                }
                final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j2);
                int width = placeableMo6026measureBRTryo0.getWidth();
                int height = placeableMo6026measureBRTryo0.getHeight();
                final CarouselState carouselState2 = carouselState;
                final int i2 = i;
                final CarouselItemInfoImpl carouselItemInfoImpl2 = carouselItemInfoImpl;
                final Shape shape2 = shape;
                return MeasureScope.CC.layout$default(measureScope, width, height, null, new Function1<Placeable.PlacementScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable.PlacementScope placementScope) {
                        Placeable placeable = placeableMo6026measureBRTryo0;
                        final CarouselState carouselState3 = carouselState2;
                        final Strategy strategy2 = strategy;
                        final int i3 = i2;
                        final boolean z3 = z;
                        final CarouselItemInfoImpl carouselItemInfoImpl3 = carouselItemInfoImpl2;
                        final Shape shape3 = shape2;
                        final boolean z4 = z2;
                        Placeable.PlacementScope.placeWithLayer$default(placementScope, placeable, 0, 0, 0.0f, new Function1<GraphicsLayerScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((GraphicsLayerScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                                float fCalculateCurrentScrollOffset = CarouselKt.calculateCurrentScrollOffset(carouselState3, strategy2);
                                float fCalculateMaxScrollOffset = CarouselKt.calculateMaxScrollOffset(carouselState3, strategy2);
                                KeylineList keylineListForScrollOffset$material3_release$default = Strategy.getKeylineListForScrollOffset$material3_release$default(strategy2, fCalculateCurrentScrollOffset, fCalculateMaxScrollOffset, false, 4, null);
                                KeylineList keylineListForScrollOffset$material3_release = strategy2.getKeylineListForScrollOffset$material3_release(fCalculateCurrentScrollOffset, fCalculateMaxScrollOffset, true);
                                float itemMainAxisSize2 = ((i3 * (strategy2.getItemMainAxisSize() + strategy2.getItemSpacing())) + (strategy2.getItemMainAxisSize() / 2.0f)) - fCalculateCurrentScrollOffset;
                                Keyline keylineBefore = keylineListForScrollOffset$material3_release$default.getKeylineBefore(itemMainAxisSize2);
                                Keyline keylineAfter = keylineListForScrollOffset$material3_release$default.getKeylineAfter(itemMainAxisSize2);
                                Keyline keylineLerp = KeylineListKt.lerp(keylineBefore, keylineAfter, CarouselKt.getProgress(keylineBefore, keylineAfter, itemMainAxisSize2));
                                boolean zAreEqual = Intrinsics.areEqual(keylineBefore, keylineAfter);
                                float fM4412getHeightimpl = (z3 ? Size.m4412getHeightimpl(graphicsLayerScope.getSize()) : strategy2.getItemMainAxisSize()) / 2.0f;
                                float itemMainAxisSize3 = (z3 ? strategy2.getItemMainAxisSize() : Size.m4412getHeightimpl(graphicsLayerScope.getSize())) / 2.0f;
                                float fM4415getWidthimpl = (z3 ? Size.m4415getWidthimpl(graphicsLayerScope.getSize()) : keylineLerp.getSize()) / 2.0f;
                                float size = (z3 ? keylineLerp.getSize() : Size.m4412getHeightimpl(graphicsLayerScope.getSize())) / 2.0f;
                                Rect rect = new Rect(fM4412getHeightimpl - fM4415getWidthimpl, itemMainAxisSize3 - size, fM4412getHeightimpl + fM4415getWidthimpl, itemMainAxisSize3 + size);
                                carouselItemInfoImpl3.setSizeState(keylineLerp.getSize());
                                CarouselItemInfoImpl carouselItemInfoImpl4 = carouselItemInfoImpl3;
                                Iterator<Keyline> it = keylineListForScrollOffset$material3_release.iterator();
                                if (!it.hasNext()) {
                                    throw new NoSuchElementException();
                                }
                                Keyline next = it.next();
                                if (it.hasNext()) {
                                    float size2 = next.getSize();
                                    do {
                                        Keyline next2 = it.next();
                                        float size3 = next2.getSize();
                                        if (Float.compare(size2, size3) > 0) {
                                            next = next2;
                                            size2 = size3;
                                        }
                                    } while (it.hasNext());
                                }
                                carouselItemInfoImpl4.setMinSizeState(next.getSize());
                                carouselItemInfoImpl3.setMaxSizeState(keylineListForScrollOffset$material3_release.getFirstFocal().getSize());
                                carouselItemInfoImpl3.setMaskRectState(rect);
                                graphicsLayerScope.setClip(!Intrinsics.areEqual(rect, new Rect(0.0f, 0.0f, Size.m4415getWidthimpl(graphicsLayerScope.getSize()), Size.m4412getHeightimpl(graphicsLayerScope.getSize()))));
                                graphicsLayerScope.setShape(shape3);
                                float offset = keylineLerp.getOffset() - itemMainAxisSize2;
                                if (zAreEqual) {
                                    offset += (itemMainAxisSize2 - keylineLerp.getUnadjustedOffset()) / keylineLerp.getSize();
                                }
                                if (z3) {
                                    graphicsLayerScope.setTranslationY(offset);
                                    return;
                                }
                                if (z4) {
                                    offset = -offset;
                                }
                                graphicsLayerScope.setTranslationX(offset);
                            }
                        }, 4, (Object) null);
                    }
                }, 4, null);
            }
        });
    }

    public static final float calculateCurrentScrollOffset(CarouselState carouselState, Strategy strategy) {
        float itemMainAxisSize = strategy.getItemMainAxisSize() + strategy.getItemSpacing();
        return ((carouselState.getPagerState().getCurrentPage() * itemMainAxisSize) + (carouselState.getPagerState().getCurrentPageOffsetFraction() * itemMainAxisSize)) - KeylineSnapPositionKt.getSnapPositionOffset(strategy, carouselState.getPagerState().getCurrentPage(), carouselState.getPagerState().getPageCount());
    }

    public static final float calculateMaxScrollOffset(CarouselState carouselState, Strategy strategy) {
        float pageCount = carouselState.getPagerState().getPageCount();
        return RangesKt.coerceAtLeast(((strategy.getItemMainAxisSize() * pageCount) + (strategy.getItemSpacing() * (pageCount - 1))) - strategy.getAvailableSpace(), 0.0f);
    }

    public static final float getProgress(Keyline keyline, Keyline keyline2, float f) {
        if (Intrinsics.areEqual(keyline, keyline2)) {
            return 1.0f;
        }
        return (f - keyline.getUnadjustedOffset()) / (keyline2.getUnadjustedOffset() - keyline.getUnadjustedOffset());
    }
}
