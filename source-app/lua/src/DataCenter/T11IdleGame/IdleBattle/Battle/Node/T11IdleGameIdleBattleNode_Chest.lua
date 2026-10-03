local base = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Base")
local T11IdleGameIdleBattleNode_Chest = BaseClass("T11IdleGameIdleBattleNode_Chest", base)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleNode_Chest:__init(logic, owner)
  base.__init(self, logic, owner)
end

function T11IdleGameIdleBattleNode_Chest:__delete()
  base.__delete(self)
end

function T11IdleGameIdleBattleNode_Chest:Destroy()
  base.Destroy(self)
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function T11IdleGameIdleBattleNode_Chest:Start()
  base.Start(self)
  if self.data == nil or self.owner == nil then
    return
  end
  local propAssetPath = self.data:GetPropAssetPath()
  if string.IsNullOrEmpty(propAssetPath) then
    propAssetPath = Const.NodeChestDefaultAssetPath
  end
  self:CreateProp(propAssetPath, Const.NodeChestPosition, Const.NodeChestRotation, function()
    if IsNotNull(self.propAnim) then
      self.propAnim:Play("idle")
    end
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    local soldier = self.logic:GetSoldier(1)
    if not soldier or IsNull(soldier.obj) then
      return
    end
    local duration = math.abs(Const.NodeChestPosition.z) / Const.PropMoveSpeed
    local moveTween1 = self.propObj.transform:DOLocalMoveZ(0, duration):SetEase(CS.DG.Tweening.Ease.Linear)
    moveTween1:OnComplete(function()
      if self.logic then
        self.logic:PauseSceneManager()
        self.logic:ChangeSquadState(Const.SoldierState.Idle, "idle_game_idle01")
      end
      base.ShowTips(self, Localization:GetString("t11_idle_game_desc_14"))
    end)
    self.sequence:Append(moveTween1)
    self.sequence:AppendInterval(1)
    self.sequence:AppendCallback(function()
      soldier:SetBubbleImage(Const.NodeChestSoldierBubbleIconImagePath1)
      soldier:ShowBubble()
    end)
    self.sequence:AppendInterval(1)
    local moveTween2 = soldier.obj.transform:DOLocalMove(Const.NodeChestSoldierMovePosition, 1):SetEase(CS.DG.Tweening.Ease.Linear)
    moveTween2:OnStart(function()
      soldier:ChangeState(Const.SoldierState.Run)
      DataCenter.LWSoundManager:PlaySound(91022, false)
    end)
    moveTween2:OnComplete(function()
      soldier:HideBubble()
      soldier:ChangeState(Const.SoldierState.Idle)
    end)
    self.sequence:Append(moveTween2)
    self.sequence:AppendInterval(0.5)
    self.sequence:AppendCallback(function()
      if self.logic then
        self.logic:SetVirtualCameraState(Const.VirtualCameraState.Chest)
      end
    end)
    self.sequence:AppendInterval(0.5)
    self.sequence:AppendCallback(function()
      soldier:ChangeState(Const.SoldierState.OpenChest)
    end)
    self.sequence:AppendInterval(0.3)
    self.sequence:AppendCallback(function()
      if IsNotNull(self.propAnim) then
        self.propAnim:Play("open")
      end
      self:CreateAsset(Const.NodeChestOpenEffectPath, self.propObj, ResetPosition, ResetEulerAngles)
    end)
    self.sequence:AppendInterval(1)
    self.sequence:AppendCallback(function()
      soldier:SetBubbleImage(Const.NodeChestSoldierBubbleIconImagePath2)
      soldier:ShowBubble()
      EventManager:GetInstance():Broadcast(EventId.T11IdleGamePlayFlyRewardNew)
    end)
    self.sequence:AppendInterval(1)
    local bubble2ShowState = false
    local moveTween3 = soldier.obj.transform:DOLocalMove(Const.DefaultSoldierPosList[1], 1):SetEase(CS.DG.Tweening.Ease.Linear)
    moveTween3:OnStart(function()
      soldier:SetSoldierForward(0)
      soldier.obj.transform:Set_localEulerAngles(0, 0, 0)
      soldier:ChangeState(Const.SoldierState.Run)
      if IsNotNull(self.propAnim) then
        self.propAnim:Play("dead")
      end
      self:DestroyAssets()
      if self.logic then
        self.logic:SetVirtualCameraState(Const.VirtualCameraState.Idle)
        local uiComp = self.logic:GetBattleUIComponent()
        if uiComp then
          uiComp:RefreshRewardContent()
        end
      end
    end)
    moveTween3:OnComplete(function()
      soldier:SetSoldierForward(180)
      soldier:ChangeState(Const.SoldierState.Idle, "idle_game_idle01")
    end)
    moveTween3:OnUpdate(function()
      if bubble2ShowState == false then
        local curAnimPercent = moveTween3:ElapsedPercentage()
        if 0.5 <= curAnimPercent then
          bubble2ShowState = true
          soldier:HideBubble()
        end
      end
    end)
    self.sequence:Append(moveTween3)
    self.sequence:AppendInterval(1)
    self.sequence:OnComplete(function()
      self.sequence = nil
      self:RefreshUINodeInfoComponent()
      self:Finish()
    end)
  end)
end

return T11IdleGameIdleBattleNode_Chest
