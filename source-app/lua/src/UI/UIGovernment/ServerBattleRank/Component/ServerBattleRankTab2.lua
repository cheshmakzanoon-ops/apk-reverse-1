local ServerBattleRankTab2 = BaseClass("ServerBattleRankTab2", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ServerBattleRankTab2Item = require("UI.UIGovernment.ServerBattleRank.Component.ServerBattleRankTab2Item")
local reward_item_path = "ScrollView/RewardItem"
local item_path = "ScrollView/item"
local content_path = "ScrollView/Viewport/Content"
local obj_no_value_path = "ScrollView/NoValue"

function ServerBattleRankTab2:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theCell = self.transform:Find(item_path).gameObject
  self.theCell:GameObjectCreatePool()
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.noValue = self:AddComponent(UIBaseContainer, obj_no_value_path)
end

function ServerBattleRankTab2:OnDestroy()
  self:DeInit()
  base.OnDestroy(self)
end

function ServerBattleRankTab2:ReInit()
  if self.data == nil then
    local data = DataCenter.ZoneWarManager.personScoreRankRewardPreview
    if data == nil then
      SFSNetwork.SendMessage(MsgDefines.GetCrossKingPersonScoreRankRewardPreviewInfo)
    else
      self:RefreshRankList()
    end
  end
end

function ServerBattleRankTab2:DeInit()
  self.content:RemoveComponents(ServerBattleRankTab2Item)
  self.theItem:GameObjectRecycleAll()
  self.theCell:GameObjectRecycleAll()
end

function ServerBattleRankTab2:RefreshRankList()
  local data = DataCenter.ZoneWarManager.personScoreRankRewardPreview
  if data == nil then
    self.noValue:SetActive(true)
    return
  end
  self.data = data
  local goItem, theItem
  self:DeInit()
  for i, v in ipairs(data) do
    goItem = self.theCell:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    theItem = self.content:AddComponent(ServerBattleRankTab2Item, goItem.name)
    theItem:ReInit(v, self.theItem)
  end
  self.noValue:SetActive(#data == 0)
end

return ServerBattleRankTab2
