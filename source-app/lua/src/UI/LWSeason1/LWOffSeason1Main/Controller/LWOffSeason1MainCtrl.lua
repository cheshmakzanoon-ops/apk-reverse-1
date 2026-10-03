local LWOffSeason1MainCtrl = BaseClass("LWOffSeason1MainCtrl", UIBaseCtrl)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWOffSeason1MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWOffSeason1Main)
end

function LWOffSeason1MainCtrl:GetActivityGroupList()
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(nil, true)
  local activityList = {}
  if list ~= nil then
    for i, v in pairs(list) do
      if not DataCenter.ActivityListDataManager:GetTheActIsCanShow(tonumber(v.id)) then
        Logger.Log(string.format("[\232\181\155\229\173\163\230\180\187\229\138\168] %s \233\133\141\231\189\174\233\154\144\232\151\143", v.id))
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
  end
  return activityList
end

return LWOffSeason1MainCtrl
