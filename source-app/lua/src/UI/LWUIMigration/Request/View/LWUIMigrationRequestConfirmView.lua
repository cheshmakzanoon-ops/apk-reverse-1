local base = UIBaseView
local LWUIMigrationRequestConfirmView = BaseClass("LWUIMigrationRequestConfirmView", base)
local close_panel_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local left_btn_path = "BtnGo/LeftBtn"
local left_btn_text_path = "BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "BtnGo/RightBtn"
local right_btn_text_path = "BtnGo/RightBtn/RightBtnName"
local content_text_path = "DesName"
local CD_TIME = 10

function LWUIMigrationRequestConfirmView:OnCreate()
  base.OnCreate(self)
  local tipText, cb = self:GetUserData()
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_text:SetLocalText(100378)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(closeCb)
  self.close_panel_btn = self:AddComponent(UIButton, close_panel_btn_path)
  self.close_panel_btn:SetOnClick(closeCb)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn:SetOnClick(function()
    if cb then
      cb()
    end
    self.ctrl:CloseSelf()
  end)
  self.left_btn_text = self:AddComponent(UIText, left_btn_text_path)
  self.leftText = CS.GameEntry.Localization:GetString(GameDialogDefine.CONFIRM)
  CS.UIGray.SetGray(self.left_btn.transform, true, false)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(closeCb)
  self.right_btn_text = self:AddComponent(UIText, right_btn_text_path)
  self.right_btn_text:SetLocalText(GameDialogDefine.CANCEL)
  self.content_text = self:AddComponent(UIText, content_text_path)
  self.content_text:SetText(tipText)
  self.sSec = UITimeManager:GetInstance():GetServerSeconds()
  self:Update1000MS()
end

function LWUIMigrationRequestConfirmView:Update1000MS()
  if self.sSec == nil or self.leftText == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local leftSec = CD_TIME - (curSec - self.sSec)
  if 0 < leftSec then
    self.left_btn_text:SetText(leftSec .. "s " .. self.leftText)
  else
    self.left_btn_text:SetText(self.leftText)
    CS.UIGray.SetGray(self.left_btn.transform, false, true)
  end
end

return LWUIMigrationRequestConfirmView
