local base = UIBaseContainer
local UIDoomsdayRankItem = BaseClass("UIDoomsdayRankItem", base)
local compBook = {
  {
    path = "imgRibbon",
    name = "imgRibbon",
    type = UIImage
  },
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "scroll",
    name = "scroll",
    type = UIScrollRect
  },
  {
    path = "scroll/Viewport/Content",
    name = "content",
    type = UIBaseContainer
  },
  {
    path = "scroll/itemReward",
    name = "itemReward",
    type = nil,
    active = false
  }
}

function UIDoomsdayRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayRankItem:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayRankItem:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayRankItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemReward:GameObjectCreatePool()
  self.rewardItems = {}
end

function UIDoomsdayRankItem:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.itemReward:GameObjectRecycleAll()
  self:ClearCompsByBook(compBook)
  self.rewardItems = nil
end

function UIDoomsdayRankItem:Refresh(vo)
  self.imgRibbon:LoadSprite(vo.ribbonRes)
  self.txtRank:SetText(vo.rankStr)
  local idx = 0
  for i, reward in ipairs(vo.rewards) do
    local itemComp = self.rewardItems[i]
    if not itemComp then
      local newItem = self.itemReward:GameObjectSpawn(self.content.transform)
      local itemLbl = "item_" .. i
      newItem.name = itemLbl
      itemComp = self.content:AddComponent(UICommonResItem, itemLbl)
      self.rewardItems[i] = itemComp
    end
    if not reward.VO then
      reward.VO = {
        rewardType = reward.type,
        itemId = type(reward.value) == "table" and reward.value.id or 0,
        count = type(reward.value) == "table" and reward.value.num or reward.value
      }
    end
    itemComp:SetActive(true)
    itemComp:ReInit(reward.VO)
    idx = i
  end
  for i = idx + 1, #self.rewardItems do
    local itemComp = self.rewardItems[i]
    if itemComp then
      itemComp:SetActive(false)
    end
  end
  self.scroll:StopMovement()
  self.scroll:SetHorizontalNormalizedPosition(0)
end

return UIDoomsdayRankItem
