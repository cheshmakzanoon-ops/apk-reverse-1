local UILWSeasonFactionWarInviteDlgView = BaseClass("UILWSeasonFactionWarInviteDlgView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local InviteDlgItem = require("UI.LWSeason2.UILWSeasonFactionWarInviteDlg.Component.UILWSeasonFactionWarInviteDlgItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local item_path = "PopUpTitle/ScrollView/Viewport/Content/Item"
local input_field_text_path = "PopUpTitle/InputFieldText"
local tips_path = "PopUpTitle/tips"

function UILWSeasonFactionWarInviteDlgView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.theContent = Localization:GetString("season_s2_faction_war_tips_07")
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteList)
end

function UILWSeasonFactionWarInviteDlgView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarInviteDlgView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteListUpdate, self.OnInviteListUpdate)
end

function UILWSeasonFactionWarInviteDlgView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteListUpdate, self.OnInviteListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarInviteDlgView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s2_faction_war_44")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.input_field_text = self:AddComponent(UIInput, input_field_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.input_field_text:SetLocalText("season_s2_faction_war_tips_07")
  self.input_field_text:SetOnValueChange(function(value)
    self:TextValueChange(value)
  end)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.tips:SetActive(false)
end

function UILWSeasonFactionWarInviteDlgView:ComponentDestroy()
  self.content:RemoveComponents(InviteDlgItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.tips = nil
  self.input_field_text = nil
end

function UILWSeasonFactionWarInviteDlgView:TextValueChange(value)
  self.theContent = value or ""
  self.tips:SetActive(#self.theContent > 150)
end

function UILWSeasonFactionWarInviteDlgView:OnInviteListUpdate(dataList)
  local goItem, theItem
  self.content:RemoveComponents(InviteDlgItem)
  self.theItem:GameObjectRecycleAll()
  if dataList then
    for k, v in ipairs(dataList) do
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      theItem = self.content:AddComponent(InviteDlgItem, goItem.name)
      theItem:ReInit(k, v, self)
    end
  end
end

return UILWSeasonFactionWarInviteDlgView
