local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("Scene.LWBattle.Const")
local Resource = CS.GameEntry.Resource
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = true
  self.canInput = false
  self.transNextPlayer = nil
  self.animNextPlayer = nil
end

function State:OnExit()
end

function State:OnEnter(callBack)
  local owner = self.owner
  if owner then
    if owner.curScene then
      owner.curScene:RecycleProps()
      local preScene = owner:GetSceneByIndex(owner.curScene.sceneData.index - 1)
      if preScene then
        preScene:RecycleProps()
      end
      local nextScene = owner:GetSceneByIndex(owner.curScene.sceneData.index + 1)
      if nextScene then
        nextScene:RecycleProps()
      end
    end
    if owner.player then
      owner.player:ChangeState(owner.player.State.Finish)
    end
    if owner.mainView then
      owner.mainView:UpdateRedEffect(false)
    end
    self:ClearAllTimer()
    local delayTime = 0
    local stageTemplate = DataCenter.ActivityTorchRelayManager:GetStageTemplate(owner.activityId)
    local showNextPlayer
    local nextPlayerResPath = TorchConstant.FINISH_NEXT_PLAYER_ASSET_PATH
    if stageTemplate then
      showNextPlayer = stageTemplate.end_GiveAway == 1
      if stageTemplate:getNextSoliderResPath() then
        nextPlayerResPath = stageTemplate:getNextSoliderResPath()
      end
    end
    if showNextPlayer then
      delayTime = delayTime + 1
      self.delayShowNextPlayerTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.reqNextPlayer = Resource:InstantiateAsync(nextPlayerResPath)
        self.reqNextPlayer:completed("+", function(handle)
          if self.reqNextPlayer.isError or owner == nil or owner.player == nil or owner.player.transform == nil then
            self.reqNextPlayer:Destroy()
            self.reqNextPlayer = nil
            return
          end
          self.transNextPlayer = handle.gameObject.transform
          local pos = Vector3.New(owner.player.transform.position.x, owner.player.transform.position.y, owner.player.transform.position.z)
          pos = pos + TorchConstant.FINISH_NEXT_PLAYER_POSITION_OFFSET
          self.transNextPlayer:Set_position(pos:Split())
          self.transNextPlayer:Set_localScale(TorchConstant.PLAYER_SCALE:Split())
          self.transNextPlayer.rotation = Quaternion.Euler(0, -90, 0)
          handle.gameObject:SetActive(true)
          self.animNextPlayer = self.transNextPlayer:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
          if not IsNull(self.animNextPlayer) then
            self.animNextPlayer:Play("Transfer02")
          end
          if owner and owner.player then
            owner.player:PlayTransferAnim()
          end
        end)
      end, delayTime)
    end
    delayTime = delayTime + 1
    self.delayShowFinalResultTimer = TimerManager:GetInstance():DelayInvoke(function()
      if owner then
        owner.isFinishAnimationOver = true
        owner:PrintRealInfoLog("finish anim over")
        owner:TryShowFinalResult()
      end
    end, delayTime)
  end
end

function State:ClearAllTimer()
  if self.delayShowNextPlayerTimer then
    self.delayShowNextPlayerTimer:Stop()
    self.delayShowNextPlayerTimer = nil
  end
  if self.delayShowWinEffectTimer then
    self.delayShowWinEffectTimer:Stop()
    self.delayShowWinEffectTimer = nil
  end
  if self.delayShowFinalResultTimer then
    self.delayShowFinalResultTimer:Stop()
    self.delayShowFinalResultTimer = nil
  end
end

function State:Dispose()
  self:ClearAllTimer()
  if self.reqNextPlayer then
    self.reqNextPlayer:Destroy()
    self.reqNextPlayer = nil
  end
end

return State
