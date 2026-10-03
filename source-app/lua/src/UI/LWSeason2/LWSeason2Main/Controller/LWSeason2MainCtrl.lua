local LWSeason2MainCtrl = BaseClass("LWSeason2MainCtrl", UIBaseCtrl)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeason2MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeason2Main)
end

function LWSeason2MainCtrl:GetActivityGroupList()
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(true)
  local activityList = {}
  local heroPromotionActivity
  if list ~= nil then
    for i, v in pairs(list) do
      if v.type == EnumActivity.ActHeroPromotion.Type then
        local activityHeroData = SeasonRedPointUtils.GetConfigData(v.id)
        if activityHeroData then
          local newHeroData = DataCenter.HeroDataManager:GetHeroByHeroId(activityHeroData.newId)
          if newHeroData == nil then
            table.insert(activityList, v)
          else
            heroPromotionActivity = v
          end
        end
      elseif v.type == EnumActivity.SnowStormComing.Type then
        local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
        if state ~= ActivitySnowStormState.NoStart and state ~= ActivitySnowStormState.End then
          table.insert(activityList, v)
        end
      else
        table.insert(activityList, v)
      end
    end
    table.sort(activityList, function(a, b)
      if a.order ~= b.order then
        return a.order < b.order
      else
        return false
      end
    end)
    if heroPromotionActivity then
      table.insert(activityList, heroPromotionActivity)
    end
  end
  return activityList
end

function LWSeason2MainCtrl:GetSeasonCardData()
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
  return cardData
end

return LWSeason2MainCtrl
