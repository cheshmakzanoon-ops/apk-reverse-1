local LWSeason5MainCtrl = BaseClass("LWSeason5MainCtrl", UIBaseCtrl)
local SeasonMainActivitySignUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonMainActivitySignUtils")

function LWSeason5MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeason5Main)
end

function LWSeason5MainCtrl:GetActivityGroupList()
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(true)
  local activityList = {}
  if list ~= nil then
    for _, v in pairs(list) do
      table.insert(activityList, v)
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

function LWSeason5MainCtrl:GetSeasonCardData()
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
  return cardData
end

return LWSeason5MainCtrl
