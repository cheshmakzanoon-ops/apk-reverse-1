local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniInteract = BaseClass("PlayerAniInteract", base)
local Const = require("Scene.PVEBattleLevel.Const")

function PlayerAniInteract:__init(spaceman)
  self.time = 0
  self.isSendCmd = false
  self.animTime = Const.Interact_time
end

function PlayerAniInteract:OnEnter()
  base.OnEnter(self)
  self.time = UITimeManager:GetInstance():GetServerTime()
  self.isSendCmd = false
  self.isAlreadySet = false
  self.animTime = Const.Interact_time
  self.triggerId = nil
end

function PlayerAniInteract:OnExit()
  if self.triggerId ~= nil then
    local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.triggerId)
    if triggerData ~= nil and not triggerData:ISCollectRewardMoreThanOneTime() then
      triggerData:SetPlayerInteractEnd(true)
      triggerData:CheckDoTrigger()
    end
  end
  self.time = 0
  self.isSendCmd = false
  self.isAlreadySet = false
  self.triggerId = nil
  self.m_citySpaceMan:ShowWeapon(false)
end

function PlayerAniInteract:SetFakeStamina()
  if self.isAlreadySet then
    return
  end
  self.isAlreadySet = true
  local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.triggerId)
  if triggerData ~= nil then
    local needStaminaCount = triggerData:GetNeedPveStamina()
    if needStaminaCount ~= nil and 0 < needStaminaCount then
      local current = LuaEntry.Player:GetCurPveStamina() - needStaminaCount
      current = math.max(0, current)
      local now = UITimeManager:GetInstance():GetServerTime()
      local para = {}
      para.stamina = current
      para.lastStaminaTime = now
      LuaEntry.Player:SetStaminaData(para)
    end
  end
end

function PlayerAniInteract:OnUpdate()
  local passTime = UITimeManager:GetInstance():GetServerTime() - self.time
  local battleLevel = DataCenter.BattleLevel
  if battleLevel ~= nil then
    if self.triggerId ~= nil then
      local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.triggerId)
      if passTime >= self.animTime - 500 then
        self:SetFakeStamina()
      end
      if triggerData ~= nil and triggerData:ISCollectRewardMoreThanOneTime() then
        if passTime >= self.animTime and not self.isSendCmd then
          self.isSendCmd = true
          battleLevel:DoReceivePVETriggerReward(triggerData)
          local triggerPoint = battleLevel:GetTriggerByTriggerId(self.triggerId)
          if triggerPoint ~= nil then
            triggerPoint:HideHighlightItem()
          end
          self.m_citySpaceMan:LeaveInteractState()
        end
        return
      end
      if passTime >= self.animTime and not self.isSendCmd and not battleLevel:IsFinishTrigger(self.triggerId) then
        self.isSendCmd = true
        if triggerData ~= nil then
          triggerData:SetPlayerInteractEnd(true)
          triggerData:CheckDoTrigger()
        end
      end
      if passTime >= self.animTime and battleLevel:IsFinishTrigger(self.triggerId) then
        self.m_citySpaceMan:LeaveInteractState()
      end
    elseif passTime >= self.animTime then
      self.m_citySpaceMan:LeaveInteractState()
    end
  end
end

function PlayerAniInteract:SetTriggerId(triggerId)
  if triggerId ~= nil then
    self.triggerId = triggerId
    local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.triggerId)
    if triggerData ~= nil then
      triggerData:SetPlayerInteractEnd(false)
    end
    self.m_citySpaceMan:TurnToTargetId(self.triggerId)
  end
end

function PlayerAniInteract:SetAnimTime(animTime)
  if animTime == nil then
    self.animTime = Const.Interact_time
  else
    self.animTime = animTime
  end
end

function PlayerAniInteract:RefreshBuff()
end

return PlayerAniInteract
