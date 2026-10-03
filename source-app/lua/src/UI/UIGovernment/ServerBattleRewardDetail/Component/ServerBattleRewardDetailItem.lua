local ServerBattleRewardDetailItem = BaseClass("ServerBattleRewardDetailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local king_reward_root_path = "KingReward"
local king_reward_path = "KingReward/KingReward"
local king_reward_item_path = "KingReward/KingRewardItem"
local zone_reward_root_path = "ZoneReward"
local zone_reward_path = "ZoneReward/ZoneReward"
local zone_reward_item_path = "ZoneReward/ZoneRewardItem"
local al_reward_root_path = "ALReward"
local al_reward_path = "ALReward/ALReward"
local al_reward_item_path = "ALReward/ALRewardItem"

function ServerBattleRewardDetailItem:OnCreate()
  base.OnCreate(self)
  self.rank_text = self:AddComponent(UIText, "rank/rankText")
  self.reward_list = self:AddComponent(UIBaseContainer, "PlayerReward/ScrollView/Viewport/Content")
  self.king_reward_root = self:AddComponent(UIBaseComponent, king_reward_root_path)
  self.king_reward = self:AddComponent(UIText, king_reward_path)
  self.king_reward_item = self:AddComponent(UICommonResItem, king_reward_item_path)
  self.zone_reward_root = self:AddComponent(UIBaseComponent, zone_reward_root_path)
  self.zone_reward = self:AddComponent(UIText, zone_reward_path)
  self.zone_reward_item = self:AddComponent(UICommonResItem, zone_reward_item_path)
  self.al_reward_root = self:AddComponent(UIBaseComponent, al_reward_root_path)
  self.al_reward = self:AddComponent(UIText, al_reward_path)
  self.al_reward_item = self:AddComponent(UICommonResItem, al_reward_item_path)
end

function ServerBattleRewardDetailItem:OnDestroy()
  self.theItemPool = nil
  self.rewardList = nil
  self.cursor = nil
  self:CleanNodes()
  base.OnDestroy(self)
end

function ServerBattleRewardDetailItem:SetRewardItem(itemId, itemNode, itemCount)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(tostring(itemId))
  if template then
    local param = {}
    param.count = itemCount or 1
    param.rewardType = RewardType.GOODS
    param.itemId = itemId
    itemNode:ReInit(param)
    return template.name or ""
  end
  return ""
end

function ServerBattleRewardDetailItem:CleanNodes()
  self.reward_list:RemoveComponents(UICommonResItem)
  if self.itemList then
    for _, v in ipairs(self.itemList) do
      if v then
        v:GameObjectRecycle()
      end
    end
    self.itemList = nil
  end
end

function ServerBattleRewardDetailItem:ReInit(rank, data, theItemTemplate, title)
  if title then
    self.rank_text:SetText(title)
  else
    self.rank_text:SetLocalText(801430, rank)
  end
  self.data = data
  self:CleanNodes()
  if data.kingReward and #data.kingReward ~= 0 then
    self.king_reward_root:SetActive(true)
    self.king_reward_item:ParseInfo(data.kingReward[1])
    self.king_reward:SetText(self.king_reward_item.nameText)
  else
    self.king_reward_root:SetActive(false)
  end
  if data.kingAlReward and #data.kingAlReward ~= 0 then
    self.al_reward_root:SetActive(true)
    self.al_reward_item:ParseInfo(data.kingAlReward[1])
    self.al_reward:SetText(self.al_reward_item.nameText)
  else
    self.al_reward_root:SetActive(false)
  end
  if string.IsNullOrEmpty(data.serverBadges) then
    self.zone_reward_root:SetActive(false)
  else
    self.zone_reward_root:SetActive(true)
    self.zone_reward:SetText(Localization:GetString(self:SetRewardItem(data.serverBadges, self.zone_reward_item)))
  end
  if data.normalReward ~= nil and #data.normalReward ~= 0 then
    self.rewardList = data.normalReward
    self.cursor = 1
    self.theItemPool = theItemTemplate
  else
    self.theItemPool = nil
    self.rewardList = nil
    self.cursor = nil
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function ServerBattleRewardDetailItem:Update100MS()
  if self.rewardList == nil or self.theItemPool == nil or self.cursor == nil or #self.rewardList < self.cursor then
    return
  end
  local data = self.rewardList[self.cursor]
  if data then
    local theName = "item_" .. UIUtil.GetLoopListItemIndex()
    local goItem = self.theItemPool:GameObjectSpawn(self.reward_list.transform)
    goItem.name = theName
    goItem:SetActive(true)
    local theItem = self.reward_list:AddComponent(UICommonResItem, theName)
    theItem:ParseInfo(data)
    self.cursor = self.cursor + 1
    if self.itemList == nil then
      self.itemList = {}
    end
    table.insert(self.itemList, goItem)
  end
  if data == nil or self.rewardList[self.cursor] == nil then
    self.theItemPool = nil
    self.rewardList = nil
    self.cursor = nil
  end
end

return ServerBattleRewardDetailItem
