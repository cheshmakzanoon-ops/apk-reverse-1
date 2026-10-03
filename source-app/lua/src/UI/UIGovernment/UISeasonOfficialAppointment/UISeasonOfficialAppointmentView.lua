local UISeasonOfficialAppointmentView = BaseClass("UISeasonOfficialAppointmentView", UIBaseView)
local base = UIBaseView
local OfficialUser = require("UI.UIGovernment.OfficialUser")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"

function UISeasonOfficialAppointmentView:OnCreate()
  base.OnCreate(self)
  local param, serverData = self:GetUserData()
  self.param = param
  self.serverData = serverData
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player:GetSelfServerId())
end

function UISeasonOfficialAppointmentView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialAppointmentView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
end

function UISeasonOfficialAppointmentView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UISeasonOfficialAppointmentView:ComponentDefine()
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

function UISeasonOfficialAppointmentView:ComponentDestroy()
  self.btn_back = nil
end

function UISeasonOfficialAppointmentView:UpdateData(action)
  if action then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialAppointment)
  end
end

return UISeasonOfficialAppointmentView
