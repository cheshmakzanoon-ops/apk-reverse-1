local PresidentDeclarationView = BaseClass("PresidentDeclarationView", UIBaseView)
local base = UIBaseView
local PresidentDeclarationItem = require("UI.UIGovernment.PresidentDeclaration.Component.PresidentDeclarationItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/Content/TitleText"
local input_field_path = "PopUpTitle/Content/InputField"
local bottom_path = "PopUpTitle/Content/Bottom"
local btn_effect_path = "PopUpTitle/Content/Bottom/BtnEffect"

function PresidentDeclarationView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.serverId = param
  self:ComponentDefine()
end

function PresidentDeclarationView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PresidentDeclarationView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.dialog_title_text:SetLocalText("457049")
  self.title_text:SetLocalText("457050")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.btnSubmit = self:AddComponent(UIButton, btn_effect_path)
  self.input_field:SetOnValueChange(function(value)
    self:InputValueChange(value)
  end)
  self.btnSubmit:SetOnClick(function()
    self:OnSubmitClick()
  end)
  local info = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  if info ~= nil and info.declaration ~= nil and info.declaration ~= "" then
    self.input_field:SetText(info.declaration)
    self.declaration = info.declaration
  else
    self.input_field:SetLocalText("457062")
  end
end

function PresidentDeclarationView:InputValueChange(value)
  self.theDeclaration = value
end

function PresidentDeclarationView:OnSubmitClick()
  local inputStr = self.input_field:GetText()
  if inputStr == "" then
    return
  end
  if inputStr ~= self.declaration then
    DataCenter.GovernmentManager:ModifyKingDeclaration(inputStr)
  end
end

function PresidentDeclarationView:ComponentDestroy()
  self.btn_back = nil
end

return PresidentDeclarationView
