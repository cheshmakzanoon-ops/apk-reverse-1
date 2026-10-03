package net.aihelp.core.p004ui.glide.load.data;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Priority;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.ImageHeaderParser;

public class MediaStoreThumbFetcher implements DataFetcher<InputStream> {
    private static final ThumbnailStreamOpenerFactory DEFAULT_FACTORY = new ThumbnailStreamOpenerFactory();
    private static final int MINI_HEIGHT = 384;
    private static final int MINI_WIDTH = 512;
    private static final String TAG = "MediaStoreThumbFetcher";
    private final Context context;
    private final DataFetcher<InputStream> defaultFetcher;
    private final ThumbnailStreamOpenerFactory factory;
    private final int height;
    private InputStream inputStream;
    private final Uri mediaStoreUri;
    private final int width;

    interface ThumbnailQuery {
        Cursor queryPath(Context context, Uri uri);
    }

    @Override
    public void cancel() {
    }

    public MediaStoreThumbFetcher(Context context, Uri uri, DataFetcher<InputStream> dataFetcher, int i, int i2) {
        this(context, uri, dataFetcher, i, i2, DEFAULT_FACTORY);
    }

    MediaStoreThumbFetcher(Context context, Uri uri, DataFetcher<InputStream> dataFetcher, int i, int i2, ThumbnailStreamOpenerFactory thumbnailStreamOpenerFactory) {
        this.context = context;
        this.mediaStoreUri = uri;
        this.defaultFetcher = dataFetcher;
        this.width = i;
        this.height = i2;
        this.factory = thumbnailStreamOpenerFactory;
    }

    @Override
    public InputStream loadData(Priority priority) throws Exception {
        ThumbnailStreamOpener thumbnailStreamOpenerBuild = this.factory.build(this.mediaStoreUri, this.width, this.height);
        if (thumbnailStreamOpenerBuild != null) {
            this.inputStream = openThumbInputStream(thumbnailStreamOpenerBuild);
        }
        if (this.inputStream == null) {
            this.inputStream = this.defaultFetcher.loadData(priority);
        }
        return this.inputStream;
    }

    private InputStream openThumbInputStream(ThumbnailStreamOpener thumbnailStreamOpener) {
        InputStream inputStreamOpen;
        try {
            inputStreamOpen = thumbnailStreamOpener.open(this.context, this.mediaStoreUri);
        } catch (FileNotFoundException e) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Failed to find thumbnail file", e);
            }
            inputStreamOpen = null;
        }
        int orientation = inputStreamOpen != null ? thumbnailStreamOpener.getOrientation(this.context, this.mediaStoreUri) : -1;
        return orientation != -1 ? new ExifOrientationStream(inputStreamOpen, orientation) : inputStreamOpen;
    }

    @Override
    public void cleanup() {
        InputStream inputStream = this.inputStream;
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException unused) {
            }
        }
        this.defaultFetcher.cleanup();
    }

    @Override
    public String getId() {
        return this.mediaStoreUri.toString();
    }

    public static boolean isMediaStoreUri(Uri uri) {
        return uri != null && "content".equals(uri.getScheme()) && "media".equals(uri.getAuthority());
    }

    public static boolean isMediaStoreVideo(Uri uri) {
        return isMediaStoreUri(uri) && uri.getPathSegments().contains("video");
    }

    static class FileService {
        FileService() {
        }

        public boolean exists(File file) {
            return file.exists();
        }

        public long length(File file) {
            return file.length();
        }

        public File get(String str) {
            return new File(str);
        }
    }

    static class ThumbnailStreamOpener {
        private static final FileService DEFAULT_SERVICE = new FileService();
        private ThumbnailQuery query;
        private final FileService service;

        public ThumbnailStreamOpener(ThumbnailQuery thumbnailQuery) {
            this(DEFAULT_SERVICE, thumbnailQuery);
        }

        public ThumbnailStreamOpener(FileService fileService, ThumbnailQuery thumbnailQuery) {
            this.service = fileService;
            this.query = thumbnailQuery;
        }

        public int getOrientation(Context context, Uri uri) {
            InputStream inputStreamOpenInputStream = null;
            try {
                inputStreamOpenInputStream = context.getContentResolver().openInputStream(uri);
                int orientation = new ImageHeaderParser(inputStreamOpenInputStream).getOrientation();
                if (inputStreamOpenInputStream == null) {
                    return orientation;
                }
                try {
                    return orientation;
                } catch (IOException unused) {
                    return orientation;
                }
            } catch (IOException e) {
                if (Log.isLoggable(MediaStoreThumbFetcher.TAG, 3)) {
                    Log.d(MediaStoreThumbFetcher.TAG, "Failed to open uri: " + uri, e);
                }
                return -1;
            } finally {
                if (inputStreamOpenInputStream != null) {
                    try {
                        inputStreamOpenInputStream.close();
                    } catch (IOException unused2) {
                    }
                }
            }
        }

        public InputStream open(Context context, Uri uri) throws FileNotFoundException {
            Uri thumbUri;
            Cursor cursorQueryPath = this.query.queryPath(context, uri);
            if (cursorQueryPath != null) {
                try {
                    if (cursorQueryPath.moveToFirst()) {
                        thumbUri = parseThumbUri(cursorQueryPath);
                    } else {
                        thumbUri = null;
                    }
                } catch (Throwable th) {
                    if (cursorQueryPath != null) {
                        cursorQueryPath.close();
                    }
                    throw th;
                }
            } else {
                thumbUri = null;
            }
            if (cursorQueryPath != null) {
                cursorQueryPath.close();
            }
            if (thumbUri != null) {
                return context.getContentResolver().openInputStream(thumbUri);
            }
            return null;
        }

        private Uri parseThumbUri(Cursor cursor) {
            String string = cursor.getString(0);
            if (!TextUtils.isEmpty(string)) {
                File file = this.service.get(string);
                if (this.service.exists(file) && this.service.length(file) > 0) {
                    return Uri.fromFile(file);
                }
            }
            return null;
        }
    }

    static class ImageThumbnailQuery implements ThumbnailQuery {
        private static final String[] PATH_PROJECTION = {"_data"};
        private static final String PATH_SELECTION = "kind = 1 AND image_id = ?";

        ImageThumbnailQuery() {
        }

        @Override
        public Cursor queryPath(Context context, Uri uri) {
            return context.getContentResolver().query(MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI, PATH_PROJECTION, PATH_SELECTION, new String[]{uri.getLastPathSegment()}, null);
        }
    }

    static class VideoThumbnailQuery implements ThumbnailQuery {
        private static final String[] PATH_PROJECTION = {"_data"};
        private static final String PATH_SELECTION = "kind = 1 AND video_id = ?";

        VideoThumbnailQuery() {
        }

        @Override
        public Cursor queryPath(Context context, Uri uri) {
            return context.getContentResolver().query(MediaStore.Video.Thumbnails.EXTERNAL_CONTENT_URI, PATH_PROJECTION, PATH_SELECTION, new String[]{uri.getLastPathSegment()}, null);
        }
    }

    static class ThumbnailStreamOpenerFactory {
        ThumbnailStreamOpenerFactory() {
        }

        public ThumbnailStreamOpener build(Uri uri, int i, int i2) {
            if (!MediaStoreThumbFetcher.isMediaStoreUri(uri) || i > 512 || i2 > MediaStoreThumbFetcher.MINI_HEIGHT) {
                return null;
            }
            if (MediaStoreThumbFetcher.isMediaStoreVideo(uri)) {
                return new ThumbnailStreamOpener(new VideoThumbnailQuery());
            }
            return new ThumbnailStreamOpener(new ImageThumbnailQuery());
        }
    }
}
