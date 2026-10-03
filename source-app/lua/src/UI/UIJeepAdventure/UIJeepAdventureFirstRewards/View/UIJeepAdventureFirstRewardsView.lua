local UIJeepAdventureFirstRewardsView = BaseClass("UIJeepAdventureFirstRewardsView", UIBaseView)
local UIJeepAdventureFirstRewardItem = require("UI.UIJeepAdventure.UIJeepAdventureFirstRewards.Component.UIJeepAdventureFirstRewardItem")
local base = UIBaseView
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
  self.btnBlackBg = self:AddComponent(UIButton, "BlackBg")
  self.btnBlackBg:SetOnClick(function()
    self:OnBtnBlackBgClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Bg/Top/TitleText")
  self.btnClose = self:AddComponent(UIButton, "Bg/Top/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "Bg/InnerBg/ScrollView")
  self.btnAll = self:AddComponent(UIButton, "Bg/AllBtn")
  self.btnAll:SetOnClick(function()
    self:OnBtnAllClick()
  end)
  self.textAllBtn = self:AddComponent(UITextMeshProUGUIEx, "Bg/AllBtn/AllBtnText")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textTitle:SetLocalText("armed_truck_reward_title")
  self.textAllBtn:SetLocalText("armed_truck_reward_get_all_btn")
end

local function ComponentDestroy(self)
  self.btnBlackBg = nil
  self.textTitle = nil
  self.btnClose = nil
  self.scrollView = nil
  self.btnAll = nil
  self.textAllBtn = nil
end

local function DataDefine(self)
  self.pageType = self:GetUserData()
  self:Refresh()
end

local function DataDestroy(self)
  self.pageType = nil
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReveiveDominatorUpFirstReward, self.OnReveiveDominatorUpFirstReward)
  self:AddUIListener(EventId.ReveiveTowerUpFirstReward, self.OnReveiveTowerUpFirstReward)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReveiveDominatorUpFirstReward, self.OnReveiveDominatorUpFirstReward)
  self:RemoveUIListener(EventId.ReveiveTowerUpFirstReward, self.OnReveiveTowerUpFirstReward)
  base.OnRemoveListener(self)
end

local function OnBtnBlackBgClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnAllClick(self)
  self.ctrl:SendGetFirstReward(self.pageType, -1)
end

local function Refresh(self)
  self.showDatalist = {}
  local stageList = DataCenter.LWJeepAdventureManager:GetFirstRewardStageByType(self.pageType)
  local showAllBtn = false
  for i, v in ipairs(stageList) do
    local data = {}
    data.rewardType = DataCenter.LWJeepAdventureManager:GetStageFirstRewardType(v, self.pageType)
    if data.rewardType == JeepStageFirstRewardType.CanClaim then
      showAllBtn = true
    end
    data.template = DataCenter.LWJeepAdventureManager:GetStageMetaByType(v, self.pageType)
    if data.template then
      table.insert(self.showDatalist, data)
    end
  end
  table.sort(self.showDatalist, function(a, b)
    if a.rewardType ~= b.rewardType then
      return a.rewardType < b.rewardType
    else
      return a.template.id < b.template.id
    end
  end)
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
  self.btnAll:SetActive(showAllBtn)
end

local function OnReveiveDominatorUpFirstReward(self)
  if self.pageType == JeepAdventurePageType.Domintor then
    self:Refresh()
  end
end

local function OnReveiveTowerUpFirstReward(self)
  if self.pageType == JeepAdventurePageType.TowerUp then
    self:Refresh()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIJeepAdventureFirstRewardItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIJeepAdventureFirstRewardItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

UIJeepAdventureFirstRewardsView.OnCreate = OnCreate
UIJeepAdventureFirstRewardsView.OnDestroy = OnDestroy
UIJeepAdventureFirstRewardsView.OnEnable = OnEnable
UIJeepAdventureFirstRewardsView.OnDisable = OnDisable
UIJeepAdventureFirstRewardsView.ComponentDefine = ComponentDefine
UIJeepAdventureFirstRewardsView.ComponentDestroy = ComponentDestroy
UIJeepAdventureFirstRewardsView.DataDefine = DataDefine
UIJeepAdventureFirstRewardsView.DataDestroy = DataDestroy
UIJeepAdventureFirstRewardsView.OnAddListener = OnAddListener
UIJeepAdventureFirstRewardsView.OnRemoveListener = OnRemoveListener
UIJeepAdventureFirstRewardsView.OnBtnBlackBgClick = OnBtnBlackBgClick
UIJeepAdventureFirstRewardsView.OnBtnCloseClick = OnBtnCloseClick
UIJeepAdventureFirstRewardsView.OnBtnAllClick = OnBtnAllClick
UIJeepAdventureFirstRewardsView.Refresh = Refresh
UIJeepAdventureFirstRewardsView.Refresh = Refresh
UIJeepAdventureFirstRewardsView.OnReveiveDominatorUpFirstReward = OnReveiveDominatorUpFirstReward
UIJeepAdventureFirstRewardsView.OnReveiveTowerUpFirstReward = OnReveiveTowerUpFirstReward
UIJeepAdventureFirstRewardsView.OnItemMoveIn = OnItemMoveIn
UIJeepAdventureFirstRewardsView.OnItemMoveOut = OnItemMoveOut
UIJeepAdventureFirstRewardsView.ClearScroll = ClearScroll
return UIJeepAdventureFirstRewardsView
