local base = UIBaseContainer
local SeasonSelectLocationGameRewardDailyComp = BaseClass("SeasonSelectLocationGameRewardDailyComp", UIBaseContainer)
local SeasonSelectLocationGameRewardDailyItem = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.Comp.SeasonSelectLocationGameRewardDailyItem")

function SeasonSelectLocationGameRewardDailyComp:OnCreate()
  base.OnCreate(self)
  self.showDatalist = {}
  self.ScrollView = self:AddComponent(UIScrollView, "")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function SeasonSelectLocationGameRewardDailyComp:OnDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRewardDailyComp:OnEnable()
  base.OnEnable(self)
end

function SeasonSelectLocationGameRewardDailyComp:OnDisable()
  base.OnDisable(self)
end

function SeasonSelectLocationGameRewardDailyComp:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonSelectLocationGameRewardDailyItem)
  self.showDatalist = {}
end

function SeasonSelectLocationGameRewardDailyComp:RefreshList()
  self:ClearScroll()
  self.ScrollView:SetTotalCount(1)
  self.ScrollView:RefillCells()
end

function SeasonSelectLocationGameRewardDailyComp:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonSelectLocationGameRewardDailyItem, itemObj)
  cellItem:SetData(nil)
end

function SeasonSelectLocationGameRewardDailyComp:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonSelectLocationGameRewardDailyItem)
end

return SeasonSelectLocationGameRewardDailyComp
