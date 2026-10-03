package zendesk.guidekit.android.internal.data;

import java.io.IOException;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.serialization.SerializationException;
import net.aihelp.data.track.data.TrackType;
import retrofit2.HttpException;
import zendesk.guidekit.android.internal.data.mapper.BrandsMapperKt;
import zendesk.guidekit.android.internal.rest.model.BrandDto;
import zendesk.guidekit.android.internal.rest.model.BrandsDto;
import zendesk.guidekit.android.model.Brand;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.GuideKitRepository$initJob$1", m37f = "GuideKitRepository.kt", m38i = {}, m39l = {TrackType.TRACK_DURATION_CUSTOMER_SERVICE, 57}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class GuideKitRepository$initJob$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    int label;
    final GuideKitRepository this$0;

    GuideKitRepository$initJob$1(GuideKitRepository guideKitRepository, Continuation<? super GuideKitRepository$initJob$1> continuation) {
        super(2, continuation);
        this.this$0 = guideKitRepository;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new GuideKitRepository$initJob$1(this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((GuideKitRepository$initJob$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                String channelId$zendesk_guidekit_guidekit_android = this.this$0.guideKitSettings.getChannelId$zendesk_guidekit_guidekit_android();
                this.label = 1;
                obj = this.this$0.brandsApi.getBrands(channelId$zendesk_guidekit_guidekit_android, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            BrandDto brandDto = (BrandDto) CollectionsKt.firstOrNull((List) ((BrandsDto) obj).getBrands());
            if (brandDto != null) {
                BrandsInMemoryDataSource brandsInMemoryDataSource = this.this$0.brandsInMemoryDataSource;
                Brand brand = BrandsMapperKt.toBrand(brandDto);
                this.label = 2;
                if (brandsInMemoryDataSource.saveBrand(brand, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        } catch (IOException e) {
            Logger.m218e("GuideKitRepository", "IOException when fetching the brand", e, new Object[0]);
        } catch (SerializationException e2) {
            Logger.m218e("GuideKitRepository", "Json serialization when fetching the brand", e2, new Object[0]);
        } catch (HttpException e3) {
            Logger.m218e("GuideKitRepository", "HttpException when fetching the brand", e3, new Object[0]);
        }
        return Unit.INSTANCE;
    }
}
