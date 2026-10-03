local UIMainBirthdaySetTipBtn = BaseClass("UIMainBirthdaySetTipBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIMainBirthdaySetTipBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainBirthdaySetTipBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainBirthdaySetTipBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OpenSetView()
  end)
end

function UIMainBirthdaySetTipBtn:ComponentDestroy()
  self.btn = nil
end

function UIMainBirthdaySetTipBtn:OpenSetView()
  UIUtil.OpenUIPlayerInfo(LuaEntry.Player.uid)
end

return UIMainBirthdaySetTipBtn
