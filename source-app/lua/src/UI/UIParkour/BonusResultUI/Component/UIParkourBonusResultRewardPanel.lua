local UIParkourBonusResultRewardPanel = BaseClass("UIParkourBonusResultRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.scrollView = self:AddComponent(UIScrollView, "CellList")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.textTitle = nil
end

local function DataDefine(self)
  self.flyReward = {}
end

local function DataDestroy(self)
  self.isAdd = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, data, titleText)
  if data and 0 < #data then
    self.scrollView:SetActive(true)
    self.showDatalist = data
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
  if titleText then
    self.textTitle:SetActive(true)
    self.textTitle:SetText(titleText)
  else
    self.textTitle:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UICommonResItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  item:ReInit(data)
  if data.rewardType == RewardType.RESOURCE then
    local name = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(name)
  end
  self.flyReward[itemObj.transform] = data
end

local function OnItemMoveOut(self, itemObj, index)
  self.flyReward[itemObj.transform] = nil
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

local function GetFlyReward(self)
  return self.flyReward
end

UIParkourBonusResultRewardPanel.OnCreate = OnCreate
UIParkourBonusResultRewardPanel.OnDestroy = OnDestroy
UIParkourBonusResultRewardPanel.OnEnable = OnEnable
UIParkourBonusResultRewardPanel.OnDisable = OnDisable
UIParkourBonusResultRewardPanel.ComponentDefine = ComponentDefine
UIParkourBonusResultRewardPanel.ComponentDestroy = ComponentDestroy
UIParkourBonusResultRewardPanel.DataDefine = DataDefine
UIParkourBonusResultRewardPanel.DataDestroy = DataDestroy
UIParkourBonusResultRewardPanel.OnAddListener = OnAddListener
UIParkourBonusResultRewardPanel.OnRemoveListener = OnRemoveListener
UIParkourBonusResultRewardPanel.OnItemMoveIn = OnItemMoveIn
UIParkourBonusResultRewardPanel.OnItemMoveOut = OnItemMoveOut
UIParkourBonusResultRewardPanel.ClearScroll = ClearScroll
UIParkourBonusResultRewardPanel.Refresh = Refresh
UIParkourBonusResultRewardPanel.GetFlyReward = GetFlyReward
return UIParkourBonusResultRewardPanel
