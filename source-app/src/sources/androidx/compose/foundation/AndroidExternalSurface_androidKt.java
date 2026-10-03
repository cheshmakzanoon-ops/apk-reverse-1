package androidx.compose.foundation;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.view.SurfaceView;
import android.view.TextureView;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.AndroidMatrixConversions_androidKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.viewinterop.AndroidView_androidKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000H\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001aU\u0010\u0000\u001a\u00020\u00012\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t2\u0017\u0010\n\u001a\u0013\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00010\u000b¢\u0006\u0002\b\rH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000f\u001a]\u0010\u0010\u001a\u00020\u00012\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\u0011\u001a\u00020\u00122\b\b\u0002\u0010\u0013\u001a\u00020\u00052\u0017\u0010\n\u001a\u0013\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00010\u000b¢\u0006\u0002\b\rH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\u0015\u001a\r\u0010\u0016\u001a\u00020\u0017H\u0003¢\u0006\u0002\u0010\u0018\u001a\r\u0010\u0019\u001a\u00020\u001aH\u0003¢\u0006\u0002\u0010\u001b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001c"}, d2 = {"AndroidEmbeddedExternalSurface", "", "modifier", "Landroidx/compose/ui/Modifier;", "isOpaque", "", "surfaceSize", "Landroidx/compose/ui/unit/IntSize;", "transform", "Landroidx/compose/ui/graphics/Matrix;", "onInit", "Lkotlin/Function1;", "Landroidx/compose/foundation/AndroidExternalSurfaceScope;", "Lkotlin/ExtensionFunctionType;", "AndroidEmbeddedExternalSurface-sv6N_fY", "(Landroidx/compose/ui/Modifier;ZJ[FLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "AndroidExternalSurface", "zOrder", "Landroidx/compose/foundation/AndroidExternalSurfaceZOrder;", "isSecure", "AndroidExternalSurface-58FFMhA", "(Landroidx/compose/ui/Modifier;ZJIZLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "rememberAndroidEmbeddedExternalSurfaceState", "Landroidx/compose/foundation/AndroidEmbeddedExternalSurfaceState;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/AndroidEmbeddedExternalSurfaceState;", "rememberAndroidExternalSurfaceState", "Landroidx/compose/foundation/AndroidExternalSurfaceState;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/AndroidExternalSurfaceState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidExternalSurface_androidKt {
    private static final AndroidExternalSurfaceState rememberAndroidExternalSurfaceState(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -873615933, "C(rememberAndroidExternalSurfaceState)190@7150L24,191@7186L47:AndroidExternalSurface.android.kt#71ulvw");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-873615933, i, -1, "androidx.compose.foundation.rememberAndroidExternalSurfaceState (AndroidExternalSurface.android.kt:189)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
        ComposerKt.sourceInformationMarkerStart(composer, -954367824, "CC(remember):Effects.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composer));
            composer.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
            objRememberedValue = compositionScopedCoroutineScopeCanceller;
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 1983762950, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
        Object objRememberedValue2 = composer.rememberedValue();
        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = new AndroidExternalSurfaceState(coroutineScope);
            composer.updateRememberedValue(objRememberedValue2);
        }
        AndroidExternalSurfaceState androidExternalSurfaceState = (AndroidExternalSurfaceState) objRememberedValue2;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return androidExternalSurfaceState;
    }

    public static final void m517AndroidExternalSurface58FFMhA(Modifier modifier, boolean z, long j, int i, boolean z2, final Function1<? super AndroidExternalSurfaceScope, Unit> function1, Composer composer, final int i2, final int i3) {
        Modifier modifier2;
        int i4;
        boolean z3;
        long j2;
        int i5;
        int iM513getBehindB_4ceCc;
        int i6;
        int i7;
        boolean z4;
        int i8;
        int i9;
        Modifier.Companion companion;
        boolean z5;
        boolean z6;
        final int i10;
        int i11;
        final long j3;
        final AndroidExternalSurfaceState androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
        boolean z7;
        boolean zChangedInstance;
        Object objRememberedValue;
        boolean z8;
        boolean z9;
        boolean z10;
        Object objRememberedValue2;
        final long j4;
        final int i12;
        final boolean z11;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i13;
        Composer composerStartRestartGroup = composer.startRestartGroup(640888974);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AndroidExternalSurface)P(2!1,4:c#ui.unit.IntSize,5:c#foundation.AndroidExternalSurfaceZOrder)288@12167L37,291@12241L150,299@12462L774,290@12210L1032:AndroidExternalSurface.android.kt#71ulvw");
        int i14 = i3 & 1;
        if (i14 != 0) {
            i4 = i2 | 6;
            modifier2 = modifier;
        } else if ((i2 & 6) == 0) {
            modifier2 = modifier;
            i4 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i2;
        } else {
            modifier2 = modifier;
            i4 = i2;
        }
        int i15 = i3 & 2;
        if (i15 == 0) {
            if ((i2 & 48) == 0) {
                z3 = z;
                i4 |= composerStartRestartGroup.changed(z3) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                j2 = j;
                if ((i3 & 4) == 0 || !composerStartRestartGroup.changed(j2)) {
                    i13 = Fields.SpotShadowColor;
                } else {
                    i13 = Fields.RotationX;
                }
                i4 |= i13;
            } else {
                j2 = j;
            }
            i5 = i3 & 8;
            if (i5 != 0) {
                if ((i2 & 3072) == 0) {
                    iM513getBehindB_4ceCc = i;
                    if (composerStartRestartGroup.changed(iM513getBehindB_4ceCc)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i4 |= i6;
                }
                i7 = i3 & 16;
                if (i7 != 0) {
                    if ((i2 & 24576) == 0) {
                        z4 = z2;
                        if (composerStartRestartGroup.changed(z4)) {
                            i8 = Fields.Clip;
                        } else {
                            i8 = Fields.Shape;
                        }
                        i4 |= i8;
                    }
                    if ((i3 & 32) != 0) {
                        i4 |= 196608;
                    } else if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i4 |= i9;
                    }
                    if ((i4 & 74899) == 74898 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i14 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i15 != 0) {
                                z3 = true;
                            }
                            if ((i3 & 4) != 0) {
                                i4 &= -897;
                                j2 = IntSize.Companion.getZero-YbymL2g();
                            }
                            if (i5 != 0) {
                                iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                            }
                            z5 = z3;
                            if (i7 != 0) {
                                z6 = false;
                            }
                            i10 = iM513getBehindB_4ceCc;
                            i11 = i4;
                            j3 = j2;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                            }
                            androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                            if ((458752 & i11) == 131072) {
                                z7 = true;
                            } else {
                                z7 = false;
                            }
                            zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!zChangedInstance || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                                    {
                                        super(1);
                                    }

                                    public final SurfaceView invoke(Context context) {
                                        SurfaceView surfaceView = new SurfaceView(context);
                                        Function1<AndroidExternalSurfaceScope, Unit> function2 = function1;
                                        AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                        function2.invoke(androidExternalSurfaceState);
                                        surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                        return surfaceView;
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            Function1 function2 = (Function1) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$2 = new Function1<SurfaceView, Unit>() {
                                public final void invoke(SurfaceView surfaceView) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((SurfaceView) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                            boolean z12 = (((i11 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(j3)) || (i11 & 384) == 256;
                            if ((i11 & 112) == 32) {
                                z8 = true;
                            } else {
                                z8 = false;
                            }
                            boolean z13 = z12 | z8;
                            if ((i11 & 7168) == 2048) {
                                z9 = true;
                            } else {
                                z9 = false;
                            }
                            z10 = z13 | z9 | ((57344 & i11) == 16384);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z10 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                final boolean z14 = z5;
                                final boolean z15 = z6;
                                objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SurfaceView) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(SurfaceView surfaceView) {
                                        if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                            surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                        } else {
                                            surfaceView.getHolder().setSizeFromLayout();
                                        }
                                        surfaceView.getHolder().setFormat(z14 ? -1 : -3);
                                        int i16 = i10;
                                        if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                            surfaceView.setZOrderOnTop(false);
                                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                            surfaceView.setZOrderMediaOverlay(true);
                                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                            surfaceView.setZOrderOnTop(true);
                                        }
                                        surfaceView.setSecure(z15);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            AndroidView_androidKt.AndroidView(function2, companion, androidExternalSurface_androidKt$AndroidExternalSurface$2, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            z3 = z5;
                            j4 = j3;
                            i12 = i10;
                            z11 = z6;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 4) != 0) {
                                i4 &= -897;
                            }
                            companion = modifier2;
                            z5 = z3;
                        }
                        z6 = z4;
                        i10 = iM513getBehindB_4ceCc;
                        i11 = i4;
                        j3 = j2;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                        }
                        androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                        if ((458752 & i11) == 131072) {
                            z7 = true;
                        } else {
                            z7 = false;
                        }
                        zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!zChangedInstance) {
                            objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                                {
                                    super(1);
                                }

                                public final SurfaceView invoke(Context context) {
                                    SurfaceView surfaceView = new SurfaceView(context);
                                    Function1<AndroidExternalSurfaceScope, Unit> function3 = function1;
                                    AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                    function3.invoke(androidExternalSurfaceState);
                                    surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                    return surfaceView;
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                                {
                                    super(1);
                                }

                                public final SurfaceView invoke(Context context) {
                                    SurfaceView surfaceView = new SurfaceView(context);
                                    Function1<AndroidExternalSurfaceScope, Unit> function3 = function1;
                                    AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                    function3.invoke(androidExternalSurfaceState);
                                    surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                    return surfaceView;
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        Function1 function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$3 = new Function1<SurfaceView, Unit>() {
                            public final void invoke(SurfaceView surfaceView) {
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }
                        };
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                        if (((i11 & 896) ^ 384) <= 256) {
                        }
                        if ((i11 & 112) == 32) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        boolean z16 = z12 | z8;
                        if ((i11 & 7168) == 2048) {
                            z9 = true;
                        } else {
                            z9 = false;
                        }
                        z10 = z16 | z9 | ((57344 & i11) == 16384);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z10) {
                            final boolean z17 = z5;
                            final boolean z18 = z6;
                            objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((SurfaceView) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SurfaceView surfaceView) {
                                    if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                        surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                    } else {
                                        surfaceView.getHolder().setSizeFromLayout();
                                    }
                                    surfaceView.getHolder().setFormat(z17 ? -1 : -3);
                                    int i16 = i10;
                                    if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                        surfaceView.setZOrderOnTop(false);
                                    } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                        surfaceView.setZOrderMediaOverlay(true);
                                    } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                        surfaceView.setZOrderOnTop(true);
                                    }
                                    surfaceView.setSecure(z18);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final boolean z19 = z5;
                            final boolean z110 = z6;
                            objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((SurfaceView) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SurfaceView surfaceView) {
                                    if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                        surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                    } else {
                                        surfaceView.getHolder().setSizeFromLayout();
                                    }
                                    surfaceView.getHolder().setFormat(z19 ? -1 : -3);
                                    int i16 = i10;
                                    if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                        surfaceView.setZOrderOnTop(false);
                                    } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                        surfaceView.setZOrderMediaOverlay(true);
                                    } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                        surfaceView.setZOrderOnTop(true);
                                    }
                                    surfaceView.setSecure(z110);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        AndroidView_androidKt.AndroidView(function3, companion, androidExternalSurface_androidKt$AndroidExternalSurface$3, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z5;
                        j4 = j3;
                        i12 = i10;
                        z11 = z6;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        companion = modifier2;
                        j4 = j2;
                        z11 = z4;
                        i12 = iM513getBehindB_4ceCc;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = companion;
                        final boolean z20 = z3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i16) {
                                AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier3, z20, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                z4 = z2;
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function4 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function4.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function4 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function4.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function4 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$4 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z111 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z111 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z112 = z5;
                        final boolean z113 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z112 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z113);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z114 = z5;
                        final boolean z115 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z114 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z115);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function4, companion, androidExternalSurface_androidKt$AndroidExternalSurface$4, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function5 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function5.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function5 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function5.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function5 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$5 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z116 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z116 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z117 = z5;
                        final boolean z118 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z117 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z118);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z119 = z5;
                        final boolean z1110 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z119 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z1110);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function5, companion, androidExternalSurface_androidKt$AndroidExternalSurface$5, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = companion;
                    final boolean z21 = z3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier4, z21, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            iM513getBehindB_4ceCc = i;
            i7 = i3 & 16;
            if (i7 != 0) {
                if ((i2 & 24576) == 0) {
                    z4 = z2;
                    if (composerStartRestartGroup.changed(z4)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i4 |= i8;
                }
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function6 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function6.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function6 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function6.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function6 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$6 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z1111 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z1111 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z1112 = z5;
                        final boolean z1113 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z1112 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z1113);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z1114 = z5;
                        final boolean z1115 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z1114 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z1115);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function6, companion, androidExternalSurface_androidKt$AndroidExternalSurface$6, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function7 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function7.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function7 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function7.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function7 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$7 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z1116 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z1116 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z1117 = z5;
                        final boolean z1118 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z1117 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z1118);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z1119 = z5;
                        final boolean z11110 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z1119 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z11110);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function7, companion, androidExternalSurface_androidKt$AndroidExternalSurface$7, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = companion;
                    final boolean z22 = z3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier5, z22, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            z4 = z2;
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function8 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function8.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function8 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function8.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function8 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$8 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z11111 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z11111 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z11112 = z5;
                    final boolean z11113 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11112 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11113);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z11114 = z5;
                    final boolean z11115 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11114 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11115);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function8, companion, androidExternalSurface_androidKt$AndroidExternalSurface$8, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function9 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function9.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function9 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function9.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function9 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$9 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z11116 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z11116 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z11117 = z5;
                    final boolean z11118 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11117 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11118);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z11119 = z5;
                    final boolean z111110 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11119 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z111110);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function9, companion, androidExternalSurface_androidKt$AndroidExternalSurface$9, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = companion;
                final boolean z23 = z3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier6, z23, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        z3 = z;
        if ((i2 & 384) == 0) {
            j2 = j;
            if ((i3 & 4) == 0) {
                i13 = Fields.SpotShadowColor;
            } else {
                i13 = Fields.SpotShadowColor;
            }
            i4 |= i13;
        } else {
            j2 = j;
        }
        i5 = i3 & 8;
        if (i5 != 0) {
            if ((i2 & 3072) == 0) {
                iM513getBehindB_4ceCc = i;
                if (composerStartRestartGroup.changed(iM513getBehindB_4ceCc)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i4 |= i6;
            }
            i7 = i3 & 16;
            if (i7 != 0) {
                if ((i2 & 24576) == 0) {
                    z4 = z2;
                    if (composerStartRestartGroup.changed(z4)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i4 |= i8;
                }
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function10 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function10.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function10 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function10.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function10 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$10 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z111111 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z111111 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z111112 = z5;
                        final boolean z111113 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z111112 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z111113);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z111114 = z5;
                        final boolean z111115 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z111114 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z111115);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function10, companion, androidExternalSurface_androidKt$AndroidExternalSurface$10, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    } else {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i15 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            j2 = IntSize.Companion.getZero-YbymL2g();
                        }
                        if (i5 != 0) {
                            iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                        }
                        z5 = z3;
                        if (i7 != 0) {
                            z6 = false;
                        } else {
                            z6 = z4;
                        }
                    }
                    i10 = iM513getBehindB_4ceCc;
                    i11 = i4;
                    j3 = j2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                    }
                    androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if ((458752 & i11) == 131072) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance) {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function11 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function11.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                            {
                                super(1);
                            }

                            public final SurfaceView invoke(Context context) {
                                SurfaceView surfaceView = new SurfaceView(context);
                                Function1<AndroidExternalSurfaceScope, Unit> function11 = function1;
                                AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                                function11.invoke(androidExternalSurfaceState);
                                surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                                return surfaceView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function11 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$11 = new Function1<SurfaceView, Unit>() {
                        public final void invoke(SurfaceView surfaceView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    if (((i11 & 896) ^ 384) <= 256) {
                    }
                    if ((i11 & 112) == 32) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    boolean z111116 = z12 | z8;
                    if ((i11 & 7168) == 2048) {
                        z9 = true;
                    } else {
                        z9 = false;
                    }
                    z10 = z111116 | z9 | ((57344 & i11) == 16384);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z10) {
                        final boolean z111117 = z5;
                        final boolean z111118 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z111117 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z111118);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final boolean z111119 = z5;
                        final boolean z1111110 = z6;
                        objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SurfaceView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SurfaceView surfaceView) {
                                if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                    surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                                } else {
                                    surfaceView.getHolder().setSizeFromLayout();
                                }
                                surfaceView.getHolder().setFormat(z111119 ? -1 : -3);
                                int i16 = i10;
                                if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(false);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                    surfaceView.setZOrderMediaOverlay(true);
                                } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                    surfaceView.setZOrderOnTop(true);
                                }
                                surfaceView.setSecure(z1111110);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function11, companion, androidExternalSurface_androidKt$AndroidExternalSurface$11, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z5;
                    j4 = j3;
                    i12 = i10;
                    z11 = z6;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = companion;
                    final boolean z24 = z3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier7, z24, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            z4 = z2;
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function12 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function12.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function12 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function12.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function12 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$12 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z1111111 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z1111111 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z1111112 = z5;
                    final boolean z1111113 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z1111112 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z1111113);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z1111114 = z5;
                    final boolean z1111115 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z1111114 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z1111115);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function12, companion, androidExternalSurface_androidKt$AndroidExternalSurface$12, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function13 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function13.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function13 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function13.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function13 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$13 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z1111116 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z1111116 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z1111117 = z5;
                    final boolean z1111118 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z1111117 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z1111118);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z1111119 = z5;
                    final boolean z11111110 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z1111119 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11111110);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function13, companion, androidExternalSurface_androidKt$AndroidExternalSurface$13, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = companion;
                final boolean z25 = z3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier8, z25, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        iM513getBehindB_4ceCc = i;
        i7 = i3 & 16;
        if (i7 != 0) {
            if ((i2 & 24576) == 0) {
                z4 = z2;
                if (composerStartRestartGroup.changed(z4)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i4 |= i8;
            }
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function14 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function14.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function14 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function14.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function14 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$14 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z11111111 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z11111111 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z11111112 = z5;
                    final boolean z11111113 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11111112 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11111113);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z11111114 = z5;
                    final boolean z11111115 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11111114 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11111115);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function14, companion, androidExternalSurface_androidKt$AndroidExternalSurface$14, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i15 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        j2 = IntSize.Companion.getZero-YbymL2g();
                    }
                    if (i5 != 0) {
                        iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                    }
                    z5 = z3;
                    if (i7 != 0) {
                        z6 = false;
                    } else {
                        z6 = z4;
                    }
                }
                i10 = iM513getBehindB_4ceCc;
                i11 = i4;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
                }
                androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if ((458752 & i11) == 131072) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function15 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function15.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                        {
                            super(1);
                        }

                        public final SurfaceView invoke(Context context) {
                            SurfaceView surfaceView = new SurfaceView(context);
                            Function1<AndroidExternalSurfaceScope, Unit> function15 = function1;
                            AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                            function15.invoke(androidExternalSurfaceState);
                            surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                            return surfaceView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function15 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$15 = new Function1<SurfaceView, Unit>() {
                    public final void invoke(SurfaceView surfaceView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                if (((i11 & 896) ^ 384) <= 256) {
                }
                if ((i11 & 112) == 32) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                boolean z11111116 = z12 | z8;
                if ((i11 & 7168) == 2048) {
                    z9 = true;
                } else {
                    z9 = false;
                }
                z10 = z11111116 | z9 | ((57344 & i11) == 16384);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z10) {
                    final boolean z11111117 = z5;
                    final boolean z11111118 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11111117 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z11111118);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final boolean z11111119 = z5;
                    final boolean z111111110 = z6;
                    objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SurfaceView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SurfaceView surfaceView) {
                            if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                                surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                            } else {
                                surfaceView.getHolder().setSizeFromLayout();
                            }
                            surfaceView.getHolder().setFormat(z11111119 ? -1 : -3);
                            int i16 = i10;
                            if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                                surfaceView.setZOrderOnTop(false);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                                surfaceView.setZOrderMediaOverlay(true);
                            } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                                surfaceView.setZOrderOnTop(true);
                            }
                            surfaceView.setSecure(z111111110);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function15, companion, androidExternalSurface_androidKt$AndroidExternalSurface$15, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z5;
                j4 = j3;
                i12 = i10;
                z11 = z6;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = companion;
                final boolean z26 = z3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier9, z26, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        z4 = z2;
        if ((i3 & 32) != 0) {
            i4 |= 196608;
        } else if ((i2 & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
                i9 = Fields.RenderEffect;
            } else {
                i9 = 65536;
            }
            i4 |= i9;
        }
        if ((i4 & 74899) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i15 != 0) {
                    z3 = true;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    j2 = IntSize.Companion.getZero-YbymL2g();
                }
                if (i5 != 0) {
                    iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                }
                z5 = z3;
                if (i7 != 0) {
                    z6 = false;
                } else {
                    z6 = z4;
                }
            } else {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i15 != 0) {
                    z3 = true;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    j2 = IntSize.Companion.getZero-YbymL2g();
                }
                if (i5 != 0) {
                    iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                }
                z5 = z3;
                if (i7 != 0) {
                    z6 = false;
                } else {
                    z6 = z4;
                }
            }
            i10 = iM513getBehindB_4ceCc;
            i11 = i4;
            j3 = j2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
            }
            androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            if ((458752 & i11) == 131072) {
                z7 = true;
            } else {
                z7 = false;
            }
            zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                    {
                        super(1);
                    }

                    public final SurfaceView invoke(Context context) {
                        SurfaceView surfaceView = new SurfaceView(context);
                        Function1<AndroidExternalSurfaceScope, Unit> function16 = function1;
                        AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                        function16.invoke(androidExternalSurfaceState);
                        surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                        return surfaceView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                    {
                        super(1);
                    }

                    public final SurfaceView invoke(Context context) {
                        SurfaceView surfaceView = new SurfaceView(context);
                        Function1<AndroidExternalSurfaceScope, Unit> function16 = function1;
                        AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                        function16.invoke(androidExternalSurfaceState);
                        surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                        return surfaceView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function1 function16 = (Function1) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$16 = new Function1<SurfaceView, Unit>() {
                public final void invoke(SurfaceView surfaceView) {
                }

                public Object invoke(Object obj) {
                    invoke((SurfaceView) obj);
                    return Unit.INSTANCE;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            if (((i11 & 896) ^ 384) <= 256) {
            }
            if ((i11 & 112) == 32) {
                z8 = true;
            } else {
                z8 = false;
            }
            boolean z111111111 = z12 | z8;
            if ((i11 & 7168) == 2048) {
                z9 = true;
            } else {
                z9 = false;
            }
            z10 = z111111111 | z9 | ((57344 & i11) == 16384);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z10) {
                final boolean z111111112 = z5;
                final boolean z111111113 = z6;
                objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SurfaceView surfaceView) {
                        if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                            surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                        } else {
                            surfaceView.getHolder().setSizeFromLayout();
                        }
                        surfaceView.getHolder().setFormat(z111111112 ? -1 : -3);
                        int i16 = i10;
                        if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                            surfaceView.setZOrderOnTop(false);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                            surfaceView.setZOrderMediaOverlay(true);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                            surfaceView.setZOrderOnTop(true);
                        }
                        surfaceView.setSecure(z111111113);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final boolean z111111114 = z5;
                final boolean z111111115 = z6;
                objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SurfaceView surfaceView) {
                        if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                            surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                        } else {
                            surfaceView.getHolder().setSizeFromLayout();
                        }
                        surfaceView.getHolder().setFormat(z111111114 ? -1 : -3);
                        int i16 = i10;
                        if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                            surfaceView.setZOrderOnTop(false);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                            surfaceView.setZOrderMediaOverlay(true);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                            surfaceView.setZOrderOnTop(true);
                        }
                        surfaceView.setSecure(z111111115);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidView_androidKt.AndroidView(function16, companion, androidExternalSurface_androidKt$AndroidExternalSurface$16, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z3 = z5;
            j4 = j3;
            i12 = i10;
            z11 = z6;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i15 != 0) {
                    z3 = true;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    j2 = IntSize.Companion.getZero-YbymL2g();
                }
                if (i5 != 0) {
                    iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                }
                z5 = z3;
                if (i7 != 0) {
                    z6 = false;
                } else {
                    z6 = z4;
                }
            } else {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i15 != 0) {
                    z3 = true;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    j2 = IntSize.Companion.getZero-YbymL2g();
                }
                if (i5 != 0) {
                    iM513getBehindB_4ceCc = AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc();
                }
                z5 = z3;
                if (i7 != 0) {
                    z6 = false;
                } else {
                    z6 = z4;
                }
            }
            i10 = iM513getBehindB_4ceCc;
            i11 = i4;
            j3 = j2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(640888974, i11, -1, "androidx.compose.foundation.AndroidExternalSurface (AndroidExternalSurface.android.kt:287)");
            }
            androidExternalSurfaceStateRememberAndroidExternalSurfaceState = rememberAndroidExternalSurfaceState(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356109309, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            if ((458752 & i11) == 131072) {
                z7 = true;
            } else {
                z7 = false;
            }
            zChangedInstance = z7 | composerStartRestartGroup.changedInstance(androidExternalSurfaceStateRememberAndroidExternalSurfaceState);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                    {
                        super(1);
                    }

                    public final SurfaceView invoke(Context context) {
                        SurfaceView surfaceView = new SurfaceView(context);
                        Function1<AndroidExternalSurfaceScope, Unit> function17 = function1;
                        AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                        function17.invoke(androidExternalSurfaceState);
                        surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                        return surfaceView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<Context, SurfaceView>() {
                    {
                        super(1);
                    }

                    public final SurfaceView invoke(Context context) {
                        SurfaceView surfaceView = new SurfaceView(context);
                        Function1<AndroidExternalSurfaceScope, Unit> function17 = function1;
                        AndroidExternalSurfaceState androidExternalSurfaceState = androidExternalSurfaceStateRememberAndroidExternalSurfaceState;
                        function17.invoke(androidExternalSurfaceState);
                        surfaceView.getHolder().addCallback(androidExternalSurfaceState);
                        return surfaceView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function1 function17 = (Function1) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidExternalSurface_androidKt$AndroidExternalSurface$2 androidExternalSurface_androidKt$AndroidExternalSurface$17 = new Function1<SurfaceView, Unit>() {
                public final void invoke(SurfaceView surfaceView) {
                }

                public Object invoke(Object obj) {
                    invoke((SurfaceView) obj);
                    return Unit.INSTANCE;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1356101613, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            if (((i11 & 896) ^ 384) <= 256) {
            }
            if ((i11 & 112) == 32) {
                z8 = true;
            } else {
                z8 = false;
            }
            boolean z111111116 = z12 | z8;
            if ((i11 & 7168) == 2048) {
                z9 = true;
            } else {
                z9 = false;
            }
            z10 = z111111116 | z9 | ((57344 & i11) == 16384);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z10) {
                final boolean z111111117 = z5;
                final boolean z111111118 = z6;
                objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SurfaceView surfaceView) {
                        if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                            surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                        } else {
                            surfaceView.getHolder().setSizeFromLayout();
                        }
                        surfaceView.getHolder().setFormat(z111111117 ? -1 : -3);
                        int i16 = i10;
                        if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                            surfaceView.setZOrderOnTop(false);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                            surfaceView.setZOrderMediaOverlay(true);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                            surfaceView.setZOrderOnTop(true);
                        }
                        surfaceView.setSecure(z111111118);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final boolean z111111119 = z5;
                final boolean z1111111110 = z6;
                objRememberedValue2 = (Function1) new Function1<SurfaceView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SurfaceView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SurfaceView surfaceView) {
                        if (!IntSize.equals-impl0(j3, IntSize.Companion.getZero-YbymL2g())) {
                            surfaceView.getHolder().setFixedSize(IntSize.getWidth-impl(j3), IntSize.getHeight-impl(j3));
                        } else {
                            surfaceView.getHolder().setSizeFromLayout();
                        }
                        surfaceView.getHolder().setFormat(z111111119 ? -1 : -3);
                        int i16 = i10;
                        if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m513getBehindB_4ceCc())) {
                            surfaceView.setZOrderOnTop(false);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m514getMediaOverlayB_4ceCc())) {
                            surfaceView.setZOrderMediaOverlay(true);
                        } else if (AndroidExternalSurfaceZOrder.m509equalsimpl0(i16, AndroidExternalSurfaceZOrder.INSTANCE.m515getOnTopB_4ceCc())) {
                            surfaceView.setZOrderOnTop(true);
                        }
                        surfaceView.setSecure(z1111111110);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidView_androidKt.AndroidView(function17, companion, androidExternalSurface_androidKt$AndroidExternalSurface$17, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i11 << 3) & 112) | 384, 8);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z3 = z5;
            j4 = j3;
            i12 = i10;
            z11 = z6;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = companion;
            final boolean z27 = z3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i16) {
                    AndroidExternalSurface_androidKt.m517AndroidExternalSurface58FFMhA(modifier10, z27, j4, i12, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    private static final AndroidEmbeddedExternalSurfaceState rememberAndroidEmbeddedExternalSurfaceState(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1057437053, "C(rememberAndroidEmbeddedExternalSurfaceState)384@15036L24,385@15072L55:AndroidExternalSurface.android.kt#71ulvw");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1057437053, i, -1, "androidx.compose.foundation.rememberAndroidEmbeddedExternalSurfaceState (AndroidExternalSurface.android.kt:383)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
        ComposerKt.sourceInformationMarkerStart(composer, -954367824, "CC(remember):Effects.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composer));
            composer.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
            objRememberedValue = compositionScopedCoroutineScopeCanceller;
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 1142294264, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
        Object objRememberedValue2 = composer.rememberedValue();
        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = new AndroidEmbeddedExternalSurfaceState(coroutineScope);
            composer.updateRememberedValue(objRememberedValue2);
        }
        AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = (AndroidEmbeddedExternalSurfaceState) objRememberedValue2;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return androidEmbeddedExternalSurfaceState;
    }

    public static final void m516AndroidEmbeddedExternalSurfacesv6N_fY(Modifier modifier, boolean z, long j, float[] fArr, final Function1<? super AndroidExternalSurfaceScope, Unit> function1, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        boolean z2;
        long j2;
        int i4;
        Matrix matrixM4826boximpl;
        int i5;
        int i6;
        Modifier.Companion companion;
        int i7;
        boolean z3;
        final long j3;
        final AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
        boolean z4;
        boolean z5;
        Object objRememberedValue;
        Matrix matrixM4826boximpl2;
        boolean zChangedInstance;
        Object objRememberedValue2;
        final long j4;
        final float[] fArr2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(217541314);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AndroidEmbeddedExternalSurface)P(1!1,3:c#ui.unit.IntSize,4:c#ui.graphics.Matrix)455@18917L45,458@18999L203,467@19273L485,457@18968L796:AndroidExternalSurface.android.kt#71ulvw");
        int i9 = i2 & 1;
        if (i9 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                z2 = z;
                i3 |= composerStartRestartGroup.changed(z2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                j2 = j;
                if ((i2 & 4) == 0 || !composerStartRestartGroup.changed(j2)) {
                    i8 = Fields.SpotShadowColor;
                } else {
                    i8 = 256;
                }
                i3 |= i8;
            } else {
                j2 = j;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                i3 |= 3072;
            } else if ((i & 3072) == 0) {
                if (fArr != null) {
                    matrixM4826boximpl = Matrix.m4826boximpl(fArr);
                } else {
                    matrixM4826boximpl = null;
                }
                if (composerStartRestartGroup.changedInstance(matrixM4826boximpl)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i6 = 16384;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 4) != 0) {
                        j2 = IntSize.Companion.getZero-YbymL2g();
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        i7 = i3;
                        z3 = z2;
                        j3 = j2;
                        fArr = null;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(217541314, i7, -1, "androidx.compose.foundation.AndroidEmbeddedExternalSurface (AndroidExternalSurface.android.kt:454)");
                    }
                    androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState = rememberAndroidEmbeddedExternalSurfaceState(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184051342, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    int i11 = (i7 & 896) ^ 384;
                    boolean zChangedInstance2 = ((i11 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState);
                    if ((57344 & i7) == 16384) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    z5 = zChangedInstance2 | z4;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z5 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                            {
                                super(1);
                            }

                            public final TextureView invoke(Context context) {
                                TextureView textureView = new TextureView(context);
                                AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                                long j5 = j3;
                                Function1<AndroidExternalSurfaceScope, Unit> function2 = function1;
                                androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j5);
                                function2.invoke(androidEmbeddedExternalSurfaceState);
                                textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                                return textureView;
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    Function1 function2 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    C0342x1320780f c0342x1320780f = new Function1<TextureView, Unit>() {
                        public final void invoke(TextureView textureView) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextureView) obj);
                            return Unit.INSTANCE;
                        }
                    };
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184060392, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                    boolean zChangedInstance3 = ((i11 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState) | ((i7 & 112) == 32);
                    if (fArr != null) {
                        matrixM4826boximpl2 = Matrix.m4826boximpl(fArr);
                    } else {
                        matrixM4826boximpl2 = null;
                    }
                    zChangedInstance = zChangedInstance3 | composerStartRestartGroup.changedInstance(matrixM4826boximpl2);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        final long j5 = j3;
                        final boolean z6 = z3;
                        final float[] fArr3 = fArr;
                        objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextureView) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextureView textureView) {
                                android.graphics.Matrix matrix;
                                SurfaceTexture surfaceTexture;
                                if (!IntSize.equals-impl0(j5, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                                    surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j5), IntSize.getHeight-impl(j5));
                                }
                                androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j5);
                                textureView.setOpaque(z6);
                                float[] fArr4 = fArr3;
                                if (fArr4 != null) {
                                    matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                                    AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr4);
                                } else {
                                    matrix = null;
                                }
                                textureView.setTransform(matrix);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    AndroidView_androidKt.AndroidView(function2, companion, c0342x1320780f, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i7 << 3) & 112) | 384, 8);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z2 = z3;
                    j4 = j3;
                    fArr2 = fArr;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    companion = modifier2;
                }
                i7 = i3;
                z3 = z2;
                j3 = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(217541314, i7, -1, "androidx.compose.foundation.AndroidEmbeddedExternalSurface (AndroidExternalSurface.android.kt:454)");
                }
                androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState = rememberAndroidEmbeddedExternalSurfaceState(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184051342, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                int i12 = (i7 & 896) ^ 384;
                boolean zChangedInstance4 = ((i12 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState);
                if ((57344 & i7) == 16384) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                z5 = zChangedInstance4 | z4;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                        {
                            super(1);
                        }

                        public final TextureView invoke(Context context) {
                            TextureView textureView = new TextureView(context);
                            AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                            long j6 = j3;
                            Function1<AndroidExternalSurfaceScope, Unit> function3 = function1;
                            androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j6);
                            function3.invoke(androidEmbeddedExternalSurfaceState);
                            textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                            return textureView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                        {
                            super(1);
                        }

                        public final TextureView invoke(Context context) {
                            TextureView textureView = new TextureView(context);
                            AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                            long j6 = j3;
                            Function1<AndroidExternalSurfaceScope, Unit> function3 = function1;
                            androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j6);
                            function3.invoke(androidEmbeddedExternalSurfaceState);
                            textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                            return textureView;
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                Function1 function3 = (Function1) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                C0342x1320780f c0342x1320780f2 = new Function1<TextureView, Unit>() {
                    public final void invoke(TextureView textureView) {
                    }

                    public Object invoke(Object obj) {
                        invoke((TextureView) obj);
                        return Unit.INSTANCE;
                    }
                };
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184060392, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
                boolean zChangedInstance5 = ((i12 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState) | ((i7 & 112) == 32);
                if (fArr != null) {
                    matrixM4826boximpl2 = Matrix.m4826boximpl(fArr);
                } else {
                    matrixM4826boximpl2 = null;
                }
                zChangedInstance = zChangedInstance5 | composerStartRestartGroup.changedInstance(matrixM4826boximpl2);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    final long j6 = j3;
                    final boolean z7 = z3;
                    final float[] fArr4 = fArr;
                    objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextureView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextureView textureView) {
                            android.graphics.Matrix matrix;
                            SurfaceTexture surfaceTexture;
                            if (!IntSize.equals-impl0(j6, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                                surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j6), IntSize.getHeight-impl(j6));
                            }
                            androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j6);
                            textureView.setOpaque(z7);
                            float[] fArr5 = fArr4;
                            if (fArr5 != null) {
                                matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                                AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr5);
                            } else {
                                matrix = null;
                            }
                            textureView.setTransform(matrix);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j7 = j3;
                    final boolean z8 = z3;
                    final float[] fArr5 = fArr;
                    objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextureView) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextureView textureView) {
                            android.graphics.Matrix matrix;
                            SurfaceTexture surfaceTexture;
                            if (!IntSize.equals-impl0(j7, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                                surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j7), IntSize.getHeight-impl(j7));
                            }
                            androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j7);
                            textureView.setOpaque(z8);
                            float[] fArr6 = fArr5;
                            if (fArr6 != null) {
                                matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                                AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr6);
                            } else {
                                matrix = null;
                            }
                            textureView.setTransform(matrix);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                AndroidView_androidKt.AndroidView(function3, companion, c0342x1320780f2, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i7 << 3) & 112) | 384, 8);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z2 = z3;
                j4 = j3;
                fArr2 = fArr;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                fArr2 = fArr;
                companion = modifier2;
                j4 = j2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final boolean z9 = z2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        AndroidExternalSurface_androidKt.m516AndroidEmbeddedExternalSurfacesv6N_fY(modifier3, z9, j4, fArr2, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        z2 = z;
        if ((i & 384) == 0) {
            j2 = j;
            if ((i2 & 4) == 0) {
                i8 = Fields.SpotShadowColor;
            } else {
                i8 = Fields.SpotShadowColor;
            }
            i3 |= i8;
        } else {
            j2 = j;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            if (fArr != null) {
                matrixM4826boximpl = Matrix.m4826boximpl(fArr);
            } else {
                matrixM4826boximpl = null;
            }
            if (composerStartRestartGroup.changedInstance(matrixM4826boximpl)) {
                i5 = Fields.CameraDistance;
            } else {
                i5 = Fields.RotationZ;
            }
            i3 |= i5;
        }
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
                i6 = 16384;
            } else {
                i6 = Fields.Shape;
            }
            i3 |= i6;
        }
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    z2 = true;
                }
                if ((i2 & 4) != 0) {
                    j2 = IntSize.Companion.getZero-YbymL2g();
                    i3 &= -897;
                }
                if (i4 != 0) {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                    fArr = null;
                } else {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    z2 = true;
                }
                if ((i2 & 4) != 0) {
                    j2 = IntSize.Companion.getZero-YbymL2g();
                    i3 &= -897;
                }
                if (i4 != 0) {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                    fArr = null;
                } else {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(217541314, i7, -1, "androidx.compose.foundation.AndroidEmbeddedExternalSurface (AndroidExternalSurface.android.kt:454)");
            }
            androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState = rememberAndroidEmbeddedExternalSurfaceState(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184051342, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            int i13 = (i7 & 896) ^ 384;
            boolean zChangedInstance6 = ((i13 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState);
            if ((57344 & i7) == 16384) {
                z4 = true;
            } else {
                z4 = false;
            }
            z5 = zChangedInstance6 | z4;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                    {
                        super(1);
                    }

                    public final TextureView invoke(Context context) {
                        TextureView textureView = new TextureView(context);
                        AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                        long j8 = j3;
                        Function1<AndroidExternalSurfaceScope, Unit> function4 = function1;
                        androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j8);
                        function4.invoke(androidEmbeddedExternalSurfaceState);
                        textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                        return textureView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                    {
                        super(1);
                    }

                    public final TextureView invoke(Context context) {
                        TextureView textureView = new TextureView(context);
                        AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                        long j8 = j3;
                        Function1<AndroidExternalSurfaceScope, Unit> function4 = function1;
                        androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j8);
                        function4.invoke(androidEmbeddedExternalSurfaceState);
                        textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                        return textureView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function1 function4 = (Function1) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            C0342x1320780f c0342x1320780f3 = new Function1<TextureView, Unit>() {
                public final void invoke(TextureView textureView) {
                }

                public Object invoke(Object obj) {
                    invoke((TextureView) obj);
                    return Unit.INSTANCE;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184060392, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            boolean zChangedInstance7 = ((i13 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState) | ((i7 & 112) == 32);
            if (fArr != null) {
                matrixM4826boximpl2 = Matrix.m4826boximpl(fArr);
            } else {
                matrixM4826boximpl2 = null;
            }
            zChangedInstance = zChangedInstance7 | composerStartRestartGroup.changedInstance(matrixM4826boximpl2);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                final long j8 = j3;
                final boolean z10 = z3;
                final float[] fArr6 = fArr;
                objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextureView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextureView textureView) {
                        android.graphics.Matrix matrix;
                        SurfaceTexture surfaceTexture;
                        if (!IntSize.equals-impl0(j8, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                            surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j8), IntSize.getHeight-impl(j8));
                        }
                        androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j8);
                        textureView.setOpaque(z10);
                        float[] fArr7 = fArr6;
                        if (fArr7 != null) {
                            matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                            AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr7);
                        } else {
                            matrix = null;
                        }
                        textureView.setTransform(matrix);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j9 = j3;
                final boolean z11 = z3;
                final float[] fArr7 = fArr;
                objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextureView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextureView textureView) {
                        android.graphics.Matrix matrix;
                        SurfaceTexture surfaceTexture;
                        if (!IntSize.equals-impl0(j9, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                            surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j9), IntSize.getHeight-impl(j9));
                        }
                        androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j9);
                        textureView.setOpaque(z11);
                        float[] fArr8 = fArr7;
                        if (fArr8 != null) {
                            matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                            AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr8);
                        } else {
                            matrix = null;
                        }
                        textureView.setTransform(matrix);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidView_androidKt.AndroidView(function4, companion, c0342x1320780f3, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i7 << 3) & 112) | 384, 8);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z2 = z3;
            j4 = j3;
            fArr2 = fArr;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    z2 = true;
                }
                if ((i2 & 4) != 0) {
                    j2 = IntSize.Companion.getZero-YbymL2g();
                    i3 &= -897;
                }
                if (i4 != 0) {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                    fArr = null;
                } else {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    z2 = true;
                }
                if ((i2 & 4) != 0) {
                    j2 = IntSize.Companion.getZero-YbymL2g();
                    i3 &= -897;
                }
                if (i4 != 0) {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                    fArr = null;
                } else {
                    i7 = i3;
                    z3 = z2;
                    j3 = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(217541314, i7, -1, "androidx.compose.foundation.AndroidEmbeddedExternalSurface (AndroidExternalSurface.android.kt:454)");
            }
            androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState = rememberAndroidEmbeddedExternalSurfaceState(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184051342, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            int i14 = (i7 & 896) ^ 384;
            boolean zChangedInstance8 = ((i14 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState);
            if ((57344 & i7) == 16384) {
                z4 = true;
            } else {
                z4 = false;
            }
            z5 = zChangedInstance8 | z4;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                    {
                        super(1);
                    }

                    public final TextureView invoke(Context context) {
                        TextureView textureView = new TextureView(context);
                        AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                        long j10 = j3;
                        Function1<AndroidExternalSurfaceScope, Unit> function5 = function1;
                        androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j10);
                        function5.invoke(androidEmbeddedExternalSurfaceState);
                        textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                        return textureView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<Context, TextureView>() {
                    {
                        super(1);
                    }

                    public final TextureView invoke(Context context) {
                        TextureView textureView = new TextureView(context);
                        AndroidEmbeddedExternalSurfaceState androidEmbeddedExternalSurfaceState = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState;
                        long j10 = j3;
                        Function1<AndroidExternalSurfaceScope, Unit> function5 = function1;
                        androidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j10);
                        function5.invoke(androidEmbeddedExternalSurfaceState);
                        textureView.setSurfaceTextureListener(androidEmbeddedExternalSurfaceState);
                        return textureView;
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            Function1 function5 = (Function1) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            C0342x1320780f c0342x1320780f4 = new Function1<TextureView, Unit>() {
                public final void invoke(TextureView textureView) {
                }

                public Object invoke(Object obj) {
                    invoke((TextureView) obj);
                    return Unit.INSTANCE;
                }
            };
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 184060392, "CC(remember):AndroidExternalSurface.android.kt#9igjgp");
            boolean zChangedInstance9 = ((i14 <= 256 && composerStartRestartGroup.changed(j3)) || (i7 & 384) == 256) | composerStartRestartGroup.changedInstance(androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState) | ((i7 & 112) == 32);
            if (fArr != null) {
                matrixM4826boximpl2 = Matrix.m4826boximpl(fArr);
            } else {
                matrixM4826boximpl2 = null;
            }
            zChangedInstance = zChangedInstance9 | composerStartRestartGroup.changedInstance(matrixM4826boximpl2);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                final long j10 = j3;
                final boolean z12 = z3;
                final float[] fArr8 = fArr;
                objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextureView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextureView textureView) {
                        android.graphics.Matrix matrix;
                        SurfaceTexture surfaceTexture;
                        if (!IntSize.equals-impl0(j10, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                            surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j10), IntSize.getHeight-impl(j10));
                        }
                        androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j10);
                        textureView.setOpaque(z12);
                        float[] fArr9 = fArr8;
                        if (fArr9 != null) {
                            matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                            AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr9);
                        } else {
                            matrix = null;
                        }
                        textureView.setTransform(matrix);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j11 = j3;
                final boolean z13 = z3;
                final float[] fArr9 = fArr;
                objRememberedValue2 = (Function1) new Function1<TextureView, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextureView) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextureView textureView) {
                        android.graphics.Matrix matrix;
                        SurfaceTexture surfaceTexture;
                        if (!IntSize.equals-impl0(j11, IntSize.Companion.getZero-YbymL2g()) && (surfaceTexture = textureView.getSurfaceTexture()) != null) {
                            surfaceTexture.setDefaultBufferSize(IntSize.getWidth-impl(j11), IntSize.getHeight-impl(j11));
                        }
                        androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.m505setSurfaceSizeozmzZPI(j11);
                        textureView.setOpaque(z13);
                        float[] fArr10 = fArr9;
                        if (fArr10 != null) {
                            matrix = androidEmbeddedExternalSurfaceStateRememberAndroidEmbeddedExternalSurfaceState.getMatrix();
                            AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix, fArr10);
                        } else {
                            matrix = null;
                        }
                        textureView.setTransform(matrix);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidView_androidKt.AndroidView(function5, companion, c0342x1320780f4, (Function1) null, (Function1) objRememberedValue2, composerStartRestartGroup, ((i7 << 3) & 112) | 384, 8);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z2 = z3;
            j4 = j3;
            fArr2 = fArr;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final boolean z14 = z2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    AndroidExternalSurface_androidKt.m516AndroidEmbeddedExternalSurfacesv6N_fY(modifier4, z14, j4, fArr2, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
