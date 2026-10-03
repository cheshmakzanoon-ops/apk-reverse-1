local LWS6AllianceRewardItem = BaseClass("LWS6AllianceRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "bg/titleBg/title"
local u_i_common_res_item_path = "bg/UICommonResItem"
local count_path = "bg/titleBg/count"
local content_path = "bg/Content"

function LWS6AllianceRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWS6AllianceRewardItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWS6AllianceRewardItem:OnEnable()
  base.OnEnable(self)
end

function LWS6AllianceRewardItem:OnDisable()
  base.OnDisable(self)
end

function LWS6AllianceRewardItem:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.count = self:AddComponent(UIText, count_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.common_res_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.common_res_item:GameObjectCreatePool()
end

function LWS6AllianceRewardItem:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content = nil
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  self.title = nil
  self.count = nil
  self.content = nil
end

function LWS6AllianceRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function LWS6AllianceRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWS6AllianceRewardItem:OnClaimBtn()
end

function LWS6AllianceRewardItem:SetData(data)
  local reward = data.reward
  self.title:SetText(data.tittle)
  self.count:SetText(string.format("%d/%d", data.rewardCount, data.rewardMax))
  self.content:RemoveComponents(UICommonResItem)
  self.common_res_item:GameObjectRecycleAll()
  self.content:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local go = self.common_res_item:GameObjectSpawn(self.content.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.86, 0.86, 0.86)
      go.name = "item" .. tostring(index)
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
end

return LWS6AllianceRewardItem
