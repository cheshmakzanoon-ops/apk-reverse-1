local base = UIAsyncContainer
local UIWorldSiegeQueenOfBloodRank = BaseClass("UIWorldSiegeQueenOfBloodRank", base)
local UIWorldSiegeQueenOfBloodRankItem = require("UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeQueenOfBloodRankItem")

function UIWorldSiegeQueenOfBloodRank:OnCreate()
  base.OnCreate(self)
  self.textTip = self:AddComponent(UIText, "TipText")
  self.firstItem = self:AddComponent(UIWorldSiegeQueenOfBloodRankItem, "FirstItem")
  self.secondItem = self:AddComponent(UIWorldSiegeQueenOfBloodRankItem, "SecondItem")
  self.thirdItem = self:AddComponent(UIWorldSiegeQueenOfBloodRankItem, "ThirdItem")
  self.itemList = {
    self.firstItem,
    self.secondItem,
    self.thirdItem
  }
end

function UIWorldSiegeQueenOfBloodRank:ReInit(data)
  self.data = data
  table.sort(self.data, function(a, b)
    return a.rank < b.rank
  end)
  self:UpdateData()
end

function UIWorldSiegeQueenOfBloodRank:OnDestroy()
  self.itemList = nil
  self.textTip = nil
  self.firstItem = nil
  self.secondItem = nil
  self.thirdItem = nil
  base.OnDestroy(self)
end

function UIWorldSiegeQueenOfBloodRank:UpdateData()
  if self:AsyncLoadDone() and self.itemList then
    local fullScore = 0
    if self.data and 0 < #self.data then
      fullScore = self.data[1].score
    end
    for i = 1, 3 do
      if self.data[i] then
        self.itemList[i]:SetActive(true)
        self.itemList[i]:SetData(self.data[i], fullScore)
      else
        self.itemList[i]:SetActive(false)
      end
    end
  end
end

function UIWorldSiegeQueenOfBloodRank:AsyncLoadDone()
  return GameObjectIsValid(self.gameObject)
end

return UIWorldSiegeQueenOfBloodRank
