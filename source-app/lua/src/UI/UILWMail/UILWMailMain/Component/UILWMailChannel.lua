local UILWMailChannel = BaseClass("UILWMailChannel", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MailChannelItem = require("UI.UILWMail.UILWMailMain.Component.UILWMailChannelItem")
local content_path = "CScroll/CViewport/CContent"
local item_path = "UILWMailChannelItem"

function UILWMailChannel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailChannel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailChannel:ComponentDefine()
  self.channelContent = self:AddComponent(UIBaseContainer, content_path)
  self.channelItemPrefab = self.transform:Find(item_path).gameObject
  self.channelItemPrefab:GameObjectCreatePool()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

function UILWMailChannel:ComponentDestroy()
  self.channelContent = nil
  self.channelItemPrefab = nil
end

function UILWMailChannel:DataDefine()
end

function UILWMailChannel:DataDestroy()
end

function UILWMailChannel:OnEnable()
  base.OnEnable(self)
end

function UILWMailChannel:OnDisable()
  base.OnDisable(self)
end

function UILWMailChannel:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailChannel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailChannel:ClearContent()
  self.channelContent:RemoveComponents(MailChannelItem)
end

function UILWMailChannel:RefreshContent()
  self:ClearContent()
  self.channelItemPrefab.gameObject:GameObjectRecycleAll()
  local isInSeason = SeasonUtil.IsInSeason()
  for i = 1, table.count(MailShowGroup) do
    local group = MailShowGroup[i]
    local enable = true
    if group == MailInternalGroup.MAIL_IN_season and not isInSeason then
      local count = DataCenter.MailDataManager:GetMailUnReadCountByGroup(group)
      if count == 0 then
        count = DataCenter.MailDataManager:GetMailUnRewardCountByGroup(group)
      end
      enable = 0 < toInt(count)
    end
    if enable then
      local item = self.channelItemPrefab:GameObjectSpawn(self.channelContent.transform)
      item.name = "channel_item" .. i
      local cell = self.channelContent:AddComponent(MailChannelItem, item.name)
      local params = {tab = group}
      cell:SetData(params)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.channelContent.rectTransform)
end

function UILWMailChannel:SetShow(bool)
  self:SetActive(bool)
end

return UILWMailChannel
