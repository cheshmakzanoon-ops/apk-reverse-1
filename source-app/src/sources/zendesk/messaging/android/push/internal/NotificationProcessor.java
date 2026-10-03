package zendesk.messaging.android.push.internal;

import android.app.Notification;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.app.Person;
import androidx.core.graphics.drawable.IconCompat;
import coil.ImageLoader;
import coil.request.ErrorResult;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import coil.request.SuccessResult;
import coil.transform.CircleCropTransformation;
import coil.transform.Transformation;
import j$.util.Objects;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.UnreadMessageCounter;
import zendesk.p026ui.android.internal.ImageLoaderFactory;

@Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010$\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 %2\u00020\u0001:\u0001%B\u0017\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J0\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\b\u0010\u0011\u001a\u0004\u0018\u00010\u000fH\u0082@¢\u0006\u0002\u0010\u0012J:\u0010\u0013\u001a\u00020\u00142\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u0015\u001a\u00020\t2\u0006\u0010\u0016\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u000f2\u0006\u0010\u0018\u001a\u00020\u00192\b\b\u0001\u0010\u001a\u001a\u00020\tH\u0007J<\u0010\u001b\u001a\u00020\u00142\u0006\u0010\f\u001a\u00020\r2\u0012\u0010\u001c\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0\u001d2\u0006\u0010\u0018\u001a\u00020\u00192\b\b\u0001\u0010\u001a\u001a\u00020\tH\u0087@¢\u0006\u0002\u0010\u001eJ.\u0010\u001f\u001a\u0004\u0018\u00010 2\u0006\u0010\f\u001a\u00020\r2\b\u0010!\u001a\u0004\u0018\u00010\u000f2\n\b\u0002\u0010\"\u001a\u0004\u0018\u00010#H\u0082@¢\u0006\u0002\u0010$R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006&"}, m18d2 = {"Lzendesk/messaging/android/push/internal/NotificationProcessor;", "", "unreadMessageCounter", "Lzendesk/messaging/android/internal/UnreadMessageCounter;", "json", "Lkotlinx/serialization/json/Json;", "(Lzendesk/messaging/android/internal/UnreadMessageCounter;Lkotlinx/serialization/json/Json;)V", "people", "", "", "Landroidx/core/app/Person;", "createPerson", "context", "Landroid/content/Context;", "authorId", "", "authorName", "avatarUrl", "(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "displayLocalNotification", "", "notificationId", "title", "body", "notificationBuilder", "Lzendesk/messaging/android/push/internal/NotificationBuilder;", "smallIconId", "displayPushNotification", "messageData", "", "(Landroid/content/Context;Ljava/util/Map;Lzendesk/messaging/android/push/internal/NotificationBuilder;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "loadBitmapImage", "Landroid/graphics/Bitmap;", "url", "imageTransformation", "Lcoil/transform/Transformation;", "(Landroid/content/Context;Ljava/lang/String;Lcoil/transform/Transformation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NotificationProcessor {
    private static final String LOG_TAG = "NotificationProcessor";
    private final Json json;
    private final Map<Integer, Person> people;
    private final UnreadMessageCounter unreadMessageCounter;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.push.internal.NotificationProcessor", m37f = "NotificationProcessor.kt", m38i = {0, 0, 0}, m39l = {136}, m40m = "createPerson", m41n = {"this", "builder", "personKey"}, m42s = {"L$0", "L$2", "I$0"})
    static final class C15291 extends ContinuationImpl {
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C15291(Continuation<? super C15291> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return NotificationProcessor.this.createPerson(null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.push.internal.NotificationProcessor", m37f = "NotificationProcessor.kt", m38i = {0, 0, 0, 0, 0, 0}, m39l = {75}, m40m = "displayPushNotification", m41n = {"this", "context", "notificationBuilder", "conversationId", "messagePayload", "smallIconId"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "I$0"})
    static final class C15301 extends ContinuationImpl {
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C15301(Continuation<? super C15301> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return NotificationProcessor.this.displayPushNotification(null, null, null, 0, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.push.internal.NotificationProcessor", m37f = "NotificationProcessor.kt", m38i = {}, m39l = {170}, m40m = "loadBitmapImage", m41n = {}, m42s = {})
    static final class C15311 extends ContinuationImpl {
        int label;
        Object result;

        C15311(Continuation<? super C15311> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return NotificationProcessor.this.loadBitmapImage(null, null, null, this);
        }
    }

    public NotificationProcessor(UnreadMessageCounter unreadMessageCounter, Json json) {
        Intrinsics.checkNotNullParameter(unreadMessageCounter, "unreadMessageCounter");
        Intrinsics.checkNotNullParameter(json, "json");
        this.unreadMessageCounter = unreadMessageCounter;
        this.json = json;
        this.people = new LinkedHashMap();
    }

    public NotificationProcessor(UnreadMessageCounter unreadMessageCounter, Json json, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? UnreadMessageCounter.INSTANCE : unreadMessageCounter, json);
    }

    public final Object displayPushNotification(Context context, Map<String, String> map, NotificationBuilder notificationBuilder, int i, Continuation<? super Unit> continuation) throws Throwable {
        C15301 c15301;
        MessagePayload messagePayload;
        String string;
        Context context2;
        MessagePayload messagePayload2;
        String str;
        NotificationProcessor notificationProcessor;
        String string2;
        if (continuation instanceof C15301) {
            c15301 = (C15301) continuation;
            if ((c15301.label & Integer.MIN_VALUE) != 0) {
                c15301.label -= Integer.MIN_VALUE;
            } else {
                c15301 = new C15301(continuation);
            }
        } else {
            c15301 = new C15301(continuation);
        }
        C15301 c15302 = c15301;
        Object obj = c15302.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c15302.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(obj);
            String str2 = map.get("conversationId");
            if (str2 == null) {
                Logger.m225w(LOG_TAG, "Unable to parse the received notification payload without a conversation id.", new Object[0]);
                return Unit.INSTANCE;
            }
            try {
                String str3 = map.get("message");
                if (str3 != null) {
                    Json json = this.json;
                    json.getSerializersModule();
                    messagePayload = (MessagePayload) json.decodeFromString(MessagePayload.INSTANCE.serializer(), str3);
                } else {
                    messagePayload = null;
                }
                if (messagePayload == null) {
                    Logger.m225w(LOG_TAG, "Unable to parse the received notification payload without a message.", new Object[0]);
                    return Unit.INSTANCE;
                }
                String name = messagePayload.getName();
                if (name == null || name.length() == 0) {
                    string = context.getString(C1256R.string.zma_notification_default_author_name);
                } else {
                    string = messagePayload.getName();
                }
                String str4 = string;
                Intrinsics.checkNotNull(str4);
                String authorId = messagePayload.getAuthorId();
                String avatarUrl = messagePayload.getAvatarUrl();
                c15302.L$0 = this;
                c15302.L$1 = context;
                c15302.L$2 = notificationBuilder;
                c15302.L$3 = str2;
                c15302.L$4 = messagePayload;
                c15302.I$0 = i;
                c15302.label = 1;
                Object objCreatePerson = createPerson(context, authorId, str4, avatarUrl, c15302);
                if (objCreatePerson == coroutine_suspended) {
                    return coroutine_suspended;
                }
                context2 = context;
                messagePayload2 = messagePayload;
                str = str2;
                obj = objCreatePerson;
                notificationProcessor = this;
            } catch (Exception e) {
                Logger.m218e(LOG_TAG, "Unable to parse the received notification payload.", e, new Object[0]);
                return Unit.INSTANCE;
            }
        } else {
            if (i2 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            i = c15302.I$0;
            messagePayload2 = (MessagePayload) c15302.L$4;
            str = (String) c15302.L$3;
            notificationBuilder = (NotificationBuilder) c15302.L$2;
            context2 = (Context) c15302.L$1;
            notificationProcessor = (NotificationProcessor) c15302.L$0;
            ResultKt.throwOnFailure(obj);
        }
        Person person = (Person) obj;
        int unreadMessageCount = notificationProcessor.unreadMessageCounter.getUnreadMessageCount(str);
        String text = messagePayload2.getText();
        if (text != null && text.length() != 0) {
            string2 = messagePayload2.getText();
        } else {
            string2 = context2.getString(C1256R.string.zma_notification_default_text);
            Intrinsics.checkNotNull(string2);
        }
        Notification notificationBuild = notificationBuilder.setMessagingStyle(string2, (long) (messagePayload2.getReceived() * ((double) 1000)), person).setSmallIcon(i).setCategory("msg").setAutoCancel(true).setUnreadCount(unreadMessageCount).setOpenConversationIntent(str).build();
        NotificationManagerCompat notificationManagerCompatFrom = NotificationManagerCompat.from(context2);
        Intrinsics.checkNotNullExpressionValue(notificationManagerCompatFrom, "from(...)");
        if (notificationManagerCompatFrom.areNotificationsEnabled()) {
            notificationManagerCompatFrom.notify(Objects.hash(new Object[]{str}), notificationBuild);
        } else {
            Logger.m225w(LOG_TAG, "Cannot display notification because the notification permission is not granted", new Object[0]);
        }
        return Unit.INSTANCE;
    }

    public final Object createPerson(Context context, String str, String str2, String str3, Continuation<? super Person> continuation) throws Throwable {
        C15291 c15291;
        Person.Builder name;
        NotificationProcessor notificationProcessor;
        int i;
        Person.Builder builder;
        if (continuation instanceof C15291) {
            c15291 = (C15291) continuation;
            if ((c15291.label & Integer.MIN_VALUE) != 0) {
                c15291.label -= Integer.MIN_VALUE;
            } else {
                c15291 = new C15291(continuation);
            }
        } else {
            c15291 = new C15291(continuation);
        }
        Object objLoadBitmapImage = c15291.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c15291.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(objLoadBitmapImage);
            int iHash = Objects.hash(new Object[]{str, str2, str3});
            Person person = this.people.get(Boxing.boxInt(iHash));
            if (person != null) {
                return person;
            }
            name = new Person.Builder().setName(str2);
            Transformation circleCropTransformation = new CircleCropTransformation();
            c15291.L$0 = this;
            c15291.L$1 = name;
            c15291.L$2 = name;
            c15291.I$0 = iHash;
            c15291.label = 1;
            objLoadBitmapImage = loadBitmapImage(context, str3, circleCropTransformation, c15291);
            if (objLoadBitmapImage == coroutine_suspended) {
                return coroutine_suspended;
            }
            notificationProcessor = this;
            i = iHash;
            builder = name;
        } else {
            if (i2 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            i = c15291.I$0;
            builder = (Person.Builder) c15291.L$2;
            name = (Person.Builder) c15291.L$1;
            notificationProcessor = (NotificationProcessor) c15291.L$0;
            ResultKt.throwOnFailure(objLoadBitmapImage);
        }
        Bitmap bitmap = (Bitmap) objLoadBitmapImage;
        if (bitmap != null) {
            builder.setIcon(IconCompat.createWithBitmap(bitmap));
        }
        Person personBuild = name.build();
        Intrinsics.checkNotNullExpressionValue(personBuild, "build(...)");
        notificationProcessor.people.put(Boxing.boxInt(i), personBuild);
        return personBuild;
    }

    public final Object loadBitmapImage(Context context, String str, Transformation transformation, Continuation<? super Bitmap> continuation) throws Throwable {
        C15311 c15311;
        if (continuation instanceof C15311) {
            c15311 = (C15311) continuation;
            if ((c15311.label & Integer.MIN_VALUE) != 0) {
                c15311.label -= Integer.MIN_VALUE;
            } else {
                c15311 = new C15311(continuation);
            }
        } else {
            c15311 = new C15311(continuation);
        }
        Object objExecute = c15311.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15311.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objExecute);
            String str2 = str;
            if (str2 == null || str2.length() == 0) {
                return null;
            }
            ImageLoader imageLoader = ImageLoaderFactory.INSTANCE.getImageLoader(context);
            ImageRequest.Builder builderAllowHardware = new ImageRequest.Builder(context).data(str).allowHardware(false);
            if (transformation != null) {
                builderAllowHardware.transformations(new Transformation[]{transformation});
            }
            ImageRequest imageRequestBuild = builderAllowHardware.build();
            c15311.label = 1;
            objExecute = imageLoader.execute(imageRequestBuild, c15311);
            if (objExecute == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objExecute);
        }
        SuccessResult successResult = (ImageResult) objExecute;
        if (successResult instanceof SuccessResult) {
            Drawable drawable = successResult.getDrawable();
            Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.BitmapDrawable");
            return ((BitmapDrawable) drawable).getBitmap();
        }
        if (successResult instanceof ErrorResult) {
            Logger.m225w(LOG_TAG, "Unable to load avatar image: " + ((ErrorResult) successResult).getThrowable().getMessage(), new Object[0]);
            return null;
        }
        throw new NoWhenBranchMatchedException();
    }

    static Object loadBitmapImage$default(NotificationProcessor notificationProcessor, Context context, String str, Transformation transformation, Continuation continuation, int i, Object obj) {
        if ((i & 4) != 0) {
            transformation = null;
        }
        return notificationProcessor.loadBitmapImage(context, str, transformation, continuation);
    }

    public final void displayLocalNotification(Context context, int notificationId, String title, String body, NotificationBuilder notificationBuilder, int smallIconId) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(body, "body");
        Intrinsics.checkNotNullParameter(notificationBuilder, "notificationBuilder");
        Notification notificationBuild = notificationBuilder.setTitle(title).setMessage(body).setSmallIcon(smallIconId).setCategory("msg").setAutoCancel(true).setOpenProactiveNotificationIntent(notificationId).build();
        NotificationManagerCompat notificationManagerCompatFrom = NotificationManagerCompat.from(context);
        Intrinsics.checkNotNullExpressionValue(notificationManagerCompatFrom, "from(...)");
        if (notificationManagerCompatFrom.areNotificationsEnabled()) {
            notificationManagerCompatFrom.notify(notificationId, notificationBuild);
        } else {
            Logger.m225w(LOG_TAG, "Cannot display notification because the notification permission is not granted", new Object[0]);
        }
    }
}
