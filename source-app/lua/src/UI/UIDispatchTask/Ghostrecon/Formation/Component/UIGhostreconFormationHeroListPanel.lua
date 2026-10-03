local base = UIBaseContainer
local UIGhostreconFormationHeroListPanel = BaseClass("UIGhostreconFormationHeroListPanel", base)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local titleText_path = "TitleText"
local scrollView_path = "Bg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.titleText:SetLocalText("ghostrecon_029")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.scrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.heroList = nil
  self.clickFunc = nil
end

local function OnItemMoveIn(self, itemObj, index)
  local uuid = self.heroList[index].uuid
  itemObj.name = uuid
  local cellItem = self.scrollView:AddComponent(UIHeroCellSmall, itemObj)
  cellItem:SetData(uuid, self.clickFunc)
  cellItem.img_job:SetActive(false)
  cellItem:SetActive(true)
  cellItem:SetSelected(self.view:HasSelectUuid(uuid))
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIHeroCellSmall)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIHeroCellSmall)
end

local function SetData(self, heroList, clickFunc)
  self.heroList = heroList
  self.clickFunc = clickFunc
  self:ClearScroll()
  local count = table.count(self.heroList)
  if 0 < count then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
end

local function GetCellByHeroUUid(self, heroUuid)
  return self.scrollView:GetComponent(tostring(heroUuid), UIHeroCellSmall)
end

UIGhostreconFormationHeroListPanel.OnCreate = OnCreate
UIGhostreconFormationHeroListPanel.OnDestroy = OnDestroy
UIGhostreconFormationHeroListPanel.OnEnable = OnEnable
UIGhostreconFormationHeroListPanel.OnDisable = OnDisable
UIGhostreconFormationHeroListPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationHeroListPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationHeroListPanel.DataDefine = DataDefine
UIGhostreconFormationHeroListPanel.DataDestroy = DataDestroy
UIGhostreconFormationHeroListPanel.SetData = SetData
UIGhostreconFormationHeroListPanel.OnItemMoveIn = OnItemMoveIn
UIGhostreconFormationHeroListPanel.OnItemMoveOut = OnItemMoveOut
UIGhostreconFormationHeroListPanel.ClearScroll = ClearScroll
UIGhostreconFormationHeroListPanel.GetCellByHeroUUid = GetCellByHeroUUid
return UIGhostreconFormationHeroListPanel
