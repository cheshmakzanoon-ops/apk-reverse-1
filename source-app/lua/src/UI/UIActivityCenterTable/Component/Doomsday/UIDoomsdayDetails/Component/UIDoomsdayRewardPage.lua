local base = UIBaseContainer
local UIDoomsdayRewardPage = BaseClass("UIDoomsdayRewardPage", base)
local RewardItem = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayRewardItem")
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
    path = "scroll/itemReward",
    name = "itemReward",
    type = nil,
    active = false
  }
}

function UIDoomsdayRewardPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayRewardPage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayRewardPage:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayRewardPage:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayRewardPage:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemIncNo = 1
  self.itemComps = {}
  self.scroll:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "item_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local itemComp = self:AddComponent(RewardItem, itemObj)
    self.itemComps[itemObj] = itemComp
  end)
  self.scroll:AddDisplayItemListener(function(itemObj, dataIdx)
    local itemComp = self.itemComps[itemObj]
    local vo = self.voArr[dataIdx + 1]
    itemComp:Refresh(vo)
  end)
end

function UIDoomsdayRewardPage:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDoomsdayRewardPage:Refresh(voArr)
  self.voArr = voArr
  self.prefabIdxs = {}
  for _, _ in ipairs(voArr) do
    table.insert(self.prefabIdxs, 0)
  end
  self.scroll:SetDatas(self.prefabIdxs)
  self.scroll:SetScrollOffset(0)
end

function UIDoomsdayRewardPage:Clear()
  self.scroll:SetDatas({})
end

return UIDoomsdayRewardPage
