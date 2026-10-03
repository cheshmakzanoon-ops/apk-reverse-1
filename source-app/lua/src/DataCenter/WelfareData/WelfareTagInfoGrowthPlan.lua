require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoGrowthPlan = BaseClass("WelfareTagInfoGrowthPlan", WelfareTagInfo)
local M = WelfareTagInfoGrowthPlan

function M:isShow()
  local pack = GiftPackageData.getGrowthPlanPack()
  return pack ~= nil and WelfareTagInfo.isShow(self)
end

function M:getRedDotNum()
  local count = 0
  local t = WelfareController.getWelfareCache(WelfareMessageKey.GrowthPlanInfo)
  if t ~= nil and t.stageInfo ~= nil then
    for _, data in ipairs(t.stageInfo) do
      if DataCenter.BuildManager.MainLv >= data.needLevel then
        if data.normalState == 0 then
          count = count + 1
        end
        if data.specialState == 0 and t.unlockSpecialReward == 1 then
          count = count + 1
        end
      end
    end
  end
  return count
end

return M
