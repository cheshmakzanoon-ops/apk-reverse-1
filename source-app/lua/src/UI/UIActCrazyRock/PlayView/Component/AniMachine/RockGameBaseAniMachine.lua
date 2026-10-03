local RockGameBaseAniMachine = BaseClass("RockGameBaseAniMachine")
local Localization = CS.GameEntry.Localization

local function __init(self)
end

local function __delete(self)
end

function RockGameBaseAniMachine:Init(transform, aniSpeed, getRtNodeFunc, customParam)
  self.transform = transform
  self.getRtNodeFunc = getRtNodeFunc
  self.simpleAni = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  self.aniSpeed = aniSpeed or 1
  self.changeIdleTimer = nil
  self.ANI_NAME_CONFIG = {}
  self.effectObjDic = {}
end

function RockGameBaseAniMachine:SetEntityName(entityName)
  self.entityName = entityName
end

function RockGameBaseAniMachine:OnPlayerSuccessHit(hitRet, params)
  if hitRet.hitType == CrazyRockHitType.SingleNoteHit then
    return self:OnPlayerSuccessSingleHit(hitRet, params)
  elseif hitRet.hitType == CrazyRockHitType.ContinueFirstNoteHit or hitRet.hitType == CrazyRockHitType.ContinueHit then
    return self:OnPlayerSuccessContinueHit(hitRet, params)
  end
end

function RockGameBaseAniMachine:OnEnterContinueClickState()
end

function RockGameBaseAniMachine:OnExitContinueClickState()
end

function RockGameBaseAniMachine:OnPlayerSuccessSingleHit(hitRet, params)
end

function RockGameBaseAniMachine:OnPlayerSuccessContinueHit(hitRet, params)
end

function RockGameBaseAniMachine:OnBreakCombo(noteItem)
  self:CheckMatchStateAndAni()
end

function RockGameBaseAniMachine:OnNoteItemFinish(noteType)
end

function RockGameBaseAniMachine:AutoChangeState(state, nextState, fadeTime)
  local autoChangeStateFunc
  if nextState then
    function autoChangeStateFunc()
      self:ChangeState(nextState, nil, 0.2)
    end
  end
  self:ChangeState(state, autoChangeStateFunc, fadeTime)
end

function RockGameBaseAniMachine:ChangeState(state, aniFinishCallback, fadeTime)
  if not state or not self.ANI_NAME_CONFIG then
    Logger.LogError("RockGameBaseAniMachine:ChangeState. state or ANI_NAME_CONFIG is nil")
    return
  end
  self.state = state
  if table.containsKey(self.ANI_NAME_CONFIG, state) then
    self:PlayAni(self.ANI_NAME_CONFIG[state], aniFinishCallback, fadeTime or 0.2)
  end
end

function RockGameBaseAniMachine:PlayAni(aniName, finishCallback, fadeTime)
  if not self.simpleAni then
    return
  end
  if self.simpleAni:IsPlaying(aniName) then
    self.simpleAni:Rewind(aniName)
    self.simpleAni:CrossFade(aniName, fadeTime or 0)
  else
    self.simpleAni:Rewind(aniName)
    self.simpleAni:CrossFade(aniName, fadeTime or 0)
  end
  self.simpleAni:SetStateSpeed(aniName, self.aniSpeed)
  self:PlayEffect(aniName)
  if self.changeIdleTimer then
    self.changeIdleTimer:Stop()
    self.changeIdleTimer = nil
  end
  if finishCallback then
    local aniDuration = self.simpleAni:GetClipLength(aniName)
    if aniDuration and 0 < aniDuration then
      self.changeIdleTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.changeIdleTimer = nil
        if finishCallback then
          finishCallback()
        end
      end, aniDuration)
    end
  end
end

function RockGameBaseAniMachine:GetAniDuration(aniName)
  if not self.simpleAni then
    return 0
  end
  return self.simpleAni:GetClipLength(aniName)
end

function RockGameBaseAniMachine:SetAniSpeed(aniSpeed)
  self.aniSpeed = aniSpeed
  if self.simpleAni:IsPlaying("Idle") then
    self:PlayAni("Idle")
  end
end

function RockGameBaseAniMachine:PlayEffect(effectName)
  if not self.effectObjDic then
    return
  end
  for name, v in pairs(self.effectObjDic) do
    local isShow = effectName == name
    if isShow then
      v:SetActive(false)
    else
    end
    v:SetActive(isShow)
  end
end

function RockGameBaseAniMachine:CheckMatchStateAndAni()
end

function RockGameBaseAniMachine:Destroy()
  if self.changeIdleTimer then
    self.changeIdleTimer:Stop()
    self.changeIdleTimer = nil
  end
end

return RockGameBaseAniMachine
