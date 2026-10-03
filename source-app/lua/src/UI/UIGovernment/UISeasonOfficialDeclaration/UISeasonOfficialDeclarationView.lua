local UISeasonOfficialDeclarationView = BaseClass("UISeasonOfficialDeclarationView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local input_field_path = "PopUpTitle/Content/InputField"
local bottom_path = "PopUpTitle/Content/Bottom"
local btn_effect_path = "PopUpTitle/Content/Bottom/BtnEffect"
local DEFAULT_DECLARE = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_4",
  [GovOfficialType.Center] = "supreme_president_ui_5"
}
local DECLARE_NAME = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_3",
  [GovOfficialType.Center] = "supreme_president_ui_4"
}

function UISeasonOfficialDeclarationView:OnCreate()
  base.OnCreate(self)
  self.govOfficialType, self.serverId, self.buildingId = self:GetUserData()
  self:ComponentDefine()
end

function UISeasonOfficialDeclarationView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialDeclarationView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText(DECLARE_NAME[self.govOfficialType])
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
  local info = DataCenter.BuildingOfficialManager:GetSurfaceLeader(self.serverId, self.buildingId)
  if info ~= nil and info.declaration ~= nil and info.declaration ~= "" then
    self.input_field:SetText(info.declaration)
    self.declaration = info.declaration
  else
    self.input_field:SetLocalText(DEFAULT_DECLARE[self.govOfficialType])
  end
end

function UISeasonOfficialDeclarationView:InputValueChange(value)
  self.theDeclaration = value
end

function UISeasonOfficialDeclarationView:OnSubmitClick()
  local inputStr = self.input_field:GetText()
  if inputStr == "" then
    return
  end
  if inputStr ~= self.declaration then
    DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionDeclarationUpdate(self.serverId, self.buildingId, inputStr)
  end
end

function UISeasonOfficialDeclarationView:ComponentDestroy()
  self.btn_back = nil
end

function UISeasonOfficialDeclarationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionDeclarationUpdate, self.CloseSelf)
end

function UISeasonOfficialDeclarationView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionDeclarationUpdate, self.CloseSelf)
  base.OnRemoveListener(self)
end

function UISeasonOfficialDeclarationView:CloseSelf()
  self.ctrl:CloseSelf()
end

return UISeasonOfficialDeclarationView
