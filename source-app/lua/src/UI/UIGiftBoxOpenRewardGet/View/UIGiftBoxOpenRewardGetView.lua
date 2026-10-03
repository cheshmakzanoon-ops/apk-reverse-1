local UIGiftPackageRewardGetView = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView")
local UIGiftBoxOpenRewardGetView = BaseClass("UIGiftBoxOpenRewardGetView", UIGiftPackageRewardGetView)
local UIGiftBoxOpenRewardGetItem = require("UI.UIGiftBoxOpenRewardGet.Component.UIGiftBoxOpenRewardGetItem")
local base = UIGiftPackageRewardGetView

local function ClearScroll(self)
  self.cells = {}
  if self.param and self.param.isUpChange then
    if self.scroll_view_change then
      self.scroll_view_change:ClearCells()
      self.scroll_view_change:RemoveComponents(UIGiftBoxOpenRewardGetItem)
    end
  elseif self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIGiftBoxOpenRewardGetItem)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  if self.param.isUpChange then
    cellItem = self.scroll_view_change:AddComponent(UIGiftBoxOpenRewardGetItem, itemObj)
  else
    cellItem = self.scroll_view:AddComponent(UIGiftBoxOpenRewardGetItem, itemObj)
  end
  local rewardParam = self.param.rewardList[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  cellItem:ReInit(param, self.param.crit == 1)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

local function OnDeleteCell(self, itemObj, index)
  if self.param.isUpChange then
    self.scroll_view_change:RemoveComponent(itemObj.name, UIGiftBoxOpenRewardGetItem)
  else
    self.scroll_view:RemoveComponent(itemObj.name, UIGiftBoxOpenRewardGetItem)
  end
end

local function SetNameText(self, value)
  if self.nameText ~= value then
    self.nameText = value
    self.title_name:SetText(value)
    if self.param.crit == 1 then
      self.title_name:SetLocalText(2800083)
    end
  end
end

UIGiftBoxOpenRewardGetView.ClearScroll = ClearScroll
UIGiftBoxOpenRewardGetView.OnCreateCell = OnCreateCell
UIGiftBoxOpenRewardGetView.OnDeleteCell = OnDeleteCell
UIGiftBoxOpenRewardGetView.SetNameText = SetNameText
return UIGiftBoxOpenRewardGetView
