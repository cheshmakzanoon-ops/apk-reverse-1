local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitPlayer = BaseClass("LWHummerSceneUnitPlayer", base)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local FSMachine = require("Common.FSMachine")
local SpeedMaxLevel = 4
local Effect1Path = "SpeedEffect/Eff_jidongdui_jiasu_01"
local Effect2Path = "SpeedEffect/Eff_jidongdui_jiasu_02"
local Effect3Path = "SpeedEffect/Eff_jidongdui_jiasu_03"
local WeiYanEffectPath = "A_vehicle_jidongduikache_02/A_build@yinmijidongduihuoche_02_skin/To_unity/DeformationSystem/Root/cheshen/Body_M/BodyEnd_M/Eff_jidongdui_weiyan"
LWHummerSceneUnitPlayer.State = {
  Node = 0,
  Run = 1,
  Stay = 2,
  PreBattle = 3,
  ExitBattle = 4
}
LWHummerSceneUnitPlayer.HorizontalMoveState = {
  Idle = 1,
  Left = 2,
  Right = 3
}
LWHummerSceneUnitPlayer.HitState = {
  None = 0,
  Left = 1,
  Right = 2
}

function LWHummerSceneUnitPlayer:OnDestroy()
  base.OnDestroy(self)
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  for _, groups in pairs(self.progressGroups) do
    for _, group in pairs(groups) do
      if not IsNull(group) then
        group:Destroy()
      end
    end
  end
  self.progressGroups = nil
  self.refreshTimer = nil
end

function LWHummerSceneUnitPlayer:__init(param)
  self.layerMask = LayerMask.GetMask(LayerType.Zombie, LayerType.Junk)
  self.curState = self.State.None
  self.buffState = {}
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Run, require("Scene.LWHummerScene.State.Player.LWHummerScenePlayerRun").Create())
  self.fsm:Add(self.State.Stay, require("Scene.LWHummerScene.State.Player.LWHummerScenePlayerStay").Create())
  self.fsm:Add(self.State.PreBattle, require("Scene.LWHummerScene.State.Player.LWHummerScenePlayerPreBattle").Create())
  self.fsm:Add(self.State.ExitBattle, require("Scene.LWHummerScene.State.Player.LWHummerScenePlayerExitBattle").Create())
end

function LWHummerSceneUnitPlayer:InitBase(param)
  base.InitBase(self, param)
  self.baseSpeed = self.logic.data:GetInitVerticalSpeed()
  self.speedLevel = 0
  self.speed = self.baseSpeed
  self.curStateHorizontal = self.HorizontalMoveState.Idle
  self.curState = self.State.None
  self.birthPos = self.logic.data:GetPlayerBirthPos()
  self:SetPosition(self.birthPos.x, self.birthPos.z)
  self.hummerSceneSpeedLevelParam = {}
  self.hummerSceneSpeedLevelParam.speed = 0
  self.hummerSceneSpeedLevelParam.progress = 0
  self.hummerSceneSpeedLevelParam.jumpZombieChangeSpeed = 0
  self.hummerSceneSpeedLevelParam.jumpZombiesChange = true
  self.hummerSceneSpeedLevelParam.speedBuffJumpZombies = {}
end

function LWHummerSceneUnitPlayer:OnInited()
  base.OnInited(self)
  self.membersTransList = {}
  for i = 1, 5 do
    local memeber = self.transform:Find(string.format(Constant.PLAER_MEMBER_PATH, i))
    table.insert(self.membersTransList, memeber)
  end
  self.jumpZombieTransList = {}
  for i = 1, 6 do
    local trans = self.transform:Find(string.format(Constant.PLAER_ZOMBIE_PATH, i))
    table.insert(self.jumpZombieTransList, trans)
  end
  self.progressGroups = {}
  self.dummyTrans = self.transform:Find(Constant.TRUCK_GOODS_GROUP_DUMMY)
  self.refreshTimer = 0
  self.effect1 = self.transform:Find(Effect1Path).gameObject
  self.effect2 = self.transform:Find(Effect2Path).gameObject
  self.effect3 = self.transform:Find(Effect3Path).gameObject
  self.weiyanEffect = self.transform:Find(WeiYanEffectPath).gameObject
  self.effect1:SetActive(false)
  self.effect2:SetActive(false)
  self.effect3:SetActive(false)
  self.weiyanEffect:SetActive(false)
end

function LWHummerSceneUnitPlayer:GetMoveSpeedVertical()
  return self.speed
end

function LWHummerSceneUnitPlayer:ChangeHorizontalMoveState(state, value)
  if self.curState == self.State.Run then
    self.fsm.currState:ChangeHorizontalState(state, value)
  end
end

function LWHummerSceneUnitPlayer:ShowHit(state)
  if self.curState == self.State.Run then
    self.fsm.currState:ShowHit(state)
  end
end

function LWHummerSceneUnitPlayer:ChangeState(targetState)
  if self.curState == targetState then
    return
  end
  self.fsm:Switch(targetState)
  self.curState = targetState
end

function LWHummerSceneUnitPlayer:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.fsm then
    self.fsm:Update(dt)
  end
  self:UpdateBuff(dt)
  if self.refreshTimer then
    self.refreshTimer = self.refreshTimer - dt
    if self.refreshTimer <= 0 then
      self.refreshTimer = Constant.TRUCK_REFRESH_TIME
      self:RefreshTruckGoods()
    end
  end
end

function LWHummerSceneUnitPlayer:OnCollisionTrigger(trigger)
  if trigger.triggerType == HummerSceneTriggerType.SpeedAdd then
    self:AddOneBuff(trigger.cfg.buffId)
  end
end

function LWHummerSceneUnitPlayer:AddOneBuff(buffId)
  local cfg = self.logic.data:GetBuffTemplate(buffId)
  local buffData = self.buffState[cfg.type]
  if not buffData then
    buffData = {}
    buffData.type = cfg.type
    buffData.duration = cfg.duration
    buffData.durationEnd = Time.time + cfg.duration
    buffData.buffNum = 1
    buffData.value = cfg.value
    buffData.maxAddNum = cfg.maxAddNum
  else
    buffData.durationEnd = Time.time + cfg.duration
    buffData.buffNum = math.min(buffData.buffNum + 1, cfg.maxAddNum)
  end
  self.buffState[cfg.type] = buffData
end

function LWHummerSceneUnitPlayer:RemoveOneBuff(type)
  if self.buffState[type] then
    self.buffState[type].buffNum = math.max(self.buffState[type].buffNum - 1, 0)
  end
end

function LWHummerSceneUnitPlayer:ResetSpeedBuff()
  if self.buffState[HummerSceneBuffType.TriggerSpeedAdd] then
    self.buffState[HummerSceneBuffType.TriggerSpeedAdd].buffNum = 0
  end
  if self.buffState[HummerSceneBuffType.FingerSpeedAdd] then
    self.buffState[HummerSceneBuffType.FingerSpeedAdd].buffNum = 0
  end
  if self.buffState[HummerSceneBuffType.JumpZombieSpeedAdd] then
    self.buffState[HummerSceneBuffType.JumpZombieSpeedAdd].buffNum = 0
  end
  self.hummerSceneSpeedLevelParam.jumpZombiesChange = true
  self.hummerSceneSpeedLevelParam.speedBuffJumpZombies = {}
end

function LWHummerSceneUnitPlayer:UpdateBuff(dt)
  local triggerSpeed = 0
  local fingerSpeed = 0
  local jumpZombieChangeSpeed = 0
  local fingerBuffNum = 0
  local fingerBuffMaxNum = 0
  for k, v in pairs(self.buffState) do
    local buff = v
    if 0 < buff.buffNum then
      local canRemoveBuff = true
      if buff.type == HummerSceneBuffType.TriggerSpeedAdd then
        triggerSpeed = buff.buffNum * buff.value
      elseif buff.type == HummerSceneBuffType.FingerSpeedAdd then
        fingerSpeed = buff.buffNum * buff.value
        fingerBuffNum = fingerBuffNum + buff.buffNum
        fingerBuffMaxNum = buff.maxAddNum
        canRemoveBuff = not self.logic.fingerDown
      elseif buff.type == HummerSceneBuffType.JumpZombieSpeedAdd then
        jumpZombieChangeSpeed = buff.buffNum * buff.value
      end
      if 0 <= buff.duration and Time.time >= buff.durationEnd and canRemoveBuff then
        self:RemoveOneBuff(buff.type)
      end
    end
  end
  local speedLevel = 0
  local speed = 0
  local progress = 0
  if 0 < triggerSpeed then
    speed = self.baseSpeed + triggerSpeed
    speedLevel = SpeedMaxLevel
    progress = 1
  elseif 0 < fingerSpeed then
    speed = self.baseSpeed + fingerSpeed
    local levelSize = fingerBuffMaxNum / SpeedMaxLevel
    speedLevel = math.floor(fingerBuffNum / levelSize)
    if 20 < fingerBuffNum then
      progress = fingerBuffNum / fingerBuffMaxNum
    end
  else
    speed = self.baseSpeed
    speedLevel = 0
  end
  speed = speed + jumpZombieChangeSpeed
  if self.speedLevel ~= speedLevel and self.speed ~= speed or self.triggerSpeed ~= triggerSpeed then
    if 0 < triggerSpeed then
      self.effect1:SetActive(false)
      self.effect2:SetActive(false)
      self.effect3:SetActive(true)
      self.weiyanEffect:SetActive(true)
    elseif 2 < speedLevel then
      self.effect1:SetActive(false)
      self.effect2:SetActive(true)
      self.effect3:SetActive(false)
      self.weiyanEffect:SetActive(false)
    elseif 0 < speedLevel then
      self.effect1:SetActive(true)
      self.effect2:SetActive(false)
      self.effect3:SetActive(false)
      self.weiyanEffect:SetActive(false)
    else
      self.effect1:SetActive(false)
      self.effect2:SetActive(false)
      self.effect3:SetActive(false)
      self.weiyanEffect:SetActive(false)
    end
  end
  self.hummerSceneSpeedLevelParam.speed = math.floor(self.speed)
  self.hummerSceneSpeedLevelParam.progress = progress
  self.hummerSceneSpeedLevelParam.jumpZombieChangeSpeed = jumpZombieChangeSpeed
  EventManager:GetInstance():Broadcast(EventId.HummerSceneSpeedLevel, self.hummerSceneSpeedLevelParam)
  self.hummerSceneSpeedLevelParam.jumpZombiesChange = false
  self.speedLevel = speedLevel
  self.speed = speed
  self.triggerSpeed = triggerSpeed
end

function LWHummerSceneUnitPlayer:Recycle()
  base.Recycle(self)
  if self.fsm then
    self.fsm:Reset()
  end
end

function LWHummerSceneUnitPlayer:GetMembersTransList()
  return self.membersTransList
end

function LWHummerSceneUnitPlayer:RefreshTruckGoods()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local lastTime = DataCenter.StageManager.lastIdleRewardTimeStamp
  if not lastTime then
    return
  end
  local passedTime = serverTime - DataCenter.StageManager.lastIdleRewardTimeStamp
  local maxTime = DataCenter.StageManager.hangUpMaxTime
  local progress = math.min(1, passedTime / maxTime)
  local setting = Constant.TRUCK_GOODS_GROUP_SETTING[1]
  for i, v in ipairs(Constant.TRUCK_GOODS_GROUP_SETTING) do
    if progress <= v.maxProgress then
      setting = v
      break
    end
  end
  self.curSetting = setting
  if self.progressGroups[setting.groupPath] == nil then
    self.progressGroups[setting.groupPath] = {}
  end
  local curGroups = self.progressGroups[setting.groupPath]
  for k, groups in pairs(self.progressGroups) do
    if k ~= setting.groupPath then
      for _, group in pairs(groups) do
        if not IsNull(group) and not IsNull(group.gameObject) then
          group.gameObject:SetActive(false)
        end
      end
    end
  end
  for i = 1, math.max(setting.groupNum, #curGroups) do
    local goodsGroup = curGroups[i]
    if not IsNull(goodsGroup) then
      if not IsNull(goodsGroup.gameObject) then
        goodsGroup.gameObject:SetActive(i <= setting.groupNum)
      end
    else
      local idx = i
      local handle = CS.GameEntry.Resource:InstantiateAsync(setting.groupPath, ObjectPoolTag.Normal, LoadPriority.Low)
      local space = setting.space
      handle:completed("+", function(request)
        if not (self.logic and self.logic.inLogic) or IsNull(self.dummyTrans) then
          request:Destroy()
          return
        end
        local transform = request.gameObject.transform
        transform:SetParent(self.dummyTrans)
        transform:Set_localPosition(0, space * (idx - 1), 0)
        transform:Set_localEulerAngles(0, 180, 0)
        transform:Set_localScale(0.8, 0.8, 0.8)
        handle.gameObject:SetActive(self.curSetting.groupPath == setting.groupPath and idx <= setting.groupNum)
      end)
      curGroups[i] = handle
    end
  end
end

function LWHummerSceneUnitPlayer:GetJumpZombieTransList()
  return self.jumpZombieTransList
end

function LWHummerSceneUnitPlayer:AddOneJumpZombieSpeedBuff(jumpZombie)
  table.insert(self.hummerSceneSpeedLevelParam.speedBuffJumpZombies, jumpZombie)
  self.hummerSceneSpeedLevelParam.jumpZombiesChange = true
  self:AddOneBuff(self.logic.data:GetJumpZombieBuffId())
end

function LWHummerSceneUnitPlayer:RemoveOneJumpZombieSpeedBuff(jumpZombie)
  local remove_count = table.removebyvalue(self.hummerSceneSpeedLevelParam.speedBuffJumpZombies, jumpZombie)
  if 0 < remove_count then
    self.hummerSceneSpeedLevelParam.jumpZombiesChange = true
    self:RemoveOneBuff(HummerSceneBuffType.JumpZombieSpeedAdd)
  end
end

return LWHummerSceneUnitPlayer
