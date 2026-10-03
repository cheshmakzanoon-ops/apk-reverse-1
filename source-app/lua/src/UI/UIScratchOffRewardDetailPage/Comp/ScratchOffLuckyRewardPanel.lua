local ScratchOffLuckyRewardPanel = BaseClass("ScratchOffLuckyRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local ScratchOffLucyRewardItem = require("UI.UIScratchOffRewardDetailPage.Comp.ScratchOffLucyRewardItem")
local scroll_path = "ScrollView"

function ScratchOffLuckyRewardPanel:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffLuckyRewardPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffLuckyRewardPanel:DataDefine()
  self.activityId = -1
  self.itemInfoList = {}
end

function ScratchOffLuckyRewardPanel:DataDestroy()
  self.activityId = nil
  self.itemInfoList = nil
end

function ScratchOffLuckyRewardPanel:ComponentDefine()
  self.scrollView = self:AddComponent(UIScrollView, scroll_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function ScratchOffLuckyRewardPanel:ComponentDestroy()
  self:ClearScroll()
end

function ScratchOffLuckyRewardPanel:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(ScratchOffLucyRewardItem, itemObj)
  cellItem:SetData(self.itemInfoList[index])
end

function ScratchOffLuckyRewardPanel:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, ScratchOffLucyRewardItem)
end

function ScratchOffLuckyRewardPanel:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(ScratchOffLucyRewardItem)
end

function ScratchOffLuckyRewardPanel:RefreshPanel(activityId)
  if self.activityId == activityId then
    self.scrollView:ScrollToCell(1)
  else
    self.activityId = activityId
    self:GetItemInfoList(activityId)
    if self.itemInfoList == nil or #self.itemInfoList == 0 then
      return
    end
    if #self.itemInfoList > 0 then
      self.scrollView:SetTotalCount(#self.itemInfoList)
      self.scrollView:RefillCells()
      self.scrollView:ScrollToCell(1)
    end
  end
end

function ScratchOffLuckyRewardPanel:GetItemInfoList(activityId)
  local list = DataCenter.ScratchOffGameManager:GetLuckyRewardItemInfoListByActId(activityId)
  if list and 0 < #list then
    self.itemInfoList = {}
    for i = 1, #list do
      local value = list[i]
      local level = value.level
      if not (level <= 0) then
        local itemInfo = self.itemInfoList[level]
        if itemInfo == nil then
          itemInfo = {}
          itemInfo.levelTxtNum = value.levelTxtNum
          itemInfo.level = value.level
          itemInfo.luckyIconList = {}
          self.itemInfoList[level] = itemInfo
        end
        local luckyIconItemInfo = {}
        luckyIconItemInfo.diamondProportion = value.diamondProportion
        luckyIconItemInfo.icon = value.iconPath
        table.insert(itemInfo.luckyIconList, luckyIconItemInfo)
      end
    end
  end
end

return ScratchOffLuckyRewardPanel
