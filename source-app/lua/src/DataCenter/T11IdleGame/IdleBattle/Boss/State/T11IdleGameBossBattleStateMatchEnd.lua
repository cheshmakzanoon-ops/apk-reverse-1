local T11IdleGameBossBattleStateMatchEnd = BaseClass("T11IdleGameBossBattleStateMatchEnd")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization

function T11IdleGameBossBattleStateMatchEnd:__init(logic)
  self.logic = logic
  self.resultData = nil
end

function T11IdleGameBossBattleStateMatchEnd:__delete()
  self.logic = nil
  self.resultData = nil
end

function T11IdleGameBossBattleStateMatchEnd:OnEnter(resultData)
  self.resultData = resultData
  if not self.logic or not self.resultData then
    return
  end
  if self.resultData.win == true then
    self:OnBattleWin()
  else
    self:OnBattleLose()
  end
end

function T11IdleGameBossBattleStateMatchEnd:OnExit()
  if self.delayEnterNextBossTimer then
    self.delayEnterNextBossTimer:Stop()
    self.delayEnterNextBossTimer = nil
  end
end

function T11IdleGameBossBattleStateMatchEnd:OnUpdate()
end

function T11IdleGameBossBattleStateMatchEnd:Dispose()
end

function T11IdleGameBossBattleStateMatchEnd:OnBattleWin()
  self.logic:DestroyBoss()
  local mainData = self.logic:GetMainData()
  if not mainData then
    return
  end
  local uiComp = self.logic:GetBattleUIComponent()
  if not uiComp then
    return
  end
  uiComp:RefreshBossCountAfterFlyEffect()
  local lastBossId = self.resultData.challengeBoss
  local lastBoss = DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(lastBossId)
  if not lastBoss then
    return
  end
  if lastBoss:IsFinalBoss() then
    self.logic:SetAutoMode(false)
    self.logic:RefreshUIBottomBtn()
    uiComp:ShowYellowTips(Localization:GetString("t11_idle_game_desc_18"))
    uiComp:RefreshRewardContent()
    if self.resultData.changeLevel ~= nil then
      local title = Localization:GetString("t11_idle_game_title_61")
      local content = Localization:GetString("t11_idle_game_desc_52")
      local btnKey1 = "t11_idle_game_button_63"
      UIUtil.ShowSecondMessage(title, content, 1, btnKey1, nil, function()
        EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnLevelChanged, self.resultData.changeLevel)
      end, nil, nil, function()
        EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnLevelChanged, self.resultData.changeLevel)
      end, nil, nil, nil, nil, nil, false)
    else
    end
  else
    uiComp:ShowBlueTips(Localization:GetString("t11_idle_game_desc_16"), 2)
    DataCenter.LWSoundManager:PlaySound(91012, false)
    local curBoss = self.logic:GetCurBossTemplate()
    if curBoss then
      uiComp:TryFlyAddReward()
      if self.delayEnterNextBossTimer then
        self.delayEnterNextBossTimer:Stop()
        self.delayEnterNextBossTimer = nil
      end
      self.delayEnterNextBossTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.logic then
          self.logic:ChangeState(Const.BossBattleState.Match_Init, curBoss)
        end
        if uiComp then
          uiComp:RefreshRewardContent()
        end
      end, 2)
    else
      DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameBossBattleStateMatchEnd:OnBattleWin curBoss is nil")
    end
  end
end

function T11IdleGameBossBattleStateMatchEnd:OnBattleLose()
  local uiComp = self.logic:GetBattleUIComponent()
  if not uiComp then
    return
  end
  uiComp:ShowBlueTips(Localization:GetString("t11_idle_game_desc_17"), 2)
  DataCenter.LWSoundManager:PlaySound(91013, false)
  local lastBossId = self.resultData.challengeBoss
  local lastBoss = DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(lastBossId)
  uiComp:ShowBossInfo(lastBoss)
  self.logic:SetAutoMode(false)
  self.logic:RefreshUIBottomBtn()
  self.logic:ChangeState(Const.BossBattleState.Match_Ready, lastBoss)
end

return T11IdleGameBossBattleStateMatchEnd
