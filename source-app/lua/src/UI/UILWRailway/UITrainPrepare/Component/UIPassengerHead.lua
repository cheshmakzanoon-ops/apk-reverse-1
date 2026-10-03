local base = UICommonHead
local UIPassengerHead = BaseClass("UIPassengerHead", base)
local Localization = CS.GameEntry.Localization

function UIPassengerHead:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIPassengerHead:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPassengerHead:ComponentDefine()
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

function UIPassengerHead:ComponentDestroy()
end

function UIPassengerHead:PlayAnim(name)
  self.anim:Play(name)
end

return UIPassengerHead
