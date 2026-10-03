package kotlinx.coroutines.channels;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.concurrent.CancellationException;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.ExceptionsKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.IndexedValue;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.GlobalScope;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.track.data.TrackType;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import okhttp3.internal.http.StatusLine;

@Metadata(m17d1 = {"\u0000¶\u0001\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u001f\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010$\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\b\u0002\n\u0002\u0010!\n\u0000\n\u0002\u0010\"\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010#\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\u001aC\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00020\u00032\u001d\u0010\u0004\u001a\u0019\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00020\u0006\u0012\u0004\u0012\u0002H\u00010\u0005¢\u0006\u0002\b\u0007H\u0087\b¢\u0006\u0002\u0010\b\u001a2\u0010\t\u001a\u00020\n\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00032\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u00020\n0\u0005H\u0087H¢\u0006\u0002\u0010\f\u001aJ\u0010\r\u001a#\u0012\u0015\u0012\u0013\u0018\u00010\u000f¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(\u0012\u0012\u0004\u0012\u00020\n0\u0005j\u0002`\u000e2\u001a\u0010\u0013\u001a\u000e\u0012\n\b\u0001\u0012\u0006\u0012\u0002\b\u00030\u00060\u0014\"\u0006\u0012\u0002\b\u00030\u0006H\u0001¢\u0006\u0002\u0010\u0015\u001a&\u0010\u0016\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u0018H\u0087@¢\u0006\u0002\u0010\u0019\u001a(\u0010\u001a\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u0018H\u0087@¢\u0006\u0002\u0010\u0019\u001a\u001e\u0010\u001b\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a \u0010\u001d\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a&\u0010\u001e\u001a\u00020\u0018\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010\u001f\u001a\u0002H\u0002H\u0087@¢\u0006\u0002\u0010 \u001a\u001e\u0010!\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a&\u0010\"\u001a\u00020\u0018\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010\u001f\u001a\u0002H\u0002H\u0087@¢\u0006\u0002\u0010 \u001a \u0010#\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a\u001e\u0010$\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a \u0010%\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a0\u0010&\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010'\u001a\u00020\u00182\b\b\u0002\u0010(\u001a\u00020)H\u0007\u001aQ\u0010*\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010+\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020.0-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0007¢\u0006\u0002\u00100\u001aQ\u00101\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010+\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020.0-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0001¢\u0006\u0002\u00100\u001af\u00102\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)27\u0010+\u001a3\b\u0001\u0012\u0013\u0012\u00110\u0018¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(\u0017\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020.0-\u0012\u0006\u0012\u0004\u0018\u00010/03H\u0007¢\u0006\u0002\u00104\u001aQ\u00105\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010+\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020.0-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0007¢\u0006\u0002\u00100\u001a$\u00106\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\b\b\u0000\u0010\u0002*\u00020/*\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00020\u0006H\u0001\u001a>\u00107\u001a\u0002H8\"\b\b\u0000\u0010\u0002*\u00020/\"\u0010\b\u0001\u00108*\n\u0012\u0006\b\u0000\u0012\u0002H\u000209*\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00020\u00062\u0006\u0010:\u001a\u0002H8H\u0087@¢\u0006\u0002\u0010;\u001a<\u00107\u001a\u0002H8\"\b\b\u0000\u0010\u0002*\u00020/\"\u000e\b\u0001\u00108*\b\u0012\u0004\u0012\u0002H\u00020<*\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00020\u00062\u0006\u0010:\u001a\u0002H8H\u0087@¢\u0006\u0002\u0010=\u001a0\u0010>\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010'\u001a\u00020\u00182\b\b\u0002\u0010(\u001a\u00020)H\u0007\u001aQ\u0010?\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010+\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020.0-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0007¢\u0006\u0002\u00100\u001a6\u0010@\u001a\u0002H8\"\u0004\b\u0000\u0010\u0002\"\u000e\b\u0001\u00108*\b\u0012\u0004\u0012\u0002H\u00020<*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010:\u001a\u0002H8H\u0081@¢\u0006\u0002\u0010=\u001a8\u0010A\u001a\u0002H8\"\u0004\b\u0000\u0010\u0002\"\u0010\b\u0001\u00108*\n\u0012\u0006\b\u0000\u0012\u0002H\u000209*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u0006\u0010:\u001a\u0002H8H\u0081@¢\u0006\u0002\u0010;\u001a<\u0010B\u001a\u000e\u0012\u0004\u0012\u0002HD\u0012\u0004\u0012\u0002HE0C\"\u0004\b\u0000\u0010D\"\u0004\b\u0001\u0010E*\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u0002HD\u0012\u0004\u0012\u0002HE0F0\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001aR\u0010B\u001a\u0002HG\"\u0004\b\u0000\u0010D\"\u0004\b\u0001\u0010E\"\u0018\b\u0002\u0010G*\u0012\u0012\u0006\b\u0000\u0012\u0002HD\u0012\u0006\b\u0000\u0012\u0002HE0H*\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u0002HD\u0012\u0004\u0012\u0002HE0F0\u00062\u0006\u0010:\u001a\u0002HGH\u0081@¢\u0006\u0002\u0010I\u001a$\u0010J\u001a\b\u0012\u0004\u0012\u0002H\u00020K\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a$\u0010L\u001a\b\u0012\u0004\u0012\u0002H\u00020M\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a]\u0010N\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2(\u0010O\u001a$\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\u0010\u0012\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u00060-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0007¢\u0006\u0002\u00100\u001aW\u0010P\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010O\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0001¢\u0006\u0002\u00100\u001al\u0010Q\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)27\u0010O\u001a3\b\u0001\u0012\u0013\u0012\u00110\u0018¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(\u0017\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010-\u0012\u0006\u0012\u0004\u0018\u00010/03H\u0001¢\u0006\u0002\u00104\u001ar\u0010R\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006\"\u0004\b\u0000\u0010\u0002\"\b\b\u0001\u0010\u0001*\u00020/*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)29\u0010O\u001a5\b\u0001\u0012\u0013\u0012\u00110\u0018¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(\u0017\u0012\u0004\u0012\u0002H\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00010-\u0012\u0006\u0012\u0004\u0018\u00010/03H\u0007¢\u0006\u0002\u00104\u001a]\u0010S\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006\"\u0004\b\u0000\u0010\u0002\"\b\b\u0001\u0010\u0001*\u00020/*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2$\u0010O\u001a \b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00010-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0007¢\u0006\u0002\u00100\u001a.\u0010T\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00020U0\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)H\u0007\u001a\u001e\u0010V\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0007\u001aW\u0010W\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010D*\b\u0012\u0004\u0012\u0002H\u00020\u00062\b\b\u0002\u0010(\u001a\u00020)2\"\u0010X\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u0002HD0-\u0012\u0006\u0012\u0004\u0018\u00010/0,H\u0001¢\u0006\u0002\u00100\u001a$\u0010Y\u001a\b\u0012\u0004\u0012\u0002H\u00020Z\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0081@¢\u0006\u0002\u0010\u001c\u001a\u001e\u0010[\u001a\u00020.\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a\u001e\u0010\\\u001a\u00020\u0018\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a<\u0010]\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u001a\u0010^\u001a\u0016\u0012\u0006\b\u0000\u0012\u0002H\u00020`j\n\u0012\u0006\b\u0000\u0012\u0002H\u0002`_H\u0087@¢\u0006\u0002\u0010a\u001a<\u0010b\u001a\u0004\u0018\u0001H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00062\u001a\u0010^\u001a\u0016\u0012\u0006\b\u0000\u0012\u0002H\u00020`j\n\u0012\u0006\b\u0000\u0012\u0002H\u0002`_H\u0087@¢\u0006\u0002\u0010a\u001a\u001e\u0010c\u001a\u00020.\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0006H\u0087@¢\u0006\u0002\u0010\u001c\u001a$\u0010d\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0006\"\b\b\u0000\u0010\u0002*\u00020/*\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00020\u0006H\u0007\u001a?\u0010e\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00010F0\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00020\u00062\f\u0010f\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0006H\u0087\u0004\u001az\u0010e\u001a\b\u0012\u0004\u0012\u0002HE0\u0006\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001\"\u0004\b\u0002\u0010E*\b\u0012\u0004\u0012\u0002H\u00020\u00062\f\u0010f\u001a\b\u0012\u0004\u0012\u0002H\u00010\u00062\b\b\u0002\u0010(\u001a\u00020)26\u0010O\u001a2\u0012\u0013\u0012\u0011H\u0002¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(g\u0012\u0013\u0012\u0011H\u0001¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(h\u0012\u0004\u0012\u0002HE0,H\u0001\u001a6\u0010i\u001a#\u0012\u0015\u0012\u0013\u0018\u00010\u000f¢\u0006\f\b\u0010\u0012\b\b\u0011\u0012\u0004\b\b(\u0012\u0012\u0004\u0012\u00020\n0\u0005j\u0002`\u000e*\u0006\u0012\u0002\b\u00030\u0006H\u0001¢\u0006\u0002\u0010j¨\u0006k"}, m18d2 = {"consume", "R", "E", "Lkotlinx/coroutines/channels/BroadcastChannel;", "block", "Lkotlin/Function1;", "Lkotlinx/coroutines/channels/ReceiveChannel;", "Lkotlin/ExtensionFunctionType;", "(Lkotlinx/coroutines/channels/BroadcastChannel;Lkotlin/jvm/functions/Function1;)Ljava/lang/Object;", "consumeEach", "", "action", "(Lkotlinx/coroutines/channels/BroadcastChannel;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "consumesAll", "Lkotlinx/coroutines/CompletionHandler;", "", "Lkotlin/ParameterName;", "name", "cause", "channels", "", "([Lkotlinx/coroutines/channels/ReceiveChannel;)Lkotlin/jvm/functions/Function1;", "elementAt", "index", "", "(Lkotlinx/coroutines/channels/ReceiveChannel;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "elementAtOrNull", "first", "(Lkotlinx/coroutines/channels/ReceiveChannel;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "firstOrNull", "indexOf", "element", "(Lkotlinx/coroutines/channels/ReceiveChannel;Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "last", "lastIndexOf", "lastOrNull", "single", "singleOrNull", "drop", "n", "context", "Lkotlin/coroutines/CoroutineContext;", "dropWhile", "predicate", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "", "(Lkotlinx/coroutines/channels/ReceiveChannel;Lkotlin/coroutines/CoroutineContext;Lkotlin/jvm/functions/Function2;)Lkotlinx/coroutines/channels/ReceiveChannel;", "filter", "filterIndexed", "Lkotlin/Function3;", "(Lkotlinx/coroutines/channels/ReceiveChannel;Lkotlin/coroutines/CoroutineContext;Lkotlin/jvm/functions/Function3;)Lkotlinx/coroutines/channels/ReceiveChannel;", "filterNot", "filterNotNull", "filterNotNullTo", "C", "", "destination", "(Lkotlinx/coroutines/channels/ReceiveChannel;Ljava/util/Collection;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lkotlinx/coroutines/channels/SendChannel;", "(Lkotlinx/coroutines/channels/ReceiveChannel;Lkotlinx/coroutines/channels/SendChannel;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "take", "takeWhile", "toChannel", "toCollection", "toMap", "", "K", "V", "Lkotlin/Pair;", "M", "", "(Lkotlinx/coroutines/channels/ReceiveChannel;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "toMutableList", "", "toSet", "", "flatMap", "transform", "map", "mapIndexed", "mapIndexedNotNull", "mapNotNull", "withIndex", "Lkotlin/collections/IndexedValue;", "distinct", "distinctBy", "selector", "toMutableSet", "", "any", "count", "maxWith", "comparator", "Lkotlin/Comparator;", "Ljava/util/Comparator;", "(Lkotlinx/coroutines/channels/ReceiveChannel;Ljava/util/Comparator;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "minWith", "none", "requireNoNulls", "zip", "other", "a", "b", "consumes", "(Lkotlinx/coroutines/channels/ReceiveChannel;)Lkotlin/jvm/functions/Function1;", "kotlinx-coroutines-core"}, m19k = 5, m20mv = {2, 0, 0}, m22xi = 48, m23xs = "kotlinx/coroutines/channels/ChannelsKt")
final class ChannelsKt__DeprecatedKt {

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0}, m39l = {434}, m40m = "any", m41n = {"$this$consume$iv"}, m42s = {"L$0"})
    static final class C02131<E> extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C02131(Continuation<? super C02131> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.any(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {ConversationMsg.TYPE_TIMESTAMP}, m40m = "consumeEach", m41n = {"action", "channel$iv"}, m42s = {"L$0", "L$1"})
    static final class C02141<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02141(Continuation<? super C02141> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.consumeEach(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {514}, m40m = "count", m41n = {"count", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1"})
    static final class C02151<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02151(Continuation<? super C02151> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.count(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0}, m39l = {68}, m40m = "elementAt", m41n = {"$this$consume$iv", "index", "count"}, m42s = {"L$0", "I$0", "I$1"})
    static final class C02201<E> extends ContinuationImpl {
        int I$0;
        int I$1;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02201(Continuation<? super C02201> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.elementAt(null, 0, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0}, m39l = {83}, m40m = "elementAtOrNull", m41n = {"$this$consume$iv", "index", "count"}, m42s = {"L$0", "I$0", "I$1"})
    static final class C02211<E> extends ContinuationImpl {
        int I$0;
        int I$1;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02211(Continuation<? super C02211> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.elementAtOrNull(null, 0, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {514}, m40m = "filterNotNullTo", m41n = {"destination", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1"})
    static final class C02261<E, C extends Collection<? super E>> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02261(Continuation<? super C02261> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.filterNotNullTo((ReceiveChannel) null, (Collection) null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {514, 272}, m40m = "filterNotNullTo", m41n = {"destination", "$this$consume$iv$iv", "destination", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C02273<E, C extends SendChannel<? super E>> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02273(Continuation<? super C02273> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.filterNotNullTo((ReceiveChannel) null, (SendChannel) null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {95}, m40m = "first", m41n = {"$this$consume$iv", "iterator"}, m42s = {"L$0", "L$1"})
    static final class C02281<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02281(Continuation<? super C02281> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.first(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {TrackType.TRACK_ENTRANCE_CLICK_FAQ}, m40m = "firstOrNull", m41n = {"$this$consume$iv", "iterator"}, m42s = {"L$0", "L$1"})
    static final class C02291<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02291(Continuation<? super C02291> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.firstOrNull(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0}, m39l = {514}, m40m = "indexOf", m41n = {"element", "index", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C02311<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C02311(Continuation<? super C02311> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.indexOf(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 1}, m39l = {127, 130}, m40m = "last", m41n = {"$this$consume$iv", "iterator", "$this$consume$iv", "iterator", "last"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2"})
    static final class C02321<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02321(Continuation<? super C02321> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.last(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0, 0}, m39l = {514}, m40m = "lastIndexOf", m41n = {"element", "lastIndex", "index", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C02331<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C02331(Continuation<? super C02331> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.lastIndexOf(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 1}, m39l = {TrackType.TRACK_FAQ_MARKED_UNHELPFUL, TrackType.TRACK_FAQ_SEARCH_CONTENT}, m40m = "lastOrNull", m41n = {"$this$consume$iv", "iterator", "$this$consume$iv", "iterator", "last"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2"})
    static final class C02341<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02341(Continuation<? super C02341> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.lastOrNull(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0, 1, 1, 1, 1}, m39l = {AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, 452}, m40m = "maxWith", m41n = {"comparator", "$this$consume$iv", "iterator", "comparator", "$this$consume$iv", "iterator", "max"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$3"})
    static final class C02371<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C02371(Continuation<? super C02371> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.maxWith(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 0, 1, 1, 1, 1}, m39l = {464, 466}, m40m = "minWith", m41n = {"comparator", "$this$consume$iv", "iterator", "comparator", "$this$consume$iv", "iterator", "min"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$3"})
    static final class C02381<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C02381(Continuation<? super C02381> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.minWith(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0}, m39l = {477}, m40m = "none", m41n = {"$this$consume$iv"}, m42s = {"L$0"})
    static final class C02391<E> extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C02391(Continuation<? super C02391> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.none(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {166, 169}, m40m = "single", m41n = {"$this$consume$iv", "iterator", "$this$consume$iv", "single"}, m42s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C02411<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02411(Continuation<? super C02411> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.single(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {179, 182}, m40m = "singleOrNull", m41n = {"$this$consume$iv", "iterator", "$this$consume$iv", "single"}, m42s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C02421<E> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C02421(Continuation<? super C02421> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt__DeprecatedKt.singleOrNull(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {514, StatusLine.HTTP_PERM_REDIRECT}, m40m = "toChannel", m41n = {"destination", "$this$consume$iv$iv", "destination", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C02451<E, C extends SendChannel<? super E>> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02451(Continuation<? super C02451> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt.toChannel(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {514}, m40m = "toCollection", m41n = {"destination", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1"})
    static final class C02461<E, C extends Collection<? super E>> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02461(Continuation<? super C02461> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt.toCollection(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt", m37f = "Deprecated.kt", m38i = {0, 0}, m39l = {514}, m40m = "toMap", m41n = {"destination", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1"})
    static final class C02472<K, V, M extends Map<? super K, ? super V>> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C02472(Continuation<? super C02472> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChannelsKt.toMap(null, null, this);
        }
    }

    @Deprecated(level = DeprecationLevel.ERROR, message = "BroadcastChannel is deprecated in the favour of SharedFlow and is no longer supported")
    public static final <E, R> R consume(BroadcastChannel<E> broadcastChannel, Function1<? super ReceiveChannel<? extends E>, ? extends R> function1) {
        ReceiveChannel<E> receiveChannelOpenSubscription = broadcastChannel.openSubscription();
        try {
            return function1.invoke(receiveChannelOpenSubscription);
        } finally {
            ReceiveChannel.DefaultImpls.cancel$default((ReceiveChannel) receiveChannelOpenSubscription, (CancellationException) null, 1, (Object) null);
        }
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.ERROR, message = "BroadcastChannel is deprecated in the favour of SharedFlow and is no longer supported")
    public static final <E> java.lang.Object consumeEach(kotlinx.coroutines.channels.BroadcastChannel<E> r6, kotlin.jvm.functions.Function1<? super E, kotlin.Unit> r7, kotlin.coroutines.Continuation<? super kotlin.Unit> r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.consumeEach(kotlinx.coroutines.channels.BroadcastChannel, kotlin.jvm.functions.Function1, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final Function1<Throwable, Unit> consumesAll(final ReceiveChannel<?>... receiveChannelArr) {
        return new Function1() {
            @Override
            public final Object invoke(Object obj) {
                return ChannelsKt__DeprecatedKt.consumesAll$lambda$2$ChannelsKt__DeprecatedKt(receiveChannelArr, (Throwable) obj);
            }
        };
    }

    public static final Unit consumesAll$lambda$2$ChannelsKt__DeprecatedKt(ReceiveChannel[] receiveChannelArr, Throwable th) throws Throwable {
        Throwable th2 = null;
        for (ReceiveChannel receiveChannel : receiveChannelArr) {
            try {
                ChannelsKt.cancelConsumed(receiveChannel, th);
            } catch (Throwable th3) {
                if (th2 == null) {
                    th2 = th3;
                } else {
                    ExceptionsKt.addSuppressed(th2, th3);
                }
            }
        }
        if (th2 != null) {
            throw th2;
        }
        return Unit.INSTANCE;
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object elementAt(kotlinx.coroutines.channels.ReceiveChannel r10, int r11, kotlin.coroutines.Continuation r12) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.elementAt(kotlinx.coroutines.channels.ReceiveChannel, int, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object elementAtOrNull(kotlinx.coroutines.channels.ReceiveChannel r9, int r10, kotlin.coroutines.Continuation r11) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.elementAtOrNull(kotlinx.coroutines.channels.ReceiveChannel, int, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object first(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02281 c02281;
        ReceiveChannel receiveChannel2;
        Throwable th;
        ChannelIterator channelIterator;
        if (continuation instanceof C02281) {
            c02281 = (C02281) continuation;
            if ((c02281.label & Integer.MIN_VALUE) != 0) {
                c02281.label -= Integer.MIN_VALUE;
            } else {
                c02281 = new C02281(continuation);
            }
        } else {
            c02281 = new C02281(continuation);
        }
        Object obj = c02281.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02281.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            channelIterator = (ChannelIterator) c02281.L$1;
            receiveChannel2 = (ReceiveChannel) c02281.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                if (((Boolean) obj).booleanValue()) {
                    throw new NoSuchElementException("ReceiveChannel is empty.");
                }
                Object next = channelIterator.next();
                ChannelsKt.cancelConsumed(receiveChannel2, null);
                return next;
            } catch (Throwable th2) {
                th = th2;
                try {
                    throw th;
                } catch (Throwable th3) {
                    ChannelsKt.cancelConsumed(receiveChannel2, th);
                    throw th3;
                }
            }
        }
        ResultKt.throwOnFailure(obj);
        try {
            ChannelIterator it = receiveChannel.iterator();
            c02281.L$0 = receiveChannel;
            c02281.L$1 = it;
            c02281.label = 1;
            Object objHasNext = it.hasNext(c02281);
            if (objHasNext == coroutine_suspended) {
                return coroutine_suspended;
            }
            receiveChannel2 = receiveChannel;
            channelIterator = it;
            obj = objHasNext;
            if (((Boolean) obj).booleanValue()) {
                throw new NoSuchElementException("ReceiveChannel is empty.");
            }
            Object next2 = channelIterator.next();
            ChannelsKt.cancelConsumed(receiveChannel2, null);
            return next2;
        } catch (Throwable th4) {
            receiveChannel2 = receiveChannel;
            th = th4;
            throw th;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object firstOrNull(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02291 c02291;
        ReceiveChannel receiveChannel2;
        Throwable th;
        ChannelIterator channelIterator;
        if (continuation instanceof C02291) {
            c02291 = (C02291) continuation;
            if ((c02291.label & Integer.MIN_VALUE) != 0) {
                c02291.label -= Integer.MIN_VALUE;
            } else {
                c02291 = new C02291(continuation);
            }
        } else {
            c02291 = new C02291(continuation);
        }
        Object obj = c02291.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02291.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            try {
                ChannelIterator it = receiveChannel.iterator();
                c02291.L$0 = receiveChannel;
                c02291.L$1 = it;
                c02291.label = 1;
                Object objHasNext = it.hasNext(c02291);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
                receiveChannel2 = receiveChannel;
                channelIterator = it;
                obj = objHasNext;
            } catch (Throwable th2) {
                receiveChannel2 = receiveChannel;
                th = th2;
                throw th;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            channelIterator = (ChannelIterator) c02291.L$1;
            receiveChannel2 = (ReceiveChannel) c02291.L$0;
            try {
                ResultKt.throwOnFailure(obj);
            } catch (Throwable th3) {
                th = th3;
                try {
                    throw th;
                } catch (Throwable th4) {
                    ChannelsKt.cancelConsumed(receiveChannel2, th);
                    throw th4;
                }
            }
        }
        if (((Boolean) obj).booleanValue()) {
            Object next = channelIterator.next();
            ChannelsKt.cancelConsumed(receiveChannel2, null);
            return next;
        }
        ChannelsKt.cancelConsumed(receiveChannel2, null);
        return null;
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object indexOf(kotlinx.coroutines.channels.ReceiveChannel r7, java.lang.Object r8, kotlin.coroutines.Continuation r9) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.indexOf(kotlinx.coroutines.channels.ReceiveChannel, java.lang.Object, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object last(kotlinx.coroutines.channels.ReceiveChannel r7, kotlin.coroutines.Continuation r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.last(kotlinx.coroutines.channels.ReceiveChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object lastIndexOf(kotlinx.coroutines.channels.ReceiveChannel r8, java.lang.Object r9, kotlin.coroutines.Continuation r10) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.lastIndexOf(kotlinx.coroutines.channels.ReceiveChannel, java.lang.Object, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object lastOrNull(kotlinx.coroutines.channels.ReceiveChannel r7, kotlin.coroutines.Continuation r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.lastOrNull(kotlinx.coroutines.channels.ReceiveChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object single(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02411 c02411;
        ReceiveChannel receiveChannel2;
        Throwable th;
        ChannelIterator channelIterator;
        Object next;
        Object objHasNext;
        ReceiveChannel receiveChannel3;
        Object obj;
        if (continuation instanceof C02411) {
            c02411 = (C02411) continuation;
            if ((c02411.label & Integer.MIN_VALUE) != 0) {
                c02411.label -= Integer.MIN_VALUE;
            } else {
                c02411 = new C02411(continuation);
            }
        } else {
            c02411 = new C02411(continuation);
        }
        Object obj2 = c02411.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02411.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            try {
                ChannelIterator it = receiveChannel.iterator();
                c02411.L$0 = receiveChannel;
                c02411.L$1 = it;
                c02411.label = 1;
                Object objHasNext2 = it.hasNext(c02411);
                if (objHasNext2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                receiveChannel2 = receiveChannel;
                channelIterator = it;
                obj2 = objHasNext2;
                if (((Boolean) obj2).booleanValue()) {
                    throw new NoSuchElementException("ReceiveChannel is empty.");
                }
                next = channelIterator.next();
                c02411.L$0 = receiveChannel2;
                c02411.L$1 = next;
                c02411.label = 2;
                objHasNext = channelIterator.hasNext(c02411);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
                receiveChannel3 = receiveChannel2;
                obj2 = objHasNext;
                obj = next;
            } catch (Throwable th2) {
                receiveChannel2 = receiveChannel;
                th = th2;
                throw th;
            }
        } else if (i == 1) {
            channelIterator = (ChannelIterator) c02411.L$1;
            receiveChannel2 = (ReceiveChannel) c02411.L$0;
            try {
                ResultKt.throwOnFailure(obj2);
                if (((Boolean) obj2).booleanValue()) {
                    throw new NoSuchElementException("ReceiveChannel is empty.");
                }
                next = channelIterator.next();
                c02411.L$0 = receiveChannel2;
                c02411.L$1 = next;
                c02411.label = 2;
                objHasNext = channelIterator.hasNext(c02411);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
                receiveChannel3 = receiveChannel2;
                obj2 = objHasNext;
                obj = next;
            } catch (Throwable th3) {
                th = th3;
                throw th;
            }
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            obj = c02411.L$1;
            receiveChannel3 = (ReceiveChannel) c02411.L$0;
            try {
                ResultKt.throwOnFailure(obj2);
            } catch (Throwable th4) {
                th = th4;
                receiveChannel2 = receiveChannel3;
                try {
                    throw th;
                } catch (Throwable th5) {
                    ChannelsKt.cancelConsumed(receiveChannel2, th);
                    throw th5;
                }
            }
        }
        if (((Boolean) obj2).booleanValue()) {
            throw new IllegalArgumentException("ReceiveChannel has more than one element.");
        }
        ChannelsKt.cancelConsumed(receiveChannel3, null);
        return obj;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object singleOrNull(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02421 c02421;
        ReceiveChannel receiveChannel2;
        Throwable th;
        ChannelIterator channelIterator;
        ReceiveChannel receiveChannel3;
        Object obj;
        if (continuation instanceof C02421) {
            c02421 = (C02421) continuation;
            if ((c02421.label & Integer.MIN_VALUE) != 0) {
                c02421.label -= Integer.MIN_VALUE;
            } else {
                c02421 = new C02421(continuation);
            }
        } else {
            c02421 = new C02421(continuation);
        }
        Object obj2 = c02421.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02421.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            try {
                ChannelIterator it = receiveChannel.iterator();
                c02421.L$0 = receiveChannel;
                c02421.L$1 = it;
                c02421.label = 1;
                Object objHasNext = it.hasNext(c02421);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
                receiveChannel2 = receiveChannel;
                channelIterator = it;
                obj2 = objHasNext;
            } catch (Throwable th2) {
                receiveChannel2 = receiveChannel;
                th = th2;
                throw th;
            }
        } else {
            if (i != 1) {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                obj = c02421.L$1;
                receiveChannel3 = (ReceiveChannel) c02421.L$0;
                try {
                    ResultKt.throwOnFailure(obj2);
                    if (((Boolean) obj2).booleanValue()) {
                        ChannelsKt.cancelConsumed(receiveChannel3, null);
                        return null;
                    }
                    ChannelsKt.cancelConsumed(receiveChannel3, null);
                    return obj;
                } catch (Throwable th3) {
                    th = th3;
                    receiveChannel2 = receiveChannel3;
                    try {
                        throw th;
                    } catch (Throwable th4) {
                        ChannelsKt.cancelConsumed(receiveChannel2, th);
                        throw th4;
                    }
                }
            }
            channelIterator = (ChannelIterator) c02421.L$1;
            receiveChannel2 = (ReceiveChannel) c02421.L$0;
            try {
                ResultKt.throwOnFailure(obj2);
            } catch (Throwable th5) {
                th = th5;
                throw th;
            }
        }
        if (((Boolean) obj2).booleanValue()) {
            Object next = channelIterator.next();
            c02421.L$0 = receiveChannel2;
            c02421.L$1 = next;
            c02421.label = 2;
            Object objHasNext2 = channelIterator.hasNext(c02421);
            if (objHasNext2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            receiveChannel3 = receiveChannel2;
            obj2 = objHasNext2;
            obj = next;
            if (((Boolean) obj2).booleanValue()) {
                ChannelsKt.cancelConsumed(receiveChannel3, null);
                return null;
            }
            ChannelsKt.cancelConsumed(receiveChannel3, null);
            return obj;
        }
        ChannelsKt.cancelConsumed(receiveChannel2, null);
        return null;
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$drop$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 2}, m39l = {194, 199, 200}, m40m = "invokeSuspend", m41n = {"$this$produce", "remaining", "$this$produce", "$this$produce"}, m42s = {"L$0", "I$0", "L$0", "L$0"})
    static final class C02181<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {

        final int f44$n;
        final ReceiveChannel<E> $this_drop;
        int I$0;
        private Object L$0;
        Object L$1;
        int label;

        C02181(int i, ReceiveChannel<? extends E> receiveChannel, Continuation<? super C02181> continuation) {
            super(2, continuation);
            this.f44$n = i;
            this.$this_drop = receiveChannel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02181 c02181 = new C02181(this.f44$n, this.$this_drop, continuation);
            c02181.L$0 = obj;
            return c02181;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02181) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r9) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02181.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static ReceiveChannel drop$default(ReceiveChannel receiveChannel, int i, CoroutineContext coroutineContext, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return drop(receiveChannel, i, coroutineContext);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel drop(ReceiveChannel receiveChannel, int i, CoroutineContext coroutineContext) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02181(i, receiveChannel, null), 6, null);
    }

    public static ReceiveChannel dropWhile$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return dropWhile(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$dropWhile$1", m37f = "Deprecated.kt", m38i = {0, 1, 1, 2, 3, 4}, m39l = {211, 212, 213, 217, 218}, m40m = "invokeSuspend", m41n = {"$this$produce", "$this$produce", "e", "$this$produce", "$this$produce", "$this$produce"}, m42s = {"L$0", "L$0", "L$2", "L$0", "L$0", "L$0"})
    static final class C02191<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {
        final Function2<E, Continuation<? super Boolean>, Object> $predicate;
        final ReceiveChannel<E> $this_dropWhile;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C02191(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super Boolean>, ? extends Object> function2, Continuation<? super C02191> continuation) {
            super(2, continuation);
            this.$this_dropWhile = receiveChannel;
            this.$predicate = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02191 c02191 = new C02191(this.$this_dropWhile, this.$predicate, continuation);
            c02191.L$0 = obj;
            return c02191;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02191) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r12) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02191.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel dropWhile(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02191(receiveChannel, function2, null), 6, null);
    }

    public static ReceiveChannel filter$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return ChannelsKt.filter(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$filter$1", m37f = "Deprecated.kt", m38i = {0, 1, 1, 2}, m39l = {228, 229, 229}, m40m = "invokeSuspend", m41n = {"$this$produce", "$this$produce", "e", "$this$produce"}, m42s = {"L$0", "L$0", "L$2", "L$0"})
    static final class C02221<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {
        final Function2<E, Continuation<? super Boolean>, Object> $predicate;
        final ReceiveChannel<E> $this_filter;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C02221(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super Boolean>, ? extends Object> function2, Continuation<? super C02221> continuation) {
            super(2, continuation);
            this.$this_filter = receiveChannel;
            this.$predicate = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02221 c02221 = new C02221(this.$this_filter, this.$predicate, continuation);
            c02221.L$0 = obj;
            return c02221;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02221) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r10) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02221.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final <E> ReceiveChannel<E> filter(ReceiveChannel<? extends E> receiveChannel, CoroutineContext coroutineContext, Function2<? super E, ? super Continuation<? super Boolean>, ? extends Object> function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02221(receiveChannel, function2, null), 6, null);
    }

    public static ReceiveChannel filterIndexed$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function3 function3, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return filterIndexed(receiveChannel, coroutineContext, function3);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$filterIndexed$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 1, 2, 2}, m39l = {241, 242, 242}, m40m = "invokeSuspend", m41n = {"$this$produce", "index", "$this$produce", "e", "index", "$this$produce", "index"}, m42s = {"L$0", "I$0", "L$0", "L$2", "I$0", "L$0", "I$0"})
    static final class C02231<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {
        final Function3<Integer, E, Continuation<? super Boolean>, Object> $predicate;
        final ReceiveChannel<E> $this_filterIndexed;
        int I$0;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C02231(ReceiveChannel<? extends E> receiveChannel, Function3<? super Integer, ? super E, ? super Continuation<? super Boolean>, ? extends Object> function3, Continuation<? super C02231> continuation) {
            super(2, continuation);
            this.$this_filterIndexed = receiveChannel;
            this.$predicate = function3;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02231 c02231 = new C02231(this.$this_filterIndexed, this.$predicate, continuation);
            c02231.L$0 = obj;
            return c02231;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02231) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r12) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02231.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel filterIndexed(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function3 function3) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02231(receiveChannel, function3, null), 6, null);
    }

    public static ReceiveChannel filterNot$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return filterNot(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u0002H\u0002H\n"}, m18d2 = {"<anonymous>", "", "E", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$filterNot$1", m37f = "Deprecated.kt", m38i = {}, m39l = {TrackType.TRACK_FORM_ACTION_CLICKED}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02241<E> extends SuspendLambda implements Function2<E, Continuation<? super Boolean>, Object> {
        final Function2<E, Continuation<? super Boolean>, Object> $predicate;
        Object L$0;
        int label;

        C02241(Function2<? super E, ? super Continuation<? super Boolean>, ? extends Object> function2, Continuation<? super C02241> continuation) {
            super(2, continuation);
            this.$predicate = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02241 c02241 = new C02241(this.$predicate, continuation);
            c02241.L$0 = obj;
            return c02241;
        }

        @Override
        public final Object invoke(E e, Continuation<? super Boolean> continuation) {
            return ((C02241) create(e, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r4) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02241.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel filterNot(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2) {
        return ChannelsKt.filter(receiveChannel, coroutineContext, new C02241(function2, null));
    }

    @Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\u0010\u0000\u001a\u00020\u0001\"\b\b\u0000\u0010\u0002*\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u0001H\u0002H\n"}, m18d2 = {"<anonymous>", "", "E", "", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$filterNotNull$1", m37f = "Deprecated.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02251<E> extends SuspendLambda implements Function2<E, Continuation<? super Boolean>, Object> {
        Object L$0;
        int label;

        C02251(Continuation<? super C02251> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02251 c02251 = new C02251(continuation);
            c02251.L$0 = obj;
            return c02251;
        }

        @Override
        public final Object invoke(E e, Continuation<? super Boolean> continuation) {
            return ((C02251) create(e, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return Boxing.boxBoolean(this.L$0 != null);
        }
    }

    public static final <E> ReceiveChannel<E> filterNotNull(ReceiveChannel<? extends E> receiveChannel) {
        ReceiveChannel<E> receiveChannelFilter$default = filter$default(receiveChannel, null, new C02251(null), 1, null);
        Intrinsics.checkNotNull(receiveChannelFilter$default, "null cannot be cast to non-null type kotlinx.coroutines.channels.ReceiveChannel<E of kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.filterNotNull>");
        return receiveChannelFilter$default;
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object filterNotNullTo(kotlinx.coroutines.channels.ReceiveChannel r6, java.util.Collection r7, kotlin.coroutines.Continuation r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.filterNotNullTo(kotlinx.coroutines.channels.ReceiveChannel, java.util.Collection, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object filterNotNullTo(kotlinx.coroutines.channels.ReceiveChannel r7, kotlinx.coroutines.channels.SendChannel r8, kotlin.coroutines.Continuation r9) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.filterNotNullTo(kotlinx.coroutines.channels.ReceiveChannel, kotlinx.coroutines.channels.SendChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$take$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {284, 285}, m40m = "invokeSuspend", m41n = {"$this$produce", "remaining", "$this$produce", "remaining"}, m42s = {"L$0", "I$0", "L$0", "I$0"})
    static final class C02431<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {

        final int f45$n;
        final ReceiveChannel<E> $this_take;
        int I$0;
        private Object L$0;
        Object L$1;
        int label;

        C02431(int i, ReceiveChannel<? extends E> receiveChannel, Continuation<? super C02431> continuation) {
            super(2, continuation);
            this.f45$n = i;
            this.$this_take = receiveChannel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02431 c02431 = new C02431(this.f45$n, this.$this_take, continuation);
            c02431.L$0 = obj;
            return c02431;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02431) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r9) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02431.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static ReceiveChannel take$default(ReceiveChannel receiveChannel, int i, CoroutineContext coroutineContext, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return take(receiveChannel, i, coroutineContext);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel take(ReceiveChannel receiveChannel, int i, CoroutineContext coroutineContext) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02431(i, receiveChannel, null), 6, null);
    }

    public static ReceiveChannel takeWhile$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return takeWhile(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$takeWhile$1", m37f = "Deprecated.kt", m38i = {0, 1, 1, 2}, m39l = {299, 300, HttpStatus.SC_MOVED_PERMANENTLY}, m40m = "invokeSuspend", m41n = {"$this$produce", "$this$produce", "e", "$this$produce"}, m42s = {"L$0", "L$0", "L$2", "L$0"})
    static final class C02441<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {
        final Function2<E, Continuation<? super Boolean>, Object> $predicate;
        final ReceiveChannel<E> $this_takeWhile;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C02441(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super Boolean>, ? extends Object> function2, Continuation<? super C02441> continuation) {
            super(2, continuation);
            this.$this_takeWhile = receiveChannel;
            this.$predicate = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02441 c02441 = new C02441(this.$this_takeWhile, this.$predicate, continuation);
            c02441.L$0 = obj;
            return c02441;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02441) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r10) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02441.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel takeWhile(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02441(receiveChannel, function2, null), 6, null);
    }

    public static final <E, C extends kotlinx.coroutines.channels.SendChannel<? super E>> java.lang.Object toChannel(kotlinx.coroutines.channels.ReceiveChannel<? extends E> r7, C r8, kotlin.coroutines.Continuation<? super C> r9) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.toChannel(kotlinx.coroutines.channels.ReceiveChannel, kotlinx.coroutines.channels.SendChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final <E, C extends java.util.Collection<? super E>> java.lang.Object toCollection(kotlinx.coroutines.channels.ReceiveChannel<? extends E> r6, C r7, kotlin.coroutines.Continuation<? super C> r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.toCollection(kotlinx.coroutines.channels.ReceiveChannel, java.util.Collection, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final <K, V, M extends java.util.Map<? super K, ? super V>> java.lang.Object toMap(kotlinx.coroutines.channels.ReceiveChannel<? extends kotlin.Pair<? extends K, ? extends V>> r7, M r8, kotlin.coroutines.Continuation<? super M> r9) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.toMap(kotlinx.coroutines.channels.ReceiveChannel, java.util.Map, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static ReceiveChannel flatMap$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return flatMap(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "R", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$flatMap$1", m37f = "Deprecated.kt", m38i = {0, 1, 2}, m39l = {351, 352, 352}, m40m = "invokeSuspend", m41n = {"$this$produce", "$this$produce", "$this$produce"}, m42s = {"L$0", "L$0", "L$0"})
    static final class C02301<R> extends SuspendLambda implements Function2<ProducerScope<? super R>, Continuation<? super Unit>, Object> {
        final ReceiveChannel<E> $this_flatMap;
        final Function2<E, Continuation<? super ReceiveChannel<? extends R>>, Object> $transform;
        private Object L$0;
        Object L$1;
        int label;

        C02301(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super ReceiveChannel<? extends R>>, ? extends Object> function2, Continuation<? super C02301> continuation) {
            super(2, continuation);
            this.$this_flatMap = receiveChannel;
            this.$transform = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02301 c02301 = new C02301(this.$this_flatMap, this.$transform, continuation);
            c02301.L$0 = obj;
            return c02301;
        }

        @Override
        public final Object invoke(ProducerScope<? super R> producerScope, Continuation<? super Unit> continuation) {
            return ((C02301) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r9) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02301.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel flatMap(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02301(receiveChannel, function2, null), 6, null);
    }

    public static ReceiveChannel map$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return ChannelsKt.map(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "R", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$map$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 2, 2}, m39l = {514, 363, 363}, m40m = "invokeSuspend", m41n = {"$this$produce", "$this$consume$iv$iv", "$this$produce", "$this$consume$iv$iv", "$this$produce", "$this$consume$iv$iv"}, m42s = {"L$0", "L$2", "L$0", "L$2", "L$0", "L$2"})
    static final class C02351<R> extends SuspendLambda implements Function2<ProducerScope<? super R>, Continuation<? super Unit>, Object> {
        final ReceiveChannel<E> $this_map;
        final Function2<E, Continuation<? super R>, Object> $transform;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;

        C02351(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super R>, ? extends Object> function2, Continuation<? super C02351> continuation) {
            super(2, continuation);
            this.$this_map = receiveChannel;
            this.$transform = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02351 c02351 = new C02351(this.$this_map, this.$transform, continuation);
            c02351.L$0 = obj;
            return c02351;
        }

        @Override
        public final Object invoke(ProducerScope<? super R> producerScope, Continuation<? super Unit> continuation) {
            return ((C02351) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r13) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02351.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final <E, R> ReceiveChannel<R> map(ReceiveChannel<? extends E> receiveChannel, CoroutineContext coroutineContext, Function2<? super E, ? super Continuation<? super R>, ? extends Object> function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02351(receiveChannel, function2, null), 6, null);
    }

    public static ReceiveChannel mapIndexed$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function3 function3, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return ChannelsKt.mapIndexed(receiveChannel, coroutineContext, function3);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "R", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$mapIndexed$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 2, 2}, m39l = {374, 375, 375}, m40m = "invokeSuspend", m41n = {"$this$produce", "index", "$this$produce", "index", "$this$produce", "index"}, m42s = {"L$0", "I$0", "L$0", "I$0", "L$0", "I$0"})
    static final class C02361<R> extends SuspendLambda implements Function2<ProducerScope<? super R>, Continuation<? super Unit>, Object> {
        final ReceiveChannel<E> $this_mapIndexed;
        final Function3<Integer, E, Continuation<? super R>, Object> $transform;
        int I$0;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C02361(ReceiveChannel<? extends E> receiveChannel, Function3<? super Integer, ? super E, ? super Continuation<? super R>, ? extends Object> function3, Continuation<? super C02361> continuation) {
            super(2, continuation);
            this.$this_mapIndexed = receiveChannel;
            this.$transform = function3;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02361 c02361 = new C02361(this.$this_mapIndexed, this.$transform, continuation);
            c02361.L$0 = obj;
            return c02361;
        }

        @Override
        public final Object invoke(ProducerScope<? super R> producerScope, Continuation<? super Unit> continuation) {
            return ((C02361) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r12) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02361.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final <E, R> ReceiveChannel<R> mapIndexed(ReceiveChannel<? extends E> receiveChannel, CoroutineContext coroutineContext, Function3<? super Integer, ? super E, ? super Continuation<? super R>, ? extends Object> function3) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02361(receiveChannel, function3, null), 6, null);
    }

    public static ReceiveChannel mapIndexedNotNull$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function3 function3, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return mapIndexedNotNull(receiveChannel, coroutineContext, function3);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel mapIndexedNotNull(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function3 function3) {
        return ChannelsKt.filterNotNull(ChannelsKt.mapIndexed(receiveChannel, coroutineContext, function3));
    }

    public static ReceiveChannel mapNotNull$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return mapNotNull(receiveChannel, coroutineContext, function2);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel mapNotNull(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2) {
        return ChannelsKt.filterNotNull(ChannelsKt.map(receiveChannel, coroutineContext, function2));
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00020\u00040\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;", "Lkotlin/collections/IndexedValue;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$withIndex$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1}, m39l = {400, HttpStatus.SC_UNAUTHORIZED}, m40m = "invokeSuspend", m41n = {"$this$produce", "index", "$this$produce", "index"}, m42s = {"L$0", "I$0", "L$0", "I$0"})
    static final class C02481<E> extends SuspendLambda implements Function2<ProducerScope<? super IndexedValue<? extends E>>, Continuation<? super Unit>, Object> {
        final ReceiveChannel<E> $this_withIndex;
        int I$0;
        private Object L$0;
        Object L$1;
        int label;

        C02481(ReceiveChannel<? extends E> receiveChannel, Continuation<? super C02481> continuation) {
            super(2, continuation);
            this.$this_withIndex = receiveChannel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02481 c02481 = new C02481(this.$this_withIndex, continuation);
            c02481.L$0 = obj;
            return c02481;
        }

        @Override
        public final Object invoke(ProducerScope<? super IndexedValue<? extends E>> producerScope, Continuation<? super Unit> continuation) {
            return ((C02481) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r11) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02481.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static ReceiveChannel withIndex$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return withIndex(receiveChannel, coroutineContext);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final ReceiveChannel withIndex(ReceiveChannel receiveChannel, CoroutineContext coroutineContext) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02481(receiveChannel, null), 6, null);
    }

    @Metadata(m17d1 = {"\u0000\u0004\n\u0002\b\u0003\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u00012\u0006\u0010\u0002\u001a\u0002H\u0001H\n"}, m18d2 = {"<anonymous>", "E", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$distinct$1", m37f = "Deprecated.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02161<E> extends SuspendLambda implements Function2<E, Continuation<? super E>, Object> {
        Object L$0;
        int label;

        C02161(Continuation<? super C02161> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02161 c02161 = new C02161(continuation);
            c02161.L$0 = obj;
            return c02161;
        }

        @Override
        public final Object invoke(E e, Continuation<? super E> continuation) {
            return ((C02161) create(e, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return this.L$0;
        }
    }

    public static ReceiveChannel distinctBy$default(ReceiveChannel receiveChannel, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return ChannelsKt.distinctBy(receiveChannel, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "E", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$distinctBy$1", m37f = "Deprecated.kt", m38i = {0, 0, 1, 1, 1, 2, 2, 2}, m39l = {HttpStatus.SC_EXPECTATION_FAILED, 418, HttpStatus.SC_METHOD_FAILURE}, m40m = "invokeSuspend", m41n = {"$this$produce", "keys", "$this$produce", "keys", "e", "$this$produce", "keys", "k"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$3", "L$0", "L$1", "L$3"})
    static final class C02171<E> extends SuspendLambda implements Function2<ProducerScope<? super E>, Continuation<? super Unit>, Object> {
        final Function2<E, Continuation<? super K>, Object> $selector;
        final ReceiveChannel<E> $this_distinctBy;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;

        C02171(ReceiveChannel<? extends E> receiveChannel, Function2<? super E, ? super Continuation<? super K>, ? extends Object> function2, Continuation<? super C02171> continuation) {
            super(2, continuation);
            this.$this_distinctBy = receiveChannel;
            this.$selector = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02171 c02171 = new C02171(this.$this_distinctBy, this.$selector, continuation);
            c02171.L$0 = obj;
            return c02171;
        }

        @Override
        public final Object invoke(ProducerScope<? super E> producerScope, Continuation<? super Unit> continuation) {
            return ((C02171) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r11) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02171.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final <E, K> ReceiveChannel<E> distinctBy(ReceiveChannel<? extends E> receiveChannel, CoroutineContext coroutineContext, Function2<? super E, ? super Continuation<? super K>, ? extends Object> function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumes(receiveChannel), new C02171(receiveChannel, function2, null), 6, null);
    }

    public static final <E> Object toMutableSet(ReceiveChannel<? extends E> receiveChannel, Continuation<? super Set<E>> continuation) {
        return ChannelsKt.toCollection(receiveChannel, new LinkedHashSet(), continuation);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object any(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02131 c02131;
        if (continuation instanceof C02131) {
            c02131 = (C02131) continuation;
            if ((c02131.label & Integer.MIN_VALUE) != 0) {
                c02131.label -= Integer.MIN_VALUE;
            } else {
                c02131 = new C02131(continuation);
            }
        } else {
            c02131 = new C02131(continuation);
        }
        Object objHasNext = c02131.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02131.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objHasNext);
                ChannelIterator it = receiveChannel.iterator();
                c02131.L$0 = receiveChannel;
                c02131.label = 1;
                objHasNext = it.hasNext(c02131);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                receiveChannel = (ReceiveChannel) c02131.L$0;
                ResultKt.throwOnFailure(objHasNext);
            }
            ChannelsKt.cancelConsumed(receiveChannel, null);
            return objHasNext;
        } catch (Throwable th) {
            try {
                throw th;
            } catch (Throwable th2) {
                ChannelsKt.cancelConsumed(receiveChannel, th);
                throw th2;
            }
        }
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object count(kotlinx.coroutines.channels.ReceiveChannel r7, kotlin.coroutines.Continuation r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.count(kotlinx.coroutines.channels.ReceiveChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object maxWith(kotlinx.coroutines.channels.ReceiveChannel r8, java.util.Comparator r9, kotlin.coroutines.Continuation r10) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.maxWith(kotlinx.coroutines.channels.ReceiveChannel, java.util.Comparator, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @kotlin.Deprecated(level = kotlin.DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final java.lang.Object minWith(kotlinx.coroutines.channels.ReceiveChannel r8, java.util.Comparator r9, kotlin.coroutines.Continuation r10) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.minWith(kotlinx.coroutines.channels.ReceiveChannel, java.util.Comparator, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Binary compatibility")
    public static final Object none(ReceiveChannel receiveChannel, Continuation continuation) throws Throwable {
        C02391 c02391;
        if (continuation instanceof C02391) {
            c02391 = (C02391) continuation;
            if ((c02391.label & Integer.MIN_VALUE) != 0) {
                c02391.label -= Integer.MIN_VALUE;
            } else {
                c02391 = new C02391(continuation);
            }
        } else {
            c02391 = new C02391(continuation);
        }
        Object objHasNext = c02391.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02391.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objHasNext);
                ChannelIterator it = receiveChannel.iterator();
                c02391.L$0 = receiveChannel;
                c02391.label = 1;
                objHasNext = it.hasNext(c02391);
                if (objHasNext == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                receiveChannel = (ReceiveChannel) c02391.L$0;
                ResultKt.throwOnFailure(objHasNext);
            }
            Boolean boolBoxBoolean = Boxing.boxBoolean(!((Boolean) objHasNext).booleanValue());
            ChannelsKt.cancelConsumed(receiveChannel, null);
            return boolBoxBoolean;
        } catch (Throwable th) {
            try {
                throw th;
            } catch (Throwable th2) {
                ChannelsKt.cancelConsumed(receiveChannel, th);
                throw th2;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\u0010\u0000\u001a\u0002H\u0001\"\b\b\u0000\u0010\u0001*\u00020\u00022\b\u0010\u0003\u001a\u0004\u0018\u0001H\u0001H\n"}, m18d2 = {"<anonymous>", "E", "", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$requireNoNulls$1", m37f = "Deprecated.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02401<E> extends SuspendLambda implements Function2<E, Continuation<? super E>, Object> {
        final ReceiveChannel<E> $this_requireNoNulls;
        Object L$0;
        int label;

        C02401(ReceiveChannel<? extends E> receiveChannel, Continuation<? super C02401> continuation) {
            super(2, continuation);
            this.$this_requireNoNulls = receiveChannel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02401 c02401 = new C02401(this.$this_requireNoNulls, continuation);
            c02401.L$0 = obj;
            return c02401;
        }

        @Override
        public final Object invoke(E e, Continuation<? super E> continuation) {
            return ((C02401) create(e, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Object obj2 = this.L$0;
            if (obj2 != null) {
                return obj2;
            }
            throw new IllegalArgumentException("null element found in " + this.$this_requireNoNulls + '.');
        }
    }

    public static ReceiveChannel zip$default(ReceiveChannel receiveChannel, ReceiveChannel receiveChannel2, CoroutineContext coroutineContext, Function2 function2, int i, Object obj) {
        if ((i & 2) != 0) {
            coroutineContext = Dispatchers.getUnconfined();
        }
        return ChannelsKt.zip(receiveChannel, receiveChannel2, coroutineContext, function2);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "V", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt$zip$2", m37f = "Deprecated.kt", m38i = {0, 0, 0, 1, 1, 1, 1, 2, 2, 2}, m39l = {514, 499, HttpStatus.SC_NOT_IMPLEMENTED}, m40m = "invokeSuspend", m41n = {"$this$produce", "otherIterator", "$this$consume$iv$iv", "$this$produce", "otherIterator", "$this$consume$iv$iv", "element1", "$this$produce", "otherIterator", "$this$consume$iv$iv"}, m42s = {"L$0", "L$1", "L$3", "L$0", "L$1", "L$3", "L$5", "L$0", "L$1", "L$3"})
    static final class C02492<V> extends SuspendLambda implements Function2<ProducerScope<? super V>, Continuation<? super Unit>, Object> {
        final ReceiveChannel<R> $other;
        final ReceiveChannel<E> $this_zip;
        final Function2<E, R, V> $transform;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;

        C02492(ReceiveChannel<? extends R> receiveChannel, ReceiveChannel<? extends E> receiveChannel2, Function2<? super E, ? super R, ? extends V> function2, Continuation<? super C02492> continuation) {
            super(2, continuation);
            this.$other = receiveChannel;
            this.$this_zip = receiveChannel2;
            this.$transform = function2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02492 c02492 = new C02492(this.$other, this.$this_zip, this.$transform, continuation);
            c02492.L$0 = obj;
            return c02492;
        }

        @Override
        public final Object invoke(ProducerScope<? super V> producerScope, Continuation<? super Unit> continuation) {
            return ((C02492) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r14) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.ChannelsKt__DeprecatedKt.C02492.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final <E, R, V> ReceiveChannel<V> zip(ReceiveChannel<? extends E> receiveChannel, ReceiveChannel<? extends R> receiveChannel2, CoroutineContext coroutineContext, Function2<? super E, ? super R, ? extends V> function2) {
        return ProduceKt.produce$default(GlobalScope.INSTANCE, coroutineContext, 0, null, ChannelsKt.consumesAll(receiveChannel, receiveChannel2), new C02492(receiveChannel2, receiveChannel, function2, null), 6, null);
    }

    public static final Function1<Throwable, Unit> consumes(final ReceiveChannel<?> receiveChannel) {
        return new Function1() {
            @Override
            public final Object invoke(Object obj) {
                return ChannelsKt__DeprecatedKt.consumes$lambda$24$ChannelsKt__DeprecatedKt(receiveChannel, (Throwable) obj);
            }
        };
    }

    public static final Unit consumes$lambda$24$ChannelsKt__DeprecatedKt(ReceiveChannel receiveChannel, Throwable th) {
        ChannelsKt.cancelConsumed(receiveChannel, th);
        return Unit.INSTANCE;
    }

    @Deprecated(level = DeprecationLevel.ERROR, message = "BroadcastChannel is deprecated in the favour of SharedFlow and is no longer supported")
    private static final <E> Object consumeEach$$forInline(BroadcastChannel<E> broadcastChannel, Function1<? super E, Unit> function1, Continuation<? super Unit> continuation) {
        ReceiveChannel<E> receiveChannelOpenSubscription = broadcastChannel.openSubscription();
        try {
            ReceiveChannel<E> receiveChannel = receiveChannelOpenSubscription;
            ChannelIterator<E> it = receiveChannelOpenSubscription.iterator();
            while (((Boolean) it.hasNext(null)).booleanValue()) {
                function1.invoke(it.next());
            }
            Unit unit = Unit.INSTANCE;
            return Unit.INSTANCE;
        } finally {
            ReceiveChannel.DefaultImpls.cancel$default((ReceiveChannel) receiveChannelOpenSubscription, (CancellationException) null, 1, (Object) null);
        }
    }
}
