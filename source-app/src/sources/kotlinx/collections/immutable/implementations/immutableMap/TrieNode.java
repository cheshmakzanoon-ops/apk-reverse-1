package kotlinx.collections.immutable.implementations.immutableMap;

import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.IntIterator;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function5;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.IntProgression;
import kotlin.ranges.RangesKt;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;
import kotlinx.collections.immutable.internal.DeltaCounter;
import kotlinx.collections.immutable.internal.MutabilityOwnership;

@Metadata(m17d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0011\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\b\u001b\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b(\b\u0000\u0018\u0000 \u0085\u0001*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022\u00020\u0003:\u0004\u0085\u0001\u0086\u0001B'\b\u0016\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u000e\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\b¢\u0006\u0002\u0010\tB/\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u000e\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\b\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fJ\u0091\u0001\u0010\u0011\u001a\u00020\u00122\u0081\u0001\u0010\u0013\u001a}\u0012\u001f\u0012\u001d\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0000¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0017\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0018\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0019\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0004\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0006\u0012\u0004\u0012\u00020\u00120\u0014H\u0000¢\u0006\u0002\b\u001aJ\u009c\u0001\u0010\u0011\u001a\u00020\u00122\u0081\u0001\u0010\u0013\u001a}\u0012\u001f\u0012\u001d\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0000¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0017\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0018\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0019\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0004\u0012\u0013\u0012\u00110\u0005¢\u0006\f\b\u0015\u0012\b\b\u0016\u0012\u0004\b\b(\u0006\u0012\u0004\u0012\u00020\u00120\u00142\u0006\u0010\u0019\u001a\u00020\u00052\u0006\u0010\u0018\u001a\u00020\u0005H\u0002J\u0014\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u001cH\u0002J\u0014\u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u001cH\u0002JO\u0010\u001e\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\b2\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0006\u0010!\u001a\u00020\u00052\u0006\u0010\"\u001a\u00028\u00002\u0006\u0010#\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u00052\b\u0010$\u001a\u0004\u0018\u00010\u000bH\u0002¢\u0006\u0002\u0010%J\b\u0010&\u001a\u00020\u0005H\u0002J\u0015\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010*J\u0017\u0010+\u001a\u0004\u0018\u00018\u00012\u0006\u0010)\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010,J\u0012\u0010-\u001a\u00020\u00052\b\u0010)\u001a\u0004\u0018\u00010\u0003H\u0002J+\u0010.\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u001c2\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u0001H\u0002¢\u0006\u0002\u00100J#\u00101\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010)\u001a\u00028\u0000H\u0002¢\u0006\u0002\u00102J+\u00101\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u0001H\u0002¢\u0006\u0002\u00103J\u001e\u00104\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00105\u001a\u00020\u0005H\u0002J#\u00106\u001a\u00020(2\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010\u0018\u001a\u00020\u0005¢\u0006\u0002\u00108J\u001c\u00109\u001a\u00020(2\u0012\u0010:\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0000H\u0002J\r\u0010;\u001a\u00020\u0005H\u0000¢\u0006\u0002\b<J\u0015\u0010=\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0000¢\u0006\u0002\b>JG\u0010?\u001a\u00020(\"\u0004\b\u0002\u0010@\"\u0004\b\u0003\u0010A2\u0012\u0010B\u001a\u000e\u0012\u0004\u0012\u0002H@\u0012\u0004\u0012\u0002HA0\u00002\u0018\u0010C\u001a\u0014\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u0002HA\u0012\u0004\u0012\u00020(0DH\u0000¢\u0006\u0002\bEJ%\u0010F\u001a\u0004\u0018\u00018\u00012\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010\u0018\u001a\u00020\u0005¢\u0006\u0002\u0010GJ\u0015\u0010H\u001a\u00020(2\u0006\u0010 \u001a\u00020\u0005H\u0000¢\u0006\u0002\bIJ\u0010\u0010J\u001a\u00020(2\u0006\u0010 \u001a\u00020\u0005H\u0002J1\u0010K\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010 \u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u0001H\u0002¢\u0006\u0002\u0010LJ\u0015\u0010M\u001a\u00028\u00002\u0006\u0010\u001f\u001a\u00020\u0005H\u0002¢\u0006\u0002\u0010NJ[\u0010O\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010P\u001a\u00020\u00052\u0006\u0010Q\u001a\u00028\u00002\u0006\u0010R\u001a\u00028\u00012\u0006\u0010S\u001a\u00020\u00052\u0006\u0010T\u001a\u00028\u00002\u0006\u0010U\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u00052\b\u0010$\u001a\u0004\u0018\u00010\u000bH\u0002¢\u0006\u0002\u0010VJI\u0010W\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0006\u0010!\u001a\u00020\u00052\u0006\u0010\"\u001a\u00028\u00002\u0006\u0010#\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u0005H\u0002¢\u0006\u0002\u0010XJ=\u0010Y\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002¢\u0006\u0002\u0010\\J8\u0010]\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010:\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010^\u001a\u00020_2\u0006\u0010$\u001a\u00020\u000bH\u0002J?\u0010`\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002¢\u0006\u0002\u0010\\J7\u0010`\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010)\u001a\u00028\u00002\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002¢\u0006\u0002\u0010aJ2\u0010b\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00105\u001a\u00020\u00052\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002J9\u0010c\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010 \u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0006\u0010$\u001a\u00020\u000bH\u0002¢\u0006\u0002\u0010dJQ\u0010e\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0006\u0010!\u001a\u00020\u00052\u0006\u0010\"\u001a\u00028\u00002\u0006\u0010#\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u00052\u0006\u0010$\u001a\u00020\u000bH\u0002¢\u0006\u0002\u0010fJK\u0010g\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u00052\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[¢\u0006\u0002\u0010hJJ\u0010i\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010:\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\u0018\u001a\u00020\u00052\u0006\u0010^\u001a\u00020_2\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[JT\u0010j\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010:\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010 \u001a\u00020\u00052\u0006\u0010\u0018\u001a\u00020\u00052\u0006\u0010^\u001a\u00020_2\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002JM\u0010k\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u00052\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[¢\u0006\u0002\u0010hJE\u0010k\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010\u0018\u001a\u00020\u00052\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[¢\u0006\u0002\u0010lJ:\u0010m\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002J.\u0010n\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0006\u0010$\u001a\u00020\u000bH\u0002JX\u0010p\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0012\u0010q\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0014\u0010r\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0006\u0010$\u001a\u00020\u000bH\u0002J8\u0010s\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0012\u0010r\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010$\u001a\u00020\u000bH\u0002J=\u0010t\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010/\u001a\u00028\u00012\u0012\u0010Z\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010[H\u0002¢\u0006\u0002\u0010uJ!\u0010v\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010o\u001a\u00020\u0005H\u0000¢\u0006\u0002\bwJ\u0015\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0000¢\u0006\u0002\bxJ9\u0010y\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u001c2\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u0005¢\u0006\u0002\u0010zJ9\u0010{\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u00012\u0006\u0010\u0018\u001a\u00020\u0005¢\u0006\u0002\u0010|J1\u0010{\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u00107\u001a\u00020\u00052\u0006\u0010)\u001a\u00028\u00002\u0006\u0010\u0018\u001a\u00020\u0005¢\u0006\u0002\u0010}J&\u0010~\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0002J&\u0010\u007f\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0002JQ\u0010\u0080\u0001\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0012\u0010q\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0014\u0010r\u001a\u0010\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0002J9\u0010\u0081\u0001\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010o\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u00052\u0012\u0010r\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0000H\u0002J+\u0010\u0082\u0001\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\u001f\u001a\u00020\u00052\u0006\u0010/\u001a\u00028\u0001H\u0002¢\u0006\u0003\u0010\u0083\u0001J\u0016\u0010\u0084\u0001\u001a\u00028\u00012\u0006\u0010\u001f\u001a\u00020\u0005H\u0002¢\u0006\u0002\u0010NR0\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\b2\u000e\u0010\r\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\b@BX\u0080\u000e¢\u0006\n\n\u0002\u0010\u0010\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\n\u001a\u0004\u0018\u00010\u000bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0087\u0001"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "K", "V", "", "dataMap", "", "nodeMap", "buffer", "", "(II[Ljava/lang/Object;)V", "ownedBy", "Lkotlinx/collections/immutable/internal/MutabilityOwnership;", "(II[Ljava/lang/Object;Lkotlinx/collections/immutable/internal/MutabilityOwnership;)V", "<set-?>", "getBuffer$kotlinx_collections_immutable", "()[Ljava/lang/Object;", "[Ljava/lang/Object;", "accept", "", "visitor", "Lkotlin/Function5;", "Lkotlin/ParameterName;", "name", "node", "shift", "hash", "accept$kotlinx_collections_immutable", "asInsertResult", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode$ModificationResult;", "asUpdateResult", "bufferMoveEntryToNode", "keyIndex", "positionMask", "newKeyHash", "newKey", "newValue", "owner", "(IIILjava/lang/Object;Ljava/lang/Object;ILkotlinx/collections/immutable/internal/MutabilityOwnership;)[Ljava/lang/Object;", "calculateSize", "collisionContainsKey", "", "key", "(Ljava/lang/Object;)Z", "collisionGet", "(Ljava/lang/Object;)Ljava/lang/Object;", "collisionKeyIndex", "collisionPut", "value", "(Ljava/lang/Object;Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode$ModificationResult;", "collisionRemove", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "(Ljava/lang/Object;Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "collisionRemoveEntryAtIndex", "i", "containsKey", "keyHash", "(ILjava/lang/Object;I)Z", "elementsIdentityEquals", "otherNode", "entryCount", "entryCount$kotlinx_collections_immutable", "entryKeyIndex", "entryKeyIndex$kotlinx_collections_immutable", "equalsWith", "K1", "V1", "that", "equalityComparator", "Lkotlin/Function2;", "equalsWith$kotlinx_collections_immutable", "get", "(ILjava/lang/Object;I)Ljava/lang/Object;", "hasEntryAt", "hasEntryAt$kotlinx_collections_immutable", "hasNodeAt", "insertEntryAt", "(ILjava/lang/Object;Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "keyAtIndex", "(I)Ljava/lang/Object;", "makeNode", "keyHash1", "key1", "value1", "keyHash2", "key2", "value2", "(ILjava/lang/Object;Ljava/lang/Object;ILjava/lang/Object;Ljava/lang/Object;ILkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "moveEntryToNode", "(IIILjava/lang/Object;Ljava/lang/Object;I)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutableCollisionPut", "mutator", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "(Ljava/lang/Object;Ljava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutableCollisionPutAll", "intersectionCounter", "Lkotlinx/collections/immutable/internal/DeltaCounter;", "mutableCollisionRemove", "(Ljava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutableCollisionRemoveEntryAtIndex", "mutableInsertEntryAt", "(ILjava/lang/Object;Ljava/lang/Object;Lkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutableMoveEntryToNode", "(IIILjava/lang/Object;Ljava/lang/Object;ILkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutablePut", "(ILjava/lang/Object;Ljava/lang/Object;ILkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutablePutAll", "mutablePutAllFromOtherNodeCell", "mutableRemove", "(ILjava/lang/Object;ILkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "mutableRemoveEntryAtIndex", "mutableRemoveNodeAtIndex", "nodeIndex", "mutableReplaceNode", "targetNode", "newNode", "mutableUpdateNodeAtIndex", "mutableUpdateValueAtIndex", "(ILjava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "nodeAtIndex", "nodeAtIndex$kotlinx_collections_immutable", "nodeIndex$kotlinx_collections_immutable", "put", "(ILjava/lang/Object;Ljava/lang/Object;I)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode$ModificationResult;", "remove", "(ILjava/lang/Object;Ljava/lang/Object;I)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "(ILjava/lang/Object;I)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "removeEntryAtIndex", "removeNodeAtIndex", "replaceNode", "updateNodeAtIndex", "updateValueAtIndex", "(ILjava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "valueAtKeyIndex", "Companion", "ModificationResult", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class TrieNode<K, V> {

    public static final Companion INSTANCE = new Companion(null);
    private static final TrieNode EMPTY = new TrieNode(0, 0, new Object[0]);
    private Object[] buffer;
    private int dataMap;
    private int nodeMap;
    private final MutabilityOwnership ownedBy;

    public TrieNode(int i, int i2, Object[] buffer, MutabilityOwnership mutabilityOwnership) {
        Intrinsics.checkNotNullParameter(buffer, "buffer");
        this.dataMap = i;
        this.nodeMap = i2;
        this.ownedBy = mutabilityOwnership;
        this.buffer = buffer;
    }

    public TrieNode(int i, int i2, Object[] buffer) {
        this(i, i2, buffer, null);
        Intrinsics.checkNotNullParameter(buffer, "buffer");
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u0000*\u0004\b\u0002\u0010\u0001*\u0004\b\u0003\u0010\u00022\u00020\u0003B!\u0012\u0012\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00028\u0002\u0012\u0004\u0012\u00028\u00030\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJD\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00028\u0002\u0012\u0004\u0012\u00028\u00030\u00002*\u0010\u0010\u001a&\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0002\u0012\u0004\u0012\u00028\u00030\u0005\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0002\u0012\u0004\u0012\u00028\u00030\u00050\u0011H\u0086\bø\u0001\u0000R&\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00028\u0002\u0012\u0004\u0012\u00028\u00030\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e\u0082\u0002\u0007\n\u0005\b\u009920\u0001¨\u0006\u0012"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode$ModificationResult;", "K", "V", "", "node", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "sizeDelta", "", "(Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;I)V", "getNode", "()Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "setNode", "(Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;)V", "getSizeDelta", "()I", "replaceNode", "operation", "Lkotlin/Function1;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class ModificationResult<K, V> {
        private TrieNode<K, V> node;
        private final int sizeDelta;

        public ModificationResult(TrieNode<K, V> node, int i) {
            Intrinsics.checkNotNullParameter(node, "node");
            this.node = node;
            this.sizeDelta = i;
        }

        public final TrieNode<K, V> getNode() {
            return this.node;
        }

        public final int getSizeDelta() {
            return this.sizeDelta;
        }

        public final void setNode(TrieNode<K, V> trieNode) {
            Intrinsics.checkNotNullParameter(trieNode, "<set-?>");
            this.node = trieNode;
        }

        public final ModificationResult<K, V> replaceNode(Function1<? super TrieNode<K, V>, TrieNode<K, V>> operation) {
            Intrinsics.checkNotNullParameter(operation, "operation");
            setNode(operation.invoke(getNode()));
            return this;
        }
    }

    private final ModificationResult<K, V> asInsertResult() {
        return new ModificationResult<>(this, 1);
    }

    private final ModificationResult<K, V> asUpdateResult() {
        return new ModificationResult<>(this, 0);
    }

    public final Object[] getBuffer() {
        return this.buffer;
    }

    public final int entryCount$kotlinx_collections_immutable() {
        return Integer.bitCount(this.dataMap);
    }

    public final boolean hasEntryAt$kotlinx_collections_immutable(int positionMask) {
        return (positionMask & this.dataMap) != 0;
    }

    private final boolean hasNodeAt(int positionMask) {
        return (positionMask & this.nodeMap) != 0;
    }

    public final int entryKeyIndex$kotlinx_collections_immutable(int positionMask) {
        return Integer.bitCount((positionMask - 1) & this.dataMap) * 2;
    }

    public final int nodeIndex$kotlinx_collections_immutable(int positionMask) {
        return (this.buffer.length - 1) - Integer.bitCount((positionMask - 1) & this.nodeMap);
    }

    private final K keyAtIndex(int keyIndex) {
        return (K) this.buffer[keyIndex];
    }

    private final V valueAtKeyIndex(int keyIndex) {
        return (V) this.buffer[keyIndex + 1];
    }

    public final TrieNode<K, V> nodeAtIndex$kotlinx_collections_immutable(int nodeIndex) {
        Object obj = this.buffer[nodeIndex];
        if (obj != null) {
            return (TrieNode) obj;
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableMap.TrieNode<K of kotlinx.collections.immutable.implementations.immutableMap.TrieNode, V of kotlinx.collections.immutable.implementations.immutableMap.TrieNode>");
    }

    private final TrieNode<K, V> insertEntryAt(int positionMask, K key, V value) {
        return new TrieNode<>(positionMask | this.dataMap, this.nodeMap, TrieNodeKt.insertEntryAtIndex(this.buffer, entryKeyIndex$kotlinx_collections_immutable(positionMask), key, value));
    }

    private final TrieNode<K, V> mutableInsertEntryAt(int positionMask, K key, V value, MutabilityOwnership owner) {
        int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(positionMask);
        if (this.ownedBy == owner) {
            this.buffer = TrieNodeKt.insertEntryAtIndex(this.buffer, iEntryKeyIndex$kotlinx_collections_immutable, key, value);
            this.dataMap = positionMask | this.dataMap;
            return this;
        }
        return new TrieNode<>(positionMask | this.dataMap, this.nodeMap, TrieNodeKt.insertEntryAtIndex(this.buffer, iEntryKeyIndex$kotlinx_collections_immutable, key, value), owner);
    }

    private final TrieNode<K, V> updateValueAtIndex(int keyIndex, V value) {
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        objArrCopyOf[keyIndex + 1] = value;
        return new TrieNode<>(this.dataMap, this.nodeMap, objArrCopyOf);
    }

    private final TrieNode<K, V> mutableUpdateValueAtIndex(int keyIndex, V value, PersistentHashMapBuilder<K, V> mutator) {
        if (this.ownedBy == mutator.getOwnership()) {
            this.buffer[keyIndex + 1] = value;
            return this;
        }
        mutator.setModCount$kotlinx_collections_immutable(mutator.getModCount() + 1);
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        objArrCopyOf[keyIndex + 1] = value;
        return new TrieNode<>(this.dataMap, this.nodeMap, objArrCopyOf, mutator.getOwnership());
    }

    private final TrieNode<K, V> updateNodeAtIndex(int nodeIndex, int positionMask, TrieNode<K, V> newNode) {
        Object[] objArr = newNode.buffer;
        if (objArr.length == 2 && newNode.nodeMap == 0) {
            if (this.buffer.length == 1) {
                newNode.dataMap = this.nodeMap;
                return newNode;
            }
            return new TrieNode<>(this.dataMap ^ positionMask, positionMask ^ this.nodeMap, TrieNodeKt.replaceNodeWithEntry(this.buffer, nodeIndex, entryKeyIndex$kotlinx_collections_immutable(positionMask), objArr[0], objArr[1]));
        }
        Object[] objArr2 = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr2, objArr2.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        objArrCopyOf[nodeIndex] = newNode;
        return new TrieNode<>(this.dataMap, this.nodeMap, objArrCopyOf);
    }

    private final TrieNode<K, V> mutableUpdateNodeAtIndex(int nodeIndex, TrieNode<K, V> newNode, MutabilityOwnership owner) {
        CommonFunctionsKt.m1793assert(newNode.ownedBy == owner);
        Object[] objArr = this.buffer;
        if (objArr.length == 1 && newNode.buffer.length == 2 && newNode.nodeMap == 0) {
            newNode.dataMap = this.nodeMap;
            return newNode;
        }
        if (this.ownedBy == owner) {
            objArr[nodeIndex] = newNode;
            return this;
        }
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        objArrCopyOf[nodeIndex] = newNode;
        return new TrieNode<>(this.dataMap, this.nodeMap, objArrCopyOf, owner);
    }

    private final TrieNode<K, V> removeNodeAtIndex(int nodeIndex, int positionMask) {
        Object[] objArr = this.buffer;
        if (objArr.length == 1) {
            return null;
        }
        return new TrieNode<>(this.dataMap, positionMask ^ this.nodeMap, TrieNodeKt.removeNodeAtIndex(objArr, nodeIndex));
    }

    private final TrieNode<K, V> mutableRemoveNodeAtIndex(int nodeIndex, int positionMask, MutabilityOwnership owner) {
        Object[] objArr = this.buffer;
        if (objArr.length == 1) {
            return null;
        }
        if (this.ownedBy == owner) {
            this.buffer = TrieNodeKt.removeNodeAtIndex(objArr, nodeIndex);
            this.nodeMap ^= positionMask;
            return this;
        }
        return new TrieNode<>(this.dataMap, positionMask ^ this.nodeMap, TrieNodeKt.removeNodeAtIndex(objArr, nodeIndex), owner);
    }

    private final Object[] bufferMoveEntryToNode(int keyIndex, int positionMask, int newKeyHash, K newKey, V newValue, int shift, MutabilityOwnership owner) {
        K kKeyAtIndex = keyAtIndex(keyIndex);
        return TrieNodeKt.replaceEntryWithNode(this.buffer, keyIndex, nodeIndex$kotlinx_collections_immutable(positionMask) + 1, makeNode(kKeyAtIndex == null ? 0 : kKeyAtIndex.hashCode(), kKeyAtIndex, valueAtKeyIndex(keyIndex), newKeyHash, newKey, newValue, shift + 5, owner));
    }

    private final TrieNode<K, V> moveEntryToNode(int keyIndex, int positionMask, int newKeyHash, K newKey, V newValue, int shift) {
        return new TrieNode<>(this.dataMap ^ positionMask, positionMask | this.nodeMap, bufferMoveEntryToNode(keyIndex, positionMask, newKeyHash, newKey, newValue, shift, null));
    }

    private final TrieNode<K, V> mutableMoveEntryToNode(int keyIndex, int positionMask, int newKeyHash, K newKey, V newValue, int shift, MutabilityOwnership owner) {
        if (this.ownedBy == owner) {
            this.buffer = bufferMoveEntryToNode(keyIndex, positionMask, newKeyHash, newKey, newValue, shift, owner);
            this.dataMap ^= positionMask;
            this.nodeMap |= positionMask;
            return this;
        }
        return new TrieNode<>(this.dataMap ^ positionMask, positionMask | this.nodeMap, bufferMoveEntryToNode(keyIndex, positionMask, newKeyHash, newKey, newValue, shift, owner), owner);
    }

    private final TrieNode<K, V> makeNode(int keyHash1, K key1, V value1, int keyHash2, K key2, V value2, int shift, MutabilityOwnership owner) {
        Object[] objArr;
        if (shift > 30) {
            return new TrieNode<>(0, 0, new Object[]{key1, value1, key2, value2}, owner);
        }
        int iIndexSegment = TrieNodeKt.indexSegment(keyHash1, shift);
        int iIndexSegment2 = TrieNodeKt.indexSegment(keyHash2, shift);
        if (iIndexSegment != iIndexSegment2) {
            if (iIndexSegment < iIndexSegment2) {
                objArr = new Object[]{key1, value1, key2, value2};
            } else {
                objArr = new Object[]{key2, value2, key1, value1};
            }
            return new TrieNode<>((1 << iIndexSegment) | (1 << iIndexSegment2), 0, objArr, owner);
        }
        return new TrieNode<>(0, 1 << iIndexSegment, new Object[]{makeNode(keyHash1, key1, value1, keyHash2, key2, value2, shift + 5, owner)}, owner);
    }

    private final TrieNode<K, V> removeEntryAtIndex(int keyIndex, int positionMask) {
        Object[] objArr = this.buffer;
        if (objArr.length == 2) {
            return null;
        }
        return new TrieNode<>(positionMask ^ this.dataMap, this.nodeMap, TrieNodeKt.removeEntryAtIndex(objArr, keyIndex));
    }

    private final TrieNode<K, V> mutableRemoveEntryAtIndex(int keyIndex, int positionMask, PersistentHashMapBuilder<K, V> mutator) {
        mutator.setSize(mutator.size() - 1);
        mutator.setOperationResult$kotlinx_collections_immutable(valueAtKeyIndex(keyIndex));
        if (this.buffer.length == 2) {
            return null;
        }
        if (this.ownedBy == mutator.getOwnership()) {
            this.buffer = TrieNodeKt.removeEntryAtIndex(this.buffer, keyIndex);
            this.dataMap ^= positionMask;
            return this;
        }
        return new TrieNode<>(positionMask ^ this.dataMap, this.nodeMap, TrieNodeKt.removeEntryAtIndex(this.buffer, keyIndex), mutator.getOwnership());
    }

    private final TrieNode<K, V> collisionRemoveEntryAtIndex(int i) {
        Object[] objArr = this.buffer;
        if (objArr.length == 2) {
            return null;
        }
        return new TrieNode<>(0, 0, TrieNodeKt.removeEntryAtIndex(objArr, i));
    }

    private final TrieNode<K, V> mutableCollisionRemoveEntryAtIndex(int i, PersistentHashMapBuilder<K, V> mutator) {
        mutator.setSize(mutator.size() - 1);
        mutator.setOperationResult$kotlinx_collections_immutable(valueAtKeyIndex(i));
        if (this.buffer.length == 2) {
            return null;
        }
        if (this.ownedBy == mutator.getOwnership()) {
            this.buffer = TrieNodeKt.removeEntryAtIndex(this.buffer, i);
            return this;
        }
        return new TrieNode<>(0, 0, TrieNodeKt.removeEntryAtIndex(this.buffer, i), mutator.getOwnership());
    }

    private final int collisionKeyIndex(Object key) {
        IntProgression intProgressionStep = RangesKt.step(RangesKt.until(0, this.buffer.length), 2);
        int first = intProgressionStep.getFirst();
        int last = intProgressionStep.getLast();
        int step = intProgressionStep.getStep();
        if ((step <= 0 || first > last) && (step >= 0 || last > first)) {
            return -1;
        }
        while (true) {
            int i = first + step;
            if (Intrinsics.areEqual(key, keyAtIndex(first))) {
                return first;
            }
            if (first == last) {
                return -1;
            }
            first = i;
        }
    }

    private final boolean collisionContainsKey(K key) {
        return collisionKeyIndex(key) != -1;
    }

    private final V collisionGet(K key) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        if (iCollisionKeyIndex != -1) {
            return valueAtKeyIndex(iCollisionKeyIndex);
        }
        return null;
    }

    private final ModificationResult<K, V> collisionPut(K key, V value) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        if (iCollisionKeyIndex != -1) {
            if (value == valueAtKeyIndex(iCollisionKeyIndex)) {
                return null;
            }
            Object[] objArr = this.buffer;
            Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
            objArrCopyOf[iCollisionKeyIndex + 1] = value;
            return new TrieNode(0, 0, objArrCopyOf).asUpdateResult();
        }
        return new TrieNode(0, 0, TrieNodeKt.insertEntryAtIndex(this.buffer, 0, key, value)).asInsertResult();
    }

    private final TrieNode<K, V> mutableCollisionPut(K key, V value, PersistentHashMapBuilder<K, V> mutator) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        if (iCollisionKeyIndex != -1) {
            mutator.setOperationResult$kotlinx_collections_immutable(valueAtKeyIndex(iCollisionKeyIndex));
            if (this.ownedBy == mutator.getOwnership()) {
                this.buffer[iCollisionKeyIndex + 1] = value;
                return this;
            }
            mutator.setModCount$kotlinx_collections_immutable(mutator.getModCount() + 1);
            Object[] objArr = this.buffer;
            Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
            objArrCopyOf[iCollisionKeyIndex + 1] = value;
            return new TrieNode<>(0, 0, objArrCopyOf, mutator.getOwnership());
        }
        mutator.setSize(mutator.size() + 1);
        return new TrieNode<>(0, 0, TrieNodeKt.insertEntryAtIndex(this.buffer, 0, key, value), mutator.getOwnership());
    }

    private final TrieNode<K, V> collisionRemove(K key) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        return iCollisionKeyIndex != -1 ? collisionRemoveEntryAtIndex(iCollisionKeyIndex) : this;
    }

    private final TrieNode<K, V> mutableCollisionRemove(K key, PersistentHashMapBuilder<K, V> mutator) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        return iCollisionKeyIndex != -1 ? mutableCollisionRemoveEntryAtIndex(iCollisionKeyIndex, mutator) : this;
    }

    private final TrieNode<K, V> collisionRemove(K key, V value) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        return (iCollisionKeyIndex == -1 || !Intrinsics.areEqual(value, valueAtKeyIndex(iCollisionKeyIndex))) ? this : collisionRemoveEntryAtIndex(iCollisionKeyIndex);
    }

    private final TrieNode<K, V> mutableCollisionRemove(K key, V value, PersistentHashMapBuilder<K, V> mutator) {
        int iCollisionKeyIndex = collisionKeyIndex(key);
        return (iCollisionKeyIndex == -1 || !Intrinsics.areEqual(value, valueAtKeyIndex(iCollisionKeyIndex))) ? this : mutableCollisionRemoveEntryAtIndex(iCollisionKeyIndex, mutator);
    }

    private final TrieNode<K, V> mutableCollisionPutAll(TrieNode<K, V> otherNode, DeltaCounter intersectionCounter, MutabilityOwnership owner) {
        CommonFunctionsKt.m1793assert(this.nodeMap == 0);
        CommonFunctionsKt.m1793assert(this.dataMap == 0);
        CommonFunctionsKt.m1793assert(otherNode.nodeMap == 0);
        CommonFunctionsKt.m1793assert(otherNode.dataMap == 0);
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length + otherNode.buffer.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        int length = this.buffer.length;
        IntProgression intProgressionStep = RangesKt.step(RangesKt.until(0, otherNode.buffer.length), 2);
        int first = intProgressionStep.getFirst();
        int last = intProgressionStep.getLast();
        int step = intProgressionStep.getStep();
        if ((step > 0 && first <= last) || (step < 0 && last <= first)) {
            while (true) {
                int i = first + step;
                if (!collisionContainsKey(otherNode.buffer[first])) {
                    Object[] objArr2 = otherNode.buffer;
                    objArrCopyOf[length] = objArr2[first];
                    objArrCopyOf[length + 1] = objArr2[first + 1];
                    length += 2;
                } else {
                    intersectionCounter.setCount(intersectionCounter.getCount() + 1);
                }
                if (first == last) {
                    break;
                }
                first = i;
            }
        }
        if (length == this.buffer.length) {
            return this;
        }
        if (length == otherNode.buffer.length) {
            return otherNode;
        }
        if (length == objArrCopyOf.length) {
            return new TrieNode<>(0, 0, objArrCopyOf, owner);
        }
        Object[] objArrCopyOf2 = Arrays.copyOf(objArrCopyOf, length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf2, "copyOf(this, newSize)");
        return new TrieNode<>(0, 0, objArrCopyOf2, owner);
    }

    private final TrieNode<K, V> mutablePutAllFromOtherNodeCell(TrieNode<K, V> otherNode, int positionMask, int shift, DeltaCounter intersectionCounter, PersistentHashMapBuilder<K, V> mutator) {
        if (hasNodeAt(positionMask)) {
            TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(nodeIndex$kotlinx_collections_immutable(positionMask));
            if (otherNode.hasNodeAt(positionMask)) {
                return trieNodeNodeAtIndex$kotlinx_collections_immutable.mutablePutAll(otherNode.nodeAtIndex$kotlinx_collections_immutable(otherNode.nodeIndex$kotlinx_collections_immutable(positionMask)), shift + 5, intersectionCounter, mutator);
            }
            if (!otherNode.hasEntryAt$kotlinx_collections_immutable(positionMask)) {
                return trieNodeNodeAtIndex$kotlinx_collections_immutable;
            }
            int iEntryKeyIndex$kotlinx_collections_immutable = otherNode.entryKeyIndex$kotlinx_collections_immutable(positionMask);
            K kKeyAtIndex = otherNode.keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable);
            V vValueAtKeyIndex = otherNode.valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable);
            int size = mutator.size();
            TrieNode<K, V> trieNodeMutablePut = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutablePut(kKeyAtIndex != null ? kKeyAtIndex.hashCode() : 0, kKeyAtIndex, vValueAtKeyIndex, shift + 5, mutator);
            if (mutator.size() != size) {
                return trieNodeMutablePut;
            }
            intersectionCounter.setCount(intersectionCounter.getCount() + 1);
            return trieNodeMutablePut;
        }
        if (otherNode.hasNodeAt(positionMask)) {
            TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable2 = otherNode.nodeAtIndex$kotlinx_collections_immutable(otherNode.nodeIndex$kotlinx_collections_immutable(positionMask));
            if (hasEntryAt$kotlinx_collections_immutable(positionMask)) {
                int iEntryKeyIndex$kotlinx_collections_immutable2 = entryKeyIndex$kotlinx_collections_immutable(positionMask);
                K kKeyAtIndex2 = keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable2);
                int i = shift + 5;
                if (!trieNodeNodeAtIndex$kotlinx_collections_immutable2.containsKey(kKeyAtIndex2 == null ? 0 : kKeyAtIndex2.hashCode(), kKeyAtIndex2, i)) {
                    return trieNodeNodeAtIndex$kotlinx_collections_immutable2.mutablePut(kKeyAtIndex2 != null ? kKeyAtIndex2.hashCode() : 0, kKeyAtIndex2, valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable2), i, mutator);
                }
                intersectionCounter.setCount(intersectionCounter.getCount() + 1);
            }
            return trieNodeNodeAtIndex$kotlinx_collections_immutable2;
        }
        int iEntryKeyIndex$kotlinx_collections_immutable3 = entryKeyIndex$kotlinx_collections_immutable(positionMask);
        K kKeyAtIndex3 = keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable3);
        V vValueAtKeyIndex2 = valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable3);
        int iEntryKeyIndex$kotlinx_collections_immutable4 = otherNode.entryKeyIndex$kotlinx_collections_immutable(positionMask);
        K kKeyAtIndex4 = otherNode.keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable4);
        return makeNode(kKeyAtIndex3 == null ? 0 : kKeyAtIndex3.hashCode(), kKeyAtIndex3, vValueAtKeyIndex2, kKeyAtIndex4 != null ? kKeyAtIndex4.hashCode() : 0, kKeyAtIndex4, otherNode.valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable4), shift + 5, mutator.getOwnership());
    }

    private final int calculateSize() {
        if (this.nodeMap == 0) {
            return this.buffer.length / 2;
        }
        int iBitCount = Integer.bitCount(this.dataMap);
        int length = this.buffer.length;
        for (int i = iBitCount * 2; i < length; i++) {
            iBitCount += nodeAtIndex$kotlinx_collections_immutable(i).calculateSize();
        }
        return iBitCount;
    }

    private final boolean elementsIdentityEquals(TrieNode<K, V> otherNode) {
        if (this == otherNode) {
            return true;
        }
        if (this.nodeMap != otherNode.nodeMap || this.dataMap != otherNode.dataMap) {
            return false;
        }
        int length = this.buffer.length;
        int i = 0;
        while (i < length) {
            int i2 = i + 1;
            if (this.buffer[i] != otherNode.buffer[i]) {
                return false;
            }
            i = i2;
        }
        return true;
    }

    public final boolean containsKey(int keyHash, K key, int shift) {
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            return Intrinsics.areEqual(key, keyAtIndex(entryKeyIndex$kotlinx_collections_immutable(iIndexSegment)));
        }
        if (!hasNodeAt(iIndexSegment)) {
            return false;
        }
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(nodeIndex$kotlinx_collections_immutable(iIndexSegment));
        if (shift == 30) {
            return trieNodeNodeAtIndex$kotlinx_collections_immutable.collisionContainsKey(key);
        }
        return trieNodeNodeAtIndex$kotlinx_collections_immutable.containsKey(keyHash, key, shift + 5);
    }

    public final V get(int keyHash, K key, int shift) {
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            if (Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable))) {
                return valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable);
            }
            return null;
        }
        if (!hasNodeAt(iIndexSegment)) {
            return null;
        }
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(nodeIndex$kotlinx_collections_immutable(iIndexSegment));
        if (shift == 30) {
            return trieNodeNodeAtIndex$kotlinx_collections_immutable.collisionGet(key);
        }
        return trieNodeNodeAtIndex$kotlinx_collections_immutable.get(keyHash, key, shift + 5);
    }

    public final TrieNode<K, V> mutablePutAll(TrieNode<K, V> otherNode, int shift, DeltaCounter intersectionCounter, PersistentHashMapBuilder<K, V> mutator) {
        Intrinsics.checkNotNullParameter(otherNode, "otherNode");
        Intrinsics.checkNotNullParameter(intersectionCounter, "intersectionCounter");
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        if (this == otherNode) {
            intersectionCounter.plusAssign(calculateSize());
            return this;
        }
        if (shift > 30) {
            return mutableCollisionPutAll(otherNode, intersectionCounter, mutator.getOwnership());
        }
        int i = this.nodeMap | otherNode.nodeMap;
        int i2 = this.dataMap;
        int i3 = otherNode.dataMap;
        int i4 = (i2 ^ i3) & (~i);
        int i5 = i2 & i3;
        int i6 = i4;
        while (i5 != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i5);
            if (Intrinsics.areEqual(keyAtIndex(entryKeyIndex$kotlinx_collections_immutable(iLowestOneBit)), otherNode.keyAtIndex(otherNode.entryKeyIndex$kotlinx_collections_immutable(iLowestOneBit)))) {
                i6 |= iLowestOneBit;
            } else {
                i |= iLowestOneBit;
            }
            i5 ^= iLowestOneBit;
        }
        if ((i & i6) != 0) {
            throw new IllegalStateException("Check failed.".toString());
        }
        TrieNode<K, V> trieNode = (Intrinsics.areEqual(this.ownedBy, mutator.getOwnership()) && this.dataMap == i6 && this.nodeMap == i) ? this : new TrieNode<>(i6, i, new Object[(Integer.bitCount(i6) * 2) + Integer.bitCount(i)]);
        int i7 = 0;
        int i8 = i;
        int i9 = 0;
        while (i8 != 0) {
            int iLowestOneBit2 = Integer.lowestOneBit(i8);
            trieNode.getBuffer()[(trieNode.getBuffer().length - 1) - i9] = mutablePutAllFromOtherNodeCell(otherNode, iLowestOneBit2, shift, intersectionCounter, mutator);
            i9++;
            i8 ^= iLowestOneBit2;
        }
        while (i6 != 0) {
            int iLowestOneBit3 = Integer.lowestOneBit(i6);
            int i10 = i7 * 2;
            if (!otherNode.hasEntryAt$kotlinx_collections_immutable(iLowestOneBit3)) {
                int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iLowestOneBit3);
                trieNode.getBuffer()[i10] = keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable);
                trieNode.getBuffer()[i10 + 1] = valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable);
            } else {
                int iEntryKeyIndex$kotlinx_collections_immutable2 = otherNode.entryKeyIndex$kotlinx_collections_immutable(iLowestOneBit3);
                trieNode.getBuffer()[i10] = otherNode.keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable2);
                trieNode.getBuffer()[i10 + 1] = otherNode.valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable2);
                if (hasEntryAt$kotlinx_collections_immutable(iLowestOneBit3)) {
                    intersectionCounter.setCount(intersectionCounter.getCount() + 1);
                }
            }
            i7++;
            i6 ^= iLowestOneBit3;
        }
        if (elementsIdentityEquals(trieNode)) {
            return this;
        }
        return otherNode.elementsIdentityEquals(trieNode) ? otherNode : trieNode;
    }

    public final ModificationResult<K, V> put(int keyHash, K key, V value, int shift) {
        ModificationResult<K, V> modificationResultPut;
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            if (Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable))) {
                if (valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable) == value) {
                    return null;
                }
                return updateValueAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, value).asUpdateResult();
            }
            return moveEntryToNode(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment, keyHash, key, value, shift).asInsertResult();
        }
        if (hasNodeAt(iIndexSegment)) {
            int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
            TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
            if (shift == 30) {
                modificationResultPut = trieNodeNodeAtIndex$kotlinx_collections_immutable.collisionPut(key, value);
                if (modificationResultPut == null) {
                    return null;
                }
            } else {
                modificationResultPut = trieNodeNodeAtIndex$kotlinx_collections_immutable.put(keyHash, key, value, shift + 5);
                if (modificationResultPut == null) {
                    return null;
                }
            }
            modificationResultPut.setNode(updateNodeAtIndex(iNodeIndex$kotlinx_collections_immutable, iIndexSegment, modificationResultPut.getNode()));
            return modificationResultPut;
        }
        return insertEntryAt(iIndexSegment, key, value).asInsertResult();
    }

    public final TrieNode<K, V> mutablePut(int keyHash, K key, V value, int shift, PersistentHashMapBuilder<K, V> mutator) {
        TrieNode<K, V> trieNodeMutablePut;
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            if (Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable))) {
                mutator.setOperationResult$kotlinx_collections_immutable(valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable));
                return valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable) == value ? this : mutableUpdateValueAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, value, mutator);
            }
            mutator.setSize(mutator.size() + 1);
            return mutableMoveEntryToNode(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment, keyHash, key, value, shift, mutator.getOwnership());
        }
        if (hasNodeAt(iIndexSegment)) {
            int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
            TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
            if (shift == 30) {
                trieNodeMutablePut = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutableCollisionPut(key, value, mutator);
            } else {
                trieNodeMutablePut = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutablePut(keyHash, key, value, shift + 5, mutator);
            }
            return trieNodeNodeAtIndex$kotlinx_collections_immutable == trieNodeMutablePut ? this : mutableUpdateNodeAtIndex(iNodeIndex$kotlinx_collections_immutable, trieNodeMutablePut, mutator.getOwnership());
        }
        mutator.setSize(mutator.size() + 1);
        return mutableInsertEntryAt(iIndexSegment, key, value, mutator.getOwnership());
    }

    public final TrieNode<K, V> remove(int keyHash, K key, int shift) {
        TrieNode<K, V> trieNodeRemove;
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            return Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable)) ? removeEntryAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment) : this;
        }
        if (!hasNodeAt(iIndexSegment)) {
            return this;
        }
        int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.collisionRemove(key);
        } else {
            trieNodeRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.remove(keyHash, key, shift + 5);
        }
        return replaceNode(trieNodeNodeAtIndex$kotlinx_collections_immutable, trieNodeRemove, iNodeIndex$kotlinx_collections_immutable, iIndexSegment);
    }

    private final TrieNode<K, V> replaceNode(TrieNode<K, V> targetNode, TrieNode<K, V> newNode, int nodeIndex, int positionMask) {
        if (newNode == null) {
            return removeNodeAtIndex(nodeIndex, positionMask);
        }
        return targetNode != newNode ? updateNodeAtIndex(nodeIndex, positionMask, newNode) : this;
    }

    public final TrieNode<K, V> mutableRemove(int keyHash, K key, int shift, PersistentHashMapBuilder<K, V> mutator) {
        TrieNode<K, V> trieNodeMutableRemove;
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            return Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable)) ? mutableRemoveEntryAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment, mutator) : this;
        }
        if (!hasNodeAt(iIndexSegment)) {
            return this;
        }
        int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeMutableRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutableCollisionRemove(key, mutator);
        } else {
            trieNodeMutableRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutableRemove(keyHash, key, shift + 5, mutator);
        }
        return mutableReplaceNode(trieNodeNodeAtIndex$kotlinx_collections_immutable, trieNodeMutableRemove, iNodeIndex$kotlinx_collections_immutable, iIndexSegment, mutator.getOwnership());
    }

    private final TrieNode<K, V> mutableReplaceNode(TrieNode<K, V> targetNode, TrieNode<K, V> newNode, int nodeIndex, int positionMask, MutabilityOwnership owner) {
        if (newNode == null) {
            return mutableRemoveNodeAtIndex(nodeIndex, positionMask, owner);
        }
        return targetNode != newNode ? mutableUpdateNodeAtIndex(nodeIndex, newNode, owner) : this;
    }

    public final TrieNode<K, V> remove(int keyHash, K key, V value, int shift) {
        TrieNode<K, V> trieNodeRemove;
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            return (Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable)) && Intrinsics.areEqual(value, valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable))) ? removeEntryAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment) : this;
        }
        if (!hasNodeAt(iIndexSegment)) {
            return this;
        }
        int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.collisionRemove(key, value);
        } else {
            trieNodeRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.remove(keyHash, key, value, shift + 5);
        }
        return replaceNode(trieNodeNodeAtIndex$kotlinx_collections_immutable, trieNodeRemove, iNodeIndex$kotlinx_collections_immutable, iIndexSegment);
    }

    public final TrieNode<K, V> mutableRemove(int keyHash, K key, V value, int shift, PersistentHashMapBuilder<K, V> mutator) {
        TrieNode<K, V> trieNodeMutableRemove;
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, shift);
        if (hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            int iEntryKeyIndex$kotlinx_collections_immutable = entryKeyIndex$kotlinx_collections_immutable(iIndexSegment);
            return (Intrinsics.areEqual(key, keyAtIndex(iEntryKeyIndex$kotlinx_collections_immutable)) && Intrinsics.areEqual(value, valueAtKeyIndex(iEntryKeyIndex$kotlinx_collections_immutable))) ? mutableRemoveEntryAtIndex(iEntryKeyIndex$kotlinx_collections_immutable, iIndexSegment, mutator) : this;
        }
        if (!hasNodeAt(iIndexSegment)) {
            return this;
        }
        int iNodeIndex$kotlinx_collections_immutable = nodeIndex$kotlinx_collections_immutable(iIndexSegment);
        TrieNode<K, V> trieNodeNodeAtIndex$kotlinx_collections_immutable = nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeMutableRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutableCollisionRemove(key, value, mutator);
        } else {
            trieNodeMutableRemove = trieNodeNodeAtIndex$kotlinx_collections_immutable.mutableRemove(keyHash, key, value, shift + 5, mutator);
        }
        return mutableReplaceNode(trieNodeNodeAtIndex$kotlinx_collections_immutable, trieNodeMutableRemove, iNodeIndex$kotlinx_collections_immutable, iIndexSegment, mutator.getOwnership());
    }

    public final <K1, V1> boolean equalsWith$kotlinx_collections_immutable(TrieNode<K1, V1> that, Function2<? super V, ? super V1, Boolean> equalityComparator) {
        int i;
        Intrinsics.checkNotNullParameter(that, "that");
        Intrinsics.checkNotNullParameter(equalityComparator, "equalityComparator");
        if (this == that) {
            return true;
        }
        int i2 = this.dataMap;
        if (i2 != that.dataMap || (i = this.nodeMap) != that.nodeMap) {
            return false;
        }
        if (i2 == 0 && i == 0) {
            Object[] objArr = this.buffer;
            if (objArr.length != that.buffer.length) {
                return false;
            }
            Iterable iterableStep = RangesKt.step(RangesKt.until(0, objArr.length), 2);
            if ((iterableStep instanceof Collection) && ((Collection) iterableStep).isEmpty()) {
                return true;
            }
            Iterator it = iterableStep.iterator();
            while (it.hasNext()) {
                int iNextInt = ((IntIterator) it).nextInt();
                K1 k1KeyAtIndex = that.keyAtIndex(iNextInt);
                V1 v1ValueAtKeyIndex = that.valueAtKeyIndex(iNextInt);
                int iCollisionKeyIndex = collisionKeyIndex(k1KeyAtIndex);
                if (!(iCollisionKeyIndex != -1 ? equalityComparator.invoke(valueAtKeyIndex(iCollisionKeyIndex), v1ValueAtKeyIndex).booleanValue() : false)) {
                    return false;
                }
            }
            return true;
        }
        int iBitCount = Integer.bitCount(i2) * 2;
        IntProgression intProgressionStep = RangesKt.step(RangesKt.until(0, iBitCount), 2);
        int first = intProgressionStep.getFirst();
        int last = intProgressionStep.getLast();
        int step = intProgressionStep.getStep();
        if ((step > 0 && first <= last) || (step < 0 && last <= first)) {
            while (true) {
                int i3 = first + step;
                if (!Intrinsics.areEqual(keyAtIndex(first), that.keyAtIndex(first)) || !equalityComparator.invoke(valueAtKeyIndex(first), that.valueAtKeyIndex(first)).booleanValue()) {
                    return false;
                }
                if (first == last) {
                    break;
                }
                first = i3;
            }
        }
        int length = this.buffer.length;
        while (iBitCount < length) {
            int i4 = iBitCount + 1;
            if (!nodeAtIndex$kotlinx_collections_immutable(iBitCount).equalsWith$kotlinx_collections_immutable(that.nodeAtIndex$kotlinx_collections_immutable(iBitCount), equalityComparator)) {
                return false;
            }
            iBitCount = i4;
        }
        return true;
    }

    public final void accept$kotlinx_collections_immutable(Function5<? super TrieNode<K, V>, ? super Integer, ? super Integer, ? super Integer, ? super Integer, Unit> visitor) {
        Intrinsics.checkNotNullParameter(visitor, "visitor");
        accept(visitor, 0, 0);
    }

    private final void accept(Function5<? super TrieNode<K, V>, ? super Integer, ? super Integer, ? super Integer, ? super Integer, Unit> visitor, int hash, int shift) {
        visitor.invoke(this, Integer.valueOf(shift), Integer.valueOf(hash), Integer.valueOf(this.dataMap), Integer.valueOf(this.nodeMap));
        int i = this.nodeMap;
        while (i != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i);
            nodeAtIndex$kotlinx_collections_immutable(nodeIndex$kotlinx_collections_immutable(iLowestOneBit)).accept(visitor, (Integer.numberOfTrailingZeros(iLowestOneBit) << shift) + hash, shift + 5);
            i -= iLowestOneBit;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0002\b\u0003\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R \u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u0004X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode$Companion;", "", "()V", "EMPTY", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "", "getEMPTY$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final TrieNode getEMPTY$kotlinx_collections_immutable() {
            return TrieNode.EMPTY;
        }
    }
}
