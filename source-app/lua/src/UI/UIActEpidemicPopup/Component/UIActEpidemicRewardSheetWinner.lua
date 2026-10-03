local base = UIAsyncContainer
local UIActEpidemicRewardSheetWinner = BaseClass("UIActEpidemicRewardSheetWinner", base)
local Localization = CS.GameEntry.Localization
local UIActEpidemicRewardSheetWinnerItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetWinnerItem")

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
  self.btnTeamAB = self:AddComponent(UIButton, "TopRect/BtnTeamAB")
  self.btnTeamAB:SetOnClick(function()
    self:OnBtnTeamABClick()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, "RewardRect")
  self.compContent = self:AddComponent(UIBaseContainer, "RewardRect/Viewport/Content")
  self.btnTeamA = self:AddComponent(UIButton, "TopRect/BtnTeamA")
  self.btnTeamA:SetOnClick(function()
    self:OnBtnTeamAClick()
  end)
  self.btnTips = self:AddComponent(UIButton, "TopRect/BtnTeamA/BtnTips")
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.nodeTeamAB_Active = self.btnTeamAB.transform:Find("ActiveNode").gameObject
  self.nodeTeamAB_Inactive = self.btnTeamAB.transform:Find("InactiveNode").gameObject
  self.nodeTeamA_Active = self.btnTeamA.transform:Find("ActiveNode").gameObject
  self.nodeTeamA_Inactive = self.btnTeamA.transform:Find("InactiveNode").gameObject
  self.nodeTeamAB_current = self.btnTeamAB.transform:Find("CurrentNode").gameObject
  self.nodeTeamA_current = self.btnTeamA.transform:Find("CurrentNode").gameObject
  UIUtil.SetTextLit(self.btnTeamAB.transform, "ActiveNode/Label", "YiBianJinQu_reward_tips_4")
  UIUtil.SetTextLit(self.btnTeamAB.transform, "InactiveNode/Label", "YiBianJinQu_reward_tips_4")
  UIUtil.SetTextLit(self.btnTeamA.transform, "ActiveNode/Label", "YiBianJinQu_reward_tips_5")
  UIUtil.SetTextLit(self.btnTeamA.transform, "InactiveNode/Label", "YiBianJinQu_reward_tips_5")
  UIUtil.SetTextLit(self.btnTeamAB.transform, "CurrentNode/Label", "YiBianJinQu_reward_tips_3")
  UIUtil.SetTextLit(self.btnTeamA.transform, "CurrentNode/Label", "YiBianJinQu_reward_tips_3")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.currentIndex = nil
  self.currentRole = self:GetDefaultRole()
  local showCurrentAB, showCurrentA = self:GetCurrentABState()
  self:OnToggleClicked(showCurrentA and EpidemicTeamRewardType.A or EpidemicTeamRewardType.AB)
end

function UIActEpidemicRewardSheetWinner:GetDefaultRole()
  local role = ActEpidemicUtils.GetMyRole()
  if role == EpidemicZoneRole.Default then
    return EpidemicZoneRole.Lord
  end
  return role
end

function UIActEpidemicRewardSheetWinner:GetCurrentABState()
  local groupAState = ActEpidemicUtils.GetTeamAState()
  local groupBState = ActEpidemicUtils.GetTeamBState()
  local showCurrentA = groupAState == EpidemicZoneSignState.StateMatchSuc and groupBState == EpidemicZoneSignState.StateBan
  local showCurrentAB = (groupAState == EpidemicZoneSignState.StateMatchSuc or groupBState == EpidemicZoneSignState.StateMatchSuc) and groupBState ~= EpidemicZoneSignState.StateBan
  return showCurrentAB, showCurrentA
end

function UIActEpidemicRewardSheetWinner:OnToggleClicked(index)
  if self.currentIndex == index then
    return
  end
  self.currentIndex = index
  self.nodeTeamAB_Active:SetActive(self.currentIndex == EpidemicTeamRewardType.AB)
  self.nodeTeamAB_Inactive:SetActive(self.currentIndex ~= EpidemicTeamRewardType.AB)
  self.nodeTeamA_Active:SetActive(self.currentIndex == EpidemicTeamRewardType.A)
  self.nodeTeamA_Inactive:SetActive(self.currentIndex ~= EpidemicTeamRewardType.A)
  local showCurrentAB, showCurrentA = self:GetCurrentABState()
  self.nodeTeamAB_current:SetActive(showCurrentAB)
  self.nodeTeamA_current:SetActive(showCurrentA)
  self:RefreshRewardList()
end

function UIActEpidemicRewardSheetWinner:RefreshRewardList()
  self.rankList = self:GetRewardList()
  if #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
end

function UIActEpidemicRewardSheetWinner:GetRewardList()
  return ActEpidemicUtils.GetWinnerRewardIdByTeamTypeAndRoleType(self.currentIndex, self.currentRole) or {}
end

function UIActEpidemicRewardSheetWinner:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIActEpidemicRewardSheetWinnerItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UIActEpidemicRewardSheetWinner:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIActEpidemicRewardSheetWinnerItem)
end

function UIActEpidemicRewardSheetWinner:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIActEpidemicRewardSheetWinnerItem)
end

function UIActEpidemicRewardSheetWinner:OnBtnTeamABClick(index)
  self:OnToggleClicked(EpidemicTeamRewardType.AB)
end

function UIActEpidemicRewardSheetWinner:OnBtnTeamAClick(index)
  self:OnToggleClicked(EpidemicTeamRewardType.A)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnTeamAB = nil
  self.ScrollView = nil
  self.compContent = nil
  self.btnTeamA = nil
  self.btnTips = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEpidemicRewardSheetWinner:RefreshSheet(role)
  self.currentRole = role
  self:RefreshRewardList()
end

function UIActEpidemicRewardSheetWinner:RefreshCurrentRole(role)
  self.currentRole = role
  self:RefreshRewardList()
end

function UIActEpidemicRewardSheetWinner:UpdateCurrentRole(role)
  self.currentRole = role
end

function UIActEpidemicRewardSheetWinner:OnBtnTipsClick()
  local strTip = Localization:GetString("Desert_strom_interface_1003")
  UIUtil.ShowBubbleTips(strTip, self.btnTips.transform.position, 0, -30, 0, nil, nil)
end

UIActEpidemicRewardSheetWinner.OnCreate = OnCreate
UIActEpidemicRewardSheetWinner.OnDestroy = OnDestroy
UIActEpidemicRewardSheetWinner.OnEnable = OnEnable
UIActEpidemicRewardSheetWinner.OnDisable = OnDisable
UIActEpidemicRewardSheetWinner.ComponentDefine = ComponentDefine
UIActEpidemicRewardSheetWinner.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardSheetWinner.DataDefine = DataDefine
UIActEpidemicRewardSheetWinner.DataDestroy = DataDestroy
UIActEpidemicRewardSheetWinner.OnAddListener = OnAddListener
UIActEpidemicRewardSheetWinner.OnRemoveListener = OnRemoveListener
return UIActEpidemicRewardSheetWinner
