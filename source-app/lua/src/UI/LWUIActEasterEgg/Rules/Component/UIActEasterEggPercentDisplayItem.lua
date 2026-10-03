local UIActEasterEggPercentDisplayItem = BaseClass("UIActEasterEggPercentDisplayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local iconPathFormat = "Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterAmazingEgg/%s.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.imgBox = self:AddComponent(UIImage, "BoxImg")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.textProp = self:AddComponent(UITextMeshProUGUIEx, "PropText")
  self.loopListView2ScrollView = self:AddComponent(UILoopListView2, "ScrollView")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.loopListView2ScrollView:InitListView(0, function(loopScroll, index, item)
    return self:OnGetItemByIndex(loopScroll, index)
  end)
  self.itemIndex = 0
end

local function ComponentDestroy(self)
  self.data = nil
  self.rewardList = nil
  self.itemIndex = nil
  self.compContent:RemoveComponents(UICommonResItem)
  self.loopListView2ScrollView:ClearAllItems()
  self.imgBox = nil
  self.textName = nil
  self.textProp = nil
  self.loopListView2ScrollView = nil
  self.compContent = nil
end

function UIActEasterEggPercentDisplayItem:ReInit(data)
  self.data = data
  self.textName:SetLocalText(data.name)
  self.textProp:SetLocalText("activity_99144_ui_2d", string.format("%.2f%%", data.percent * 100))
  self.rewardList = DataCenter.RewardTemplateManager:GetList(data.rewardId)
  self.imgBox:LoadSprite(string.format(iconPathFormat, data.icon))
  self.loopListView2ScrollView:SetListItemCount(#self.rewardList, false, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
end

function UIActEasterEggPercentDisplayItem:OnGetItemByIndex(loopScroll, index)
  if self.rewardList ~= nil then
    local count = #self.rewardList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UICommonResItem")
    local script = self.compContent:GetComponent(item.gameObject.name, UICommonResItem)
    if script == nil then
      self.itemIndex = self.itemIndex + 1
      local name = "reward_" .. self.itemIndex
      item.gameObject.name = name
      script = self.compContent:AddComponent(UICommonResItem, name)
    end
    local data = self.rewardList[index]
    script:ReInit(data)
    return item
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIActEasterEggPercentDisplayItem.OnCreate = OnCreate
UIActEasterEggPercentDisplayItem.OnDestroy = OnDestroy
UIActEasterEggPercentDisplayItem.OnEnable = OnEnable
UIActEasterEggPercentDisplayItem.OnDisable = OnDisable
UIActEasterEggPercentDisplayItem.ComponentDefine = ComponentDefine
UIActEasterEggPercentDisplayItem.ComponentDestroy = ComponentDestroy
UIActEasterEggPercentDisplayItem.OnAddListener = OnAddListener
UIActEasterEggPercentDisplayItem.OnRemoveListener = OnRemoveListener
return UIActEasterEggPercentDisplayItem
