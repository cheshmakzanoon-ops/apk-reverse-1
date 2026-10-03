package zendesk.p009ui.android.common.connectionbanner;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.parcelize.Parceler;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.internal.DimensionExtKt;
import zendesk.ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.internal.ViewKt;

@Metadata(d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u0000 %2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0003%&'B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH\u0002J\u0012\u0010\u001d\u001a\u00020\u001a2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001fH\u0014J\b\u0010 \u001a\u00020\u001fH\u0014J\u001c\u0010!\u001a\u00020\u001a2\u0012\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030#H\u0016J\b\u0010$\u001a\u00020\u001aH\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006("}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "animationTime", "", "backgroundDrawable", "Landroid/graphics/drawable/GradientDrawable;", "connectionBanner", "Landroid/view/View;", "label", "Landroid/widget/TextView;", "rendering", "retryButton", "Landroid/widget/ImageView;", "shouldAnimate", "", "announceConnectionStatusForAccessibility", "", "accessibilityAnnouncement", "", "onRestoreInstanceState", ServerProtocol.DIALOG_PARAM_STATE, "Landroid/os/Parcelable;", "onSaveInstanceState", "render", "renderingUpdate", "Lkotlin/Function1;", "startAnimation", "Companion", "ConnectionStateParceler", "SavedState", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ConnectionBannerView extends FrameLayout implements Renderer<ConnectionBannerRendering> {
    private static final long FADE_DURATION = 300;
    private static final long NOT_CONNECTED_ACCESSIBILITY_EVENT_DELAY = 3500;
    private final long animationTime;
    private final GradientDrawable backgroundDrawable;
    private final View connectionBanner;
    private final TextView label;
    private ConnectionBannerRendering rendering;
    private final ImageView retryButton;
    private boolean shouldAnimate;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public ConnectionBannerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConnectionBannerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConnectionBannerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConnectionBannerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConnectionBannerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ConnectionBannerRendering();
        GradientDrawable gradientDrawable = new GradientDrawable();
        this.backgroundDrawable = gradientDrawable;
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_ConnectionBannerStyle, false);
        FrameLayout.inflate(context, R.layout.zuia_view_connection_banner, this);
        View viewFindViewById = findViewById(R.id.zuia_connection_banner);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.connectionBanner = viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_banner_label);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.label = (TextView) viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zuia_retry_button);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        ImageView imageView = (ImageView) viewFindViewById3;
        this.retryButton = imageView;
        this.animationTime = getResources().getInteger(R.integer.zuia_connection_banner_animation_duration);
        gradientDrawable.setShape(0);
        gradientDrawable.setCornerRadius(DimensionExtKt.resolveDimensionAttr(context, new int[]{R.attr.connectionBannerRadius}));
        ViewKt.expandTouchArea$default(imageView, this, 0, 0, 0, 0, 30, (Object) null);
        setVisibility(8);
        render(new Function1<ConnectionBannerRendering, ConnectionBannerRendering>() {
            public final ConnectionBannerRendering invoke(ConnectionBannerRendering connectionBannerRendering) {
                Intrinsics.checkNotNullParameter(connectionBannerRendering, "it");
                return connectionBannerRendering;
            }
        });
    }

    @Override
    protected Parcelable onSaveInstanceState() {
        return new SavedState(super.onSaveInstanceState(), getVisibility(), this.rendering.getShowRetry(), this.rendering.getState().getConnectionState());
    }

    @Override
    protected void onRestoreInstanceState(final Parcelable state) {
        if (state instanceof SavedState) {
            SavedState savedState = (SavedState) state;
            super.onRestoreInstanceState(savedState.getSuperState());
            setVisibility(savedState.getVisibility());
            render(new Function1<ConnectionBannerRendering, ConnectionBannerRendering>() {
                {
                    super(1);
                }

                public final ConnectionBannerRendering invoke(ConnectionBannerRendering connectionBannerRendering) {
                    Intrinsics.checkNotNullParameter(connectionBannerRendering, "connectionBannerRendering");
                    ConnectionBannerRendering.Builder builderShowRetry = connectionBannerRendering.toBuilder().showRetry(((SavedState) state).getShowRetry());
                    final Parcelable parcelable = state;
                    return builderShowRetry.state(new Function1<ConnectionBannerState, ConnectionBannerState>() {
                        {
                            super(1);
                        }

                        public final ConnectionBannerState invoke(ConnectionBannerState connectionBannerState) {
                            Intrinsics.checkNotNullParameter(connectionBannerState, "it");
                            return ConnectionBannerState.copy$default(connectionBannerState, ((SavedState) parcelable).getConnectionState(), 0, 0, 0, 14, null);
                        }
                    }).build();
                }
            });
            return;
        }
        super.onRestoreInstanceState(state);
    }

    public void render(Function1<? super ConnectionBannerRendering, ConnectionBannerRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = (ConnectionBannerRendering) renderingUpdate.invoke(this.rendering);
        this.retryButton.setOnClickListener((View.OnClickListener) ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m2638invoke();
                return Unit.INSTANCE;
            }

            public final void m2638invoke() {
                ConnectionBannerView.this.rendering.getOnRetryClicked$zendesk_ui_ui_android().invoke();
            }
        }, 1, (Object) null));
        if (getVisibility() != 0 && !Intrinsics.areEqual(this.rendering.getState().getConnectionState(), ConnectionBannerState.ConnectionState.Disconnected.INSTANCE)) {
            animate().cancel();
            return;
        }
        int backgroundColor = this.rendering.getState().getBackgroundColor();
        int labelColor = this.rendering.getState().getLabelColor();
        String text = this.label.getText();
        ConnectionBannerState.ConnectionState connectionState = this.rendering.getState().getConnectionState();
        int i = 0;
        if (Intrinsics.areEqual(connectionState, ConnectionBannerState.ConnectionState.Disconnected.INSTANCE) ? true : Intrinsics.areEqual(connectionState, ConnectionBannerState.ConnectionState.Connected.INSTANCE)) {
            this.label.setText(R.string.zuia_connection_banner_label_disconnected);
            this.shouldAnimate = true;
            StringBuilder sb = new StringBuilder();
            sb.append((Object) this.label.getText());
            sb.append(' ');
            sb.append((Object) this.retryButton.getContentDescription());
            text = sb.toString();
        } else {
            if (Intrinsics.areEqual(connectionState, ConnectionBannerState.ConnectionState.Reconnecting.INSTANCE)) {
                this.label.setText(R.string.zuia_connection_banner_label_reconnecting);
                this.shouldAnimate = false;
                text = this.label.getText();
            } else if (Intrinsics.areEqual(connectionState, ConnectionBannerState.ConnectionState.Reconnected.INSTANCE)) {
                this.label.setText(R.string.zuia_connection_banner_label_state_reconnected);
                backgroundColor = this.rendering.getState().getSuccessBackgroundColor();
                labelColor = this.rendering.getState().getLabelColor();
                this.shouldAnimate = getVisibility() == 0;
                onSaveInstanceState();
                text = this.label.getText();
            }
            i = 8;
        }
        this.connectionBanner.setContentDescription(text);
        Intrinsics.checkNotNull(text, "null cannot be cast to non-null type kotlin.String");
        announceConnectionStatusForAccessibility((String) text);
        this.backgroundDrawable.setColor(backgroundColor);
        this.label.setTextColor(labelColor);
        this.retryButton.getDrawable().setTint(labelColor);
        this.connectionBanner.setBackground(this.backgroundDrawable);
        this.retryButton.setVisibility(this.rendering.getShowRetry() ? i : 8);
        if (this.shouldAnimate) {
            startAnimation();
        }
    }

    private final void announceConnectionStatusForAccessibility(final String accessibilityAnnouncement) {
        this.label.postDelayed(new Runnable() {
            @Override
            public final void run() {
                ConnectionBannerView.announceConnectionStatusForAccessibility$lambda$1(this.f$0, accessibilityAnnouncement);
            }
        }, NOT_CONNECTED_ACCESSIBILITY_EVENT_DELAY);
    }

    public static final void announceConnectionStatusForAccessibility$lambda$1(ConnectionBannerView connectionBannerView, String str) {
        Intrinsics.checkNotNullParameter(connectionBannerView, "this$0");
        Intrinsics.checkNotNullParameter(str, "$accessibilityAnnouncement");
        connectionBannerView.label.announceForAccessibility(str);
    }

    private final void startAnimation() {
        animate().setDuration(FADE_DURATION).setStartDelay(this.animationTime);
        if (Intrinsics.areEqual(this.rendering.getState().getConnectionState(), ConnectionBannerState.ConnectionState.Disconnected.INSTANCE)) {
            animate().alpha(1.0f).withStartAction(new Runnable() {
                @Override
                public final void run() {
                    ConnectionBannerView.startAnimation$lambda$2(this.f$0);
                }
            }).start();
        }
        if (Intrinsics.areEqual(this.rendering.getState().getConnectionState(), ConnectionBannerState.ConnectionState.Reconnected.INSTANCE)) {
            animate().alpha(0.0f).withEndAction(new Runnable() {
                @Override
                public final void run() {
                    ConnectionBannerView.startAnimation$lambda$3(this.f$0);
                }
            }).start();
        }
    }

    public static final void startAnimation$lambda$2(ConnectionBannerView connectionBannerView) {
        Intrinsics.checkNotNullParameter(connectionBannerView, "this$0");
        connectionBannerView.setVisibility(0);
    }

    public static final void startAnimation$lambda$3(ConnectionBannerView connectionBannerView) {
        Intrinsics.checkNotNullParameter(connectionBannerView, "this$0");
        connectionBannerView.setVisibility(8);
    }

    @Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u0000 \u001f2\u00020\u0001:\u0001\u001fB-\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001J\u0019\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u0005HÖ\u0001R\u001a\u0010\b\u001a\u00020\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018¨\u0006 "}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView$SavedState;", "Landroid/view/View$BaseSavedState;", ServerProtocol.DIALOG_PARAM_STATE, "Landroid/os/Parcelable;", "visibility", "", "showRetry", "", "connectionState", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "(Landroid/os/Parcelable;IZLzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;)V", "getConnectionState", "()Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "setConnectionState", "(Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;)V", "getShowRetry", "()Z", "setShowRetry", "(Z)V", "getState", "()Landroid/os/Parcelable;", "getVisibility", "()I", "setVisibility", "(I)V", "describeContents", "writeToParcel", "", "parcel", "Landroid/os/Parcel;", "flags", "Companion", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class SavedState extends View.BaseSavedState {
        private ConnectionBannerState.ConnectionState connectionState;
        private boolean showRetry;
        private final Parcelable state;
        private int visibility;

        public static final Companion INSTANCE = new Companion(null);
        public static final int $stable = 8;
        public static final Parcelable.Creator<SavedState> CREATOR = new Creator();

        @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Creator implements Parcelable.Creator<SavedState> {
            @Override
            public final SavedState createFromParcel(Parcel parcel) {
                Intrinsics.checkNotNullParameter(parcel, "parcel");
                return new SavedState(parcel.readParcelable(SavedState.class.getClassLoader()), parcel.readInt(), parcel.readInt() != 0, ConnectionStateParceler.INSTANCE.create(parcel));
            }

            @Override
            public final SavedState[] newArray(int i) {
                return new SavedState[i];
            }
        }

        @Override
        public int describeContents() {
            return 0;
        }

        @Override
        public void writeToParcel(Parcel parcel, int flags) {
            Intrinsics.checkNotNullParameter(parcel, "out");
            parcel.writeParcelable(this.state, flags);
            parcel.writeInt(this.visibility);
            parcel.writeInt(this.showRetry ? 1 : 0);
            ConnectionStateParceler.INSTANCE.write(this.connectionState, parcel, flags);
        }

        public final Parcelable getState() {
            return this.state;
        }

        public final int getVisibility() {
            return this.visibility;
        }

        public final void setVisibility(int i) {
            this.visibility = i;
        }

        public final boolean getShowRetry() {
            return this.showRetry;
        }

        public final void setShowRetry(boolean z) {
            this.showRetry = z;
        }

        public SavedState(Parcelable parcelable, int i, boolean z, ConnectionBannerState.ConnectionState.Connected connected, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this(parcelable, (i2 & 2) != 0 ? 8 : i, (i2 & 4) != 0 ? true : z, (i2 & 8) != 0 ? ConnectionBannerState.ConnectionState.Connected.INSTANCE : connected);
        }

        public final ConnectionBannerState.ConnectionState getConnectionState() {
            return this.connectionState;
        }

        public final void setConnectionState(ConnectionBannerState.ConnectionState connectionState) {
            Intrinsics.checkNotNullParameter(connectionState, "<set-?>");
            this.connectionState = connectionState;
        }

        public SavedState(Parcelable parcelable, int i, boolean z, ConnectionBannerState.ConnectionState connectionState) {
            super(parcelable);
            Intrinsics.checkNotNullParameter(connectionState, "connectionState");
            this.state = parcelable;
            this.visibility = i;
            this.showRetry = z;
            this.connectionState = connectionState;
        }

        @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006¨\u0006\u0007"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView$SavedState$Companion;", "", "()V", "parseConnectionStateValue", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "stateValue", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final ConnectionBannerState.ConnectionState parseConnectionStateValue(String stateValue) {
                Intrinsics.checkNotNullParameter(stateValue, "stateValue");
                int iHashCode = stateValue.hashCode();
                if (iHashCode != -1217068453) {
                    if (iHashCode != -273361386) {
                        if (iHashCode == 115735883 && stateValue.equals("Reconnecting")) {
                            return ConnectionBannerState.ConnectionState.Reconnecting.INSTANCE;
                        }
                    } else if (stateValue.equals("Reconnected")) {
                        return ConnectionBannerState.ConnectionState.Reconnected.INSTANCE;
                    }
                } else if (stateValue.equals("Disconnected")) {
                    return ConnectionBannerState.ConnectionState.Disconnected.INSTANCE;
                }
                return ConnectionBannerState.ConnectionState.Connected.INSTANCE;
            }
        }
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0000\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\u0004\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u001c\u0010\u0007\u001a\u00020\b*\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nH\u0016¨\u0006\u000b"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView$ConnectionStateParceler;", "Lkotlinx/parcelize/Parceler;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerState$ConnectionState;", "()V", "create", "parcel", "Landroid/os/Parcel;", "write", "", "flags", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class ConnectionStateParceler implements Parceler<ConnectionBannerState.ConnectionState> {
        public static final int $stable = 0;
        public static final ConnectionStateParceler INSTANCE = new ConnectionStateParceler();

        private ConnectionStateParceler() {
        }

        public ConnectionBannerState.ConnectionState[] newArray(int i) {
            return (ConnectionBannerState.ConnectionState[]) Parceler.DefaultImpls.newArray(this, i);
        }

        public ConnectionBannerState.ConnectionState create(Parcel parcel) {
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            SavedState.Companion companion = SavedState.INSTANCE;
            String string = parcel.readString();
            if (string == null) {
                string = "";
            }
            return companion.parseConnectionStateValue(string);
        }

        public void write(ConnectionBannerState.ConnectionState connectionState, Parcel parcel, int i) {
            Intrinsics.checkNotNullParameter(connectionState, "<this>");
            Intrinsics.checkNotNullParameter(parcel, "parcel");
            parcel.writeString(connectionState.getStateValue());
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, d2 = {"Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView$Companion;", "", "()V", "FADE_DURATION", "", "NOT_CONNECTED_ACCESSIBILITY_EVENT_DELAY", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
