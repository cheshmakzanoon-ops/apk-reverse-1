local base = UIBaseContainer
local UIDoomsdayRankPage = BaseClass("UIDoomsdayRankPage", base)
local RankItem = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayRankItem")
local compBook = {
  {
    path = "scroll",
    name = "scroll",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "scroll/Viewport/Content",
    name = "content",
    type = UIBaseContainer
  },
  {
    path = "txtEmpty",
    name = "txtEmpty",
    type = UIText
  },
  {
    path = "scroll/itemRank",
    name = "itemRank",
    type = nil,
    active = false
  },
  {
    path = "itemSelf",
    name = "itemSelf",
    type = RankItem,
    active = false
  }
}

function UIDoomsdayRankPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayRankPage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayRankPage:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayRankPage:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayRankPage:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemIncNo = 1
  self.itemComps = {}
  self.scroll:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "item_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local itemComp = self:AddComponent(RankItem, itemObj)
    self.itemComps[itemObj] = itemComp
  end)
  self.scroll:AddDisplayItemListener(function(itemObj, dataIdx)
    local itemComp = self.itemComps[itemObj]
    local vo = self.voArr.rankVOs[dataIdx + 1]
    itemComp:Refresh(vo)
  end)
end

function UIDoomsdayRankPage:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDoomsdayRankPage:Refresh(voArr)
  self.voArr = voArr
  self.prefabIdxs = {}
  local myRankVO = voArr.selfRankVO
  for _, vo in ipairs(voArr.rankVOs) do
    table.insert(self.prefabIdxs, 0)
  end
  self.scroll:SetDatas(self.prefabIdxs)
  self.scroll:SetScrollOffset(0)
  if myRankVO then
    self.itemSelf:SetActive(true)
    self.itemSelf:Refresh(myRankVO)
  else
    self.itemSelf:SetActive(false)
  end
  self.txtEmpty:SetActive(#voArr.rankVOs <= 0)
end

function UIDoomsdayRankPage:Clear()
  self.scroll:SetDatas({})
  self.itemSelf:SetActive(false)
end

return UIDoomsdayRankPage
