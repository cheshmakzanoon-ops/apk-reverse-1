package com.facebook.internal;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.hardware.display.DisplayManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Parcel;
import android.os.StatFs;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.autofill.AutofillManager;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import androidx.compose.ui.graphics.Api26Bitmap$;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.location.LocationRequestCompat;
import androidx.exifinterface.media.ExifInterface;
import androidx.webkit.ProxyConfig;
import com.facebook.AccessToken;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.appevents.UserDataStore;
import com.facebook.appevents.codeless.internal.Constants;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.share.internal.ShareConstants;
import com.facebook.share.internal.ShareInternalUtility;
import java.io.BufferedInputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TimeZone;
import java.util.regex.Pattern;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Charsets;
import kotlin.text.Regex;
import kotlin.text.StringsKt;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

@Metadata(d1 = {"\u0000\u0090\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\f\n\u0002\u0010\t\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0010\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0006\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0011\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0010\u0012\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u001e\n\u0002\b\u0002\n\u0002\u0010\"\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0010\bÆ\u0002\u0018\u00002\u00020\u0001:\u0002ß\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J*\u0010:\u001a\u00020;2\u0006\u0010<\u001a\u00020\"2\u0006\u0010=\u001a\u00020>2\b\u0010?\u001a\u0004\u0018\u00010\u00042\u0006\u0010@\u001a\u00020AH\u0002J \u0010B\u001a\u00020;2\u0006\u0010<\u001a\u00020\"2\u0006\u0010=\u001a\u00020>2\u0006\u0010@\u001a\u00020AH\u0002J'\u0010C\u001a\u00020*\"\u0004\b\u0000\u0010D2\b\u0010E\u001a\u0004\u0018\u0001HD2\b\u0010F\u001a\u0004\u0018\u0001HDH\u0007¢\u0006\u0002\u0010GJ\u0012\u0010H\u001a\u0004\u0018\u00010\"2\u0006\u0010I\u001a\u00020\u0004H\u0007J&\u0010J\u001a\u00020K2\b\u0010L\u001a\u0004\u0018\u00010\u00042\b\u0010M\u001a\u0004\u0018\u00010\u00042\b\u0010N\u001a\u0004\u0018\u00010OH\u0007J\u0018\u0010P\u001a\u00020;2\u0006\u0010@\u001a\u00020A2\u0006\u0010Q\u001a\u00020\u0004H\u0002J\u0010\u0010R\u001a\u00020;2\u0006\u0010@\u001a\u00020AH\u0007J\u0012\u0010S\u001a\u00020;2\b\u0010T\u001a\u0004\u0018\u00010UH\u0007J\u001e\u0010V\u001a\u0004\u0018\u00010\u00042\b\u0010W\u001a\u0004\u0018\u00010\u00042\b\u0010X\u001a\u0004\u0018\u00010\u0004H\u0007J\u0010\u0010Y\u001a\u00020\u00132\u0006\u0010Z\u001a\u00020[H\u0002J\u0016\u0010\\\u001a\b\u0012\u0004\u0012\u00020\u00040]2\u0006\u0010^\u001a\u00020_H\u0007J\u001c\u0010`\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00010a2\u0006\u0010b\u001a\u00020\"H\u0007J\u001c\u0010c\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040a2\u0006\u0010b\u001a\u00020\"H\u0007J\u001a\u0010d\u001a\u00020\u00062\b\u0010e\u001a\u0004\u0018\u00010f2\u0006\u0010g\u001a\u00020hH\u0007J\u0012\u0010i\u001a\u00020;2\b\u0010j\u001a\u0004\u0018\u00010kH\u0007J\b\u0010l\u001a\u00020*H\u0002J\u0010\u0010m\u001a\u00020\u00042\u0006\u0010n\u001a\u00020\u0006H\u0007J\u0012\u0010o\u001a\u00020\u00042\b\u0010@\u001a\u0004\u0018\u00010AH\u0007J\u0010\u0010p\u001a\u00020\u00042\u0006\u0010@\u001a\u00020AH\u0007J\n\u0010q\u001a\u0004\u0018\u00010\u0004H\u0007J&\u0010r\u001a\u0004\u0018\u00010s2\b\u0010t\u001a\u0004\u0018\u00010O2\b\u0010u\u001a\u0004\u0018\u00010\u00042\u0006\u0010v\u001a\u00020sH\u0007J\u0010\u0010w\u001a\u00020\u00132\u0006\u0010x\u001a\u00020KH\u0007J\n\u0010y\u001a\u0004\u0018\u00010\u0004H\u0002J\u0012\u0010z\u001a\u00020\u00042\b\u0010{\u001a\u0004\u0018\u00010\u0004H\u0007J\u0010\u0010|\u001a\u00020}2\u0006\u0010I\u001a\u00020\u0004H\u0002J\u0019\u0010~\u001a\u00020;2\u0006\u0010I\u001a\u00020\u00042\u0007\u0010\u007f\u001a\u00030\u0080\u0001H\u0007J\u0013\u0010\u0081\u0001\u001a\u00020\u00042\b\u0010@\u001a\u0004\u0018\u00010AH\u0007JM\u0010\u0082\u0001\u001a\u0005\u0018\u00010\u0083\u00012\f\u0010\u0084\u0001\u001a\u0007\u0012\u0002\b\u00030\u0085\u00012\u0007\u0010\u0086\u0001\u001a\u00020\u00042\"\u0010\u0087\u0001\u001a\u0012\u0012\r\b\u0001\u0012\t\u0012\u0002\b\u0003\u0018\u00010\u0085\u00010\u0088\u0001\"\t\u0012\u0002\b\u0003\u0018\u00010\u0085\u0001H\u0007¢\u0006\u0003\u0010\u0089\u0001JH\u0010\u0082\u0001\u001a\u0005\u0018\u00010\u0083\u00012\u0007\u0010\u008a\u0001\u001a\u00020\u00042\u0007\u0010\u0086\u0001\u001a\u00020\u00042\"\u0010\u0087\u0001\u001a\u0012\u0012\r\b\u0001\u0012\t\u0012\u0002\b\u0003\u0018\u00010\u0085\u00010\u0088\u0001\"\t\u0012\u0002\b\u0003\u0018\u00010\u0085\u0001H\u0007¢\u0006\u0003\u0010\u008b\u0001J\u0014\u0010\u008c\u0001\u001a\u00020\u00042\t\u0010\u008d\u0001\u001a\u0004\u0018\u00010\u0004H\u0002J(\u0010\u008e\u0001\u001a\u0004\u0018\u00010\u00012\u0006\u0010b\u001a\u00020\"2\b\u0010u\u001a\u0004\u0018\u00010\u00042\t\u0010\u008f\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J\u0016\u0010\u0090\u0001\u001a\u0004\u0018\u00010\u00042\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010KH\u0007J\u001c\u0010\u0092\u0001\u001a\u00020\u00042\b\u0010\u0093\u0001\u001a\u00030\u0094\u00012\u0007\u0010Z\u001a\u00030\u0095\u0001H\u0002J\u001d\u0010\u0096\u0001\u001a\u0004\u0018\u00010\u00042\u0007\u0010\u0097\u0001\u001a\u00020\u00042\u0007\u0010Z\u001a\u00030\u0095\u0001H\u0002J\u001c\u0010\u0096\u0001\u001a\u0004\u0018\u00010\u00042\u0007\u0010\u0097\u0001\u001a\u00020\u00042\u0006\u0010u\u001a\u00020\u0004H\u0002J@\u0010\u0098\u0001\u001a\u0004\u0018\u00010\u00012\t\u0010\u0099\u0001\u001a\u0004\u0018\u00010\u00012\b\u0010\u009a\u0001\u001a\u00030\u0083\u00012\u0018\u0010\u009b\u0001\u001a\r\u0012\b\b\u0001\u0012\u0004\u0018\u00010\u00010\u0088\u0001\"\u0004\u0018\u00010\u0001H\u0007¢\u0006\u0003\u0010\u009c\u0001J\u0011\u0010\u009d\u0001\u001a\u00020*2\u0006\u0010@\u001a\u00020AH\u0007J\u0011\u0010\u009e\u0001\u001a\u00020*2\u0006\u0010@\u001a\u00020AH\u0007J\u0014\u0010\u009f\u0001\u001a\u00020*2\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010KH\u0007J\u0015\u0010 \u0001\u001a\u00020*2\n\u0010¡\u0001\u001a\u0005\u0018\u00010¢\u0001H\u0007J\u0014\u0010£\u0001\u001a\u00020*2\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010KH\u0007J\u0011\u0010¤\u0001\u001a\u00020*2\u0006\u0010@\u001a\u00020AH\u0002J\u0013\u0010¥\u0001\u001a\u00020*2\b\u0010W\u001a\u0004\u0018\u00010\u0004H\u0007J\u0019\u0010¥\u0001\u001a\u00020*2\u000e\u0010¦\u0001\u001a\t\u0012\u0002\b\u0003\u0018\u00010§\u0001H\u0007J\u0014\u0010¨\u0001\u001a\u00020*2\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010KH\u0007J\u0018\u0010©\u0001\u001a\t\u0012\u0004\u0012\u00020\u00040ª\u00012\u0006\u0010^\u001a\u00020_H\u0007J\u0017\u0010«\u0001\u001a\b\u0012\u0004\u0012\u00020\u00040]2\u0006\u0010^\u001a\u00020_H\u0007J\u001e\u0010¬\u0001\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040a2\u0007\u0010\u00ad\u0001\u001a\u00020\u0004H\u0007J'\u0010®\u0001\u001a\u00020;2\t\u0010¯\u0001\u001a\u0004\u0018\u00010\u00042\u0011\u0010°\u0001\u001a\f\u0018\u00010±\u0001j\u0005\u0018\u0001`²\u0001H\u0007J\u001f\u0010®\u0001\u001a\u00020;2\t\u0010¯\u0001\u001a\u0004\u0018\u00010\u00042\t\u0010³\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J+\u0010®\u0001\u001a\u00020;2\t\u0010¯\u0001\u001a\u0004\u0018\u00010\u00042\t\u0010³\u0001\u001a\u0004\u0018\u00010\u00042\n\u0010´\u0001\u001a\u0005\u0018\u00010µ\u0001H\u0007J\"\u0010¶\u0001\u001a\u00020\u00042\u0017\u0010·\u0001\u001a\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u00040aH\u0007J\u0013\u0010¸\u0001\u001a\u0004\u0018\u00010\u00042\u0006\u0010u\u001a\u00020\u0004H\u0007J\u0011\u0010¹\u0001\u001a\u00020*2\u0006\u0010@\u001a\u00020AH\u0007J\u0014\u0010º\u0001\u001a\u00020O2\t\u0010»\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J.\u0010¼\u0001\u001a\u00020;2\u0006\u0010F\u001a\u00020O2\b\u0010u\u001a\u0004\u0018\u00010\u00042\u0011\u0010½\u0001\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0018\u00010]H\u0007J&\u0010¾\u0001\u001a\u00020*2\u0006\u0010t\u001a\u00020O2\b\u0010u\u001a\u0004\u0018\u00010\u00042\t\u0010¿\u0001\u001a\u0004\u0018\u00010\u0001H\u0007J&\u0010À\u0001\u001a\u00020;2\u0006\u0010F\u001a\u00020O2\b\u0010u\u001a\u0004\u0018\u00010\u00042\t\u0010¿\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J&\u0010Á\u0001\u001a\u00020;2\u0006\u0010F\u001a\u00020O2\b\u0010u\u001a\u0004\u0018\u00010\u00042\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010KH\u0007J!\u0010Â\u0001\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0004\u0018\u00010a2\b\u0010Ã\u0001\u001a\u00030Ä\u0001H\u0007J\u0013\u0010Å\u0001\u001a\u00020\u00042\b\u0010e\u001a\u0004\u0018\u00010fH\u0007J%\u0010Æ\u0001\u001a\u0014\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0018\u00010a2\b\u0010Ã\u0001\u001a\u00030Ä\u0001H\u0007J\t\u0010Ç\u0001\u001a\u00020;H\u0002J\t\u0010È\u0001\u001a\u00020\u0006H\u0002J\u0012\u0010É\u0001\u001a\u00020;2\u0007\u0010Ê\u0001\u001a\u00020AH\u0002J\u0012\u0010Ë\u0001\u001a\u00020;2\u0007\u0010Ê\u0001\u001a\u00020AH\u0002J\t\u0010Ì\u0001\u001a\u00020;H\u0002J\t\u0010Í\u0001\u001a\u00020;H\u0002J\u0015\u0010Î\u0001\u001a\u00020;2\n\u0010Ï\u0001\u001a\u0005\u0018\u00010Ð\u0001H\u0007J\u001f\u0010Ñ\u0001\u001a\u00020\u00042\t\u0010Ò\u0001\u001a\u0004\u0018\u00010\"2\t\u0010Ó\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J6\u0010Ô\u0001\u001a\u00020;2\u0006\u0010<\u001a\u00020\"2\b\u0010=\u001a\u0004\u0018\u00010>2\b\u0010?\u001a\u0004\u0018\u00010\u00042\u0007\u0010Õ\u0001\u001a\u00020*2\u0006\u0010@\u001a\u00020AH\u0007J\u001a\u0010Ö\u0001\u001a\u00020;2\u0006\u0010<\u001a\u00020\"2\u0007\u0010Ê\u0001\u001a\u00020AH\u0007J\u0014\u0010×\u0001\u001a\u0004\u0018\u00010\u00042\u0007\u0010Z\u001a\u00030\u0095\u0001H\u0007J\u0013\u0010×\u0001\u001a\u0004\u0018\u00010\u00042\u0006\u0010u\u001a\u00020\u0004H\u0007J\u0016\u0010Ø\u0001\u001a\u0004\u0018\u00010\u00042\t\u0010Z\u001a\u0005\u0018\u00010\u0095\u0001H\u0007J\u0015\u0010Ø\u0001\u001a\u0004\u0018\u00010\u00042\b\u0010u\u001a\u0004\u0018\u00010\u0004H\u0007J\u001d\u0010Ù\u0001\u001a\u00020*2\b\u0010E\u001a\u0004\u0018\u00010\u00042\b\u0010F\u001a\u0004\u0018\u00010\u0004H\u0007J!\u0010Ú\u0001\u001a\u0004\u0018\u00010_2\t\u0010Ò\u0001\u001a\u0004\u0018\u00010\"2\t\u0010Û\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J!\u0010Ü\u0001\u001a\u0004\u0018\u00010\"2\t\u0010Ò\u0001\u001a\u0004\u0018\u00010\"2\t\u0010Û\u0001\u001a\u0004\u0018\u00010\u0004H\u0007J*\u0010Ý\u0001\u001a\u00020;2\b\u0010Ã\u0001\u001a\u00030Ä\u00012\u0015\u0010·\u0001\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0004\u0018\u00010aH\u0007J.\u0010Þ\u0001\u001a\u00020;2\b\u0010Ã\u0001\u001a\u00030Ä\u00012\u0019\u0010·\u0001\u001a\u0014\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0018\u00010aH\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u001a\u0010\u0012\u001a\u00020\u0013X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u001a\u0010\u0018\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR\u0011\u0010\u001d\u001a\u00020\u001e8G¢\u0006\u0006\u001a\u0004\b\u001f\u0010 R\u0013\u0010!\u001a\u0004\u0018\u00010\"8G¢\u0006\u0006\u001a\u0004\b#\u0010$R\u001a\u0010%\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010\u001a\"\u0004\b'\u0010\u001cR\u000e\u0010(\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010)\u001a\u00020*8FX\u0087\u0004¢\u0006\f\u0012\u0004\b+\u0010\u0002\u001a\u0004\b)\u0010,R\u0011\u0010-\u001a\u00020*8G¢\u0006\u0006\u001a\u0004\b-\u0010,R\u001c\u0010.\u001a\u0004\u0018\u00010\u001eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b/\u0010 \"\u0004\b0\u00101R\u000e\u00102\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0013\u00103\u001a\u0004\u0018\u00010\u001e8G¢\u0006\u0006\u001a\u0004\b4\u0010 R\u000e\u00105\u001a\u00020\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u00106\u001a\u00020\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u00107\u001a\u0004\u0018\u00010\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b8\u0010\u001a\"\u0004\b9\u0010\u001c¨\u0006à\u0001"}, d2 = {"Lcom/facebook/internal/Utility;", "", "()V", "ARC_DEVICE_PATTERN", "", "DEFAULT_STREAM_BUFFER_SIZE", "", "EXTRA_APP_EVENTS_INFO_FORMAT_VERSION", "FACEBOOK_PROFILE_FIELDS", "HASH_ALGORITHM_MD5", "HASH_ALGORITHM_SHA1", "HASH_ALGORITHM_SHA256", "INSTAGRAM_PROFILE_FIELDS", "LOG_TAG", "NO_CARRIER", "REFRESH_TIME_FOR_EXTENDED_DEVICE_INFO_MILLIS", "URL_SCHEME", "UTF8", "availableExternalStorageGB", "", "getAvailableExternalStorageGB", "()J", "setAvailableExternalStorageGB", "(J)V", "carrierName", "getCarrierName", "()Ljava/lang/String;", "setCarrierName", "(Ljava/lang/String;)V", "currentLocale", "Ljava/util/Locale;", "getCurrentLocale", "()Ljava/util/Locale;", "dataProcessingOptions", "Lorg/json/JSONObject;", "getDataProcessingOptions", "()Lorg/json/JSONObject;", "deviceTimeZoneName", "getDeviceTimeZoneName", "setDeviceTimeZoneName", "deviceTimezoneAbbreviation", "isAutoAppLinkSetup", "", "isAutoAppLinkSetup$annotations", "()Z", "isDataProcessingRestricted", "locale", "getLocale", "setLocale", "(Ljava/util/Locale;)V", "numCPUCores", "resourceLocale", "getResourceLocale", "timestampOfLastCheck", "totalExternalStorageGB", "versionName", "getVersionName", "setVersionName", "appendAnonIdUnderCompliance", "", NativeProtocol.WEB_DIALOG_PARAMS, "attributionIdentifiers", "Lcom/facebook/internal/AttributionIdentifiers;", "anonymousAppDeviceGUID", "context", "Landroid/content/Context;", "appendAttributionIdUnderCompliance", "areObjectsEqual", ExifInterface.GPS_DIRECTION_TRUE, "a", "b", "(Ljava/lang/Object;Ljava/lang/Object;)Z", "awaitGetGraphMeRequestWithCache", SDKConstants.PARAM_ACCESS_TOKEN, "buildUri", "Landroid/net/Uri;", "authority", "path", "parameters", "Landroid/os/Bundle;", "clearCookiesForDomain", "domain", "clearFacebookCookies", "closeQuietly", "closeable", "Ljava/io/Closeable;", "coerceValueIfNullOrEmpty", "s", "valueIfNullOrEmpty", "convertBytesToGB", "bytes", "", "convertJSONArrayToList", "", "jsonArray", "Lorg/json/JSONArray;", "convertJSONObjectToHashMap", "", "jsonObject", "convertJSONObjectToStringMap", "copyAndCloseInputStream", "inputStream", "Ljava/io/InputStream;", "outputStream", "Ljava/io/OutputStream;", "disconnectQuietly", "connection", "Ljava/net/URLConnection;", "externalStorageExists", "generateRandomString", "length", "getActivityName", "getAppName", "getAppVersion", "getBundleLongAsDate", "Ljava/util/Date;", "bundle", SDKConstants.PARAM_KEY, "dateBase", "getContentSize", "contentUri", "getCurrentTokenDomainWithDefault", "getGraphDomainFromTokenDomain", "tokenGraphDomain", "getGraphMeRequestWithCache", "Lcom/facebook/GraphRequest;", "getGraphMeRequestWithCacheAsync", "callback", "Lcom/facebook/internal/Utility$GraphMeRequestWithCacheCallback;", "getMetadataApplicationId", "getMethodQuietly", "Ljava/lang/reflect/Method;", "clazz", "Ljava/lang/Class;", "methodName", "parameterTypes", "", "(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;", "className", "(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;", "getProfileFieldsForGraphDomain", SDKConstants.PARAM_GRAPH_DOMAIN, "getStringPropertyAsJSON", "nonJSONPropertyKey", "getUriString", ShareConstants.MEDIA_URI, "hashBytes", "hash", "Ljava/security/MessageDigest;", "", "hashWithAlgorithm", "algorithm", "invokeMethodQuietly", "receiver", "method", "args", "(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;", "isAutofillAvailable", "isChromeOS", "isContentUri", "isCurrentAccessToken", "token", "Lcom/facebook/AccessToken;", "isFileUri", "isGooglePlayServicesAvailable", "isNullOrEmpty", "c", "", "isWebUri", "jsonArrayToSet", "", "jsonArrayToStringList", "jsonStrToMap", "str", "logd", "tag", "e", "Ljava/lang/Exception;", "Lkotlin/Exception;", "msg", "t", "", "mapToJsonStr", "map", "md5hash", "mustFixWindowParamsForAutofill", "parseUrlQueryString", "queryString", "putCommaSeparatedStringList", "list", "putJSONValueInBundle", SDKConstants.PARAM_VALUE, "putNonEmptyString", "putUri", "readNonnullStringMapFromParcel", "parcel", "Landroid/os/Parcel;", "readStreamToString", "readStringMapFromParcel", "refreshAvailableExternalStorage", "refreshBestGuessNumberOfCPUCores", "refreshCarrierName", "appContext", "refreshPeriodicExtendedDeviceInfo", "refreshTimezone", "refreshTotalExternalStorage", "runOnNonUiThread", "runnable", "Ljava/lang/Runnable;", "safeGetStringFromResponse", "response", "propertyName", "setAppEventAttributionParameters", "limitEventUsage", "setAppEventExtendedDeviceInfoParameters", "sha1hash", "sha256hash", "stringsEqualOrEmpty", "tryGetJSONArrayFromResponse", "propertyKey", "tryGetJSONObjectFromResponse", "writeNonnullStringMapToParcel", "writeStringMapToParcel", "GraphMeRequestWithCacheCallback", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Utility {
    private static final String ARC_DEVICE_PATTERN = ".+_cheets|cheets_.+";
    public static final int DEFAULT_STREAM_BUFFER_SIZE = 8192;
    private static final String EXTRA_APP_EVENTS_INFO_FORMAT_VERSION = "a2";
    private static final String FACEBOOK_PROFILE_FIELDS = "id,name,first_name,middle_name,last_name";
    private static final String HASH_ALGORITHM_MD5 = "MD5";
    private static final String HASH_ALGORITHM_SHA1 = "SHA-1";
    private static final String HASH_ALGORITHM_SHA256 = "SHA-256";
    private static final String INSTAGRAM_PROFILE_FIELDS = "id,name,profile_picture";
    public static final String LOG_TAG = "FacebookSDK";
    private static final int REFRESH_TIME_FOR_EXTENDED_DEVICE_INFO_MILLIS = 1800000;
    private static final String URL_SCHEME = "https";
    private static final String UTF8 = "UTF-8";
    private static Locale locale;
    private static int numCPUCores;
    public static final Utility INSTANCE = new Utility();
    private static long timestampOfLastCheck = -1;
    private static long totalExternalStorageGB = -1;
    private static long availableExternalStorageGB = -1;
    private static String deviceTimezoneAbbreviation = "";
    private static String deviceTimeZoneName = "";
    private static final String NO_CARRIER = "NoCarrier";
    private static String carrierName = NO_CARRIER;
    private static String versionName = "";

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\bf\u0018\u00002\u00020\u0001J\u0012\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005H&J\u0012\u0010\u0006\u001a\u00020\u00032\b\u0010\u0007\u001a\u0004\u0018\u00010\bH&¨\u0006\t"}, d2 = {"Lcom/facebook/internal/Utility$GraphMeRequestWithCacheCallback;", "", "onFailure", "", "error", "Lcom/facebook/FacebookException;", "onSuccess", "userInfo", "Lorg/json/JSONObject;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface GraphMeRequestWithCacheCallback {
        void onFailure(FacebookException error);

        void onSuccess(JSONObject userInfo);
    }

    @JvmStatic
    public static void isAutoAppLinkSetup$annotations() {
    }

    private Utility() {
    }

    public final long getAvailableExternalStorageGB() {
        return availableExternalStorageGB;
    }

    public final void setAvailableExternalStorageGB(long j) {
        availableExternalStorageGB = j;
    }

    public final String getDeviceTimeZoneName() {
        return deviceTimeZoneName;
    }

    public final void setDeviceTimeZoneName(String str) {
        Intrinsics.checkNotNullParameter(str, "<set-?>");
        deviceTimeZoneName = str;
    }

    public final String getCarrierName() {
        return carrierName;
    }

    public final void setCarrierName(String str) {
        Intrinsics.checkNotNullParameter(str, "<set-?>");
        carrierName = str;
    }

    public final String getVersionName() {
        return versionName;
    }

    public final void setVersionName(String str) {
        versionName = str;
    }

    public final Locale getLocale() {
        return locale;
    }

    public final void setLocale(Locale locale2) {
        locale = locale2;
    }

    @JvmStatic
    public static final boolean isNullOrEmpty(Collection<?> c) {
        return c == null || c.isEmpty();
    }

    @JvmStatic
    public static final boolean isNullOrEmpty(String s) {
        return s == null || s.length() == 0;
    }

    @JvmStatic
    public static final String coerceValueIfNullOrEmpty(String s, String valueIfNullOrEmpty) {
        return isNullOrEmpty(s) ? valueIfNullOrEmpty : s;
    }

    @JvmStatic
    public static final String md5hash(String key) {
        Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
        return INSTANCE.hashWithAlgorithm(HASH_ALGORITHM_MD5, key);
    }

    @JvmStatic
    public static final String sha1hash(String key) {
        Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
        return INSTANCE.hashWithAlgorithm(HASH_ALGORITHM_SHA1, key);
    }

    @JvmStatic
    public static final String sha1hash(byte[] bytes) {
        Intrinsics.checkNotNullParameter(bytes, "bytes");
        return INSTANCE.hashWithAlgorithm(HASH_ALGORITHM_SHA1, bytes);
    }

    @JvmStatic
    public static final String sha256hash(String key) {
        if (key == null) {
            return null;
        }
        return INSTANCE.hashWithAlgorithm(HASH_ALGORITHM_SHA256, key);
    }

    @JvmStatic
    public static final String sha256hash(byte[] bytes) {
        if (bytes == null) {
            return null;
        }
        return INSTANCE.hashWithAlgorithm(HASH_ALGORITHM_SHA256, bytes);
    }

    private final String hashWithAlgorithm(String algorithm, String key) {
        Charset charset = Charsets.UTF_8;
        if (key == null) {
            throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
        }
        byte[] bytes = key.getBytes(charset);
        Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
        return hashWithAlgorithm(algorithm, bytes);
    }

    private final String hashWithAlgorithm(String algorithm, byte[] bytes) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
            Intrinsics.checkNotNullExpressionValue(messageDigest, "hash");
            return hashBytes(messageDigest, bytes);
        } catch (NoSuchAlgorithmException unused) {
            return null;
        }
    }

    private final String hashBytes(MessageDigest hash, byte[] bytes) {
        hash.update(bytes);
        byte[] bArrDigest = hash.digest();
        StringBuilder sb = new StringBuilder();
        Intrinsics.checkNotNullExpressionValue(bArrDigest, "digest");
        int length = bArrDigest.length;
        int i = 0;
        while (i < length) {
            byte b = bArrDigest[i];
            i++;
            sb.append(Integer.toHexString((b >> 4) & 15));
            sb.append(Integer.toHexString(b & 15));
        }
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "builder.toString()");
        return string;
    }

    @JvmStatic
    public static final Uri buildUri(String authority, String path, Bundle parameters) {
        Uri.Builder builder = new Uri.Builder();
        builder.scheme("https");
        builder.authority(authority);
        builder.path(path);
        if (parameters != null) {
            for (String str : parameters.keySet()) {
                Object obj = parameters.get(str);
                if (obj instanceof String) {
                    builder.appendQueryParameter(str, (String) obj);
                }
            }
        }
        Uri uriBuild = builder.build();
        Intrinsics.checkNotNullExpressionValue(uriBuild, "builder.build()");
        return uriBuild;
    }

    @JvmStatic
    public static final Bundle parseUrlQueryString(String queryString) {
        Bundle bundle = new Bundle();
        if (!isNullOrEmpty(queryString)) {
            if (queryString == null) {
                throw new IllegalStateException("Required value was null.".toString());
            }
            Object[] array = StringsKt.split$default(queryString, new String[]{"&"}, false, 0, 6, (Object) null).toArray(new String[0]);
            if (array != null) {
                String[] strArr = (String[]) array;
                int length = strArr.length;
                int i = 0;
                while (i < length) {
                    String str = strArr[i];
                    i++;
                    Object[] array2 = StringsKt.split$default(str, new String[]{"="}, false, 0, 6, (Object) null).toArray(new String[0]);
                    if (array2 != null) {
                        String[] strArr2 = (String[]) array2;
                        try {
                            if (strArr2.length == 2) {
                                bundle.putString(URLDecoder.decode(strArr2[0], UTF8), URLDecoder.decode(strArr2[1], UTF8));
                            } else if (strArr2.length == 1) {
                                bundle.putString(URLDecoder.decode(strArr2[0], UTF8), "");
                            }
                        } catch (UnsupportedEncodingException e) {
                            logd(LOG_TAG, e);
                        }
                    } else {
                        throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
                    }
                }
            } else {
                throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
            }
        }
        return bundle;
    }

    @JvmStatic
    public static final void putNonEmptyString(Bundle b, String key, String value) {
        Intrinsics.checkNotNullParameter(b, "b");
        if (isNullOrEmpty(value)) {
            return;
        }
        b.putString(key, value);
    }

    @JvmStatic
    public static final void putCommaSeparatedStringList(Bundle b, String key, List<String> list) {
        Intrinsics.checkNotNullParameter(b, "b");
        if (list != null) {
            b.putString(key, TextUtils.join(",", list));
        }
    }

    @JvmStatic
    public static final void putUri(Bundle b, String key, Uri uri) {
        Intrinsics.checkNotNullParameter(b, "b");
        if (uri != null) {
            putNonEmptyString(b, key, uri.toString());
        }
    }

    @JvmStatic
    public static final boolean putJSONValueInBundle(Bundle bundle, String key, Object value) {
        Intrinsics.checkNotNullParameter(bundle, "bundle");
        if (value == null) {
            bundle.remove(key);
            return true;
        }
        if (value instanceof Boolean) {
            bundle.putBoolean(key, ((Boolean) value).booleanValue());
            return true;
        }
        if (value instanceof boolean[]) {
            bundle.putBooleanArray(key, (boolean[]) value);
            return true;
        }
        if (value instanceof Double) {
            bundle.putDouble(key, ((Number) value).doubleValue());
            return true;
        }
        if (value instanceof double[]) {
            bundle.putDoubleArray(key, (double[]) value);
            return true;
        }
        if (value instanceof Integer) {
            bundle.putInt(key, ((Number) value).intValue());
            return true;
        }
        if (value instanceof int[]) {
            bundle.putIntArray(key, (int[]) value);
            return true;
        }
        if (value instanceof Long) {
            bundle.putLong(key, ((Number) value).longValue());
            return true;
        }
        if (value instanceof long[]) {
            bundle.putLongArray(key, (long[]) value);
            return true;
        }
        if (value instanceof String) {
            bundle.putString(key, (String) value);
            return true;
        }
        if (value instanceof JSONArray) {
            bundle.putString(key, ((JSONArray) value).toString());
            return true;
        }
        if (!(value instanceof JSONObject)) {
            return false;
        }
        bundle.putString(key, ((JSONObject) value).toString());
        return true;
    }

    @JvmStatic
    public static final void closeQuietly(Closeable closeable) {
        if (closeable == null) {
            return;
        }
        try {
            closeable.close();
        } catch (IOException unused) {
        }
    }

    @JvmStatic
    public static final void disconnectQuietly(URLConnection connection) {
        if (connection == null || !(connection instanceof HttpURLConnection)) {
            return;
        }
        ((HttpURLConnection) connection).disconnect();
    }

    @JvmStatic
    public static final String getMetadataApplicationId(Context context) {
        Validate validate = Validate.INSTANCE;
        Validate.notNull(context, "context");
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        return FacebookSdk.getApplicationId();
    }

    @JvmStatic
    public static final Map<String, Object> convertJSONObjectToHashMap(JSONObject jsonObject) {
        Intrinsics.checkNotNullParameter(jsonObject, "jsonObject");
        HashMap map = new HashMap();
        JSONArray jSONArrayNames = jsonObject.names();
        if (jSONArrayNames == null) {
            return map;
        }
        int length = jSONArrayNames.length();
        if (length > 0) {
            int i = 0;
            while (true) {
                int i2 = i + 1;
                try {
                    String string = jSONArrayNames.getString(i);
                    Intrinsics.checkNotNullExpressionValue(string, "keys.getString(i)");
                    Object objConvertJSONObjectToHashMap = jsonObject.get(string);
                    if (objConvertJSONObjectToHashMap instanceof JSONObject) {
                        objConvertJSONObjectToHashMap = convertJSONObjectToHashMap((JSONObject) objConvertJSONObjectToHashMap);
                    }
                    Intrinsics.checkNotNullExpressionValue(objConvertJSONObjectToHashMap, SDKConstants.PARAM_VALUE);
                    map.put(string, objConvertJSONObjectToHashMap);
                } catch (JSONException unused) {
                }
                if (i2 >= length) {
                    break;
                }
                i = i2;
            }
        }
        return map;
    }

    @JvmStatic
    public static final Map<String, String> convertJSONObjectToStringMap(JSONObject jsonObject) {
        Intrinsics.checkNotNullParameter(jsonObject, "jsonObject");
        HashMap map = new HashMap();
        Iterator<String> itKeys = jsonObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            String strOptString = jsonObject.optString(next);
            if (strOptString != null) {
                Intrinsics.checkNotNullExpressionValue(next, SDKConstants.PARAM_KEY);
                map.put(next, strOptString);
            }
        }
        return map;
    }

    @JvmStatic
    public static final List<String> convertJSONArrayToList(JSONArray jsonArray) {
        Intrinsics.checkNotNullParameter(jsonArray, "jsonArray");
        try {
            ArrayList arrayList = new ArrayList();
            int length = jsonArray.length();
            if (length <= 0) {
                return arrayList;
            }
            int i = 0;
            while (true) {
                int i2 = i + 1;
                String string = jsonArray.getString(i);
                Intrinsics.checkNotNullExpressionValue(string, "jsonArray.getString(i)");
                arrayList.add(string);
                if (i2 >= length) {
                    return arrayList;
                }
                i = i2;
            }
        } catch (JSONException unused) {
            return new ArrayList();
        }
    }

    @JvmStatic
    public static final Object getStringPropertyAsJSON(JSONObject jsonObject, String key, String nonJSONPropertyKey) throws JSONException {
        Intrinsics.checkNotNullParameter(jsonObject, "jsonObject");
        Object objOpt = jsonObject.opt(key);
        if (objOpt != null && (objOpt instanceof String)) {
            objOpt = new JSONTokener((String) objOpt).nextValue();
        }
        if (objOpt == null || (objOpt instanceof JSONObject) || (objOpt instanceof JSONArray)) {
            return objOpt;
        }
        if (nonJSONPropertyKey != null) {
            JSONObject jSONObject = new JSONObject();
            jSONObject.putOpt(nonJSONPropertyKey, objOpt);
            return jSONObject;
        }
        throw new FacebookException("Got an unexpected non-JSON object.");
    }

    @JvmStatic
    public static final String readStreamToString(InputStream inputStream) throws Throwable {
        BufferedInputStream bufferedInputStream;
        Throwable th;
        InputStreamReader inputStreamReader;
        try {
            bufferedInputStream = new BufferedInputStream(inputStream);
            try {
                inputStreamReader = new InputStreamReader(bufferedInputStream);
                try {
                    StringBuilder sb = new StringBuilder();
                    char[] cArr = new char[2048];
                    while (true) {
                        int i = inputStreamReader.read(cArr);
                        if (i != -1) {
                            sb.append(cArr, 0, i);
                        } else {
                            String string = sb.toString();
                            Intrinsics.checkNotNullExpressionValue(string, "{\n      bufferedInputStream = BufferedInputStream(inputStream)\n      reader = InputStreamReader(bufferedInputStream)\n      val stringBuilder = StringBuilder()\n      val bufferSize = 1024 * 2\n      val buffer = CharArray(bufferSize)\n      var n = 0\n      while (reader.read(buffer).also { n = it } != -1) {\n        stringBuilder.append(buffer, 0, n)\n      }\n      stringBuilder.toString()\n    }");
                            closeQuietly(bufferedInputStream);
                            closeQuietly(inputStreamReader);
                            return string;
                        }
                    }
                } catch (Throwable th2) {
                    th = th2;
                    closeQuietly(bufferedInputStream);
                    closeQuietly(inputStreamReader);
                    throw th;
                }
            } catch (Throwable th3) {
                th = th3;
                inputStreamReader = null;
            }
        } catch (Throwable th4) {
            bufferedInputStream = null;
            th = th4;
            inputStreamReader = null;
        }
    }

    @JvmStatic
    public static final int copyAndCloseInputStream(InputStream inputStream, OutputStream outputStream) throws Throwable {
        Intrinsics.checkNotNullParameter(outputStream, "outputStream");
        BufferedInputStream bufferedInputStream = null;
        try {
            BufferedInputStream bufferedInputStream2 = new BufferedInputStream(inputStream);
            try {
                byte[] bArr = new byte[8192];
                int i = 0;
                while (true) {
                    int i2 = bufferedInputStream2.read(bArr);
                    if (i2 == -1) {
                        break;
                    }
                    outputStream.write(bArr, 0, i2);
                    i += i2;
                }
                bufferedInputStream2.close();
                if (inputStream != null) {
                    inputStream.close();
                }
                return i;
            } catch (Throwable th) {
                th = th;
                bufferedInputStream = bufferedInputStream2;
                if (bufferedInputStream != null) {
                    bufferedInputStream.close();
                }
                if (inputStream != null) {
                    inputStream.close();
                }
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    @JvmStatic
    public static final boolean stringsEqualOrEmpty(String a, String b) {
        String str = a;
        boolean z = str == null || str.length() == 0;
        String str2 = b;
        boolean z2 = str2 == null || str2.length() == 0;
        if (z && z2) {
            return true;
        }
        if (z || z2) {
            return false;
        }
        return Intrinsics.areEqual(a, b);
    }

    private final void clearCookiesForDomain(Context context, String domain) {
        CookieSyncManager.createInstance(context).sync();
        CookieManager cookieManager = CookieManager.getInstance();
        String cookie = cookieManager.getCookie(domain);
        if (cookie == null) {
            return;
        }
        Object[] array = StringsKt.split$default(cookie, new String[]{";"}, false, 0, 6, (Object) null).toArray(new String[0]);
        if (array != null) {
            String[] strArr = (String[]) array;
            int length = strArr.length;
            int i = 0;
            while (i < length) {
                String str = strArr[i];
                i++;
                Object[] array2 = StringsKt.split$default(str, new String[]{"="}, false, 0, 6, (Object) null).toArray(new String[0]);
                if (array2 != null) {
                    String[] strArr2 = (String[]) array2;
                    if (strArr2.length > 0) {
                        String str2 = strArr2[0];
                        int length2 = str2.length() - 1;
                        int i2 = 0;
                        boolean z = false;
                        while (i2 <= length2) {
                            boolean z2 = Intrinsics.compare(str2.charAt(!z ? i2 : length2), 32) <= 0;
                            if (z) {
                                if (!z2) {
                                    break;
                                } else {
                                    length2--;
                                }
                            } else if (z2) {
                                i2++;
                            } else {
                                z = true;
                            }
                        }
                        cookieManager.setCookie(domain, Intrinsics.stringPlus(str2.subSequence(i2, length2 + 1).toString(), "=;expires=Sat, 1 Jan 2000 00:00:01 UTC;"));
                    }
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
                }
            }
            cookieManager.removeExpiredCookie();
            return;
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<T>");
    }

    @JvmStatic
    public static final void clearFacebookCookies(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        try {
            Utility utility = INSTANCE;
            utility.clearCookiesForDomain(context, FacebookSdk.FACEBOOK_COM);
            utility.clearCookiesForDomain(context, ".facebook.com");
            utility.clearCookiesForDomain(context, "https://facebook.com");
            utility.clearCookiesForDomain(context, "https://.facebook.com");
        } catch (Exception unused) {
        }
    }

    @JvmStatic
    public static final void logd(String tag, Exception e) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (!FacebookSdk.isDebugEnabled() || tag == null || e == null) {
            return;
        }
        Log.d(tag, e.getClass().getSimpleName() + ": " + ((Object) e.getMessage()));
    }

    @JvmStatic
    public static final void logd(String tag, String msg) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (!FacebookSdk.isDebugEnabled() || tag == null || msg == null) {
            return;
        }
        Log.d(tag, msg);
    }

    @JvmStatic
    public static final void logd(String tag, String msg, Throwable t) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (!FacebookSdk.isDebugEnabled() || isNullOrEmpty(tag)) {
            return;
        }
        Log.d(tag, msg, t);
    }

    @JvmStatic
    public static final <T> boolean areObjectsEqual(T a, T b) {
        if (a == null) {
            return b == null;
        }
        return Intrinsics.areEqual(a, b);
    }

    @JvmStatic
    public static final String safeGetStringFromResponse(JSONObject response, String propertyName) {
        if (response != null) {
            String strOptString = response.optString(propertyName, "");
            Intrinsics.checkNotNullExpressionValue(strOptString, "response.optString(propertyName, \"\")");
            return strOptString;
        }
        return "";
    }

    @JvmStatic
    public static final JSONObject tryGetJSONObjectFromResponse(JSONObject response, String propertyKey) {
        if (response == null) {
            return null;
        }
        return response.optJSONObject(propertyKey);
    }

    @JvmStatic
    public static final JSONArray tryGetJSONArrayFromResponse(JSONObject response, String propertyKey) {
        if (response == null) {
            return null;
        }
        return response.optJSONArray(propertyKey);
    }

    @JvmStatic
    public static final List<String> jsonArrayToStringList(JSONArray jsonArray) throws JSONException {
        Intrinsics.checkNotNullParameter(jsonArray, "jsonArray");
        ArrayList arrayList = new ArrayList();
        int length = jsonArray.length();
        if (length > 0) {
            int i = 0;
            while (true) {
                int i2 = i + 1;
                arrayList.add(jsonArray.getString(i));
                if (i2 >= length) {
                    break;
                }
                i = i2;
            }
        }
        return arrayList;
    }

    @JvmStatic
    public static final Set<String> jsonArrayToSet(JSONArray jsonArray) throws JSONException {
        Intrinsics.checkNotNullParameter(jsonArray, "jsonArray");
        HashSet hashSet = new HashSet();
        int length = jsonArray.length();
        if (length > 0) {
            int i = 0;
            while (true) {
                int i2 = i + 1;
                String string = jsonArray.getString(i);
                Intrinsics.checkNotNullExpressionValue(string, "jsonArray.getString(i)");
                hashSet.add(string);
                if (i2 >= length) {
                    break;
                }
                i = i2;
            }
        }
        return hashSet;
    }

    @JvmStatic
    public static final String mapToJsonStr(Map<String, String> map) {
        Intrinsics.checkNotNullParameter(map, "map");
        String string = "";
        if (!map.isEmpty()) {
            try {
                JSONObject jSONObject = new JSONObject();
                for (Map.Entry<String, String> entry : map.entrySet()) {
                    jSONObject.put(entry.getKey(), entry.getValue());
                }
                string = jSONObject.toString();
            } catch (JSONException unused) {
            }
            Intrinsics.checkNotNullExpressionValue(string, "{\n      try {\n        val jsonObject = JSONObject()\n        for ((key, value) in map) {\n          jsonObject.put(key, value)\n        }\n        jsonObject.toString()\n      } catch (_e: JSONException) {\n        \"\"\n      }\n    }");
        }
        return string;
    }

    @JvmStatic
    public static final Map<String, String> jsonStrToMap(String str) {
        Intrinsics.checkNotNullParameter(str, "str");
        if (str.length() == 0) {
            return new HashMap();
        }
        try {
            HashMap map = new HashMap();
            JSONObject jSONObject = new JSONObject(str);
            Iterator<String> itKeys = jSONObject.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                Intrinsics.checkNotNullExpressionValue(next, SDKConstants.PARAM_KEY);
                String string = jSONObject.getString(next);
                Intrinsics.checkNotNullExpressionValue(string, "jsonObject.getString(key)");
                map.put(next, string);
            }
            return map;
        } catch (JSONException unused) {
            return new HashMap();
        }
    }

    @JvmStatic
    public static final void setAppEventAttributionParameters(JSONObject params, AttributionIdentifiers attributionIdentifiers, String anonymousAppDeviceGUID, boolean limitEventUsage, Context context) throws JSONException {
        Intrinsics.checkNotNullParameter(params, NativeProtocol.WEB_DIALOG_PARAMS);
        Intrinsics.checkNotNullParameter(context, "context");
        FeatureManager featureManager = FeatureManager.INSTANCE;
        if (!FeatureManager.isEnabled(FeatureManager.Feature.ServiceUpdateCompliance)) {
            params.put("anon_id", anonymousAppDeviceGUID);
        }
        params.put("application_tracking_enabled", !limitEventUsage);
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        params.put("advertiser_id_collection_enabled", FacebookSdk.getAdvertiserIDCollectionEnabled());
        if (attributionIdentifiers != null) {
            FeatureManager featureManager2 = FeatureManager.INSTANCE;
            if (FeatureManager.isEnabled(FeatureManager.Feature.ServiceUpdateCompliance)) {
                INSTANCE.appendAnonIdUnderCompliance(params, attributionIdentifiers, anonymousAppDeviceGUID, context);
            }
            if (attributionIdentifiers.getAttributionId() != null) {
                FeatureManager featureManager3 = FeatureManager.INSTANCE;
                if (FeatureManager.isEnabled(FeatureManager.Feature.ServiceUpdateCompliance)) {
                    INSTANCE.appendAttributionIdUnderCompliance(params, attributionIdentifiers, context);
                } else {
                    params.put("attribution", attributionIdentifiers.getAttributionId());
                }
            }
            if (attributionIdentifiers.getAndroidAdvertiserId() != null) {
                params.put("advertiser_id", attributionIdentifiers.getAndroidAdvertiserId());
                params.put("advertiser_tracking_enabled", !attributionIdentifiers.getIsTrackingLimited());
            }
            if (!attributionIdentifiers.getIsTrackingLimited()) {
                UserDataStore userDataStore = UserDataStore.INSTANCE;
                String allHashedUserData = UserDataStore.getAllHashedUserData();
                if (allHashedUserData.length() != 0) {
                    params.put("ud", allHashedUserData);
                }
            }
            if (attributionIdentifiers.getAndroidInstallerPackage() != null) {
                params.put("installer_package", attributionIdentifiers.getAndroidInstallerPackage());
            }
        }
    }

    @JvmStatic
    public static final String getAppVersion() {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        Context applicationContext = FacebookSdk.getApplicationContext();
        if (applicationContext == null) {
            return null;
        }
        try {
            PackageInfo packageInfo = applicationContext.getPackageManager().getPackageInfo(applicationContext.getPackageName(), 0);
            if (packageInfo == null) {
                return null;
            }
            return packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException unused) {
            return null;
        }
    }

    @JvmStatic
    public static final void setAppEventExtendedDeviceInfoParameters(JSONObject params, Context appContext) throws JSONException {
        Locale locale2;
        String language;
        int i;
        String country;
        Intrinsics.checkNotNullParameter(params, NativeProtocol.WEB_DIALOG_PARAMS);
        Intrinsics.checkNotNullParameter(appContext, "appContext");
        JSONArray jSONArray = new JSONArray();
        Utility utility = INSTANCE;
        jSONArray.put(EXTRA_APP_EVENTS_INFO_FORMAT_VERSION);
        utility.refreshPeriodicExtendedDeviceInfo(appContext);
        String packageName = appContext.getPackageName();
        int i2 = 0;
        int i3 = -1;
        try {
            PackageInfo packageInfo = appContext.getPackageManager().getPackageInfo(packageName, 0);
            if (packageInfo == null) {
                return;
            }
            i3 = packageInfo.versionCode;
            versionName = packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException unused) {
        }
        jSONArray.put(packageName);
        jSONArray.put(i3);
        jSONArray.put(versionName);
        jSONArray.put(Build.VERSION.RELEASE);
        jSONArray.put(Build.MODEL);
        try {
            locale2 = appContext.getResources().getConfiguration().locale;
        } catch (Exception unused2) {
            locale2 = Locale.getDefault();
        }
        locale = locale2;
        StringBuilder sb = new StringBuilder();
        Locale locale3 = locale;
        String str = "";
        if (locale3 == null || (language = locale3.getLanguage()) == null) {
            language = "";
        }
        sb.append(language);
        sb.append('_');
        Locale locale4 = locale;
        if (locale4 != null && (country = locale4.getCountry()) != null) {
            str = country;
        }
        sb.append(str);
        jSONArray.put(sb.toString());
        jSONArray.put(deviceTimezoneAbbreviation);
        jSONArray.put(carrierName);
        double d = 0.0d;
        try {
            Object systemService = appContext.getSystemService(ServerProtocol.DIALOG_PARAM_DISPLAY);
            Display display = null;
            DisplayManager displayManager = systemService instanceof DisplayManager ? (DisplayManager) systemService : null;
            if (displayManager != null) {
                display = displayManager.getDisplay(0);
            }
            if (display != null) {
                DisplayMetrics displayMetrics = new DisplayMetrics();
                display.getMetrics(displayMetrics);
                int i4 = displayMetrics.widthPixels;
                try {
                    i2 = displayMetrics.heightPixels;
                    d = displayMetrics.density;
                } catch (Exception unused3) {
                }
                i = i2;
                i2 = i4;
            } else {
                i = 0;
            }
        } catch (Exception unused4) {
        }
        jSONArray.put(i2);
        jSONArray.put(i);
        jSONArray.put(new DecimalFormat("#.##").format(d));
        jSONArray.put(INSTANCE.refreshBestGuessNumberOfCPUCores());
        jSONArray.put(totalExternalStorageGB);
        jSONArray.put(availableExternalStorageGB);
        jSONArray.put(deviceTimeZoneName);
        params.put(Constants.EXTINFO, jSONArray.toString());
    }

    @JvmStatic
    public static final Method getMethodQuietly(Class<?> clazz, String methodName, Class<?>... parameterTypes) {
        Intrinsics.checkNotNullParameter(clazz, "clazz");
        Intrinsics.checkNotNullParameter(methodName, "methodName");
        Intrinsics.checkNotNullParameter(parameterTypes, "parameterTypes");
        try {
            return clazz.getMethod(methodName, (Class[]) Arrays.copyOf(parameterTypes, parameterTypes.length));
        } catch (NoSuchMethodException unused) {
            return null;
        }
    }

    @JvmStatic
    public static final Method getMethodQuietly(String className, String methodName, Class<?>... parameterTypes) {
        Intrinsics.checkNotNullParameter(className, "className");
        Intrinsics.checkNotNullParameter(methodName, "methodName");
        Intrinsics.checkNotNullParameter(parameterTypes, "parameterTypes");
        try {
            Class<?> cls = Class.forName(className);
            Intrinsics.checkNotNullExpressionValue(cls, "clazz");
            return getMethodQuietly(cls, methodName, (Class<?>[]) Arrays.copyOf(parameterTypes, parameterTypes.length));
        } catch (ClassNotFoundException unused) {
            return null;
        }
    }

    @JvmStatic
    public static final Object invokeMethodQuietly(Object receiver, Method method, Object... args) {
        Intrinsics.checkNotNullParameter(method, "method");
        Intrinsics.checkNotNullParameter(args, "args");
        try {
            return method.invoke(receiver, Arrays.copyOf(args, args.length));
        } catch (IllegalAccessException | InvocationTargetException unused) {
            return null;
        }
    }

    @JvmStatic
    public static final String getActivityName(Context context) {
        if (context == null) {
            return "null";
        }
        if (context == context.getApplicationContext()) {
            return "unknown";
        }
        String simpleName = context.getClass().getSimpleName();
        Intrinsics.checkNotNullExpressionValue(simpleName, "{\n      context.javaClass.simpleName\n    }");
        return simpleName;
    }

    @JvmStatic
    public static final String getUriString(Uri uri) {
        if (uri == null) {
            return null;
        }
        return uri.toString();
    }

    @JvmStatic
    public static final boolean isWebUri(Uri uri) {
        return uri != null && (StringsKt.equals(ProxyConfig.MATCH_HTTP, uri.getScheme(), true) || StringsKt.equals("https", uri.getScheme(), true) || StringsKt.equals("fbstaging", uri.getScheme(), true));
    }

    @JvmStatic
    public static final boolean isContentUri(Uri uri) {
        return uri != null && StringsKt.equals("content", uri.getScheme(), true);
    }

    @JvmStatic
    public static final boolean isFileUri(Uri uri) {
        return uri != null && StringsKt.equals(ShareInternalUtility.STAGING_PARAM, uri.getScheme(), true);
    }

    @JvmStatic
    public static final long getContentSize(Uri contentUri) {
        Intrinsics.checkNotNullParameter(contentUri, "contentUri");
        Cursor cursorQuery = null;
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            cursorQuery = FacebookSdk.getApplicationContext().getContentResolver().query(contentUri, null, null, null, null);
            if (cursorQuery == null) {
                return 0L;
            }
            int columnIndex = cursorQuery.getColumnIndex("_size");
            cursorQuery.moveToFirst();
            long j = cursorQuery.getLong(columnIndex);
            cursorQuery.close();
            return j;
        } catch (Throwable th) {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            throw th;
        }
    }

    @JvmStatic
    public static final Date getBundleLongAsDate(Bundle bundle, String key, Date dateBase) {
        long jLongValue;
        Intrinsics.checkNotNullParameter(dateBase, "dateBase");
        if (bundle == null) {
            return null;
        }
        Object obj = bundle.get(key);
        if (obj instanceof Long) {
            jLongValue = ((Number) obj).longValue();
        } else {
            if (obj instanceof String) {
                try {
                    jLongValue = Long.parseLong((String) obj);
                } catch (NumberFormatException unused) {
                }
            }
            return null;
        }
        if (jLongValue == 0) {
            return new Date(LocationRequestCompat.PASSIVE_INTERVAL);
        }
        return new Date(dateBase.getTime() + (jLongValue * 1000));
    }

    @JvmStatic
    public static final void writeStringMapToParcel(Parcel parcel, Map<String, String> map) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        if (map == null) {
            parcel.writeInt(-1);
            return;
        }
        parcel.writeInt(map.size());
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            parcel.writeString(key);
            parcel.writeString(value);
        }
    }

    @JvmStatic
    public static final Map<String, String> readStringMapFromParcel(Parcel parcel) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        int i = parcel.readInt();
        if (i < 0) {
            return null;
        }
        HashMap map = new HashMap();
        if (i > 0) {
            int i2 = 0;
            do {
                i2++;
                map.put(parcel.readString(), parcel.readString());
            } while (i2 < i);
        }
        return map;
    }

    @JvmStatic
    public static final void writeNonnullStringMapToParcel(Parcel parcel, Map<String, String> map) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        if (map == null) {
            parcel.writeInt(-1);
            return;
        }
        parcel.writeInt(map.size());
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            parcel.writeString(key);
            parcel.writeString(value);
        }
    }

    @JvmStatic
    public static final Map<String, String> readNonnullStringMapFromParcel(Parcel parcel) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        int i = parcel.readInt();
        if (i < 0) {
            return null;
        }
        HashMap map = new HashMap();
        if (i > 0) {
            int i2 = 0;
            do {
                i2++;
                String string = parcel.readString();
                String string2 = parcel.readString();
                if (string != null && string2 != null) {
                    map.put(string, string2);
                }
            } while (i2 < i);
        }
        return map;
    }

    @JvmStatic
    public static final boolean isCurrentAccessToken(AccessToken token) {
        return token != null && Intrinsics.areEqual(token, AccessToken.INSTANCE.getCurrentAccessToken());
    }

    @JvmStatic
    public static final String getGraphDomainFromTokenDomain(String tokenGraphDomain) {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        String facebookDomain = FacebookSdk.getFacebookDomain();
        if (tokenGraphDomain == null) {
            return facebookDomain;
        }
        if (Intrinsics.areEqual(tokenGraphDomain, FacebookSdk.GAMING)) {
            return StringsKt.replace$default(facebookDomain, FacebookSdk.FACEBOOK_COM, "fb.gg", false, 4, (Object) null);
        }
        return Intrinsics.areEqual(tokenGraphDomain, FacebookSdk.INSTAGRAM) ? StringsKt.replace$default(facebookDomain, FacebookSdk.FACEBOOK_COM, FacebookSdk.INSTAGRAM_COM, false, 4, (Object) null) : facebookDomain;
    }

    @JvmStatic
    public static final void getGraphMeRequestWithCacheAsync(final String accessToken, final GraphMeRequestWithCacheCallback callback) {
        Intrinsics.checkNotNullParameter(accessToken, SDKConstants.PARAM_ACCESS_TOKEN);
        Intrinsics.checkNotNullParameter(callback, "callback");
        ProfileInformationCache profileInformationCache = ProfileInformationCache.INSTANCE;
        JSONObject profileInformation = ProfileInformationCache.getProfileInformation(accessToken);
        if (profileInformation != null) {
            callback.onSuccess(profileInformation);
            return;
        }
        GraphRequest.Callback callback2 = new GraphRequest.Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                Utility.m2511getGraphMeRequestWithCacheAsync$lambda3(callback, accessToken, graphResponse);
            }
        };
        GraphRequest graphMeRequestWithCache = INSTANCE.getGraphMeRequestWithCache(accessToken);
        graphMeRequestWithCache.setCallback(callback2);
        graphMeRequestWithCache.executeAsync();
    }

    public static final void m2511getGraphMeRequestWithCacheAsync$lambda3(GraphMeRequestWithCacheCallback graphMeRequestWithCacheCallback, String str, GraphResponse graphResponse) {
        Intrinsics.checkNotNullParameter(graphMeRequestWithCacheCallback, "$callback");
        Intrinsics.checkNotNullParameter(str, "$accessToken");
        Intrinsics.checkNotNullParameter(graphResponse, "response");
        if (graphResponse.getError() != null) {
            graphMeRequestWithCacheCallback.onFailure(graphResponse.getError().getException());
            return;
        }
        ProfileInformationCache profileInformationCache = ProfileInformationCache.INSTANCE;
        JSONObject jsonObject = graphResponse.getJsonObject();
        if (jsonObject == null) {
            throw new IllegalStateException("Required value was null.".toString());
        }
        ProfileInformationCache.putProfileInformation(str, jsonObject);
        graphMeRequestWithCacheCallback.onSuccess(graphResponse.getJsonObject());
    }

    @JvmStatic
    public static final JSONObject awaitGetGraphMeRequestWithCache(String accessToken) {
        Intrinsics.checkNotNullParameter(accessToken, SDKConstants.PARAM_ACCESS_TOKEN);
        ProfileInformationCache profileInformationCache = ProfileInformationCache.INSTANCE;
        JSONObject profileInformation = ProfileInformationCache.getProfileInformation(accessToken);
        if (profileInformation != null) {
            return profileInformation;
        }
        GraphResponse graphResponseExecuteAndWait = INSTANCE.getGraphMeRequestWithCache(accessToken).executeAndWait();
        if (graphResponseExecuteAndWait.getError() != null) {
            return null;
        }
        return graphResponseExecuteAndWait.getJsonObject();
    }

    private final GraphRequest getGraphMeRequestWithCache(String accessToken) {
        Bundle bundle = new Bundle();
        bundle.putString(GraphRequest.FIELDS_PARAM, getProfileFieldsForGraphDomain(getCurrentTokenDomainWithDefault()));
        bundle.putString("access_token", accessToken);
        GraphRequest graphRequestNewMeRequest = GraphRequest.INSTANCE.newMeRequest(null, null);
        graphRequestNewMeRequest.setParameters(bundle);
        graphRequestNewMeRequest.setHttpMethod(HttpMethod.GET);
        return graphRequestNewMeRequest;
    }

    private final String getProfileFieldsForGraphDomain(String graphDomain) {
        if (Intrinsics.areEqual(graphDomain, FacebookSdk.INSTAGRAM)) {
            return INSTAGRAM_PROFILE_FIELDS;
        }
        return FACEBOOK_PROFILE_FIELDS;
    }

    private final String getCurrentTokenDomainWithDefault() {
        AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
        if (currentAccessToken != null && currentAccessToken.getGraphDomain() != null) {
            return currentAccessToken.getGraphDomain();
        }
        return AccessToken.DEFAULT_GRAPH_DOMAIN;
    }

    private final int refreshBestGuessNumberOfCPUCores() {
        int i = numCPUCores;
        if (i > 0) {
            return i;
        }
        try {
            File[] fileArrListFiles = new File("/sys/devices/system/cpu/").listFiles(new FilenameFilter() {
                @Override
                public final boolean accept(File file, String str) {
                    return Utility.m2512refreshBestGuessNumberOfCPUCores$lambda4(file, str);
                }
            });
            if (fileArrListFiles != null) {
                numCPUCores = fileArrListFiles.length;
            }
        } catch (Exception unused) {
        }
        if (numCPUCores <= 0) {
            numCPUCores = Math.max(Runtime.getRuntime().availableProcessors(), 1);
        }
        return numCPUCores;
    }

    public static final boolean m2512refreshBestGuessNumberOfCPUCores$lambda4(File file, String str) {
        return Pattern.matches("cpu[0-9]+", str);
    }

    private final void refreshPeriodicExtendedDeviceInfo(Context appContext) {
        if (timestampOfLastCheck == -1 || System.currentTimeMillis() - timestampOfLastCheck >= 1800000) {
            timestampOfLastCheck = System.currentTimeMillis();
            refreshTimezone();
            refreshCarrierName(appContext);
            refreshTotalExternalStorage();
            refreshAvailableExternalStorage();
        }
    }

    private final void refreshTimezone() {
        try {
            TimeZone timeZone = TimeZone.getDefault();
            String displayName = timeZone.getDisplayName(timeZone.inDaylightTime(new Date()), 0);
            Intrinsics.checkNotNullExpressionValue(displayName, "tz.getDisplayName(tz.inDaylightTime(Date()), TimeZone.SHORT)");
            deviceTimezoneAbbreviation = displayName;
            String id = timeZone.getID();
            Intrinsics.checkNotNullExpressionValue(id, "tz.id");
            deviceTimeZoneName = id;
        } catch (AssertionError | Exception unused) {
        }
    }

    private final void refreshCarrierName(Context appContext) {
        if (Intrinsics.areEqual(carrierName, NO_CARRIER)) {
            try {
                Object systemService = appContext.getSystemService("phone");
                if (systemService == null) {
                    throw new NullPointerException("null cannot be cast to non-null type android.telephony.TelephonyManager");
                }
                String networkOperatorName = ((TelephonyManager) systemService).getNetworkOperatorName();
                Intrinsics.checkNotNullExpressionValue(networkOperatorName, "telephonyManager.networkOperatorName");
                carrierName = networkOperatorName;
            } catch (Exception unused) {
            }
        }
    }

    private final boolean externalStorageExists() {
        return Intrinsics.areEqual("mounted", Environment.getExternalStorageState());
    }

    private final void refreshAvailableExternalStorage() {
        try {
            if (externalStorageExists()) {
                StatFs statFs = new StatFs(Environment.getExternalStorageDirectory().getPath());
                availableExternalStorageGB = ((long) statFs.getAvailableBlocks()) * ((long) statFs.getBlockSize());
            }
            availableExternalStorageGB = convertBytesToGB(availableExternalStorageGB);
        } catch (Exception unused) {
        }
    }

    private final void refreshTotalExternalStorage() {
        try {
            if (externalStorageExists()) {
                StatFs statFs = new StatFs(Environment.getExternalStorageDirectory().getPath());
                totalExternalStorageGB = ((long) statFs.getBlockCount()) * ((long) statFs.getBlockSize());
            }
            totalExternalStorageGB = convertBytesToGB(totalExternalStorageGB);
        } catch (Exception unused) {
        }
    }

    private final long convertBytesToGB(double bytes) {
        return Math.round(bytes / 1.073741824E9d);
    }

    private final void appendAnonIdUnderCompliance(JSONObject params, AttributionIdentifiers attributionIdentifiers, String anonymousAppDeviceGUID, Context context) throws JSONException {
        if (Build.VERSION.SDK_INT >= 31 && isGooglePlayServicesAvailable(context)) {
            if (attributionIdentifiers.getIsTrackingLimited()) {
                return;
            }
            params.put("anon_id", anonymousAppDeviceGUID);
            return;
        }
        params.put("anon_id", anonymousAppDeviceGUID);
    }

    private final void appendAttributionIdUnderCompliance(JSONObject params, AttributionIdentifiers attributionIdentifiers, Context context) throws JSONException {
        if (Build.VERSION.SDK_INT >= 31 && isGooglePlayServicesAvailable(context)) {
            if (attributionIdentifiers.getIsTrackingLimited()) {
                return;
            }
            params.put("attribution", attributionIdentifiers.getAttributionId());
            return;
        }
        params.put("attribution", attributionIdentifiers.getAttributionId());
    }

    private final boolean isGooglePlayServicesAvailable(Context context) {
        Method methodQuietly = getMethodQuietly("com.google.android.gms.common.GooglePlayServicesUtil", "isGooglePlayServicesAvailable", (Class<?>[]) new Class[]{Context.class});
        if (methodQuietly == null) {
            return false;
        }
        Object objInvokeMethodQuietly = invokeMethodQuietly(null, methodQuietly, context);
        return (objInvokeMethodQuietly instanceof Integer) && Intrinsics.areEqual(objInvokeMethodQuietly, 0);
    }

    @JvmStatic
    public static final String generateRandomString(int length) {
        String string = new BigInteger(length * 5, new Random()).toString(32);
        Intrinsics.checkNotNullExpressionValue(string, "BigInteger(length * 5, r).toString(32)");
        return string;
    }

    @JvmStatic
    public static final boolean mustFixWindowParamsForAutofill(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        return isAutofillAvailable(context);
    }

    @JvmStatic
    public static final boolean isAutofillAvailable(Context context) {
        AutofillManager autofillManagerM;
        Intrinsics.checkNotNullParameter(context, "context");
        return Build.VERSION.SDK_INT >= 26 && (autofillManagerM = Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(context.getSystemService(Api26Bitmap$.ExternalSyntheticApiModelOutline0.m()))) != null && autofillManagerM.isAutofillSupported() && autofillManagerM.isEnabled();
    }

    @JvmStatic
    public static final boolean isChromeOS(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        if (Build.VERSION.SDK_INT >= 27) {
            return context.getPackageManager().hasSystemFeature("android.hardware.type.pc");
        }
        if (Build.DEVICE != null) {
            String str = Build.DEVICE;
            Intrinsics.checkNotNullExpressionValue(str, "DEVICE");
            if (new Regex(ARC_DEVICE_PATTERN).matches(str)) {
                return true;
            }
        }
        return false;
    }

    @JvmStatic
    public static final Locale getResourceLocale() {
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            return FacebookSdk.getApplicationContext().getResources().getConfiguration().locale;
        } catch (Exception unused) {
            return null;
        }
    }

    @JvmStatic
    public static final Locale getCurrentLocale() {
        Locale resourceLocale = getResourceLocale();
        if (resourceLocale != null) {
            return resourceLocale;
        }
        Locale locale2 = Locale.getDefault();
        Intrinsics.checkNotNullExpressionValue(locale2, "getDefault()");
        return locale2;
    }

    @JvmStatic
    public static final void runOnNonUiThread(Runnable runnable) {
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            FacebookSdk.getExecutor().execute(runnable);
        } catch (Exception unused) {
        }
    }

    @JvmStatic
    public static final String getAppName(Context context) {
        String string;
        Intrinsics.checkNotNullParameter(context, "context");
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            String applicationName = FacebookSdk.getApplicationName();
            if (applicationName != null) {
                return applicationName;
            }
            ApplicationInfo applicationInfo = context.getApplicationInfo();
            int i = applicationInfo.labelRes;
            if (i == 0) {
                string = applicationInfo.nonLocalizedLabel.toString();
            } else {
                string = context.getString(i);
                Intrinsics.checkNotNullExpressionValue(string, "context.getString(stringId)");
            }
            return string;
        } catch (Exception unused) {
            return "";
        }
    }

    public static final boolean isAutoAppLinkSetup() {
        try {
            Intent intent = new Intent("android.intent.action.VIEW");
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            String str = String.format("fb%s://applinks", Arrays.copyOf(new Object[]{FacebookSdk.getApplicationId()}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
            intent.setData(Uri.parse(str));
            FacebookSdk facebookSdk2 = FacebookSdk.INSTANCE;
            Context applicationContext = FacebookSdk.getApplicationContext();
            PackageManager packageManager = applicationContext.getPackageManager();
            String packageName = applicationContext.getPackageName();
            List<ResolveInfo> listQueryIntentActivities = packageManager.queryIntentActivities(intent, 65536);
            Intrinsics.checkNotNullExpressionValue(listQueryIntentActivities, "packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)");
            Iterator<ResolveInfo> it = listQueryIntentActivities.iterator();
            while (it.hasNext()) {
                if (Intrinsics.areEqual(packageName, it.next().activityInfo.packageName)) {
                    return true;
                }
            }
        } catch (Exception unused) {
        }
        return false;
    }

    @JvmStatic
    public static final JSONObject getDataProcessingOptions() {
        if (CrashShieldHandler.isObjectCrashing(Utility.class)) {
            return null;
        }
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            String string = FacebookSdk.getApplicationContext().getSharedPreferences(FacebookSdk.DATA_PROCESSING_OPTIONS_PREFERENCES, 0).getString(FacebookSdk.DATA_PROCESSION_OPTIONS, null);
            if (string != null) {
                try {
                    return new JSONObject(string);
                } catch (JSONException unused) {
                }
            }
            return null;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Utility.class);
            return null;
        }
    }

    @JvmStatic
    public static final boolean isDataProcessingRestricted() {
        if (CrashShieldHandler.isObjectCrashing(Utility.class)) {
            return false;
        }
        try {
            JSONObject dataProcessingOptions = getDataProcessingOptions();
            if (dataProcessingOptions == null) {
                return false;
            }
            try {
                JSONArray jSONArray = dataProcessingOptions.getJSONArray(FacebookSdk.DATA_PROCESSION_OPTIONS);
                int length = jSONArray.length();
                if (length > 0) {
                    int i = 0;
                    while (true) {
                        int i2 = i + 1;
                        String string = jSONArray.getString(i);
                        Intrinsics.checkNotNullExpressionValue(string, "options.getString(i)");
                        String lowerCase = string.toLowerCase();
                        Intrinsics.checkNotNullExpressionValue(lowerCase, "(this as java.lang.String).toLowerCase()");
                        if (Intrinsics.areEqual(lowerCase, "ldu")) {
                            return true;
                        }
                        if (i2 < length) {
                            i = i2;
                        }
                    }
                }
            } catch (Exception unused) {
            }
            return false;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, Utility.class);
            return false;
        }
    }
}
