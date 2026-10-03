local base = ActivityInfoData
local ActivityOptionalWeekCardInfoData = BaseClass("ActivityOptionalWeekCardInfoData", base)

function ActivityOptionalWeekCardInfoData:CanShowNewTag()
  return DataCenter.ActivityRewardChangePreviewManager:IsShowNewTagByActivityInfo(self)
end

return ActivityOptionalWeekCardInfoData
