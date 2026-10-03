local UIMainJungleTrialObj = BaseClass("UIMainJungleTrialObj", UIAsyncContainer)
local base = UIAsyncContainer
local btn_path = "btn"

function UIMainJungleTrialObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainJungleTrialObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainJungleTrialObj:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.icon = self:AddComponent(UIImage, "Icon")
end

function UIMainJungleTrialObj:ComponentDestroy()
  self.btn = nil
  self.icon = nil
end

function UIMainJungleTrialObj:OnClickBtn()
  local nearestJungleTrial = DataCenter.JungleTrialDataManager:GetNearestChomper()
  if nearestJungleTrial then
    GoToUtil.MoveToWorldMarchAndOpen(nearestJungleTrial.pointId, nearestJungleTrial.monsterUuid, nearestJungleTrial.serverId, 0)
  end
end

function UIMainJungleTrialObj:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > DataCenter.JungleTrialDataManager:GetEndTime() then
    EventManager:GetInstance():Broadcast(EventId.JungleTrialMonsterRefresh)
  end
end

return UIMainJungleTrialObj
