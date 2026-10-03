local UIMainWinterStormTipMainBtn = BaseClass("UIMainWinterStormTipMainBtn", UIButton)
local base = UIButton

function UIMainWinterStormTipMainBtn:OnCreate()
  base.OnCreate(self)
  self:SetOnClick(function()
    local actInfos = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActWinterStorm.Type)
    if 0 < #actInfos then
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actInfos[1].id)
    end
  end)
end

function UIMainWinterStormTipMainBtn:Refresh()
  if RaceEntranceUtil.IsNewEntranceOpen() or not RaceEntranceUtil.IsOldEntranceOpen() then
    self:SetActive(false)
    return
  end
  local activityDatas = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActWinterStorm.Type)
  local activityData = activityDatas ~= nil and activityDatas[1] or nil
  if activityData == nil then
    self:SetActive(false)
    return
  end
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv == nil then
    Logger.LogError("UIMainWinterStormTipMainBtn::Refresh mainLv is nil")
    mainLv = 0
  end
  local lv = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k14", 15)
  if mainLv < lv then
    self:SetActive(false)
    return
  end
  local flag = DataCenter.ActWinterStormManager:CheckInBattleTime()
  self:SetActive(flag)
end

return UIMainWinterStormTipMainBtn
