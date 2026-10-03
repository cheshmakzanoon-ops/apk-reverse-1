local base = UIBaseContainer
local UIDoomsdayAchievePage = BaseClass("UIDoomsdayAchievePage", base)
local AchieveItem = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayAchieveItem")
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
    path = "scroll/itemAchieve",
    name = "itemAchieve",
    type = nil,
    active = false
  },
  {
    path = "btnAll",
    name = "btnAll",
    type = UIButton,
    onClick = function(self)
      self:RecieveAll()
    end
  }
}

function UIDoomsdayAchievePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayAchievePage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayAchievePage:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayAchievePage:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayAchievePage:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemIncNo = 1
  self.itemComps = {}
  self.scroll:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "item_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local itemComp = self:AddComponent(AchieveItem, itemObj)
    self.itemComps[itemObj] = itemComp
  end)
  self.scroll:AddDisplayItemListener(function(itemObj, dataIdx)
    local itemComp = self.itemComps[itemObj]
    local vo = self.voArr[dataIdx + 1]
    itemComp:Refresh(vo)
  end)
end

function UIDoomsdayAchievePage:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDoomsdayAchievePage:Refresh(voArr)
  self.voArr = voArr
  self.prefabIdxs = {}
  self.canRecieveVOs = {}
  self.firstCanRecieveVOIndex = nil
  for i, vo in ipairs(voArr) do
    table.insert(self.prefabIdxs, 0)
    if vo.canRecieve then
      if not self.firstCanRecieveVOIndex then
        self.firstCanRecieveVOIndex = i
      end
      table.insert(self.canRecieveVOs, vo)
    end
  end
  self.scroll:SetDatas(self.prefabIdxs)
  if self.firstCanRecieveVOIndex then
    local scrollOffset = self.scroll:GetScrollOffsetOfDataIdx(self.firstCanRecieveVOIndex - 1)
    self.scroll:SetScrollOffset(scrollOffset)
  else
    self.scroll:SetScrollOffset(0)
  end
  self.btnAll:SetActive(#self.canRecieveVOs > 0)
end

function UIDoomsdayAchievePage:Clear()
  self.scroll:SetDatas({})
  self.btnAll:SetActive(false)
end

function UIDoomsdayAchievePage:RecieveAll()
  if self.canRecieveVOs and #self.canRecieveVOs > 0 then
    SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestReward, "all")
  end
end

return UIDoomsdayAchievePage
