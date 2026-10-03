local AllianceStarCeremonyScene = BaseClass("AllianceStarCeremonyScene")
local FSMachine = require("Common.FSMachine")
local ResourceManager = CS.GameEntry.Resource
local Compere = require("Scene.AllianceStarCeremony.AllianceStarCeremonyCompere")
local Winner = require("Scene.AllianceStarCeremony.AllianceStarCeremonyWinner")
local Ally = require("Scene.AllianceStarCeremony.AllianceStarCeremonyAlly")
local ProgressCtrl = require("DataCenter.AllianceStar.AllianceStarCeremonyProgressCtrl")
local ScenePrefabPath = "Assets/Main/Prefabs/AllianceStar/UIAllianceStarCeremonyScene.prefab"
local AllyPrefabPath = "Assets/Main/Prefabs/AllianceStar/shibing_guanzhong.prefab"
local Localization = CS.GameEntry.Localization
local MaskColor = Color.New(0, 0.047058823529411764, 0.21176470588235294, 0)

function AllianceStarCeremonyScene:__init()
  self.State = AlStarCeremonyState
end

function AllianceStarCeremonyScene:__delete()
  self:Exit()
end

function AllianceStarCeremonyScene:OnDestroy()
  self:RemoveUpdateTimer()
  self:ClearRandomAnim()
  if self.allyDict then
    for k, v in pairs(self.allyDict) do
      self:RemoveAlly(v)
      ObjectPool:GetInstance():Save(v)
    end
    self.allyDict = nil
  end
  self.freeAllyPoints = nil
  self.allyParent = nil
  if self.compere then
    self.compere:Delete()
    self.compere = nil
  end
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.sceneReq then
    self.sceneReq:Destroy()
    self.sceneReq = nil
  end
  self.sceneObj = nil
  self.camera = nil
  self:ClearMPB()
  self.maskRenderer = nil
  self.MPB = nil
  self.dialogMode = nil
  self.dialogGroup = nil
  self.nextDialogCD = nil
  self.closeDialogCD = nil
  self.curDialogIndex = nil
  self.curDialogDelay = nil
  self.curDialogTemplate = nil
end

function AllianceStarCeremonyScene:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function AllianceStarCeremonyScene:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function AllianceStarCeremonyScene:OnUpdate()
  local dt = Time.deltaTime
  if self.fsm then
    self.fsm:Update(dt)
  end
  if self.allyDict then
    for k, v in pairs(self.allyDict) do
      if v.inited then
        v:Update(dt)
      end
    end
  end
  self:CompereBubbleUpdate(dt)
end

function AllianceStarCeremonyScene:Enter(manager, callback)
  self.manager = manager
  self:AddUpdateTimer()
  self:CreateScene(callback)
  self.progressCtrl = ProgressCtrl.New(self)
  self.curState = nil
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Ready, require("Scene.AllianceStarCeremony.State.Scene.AlStarReady").Create(self.State.Ready))
  self.fsm:Add(self.State.Opening, require("Scene.AllianceStarCeremony.State.Scene.AlStarOpening").Create(self.State.Opening))
  self.fsm:Add(self.State.ReadPersonReward, require("Scene.AllianceStarCeremony.State.Scene.AlStarReadPersonReward").Create(self.State.ReadPersonReward))
  self.fsm:Add(self.State.Applaud, require("Scene.AllianceStarCeremony.State.Scene.AlStarApplaud").Create(self.State.Applaud))
  self.fsm:Add(self.State.PersonAwards, require("Scene.AllianceStarCeremony.State.Scene.AlStarPersonAwards").Create(self.State.PersonAwards))
  self.fsm:Add(self.State.ReadAllianceReward, require("Scene.AllianceStarCeremony.State.Scene.AlStarReadAllianceReward").Create(self.State.ReadAllianceReward))
  self.fsm:Add(self.State.AllianceAwards, require("Scene.AllianceStarCeremony.State.Scene.AlStarAllianceAwards").Create(self.State.AllianceAwards))
  self.fsm:Add(self.State.Finish, require("Scene.AllianceStarCeremony.State.Scene.AlStarFinish").Create(self.State.Finish))
end

function AllianceStarCeremonyScene:Exit()
  self:OnDestroy()
end

function AllianceStarCeremonyScene:ChangeState(ceremonyInfo)
  self.ceremonyInfo = ceremonyInfo
  local targetState = ceremonyInfo.stateId
  if targetState ~= -1 then
    if self.curState ~= targetState then
      self.curState = targetState
      self.fsm:Switch(targetState, ceremonyInfo)
    else
      self.fsm.currState:Refresh(ceremonyInfo)
    end
  end
end

function AllianceStarCeremonyScene:ChangeProgressCtrlStageById(stageId)
  self.progressCtrl:ChangeStage(stageId)
end

function AllianceStarCeremonyScene:ChangeProgressCtrlStage(isNext)
  self.progressCtrl:ChangeCtrlStage(isNext)
end

function AllianceStarCeremonyScene:GetProgressCtrlStageId()
  return self.progressCtrl:GetStageId()
end

function AllianceStarCeremonyScene:ChangeCurStageInnerStage(innerStageId)
  self.progressCtrl:ChangeCurStageInnerStage(innerStageId)
end

function AllianceStarCeremonyScene:CreateScene(callback)
  if self.sceneReq == nil then
    self.sceneReq = ResourceManager:InstantiateAsync(ScenePrefabPath)
    self.sceneReq:completed("+", function()
      if self.sceneReq.isError then
        return
      end
      self.sceneObj = self.sceneReq.gameObject
      self.sceneObj.name = "UIAllianceStarCeremonyScene"
      self.camera = self.sceneObj.transform:Find("Camera"):GetComponentInChildren(typeof(CS.UnityEngine.Camera))
      self.maskRenderer = self.sceneObj.transform:Find("Camera/Mask"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
      local MPB = CS.UnityEngine.MaterialPropertyBlock()
      MPB:SetColor("_BaseColor", Color.New(MaskColor.r, MaskColor.g, MaskColor.b, MaskColor.a))
      self.MPB = MPB
      self:CreateCompere(self.sceneObj.transform:Find("CompereParent/monika_zhuchiren"))
      self.allyParent = self.sceneObj.transform:Find("AllyParent")
      self:CreateAllyDict()
      self.progressCtrl:OnEnter()
      callback(self.sceneObj)
    end)
  elseif self.sceneObj then
    self.manager:RefreshScene()
    if callback then
      callback(self.sceneObj)
    end
  end
end

function AllianceStarCeremonyScene:RefreshSceneByData()
  if self.manager.ceremonyInfo then
    self:ChangeState(self.manager.ceremonyInfo)
  end
  if self.manager.allyInfoDict then
    for k, v in pairs(self.manager.allyInfoDict) do
      self:AddAlly(v)
    end
  end
end

function AllianceStarCeremonyScene:CreateCompere(gameObject)
  if self.compere ~= nil then
    self.compere:Delete()
  end
  self.compere = Compere.New()
  local compereParam = {}
  compereParam.gameObject = gameObject
  self.compere:Init(compereParam)
end

function AllianceStarCeremonyScene:CreateWinner(param)
  if self.winner ~= nil then
    self.winner:Delete()
  end
  self.winner = Winner.New()
  self.winner:Init(param)
end

function AllianceStarCeremonyScene:AddAlly(allyInfo)
  if self.allyParent == nil or allyInfo == nil or #self.freeAllyPoints == 0 then
    return
  end
  local idx = #self.freeAllyPoints
  local point = table.remove(self.freeAllyPoints, idx)
  if point then
    local param = {}
    param.prefabPath = AllyPrefabPath
    param.parent = point
    local ally = self.allyDict[point]
    ally:Init(param)
    ally:RefreshAllyInfo(allyInfo)
    self.manager.LogError("AddAlly: " .. allyInfo.uid)
  end
end

function AllianceStarCeremonyScene:RemoveAllyByInfo(allyInfo)
  local ally = allyInfo:GetAlly()
  self:RemoveAlly(ally)
  self.manager.LogError("RemoveAllyByInfo: " .. allyInfo.uid)
end

function AllianceStarCeremonyScene:RemoveAlly(ally)
  if ally and ally:GetPoint() then
    table.insert(self.freeAllyPoints, ally:GetPoint())
    ally:Delete()
  end
end

function AllianceStarCeremonyScene:CreateAllyDict()
  if self.allyDict then
    for k, v in pairs(self.allyDict) do
      self:RemoveAlly(v)
      ObjectPool:GetInstance():Save(v)
    end
    self.allyDict = nil
  end
  self.allyDict = {}
  self.freeAllyPoints = {}
  for i = self.allyParent.childCount - 1, 0, -1 do
    local point = self.allyParent:GetChild(i)
    self.allyDict[point] = ObjectPool:GetInstance():Load(Ally)
    self.allyDict[point]:SetIndex(i + 1)
    table.insert(self.freeAllyPoints, point)
  end
end

function AllianceStarCeremonyScene:GetFreeAllyBubblePos(screenRTRect)
  local freeBubbleAllys = {}
  local canPopAllyIndexDict = self.manager:GetCanPopAllyIndexDict()
  for k, v in pairs(self.allyDict) do
    local index = v:GetIndex()
    if v.inited and v.showBubble == false and (canPopAllyIndexDict == nil or index and canPopAllyIndexDict[index]) then
      table.insert(freeBubbleAllys, v)
    end
  end
  local ally, pos
  if 0 < #freeBubbleAllys then
    ally = table.randomArrayValue(freeBubbleAllys)
    pos = self:GetAllyBubblePos(screenRTRect, ally)
  end
  return ally, pos
end

function AllianceStarCeremonyScene:GetAllyBubblePos(screenRTRect, ally)
  local pos = ally:GetPosition()
  pos.y = pos.y + 0.4
  pos = self.camera:WorldToViewportPoint(pos)
  local screenRTSizeW, screenRTSizeH = screenRTRect:Get_sizeDelta()
  pos.x = screenRTSizeW * pos.x - screenRTSizeW * 0.5
  pos.y = screenRTSizeH * pos.y - screenRTSizeH * 0.5
  ally:ShowBubble()
  return pos
end

function AllianceStarCeremonyScene:GetFreeAllyInteractionPos(screenRTRect)
  if self.allyDict == nil then
    return
  end
  local freeInteractionAllys = {}
  local canPopAllyIndexDict = self.manager:GetCanPopAllyIndexDict()
  for k, v in pairs(self.allyDict) do
    local index = v:GetIndex()
    if v.inited and v.showInteractionIcon == false and (canPopAllyIndexDict == nil or index and canPopAllyIndexDict[index]) then
      table.insert(freeInteractionAllys, v)
    end
  end
  local ally, pos
  if 0 < #freeInteractionAllys then
    ally = table.randomArrayValue(freeInteractionAllys)
    pos = ally:GetPosition()
    pos.y = pos.y + 0.4
    pos = self.camera:WorldToViewportPoint(pos)
    local screenRTSizeW, screenRTSizeH = screenRTRect:Get_sizeDelta()
    pos.x = screenRTSizeW * pos.x - screenRTSizeW * 0.5
    pos.y = screenRTSizeH * pos.y - screenRTSizeH * 0.5
    ally:ShowInteractionIcon()
  end
  return ally, pos
end

function AllianceStarCeremonyScene:SetRandomAnimAndDelay(allyRandomAnimInfo)
  self.allyRandomAnimInfo = allyRandomAnimInfo
  for k, v in pairs(self.allyDict) do
    if v.inited then
      v:SetRandomAnimAndDelay(self.allyRandomAnimInfo)
    end
  end
end

function AllianceStarCeremonyScene:ClearRandomAnim()
  self.allyRandomAnimInfo = nil
  if self.allyDict then
    for k, v in pairs(self.allyDict) do
      if v.inited then
        v:ClearRandomAnim()
      end
    end
  end
end

function AllianceStarCeremonyScene:PlayInteractionAnim(msg)
  local animName = AlStarAnimName.Applaud
  if self.allyDict then
    for k, v in pairs(self.allyDict) do
      if v.allyInfo and v.allyInfo.uid == msg.uid then
        v:PlayInteractionAnim(animName)
        break
      end
    end
  end
end

function AllianceStarCeremonyScene:PlayReadPersonRewardAnim()
  local indexList = table.randomArrayValue(AlStarCeremonyReadPersonRewardRandomPoint)
  for i, v in ipairs(indexList) do
    local point = self.allyParent:GetChild(v - 1)
    if point then
      local ally = self.allyDict[point]
      if ally and ally.inited then
        local starInfo = self.ceremonyInfo:GetStarPlayerInfo()
        if starInfo then
          local param = {}
          param.unit = ally
          param.dialogStr = starInfo.name
          ally:PlayReadPersonRewardAnim(AlStarAnimName.Cheer, math.random(0, 1) + math.random(0, 1), param)
        end
      end
    end
  end
end

local DialogType = {
  Random = 1,
  Sequence = 2,
  Custom = 3
}
local DialogParamType = {
  PlayerName = 1,
  ContentAndValue = 2,
  Custom = 3
}

function AllianceStarCeremonyScene:RefreshCompereBubble(template, elapsedTime, stateId, innerStateId)
  self.dialogMode = nil
  self.dialogGroup = nil
  self.nextDialogCD = nil
  self.closeDialogCD = nil
  self.curDialogIndex = nil
  self.curDialogDelay = nil
  self.curDialogTemplate = nil
  if template then
    self.dialogMode = template.dialogMode
    if template.dialogGroup then
      self.dialogGroup = {}
      for i, v in ipairs(template.dialogGroup) do
        table.insert(self.dialogGroup, DataCenter.AllianceStarManager:GetAlStarPlayScriptTemplateInfo(v))
      end
    end
    if self.dialogMode[1] == DialogType.Custom then
      if stateId == self.State.PersonAwards then
        local starTemplate = self.ceremonyInfo:GetTemplateInfo()
        local info = DataCenter.AllianceStarManager:GetCeremonyInteractionInfo(starTemplate:GetInteractionType())
        local level = 1
        if info then
          level = starTemplate:GetLevelByInteractionNum(info.interactionNumber)
        end
        self.dialogMode = DeepCopy(template.dialogMode)
        self.dialogMode[1] = DialogType.Sequence
        self.dialogGroup = {
          self.dialogGroup[level]
        }
      elseif stateId == AlStarCeremonyState.ReadPersonReward and innerStateId == AlStarCeremonyInnerState[AlStarCeremonyState.ReadPersonReward].State5 then
        local starTemplate = self.ceremonyInfo:GetTemplateInfo()
        self.dialogMode = DeepCopy(template.dialogMode)
        self.dialogMode[1] = DialogType.Sequence
        local copyTemplate = DeepCopy(self.dialogGroup[1])
        copyTemplate.dialog = Localization:GetString(starTemplate.content, self.ceremonyInfo:GetStarPlayerScore())
        self.dialogGroup = {copyTemplate}
      end
    end
    if self.dialogMode and #self.dialogMode > 0 and self.dialogGroup and #self.dialogGroup > 0 then
      self.nextDialogCD = template.dialogMode[2] or 5
      self.curDialogDelay = elapsedTime / 1000 % self.nextDialogCD
      if self.dialogMode[1] == DialogType.Random then
        self.curDialogIndex = table.randomKey(self.dialogGroup)
      elseif self.dialogMode[1] == DialogType.Sequence then
        self.curDialogIndex = elapsedTime / 1000 // self.nextDialogCD + 1
      end
      self.curDialogTemplate = self.dialogGroup[self.curDialogIndex]
      if self.curDialogTemplate then
        self.closeDialogCD = self.curDialogTemplate.bubbleStay
      end
    end
  end
  self:CompereBubbleUpdate(0)
end

function AllianceStarCeremonyScene:CompereBubbleUpdate(dt)
  local needBroadcast = dt == 0
  if self.curDialogDelay then
    self.curDialogDelay = self.curDialogDelay + dt
    if self.dialogMode and 0 < #self.dialogMode then
      if self.curDialogDelay >= self.nextDialogCD then
        if self.dialogMode[1] == DialogType.Random then
          self.curDialogIndex = table.randomKey(self.dialogGroup)
        elseif self.dialogMode[1] == DialogType.Sequence then
          self.curDialogIndex = self.curDialogIndex + 1
        end
        self.curDialogTemplate = self.dialogGroup[self.curDialogIndex]
        if self.curDialogTemplate then
          self.curDialogDelay = 0
          self:BroadcastCompereRefreshBubble(self.curDialogTemplate, 0)
        else
          self.curDialogDelay = nil
          self:BroadcastCompereRefreshBubble()
        end
      elseif self.closeDialogCD and self.curDialogDelay >= self.closeDialogCD then
        self:BroadcastCompereRefreshBubble()
      elseif needBroadcast then
        self:BroadcastCompereRefreshBubble(self.curDialogTemplate, self.curDialogDelay)
      end
      needBroadcast = false
    end
  end
  if needBroadcast then
    self:BroadcastCompereRefreshBubble()
  end
end

function AllianceStarCeremonyScene:BroadcastCompereRefreshBubble(dialogTemplate, dialogDelay)
  if dialogTemplate then
    local dialogStr
    if dialogTemplate.type then
      if dialogTemplate.type == DialogParamType.PlayerName then
        local playerInfo = self.manager.ceremonyInfo:GetStarPlayerInfo()
        if playerInfo then
          if not string.IsNullOrEmpty(dialogTemplate.dialog) then
            dialogStr = Localization:GetString(dialogTemplate.dialog, playerInfo.name)
          else
            dialogStr = playerInfo.name
          end
        end
      elseif dialogTemplate.type == DialogParamType.ContentAndValue then
        local content = Localization:GetString(self.manager.ceremonyInfo:GetTemplateInfo().content)
        if not string.IsNullOrEmpty(dialogTemplate.dialog) then
          dialogStr = Localization:GetString(dialogTemplate.dialog, content, self.manager.ceremonyInfo:GetStarPlayerScore())
        end
      elseif dialogTemplate.type == DialogParamType.Custom then
        dialogStr = dialogTemplate.dialog
      elseif not string.IsNullOrEmpty(dialogTemplate.dialog) then
        dialogStr = Localization:GetString(dialogTemplate.dialog)
      end
    else
      dialogStr = Localization:GetString(dialogTemplate.dialog)
    end
    local animName = dialogTemplate.animation
    if self.compere and not string.IsNullOrEmpty(animName) and dialogDelay then
      local animLength = self.compere:GetAnimLength(animName)
      local progress = math.min(dialogDelay / animLength, 1)
      self.compere:PlaySampleAnimationAtTime(animName, progress, 1)
      self.compere:CrossFadeQueued("idle", 0.2, CS.UnityEngine.QueueMode.CompleteOthers)
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyCompereRefreshBubble, {
      dialogStr = dialogStr,
      dialogDelay = dialogDelay,
      dialogTemplate = dialogTemplate
    })
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyCompereRefreshBubble)
  end
end

function AllianceStarCeremonyScene:SetMaskRendererAlpha(alpha)
  if self.maskRenderer and self.MPB then
    self.MPB:SetColor("_BaseColor", Color.New(MaskColor.r, MaskColor.g, MaskColor.b, alpha))
    self.maskRenderer:SetPropertyBlock(self.MPB)
  end
end

function AllianceStarCeremonyScene:ClearMPB()
  if self.maskRenderer and self.MPB then
    self.MPB:SetColor("_BaseColor", Color.New(MaskColor.r, MaskColor.g, MaskColor.b, MaskColor.a))
    self.maskRenderer:SetPropertyBlock(nil)
  end
end

function AllianceStarCeremonyScene:IsInState(state, innerState)
  if self.curState == state and self.fsm and self.fsm.currState and self.fsm.currState.curState == innerState then
    return true
  end
  return false
end

return AllianceStarCeremonyScene
