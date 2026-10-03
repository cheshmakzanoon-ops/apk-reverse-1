local UIMultipleParkourRank = BaseClass("UIMultipleParkourRank", UIBaseContainer)
local UIMultipleParkourRankItem = require("UI.UIMultipleParkour.Win.Component.UIMultipleParkourRankItem")
local base = UIBaseContainer
local scroll_rank_path = "scrollRank"

function UIMultipleParkourRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

function UIMultipleParkourRank:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourRank:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.scrollRank = self:AddComponent(UIDynamicVerticleScrollRectEx, scroll_rank_path)
  self.itemIncNo = 1
  self.rankItemMap = {}
  self.scrollRank:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rankItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rankItem = self:AddComponent(UIMultipleParkourRankItem, itemObj)
    self.rankItemMap[itemObj] = rankItem
  end)
  self.scrollRank:AddDisplayItemListener(function(itemObj, dataIdx)
    local rankItem = self.rankItemMap[itemObj]
    assert(rankItem, "rankItem is nil. dataIdx:" .. dataIdx)
    local rankData = self.players[dataIdx + 1]
    assert(rankData, "rankData is nil. dataIdx:" .. dataIdx)
    rankItem:Refresh(rankData, DataCenter.MultipleParkourManager:GetTopScore())
  end)
  self.players = DataCenter.MultipleParkourManager:GetAllPlayers()
end

function UIMultipleParkourRank:ComponentDestroy()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.scrollRank = nil
end

function UIMultipleParkourRank:FadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.canvasGroup.alpha
  end, function(value)
    self.canvasGroup.alpha = value
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIMultipleParkourRank:RefreshView()
  self.scrollRank:SetDatas(self.players)
  self.scrollRank:UpdateItems()
end

return UIMultipleParkourRank
