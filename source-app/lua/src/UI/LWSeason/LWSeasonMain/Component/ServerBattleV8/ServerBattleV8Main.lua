local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ServerBattleV8Main = BaseClass("ServerBattleV8Main", base)
local Localization = CS.GameEntry.Localization
local title_path = "title"
local info_btn_path = "InfoBtn"
local remain_time_path = "TimeBg/remainTime"
local btn_active_path = "BtnActive"
local btn_active_text_path = "BtnActive/BtnActiveText"
local desc_path = "Content/desc"

function ServerBattleV8Main:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.btn_active = self:AddComponent(UIButton, btn_active_path)
  self.btn_active_text = self:AddComponent(UITextMeshProUGUIEx, btn_active_text_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.btn_active:SetOnClick(BindCallback(self, self.OnGoToClick))
  self.desc:SetText(Localization:GetString("season_zone_war_01"))
  self.btn_active_text:SetLocalText("110003")
  UIUtil.GetWeekActiveCount("OpenServerBattleV8Main", true)
end

function ServerBattleV8Main:OnDestroy()
  base.OnDestroy(self)
end

function ServerBattleV8Main:OnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonServerBattleV8Detail)
end

function ServerBattleV8Main:OnGoToClick()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local mainBuildLV = DataCenter.BuildManager.MainLv
  if configSchedule == nil or configSchedule.needMainCityLevel ~= nil and mainBuildLV < configSchedule.needMainCityLevel or curTime >= configSchedule.endTime or curTime < configSchedule.startTime or not DataCenter.ZoneWarManager:IsBattleMember() then
    UIUtil.ShowTipsId(801606)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleMain)
  end
end

function ServerBattleV8Main:SetData(activityId)
  base.SetData(self, activityId)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData then
    self.title:SetLocalText(actData.name)
    self.fightStartTime = actData.startTime
    self.fightEndTime = actData.endTime
    self.activityData = actData
    self:Update1000MS()
  end
end

function ServerBattleV8Main:Update1000MS()
  if self.activityData ~= nil then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.fightStartTime then
      deltaTime = self.fightStartTime - curTime
    elseif curTime < self.fightEndTime then
      deltaTime = self.fightEndTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.remain_time:SetText(showTime)
    else
      self.remain_time:SetText("00:00:00")
    end
  end
end

return ServerBattleV8Main
