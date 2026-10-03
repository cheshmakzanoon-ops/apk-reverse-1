local OfficialDialogView = BaseClass("OfficialDialogView", UIBaseView)
local base = UIBaseView
local OfficialUser = require("UI.UIGovernment.OfficialUser")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"

function OfficialDialogView:OnCreate()
  base.OnCreate(self)
  local param, serverData = self:GetUserData()
  self.param = param
  self.serverData = serverData
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player:GetSelfServerId())
end

function OfficialDialogView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialDialogView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
end

function OfficialDialogView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function OfficialDialogView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("457029")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  local isConqueror = DataCenter.GovernmentManager:IsConqueror(LuaEntry.Player:GetCurServerId())
  for i = 1, 2 do
    local item = self:AddComponent(OfficialUser, "PopUpTitle/ScrollView/Viewport/OfficialList/colonistList/cell" .. i)
    item:ReInit(i, self.param, self.serverData)
    item:SetActive(isConqueror)
  end
  for i = 3, 8 do
    local item = self:AddComponent(OfficialUser, "PopUpTitle/ScrollView/Viewport/OfficialList/nativeList/cell" .. i)
    item:ReInit(i, self.param, self.serverData)
  end
end

function OfficialDialogView:ComponentDestroy()
  self.btn_back = nil
end

function OfficialDialogView:UpdateData(action)
  if action then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficialDialog)
  end
end

return OfficialDialogView
