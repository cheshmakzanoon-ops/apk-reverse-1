package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Size;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\bg\u0018\u0000 \t2\u00020\u0001:\u0001\tJ\"\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0005H&ø\u0001\u0000¢\u0006\u0004\b\u0007\u0010\bø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006\nÀ\u0006\u0001"}, d2 = {"Landroidx/compose/ui/layout/ContentScale;", "", "computeScaleFactor", "Landroidx/compose/ui/layout/ScaleFactor;", "srcSize", "Landroidx/compose/ui/geometry/Size;", "dstSize", "computeScaleFactor-H7hwNQA", "(JJ)J", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface ContentScale {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize);

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001c\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R\u001c\u0010\b\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\t\u0010\u0002\u001a\u0004\b\n\u0010\u0007R\u001c\u0010\u000b\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\f\u0010\u0002\u001a\u0004\b\r\u0010\u0007R\u001c\u0010\u000e\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000f\u0010\u0002\u001a\u0004\b\u0010\u0010\u0007R\u001c\u0010\u0011\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0012\u0010\u0002\u001a\u0004\b\u0013\u0010\u0007R\u001c\u0010\u0014\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0015\u0010\u0002\u001a\u0004\b\u0016\u0010\u0007R\u001c\u0010\u0017\u001a\u00020\u00188\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0019\u0010\u0002\u001a\u0004\b\u001a\u0010\u001b¨\u0006\u001c"}, d2 = {"Landroidx/compose/ui/layout/ContentScale$Companion;", "", "()V", "Crop", "Landroidx/compose/ui/layout/ContentScale;", "getCrop$annotations", "getCrop", "()Landroidx/compose/ui/layout/ContentScale;", "FillBounds", "getFillBounds$annotations", "getFillBounds", "FillHeight", "getFillHeight$annotations", "getFillHeight", "FillWidth", "getFillWidth$annotations", "getFillWidth", "Fit", "getFit$annotations", "getFit", "Inside", "getInside$annotations", "getInside", "None", "Landroidx/compose/ui/layout/FixedScale;", "getNone$annotations", "getNone", "()Landroidx/compose/ui/layout/FixedScale;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        private static final ContentScale Crop = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                float fM6023computeFillMaxDimensioniLBOSCw = ContentScaleKt.m6023computeFillMaxDimensioniLBOSCw(srcSize, dstSize);
                return ScaleFactorKt.ScaleFactor(fM6023computeFillMaxDimensioniLBOSCw, fM6023computeFillMaxDimensioniLBOSCw);
            }
        };
        private static final ContentScale Fit = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                float fM6024computeFillMinDimensioniLBOSCw = ContentScaleKt.m6024computeFillMinDimensioniLBOSCw(srcSize, dstSize);
                return ScaleFactorKt.ScaleFactor(fM6024computeFillMinDimensioniLBOSCw, fM6024computeFillMinDimensioniLBOSCw);
            }
        };
        private static final ContentScale FillHeight = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                float fM6022computeFillHeightiLBOSCw = ContentScaleKt.m6022computeFillHeightiLBOSCw(srcSize, dstSize);
                return ScaleFactorKt.ScaleFactor(fM6022computeFillHeightiLBOSCw, fM6022computeFillHeightiLBOSCw);
            }
        };
        private static final ContentScale FillWidth = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                float fM6025computeFillWidthiLBOSCw = ContentScaleKt.m6025computeFillWidthiLBOSCw(srcSize, dstSize);
                return ScaleFactorKt.ScaleFactor(fM6025computeFillWidthiLBOSCw, fM6025computeFillWidthiLBOSCw);
            }
        };
        private static final ContentScale Inside = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                if (Size.m4415getWidthimpl(srcSize) > Size.m4415getWidthimpl(dstSize) || Size.m4412getHeightimpl(srcSize) > Size.m4412getHeightimpl(dstSize)) {
                    float fM6024computeFillMinDimensioniLBOSCw = ContentScaleKt.m6024computeFillMinDimensioniLBOSCw(srcSize, dstSize);
                    return ScaleFactorKt.ScaleFactor(fM6024computeFillMinDimensioniLBOSCw, fM6024computeFillMinDimensioniLBOSCw);
                }
                return ScaleFactorKt.ScaleFactor(1.0f, 1.0f);
            }
        };
        private static final FixedScale None = new FixedScale(1.0f);
        private static final ContentScale FillBounds = new ContentScale() {
            @Override
            public long mo6017computeScaleFactorH7hwNQA(long srcSize, long dstSize) {
                return ScaleFactorKt.ScaleFactor(ContentScaleKt.m6025computeFillWidthiLBOSCw(srcSize, dstSize), ContentScaleKt.m6022computeFillHeightiLBOSCw(srcSize, dstSize));
            }
        };

        public static void getCrop$annotations() {
        }

        public static void getFillBounds$annotations() {
        }

        public static void getFillHeight$annotations() {
        }

        public static void getFillWidth$annotations() {
        }

        public static void getFit$annotations() {
        }

        public static void getInside$annotations() {
        }

        public static void getNone$annotations() {
        }

        private Companion() {
        }

        public final ContentScale getCrop() {
            return Crop;
        }

        public final ContentScale getFit() {
            return Fit;
        }

        public final ContentScale getFillHeight() {
            return FillHeight;
        }

        public final ContentScale getFillWidth() {
            return FillWidth;
        }

        public final ContentScale getInside() {
            return Inside;
        }

        public final FixedScale getNone() {
            return None;
        }

        public final ContentScale getFillBounds() {
            return FillBounds;
        }
    }
}
