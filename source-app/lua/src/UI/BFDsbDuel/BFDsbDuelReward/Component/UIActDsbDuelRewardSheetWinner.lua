local base = UIAsyncContainer
local UIActDsbDuelRewardSheetWinner = BaseClass("UIActDsbDuelRewardSheetWinner", base)
local Localization = CS.GameEntry.Localization
local UIActDsbDuelRewardSheetWinnerItem = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetWinnerItem")

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
  local showCurrentAB, showCurrentA = self:GetCurrentABState()
  self:OnToggleClicked(showCurrentA and EpidemicTeamRewardType.A or EpidemicTeamRewardType.AB)
end

function UIActDsbDuelRewardSheetWinner:GetCurrentABState()
  local groupAState = BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.A)
  local groupBState = BattlefieldDsbDuelUtils.ActInfo:GetTeamState(BattlefieldDsbConst.TeamType.B)
  local showCurrentA = (groupAState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess or groupAState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.Bye) and (groupBState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp or groupBState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.NotSignUp)
  local showCurrentAB = (groupAState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess or groupAState == BattlefieldDsbConst.BF_DSB_TEAM_STATE.Bye) and groupBState ~= BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp and groupBState ~= BattlefieldDsbConst.BF_DSB_TEAM_STATE.NotSignUp
  return showCurrentAB, showCurrentA
end

function UIActDsbDuelRewardSheetWinner:OnToggleClicked(index)
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

function UIActDsbDuelRewardSheetWinner:RefreshRewardList()
  self.rankList = self:GetRewardList()
  if #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
end

function UIActDsbDuelRewardSheetWinner:GetRewardList()
  return BattlefieldDsbDuelUtils.ActInfo:GetWinnerRewardIdByTeamType(self.currentIndex) or {}
end

function UIActDsbDuelRewardSheetWinner:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIActDsbDuelRewardSheetWinnerItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UIActDsbDuelRewardSheetWinner:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIActDsbDuelRewardSheetWinnerItem)
end

function UIActDsbDuelRewardSheetWinner:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIActDsbDuelRewardSheetWinnerItem)
end

function UIActDsbDuelRewardSheetWinner:OnBtnTeamABClick(index)
  self:OnToggleClicked(EpidemicTeamRewardType.AB)
end

function UIActDsbDuelRewardSheetWinner:OnBtnTeamAClick(index)
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

function UIActDsbDuelRewardSheetWinner:RefreshSheet(role)
  self:RefreshRewardList()
end

function UIActDsbDuelRewardSheetWinner:RefreshCurrentRole(role)
  self:RefreshRewardList()
end

function UIActDsbDuelRewardSheetWinner:UpdateCurrentRole(role)
end

function UIActDsbDuelRewardSheetWinner:OnBtnTipsClick()
  local strTip = Localization:GetString("Desert_strom_interface_1003")
  UIUtil.ShowBubbleTips(strTip, self.btnTips.transform.position, 0, -30, 0, nil, nil)
end

UIActDsbDuelRewardSheetWinner.OnCreate = OnCreate
UIActDsbDuelRewardSheetWinner.OnDestroy = OnDestroy
UIActDsbDuelRewardSheetWinner.OnEnable = OnEnable
UIActDsbDuelRewardSheetWinner.OnDisable = OnDisable
UIActDsbDuelRewardSheetWinner.ComponentDefine = ComponentDefine
UIActDsbDuelRewardSheetWinner.ComponentDestroy = ComponentDestroy
UIActDsbDuelRewardSheetWinner.DataDefine = DataDefine
UIActDsbDuelRewardSheetWinner.DataDestroy = DataDestroy
UIActDsbDuelRewardSheetWinner.OnAddListener = OnAddListener
UIActDsbDuelRewardSheetWinner.OnRemoveListener = OnRemoveListener
return UIActDsbDuelRewardSheetWinner
