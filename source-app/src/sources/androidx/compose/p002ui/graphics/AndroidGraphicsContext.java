package androidx.compose.p002ui.graphics;

import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.res.Configuration;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.graphics.layer.GraphicsLayerV23;
import androidx.compose.p002ui.graphics.layer.GraphicsLayerV29;
import androidx.compose.p002ui.graphics.layer.GraphicsViewLayer;
import androidx.compose.p002ui.graphics.layer.LayerManager;
import androidx.compose.p002ui.graphics.layer.view.DrawChildContainer;
import androidx.compose.p002ui.graphics.layer.view.ViewLayerContainer;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0002\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001f B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010\u0010\u001a\u00020\u0011H\u0016J\u0010\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0015H\u0002J\u0006\u0010\u0016\u001a\u00020\bJ\u0010\u0010\u0017\u001a\u00020\u000f2\u0006\u0010\u0002\u001a\u00020\u0003H\u0002J\u0010\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0002J\u0010\u0010\u001c\u001a\u00020\u00192\u0006\u0010\u001d\u001a\u00020\u0011H\u0016J\u0010\u0010\u001e\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0002R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006!"}, d2 = {"Landroidx/compose/ui/graphics/AndroidGraphicsContext;", "Landroidx/compose/ui/graphics/GraphicsContext;", "ownerView", "Landroid/view/ViewGroup;", "(Landroid/view/ViewGroup;)V", "componentCallback", "Landroid/content/ComponentCallbacks2;", "componentCallbackRegistered", "", "layerManager", "Landroidx/compose/ui/graphics/layer/LayerManager;", "lock", "", "predrawListenerRegistered", "viewLayerContainer", "Landroidx/compose/ui/graphics/layer/view/DrawChildContainer;", "createGraphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "getUniqueDrawingId", "", "view", "Landroid/view/View;", "isLayerManagerInitialized", "obtainViewLayerContainer", "registerComponentCallback", "", "context", "Landroid/content/Context;", "releaseGraphicsLayer", "layer", "unregisterComponentCallback", "Companion", "UniqueDrawingIdApi29", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class AndroidGraphicsContext implements GraphicsContext {
    public static final boolean enableLayerPersistence = false;
    private boolean componentCallbackRegistered;
    private final ViewGroup ownerView;
    private boolean predrawListenerRegistered;
    private DrawChildContainer viewLayerContainer;

    public static final Companion INSTANCE = new Companion(null);
    private static boolean isRenderNodeCompatible = true;
    private final Object lock = new Object();
    private final LayerManager layerManager = null;
    private final ComponentCallbacks2 componentCallback = null;

    public AndroidGraphicsContext(ViewGroup viewGroup) {
        this.ownerView = viewGroup;
    }

    @Metadata(d1 = {"\u0000\u001f\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016J\b\u0010\u0006\u001a\u00020\u0003H\u0016J\u0010\u0010\u0007\u001a\u00020\u00032\u0006\u0010\b\u001a\u00020\tH\u0016¨\u0006\n"}, d2 = {"androidx/compose/ui/graphics/AndroidGraphicsContext$1", "Landroid/content/ComponentCallbacks2;", "onConfigurationChanged", "", "newConfig", "Landroid/content/res/Configuration;", "onLowMemory", "onTrimMemory", "level", "", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class ComponentCallbacks2C16141 implements ComponentCallbacks2 {
        @Override
        public void onConfigurationChanged(Configuration newConfig) {
        }

        @Override
        public void onLowMemory() {
        }

        ComponentCallbacks2C16141() {
        }

        @Override
        public void onTrimMemory(int level) {
            if (level < 40 || AndroidGraphicsContext.this.predrawListenerRegistered) {
                return;
            }
            AndroidGraphicsContext.this.layerManager.destroy();
            ViewTreeObserver viewTreeObserver = AndroidGraphicsContext.this.ownerView.getViewTreeObserver();
            final AndroidGraphicsContext androidGraphicsContext = AndroidGraphicsContext.this;
            viewTreeObserver.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    androidGraphicsContext.layerManager.updateLayerPersistence();
                    androidGraphicsContext.ownerView.getViewTreeObserver().removeOnPreDrawListener(this);
                    androidGraphicsContext.predrawListenerRegistered = false;
                    return true;
                }
            });
            AndroidGraphicsContext.this.predrawListenerRegistered = true;
        }
    }

    @Metadata(d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016J\u0010\u0010\u0006\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016¨\u0006\u0007"}, d2 = {"androidx/compose/ui/graphics/AndroidGraphicsContext$2", "Landroid/view/View$OnAttachStateChangeListener;", "onViewAttachedToWindow", "", "v", "Landroid/view/View;", "onViewDetachedFromWindow", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class ViewOnAttachStateChangeListenerC16152 implements View.OnAttachStateChangeListener {
        ViewOnAttachStateChangeListenerC16152() {
        }

        @Override
        public void onViewAttachedToWindow(View v) {
            AndroidGraphicsContext.this.registerComponentCallback(v.getContext());
        }

        @Override
        public void onViewDetachedFromWindow(View v) {
            AndroidGraphicsContext.this.unregisterComponentCallback(v.getContext());
            AndroidGraphicsContext.this.layerManager.destroy();
        }
    }

    public final boolean isLayerManagerInitialized() {
        LayerManager layerManager = this.layerManager;
        if (layerManager != null) {
            return layerManager.hasImageReader();
        }
        return false;
    }

    public final void registerComponentCallback(Context context) {
        if (this.componentCallbackRegistered) {
            return;
        }
        context.getApplicationContext().registerComponentCallbacks(this.componentCallback);
        this.componentCallbackRegistered = true;
    }

    public final void unregisterComponentCallback(Context context) {
        if (this.componentCallbackRegistered) {
            context.getApplicationContext().unregisterComponentCallbacks(this.componentCallback);
            this.componentCallbackRegistered = false;
        }
    }

    @Override
    public GraphicsLayer createGraphicsLayer() {
        GraphicsViewLayer graphicsViewLayer;
        GraphicsLayer graphicsLayer;
        synchronized (this.lock) {
            long uniqueDrawingId = getUniqueDrawingId(this.ownerView);
            if (Build.VERSION.SDK_INT >= 29) {
                graphicsViewLayer = new GraphicsLayerV29(uniqueDrawingId, null, null, 6, null);
            } else if (isRenderNodeCompatible) {
                try {
                    graphicsViewLayer = new GraphicsLayerV23(this.ownerView, uniqueDrawingId, null, null, 12, null);
                } catch (Throwable unused) {
                    isRenderNodeCompatible = false;
                    graphicsViewLayer = new GraphicsViewLayer(obtainViewLayerContainer(this.ownerView), uniqueDrawingId, null, null, 12, null);
                }
            } else {
                graphicsViewLayer = new GraphicsViewLayer(obtainViewLayerContainer(this.ownerView), uniqueDrawingId, null, null, 12, null);
            }
            graphicsLayer = new GraphicsLayer(graphicsViewLayer, this.layerManager);
        }
        return graphicsLayer;
    }

    @Override
    public void releaseGraphicsLayer(GraphicsLayer layer) {
        synchronized (this.lock) {
            layer.release$ui_graphics_release();
            Unit unit = Unit.INSTANCE;
        }
    }

    private final DrawChildContainer obtainViewLayerContainer(ViewGroup ownerView) {
        DrawChildContainer drawChildContainer = this.viewLayerContainer;
        if (drawChildContainer != null) {
            return drawChildContainer;
        }
        ViewLayerContainer viewLayerContainer = new ViewLayerContainer(ownerView.getContext());
        ownerView.addView(viewLayerContainer);
        this.viewLayerContainer = viewLayerContainer;
        return viewLayerContainer;
    }

    private final long getUniqueDrawingId(View view) {
        if (Build.VERSION.SDK_INT >= 29) {
            return UniqueDrawingIdApi29.getUniqueDrawingId(view);
        }
        return -1L;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u001a\u0010\u0005\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\b¨\u0006\t"}, d2 = {"Landroidx/compose/ui/graphics/AndroidGraphicsContext$Companion;", "", "()V", "enableLayerPersistence", "", "isRenderNodeCompatible", "()Z", "setRenderNodeCompatible", "(Z)V", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final boolean isRenderNodeCompatible() {
            return AndroidGraphicsContext.isRenderNodeCompatible;
        }

        public final void setRenderNodeCompatible(boolean z) {
            AndroidGraphicsContext.isRenderNodeCompatible = z;
        }
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/graphics/AndroidGraphicsContext$UniqueDrawingIdApi29;", "", "()V", "getUniqueDrawingId", "", "view", "Landroid/view/View;", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class UniqueDrawingIdApi29 {
        public static final UniqueDrawingIdApi29 INSTANCE = new UniqueDrawingIdApi29();

        private UniqueDrawingIdApi29() {
        }

        @JvmStatic
        public static final long getUniqueDrawingId(View view) {
            return view.getUniqueDrawingId();
        }
    }
}
