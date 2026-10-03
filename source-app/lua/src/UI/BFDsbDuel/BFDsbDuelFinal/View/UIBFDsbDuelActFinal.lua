local UIBFDsbDuelActFinal = BaseClass("UIBFDsbDuelActFinal", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActFinalToggle = require("UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalToggle")
local UIBFDsbDuelActFinalGroup = require("UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalGroup")
local UIBFDsbDuelActFinalTopThree = require("UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalTopThree")

function UIBFDsbDuelActFinal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActFinal:OnDestroy()
  self:ClearTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinal:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compToggleAll = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalToggle, 3)
  self.compToggleG1 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalToggle, 4)
  self.compToggleG2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalToggle, 5)
  self.compToggleG3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalToggle, 6)
  self.compToggleG4 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalToggle, 7)
  self.compContentContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.compRedAward = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compUIBFDsbDuelActFinalTopThree = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalTopThree, 12)
  self.compUIBFDsbDuelActFinalGroup4To6 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalGroup, 13)
  self.compUIBFDsbDuelActFinalGroup7To10 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalGroup, 14)
  self.compUIBFDsbDuelActFinalGroup11To20 = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalGroup, 15)
  self.compViewPort = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.group = {}
  table.insert(self.group, self.compUIBFDsbDuelActFinalGroup4To6)
  table.insert(self.group, self.compUIBFDsbDuelActFinalGroup7To10)
  table.insert(self.group, self.compUIBFDsbDuelActFinalGroup11To20)
  self.compToggleAll.toggleUIBFDsbDuelActFinal:SetIsOn(false)
  self.compToggleG1.toggleUIBFDsbDuelActFinal:SetIsOn(false)
  self.compToggleG2.toggleUIBFDsbDuelActFinal:SetIsOn(false)
  self.compToggleG3.toggleUIBFDsbDuelActFinal:SetIsOn(false)
  self.compToggleG4.toggleUIBFDsbDuelActFinal:SetIsOn(false)
  self.textTitle:SetLocalText("dsb_duel_activitiy_name_1001")
end

function UIBFDsbDuelActFinal:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.compToggleAll = nil
  self.compToggleG1 = nil
  self.compToggleG2 = nil
  self.compToggleG3 = nil
  self.compToggleG4 = nil
  self.compContentContainer = nil
  self.btnBack = nil
  self.btnReward = nil
  self.compRedAward = nil
  self.compUIBFDsbDuelActFinalTopThree = nil
  self.compUIBFDsbDuelActFinalGroup4To6 = nil
  self.compUIBFDsbDuelActFinalGroup7To10 = nil
  self.compUIBFDsbDuelActFinalGroup11To20 = nil
  self.compViewPort = nil
  self.group = nil
end

function UIBFDsbDuelActFinal:DataDefine()
  self.curToggleIndex = -1
  BattlefieldDsbDuelUtils.ActInfo:SendActRewardInfoMsg()
end

function UIBFDsbDuelActFinal:DataDestroy()
  self.curToggleIndex = nil
  self.topThree = nil
end

function UIBFDsbDuelActFinal:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  self:AddUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActRewardReceived)
end

function UIBFDsbDuelActFinal:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  self:RemoveUIListener(EventId.DsbDuelActOnGetRewardList, self.OnDsbDuelActRewardReceived)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinal:OnBtnInfoClick()
end

function UIBFDsbDuelActFinal:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true}, BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward)
end

function UIBFDsbDuelActFinal:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

local function OnClickToggle(self, index)
  if self.curToggleIndex ~= index then
    self.curToggleIndex = index
    BattlefieldDsbDuelUtils.ActInfo:SendActGroupListMsg(self.curToggleIndex)
  end
end

function UIBFDsbDuelActFinal:RefreshRedDot()
  self.compRedAward:SetActive(BattlefieldDsbDuelUtils.ActInfo:GetCanReceiveRewardNum() > 0)
end

function UIBFDsbDuelActFinal:ReInit()
  self.compToggleAll:SetData({
    index = 0,
    clickCallback = function(index)
      OnClickToggle(self, index)
    end
  })
  self.compToggleG1:SetData({
    index = 1,
    clickCallback = function(index)
      OnClickToggle(self, index)
    end
  })
  self.compToggleG2:SetData({
    index = 2,
    clickCallback = function(index)
      OnClickToggle(self, index)
    end
  })
  self.compToggleG3:SetData({
    index = 3,
    clickCallback = function(index)
      OnClickToggle(self, index)
    end
  })
  self.compToggleG4:SetData({
    index = 4,
    clickCallback = function(index)
      OnClickToggle(self, index)
    end
  })
  if self.compToggleAll.toggleUIBFDsbDuelActFinal:GetIsOn() then
    BattlefieldDsbDuelUtils.ActInfo:SendActGroupListMsg(0)
  else
    self.compToggleAll.toggleUIBFDsbDuelActFinal:SetIsOn(true)
  end
  self.curToggleIndex = 0
  self:RefreshRedDot()
end

function UIBFDsbDuelActFinal:OnDsbDuelActRankInfoUpdate()
  self.data = BattlefieldDsbDuelUtils.ActInfo:GetAllianceRankList()
  self.selfRankIndex = -1
  for i = 1, #self.data do
    if self.data[i].allianceId == LuaEntry.Player.allianceId then
      self.selfRankIndex = i
      break
    end
  end
  self:RefreshPanel()
end

function UIBFDsbDuelActFinal:OnDsbDuelActRewardReceived()
  self:RefreshRedDot()
end

function UIBFDsbDuelActFinal:RefreshTop3(top3Data)
  if self.compUIBFDsbDuelActFinalTopThree then
    self.compUIBFDsbDuelActFinalTopThree:SetData(top3Data)
  end
end

function UIBFDsbDuelActFinal:RefreshGroup(groupData, index)
  if self.group[index] then
    self.group[index]:SetData(groupData)
  end
end

function UIBFDsbDuelActFinal:RefreshPanel()
  local topThreeData = {}
  for i = 1, math.min(3, #self.data) do
    table.insert(topThreeData, self.data[i])
  end
  self:RefreshTop3(topThreeData)
  local group4To6 = {}
  for i = 4, math.min(6, #self.data) do
    table.insert(group4To6, self.data[i])
  end
  self:RefreshGroup(group4To6, 1)
  local group6To10 = {}
  for i = 7, math.min(10, #self.data) do
    table.insert(group6To10, self.data[i])
  end
  self:RefreshGroup(group6To10, 2)
  local group10ToLast = {}
  for i = 11, #self.data do
    table.insert(group10ToLast, self.data[i])
  end
  self:RefreshGroup(group10ToLast, 3)
  self:ClearTimer()
  self.jumpTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:JumpSelfIndex()
  end, 0.5)
end

function UIBFDsbDuelActFinal:ClearTimer()
  if self.jumpTimer then
    self.jumpTimer:Stop()
    self.jumpTimer = nil
  end
end

local groupSpacing = 10
local groupTopBar = 60
local singleGroupItemHeight = 105
local singleGroupItemSpacing = 10
local top3Height = 872
local firstGroupHeight = groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * 3
local SecondGroupHeight = groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * 4

local function IsInViewPort(self)
  local viewportHeight = self.compViewPort.rectTransform.rect.height
  if self.selfRankIndex <= 3 then
    return true
  elseif self.selfRankIndex > 3 and self.selfRankIndex <= 6 then
    return viewportHeight > top3Height + groupSpacing + groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * (self.selfRankIndex - 3)
  elseif self.selfRankIndex > 6 and self.selfRankIndex <= 10 then
    return viewportHeight > top3Height + firstGroupHeight + groupSpacing * 2 + groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * (self.selfRankIndex - 6)
  elseif self.selfRankIndex > 10 then
    return viewportHeight > top3Height + firstGroupHeight + SecondGroupHeight + groupSpacing * 3 + groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * (self.selfRankIndex - 10)
  end
end

function UIBFDsbDuelActFinal:JumpSelfIndex()
  if not self.compContentContainer then
    return
  end
  if not IsInViewPort(self) then
    local viewportHeight = self.compViewPort.rectTransform.rect.height
    local contentHeight = self.compContentContainer.rectTransform.rect.height
    if self.selfRankIndex > 0 then
      if self.selfRankIndex > 3 and self.selfRankIndex <= 6 then
        self.compContentContainer:SetAnchoredPositionXY(0, Mathf.Max(0, Mathf.Min(contentHeight - viewportHeight, top3Height + groupSpacing)))
      elseif self.selfRankIndex > 6 and self.selfRankIndex <= 10 then
        self.compContentContainer:SetAnchoredPositionXY(0, Mathf.Max(0, Mathf.Min(contentHeight - viewportHeight, top3Height + firstGroupHeight + groupSpacing * 2)))
      elseif self.selfRankIndex > 10 then
        self.compContentContainer:SetAnchoredPositionXY(0, Mathf.Max(0, Mathf.Min(contentHeight - viewportHeight, top3Height + firstGroupHeight + SecondGroupHeight + groupSpacing * 3 + groupTopBar + (singleGroupItemHeight + singleGroupItemSpacing) * (self.selfRankIndex - 11))))
      end
      return
    end
  end
  self.compContentContainer:SetAnchoredPositionXY(0, 0)
end

return UIBFDsbDuelActFinal
