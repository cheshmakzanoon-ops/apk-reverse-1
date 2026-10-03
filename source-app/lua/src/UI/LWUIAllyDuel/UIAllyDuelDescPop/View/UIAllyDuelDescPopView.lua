local UIAllyDuelDescPopView = BaseClass("UIAllyDuelDescPopView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local btn_close_path = "bg/BtnClose"
local info_btn_path = "bg/TextTitle/InfoBtn"

function UIAllyDuelDescPopView:OnCreate()
  base.OnCreate(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
  end)
end

function UIAllyDuelDescPopView:OnDestroy()
  self.panel = nil
  self.btn_close = nil
  self.info_btn = nil
  base.OnDestroy(self)
end

return UIAllyDuelDescPopView
