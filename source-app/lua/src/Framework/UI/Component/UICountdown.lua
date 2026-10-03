local UICountdown = BaseClass("UICountdown", UIBaseContainer)
local base = UIBaseContainer

function UICountdown:OnCreate()
  base.OnCreate(self)
  self.text = self:AddComponent(UITextMeshProUGUIEx, "text")
end

function UICountdown:OnDestroy()
  base.OnDestroy(self)
end

function UICountdown:SetEndTime(endTime)
  self.endTime = endTime
  self:Update1000MS()
end

function UICountdown:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now)
  self.text:SetText(countdown)
end

return UICountdown
