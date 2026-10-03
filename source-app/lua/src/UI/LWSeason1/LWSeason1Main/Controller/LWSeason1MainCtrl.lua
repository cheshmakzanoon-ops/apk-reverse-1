local SeasonMainActivitySignUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonMainActivitySignUtils")
local LWSeason1MainCtrl = BaseClass("LWSeason1MainCtrl", UIBaseCtrl)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeason1MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeason1Main)
end

function LWSeason1MainCtrl:GetActivityGroupList()
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(true)
  local activityList = {}
  if list ~= nil then
    local isInSeasonPrepareMode = SeasonUtil.IsInSeasonPrepareMode()
    for i, v in pairs(list) do
      local _, isSeasonPreActivity = DataCenter.SeasonDataManager:IsActivityForSeason(v.id)
      if isInSeasonPrepareMode == isSeasonPreActivity then
        table.insert(activityList, v)
      end
    end
    local signStatus = {}
    table.sort(activityList, function(a, b)
      local aState = signStatus[a.id] or SeasonMainActivitySignUtils:GetSignStatus(a)
      local bState = signStatus[b.id] or SeasonMainActivitySignUtils:GetSignStatus(b)
      if signStatus[a.id] == nil then
        signStatus[a.id] = aState
      end
      if signStatus[b.id] == nil then
        signStatus[b.id] = bState
      end
      if aState ~= bState then
        return aState < bState
      end
      if a.order ~= b.order then
        return a.order < b.order
      else
        return false
      end
    end)
  end
  return activityList
end

function LWSeason1MainCtrl:GetSeasonCardData()
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
  return cardData
end

return LWSeason1MainCtrl
