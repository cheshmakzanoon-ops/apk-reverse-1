local UITutorialAnimation = BaseClass("UITutorialAnimation", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local duration = self:GetUserData()
  self.textTip = self:AddComponent(UIText, "Root/TextTips")
  self.textTip:SetLocalText(333014)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, duration)
end

UITutorialAnimation.OnCreate = OnCreate
UITutorialAnimation.OnDestroy = OnDestroy
UITutorialAnimation.ComponentDefine = ComponentDefine
return UITutorialAnimation
