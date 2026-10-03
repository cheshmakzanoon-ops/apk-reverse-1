local base = UIAsyncContainer
local UIActDsbDuelRewardSheetPersonalPt = BaseClass("UIActDsbDuelRewardSheetPersonalPt", base)
local Localization = CS.GameEntry.Localization
local UIActDsbDuelRewardSheetPersonalRewardItem = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetPersonalRewardItem")
local UIActDsbDuelRewardSheetPersonalPtSelect = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetPersonalPtSelect")

local function OnCreate(self, view)
  base.OnCreate(self)
  self.view = view
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScrollRewards()
  self.rewardList = nil
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
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSelect = self.viewSkin:AddComponent(self, UIActDsbDuelRewardSheetPersonalPtSelect, 1)
  self.scrollViewRewardsRect = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compTitleBg = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textTmpMyScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.scrollViewRewardsRect:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveInRewards(itemObj, index)
  end)
  self.scrollViewRewardsRect:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOutRewards(itemObj, index)
  end)
  self.curShowRankIndex = BattlefieldDsbDuelUtils.GetMyAllianceRankInBattle() == 0 and 1 or BattlefieldDsbDuelUtils.GetMyAllianceRankInBattle()
  self.compSelect:SetData(self.curShowRankIndex)
  self:InitSheet()
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.compSelect = nil
  self.scrollViewRewardsRect = nil
  self.compTitleBg = nil
  self.textTmpMyScore = nil
  self.btnInfo = nil
end

function UIActDsbDuelRewardSheetPersonalPt:InitSheet()
  UIUtil.SetTextLit(self.compTitleBg.transform, "Label0", "YiBianJinQu_battle_detail_tips_1")
  UIUtil.SetTextLit(self.compTitleBg.transform, "Label1", "YiBianJinQu_reward_tips_1")
  self:RefreshRewardList()
end

local function DataDefine(self)
  local myTeam = BattlefieldDsbDuelUtils.GetMyTeam()
  if myTeam == BattlefieldDsbConst.TeamType.None then
    return
  end
  if DataCenter.BattlefieldDsbDuelManager:CanShowEnter() then
    SFSNetwork.SendMessage(MsgDefines.DsbBattlePlayerInfo, myTeam)
  end
end

local function DataDestroy(self)
  self.curShowRankIndex = nil
  self.myScore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelBattleMyInfoChanged, self.OnDsbDuelMyInfoChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DsbDuelBattleMyInfoChanged, self.OnDsbDuelMyInfoChanged)
  base.OnRemoveListener(self)
end

function UIActDsbDuelRewardSheetPersonalPt:OnDsbDuelMyInfoChanged()
  self:RefreshRewardList()
end

function UIActDsbDuelRewardSheetPersonalPt:RefreshMyInfo()
  self.myScore = BattlefieldDsbDuelUtils.GetMyPointsInBattle()
  self.textTmpMyScore:SetLocalText("100350", string.GetFormattedSeparatorNum(self.myScore))
end

function UIActDsbDuelRewardSheetPersonalPt:RefreshRewardList()
  self:RefreshMyInfo()
  self.rewardList = BattlefieldDsbDuelUtils.ActInfo:GetScoreRewards(self.compSelect.group)
  self.myRewardIndex = 0
  if #self.rewardList > 0 then
    if 0 < self.myScore then
      for k, v in ipairs(self.rewardList) do
        local score = v[1] or 0
        if score <= self.myScore then
          self.myRewardIndex = k
        end
      end
    end
    self.scrollViewRewardsRect:SetTotalCount(#self.rewardList)
    self.scrollViewRewardsRect:RefillCells()
  end
end

function UIActDsbDuelRewardSheetPersonalPt:OnItemMoveInRewards(itemObj, index)
  itemObj.name = tostring(index)
  local reward = self.rewardList[index]
  local cellItem = self.scrollViewRewardsRect:AddComponent(UIActDsbDuelRewardSheetPersonalRewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, {
      score = reward[1] or 0,
      rewardId = reward[2] or 0,
      my = self.myRewardIndex == index
    })
  end
end

function UIActDsbDuelRewardSheetPersonalPt:OnItemMoveOutRewards(itemObj, index)
  self.scrollViewRewardsRect:RemoveComponent(itemObj.name, UIActDsbDuelRewardSheetPersonalRewardItem)
end

function UIActDsbDuelRewardSheetPersonalPt:ClearScrollRewards()
  if self.scrollViewRewardsRect then
    self.scrollViewRewardsRect:ClearCells()
    self.scrollViewRewardsRect:RemoveComponents(UIActDsbDuelRewardSheetPersonalRewardItem)
  end
end

function UIActDsbDuelRewardSheetPersonalPt:RefreshSheet()
end

function UIActDsbDuelRewardSheetPersonalPt:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActBattleSkillPoint)
end

UIActDsbDuelRewardSheetPersonalPt.OnCreate = OnCreate
UIActDsbDuelRewardSheetPersonalPt.OnDestroy = OnDestroy
UIActDsbDuelRewardSheetPersonalPt.OnEnable = OnEnable
UIActDsbDuelRewardSheetPersonalPt.OnDisable = OnDisable
UIActDsbDuelRewardSheetPersonalPt.ComponentDefine = ComponentDefine
UIActDsbDuelRewardSheetPersonalPt.ComponentDestroy = ComponentDestroy
UIActDsbDuelRewardSheetPersonalPt.DataDefine = DataDefine
UIActDsbDuelRewardSheetPersonalPt.DataDestroy = DataDestroy
UIActDsbDuelRewardSheetPersonalPt.OnAddListener = OnAddListener
UIActDsbDuelRewardSheetPersonalPt.OnRemoveListener = OnRemoveListener
return UIActDsbDuelRewardSheetPersonalPt
