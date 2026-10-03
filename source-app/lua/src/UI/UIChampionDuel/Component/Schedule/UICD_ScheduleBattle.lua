local UICD_ScheduleBattle = BaseClass("UICD_ScheduleBattle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local UICD_VSCell = require("UI.UIChampionDuel.Component.Schedule.UICD_VSCell")
local UICD_LogPopItem = require("UI.UIChampionDuel.Component.Schedule.UICD_LogPopItem")
local time_path = "Mid/Time"
local left_path = "Mid/BgLeft"
local right_path = "Mid/BgRight"
local mid_path = "Mid"
local text_down_path = "DownText"
local text_down2_path = "DownText2"
local logPop_path = "LogPop"
local item_path = "LogPop/Item"
local btn_log_path = "BtnLog"
local text_btn_log_path = "BtnLog/BtnLogIcon/BtnLogText"
local red_log_path = "BtnLog/BtnLogIcon/RedLog"
local score_group_path = "Mid/Time/ScoreGroup"
local left_score_left_path = "Mid/Time/ScoreGroup/ScoreLeft/LeftText"
local right_score_left_path = "Mid/Time/ScoreGroup/ScoreRight/RightText"
local MID_STATE = {
  DEFAULT = 0,
  ENTER = 1,
  VS = 2,
  FIGHT = 3
}

function UICD_ScheduleBattle:OnCreate()
  base.OnCreate(self)
  self.remainTime = 0
  self.lastPopTime = 0
  self.retryTime = 0
  self.logPopCnt = 0
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.left_group = self:AddComponent(UICD_VSCell, left_path)
  self.right_group = self:AddComponent(UICD_VSCell, right_path)
  self.midAnim = self:AddComponent(UIAnimator, mid_path)
  self.midAnim:Enable(false)
  self.text_down = self:AddComponent(UIText, text_down_path)
  self.text_down2 = self:AddComponent(UIText, text_down2_path)
  self.logPop = self:AddComponent(UIBaseContainer, logPop_path)
  self.item = self.transform:Find(item_path)
  self.item.gameObject:GameObjectCreatePool()
  self.btn_log = self:AddComponent(UIButton, btn_log_path)
  self.btn_log:SetOnClick(BindCallback(self, self.OnBtnLogClick))
  self.text_btn_log = self:AddComponent(UIText, text_btn_log_path)
  self.text_btn_log:SetLocalText("champion_duel_tips1065")
  self.red_log = self:AddComponent(UIBaseComponent, red_log_path)
  self.score_group = self:AddComponent(UIBaseContainer, score_group_path)
  self.text_score_left = self:AddComponent(UIText, left_score_left_path)
  self.text_score_right = self:AddComponent(UIText, right_score_left_path)
end

function UICD_ScheduleBattle:OnDestroy()
  if self.headTimer ~= nil then
    self.headTimer:Stop()
  end
  self.headTimer = nil
  if self.midTimer ~= nil then
    self.midTimer:Stop()
  end
  self.midTimer = nil
  self:CleanTimer()
  self.item.gameObject:GameObjectRecycleAll()
  self.logPop:RemoveComponents(UICD_LogPopItem)
  self.logPop = nil
  self.item = nil
  self.remainTime = 0
  self.lastPopTime = 0
  self.retryTime = 0
  self.logPopCnt = 0
  self.anim = nil
  self.time_group = nil
  self.left_group = nil
  self.right_group = nil
  self.midAnim = nil
  self.text_down = nil
  self.text_down2 = nil
  self.btn_log = nil
  self.text_btn_log = nil
  self.red_log = nil
  self.score_group = nil
  self.text_score_left = nil
  self.text_score_right = nil
  base.OnDestroy(self)
end

function UICD_ScheduleBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelAuditionInfoRefresh, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
end

function UICD_ScheduleBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelAuditionInfoRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
  base.OnRemoveListener(self)
end

function UICD_ScheduleBattle:OnDisable()
  self.midState = nil
  base.OnDisable(self)
end

function UICD_ScheduleBattle:CleanTimer()
  if self.timers ~= nil then
    for _, v in pairs(self.timers) do
      if v then
        v:Stop()
      end
    end
  end
  self.timers = {}
end

function UICD_ScheduleBattle:OnBtnLogClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog)
  DataCenter.ChampionDuelManager:UpdateLogPopSign(false)
end

function UICD_ScheduleBattle:ReInit()
  if self.headTimer then
    self.headTimer:Stop()
  end
  self.headTimer = nil
  self.time_group:ReInit()
  self:UpdateData()
  DataCenter.ChampionDuelManager:ReqStageInfo()
  self:UpdateRed()
end

function UICD_ScheduleBattle:UpdateData(info)
  local selfInfo = info ~= nil and info.selfInfo or nil
  local targetInfo = info ~= nil and info.targetInfo or nil
  local selfScore = info ~= nil and info.selfScore or 0
  local targetScore = info ~= nil and info.targetScore or 0
  local remainTime = info ~= nil and info.remainTime or 0
  local fightFlag = false
  if self.info and info then
    local selfUid = self.info.selfInfo ~= nil and self.info.selfInfo.uid or 0
    local newSelfUid = selfInfo ~= nil and selfInfo.uid or 0
    local targetUid = self.info.targetInfo ~= nil and self.info.targetInfo.uid or 0
    local newTargetUid = targetInfo ~= nil and targetInfo.uid or 0
    if newSelfUid == selfUid and newTargetUid == targetUid and selfScore == self.info.selfScore and targetScore == self.info.targetScore then
      if remainTime == self.info.remainTime then
        return
      else
        fightFlag = true
      end
    end
  end
  self.info = info
  self:PlayMidAnim(MID_STATE.DEFAULT)
  if not fightFlag and info then
    self:PlayMidAnim(MID_STATE.ENTER)
  end
  DataCenter.ChampionDuelManager:ReqBattleLogPop()
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  self.retryTime = 0
  self.remainTime = remainTime
  self.endTime = actInfo ~= nil and actInfo.stageEndTime or 0
  self.left_group:SetActive(true)
  self.left_group:ReInit(selfInfo)
  self.right_group:SetActive(true)
  self.right_group:ReInit(targetInfo)
  local dayMatchTimes = info ~= nil and info.dayMatchTimes or 0
  local dayMatchMaxTimes = info ~= nil and info.dayMatchMaxTimes or 0
  local matchDay = info ~= nil and info.matchDay or 0
  local matchMaxDay = info ~= nil and info.matchMaxDay or 0
  self.isLastDay = matchDay == matchMaxDay
  self.isLastOne = dayMatchTimes == dayMatchMaxTimes
  if dayMatchMaxTimes == 0 then
    self.text_down2:SetActive(false)
  else
    self.text_down2:SetActive(true)
    self.text_down2:SetLocalText("champion_duel_tips1084", dayMatchTimes .. "/" .. dayMatchMaxTimes)
  end
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  local scoreShow = stageId >= ChampionDuelState.Rematch
  self.score_group:SetActive(scoreShow)
  if scoreShow then
    self.text_score_left:SetText(info ~= nil and info.selfScore or 0)
    self.text_score_right:SetText(info ~= nil and info.targetScore or 0)
  end
  self:PlayHeadAnim(true)
  self:UpdateRemainTime()
end

function UICD_ScheduleBattle:PlayHeadAnim(bOpen)
  if self.headTimer ~= nil then
    return
  end
  self.anim:Enable(true)
  local animName = bOpen and "start" or "end"
  local ret, time = self.anim:PlayAnimationReturnTime(animName)
  if ret then
    self.headTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.headTimer then
        self.headTimer:Stop()
      end
      self.headTimer = nil
      self:PlayHeadAnim(not bOpen)
    end, time + 5)
  end
end

function UICD_ScheduleBattle:PlayMidAnim(state)
  if self.midState == state then
    return
  end
  if self.midTimer ~= nil then
    self.midTimer:Stop()
    self.midTimer = nil
  end
  self.midState = state
  self.midAnim:Enable(state ~= MID_STATE.DEFAULT)
  if state == MID_STATE.DEFAULT then
    return
  end
  if state == MID_STATE.VS then
    self.midAnim:Play("idle", 0, 0)
    return
  elseif state == MID_STATE.FIGHT then
    self.midAnim:Play("loop", 0, 0)
    return
  elseif state == MID_STATE.ENTER then
    local animName = "start"
    self.midAnim:Play(animName, 0, 0)
    local ret, time = self.anim:GetAnimationReturnTime(animName)
    if ret then
      self.midTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.midTimer then
          self.midTimer:Stop()
        end
        self.midTimer = nil
        self.midState = MID_STATE.DEFAULT
        self:UpdateRemainTime()
      end, time)
    end
  end
end

function UICD_ScheduleBattle:UpdateRemainTime()
  if self.info == nil then
    self.text_down:SetActive(false)
    self.text_down2:SetActive(false)
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.remainTime - curSec
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if stageId == ChampionDuelState.KnockOut and self.isLastOne then
    local todayLeft = self.endTime - curSec
    local dayTime = 86400
    while todayLeft > dayTime do
      todayLeft = todayLeft - dayTime
    end
    if remainTime < 0 or remainTime > todayLeft then
      local selfScore = self.info ~= nil and self.info.selfScore or 0
      local targetScore = self.info ~= nil and self.info.targetScore or 0
      if selfScore < targetScore then
        self.text_down:SetLocalText("champion_duel_tips1148")
        self.text_down:SetActive(true)
        local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
        local group = actInfo ~= nil and actInfo.group or 0
        local key = DataCenter.ChampionDuelManager:GetFinalStrKey(group)
        self.text_down2:SetLocalText("champion_duel_tips1166", Localization:GetString(key))
        return
      elseif not self.isLastDay then
        local timeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(0 < remainTime and remainTime or todayLeft)
        self.text_down:SetLocalText("champion_duel_tips1169", timeStr)
        self.text_down:SetActive(true)
        return
      end
    end
  end
  if 0 < remainTime then
    local timeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime)
    self.text_down:SetLocalText("champion_duel_tips1083", timeStr)
    self.text_down:SetActive(true)
    if self.midState ~= MID_STATE.ENTER then
      self:PlayMidAnim(MID_STATE.VS)
    end
  else
    if self.isLastDay then
      self.text_down:SetLocalText(self.isLastOne and "champion_duel_tips1085" or "champion_duel_tips1086")
    else
      self.text_down:SetLocalText(self.isLastOne and "champion_duel_tips1027" or "champion_duel_tips1086")
    end
    self.text_down:SetActive(true)
    if self.isLastDay and self.isLastOne then
      remainTime = self.endTime - curSec
      if 0 < remainTime then
        local timeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime)
        self.text_down2:SetLocalText("champion_duel_tips1104", timeStr)
        self.text_down2:SetActive(true)
      else
        self.text_down2:SetActive(false)
      end
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.retryTime < 60 and self.lastGetStageInfoTime == nil or curTime - self.lastGetStageInfoTime > 3000 then
        self.retryTime = self.retryTime + 1
        DataCenter.ChampionDuelManager:ReqStageInfo()
        self.lastGetStageInfoTime = curTime
      end
    end
    if self.midState ~= MID_STATE.ENTER then
      self:PlayMidAnim(self.isLastOne and MID_STATE.VS or MID_STATE.FIGHT)
    end
  end
end

function UICD_ScheduleBattle:UpdateLogPop()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastPopTime < 3000 then
    return
  end
  self.lastPopTime = curTime
  self:CleanTimer()
  for i = 1, 3 do
    self.timers[i] = TimerManager:GetInstance():DelayInvoke(function()
      local timer = self.timers ~= nil and self.timers[i] or nil
      if timer then
        timer:Stop()
        self.timers[i] = nil
      end
      local logData = DataCenter.ChampionDuelManager:PopOnLogPop()
      if logData == nil then
        return
      end
      local item = self.item.gameObject:GameObjectSpawn(self.logPop.transform)
      local key = "item" .. self.logPopCnt
      item.name = key
      local obj = self.logPop:AddComponent(UICD_LogPopItem, key)
      obj:ReInit(logData)
      obj:PlayAnim(function()
        if self.logPop and not IsNull(self.logPop.gameObject) then
          if obj and not IsNull(obj.gameObject) then
            obj.gameObject:GameObjectRecycle()
          end
          self.logPop:RemoveComponent(key, UICD_LogPopItem)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.logPop)
        end
      end)
      self.logPopCnt = self.logPopCnt + 1
    end, (i - 1) * 0.1)
  end
end

function UICD_ScheduleBattle:Update1000MS()
  self:UpdateRemainTime()
end

function UICD_ScheduleBattle:Update()
  self:UpdateLogPop()
end

function UICD_ScheduleBattle:UpdateRed()
  local cnt = DataCenter.ChampionDuelManager:CheckLogPopRed()
  self.red_log:SetActive(0 < cnt)
end

return UICD_ScheduleBattle
