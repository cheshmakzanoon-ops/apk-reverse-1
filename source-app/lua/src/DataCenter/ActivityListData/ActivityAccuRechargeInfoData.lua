local base = ActivityInfoData
local ActivityAccuRechargeInfoData = BaseClass("ActivityAccuRechargeInfoData", base)

function ActivityAccuRechargeInfoData:CanShowNewTag()
  return DataCenter.ActivityRewardChangePreviewManager:IsShowNewTagByActivityInfo(self)
end

return ActivityAccuRechargeInfoData
