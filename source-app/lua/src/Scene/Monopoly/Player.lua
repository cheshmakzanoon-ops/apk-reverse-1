local Player = BaseClass("Player")
local Const = require("Scene.Monopoly.Const")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

function Player:__init()
  self.modelHeight = 0
  self.delayList = {}
  self.endPos = {}
  self.playerState = MonoPolyPlayerState.Normal
end

function Player:__delete()
  self.visible = nil
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  if not IsNull(self.transform) then
    self.transform:Find("A_build_arrow").gameObject:SetActive(false)
  end
  if not IsNull(self.initEffect) then
    self.initEffect:SetActive(false)
  end
  if not IsNull(self.initEffect_2) then
    self.initEffect_2:SetActive(false)
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  if self.showEffReq then
    self.showEffReq:Destroy()
    self.showEffReq = nil
  end
  if self.battleRes then
    self.battleRes:Destroy()
    self.battleRes = nil
  end
  if self.delayList then
    for i, v in pairs(self.delayList) do
      v:Stop()
    end
    self.delayList = nil
  end
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
    self.updateTimer = nil
  end
  if self.eventEndDelay then
    self.eventEndDelay:Stop()
    self.eventEndDelay = nil
  end
  self.delayList = nil
  self.effect = nil
  self.modelTrigger = nil
  self.obj = nil
  self.effect = nil
  self.initEffect = nil
  self.initEffect_2 = nil
  self.isArrival = nil
  self.endPos = nil
  self.isCreate = nil
  self.nextData = nil
  self.curData = nil
  self.halfwayPos = nil
  self.isEnd = nil
  self.continueTip = nil
  self.resetModel = nil
  self.playerState = nil
end

function Player:CreateModel(curId, isInit)
  if curId == 0 or curId == nil then
    return
  end
  self.isCreate = true
  self.nextData = DataCenter.MonopolyManager:GetPlacealityDataById(curId)
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  self.curData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
  if not self.curData or not self.nextData then
    return
  end
  self.req = Resource:InstantiateAsync(DataCenter.LWCivilizationSparkExtend:MonopolyPlayer_getPlayerModelPath(Const))
  self.req:completed("+", function(req)
    self.gameObject = req.gameObject
    if self.visible == nil then
      self.gameObject:SetActive(true)
    else
      self.gameObject:SetActive(self.visible)
    end
    self.gameObject.name = "monopolyPlayer"
    self.transform = req.gameObject.transform
    
    function self.updateTimer()
      self:Update()
    end
    
    local pos1 = self.curData:GetCenterWorldPos()
    local pos2 = self.nextData:GetCenterWorldPos()
    local lookRot = Vector3.Normalize(pos2 - pos1)
    if lookRot ~= Vector3.zero then
      lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
    end
    self.endPos = {}
    self.transform.rotation = lookRot
    self.transform:Set_position(pos1.x, pos1.y + 0.3, pos1.z)
    self.simpleAnimList = DataCenter.LWCivilizationSparkExtend:MonopolyPlayer_getSimpleList(self.transform)
    for i, v in ipairs(self.simpleAnimList) do
      v.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
    end
    self.transform:Find("A_build_arrow").gameObject:SetActive(true)
    self.update = UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    self.obj = self.transform:Find("A_Hero_bubing05/Hero@bubing05_skin (1)")
    self.effect = self.transform:Find("Eff_dafuw_wjsc_dikuai").gameObject
    self.initEffect = self.transform:Find("VFX_animal_grow").gameObject
    self.initEffect_2 = self.transform:Find("VFX_xinshou_kongtou").gameObject
    local modelHeightCom = self.gameObject:GetComponent(typeof(CS.ModelHeight))
    if modelHeightCom then
      self.modelHeight = modelHeightCom:GetHeight()
    end
    local sBattleTipText = self.transform:Find("continueTip/icon/text"):GetComponent(typeof(CS.SuperTextMesh))
    sBattleTipText.text = Localization:GetString(801352)
    self.continueTip = self.transform:Find("continueTip")
    self:RefreshSBattleTip()
    self.isArrival = true
    self.trigger = self.transform:Find("continueTip/Trigger").gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.trigger then
      function self.trigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    local idle = true
    if self.nextData.state == MonopolyPlacealityType.EventEnd then
      self:OnEventEnd()
      idle = false
    end
    self:PlayAnim("idle")
    self.effect:SetActive(true)
    if isInit then
      self:OnInitCreate(isInit)
    end
    if self.nextData.isLose or self.nextData.isExit then
      idle = false
    end
    EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerCreated, idle)
    if self.nextData.isLose then
      EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerLose)
      DataCenter.MonopolyManager.dataManager:SetIsLose(false)
    end
    if self.nextData.isExit then
      EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerExit)
      DataCenter.MonopolyManager.dataManager:SetIsExit(false)
    end
  end)
end

function Player:ResetModel(curId)
  if curId == 0 or curId == nil then
    return
  end
  self.nextData = DataCenter.MonopolyManager:GetPlacealityDataById(curId)
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  self.curData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
  if IsNull(self.gameObject) then
    return
  end
  self.resetModel = true
  local pos1 = self.curData:GetCenterWorldPos()
  local pos2 = self.nextData:GetCenterWorldPos()
  local lookRot = Vector3.Normalize(pos2 - pos1)
  if lookRot ~= Vector3.zero then
    lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
  end
  self.endPos = {}
  self.transform.rotation = lookRot
  self.transform:Set_position(pos1.x, pos1.y + 0.3, pos1.z)
  self:RefreshSBattleTip()
  self.isArrival = true
  local idle = true
  if self.nextData.state == MonopolyPlacealityType.EventEnd then
    self:OnEventEnd()
    idle = false
  end
  self:PlayAnim("idle")
  self.effect:SetActive(true)
  if self.nextData.isLose or self.nextData.isExit then
    idle = false
  end
  if self.nextData.isLose then
    EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerLose)
    DataCenter.MonopolyManager.dataManager:SetIsLose(false)
  end
  if self.nextData.isExit then
    EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerExit)
    DataCenter.MonopolyManager.dataManager:SetIsExit(false)
  end
end

function Player:RefreshSBattleTip()
  if self.continueTip then
    local isSbattle = DataCenter.MonopolyManager:GetSpontaneousBattle()
    self.continueTip.gameObject:SetActive(isSbattle)
  end
end

function Player:OnInitCreate(isInit)
  self:ShowEffectActive(isInit)
  self.simpleAnimList = DataCenter.LWCivilizationSparkExtend:MonopolyPlayer_getSimpleList(self.transform)
  for i, v in ipairs(self.simpleAnimList) do
    local obj = v.transform
    if obj then
      obj.localPosition = Vector3.New(0, 10, 0)
      obj:DOLocalMoveY(0, 1.5)
    end
  end
  local delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self:ShowEffectActive(not isInit)
  end, 1.5)
  table.insert(self.delayList, delayTime)
end

function Player:ShowEffectActive(isOn)
  self.initEffect:SetActive(isOn)
  self.initEffect_2:SetActive(isOn)
  self.effect:SetActive(not isOn)
  self.transform:Find("A_build_arrow").gameObject:SetActive(not isOn)
end

function Player:OnTriggerClick()
  DataCenter.MonopolyManager:SetSpontaneousBattle(false)
  self.continueTip.gameObject:SetActive(false)
end

function Player:OnEventEnd()
  if IsNull(self.transform) then
    return
  end
  self.resetModel = nil
  if self.eventEndDelay then
    self.eventEndDelay:Stop()
    self.eventEndDelay = nil
  end
  if self.playerState == MonoPolyPlayerState.CrossFast then
    self:CheckToWinOrLose()
    GoToUtil.GotoPos(self.transform.position, CS.SceneManager.World.InitZoom, 0)
  elseif self.playerState == MonoPolyPlayerState.Normal then
    self.eventEndDelay = TimerManager:GetInstance():DelayInvoke(function()
      self:CheckToWinOrLose()
    end, 0.5)
    GoToUtil.GotoPos(self.transform.position, CS.SceneManager.World.InitZoom, 0.5)
  end
  self.isEeventEnd = true
end

function Player:CheckToWinOrLose()
  if not self.nextData then
    return
  end
  if self.resetModel then
    return
  end
  if self.nextData.isLose then
    self:OnLose()
    DataCenter.MonopolyManager.dataManager:ChangeState(MonopolyPlacealityType.Arrive)
    DataCenter.MonopolyManager.dataManager:SetIsLose(false)
  else
    self:OnWin()
  end
end

function Player:OnWin()
  DataCenter.MonopolyManager:EventEndShow()
  local pos = self.transform.position + Vector3.New(0, self.modelHeight + 4.5)
  DataCenter.MonopolyManager.effectMgr:ShowEffectObj(Const.winEffectPath, pos, Vector3.New(2, 2, 2))
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Novice_Route_Victory, false)
  EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerWin)
end

function Player:OnLose()
  local pos = self.transform.position + Vector3.New(0, self.modelHeight + 4.5)
  DataCenter.MonopolyManager.effectMgr:ShowEffectObj(Const.loseEffectPath, pos, Vector3.New(2, 2, 2))
  EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerLose)
end

function Player:ShowLoseEffect()
end

function Player:OnPlacealityChangeState(placealityData, isEnd)
  if isEnd then
    local endlist = {
      self.nextData:GetCenterWorldPos() + Vector3.New(0, 0.4, 0)
    }
    self:SetTargetEndPos(endlist)
    self.isEnd = true
    return
  end
  if self.nextData.id == placealityData.id then
    self.nextData = placealityData
    if self.nextData.state > MonopolyPlacealityType.ArrivalBefore then
      self:PlayAnim(Const.animNames.run)
    end
    return
  end
  self.nextData = placealityData
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.nextData.id)
  self.curData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
  if #self.endPos >= 1 then
    table.insert(self.endPos, self.curData:GetCenterWorldPos())
  else
    local endlist = {
      self.curData:GetCenterWorldPos() + Vector3.New(0, 0.4, 0)
    }
    self:SetTargetEndPos(endlist)
  end
  if self.nextData.state == MonopolyPlacealityType.EventEnd then
  end
end

function Player:SetTargetEndPos(endPos)
  if self.transform and 1 <= #endPos then
    EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerBeforeMove)
    self.effect:SetActive(false)
    self.endPos = endPos
    self:RotateByTrans(self.endPos[1])
    self.curendPos = self.endPos[#self.endPos]
    self:PlayAnim(Const.animNames.run)
    self.isArrival = false
    local dir = self.endPos[1] - self.transform.position
    dir.x = dir.x / 2
    dir.y = dir.y / 2
    dir.z = dir.z / 2
    self.halfwayPos = self.transform.position + dir
  end
end

function Player:RotateByTrans(trans)
  local ro = Vector3.Normalize(trans - self.transform.position)
  local lookRot = self.transform.rotation
  if ro ~= Vector3.zero then
    lookRot = Quaternion.LookRotation(ro, Vector3.up)
  end
  self.transform.rotation = lookRot
  local v3 = self.transform.rotation.eulerAngles
  local rotation = Quaternion.Euler(0, v3.y, 0)
  self.transform.rotation = rotation
  if self.continueTip and not IsNull(CS.SceneManager.World) then
    self.continueTip.transform.rotation = CS.SceneManager.World:GetRotation()
  end
end

function Player:SetPlayerState(playerState)
  self.playerState = playerState
end

function Player:Update()
  if self.transform and self.endPos then
    if #self.endPos > 0 and Vector3.Distance(self.transform.position, self.endPos[1]) > 0.001 then
      if Vector3.Distance(self.transform.position, self.halfwayPos) < 0.01 then
        self:OnArrivalHalfway()
      end
      local speedFactor = self.playerState == MonoPolyPlayerState.CrossFast and 4 or 1
      self.transform.position = Vector3.MoveTowards(self.transform.position, self.endPos[1], Time.deltaTime * 2 * speedFactor)
      if self.nextData == nil or self.nextData.playerGoCameraFollow then
        GoToUtil.GotoPos(self.transform.position, CS.SceneManager.World.InitZoom, 0)
      end
    elseif #self.endPos >= 1 then
      table.remove(self.endPos, 1)
      if #self.endPos >= 1 then
        local dir = self.endPos[1] - self.transform.position
        dir.x = dir.x / 2
        dir.y = dir.y / 2
        dir.z = dir.z / 2
        self.halfwayPos = self.transform.position + dir
        self:RotateByTrans(self.endPos[1])
      end
    elseif not self.isArrival then
      self.isArrival = true
      self:OnArrivalTerminal()
    end
  end
end

function Player:OnArrivalHalfway()
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.curData.id)
  DataCenter.MonopolyManager:UpdatePalceality(preId, 0)
  DataCenter.MonopolyManager:UpdatePalceality(self.curData.id, 1)
end

function Player:OnArrivalTerminal()
  self:RotateByTrans(self.nextData:GetCenterWorldPos())
  self.effect:SetActive(true)
  if self.isEnd then
    self:PlayAnim(Const.animNames.idle)
    DataCenter.MonopolyManager:ChangeData()
    return
  end
  DataCenter.MonopolyManager:ChangeData()
  if self.playerState == MonoPolyPlayerState.Normal then
    self:PlayAnim(Const.animNames.idle)
  end
  local info, temp, delay
  for i = 1, #self.curData.polotInfo do
    if not string.IsNullOrEmpty(self.curData.polotInfo[i]) then
      delay = nil
      info = {}
      info.mode = "3D"
      info.screenRatioFix = false
      temp = self.curData.polotInfo[i]
      if temp[1] == "1" then
        info.plotGroupId = tonumber(temp[2])
        info.anchor = self.transform.position + Vector3.New(0, 2.5, -1)
        if not string.IsNullOrEmpty(temp[3]) then
          delay = tonumber(temp[3])
        end
      elseif temp[1] == "2" then
        info.plotGroupId = tonumber(temp[5])
        info.anchor = Vector3.New(tonumber(temp[2]), tonumber(temp[3]), tonumber(temp[4]))
        if not string.IsNullOrEmpty(temp[6]) then
          delay = tonumber(temp[6])
        end
      else
        info.plotGroupId = tonumber(temp[3])
        info.anchor = DataCenter.MonopolyManager:GetPlacealityDataById(tonumber(temp[2])):GetCenterWorldPos() + Vector3.New(2, 2.5, 0)
        if not string.IsNullOrEmpty(temp[4]) then
          delay = tonumber(temp[4])
        end
      end
      if delay and 0 < delay then
        local delayTime = TimerManager:GetInstance():DelayInvoke(function()
          EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, info)
        end, delay)
        table.insert(self.delayList, delayTime)
        return
      end
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, info)
    end
  end
end

function Player:GetPosition()
  if self.transform then
    return self.transform:Get_localPosition()
  end
  if self.curData then
    local pos = self.curData:GetCenterWorldPos()
    return pos.x, pos.y, pos.z
  end
  return 0, 0, 0
end

function Player:SetVisible(visible)
  self.visible = visible
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(visible)
  end
end

function Player:PlayAnim(animName)
  for i, v in ipairs(self.simpleAnimList) do
    v:Play(animName)
  end
end

return Player
