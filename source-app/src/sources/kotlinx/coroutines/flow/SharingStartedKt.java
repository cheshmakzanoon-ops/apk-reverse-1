package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.time.Duration;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a%\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u0004¢\u0006\u0004\b\u0006\u0010\u0007¨\u0006\b"}, m18d2 = {"WhileSubscribed", "Lkotlinx/coroutines/flow/SharingStarted;", "Lkotlinx/coroutines/flow/SharingStarted$Companion;", "stopTimeout", "Lkotlin/time/Duration;", "replayExpiration", "WhileSubscribed-5qebJ5I", "(Lkotlinx/coroutines/flow/SharingStarted$Companion;JJ)Lkotlinx/coroutines/flow/SharingStarted;", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class SharingStartedKt {
    public static SharingStarted m1861WhileSubscribed5qebJ5I$default(SharingStarted.Companion companion, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            j = Duration.INSTANCE.m1733getZEROUwyO8pc();
        }
        if ((i & 2) != 0) {
            j2 = Duration.INSTANCE.m1731getINFINITEUwyO8pc();
        }
        return m1860WhileSubscribed5qebJ5I(companion, j, j2);
    }

    public static final SharingStarted m1860WhileSubscribed5qebJ5I(SharingStarted.Companion companion, long j, long j2) {
        return new StartedWhileSubscribed(Duration.m1649getInWholeMillisecondsimpl(j), Duration.m1649getInWholeMillisecondsimpl(j2));
    }
}
