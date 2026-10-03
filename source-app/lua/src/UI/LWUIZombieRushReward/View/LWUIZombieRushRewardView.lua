local base = UIBaseView
local LWUIZombieRushRewardView = BaseClass("LWUIZombieRushRewardView", base)
local LWUIZombieRushTabItemRender = require("UI.LWUIZombieRushReward.Component.LWUIZombieRushTabItemRender")
local LWUIZombieRushRewardItemRender = require("UI.LWUIZombieRushReward.Component.LWUIZombieRushRewardItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tabItem_path = "PopUpContent/Content/LWUIZombieRushTabItemRender"
local tabContent_path = "PopUpContent/Content/TabListView/Viewport/TabContent"
local tipsText1_path = "PopUpContent/Content/TipsText1"
local tipsText2_path = "PopUpContent/Content/TipsText2"
local rewardLoopView_path = "PopUpContent/Content/RewardScrollView"
local rewardLoopViewContent_path = "PopUpContent/Content/RewardScrollView/Viewport/RewardScrollViewContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.selectZombieRushId = self:GetUserData()
  DataCenter.LWZombieRushManager:SendMsgZombieRushRewardInfo(self.selectZombieRushId)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

local function OnDestroy(self)
  self:ClearTabItem()
  self:ClearRewardLoopView()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.tabItem = self:AddComponent(UIBaseContainer, tabItem_path)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.tipsText1 = self:AddComponent(UITextMeshProUGUIEx, tipsText1_path)
  self.tipsText2 = self:AddComponent(UITextMeshProUGUIEx, tipsText2_path)
  self.rewardLoopView = self:AddComponent(UILoopListView2, rewardLoopView_path)
  self.rewardLoopViewContent = self:AddComponent(UIBaseContainer, rewardLoopViewContent_path)
  self.rewardLoopView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText:SetLocalText(2010309)
  self.tipsText2:SetLocalText(130065)
  self.tabObj = self.transform:Find(tabItem_path).gameObject
  self.tabObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tabItem = nil
  self.tabContent = nil
  self.tipsText1 = nil
  self.tipsText2 = nil
  self.rewardLoopView = nil
  self.rewardLoopViewContent = nil
  self.tabObj = nil
end

local function DataDefine(self)
  self.curTabType = ZombieRushRewardTabType.Alliance
  self.tabItemList = {}
  self.showReward = nil
  self.showRewardTargetValue = nil
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.curTabType = nil
  self.tabItemList = nil
  self.showReward = nil
  self.showRewardTargetValue = nil
  self.itemIndex = nil
  self.rewardInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZombieRushRewardInfoData, self.OnGetZombieRushRewardInfoData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZombieRushRewardInfoData, self.OnGetZombieRushRewardInfoData)
  base.OnRemoveListener(self)
end

local function OnGetZombieRushRewardInfoData(self)
  self.rewardInfo = DataCenter.LWZombieRushManager:GetRewardInfoByTemplateId(self.selectZombieRushId)
  self:ShowReward()
end

local function Init(self)
  self.rewardInfo = DataCenter.LWZombieRushManager:GetRewardInfoByTemplateId(self.selectZombieRushId)
  self:CreateTabItem()
  self:ShowReward()
end

local function CreateTabItem(self)
  self:ClearTabItem()
  for i = 1, 2 do
    local goObj = self.tabObj:GameObjectSpawn(self.tabContent.transform)
    goObj.name = "TabItem" .. i
    goObj:SetActive(true)
    local item = self.tabContent:AddComponent(LWUIZombieRushTabItemRender, goObj.name)
    local isSelected = i == self.curTabType
    item:ReInit(i, isSelected, function(tabType)
      self:OnClickTabItem(tabType)
    end)
    table.insert(self.tabItemList, item)
  end
end

local function OnClickTabItem(self, tabType)
  self.curTabType = tabType
  for i = 1, table.count(self.tabItemList) do
    local isSelected = i == self.curTabType
    self.tabItemList[i]:SetSelect(isSelected)
  end
  self:ShowReward()
end

local function ClearTabItem(self)
  self.tabContent:RemoveComponents(LWUIZombieRushTabItemRender)
  self.tabObj:GameObjectRecycleAll()
end

local function ShowReward(self)
  if self.rewardInfo == nil then
    return
  end
  if self.curTabType == ZombieRushRewardTabType.Alliance then
    self.tipsText1:SetLocalText("zombieRush_title_06")
    self.showReward = self.rewardInfo.allianceRewardInfoList
  else
    self.tipsText1:SetLocalText("zombieRush_title_05")
    self.showReward = self.rewardInfo.personalRewardInfoList
  end
  if self.showReward then
    local count = table.count(self.showReward)
    if 0 < count then
      self.rewardLoopView:SetListItemCount(count, false, false)
      self.rewardLoopView:RefreshAllShownItem()
    end
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  local count = table.count(self.showReward)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWUIZombieRushRewardItemRender")
  local script = self.rewardLoopViewContent:GetComponent(item.gameObject.name, LWUIZombieRushRewardItemRender)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rewardLoopViewContent:AddComponent(LWUIZombieRushRewardItemRender, objectName)
  end
  script:SetActive(true)
  local rewardList = self.showReward[index].rewardList
  local targetValue = self.showReward[index].min
  script:SetData(rewardList, targetValue)
  return item
end

local function ClearRewardLoopView(self)
  self.rewardLoopViewContent:RemoveComponents(LWUIZombieRushRewardItemRender)
  self.rewardLoopView:ClearAllItems()
end

LWUIZombieRushRewardView.OnCreate = OnCreate
LWUIZombieRushRewardView.OnDestroy = OnDestroy
LWUIZombieRushRewardView.OnEnable = OnEnable
LWUIZombieRushRewardView.OnDisable = OnDisable
LWUIZombieRushRewardView.ComponentDefine = ComponentDefine
LWUIZombieRushRewardView.ComponentDestroy = ComponentDestroy
LWUIZombieRushRewardView.DataDefine = DataDefine
LWUIZombieRushRewardView.DataDestroy = DataDestroy
LWUIZombieRushRewardView.Init = Init
LWUIZombieRushRewardView.CreateTabItem = CreateTabItem
LWUIZombieRushRewardView.OnClickTabItem = OnClickTabItem
LWUIZombieRushRewardView.ClearTabItem = ClearTabItem
LWUIZombieRushRewardView.OnGetItemByIndex = OnGetItemByIndex
LWUIZombieRushRewardView.ClearRewardLoopView = ClearRewardLoopView
LWUIZombieRushRewardView.ShowReward = ShowReward
LWUIZombieRushRewardView.OnAddListener = OnAddListener
LWUIZombieRushRewardView.OnRemoveListener = OnRemoveListener
LWUIZombieRushRewardView.OnGetZombieRushRewardInfoData = OnGetZombieRushRewardInfoData
return LWUIZombieRushRewardView
