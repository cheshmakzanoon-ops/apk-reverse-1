local base = UIBaseContainer
local UILWTorchRelayCheerItemComponent = BaseClass("UILWTorchRelayCheerItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")

function UILWTorchRelayCheerItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayCheerItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayCheerItemComponent:ComponentDefine()
  self.compContentPlayer = self:AddComponent(UIBaseContainer, "ContentPlayer")
  self.textPlayer = self:AddComponent(UIText, "ContentPlayer/PlayerText")
  self.textPlayerDes = self:AddComponent(UIText, "ContentPlayer/PlayerDesText")
  self.textPlayerDes:SetText(Localization:GetString("activity_torch_relay_desc_12"))
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "ContentPlayer/UIPlayerHead")
  self.compContentEmpty = self:AddComponent(UIBaseContainer, "ContentEmpty")
  self.textInviteTitle = self:AddComponent(UIText, "ContentEmpty/InviteTitleText")
  self.textInviteTitle:SetText(Localization:GetString("activity_torch_relay_desc_10"))
  self.textInviteDes = self:AddComponent(UIText, "ContentEmpty/InviteDesText")
  self.textInviteDes:SetText(Localization:GetString("activity_torch_relay_desc_11"))
  self.btnAdd = self:AddComponent(UIButton, "ContentEmpty/AddBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
end

function UILWTorchRelayCheerItemComponent:ComponentDestroy()
  self.compContentPlayer = nil
  self.textPlayer = nil
  self.textPlayerDes = nil
  self.compUIPlayerHead = nil
  self.compContentEmpty = nil
  self.textInviteTitle = nil
  self.textInviteDes = nil
  self.btnAdd = nil
end

function UILWTorchRelayCheerItemComponent:DataDefine()
end

function UILWTorchRelayCheerItemComponent:DataDestroy()
end

function UILWTorchRelayCheerItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayCheerItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayCheerItemComponent:ReInit(activityId, data)
  self.activityId = activityId
  self.data = data
  local isEmpty = self.data == nil
  self.compContentPlayer:SetActive(not isEmpty)
  self.compContentEmpty:SetActive(isEmpty)
  if not isEmpty then
    self.compUIPlayerHead:SetData(self.data.uid, self.data.pic, self.data.picver)
    self.textPlayer:SetText(UIUtil.FormatServerAllianceName(self.data.serverId, self.data.abbr, self.data.name))
  end
end

function UILWTorchRelayCheerItemComponent:OnBtnAddClick()
  if self.activityId then
    local share_param = {}
    share_param.sid = LuaEntry.Player:GetSelfServerId()
    share_param.post = PostType.TorchRelayCheer
    share_param.postType = PostType.TorchRelayCheer
    share_param.activityId = self.activityId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  end
end

return UILWTorchRelayCheerItemComponent
