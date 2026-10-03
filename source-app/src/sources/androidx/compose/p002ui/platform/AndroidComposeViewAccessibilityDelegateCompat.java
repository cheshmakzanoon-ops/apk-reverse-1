package androidx.compose.p002ui.platform;

import android.R;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.graphics.Rect;
import android.graphics.RectF;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Parcelable;
import android.os.SystemClock;
import android.os.Trace;
import android.text.SpannableString;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewParent;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityManager;
import androidx.collection.ArraySet;
import androidx.collection.IntList;
import androidx.collection.IntListKt;
import androidx.collection.IntObjectMap;
import androidx.collection.IntObjectMapKt;
import androidx.collection.IntSetKt;
import androidx.collection.MutableIntIntMap;
import androidx.collection.MutableIntList;
import androidx.collection.MutableIntObjectMap;
import androidx.collection.MutableIntSet;
import androidx.collection.MutableObjectIntMap;
import androidx.collection.ObjectIntMapKt;
import androidx.collection.SparseArrayCompat;
import androidx.compose.p002ui.C1597R;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.RectHelper_androidKt;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.HitTestResult;
import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.p002ui.node.NodeChain;
import androidx.compose.p002ui.node.NodeKind;
import androidx.compose.p002ui.node.Owner;
import androidx.compose.p002ui.platform.accessibility.CollectionInfo_androidKt;
import androidx.compose.p002ui.semantics.AccessibilityAction;
import androidx.compose.p002ui.semantics.CustomAccessibilityAction;
import androidx.compose.p002ui.semantics.LiveRegionMode;
import androidx.compose.p002ui.semantics.ProgressBarRangeInfo;
import androidx.compose.p002ui.semantics.Role;
import androidx.compose.p002ui.semantics.ScrollAxisRange;
import androidx.compose.p002ui.semantics.SemanticsActions;
import androidx.compose.p002ui.semantics.SemanticsConfiguration;
import androidx.compose.p002ui.semantics.SemanticsConfigurationKt;
import androidx.compose.p002ui.semantics.SemanticsNode;
import androidx.compose.p002ui.semantics.SemanticsNodeKt;
import androidx.compose.p002ui.semantics.SemanticsProperties;
import androidx.compose.p002ui.semantics.SemanticsPropertiesAndroid;
import androidx.compose.p002ui.semantics.SemanticsPropertyKey;
import androidx.compose.p002ui.state.ToggleableState;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.platform.AndroidAccessibilitySpannableString_androidKt;
import androidx.compose.ui.text.platform.URLSpanCache;
import androidx.compose.ui.util.ListUtilsKt;
import androidx.compose.ui.viewinterop.AndroidViewHolder;
import androidx.core.view.AccessibilityDelegateCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import androidx.core.view.accessibility.AccessibilityNodeProviderCompat;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Pair;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.ClosedFloatingPointRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.channels.BufferOverflow;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;

@Metadata(d1 = {"\u0000è\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\r\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\"\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 ú\u00012\u00020\u0001:\u0010ø\u0001ù\u0001ú\u0001û\u0001ü\u0001ý\u0001þ\u0001ÿ\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J*\u0010p\u001a\u00020!2\u0006\u0010q\u001a\u00020\u00122\u0006\u0010r\u001a\u00020*2\u0006\u0010s\u001a\u00020\u00062\b\u0010t\u001a\u0004\u0018\u00010uH\u0002J\u0010\u0010v\u001a\u00020w2\u0006\u0010x\u001a\u00020%H\u0002J\u0010\u0010y\u001a\u00020!H\u0080@¢\u0006\u0004\bz\u0010{J;\u0010|\u001a\u00020\u00142\f\u0010#\u001a\b\u0012\u0004\u0012\u00020%0$2\u0006\u0010}\u001a\u00020\u00142\u0006\u0010~\u001a\u00020\u00122\u0007\u0010\u007f\u001a\u00030\u0080\u0001H\u0002ø\u0001\u0000¢\u0006\u0006\b\u0081\u0001\u0010\u0082\u0001J-\u0010|\u001a\u00020\u00142\u0006\u0010}\u001a\u00020\u00142\u0006\u0010~\u001a\u00020\u00122\u0007\u0010\u007f\u001a\u00030\u0080\u0001H\u0000ø\u0001\u0000¢\u0006\u0006\b\u0083\u0001\u0010\u0084\u0001J\t\u0010\u0085\u0001\u001a\u00020!H\u0002J\u0011\u0010\u0086\u0001\u001a\u00020\u00142\u0006\u0010q\u001a\u00020\u0012H\u0002J\u001a\u0010\u0087\u0001\u001a\u00020N2\u0006\u0010q\u001a\u00020\u00122\u0007\u0010\u0088\u0001\u001a\u00020\u0012H\u0003J\u0013\u0010\u0089\u0001\u001a\u0004\u0018\u00010*2\u0006\u0010q\u001a\u00020\u0012H\u0002J\u0014\u0010\u008a\u0001\u001a\u0004\u0018\u00010\u00062\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002JC\u0010\u008c\u0001\u001a\u00020N2\u0006\u0010q\u001a\u00020\u00122\t\u0010\u008d\u0001\u001a\u0004\u0018\u00010\u00122\t\u0010\u008e\u0001\u001a\u0004\u0018\u00010\u00122\t\u0010\u008f\u0001\u001a\u0004\u0018\u00010\u00122\t\u0010\u0090\u0001\u001a\u0004\u0018\u00010\u001eH\u0002¢\u0006\u0003\u0010\u0091\u0001J\u0019\u0010\u0092\u0001\u001a\u00020\u00142\b\u0010\u0093\u0001\u001a\u00030\u0094\u0001H\u0000¢\u0006\u0003\b\u0095\u0001JF\u0010\u0096\u0001\u001a\u00020!2\b\u0010\u0097\u0001\u001a\u00030\u008b\u00012\u001b\u0010\u0098\u0001\u001a\u0016\u0012\u0005\u0012\u00030\u008b\u00010\u0099\u0001j\n\u0012\u0005\u0012\u00030\u008b\u0001`\u009a\u00012\u0014\u0010\u009b\u0001\u001a\u000f\u0012\u000b\u0012\t\u0012\u0005\u0012\u00030\u008b\u00010,0WH\u0002J\u0014\u0010\u009c\u0001\u001a\u00030\u009d\u00012\b\u0010\u009e\u0001\u001a\u00030\u009f\u0001H\u0016J\u0012\u0010 \u0001\u001a\u00020\u00122\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0012\u0010¡\u0001\u001a\u00020\u00122\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0012\u0010¢\u0001\u001a\u00020\u00142\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0014\u0010£\u0001\u001a\u0004\u0018\u00010\u00062\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0015\u0010¤\u0001\u001a\u0005\u0018\u00010¥\u00012\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0016\u0010¦\u0001\u001a\u0004\u0018\u00010\u00062\t\u0010x\u001a\u0005\u0018\u00010\u008b\u0001H\u0002J \u0010§\u0001\u001a\u0005\u0018\u00010¨\u00012\t\u0010x\u001a\u0005\u0018\u00010\u008b\u00012\u0007\u0010©\u0001\u001a\u00020\u0012H\u0002J#\u0010ª\u0001\u001a\u00020\u00122\b\u0010«\u0001\u001a\u00030¬\u00012\b\u0010\u00ad\u0001\u001a\u00030¬\u0001H\u0001¢\u0006\u0003\b®\u0001J\u0011\u0010¯\u0001\u001a\u00020\u00142\u0006\u0010q\u001a\u00020\u0012H\u0002J\u0012\u0010°\u0001\u001a\u00020\u00142\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0012\u0010±\u0001\u001a\u00020\u00142\u0007\u0010x\u001a\u00030\u008b\u0001H\u0002J\u0012\u0010²\u0001\u001a\u00020!2\u0007\u0010³\u0001\u001a\u00020iH\u0002J\u0018\u0010´\u0001\u001a\u00020!2\u0007\u0010³\u0001\u001a\u00020iH\u0000¢\u0006\u0003\bµ\u0001J\u000f\u0010¶\u0001\u001a\u00020!H\u0000¢\u0006\u0003\b·\u0001J$\u0010¸\u0001\u001a\u00020\u00142\u0006\u0010q\u001a\u00020\u00122\u0007\u0010¹\u0001\u001a\u00020\u00122\b\u0010t\u001a\u0004\u0018\u00010uH\u0002J#\u0010º\u0001\u001a\u00020!2\u0006\u0010q\u001a\u00020\u00122\u0006\u0010r\u001a\u00020*2\b\u0010»\u0001\u001a\u00030\u008b\u0001H\u0002J!\u0010¼\u0001\u001a\u00020\u00142\u0007\u0010½\u0001\u001a\u00020\u00122\r\u0010¾\u0001\u001a\b\u0012\u0004\u0012\u00020b0/H\u0002J\u0011\u0010¿\u0001\u001a\u00020\u00142\u0006\u0010q\u001a\u00020\u0012H\u0002J\u0012\u0010À\u0001\u001a\u00020!2\u0007\u0010Á\u0001\u001a\u00020bH\u0002J'\u0010Â\u0001\u001a\u0016\u0012\u0005\u0012\u00030\u008b\u00010Ã\u0001j\n\u0012\u0005\u0012\u00030\u008b\u0001`Ä\u00012\u0007\u0010Å\u0001\u001a\u00020\u0014H\u0082\bJ\u0012\u0010Æ\u0001\u001a\u00020\u00122\u0007\u0010½\u0001\u001a\u00020\u0012H\u0002J\u001c\u0010Ç\u0001\u001a\u00020!2\b\u0010È\u0001\u001a\u00030\u008b\u00012\u0007\u0010É\u0001\u001a\u00020]H\u0002J\u0012\u0010Ê\u0001\u001a\u00020\u00142\u0007\u0010\u0093\u0001\u001a\u00020NH\u0002J@\u0010Ë\u0001\u001a\u00020\u00142\u0006\u0010q\u001a\u00020\u00122\u0007\u0010\u0088\u0001\u001a\u00020\u00122\u000b\b\u0002\u0010Ì\u0001\u001a\u0004\u0018\u00010\u00122\u0011\b\u0002\u0010Í\u0001\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010/H\u0002¢\u0006\u0003\u0010Î\u0001J&\u0010Ï\u0001\u001a\u00020!2\u0007\u0010Ð\u0001\u001a\u00020\u00122\u0007\u0010Ì\u0001\u001a\u00020\u00122\t\u0010Ñ\u0001\u001a\u0004\u0018\u00010\u0006H\u0002J\u0012\u0010Ò\u0001\u001a\u00020!2\u0007\u0010Ð\u0001\u001a\u00020\u0012H\u0002J\u0018\u0010Ó\u0001\u001a\u00020!2\r\u0010Ô\u0001\u001a\b\u0012\u0004\u0012\u00020%0$H\u0002J\u001b\u0010Õ\u0001\u001a\u00020!2\u0007\u0010³\u0001\u001a\u00020i2\u0007\u0010Ö\u0001\u001a\u00020UH\u0002J\u0012\u0010×\u0001\u001a\u00020!2\u0007\u0010³\u0001\u001a\u00020iH\u0002J-\u0010Ø\u0001\u001a\u00020\u00142\u0007\u0010x\u001a\u00030\u008b\u00012\u0007\u0010Ù\u0001\u001a\u00020\u00122\u0007\u0010Ú\u0001\u001a\u00020\u00122\u0007\u0010Û\u0001\u001a\u00020\u0014H\u0002J\u001a\u0010Ü\u0001\u001a\u00020!2\u0007\u0010x\u001a\u00030\u008b\u00012\u0006\u0010r\u001a\u00020*H\u0002J\u001a\u0010Ý\u0001\u001a\u00020!2\u0007\u0010x\u001a\u00030\u008b\u00012\u0006\u0010r\u001a\u00020*H\u0002J\u001a\u0010Þ\u0001\u001a\u00020!2\u0007\u0010x\u001a\u00030\u008b\u00012\u0006\u0010r\u001a\u00020*H\u0002J\u001a\u0010ß\u0001\u001a\u00020!2\u0007\u0010x\u001a\u00030\u008b\u00012\u0006\u0010r\u001a\u00020*H\u0002J\t\u0010à\u0001\u001a\u00020!H\u0002JN\u0010á\u0001\u001a\t\u0012\u0005\u0012\u00030\u008b\u00010,2\u0007\u0010Å\u0001\u001a\u00020\u00142\u001b\u0010â\u0001\u001a\u0016\u0012\u0005\u0012\u00030\u008b\u00010\u0099\u0001j\n\u0012\u0005\u0012\u00030\u008b\u0001`\u009a\u00012\u0016\b\u0002\u0010ã\u0001\u001a\u000f\u0012\u000b\u0012\t\u0012\u0005\u0012\u00030\u008b\u00010,0WH\u0002J)\u0010ä\u0001\u001a\t\u0012\u0005\u0012\u00030\u008b\u00010,2\u0007\u0010Å\u0001\u001a\u00020\u00142\u000e\u0010å\u0001\u001a\t\u0012\u0005\u0012\u00030\u008b\u00010,H\u0002J\"\u0010æ\u0001\u001a\u0005\u0018\u00010ç\u00012\n\u0010è\u0001\u001a\u0005\u0018\u00010\u008b\u00012\b\u0010é\u0001\u001a\u00030ê\u0001H\u0002J-\u0010ë\u0001\u001a\u00020\u00142\u0007\u0010x\u001a\u00030\u008b\u00012\u0007\u0010©\u0001\u001a\u00020\u00122\u0007\u0010ì\u0001\u001a\u00020\u00142\u0007\u0010í\u0001\u001a\u00020\u0014H\u0002J4\u0010î\u0001\u001a\u0005\u0018\u0001Hï\u0001\"\t\b\u0000\u0010ï\u0001*\u00020\u001e2\n\u0010\u0090\u0001\u001a\u0005\u0018\u0001Hï\u00012\t\b\u0001\u0010ð\u0001\u001a\u00020\u0012H\u0002¢\u0006\u0003\u0010ñ\u0001J\u0011\u0010ò\u0001\u001a\u00020!2\u0006\u0010q\u001a\u00020\u0012H\u0002J\t\u0010ó\u0001\u001a\u00020!H\u0002J\u0011\u0010ô\u0001\u001a\u0005\u0018\u00010¥\u0001*\u00030õ\u0001H\u0002J\u0011\u0010ö\u0001\u001a\u0005\u0018\u00010÷\u0001*\u00030¥\u0001H\u0002R\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0014\u0010\t\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\bR\u001a\u0010\u000b\u001a\u00020\fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u0013\u001a\u00020\u0014@@X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u000e\u0010\u001a\u001a\u00020\u001bX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u001c\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001e0\u001d0\u001dX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020!0 X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010#\u001a\b\u0012\u0004\u0012\u00020%0$8BX\u0082\u000e¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u000e\u0010(\u001a\u00020\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010)\u001a\u0004\u0018\u00010*X\u0082\u000e¢\u0006\u0002\n\u0000R2\u0010+\u001a&\u0012\f\u0012\n .*\u0004\u0018\u00010-0- .*\u0012\u0012\f\u0012\n .*\u0004\u0018\u00010-0-\u0018\u00010/0,X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u00100\u001a\u000201X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u00102\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u00103\u001a\u000204X\u0082\u0004¢\u0006\u0002\n\u0000R$\u00105\u001a\u00020\u00128\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b6\u00107\u001a\u0004\b8\u00109\"\u0004\b:\u0010;R\u001a\u0010<\u001a\u00020=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u0010?\"\u0004\b@\u0010AR\u001a\u0010B\u001a\u00020=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bC\u0010?\"\u0004\bD\u0010AR\u0014\u0010E\u001a\u00020\u00148@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bF\u0010\u0017R\u0014\u0010G\u001a\u00020\u00148BX\u0082\u0004¢\u0006\u0006\u001a\u0004\bG\u0010\u0017R\u001a\u0010H\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001e0I0\u001dX\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010J\u001a\u00060KR\u00020\u0000X\u0082\u000e¢\u0006\u0002\n\u0000R0\u0010L\u001a\u000e\u0012\u0004\u0012\u00020N\u0012\u0004\u0012\u00020\u00140M8\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\bO\u00107\u001a\u0004\bP\u0010Q\"\u0004\bR\u0010SR\u000e\u0010T\u001a\u00020UX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010V\u001a\b\u0012\u0004\u0012\u00020X0WX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010Y\u001a\u0004\u0018\u00010ZX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010[\u001a\b\u0012\u0004\u0012\u00020X0WX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\\\u001a\b\u0012\u0004\u0012\u00020]0WX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010^\u001a\u00020]X\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010_\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0004\n\u0002\u0010`R\u001a\u0010a\u001a\u000e\u0012\u0004\u0012\u00020b\u0012\u0004\u0012\u00020!0MX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010c\u001a\b\u0012\u0004\u0012\u00020b0,X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010d\u001a\u00020eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010f\u001a\u00020\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010g\u001a\b\u0012\u0004\u0012\u00020i0hX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010j\u001a\u00020kX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010l\u001a\u00020mX\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\bn\u0010o\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0080\u0002"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat;", "Landroidx/core/view/AccessibilityDelegateCompat;", "view", "Landroidx/compose/ui/platform/AndroidComposeView;", "(Landroidx/compose/ui/platform/AndroidComposeView;)V", "ExtraDataTestTraversalAfterVal", "", "getExtraDataTestTraversalAfterVal$ui_release", "()Ljava/lang/String;", "ExtraDataTestTraversalBeforeVal", "getExtraDataTestTraversalBeforeVal$ui_release", "SendRecurringAccessibilityEventsIntervalMillis", "", "getSendRecurringAccessibilityEventsIntervalMillis$ui_release", "()J", "setSendRecurringAccessibilityEventsIntervalMillis$ui_release", "(J)V", "accessibilityCursorPosition", "", "value", "", "accessibilityForceEnabledForTesting", "getAccessibilityForceEnabledForTesting$ui_release", "()Z", "setAccessibilityForceEnabledForTesting$ui_release", "(Z)V", "accessibilityManager", "Landroid/view/accessibility/AccessibilityManager;", "actionIdToLabel", "Landroidx/collection/SparseArrayCompat;", "", "boundsUpdateChannel", "Lkotlinx/coroutines/channels/Channel;", "", "checkingForSemanticsChanges", "currentSemanticsNodes", "Landroidx/collection/IntObjectMap;", "Landroidx/compose/ui/platform/SemanticsNodeWithAdjustedBounds;", "getCurrentSemanticsNodes", "()Landroidx/collection/IntObjectMap;", "currentSemanticsNodesInvalidated", "currentlyFocusedANI", "Landroidx/core/view/accessibility/AccessibilityNodeInfoCompat;", "enabledServices", "", "Landroid/accessibilityservice/AccessibilityServiceInfo;", "kotlin.jvm.PlatformType", "", "enabledStateListener", "Landroid/view/accessibility/AccessibilityManager$AccessibilityStateChangeListener;", "focusedVirtualViewId", "handler", "Landroid/os/Handler;", "hoveredVirtualViewId", "getHoveredVirtualViewId$ui_release$annotations", "()V", "getHoveredVirtualViewId$ui_release", "()I", "setHoveredVirtualViewId$ui_release", "(I)V", "idToAfterMap", "Landroidx/collection/MutableIntIntMap;", "getIdToAfterMap$ui_release", "()Landroidx/collection/MutableIntIntMap;", "setIdToAfterMap$ui_release", "(Landroidx/collection/MutableIntIntMap;)V", "idToBeforeMap", "getIdToBeforeMap$ui_release", "setIdToBeforeMap$ui_release", "isEnabled", "isEnabled$ui_release", "isTouchExplorationEnabled", "labelToActionId", "Landroidx/collection/MutableObjectIntMap;", "nodeProvider", "Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$ComposeAccessibilityNodeProvider;", "onSendAccessibilityEvent", "Lkotlin/Function1;", "Landroid/view/accessibility/AccessibilityEvent;", "getOnSendAccessibilityEvent$ui_release$annotations", "getOnSendAccessibilityEvent$ui_release", "()Lkotlin/jvm/functions/Function1;", "setOnSendAccessibilityEvent$ui_release", "(Lkotlin/jvm/functions/Function1;)V", "paneDisplayed", "Landroidx/collection/MutableIntSet;", "pendingHorizontalScrollEvents", "Landroidx/collection/MutableIntObjectMap;", "Landroidx/compose/ui/semantics/ScrollAxisRange;", "pendingTextTraversedEvent", "Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$PendingTextTraversedEvent;", "pendingVerticalScrollEvents", "previousSemanticsNodes", "Landroidx/compose/ui/platform/SemanticsNodeCopy;", "previousSemanticsRoot", "previousTraversedNode", "Ljava/lang/Integer;", "scheduleScrollEventIfNeededLambda", "Landroidx/compose/ui/platform/ScrollObservationScope;", "scrollObservationScopes", "semanticsChangeChecker", "Ljava/lang/Runnable;", "sendingFocusAffectingEvent", "subtreeChangedLayoutNodes", "Landroidx/collection/ArraySet;", "Landroidx/compose/ui/node/LayoutNode;", "touchExplorationStateListener", "Landroid/view/accessibility/AccessibilityManager$TouchExplorationStateChangeListener;", "urlSpanCache", "Landroidx/compose/ui/text/platform/URLSpanCache;", "getView", "()Landroidx/compose/ui/platform/AndroidComposeView;", "addExtraDataToAccessibilityNodeInfoHelper", "virtualViewId", "info", "extraDataKey", "arguments", "Landroid/os/Bundle;", "boundsInScreen", "Landroid/graphics/Rect;", "node", "boundsUpdatesEventLoop", "boundsUpdatesEventLoop$ui_release", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "canScroll", "vertical", "direction", "position", "Landroidx/compose/ui/geometry/Offset;", "canScroll-moWRBKg", "(Landroidx/collection/IntObjectMap;ZIJ)Z", "canScroll-0AR0LA0$ui_release", "(ZIJ)Z", "checkForSemanticsChanges", "clearAccessibilityFocus", "createEvent", "eventType", "createNodeInfo", "createStateDescriptionForTextField", "Landroidx/compose/ui/semantics/SemanticsNode;", "createTextSelectionChangedEvent", "fromIndex", "toIndex", "itemCount", "text", "(ILjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/CharSequence;)Landroid/view/accessibility/AccessibilityEvent;", "dispatchHoverEvent", "event", "Landroid/view/MotionEvent;", "dispatchHoverEvent$ui_release", "geometryDepthFirstSearch", "currNode", "geometryList", "Ljava/util/ArrayList;", "Lkotlin/collections/ArrayList;", "containerMapToChildren", "getAccessibilityNodeProvider", "Landroidx/core/view/accessibility/AccessibilityNodeProviderCompat;", "host", "Landroid/view/View;", "getAccessibilitySelectionEnd", "getAccessibilitySelectionStart", "getInfoIsCheckable", "getInfoStateDescriptionOrNull", "getInfoText", "Landroidx/compose/ui/text/AnnotatedString;", "getIterableTextForAccessibility", "getIteratorForGranularity", "Landroidx/compose/ui/platform/AccessibilityIterators$TextSegmentIterator;", "granularity", "hitTestSemanticsAt", "x", "", "y", "hitTestSemanticsAt$ui_release", "isAccessibilityFocused", "isAccessibilitySelectionExtendable", "isScreenReaderFocusable", "notifySubtreeAccessibilityStateChangedIfNeeded", "layoutNode", "onLayoutChange", "onLayoutChange$ui_release", "onSemanticsChange", "onSemanticsChange$ui_release", "performActionHelper", "action", "populateAccessibilityNodeInfoProperties", "semanticsNode", "registerScrollingId", "id", "oldScrollObservationScopes", "requestAccessibilityFocus", "scheduleScrollEventIfNeeded", "scrollObservationScope", "semanticComparator", "Ljava/util/Comparator;", "Lkotlin/Comparator;", "layoutIsRtl", "semanticsNodeIdToAccessibilityVirtualNodeId", "sendAccessibilitySemanticsStructureChangeEvents", "newNode", "oldNode", "sendEvent", "sendEventForVirtualView", "contentChangeType", "contentDescription", "(IILjava/lang/Integer;Ljava/util/List;)Z", "sendPaneChangeEvents", "semanticsNodeId", "title", "sendPendingTextTraversedAtGranularityEvent", "sendSemanticsPropertyChangeEvents", "newSemanticsNodes", "sendSubtreeChangeAccessibilityEvents", "subtreeChangedSemanticsNodesIds", "sendTypeViewScrolledAccessibilityEvent", "setAccessibilitySelection", "start", "end", "traversalMode", "setContentInvalid", "setIsCheckable", "setStateDescription", "setText", "setTraversalValues", "sortByGeometryGroupings", "parentListToSort", "containerChildrenMapping", "subtreeSortedByGeometryGrouping", "listToSort", "toScreenCoords", "Landroid/graphics/RectF;", "textNode", "bounds", "Landroidx/compose/ui/geometry/Rect;", "traverseAtGranularity", "forward", "extendSelection", "trimToSize", "T", "size", "(Ljava/lang/CharSequence;I)Ljava/lang/CharSequence;", "updateHoveredVirtualView", "updateSemanticsNodesCopyAndPanes", "getTextForTextField", "Landroidx/compose/ui/semantics/SemanticsConfiguration;", "toSpannableString", "Landroid/text/SpannableString;", "Api24Impl", "Api29Impl", "Companion", "ComposeAccessibilityNodeProvider", "LtrBoundsComparator", "PendingTextTraversedEvent", "RtlBoundsComparator", "TopBottomBoundsComparator", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidComposeViewAccessibilityDelegateCompat extends AccessibilityDelegateCompat {
    public static final int AccessibilityCursorPositionUndefined = -1;
    public static final int AccessibilitySliderStepsCount = 20;
    public static final String ClassName = "android.view.View";
    public static final String ExtraDataIdKey = "androidx.compose.ui.semantics.id";
    public static final String ExtraDataTestTagKey = "androidx.compose.ui.semantics.testTag";
    public static final int InvalidId = Integer.MIN_VALUE;
    public static final String LogTag = "AccessibilityDelegate";
    public static final int ParcelSafeTextLength = 100000;
    public static final String TextClassName = "android.widget.TextView";
    public static final String TextFieldClassName = "android.widget.EditText";
    public static final long TextTraversedEventTimeoutMillis = 1000;
    private final String ExtraDataTestTraversalAfterVal;
    private final String ExtraDataTestTraversalBeforeVal;
    private long SendRecurringAccessibilityEventsIntervalMillis;
    private int accessibilityCursorPosition;
    private boolean accessibilityForceEnabledForTesting;
    private final AccessibilityManager accessibilityManager;
    private SparseArrayCompat<SparseArrayCompat<CharSequence>> actionIdToLabel;
    private final Channel<Unit> boundsUpdateChannel;
    private boolean checkingForSemanticsChanges;
    private IntObjectMap<SemanticsNodeWithAdjustedBounds> currentSemanticsNodes;
    private boolean currentSemanticsNodesInvalidated;
    private AccessibilityNodeInfoCompat currentlyFocusedANI;
    private List<AccessibilityServiceInfo> enabledServices;
    private final AccessibilityManager.AccessibilityStateChangeListener enabledStateListener;
    private int focusedVirtualViewId;
    private final Handler handler;
    private MutableIntIntMap idToAfterMap;
    private MutableIntIntMap idToBeforeMap;
    private SparseArrayCompat<MutableObjectIntMap<CharSequence>> labelToActionId;
    private ComposeAccessibilityNodeProvider nodeProvider;
    private MutableIntSet paneDisplayed;
    private final MutableIntObjectMap<ScrollAxisRange> pendingHorizontalScrollEvents;
    private PendingTextTraversedEvent pendingTextTraversedEvent;
    private final MutableIntObjectMap<ScrollAxisRange> pendingVerticalScrollEvents;
    private MutableIntObjectMap<SemanticsNodeCopy> previousSemanticsNodes;
    private SemanticsNodeCopy previousSemanticsRoot;
    private Integer previousTraversedNode;
    private final Function1<ScrollObservationScope, Unit> scheduleScrollEventIfNeededLambda;
    private final List<ScrollObservationScope> scrollObservationScopes;
    private final Runnable semanticsChangeChecker;
    private boolean sendingFocusAffectingEvent;
    private final ArraySet<LayoutNode> subtreeChangedLayoutNodes;
    private final AccessibilityManager.TouchExplorationStateChangeListener touchExplorationStateListener;
    private final URLSpanCache urlSpanCache;
    private final AndroidComposeView view;
    public static final int $stable = 8;
    private static final IntList AccessibilityActionsResourceIds = IntListKt.intListOf(C1597R.id.accessibility_custom_action_0, C1597R.id.accessibility_custom_action_1, C1597R.id.accessibility_custom_action_2, C1597R.id.accessibility_custom_action_3, C1597R.id.accessibility_custom_action_4, C1597R.id.accessibility_custom_action_5, C1597R.id.accessibility_custom_action_6, C1597R.id.accessibility_custom_action_7, C1597R.id.accessibility_custom_action_8, C1597R.id.accessibility_custom_action_9, C1597R.id.accessibility_custom_action_10, C1597R.id.accessibility_custom_action_11, C1597R.id.accessibility_custom_action_12, C1597R.id.accessibility_custom_action_13, C1597R.id.accessibility_custom_action_14, C1597R.id.accessibility_custom_action_15, C1597R.id.accessibility_custom_action_16, C1597R.id.accessibility_custom_action_17, C1597R.id.accessibility_custom_action_18, C1597R.id.accessibility_custom_action_19, C1597R.id.accessibility_custom_action_20, C1597R.id.accessibility_custom_action_21, C1597R.id.accessibility_custom_action_22, C1597R.id.accessibility_custom_action_23, C1597R.id.accessibility_custom_action_24, C1597R.id.accessibility_custom_action_25, C1597R.id.accessibility_custom_action_26, C1597R.id.accessibility_custom_action_27, C1597R.id.accessibility_custom_action_28, C1597R.id.accessibility_custom_action_29, C1597R.id.accessibility_custom_action_30, C1597R.id.accessibility_custom_action_31);
    private int hoveredVirtualViewId = Integer.MIN_VALUE;
    private Function1<? super AccessibilityEvent, Boolean> onSendAccessibilityEvent = new Function1<AccessibilityEvent, Boolean>() {
        {
            super(1);
        }

        public final Boolean invoke(AccessibilityEvent accessibilityEvent) {
            return Boolean.valueOf(this.this$0.getView().getParent().requestSendAccessibilityEvent(this.this$0.getView(), accessibilityEvent));
        }
    };

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ToggleableState.values().length];
            try {
                iArr[ToggleableState.On.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ToggleableState.Off.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ToggleableState.Indeterminate.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static void getHoveredVirtualViewId$ui_release$annotations() {
    }

    public static void getOnSendAccessibilityEvent$ui_release$annotations() {
    }

    public final AndroidComposeView getView() {
        return this.view;
    }

    public AndroidComposeViewAccessibilityDelegateCompat(AndroidComposeView androidComposeView) {
        this.view = androidComposeView;
        Object systemService = androidComposeView.getContext().getSystemService("accessibility");
        Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.view.accessibility.AccessibilityManager");
        AccessibilityManager accessibilityManager = (AccessibilityManager) systemService;
        this.accessibilityManager = accessibilityManager;
        this.SendRecurringAccessibilityEventsIntervalMillis = 100L;
        this.enabledStateListener = new AccessibilityManager.AccessibilityStateChangeListener() {
            @Override
            public final void onAccessibilityStateChanged(boolean z) {
                AndroidComposeViewAccessibilityDelegateCompat.enabledStateListener$lambda$0(this.f$0, z);
            }
        };
        this.touchExplorationStateListener = new AccessibilityManager.TouchExplorationStateChangeListener() {
            @Override
            public final void onTouchExplorationStateChanged(boolean z) {
                AndroidComposeViewAccessibilityDelegateCompat.touchExplorationStateListener$lambda$1(this.f$0, z);
            }
        };
        this.enabledServices = accessibilityManager.getEnabledAccessibilityServiceList(-1);
        this.handler = new Handler(Looper.getMainLooper());
        this.nodeProvider = new ComposeAccessibilityNodeProvider();
        this.focusedVirtualViewId = Integer.MIN_VALUE;
        this.pendingHorizontalScrollEvents = new MutableIntObjectMap<>(0, 1, null);
        this.pendingVerticalScrollEvents = new MutableIntObjectMap<>(0, 1, null);
        this.actionIdToLabel = new SparseArrayCompat<>(0, 1, null);
        this.labelToActionId = new SparseArrayCompat<>(0, 1, null);
        this.accessibilityCursorPosition = -1;
        this.subtreeChangedLayoutNodes = new ArraySet<>(0, 1, null);
        this.boundsUpdateChannel = ChannelKt.Channel$default(1, (BufferOverflow) null, (Function1) null, 6, (Object) null);
        this.currentSemanticsNodesInvalidated = true;
        this.currentSemanticsNodes = IntObjectMapKt.intObjectMapOf();
        this.paneDisplayed = new MutableIntSet(0, 1, null);
        this.idToBeforeMap = new MutableIntIntMap(0, 1, null);
        this.idToAfterMap = new MutableIntIntMap(0, 1, null);
        this.ExtraDataTestTraversalBeforeVal = "android.view.accessibility.extra.EXTRA_DATA_TEST_TRAVERSALBEFORE_VAL";
        this.ExtraDataTestTraversalAfterVal = "android.view.accessibility.extra.EXTRA_DATA_TEST_TRAVERSALAFTER_VAL";
        this.urlSpanCache = new URLSpanCache();
        this.previousSemanticsNodes = IntObjectMapKt.mutableIntObjectMapOf();
        this.previousSemanticsRoot = new SemanticsNodeCopy(androidComposeView.getSemanticsOwner().getUnmergedRootSemanticsNode(), IntObjectMapKt.intObjectMapOf());
        androidComposeView.addOnAttachStateChangeListener(new View.OnAttachStateChangeListener() {
            @Override
            public void onViewAttachedToWindow(View view) {
                AccessibilityManager accessibilityManager2 = AndroidComposeViewAccessibilityDelegateCompat.this.accessibilityManager;
                AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat = AndroidComposeViewAccessibilityDelegateCompat.this;
                accessibilityManager2.addAccessibilityStateChangeListener(androidComposeViewAccessibilityDelegateCompat.enabledStateListener);
                accessibilityManager2.addTouchExplorationStateChangeListener(androidComposeViewAccessibilityDelegateCompat.touchExplorationStateListener);
            }

            @Override
            public void onViewDetachedFromWindow(View view) {
                AndroidComposeViewAccessibilityDelegateCompat.this.handler.removeCallbacks(AndroidComposeViewAccessibilityDelegateCompat.this.semanticsChangeChecker);
                AccessibilityManager accessibilityManager2 = AndroidComposeViewAccessibilityDelegateCompat.this.accessibilityManager;
                AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat = AndroidComposeViewAccessibilityDelegateCompat.this;
                accessibilityManager2.removeAccessibilityStateChangeListener(androidComposeViewAccessibilityDelegateCompat.enabledStateListener);
                accessibilityManager2.removeTouchExplorationStateChangeListener(androidComposeViewAccessibilityDelegateCompat.touchExplorationStateListener);
            }
        });
        this.semanticsChangeChecker = new Runnable() {
            @Override
            public final void run() {
                AndroidComposeViewAccessibilityDelegateCompat.semanticsChangeChecker$lambda$49(this.f$0);
            }
        };
        this.scrollObservationScopes = new ArrayList();
        this.scheduleScrollEventIfNeededLambda = new Function1<ScrollObservationScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ScrollObservationScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ScrollObservationScope scrollObservationScope) {
                this.this$0.scheduleScrollEventIfNeeded(scrollObservationScope);
            }
        };
    }

    public final int getHoveredVirtualViewId() {
        return this.hoveredVirtualViewId;
    }

    public final void setHoveredVirtualViewId$ui_release(int i) {
        this.hoveredVirtualViewId = i;
    }

    public final Function1<AccessibilityEvent, Boolean> getOnSendAccessibilityEvent$ui_release() {
        return this.onSendAccessibilityEvent;
    }

    public final void setOnSendAccessibilityEvent$ui_release(Function1<? super AccessibilityEvent, Boolean> function1) {
        this.onSendAccessibilityEvent = function1;
    }

    public final boolean getAccessibilityForceEnabledForTesting() {
        return this.accessibilityForceEnabledForTesting;
    }

    public final void setAccessibilityForceEnabledForTesting$ui_release(boolean z) {
        this.accessibilityForceEnabledForTesting = z;
        this.currentSemanticsNodesInvalidated = true;
    }

    public final long getSendRecurringAccessibilityEventsIntervalMillis() {
        return this.SendRecurringAccessibilityEventsIntervalMillis;
    }

    public final void setSendRecurringAccessibilityEventsIntervalMillis$ui_release(long j) {
        this.SendRecurringAccessibilityEventsIntervalMillis = j;
    }

    public static final void enabledStateListener$lambda$0(AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat, boolean z) {
        List<AccessibilityServiceInfo> listEmptyList;
        if (z) {
            listEmptyList = androidComposeViewAccessibilityDelegateCompat.accessibilityManager.getEnabledAccessibilityServiceList(-1);
        } else {
            listEmptyList = CollectionsKt.emptyList();
        }
        androidComposeViewAccessibilityDelegateCompat.enabledServices = listEmptyList;
    }

    public static final void touchExplorationStateListener$lambda$1(AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat, boolean z) {
        androidComposeViewAccessibilityDelegateCompat.enabledServices = androidComposeViewAccessibilityDelegateCompat.accessibilityManager.getEnabledAccessibilityServiceList(-1);
    }

    public final boolean isEnabled$ui_release() {
        return this.accessibilityForceEnabledForTesting || (this.accessibilityManager.isEnabled() && !this.enabledServices.isEmpty());
    }

    private final boolean isTouchExplorationEnabled() {
        return this.accessibilityForceEnabledForTesting || (this.accessibilityManager.isEnabled() && this.accessibilityManager.isTouchExplorationEnabled());
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\b\u000b\b\u0002\u0018\u00002\u00020\u0001B5\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\rR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\rR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\rR\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014¨\u0006\u0015"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$PendingTextTraversedEvent;", "", "node", "Landroidx/compose/ui/semantics/SemanticsNode;", "action", "", "granularity", "fromIndex", "toIndex", "traverseTime", "", "(Landroidx/compose/ui/semantics/SemanticsNode;IIIIJ)V", "getAction", "()I", "getFromIndex", "getGranularity", "getNode", "()Landroidx/compose/ui/semantics/SemanticsNode;", "getToIndex", "getTraverseTime", "()J", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class PendingTextTraversedEvent {
        private final int action;
        private final int fromIndex;
        private final int granularity;
        private final SemanticsNode node;
        private final int toIndex;
        private final long traverseTime;

        public PendingTextTraversedEvent(SemanticsNode semanticsNode, int i, int i2, int i3, int i4, long j) {
            this.node = semanticsNode;
            this.action = i;
            this.granularity = i2;
            this.fromIndex = i3;
            this.toIndex = i4;
            this.traverseTime = j;
        }

        public final SemanticsNode getNode() {
            return this.node;
        }

        public final int getAction() {
            return this.action;
        }

        public final int getGranularity() {
            return this.granularity;
        }

        public final int getFromIndex() {
            return this.fromIndex;
        }

        public final int getToIndex() {
            return this.toIndex;
        }

        public final long getTraverseTime() {
            return this.traverseTime;
        }
    }

    public final IntObjectMap<SemanticsNodeWithAdjustedBounds> getCurrentSemanticsNodes() {
        if (this.currentSemanticsNodesInvalidated) {
            this.currentSemanticsNodesInvalidated = false;
            this.currentSemanticsNodes = SemanticsUtils_androidKt.getAllUncoveredSemanticsNodesToIntObjectMap(this.view.getSemanticsOwner());
            if (isEnabled$ui_release()) {
                setTraversalValues();
            }
        }
        return this.currentSemanticsNodes;
    }

    public final MutableIntIntMap getIdToBeforeMap() {
        return this.idToBeforeMap;
    }

    public final void setIdToBeforeMap$ui_release(MutableIntIntMap mutableIntIntMap) {
        this.idToBeforeMap = mutableIntIntMap;
    }

    public final MutableIntIntMap getIdToAfterMap() {
        return this.idToAfterMap;
    }

    public final void setIdToAfterMap$ui_release(MutableIntIntMap mutableIntIntMap) {
        this.idToAfterMap = mutableIntIntMap;
    }

    public final String getExtraDataTestTraversalBeforeVal() {
        return this.ExtraDataTestTraversalBeforeVal;
    }

    public final String getExtraDataTestTraversalAfterVal() {
        return this.ExtraDataTestTraversalAfterVal;
    }

    public final boolean m6475canScroll0AR0LA0$ui_release(boolean vertical, int direction, long position) {
        if (Intrinsics.areEqual(Looper.getMainLooper().getThread(), Thread.currentThread())) {
            return m6474canScrollmoWRBKg(getCurrentSemanticsNodes(), vertical, direction, position);
        }
        return false;
    }

    private final boolean m6474canScrollmoWRBKg(IntObjectMap<SemanticsNodeWithAdjustedBounds> currentSemanticsNodes, boolean vertical, int direction, long position) throws NoWhenBranchMatchedException {
        SemanticsPropertyKey<ScrollAxisRange> horizontalScrollAxisRange;
        boolean z;
        ScrollAxisRange scrollAxisRange;
        if (Offset.m4343equalsimpl0(position, Offset.INSTANCE.m4361getUnspecifiedF1C5BW0()) || !Offset.m4349isValidimpl(position)) {
            return false;
        }
        if (vertical) {
            horizontalScrollAxisRange = SemanticsProperties.INSTANCE.getVerticalScrollAxisRange();
        } else if (!vertical) {
            horizontalScrollAxisRange = SemanticsProperties.INSTANCE.getHorizontalScrollAxisRange();
        } else {
            throw new NoWhenBranchMatchedException();
        }
        Object[] objArr = currentSemanticsNodes.values;
        long[] jArr = currentSemanticsNodes.metadata;
        int length = jArr.length - 2;
        if (length >= 0) {
            int i = 0;
            boolean z2 = false;
            while (true) {
                long j = jArr[i];
                if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i2 = 8 - ((~(i - length)) >>> 31);
                    for (int i3 = 0; i3 < i2; i3++) {
                        if ((j & 255) < 128) {
                            SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = (SemanticsNodeWithAdjustedBounds) objArr[(i << 3) + i3];
                            if (RectHelper_androidKt.toComposeRect(semanticsNodeWithAdjustedBounds.getAdjustedBounds()).m4372containsk4lQ0M(position) && (scrollAxisRange = (ScrollAxisRange) SemanticsConfigurationKt.getOrNull(semanticsNodeWithAdjustedBounds.getSemanticsNode().getUnmergedConfig(), horizontalScrollAxisRange)) != null) {
                                int i4 = scrollAxisRange.getReverseScrolling() ? -direction : direction;
                                if (direction == 0 && scrollAxisRange.getReverseScrolling()) {
                                    i4 = -1;
                                }
                                if (i4 < 0) {
                                    if (((Number) scrollAxisRange.getValue().invoke()).floatValue() > 0.0f) {
                                        z2 = true;
                                    }
                                } else if (((Number) scrollAxisRange.getValue().invoke()).floatValue() < ((Number) scrollAxisRange.getMaxValue().invoke()).floatValue()) {
                                    z2 = true;
                                }
                            }
                        }
                        j >>= 8;
                    }
                    if (i2 != 8) {
                        return z2;
                    }
                }
                if (i != length) {
                    i++;
                } else {
                    z = z2;
                }
            }
        } else {
            z = false;
        }
        return z;
    }

    public final AccessibilityNodeInfoCompat createNodeInfo(int virtualViewId) throws KotlinNothingValueException {
        LifecycleOwner lifecycleOwner;
        Lifecycle lifecycle;
        AndroidComposeView.ViewTreeOwners viewTreeOwners = this.view.getViewTreeOwners();
        if (((viewTreeOwners == null || (lifecycleOwner = viewTreeOwners.getLifecycleOwner()) == null || (lifecycle = lifecycleOwner.getLifecycle()) == null) ? null : lifecycle.getCurrentState()) == Lifecycle.State.DESTROYED) {
            return null;
        }
        AccessibilityNodeInfoCompat accessibilityNodeInfoCompatObtain = AccessibilityNodeInfoCompat.obtain();
        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = getCurrentSemanticsNodes().get(virtualViewId);
        if (semanticsNodeWithAdjustedBounds == null) {
            return null;
        }
        SemanticsNode semanticsNode = semanticsNodeWithAdjustedBounds.getSemanticsNode();
        if (virtualViewId == -1) {
            ViewParent parentForAccessibility = this.view.getParentForAccessibility();
            accessibilityNodeInfoCompatObtain.setParent(parentForAccessibility instanceof View ? (View) parentForAccessibility : null);
        } else {
            SemanticsNode parent = semanticsNode.getParent();
            Integer numValueOf = parent != null ? Integer.valueOf(parent.getId()) : null;
            if (numValueOf == null) {
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("semanticsNode " + virtualViewId + " has null parent");
                throw new KotlinNothingValueException();
            }
            int iIntValue = numValueOf.intValue();
            accessibilityNodeInfoCompatObtain.setParent(this.view, iIntValue != this.view.getSemanticsOwner().getUnmergedRootSemanticsNode().getId() ? iIntValue : -1);
        }
        accessibilityNodeInfoCompatObtain.setSource(this.view, virtualViewId);
        accessibilityNodeInfoCompatObtain.setBoundsInScreen(boundsInScreen(semanticsNodeWithAdjustedBounds));
        populateAccessibilityNodeInfoProperties(virtualViewId, accessibilityNodeInfoCompatObtain, semanticsNode);
        return accessibilityNodeInfoCompatObtain;
    }

    public final Rect boundsInScreen(SemanticsNodeWithAdjustedBounds node) {
        Rect adjustedBounds = node.getAdjustedBounds();
        long jMo5929localToScreenMKHz9U = this.view.mo5929localToScreenMKHz9U(OffsetKt.Offset(adjustedBounds.left, adjustedBounds.top));
        long jMo5929localToScreenMKHz9U2 = this.view.mo5929localToScreenMKHz9U(OffsetKt.Offset(adjustedBounds.right, adjustedBounds.bottom));
        return new Rect((int) Math.floor(Offset.m4346getXimpl(jMo5929localToScreenMKHz9U)), (int) Math.floor(Offset.m4347getYimpl(jMo5929localToScreenMKHz9U)), (int) Math.ceil(Offset.m4346getXimpl(jMo5929localToScreenMKHz9U2)), (int) Math.ceil(Offset.m4347getYimpl(jMo5929localToScreenMKHz9U2)));
    }

    @Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\bÂ\u0002\u0018\u000026\u0012\u0016\u0012\u0014\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u00020\u0001j\u001a\u0012\u0016\u0012\u0014\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u0002`\u0006B\u0007\b\u0002¢\u0006\u0002\u0010\u0007J<\u0010\b\u001a\u00020\t2\u0018\u0010\n\u001a\u0014\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u00022\u0018\u0010\u000b\u001a\u0014\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u0002H\u0016¨\u0006\f"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$TopBottomBoundsComparator;", "Ljava/util/Comparator;", "Lkotlin/Pair;", "Landroidx/compose/ui/geometry/Rect;", "", "Landroidx/compose/ui/semantics/SemanticsNode;", "Lkotlin/Comparator;", "()V", "compare", "", "a", "b", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class TopBottomBoundsComparator implements Comparator<Pair<? extends androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>>> {
        public static final TopBottomBoundsComparator INSTANCE = new TopBottomBoundsComparator();

        private TopBottomBoundsComparator() {
        }

        @Override
        public int compare(Pair<? extends androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>> pair, Pair<? extends androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>> pair2) {
            return compare2((Pair<androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>>) pair, (Pair<androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>>) pair2);
        }

        public int compare2(Pair<androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>> a2, Pair<androidx.compose.p002ui.geometry.Rect, ? extends List<SemanticsNode>> b) {
            int iCompare = Float.compare(((androidx.compose.p002ui.geometry.Rect) a2.getFirst()).getTop(), ((androidx.compose.p002ui.geometry.Rect) b.getFirst()).getTop());
            return iCompare != 0 ? iCompare : Float.compare(((androidx.compose.p002ui.geometry.Rect) a2.getFirst()).getBottom(), ((androidx.compose.p002ui.geometry.Rect) b.getFirst()).getBottom());
        }
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\bÂ\u0002\u0018\u00002\u0012\u0012\u0004\u0012\u00020\u00020\u0001j\b\u0012\u0004\u0012\u00020\u0002`\u0003B\u0007\b\u0002¢\u0006\u0002\u0010\u0004J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0002H\u0016¨\u0006\t"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$LtrBoundsComparator;", "Ljava/util/Comparator;", "Landroidx/compose/ui/semantics/SemanticsNode;", "Lkotlin/Comparator;", "()V", "compare", "", "a", "b", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class LtrBoundsComparator implements Comparator<SemanticsNode> {
        public static final LtrBoundsComparator INSTANCE = new LtrBoundsComparator();

        private LtrBoundsComparator() {
        }

        @Override
        public int compare(SemanticsNode a2, SemanticsNode b) {
            androidx.compose.p002ui.geometry.Rect boundsInWindow = a2.getBoundsInWindow();
            androidx.compose.p002ui.geometry.Rect boundsInWindow2 = b.getBoundsInWindow();
            int iCompare = Float.compare(boundsInWindow.getLeft(), boundsInWindow2.getLeft());
            if (iCompare != 0) {
                return iCompare;
            }
            int iCompare2 = Float.compare(boundsInWindow.getTop(), boundsInWindow2.getTop());
            if (iCompare2 != 0) {
                return iCompare2;
            }
            int iCompare3 = Float.compare(boundsInWindow.getBottom(), boundsInWindow2.getBottom());
            return iCompare3 != 0 ? iCompare3 : Float.compare(boundsInWindow.getRight(), boundsInWindow2.getRight());
        }
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\bÂ\u0002\u0018\u00002\u0012\u0012\u0004\u0012\u00020\u00020\u0001j\b\u0012\u0004\u0012\u00020\u0002`\u0003B\u0007\b\u0002¢\u0006\u0002\u0010\u0004J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0002H\u0016¨\u0006\t"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$RtlBoundsComparator;", "Ljava/util/Comparator;", "Landroidx/compose/ui/semantics/SemanticsNode;", "Lkotlin/Comparator;", "()V", "compare", "", "a", "b", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class RtlBoundsComparator implements Comparator<SemanticsNode> {
        public static final RtlBoundsComparator INSTANCE = new RtlBoundsComparator();

        private RtlBoundsComparator() {
        }

        @Override
        public int compare(SemanticsNode a2, SemanticsNode b) {
            androidx.compose.p002ui.geometry.Rect boundsInWindow = a2.getBoundsInWindow();
            androidx.compose.p002ui.geometry.Rect boundsInWindow2 = b.getBoundsInWindow();
            int iCompare = Float.compare(boundsInWindow2.getRight(), boundsInWindow.getRight());
            if (iCompare != 0) {
                return iCompare;
            }
            int iCompare2 = Float.compare(boundsInWindow.getTop(), boundsInWindow2.getTop());
            if (iCompare2 != 0) {
                return iCompare2;
            }
            int iCompare3 = Float.compare(boundsInWindow.getBottom(), boundsInWindow2.getBottom());
            return iCompare3 != 0 ? iCompare3 : Float.compare(boundsInWindow2.getLeft(), boundsInWindow.getLeft());
        }
    }

    private final Comparator<SemanticsNode> semanticComparator(boolean layoutIsRtl) {
        return new C1710xaf6f85ce(new C1709xaf6f85cd(layoutIsRtl ? RtlBoundsComparator.INSTANCE : LtrBoundsComparator.INSTANCE, LayoutNode.INSTANCE.getZComparator$ui_release()));
    }

    static List sortByGeometryGroupings$default(AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat, boolean z, ArrayList arrayList, MutableIntObjectMap mutableIntObjectMap, int i, Object obj) {
        if ((i & 4) != 0) {
            mutableIntObjectMap = IntObjectMapKt.mutableIntObjectMapOf();
        }
        return androidComposeViewAccessibilityDelegateCompat.sortByGeometryGroupings(z, arrayList, mutableIntObjectMap);
    }

    private final List<SemanticsNode> sortByGeometryGroupings(boolean layoutIsRtl, ArrayList<SemanticsNode> parentListToSort, MutableIntObjectMap<List<SemanticsNode>> containerChildrenMapping) {
        ArrayList arrayList = new ArrayList();
        int lastIndex = CollectionsKt.getLastIndex(parentListToSort);
        int size = 0;
        if (lastIndex >= 0) {
            int i = 0;
            while (true) {
                SemanticsNode semanticsNode = parentListToSort.get(i);
                if (i == 0 || !sortByGeometryGroupings$placedEntryRowOverlaps(arrayList, semanticsNode)) {
                    arrayList.add(new Pair(semanticsNode.getBoundsInWindow(), CollectionsKt.mutableListOf(new SemanticsNode[]{semanticsNode})));
                }
                if (i == lastIndex) {
                    break;
                }
                i++;
            }
        }
        ArrayList arrayList2 = arrayList;
        CollectionsKt.sortWith(arrayList2, TopBottomBoundsComparator.INSTANCE);
        ArrayList arrayList3 = new ArrayList();
        int size2 = arrayList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            Pair pair = (Pair) arrayList2.get(i2);
            CollectionsKt.sortWith((List) pair.getSecond(), new C1710xaf6f85ce(new C1709xaf6f85cd(layoutIsRtl ? RtlBoundsComparator.INSTANCE : LtrBoundsComparator.INSTANCE, LayoutNode.INSTANCE.getZComparator$ui_release())));
            arrayList3.addAll((Collection) pair.getSecond());
        }
        ArrayList arrayList4 = arrayList3;
        final C17132 c17132 = new Function2<SemanticsNode, SemanticsNode, Integer>() {
            public final Integer invoke(SemanticsNode semanticsNode2, SemanticsNode semanticsNode3) {
                return Integer.valueOf(Float.compare(((Number) semanticsNode2.getUnmergedConfig().getOrElse(SemanticsProperties.INSTANCE.getTraversalIndex(), new Function0<Float>() {
                    public final Float m6478invoke() {
                        return Float.valueOf(0.0f);
                    }
                })).floatValue(), ((Number) semanticsNode3.getUnmergedConfig().getOrElse(SemanticsProperties.INSTANCE.getTraversalIndex(), new Function0<Float>() {
                    public final Float m6479invoke() {
                        return Float.valueOf(0.0f);
                    }
                })).floatValue()));
            }
        };
        CollectionsKt.sortWith(arrayList4, new Comparator() {
            @Override
            public final int compare(Object obj, Object obj2) {
                return AndroidComposeViewAccessibilityDelegateCompat.sortByGeometryGroupings$lambda$7(c17132, obj, obj2);
            }
        });
        while (size <= CollectionsKt.getLastIndex(arrayList4)) {
            List<SemanticsNode> list = containerChildrenMapping.get(((SemanticsNode) arrayList3.get(size)).getId());
            if (list != null) {
                if (isScreenReaderFocusable((SemanticsNode) arrayList3.get(size))) {
                    size++;
                } else {
                    arrayList3.remove(size);
                }
                arrayList3.addAll(size, list);
                size += list.size();
            } else {
                size++;
            }
        }
        return arrayList4;
    }

    private static final boolean sortByGeometryGroupings$placedEntryRowOverlaps(ArrayList<Pair<androidx.compose.p002ui.geometry.Rect, List<SemanticsNode>>> arrayList, SemanticsNode semanticsNode) {
        float top = semanticsNode.getBoundsInWindow().getTop();
        float bottom = semanticsNode.getBoundsInWindow().getBottom();
        boolean z = top >= bottom;
        int lastIndex = CollectionsKt.getLastIndex(arrayList);
        if (lastIndex >= 0) {
            int i = 0;
            while (true) {
                androidx.compose.p002ui.geometry.Rect rect = (androidx.compose.p002ui.geometry.Rect) arrayList.get(i).getFirst();
                boolean z2 = rect.getTop() >= rect.getBottom();
                if (!z && !z2 && Math.max(top, rect.getTop()) < Math.min(bottom, rect.getBottom())) {
                    arrayList.set(i, new Pair<>(rect.intersect(0.0f, top, Float.POSITIVE_INFINITY, bottom), arrayList.get(i).getSecond()));
                    ((List) arrayList.get(i).getSecond()).add(semanticsNode);
                    return true;
                }
                if (i != lastIndex) {
                    i++;
                }
            }
        }
        return false;
    }

    public static final int sortByGeometryGroupings$lambda$7(Function2 function2, Object obj, Object obj2) {
        return ((Number) function2.invoke(obj, obj2)).intValue();
    }

    private final void geometryDepthFirstSearch(SemanticsNode currNode, ArrayList<SemanticsNode> geometryList, MutableIntObjectMap<List<SemanticsNode>> containerMapToChildren) {
        boolean zIsRtl = AndroidComposeViewAccessibilityDelegateCompat_androidKt.isRtl(currNode);
        boolean zBooleanValue = ((Boolean) currNode.getUnmergedConfig().getOrElse(SemanticsProperties.INSTANCE.getIsTraversalGroup(), new Function0<Boolean>() {
            public final Boolean m6476invoke() {
                return false;
            }
        })).booleanValue();
        if ((zBooleanValue || isScreenReaderFocusable(currNode)) && getCurrentSemanticsNodes().containsKey(currNode.getId())) {
            geometryList.add(currNode);
        }
        if (zBooleanValue) {
            containerMapToChildren.set(currNode.getId(), subtreeSortedByGeometryGrouping(zIsRtl, CollectionsKt.toMutableList(currNode.getChildren())));
            return;
        }
        List<SemanticsNode> children = currNode.getChildren();
        int size = children.size();
        for (int i = 0; i < size; i++) {
            geometryDepthFirstSearch(children.get(i), geometryList, containerMapToChildren);
        }
    }

    private final List<SemanticsNode> subtreeSortedByGeometryGrouping(boolean layoutIsRtl, List<SemanticsNode> listToSort) {
        MutableIntObjectMap<List<SemanticsNode>> mutableIntObjectMapMutableIntObjectMapOf = IntObjectMapKt.mutableIntObjectMapOf();
        ArrayList<SemanticsNode> arrayList = new ArrayList<>();
        int size = listToSort.size();
        for (int i = 0; i < size; i++) {
            geometryDepthFirstSearch(listToSort.get(i), arrayList, mutableIntObjectMapMutableIntObjectMapOf);
        }
        return sortByGeometryGroupings(layoutIsRtl, arrayList, mutableIntObjectMapMutableIntObjectMapOf);
    }

    private final void setTraversalValues() {
        this.idToBeforeMap.clear();
        this.idToAfterMap.clear();
        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = getCurrentSemanticsNodes().get(-1);
        SemanticsNode semanticsNode = semanticsNodeWithAdjustedBounds != null ? semanticsNodeWithAdjustedBounds.getSemanticsNode() : null;
        Intrinsics.checkNotNull(semanticsNode);
        int i = 1;
        List<SemanticsNode> listSubtreeSortedByGeometryGrouping = subtreeSortedByGeometryGrouping(AndroidComposeViewAccessibilityDelegateCompat_androidKt.isRtl(semanticsNode), CollectionsKt.mutableListOf(new SemanticsNode[]{semanticsNode}));
        int lastIndex = CollectionsKt.getLastIndex(listSubtreeSortedByGeometryGrouping);
        if (1 > lastIndex) {
            return;
        }
        while (true) {
            int id = listSubtreeSortedByGeometryGrouping.get(i - 1).getId();
            int id2 = listSubtreeSortedByGeometryGrouping.get(i).getId();
            this.idToBeforeMap.set(id, id2);
            this.idToAfterMap.set(id2, id);
            if (i == lastIndex) {
                return;
            } else {
                i++;
            }
        }
    }

    private final boolean isScreenReaderFocusable(SemanticsNode node) {
        List list = (List) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getContentDescription());
        return node.getUnmergedConfig().getIsMergingSemanticsOfDescendants() || (node.isUnmergedLeafNode$ui_release() && ((list != null ? (String) CollectionsKt.firstOrNull(list) : null) != null || getInfoText(node) != null || getInfoStateDescriptionOrNull(node) != null || getInfoIsCheckable(node)));
    }

    private final void populateAccessibilityNodeInfoProperties(int virtualViewId, AccessibilityNodeInfoCompat info, SemanticsNode semanticsNode) {
        View viewSemanticsIdToView;
        AccessibilityNodeInfoCompat.AccessibilityActionCompat accessibilityActionCompat;
        AccessibilityNodeInfoCompat.AccessibilityActionCompat accessibilityActionCompat2;
        boolean z;
        boolean zBooleanValue;
        info.setClassName(ClassName);
        if (semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getEditableText())) {
            info.setClassName(TextFieldClassName);
        }
        if (semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getText())) {
            info.setClassName(TextClassName);
        }
        Role role = (Role) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getRole());
        if (role != null) {
            role.getValue();
            if (semanticsNode.getIsFake() || semanticsNode.getReplacedChildren$ui_release().isEmpty()) {
                if (Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c())) {
                    info.setRoleDescription(this.view.getContext().getResources().getString(C1597R.string.tab));
                } else if (Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6616getSwitcho7Vup1c())) {
                    info.setRoleDescription(this.view.getContext().getResources().getString(C1597R.string.switch_role));
                } else {
                    String strM6574toLegacyClassNameV4PA4sw = SemanticsUtils_androidKt.m6574toLegacyClassNameV4PA4sw(role.getValue());
                    if (!Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6614getImageo7Vup1c()) || semanticsNode.isUnmergedLeafNode$ui_release() || semanticsNode.getUnmergedConfig().getIsMergingSemanticsOfDescendants()) {
                        info.setClassName(strM6574toLegacyClassNameV4PA4sw);
                    }
                }
            }
            Unit unit = Unit.INSTANCE;
            Unit unit2 = Unit.INSTANCE;
        }
        info.setPackageName(this.view.getContext().getPackageName());
        info.setImportantForAccessibility(SemanticsUtils_androidKt.isImportantForAccessibility(semanticsNode));
        List<SemanticsNode> replacedChildren$ui_release = semanticsNode.getReplacedChildren$ui_release();
        int size = replacedChildren$ui_release.size();
        for (int i = 0; i < size; i++) {
            SemanticsNode semanticsNode2 = replacedChildren$ui_release.get(i);
            if (getCurrentSemanticsNodes().contains(semanticsNode2.getId())) {
                View view = (AndroidViewHolder) this.view.getAndroidViewsHandler$ui_release().getLayoutNodeToHolder().get(semanticsNode2.getLayoutNode());
                if (semanticsNode2.getId() != -1) {
                    if (view != null) {
                        info.addChild(view);
                    } else {
                        info.addChild(this.view, semanticsNode2.getId());
                    }
                }
            }
        }
        if (virtualViewId == this.focusedVirtualViewId) {
            info.setAccessibilityFocused(true);
            info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_CLEAR_ACCESSIBILITY_FOCUS);
        } else {
            info.setAccessibilityFocused(false);
            info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_ACCESSIBILITY_FOCUS);
        }
        setText(semanticsNode, info);
        setContentInvalid(semanticsNode, info);
        setStateDescription(semanticsNode, info);
        setIsCheckable(semanticsNode, info);
        ToggleableState toggleableState = (ToggleableState) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getToggleableState());
        if (toggleableState != null) {
            if (toggleableState == ToggleableState.On) {
                info.setChecked(true);
            } else if (toggleableState == ToggleableState.Off) {
                info.setChecked(false);
            }
            Unit unit3 = Unit.INSTANCE;
            Unit unit4 = Unit.INSTANCE;
        }
        Boolean bool = (Boolean) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getSelected());
        if (bool != null) {
            boolean zBooleanValue2 = bool.booleanValue();
            if (role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c())) {
                info.setSelected(zBooleanValue2);
            } else {
                info.setChecked(zBooleanValue2);
            }
            Unit unit5 = Unit.INSTANCE;
            Unit unit6 = Unit.INSTANCE;
        }
        if (!semanticsNode.getUnmergedConfig().getIsMergingSemanticsOfDescendants() || semanticsNode.getReplacedChildren$ui_release().isEmpty()) {
            List list = (List) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getContentDescription());
            info.setContentDescription(list != null ? (String) CollectionsKt.firstOrNull(list) : null);
        }
        String str = (String) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getTestTag());
        if (str != null) {
            SemanticsNode parent = semanticsNode;
            while (true) {
                if (parent == null) {
                    zBooleanValue = false;
                    break;
                } else {
                    if (parent.getUnmergedConfig().contains(SemanticsPropertiesAndroid.INSTANCE.getTestTagsAsResourceId())) {
                        zBooleanValue = ((Boolean) parent.getUnmergedConfig().get(SemanticsPropertiesAndroid.INSTANCE.getTestTagsAsResourceId())).booleanValue();
                        break;
                    }
                    parent = parent.getParent();
                }
            }
            if (zBooleanValue) {
                info.setViewIdResourceName(str);
            }
        }
        if (((Unit) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getHeading())) != null) {
            info.setHeading(true);
            Unit unit7 = Unit.INSTANCE;
            Unit unit8 = Unit.INSTANCE;
        }
        info.setPassword(semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPassword()));
        info.setEditable(semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getIsEditable()));
        Integer num = (Integer) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getMaxTextLength());
        info.setMaxTextLength(num != null ? num.intValue() : -1);
        info.setEnabled(AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode));
        info.setFocusable(semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getFocused()));
        if (info.isFocusable()) {
            info.setFocused(((Boolean) semanticsNode.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getFocused())).booleanValue());
            if (info.isFocused()) {
                info.addAction(2);
            } else {
                info.addAction(1);
            }
        }
        info.setVisibleToUser(AndroidComposeViewAccessibilityDelegateCompat_androidKt.isVisible(semanticsNode));
        LiveRegionMode liveRegionMode = (LiveRegionMode) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getLiveRegion());
        if (liveRegionMode != null) {
            int value = liveRegionMode.getValue();
            info.setLiveRegion((LiveRegionMode.m6598equalsimpl0(value, LiveRegionMode.INSTANCE.m6603getPolite0phEisY()) || !LiveRegionMode.m6598equalsimpl0(value, LiveRegionMode.INSTANCE.m6602getAssertive0phEisY())) ? 1 : 2);
            Unit unit9 = Unit.INSTANCE;
            Unit unit10 = Unit.INSTANCE;
        }
        info.setClickable(false);
        AccessibilityAction accessibilityAction = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getOnClick());
        if (accessibilityAction != null) {
            boolean zAreEqual = Intrinsics.areEqual(SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getSelected()), true);
            if (role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c())) {
                z = true;
            } else if (role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6615getRadioButtono7Vup1c())) {
                z = true;
            } else {
                z = false;
            }
            info.setClickable(!z || (z && !zAreEqual));
            if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode) && info.isClickable()) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(16, accessibilityAction.getLabel()));
            }
            Unit unit11 = Unit.INSTANCE;
            Unit unit12 = Unit.INSTANCE;
        }
        info.setLongClickable(false);
        AccessibilityAction accessibilityAction2 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getOnLongClick());
        if (accessibilityAction2 != null) {
            info.setLongClickable(true);
            if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(32, accessibilityAction2.getLabel()));
            }
            Unit unit13 = Unit.INSTANCE;
            Unit unit14 = Unit.INSTANCE;
        }
        AccessibilityAction accessibilityAction3 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getCopyText());
        if (accessibilityAction3 != null) {
            info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(Fields.Clip, accessibilityAction3.getLabel()));
            Unit unit15 = Unit.INSTANCE;
            Unit unit16 = Unit.INSTANCE;
        }
        if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
            AccessibilityAction accessibilityAction4 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getSetText());
            if (accessibilityAction4 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(2097152, accessibilityAction4.getLabel()));
                Unit unit17 = Unit.INSTANCE;
                Unit unit18 = Unit.INSTANCE;
            }
            AccessibilityAction accessibilityAction5 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getOnImeAction());
            if (accessibilityAction5 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionImeEnter, accessibilityAction5.getLabel()));
                Unit unit19 = Unit.INSTANCE;
                Unit unit20 = Unit.INSTANCE;
            }
            AccessibilityAction accessibilityAction6 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getCutText());
            if (accessibilityAction6 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(65536, accessibilityAction6.getLabel()));
                Unit unit21 = Unit.INSTANCE;
                Unit unit22 = Unit.INSTANCE;
            }
            AccessibilityAction accessibilityAction7 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getPasteText());
            if (accessibilityAction7 != null) {
                if (info.isFocused() && this.view.getClipboardManager().hasText()) {
                    info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(Fields.CompositingStrategy, accessibilityAction7.getLabel()));
                }
                Unit unit23 = Unit.INSTANCE;
                Unit unit24 = Unit.INSTANCE;
            }
        }
        String iterableTextForAccessibility = getIterableTextForAccessibility(semanticsNode);
        if (!(iterableTextForAccessibility == null || iterableTextForAccessibility.length() == 0)) {
            info.setTextSelection(getAccessibilitySelectionStart(semanticsNode), getAccessibilitySelectionEnd(semanticsNode));
            AccessibilityAction accessibilityAction8 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getSetSelection());
            info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(Fields.RenderEffect, accessibilityAction8 != null ? accessibilityAction8.getLabel() : null));
            info.addAction(Fields.RotationX);
            info.addAction(Fields.RotationY);
            info.setMovementGranularities(11);
            List list2 = (List) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getContentDescription());
            if ((list2 == null || list2.isEmpty()) && semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getGetTextLayoutResult()) && !AndroidComposeViewAccessibilityDelegateCompat_androidKt.excludeLineAndPageGranularities(semanticsNode)) {
                info.setMovementGranularities(info.getMovementGranularities() | 20);
            }
        }
        if (Build.VERSION.SDK_INT >= 26) {
            ArrayList arrayList = new ArrayList();
            arrayList.add(ExtraDataIdKey);
            CharSequence text = info.getText();
            if (!(text == null || text.length() == 0) && semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getGetTextLayoutResult())) {
                arrayList.add("android.view.accessibility.extra.DATA_TEXT_CHARACTER_LOCATION_KEY");
            }
            if (semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getTestTag())) {
                arrayList.add(ExtraDataTestTagKey);
            }
            info.setAvailableExtraData(arrayList);
        }
        ProgressBarRangeInfo progressBarRangeInfo = (ProgressBarRangeInfo) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getProgressBarRangeInfo());
        if (progressBarRangeInfo != null) {
            if (semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getSetProgress())) {
                info.setClassName("android.widget.SeekBar");
            } else {
                info.setClassName("android.widget.ProgressBar");
            }
            if (progressBarRangeInfo != ProgressBarRangeInfo.INSTANCE.getIndeterminate()) {
                info.setRangeInfo(AccessibilityNodeInfoCompat.RangeInfoCompat.obtain(1, ((Number) progressBarRangeInfo.getRange().getStart()).floatValue(), ((Number) progressBarRangeInfo.getRange().getEndInclusive()).floatValue(), progressBarRangeInfo.getCurrent()));
            }
            if (semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getSetProgress()) && AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
                if (progressBarRangeInfo.getCurrent() < RangesKt.coerceAtLeast(((Number) progressBarRangeInfo.getRange().getEndInclusive()).floatValue(), ((Number) progressBarRangeInfo.getRange().getStart()).floatValue())) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_FORWARD);
                }
                if (progressBarRangeInfo.getCurrent() > RangesKt.coerceAtMost(((Number) progressBarRangeInfo.getRange().getStart()).floatValue(), ((Number) progressBarRangeInfo.getRange().getEndInclusive()).floatValue())) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_BACKWARD);
                }
            }
        }
        if (Build.VERSION.SDK_INT >= 24) {
            Api24Impl.addSetProgressAction(info, semanticsNode);
        }
        CollectionInfo_androidKt.setCollectionInfo(semanticsNode, info);
        CollectionInfo_androidKt.setCollectionItemInfo(semanticsNode, info);
        ScrollAxisRange scrollAxisRange = (ScrollAxisRange) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getHorizontalScrollAxisRange());
        AccessibilityAction accessibilityAction9 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getScrollBy());
        if (scrollAxisRange != null && accessibilityAction9 != null) {
            if (!CollectionInfo_androidKt.hasCollectionInfo(semanticsNode)) {
                info.setClassName("android.widget.HorizontalScrollView");
            }
            if (((Number) scrollAxisRange.getMaxValue().invoke()).floatValue() > 0.0f) {
                info.setScrollable(true);
            }
            if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
                if (populateAccessibilityNodeInfoProperties$canScrollForward(scrollAxisRange)) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_FORWARD);
                    if (!AndroidComposeViewAccessibilityDelegateCompat_androidKt.isRtl(semanticsNode)) {
                        accessibilityActionCompat2 = AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_RIGHT;
                    } else {
                        accessibilityActionCompat2 = AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_LEFT;
                    }
                    info.addAction(accessibilityActionCompat2);
                }
                if (populateAccessibilityNodeInfoProperties$canScrollBackward(scrollAxisRange)) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_BACKWARD);
                    if (!AndroidComposeViewAccessibilityDelegateCompat_androidKt.isRtl(semanticsNode)) {
                        accessibilityActionCompat = AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_LEFT;
                    } else {
                        accessibilityActionCompat = AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_RIGHT;
                    }
                    info.addAction(accessibilityActionCompat);
                }
            }
        }
        ScrollAxisRange scrollAxisRange2 = (ScrollAxisRange) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getVerticalScrollAxisRange());
        if (scrollAxisRange2 != null && accessibilityAction9 != null) {
            if (!CollectionInfo_androidKt.hasCollectionInfo(semanticsNode)) {
                info.setClassName("android.widget.ScrollView");
            }
            if (((Number) scrollAxisRange2.getMaxValue().invoke()).floatValue() > 0.0f) {
                info.setScrollable(true);
            }
            if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
                if (populateAccessibilityNodeInfoProperties$canScrollForward(scrollAxisRange2)) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_FORWARD);
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_DOWN);
                }
                if (populateAccessibilityNodeInfoProperties$canScrollBackward(scrollAxisRange2)) {
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_BACKWARD);
                    info.addAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_SCROLL_UP);
                }
            }
        }
        if (Build.VERSION.SDK_INT >= 29) {
            Api29Impl.addPageActions(info, semanticsNode);
        }
        info.setPaneTitle((CharSequence) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getPaneTitle()));
        if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
            AccessibilityAction accessibilityAction10 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getExpand());
            if (accessibilityAction10 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(262144, accessibilityAction10.getLabel()));
                Unit unit25 = Unit.INSTANCE;
                Unit unit26 = Unit.INSTANCE;
            }
            AccessibilityAction accessibilityAction11 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getCollapse());
            if (accessibilityAction11 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(524288, accessibilityAction11.getLabel()));
                Unit unit27 = Unit.INSTANCE;
                Unit unit28 = Unit.INSTANCE;
            }
            AccessibilityAction accessibilityAction12 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getDismiss());
            if (accessibilityAction12 != null) {
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(1048576, accessibilityAction12.getLabel()));
                Unit unit29 = Unit.INSTANCE;
                Unit unit30 = Unit.INSTANCE;
            }
            if (semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getCustomActions())) {
                List list3 = (List) semanticsNode.getUnmergedConfig().get(SemanticsActions.INSTANCE.getCustomActions());
                int size2 = list3.size();
                IntList intList = AccessibilityActionsResourceIds;
                if (size2 >= intList.getSize()) {
                    throw new IllegalStateException("Can't have more than " + intList.getSize() + " custom actions for one widget");
                }
                SparseArrayCompat<CharSequence> sparseArrayCompat = new SparseArrayCompat<>(0, 1, null);
                MutableObjectIntMap<CharSequence> mutableObjectIntMapMutableObjectIntMapOf = ObjectIntMapKt.mutableObjectIntMapOf();
                if (this.labelToActionId.containsKey(virtualViewId)) {
                    MutableObjectIntMap<CharSequence> mutableObjectIntMap = this.labelToActionId.get(virtualViewId);
                    MutableIntList mutableIntList = new MutableIntList(0, 1, null);
                    int[] iArr = intList.content;
                    int i2 = intList._size;
                    for (int i3 = 0; i3 < i2; i3++) {
                        mutableIntList.add(iArr[i3]);
                    }
                    ArrayList arrayList2 = new ArrayList();
                    int size3 = list3.size();
                    for (int i4 = 0; i4 < size3; i4++) {
                        CustomAccessibilityAction customAccessibilityAction = (CustomAccessibilityAction) list3.get(i4);
                        Intrinsics.checkNotNull(mutableObjectIntMap);
                        if (mutableObjectIntMap.contains(customAccessibilityAction.getLabel())) {
                            int i5 = mutableObjectIntMap.get(customAccessibilityAction.getLabel());
                            sparseArrayCompat.put(i5, customAccessibilityAction.getLabel());
                            mutableObjectIntMapMutableObjectIntMapOf.set(customAccessibilityAction.getLabel(), i5);
                            mutableIntList.remove(i5);
                            info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(i5, customAccessibilityAction.getLabel()));
                        } else {
                            arrayList2.add(customAccessibilityAction);
                        }
                    }
                    int size4 = arrayList2.size();
                    for (int i6 = 0; i6 < size4; i6++) {
                        CustomAccessibilityAction customAccessibilityAction2 = (CustomAccessibilityAction) arrayList2.get(i6);
                        int i7 = mutableIntList.get(i6);
                        sparseArrayCompat.put(i7, customAccessibilityAction2.getLabel());
                        mutableObjectIntMapMutableObjectIntMapOf.set(customAccessibilityAction2.getLabel(), i7);
                        info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(i7, customAccessibilityAction2.getLabel()));
                    }
                } else {
                    int size5 = list3.size();
                    for (int i8 = 0; i8 < size5; i8++) {
                        CustomAccessibilityAction customAccessibilityAction3 = (CustomAccessibilityAction) list3.get(i8);
                        int i9 = AccessibilityActionsResourceIds.get(i8);
                        sparseArrayCompat.put(i9, customAccessibilityAction3.getLabel());
                        mutableObjectIntMapMutableObjectIntMapOf.set(customAccessibilityAction3.getLabel(), i9);
                        info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(i9, customAccessibilityAction3.getLabel()));
                    }
                }
                this.actionIdToLabel.put(virtualViewId, sparseArrayCompat);
                this.labelToActionId.put(virtualViewId, mutableObjectIntMapMutableObjectIntMapOf);
            }
        }
        info.setScreenReaderFocusable(isScreenReaderFocusable(semanticsNode));
        int orDefault = this.idToBeforeMap.getOrDefault(virtualViewId, -1);
        if (orDefault != -1) {
            View viewSemanticsIdToView2 = SemanticsUtils_androidKt.semanticsIdToView(this.view.getAndroidViewsHandler$ui_release(), orDefault);
            if (viewSemanticsIdToView2 != null) {
                info.setTraversalBefore(viewSemanticsIdToView2);
            } else {
                info.setTraversalBefore(this.view, orDefault);
            }
            addExtraDataToAccessibilityNodeInfoHelper(virtualViewId, info, this.ExtraDataTestTraversalBeforeVal, null);
        }
        int orDefault2 = this.idToAfterMap.getOrDefault(virtualViewId, -1);
        if (orDefault2 == -1 || (viewSemanticsIdToView = SemanticsUtils_androidKt.semanticsIdToView(this.view.getAndroidViewsHandler$ui_release(), orDefault2)) == null) {
            return;
        }
        info.setTraversalAfter(viewSemanticsIdToView);
        addExtraDataToAccessibilityNodeInfoHelper(virtualViewId, info, this.ExtraDataTestTraversalAfterVal, null);
    }

    private static final boolean populateAccessibilityNodeInfoProperties$canScrollForward(ScrollAxisRange scrollAxisRange) {
        return (((Number) scrollAxisRange.getValue().invoke()).floatValue() < ((Number) scrollAxisRange.getMaxValue().invoke()).floatValue() && !scrollAxisRange.getReverseScrolling()) || (((Number) scrollAxisRange.getValue().invoke()).floatValue() > 0.0f && scrollAxisRange.getReverseScrolling());
    }

    private static final boolean populateAccessibilityNodeInfoProperties$canScrollBackward(ScrollAxisRange scrollAxisRange) {
        return (((Number) scrollAxisRange.getValue().invoke()).floatValue() > 0.0f && !scrollAxisRange.getReverseScrolling()) || (((Number) scrollAxisRange.getValue().invoke()).floatValue() < ((Number) scrollAxisRange.getMaxValue().invoke()).floatValue() && scrollAxisRange.getReverseScrolling());
    }

    private final void setContentInvalid(SemanticsNode node, AccessibilityNodeInfoCompat info) {
        if (node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getError())) {
            info.setContentInvalid(true);
            info.setError((CharSequence) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getError()));
        }
    }

    private final String getInfoStateDescriptionOrNull(SemanticsNode node) {
        int iCoerceIn;
        Object orNull = SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getStateDescription());
        ToggleableState toggleableState = (ToggleableState) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getToggleableState());
        Role role = (Role) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getRole());
        if (toggleableState != null) {
            int i = WhenMappings.$EnumSwitchMapping$0[toggleableState.ordinal()];
            if (i == 1) {
                if ((role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6616getSwitcho7Vup1c())) && orNull == null) {
                    orNull = this.view.getContext().getResources().getString(C1597R.string.state_on);
                }
            } else if (i == 2) {
                if ((role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6616getSwitcho7Vup1c())) && orNull == null) {
                    orNull = this.view.getContext().getResources().getString(C1597R.string.state_off);
                }
            } else if (i == 3 && orNull == null) {
                orNull = this.view.getContext().getResources().getString(C1597R.string.indeterminate);
            }
        }
        Boolean bool = (Boolean) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getSelected());
        if (bool != null) {
            boolean zBooleanValue = bool.booleanValue();
            if (!(role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c())) && orNull == null) {
                if (zBooleanValue) {
                    orNull = this.view.getContext().getResources().getString(C1597R.string.selected);
                } else {
                    orNull = this.view.getContext().getResources().getString(C1597R.string.not_selected);
                }
            }
        }
        ProgressBarRangeInfo progressBarRangeInfo = (ProgressBarRangeInfo) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getProgressBarRangeInfo());
        if (progressBarRangeInfo != null) {
            if (progressBarRangeInfo != ProgressBarRangeInfo.INSTANCE.getIndeterminate()) {
                if (orNull == null) {
                    ClosedFloatingPointRange<Float> range = progressBarRangeInfo.getRange();
                    float current = ((((Number) range.getEndInclusive()).floatValue() - ((Number) range.getStart()).floatValue()) > 0.0f ? 1 : ((((Number) range.getEndInclusive()).floatValue() - ((Number) range.getStart()).floatValue()) == 0.0f ? 0 : -1)) == 0 ? 0.0f : (progressBarRangeInfo.getCurrent() - ((Number) range.getStart()).floatValue()) / (((Number) range.getEndInclusive()).floatValue() - ((Number) range.getStart()).floatValue());
                    if (current < 0.0f) {
                        current = 0.0f;
                    }
                    if (current > 1.0f) {
                        current = 1.0f;
                    }
                    if (current == 0.0f) {
                        iCoerceIn = 0;
                    } else {
                        iCoerceIn = 100;
                        if (!(current == 1.0f)) {
                            iCoerceIn = RangesKt.coerceIn(Math.round(current * 100), 1, 99);
                        }
                    }
                    orNull = this.view.getContext().getResources().getString(C1597R.string.template_percent, Integer.valueOf(iCoerceIn));
                }
            } else if (orNull == null) {
                orNull = this.view.getContext().getResources().getString(C1597R.string.in_progress);
            }
        }
        if (node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getEditableText())) {
            orNull = createStateDescriptionForTextField(node);
        }
        return (String) orNull;
    }

    private final String createStateDescriptionForTextField(SemanticsNode node) {
        Collection collection;
        CharSequence charSequence;
        SemanticsConfiguration config = node.copyWithMergingEnabled$ui_release().getConfig();
        Collection collection2 = (Collection) SemanticsConfigurationKt.getOrNull(config, SemanticsProperties.INSTANCE.getContentDescription());
        if ((collection2 == null || collection2.isEmpty()) && (((collection = (Collection) SemanticsConfigurationKt.getOrNull(config, SemanticsProperties.INSTANCE.getText())) == null || collection.isEmpty()) && ((charSequence = (CharSequence) SemanticsConfigurationKt.getOrNull(config, SemanticsProperties.INSTANCE.getEditableText())) == null || charSequence.length() == 0))) {
            return this.view.getContext().getResources().getString(C1597R.string.state_empty);
        }
        return null;
    }

    private final void setStateDescription(SemanticsNode node, AccessibilityNodeInfoCompat info) {
        info.setStateDescription(getInfoStateDescriptionOrNull(node));
    }

    private final boolean getInfoIsCheckable(SemanticsNode node) {
        ToggleableState toggleableState = (ToggleableState) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getToggleableState());
        Role role = (Role) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getRole());
        boolean z = toggleableState != null;
        Boolean bool = (Boolean) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getSelected());
        if (bool == null) {
            return z;
        }
        bool.booleanValue();
        return role != null ? Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c()) : false ? z : true;
    }

    private final void setIsCheckable(SemanticsNode node, AccessibilityNodeInfoCompat info) {
        info.setCheckable(getInfoIsCheckable(node));
    }

    private final AnnotatedString getInfoText(SemanticsNode node) {
        AnnotatedString textForTextField = getTextForTextField(node.getUnmergedConfig());
        List list = (List) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getText());
        return textForTextField == null ? list != null ? (AnnotatedString) CollectionsKt.firstOrNull(list) : null : textForTextField;
    }

    private final SpannableString toSpannableString(AnnotatedString annotatedString) {
        return (SpannableString) trimToSize(AndroidAccessibilitySpannableString_androidKt.toAccessibilitySpannableString(annotatedString, this.view.getDensity(), this.view.getFontFamilyResolver(), this.urlSpanCache), ParcelSafeTextLength);
    }

    private final void setText(SemanticsNode node, AccessibilityNodeInfoCompat info) {
        AnnotatedString infoText = getInfoText(node);
        info.setText(infoText != null ? toSpannableString(infoText) : null);
    }

    private final boolean isAccessibilityFocused(int virtualViewId) {
        return this.focusedVirtualViewId == virtualViewId;
    }

    private final boolean requestAccessibilityFocus(int virtualViewId) {
        if (!isTouchExplorationEnabled() || isAccessibilityFocused(virtualViewId)) {
            return false;
        }
        int i = this.focusedVirtualViewId;
        if (i != Integer.MIN_VALUE) {
            sendEventForVirtualView$default(this, i, 65536, null, null, 12, null);
        }
        this.focusedVirtualViewId = virtualViewId;
        this.view.invalidate();
        sendEventForVirtualView$default(this, virtualViewId, Fields.CompositingStrategy, null, null, 12, null);
        return true;
    }

    static boolean sendEventForVirtualView$default(AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat, int i, int i2, Integer num, List list, int i3, Object obj) {
        if ((i3 & 4) != 0) {
            num = null;
        }
        if ((i3 & 8) != 0) {
            list = null;
        }
        return androidComposeViewAccessibilityDelegateCompat.sendEventForVirtualView(i, i2, num, list);
    }

    private final boolean sendEventForVirtualView(int virtualViewId, int eventType, Integer contentChangeType, List<String> contentDescription) {
        if (virtualViewId == Integer.MIN_VALUE || !isEnabled$ui_release()) {
            return false;
        }
        AccessibilityEvent accessibilityEventCreateEvent = createEvent(virtualViewId, eventType);
        if (contentChangeType != null) {
            accessibilityEventCreateEvent.setContentChangeTypes(contentChangeType.intValue());
        }
        if (contentDescription != null) {
            accessibilityEventCreateEvent.setContentDescription(ListUtilsKt.fastJoinToString$default(contentDescription, ",", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 62, (Object) null));
        }
        Trace.beginSection("sendEvent");
        try {
            return sendEvent(accessibilityEventCreateEvent);
        } finally {
            Trace.endSection();
        }
    }

    private final boolean sendEvent(AccessibilityEvent event) {
        if (!isEnabled$ui_release()) {
            return false;
        }
        if (event.getEventType() == 2048 || event.getEventType() == 32768) {
            this.sendingFocusAffectingEvent = true;
        }
        try {
            return ((Boolean) this.onSendAccessibilityEvent.invoke(event)).booleanValue();
        } finally {
            this.sendingFocusAffectingEvent = false;
        }
    }

    private final AccessibilityEvent createEvent(int virtualViewId, int eventType) {
        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds;
        AccessibilityEvent accessibilityEventObtain = AccessibilityEvent.obtain(eventType);
        accessibilityEventObtain.setEnabled(true);
        accessibilityEventObtain.setClassName(ClassName);
        accessibilityEventObtain.setPackageName(this.view.getContext().getPackageName());
        accessibilityEventObtain.setSource(this.view, virtualViewId);
        if (isEnabled$ui_release() && (semanticsNodeWithAdjustedBounds = getCurrentSemanticsNodes().get(virtualViewId)) != null) {
            accessibilityEventObtain.setPassword(semanticsNodeWithAdjustedBounds.getSemanticsNode().getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPassword()));
        }
        return accessibilityEventObtain;
    }

    private final AccessibilityEvent createTextSelectionChangedEvent(int virtualViewId, Integer fromIndex, Integer toIndex, Integer itemCount, CharSequence text) {
        AccessibilityEvent accessibilityEventCreateEvent = createEvent(virtualViewId, Fields.Shape);
        if (fromIndex != null) {
            accessibilityEventCreateEvent.setFromIndex(fromIndex.intValue());
        }
        if (toIndex != null) {
            accessibilityEventCreateEvent.setToIndex(toIndex.intValue());
        }
        if (itemCount != null) {
            accessibilityEventCreateEvent.setItemCount(itemCount.intValue());
        }
        if (text != null) {
            accessibilityEventCreateEvent.getText().add(text);
        }
        return accessibilityEventCreateEvent;
    }

    private final boolean clearAccessibilityFocus(int virtualViewId) {
        if (!isAccessibilityFocused(virtualViewId)) {
            return false;
        }
        this.focusedVirtualViewId = Integer.MIN_VALUE;
        this.currentlyFocusedANI = null;
        this.view.invalidate();
        sendEventForVirtualView$default(this, virtualViewId, 65536, null, null, 12, null);
        return true;
    }

    public final boolean performActionHelper(int r13, int r14, android.os.Bundle r15) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p002ui.platform.AndroidComposeViewAccessibilityDelegateCompat.performActionHelper(int, int, android.os.Bundle):boolean");
    }

    private static final boolean performActionHelper$canScroll(ScrollAxisRange scrollAxisRange, float f) {
        return (f < 0.0f && ((Number) scrollAxisRange.getValue().invoke()).floatValue() > 0.0f) || (f > 0.0f && ((Number) scrollAxisRange.getValue().invoke()).floatValue() < ((Number) scrollAxisRange.getMaxValue().invoke()).floatValue());
    }

    private static final float performActionHelper$scrollDelta(float f, float f2) {
        if (Math.signum(f) == Math.signum(f2)) {
            return Math.abs(f) < Math.abs(f2) ? f : f2;
        }
        return 0.0f;
    }

    public final void addExtraDataToAccessibilityNodeInfoHelper(int virtualViewId, AccessibilityNodeInfoCompat info, String extraDataKey, Bundle arguments) {
        SemanticsNode semanticsNode;
        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = getCurrentSemanticsNodes().get(virtualViewId);
        if (semanticsNodeWithAdjustedBounds == null || (semanticsNode = semanticsNodeWithAdjustedBounds.getSemanticsNode()) == null) {
            return;
        }
        String iterableTextForAccessibility = getIterableTextForAccessibility(semanticsNode);
        if (Intrinsics.areEqual(extraDataKey, this.ExtraDataTestTraversalBeforeVal)) {
            int orDefault = this.idToBeforeMap.getOrDefault(virtualViewId, -1);
            if (orDefault != -1) {
                info.getExtras().putInt(extraDataKey, orDefault);
                return;
            }
            return;
        }
        if (Intrinsics.areEqual(extraDataKey, this.ExtraDataTestTraversalAfterVal)) {
            int orDefault2 = this.idToAfterMap.getOrDefault(virtualViewId, -1);
            if (orDefault2 != -1) {
                info.getExtras().putInt(extraDataKey, orDefault2);
                return;
            }
            return;
        }
        if (semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getGetTextLayoutResult()) && arguments != null && Intrinsics.areEqual(extraDataKey, "android.view.accessibility.extra.DATA_TEXT_CHARACTER_LOCATION_KEY")) {
            int i = arguments.getInt("android.view.accessibility.extra.DATA_TEXT_CHARACTER_LOCATION_ARG_START_INDEX", -1);
            int i2 = arguments.getInt("android.view.accessibility.extra.DATA_TEXT_CHARACTER_LOCATION_ARG_LENGTH", -1);
            if (i2 > 0 && i >= 0) {
                if (i < (iterableTextForAccessibility != null ? iterableTextForAccessibility.length() : Integer.MAX_VALUE)) {
                    TextLayoutResult textLayoutResult = SemanticsUtils_androidKt.getTextLayoutResult(semanticsNode.getUnmergedConfig());
                    if (textLayoutResult == null) {
                        return;
                    }
                    ArrayList arrayList = new ArrayList();
                    for (int i3 = 0; i3 < i2; i3++) {
                        int i4 = i + i3;
                        if (i4 >= textLayoutResult.getLayoutInput().getText().length()) {
                            arrayList.add(null);
                        } else {
                            arrayList.add(toScreenCoords(semanticsNode, textLayoutResult.getBoundingBox(i4)));
                        }
                    }
                    info.getExtras().putParcelableArray(extraDataKey, (Parcelable[]) arrayList.toArray(new RectF[0]));
                    return;
                }
            }
            Log.e(LogTag, "Invalid arguments for accessibility character locations");
            return;
        }
        if (semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getTestTag()) && arguments != null && Intrinsics.areEqual(extraDataKey, ExtraDataTestTagKey)) {
            String str = (String) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getTestTag());
            if (str != null) {
                info.getExtras().putCharSequence(extraDataKey, str);
                return;
            }
            return;
        }
        if (Intrinsics.areEqual(extraDataKey, ExtraDataIdKey)) {
            info.getExtras().putInt(extraDataKey, semanticsNode.getId());
        }
    }

    private final RectF toScreenCoords(SemanticsNode textNode, androidx.compose.p002ui.geometry.Rect bounds) {
        if (textNode == null) {
            return null;
        }
        androidx.compose.p002ui.geometry.Rect rectM4383translatek4lQ0M = bounds.m4383translatek4lQ0M(textNode.m6619getPositionInRootF1C5BW0());
        androidx.compose.p002ui.geometry.Rect boundsInRoot = textNode.getBoundsInRoot();
        androidx.compose.p002ui.geometry.Rect rectIntersect = rectM4383translatek4lQ0M.overlaps(boundsInRoot) ? rectM4383translatek4lQ0M.intersect(boundsInRoot) : null;
        if (rectIntersect == null) {
            return null;
        }
        long jMo5929localToScreenMKHz9U = this.view.mo5929localToScreenMKHz9U(OffsetKt.Offset(rectIntersect.getLeft(), rectIntersect.getTop()));
        long jMo5929localToScreenMKHz9U2 = this.view.mo5929localToScreenMKHz9U(OffsetKt.Offset(rectIntersect.getRight(), rectIntersect.getBottom()));
        return new RectF(Offset.m4346getXimpl(jMo5929localToScreenMKHz9U), Offset.m4347getYimpl(jMo5929localToScreenMKHz9U), Offset.m4346getXimpl(jMo5929localToScreenMKHz9U2), Offset.m4347getYimpl(jMo5929localToScreenMKHz9U2));
    }

    public final boolean dispatchHoverEvent$ui_release(MotionEvent event) {
        if (!isTouchExplorationEnabled()) {
            return false;
        }
        int action = event.getAction();
        if (action == 7 || action == 9) {
            int iHitTestSemanticsAt$ui_release = hitTestSemanticsAt$ui_release(event.getX(), event.getY());
            boolean zDispatchGenericMotionEvent = this.view.getAndroidViewsHandler$ui_release().dispatchGenericMotionEvent(event);
            updateHoveredVirtualView(iHitTestSemanticsAt$ui_release);
            if (iHitTestSemanticsAt$ui_release == Integer.MIN_VALUE) {
                return zDispatchGenericMotionEvent;
            }
            return true;
        }
        if (action != 10) {
            return false;
        }
        if (this.hoveredVirtualViewId != Integer.MIN_VALUE) {
            updateHoveredVirtualView(Integer.MIN_VALUE);
            return true;
        }
        return this.view.getAndroidViewsHandler$ui_release().dispatchGenericMotionEvent(event);
    }

    public final int hitTestSemanticsAt$ui_release(float x, float y) {
        NodeChain nodes;
        Owner.CC.measureAndLayout$default(this.view, false, 1, null);
        HitTestResult hitTestResult = new HitTestResult();
        this.view.getRoot().m6233hitTestSemanticsM_7yMNQ$ui_release(OffsetKt.Offset(x, y), hitTestResult, (12 & 4) != 0, (12 & 8) != 0);
        Modifier.Node node = (Modifier.Node) CollectionsKt.lastOrNull(hitTestResult);
        LayoutNode layoutNodeRequireLayoutNode = node != null ? DelegatableNodeKt.requireLayoutNode(node) : null;
        if (layoutNodeRequireLayoutNode != null && (nodes = layoutNodeRequireLayoutNode.getNodes()) != null && nodes.m6322hasH91voCI$ui_release(NodeKind.m6367constructorimpl(8)) && AndroidComposeViewAccessibilityDelegateCompat_androidKt.isVisible(SemanticsNodeKt.SemanticsNode(layoutNodeRequireLayoutNode, false)) && this.view.getAndroidViewsHandler$ui_release().getLayoutNodeToHolder().get(layoutNodeRequireLayoutNode) == null) {
            return semanticsNodeIdToAccessibilityVirtualNodeId(layoutNodeRequireLayoutNode.getSemanticsId());
        }
        return Integer.MIN_VALUE;
    }

    private final void updateHoveredVirtualView(int virtualViewId) {
        int i = this.hoveredVirtualViewId;
        if (i == virtualViewId) {
            return;
        }
        this.hoveredVirtualViewId = virtualViewId;
        sendEventForVirtualView$default(this, virtualViewId, Fields.SpotShadowColor, null, null, 12, null);
        sendEventForVirtualView$default(this, i, Fields.RotationX, null, null, 12, null);
    }

    public AccessibilityNodeProviderCompat getAccessibilityNodeProvider(View host) {
        return this.nodeProvider;
    }

    private final <T extends CharSequence> T trimToSize(T text, int size) {
        if (size <= 0) {
            throw new IllegalArgumentException("size should be greater than 0".toString());
        }
        if (text == null || text.length() == 0 || text.length() <= size) {
            return text;
        }
        int i = size - 1;
        if (Character.isHighSurrogate(text.charAt(i)) && Character.isLowSurrogate(text.charAt(size))) {
            size = i;
        }
        T t = (T) text.subSequence(0, size);
        Intrinsics.checkNotNull(t, "null cannot be cast to non-null type T of androidx.compose.ui.platform.AndroidComposeViewAccessibilityDelegateCompat.trimToSize");
        return t;
    }

    public static final void semanticsChangeChecker$lambda$49(AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat) {
        Trace.beginSection("measureAndLayout");
        try {
            Owner.CC.measureAndLayout$default(androidComposeViewAccessibilityDelegateCompat.view, false, 1, null);
            Unit unit = Unit.INSTANCE;
            Trace.endSection();
            Trace.beginSection("checkForSemanticsChanges");
            try {
                androidComposeViewAccessibilityDelegateCompat.checkForSemanticsChanges();
                Unit unit2 = Unit.INSTANCE;
                Trace.endSection();
                androidComposeViewAccessibilityDelegateCompat.checkingForSemanticsChanges = false;
            } catch (Throwable th) {
                Trace.endSection();
                throw th;
            }
        } catch (Throwable th2) {
            Trace.endSection();
            throw th2;
        }
    }

    public final void onSemanticsChange$ui_release() {
        this.currentSemanticsNodesInvalidated = true;
        if (!isEnabled$ui_release() || this.checkingForSemanticsChanges) {
            return;
        }
        this.checkingForSemanticsChanges = true;
        this.handler.post(this.semanticsChangeChecker);
    }

    public final java.lang.Object boundsUpdatesEventLoop$ui_release(kotlin.coroutines.Continuation<? super kotlin.Unit> r12) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p002ui.platform.AndroidComposeViewAccessibilityDelegateCompat.boundsUpdatesEventLoop$ui_release(kotlin.coroutines.Continuation):java.lang.Object");
    }

    public final void onLayoutChange$ui_release(LayoutNode layoutNode) {
        this.currentSemanticsNodesInvalidated = true;
        if (isEnabled$ui_release()) {
            notifySubtreeAccessibilityStateChangedIfNeeded(layoutNode);
        }
    }

    public final void notifySubtreeAccessibilityStateChangedIfNeeded(LayoutNode layoutNode) {
        if (this.subtreeChangedLayoutNodes.add(layoutNode)) {
            this.boundsUpdateChannel.trySend-JP2dKIU(Unit.INSTANCE);
        }
    }

    private final void sendTypeViewScrolledAccessibilityEvent(LayoutNode layoutNode) {
        if (layoutNode.isAttached() && !this.view.getAndroidViewsHandler$ui_release().getLayoutNodeToHolder().containsKey(layoutNode)) {
            int semanticsId = layoutNode.getSemanticsId();
            ScrollAxisRange scrollAxisRange = this.pendingHorizontalScrollEvents.get(semanticsId);
            ScrollAxisRange scrollAxisRange2 = this.pendingVerticalScrollEvents.get(semanticsId);
            if (scrollAxisRange == null && scrollAxisRange2 == null) {
                return;
            }
            AccessibilityEvent accessibilityEventCreateEvent = createEvent(semanticsId, Fields.TransformOrigin);
            if (scrollAxisRange != null) {
                accessibilityEventCreateEvent.setScrollX((int) ((Number) scrollAxisRange.getValue().invoke()).floatValue());
                accessibilityEventCreateEvent.setMaxScrollX((int) ((Number) scrollAxisRange.getMaxValue().invoke()).floatValue());
            }
            if (scrollAxisRange2 != null) {
                accessibilityEventCreateEvent.setScrollY((int) ((Number) scrollAxisRange2.getValue().invoke()).floatValue());
                accessibilityEventCreateEvent.setMaxScrollY((int) ((Number) scrollAxisRange2.getMaxValue().invoke()).floatValue());
            }
            sendEvent(accessibilityEventCreateEvent);
        }
    }

    private final void sendSubtreeChangeAccessibilityEvents(LayoutNode layoutNode, MutableIntSet subtreeChangedSemanticsNodesIds) {
        SemanticsConfiguration collapsedSemantics$ui_release;
        LayoutNode layoutNodeFindClosestParentNode;
        if (layoutNode.isAttached() && !this.view.getAndroidViewsHandler$ui_release().getLayoutNodeToHolder().containsKey(layoutNode)) {
            if (!layoutNode.getNodes().m6322hasH91voCI$ui_release(NodeKind.m6367constructorimpl(8))) {
                layoutNode = AndroidComposeViewAccessibilityDelegateCompat_androidKt.findClosestParentNode(layoutNode, new Function1<LayoutNode, Boolean>() {
                    public final Boolean invoke(LayoutNode layoutNode2) {
                        return Boolean.valueOf(layoutNode2.getNodes().m6322hasH91voCI$ui_release(NodeKind.m6367constructorimpl(8)));
                    }
                });
            }
            if (layoutNode == null || (collapsedSemantics$ui_release = layoutNode.getCollapsedSemantics$ui_release()) == null) {
                return;
            }
            if (!collapsedSemantics$ui_release.getIsMergingSemanticsOfDescendants() && (layoutNodeFindClosestParentNode = AndroidComposeViewAccessibilityDelegateCompat_androidKt.findClosestParentNode(layoutNode, new Function1<LayoutNode, Boolean>() {
                public final Boolean invoke(LayoutNode layoutNode2) {
                    SemanticsConfiguration collapsedSemantics$ui_release2 = layoutNode2.getCollapsedSemantics$ui_release();
                    boolean z = false;
                    if (collapsedSemantics$ui_release2 != null && collapsedSemantics$ui_release2.getIsMergingSemanticsOfDescendants()) {
                        z = true;
                    }
                    return Boolean.valueOf(z);
                }
            })) != null) {
                layoutNode = layoutNodeFindClosestParentNode;
            }
            if (layoutNode != null) {
                int semanticsId = layoutNode.getSemanticsId();
                if (subtreeChangedSemanticsNodesIds.add(semanticsId)) {
                    sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(semanticsId), Fields.CameraDistance, 1, null, 8, null);
                }
            }
        }
    }

    private final void checkForSemanticsChanges() {
        Trace.beginSection("sendAccessibilitySemanticsStructureChangeEvents");
        try {
            if (isEnabled$ui_release()) {
                sendAccessibilitySemanticsStructureChangeEvents(this.view.getSemanticsOwner().getUnmergedRootSemanticsNode(), this.previousSemanticsRoot);
            }
            Unit unit = Unit.INSTANCE;
            Trace.endSection();
            Trace.beginSection("sendSemanticsPropertyChangeEvents");
            try {
                sendSemanticsPropertyChangeEvents(getCurrentSemanticsNodes());
                Unit unit2 = Unit.INSTANCE;
                Trace.endSection();
                Trace.beginSection("updateSemanticsNodesCopyAndPanes");
                try {
                    updateSemanticsNodesCopyAndPanes();
                    Unit unit3 = Unit.INSTANCE;
                } finally {
                    Trace.endSection();
                }
            } catch (Throwable th) {
                Trace.endSection();
                throw th;
            }
        } catch (Throwable th2) {
            Trace.endSection();
            throw th2;
        }
    }

    private final void updateSemanticsNodesCopyAndPanes() {
        SemanticsConfiguration unmergedConfig;
        MutableIntSet mutableIntSet = new MutableIntSet(0, 1, null);
        MutableIntSet mutableIntSet2 = this.paneDisplayed;
        int[] iArr = mutableIntSet2.elements;
        long[] jArr = mutableIntSet2.metadata;
        int length = jArr.length - 2;
        long j = 128;
        long j2 = 255;
        char c = 7;
        long j3 = -9187201950435737472L;
        if (length >= 0) {
            int i = 0;
            while (true) {
                long j4 = jArr[i];
                long[] jArr2 = jArr;
                if ((((~j4) << 7) & j4 & (-9187201950435737472L)) == -9187201950435737472L) {
                    if (i != length) {
                        break;
                        break;
                    }
                    i++;
                    jArr = jArr2;
                    j = 128;
                    j2 = 255;
                } else {
                    int i2 = 8 - ((~(i - length)) >>> 31);
                    int i3 = 0;
                    while (i3 < i2) {
                        if ((j4 & j2) < j) {
                            int i4 = iArr[(i << 3) + i3];
                            SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = getCurrentSemanticsNodes().get(i4);
                            SemanticsNode semanticsNode = semanticsNodeWithAdjustedBounds != null ? semanticsNodeWithAdjustedBounds.getSemanticsNode() : null;
                            if (semanticsNode == null || !semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPaneTitle())) {
                                mutableIntSet.add(i4);
                                SemanticsNodeCopy semanticsNodeCopy = this.previousSemanticsNodes.get(i4);
                                sendPaneChangeEvents(i4, 32, (semanticsNodeCopy == null || (unmergedConfig = semanticsNodeCopy.getUnmergedConfig()) == null) ? null : (String) SemanticsConfigurationKt.getOrNull(unmergedConfig, SemanticsProperties.INSTANCE.getPaneTitle()));
                            }
                        }
                        j4 >>= 8;
                        i3++;
                        j = 128;
                        j2 = 255;
                    }
                    if (i2 != 8) {
                        break;
                    }
                    if (i != length) {
                        break;
                    }
                    i++;
                    jArr = jArr2;
                    j = 128;
                    j2 = 255;
                }
            }
        }
        this.paneDisplayed.removeAll(mutableIntSet);
        this.previousSemanticsNodes.clear();
        IntObjectMap<SemanticsNodeWithAdjustedBounds> currentSemanticsNodes = getCurrentSemanticsNodes();
        int[] iArr2 = currentSemanticsNodes.keys;
        Object[] objArr = currentSemanticsNodes.values;
        long[] jArr3 = currentSemanticsNodes.metadata;
        int length2 = jArr3.length - 2;
        if (length2 >= 0) {
            int i5 = 0;
            while (true) {
                long j5 = jArr3[i5];
                if ((((~j5) << c) & j5 & j3) != j3) {
                    int i6 = 8 - ((~(i5 - length2)) >>> 31);
                    for (int i7 = 0; i7 < i6; i7++) {
                        if ((j5 & 255) < 128) {
                            int i8 = (i5 << 3) + i7;
                            int i9 = iArr2[i8];
                            SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds2 = (SemanticsNodeWithAdjustedBounds) objArr[i8];
                            if (semanticsNodeWithAdjustedBounds2.getSemanticsNode().getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPaneTitle()) && this.paneDisplayed.add(i9)) {
                                sendPaneChangeEvents(i9, 16, (String) semanticsNodeWithAdjustedBounds2.getSemanticsNode().getUnmergedConfig().get(SemanticsProperties.INSTANCE.getPaneTitle()));
                            }
                            this.previousSemanticsNodes.set(i9, new SemanticsNodeCopy(semanticsNodeWithAdjustedBounds2.getSemanticsNode(), getCurrentSemanticsNodes()));
                        }
                        j5 >>= 8;
                    }
                    if (i6 != 8) {
                        break;
                    }
                }
                if (i5 == length2) {
                    break;
                }
                i5++;
                c = 7;
                j3 = -9187201950435737472L;
            }
        }
        this.previousSemanticsRoot = new SemanticsNodeCopy(this.view.getSemanticsOwner().getUnmergedRootSemanticsNode(), getCurrentSemanticsNodes());
    }

    private final void sendSemanticsPropertyChangeEvents(IntObjectMap<SemanticsNodeWithAdjustedBounds> newSemanticsNodes) throws KotlinNothingValueException {
        ArrayList arrayList;
        int[] iArr;
        char c;
        int i;
        ArrayList arrayList2;
        int[] iArr2;
        char c2;
        int i2;
        int i3;
        SemanticsNode semanticsNode;
        int i4;
        int i5;
        int i6;
        ArrayList arrayList3;
        int[] iArr3;
        char c3;
        String text;
        AccessibilityEvent accessibilityEventCreateTextSelectionChangedEvent;
        IntObjectMap<SemanticsNodeWithAdjustedBounds> intObjectMap = newSemanticsNodes;
        ArrayList arrayList4 = new ArrayList(this.scrollObservationScopes);
        this.scrollObservationScopes.clear();
        int[] iArr4 = intObjectMap.keys;
        long[] jArr = intObjectMap.metadata;
        char c4 = 2;
        int length = jArr.length - 2;
        if (length < 0) {
            return;
        }
        int i7 = 0;
        while (true) {
            long j = jArr[i7];
            if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                int i8 = 8;
                int i9 = 8 - ((~(i7 - length)) >>> 31);
                long j2 = j;
                int i10 = 0;
                while (i10 < i9) {
                    if ((j2 & 255) < 128) {
                        int i11 = iArr4[(i7 << 3) + i10];
                        SemanticsNodeCopy semanticsNodeCopy = this.previousSemanticsNodes.get(i11);
                        if (semanticsNodeCopy == null) {
                            i = i9;
                            arrayList2 = arrayList4;
                            iArr2 = iArr4;
                            c2 = c4;
                            i2 = i10;
                        } else {
                            SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = intObjectMap.get(i11);
                            SemanticsNode semanticsNode2 = semanticsNodeWithAdjustedBounds != null ? semanticsNodeWithAdjustedBounds.getSemanticsNode() : null;
                            if (semanticsNode2 != null) {
                                boolean zPropertiesDeleted = false;
                                for (Map.Entry<? extends SemanticsPropertyKey<?>, ? extends Object> entry : semanticsNode2.getUnmergedConfig()) {
                                    if (((Intrinsics.areEqual(entry.getKey(), SemanticsProperties.INSTANCE.getHorizontalScrollAxisRange()) || Intrinsics.areEqual(entry.getKey(), SemanticsProperties.INSTANCE.getVerticalScrollAxisRange())) ? registerScrollingId(i11, arrayList4) : false) || !Intrinsics.areEqual(entry.getValue(), SemanticsConfigurationKt.getOrNull(semanticsNodeCopy.getUnmergedConfig(), entry.getKey()))) {
                                        SemanticsPropertyKey<?> key = entry.getKey();
                                        if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getPaneTitle())) {
                                            Object value = entry.getValue();
                                            Intrinsics.checkNotNull(value, "null cannot be cast to non-null type kotlin.String");
                                            String str = (String) value;
                                            if (semanticsNodeCopy.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPaneTitle())) {
                                                sendPaneChangeEvents(i11, i8, str);
                                            }
                                            semanticsNode = semanticsNode2;
                                            i6 = i11;
                                            i4 = i10;
                                            i5 = i9;
                                            arrayList3 = arrayList4;
                                            iArr3 = iArr4;
                                            c3 = 2;
                                            i10 = i4;
                                            i11 = i6;
                                            arrayList4 = arrayList3;
                                            semanticsNode2 = semanticsNode;
                                            i9 = i5;
                                            iArr4 = iArr3;
                                            i8 = 8;
                                        } else {
                                            if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getStateDescription()) ? true : Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getToggleableState())) {
                                                semanticsNode = semanticsNode2;
                                                int i12 = i11;
                                                i4 = i10;
                                                i5 = i9;
                                                sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i11), Fields.CameraDistance, 64, null, 8, null);
                                                i6 = i12;
                                                sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i12), Fields.CameraDistance, 0, null, 8, null);
                                            } else {
                                                semanticsNode = semanticsNode2;
                                                i4 = i10;
                                                i5 = i9;
                                                i6 = i11;
                                                if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getProgressBarRangeInfo())) {
                                                    sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 64, null, 8, null);
                                                    sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 0, null, 8, null);
                                                } else if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getSelected())) {
                                                    Role role = (Role) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getRole());
                                                    if (role == null ? false : Role.m6607equalsimpl0(role.getValue(), Role.INSTANCE.m6617getTabo7Vup1c())) {
                                                        if (Intrinsics.areEqual(SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getSelected()), true)) {
                                                            AccessibilityEvent accessibilityEventCreateEvent = createEvent(semanticsNodeIdToAccessibilityVirtualNodeId(i6), 4);
                                                            SemanticsNode semanticsNodeCopyWithMergingEnabled$ui_release = semanticsNode.copyWithMergingEnabled$ui_release();
                                                            List list = (List) SemanticsConfigurationKt.getOrNull(semanticsNodeCopyWithMergingEnabled$ui_release.getConfig(), SemanticsProperties.INSTANCE.getContentDescription());
                                                            String strFastJoinToString$default = list != null ? ListUtilsKt.fastJoinToString$default(list, ",", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 62, (Object) null) : null;
                                                            List list2 = (List) SemanticsConfigurationKt.getOrNull(semanticsNodeCopyWithMergingEnabled$ui_release.getConfig(), SemanticsProperties.INSTANCE.getText());
                                                            String strFastJoinToString$default2 = list2 != null ? ListUtilsKt.fastJoinToString$default(list2, ",", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 62, (Object) null) : null;
                                                            if (strFastJoinToString$default != null) {
                                                                accessibilityEventCreateEvent.setContentDescription(strFastJoinToString$default);
                                                                Unit unit = Unit.INSTANCE;
                                                                Unit unit2 = Unit.INSTANCE;
                                                            }
                                                            if (strFastJoinToString$default2 != null) {
                                                                Boolean.valueOf(accessibilityEventCreateEvent.getText().add(strFastJoinToString$default2));
                                                            }
                                                            sendEvent(accessibilityEventCreateEvent);
                                                        } else {
                                                            sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 0, null, 8, null);
                                                        }
                                                    } else {
                                                        sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 64, null, 8, null);
                                                        sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 0, null, 8, null);
                                                    }
                                                } else if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getContentDescription())) {
                                                    int iSemanticsNodeIdToAccessibilityVirtualNodeId = semanticsNodeIdToAccessibilityVirtualNodeId(i6);
                                                    Object value2 = entry.getValue();
                                                    Intrinsics.checkNotNull(value2, "null cannot be cast to non-null type kotlin.collections.List<kotlin.String>");
                                                    sendEventForVirtualView(iSemanticsNodeIdToAccessibilityVirtualNodeId, Fields.CameraDistance, 4, (List) value2);
                                                } else {
                                                    String str2 = "";
                                                    if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getEditableText())) {
                                                        if (semanticsNode.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getSetText())) {
                                                            AnnotatedString textForTextField = getTextForTextField(semanticsNodeCopy.getUnmergedConfig());
                                                            CharSequence charSequence = textForTextField != null ? (CharSequence) textForTextField : "";
                                                            CharSequence textForTextField2 = getTextForTextField(semanticsNode.getUnmergedConfig());
                                                            String str3 = textForTextField2 != null ? textForTextField2 : "";
                                                            CharSequence charSequenceTrimToSize = trimToSize(str3, ParcelSafeTextLength);
                                                            int length2 = charSequence.length();
                                                            int length3 = str3.length();
                                                            int iCoerceAtMost = RangesKt.coerceAtMost(length2, length3);
                                                            int i13 = 0;
                                                            while (true) {
                                                                if (i13 >= iCoerceAtMost) {
                                                                    arrayList3 = arrayList4;
                                                                    break;
                                                                }
                                                                arrayList3 = arrayList4;
                                                                if (charSequence.charAt(i13) != str3.charAt(i13)) {
                                                                    break;
                                                                }
                                                                i13++;
                                                                arrayList4 = arrayList3;
                                                            }
                                                            int i14 = 0;
                                                            while (i14 < iCoerceAtMost - i13) {
                                                                int i15 = iCoerceAtMost;
                                                                if (charSequence.charAt((length2 - 1) - i14) != str3.charAt((length3 - 1) - i14)) {
                                                                    break;
                                                                }
                                                                i14++;
                                                                iCoerceAtMost = i15;
                                                            }
                                                            int i16 = (length2 - i14) - i13;
                                                            int i17 = (length3 - i14) - i13;
                                                            boolean zContains = semanticsNodeCopy.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPassword());
                                                            boolean zContains2 = semanticsNode.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getPassword());
                                                            iArr3 = iArr4;
                                                            boolean zContains3 = semanticsNodeCopy.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getEditableText());
                                                            boolean z = zContains3 && !zContains && zContains2;
                                                            boolean z2 = zContains3 && zContains && !zContains2;
                                                            if (z || z2) {
                                                                accessibilityEventCreateTextSelectionChangedEvent = createTextSelectionChangedEvent(semanticsNodeIdToAccessibilityVirtualNodeId(i6), 0, 0, Integer.valueOf(length3), charSequenceTrimToSize);
                                                            } else {
                                                                accessibilityEventCreateTextSelectionChangedEvent = createEvent(semanticsNodeIdToAccessibilityVirtualNodeId(i6), 16);
                                                                accessibilityEventCreateTextSelectionChangedEvent.setFromIndex(i13);
                                                                accessibilityEventCreateTextSelectionChangedEvent.setRemovedCount(i16);
                                                                accessibilityEventCreateTextSelectionChangedEvent.setAddedCount(i17);
                                                                accessibilityEventCreateTextSelectionChangedEvent.setBeforeText(charSequence);
                                                                accessibilityEventCreateTextSelectionChangedEvent.getText().add(charSequenceTrimToSize);
                                                            }
                                                            accessibilityEventCreateTextSelectionChangedEvent.setClassName(TextFieldClassName);
                                                            sendEvent(accessibilityEventCreateTextSelectionChangedEvent);
                                                            if (z || z2) {
                                                                long j3 = ((TextRange) semanticsNode.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getTextSelectionRange())).unbox-impl();
                                                                accessibilityEventCreateTextSelectionChangedEvent.setFromIndex(TextRange.getStart-impl(j3));
                                                                accessibilityEventCreateTextSelectionChangedEvent.setToIndex(TextRange.getEnd-impl(j3));
                                                                sendEvent(accessibilityEventCreateTextSelectionChangedEvent);
                                                            }
                                                            c3 = 2;
                                                        } else {
                                                            arrayList3 = arrayList4;
                                                            iArr3 = iArr4;
                                                            c3 = 2;
                                                            sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i6), Fields.CameraDistance, 2, null, 8, null);
                                                        }
                                                    } else {
                                                        arrayList3 = arrayList4;
                                                        iArr3 = iArr4;
                                                        c3 = 2;
                                                        if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getTextSelectionRange())) {
                                                            AnnotatedString textForTextField3 = getTextForTextField(semanticsNode.getUnmergedConfig());
                                                            if (textForTextField3 != null && (text = textForTextField3.getText()) != null) {
                                                                str2 = text;
                                                            }
                                                            long j4 = ((TextRange) semanticsNode.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getTextSelectionRange())).unbox-impl();
                                                            sendEvent(createTextSelectionChangedEvent(semanticsNodeIdToAccessibilityVirtualNodeId(i6), Integer.valueOf(TextRange.getStart-impl(j4)), Integer.valueOf(TextRange.getEnd-impl(j4)), Integer.valueOf(str2.length()), trimToSize(str2, ParcelSafeTextLength)));
                                                            sendPendingTextTraversedAtGranularityEvent(semanticsNode.getId());
                                                        } else if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getHorizontalScrollAxisRange()) ? true : Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getVerticalScrollAxisRange())) {
                                                            notifySubtreeAccessibilityStateChangedIfNeeded(semanticsNode.getLayoutNode());
                                                            ScrollObservationScope scrollObservationScopeFindById = SemanticsUtils_androidKt.findById(this.scrollObservationScopes, i6);
                                                            Intrinsics.checkNotNull(scrollObservationScopeFindById);
                                                            scrollObservationScopeFindById.setHorizontalScrollAxisRange((ScrollAxisRange) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getHorizontalScrollAxisRange()));
                                                            scrollObservationScopeFindById.setVerticalScrollAxisRange((ScrollAxisRange) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsProperties.INSTANCE.getVerticalScrollAxisRange()));
                                                            scheduleScrollEventIfNeeded(scrollObservationScopeFindById);
                                                        } else if (Intrinsics.areEqual(key, SemanticsProperties.INSTANCE.getFocused())) {
                                                            Object value3 = entry.getValue();
                                                            Intrinsics.checkNotNull(value3, "null cannot be cast to non-null type kotlin.Boolean");
                                                            if (((Boolean) value3).booleanValue()) {
                                                                sendEvent(createEvent(semanticsNodeIdToAccessibilityVirtualNodeId(semanticsNode.getId()), 8));
                                                            }
                                                            sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(semanticsNode.getId()), Fields.CameraDistance, 0, null, 8, null);
                                                        } else if (Intrinsics.areEqual(key, SemanticsActions.INSTANCE.getCustomActions())) {
                                                            List list3 = (List) semanticsNode.getUnmergedConfig().get(SemanticsActions.INSTANCE.getCustomActions());
                                                            List list4 = (List) SemanticsConfigurationKt.getOrNull(semanticsNodeCopy.getUnmergedConfig(), SemanticsActions.INSTANCE.getCustomActions());
                                                            if (list4 != null) {
                                                                LinkedHashSet linkedHashSet = new LinkedHashSet();
                                                                int size = list3.size();
                                                                for (int i18 = 0; i18 < size; i18++) {
                                                                    linkedHashSet.add(((CustomAccessibilityAction) list3.get(i18)).getLabel());
                                                                }
                                                                LinkedHashSet linkedHashSet2 = new LinkedHashSet();
                                                                int size2 = list4.size();
                                                                for (int i19 = 0; i19 < size2; i19++) {
                                                                    linkedHashSet2.add(((CustomAccessibilityAction) list4.get(i19)).getLabel());
                                                                }
                                                                if (linkedHashSet.containsAll(linkedHashSet2) && linkedHashSet2.containsAll(linkedHashSet)) {
                                                                    zPropertiesDeleted = false;
                                                                } else {
                                                                    zPropertiesDeleted = true;
                                                                }
                                                            } else if (!list3.isEmpty()) {
                                                                i10 = i4;
                                                                i11 = i6;
                                                                arrayList4 = arrayList3;
                                                                semanticsNode2 = semanticsNode;
                                                                i9 = i5;
                                                                iArr4 = iArr3;
                                                                i8 = 8;
                                                                zPropertiesDeleted = true;
                                                            }
                                                        } else {
                                                            if (entry.getValue() instanceof AccessibilityAction) {
                                                                Object value4 = entry.getValue();
                                                                Intrinsics.checkNotNull(value4, "null cannot be cast to non-null type androidx.compose.ui.semantics.AccessibilityAction<*>");
                                                                if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.accessibilityEquals((AccessibilityAction) value4, SemanticsConfigurationKt.getOrNull(semanticsNodeCopy.getUnmergedConfig(), entry.getKey()))) {
                                                                    zPropertiesDeleted = false;
                                                                }
                                                            }
                                                            zPropertiesDeleted = true;
                                                        }
                                                    }
                                                    i10 = i4;
                                                    i11 = i6;
                                                    arrayList4 = arrayList3;
                                                    semanticsNode2 = semanticsNode;
                                                    i9 = i5;
                                                    iArr4 = iArr3;
                                                    i8 = 8;
                                                }
                                            }
                                            arrayList3 = arrayList4;
                                            iArr3 = iArr4;
                                            c3 = 2;
                                            i10 = i4;
                                            i11 = i6;
                                            arrayList4 = arrayList3;
                                            semanticsNode2 = semanticsNode;
                                            i9 = i5;
                                            iArr4 = iArr3;
                                            i8 = 8;
                                        }
                                    } else {
                                        semanticsNode = semanticsNode2;
                                        i6 = i11;
                                        i4 = i10;
                                        i5 = i9;
                                        arrayList3 = arrayList4;
                                        iArr3 = iArr4;
                                        c3 = 2;
                                        i10 = i4;
                                        i11 = i6;
                                        arrayList4 = arrayList3;
                                        semanticsNode2 = semanticsNode;
                                        i9 = i5;
                                        iArr4 = iArr3;
                                        i8 = 8;
                                    }
                                    c4 = c3;
                                }
                                SemanticsNode semanticsNode3 = semanticsNode2;
                                int i20 = i11;
                                i = i9;
                                arrayList2 = arrayList4;
                                iArr2 = iArr4;
                                c2 = c4;
                                i2 = i10;
                                if (!zPropertiesDeleted) {
                                    zPropertiesDeleted = AndroidComposeViewAccessibilityDelegateCompat_androidKt.propertiesDeleted(semanticsNode3, semanticsNodeCopy.getUnmergedConfig());
                                }
                                if (zPropertiesDeleted) {
                                    sendEventForVirtualView$default(this, semanticsNodeIdToAccessibilityVirtualNodeId(i20), Fields.CameraDistance, 0, null, 8, null);
                                }
                            } else {
                                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("no value for specified key");
                                throw new KotlinNothingValueException();
                            }
                        }
                        i3 = 8;
                    } else {
                        i = i9;
                        arrayList2 = arrayList4;
                        iArr2 = iArr4;
                        c2 = c4;
                        i2 = i10;
                        i3 = i8;
                    }
                    j2 >>= i3;
                    i10 = i2 + 1;
                    i8 = i3;
                    c4 = c2;
                    arrayList4 = arrayList2;
                    i9 = i;
                    iArr4 = iArr2;
                    intObjectMap = newSemanticsNodes;
                }
                arrayList = arrayList4;
                iArr = iArr4;
                c = c4;
                if (i9 != i8) {
                    return;
                }
            } else {
                arrayList = arrayList4;
                iArr = iArr4;
                c = c4;
            }
            if (i7 == length) {
                return;
            }
            i7++;
            c4 = c;
            arrayList4 = arrayList;
            iArr4 = iArr;
            intObjectMap = newSemanticsNodes;
        }
    }

    private final boolean registerScrollingId(int id, List<ScrollObservationScope> oldScrollObservationScopes) {
        boolean z;
        ScrollObservationScope scrollObservationScopeFindById = SemanticsUtils_androidKt.findById(oldScrollObservationScopes, id);
        if (scrollObservationScopeFindById != null) {
            z = false;
        } else {
            scrollObservationScopeFindById = new ScrollObservationScope(id, this.scrollObservationScopes, null, null, null, null);
            z = true;
        }
        this.scrollObservationScopes.add(scrollObservationScopeFindById);
        return z;
    }

    public final void scheduleScrollEventIfNeeded(final ScrollObservationScope scrollObservationScope) {
        if (scrollObservationScope.isValidOwnerScope()) {
            this.view.getSnapshotObserver().observeReads$ui_release(scrollObservationScope, this.scheduleScrollEventIfNeededLambda, new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6477invoke();
                    return Unit.INSTANCE;
                }

                public final void m6477invoke() {
                    SemanticsNode semanticsNode;
                    LayoutNode layoutNode;
                    ScrollAxisRange horizontalScrollAxisRange = scrollObservationScope.getHorizontalScrollAxisRange();
                    ScrollAxisRange verticalScrollAxisRange = scrollObservationScope.getVerticalScrollAxisRange();
                    Float oldXValue = scrollObservationScope.getOldXValue();
                    Float oldYValue = scrollObservationScope.getOldYValue();
                    float fFloatValue = (horizontalScrollAxisRange == null || oldXValue == null) ? 0.0f : ((Number) horizontalScrollAxisRange.getValue().invoke()).floatValue() - oldXValue.floatValue();
                    float fFloatValue2 = (verticalScrollAxisRange == null || oldYValue == null) ? 0.0f : ((Number) verticalScrollAxisRange.getValue().invoke()).floatValue() - oldYValue.floatValue();
                    if (fFloatValue != 0.0f || fFloatValue2 != 0.0f) {
                        int iSemanticsNodeIdToAccessibilityVirtualNodeId = this.semanticsNodeIdToAccessibilityVirtualNodeId(scrollObservationScope.getSemanticsNodeId());
                        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds = (SemanticsNodeWithAdjustedBounds) this.getCurrentSemanticsNodes().get(this.focusedVirtualViewId);
                        if (semanticsNodeWithAdjustedBounds != null) {
                            AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat = this;
                            try {
                                AccessibilityNodeInfoCompat accessibilityNodeInfoCompat = androidComposeViewAccessibilityDelegateCompat.currentlyFocusedANI;
                                if (accessibilityNodeInfoCompat != null) {
                                    accessibilityNodeInfoCompat.setBoundsInScreen(androidComposeViewAccessibilityDelegateCompat.boundsInScreen(semanticsNodeWithAdjustedBounds));
                                    Unit unit = Unit.INSTANCE;
                                }
                            } catch (IllegalStateException unused) {
                                Unit unit2 = Unit.INSTANCE;
                            }
                        }
                        this.getView().invalidate();
                        SemanticsNodeWithAdjustedBounds semanticsNodeWithAdjustedBounds2 = (SemanticsNodeWithAdjustedBounds) this.getCurrentSemanticsNodes().get(iSemanticsNodeIdToAccessibilityVirtualNodeId);
                        if (semanticsNodeWithAdjustedBounds2 != null && (semanticsNode = semanticsNodeWithAdjustedBounds2.getSemanticsNode()) != null && (layoutNode = semanticsNode.getLayoutNode()) != null) {
                            AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat2 = this;
                            if (horizontalScrollAxisRange != null) {
                                androidComposeViewAccessibilityDelegateCompat2.pendingHorizontalScrollEvents.set(iSemanticsNodeIdToAccessibilityVirtualNodeId, horizontalScrollAxisRange);
                            }
                            if (verticalScrollAxisRange != null) {
                                androidComposeViewAccessibilityDelegateCompat2.pendingVerticalScrollEvents.set(iSemanticsNodeIdToAccessibilityVirtualNodeId, verticalScrollAxisRange);
                            }
                            androidComposeViewAccessibilityDelegateCompat2.notifySubtreeAccessibilityStateChangedIfNeeded(layoutNode);
                        }
                    }
                    if (horizontalScrollAxisRange != null) {
                        scrollObservationScope.setOldXValue((Float) horizontalScrollAxisRange.getValue().invoke());
                    }
                    if (verticalScrollAxisRange != null) {
                        scrollObservationScope.setOldYValue((Float) verticalScrollAxisRange.getValue().invoke());
                    }
                }
            });
        }
    }

    private final void sendPaneChangeEvents(int semanticsNodeId, int contentChangeType, String title) {
        AccessibilityEvent accessibilityEventCreateEvent = createEvent(semanticsNodeIdToAccessibilityVirtualNodeId(semanticsNodeId), 32);
        accessibilityEventCreateEvent.setContentChangeTypes(contentChangeType);
        if (title != null) {
            accessibilityEventCreateEvent.getText().add(title);
        }
        sendEvent(accessibilityEventCreateEvent);
    }

    private final void sendAccessibilitySemanticsStructureChangeEvents(SemanticsNode newNode, SemanticsNodeCopy oldNode) {
        MutableIntSet mutableIntSetMutableIntSetOf = IntSetKt.mutableIntSetOf();
        List<SemanticsNode> replacedChildren$ui_release = newNode.getReplacedChildren$ui_release();
        int size = replacedChildren$ui_release.size();
        for (int i = 0; i < size; i++) {
            SemanticsNode semanticsNode = replacedChildren$ui_release.get(i);
            if (getCurrentSemanticsNodes().contains(semanticsNode.getId())) {
                if (!oldNode.getChildren().contains(semanticsNode.getId())) {
                    notifySubtreeAccessibilityStateChangedIfNeeded(newNode.getLayoutNode());
                    return;
                }
                mutableIntSetMutableIntSetOf.add(semanticsNode.getId());
            }
        }
        MutableIntSet children = oldNode.getChildren();
        int[] iArr = children.elements;
        long[] jArr = children.metadata;
        int length = jArr.length - 2;
        if (length >= 0) {
            int i2 = 0;
            while (true) {
                long j = jArr[i2];
                if ((((~j) << 7) & j & (-9187201950435737472L)) == -9187201950435737472L) {
                    if (i2 != length) {
                        break;
                        break;
                    }
                    i2++;
                } else {
                    int i3 = 8 - ((~(i2 - length)) >>> 31);
                    for (int i4 = 0; i4 < i3; i4++) {
                        if ((255 & j) < 128 && !mutableIntSetMutableIntSetOf.contains(iArr[(i2 << 3) + i4])) {
                            notifySubtreeAccessibilityStateChangedIfNeeded(newNode.getLayoutNode());
                            return;
                        }
                        j >>= 8;
                    }
                    if (i3 != 8) {
                        break;
                    } else if (i2 != length) {
                        break;
                    } else {
                        i2++;
                    }
                }
            }
        }
        List<SemanticsNode> replacedChildren$ui_release2 = newNode.getReplacedChildren$ui_release();
        int size2 = replacedChildren$ui_release2.size();
        for (int i5 = 0; i5 < size2; i5++) {
            SemanticsNode semanticsNode2 = replacedChildren$ui_release2.get(i5);
            if (getCurrentSemanticsNodes().contains(semanticsNode2.getId())) {
                SemanticsNodeCopy semanticsNodeCopy = this.previousSemanticsNodes.get(semanticsNode2.getId());
                Intrinsics.checkNotNull(semanticsNodeCopy);
                sendAccessibilitySemanticsStructureChangeEvents(semanticsNode2, semanticsNodeCopy);
            }
        }
    }

    public final int semanticsNodeIdToAccessibilityVirtualNodeId(int id) {
        if (id == this.view.getSemanticsOwner().getUnmergedRootSemanticsNode().getId()) {
            return -1;
        }
        return id;
    }

    private final boolean traverseAtGranularity(SemanticsNode node, int granularity, boolean forward, boolean extendSelection) {
        AccessibilityIterators.TextSegmentIterator iteratorForGranularity;
        int accessibilitySelectionStart;
        int i;
        int id = node.getId();
        Integer num = this.previousTraversedNode;
        if (num == null || id != num.intValue()) {
            this.accessibilityCursorPosition = -1;
            this.previousTraversedNode = Integer.valueOf(node.getId());
        }
        String iterableTextForAccessibility = getIterableTextForAccessibility(node);
        String str = iterableTextForAccessibility;
        if (str == null || str.length() == 0 || (iteratorForGranularity = getIteratorForGranularity(node, granularity)) == null) {
            return false;
        }
        int accessibilitySelectionEnd = getAccessibilitySelectionEnd(node);
        if (accessibilitySelectionEnd == -1) {
            accessibilitySelectionEnd = forward ? 0 : iterableTextForAccessibility.length();
        }
        int[] iArrFollowing = forward ? iteratorForGranularity.following(accessibilitySelectionEnd) : iteratorForGranularity.preceding(accessibilitySelectionEnd);
        if (iArrFollowing == null) {
            return false;
        }
        int i2 = iArrFollowing[0];
        int i3 = iArrFollowing[1];
        if (extendSelection && isAccessibilitySelectionExtendable(node)) {
            accessibilitySelectionStart = getAccessibilitySelectionStart(node);
            if (accessibilitySelectionStart == -1) {
                accessibilitySelectionStart = forward ? i2 : i3;
            }
            i = forward ? i3 : i2;
        } else {
            accessibilitySelectionStart = forward ? i3 : i2;
            i = accessibilitySelectionStart;
        }
        this.pendingTextTraversedEvent = new PendingTextTraversedEvent(node, forward ? Fields.RotationX : Fields.RotationY, granularity, i2, i3, SystemClock.uptimeMillis());
        setAccessibilitySelection(node, accessibilitySelectionStart, i, true);
        return true;
    }

    private final void sendPendingTextTraversedAtGranularityEvent(int semanticsNodeId) {
        PendingTextTraversedEvent pendingTextTraversedEvent = this.pendingTextTraversedEvent;
        if (pendingTextTraversedEvent != null) {
            if (semanticsNodeId != pendingTextTraversedEvent.getNode().getId()) {
                return;
            }
            if (SystemClock.uptimeMillis() - pendingTextTraversedEvent.getTraverseTime() <= 1000) {
                AccessibilityEvent accessibilityEventCreateEvent = createEvent(semanticsNodeIdToAccessibilityVirtualNodeId(pendingTextTraversedEvent.getNode().getId()), Fields.RenderEffect);
                accessibilityEventCreateEvent.setFromIndex(pendingTextTraversedEvent.getFromIndex());
                accessibilityEventCreateEvent.setToIndex(pendingTextTraversedEvent.getToIndex());
                accessibilityEventCreateEvent.setAction(pendingTextTraversedEvent.getAction());
                accessibilityEventCreateEvent.setMovementGranularity(pendingTextTraversedEvent.getGranularity());
                accessibilityEventCreateEvent.getText().add(getIterableTextForAccessibility(pendingTextTraversedEvent.getNode()));
                sendEvent(accessibilityEventCreateEvent);
            }
        }
        this.pendingTextTraversedEvent = null;
    }

    private final boolean setAccessibilitySelection(SemanticsNode node, int start, int end, boolean traversalMode) {
        String iterableTextForAccessibility;
        if (node.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getSetSelection()) && AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(node)) {
            Function3 action = ((AccessibilityAction) node.getUnmergedConfig().get(SemanticsActions.INSTANCE.getSetSelection())).getAction();
            if (action != null) {
                return ((Boolean) action.invoke(Integer.valueOf(start), Integer.valueOf(end), Boolean.valueOf(traversalMode))).booleanValue();
            }
            return false;
        }
        if ((start == end && end == this.accessibilityCursorPosition) || (iterableTextForAccessibility = getIterableTextForAccessibility(node)) == null) {
            return false;
        }
        if (start < 0 || start != end || end > iterableTextForAccessibility.length()) {
            start = -1;
        }
        this.accessibilityCursorPosition = start;
        String str = iterableTextForAccessibility;
        boolean z = str.length() > 0;
        sendEvent(createTextSelectionChangedEvent(semanticsNodeIdToAccessibilityVirtualNodeId(node.getId()), z ? Integer.valueOf(this.accessibilityCursorPosition) : null, z ? Integer.valueOf(this.accessibilityCursorPosition) : null, z ? Integer.valueOf(iterableTextForAccessibility.length()) : null, str));
        sendPendingTextTraversedAtGranularityEvent(node.getId());
        return true;
    }

    private final int getAccessibilitySelectionStart(SemanticsNode node) {
        if (!node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getContentDescription()) && node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getTextSelectionRange())) {
            return TextRange.getStart-impl(((TextRange) node.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getTextSelectionRange())).unbox-impl());
        }
        return this.accessibilityCursorPosition;
    }

    private final int getAccessibilitySelectionEnd(SemanticsNode node) {
        if (!node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getContentDescription()) && node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getTextSelectionRange())) {
            return TextRange.getEnd-impl(((TextRange) node.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getTextSelectionRange())).unbox-impl());
        }
        return this.accessibilityCursorPosition;
    }

    private final boolean isAccessibilitySelectionExtendable(SemanticsNode node) {
        return !node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getContentDescription()) && node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getEditableText());
    }

    private final AccessibilityIterators.TextSegmentIterator getIteratorForGranularity(SemanticsNode node, int granularity) {
        AccessibilityIterators.AbstractTextSegmentIterator companion;
        TextLayoutResult textLayoutResult;
        if (node == null) {
            return null;
        }
        String iterableTextForAccessibility = getIterableTextForAccessibility(node);
        String str = iterableTextForAccessibility;
        if (str == null || str.length() == 0) {
            return null;
        }
        if (granularity == 1) {
            companion = AccessibilityIterators.CharacterTextSegmentIterator.INSTANCE.getInstance(this.view.getContext().getResources().getConfiguration().locale);
            companion.initialize(iterableTextForAccessibility);
        } else if (granularity == 2) {
            companion = AccessibilityIterators.WordTextSegmentIterator.INSTANCE.getInstance(this.view.getContext().getResources().getConfiguration().locale);
            companion.initialize(iterableTextForAccessibility);
        } else if (granularity == 4) {
            if (node.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getGetTextLayoutResult()) || (textLayoutResult = SemanticsUtils_androidKt.getTextLayoutResult(node.getUnmergedConfig())) == null) {
                return null;
            }
            if (granularity == 4) {
                companion = AccessibilityIterators.LineTextSegmentIterator.INSTANCE.getInstance();
                ((AccessibilityIterators.LineTextSegmentIterator) companion).initialize(iterableTextForAccessibility, textLayoutResult);
            } else {
                AccessibilityIterators.AbstractTextSegmentIterator companion2 = AccessibilityIterators.PageTextSegmentIterator.INSTANCE.getInstance();
                ((AccessibilityIterators.PageTextSegmentIterator) companion2).initialize(iterableTextForAccessibility, textLayoutResult, node);
                companion = companion2;
            }
        } else if (granularity == 8) {
            companion = AccessibilityIterators.ParagraphTextSegmentIterator.INSTANCE.getInstance();
            companion.initialize(iterableTextForAccessibility);
        } else {
            if (granularity != 16) {
                return null;
            }
            if (node.getUnmergedConfig().contains(SemanticsActions.INSTANCE.getGetTextLayoutResult())) {
                return null;
            }
            if (granularity == 4) {
                companion = AccessibilityIterators.LineTextSegmentIterator.INSTANCE.getInstance();
                ((AccessibilityIterators.LineTextSegmentIterator) companion).initialize(iterableTextForAccessibility, textLayoutResult);
            } else {
                AccessibilityIterators.AbstractTextSegmentIterator companion3 = AccessibilityIterators.PageTextSegmentIterator.INSTANCE.getInstance();
                ((AccessibilityIterators.PageTextSegmentIterator) companion3).initialize(iterableTextForAccessibility, textLayoutResult, node);
                companion = companion3;
            }
        }
        return companion;
    }

    private final String getIterableTextForAccessibility(SemanticsNode node) {
        AnnotatedString annotatedString;
        if (node == null) {
            return null;
        }
        if (node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getContentDescription())) {
            return ListUtilsKt.fastJoinToString$default((List) node.getUnmergedConfig().get(SemanticsProperties.INSTANCE.getContentDescription()), ",", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 62, (Object) null);
        }
        if (node.getUnmergedConfig().contains(SemanticsProperties.INSTANCE.getEditableText())) {
            AnnotatedString textForTextField = getTextForTextField(node.getUnmergedConfig());
            if (textForTextField != null) {
                return textForTextField.getText();
            }
            return null;
        }
        List list = (List) SemanticsConfigurationKt.getOrNull(node.getUnmergedConfig(), SemanticsProperties.INSTANCE.getText());
        if (list == null || (annotatedString = (AnnotatedString) CollectionsKt.firstOrNull(list)) == null) {
            return null;
        }
        return annotatedString.getText();
    }

    private final AnnotatedString getTextForTextField(SemanticsConfiguration semanticsConfiguration) {
        return (AnnotatedString) SemanticsConfigurationKt.getOrNull(semanticsConfiguration, SemanticsProperties.INSTANCE.getEditableText());
    }

    @Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J*\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fH\u0016J\u0012\u0010\r\u001a\u0004\u0018\u00010\b2\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u0012\u0010\u000e\u001a\u0004\u0018\u00010\b2\u0006\u0010\u000f\u001a\u00020\u0006H\u0016J\"\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u00062\b\u0010\u000b\u001a\u0004\u0018\u00010\fH\u0016¨\u0006\u0013"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$ComposeAccessibilityNodeProvider;", "Landroidx/core/view/accessibility/AccessibilityNodeProviderCompat;", "(Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat;)V", "addExtraDataToAccessibilityNodeInfo", "", "virtualViewId", "", "info", "Landroidx/core/view/accessibility/AccessibilityNodeInfoCompat;", "extraDataKey", "", "arguments", "Landroid/os/Bundle;", "createAccessibilityNodeInfo", "findFocus", "focus", "performAction", "", "action", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class ComposeAccessibilityNodeProvider extends AccessibilityNodeProviderCompat {
        public ComposeAccessibilityNodeProvider() {
        }

        public AccessibilityNodeInfoCompat createAccessibilityNodeInfo(int virtualViewId) throws KotlinNothingValueException {
            AccessibilityNodeInfoCompat accessibilityNodeInfoCompatCreateNodeInfo = AndroidComposeViewAccessibilityDelegateCompat.this.createNodeInfo(virtualViewId);
            AndroidComposeViewAccessibilityDelegateCompat androidComposeViewAccessibilityDelegateCompat = AndroidComposeViewAccessibilityDelegateCompat.this;
            if (androidComposeViewAccessibilityDelegateCompat.sendingFocusAffectingEvent && virtualViewId == androidComposeViewAccessibilityDelegateCompat.focusedVirtualViewId) {
                androidComposeViewAccessibilityDelegateCompat.currentlyFocusedANI = accessibilityNodeInfoCompatCreateNodeInfo;
            }
            return accessibilityNodeInfoCompatCreateNodeInfo;
        }

        public boolean performAction(int virtualViewId, int action, Bundle arguments) {
            return AndroidComposeViewAccessibilityDelegateCompat.this.performActionHelper(virtualViewId, action, arguments);
        }

        public void addExtraDataToAccessibilityNodeInfo(int virtualViewId, AccessibilityNodeInfoCompat info, String extraDataKey, Bundle arguments) {
            AndroidComposeViewAccessibilityDelegateCompat.this.addExtraDataToAccessibilityNodeInfoHelper(virtualViewId, info, extraDataKey, arguments);
        }

        public AccessibilityNodeInfoCompat findFocus(int focus) {
            return createAccessibilityNodeInfo(AndroidComposeViewAccessibilityDelegateCompat.this.focusedVirtualViewId);
        }
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007¨\u0006\t"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$Api24Impl;", "", "()V", "addSetProgressAction", "", "info", "Landroidx/core/view/accessibility/AccessibilityNodeInfoCompat;", "semanticsNode", "Landroidx/compose/ui/semantics/SemanticsNode;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class Api24Impl {
        public static final Api24Impl INSTANCE = new Api24Impl();

        private Api24Impl() {
        }

        @JvmStatic
        public static final void addSetProgressAction(AccessibilityNodeInfoCompat info, SemanticsNode semanticsNode) {
            AccessibilityAction accessibilityAction;
            if (!AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode) || (accessibilityAction = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getSetProgress())) == null) {
                return;
            }
            info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionSetProgress, accessibilityAction.getLabel()));
        }
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007¨\u0006\t"}, d2 = {"Landroidx/compose/ui/platform/AndroidComposeViewAccessibilityDelegateCompat$Api29Impl;", "", "()V", "addPageActions", "", "info", "Landroidx/core/view/accessibility/AccessibilityNodeInfoCompat;", "semanticsNode", "Landroidx/compose/ui/semantics/SemanticsNode;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class Api29Impl {
        public static final Api29Impl INSTANCE = new Api29Impl();

        private Api29Impl() {
        }

        @JvmStatic
        public static final void addPageActions(AccessibilityNodeInfoCompat info, SemanticsNode semanticsNode) {
            if (AndroidComposeViewAccessibilityDelegateCompat_androidKt.enabled(semanticsNode)) {
                AccessibilityAction accessibilityAction = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getPageUp());
                if (accessibilityAction != null) {
                    info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionPageUp, accessibilityAction.getLabel()));
                }
                AccessibilityAction accessibilityAction2 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getPageDown());
                if (accessibilityAction2 != null) {
                    info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionPageDown, accessibilityAction2.getLabel()));
                }
                AccessibilityAction accessibilityAction3 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getPageLeft());
                if (accessibilityAction3 != null) {
                    info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionPageLeft, accessibilityAction3.getLabel()));
                }
                AccessibilityAction accessibilityAction4 = (AccessibilityAction) SemanticsConfigurationKt.getOrNull(semanticsNode.getUnmergedConfig(), SemanticsActions.INSTANCE.getPageRight());
                if (accessibilityAction4 != null) {
                    info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(R.id.accessibilityActionPageRight, accessibilityAction4.getLabel()));
                }
            }
        }
    }
}
