local MonopolyCheerleader = BaseClass("MonopolyCheerleader")
local ResourceManager = CS.GameEntry.Resource
local resPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing02/prefab/A_Hero_bubing02_encourage.prefab"
local resPath_worker = "Assets/_Art_LastWar/Models/Characters/Worker/ben/prefab/ben_xiangzi_B.prefab"
local landUnlockEffectPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_kongtou.prefab"
local Const = require("Scene.LWBattle.Const")
local CheerleaderState = {
  Default = 0,
  Idle = 1,
  Win = 2,
  Lose = 3,
  Land = 4,
  MoveToTarget = 5
}
local MoveState = {
  Default = 0,
  Idle = 1,
  MoveToTarget = 2,
  MoveToBack = 3
}
local bubbleAnchor = Vector3.New(0, 3, 0)
local patrolInterval = 2
local cheerleaderStateInterval = 5
local idleBubbleInterval = 7

function MonopolyCheerleader:__init()
end

function MonopolyCheerleader:__delete()
  self.visible = nil
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self:ClearBornEffect()
  self:ClearDelayTimer()
  self.transform = nil
  self.anim = nil
  self.localPos = nil
  self.index = nil
  self:ClearSequence()
  self:ClearLandUnlockEffect()
end

function MonopolyCheerleader:SetPlotStatus()
  self.plot = true
  self.emoji = nil
end

function MonopolyCheerleader:SetEmojiStatus()
  self.emoji = true
  self.plot = nil
end

function MonopolyCheerleader:ClearStatus()
  self.plot = nil
  self.emoji = nil
end

function MonopolyCheerleader:Show(posX, posZ, index, idle, endPosX, endPosZ, newFlag, worker)
  self.localPos = Vector3.New(posX, 0, posZ)
  self.startPos = Vector3.New(posX, 0, posZ)
  self.endPos = Vector3.New(endPosX, 0, endPosZ)
  self.newFlag = newFlag
  self.worker = worker
  self.patrolTimer = patrolInterval
  self.lastMoveState = MoveState.Default
  self.moveState = MoveState.Default
  if idle then
    self.moveState = MoveState.Idle
  end
  self.index = index
  if self.transform then
    return
  end
  if self.request then
    return
  end
  self.targetPos = Vector3.New(0, 0, 0)
  self.CheerleaderStateTimer = 0
  self.idleBubbleTimer = 0
  self.state = CheerleaderState.Default
  if idle then
    self.state = CheerleaderState.Idle
  end
  local path = self.worker and resPath_worker or DataCenter.LWCivilizationSparkExtend:MonopolyCheerleader_resPath(resPath)
  self.request = ResourceManager:InstantiateAsync(path)
  self.request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local transform = go.transform
    self.gameObject = go
    self.transform = transform
    self.transform:SetParent(nil)
    self.transform:Set_localScale(1, 1, 1)
    self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
    if self.visible == nil then
      self.gameObject:SetActive(true)
    else
      self.gameObject:SetActive(self.visible)
    end
    self.anim = go:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self:ShowState(self.state)
    self:Refresh()
    if self.newFlag then
      self:ShowBornEffect()
    end
  end)
end

function MonopolyCheerleader:ShowBornEffect()
  if self.bornEffectReq then
    return
  end
  self.bornEffectReq = ResourceManager:InstantiateAsync(Const.ParkourAddMemberEffectPath)
  self.bornEffectReq:completed("+", function(req)
    if req.isError then
      return
    end
    if IsNull(self.transform) then
      self:ClearBornEffect()
      return
    end
    local go = req.gameObject
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(true)
  end)
end

function MonopolyCheerleader:ClearBornEffect()
  if self.bornEffectReq then
    self.bornEffectReq:Destroy()
    self.bornEffectReq = nil
  end
end

function MonopolyCheerleader:SetEndPos(endPosX, endPosZ)
  if self.endPos == nil then
    self.endPos = Vector3.New(endPosX, 0, endPosZ)
  else
    self.endPos.x = endPosX
    self.endPos.z = endPosZ
  end
end

function MonopolyCheerleader:Refresh()
  if self.transform then
    self.targetPos.x, self.targetPos.y, self.targetPos.z = DataCenter.MonopolyManager:GetPlayerPosition()
    local dirX = self.targetPos.x - self.localPos.x
    local dirZ = self.targetPos.z - self.localPos.z
    self.transform:Set_forward(dirX, 0, dirZ)
  end
end

function MonopolyCheerleader:ClearDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function MonopolyCheerleader:DelayIdleBubble()
  self.delayTimer = nil
  if self.state == CheerleaderState.Idle then
    self:DelayCallback()
  end
end

function MonopolyCheerleader:DelayCallback()
  self.delayTimer = nil
  if IsNull(self.transform) then
    return
  end
  local state = self.state
  if state == CheerleaderState.Idle then
    if self.plot then
      local plotId = DataCenter.MonopolyCheerleaderManager:GetIdlePlot(self.index)
      if 0 < plotId then
        local bubbleParams = {}
        bubbleParams.plotId = plotId
        bubbleParams.anchor = bubbleAnchor
        bubbleParams.mode = "3DFollow"
        bubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
      end
    elseif self.emoji then
      local emojiId = DataCenter.MonopolyCheerleaderManager:GetIdleEmoji(self.index)
      if 0 < emojiId then
        local emojiBubbleParams = {}
        emojiBubbleParams.emojiId = emojiId
        emojiBubbleParams.anchor = bubbleAnchor
        emojiBubbleParams.mode = "3DFollow"
        emojiBubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayEmojiBubble, emojiBubbleParams)
      end
    end
  elseif state == CheerleaderState.Win then
    if self.plot then
      local plotId = DataCenter.MonopolyCheerleaderManager:GetWinPlot(self.index)
      if 0 < plotId then
        local bubbleParams = {}
        bubbleParams.plotId = plotId
        bubbleParams.anchor = bubbleAnchor
        bubbleParams.mode = "3DFollow"
        bubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
      end
    elseif self.emoji then
      local emojiId = DataCenter.MonopolyCheerleaderManager:GetWinEmoji(self.index)
      if 0 < emojiId then
        local emojiBubbleParams = {}
        emojiBubbleParams.emojiId = emojiId
        emojiBubbleParams.anchor = bubbleAnchor
        emojiBubbleParams.mode = "3DFollow"
        emojiBubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayEmojiBubble, emojiBubbleParams)
      end
    end
  elseif state == CheerleaderState.Lose then
    if self.plot then
      local plotId = DataCenter.MonopolyCheerleaderManager:GetLosePlot(self.index)
      if 0 < plotId then
        local bubbleParams = {}
        bubbleParams.plotId = plotId
        bubbleParams.anchor = bubbleAnchor
        bubbleParams.mode = "3DFollow"
        bubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
      end
    elseif self.emoji then
      local emojiId = DataCenter.MonopolyCheerleaderManager:GetLoseEmoji(self.index)
      if 0 < emojiId then
        local emojiBubbleParams = {}
        emojiBubbleParams.emojiId = emojiId
        emojiBubbleParams.anchor = bubbleAnchor
        emojiBubbleParams.mode = "3DFollow"
        emojiBubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayEmojiBubble, emojiBubbleParams)
      end
    end
  elseif state == CheerleaderState.Land then
    if self.plot then
      local plotId = DataCenter.MonopolyCheerleaderManager:GetLandPlot(self.index)
      if 0 < plotId then
        local bubbleParams = {}
        bubbleParams.plotId = plotId
        bubbleParams.anchor = bubbleAnchor
        bubbleParams.mode = "3DFollow"
        bubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
      end
    elseif self.emoji then
      local emojiId = DataCenter.MonopolyCheerleaderManager:GetLandEmoji(self.index)
      if 0 < emojiId then
        local emojiBubbleParams = {}
        emojiBubbleParams.emojiId = emojiId
        emojiBubbleParams.anchor = bubbleAnchor
        emojiBubbleParams.mode = "3DFollow"
        emojiBubbleParams.followTarget = self.transform
        EventManager:GetInstance():Broadcast(EventId.PlayEmojiBubble, emojiBubbleParams)
      end
    end
  end
end

function MonopolyCheerleader:ShowState(state)
  self.state = state
  if IsNull(self.transform) then
    return
  end
  if state == CheerleaderState.Default then
    self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    self:ChangeMoveState(MoveState.Default)
  elseif state == CheerleaderState.Idle then
    self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    local delayTime = math.random()
    delayTime = 0.5 + 1.5 * delayTime
    self:ClearDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DelayCallback()
    end, delayTime)
    self.CheerleaderStateTimer = cheerleaderStateInterval
    self:ChangeMoveState(MoveState.Idle)
  elseif state == CheerleaderState.Win then
    self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetWinAnim())
    self:PlayQueued(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    local delayTime = math.random()
    delayTime = 0.5 + 1.5 * delayTime
    self:ClearDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DelayCallback()
    end, delayTime)
    self.CheerleaderStateTimer = cheerleaderStateInterval
    self:ChangeMoveState(MoveState.Default)
  elseif state == CheerleaderState.Lose then
    self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetLoseAnim())
    self:PlayQueued(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    local delayTime = math.random()
    delayTime = 0.5 + 1.5 * delayTime
    self:ClearDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DelayCallback()
    end, delayTime)
    self.CheerleaderStateTimer = cheerleaderStateInterval
    self:ChangeMoveState(MoveState.Default)
  elseif state == CheerleaderState.Land then
    self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetLandAnim())
    self:PlayQueued(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    local delayTime = math.random()
    delayTime = 0.5 + 1.5 * delayTime
    self:ClearDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DelayCallback()
    end, delayTime)
    if self.index == 2 then
      self:ShowLandUnlockEffect()
    end
    self.CheerleaderStateTimer = cheerleaderStateInterval
    self:ChangeMoveState(MoveState.Idle)
  elseif state == CheerleaderState.MoveToTarget then
    self.CheerleaderStateTimer = 0
    self.patrolTimer = patrolInterval
    self:ChangeMoveState(MoveState.MoveToTarget)
  end
end

function MonopolyCheerleader:PlayWin()
  if self.state > CheerleaderState.Win then
    return
  end
  self:ShowState(CheerleaderState.Win)
end

function MonopolyCheerleader:PlayLose()
  if self.state > CheerleaderState.Lose then
    return
  end
  self:ShowState(CheerleaderState.Lose)
end

function MonopolyCheerleader:PlayLandUnlock()
  self:ShowState(CheerleaderState.Land)
end

function MonopolyCheerleader:MoveToTarget()
  self:ShowState(CheerleaderState.MoveToTarget)
end

function MonopolyCheerleader:WinToPos(posX, posZ, endPosX, endPosZ)
  if self.startPos == nil then
    self.startPos = Vector3.New(posX, 0, posZ)
    self.endPos = Vector3.New(endPosX, 0, endPosZ)
  else
    self.startPos.x = posX
    self.startPos.z = posZ
    self.endPos.x = endPosX
    self.endPos.z = endPosZ
  end
  if self.state > CheerleaderState.Win then
    return
  end
  if IsNull(self.transform) then
    self.winToPos = true
    self.toPosX = posX
    self.toPosZ = posZ
    return
  end
  self.winToPos = false
  self:ClearSequence()
  self.targetPos.x = posX
  self.targetPos.z = posZ
  local dirX = self.targetPos.x - self.localPos.x
  local dirZ = self.targetPos.z - self.localPos.z
  self.transform:Set_forward(dirX, 0, dirZ)
  self.localPos.x = posX
  self.localPos.z = posZ
  self:PlaySimpleAnim(AnimName.Run)
  self:ChangeMoveState(MoveState.Default)
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.transform:DOLocalMove(self.localPos, 2))
  self.sequence:OnComplete(function()
    self.sequence = nil
    self:Refresh()
    self:PlayWin()
  end)
end

function MonopolyCheerleader:ClearSequence()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function MonopolyCheerleader:ToRemove(posX, posZ, eventFinish)
  if IsNull(self.transform) then
    return false
  end
  self:ClearSequence()
  self.targetPos.x = posX
  self.targetPos.z = posZ
  self.eventFinish = eventFinish or false
  local dirX = self.targetPos.x - self.localPos.x
  local dirZ = self.targetPos.z - self.localPos.z
  self.transform:Set_forward(dirX, 0, dirZ)
  self.localPos.x = posX
  self.localPos.z = posZ
  self:PlaySimpleAnim(AnimName.Run)
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.transform:DOLocalMove(self.localPos, 2))
  self.sequence:OnComplete(function()
    self.sequence = nil
    if self.eventFinish then
      EventManager:GetInstance():Broadcast(EventId.MonopolyCheerleaderFinish)
    end
  end)
  return true
end

function MonopolyCheerleader:ShowLandUnlockEffect()
  self:ClearLandUnlockEffect()
  self.landUnlockEffectRequest = ResourceManager:InstantiateAsync(landUnlockEffectPath)
  self.landUnlockEffectRequest:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local transform = go.transform
    transform:SetParent(nil)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
    go:SetActive(true)
  end)
end

function MonopolyCheerleader:ClearLandUnlockEffect()
  if self.landUnlockEffectRequest then
    self.landUnlockEffectRequest:Destroy()
    self.landUnlockEffectRequest = nil
  end
end

function MonopolyCheerleader:PlaySimpleAnim(anim)
  self.curAnim = anim
  if self.anim then
    self.anim:Play(anim)
  end
end

function MonopolyCheerleader:PlayQueued(anim)
  if self.anim then
    self.anim:PlayQueued(anim)
  end
end

function MonopolyCheerleader:ChangeMoveState(newState)
  if self.moveState == newState then
    return
  end
  self.lastMoveState = self.moveState
  self.moveState = newState
  if newState == MoveState.Default then
    self.patrolTimer = patrolInterval
  elseif newState == MoveState.MoveToTarget then
    local dirX = self.endPos.x - self.startPos.x
    local dirZ = self.endPos.z - self.startPos.z
    self.transform:Set_forward(dirX, 0, dirZ)
    self:PlaySimpleAnim(AnimName.Run)
  elseif newState == MoveState.MoveToBack then
    local dirX = self.startPos.x - self.endPos.x
    local dirZ = self.startPos.z - self.endPos.z
    self.transform:Set_forward(dirX, 0, dirZ)
    self:PlaySimpleAnim(AnimName.Run)
  end
end

function MonopolyCheerleader:OnUpdate(deltaTime)
  if self.moveState == MoveState.Default then
    return
  end
  if self.state > CheerleaderState.Default and self.CheerleaderStateTimer > 0 then
    self.CheerleaderStateTimer = self.CheerleaderStateTimer - deltaTime
    if self.CheerleaderStateTimer <= 0 then
      self.state = CheerleaderState.Default
      if self.moveState == MoveState.MoveToTarget then
        self:ChangeMoveState(MoveState.Default)
      end
      self.idleBubbleTimer = idleBubbleInterval
    end
    return
  end
  if 0 < self.idleBubbleTimer then
    self.idleBubbleTimer = self.idleBubbleTimer - deltaTime
    if 0 >= self.idleBubbleTimer then
      self.idleBubbleTimer = idleBubbleInterval
      if self.index == nil or self.index == 1 then
        EventManager:GetInstance():Broadcast(EventId.MonopolyCheerleaderRandomIdle)
      end
      local delayTime = math.random()
      delayTime = 0.5 + 1.5 * delayTime
      self:ClearDelayTimer()
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:DelayIdleBubble()
      end, delayTime)
    end
  end
  if self.moveState == MoveState.Idle then
    if 0 < self.patrolTimer then
      self.patrolTimer = self.patrolTimer - deltaTime
      if 0 >= self.patrolTimer then
        self.patrolTimer = patrolInterval
        if self.lastMoveState == MoveState.MoveToTarget then
          self:ChangeMoveState(MoveState.MoveToBack)
        else
          self:ChangeMoveState(MoveState.MoveToTarget)
        end
      end
    end
  elseif self.moveState == MoveState.MoveToTarget then
    if 0 < self.patrolTimer then
      local lerp = deltaTime / self.patrolTimer
      self.patrolTimer = self.patrolTimer - deltaTime
      local lerpX = 0
      local lerpZ = 0
      if 0 >= self.patrolTimer then
        lerpX = self.endPos.x
        lerpZ = self.endPos.z
        self.patrolTimer = patrolInterval
        self:ChangeMoveState(MoveState.Default)
        self:Refresh()
        self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
      else
        lerpX = self.localPos.x + (self.endPos.x - self.localPos.x) * lerp
        lerpZ = self.localPos.z + (self.endPos.z - self.localPos.z) * lerp
      end
      self.localPos.x = lerpX
      self.localPos.z = lerpZ
      self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
    end
  elseif self.moveState == MoveState.MoveToBack and 0 < self.patrolTimer then
    local lerp = deltaTime / self.patrolTimer
    self.patrolTimer = self.patrolTimer - deltaTime
    local lerpX = 0
    local lerpZ = 0
    if 0 >= self.patrolTimer then
      lerpX = self.startPos.x
      lerpZ = self.startPos.z
      self.patrolTimer = patrolInterval
      self:ChangeMoveState(MoveState.Idle)
      self:Refresh()
      self:PlaySimpleAnim(DataCenter.MonopolyCheerleaderManager:GetIdleAnim())
    else
      lerpX = self.localPos.x + (self.startPos.x - self.localPos.x) * lerp
      lerpZ = self.localPos.z + (self.startPos.z - self.localPos.z) * lerp
    end
    self.localPos.x = lerpX
    self.localPos.z = lerpZ
    self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
  end
end

function MonopolyCheerleader:SetVisible(visible)
  self.visible = visible
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(visible)
  end
end

return MonopolyCheerleader
