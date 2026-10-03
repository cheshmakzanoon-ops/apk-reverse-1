local TorchRelayCheerMemberItem = BaseClass("TorchRelayCheerMemberItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")
local select_flag_path = "ContentPlayer/toggleBtn/selectFlag"

function TorchRelayCheerMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TorchRelayCheerMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TorchRelayCheerMemberItem:ComponentDefine()
  self.textPlayer = self:AddComponent(UIText, "ContentPlayer/PlayerText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "ContentPlayer/UIPlayerHead")
  self.toggleBtn = self:AddComponent(UIButton, "ContentPlayer/toggleBtn")
  self.toggleBtn:SetOnClick(function()
    self:OnToggleBtnClick()
  end)
  self.select_flag = self:AddComponent(UIBaseContainer, select_flag_path)
end

function TorchRelayCheerMemberItem:ComponentDestroy()
  self.textPlayer = nil
  self.compUIPlayerHead = nil
  self.toggleBtn = nil
  self.select_flag = nil
end

function TorchRelayCheerMemberItem:DataDefine()
end

function TorchRelayCheerMemberItem:DataDestroy()
end

function TorchRelayCheerMemberItem:OnAddListener()
  base.OnAddListener(self)
end

function TorchRelayCheerMemberItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TorchRelayCheerMemberItem:ReInit(param)
  self.activityId = param.activityId
  self.data = param.data
  self.onToggleClickHolder = param.holder
  self.onToggleClickHandler = param.onToggleClickHandler
  self.compUIPlayerHead:SetData(self.data.uid, self.data.pic, self.data.picver)
  self.textPlayer:SetText(UIUtil.FormatServerAllianceName(self.data.serverId, self.data.abbr, self.data.name))
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local isSelect = activityData:IsCheering(self.data.uid)
  self:SetSelectFlagVisible(isSelect)
end

function TorchRelayCheerMemberItem:OnToggleBtnClick()
  if self.onToggleClickHandler then
    self.onToggleClickHandler(self.onToggleClickHolder, self)
  end
end

function TorchRelayCheerMemberItem:SetSelectFlagVisible(visible)
  self.select_flag.gameObject:SetActive(visible)
end

return TorchRelayCheerMemberItem
