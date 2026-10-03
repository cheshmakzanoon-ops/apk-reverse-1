package zendesk.messaging.android.internal;

import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.ActivityResultRegistry;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.model.UploadFile;

@Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u0000 -2\u00020\u0001:\u0001-BE\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0018\u0010\u0006\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\t0\b\u0012\u0004\u0012\u00020\n0\u0007\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\f\u0012\u0006\u0010\r\u001a\u00020\u000e¢\u0006\u0002\u0010\u000fJ\u0016\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00130\b2\u0006\u0010\u0019\u001a\u00020\u001aH\u0002J$\u0010\u001b\u001a\u00020\n2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\t0\b2\f\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00130\bH\u0002J\u0010\u0010\u001e\u001a\u00020\n2\u0006\u0010\u0019\u001a\u00020\u001aH\u0002J\u0010\u0010\u001f\u001a\u00020\n2\u0006\u0010 \u001a\u00020\tH\u0002J\"\u0010!\u001a\u00020\n2\u0006\u0010\"\u001a\u00020\u00152\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\n0\u0007J(\u0010$\u001a\u00020\n2\u0006\u0010\"\u001a\u00020\u00152\u0018\u0010%\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\b\u0012\u0004\u0012\u00020\n0\u0007J\u0010\u0010&\u001a\u00020\n2\u0006\u0010'\u001a\u00020(H\u0016J\u001e\u0010)\u001a\u00020\n2\u0006\u0010\"\u001a\u00020\u00152\f\u0010*\u001a\b\u0012\u0004\u0012\u00020\n0\fH\u0002J\u0010\u0010+\u001a\u00020\n2\u0006\u0010'\u001a\u00020(H\u0002J\u0010\u0010,\u001a\u00020\n2\u0006\u0010'\u001a\u00020(H\u0002R\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\t0\u0011X\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\"\u0010\u0012\u001a\u0016\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\b\u0012\u0004\u0012\u00020\n\u0018\u00010\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00150\u0011X\u0082.¢\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\fX\u0082\u0004¢\u0006\u0002\n\u0000R \u0010\u0006\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\t0\b\u0012\u0004\u0012\u00020\n0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\n\u0018\u00010\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0017\u001a\u0004\u0018\u00010\tX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006."}, m18d2 = {"Lzendesk/messaging/android/internal/AttachmentIntentsLauncher;", "Landroidx/lifecycle/DefaultLifecycleObserver;", "registry", "Landroidx/activity/result/ActivityResultRegistry;", "fileResolver", "Lzendesk/messaging/android/internal/AttachmentFileResolver;", "onSaveListOfUris", "Lkotlin/Function1;", "", "Landroid/net/Uri;", "", "onRestoreUrisToUploadFiles", "Lkotlin/Function0;", "context", "Landroid/content/Context;", "(Landroidx/activity/result/ActivityResultRegistry;Lzendesk/messaging/android/internal/AttachmentFileResolver;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Landroid/content/Context;)V", "cameraLauncher", "Landroidx/activity/result/ActivityResultLauncher;", "documentSelectedResultCallback", "Lzendesk/messaging/android/internal/model/UploadFile;", "galleryLauncher", "Landroid/content/Intent;", "photoCapturedResultCallback", "temporaryPhotoUri", "createListOfUploadFileForSelectedFiles", "clipData", "Landroid/content/ClipData;", "handleDocumentSelection", "uris", "files", "handleMultipleFileSelection", "handleSingleFileSelection", "uri", "launchCamera", "intent", "onPhotoCapturedResult", "launchGallery", "onDocumentSelectedResult", "onCreate", "owner", "Landroidx/lifecycle/LifecycleOwner;", "resolveActivity", "action", "setupCameraLauncher", "setupGalleryLauncher", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AttachmentIntentsLauncher implements DefaultLifecycleObserver {
    private static final String DOCUMENT_PICKER_KEY = "DOCUMENT_PICKER_KEY";
    private static final String LOG_TAG = "AttachmentIntentsLauncher";
    private static final String TAKE_PICTURE_KEY = "TAKE_PICTURE_KEY";
    private ActivityResultLauncher<Uri> cameraLauncher;
    private final Context context;
    private Function1<? super List<UploadFile>, Unit> documentSelectedResultCallback;
    private final AttachmentFileResolver fileResolver;
    private ActivityResultLauncher<Intent> galleryLauncher;
    private final Function0<Unit> onRestoreUrisToUploadFiles;
    private final Function1<List<? extends Uri>, Unit> onSaveListOfUris;
    private Function1<? super UploadFile, Unit> photoCapturedResultCallback;
    private final ActivityResultRegistry registry;
    private Uri temporaryPhotoUri;

    public void onDestroy(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onDestroy(this, lifecycleOwner);
    }

    public void onPause(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onPause(this, lifecycleOwner);
    }

    public void onResume(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onResume(this, lifecycleOwner);
    }

    public void onStart(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStart(this, lifecycleOwner);
    }

    public void onStop(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStop(this, lifecycleOwner);
    }

    public AttachmentIntentsLauncher(ActivityResultRegistry registry, AttachmentFileResolver fileResolver, Function1<? super List<? extends Uri>, Unit> onSaveListOfUris, Function0<Unit> onRestoreUrisToUploadFiles, Context context) {
        Intrinsics.checkNotNullParameter(registry, "registry");
        Intrinsics.checkNotNullParameter(fileResolver, "fileResolver");
        Intrinsics.checkNotNullParameter(onSaveListOfUris, "onSaveListOfUris");
        Intrinsics.checkNotNullParameter(onRestoreUrisToUploadFiles, "onRestoreUrisToUploadFiles");
        Intrinsics.checkNotNullParameter(context, "context");
        this.registry = registry;
        this.fileResolver = fileResolver;
        this.onSaveListOfUris = onSaveListOfUris;
        this.onRestoreUrisToUploadFiles = onRestoreUrisToUploadFiles;
        this.context = context;
    }

    public void onCreate(LifecycleOwner owner) {
        Intrinsics.checkNotNullParameter(owner, "owner");
        DefaultLifecycleObserver.-CC.$default$onCreate(this, owner);
        setupCameraLauncher(owner);
        setupGalleryLauncher(owner);
    }

    private final void setupCameraLauncher(LifecycleOwner owner) {
        this.cameraLauncher = this.registry.register(TAKE_PICTURE_KEY, owner, new ActivityResultContracts.TakePicture(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                AttachmentIntentsLauncher.setupCameraLauncher$lambda$1(this.f$0, ((Boolean) obj).booleanValue());
            }
        });
    }

    public static final void setupCameraLauncher$lambda$1(AttachmentIntentsLauncher this$0, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (z) {
            Uri uri = this$0.temporaryPhotoUri;
            Unit unit = null;
            if (uri != null) {
                UploadFile uploadFileCreateUploadFileFromUri = this$0.fileResolver.createUploadFileFromUri(this$0.context, uri);
                Function1<? super UploadFile, Unit> function1 = this$0.photoCapturedResultCallback;
                if (function1 != null) {
                    function1.invoke(uploadFileCreateUploadFileFromUri);
                }
                this$0.photoCapturedResultCallback = null;
                unit = Unit.INSTANCE;
            }
            if (unit == null) {
                this$0.onRestoreUrisToUploadFiles.invoke();
            }
        }
    }

    public final void launchCamera(Intent intent, final Function1<? super UploadFile, Unit> onPhotoCapturedResult) {
        Intrinsics.checkNotNullParameter(intent, "intent");
        Intrinsics.checkNotNullParameter(onPhotoCapturedResult, "onPhotoCapturedResult");
        resolveActivity(intent, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() throws IOException {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() throws IOException {
                AttachmentFileResolver attachmentFileResolver = AttachmentIntentsLauncher.this.fileResolver;
                AttachmentIntentsLauncher attachmentIntentsLauncher = AttachmentIntentsLauncher.this;
                Function1<UploadFile, Unit> function1 = onPhotoCapturedResult;
                Uri uriCreateUriToCapturePhoto = attachmentFileResolver.createUriToCapturePhoto(attachmentIntentsLauncher.context);
                if (uriCreateUriToCapturePhoto != null) {
                    attachmentIntentsLauncher.temporaryPhotoUri = uriCreateUriToCapturePhoto;
                    attachmentIntentsLauncher.onSaveListOfUris.invoke(CollectionsKt.listOf(uriCreateUriToCapturePhoto));
                    ActivityResultLauncher activityResultLauncher = attachmentIntentsLauncher.cameraLauncher;
                    if (activityResultLauncher == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("cameraLauncher");
                        activityResultLauncher = null;
                    }
                    activityResultLauncher.launch(uriCreateUriToCapturePhoto);
                    attachmentIntentsLauncher.photoCapturedResultCallback = function1;
                }
            }
        });
    }

    private final void setupGalleryLauncher(LifecycleOwner owner) {
        this.galleryLauncher = this.registry.register(DOCUMENT_PICKER_KEY, owner, new ActivityResultContracts.StartActivityForResult(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                AttachmentIntentsLauncher.setupGalleryLauncher$lambda$2(this.f$0, (ActivityResult) obj);
            }
        });
    }

    public static final void setupGalleryLauncher$lambda$2(AttachmentIntentsLauncher this$0, ActivityResult activityResult) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(activityResult, "activityResult");
        if (activityResult.getResultCode() == -1) {
            Intent data = activityResult.getData();
            Uri data2 = data != null ? data.getData() : null;
            Intent data3 = activityResult.getData();
            ClipData clipData = data3 != null ? data3.getClipData() : null;
            if (data2 != null) {
                this$0.handleSingleFileSelection(data2);
            } else if (clipData != null) {
                this$0.handleMultipleFileSelection(clipData);
            }
        }
    }

    public final void launchGallery(final Intent intent, final Function1<? super List<UploadFile>, Unit> onDocumentSelectedResult) {
        Intrinsics.checkNotNullParameter(intent, "intent");
        Intrinsics.checkNotNullParameter(onDocumentSelectedResult, "onDocumentSelectedResult");
        resolveActivity(intent, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ActivityResultLauncher activityResultLauncher = AttachmentIntentsLauncher.this.galleryLauncher;
                if (activityResultLauncher == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("galleryLauncher");
                    activityResultLauncher = null;
                }
                activityResultLauncher.launch(intent);
                AttachmentIntentsLauncher.this.documentSelectedResultCallback = onDocumentSelectedResult;
            }
        });
    }

    private final void handleSingleFileSelection(Uri uri) {
        handleDocumentSelection(CollectionsKt.listOf(uri), CollectionsKt.listOf(this.fileResolver.createUploadFileFromUri(this.context, uri)));
    }

    private final void handleMultipleFileSelection(ClipData clipData) {
        List<UploadFile> listCreateListOfUploadFileForSelectedFiles = createListOfUploadFileForSelectedFiles(clipData);
        List<UploadFile> list = listCreateListOfUploadFileForSelectedFiles;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
        Iterator<T> it = list.iterator();
        while (it.hasNext()) {
            arrayList.add(Uri.parse(((UploadFile) it.next()).getUri()));
        }
        handleDocumentSelection(arrayList, listCreateListOfUploadFileForSelectedFiles);
    }

    private final List<UploadFile> createListOfUploadFileForSelectedFiles(ClipData clipData) {
        int itemCount = clipData.getItemCount();
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < itemCount; i++) {
            Uri uri = clipData.getItemAt(i).getUri();
            AttachmentFileResolver attachmentFileResolver = this.fileResolver;
            Context context = this.context;
            Intrinsics.checkNotNull(uri);
            attachmentFileResolver.grantPersistentMediaAccess(context, uri);
            arrayList.add(this.fileResolver.createUploadFileFromUri(this.context, uri));
        }
        return arrayList;
    }

    private final void handleDocumentSelection(List<? extends Uri> uris, List<UploadFile> files) {
        Unit unit;
        this.onSaveListOfUris.invoke(uris);
        Function1<? super List<UploadFile>, Unit> function1 = this.documentSelectedResultCallback;
        if (function1 != null) {
            function1.invoke(files);
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            this.onRestoreUrisToUploadFiles.invoke();
        }
    }

    private final void resolveActivity(Intent intent, Function0<Unit> action) {
        if (intent.resolveActivity(this.context.getPackageManager()) != null) {
            action.invoke();
            return;
        }
        Logger.m219e(LOG_TAG, "Unable to find activity to launch the " + intent.getAction(), new Object[0]);
    }
}
