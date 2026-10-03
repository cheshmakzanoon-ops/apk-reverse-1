local base = UIBaseContainer
local UILWTorchRelayMainCheerItemComponent = BaseClass("UILWTorchRelayMainCheerItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")

function UILWTorchRelayMainCheerItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayMainCheerItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayMainCheerItemComponent:ComponentDefine()
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textServer = self:AddComponent(UIText, "ServerText")
  self.textName = self:AddComponent(UIText, "NameText")
  self.btnAdd = self:AddComponent(UIButton, "AddBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.textEmpty = self:AddComponent(UIText, "EmptyText")
  self.textEmpty:SetLocalText("activity_torch_relay_desc_17")
  self.Background = self:AddComponent(UIImage, "Background")
end

function UILWTorchRelayMainCheerItemComponent:ComponentDestroy()
  self.compUIPlayerHead = nil
  self.textServer = nil
  self.textName = nil
  self.btnAdd = nil
  self.textEmpty = nil
end

function UILWTorchRelayMainCheerItemComponent:DataDefine()
end

function UILWTorchRelayMainCheerItemComponent:DataDestroy()
end

function UILWTorchRelayMainCheerItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayMainCheerItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayMainCheerItemComponent:ReInit(activityId, data)
  self.activityId = activityId
  self.data = data
  local isEmpty = self.data == nil
  self.compUIPlayerHead:SetActive(not isEmpty)
  self.btnAdd:SetActive(isEmpty)
  self.textName:SetActive(not isEmpty)
  self.textServer:SetActive(not isEmpty)
  self.textEmpty:SetActive(isEmpty)
  local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if actData and actData.config then
    self.Background:LoadSpriteAsync(actData.config:GetGameTeamMemberBg())
  end
  if not isEmpty then
    self.compUIPlayerHead:SetData(self.data.uid, self.data.pic, self.data.picver)
    self.textServer:SetText(UIUtil.FormatServerAllianceName(self.data.serverId, self.data.abbr, ""))
    self.textName:SetText(self.data.name)
  end
end

function UILWTorchRelayMainCheerItemComponent:OnBtnAddClick()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayCheerInfo, {anim = true}, {
      activityId = self.activityId
    })
  end
end

return UILWTorchRelayMainCheerItemComponent
