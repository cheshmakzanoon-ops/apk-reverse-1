local base = UIBaseContainer
local LWUIActEasterEggChatTop = BaseClass("LWUIActEasterEggChatTop", base)
local M = LWUIActEasterEggChatTop

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.textTitle:SetLocalText("MESSAGE EASTER EGG \229\164\154\232\175\173\232\168\128")
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "txtTitle")
end

function M:ComponentDestroy()
  self.btnClose = nil
  self.textTitle = nil
end

function M:OnBtnCloseClick()
  self.view.ctrl:CloseSelf()
end

return M
