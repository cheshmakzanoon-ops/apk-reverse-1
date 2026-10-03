local LWSeasonMainCtrl = BaseClass("LWSeasonMainCtrl", UIBaseCtrl)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeasonMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMain)
end

function LWSeasonMainCtrl:GetActivityGroupList()
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(true)
  local activityList = {}
  local heroPromotionActivity
  if list ~= nil then
    for i, v in pairs(list) do
      if v.type == EnumActivity.ActHeroPromotion.Type then
        local activitiyHeroData = SeasonRedPointUtils.GetConfigData(v.id)
        if activitiyHeroData then
          local newHeroData = DataCenter.HeroDataManager:GetHeroByHeroId(activitiyHeroData.newId)
          if newHeroData == nil then
            table.insert(activityList, v)
          else
            heroPromotionActivity = v
          end
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

function LWSeasonMainCtrl:GetSeasonCardData()
  local seasonData = {}
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, seasonConfig.week_card)
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
  return cardData
end

return LWSeasonMainCtrl
