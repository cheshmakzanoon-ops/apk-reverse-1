local LWSeason4MainCtrl = BaseClass("LWSeason4MainCtrl", UIBaseCtrl)
local SeasonMainActivitySignUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonMainActivitySignUtils")

function LWSeason4MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeason4Main)
end

function LWSeason4MainCtrl:GetActivityGroupList()
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

function LWSeason4MainCtrl:GetSeasonCardData()
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
  return cardData
end

return LWSeason4MainCtrl
