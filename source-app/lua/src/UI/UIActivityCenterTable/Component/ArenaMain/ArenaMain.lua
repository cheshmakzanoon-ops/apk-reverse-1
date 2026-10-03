local ArenaMain = BaseClass("ArenaMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ArenaRankItem = require("UI.UIActivityCenterTable.Component.ArenaMain.ArenaRankItem")
local title_path = "title"
local roundEndTime_path = "btns/rewardsBtn/roundTime"
local selfRank_path = "selfObj"
local svRank_path = "ScrollView"
local rankContent_path = "ScrollView/Viewport/Content"
local emptyTip_path = "empty"
local playerTxt_path = "playerTxt"
local rankTxt_path = "scoreTxt"
local rewardBtn_path = "btns/rewardsBtn"
local rewardBtnTxt_path = "btns/rewardsBtn/rewardsBtnTxt"
local historyBtn_path = "btns/historyBtn"
local historyBtnRed_path = "btns/historyBtn/historyRed"
local historyBtnTxt_path = "btns/historyBtn/historyBtnTxt"
local challengeBtn_path = "btns/challengeBtn"
local challengeBtnRed_path = "btns/challengeBtn/challengeRed"
local challengeRedNum_path = "btns/challengeBtn/challengeRed/challengeRedTxt"
local challengeBtnTxt_path = "btns/challengeBtn/challengeBtnTxt"
local SetTeamBtn_path = "btns/defenceBtn"
local setTeamBtnRed_path = "btns/defenceBtn/defenseRed"
local SetTeamBtnTxt_path = "btns/defenceBtn/defenceBtnTxt"
local infoBtn_path = "btns/infoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  DataCenter.ArenaManager:TryInitDefenseArmy()
end

local function OnDestroy(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(8)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(372255)
  self.roundEndTimeN = self:AddComponent(UIText, roundEndTime_path)
  self.selfRankN = self:AddComponent(ArenaRankItem, selfRank_path)
  self.svRankN = self:AddComponent(UIScrollView, svRank_path)
  self.svRankN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svRankN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.rankContentN = self:AddComponent(UIBaseContainer, rankContent_path)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(372260)
  self.playerTxtN = self:AddComponent(UIText, playerTxt_path)
  self.playerTxtN:SetLocalText(100184)
  self.rankTxtN = self:AddComponent(UIText, rankTxt_path)
  self.rankTxtN:SetLocalText(302042)
  self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnN:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.rewardBtnTxtN = self:AddComponent(UIText, rewardBtnTxt_path)
  self.rewardBtnTxtN:SetText("")
  self.historyBtnN = self:AddComponent(UIButton, historyBtn_path)
  self.historyBtnN:SetOnClick(function()
    self:OnClickHistoryBtn()
  end)
  self.historyBtnTxtN = self:AddComponent(UIText, historyBtnTxt_path)
  self.historyBtnTxtN:SetLocalText(390264)
  self.challengeBtnN = self:AddComponent(UIButton, challengeBtn_path)
  self.challengeBtnN:SetOnClick(function()
    self:OnClickChallengeBtn()
  end)
  self.challengeBtnTxtN = self:AddComponent(UIText, challengeBtnTxt_path)
  self.challengeBtnTxtN:SetLocalText(372258)
  self.setTeamBtnN = self:AddComponent(UIButton, SetTeamBtn_path)
  self.setTeamBtnN:SetOnClick(function()
    self:OnClickSetTeamBtn()
  end)
  self.setTeamBtnTxtN = self:AddComponent(UIText, SetTeamBtnTxt_path)
  self.setTeamBtnTxtN:SetLocalText(372281)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.historyRedN = self:AddComponent(UIBaseContainer, historyBtnRed_path)
  self.challengeRedN = self:AddComponent(UIBaseContainer, challengeBtnRed_path)
  self.challengeRedNumN = self:AddComponent(UIText, challengeRedNum_path)
  self.defenseRedN = self:AddComponent(UIBaseContainer, setTeamBtnRed_path)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:DelCountDownTimer()
end

local function DataDefine(self)
  self.actId = nil
  self.endTime = 0
  self.rankList = {}
  self.rankItemsDic = {}
end

local function DataDestroy(self)
  self.actId = nil
  self.endTime = nil
  self.rankList = nil
  self.rankItemsDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshRed)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshRed)
  base.OnRemoveListener(self)
end

local function SetData(self, actId)
  self.actId = actId
  SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 0)
  self:RefreshAll()
end

local function RefreshAll(self)
  self.endTime = DataCenter.ArenaManager:GetRoundEndTime()
  self:AddCountDownTimer()
  self:RefreshRemainTime()
  self:ShowRankList()
  self:RefreshRed()
  self.selfRankN:SetItem()
end

local function RefreshRed(self)
  local challengeRed = DataCenter.ArenaManager:GetChallengeRedCount()
  if 0 < challengeRed then
    self.challengeRedN:SetActive(true)
    self.challengeRedNumN:SetText(challengeRed)
  else
    self.challengeRedN:SetActive(false)
  end
  local historyRed = DataCenter.ArenaManager:GetArenaHistoryRedCount()
  self.historyRedN:SetActive(0 < historyRed)
  local setDefenseRed = DataCenter.ArenaManager:GetSetDefenseRedCount()
  self.defenseRedN:SetActive(0 < setDefenseRed)
end

local function ShowRankList(self)
  self.rankList = DataCenter.ArenaManager:GetRankList()
  if #self.rankList == 0 then
    self.emptyTipN:SetActive(true)
    self.svRankN:SetActive(false)
  else
    self.emptyTipN:SetActive(false)
    self.svRankN:SetActive(true)
    self.svRankN:SetTotalCount(#self.rankList)
    self.svRankN:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svRankN:AddComponent(ArenaRankItem, itemObj)
  local param = {}
  param.index = index
  param.isShowHeroes = index == self.curDetailIndex
  
  function param.callback(targetIndex)
    self:JumpToIndex(targetIndex)
  end
  
  cellItem:SetItem(self.rankList[index], param)
  self.rankItemsDic[index] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
  self.rankItemsDic[index] = nil
  self.svRankN:RemoveComponent(itemObj.name, ArenaRankItem)
end

local function ClearScroll(self)
  self.svRankN:ClearCells()
  self.svRankN:RemoveComponents(ArenaRankItem)
end

local function JumpToIndex(self, targetIndex)
  if self.curDetailIndex and self.rankItemsDic[self.curDetailIndex] then
    self.rankItemsDic[self.curDetailIndex]:ShowHeroesByExternal(false)
  end
  if not self.curDetailIndex or targetIndex ~= self.curDetailIndex then
    self.rankItemsDic[targetIndex]:ShowHeroesByExternal(true)
    self.svRankN:ScrollToCell(targetIndex, 1000)
    self.curDetailIndex = targetIndex
  else
    self.curDetailIndex = nil
    TimerManager:GetInstance():DelayInvoke(function()
      self.svRankN:StopMovement()
    end, 0.1)
  end
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.roundEndTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.roundEndTimeN:SetText("")
    self:DelCountDownTimer()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickRewardBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaReward, self.actId)
end

local function OnClickHistoryBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaHistory)
end

local function OnClickChallengeBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaChallenge)
end

local function OnClickSetTeamBtn(self)
  local id = ArenaSetTeamLevelId
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(id)
  if pveTemplate ~= nil then
    local param = {}
    param.pveEntrance = PveEntrance.ArenaSetting
    param.levelId = id
    param.isStart = true
    DataCenter.BattleLevel:Enter(param)
    DataCenter.ArenaManager:SetDefenseRedTs()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCenterTable)
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("372255"), Localization:GetString("302027"), Localization:GetString("372287"))
end

ArenaMain.OnCreate = OnCreate
ArenaMain.OnDestroy = OnDestroy
ArenaMain.ComponentDefine = ComponentDefine
ArenaMain.ComponentDestroy = ComponentDestroy
ArenaMain.DataDefine = DataDefine
ArenaMain.DataDestroy = DataDestroy
ArenaMain.OnAddListener = OnAddListener
ArenaMain.OnRemoveListener = OnRemoveListener
ArenaMain.SetData = SetData
ArenaMain.RefreshAll = RefreshAll
ArenaMain.RefreshRed = RefreshRed
ArenaMain.ShowRankList = ShowRankList
ArenaMain.OnClickRewardBtn = OnClickRewardBtn
ArenaMain.OnClickHistoryBtn = OnClickHistoryBtn
ArenaMain.OnClickChallengeBtn = OnClickChallengeBtn
ArenaMain.OnClickSetTeamBtn = OnClickSetTeamBtn
ArenaMain.OnItemMoveIn = OnItemMoveIn
ArenaMain.OnItemMoveOut = OnItemMoveOut
ArenaMain.ClearScroll = ClearScroll
ArenaMain.JumpToIndex = JumpToIndex
ArenaMain.OnClickInfoBtn = OnClickInfoBtn
ArenaMain.AddCountDownTimer = AddCountDownTimer
ArenaMain.RefreshRemainTime = RefreshRemainTime
ArenaMain.DelCountDownTimer = DelCountDownTimer
return ArenaMain
