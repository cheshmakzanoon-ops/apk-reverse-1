package androidx.compose.foundation.text;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.MultiParagraph;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.style.TextOverflow;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000H\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u008c\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0014\u0010\u0004\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0006\u0012\u0004\u0012\u00020\u00010\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00062\u0014\b\u0002\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00010\u00052\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00010\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014\u001av\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00062\u0014\b\u0002\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00010\u00052\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00010\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016\u001a\u001e\u0010\u0017\u001a\u00020\f*\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aH\u0002ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001c\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001d"}, d2 = {"ClickableText", "", "text", "Landroidx/compose/ui/text/AnnotatedString;", "onHover", "Lkotlin/Function1;", "", "modifier", "Landroidx/compose/ui/Modifier;", "style", "Landroidx/compose/ui/text/TextStyle;", "softWrap", "", "overflow", "Landroidx/compose/ui/text/style/TextOverflow;", "maxLines", "onTextLayout", "Landroidx/compose/ui/text/TextLayoutResult;", "onClick", "ClickableText-03UYbkw", "(Landroidx/compose/ui/text/AnnotatedString;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/text/TextStyle;ZIILkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "ClickableText-4YKlhWE", "(Landroidx/compose/ui/text/AnnotatedString;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/text/TextStyle;ZIILkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "containsWithinBounds", "Landroidx/compose/ui/text/MultiParagraph;", "positionOffset", "Landroidx/compose/ui/geometry/Offset;", "containsWithinBounds-Uv8p0NA", "(Landroidx/compose/ui/text/MultiParagraph;J)Z", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ClickableTextKt {
    @Deprecated(message = "Use Text or BasicText and pass an AnnotatedString that contains a LinkAnnotation")
    public static final void m1428ClickableText4YKlhWE(final AnnotatedString annotatedString, Modifier modifier, TextStyle textStyle, boolean z, int i, int i2, Function1<? super TextLayoutResult, Unit> function1, final Function1<? super Integer, Unit> function2, Composer composer, final int i3, final int i4) {
        int i5;
        Modifier modifier2;
        int i6;
        TextStyle textStyle2;
        int i7;
        int i8;
        boolean z2;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        TextStyle textStyle3;
        boolean z3;
        int i19;
        final Function1<? super TextLayoutResult, Unit> function3;
        Object objRememberedValue;
        final MutableState mutableState;
        boolean z4;
        ClickableTextKt$ClickableText$pressIndicator$1$1 clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue;
        boolean z5;
        Object objRememberedValue2;
        final boolean z6;
        final int i20;
        final Function1<? super TextLayoutResult, Unit> function4;
        final Modifier modifier3;
        final int i21;
        final TextStyle textStyle4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-246609449);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ClickableText)P(7,1,6,5,4:c#ui.text.style.TextOverflow!1,3)84@3976L52,85@4085L184,100@4490L76,93@4275L297:ClickableText.kt#423gt5");
        if ((i4 & 1) != 0) {
            i5 = i3 | 6;
        } else if ((i3 & 6) == 0) {
            i5 = (composerStartRestartGroup.changed(annotatedString) ? 4 : 2) | i3;
        } else {
            i5 = i3;
        }
        int i22 = i4 & 2;
        if (i22 == 0) {
            if ((i3 & 48) == 0) {
                modifier2 = modifier;
                i5 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i6 = i4 & 4;
            if (i6 != 0) {
                if ((i3 & 384) == 0) {
                    textStyle2 = textStyle;
                    if (composerStartRestartGroup.changed(textStyle2)) {
                        i7 = Fields.RotationX;
                    } else {
                        i7 = Fields.SpotShadowColor;
                    }
                    i5 |= i7;
                }
                i8 = i4 & 8;
                if (i8 != 0) {
                    if ((i3 & 3072) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i9 = Fields.CameraDistance;
                        } else {
                            i9 = Fields.RotationZ;
                        }
                        i5 |= i9;
                    }
                    i10 = i4 & 16;
                    if (i10 != 0) {
                        if ((i3 & 24576) == 0) {
                            i11 = i;
                            if (composerStartRestartGroup.changed(i11)) {
                                i12 = Fields.Clip;
                            } else {
                                i12 = Fields.Shape;
                            }
                            i5 |= i12;
                        }
                        i13 = i4 & 32;
                        if (i13 != 0) {
                            i5 |= 196608;
                            i14 = i2;
                        } else {
                            i14 = i2;
                            if ((i3 & 196608) == 0) {
                                if (composerStartRestartGroup.changed(i14)) {
                                    i15 = Fields.RenderEffect;
                                } else {
                                    i15 = 65536;
                                }
                                i5 |= i15;
                            }
                        }
                        i16 = i4 & 64;
                        if (i16 != 0) {
                            i5 |= 1572864;
                        } else if ((i3 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i17 = 1048576;
                            } else {
                                i17 = 524288;
                            }
                            i5 |= i17;
                        }
                        if ((i4 & Fields.SpotShadowColor) != 0) {
                            i5 |= 12582912;
                        } else if ((i3 & 12582912) == 0) {
                            if (composerStartRestartGroup.changedInstance(function2)) {
                                i18 = 8388608;
                            } else {
                                i18 = 4194304;
                            }
                            i5 |= i18;
                        }
                        if ((4793491 & i5) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                            if (i22 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i6 != 0) {
                                textStyle3 = TextStyle.Companion.getDefault();
                            } else {
                                textStyle3 = textStyle2;
                            }
                            if (i8 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if (i10 != 0) {
                                i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                            } else {
                                i19 = i11;
                            }
                            if (i13 != 0) {
                                i14 = Integer.MAX_VALUE;
                            }
                            if (i16 != 0) {
                                function3 = new Function1<TextLayoutResult, Unit>() {
                                    public final void invoke(TextLayoutResult textLayoutResult) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((TextLayoutResult) obj);
                                        return Unit.INSTANCE;
                                    }
                                };
                            } else {
                                function3 = function1;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableState = (MutableState) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            Modifier.Companion companion = Modifier.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                            if ((29360128 & i5) == 8388608) {
                                z4 = true;
                            } else {
                                z4 = false;
                            }
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4 || clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            Modifier modifierThen = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                            z5 = (i5 & 3670016) == 1048576;
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z5 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((TextLayoutResult) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(TextLayoutResult textLayoutResult) {
                                        mutableState.setValue(textLayoutResult);
                                        function3.invoke(textLayoutResult);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            Function1<? super TextLayoutResult, Unit> function5 = function3;
                            BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            z6 = z3;
                            i20 = i19;
                            function4 = function5;
                            modifier3 = modifier2;
                            i21 = i14;
                            textStyle4 = textStyle3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            function4 = function1;
                            modifier3 = modifier2;
                            z6 = z2;
                            i20 = i11;
                            i21 = i14;
                            textStyle4 = textStyle2;
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

                                public final void invoke(Composer composer2, int i23) {
                                    ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                                }
                            });
                        }
                    }
                    i5 |= 24576;
                    i11 = i;
                    i13 = i4 & 32;
                    if (i13 != 0) {
                        i5 |= 196608;
                        i14 = i2;
                    } else {
                        i14 = i2;
                        if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i14)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                    }
                    i16 = i4 & 64;
                    if (i16 != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i5 |= i17;
                    }
                    if ((i4 & Fields.SpotShadowColor) != 0) {
                        i5 |= 12582912;
                    } else if ((i3 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i5 |= i18;
                    }
                    if ((4793491 & i5) == 4793490) {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion2 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen2 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion2, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function6 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen2, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function6;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
                    } else {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion3 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen3 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion3, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function7 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen3, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function7;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
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

                            public final void invoke(Composer composer2, int i23) {
                                ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 3072;
                z2 = z;
                i10 = i4 & 16;
                if (i10 != 0) {
                    if ((i3 & 24576) == 0) {
                        i11 = i;
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.Clip;
                        } else {
                            i12 = Fields.Shape;
                        }
                        i5 |= i12;
                    }
                    i13 = i4 & 32;
                    if (i13 != 0) {
                        i5 |= 196608;
                        i14 = i2;
                    } else {
                        i14 = i2;
                        if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i14)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                    }
                    i16 = i4 & 64;
                    if (i16 != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i5 |= i17;
                    }
                    if ((i4 & Fields.SpotShadowColor) != 0) {
                        i5 |= 12582912;
                    } else if ((i3 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i5 |= i18;
                    }
                    if ((4793491 & i5) == 4793490) {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion4 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen4 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion4, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function8 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen4, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function8;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
                    } else {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion5 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen5 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion5, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function9 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen5, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function9;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
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

                            public final void invoke(Composer composer2, int i23) {
                                ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i11 = i;
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion6 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen6 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion6, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function10 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen6, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function10;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion7 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen7 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion7, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function11 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen7, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function11;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 384;
            textStyle2 = textStyle;
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.CameraDistance;
                    } else {
                        i9 = Fields.RotationZ;
                    }
                    i5 |= i9;
                }
                i10 = i4 & 16;
                if (i10 != 0) {
                    if ((i3 & 24576) == 0) {
                        i11 = i;
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.Clip;
                        } else {
                            i12 = Fields.Shape;
                        }
                        i5 |= i12;
                    }
                    i13 = i4 & 32;
                    if (i13 != 0) {
                        i5 |= 196608;
                        i14 = i2;
                    } else {
                        i14 = i2;
                        if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i14)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                    }
                    i16 = i4 & 64;
                    if (i16 != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i5 |= i17;
                    }
                    if ((i4 & Fields.SpotShadowColor) != 0) {
                        i5 |= 12582912;
                    } else if ((i3 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i5 |= i18;
                    }
                    if ((4793491 & i5) == 4793490) {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion8 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen8 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion8, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function12 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen8, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function12;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
                    } else {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion9 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen9 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion9, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function13 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen9, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function13;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
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

                            public final void invoke(Composer composer2, int i23) {
                                ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i11 = i;
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion10 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen10 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion10, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function14 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen10, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function14;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion11 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen11 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion11, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function15 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen11, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function15;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            z2 = z;
            i10 = i4 & 16;
            if (i10 != 0) {
                if ((i3 & 24576) == 0) {
                    i11 = i;
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.Clip;
                    } else {
                        i12 = Fields.Shape;
                    }
                    i5 |= i12;
                }
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion12 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen12 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion12, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function16 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen12, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function16;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion13 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen13 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion13, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function17 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen13, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function17;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i11 = i;
            i13 = i4 & 32;
            if (i13 != 0) {
                i5 |= 196608;
                i14 = i2;
            } else {
                i14 = i2;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i14)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
            }
            i16 = i4 & 64;
            if (i16 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i5 |= i17;
            }
            if ((i4 & Fields.SpotShadowColor) != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i5 |= i18;
            }
            if ((4793491 & i5) == 4793490) {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion14 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen14 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion14, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function18 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen14, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function18;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
            } else {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion15 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen15 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion15, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function19 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen15, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function19;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
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

                    public final void invoke(Composer composer2, int i23) {
                        ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 48;
        modifier2 = modifier;
        i6 = i4 & 4;
        if (i6 != 0) {
            if ((i3 & 384) == 0) {
                textStyle2 = textStyle;
                if (composerStartRestartGroup.changed(textStyle2)) {
                    i7 = Fields.RotationX;
                } else {
                    i7 = Fields.SpotShadowColor;
                }
                i5 |= i7;
            }
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.CameraDistance;
                    } else {
                        i9 = Fields.RotationZ;
                    }
                    i5 |= i9;
                }
                i10 = i4 & 16;
                if (i10 != 0) {
                    if ((i3 & 24576) == 0) {
                        i11 = i;
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.Clip;
                        } else {
                            i12 = Fields.Shape;
                        }
                        i5 |= i12;
                    }
                    i13 = i4 & 32;
                    if (i13 != 0) {
                        i5 |= 196608;
                        i14 = i2;
                    } else {
                        i14 = i2;
                        if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i14)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                    }
                    i16 = i4 & 64;
                    if (i16 != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i5 |= i17;
                    }
                    if ((i4 & Fields.SpotShadowColor) != 0) {
                        i5 |= 12582912;
                    } else if ((i3 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i5 |= i18;
                    }
                    if ((4793491 & i5) == 4793490) {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion16 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen16 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion16, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function110 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen16, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function110;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
                    } else {
                        if (i22 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                        } else {
                            i19 = i11;
                        }
                        if (i13 != 0) {
                            i14 = Integer.MAX_VALUE;
                        }
                        if (i16 != 0) {
                            function3 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            function3 = function1;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion17 = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        } else {
                            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen17 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion17, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                        if ((i5 & 3670016) == 1048576) {
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    function3.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Function1<? super TextLayoutResult, Unit> function111 = function3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen17, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z6 = z3;
                        i20 = i19;
                        function4 = function111;
                        modifier3 = modifier2;
                        i21 = i14;
                        textStyle4 = textStyle3;
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

                            public final void invoke(Composer composer2, int i23) {
                                ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i11 = i;
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion18 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen18 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion18, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function112 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen18, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function112;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion19 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen19 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion19, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function113 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen19, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function113;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            z2 = z;
            i10 = i4 & 16;
            if (i10 != 0) {
                if ((i3 & 24576) == 0) {
                    i11 = i;
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.Clip;
                    } else {
                        i12 = Fields.Shape;
                    }
                    i5 |= i12;
                }
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion110 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen110 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion110, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function114 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen110, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function114;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion111 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen111 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion111, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function115 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen111, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function115;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i11 = i;
            i13 = i4 & 32;
            if (i13 != 0) {
                i5 |= 196608;
                i14 = i2;
            } else {
                i14 = i2;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i14)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
            }
            i16 = i4 & 64;
            if (i16 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i5 |= i17;
            }
            if ((i4 & Fields.SpotShadowColor) != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i5 |= i18;
            }
            if ((4793491 & i5) == 4793490) {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion112 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen112 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion112, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function116 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen112, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function116;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
            } else {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion113 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen113 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion113, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function117 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen113, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function117;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
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

                    public final void invoke(Composer composer2, int i23) {
                        ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 384;
        textStyle2 = textStyle;
        i8 = i4 & 8;
        if (i8 != 0) {
            if ((i3 & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i9 = Fields.CameraDistance;
                } else {
                    i9 = Fields.RotationZ;
                }
                i5 |= i9;
            }
            i10 = i4 & 16;
            if (i10 != 0) {
                if ((i3 & 24576) == 0) {
                    i11 = i;
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.Clip;
                    } else {
                        i12 = Fields.Shape;
                    }
                    i5 |= i12;
                }
                i13 = i4 & 32;
                if (i13 != 0) {
                    i5 |= 196608;
                    i14 = i2;
                } else {
                    i14 = i2;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i14)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                }
                i16 = i4 & 64;
                if (i16 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i5 |= i17;
                }
                if ((i4 & Fields.SpotShadowColor) != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i5 |= i18;
                }
                if ((4793491 & i5) == 4793490) {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion114 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen114 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion114, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function118 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen114, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function118;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
                } else {
                    if (i22 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                    } else {
                        i19 = i11;
                    }
                    if (i13 != 0) {
                        i14 = Integer.MAX_VALUE;
                    }
                    if (i16 != 0) {
                        function3 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        function3 = function1;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion115 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen115 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion115, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                    if ((i5 & 3670016) == 1048576) {
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                function3.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Function1<? super TextLayoutResult, Unit> function119 = function3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen115, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z3;
                    i20 = i19;
                    function4 = function119;
                    modifier3 = modifier2;
                    i21 = i14;
                    textStyle4 = textStyle3;
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

                        public final void invoke(Composer composer2, int i23) {
                            ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i11 = i;
            i13 = i4 & 32;
            if (i13 != 0) {
                i5 |= 196608;
                i14 = i2;
            } else {
                i14 = i2;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i14)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
            }
            i16 = i4 & 64;
            if (i16 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i5 |= i17;
            }
            if ((i4 & Fields.SpotShadowColor) != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i5 |= i18;
            }
            if ((4793491 & i5) == 4793490) {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion116 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen116 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion116, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function1110 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen116, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function1110;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
            } else {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion117 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen117 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion117, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function1111 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen117, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function1111;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
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

                    public final void invoke(Composer composer2, int i23) {
                        ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 3072;
        z2 = z;
        i10 = i4 & 16;
        if (i10 != 0) {
            if ((i3 & 24576) == 0) {
                i11 = i;
                if (composerStartRestartGroup.changed(i11)) {
                    i12 = Fields.Clip;
                } else {
                    i12 = Fields.Shape;
                }
                i5 |= i12;
            }
            i13 = i4 & 32;
            if (i13 != 0) {
                i5 |= 196608;
                i14 = i2;
            } else {
                i14 = i2;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i14)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
            }
            i16 = i4 & 64;
            if (i16 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i5 |= i17;
            }
            if ((i4 & Fields.SpotShadowColor) != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i5 |= i18;
            }
            if ((4793491 & i5) == 4793490) {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion118 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen118 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion118, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function1112 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen118, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function1112;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
            } else {
                if (i22 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i19 = TextOverflow.Companion.getClip-gIe3tQ8();
                } else {
                    i19 = i11;
                }
                if (i13 != 0) {
                    i14 = Integer.MAX_VALUE;
                }
                if (i16 != 0) {
                    function3 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    function3 = function1;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion119 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen119 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion119, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
                if ((i5 & 3670016) == 1048576) {
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            function3.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Function1<? super TextLayoutResult, Unit> function1113 = function3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen119, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z3;
                i20 = i19;
                function4 = function1113;
                modifier3 = modifier2;
                i21 = i14;
                textStyle4 = textStyle3;
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

                    public final void invoke(Composer composer2, int i23) {
                        ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 24576;
        i11 = i;
        i13 = i4 & 32;
        if (i13 != 0) {
            i5 |= 196608;
            i14 = i2;
        } else {
            i14 = i2;
            if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i14)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
        }
        i16 = i4 & 64;
        if (i16 != 0) {
            i5 |= 1572864;
        } else if ((i3 & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
                i17 = 1048576;
            } else {
                i17 = 524288;
            }
            i5 |= i17;
        }
        if ((i4 & Fields.SpotShadowColor) != 0) {
            i5 |= 12582912;
        } else if ((i3 & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i18 = 8388608;
            } else {
                i18 = 4194304;
            }
            i5 |= i18;
        }
        if ((4793491 & i5) == 4793490) {
            if (i22 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                textStyle3 = TextStyle.Companion.getDefault();
            } else {
                textStyle3 = textStyle2;
            }
            if (i8 != 0) {
                z3 = true;
            } else {
                z3 = z2;
            }
            if (i10 != 0) {
                i19 = TextOverflow.Companion.getClip-gIe3tQ8();
            } else {
                i19 = i11;
            }
            if (i13 != 0) {
                i14 = Integer.MAX_VALUE;
            }
            if (i16 != 0) {
                function3 = new Function1<TextLayoutResult, Unit>() {
                    public final void invoke(TextLayoutResult textLayoutResult) {
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }
                };
            } else {
                function3 = function1;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier.Companion companion1110 = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
            if ((29360128 & i5) == 8388608) {
                z4 = true;
            } else {
                z4 = false;
            }
            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
            } else {
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen1110 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion1110, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
            if ((i5 & 3670016) == 1048576) {
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        function3.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        function3.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Function1<? super TextLayoutResult, Unit> function1114 = function3;
            BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen1110, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z6 = z3;
            i20 = i19;
            function4 = function1114;
            modifier3 = modifier2;
            i21 = i14;
            textStyle4 = textStyle3;
        } else {
            if (i22 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                textStyle3 = TextStyle.Companion.getDefault();
            } else {
                textStyle3 = textStyle2;
            }
            if (i8 != 0) {
                z3 = true;
            } else {
                z3 = z2;
            }
            if (i10 != 0) {
                i19 = TextOverflow.Companion.getClip-gIe3tQ8();
            } else {
                i19 = i11;
            }
            if (i13 != 0) {
                i14 = Integer.MAX_VALUE;
            }
            if (i16 != 0) {
                function3 = new Function1<TextLayoutResult, Unit>() {
                    public final void invoke(TextLayoutResult textLayoutResult) {
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }
                };
            } else {
                function3 = function1;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-246609449, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:83)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498074812, "CC(remember):ClickableText.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier.Companion companion1111 = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498078432, "CC(remember):ClickableText.kt#9igjgp");
            if ((29360128 & i5) == 8388608) {
                z4 = true;
            } else {
                z4 = false;
            }
            clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
            } else {
                clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue = new ClickableTextKt$ClickableText$pressIndicator$1$1(mutableState, function2, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen1111 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion1111, function2, (Function2<? super PointerInputScope, ? super Continuation<? super Unit>, ? extends Object>) clickableTextKt$ClickableText$pressIndicator$1$1RememberedValue));
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498091284, "CC(remember):ClickableText.kt#9igjgp");
            if ((i5 & 3670016) == 1048576) {
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        function3.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        function3.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Function1<? super TextLayoutResult, Unit> function1115 = function3;
            BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen1111, textStyle3, (Function1) objRememberedValue2, i19, z3, i14, 0, null, null, composerStartRestartGroup, (58254 & i5) | ((i5 << 6) & 458752) | ((i5 << 3) & 3670016), 896);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z6 = z3;
            i20 = i19;
            function4 = function1115;
            modifier3 = modifier2;
            i21 = i14;
            textStyle4 = textStyle3;
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

                public final void invoke(Composer composer2, int i23) {
                    ClickableTextKt.m1428ClickableText4YKlhWE(annotatedString, modifier3, textStyle4, z6, i20, i21, function4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                }
            });
        }
    }

    @Deprecated(message = "Use Text or BasicText and pass an AnnotatedString that contains a LinkAnnotation")
    public static final void m1427ClickableText03UYbkw(final AnnotatedString annotatedString, final Function1<? super Integer, Unit> function1, Modifier modifier, TextStyle textStyle, boolean z, int i, int i2, Function1<? super TextLayoutResult, Unit> function2, final Function1<? super Integer, Unit> function3, Composer composer, final int i3, final int i4) {
        int i5;
        Modifier modifier2;
        int i6;
        TextStyle textStyle2;
        int i7;
        int i8;
        boolean z2;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        TextStyle textStyle3;
        boolean z3;
        int i18;
        final ClickableTextKt$ClickableText$4 clickableTextKt$ClickableText$4;
        Object objRememberedValue;
        final MutableState mutableState;
        Object objRememberedValue2;
        CoroutineScope coroutineScope;
        boolean z4;
        boolean z5;
        boolean z6;
        ClickableTextKt$ClickableText$pointerInputModifier$1$1 clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue;
        boolean z7;
        Object objRememberedValue3;
        final TextStyle textStyle4;
        final boolean z8;
        final int i19;
        final Modifier modifier3;
        final int i20;
        final Function1<? super TextLayoutResult, Unit> function4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1020774372);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ClickableText)P(8,3,1,7,6,5:c#ui.text.style.TextOverflow!1,4)163@7538L52,164@7616L24,171@7916L413,193@8556L76,186@8335L303:ClickableText.kt#423gt5");
        if ((i4 & 1) != 0) {
            i5 = i3 | 6;
        } else if ((i3 & 6) == 0) {
            i5 = (composerStartRestartGroup.changed(annotatedString) ? 4 : 2) | i3;
        } else {
            i5 = i3;
        }
        if ((i4 & 2) != 0) {
            i5 |= 48;
        } else if ((i3 & 48) == 0) {
            i5 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
        }
        int i21 = i4 & 4;
        if (i21 == 0) {
            if ((i3 & 384) == 0) {
                modifier2 = modifier;
                i5 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i6 = i4 & 8;
            if (i6 != 0) {
                if ((i3 & 3072) == 0) {
                    textStyle2 = textStyle;
                    if (composerStartRestartGroup.changed(textStyle2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i5 |= i7;
                }
                i8 = i4 & 16;
                if (i8 != 0) {
                    if ((i3 & 24576) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i5 |= i9;
                    }
                    i10 = i4 & 32;
                    if (i10 != 0) {
                        i5 |= 196608;
                        i11 = i;
                    } else {
                        i11 = i;
                        if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i11)) {
                                i12 = Fields.RenderEffect;
                            } else {
                                i12 = 65536;
                            }
                            i5 |= i12;
                        }
                    }
                    i13 = i4 & 64;
                    if (i13 != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(i2)) {
                            i14 = 1048576;
                        } else {
                            i14 = 524288;
                        }
                        i5 |= i14;
                    }
                    i15 = i4 & Fields.SpotShadowColor;
                    if (i15 != 0) {
                        i5 |= 12582912;
                    } else if ((i3 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i16 = 8388608;
                        } else {
                            i16 = 4194304;
                        }
                        i5 |= i16;
                    }
                    if ((i4 & Fields.RotationX) != 0) {
                        i5 |= 100663296;
                    } else if ((i3 & 100663296) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i17 = 67108864;
                        } else {
                            i17 = 33554432;
                        }
                        i5 |= i17;
                    }
                    if ((38347923 & i5) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                        if (i21 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            textStyle3 = TextStyle.Companion.getDefault();
                        } else {
                            textStyle3 = textStyle2;
                        }
                        if (i8 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if (i10 != 0) {
                            i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                        }
                        if (i13 != 0) {
                            i18 = Integer.MAX_VALUE;
                        } else {
                            i18 = i2;
                        }
                        if (i15 != 0) {
                            clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                                public final void invoke(TextLayoutResult textLayoutResult) {
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }
                            };
                        } else {
                            clickableTextKt$ClickableText$4 = function2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                            objRememberedValue2 = compositionScopedCoroutineScopeCanceller;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier.Companion companion = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                        boolean zChangedInstance = composerStartRestartGroup.changedInstance(coroutineScope);
                        if ((i5 & 112) == 32) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        boolean z9 = zChangedInstance | z4;
                        if ((234881024 & i5) == 67108864) {
                            z5 = true;
                        } else {
                            z5 = false;
                        }
                        z6 = z9 | z5;
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z6 || clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                            clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                            composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Modifier modifierThen = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                        if ((29360128 & i5) == 8388608) {
                            z7 = true;
                        } else {
                            z7 = false;
                        }
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!z7 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((TextLayoutResult) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(TextLayoutResult textLayoutResult) {
                                    mutableState.setValue(textLayoutResult);
                                    clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i22 = i5 >> 3;
                        BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i22 & 896) | (i22 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        textStyle4 = textStyle3;
                        z8 = z3;
                        i19 = i11;
                        modifier3 = modifier2;
                        i20 = i18;
                        function4 = clickableTextKt$ClickableText$4;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        i19 = i11;
                        modifier3 = modifier2;
                        textStyle4 = textStyle2;
                        z8 = z2;
                        i20 = i2;
                        function4 = function2;
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

                            public final void invoke(Composer composer2, int i23) {
                                ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                z2 = z;
                i10 = i4 & 32;
                if (i10 != 0) {
                    i5 |= 196608;
                    i11 = i;
                } else {
                    i11 = i;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i5 |= i12;
                    }
                }
                i13 = i4 & 64;
                if (i13 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(i2)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i5 |= i14;
                }
                i15 = i4 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i5 |= i16;
                }
                if ((i4 & Fields.RotationX) != 0) {
                    i5 |= 100663296;
                } else if ((i3 & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i17 = 67108864;
                    } else {
                        i17 = 33554432;
                    }
                    i5 |= i17;
                }
                if ((38347923 & i5) == 38347922) {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller2 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller2);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller2;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion2 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance2 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z10 = zChangedInstance2 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z10 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen2 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion2, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i23 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen2, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i23 & 896) | (i23 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
                } else {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller3 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller3);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller3;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion3 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance3 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z11 = zChangedInstance3 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z11 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen3 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion3, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i24 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen3, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i24 & 896) | (i24 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
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

                        public final void invoke(Composer composer2, int i25) {
                            ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            textStyle2 = textStyle;
            i8 = i4 & 16;
            if (i8 != 0) {
                if ((i3 & 24576) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i5 |= i9;
                }
                i10 = i4 & 32;
                if (i10 != 0) {
                    i5 |= 196608;
                    i11 = i;
                } else {
                    i11 = i;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i5 |= i12;
                    }
                }
                i13 = i4 & 64;
                if (i13 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(i2)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i5 |= i14;
                }
                i15 = i4 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i5 |= i16;
                }
                if ((i4 & Fields.RotationX) != 0) {
                    i5 |= 100663296;
                } else if ((i3 & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i17 = 67108864;
                    } else {
                        i17 = 33554432;
                    }
                    i5 |= i17;
                }
                if ((38347923 & i5) == 38347922) {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller4 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller4);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller4;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion4 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance4 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z12 = zChangedInstance4 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z12 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen4 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion4, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i25 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen4, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i25 & 896) | (i25 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
                } else {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller5 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller5);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller5;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion5 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance5 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z13 = zChangedInstance5 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z13 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen5 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion5, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i26 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen5, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i26 & 896) | (i26 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
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

                        public final void invoke(Composer composer2, int i27) {
                            ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            z2 = z;
            i10 = i4 & 32;
            if (i10 != 0) {
                i5 |= 196608;
                i11 = i;
            } else {
                i11 = i;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i5 |= i12;
                }
            }
            i13 = i4 & 64;
            if (i13 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(i2)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i5 |= i14;
            }
            i15 = i4 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i5 |= i16;
            }
            if ((i4 & Fields.RotationX) != 0) {
                i5 |= 100663296;
            } else if ((i3 & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i17 = 67108864;
                } else {
                    i17 = 33554432;
                }
                i5 |= i17;
            }
            if ((38347923 & i5) == 38347922) {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller6 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller6);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller6;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion6 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance6 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z14 = zChangedInstance6 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z14 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen6 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion6, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i27 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen6, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i27 & 896) | (i27 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
            } else {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller7 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller7);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller7;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion7 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance7 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z15 = zChangedInstance7 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z15 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen7 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion7, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i28 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen7, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i28 & 896) | (i28 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
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

                    public final void invoke(Composer composer2, int i29) {
                        ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 384;
        modifier2 = modifier;
        i6 = i4 & 8;
        if (i6 != 0) {
            if ((i3 & 3072) == 0) {
                textStyle2 = textStyle;
                if (composerStartRestartGroup.changed(textStyle2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i5 |= i7;
            }
            i8 = i4 & 16;
            if (i8 != 0) {
                if ((i3 & 24576) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i5 |= i9;
                }
                i10 = i4 & 32;
                if (i10 != 0) {
                    i5 |= 196608;
                    i11 = i;
                } else {
                    i11 = i;
                    if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i11)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i5 |= i12;
                    }
                }
                i13 = i4 & 64;
                if (i13 != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(i2)) {
                        i14 = 1048576;
                    } else {
                        i14 = 524288;
                    }
                    i5 |= i14;
                }
                i15 = i4 & Fields.SpotShadowColor;
                if (i15 != 0) {
                    i5 |= 12582912;
                } else if ((i3 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i16 = 8388608;
                    } else {
                        i16 = 4194304;
                    }
                    i5 |= i16;
                }
                if ((i4 & Fields.RotationX) != 0) {
                    i5 |= 100663296;
                } else if ((i3 & 100663296) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i17 = 67108864;
                    } else {
                        i17 = 33554432;
                    }
                    i5 |= i17;
                }
                if ((38347923 & i5) == 38347922) {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller8 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller8);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller8;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion8 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance8 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z16 = zChangedInstance8 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z16 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen8 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion8, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i29 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen8, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i29 & 896) | (i29 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
                } else {
                    if (i21 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        textStyle3 = TextStyle.Companion.getDefault();
                    } else {
                        textStyle3 = textStyle2;
                    }
                    if (i8 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if (i10 != 0) {
                        i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                    }
                    if (i13 != 0) {
                        i18 = Integer.MAX_VALUE;
                    } else {
                        i18 = i2;
                    }
                    if (i15 != 0) {
                        clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                            public final void invoke(TextLayoutResult textLayoutResult) {
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }
                        };
                    } else {
                        clickableTextKt$ClickableText$4 = function2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller9 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller9);
                        objRememberedValue2 = compositionScopedCoroutineScopeCanceller9;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier.Companion companion9 = Modifier.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                    boolean zChangedInstance9 = composerStartRestartGroup.changedInstance(coroutineScope);
                    if ((i5 & 112) == 32) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    boolean z17 = zChangedInstance9 | z4;
                    if ((234881024 & i5) == 67108864) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    z6 = z17 | z5;
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z6) {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    } else {
                        clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                        composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen9 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion9, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                    if ((29360128 & i5) == 8388608) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!z7) {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((TextLayoutResult) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(TextLayoutResult textLayoutResult) {
                                mutableState.setValue(textLayoutResult);
                                clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i210 = i5 >> 3;
                    BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen9, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i210 & 896) | (i210 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    textStyle4 = textStyle3;
                    z8 = z3;
                    i19 = i11;
                    modifier3 = modifier2;
                    i20 = i18;
                    function4 = clickableTextKt$ClickableText$4;
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

                        public final void invoke(Composer composer2, int i211) {
                            ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            z2 = z;
            i10 = i4 & 32;
            if (i10 != 0) {
                i5 |= 196608;
                i11 = i;
            } else {
                i11 = i;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i5 |= i12;
                }
            }
            i13 = i4 & 64;
            if (i13 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(i2)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i5 |= i14;
            }
            i15 = i4 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i5 |= i16;
            }
            if ((i4 & Fields.RotationX) != 0) {
                i5 |= 100663296;
            } else if ((i3 & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i17 = 67108864;
                } else {
                    i17 = 33554432;
                }
                i5 |= i17;
            }
            if ((38347923 & i5) == 38347922) {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller10 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller10);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller10;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion10 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance10 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z18 = zChangedInstance10 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z18 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen10 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion10, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen10, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i211 & 896) | (i211 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
            } else {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller11;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion11 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance11 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z19 = zChangedInstance11 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z19 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen11 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion11, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i212 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen11, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i212 & 896) | (i212 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
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

                    public final void invoke(Composer composer2, int i213) {
                        ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 3072;
        textStyle2 = textStyle;
        i8 = i4 & 16;
        if (i8 != 0) {
            if ((i3 & 24576) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i5 |= i9;
            }
            i10 = i4 & 32;
            if (i10 != 0) {
                i5 |= 196608;
                i11 = i;
            } else {
                i11 = i;
                if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i11)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i5 |= i12;
                }
            }
            i13 = i4 & 64;
            if (i13 != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(i2)) {
                    i14 = 1048576;
                } else {
                    i14 = 524288;
                }
                i5 |= i14;
            }
            i15 = i4 & Fields.SpotShadowColor;
            if (i15 != 0) {
                i5 |= 12582912;
            } else if ((i3 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i16 = 8388608;
                } else {
                    i16 = 4194304;
                }
                i5 |= i16;
            }
            if ((i4 & Fields.RotationX) != 0) {
                i5 |= 100663296;
            } else if ((i3 & 100663296) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i17 = 67108864;
                } else {
                    i17 = 33554432;
                }
                i5 |= i17;
            }
            if ((38347923 & i5) == 38347922) {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller12 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller12);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller12;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion12 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance12 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z110 = zChangedInstance12 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z110 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen12 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion12, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i213 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen12, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i213 & 896) | (i213 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
            } else {
                if (i21 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    textStyle3 = TextStyle.Companion.getDefault();
                } else {
                    textStyle3 = textStyle2;
                }
                if (i8 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if (i10 != 0) {
                    i11 = TextOverflow.Companion.getClip-gIe3tQ8();
                }
                if (i13 != 0) {
                    i18 = Integer.MAX_VALUE;
                } else {
                    i18 = i2;
                }
                if (i15 != 0) {
                    clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                        public final void invoke(TextLayoutResult textLayoutResult) {
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }
                    };
                } else {
                    clickableTextKt$ClickableText$4 = function2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller13 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller13);
                    objRememberedValue2 = compositionScopedCoroutineScopeCanceller13;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier.Companion companion13 = Modifier.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
                boolean zChangedInstance13 = composerStartRestartGroup.changedInstance(coroutineScope);
                if ((i5 & 112) == 32) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                boolean z111 = zChangedInstance13 | z4;
                if ((234881024 & i5) == 67108864) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                z6 = z111 | z5;
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z6) {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                } else {
                    clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                    composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen13 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion13, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
                if ((29360128 & i5) == 8388608) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!z7) {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((TextLayoutResult) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextLayoutResult textLayoutResult) {
                            mutableState.setValue(textLayoutResult);
                            clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i214 = i5 >> 3;
                BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen13, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i214 & 896) | (i214 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                textStyle4 = textStyle3;
                z8 = z3;
                i19 = i11;
                modifier3 = modifier2;
                i20 = i18;
                function4 = clickableTextKt$ClickableText$4;
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

                    public final void invoke(Composer composer2, int i215) {
                        ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 24576;
        z2 = z;
        i10 = i4 & 32;
        if (i10 != 0) {
            i5 |= 196608;
            i11 = i;
        } else {
            i11 = i;
            if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i11)) {
                    i12 = Fields.RenderEffect;
                } else {
                    i12 = 65536;
                }
                i5 |= i12;
            }
        }
        i13 = i4 & 64;
        if (i13 != 0) {
            i5 |= 1572864;
        } else if ((i3 & 1572864) == 0) {
            if (composerStartRestartGroup.changed(i2)) {
                i14 = 1048576;
            } else {
                i14 = 524288;
            }
            i5 |= i14;
        }
        i15 = i4 & Fields.SpotShadowColor;
        if (i15 != 0) {
            i5 |= 12582912;
        } else if ((i3 & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i16 = 8388608;
            } else {
                i16 = 4194304;
            }
            i5 |= i16;
        }
        if ((i4 & Fields.RotationX) != 0) {
            i5 |= 100663296;
        } else if ((i3 & 100663296) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i17 = 67108864;
            } else {
                i17 = 33554432;
            }
            i5 |= i17;
        }
        if ((38347923 & i5) == 38347922) {
            if (i21 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                textStyle3 = TextStyle.Companion.getDefault();
            } else {
                textStyle3 = textStyle2;
            }
            if (i8 != 0) {
                z3 = true;
            } else {
                z3 = z2;
            }
            if (i10 != 0) {
                i11 = TextOverflow.Companion.getClip-gIe3tQ8();
            }
            if (i13 != 0) {
                i18 = Integer.MAX_VALUE;
            } else {
                i18 = i2;
            }
            if (i15 != 0) {
                clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                    public final void invoke(TextLayoutResult textLayoutResult) {
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }
                };
            } else {
                clickableTextKt$ClickableText$4 = function2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller14 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller14);
                objRememberedValue2 = compositionScopedCoroutineScopeCanceller14;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier.Companion companion14 = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
            boolean zChangedInstance14 = composerStartRestartGroup.changedInstance(coroutineScope);
            if ((i5 & 112) == 32) {
                z4 = true;
            } else {
                z4 = false;
            }
            boolean z112 = zChangedInstance14 | z4;
            if ((234881024 & i5) == 67108864) {
                z5 = true;
            } else {
                z5 = false;
            }
            z6 = z112 | z5;
            clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z6) {
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
            } else {
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen14 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion14, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
            if ((29360128 & i5) == 8388608) {
                z7 = true;
            } else {
                z7 = false;
            }
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!z7) {
                objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i215 = i5 >> 3;
            BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen14, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i215 & 896) | (i215 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            textStyle4 = textStyle3;
            z8 = z3;
            i19 = i11;
            modifier3 = modifier2;
            i20 = i18;
            function4 = clickableTextKt$ClickableText$4;
        } else {
            if (i21 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                textStyle3 = TextStyle.Companion.getDefault();
            } else {
                textStyle3 = textStyle2;
            }
            if (i8 != 0) {
                z3 = true;
            } else {
                z3 = z2;
            }
            if (i10 != 0) {
                i11 = TextOverflow.Companion.getClip-gIe3tQ8();
            }
            if (i13 != 0) {
                i18 = Integer.MAX_VALUE;
            } else {
                i18 = i2;
            }
            if (i15 != 0) {
                clickableTextKt$ClickableText$4 = new Function1<TextLayoutResult, Unit>() {
                    public final void invoke(TextLayoutResult textLayoutResult) {
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }
                };
            } else {
                clickableTextKt$ClickableText$4 = function2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1020774372, i5, -1, "androidx.compose.foundation.text.ClickableText (ClickableText.kt:162)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498188796, "CC(remember):ClickableText.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller15 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller15);
                objRememberedValue2 = compositionScopedCoroutineScopeCanceller15;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier.Companion companion15 = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498201253, "CC(remember):ClickableText.kt#9igjgp");
            boolean zChangedInstance15 = composerStartRestartGroup.changedInstance(coroutineScope);
            if ((i5 & 112) == 32) {
                z4 = true;
            } else {
                z4 = false;
            }
            boolean z113 = zChangedInstance15 | z4;
            if ((234881024 & i5) == 67108864) {
                z5 = true;
            } else {
                z5 = false;
            }
            z6 = z113 | z5;
            clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z6) {
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
            } else {
                clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(coroutineScope, function1, mutableState, function3, null);
                composerStartRestartGroup.updateRememberedValue(clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen15 = modifier2.then(SuspendingPointerInputFilterKt.pointerInput(companion15, function3, function1, (Function2) clickableTextKt$ClickableText$pointerInputModifier$1$1RememberedValue));
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1498221396, "CC(remember):ClickableText.kt#9igjgp");
            if ((29360128 & i5) == 8388608) {
                z7 = true;
            } else {
                z7 = false;
            }
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!z7) {
                objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<TextLayoutResult, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((TextLayoutResult) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(TextLayoutResult textLayoutResult) {
                        mutableState.setValue(textLayoutResult);
                        clickableTextKt$ClickableText$4.invoke(textLayoutResult);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i216 = i5 >> 3;
            BasicTextKt.m1414BasicTextRWo7tUw(annotatedString, modifierThen15, textStyle3, (Function1) objRememberedValue3, i11, z3, i18, 0, null, null, composerStartRestartGroup, (i5 & 14) | (i216 & 896) | (i216 & 57344) | ((i5 << 3) & 458752) | (i5 & 3670016), 896);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            textStyle4 = textStyle3;
            z8 = z3;
            i19 = i11;
            modifier3 = modifier2;
            i20 = i18;
            function4 = clickableTextKt$ClickableText$4;
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

                public final void invoke(Composer composer2, int i217) {
                    ClickableTextKt.m1427ClickableText03UYbkw(annotatedString, function1, modifier3, textStyle4, z8, i19, i20, function4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                }
            });
        }
    }

    public static final Integer ClickableText_03UYbkw$getOffset(MutableState<TextLayoutResult> mutableState, long j) {
        MultiParagraph multiParagraph;
        TextLayoutResult value = mutableState.getValue();
        if (value == null || (multiParagraph = value.getMultiParagraph()) == null) {
            return null;
        }
        if (!m1429containsWithinBoundsUv8p0NA(multiParagraph, j)) {
            multiParagraph = null;
        }
        if (multiParagraph != null) {
            return Integer.valueOf(multiParagraph.getOffsetForPosition-k-4lQ0M(j));
        }
        return null;
    }

    private static final boolean m1429containsWithinBoundsUv8p0NA(MultiParagraph multiParagraph, long j) {
        float fM4346getXimpl = Offset.m4346getXimpl(j);
        float fM4347getYimpl = Offset.m4347getYimpl(j);
        return fM4346getXimpl > 0.0f && fM4347getYimpl >= 0.0f && fM4346getXimpl <= multiParagraph.getWidth() && fM4347getYimpl <= multiParagraph.getHeight();
    }
}
