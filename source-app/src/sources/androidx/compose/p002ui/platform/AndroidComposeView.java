package androidx.compose.p002ui.platform;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Point;
import android.os.Build;
import android.os.SystemClock;
import android.os.Trace;
import android.util.LongSparseArray;
import android.util.SparseArray;
import android.view.FocusFinder;
import android.view.MotionEvent;
import android.view.ScrollCaptureTarget;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewStructure;
import android.view.ViewTreeObserver;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.animation.AnimationUtils;
import android.view.autofill.AutofillValue;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.translation.ViewTranslationRequest;
import android.view.translation.ViewTranslationResponse;
import androidx.autofill.HintConstants;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.SessionMutex;
import androidx.compose.p002ui.autofill.AndroidAutofill;
import androidx.compose.p002ui.autofill.AndroidAutofill_androidKt;
import androidx.compose.p002ui.autofill.Autofill;
import androidx.compose.p002ui.autofill.AutofillCallback;
import androidx.compose.p002ui.autofill.AutofillTree;
import androidx.compose.p002ui.contentcapture.AndroidContentCaptureManager;
import androidx.compose.p002ui.draganddrop.ComposeDragShadowBuilder;
import androidx.compose.p002ui.draganddrop.DragAndDropManager;
import androidx.compose.p002ui.draganddrop.DragAndDropTransferData;
import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.focus.FocusInteropUtils_androidKt;
import androidx.compose.p002ui.focus.FocusOwner;
import androidx.compose.p002ui.focus.FocusOwnerImpl;
import androidx.compose.p002ui.focus.FocusOwnerImplKt;
import androidx.compose.p002ui.focus.FocusTargetNode;
import androidx.compose.p002ui.focus.FocusTransactionsKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.AndroidGraphicsContext_androidKt;
import androidx.compose.p002ui.graphics.CanvasHolder;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.p002ui.graphics.RectHelper_androidKt;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.hapticfeedback.HapticFeedback;
import androidx.compose.p002ui.hapticfeedback.PlatformHapticFeedback;
import androidx.compose.p002ui.input.InputMode;
import androidx.compose.p002ui.input.InputModeManager;
import androidx.compose.p002ui.input.InputModeManagerImpl;
import androidx.compose.p002ui.input.key.Key;
import androidx.compose.p002ui.input.key.KeyEvent;
import androidx.compose.p002ui.input.key.KeyEventType;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import androidx.compose.p002ui.input.key.KeyInputModifierKt;
import androidx.compose.p002ui.input.pointer.MotionEventAdapter;
import androidx.compose.p002ui.input.pointer.PointerIcon;
import androidx.compose.p002ui.input.pointer.PointerIconService;
import androidx.compose.p002ui.input.pointer.PointerInputEvent;
import androidx.compose.p002ui.input.pointer.PointerInputEventData;
import androidx.compose.p002ui.input.pointer.PointerInputEventProcessor;
import androidx.compose.p002ui.input.pointer.PointerInputEventProcessorKt;
import androidx.compose.p002ui.input.pointer.PointerKeyboardModifiers;
import androidx.compose.p002ui.input.pointer.PositionCalculator;
import androidx.compose.p002ui.input.pointer.ProcessResult;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputModifierNode;
import androidx.compose.p002ui.input.rotary.RotaryInputModifierKt;
import androidx.compose.p002ui.input.rotary.RotaryScrollEvent;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.layout.PlaceableKt;
import androidx.compose.p002ui.layout.RootMeasurePolicy;
import androidx.compose.p002ui.modifier.ModifierLocalManager;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.p002ui.node.LayoutNodeDrawScope;
import androidx.compose.p002ui.node.MeasureAndLayoutDelegate;
import androidx.compose.p002ui.node.NestedVectorStack;
import androidx.compose.p002ui.node.NodeKind;
import androidx.compose.p002ui.node.OwnedLayer;
import androidx.compose.p002ui.node.Owner;
import androidx.compose.p002ui.node.OwnerSnapshotObserver;
import androidx.compose.p002ui.node.PointerInputModifierNode;
import androidx.compose.p002ui.node.RootForTest;
import androidx.compose.p002ui.scrollcapture.ScrollCapture;
import androidx.compose.p002ui.semantics.EmptySemanticsElement;
import androidx.compose.p002ui.semantics.EmptySemanticsModifier;
import androidx.compose.p002ui.semantics.SemanticsNodeKt;
import androidx.compose.p002ui.semantics.SemanticsOwner;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.text.font.Font;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontFamilyResolver_androidKt;
import androidx.compose.ui.text.input.PlatformTextInputService;
import androidx.compose.ui.text.input.TextInputService;
import androidx.compose.ui.text.input.TextInputServiceAndroid;
import androidx.compose.ui.unit.AndroidDensity_androidKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DensityKt;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntOffsetKt;
import androidx.compose.ui.unit.LayoutDirection;
import androidx.compose.ui.viewinterop.AndroidViewHolder;
import androidx.core.view.AccessibilityDelegateCompat;
import androidx.core.view.ViewCompat;
import androidx.core.view.ViewConfigurationCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.ViewTreeLifecycleOwner;
import androidx.savedstate.SavedStateRegistryOwner;
import androidx.savedstate.ViewTreeSavedStateRegistryOwner;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;
import kotlin.Deprecated;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.ResultKt;
import kotlin.ULong;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MutablePropertyReference0Impl;
import kotlin.jvm.internal.TypeIntrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u009e\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0015\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b#\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0016\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u000b*\u0002¾\u0001\b\u0000\u0018\u0000 \u0088\u00042\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u00042\u00020\u0005:\u0004\u0088\u0004\u0089\u0004B\u0015\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u001b\u0010\u0097\u0002\u001a\u0002062\b\u0010þ\u0001\u001a\u00030\u0098\u00022\b\u0010\u0099\u0002\u001a\u00030Á\u0001J&\u0010\u009a\u0002\u001a\u0002062\u0007\u0010\u009b\u0002\u001a\u00020G2\b\u0010\u009c\u0002\u001a\u00030\u009d\u00022\b\u0010\u009e\u0002\u001a\u00030\u009f\u0002H\u0002J\u0015\u0010 \u0002\u001a\u0002062\n\u0010¡\u0002\u001a\u0005\u0018\u00010ÿ\u0001H\u0016J!\u0010 \u0002\u001a\u0002062\n\u0010¡\u0002\u001a\u0005\u0018\u00010ÿ\u00012\n\u0010¢\u0002\u001a\u0005\u0018\u00010£\u0002H\u0016J\u001e\u0010 \u0002\u001a\u0002062\n\u0010¡\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010¤\u0002\u001a\u00020GH\u0016J*\u0010 \u0002\u001a\u0002062\n\u0010¡\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010¤\u0002\u001a\u00020G2\n\u0010¢\u0002\u001a\u0005\u0018\u00010£\u0002H\u0016J'\u0010 \u0002\u001a\u0002062\n\u0010¡\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010¥\u0002\u001a\u00020G2\u0007\u0010¦\u0002\u001a\u00020GH\u0016J\u0019\u0010#\u001a\u0002062\u000f\u0010§\u0002\u001a\n\u0012\u0005\u0012\u00030©\u00020¨\u0002H\u0016J\t\u0010ª\u0002\u001a\u00020mH\u0002J\u0010\u0010«\u0002\u001a\u000206H\u0086@¢\u0006\u0003\u0010¬\u0002J\u0010\u0010\u00ad\u0002\u001a\u000206H\u0086@¢\u0006\u0003\u0010¬\u0002J \u0010®\u0002\u001a\u00030\u008b\u00012\b\u0010¯\u0002\u001a\u00030\u008b\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b°\u0002\u0010±\u0002J \u0010²\u0002\u001a\u00030\u008b\u00012\b\u0010³\u0002\u001a\u00030\u008b\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b´\u0002\u0010±\u0002J\u0012\u0010µ\u0002\u001a\u00020m2\u0007\u0010¶\u0002\u001a\u00020GH\u0016J\u0012\u0010·\u0002\u001a\u00020m2\u0007\u0010¶\u0002\u001a\u00020GH\u0016J\u0012\u0010¸\u0002\u001a\u0002062\u0007\u0010¹\u0002\u001a\u00020\u0001H\u0002J\"\u0010º\u0002\u001a\u00030»\u00022\u0007\u0010¼\u0002\u001a\u00020GH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\b½\u0002\u0010¾\u0002Jh\u0010¿\u0002\u001a\u00020Q2B\u0010À\u0002\u001a=\u0012\u0017\u0012\u00150Â\u0002¢\u0006\u000f\bÃ\u0002\u0012\n\bÄ\u0002\u0012\u0005\b\b(Å\u0002\u0012\u0019\u0012\u0017\u0018\u00010Æ\u0002¢\u0006\u000f\bÃ\u0002\u0012\n\bÄ\u0002\u0012\u0005\b\b(Ç\u0002\u0012\u0004\u0012\u0002060Á\u00022\r\u0010È\u0002\u001a\b\u0012\u0004\u0012\u0002060Z2\n\u0010É\u0002\u001a\u0005\u0018\u00010Æ\u0002H\u0016J\u0013\u0010Ê\u0002\u001a\u0002062\b\u0010Å\u0002\u001a\u00030Ë\u0002H\u0014J\u0013\u0010Ì\u0002\u001a\u00020m2\b\u0010Í\u0002\u001a\u00030º\u0001H\u0016J\u0013\u0010Î\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u0001H\u0016J\u0013\u0010Ð\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030Ñ\u0002H\u0016J\u0013\u0010Ò\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030Ñ\u0002H\u0016J\t\u0010Ó\u0002\u001a\u000206H\u0002J\u0013\u0010Ô\u0002\u001a\u0002062\b\u0010Õ\u0002\u001a\u00030Ö\u0002H\u0016J\u0013\u0010×\u0002\u001a\u00020m2\b\u0010Í\u0002\u001a\u00030º\u0001H\u0016J\u001b\u0010Ø\u0002\u001a\u0002062\b\u0010þ\u0001\u001a\u00030\u0098\u00022\b\u0010Å\u0002\u001a\u00030Ë\u0002J\u0015\u0010Ù\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010¶\u0002\u001a\u00020GH\u0002J\u001f\u0010Ú\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010Û\u0002\u001a\u00020G2\b\u0010Ü\u0002\u001a\u00030ÿ\u0001H\u0002J\u0013\u0010Ý\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010Û\u0002\u001a\u00020GJ!\u0010Þ\u0002\u001a\u0005\u0018\u00010ÿ\u00012\n\u0010ß\u0002\u001a\u0005\u0018\u00010ÿ\u00012\u0007\u0010¶\u0002\u001a\u00020GH\u0016J\u0012\u0010à\u0002\u001a\u0002062\u0007\u0010á\u0002\u001a\u00020mH\u0016J\u001c\u0010â\u0002\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u00012\u0007\u0010ã\u0002\u001a\u00020mH\u0016J\"\u0010ä\u0002\u001a\u0005\u0018\u00010å\u00022\b\u0010æ\u0002\u001a\u00030ç\u0002H\u0016ø\u0001\u0000¢\u0006\u0006\bè\u0002\u0010é\u0002J\u0013\u0010ê\u0002\u001a\u0002062\b\u0010ë\u0002\u001a\u00030ì\u0002H\u0016J#\u0010í\u0002\u001a\u00030î\u00022\b\u0010Í\u0002\u001a\u00030º\u0001H\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\bï\u0002\u0010ð\u0002J\u0013\u0010ñ\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u0001H\u0002J\u001d\u0010ò\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u00012\b\u0010ó\u0002\u001a\u00030º\u0001H\u0002J\t\u0010ô\u0002\u001a\u000206H\u0016J\u0013\u0010õ\u0002\u001a\u0002062\b\u0010ö\u0002\u001a\u00030Á\u0001H\u0002J\u0013\u0010÷\u0002\u001a\u0002062\b\u0010ö\u0002\u001a\u00030Á\u0001H\u0002J\u0013\u0010ø\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u0001H\u0002J\u0013\u0010ù\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u0001H\u0002J\u0013\u0010ú\u0002\u001a\u00020m2\b\u0010Í\u0002\u001a\u00030º\u0001H\u0002J\u0013\u0010û\u0002\u001a\u00020m2\b\u0010Ï\u0002\u001a\u00030º\u0001H\u0002J \u0010ü\u0002\u001a\u00030\u008b\u00012\b\u0010³\u0002\u001a\u00030\u008b\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\bý\u0002\u0010±\u0002J\u001f\u0010ü\u0002\u001a\u0002062\b\u0010þ\u0002\u001a\u00030ø\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\bÿ\u0002\u0010\u0080\u0003J)\u0010\u0081\u0003\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u00012\b\u0010\u0082\u0003\u001a\u00030¬\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b\u0083\u0003\u0010\u0084\u0003J\u0012\u0010\u0081\u0003\u001a\u0002062\u0007\u0010\u0085\u0003\u001a\u00020mH\u0016J\t\u0010\u0086\u0003\u001a\u000206H\u0016J!\u0010\u0087\u0003\u001a\u0002062\u0007\u0010\u0088\u0003\u001a\u00020Q2\u0007\u0010\u0089\u0003\u001a\u00020mH\u0000¢\u0006\u0003\b\u008a\u0003J\u0013\u0010\u008b\u0003\u001a\u0002062\b\u0010ö\u0002\u001a\u00030Á\u0001H\u0016J\t\u0010\u008c\u0003\u001a\u000206H\u0014J\t\u0010\u008d\u0003\u001a\u00020mH\u0016J\t\u0010\u008e\u0003\u001a\u000206H\u0002J\u0012\u0010\u008f\u0003\u001a\u0002062\u0007\u0010\u0090\u0003\u001a\u000205H\u0014J\u0016\u0010\u0091\u0003\u001a\u0005\u0018\u00010\u0092\u00032\b\u0010\u0093\u0003\u001a\u00030\u0094\u0003H\u0016J0\u0010\u0095\u0003\u001a\u0002062\b\u0010\u0096\u0003\u001a\u00030\u0097\u00032\b\u0010\u0098\u0003\u001a\u00030û\u00012\u0011\u0010\u0099\u0003\u001a\f\u0012\u0007\u0012\u0005\u0018\u00010\u009b\u00030\u009a\u0003H\u0017J\u0013\u0010\u009c\u0003\u001a\u0002062\b\u0010ö\u0002\u001a\u00030Á\u0001H\u0016J\t\u0010\u009d\u0003\u001a\u000206H\u0014J\u0013\u0010\u009e\u0003\u001a\u0002062\b\u0010Å\u0002\u001a\u00030Ë\u0002H\u0014J\t\u0010\u009f\u0003\u001a\u000206H\u0016J\f\u0010 \u0003\u001a\u0005\u0018\u00010¡\u0003H\u0002J'\u0010¢\u0003\u001a\u0002062\u0007\u0010£\u0003\u001a\u00020m2\u0007\u0010¶\u0002\u001a\u00020G2\n\u0010¤\u0003\u001a\u0005\u0018\u00010ì\u0002H\u0014J\u0018\u0010¥\u0003\u001a\u0002062\r\u0010þ\u0001\u001a\b0ÿ\u0001j\u0003`¦\u0003H\u0016J6\u0010§\u0003\u001a\u0002062\u0007\u0010¨\u0003\u001a\u00020m2\u0007\u0010©\u0003\u001a\u00020G2\u0007\u0010ª\u0003\u001a\u00020G2\u0007\u0010«\u0003\u001a\u00020G2\u0007\u0010¬\u0003\u001a\u00020GH\u0014J\u0013\u0010\u00ad\u0003\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u0001H\u0016J\u001b\u0010®\u0003\u001a\u0002062\u0007\u0010¯\u0003\u001a\u00020G2\u0007\u0010°\u0003\u001a\u00020GH\u0014J\u001f\u0010±\u0003\u001a\u00020m2\b\u0010²\u0003\u001a\u00030å\u0002H\u0002ø\u0001\u0000¢\u0006\u0006\b³\u0003\u0010´\u0003J\u001e\u0010µ\u0003\u001a\u0002062\n\u0010Õ\u0002\u001a\u0005\u0018\u00010Ö\u00022\u0007\u0010¶\u0003\u001a\u00020GH\u0016J*\u0010·\u0003\u001a\u00020m2\n\u0010²\u0003\u001a\u0005\u0018\u00010å\u00022\n\u0010¤\u0003\u001a\u0005\u0018\u00010¡\u0003H\u0002ø\u0001\u0000¢\u0006\u0003\b¸\u0003J.\u0010¹\u0003\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u00012\u0007\u0010ã\u0002\u001a\u00020m2\u0007\u0010º\u0003\u001a\u00020m2\u0007\u0010»\u0003\u001a\u00020mH\u0016J%\u0010¼\u0003\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u00012\u0007\u0010ã\u0002\u001a\u00020m2\u0007\u0010º\u0003\u001a\u00020mH\u0016J\u0013\u0010½\u0003\u001a\u0002062\b\u0010¾\u0003\u001a\u00030¿\u0003H\u0016J\u0012\u0010À\u0003\u001a\u0002062\u0007\u0010\u0096\u0001\u001a\u00020GH\u0016J.\u0010Á\u0003\u001a\u0002062\b\u0010Â\u0003\u001a\u00030ì\u00022\b\u0010Ã\u0003\u001a\u00030Ä\u00032\u000f\u0010Å\u0003\u001a\n\u0012\u0005\u0012\u00030Æ\u00030\u009a\u0003H\u0016J\t\u0010Ç\u0003\u001a\u000206H\u0016J\u001c\u0010È\u0003\u001a\u0002062\u0011\u0010É\u0003\u001a\f\u0012\u0007\u0012\u0005\u0018\u00010Ë\u00030Ê\u0003H\u0017J\u0012\u0010Ì\u0003\u001a\u0002062\u0007\u0010Í\u0003\u001a\u00020mH\u0016J+\u0010Î\u0003\u001a\u00030»\u00022\u0007\u0010Ï\u0003\u001a\u00020G2\u0007\u0010¬\u0003\u001a\u00020GH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\bÐ\u0003\u0010Ñ\u0003J\t\u0010Ò\u0003\u001a\u000206H\u0002J\u0013\u0010Ò\u0003\u001a\u0002062\b\u0010Í\u0002\u001a\u00030º\u0001H\u0002J\t\u0010Ó\u0003\u001a\u000206H\u0002J\u0018\u0010Ô\u0003\u001a\u00020m2\u0007\u0010\u0088\u0003\u001a\u00020QH\u0000¢\u0006\u0003\bÕ\u0003J\u0018\u0010Ö\u0003\u001a\u0002062\r\u0010×\u0003\u001a\b\u0012\u0004\u0012\u0002060ZH\u0016J\u0013\u0010Ø\u0003\u001a\u0002062\b\u0010×\u0003\u001a\u00030Ù\u0003H\u0016J\u0011\u0010Ú\u0003\u001a\u0002062\b\u0010þ\u0001\u001a\u00030\u0098\u0002J\u0007\u0010Û\u0003\u001a\u000206J\u001e\u0010Ü\u0003\u001a\u00020m2\u0007\u0010¶\u0002\u001a\u00020G2\n\u0010¤\u0003\u001a\u0005\u0018\u00010ì\u0002H\u0016J\u0013\u0010Ý\u0003\u001a\u0002062\b\u0010\u0099\u0002\u001a\u00030Á\u0001H\u0016J\u0017\u0010»\u0003\u001a\u0002062\f\b\u0002\u0010Þ\u0003\u001a\u0005\u0018\u00010Á\u0001H\u0002J \u0010ß\u0003\u001a\u00030\u008b\u00012\b\u0010à\u0003\u001a\u00030\u008b\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\bá\u0003\u0010±\u0002J\u001f\u0010â\u0003\u001a\u00020m2\b\u0010æ\u0002\u001a\u00030ç\u0002H\u0016ø\u0001\u0000¢\u0006\u0006\bã\u0003\u0010ä\u0003J#\u0010å\u0003\u001a\u00030î\u00022\b\u0010Í\u0002\u001a\u00030º\u0001H\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\bæ\u0003\u0010ð\u0002J1\u0010ç\u0003\u001a\u0002062\b\u0010Í\u0002\u001a\u00030º\u00012\u0007\u0010è\u0003\u001a\u00020G2\b\u0010é\u0003\u001a\u00030\u008d\u00012\t\b\u0002\u0010ê\u0003\u001a\u00020mH\u0002J\u0013\u0010ë\u0003\u001a\u0002062\b\u0010ì\u0003\u001a\u00030\u008d\u0001H\u0016J\u001c\u0010í\u0003\u001a\u0002062\u0013\u0010î\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020604J\t\u0010ï\u0003\u001a\u00020mH\u0016JE\u0010ð\u0003\u001a\u00020m2\b\u0010ñ\u0003\u001a\u00030ò\u00032\b\u0010ó\u0003\u001a\u00030ô\u00032\u001a\u0010õ\u0003\u001a\u0015\u0012\u0005\u0012\u00030ö\u0003\u0012\u0004\u0012\u00020604¢\u0006\u0003\b÷\u0003H\u0002ø\u0001\u0000¢\u0006\u0006\bø\u0003\u0010ù\u0003JA\u0010ú\u0003\u001a\u00030û\u00032.\u0010ü\u0003\u001a)\b\u0001\u0012\u0005\u0012\u00030ý\u0003\u0012\f\u0012\n\u0012\u0005\u0012\u00030û\u00030þ\u0003\u0012\u0007\u0012\u0005\u0018\u00010ÿ\u00030Á\u0002¢\u0006\u0003\b÷\u0003H\u0096@¢\u0006\u0003\u0010\u0080\u0004J\t\u0010\u0081\u0004\u001a\u000206H\u0002J\u000e\u0010\u0082\u0004\u001a\u00020m*\u00030Á\u0001H\u0002J\u001b\u0010\u0083\u0004\u001a\u00020G*\u00030»\u0002H\u0082\nø\u0001\u0000¢\u0006\u0006\b\u0084\u0004\u0010\u0085\u0004J\u001b\u0010\u0086\u0004\u001a\u00020G*\u00030»\u0002H\u0082\nø\u0001\u0000¢\u0006\u0006\b\u0087\u0004\u0010\u0085\u0004R\u0010\u0010\u000b\u001a\u0004\u0018\u00010\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\r\u001a\u0004\u0018\u00010\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010\u0013\u001a\u0004\u0018\u00010\u00122\b\u0010\u0011\u001a\u0004\u0018\u00010\u00128B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0018\u0010\u0019\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u000e\u0010\u001a\u001a\u00020\u001bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001c\u001a\u00020\u001dX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0014\u0010 \u001a\u00020\f8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b!\u0010\"R\u0016\u0010#\u001a\u0004\u0018\u00010$8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b%\u0010&R\u0014\u0010'\u001a\u00020(X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b)\u0010*R\u000e\u0010+\u001a\u00020,X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010-\u001a\u00020.X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b/\u00100R\u000e\u00101\u001a\u000202X\u0082\u0004¢\u0006\u0002\n\u0000R&\u00103\u001a\u000e\u0012\u0004\u0012\u000205\u0012\u0004\u0012\u00020604X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b7\u00108\"\u0004\b9\u0010:R\u001a\u0010;\u001a\u00020<X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b=\u0010>\"\u0004\b?\u0010@R$\u0010\b\u001a\u00020\t2\u0006\u0010A\u001a\u00020\t@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bB\u0010C\"\u0004\bD\u0010ER\u000e\u0010F\u001a\u00020GX\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010I\u001a\u00020H2\u0006\u0010\u0011\u001a\u00020H8V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\bN\u0010\u0019\u001a\u0004\bJ\u0010K\"\u0004\bL\u0010MR\u0014\u0010O\u001a\b\u0012\u0004\u0012\u00020Q0PX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010R\u001a\u00020SX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\bT\u0010UR\u000e\u0010V\u001a\u00020WX\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010X\u001a\u0010\u0012\f\u0012\n\u0012\u0004\u0012\u000206\u0018\u00010Z0YX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010[\u001a\u00020\\X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b]\u0010^R+\u0010`\u001a\u00020_2\u0006\u0010\u0011\u001a\u00020_8V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\be\u0010\u0019\u001a\u0004\ba\u0010b\"\u0004\bc\u0010dR\u001c\u0010f\u001a\u00020g8\u0016X\u0097\u0004¢\u0006\u000e\n\u0000\u0012\u0004\bh\u0010i\u001a\u0004\bj\u0010kR\u000e\u0010l\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010n\u001a\u00020oX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010p\u001a\u00020qX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010rR\u0014\u0010s\u001a\u00020tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\bu\u0010vR\u0014\u0010w\u001a\u00020xX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\by\u0010zR\u0014\u0010{\u001a\u00020m8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b|\u0010}R\u000e\u0010~\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0017\u0010\u007f\u001a\u00030\u0080\u00018VX\u0096\u0004¢\u0006\b\u001a\u0006\b\u0081\u0001\u0010\u0082\u0001R\u000f\u0010\u0083\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\u0084\u0001\u001a\u00020m8VX\u0096\u0004¢\u0006\u0007\u001a\u0005\b\u0084\u0001\u0010}R\u000f\u0010\u0085\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u000f\u0010\u0086\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0087\u0001\u001a\u00030\u0088\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000f\u0010\u0089\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\u008a\u0001\u001a\u00030\u008b\u0001X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010rR+\u0010\u008c\u0001\u001a\u00030\u008d\u00018\u0000@\u0000X\u0081\u000e¢\u0006\u0019\n\u0000\u0012\u0005\b\u008e\u0001\u0010i\u001a\u0006\b\u008f\u0001\u0010\u0090\u0001\"\u0006\b\u0091\u0001\u0010\u0092\u0001R\u0016\u0010\u0093\u0001\u001a\t\u0012\u0004\u0012\u00020Q0\u0094\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R3\u0010\u0096\u0001\u001a\u00030\u0095\u00012\u0007\u0010\u0011\u001a\u00030\u0095\u00018V@RX\u0096\u008e\u0002¢\u0006\u0017\n\u0005\b\u009b\u0001\u0010\u0019\u001a\u0006\b\u0097\u0001\u0010\u0098\u0001\"\u0006\b\u0099\u0001\u0010\u009a\u0001R\u0010\u0010\u009c\u0001\u001a\u00030\u009d\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u009e\u0001\u001a\u00030\u009f\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010 \u0001\u001a\u00030¡\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010¢\u0001\u001a\u00030\u008d\u00018VX\u0096\u0004¢\u0006\b\u001a\u0006\b£\u0001\u0010\u0090\u0001R\u0018\u0010¤\u0001\u001a\u00030¥\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\b¦\u0001\u0010§\u0001R\u0010\u0010¨\u0001\u001a\u00030©\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000f\u0010ª\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010«\u0001\u001a\u0005\u0018\u00010¬\u0001X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u001d\u0010\u00ad\u0001\u001a\u0010\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u000206\u0018\u000104X\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010®\u0001\u001a\u00030¯\u00018VX\u0096\u0004¢\u0006\b\u001a\u0006\b°\u0001\u0010±\u0001R\u0018\u0010²\u0001\u001a\u00030³\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\b´\u0001\u0010µ\u0001R\u0010\u0010¶\u0001\u001a\u00030·\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010¸\u0001\u001a\n\u0012\u0004\u0012\u00020Q\u0018\u00010PX\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010¹\u0001\u001a\u0005\u0018\u00010º\u0001X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010»\u0001\u001a\u00030\u008d\u0001X\u0082\u000e¢\u0006\u0002\n\u0000R\u0015\u0010¼\u0001\u001a\b\u0012\u0004\u0012\u0002060ZX\u0082\u0004¢\u0006\u0002\n\u0000R\u0013\u0010½\u0001\u001a\u00030¾\u0001X\u0082\u0004¢\u0006\u0005\n\u0003\u0010¿\u0001R\u0018\u0010À\u0001\u001a\u00030Á\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bÂ\u0001\u0010Ã\u0001R\u0018\u0010Ä\u0001\u001a\u00030Å\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bÆ\u0001\u0010Ç\u0001R\u0010\u0010È\u0001\u001a\u00030É\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010Ê\u0001\u001a\u00030\u0088\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010Ë\u0001\u001a\u0005\u0018\u00010Ì\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010Í\u0001\u001a\u00020m8@X\u0080\u0004¢\u0006\u0007\u001a\u0005\bÎ\u0001\u0010}R\u0010\u0010Ï\u0001\u001a\u00030Ð\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010Ñ\u0001\u001a\u00030Ò\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010Ó\u0001\u001a\u00030Ô\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bÕ\u0001\u0010Ö\u0001R\u0010\u0010×\u0001\u001a\u00030Ø\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010Ù\u0001\u001a\u00030Ú\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bÛ\u0001\u0010Ü\u0001R%\u0010Ý\u0001\u001a\u00020mX\u0096\u000e¢\u0006\u0018\n\u0000\u0012\u0005\bÞ\u0001\u0010i\u001a\u0005\bß\u0001\u0010}\"\u0006\bà\u0001\u0010á\u0001R\u0018\u0010â\u0001\u001a\u00030ã\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bä\u0001\u0010å\u0001R\u0018\u0010æ\u0001\u001a\u00030ç\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bè\u0001\u0010é\u0001R\u000f\u0010ê\u0001\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010ë\u0001\u001a\u00030ì\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bí\u0001\u0010î\u0001R \u0010ï\u0001\u001a\n\u0012\u0005\u0012\u00030ñ\u00010ð\u0001X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0005\n\u0003\u0010ò\u0001R\u0018\u0010ó\u0001\u001a\u00030ô\u0001X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\bõ\u0001\u0010ö\u0001R\u0019\u0010÷\u0001\u001a\u00030ø\u0001X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0005\n\u0003\u0010ù\u0001R\u0010\u0010ú\u0001\u001a\u00030û\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010ü\u0001\u001a\u00030ý\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010þ\u0001\u001a\u00030ÿ\u00018VX\u0096\u0004¢\u0006\b\u001a\u0006\b\u0080\u0002\u0010\u0081\u0002R\u0018\u0010\u0082\u0002\u001a\u00030\u0083\u0002X\u0096\u0004¢\u0006\n\n\u0000\u001a\u0006\b\u0084\u0002\u0010\u0085\u0002R\u0012\u0010\u0086\u0002\u001a\u0005\u0018\u00010\u0087\u0002X\u0082\u000e¢\u0006\u0002\n\u0000R\u0019\u0010\u0088\u0002\u001a\u00030ø\u0001X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0005\n\u0003\u0010ù\u0001R!\u0010\u0089\u0002\u001a\u0004\u0018\u00010\u00128FX\u0086\u0084\u0002¢\u0006\u000f\n\u0006\b\u008b\u0002\u0010\u008c\u0002\u001a\u0005\b\u008a\u0002\u0010\u0015R\u000f\u0010\u008d\u0002\u001a\u00020mX\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\u008e\u0002\u001a\u00030\u008f\u00028VX\u0096\u0004¢\u0006\b\u001a\u0006\b\u0090\u0002\u0010\u0091\u0002R\u0018\u0010\u0092\u0002\u001a\u00030\u008b\u0001X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010rR\u0019\u0010\u0093\u0002\u001a\u00030ø\u0001X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0005\n\u0003\u0010ù\u0001R\u001b\u0010\u0094\u0002\u001a\u00020G*\u0002058BX\u0082\u0004¢\u0006\b\u001a\u0006\b\u0095\u0002\u0010\u0096\u0002\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u008a\u0004"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeView;", "Landroid/view/ViewGroup;", "Landroidx/compose/ui/node/Owner;", "Landroidx/compose/ui/platform/ViewRootForTest;", "Landroidx/compose/ui/input/pointer/PositionCalculator;", "Landroidx/lifecycle/DefaultLifecycleObserver;", "context", "Landroid/content/Context;", "coroutineContext", "Lkotlin/coroutines/CoroutineContext;", "(Landroid/content/Context;Lkotlin/coroutines/CoroutineContext;)V", "_androidViewsHandler", "Landroidx/compose/ui/platform/AndroidViewsHandler;", "_autofill", "Landroidx/compose/ui/autofill/AndroidAutofill;", "_inputModeManager", "Landroidx/compose/ui/input/InputModeManagerImpl;", "<set-?>", "Landroidx/compose/ui/platform/AndroidComposeView$ViewTreeOwners;", "_viewTreeOwners", "get_viewTreeOwners", "()Landroidx/compose/ui/platform/AndroidComposeView$ViewTreeOwners;", "set_viewTreeOwners", "(Landroidx/compose/ui/platform/AndroidComposeView$ViewTreeOwners;)V", "_viewTreeOwners$delegate", "Landroidx/compose/runtime/MutableState;", "_windowInfo", "Landroidx/compose/ui/platform/WindowInfoImpl;", "accessibilityManager", "Landroidx/compose/ui/platform/AndroidAccessibilityManager;", "getAccessibilityManager", "()Landroidx/compose/ui/platform/AndroidAccessibilityManager;", "androidViewsHandler", "getAndroidViewsHandler$ui_release", "()Landroidx/compose/ui/platform/AndroidViewsHandler;", "autofill", "Landroidx/compose/ui/autofill/Autofill;", "getAutofill", "()Landroidx/compose/ui/autofill/Autofill;", "autofillTree", "Landroidx/compose/ui/autofill/AutofillTree;", "getAutofillTree", "()Landroidx/compose/ui/autofill/AutofillTree;", "canvasHolder", "Landroidx/compose/ui/graphics/CanvasHolder;", "clipboardManager", "Landroidx/compose/ui/platform/AndroidClipboardManager;", "getClipboardManager", "()Landroidx/compose/ui/platform/AndroidClipboardManager;", "composeAccessibilityDelegate", "Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat;", "configurationChangeObserver", "Lkotlin/Function1;", "Landroid/content/res/Configuration;", "", "getConfigurationChangeObserver", "()Lkotlin/jvm/functions/Function1;", "setConfigurationChangeObserver", "(Lkotlin/jvm/functions/Function1;)V", "contentCaptureManager", "Landroidx/compose/ui/contentcapture/AndroidContentCaptureManager;", "getContentCaptureManager$ui_release", "()Landroidx/compose/ui/contentcapture/AndroidContentCaptureManager;", "setContentCaptureManager$ui_release", "(Landroidx/compose/ui/contentcapture/AndroidContentCaptureManager;)V", "value", "getCoroutineContext", "()Lkotlin/coroutines/CoroutineContext;", "setCoroutineContext", "(Lkotlin/coroutines/CoroutineContext;)V", "currentFontWeightAdjustment", "", "Landroidx/compose/ui/unit/Density;", "density", "getDensity", "()Landroidx/compose/ui/unit/Density;", "setDensity", "(Landroidx/compose/ui/unit/Density;)V", "density$delegate", "dirtyLayers", "", "Landroidx/compose/ui/node/OwnedLayer;", "dragAndDropManager", "Landroidx/compose/ui/draganddrop/DragAndDropManager;", "getDragAndDropManager", "()Landroidx/compose/ui/draganddrop/DragAndDropManager;", "dragAndDropModifierOnDragListener", "Landroidx/compose/ui/platform/DragAndDropModifierOnDragListener;", "endApplyChangesListeners", "Landroidx/compose/runtime/collection/MutableVector;", "Lkotlin/Function0;", "focusOwner", "Landroidx/compose/ui/focus/FocusOwner;", "getFocusOwner", "()Landroidx/compose/ui/focus/FocusOwner;", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "fontFamilyResolver", "getFontFamilyResolver", "()Landroidx/compose/ui/text/font/FontFamily$Resolver;", "setFontFamilyResolver", "(Landroidx/compose/ui/text/font/FontFamily$Resolver;)V", "fontFamilyResolver$delegate", "fontLoader", "Landroidx/compose/ui/text/font/Font$ResourceLoader;", "getFontLoader$annotations", "()V", "getFontLoader", "()Landroidx/compose/ui/text/font/Font$ResourceLoader;", "forceUseMatrixCache", "", "globalLayoutListener", "Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;", "globalPosition", "Landroidx/compose/ui/unit/IntOffset;", "J", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "getGraphicsContext", "()Landroidx/compose/ui/graphics/GraphicsContext;", "hapticFeedBack", "Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "getHapticFeedBack", "()Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "hasPendingMeasureOrLayout", "getHasPendingMeasureOrLayout", "()Z", "hoverExitReceived", "inputModeManager", "Landroidx/compose/ui/input/InputModeManager;", "getInputModeManager", "()Landroidx/compose/ui/input/InputModeManager;", "isDrawingContent", "isLifecycleInResumedState", "isPendingInteropViewLayoutChangeDispatch", "isRenderNodeCompatible", "keyInputModifier", "Landroidx/compose/ui/Modifier;", "keyboardModifiersRequireUpdate", "lastDownPointerPosition", "Landroidx/compose/ui/geometry/Offset;", "lastMatrixRecalculationAnimationTime", "", "getLastMatrixRecalculationAnimationTime$ui_release$annotations", "getLastMatrixRecalculationAnimationTime$ui_release", "()J", "setLastMatrixRecalculationAnimationTime$ui_release", "(J)V", "layerCache", "Landroidx/compose/ui/platform/WeakCache;", "Landroidx/compose/ui/unit/LayoutDirection;", "layoutDirection", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "setLayoutDirection", "(Landroidx/compose/ui/unit/LayoutDirection;)V", "layoutDirection$delegate", "legacyTextInputServiceAndroid", "Landroidx/compose/ui/text/input/TextInputServiceAndroid;", "matrixToWindow", "Landroidx/compose/ui/platform/CalculateMatrixToWindow;", "measureAndLayoutDelegate", "Landroidx/compose/ui/node/MeasureAndLayoutDelegate;", "measureIteration", "getMeasureIteration", "modifierLocalManager", "Landroidx/compose/ui/modifier/ModifierLocalManager;", "getModifierLocalManager", "()Landroidx/compose/ui/modifier/ModifierLocalManager;", "motionEventAdapter", "Landroidx/compose/ui/input/pointer/MotionEventAdapter;", "observationClearRequested", "onMeasureConstraints", "Landroidx/compose/ui/unit/Constraints;", "onViewTreeOwnersAvailable", "placementScope", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "getPlacementScope", "()Landroidx/compose/ui/layout/Placeable$PlacementScope;", "pointerIconService", "Landroidx/compose/ui/input/pointer/PointerIconService;", "getPointerIconService", "()Landroidx/compose/ui/input/pointer/PointerIconService;", "pointerInputEventProcessor", "Landroidx/compose/ui/input/pointer/PointerInputEventProcessor;", "postponedDirtyLayers", "previousMotionEvent", "Landroid/view/MotionEvent;", "relayoutTime", "resendMotionEventOnLayout", "resendMotionEventRunnable", "androidx/compose/ui/platform/AndroidComposeView$resendMotionEventRunnable$1", "Landroidx/compose/ui/platform/AndroidComposeView$resendMotionEventRunnable$1;", "root", "Landroidx/compose/ui/node/LayoutNode;", "getRoot", "()Landroidx/compose/ui/node/LayoutNode;", "rootForTest", "Landroidx/compose/ui/node/RootForTest;", "getRootForTest", "()Landroidx/compose/ui/node/RootForTest;", "rootSemanticsNode", "Landroidx/compose/ui/semantics/EmptySemanticsModifier;", "rotaryInputModifier", "scrollCapture", "Landroidx/compose/ui/scrollcapture/ScrollCapture;", "scrollCaptureInProgress", "getScrollCaptureInProgress$ui_release", "scrollChangedListener", "Landroid/view/ViewTreeObserver$OnScrollChangedListener;", "semanticsModifier", "Landroidx/compose/ui/semantics/EmptySemanticsElement;", "semanticsOwner", "Landroidx/compose/ui/semantics/SemanticsOwner;", "getSemanticsOwner", "()Landroidx/compose/ui/semantics/SemanticsOwner;", "sendHoverExitEvent", "Ljava/lang/Runnable;", "sharedDrawScope", "Landroidx/compose/ui/node/LayoutNodeDrawScope;", "getSharedDrawScope", "()Landroidx/compose/ui/node/LayoutNodeDrawScope;", "showLayoutBounds", "getShowLayoutBounds$annotations", "getShowLayoutBounds", "setShowLayoutBounds", "(Z)V", "snapshotObserver", "Landroidx/compose/ui/node/OwnerSnapshotObserver;", "getSnapshotObserver", "()Landroidx/compose/ui/node/OwnerSnapshotObserver;", "softwareKeyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "getSoftwareKeyboardController", "()Landroidx/compose/ui/platform/SoftwareKeyboardController;", "superclassInitComplete", "textInputService", "Landroidx/compose/ui/text/input/TextInputService;", "getTextInputService", "()Landroidx/compose/ui/text/input/TextInputService;", "textInputSessionMutex", "Landroidx/compose/ui/SessionMutex;", "Landroidx/compose/ui/platform/AndroidPlatformTextInputSession;", "Ljava/util/concurrent/atomic/AtomicReference;", "textToolbar", "Landroidx/compose/ui/platform/TextToolbar;", "getTextToolbar", "()Landroidx/compose/ui/platform/TextToolbar;", "tmpMatrix", "Landroidx/compose/ui/graphics/Matrix;", "[F", "tmpPositionArray", "", "touchModeChangeListener", "Landroid/view/ViewTreeObserver$OnTouchModeChangeListener;", "view", "Landroid/view/View;", "getView", "()Landroid/view/View;", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getViewConfiguration", "()Landroidx/compose/ui/platform/ViewConfiguration;", "viewLayersContainer", "Landroidx/compose/ui/platform/DrawChildContainer;", "viewToWindowMatrix", "viewTreeOwners", "getViewTreeOwners", "viewTreeOwners$delegate", "Landroidx/compose/runtime/State;", "wasMeasuredWithMultipleConstraints", "windowInfo", "Landroidx/compose/ui/platform/WindowInfo;", "getWindowInfo", "()Landroidx/compose/ui/platform/WindowInfo;", "windowPosition", "windowToViewMatrix", "fontWeightAdjustmentCompat", "getFontWeightAdjustmentCompat", "(Landroid/content/res/Configuration;)I", "addAndroidView", "Landroidx/compose/ui/viewinterop/AndroidViewHolder;", "layoutNode", "addExtraDataToAccessibilityNodeInfoHelper", "virtualViewId", "info", "Landroid/view/accessibility/AccessibilityNodeInfo;", "extraDataKey", "", "addView", "child", "params", "Landroid/view/ViewGroup$LayoutParams;", "index", "width", "height", "values", "Landroid/util/SparseArray;", "Landroid/view/autofill/AutofillValue;", "autofillSupported", "boundsUpdatesAccessibilityEventLoop", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "boundsUpdatesContentCaptureEventLoop", "calculateLocalPosition", "positionInWindow", "calculateLocalPosition-MK-Hz9U", "(J)J", "calculatePositionInWindow", "localPosition", "calculatePositionInWindow-MK-Hz9U", "canScrollHorizontally", "direction", "canScrollVertically", "clearChildInvalidObservations", "viewGroup", "convertMeasureSpec", "Lkotlin/ULong;", "measureSpec", "convertMeasureSpec-I7RO_PI", "(I)J", "createLayer", "drawBlock", "Lkotlin/Function2;", "Landroidx/compose/ui/graphics/Canvas;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "canvas", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "parentLayer", "invalidateParentLayer", "explicitLayer", "dispatchDraw", "Landroid/graphics/Canvas;", "dispatchGenericMotionEvent", "motionEvent", "dispatchHoverEvent", "event", "dispatchKeyEvent", "Landroid/view/KeyEvent;", "dispatchKeyEventPreIme", "dispatchPendingInteropLayoutCallbacks", "dispatchProvideStructure", "structure", "Landroid/view/ViewStructure;", "dispatchTouchEvent", "drawAndroidView", "findNextNonChildView", "findViewByAccessibilityIdRootedAtCurrentView", "accessibilityId", "currentView", "findViewByAccessibilityIdTraversal", "focusSearch", "focused", "forceAccessibilityForTesting", "enable", "forceMeasureTheSubtree", "affectsLookahead", "getFocusDirection", "Landroidx/compose/ui/focus/FocusDirection;", "keyEvent", "Landroidx/compose/ui/input/key/KeyEvent;", "getFocusDirection-P8AzH3I", "(Landroid/view/KeyEvent;)Landroidx/compose/ui/focus/FocusDirection;", "getFocusedRect", "rect", "Landroid/graphics/Rect;", "handleMotionEvent", "Landroidx/compose/ui/input/pointer/ProcessResult;", "handleMotionEvent-8iAsVTc", "(Landroid/view/MotionEvent;)I", "handleRotaryEvent", "hasChangedDevices", "lastEvent", "invalidateDescendants", "invalidateLayers", "node", "invalidateLayoutNodeMeasurement", "isBadMotionEvent", "isDevicePressEvent", "isInBounds", "isPositionChanged", "localToScreen", "localToScreen-MK-Hz9U", "localTransform", "localToScreen-58bKbWc", "([F)V", "measureAndLayout", "constraints", "measureAndLayout-0kLqBqw", "(Landroidx/compose/ui/node/LayoutNode;J)V", "sendPointerUpdate", "measureAndLayoutForTest", "notifyLayerIsDirty", "layer", "isDirty", "notifyLayerIsDirty$ui_release", "onAttach", "onAttachedToWindow", "onCheckIsTextEditor", "onClearFocusForOwner", "onConfigurationChanged", "newConfig", "onCreateInputConnection", "Landroid/view/inputmethod/InputConnection;", "outAttrs", "Landroid/view/inputmethod/EditorInfo;", "onCreateVirtualViewTranslationRequests", "virtualIds", "", "supportedFormats", "requestsCollector", "Ljava/util/function/Consumer;", "Landroid/view/translation/ViewTranslationRequest;", "onDetach", "onDetachedFromWindow", "onDraw", "onEndApplyChanges", "onFetchFocusRect", "Landroidx/compose/ui/geometry/Rect;", "onFocusChanged", "gainFocus", "previouslyFocusedRect", "onInteropViewLayoutChange", "Landroidx/compose/ui/viewinterop/InteropView;", "onLayout", "changed", "l", "t", "r", "b", "onLayoutChange", "onMeasure", "widthMeasureSpec", "heightMeasureSpec", "onMoveFocusInChildren", "focusDirection", "onMoveFocusInChildren-3ESFkO8", "(I)Z", "onProvideAutofillVirtualStructure", "flags", "onRequestFocusForOwner", "onRequestFocusForOwner-7o62pno", "onRequestMeasure", "forceRequest", "scheduleMeasureAndLayout", "onRequestRelayout", "onResume", "owner", "Landroidx/lifecycle/LifecycleOwner;", "onRtlPropertiesChanged", "onScrollCaptureSearch", "localVisibleRect", "windowOffset", "Landroid/graphics/Point;", "targets", "Landroid/view/ScrollCaptureTarget;", "onSemanticsChange", "onVirtualViewTranslationResponses", "response", "Landroid/util/LongSparseArray;", "Landroid/view/translation/ViewTranslationResponse;", "onWindowFocusChanged", "hasWindowFocus", "pack", "a", "pack-ZIaKswc", "(II)J", "recalculateWindowPosition", "recalculateWindowViewTransforms", "recycle", "recycle$ui_release", "registerOnEndApplyChangesListener", "listener", "registerOnLayoutCompletedListener", "Landroidx/compose/ui/node/Owner$OnLayoutCompletedListener;", "removeAndroidView", "requestClearInvalidObservations", "requestFocus", "requestOnPositionedCallback", "nodeToRemeasure", "screenToLocal", "positionOnScreen", "screenToLocal-MK-Hz9U", "sendKeyEvent", "sendKeyEvent-ZmokQxo", "(Landroid/view/KeyEvent;)Z", "sendMotionEvent", "sendMotionEvent-8iAsVTc", "sendSimulatedEvent", "action", "eventTime", "forceHover", "setAccessibilityEventBatchIntervalMillis", "intervalMillis", "setOnViewTreeOwnersAvailable", "callback", "shouldDelayChildPressedState", "startDrag", "transferData", "Landroidx/compose/ui/draganddrop/DragAndDropTransferData;", "decorationSize", "Landroidx/compose/ui/geometry/Size;", "drawDragDecoration", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "Lkotlin/ExtensionFunctionType;", "startDrag-12SF9DM", "(Landroidx/compose/ui/draganddrop/DragAndDropTransferData;JLkotlin/jvm/functions/Function1;)Z", "textInputSession", "", "session", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;", "Lkotlin/coroutines/Continuation;", "", "(Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePositionCacheAndDispatch", "childSizeCanAffectParentSize", "component1", "component1-VKZWuLQ", "(J)I", "component2", "component2-VKZWuLQ", "Companion", "ViewTreeOwners", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidComposeView extends ViewGroup implements Owner, ViewRootForTest, PositionCalculator, DefaultLifecycleObserver {
    private static Method getBooleanMethod;
    private static Class<?> systemPropertiesClass;
    private AndroidViewsHandler _androidViewsHandler;
    private final AndroidAutofill _autofill;
    private final InputModeManagerImpl _inputModeManager;

    private final MutableState _viewTreeOwners;
    private final WindowInfoImpl _windowInfo;
    private final AndroidAccessibilityManager accessibilityManager;
    private final AutofillTree autofillTree;
    private final CanvasHolder canvasHolder;
    private final AndroidClipboardManager clipboardManager;
    private final AndroidComposeViewAccessibilityDelegateCompat composeAccessibilityDelegate;
    private Function1<? super Configuration, Unit> configurationChangeObserver;
    private AndroidContentCaptureManager contentCaptureManager;
    private CoroutineContext coroutineContext;
    private int currentFontWeightAdjustment;

    private final MutableState density;
    private final List<OwnedLayer> dirtyLayers;
    private final DragAndDropManager dragAndDropManager;
    private final DragAndDropModifierOnDragListener dragAndDropModifierOnDragListener;
    private final MutableVector<Function0<Unit>> endApplyChangesListeners;
    private final FocusOwner focusOwner;

    private final MutableState fontFamilyResolver;
    private final Font.ResourceLoader fontLoader;
    private boolean forceUseMatrixCache;
    private final ViewTreeObserver.OnGlobalLayoutListener globalLayoutListener;
    private long globalPosition;
    private final GraphicsContext graphicsContext;
    private final HapticFeedback hapticFeedBack;
    private boolean hoverExitReceived;
    private boolean isDrawingContent;
    private boolean isPendingInteropViewLayoutChangeDispatch;
    private boolean isRenderNodeCompatible;
    private final Modifier keyInputModifier;
    private boolean keyboardModifiersRequireUpdate;
    private long lastDownPointerPosition;
    private long lastMatrixRecalculationAnimationTime;
    private final WeakCache<OwnedLayer> layerCache;

    private final MutableState layoutDirection;
    private final TextInputServiceAndroid legacyTextInputServiceAndroid;
    private final CalculateMatrixToWindow matrixToWindow;
    private final MeasureAndLayoutDelegate measureAndLayoutDelegate;
    private final ModifierLocalManager modifierLocalManager;
    private final MotionEventAdapter motionEventAdapter;
    private boolean observationClearRequested;
    private Constraints onMeasureConstraints;
    private Function1<? super ViewTreeOwners, Unit> onViewTreeOwnersAvailable;
    private final PointerIconService pointerIconService;
    private final PointerInputEventProcessor pointerInputEventProcessor;
    private List<OwnedLayer> postponedDirtyLayers;
    private MotionEvent previousMotionEvent;
    private long relayoutTime;
    private final Function0<Unit> resendMotionEventOnLayout;
    private final AndroidComposeView$resendMotionEventRunnable$1 resendMotionEventRunnable;
    private final LayoutNode root;
    private final RootForTest rootForTest;
    private final EmptySemanticsModifier rootSemanticsNode;
    private final Modifier rotaryInputModifier;
    private final ScrollCapture scrollCapture;
    private final ViewTreeObserver.OnScrollChangedListener scrollChangedListener;
    private final EmptySemanticsElement semanticsModifier;
    private final SemanticsOwner semanticsOwner;
    private final Runnable sendHoverExitEvent;
    private final LayoutNodeDrawScope sharedDrawScope;
    private boolean showLayoutBounds;
    private final OwnerSnapshotObserver snapshotObserver;
    private final SoftwareKeyboardController softwareKeyboardController;
    private boolean superclassInitComplete;
    private final TextInputService textInputService;
    private final AtomicReference<SessionMutex.Session<T>> textInputSessionMutex;
    private final TextToolbar textToolbar;
    private final float[] tmpMatrix;
    private final int[] tmpPositionArray;
    private final ViewTreeObserver.OnTouchModeChangeListener touchModeChangeListener;
    private final ViewConfiguration viewConfiguration;
    private DrawChildContainer viewLayersContainer;
    private final float[] viewToWindowMatrix;

    private final State viewTreeOwners;
    private boolean wasMeasuredWithMultipleConstraints;
    private long windowPosition;
    private final float[] windowToViewMatrix;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.AndroidComposeView", f = "AndroidComposeView.android.kt", i = {}, l = {592}, m = "textInputSession", n = {}, s = {})
    static final class C16971 extends ContinuationImpl {
        int label;
        Object result;

        C16971(Continuation<? super C16971> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AndroidComposeView.this.textInputSession(null, (Continuation) this);
        }
    }

    @Deprecated(message = "fontLoader is deprecated, use fontFamilyResolver", replaceWith = @ReplaceWith(expression = "fontFamilyResolver", imports = {}))
    public static void getFontLoader$annotations() {
    }

    public static void getLastMatrixRecalculationAnimationTime$ui_release$annotations() {
    }

    public static void getShowLayoutBounds$annotations() {
    }

    @Override
    public void onAttach(LayoutNode node) {
    }

    public void onCreate(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onCreate(this, lifecycleOwner);
    }

    public void onDestroy(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onDestroy(this, lifecycleOwner);
    }

    @Override
    protected void onDraw(Canvas canvas) {
    }

    public void onPause(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onPause(this, lifecycleOwner);
    }

    public void onStart(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStart(this, lifecycleOwner);
    }

    public void onStop(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStop(this, lifecycleOwner);
    }

    @Override
    public boolean shouldDelayChildPressedState() {
        return false;
    }

    public AndroidComposeView(Context context, CoroutineContext coroutineContext) throws KotlinNothingValueException {
        super(context);
        this.lastDownPointerPosition = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        this.superclassInitComplete = true;
        Object[] objArr = 0;
        Object[] objArr2 = 0;
        this.sharedDrawScope = new LayoutNodeDrawScope(0 == true ? 1 : 0, 1, 0 == true ? 1 : 0);
        this.density = SnapshotStateKt.mutableStateOf(AndroidDensity_androidKt.Density(context), SnapshotStateKt.referentialEqualityPolicy());
        EmptySemanticsModifier emptySemanticsModifier = new EmptySemanticsModifier();
        this.rootSemanticsNode = emptySemanticsModifier;
        EmptySemanticsElement emptySemanticsElement = new EmptySemanticsElement(emptySemanticsModifier);
        this.semanticsModifier = emptySemanticsElement;
        this.focusOwner = new FocusOwnerImpl(new AndroidComposeView$focusOwner$1(this), new AndroidComposeView$focusOwner$2(this), new AndroidComposeView$focusOwner$3(this), new AndroidComposeView$focusOwner$4(this), new AndroidComposeView$focusOwner$5(this), new MutablePropertyReference0Impl(this) {
            public Object get() {
                return ((AndroidComposeView) this.receiver).getLayoutDirection();
            }

            public void set(Object obj) {
                ((AndroidComposeView) this.receiver).setLayoutDirection((LayoutDirection) obj);
            }
        });
        DragAndDropModifierOnDragListener dragAndDropModifierOnDragListener = new DragAndDropModifierOnDragListener(new AndroidComposeView$dragAndDropModifierOnDragListener$1(this));
        this.dragAndDropModifierOnDragListener = dragAndDropModifierOnDragListener;
        this.coroutineContext = coroutineContext;
        this.dragAndDropManager = dragAndDropModifierOnDragListener;
        this._windowInfo = new WindowInfoImpl();
        Modifier modifierOnKeyEvent = KeyInputModifierKt.onKeyEvent(Modifier.INSTANCE, new Function1<KeyEvent, Boolean>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                return m6467invokeZmokQxo(((KeyEvent) obj).m5686unboximpl());
            }

            public final Boolean m6467invokeZmokQxo(android.view.KeyEvent keyEvent) {
                final FocusDirection focusDirectionMo6422getFocusDirectionP8AzH3I = this.this$0.mo6422getFocusDirectionP8AzH3I(keyEvent);
                if (focusDirectionMo6422getFocusDirectionP8AzH3I != null && KeyEventType.m5690equalsimpl0(KeyEvent_androidKt.m5698getTypeZmokQxo(keyEvent), KeyEventType.INSTANCE.m5694getKeyDownCS__XNY())) {
                    Rect rectOnFetchFocusRect = this.this$0.onFetchFocusRect();
                    Boolean boolMo4271focusSearchULY8qGw = this.this$0.getFocusOwner().mo4271focusSearchULY8qGw(focusDirectionMo6422getFocusDirectionP8AzH3I.getValue(), rectOnFetchFocusRect, new Function1<FocusTargetNode, Boolean>() {
                        {
                            super(1);
                        }

                        public final Boolean invoke(FocusTargetNode focusTargetNode) {
                            Boolean boolM4295requestFocusMxy_nc0 = FocusTransactionsKt.m4295requestFocusMxy_nc0(focusTargetNode, focusDirectionMo6422getFocusDirectionP8AzH3I.getValue());
                            return Boolean.valueOf(boolM4295requestFocusMxy_nc0 != null ? boolM4295requestFocusMxy_nc0.booleanValue() : true);
                        }
                    });
                    if (boolMo4271focusSearchULY8qGw != null ? boolMo4271focusSearchULY8qGw.booleanValue() : true) {
                        return true;
                    }
                    if (!FocusOwnerImplKt.m4281is1dFocusSearch3ESFkO8(focusDirectionMo6422getFocusDirectionP8AzH3I.getValue())) {
                        return false;
                    }
                    Integer numM4265toAndroidFocusDirection3ESFkO8 = FocusInteropUtils_androidKt.m4265toAndroidFocusDirection3ESFkO8(focusDirectionMo6422getFocusDirectionP8AzH3I.getValue());
                    if (numM4265toAndroidFocusDirection3ESFkO8 == null) {
                        throw new IllegalStateException("Invalid focus direction".toString());
                    }
                    int iIntValue = numM4265toAndroidFocusDirection3ESFkO8.intValue();
                    android.graphics.Rect androidRect = rectOnFetchFocusRect != null ? RectHelper_androidKt.toAndroidRect(rectOnFetchFocusRect) : null;
                    if (androidRect != null) {
                        View viewFindNextNonChildView = this.this$0.findNextNonChildView(iIntValue);
                        if (Intrinsics.areEqual(viewFindNextNonChildView, this.this$0)) {
                            viewFindNextNonChildView = null;
                        }
                        if ((viewFindNextNonChildView == null || !FocusInteropUtils_androidKt.requestInteropFocus(viewFindNextNonChildView, Integer.valueOf(iIntValue), androidRect)) && this.this$0.getFocusOwner().mo4268clearFocusI7lrPNg(false, true, false, focusDirectionMo6422getFocusDirectionP8AzH3I.getValue())) {
                            Boolean boolMo4271focusSearchULY8qGw2 = this.this$0.getFocusOwner().mo4271focusSearchULY8qGw(focusDirectionMo6422getFocusDirectionP8AzH3I.getValue(), null, new Function1<FocusTargetNode, Boolean>() {
                                {
                                    super(1);
                                }

                                public final Boolean invoke(FocusTargetNode focusTargetNode) {
                                    Boolean boolM4295requestFocusMxy_nc0 = FocusTransactionsKt.m4295requestFocusMxy_nc0(focusTargetNode, focusDirectionMo6422getFocusDirectionP8AzH3I.getValue());
                                    return Boolean.valueOf(boolM4295requestFocusMxy_nc0 != null ? boolM4295requestFocusMxy_nc0.booleanValue() : true);
                                }
                            });
                            return Boolean.valueOf(boolMo4271focusSearchULY8qGw2 != null ? boolMo4271focusSearchULY8qGw2.booleanValue() : true);
                        }
                        return true;
                    }
                    throw new IllegalStateException("Invalid rect".toString());
                }
                return false;
            }
        });
        this.keyInputModifier = modifierOnKeyEvent;
        Modifier modifierOnRotaryScrollEvent = RotaryInputModifierKt.onRotaryScrollEvent(Modifier.INSTANCE, new Function1<RotaryScrollEvent, Boolean>() {
            public final Boolean invoke(RotaryScrollEvent rotaryScrollEvent) {
                return false;
            }
        });
        this.rotaryInputModifier = modifierOnRotaryScrollEvent;
        this.canvasHolder = new CanvasHolder();
        LayoutNode layoutNode = new LayoutNode(false, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
        layoutNode.setMeasurePolicy(RootMeasurePolicy.INSTANCE);
        layoutNode.setDensity(getDensity());
        layoutNode.setModifier(Modifier.INSTANCE.then(emptySemanticsElement).then(modifierOnRotaryScrollEvent).then(modifierOnKeyEvent).then(getFocusOwner().getModifier()).then(dragAndDropModifierOnDragListener.getModifier()));
        this.root = layoutNode;
        this.rootForTest = this;
        this.semanticsOwner = new SemanticsOwner(getRoot(), emptySemanticsModifier);
        AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat = new AndroidComposeViewAccessibilityDelegateCompat(this);
        this.composeAccessibilityDelegate = androidComposeViewAccessibilityDelegateCompat;
        this.contentCaptureManager = new AndroidContentCaptureManager(this, new AndroidComposeView$contentCaptureManager$1(this));
        this.accessibilityManager = new AndroidAccessibilityManager(context);
        this.graphicsContext = AndroidGraphicsContext_androidKt.GraphicsContext(this);
        this.autofillTree = new AutofillTree();
        this.dirtyLayers = new ArrayList();
        this.motionEventAdapter = new MotionEventAdapter();
        this.pointerInputEventProcessor = new PointerInputEventProcessor(getRoot());
        this.configurationChangeObserver = new Function1<Configuration, Unit>() {
            public final void invoke(Configuration configuration) {
            }

            public Object invoke(Object obj) {
                invoke((Configuration) obj);
                return Unit.INSTANCE;
            }
        };
        this._autofill = autofillSupported() ? new AndroidAutofill(this, getAutofillTree()) : null;
        this.clipboardManager = new AndroidClipboardManager(context);
        this.snapshotObserver = new OwnerSnapshotObserver(new AndroidComposeView$snapshotObserver$1(this));
        this.measureAndLayoutDelegate = new MeasureAndLayoutDelegate(getRoot());
        this.viewConfiguration = new AndroidViewConfiguration(ViewConfiguration.get(context));
        this.globalPosition = IntOffsetKt.IntOffset(Integer.MAX_VALUE, Integer.MAX_VALUE);
        this.tmpPositionArray = new int[]{0, 0};
        float[] fArrM4828constructorimpl$default = Matrix.m4828constructorimpl$default(null, 1, null);
        this.tmpMatrix = fArrM4828constructorimpl$default;
        this.viewToWindowMatrix = Matrix.m4828constructorimpl$default(null, 1, null);
        this.windowToViewMatrix = Matrix.m4828constructorimpl$default(null, 1, null);
        this.lastMatrixRecalculationAnimationTime = -1L;
        this.windowPosition = Offset.INSTANCE.m4360getInfiniteF1C5BW0();
        this.isRenderNodeCompatible = true;
        this._viewTreeOwners = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        this.viewTreeOwners = SnapshotStateKt.derivedStateOf(new Function0<ViewTreeOwners>() {
            {
                super(0);
            }

            public final AndroidComposeView.ViewTreeOwners m6471invoke() {
                return this.this$0.get_viewTreeOwners();
            }
        });
        this.globalLayoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public final void onGlobalLayout() {
                this.f$0.updatePositionCacheAndDispatch();
            }
        };
        this.scrollChangedListener = new ViewTreeObserver.OnScrollChangedListener() {
            @Override
            public final void onScrollChanged() {
                this.f$0.updatePositionCacheAndDispatch();
            }
        };
        this.touchModeChangeListener = new ViewTreeObserver.OnTouchModeChangeListener() {
            @Override
            public final void onTouchModeChanged(boolean z) {
                AndroidComposeView.touchModeChangeListener$lambda$6(this.f$0, z);
            }
        };
        TextInputServiceAndroid textInputServiceAndroid = new TextInputServiceAndroid(getView(), this);
        this.legacyTextInputServiceAndroid = textInputServiceAndroid;
        this.textInputService = new TextInputService((PlatformTextInputService) AndroidComposeView_androidKt.getPlatformTextInputServiceInterceptor().invoke(textInputServiceAndroid));
        this.textInputSessionMutex = SessionMutex.m4174constructorimpl();
        this.softwareKeyboardController = new DelegatingSoftwareKeyboardController(getTextInputService());
        this.fontLoader = new AndroidFontResourceLoader(context);
        this.fontFamilyResolver = SnapshotStateKt.mutableStateOf(FontFamilyResolver_androidKt.createFontFamilyResolver(context), SnapshotStateKt.referentialEqualityPolicy());
        this.currentFontWeightAdjustment = getFontWeightAdjustmentCompat(context.getResources().getConfiguration());
        LayoutDirection layoutDirection = FocusInteropUtils_androidKt.toLayoutDirection(context.getResources().getConfiguration().getLayoutDirection());
        this.layoutDirection = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(layoutDirection == null ? LayoutDirection.Ltr : layoutDirection, null, 2, null);
        AndroidComposeView androidComposeView = this;
        this.hapticFeedBack = new PlatformHapticFeedback(androidComposeView);
        this._inputModeManager = new InputModeManagerImpl(isInTouchMode() ? InputMode.INSTANCE.m5380getTouchaOaMEAU() : InputMode.INSTANCE.m5379getKeyboardaOaMEAU(), new Function1<InputMode, Boolean>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                return m6459invokeiuPiT84(((InputMode) obj).getValue());
            }

            public final Boolean m6459invokeiuPiT84(int i) {
                boolean zRequestFocusFromTouch;
                if (InputMode.m5375equalsimpl0(i, InputMode.INSTANCE.m5380getTouchaOaMEAU())) {
                    zRequestFocusFromTouch = this.this$0.isInTouchMode();
                } else if (InputMode.m5375equalsimpl0(i, InputMode.INSTANCE.m5379getKeyboardaOaMEAU())) {
                    zRequestFocusFromTouch = this.this$0.isInTouchMode() ? this.this$0.requestFocusFromTouch() : true;
                } else {
                    zRequestFocusFromTouch = false;
                }
                return Boolean.valueOf(zRequestFocusFromTouch);
            }
        }, objArr2 == true ? 1 : 0);
        AndroidComposeView androidComposeView2 = this;
        this.modifierLocalManager = new ModifierLocalManager(androidComposeView2);
        this.textToolbar = new AndroidTextToolbar(androidComposeView);
        this.layerCache = new WeakCache<>();
        this.endApplyChangesListeners = new MutableVector<>(new Function0[16], 0);
        this.resendMotionEventRunnable = new Runnable() {
            @Override
            public void run() {
                this.this$0.removeCallbacks(this);
                MotionEvent motionEvent = this.this$0.previousMotionEvent;
                if (motionEvent != null) {
                    boolean z = motionEvent.getToolType(0) == 3;
                    int actionMasked = motionEvent.getActionMasked();
                    if (z) {
                        if (actionMasked == 10 || actionMasked == 1) {
                            return;
                        }
                    } else if (actionMasked == 1) {
                        return;
                    }
                    int i = 7;
                    if (actionMasked != 7 && actionMasked != 9) {
                        i = 2;
                    }
                    AndroidComposeView androidComposeView3 = this.this$0;
                    androidComposeView3.sendSimulatedEvent(motionEvent, i, androidComposeView3.relayoutTime, false);
                }
            }
        };
        this.sendHoverExitEvent = new Runnable() {
            @Override
            public final void run() {
                AndroidComposeView.sendHoverExitEvent$lambda$8(this.f$0);
            }
        };
        this.resendMotionEventOnLayout = new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m6469invoke();
                return Unit.INSTANCE;
            }

            public final void m6469invoke() {
                MotionEvent motionEvent = this.this$0.previousMotionEvent;
                if (motionEvent != null) {
                    int actionMasked = motionEvent.getActionMasked();
                    if (actionMasked == 7 || actionMasked == 9) {
                        this.this$0.relayoutTime = SystemClock.uptimeMillis();
                        AndroidComposeView androidComposeView3 = this.this$0;
                        androidComposeView3.post(androidComposeView3.resendMotionEventRunnable);
                    }
                }
            }
        };
        this.matrixToWindow = Build.VERSION.SDK_INT < 29 ? new CalculateMatrixToWindowApi21(fArrM4828constructorimpl$default, objArr == true ? 1 : 0) : new CalculateMatrixToWindowApi29();
        addOnAttachStateChangeListener(this.contentCaptureManager);
        setWillNotDraw(false);
        setFocusable(true);
        if (Build.VERSION.SDK_INT >= 26) {
            AndroidComposeViewVerificationHelperMethodsO.INSTANCE.focusable(androidComposeView, 1, false);
        }
        setFocusableInTouchMode(true);
        setClipChildren(false);
        ViewCompat.setAccessibilityDelegate(androidComposeView, androidComposeViewAccessibilityDelegateCompat);
        Function1<ViewRootForTest, Unit> onViewCreatedCallback = ViewRootForTest.INSTANCE.getOnViewCreatedCallback();
        if (onViewCreatedCallback != null) {
            onViewCreatedCallback.invoke(this);
        }
        setOnDragListener(dragAndDropModifierOnDragListener);
        getRoot().attach$ui_release(androidComposeView2);
        if (Build.VERSION.SDK_INT >= 29) {
            AndroidComposeViewForceDarkModeQ.INSTANCE.disallowForceDark(androidComposeView);
        }
        this.scrollCapture = Build.VERSION.SDK_INT >= 31 ? new ScrollCapture() : null;
        this.pointerIconService = new PointerIconService() {
            private PointerIcon currentIcon = PointerIcon.INSTANCE.getDefault();

            @Override
            public PointerIcon getCurrentIcon() {
                return this.currentIcon;
            }

            @Override
            public void setIcon(PointerIcon value) {
                if (value == null) {
                    value = PointerIcon.INSTANCE.getDefault();
                }
                this.currentIcon = value;
                if (Build.VERSION.SDK_INT >= 24) {
                    AndroidComposeViewVerificationHelperMethodsN.INSTANCE.setPointerIcon(this.this$0, this.currentIcon);
                }
            }
        };
    }

    @Override
    public LayoutNodeDrawScope getSharedDrawScope() {
        return this.sharedDrawScope;
    }

    @Override
    public View getView() {
        return this;
    }

    private void setDensity(Density density) {
        this.density.setValue(density);
    }

    @Override
    public Density getDensity() {
        return (Density) this.density.getValue();
    }

    @Override
    public FocusOwner getFocusOwner() {
        return this.focusOwner;
    }

    @Override
    public CoroutineContext getCoroutineContext() {
        return this.coroutineContext;
    }

    public void setCoroutineContext(CoroutineContext coroutineContext) throws KotlinNothingValueException {
        this.coroutineContext = coroutineContext;
        DelegatableNode head = getRoot().getNodes().getHead();
        if (head instanceof SuspendingPointerInputModifierNode) {
            ((SuspendingPointerInputModifierNode) head).resetPointerInputHandler();
        }
        DelegatableNode delegatableNode = head;
        int iM6367constructorimpl = NodeKind.m6367constructorimpl(16);
        if (!delegatableNode.getNode().getIsAttached()) {
            InlineClassHelperKt.throwIllegalStateException("visitSubtree called on an unattached node");
        }
        Modifier.Node child = delegatableNode.getNode().getChild();
        LayoutNode layoutNodeRequireLayoutNode = DelegatableNodeKt.requireLayoutNode(delegatableNode);
        NestedVectorStack nestedVectorStack = new NestedVectorStack();
        while (layoutNodeRequireLayoutNode != null) {
            if (child == null) {
                child = layoutNodeRequireLayoutNode.getNodes().getHead();
            }
            if ((child.getAggregateChildKindSet() & iM6367constructorimpl) != 0) {
                while (child != null) {
                    if ((child.getKindSet() & iM6367constructorimpl) != 0) {
                        Modifier.Node nodePop = child;
                        MutableVector mutableVector = null;
                        while (nodePop != 0) {
                            if (nodePop instanceof PointerInputModifierNode) {
                                PointerInputModifierNode pointerInputModifierNode = (PointerInputModifierNode) nodePop;
                                if (pointerInputModifierNode instanceof SuspendingPointerInputModifierNode) {
                                    ((SuspendingPointerInputModifierNode) pointerInputModifierNode).resetPointerInputHandler();
                                }
                            } else if ((nodePop.getKindSet() & iM6367constructorimpl) != 0 && (nodePop instanceof DelegatingNode)) {
                                Modifier.Node delegate$ui_release = ((DelegatingNode) nodePop).getDelegate();
                                int i = 0;
                                nodePop = nodePop;
                                while (delegate$ui_release != null) {
                                    if ((delegate$ui_release.getKindSet() & iM6367constructorimpl) != 0) {
                                        i++;
                                        if (i == 1) {
                                            nodePop = delegate$ui_release;
                                        } else {
                                            if (mutableVector == null) {
                                                mutableVector = new MutableVector(new Modifier.Node[16], 0);
                                            }
                                            if (nodePop != 0) {
                                                if (mutableVector != null) {
                                                    mutableVector.add(nodePop);
                                                }
                                                nodePop = 0;
                                            }
                                            if (mutableVector != null) {
                                                mutableVector.add(delegate$ui_release);
                                            }
                                        }
                                    }
                                    delegate$ui_release = delegate$ui_release.getChild();
                                    nodePop = nodePop;
                                }
                                if (i == 1) {
                                }
                            }
                            nodePop = DelegatableNodeKt.pop(mutableVector);
                        }
                    }
                    child = child.getChild();
                }
            }
            nestedVectorStack.push(layoutNodeRequireLayoutNode.get_children$ui_release());
            layoutNodeRequireLayoutNode = nestedVectorStack.isNotEmpty() ? (LayoutNode) nestedVectorStack.pop() : null;
            child = null;
        }
    }

    @Override
    public DragAndDropManager getDragAndDropManager() {
        return this.dragAndDropManager;
    }

    @Override
    public WindowInfo getWindowInfo() {
        return this._windowInfo;
    }

    public final boolean m6452onMoveFocusInChildren3ESFkO8(int focusDirection) {
        View viewFindNextFocusFromRect;
        if (FocusDirection.m4251equalsimpl0(focusDirection, FocusDirection.INSTANCE.m4258getEnterdhqQ8s()) || FocusDirection.m4251equalsimpl0(focusDirection, FocusDirection.INSTANCE.m4259getExitdhqQ8s())) {
            return false;
        }
        Integer numM4265toAndroidFocusDirection3ESFkO8 = FocusInteropUtils_androidKt.m4265toAndroidFocusDirection3ESFkO8(focusDirection);
        if (numM4265toAndroidFocusDirection3ESFkO8 == null) {
            throw new IllegalStateException("Invalid focus direction".toString());
        }
        int iIntValue = numM4265toAndroidFocusDirection3ESFkO8.intValue();
        Rect rectOnFetchFocusRect = onFetchFocusRect();
        android.graphics.Rect androidRect = rectOnFetchFocusRect != null ? RectHelper_androidKt.toAndroidRect(rectOnFetchFocusRect) : null;
        FocusFinder focusFinder = FocusFinder.getInstance();
        if (androidRect == null) {
            viewFindNextFocusFromRect = focusFinder.findNextFocus(this, findFocus(), iIntValue);
        } else {
            viewFindNextFocusFromRect = focusFinder.findNextFocusFromRect(this, androidRect, iIntValue);
        }
        if (viewFindNextFocusFromRect != null) {
            return FocusInteropUtils_androidKt.requestInteropFocus(viewFindNextFocusFromRect, Integer.valueOf(iIntValue), androidRect);
        }
        return false;
    }

    public final Rect onFetchFocusRect() {
        if (isFocused()) {
            return getFocusOwner().getFocusRect();
        }
        View viewFindFocus = findFocus();
        if (viewFindFocus != null) {
            return FocusInteropUtils_androidKt.calculateBoundingRect(viewFindFocus);
        }
        return null;
    }

    public final View findNextNonChildView(int direction) {
        AndroidComposeView androidComposeView = this;
        View viewFindNextFocus = androidComposeView;
        while (viewFindNextFocus != null) {
            FocusFinder focusFinder = FocusFinder.getInstance();
            View rootView = getRootView();
            Intrinsics.checkNotNull(rootView, "null cannot be cast to non-null type android.view.ViewGroup");
            viewFindNextFocus = focusFinder.findNextFocus((ViewGroup) rootView, viewFindNextFocus, direction);
            if (viewFindNextFocus != null && !AndroidComposeView_androidKt.containsDescendant(androidComposeView, viewFindNextFocus)) {
                return viewFindNextFocus;
            }
        }
        return null;
    }

    @Override
    public LayoutNode getRoot() {
        return this.root;
    }

    @Override
    public RootForTest getRootForTest() {
        return this.rootForTest;
    }

    @Override
    public SemanticsOwner getSemanticsOwner() {
        return this.semanticsOwner;
    }

    public final AndroidContentCaptureManager getContentCaptureManager() {
        return this.contentCaptureManager;
    }

    public final void setContentCaptureManager$ui_release(AndroidContentCaptureManager androidContentCaptureManager) {
        this.contentCaptureManager = androidContentCaptureManager;
    }

    @Override
    public AndroidAccessibilityManager getAccessibilityManager() {
        return this.accessibilityManager;
    }

    @Override
    public GraphicsContext getGraphicsContext() {
        return this.graphicsContext;
    }

    @Override
    public AutofillTree getAutofillTree() {
        return this.autofillTree;
    }

    public final Function1<Configuration, Unit> getConfigurationChangeObserver() {
        return this.configurationChangeObserver;
    }

    public final void setConfigurationChangeObserver(Function1<? super Configuration, Unit> function1) {
        this.configurationChangeObserver = function1;
    }

    @Override
    public Autofill getAutofill() {
        return this._autofill;
    }

    @Override
    public AndroidClipboardManager getClipboardManager() {
        return this.clipboardManager;
    }

    @Override
    public OwnerSnapshotObserver getSnapshotObserver() {
        return this.snapshotObserver;
    }

    @Override
    public boolean getShowLayoutBounds() {
        return this.showLayoutBounds;
    }

    @Override
    public void setShowLayoutBounds(boolean z) {
        this.showLayoutBounds = z;
    }

    public final AndroidViewsHandler getAndroidViewsHandler$ui_release() {
        if (this._androidViewsHandler == null) {
            AndroidViewsHandler androidViewsHandler = new AndroidViewsHandler(getContext());
            this._androidViewsHandler = androidViewsHandler;
            addView(androidViewsHandler);
            requestLayout();
        }
        AndroidViewsHandler androidViewsHandler2 = this._androidViewsHandler;
        Intrinsics.checkNotNull(androidViewsHandler2);
        return androidViewsHandler2;
    }

    @Override
    public long getMeasureIteration() {
        return this.measureAndLayoutDelegate.getMeasureIteration();
    }

    @Override
    public ViewConfiguration getViewConfiguration() {
        return this.viewConfiguration;
    }

    @Override
    public boolean getHasPendingMeasureOrLayout() {
        return this.measureAndLayoutDelegate.getHasPendingMeasureOrLayout();
    }

    public final long getLastMatrixRecalculationAnimationTime() {
        return this.lastMatrixRecalculationAnimationTime;
    }

    public final void setLastMatrixRecalculationAnimationTime$ui_release(long j) {
        this.lastMatrixRecalculationAnimationTime = j;
    }

    public final ViewTreeOwners get_viewTreeOwners() {
        return (ViewTreeOwners) this._viewTreeOwners.getValue();
    }

    private final void set_viewTreeOwners(ViewTreeOwners viewTreeOwners) {
        this._viewTreeOwners.setValue(viewTreeOwners);
    }

    public final ViewTreeOwners getViewTreeOwners() {
        return (ViewTreeOwners) this.viewTreeOwners.getValue();
    }

    public static final void touchModeChangeListener$lambda$6(AndroidComposeView androidComposeView, boolean z) {
        androidComposeView._inputModeManager.m5383setInputModeiuPiT84(z ? InputMode.INSTANCE.m5380getTouchaOaMEAU() : InputMode.INSTANCE.m5379getKeyboardaOaMEAU());
    }

    @Override
    public TextInputService getTextInputService() {
        return this.textInputService;
    }

    @Override
    public SoftwareKeyboardController getSoftwareKeyboardController() {
        return this.softwareKeyboardController;
    }

    @Override
    public Placeable.PlacementScope getPlacementScope() {
        return PlaceableKt.PlacementScope(this);
    }

    @Override
    public Object textInputSession(Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, Continuation<?> continuation) throws KotlinNothingValueException {
        C16971 c16971;
        if (continuation instanceof C16971) {
            c16971 = (C16971) continuation;
            if ((c16971.label & Integer.MIN_VALUE) != 0) {
                c16971.label -= Integer.MIN_VALUE;
            } else {
                c16971 = new C16971(continuation);
            }
        } else {
            c16971 = new C16971(continuation);
        }
        Object obj = c16971.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c16971.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            AtomicReference<SessionMutex.Session<T>> atomicReference = this.textInputSessionMutex;
            Function1<CoroutineScope, AndroidPlatformTextInputSession> function1 = new Function1<CoroutineScope, AndroidPlatformTextInputSession>() {
                {
                    super(1);
                }

                public final AndroidPlatformTextInputSession invoke(CoroutineScope coroutineScope) {
                    AndroidComposeView androidComposeView = AndroidComposeView.this;
                    return new AndroidPlatformTextInputSession(androidComposeView, androidComposeView.getTextInputService(), coroutineScope);
                }
            };
            c16971.label = 1;
            if (SessionMutex.m4181withSessionCancellingPreviousimpl(atomicReference, function1, function2, c16971) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }

    @Override
    public Font.ResourceLoader getFontLoader() {
        return this.fontLoader;
    }

    private void setFontFamilyResolver(FontFamily.Resolver resolver) {
        this.fontFamilyResolver.setValue(resolver);
    }

    @Override
    public FontFamily.Resolver getFontFamilyResolver() {
        return (FontFamily.Resolver) this.fontFamilyResolver.getValue();
    }

    private final int getFontWeightAdjustmentCompat(Configuration configuration) {
        if (Build.VERSION.SDK_INT >= 31) {
            return configuration.fontWeightAdjustment;
        }
        return 0;
    }

    public void setLayoutDirection(LayoutDirection layoutDirection) {
        this.layoutDirection.setValue(layoutDirection);
    }

    @Override
    public LayoutDirection getLayoutDirection() {
        return (LayoutDirection) this.layoutDirection.getValue();
    }

    @Override
    public HapticFeedback getHapticFeedBack() {
        return this.hapticFeedBack;
    }

    @Override
    public InputModeManager getInputModeManager() {
        return this._inputModeManager;
    }

    @Override
    public ModifierLocalManager getModifierLocalManager() {
        return this.modifierLocalManager;
    }

    @Override
    public TextToolbar getTextToolbar() {
        return this.textToolbar;
    }

    public static final void sendHoverExitEvent$lambda$8(AndroidComposeView androidComposeView) {
        androidComposeView.hoverExitReceived = false;
        MotionEvent motionEvent = androidComposeView.previousMotionEvent;
        Intrinsics.checkNotNull(motionEvent);
        if (motionEvent.getActionMasked() != 10) {
            throw new IllegalStateException("The ACTION_HOVER_EXIT event was not cleared.".toString());
        }
        androidComposeView.m6455sendMotionEvent8iAsVTc(motionEvent);
    }

    @Override
    public void getFocusedRect(android.graphics.Rect rect) {
        Unit unit;
        Rect rectOnFetchFocusRect = onFetchFocusRect();
        if (rectOnFetchFocusRect != null) {
            rect.left = Math.round(rectOnFetchFocusRect.getLeft());
            rect.top = Math.round(rectOnFetchFocusRect.getTop());
            rect.right = Math.round(rectOnFetchFocusRect.getRight());
            rect.bottom = Math.round(rectOnFetchFocusRect.getBottom());
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            super.getFocusedRect(rect);
        }
    }

    @Override
    public void dispatchProvideStructure(ViewStructure structure) {
        if (Build.VERSION.SDK_INT < 28) {
            AndroidComposeViewAssistHelperMethodsO.INSTANCE.setClassName(structure, getView());
        } else {
            super.dispatchProvideStructure(structure);
        }
    }

    public final boolean getScrollCaptureInProgress$ui_release() {
        ScrollCapture scrollCapture;
        if (Build.VERSION.SDK_INT < 31 || (scrollCapture = this.scrollCapture) == null) {
            return false;
        }
        return scrollCapture.getScrollCaptureInProgress();
    }

    @Override
    public void onScrollCaptureSearch(android.graphics.Rect localVisibleRect, Point windowOffset, Consumer<ScrollCaptureTarget> targets) {
        ScrollCapture scrollCapture;
        if (Build.VERSION.SDK_INT < 31 || (scrollCapture = this.scrollCapture) == null) {
            return;
        }
        scrollCapture.onScrollCaptureSearch(this, getSemanticsOwner(), getCoroutineContext(), targets);
    }

    public void onResume(LifecycleOwner owner) {
        setShowLayoutBounds(INSTANCE.getIsShowingLayoutBounds());
    }

    @Override
    public View focusSearch(View focused, int direction) {
        if (focused != null) {
            Rect rectCalculateBoundingRect = FocusInteropUtils_androidKt.calculateBoundingRect(focused);
            FocusDirection focusDirection = FocusInteropUtils_androidKt.toFocusDirection(direction);
            if (Intrinsics.areEqual(getFocusOwner().mo4271focusSearchULY8qGw(focusDirection != null ? focusDirection.getValue() : FocusDirection.INSTANCE.m4257getDowndhqQ8s(), rectCalculateBoundingRect, new Function1<FocusTargetNode, Boolean>() {
                public final Boolean invoke(FocusTargetNode focusTargetNode) {
                    return true;
                }
            }), true)) {
                return this;
            }
        }
        return super.focusSearch(focused, direction);
    }

    @Override
    public boolean requestFocus(int direction, android.graphics.Rect previouslyFocusedRect) {
        if (isFocused()) {
            return true;
        }
        if (getFocusOwner().getRootState().getHasFocus()) {
            return super.requestFocus(direction, previouslyFocusedRect);
        }
        FocusDirection focusDirection = FocusInteropUtils_androidKt.toFocusDirection(direction);
        final int value = focusDirection != null ? focusDirection.getValue() : FocusDirection.INSTANCE.m4258getEnterdhqQ8s();
        Boolean boolMo4271focusSearchULY8qGw = getFocusOwner().mo4271focusSearchULY8qGw(value, previouslyFocusedRect != null ? RectHelper_androidKt.toComposeRect(previouslyFocusedRect) : null, new Function1<FocusTargetNode, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(FocusTargetNode focusTargetNode) {
                Boolean boolM4295requestFocusMxy_nc0 = FocusTransactionsKt.m4295requestFocusMxy_nc0(focusTargetNode, value);
                return Boolean.valueOf(boolM4295requestFocusMxy_nc0 != null ? boolM4295requestFocusMxy_nc0.booleanValue() : false);
            }
        });
        if (boolMo4271focusSearchULY8qGw != null) {
            return boolMo4271focusSearchULY8qGw.booleanValue();
        }
        return false;
    }

    public final boolean m6453onRequestFocusForOwner7o62pno(FocusDirection focusDirection, Rect previouslyFocusedRect) {
        Integer numM4265toAndroidFocusDirection3ESFkO8;
        if (isFocused() || hasFocus()) {
            return true;
        }
        return super.requestFocus((focusDirection == null || (numM4265toAndroidFocusDirection3ESFkO8 = FocusInteropUtils_androidKt.m4265toAndroidFocusDirection3ESFkO8(focusDirection.getValue())) == null) ? 130 : numM4265toAndroidFocusDirection3ESFkO8.intValue(), previouslyFocusedRect != null ? RectHelper_androidKt.toAndroidRect(previouslyFocusedRect) : null);
    }

    public final void onClearFocusForOwner() {
        if (isFocused() || hasFocus()) {
            super.clearFocus();
        }
    }

    @Override
    protected void onFocusChanged(boolean gainFocus, int direction, android.graphics.Rect previouslyFocusedRect) {
        super.onFocusChanged(gainFocus, direction, previouslyFocusedRect);
        if (gainFocus || hasFocus()) {
            return;
        }
        getFocusOwner().releaseFocus();
    }

    @Override
    public void onWindowFocusChanged(boolean hasWindowFocus) {
        boolean isShowingLayoutBounds;
        this._windowInfo.setWindowFocused(hasWindowFocus);
        this.keyboardModifiersRequireUpdate = true;
        super.onWindowFocusChanged(hasWindowFocus);
        if (!hasWindowFocus || getShowLayoutBounds() == (isShowingLayoutBounds = INSTANCE.getIsShowingLayoutBounds())) {
            return;
        }
        setShowLayoutBounds(isShowingLayoutBounds);
        invalidateDescendants();
    }

    @Override
    public boolean mo6425sendKeyEventZmokQxo(android.view.KeyEvent keyEvent) {
        return getFocusOwner().mo4269dispatchInterceptedSoftKeyboardEventZmokQxo(keyEvent) || FocusOwner.CC.m4274dispatchKeyEventYhN2O0w$default(getFocusOwner(), keyEvent, null, 2, null);
    }

    @Override
    public boolean dispatchKeyEvent(final android.view.KeyEvent event) {
        if (isFocused()) {
            this._windowInfo.m6590setKeyboardModifiers5xRPYO0(PointerKeyboardModifiers.m5910constructorimpl(event.getMetaState()));
            return FocusOwner.CC.m4274dispatchKeyEventYhN2O0w$default(getFocusOwner(), KeyEvent.m5681constructorimpl(event), null, 2, null) || super.dispatchKeyEvent(event);
        }
        return getFocusOwner().mo4270dispatchKeyEventYhN2O0w(KeyEvent.m5681constructorimpl(event), new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m6461invoke() {
                return Boolean.valueOf(AndroidComposeView.super.dispatchKeyEvent(event));
            }
        });
    }

    @Override
    public boolean dispatchKeyEventPreIme(android.view.KeyEvent event) {
        return (isFocused() && getFocusOwner().mo4269dispatchInterceptedSoftKeyboardEventZmokQxo(KeyEvent.m5681constructorimpl(event))) || super.dispatchKeyEventPreIme(event);
    }

    @Override
    public void forceAccessibilityForTesting(boolean enable) {
        this.composeAccessibilityDelegate.setAccessibilityForceEnabledForTesting$ui_release(enable);
    }

    @Override
    public void setAccessibilityEventBatchIntervalMillis(long intervalMillis) {
        this.composeAccessibilityDelegate.setSendRecurringAccessibilityEventsIntervalMillis$ui_release(intervalMillis);
    }

    @Override
    public void onDetach(LayoutNode node) {
        this.measureAndLayoutDelegate.onNodeDetached(node);
        requestClearInvalidObservations();
    }

    public final void requestClearInvalidObservations() {
        this.observationClearRequested = true;
    }

    @Override
    public void onEndApplyChanges() {
        if (this.observationClearRequested) {
            getSnapshotObserver().clearInvalidObservations$ui_release();
            this.observationClearRequested = false;
        }
        AndroidViewsHandler androidViewsHandler = this._androidViewsHandler;
        if (androidViewsHandler != null) {
            clearChildInvalidObservations(androidViewsHandler);
        }
        while (this.endApplyChangesListeners.isNotEmpty()) {
            int size = this.endApplyChangesListeners.getSize();
            for (int i = 0; i < size; i++) {
                Function0<Unit> function0 = this.endApplyChangesListeners.getContent()[i];
                this.endApplyChangesListeners.set(i, null);
                if (function0 != null) {
                    function0.invoke();
                }
            }
            this.endApplyChangesListeners.removeRange(0, size);
        }
    }

    @Override
    public void registerOnEndApplyChangesListener(Function0<Unit> listener) {
        if (this.endApplyChangesListeners.contains(listener)) {
            return;
        }
        this.endApplyChangesListeners.add(listener);
    }

    public final boolean m6456startDrag12SF9DM(DragAndDropTransferData transferData, long decorationSize, Function1<? super DrawScope, Unit> drawDragDecoration) {
        Resources resources = getContext().getResources();
        ComposeDragShadowBuilder composeDragShadowBuilder = new ComposeDragShadowBuilder(DensityKt.Density(resources.getDisplayMetrics().density, resources.getConfiguration().fontScale), decorationSize, drawDragDecoration, null);
        if (Build.VERSION.SDK_INT >= 24) {
            return AndroidComposeViewStartDragAndDropN.INSTANCE.startDragAndDrop(this, transferData, composeDragShadowBuilder);
        }
        return startDrag(transferData.getClipData(), composeDragShadowBuilder, transferData.getLocalState(), transferData.getFlags());
    }

    private final void clearChildInvalidObservations(ViewGroup viewGroup) {
        int childCount = viewGroup.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = viewGroup.getChildAt(i);
            if (childAt instanceof AndroidComposeView) {
                ((AndroidComposeView) childAt).onEndApplyChanges();
            } else if (childAt instanceof ViewGroup) {
                clearChildInvalidObservations((ViewGroup) childAt);
            }
        }
    }

    public final void addExtraDataToAccessibilityNodeInfoHelper(int virtualViewId, AccessibilityNodeInfo info, String extraDataKey) {
        int orDefault;
        if (Intrinsics.areEqual(extraDataKey, this.composeAccessibilityDelegate.getExtraDataTestTraversalBeforeVal())) {
            int orDefault2 = this.composeAccessibilityDelegate.getIdToBeforeMap().getOrDefault(virtualViewId, -1);
            if (orDefault2 != -1) {
                info.getExtras().putInt(extraDataKey, orDefault2);
                return;
            }
            return;
        }
        if (!Intrinsics.areEqual(extraDataKey, this.composeAccessibilityDelegate.getExtraDataTestTraversalAfterVal()) || (orDefault = this.composeAccessibilityDelegate.getIdToAfterMap().getOrDefault(virtualViewId, -1)) == -1) {
            return;
        }
        info.getExtras().putInt(extraDataKey, orDefault);
    }

    @Override
    public void addView(View child) {
        addView(child, -1);
    }

    @Override
    public void addView(View child, int index) {
        Intrinsics.checkNotNull(child);
        ViewGroup.LayoutParams layoutParams = child.getLayoutParams();
        if (layoutParams == null) {
            layoutParams = generateDefaultLayoutParams();
        }
        addView(child, index, layoutParams);
    }

    @Override
    public void addView(View child, int width, int height) {
        ViewGroup.LayoutParams layoutParamsGenerateDefaultLayoutParams = generateDefaultLayoutParams();
        layoutParamsGenerateDefaultLayoutParams.width = width;
        layoutParamsGenerateDefaultLayoutParams.height = height;
        Unit unit = Unit.INSTANCE;
        addView(child, -1, layoutParamsGenerateDefaultLayoutParams);
    }

    @Override
    public void addView(View child, ViewGroup.LayoutParams params) {
        addView(child, -1, params);
    }

    @Override
    public void addView(View child, int index, ViewGroup.LayoutParams params) {
        addViewInLayout(child, index, params, true);
    }

    public final void addAndroidView(AndroidViewHolder view, final LayoutNode layoutNode) {
        getAndroidViewsHandler$ui_release().getHolderToLayoutNode().put(view, layoutNode);
        View view2 = (View) view;
        getAndroidViewsHandler$ui_release().addView(view2);
        getAndroidViewsHandler$ui_release().getLayoutNodeToHolder().put(layoutNode, view);
        view.setImportantForAccessibility(1);
        ViewCompat.setAccessibilityDelegate(view2, new AccessibilityDelegateCompat() {
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfoCompat info) {
                super.onInitializeAccessibilityNodeInfo(host, info);
                if (AndroidComposeView.this.composeAccessibilityDelegate.isEnabled$ui_release()) {
                    info.setVisibleToUser(false);
                }
                LayoutNode layoutNodeFindClosestParentNode = SemanticsNodeKt.findClosestParentNode(layoutNode, new Function1<LayoutNode, Boolean>() {
                    public final Boolean invoke(LayoutNode layoutNode2) {
                        return Boolean.valueOf(layoutNode2.getNodes().m6322hasH91voCI$ui_release(NodeKind.m6367constructorimpl(8)));
                    }
                });
                Integer numValueOf = layoutNodeFindClosestParentNode != null ? Integer.valueOf(layoutNodeFindClosestParentNode.getSemanticsId()) : null;
                if (numValueOf != null) {
                    if (numValueOf.intValue() == AndroidComposeView.this.getSemanticsOwner().getUnmergedRootSemanticsNode().getId()) {
                        numValueOf = -1;
                    }
                } else {
                    numValueOf = -1;
                }
                info.setParent(this, numValueOf.intValue());
                int semanticsId = layoutNode.getSemanticsId();
                int orDefault = AndroidComposeView.this.composeAccessibilityDelegate.getIdToBeforeMap().getOrDefault(semanticsId, -1);
                if (orDefault != -1) {
                    View viewSemanticsIdToView = SemanticsUtils_androidKt.semanticsIdToView(AndroidComposeView.this.getAndroidViewsHandler$ui_release(), orDefault);
                    if (viewSemanticsIdToView != null) {
                        info.setTraversalBefore(viewSemanticsIdToView);
                    } else {
                        info.setTraversalBefore(this, orDefault);
                    }
                    AndroidComposeView.this.addExtraDataToAccessibilityNodeInfoHelper(semanticsId, info.unwrap(), AndroidComposeView.this.composeAccessibilityDelegate.getExtraDataTestTraversalBeforeVal());
                }
                int orDefault2 = AndroidComposeView.this.composeAccessibilityDelegate.getIdToAfterMap().getOrDefault(semanticsId, -1);
                if (orDefault2 != -1) {
                    View viewSemanticsIdToView2 = SemanticsUtils_androidKt.semanticsIdToView(AndroidComposeView.this.getAndroidViewsHandler$ui_release(), orDefault2);
                    if (viewSemanticsIdToView2 != null) {
                        info.setTraversalAfter(viewSemanticsIdToView2);
                    } else {
                        info.setTraversalAfter(this, orDefault2);
                    }
                    AndroidComposeView.this.addExtraDataToAccessibilityNodeInfoHelper(semanticsId, info.unwrap(), AndroidComposeView.this.composeAccessibilityDelegate.getExtraDataTestTraversalAfterVal());
                }
            }
        });
    }

    public final void removeAndroidView(final AndroidViewHolder view) {
        registerOnEndApplyChangesListener(new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m6468invoke();
                return Unit.INSTANCE;
            }

            public final void m6468invoke() {
                AndroidComposeView.this.getAndroidViewsHandler$ui_release().removeViewInLayout((View) view);
                HashMap<LayoutNode, AndroidViewHolder> layoutNodeToHolder = AndroidComposeView.this.getAndroidViewsHandler$ui_release().getLayoutNodeToHolder();
                TypeIntrinsics.asMutableMap(layoutNodeToHolder).remove(AndroidComposeView.this.getAndroidViewsHandler$ui_release().getHolderToLayoutNode().remove(view));
                view.setImportantForAccessibility(0);
            }
        });
    }

    public final void drawAndroidView(AndroidViewHolder view, Canvas canvas) {
        getAndroidViewsHandler$ui_release().drawView(view, canvas);
    }

    static void scheduleMeasureAndLayout$default(AndroidComposeView androidComposeView, LayoutNode layoutNode, int i, Object obj) {
        if ((i & 1) != 0) {
            layoutNode = null;
        }
        androidComposeView.scheduleMeasureAndLayout(layoutNode);
    }

    private final void scheduleMeasureAndLayout(LayoutNode nodeToRemeasure) {
        if (isLayoutRequested() || !isAttachedToWindow()) {
            return;
        }
        if (nodeToRemeasure != null) {
            while (nodeToRemeasure != null && nodeToRemeasure.getMeasuredByParent$ui_release() == LayoutNode.UsageByParent.InMeasureBlock && childSizeCanAffectParentSize(nodeToRemeasure)) {
                nodeToRemeasure = nodeToRemeasure.getParent$ui_release();
            }
            if (nodeToRemeasure == getRoot()) {
                requestLayout();
                return;
            }
        }
        if (getWidth() == 0 || getHeight() == 0) {
            requestLayout();
        } else {
            invalidate();
        }
    }

    private final boolean childSizeCanAffectParentSize(LayoutNode layoutNode) {
        LayoutNode parent$ui_release;
        return this.wasMeasuredWithMultipleConstraints || !((parent$ui_release = layoutNode.getParent$ui_release()) == null || parent$ui_release.getHasFixedInnerContentConstraints$ui_release());
    }

    @Override
    public void measureAndLayout(boolean sendPointerUpdate) {
        Function0<Unit> function0;
        if (this.measureAndLayoutDelegate.getHasPendingMeasureOrLayout() || this.measureAndLayoutDelegate.getHasPendingOnPositionedCallbacks()) {
            Trace.beginSection("AndroidOwner:measureAndLayout");
            if (sendPointerUpdate) {
                try {
                    function0 = this.resendMotionEventOnLayout;
                } finally {
                    Trace.endSection();
                }
            } else {
                function0 = null;
            }
            if (this.measureAndLayoutDelegate.measureAndLayout(function0)) {
                requestLayout();
            }
            MeasureAndLayoutDelegate.dispatchOnPositionedCallbacks$default(this.measureAndLayoutDelegate, false, 1, null);
            dispatchPendingInteropLayoutCallbacks();
            Unit unit = Unit.INSTANCE;
        }
    }

    @Override
    public void mo6423measureAndLayout0kLqBqw(LayoutNode layoutNode, long constraints) {
        Trace.beginSection("AndroidOwner:measureAndLayout");
        try {
            this.measureAndLayoutDelegate.m6315measureAndLayout0kLqBqw(layoutNode, constraints);
            if (!this.measureAndLayoutDelegate.getHasPendingMeasureOrLayout()) {
                MeasureAndLayoutDelegate.dispatchOnPositionedCallbacks$default(this.measureAndLayoutDelegate, false, 1, null);
                dispatchPendingInteropLayoutCallbacks();
            }
            Unit unit = Unit.INSTANCE;
        } finally {
            Trace.endSection();
        }
    }

    private final void dispatchPendingInteropLayoutCallbacks() {
        if (this.isPendingInteropViewLayoutChangeDispatch) {
            getViewTreeObserver().dispatchOnGlobalLayout();
            this.isPendingInteropViewLayoutChangeDispatch = false;
        }
    }

    @Override
    public void forceMeasureTheSubtree(LayoutNode layoutNode, boolean affectsLookahead) {
        this.measureAndLayoutDelegate.forceMeasureTheSubtree(layoutNode, affectsLookahead);
    }

    @Override
    public void onRequestMeasure(LayoutNode layoutNode, boolean affectsLookahead, boolean forceRequest, boolean scheduleMeasureAndLayout) {
        if (affectsLookahead) {
            if (this.measureAndLayoutDelegate.requestLookaheadRemeasure(layoutNode, forceRequest) && scheduleMeasureAndLayout) {
                scheduleMeasureAndLayout(layoutNode);
                return;
            }
            return;
        }
        if (this.measureAndLayoutDelegate.requestRemeasure(layoutNode, forceRequest) && scheduleMeasureAndLayout) {
            scheduleMeasureAndLayout(layoutNode);
        }
    }

    @Override
    public void onRequestRelayout(LayoutNode layoutNode, boolean affectsLookahead, boolean forceRequest) {
        if (affectsLookahead) {
            if (this.measureAndLayoutDelegate.requestLookaheadRelayout(layoutNode, forceRequest)) {
                scheduleMeasureAndLayout$default(this, null, 1, null);
            }
        } else if (this.measureAndLayoutDelegate.requestRelayout(layoutNode, forceRequest)) {
            scheduleMeasureAndLayout$default(this, null, 1, null);
        }
    }

    @Override
    public void requestOnPositionedCallback(LayoutNode layoutNode) {
        this.measureAndLayoutDelegate.requestOnPositionedCallback(layoutNode);
        scheduleMeasureAndLayout$default(this, null, 1, null);
    }

    @Override
    public void measureAndLayoutForTest() {
        Owner.CC.measureAndLayout$default(this, false, 1, null);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        Trace.beginSection("AndroidOwner:onMeasure");
        try {
            if (!isAttachedToWindow()) {
                invalidateLayoutNodeMeasurement(getRoot());
            }
            long jM6450convertMeasureSpecI7RO_PI = m6450convertMeasureSpecI7RO_PI(widthMeasureSpec);
            int i = (int) ULong.constructor-impl(jM6450convertMeasureSpecI7RO_PI >>> 32);
            int i2 = (int) ULong.constructor-impl(jM6450convertMeasureSpecI7RO_PI & 4294967295L);
            long jM6450convertMeasureSpecI7RO_PI2 = m6450convertMeasureSpecI7RO_PI(heightMeasureSpec);
            long j = Constraints.Companion.fitPrioritizingHeight-Zbe2FdA(i, i2, (int) ULong.constructor-impl(jM6450convertMeasureSpecI7RO_PI2 >>> 32), (int) ULong.constructor-impl(4294967295L & jM6450convertMeasureSpecI7RO_PI2));
            Constraints constraints = this.onMeasureConstraints;
            boolean z = false;
            if (constraints == null) {
                this.onMeasureConstraints = Constraints.box-impl(j);
                this.wasMeasuredWithMultipleConstraints = false;
            } else {
                if (constraints != null) {
                    z = Constraints.equals-impl0(constraints.unbox-impl(), j);
                }
                if (!z) {
                    this.wasMeasuredWithMultipleConstraints = true;
                }
            }
            this.measureAndLayoutDelegate.m6316updateRootConstraintsBRTryo0(j);
            this.measureAndLayoutDelegate.measureOnly();
            setMeasuredDimension(getRoot().getWidth(), getRoot().getHeight());
            if (this._androidViewsHandler != null) {
                getAndroidViewsHandler$ui_release().measure(View.MeasureSpec.makeMeasureSpec(getRoot().getWidth(), 1073741824), View.MeasureSpec.makeMeasureSpec(getRoot().getHeight(), 1073741824));
            }
            Unit unit = Unit.INSTANCE;
        } finally {
            Trace.endSection();
        }
    }

    private final int m6448component1VKZWuLQ(long j) {
        return (int) ULong.constructor-impl(j >>> 32);
    }

    private final int m6449component2VKZWuLQ(long j) {
        return (int) ULong.constructor-impl(j & 4294967295L);
    }

    private final long m6454packZIaKswc(int a2, int b) {
        return ULong.constructor-impl(ULong.constructor-impl(b) | ULong.constructor-impl(ULong.constructor-impl(a2) << 32));
    }

    private final long m6450convertMeasureSpecI7RO_PI(int measureSpec) {
        int mode = View.MeasureSpec.getMode(measureSpec);
        int size = View.MeasureSpec.getSize(measureSpec);
        if (mode == Integer.MIN_VALUE) {
            return m6454packZIaKswc(0, size);
        }
        if (mode == 0) {
            return m6454packZIaKswc(0, Integer.MAX_VALUE);
        }
        if (mode == 1073741824) {
            return m6454packZIaKswc(size, size);
        }
        throw new IllegalStateException();
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        this.measureAndLayoutDelegate.measureAndLayout(this.resendMotionEventOnLayout);
        this.onMeasureConstraints = null;
        updatePositionCacheAndDispatch();
        if (this._androidViewsHandler != null) {
            getAndroidViewsHandler$ui_release().layout(0, 0, r - l, b - t);
        }
    }

    public final void updatePositionCacheAndDispatch() {
        getLocationOnScreen(this.tmpPositionArray);
        long j = this.globalPosition;
        int i = IntOffset.getX-impl(j);
        int i2 = IntOffset.getY-impl(j);
        int[] iArr = this.tmpPositionArray;
        boolean z = false;
        int i3 = iArr[0];
        if (i != i3 || i2 != iArr[1]) {
            this.globalPosition = IntOffsetKt.IntOffset(i3, iArr[1]);
            if (i != Integer.MAX_VALUE && i2 != Integer.MAX_VALUE) {
                getRoot().getLayoutDelegate().getMeasurePassDelegate().notifyChildrenUsingCoordinatesWhilePlacing();
                z = true;
            }
        }
        this.measureAndLayoutDelegate.dispatchOnPositionedCallbacks(z);
    }

    @Override
    public OwnedLayer createLayer(Function2<? super androidx.compose.p002ui.graphics.Canvas, ? super GraphicsLayer, Unit> drawBlock, Function0<Unit> invalidateParentLayer, GraphicsLayer explicitLayer) {
        ViewLayerContainer viewLayerContainer;
        if (explicitLayer != null) {
            return new GraphicsLayerOwnerLayer(explicitLayer, null, this, drawBlock, invalidateParentLayer);
        }
        OwnedLayer ownedLayerPop = this.layerCache.pop();
        if (ownedLayerPop != null) {
            ownedLayerPop.reuseLayer(drawBlock, invalidateParentLayer);
            return ownedLayerPop;
        }
        if (isHardwareAccelerated() && Build.VERSION.SDK_INT != 28) {
            return new GraphicsLayerOwnerLayer(getGraphicsContext().createGraphicsLayer(), getGraphicsContext(), this, drawBlock, invalidateParentLayer);
        }
        if (isHardwareAccelerated() && this.isRenderNodeCompatible) {
            try {
                return new RenderNodeLayer(this, drawBlock, invalidateParentLayer);
            } catch (Throwable unused) {
                this.isRenderNodeCompatible = false;
            }
        }
        if (this.viewLayersContainer == null) {
            if (!ViewLayer.INSTANCE.getHasRetrievedMethod()) {
                ViewLayer.INSTANCE.updateDisplayList(new View(getContext()));
            }
            if (ViewLayer.INSTANCE.getShouldUseDispatchDraw()) {
                viewLayerContainer = new DrawChildContainer(getContext());
            } else {
                viewLayerContainer = new ViewLayerContainer(getContext());
            }
            this.viewLayersContainer = viewLayerContainer;
            addView(viewLayerContainer);
        }
        DrawChildContainer drawChildContainer = this.viewLayersContainer;
        Intrinsics.checkNotNull(drawChildContainer);
        return new ViewLayer(this, drawChildContainer, drawBlock, invalidateParentLayer);
    }

    public final boolean recycle$ui_release(OwnedLayer layer) {
        if (this.viewLayersContainer != null) {
            ViewLayer.INSTANCE.getShouldUseDispatchDraw();
        }
        this.layerCache.push(layer);
        return true;
    }

    @Override
    public void onSemanticsChange() {
        this.composeAccessibilityDelegate.onSemanticsChange$ui_release();
        this.contentCaptureManager.onSemanticsChange$ui_release();
    }

    @Override
    public void onLayoutChange(LayoutNode layoutNode) {
        this.composeAccessibilityDelegate.onLayoutChange$ui_release(layoutNode);
        this.contentCaptureManager.onLayoutChange$ui_release(layoutNode);
    }

    @Override
    public void onInteropViewLayoutChange(View view) {
        this.isPendingInteropViewLayoutChangeDispatch = true;
    }

    @Override
    public void registerOnLayoutCompletedListener(Owner.OnLayoutCompletedListener listener) {
        this.measureAndLayoutDelegate.registerOnLayoutCompletedListener(listener);
        scheduleMeasureAndLayout$default(this, null, 1, null);
    }

    @Override
    public FocusDirection mo6422getFocusDirectionP8AzH3I(android.view.KeyEvent keyEvent) {
        long jM5697getKeyZmokQxo = KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent);
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5625getTabEK5gGoQ())) {
            return FocusDirection.m4248boximpl(KeyEvent_androidKt.m5703isShiftPressedZmokQxo(keyEvent) ? FocusDirection.INSTANCE.m4262getPreviousdhqQ8s() : FocusDirection.INSTANCE.m4261getNextdhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5466getDirectionRightEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4263getRightdhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5465getDirectionLeftEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4260getLeftdhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5467getDirectionUpEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5578getPageUpEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4264getUpdhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5462getDirectionDownEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5577getPageDownEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4257getDowndhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5461getDirectionCenterEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5475getEnterEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5567getNumPadEnterEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4258getEnterdhqQ8s());
        }
        if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5404getBackEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, Key.INSTANCE.m5478getEscapeEK5gGoQ())) {
            return FocusDirection.m4248boximpl(FocusDirection.INSTANCE.m4259getExitdhqQ8s());
        }
        return null;
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        if (!isAttachedToWindow()) {
            invalidateLayers(getRoot());
        }
        Owner.CC.measureAndLayout$default(this, false, 1, null);
        Snapshot.INSTANCE.sendApplyNotifications();
        this.isDrawingContent = true;
        CanvasHolder canvasHolder = this.canvasHolder;
        Canvas internalCanvas = canvasHolder.getAndroidCanvas().getInternalCanvas();
        canvasHolder.getAndroidCanvas().setInternalCanvas(canvas);
        getRoot().draw$ui_release(canvasHolder.getAndroidCanvas(), null);
        canvasHolder.getAndroidCanvas().setInternalCanvas(internalCanvas);
        if (!this.dirtyLayers.isEmpty()) {
            int size = this.dirtyLayers.size();
            for (int i = 0; i < size; i++) {
                this.dirtyLayers.get(i).updateDisplayList();
            }
        }
        if (ViewLayer.INSTANCE.getShouldUseDispatchDraw()) {
            int iSave = canvas.save();
            canvas.clipRect(0.0f, 0.0f, 0.0f, 0.0f);
            super.dispatchDraw(canvas);
            canvas.restoreToCount(iSave);
        }
        this.dirtyLayers.clear();
        this.isDrawingContent = false;
        List<OwnedLayer> list = this.postponedDirtyLayers;
        if (list != null) {
            Intrinsics.checkNotNull(list);
            this.dirtyLayers.addAll(list);
            list.clear();
        }
    }

    public final void notifyLayerIsDirty$ui_release(OwnedLayer layer, boolean isDirty) {
        if (!isDirty) {
            if (this.isDrawingContent) {
                return;
            }
            this.dirtyLayers.remove(layer);
            List<OwnedLayer> list = this.postponedDirtyLayers;
            if (list != null) {
                list.remove(layer);
                return;
            }
            return;
        }
        if (!this.isDrawingContent) {
            this.dirtyLayers.add(layer);
            return;
        }
        ArrayList arrayList = this.postponedDirtyLayers;
        if (arrayList == null) {
            arrayList = new ArrayList();
            this.postponedDirtyLayers = arrayList;
        }
        arrayList.add(layer);
    }

    public final void setOnViewTreeOwnersAvailable(Function1<? super ViewTreeOwners, Unit> callback) {
        ViewTreeOwners viewTreeOwners = getViewTreeOwners();
        if (viewTreeOwners != null) {
            callback.invoke(viewTreeOwners);
        }
        if (isAttachedToWindow()) {
            return;
        }
        this.onViewTreeOwnersAvailable = callback;
    }

    public final Object boundsUpdatesContentCaptureEventLoop(Continuation<? super Unit> continuation) {
        Object objBoundsUpdatesEventLoop$ui_release = this.contentCaptureManager.boundsUpdatesEventLoop$ui_release(continuation);
        return objBoundsUpdatesEventLoop$ui_release == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objBoundsUpdatesEventLoop$ui_release : Unit.INSTANCE;
    }

    public final Object boundsUpdatesAccessibilityEventLoop(Continuation<? super Unit> continuation) {
        Object objBoundsUpdatesEventLoop$ui_release = this.composeAccessibilityDelegate.boundsUpdatesEventLoop$ui_release(continuation);
        return objBoundsUpdatesEventLoop$ui_release == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objBoundsUpdatesEventLoop$ui_release : Unit.INSTANCE;
    }

    private final void invalidateLayoutNodeMeasurement(LayoutNode node) {
        int i = 0;
        MeasureAndLayoutDelegate.requestRemeasure$default(this.measureAndLayoutDelegate, node, false, 2, null);
        MutableVector<LayoutNode> mutableVector = node.get_children$ui_release();
        int size = mutableVector.getSize();
        if (size > 0) {
            LayoutNode[] content = mutableVector.getContent();
            do {
                invalidateLayoutNodeMeasurement(content[i]);
                i++;
            } while (i < size);
        }
    }

    private final void invalidateLayers(LayoutNode node) {
        node.invalidateLayers$ui_release();
        MutableVector<LayoutNode> mutableVector = node.get_children$ui_release();
        int size = mutableVector.getSize();
        if (size > 0) {
            LayoutNode[] content = mutableVector.getContent();
            int i = 0;
            do {
                invalidateLayers(content[i]);
                i++;
            } while (i < size);
        }
    }

    @Override
    public void invalidateDescendants() {
        invalidateLayers(getRoot());
    }

    @Override
    protected void onAttachedToWindow() throws KotlinNothingValueException {
        LifecycleOwner lifecycleOwner;
        Lifecycle lifecycle;
        LifecycleOwner lifecycleOwner2;
        AndroidAutofill androidAutofill;
        super.onAttachedToWindow();
        this._windowInfo.setWindowFocused(hasWindowFocus());
        invalidateLayoutNodeMeasurement(getRoot());
        invalidateLayers(getRoot());
        getSnapshotObserver().startObserving$ui_release();
        if (autofillSupported() && (androidAutofill = this._autofill) != null) {
            AutofillCallback.INSTANCE.register(androidAutofill);
        }
        AndroidComposeView androidComposeView = this;
        LifecycleOwner lifecycleOwner3 = ViewTreeLifecycleOwner.get(androidComposeView);
        LifecycleOwner lifecycleOwner4 = ViewTreeSavedStateRegistryOwner.get(androidComposeView);
        ViewTreeOwners viewTreeOwners = getViewTreeOwners();
        Lifecycle lifecycle2 = null;
        if (viewTreeOwners == null || (lifecycleOwner3 != null && lifecycleOwner4 != null && (lifecycleOwner3 != viewTreeOwners.getLifecycleOwner() || lifecycleOwner4 != viewTreeOwners.getLifecycleOwner()))) {
            if (lifecycleOwner3 == null) {
                throw new IllegalStateException("Composed into the View which doesn't propagate ViewTreeLifecycleOwner!");
            }
            if (lifecycleOwner4 == null) {
                throw new IllegalStateException("Composed into the View which doesn't propagateViewTreeSavedStateRegistryOwner!");
            }
            if (viewTreeOwners != null && (lifecycleOwner = viewTreeOwners.getLifecycleOwner()) != null && (lifecycle = lifecycleOwner.getLifecycle()) != null) {
                lifecycle.removeObserver((LifecycleObserver) this);
            }
            lifecycleOwner3.getLifecycle().addObserver((LifecycleObserver) this);
            ViewTreeOwners viewTreeOwners2 = new ViewTreeOwners(lifecycleOwner3, lifecycleOwner4);
            set_viewTreeOwners(viewTreeOwners2);
            Function1<? super ViewTreeOwners, Unit> function1 = this.onViewTreeOwnersAvailable;
            if (function1 != null) {
                function1.invoke(viewTreeOwners2);
            }
            this.onViewTreeOwnersAvailable = null;
        }
        this._inputModeManager.m5383setInputModeiuPiT84(isInTouchMode() ? InputMode.INSTANCE.m5380getTouchaOaMEAU() : InputMode.INSTANCE.m5379getKeyboardaOaMEAU());
        ViewTreeOwners viewTreeOwners3 = getViewTreeOwners();
        if (viewTreeOwners3 != null && (lifecycleOwner2 = viewTreeOwners3.getLifecycleOwner()) != null) {
            lifecycle2 = lifecycleOwner2.getLifecycle();
        }
        if (lifecycle2 != null) {
            lifecycle2.addObserver((LifecycleObserver) this);
            lifecycle2.addObserver(this.contentCaptureManager);
            getViewTreeObserver().addOnGlobalLayoutListener(this.globalLayoutListener);
            getViewTreeObserver().addOnScrollChangedListener(this.scrollChangedListener);
            getViewTreeObserver().addOnTouchModeChangeListener(this.touchModeChangeListener);
            if (Build.VERSION.SDK_INT >= 31) {
                AndroidComposeViewTranslationCallbackS.INSTANCE.setViewTranslationCallback(androidComposeView);
                return;
            }
            return;
        }
        InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("No lifecycle owner exists");
        throw new KotlinNothingValueException();
    }

    @Override
    protected void onDetachedFromWindow() throws KotlinNothingValueException {
        AndroidAutofill androidAutofill;
        LifecycleOwner lifecycleOwner;
        super.onDetachedFromWindow();
        getSnapshotObserver().stopObserving$ui_release();
        ViewTreeOwners viewTreeOwners = getViewTreeOwners();
        Lifecycle lifecycle = (viewTreeOwners == null || (lifecycleOwner = viewTreeOwners.getLifecycleOwner()) == null) ? null : lifecycleOwner.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this.contentCaptureManager);
            lifecycle.removeObserver((LifecycleObserver) this);
            if (autofillSupported() && (androidAutofill = this._autofill) != null) {
                AutofillCallback.INSTANCE.unregister(androidAutofill);
            }
            getViewTreeObserver().removeOnGlobalLayoutListener(this.globalLayoutListener);
            getViewTreeObserver().removeOnScrollChangedListener(this.scrollChangedListener);
            getViewTreeObserver().removeOnTouchModeChangeListener(this.touchModeChangeListener);
            if (Build.VERSION.SDK_INT >= 31) {
                AndroidComposeViewTranslationCallbackS.INSTANCE.clearViewTranslationCallback(this);
                return;
            }
            return;
        }
        InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("No lifecycle owner exists");
        throw new KotlinNothingValueException();
    }

    @Override
    public void onProvideAutofillVirtualStructure(ViewStructure structure, int flags) {
        AndroidAutofill androidAutofill;
        if (!autofillSupported() || structure == null || (androidAutofill = this._autofill) == null) {
            return;
        }
        AndroidAutofill_androidKt.populateViewStructure(androidAutofill, structure);
    }

    @Override
    public void autofill(SparseArray<AutofillValue> values) {
        AndroidAutofill androidAutofill;
        if (!autofillSupported() || (androidAutofill = this._autofill) == null) {
            return;
        }
        AndroidAutofill_androidKt.performAutofill(androidAutofill, values);
    }

    @Override
    public void onCreateVirtualViewTranslationRequests(long[] virtualIds, int[] supportedFormats, Consumer<ViewTranslationRequest> requestsCollector) {
        this.contentCaptureManager.onCreateVirtualViewTranslationRequests$ui_release(virtualIds, supportedFormats, requestsCollector);
    }

    @Override
    public void onVirtualViewTranslationResponses(LongSparseArray<ViewTranslationResponse> response) {
        AndroidContentCaptureManager androidContentCaptureManager = this.contentCaptureManager;
        androidContentCaptureManager.onVirtualViewTranslationResponses$ui_release(androidContentCaptureManager, response);
    }

    @Override
    public boolean dispatchGenericMotionEvent(MotionEvent motionEvent) {
        if (this.hoverExitReceived) {
            removeCallbacks(this.sendHoverExitEvent);
            if (motionEvent.getActionMasked() == 8) {
                this.hoverExitReceived = false;
            } else {
                this.sendHoverExitEvent.run();
            }
        }
        if (motionEvent.getActionMasked() == 8) {
            if (isBadMotionEvent(motionEvent) || !isAttachedToWindow()) {
                return super.dispatchGenericMotionEvent(motionEvent);
            }
            return motionEvent.isFromSource(4194304) ? handleRotaryEvent(motionEvent) : ProcessResult.m5936getDispatchedToAPointerInputModifierimpl(m6451handleMotionEvent8iAsVTc(motionEvent));
        }
        return super.dispatchGenericMotionEvent(motionEvent);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        if (this.hoverExitReceived) {
            removeCallbacks(this.sendHoverExitEvent);
            MotionEvent motionEvent2 = this.previousMotionEvent;
            Intrinsics.checkNotNull(motionEvent2);
            if (motionEvent.getActionMasked() != 0 || hasChangedDevices(motionEvent, motionEvent2)) {
                this.sendHoverExitEvent.run();
            } else {
                this.hoverExitReceived = false;
            }
        }
        if (isBadMotionEvent(motionEvent) || !isAttachedToWindow()) {
            return false;
        }
        if (motionEvent.getActionMasked() == 2 && !isPositionChanged(motionEvent)) {
            return false;
        }
        int iM6451handleMotionEvent8iAsVTc = m6451handleMotionEvent8iAsVTc(motionEvent);
        if (ProcessResult.m5935getAnyMovementConsumedimpl(iM6451handleMotionEvent8iAsVTc)) {
            getParent().requestDisallowInterceptTouchEvent(true);
        }
        return ProcessResult.m5936getDispatchedToAPointerInputModifierimpl(iM6451handleMotionEvent8iAsVTc);
    }

    private final boolean handleRotaryEvent(MotionEvent event) {
        ViewConfiguration viewConfiguration = ViewConfiguration.get(getContext());
        float f = -event.getAxisValue(26);
        return getFocusOwner().dispatchRotaryEvent(new RotaryScrollEvent(f * ViewConfigurationCompat.getScaledVerticalScrollFactor(viewConfiguration, getContext()), f * ViewConfigurationCompat.getScaledHorizontalScrollFactor(viewConfiguration, getContext()), event.getEventTime(), event.getDeviceId()));
    }

    private final int m6451handleMotionEvent8iAsVTc(MotionEvent motionEvent) {
        removeCallbacks(this.resendMotionEventRunnable);
        try {
            recalculateWindowPosition(motionEvent);
            this.forceUseMatrixCache = true;
            measureAndLayout(false);
            Trace.beginSection("AndroidOwner:onTouch");
            try {
                int actionMasked = motionEvent.getActionMasked();
                MotionEvent motionEvent2 = this.previousMotionEvent;
                boolean z = motionEvent2 != null && motionEvent2.getToolType(0) == 3;
                if (motionEvent2 != null && hasChangedDevices(motionEvent, motionEvent2)) {
                    if (isDevicePressEvent(motionEvent2)) {
                        this.pointerInputEventProcessor.processCancel();
                    } else if (motionEvent2.getActionMasked() != 10 && z) {
                        sendSimulatedEvent$default(this, motionEvent2, 10, motionEvent2.getEventTime(), false, 8, null);
                    }
                }
                boolean z2 = motionEvent.getToolType(0) == 3;
                if (!z && z2 && actionMasked != 3 && actionMasked != 9 && isInBounds(motionEvent)) {
                    sendSimulatedEvent$default(this, motionEvent, 9, motionEvent.getEventTime(), false, 8, null);
                }
                if (motionEvent2 != null) {
                    motionEvent2.recycle();
                }
                MotionEvent motionEvent3 = this.previousMotionEvent;
                if (motionEvent3 != null && motionEvent3.getAction() == 10) {
                    MotionEvent motionEvent4 = this.previousMotionEvent;
                    int pointerId = motionEvent4 != null ? motionEvent4.getPointerId(0) : -1;
                    if (motionEvent.getAction() == 9 && motionEvent.getHistorySize() == 0) {
                        if (pointerId >= 0) {
                            this.motionEventAdapter.endStream(pointerId);
                        }
                    } else if (motionEvent.getAction() == 0 && motionEvent.getHistorySize() == 0) {
                        MotionEvent motionEvent5 = this.previousMotionEvent;
                        float x = motionEvent5 != null ? motionEvent5.getX() : Float.NaN;
                        MotionEvent motionEvent6 = this.previousMotionEvent;
                        boolean z3 = (x == motionEvent.getX() && (motionEvent6 != null ? motionEvent6.getY() : Float.NaN) == motionEvent.getY()) ? false : true;
                        MotionEvent motionEvent7 = this.previousMotionEvent;
                        boolean z4 = (motionEvent7 != null ? motionEvent7.getEventTime() : -1L) != motionEvent.getEventTime();
                        if (z3 || z4) {
                            if (pointerId >= 0) {
                                this.motionEventAdapter.endStream(pointerId);
                            }
                            this.pointerInputEventProcessor.clearPreviouslyHitModifierNodes();
                        }
                    }
                }
                this.previousMotionEvent = MotionEvent.obtainNoHistory(motionEvent);
                int iM6455sendMotionEvent8iAsVTc = m6455sendMotionEvent8iAsVTc(motionEvent);
                Trace.endSection();
                this.forceUseMatrixCache = false;
                return iM6455sendMotionEvent8iAsVTc;
            } catch (Throwable th) {
                Trace.endSection();
                throw th;
            }
        } catch (Throwable th2) {
            this.forceUseMatrixCache = false;
            throw th2;
        }
    }

    private final boolean hasChangedDevices(MotionEvent event, MotionEvent lastEvent) {
        return (lastEvent.getSource() == event.getSource() && lastEvent.getToolType(0) == event.getToolType(0)) ? false : true;
    }

    private final boolean isDevicePressEvent(MotionEvent event) {
        int actionMasked;
        return event.getButtonState() != 0 || (actionMasked = event.getActionMasked()) == 0 || actionMasked == 2 || actionMasked == 6;
    }

    private final int m6455sendMotionEvent8iAsVTc(MotionEvent motionEvent) {
        PointerInputEventData pointerInputEventData;
        if (this.keyboardModifiersRequireUpdate) {
            this.keyboardModifiersRequireUpdate = false;
            this._windowInfo.m6590setKeyboardModifiers5xRPYO0(PointerKeyboardModifiers.m5910constructorimpl(motionEvent.getMetaState()));
        }
        AndroidComposeView androidComposeView = this;
        PointerInputEvent pointerInputEventConvertToPointerInputEvent$ui_release = this.motionEventAdapter.convertToPointerInputEvent$ui_release(motionEvent, androidComposeView);
        if (pointerInputEventConvertToPointerInputEvent$ui_release != null) {
            List<PointerInputEventData> pointers = pointerInputEventConvertToPointerInputEvent$ui_release.getPointers();
            int size = pointers.size() - 1;
            if (size < 0) {
                pointerInputEventData = null;
                break;
            }
            while (true) {
                int i = size - 1;
                pointerInputEventData = pointers.get(size);
                if (pointerInputEventData.getDown()) {
                    break;
                }
                if (i < 0) {
                    pointerInputEventData = null;
                    break;
                }
                size = i;
            }
            PointerInputEventData pointerInputEventData2 = pointerInputEventData;
            if (pointerInputEventData2 != null) {
                this.lastDownPointerPosition = pointerInputEventData2.m5863getPositionF1C5BW0();
            }
            int iM5868processBIzXfog = this.pointerInputEventProcessor.m5868processBIzXfog(pointerInputEventConvertToPointerInputEvent$ui_release, androidComposeView, isInBounds(motionEvent));
            int actionMasked = motionEvent.getActionMasked();
            if ((actionMasked != 0 && actionMasked != 5) || ProcessResult.m5936getDispatchedToAPointerInputModifierimpl(iM5868processBIzXfog)) {
                return iM5868processBIzXfog;
            }
            this.motionEventAdapter.endStream(motionEvent.getPointerId(motionEvent.getActionIndex()));
            return iM5868processBIzXfog;
        }
        this.pointerInputEventProcessor.processCancel();
        return PointerInputEventProcessorKt.ProcessResult(false, false);
    }

    static void sendSimulatedEvent$default(AndroidComposeView androidComposeView, MotionEvent motionEvent, int i, long j, boolean z, int i2, Object obj) {
        if ((i2 & 8) != 0) {
            z = true;
        }
        androidComposeView.sendSimulatedEvent(motionEvent, i, j, z);
    }

    public final void sendSimulatedEvent(MotionEvent motionEvent, int action, long eventTime, boolean forceHover) {
        int actionMasked = motionEvent.getActionMasked();
        int actionIndex = -1;
        if (actionMasked != 1) {
            if (actionMasked == 6) {
                actionIndex = motionEvent.getActionIndex();
            }
        } else if (action != 9 && action != 10) {
            actionIndex = 0;
        }
        int pointerCount = motionEvent.getPointerCount() - (actionIndex >= 0 ? 1 : 0);
        if (pointerCount == 0) {
            return;
        }
        MotionEvent.PointerProperties[] pointerPropertiesArr = new MotionEvent.PointerProperties[pointerCount];
        for (int i = 0; i < pointerCount; i++) {
            pointerPropertiesArr[i] = new MotionEvent.PointerProperties();
        }
        MotionEvent.PointerCoords[] pointerCoordsArr = new MotionEvent.PointerCoords[pointerCount];
        for (int i2 = 0; i2 < pointerCount; i2++) {
            pointerCoordsArr[i2] = new MotionEvent.PointerCoords();
        }
        int i3 = 0;
        while (i3 < pointerCount) {
            int i4 = ((actionIndex < 0 || i3 < actionIndex) ? 0 : 1) + i3;
            motionEvent.getPointerProperties(i4, pointerPropertiesArr[i3]);
            MotionEvent.PointerCoords pointerCoords = pointerCoordsArr[i3];
            motionEvent.getPointerCoords(i4, pointerCoords);
            long jMo5929localToScreenMKHz9U = mo5929localToScreenMKHz9U(OffsetKt.Offset(pointerCoords.x, pointerCoords.y));
            pointerCoords.x = Offset.m4346getXimpl(jMo5929localToScreenMKHz9U);
            pointerCoords.y = Offset.m4347getYimpl(jMo5929localToScreenMKHz9U);
            i3++;
        }
        MotionEvent motionEventObtain = MotionEvent.obtain(motionEvent.getDownTime() == motionEvent.getEventTime() ? eventTime : motionEvent.getDownTime(), eventTime, action, pointerCount, pointerPropertiesArr, pointerCoordsArr, motionEvent.getMetaState(), forceHover ? 0 : motionEvent.getButtonState(), motionEvent.getXPrecision(), motionEvent.getYPrecision(), motionEvent.getDeviceId(), motionEvent.getEdgeFlags(), motionEvent.getSource(), motionEvent.getFlags());
        AndroidComposeView androidComposeView = this;
        PointerInputEvent pointerInputEventConvertToPointerInputEvent$ui_release = this.motionEventAdapter.convertToPointerInputEvent$ui_release(motionEventObtain, androidComposeView);
        Intrinsics.checkNotNull(pointerInputEventConvertToPointerInputEvent$ui_release);
        this.pointerInputEventProcessor.m5868processBIzXfog(pointerInputEventConvertToPointerInputEvent$ui_release, androidComposeView, true);
        motionEventObtain.recycle();
    }

    @Override
    public boolean canScrollHorizontally(int direction) {
        return this.composeAccessibilityDelegate.m6475canScroll0AR0LA0$ui_release(false, direction, this.lastDownPointerPosition);
    }

    @Override
    public boolean canScrollVertically(int direction) {
        return this.composeAccessibilityDelegate.m6475canScroll0AR0LA0$ui_release(true, direction, this.lastDownPointerPosition);
    }

    private final boolean isInBounds(MotionEvent motionEvent) {
        float x = motionEvent.getX();
        float y = motionEvent.getY();
        return 0.0f <= x && x <= ((float) getWidth()) && 0.0f <= y && y <= ((float) getHeight());
    }

    @Override
    public long mo5929localToScreenMKHz9U(long localPosition) {
        recalculateWindowPosition();
        long jM4834mapMKHz9U = Matrix.m4834mapMKHz9U(this.viewToWindowMatrix, localPosition);
        return OffsetKt.Offset(Offset.m4346getXimpl(jM4834mapMKHz9U) + Offset.m4346getXimpl(this.windowPosition), Offset.m4347getYimpl(jM4834mapMKHz9U) + Offset.m4347getYimpl(this.windowPosition));
    }

    @Override
    public void mo5928localToScreen58bKbWc(float[] localTransform) {
        recalculateWindowPosition();
        Matrix.m4845timesAssign58bKbWc(localTransform, this.viewToWindowMatrix);
        AndroidComposeView_androidKt.m6484preTranslatecG2Xzmc(localTransform, Offset.m4346getXimpl(this.windowPosition), Offset.m4347getYimpl(this.windowPosition), this.tmpMatrix);
    }

    @Override
    public long mo5930screenToLocalMKHz9U(long positionOnScreen) {
        recalculateWindowPosition();
        return Matrix.m4834mapMKHz9U(this.windowToViewMatrix, OffsetKt.Offset(Offset.m4346getXimpl(positionOnScreen) - Offset.m4346getXimpl(this.windowPosition), Offset.m4347getYimpl(positionOnScreen) - Offset.m4347getYimpl(this.windowPosition)));
    }

    private final void recalculateWindowPosition() {
        if (this.forceUseMatrixCache) {
            return;
        }
        long jCurrentAnimationTimeMillis = AnimationUtils.currentAnimationTimeMillis();
        if (jCurrentAnimationTimeMillis != this.lastMatrixRecalculationAnimationTime) {
            this.lastMatrixRecalculationAnimationTime = jCurrentAnimationTimeMillis;
            recalculateWindowViewTransforms();
            ViewParent parent = getParent();
            AndroidComposeView androidComposeView = this;
            while (parent instanceof ViewGroup) {
                androidComposeView = (View) parent;
                parent = ((ViewGroup) androidComposeView).getParent();
            }
            androidComposeView.getLocationOnScreen(this.tmpPositionArray);
            int[] iArr = this.tmpPositionArray;
            float f = iArr[0];
            float f2 = iArr[1];
            androidComposeView.getLocationInWindow(iArr);
            int[] iArr2 = this.tmpPositionArray;
            this.windowPosition = OffsetKt.Offset(f - iArr2[0], f2 - iArr2[1]);
        }
    }

    private final void recalculateWindowPosition(MotionEvent motionEvent) {
        this.lastMatrixRecalculationAnimationTime = AnimationUtils.currentAnimationTimeMillis();
        recalculateWindowViewTransforms();
        long jM4834mapMKHz9U = Matrix.m4834mapMKHz9U(this.viewToWindowMatrix, OffsetKt.Offset(motionEvent.getX(), motionEvent.getY()));
        this.windowPosition = OffsetKt.Offset(motionEvent.getRawX() - Offset.m4346getXimpl(jM4834mapMKHz9U), motionEvent.getRawY() - Offset.m4347getYimpl(jM4834mapMKHz9U));
    }

    private final void recalculateWindowViewTransforms() {
        this.matrixToWindow.mo6495calculateMatrixToWindowEL8BTi8(this, this.viewToWindowMatrix);
        InvertMatrixKt.m6546invertToJiSxe2E(this.viewToWindowMatrix, this.windowToViewMatrix);
    }

    @Override
    public boolean onCheckIsTextEditor() {
        AndroidPlatformTextInputSession androidPlatformTextInputSession = (AndroidPlatformTextInputSession) SessionMutex.m4178getCurrentSessionimpl(this.textInputSessionMutex);
        if (androidPlatformTextInputSession == null) {
            return this.legacyTextInputServiceAndroid.isEditorFocused();
        }
        return androidPlatformTextInputSession.isReadyForConnection();
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        AndroidPlatformTextInputSession androidPlatformTextInputSession = (AndroidPlatformTextInputSession) SessionMutex.m4178getCurrentSessionimpl(this.textInputSessionMutex);
        if (androidPlatformTextInputSession == null) {
            return this.legacyTextInputServiceAndroid.createInputConnection(outAttrs);
        }
        return androidPlatformTextInputSession.createInputConnection(outAttrs);
    }

    @Override
    public long mo6420calculateLocalPositionMKHz9U(long positionInWindow) {
        recalculateWindowPosition();
        return Matrix.m4834mapMKHz9U(this.windowToViewMatrix, positionInWindow);
    }

    @Override
    public long mo6421calculatePositionInWindowMKHz9U(long localPosition) {
        recalculateWindowPosition();
        return Matrix.m4834mapMKHz9U(this.viewToWindowMatrix, localPosition);
    }

    @Override
    protected void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        setDensity(AndroidDensity_androidKt.Density(getContext()));
        if (getFontWeightAdjustmentCompat(newConfig) != this.currentFontWeightAdjustment) {
            this.currentFontWeightAdjustment = getFontWeightAdjustmentCompat(newConfig);
            setFontFamilyResolver(FontFamilyResolver_androidKt.createFontFamilyResolver(getContext()));
        }
        this.configurationChangeObserver.invoke(newConfig);
    }

    @Override
    public void onRtlPropertiesChanged(int layoutDirection) {
        if (this.superclassInitComplete) {
            LayoutDirection layoutDirection2 = FocusInteropUtils_androidKt.toLayoutDirection(layoutDirection);
            if (layoutDirection2 == null) {
                layoutDirection2 = LayoutDirection.Ltr;
            }
            setLayoutDirection(layoutDirection2);
        }
    }

    private final boolean autofillSupported() {
        return Build.VERSION.SDK_INT >= 26;
    }

    @Override
    public boolean dispatchHoverEvent(MotionEvent event) {
        if (this.hoverExitReceived) {
            removeCallbacks(this.sendHoverExitEvent);
            this.sendHoverExitEvent.run();
        }
        if (isBadMotionEvent(event) || !isAttachedToWindow()) {
            return false;
        }
        this.composeAccessibilityDelegate.dispatchHoverEvent$ui_release(event);
        int actionMasked = event.getActionMasked();
        if (actionMasked != 7) {
            if (actionMasked == 10 && isInBounds(event)) {
                if (event.getToolType(0) == 3 && event.getButtonState() != 0) {
                    return false;
                }
                MotionEvent motionEvent = this.previousMotionEvent;
                if (motionEvent != null) {
                    motionEvent.recycle();
                }
                this.previousMotionEvent = MotionEvent.obtainNoHistory(event);
                this.hoverExitReceived = true;
                postDelayed(this.sendHoverExitEvent, 8L);
                return false;
            }
        } else if (!isPositionChanged(event)) {
            return false;
        }
        return ProcessResult.m5936getDispatchedToAPointerInputModifierimpl(m6451handleMotionEvent8iAsVTc(event));
    }

    private final boolean isBadMotionEvent(MotionEvent event) {
        boolean z;
        float x = event.getX();
        if (Float.isInfinite(x) || Float.isNaN(x)) {
            z = true;
        } else {
            float y = event.getY();
            if (Float.isInfinite(y) || Float.isNaN(y)) {
                z = true;
            } else {
                float rawX = event.getRawX();
                if (Float.isInfinite(rawX) || Float.isNaN(rawX)) {
                    z = true;
                } else {
                    float rawY = event.getRawY();
                    if (Float.isInfinite(rawY) || Float.isNaN(rawY)) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
            }
        }
        if (!z) {
            int pointerCount = event.getPointerCount();
            for (int i = 1; i < pointerCount; i++) {
                float x2 = event.getX(i);
                if (Float.isInfinite(x2) || Float.isNaN(x2)) {
                    z = true;
                } else {
                    float y2 = event.getY(i);
                    if (Float.isInfinite(y2) || Float.isNaN(y2) || (Build.VERSION.SDK_INT >= 29 && !MotionEventVerifierApi29.INSTANCE.isValidMotionEvent(event, i))) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                if (z) {
                    break;
                }
            }
        }
        return z;
    }

    private final boolean isPositionChanged(MotionEvent event) {
        MotionEvent motionEvent;
        return (event.getPointerCount() == 1 && (motionEvent = this.previousMotionEvent) != null && motionEvent.getPointerCount() == event.getPointerCount() && event.getRawX() == motionEvent.getRawX() && event.getRawY() == motionEvent.getRawY()) ? false : true;
    }

    private final View findViewByAccessibilityIdRootedAtCurrentView(int accessibilityId, View currentView) throws NoSuchMethodException {
        if (Build.VERSION.SDK_INT < 29) {
            Method declaredMethod = Class.forName(AndroidComposeViewAccessibilityDelegateCompat.ClassName).getDeclaredMethod("getAccessibilityViewId", null);
            declaredMethod.setAccessible(true);
            if (Intrinsics.areEqual(declaredMethod.invoke(currentView, null), Integer.valueOf(accessibilityId))) {
                return currentView;
            }
            if (currentView instanceof ViewGroup) {
                ViewGroup viewGroup = (ViewGroup) currentView;
                int childCount = viewGroup.getChildCount();
                for (int i = 0; i < childCount; i++) {
                    View viewFindViewByAccessibilityIdRootedAtCurrentView = findViewByAccessibilityIdRootedAtCurrentView(accessibilityId, viewGroup.getChildAt(i));
                    if (viewFindViewByAccessibilityIdRootedAtCurrentView != null) {
                        return viewFindViewByAccessibilityIdRootedAtCurrentView;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public PointerIconService getPointerIconService() {
        return this.pointerIconService;
    }

    public final View findViewByAccessibilityIdTraversal(int accessibilityId) throws IllegalAccessException, InvocationTargetException {
        View viewFindViewByAccessibilityIdRootedAtCurrentView = null;
        try {
            if (Build.VERSION.SDK_INT >= 29) {
                Method declaredMethod = Class.forName(AndroidComposeViewAccessibilityDelegateCompat.ClassName).getDeclaredMethod("findViewByAccessibilityIdTraversal", Integer.TYPE);
                declaredMethod.setAccessible(true);
                Object objInvoke = declaredMethod.invoke(this, Integer.valueOf(accessibilityId));
                if (objInvoke instanceof View) {
                    viewFindViewByAccessibilityIdRootedAtCurrentView = (View) objInvoke;
                }
            } else {
                viewFindViewByAccessibilityIdRootedAtCurrentView = findViewByAccessibilityIdRootedAtCurrentView(accessibilityId, this);
            }
        } catch (NoSuchMethodException unused) {
        }
        return viewFindViewByAccessibilityIdRootedAtCurrentView;
    }

    @Override
    public boolean isLifecycleInResumedState() {
        LifecycleOwner lifecycleOwner;
        Lifecycle lifecycle;
        ViewTreeOwners viewTreeOwners = getViewTreeOwners();
        return ((viewTreeOwners == null || (lifecycleOwner = viewTreeOwners.getLifecycleOwner()) == null || (lifecycle = lifecycleOwner.getLifecycle()) == null) ? null : lifecycle.getCurrentState()) == Lifecycle.State.RESUMED;
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0007\u001a\u00020\bH\u0002R\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0005\u001a\b\u0012\u0002\b\u0003\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\t"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeView$Companion;", "", "()V", "getBooleanMethod", "Ljava/lang/reflect/Method;", "systemPropertiesClass", "Ljava/lang/Class;", "getIsShowingLayoutBounds", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final boolean getIsShowingLayoutBounds() {
            try {
                if (AndroidComposeView.systemPropertiesClass == null) {
                    AndroidComposeView.systemPropertiesClass = Class.forName("android.os.SystemProperties");
                    Class cls = AndroidComposeView.systemPropertiesClass;
                    AndroidComposeView.getBooleanMethod = cls != null ? cls.getDeclaredMethod("getBoolean", String.class, Boolean.TYPE) : null;
                }
                Method method = AndroidComposeView.getBooleanMethod;
                Object objInvoke = method != null ? method.invoke(null, "debug.layout", false) : null;
                Boolean bool = objInvoke instanceof Boolean ? (Boolean) objInvoke : null;
                if (bool != null) {
                    return bool.booleanValue();
                }
                return false;
            } catch (Exception unused) {
                return false;
            }
        }
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u000b"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeView$ViewTreeOwners;", "", "lifecycleOwner", "Landroidx/lifecycle/LifecycleOwner;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "(Landroidx/lifecycle/LifecycleOwner;Landroidx/savedstate/SavedStateRegistryOwner;)V", "getLifecycleOwner", "()Landroidx/lifecycle/LifecycleOwner;", "getSavedStateRegistryOwner", "()Landroidx/savedstate/SavedStateRegistryOwner;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class ViewTreeOwners {
        public static final int $stable = 8;
        private final LifecycleOwner lifecycleOwner;
        private final SavedStateRegistryOwner savedStateRegistryOwner;

        public ViewTreeOwners(LifecycleOwner lifecycleOwner, SavedStateRegistryOwner savedStateRegistryOwner) {
            this.lifecycleOwner = lifecycleOwner;
            this.savedStateRegistryOwner = savedStateRegistryOwner;
        }

        public final LifecycleOwner getLifecycleOwner() {
            return this.lifecycleOwner;
        }

        public final SavedStateRegistryOwner getSavedStateRegistryOwner() {
            return this.savedStateRegistryOwner;
        }
    }
}
