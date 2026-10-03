package zendesk.p026ui.android.conversation.imagecell;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0010\b\u0000\u0018\u00002\u00020\u0001:\u0001\u0012B'\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007R\u001a\u0010\u0006\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u001a\u0010\u0005\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\t\"\u0004\b\r\u0010\u000bR\u001a\u0010\u0002\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\t\"\u0004\b\u000f\u0010\u000bR\u001a\u0010\u0004\u001a\u00020\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\t\"\u0004\b\u0011\u0010\u000b¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageRoundedCorner;", "", "topLeft", "", "topRight", "bottomRight", "bottomLeft", "(FFFF)V", "getBottomLeft", "()F", "setBottomLeft", "(F)V", "getBottomRight", "setBottomRight", "getTopLeft", "setTopLeft", "getTopRight", "setTopRight", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageRoundedCorner {
    public static final int $stable = 8;
    private float bottomLeft;
    private float bottomRight;
    private float topLeft;
    private float topRight;

    public ImageRoundedCorner(float f, float f2, float f3, float f4, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, f2, f3, f4);
    }

    private ImageRoundedCorner(float f, float f2, float f3, float f4) {
        this.topLeft = f;
        this.topRight = f2;
        this.bottomRight = f3;
        this.bottomLeft = f4;
    }

    public final float getTopLeft() {
        return this.topLeft;
    }

    public final void setTopLeft(float f) {
        this.topLeft = f;
    }

    public final float getTopRight() {
        return this.topRight;
    }

    public final void setTopRight(float f) {
        this.topRight = f;
    }

    public final float getBottomRight() {
        return this.bottomRight;
    }

    public final void setBottomRight(float f) {
        this.bottomRight = f;
    }

    public final float getBottomLeft() {
        return this.bottomLeft;
    }

    public final void setBottomLeft(float f) {
        this.bottomLeft = f;
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u0006\u0010\u0012\u001a\u00020\u000fJ\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J1\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0018\u001a\u00020\b2\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001J\b\u0010\u001c\u001a\u00020\u000fH\u0002J\b\u0010\u001d\u001a\u00020\u000fH\u0002J\b\u0010\u001e\u001a\u00020\u000fH\u0002J\b\u0010\u001f\u001a\u00020\u000fH\u0002J\b\u0010 \u001a\u00020\u000fH\u0002J\b\u0010!\u001a\u00020\u000fH\u0002J\b\u0010\"\u001a\u00020\u000fH\u0002J\b\u0010#\u001a\u00020\u000fH\u0002J\t\u0010$\u001a\u00020%HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\u0010R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000b¨\u0006&"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageRoundedCorner$Builder;", "", "cellRadius", "", "smallCellRadius", "direction", "Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "isLayoutDirectionLTR", "", "(FFLzendesk/ui/android/conversation/imagecell/ImageCellDirection;Z)V", "getCellRadius", "()F", "getDirection", "()Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "imageRoundedCorner", "Lzendesk/ui/android/conversation/imagecell/ImageRoundedCorner;", "()Z", "getSmallCellRadius", "build", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "", "inboundBottom", "inboundMiddle", "inboundSingle", "inboundTop", "outboundBottom", "outboundMiddle", "outboundSingle", "outboundTop", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private final float cellRadius;
        private final ImageCellDirection direction;
        private final ImageRoundedCorner imageRoundedCorner;
        private final boolean isLayoutDirectionLTR;
        private final float smallCellRadius;

        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[ImageCellDirection.values().length];
                try {
                    iArr[ImageCellDirection.INBOUND_SINGLE.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[ImageCellDirection.INBOUND_TOP.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                try {
                    iArr[ImageCellDirection.INBOUND_MIDDLE.ordinal()] = 3;
                } catch (NoSuchFieldError unused3) {
                }
                try {
                    iArr[ImageCellDirection.INBOUND_BOTTOM.ordinal()] = 4;
                } catch (NoSuchFieldError unused4) {
                }
                try {
                    iArr[ImageCellDirection.OUTBOUND_SINGLE.ordinal()] = 5;
                } catch (NoSuchFieldError unused5) {
                }
                try {
                    iArr[ImageCellDirection.OUTBOUND_TOP.ordinal()] = 6;
                } catch (NoSuchFieldError unused6) {
                }
                try {
                    iArr[ImageCellDirection.OUTBOUND_MIDDLE.ordinal()] = 7;
                } catch (NoSuchFieldError unused7) {
                }
                try {
                    iArr[ImageCellDirection.OUTBOUND_BOTTOM.ordinal()] = 8;
                } catch (NoSuchFieldError unused8) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        public static Builder copy$default(Builder builder, float f, float f2, ImageCellDirection imageCellDirection, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                f = builder.cellRadius;
            }
            if ((i & 2) != 0) {
                f2 = builder.smallCellRadius;
            }
            if ((i & 4) != 0) {
                imageCellDirection = builder.direction;
            }
            if ((i & 8) != 0) {
                z = builder.isLayoutDirectionLTR;
            }
            return builder.copy(f, f2, imageCellDirection, z);
        }

        public final float getCellRadius() {
            return this.cellRadius;
        }

        public final float getSmallCellRadius() {
            return this.smallCellRadius;
        }

        public final ImageCellDirection getDirection() {
            return this.direction;
        }

        public final boolean getIsLayoutDirectionLTR() {
            return this.isLayoutDirectionLTR;
        }

        public final Builder copy(float cellRadius, float smallCellRadius, ImageCellDirection direction, boolean isLayoutDirectionLTR) {
            Intrinsics.checkNotNullParameter(direction, "direction");
            return new Builder(cellRadius, smallCellRadius, direction, isLayoutDirectionLTR);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Builder)) {
                return false;
            }
            Builder builder = (Builder) other;
            return Float.compare(this.cellRadius, builder.cellRadius) == 0 && Float.compare(this.smallCellRadius, builder.smallCellRadius) == 0 && this.direction == builder.direction && this.isLayoutDirectionLTR == builder.isLayoutDirectionLTR;
        }

        public int hashCode() {
            return (((((Float.floatToIntBits(this.cellRadius) * 31) + Float.floatToIntBits(this.smallCellRadius)) * 31) + this.direction.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isLayoutDirectionLTR);
        }

        public String toString() {
            return "Builder(cellRadius=" + this.cellRadius + ", smallCellRadius=" + this.smallCellRadius + ", direction=" + this.direction + ", isLayoutDirectionLTR=" + this.isLayoutDirectionLTR + ')';
        }

        public Builder(float f, float f2, ImageCellDirection direction, boolean z) {
            Intrinsics.checkNotNullParameter(direction, "direction");
            this.cellRadius = f;
            this.smallCellRadius = f2;
            this.direction = direction;
            this.isLayoutDirectionLTR = z;
            this.imageRoundedCorner = new ImageRoundedCorner(f, f, f, f, null);
        }

        public final float getCellRadius() {
            return this.cellRadius;
        }

        public final float getSmallCellRadius() {
            return this.smallCellRadius;
        }

        public final ImageCellDirection getDirection() {
            return this.direction;
        }

        public final boolean isLayoutDirectionLTR() {
            return this.isLayoutDirectionLTR;
        }

        private final ImageRoundedCorner inboundSingle() {
            return getImageRoundedCorner();
        }

        private final ImageRoundedCorner inboundTop() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setBottomLeft(this.smallCellRadius);
            } else {
                imageRoundedCorner.setBottomRight(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        private final ImageRoundedCorner inboundMiddle() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setTopLeft(this.smallCellRadius);
                imageRoundedCorner.setBottomLeft(this.smallCellRadius);
            } else {
                imageRoundedCorner.setTopRight(this.smallCellRadius);
                imageRoundedCorner.setBottomRight(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        private final ImageRoundedCorner inboundBottom() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setTopLeft(this.smallCellRadius);
            } else {
                imageRoundedCorner.setTopRight(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        private final ImageRoundedCorner getImageRoundedCorner() {
            return this.imageRoundedCorner;
        }

        private final ImageRoundedCorner outboundTop() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setBottomRight(this.smallCellRadius);
            } else {
                imageRoundedCorner.setBottomLeft(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        private final ImageRoundedCorner outboundMiddle() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setTopRight(this.smallCellRadius);
                imageRoundedCorner.setBottomRight(this.smallCellRadius);
            } else {
                imageRoundedCorner.setTopLeft(this.smallCellRadius);
                imageRoundedCorner.setBottomLeft(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        private final ImageRoundedCorner outboundBottom() {
            ImageRoundedCorner imageRoundedCorner = this.imageRoundedCorner;
            if (this.isLayoutDirectionLTR) {
                imageRoundedCorner.setTopRight(this.smallCellRadius);
            } else {
                imageRoundedCorner.setTopLeft(this.smallCellRadius);
            }
            return imageRoundedCorner;
        }

        public final ImageRoundedCorner build() {
            switch (WhenMappings.$EnumSwitchMapping$0[this.direction.ordinal()]) {
                case 1:
                    return inboundSingle();
                case 2:
                    return inboundTop();
                case 3:
                    return inboundMiddle();
                case 4:
                    return inboundBottom();
                case 5:
                    return getImageRoundedCorner();
                case 6:
                    return outboundTop();
                case 7:
                    return outboundMiddle();
                case 8:
                    return outboundBottom();
                default:
                    throw new NoWhenBranchMatchedException();
            }
        }
    }
}
