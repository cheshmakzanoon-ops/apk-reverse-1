local base = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Base")
local T11IdleGameIdleBattleNode_Event = BaseClass("T11IdleGameIdleBattleNode_Event", base)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleNode_Event:__init(logic, owner)
  base.__init(self, logic, owner)
end

function T11IdleGameIdleBattleNode_Event:__delete()
  base.__delete(self)
end

function T11IdleGameIdleBattleNode_Event:Destroy()
  base.Destroy(self)
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function T11IdleGameIdleBattleNode_Event:Start()
  base.Start(self)
  if self.data == nil or self.owner == nil then
    return
  end
  local propAssetPath = self.data:GetPropAssetPath()
  if string.IsNullOrEmpty(propAssetPath) then
    propAssetPath = Const.NodeEventDefaultAssetPath
  end
  self:CreateProp(propAssetPath, Const.NodeEventInitPosition, Const.NodeEventInitRotation, function()
    local propController = self.propObj.transform:GetComponentInChildren(typeof(CS.T11IdleGameIdleBattleSoldierController))
    if IsNull(propController) then
      DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNode_Event:Start, controller is null")
      return
    end
    local propMainAnim = propController:GetMainAnim()
    propMainAnim:Play("t11_idle_game_idle")
    propController:SetSoldierForward(-90)
    propController:HideBubble(true)
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    local soldier = self.logic:GetSoldier(1)
    if not soldier or IsNull(soldier.obj) then
      return
    end
    local duration = math.abs(Const.NodeEventInitPosition.z) / Const.PropMoveSpeed
    local moveTween1 = self.propObj.transform:DOLocalMoveZ(0, duration):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
      if self.logic then
        self.logic:PauseSceneManager()
        self.logic:ChangeSquadState(Const.SoldierState.Idle)
      end
      base.ShowTips(self, Localization:GetString("t11_idle_game_desc_15"))
    end)
    self.sequence:Append(moveTween1)
    self.sequence:AppendInterval(0.5)
    self.sequence:AppendCallback(function()
      soldier:SetBubbleImage(Const.NodeEventSoldierBubbleIconImagePath1)
      soldier:ShowBubble()
      propController:SetBubbleImage(Const.NodeEventSoldierBubbleIconImagePath2)
      propController:ShowBubble()
    end)
    self.sequence:AppendInterval(1)
    local moveDistance = Vector3.Distance(Const.NodeEventInitPosition, Vector3.zero)
    local moveDuration = moveDistance / Const.NodeEventRunSpeed
    local moveTween2 = self.propObj.transform:DOLocalMove(Vector3.zero, moveDuration):SetEase(CS.DG.Tweening.Ease.InQuad)
    moveTween2:OnStart(function()
      if IsNotNull(self.propAnim) then
        self.propAnim:Play("t11_idle_game_run")
      end
      DataCenter.LWSoundManager:PlaySound(91021, false)
    end)
    moveTween2:OnComplete(function()
      propController:SetSoldierForward(0)
      propMainAnim:Play("t11_idle_game_idle")
      soldier:HideBubble()
      propController:HideBubble()
    end)
    self.sequence:Append(moveTween2)
    self.sequence:AppendInterval(0.5)
    self.sequence:AppendCallback(function()
      propMainAnim:Play("t11_idle_game_give")
    end)
    self.sequence:AppendInterval(1.5)
    self.sequence:AppendCallback(function()
      soldier:SetBubbleImage(Const.NodeEventSoldierBubbleIconImagePath3)
      soldier:ShowBubble()
      propController:SetBubbleImage(Const.NodeEventSoldierBubbleIconImagePath3)
      propController:ShowBubble()
      self:PlayUIFlyEffectToTaskBtn()
      EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventRedPointRefreshByUpdateMsg)
    end)
    self.sequence:AppendInterval(0.7)
    local movePosition3 = Vector3.New(Const.NodeEventInitPosition.x, 0, 0)
    local moveTween3 = self.propObj.transform:DOLocalMove(movePosition3, moveDuration):SetEase(CS.DG.Tweening.Ease.InQuad)
    moveTween3:OnStart(function()
      propController:HideBubble()
      propController:SetSoldierForward(90)
      if IsNotNull(self.propAnim) then
        self.propAnim:Play("t11_idle_game_run")
      end
    end)
    moveTween3:OnComplete(function()
      propController:SetSoldierForward(-90)
      propMainAnim:Play("t11_idle_game_idle")
      soldier:HideBubble()
      local uiComp = self.logic:GetBattleUIComponent()
      if uiComp then
        uiComp:RefreshRewardContent()
      end
    end)
    self.sequence:Append(moveTween3)
    local moveTween4 = self.propObj.transform:DOLocalMoveZ(Const.NodeEventInitPosition.z * -1, duration):SetEase(CS.DG.Tweening.Ease.Linear)
    moveTween4:OnStart(function()
      if self.logic then
        self.logic:ResumeSceneManager()
        self.logic:ChangeSquadState(Const.SoldierState.Run)
      end
      self:RefreshUINodeInfoComponent()
    end)
    self.sequence:Append(moveTween4)
    self.sequence:OnComplete(function()
      self.sequence = nil
      self:Finish()
    end)
  end)
end

return T11IdleGameIdleBattleNode_Event
