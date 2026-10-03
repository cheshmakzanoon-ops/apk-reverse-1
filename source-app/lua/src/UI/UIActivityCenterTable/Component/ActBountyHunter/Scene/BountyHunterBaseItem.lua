local BountyHunterBaseItem = BaseClass("BountyHunterBaseItem")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger

local function __init(self, scene)
  self.isLoadFinish = false
  self.allBehaviourStateDic = {}
  self.curState = nil
  self.scene = scene
  self:Init()
end

local function __delete(self)
  self.isLoadFinish = nil
  self.allBehaviourStateDic = nil
  self.curState = nil
end

function BountyHunterBaseItem:Init(itemName)
  self.itemName = itemName
  self.allBehaviourStateDic = {}
end

function BountyHunterBaseItem:RegisterBehaviourState(behaviourStateType, behaviourState)
  if table.containsKey(self.allBehaviourStateDic, behaviourStateType) then
    return
  end
  self.allBehaviourStateDic[behaviourStateType] = behaviourState
  behaviourState:OnRegister(behaviourStateType, self)
end

function BountyHunterBaseItem:GetCurBehaviourState()
  return self.curState
end

function BountyHunterBaseItem:ChangeBehaviourState(behaviourStateType, ...)
  if not self.allBehaviourStateDic then
    return
  end
  if not table.containsKey(self.allBehaviourStateDic, behaviourStateType) then
    return
  end
  local targetState = self.allBehaviourStateDic[behaviourStateType]
  if not targetState then
    return
  end
  if self.curState and self.curState.CheckIsCanExitState and not self.curState:CheckIsCanExitState(behaviourStateType) then
    return
  end
  if self.curState and self.curState.stateType == behaviourStateType then
    self.curState:OnExecute(...)
    return
  end
  if self.curState then
    self.curState:OnExit()
  end
  self.curState = targetState
  self.curState:OnEnter(...)
end

function BountyHunterBaseItem:LoadModel(path, parent, initLocalPos, initRotation, scale, callback)
  if string.IsNullOrEmpty(path) then
    Logger.LogError("path is null!")
    return
  end
  if self.loadModelReq then
    if self.loadModelReq.gameObject and callback then
      callback()
    else
      Logger.LogError("mode is loading")
    end
    return
  end
  self.callback = callback
  self.isLoadFinish = false
  self.loadModelReq = Resource:InstantiateAsync(path)
  self.loadModelReq:completed("+", function(req)
    if req.isError then
      Logger.LogError("bounty hunter act model load fail")
      return
    end
    self.transform = req.gameObject.transform
    self.transform:Set_localScale(1, 1, 1)
    if parent then
      self.transform:SetParent(parent.transform)
    end
    if initLocalPos then
      self.transform:Set_localPosition(initLocalPos.x, initLocalPos.y, initLocalPos.z)
    else
      self.transform:Set_localPosition(0, 0, 0)
    end
    if initRotation then
      self.transform:Set_localRotation(initRotation.x, initRotation.y, initRotation.z, 1)
    else
      self.transform:Set_localRotation(0, 0, 0, 1)
    end
    if scale then
      self.transform:Set_localScale(scale, scale, scale)
    end
    self.transform.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    self.simpleAni = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.isLoadFinish = true
    self.modelHeight = 0
    local modelHeightCom = self.transform:GetComponentInChildren(typeof(CS.ModelHeight))
    if modelHeightCom then
      self.modelHeight = modelHeightCom:GetHeight() or 0
    end
    self:OnModelLoadFinish()
  end)
end

function BountyHunterBaseItem:OnModelLoadFinish()
  if self.callback then
    self.callback()
  end
end

function BountyHunterBaseItem:Destroy()
  if self.loadModelReq then
    self.loadModelReq:Destroy()
    self.loadModelReq = nil
  end
  self.callback = nil
  self.bHunterClickBtn = nil
  self.transform = nil
  self.isLoadFinish = nil
  if self.allBehaviourStateDic then
    for _, v in pairs(self.allBehaviourStateDic) do
      v:OnRemove()
    end
    self.allBehaviourStateDic = nil
  end
  self.itemName = nil
end

function BountyHunterBaseItem:PlayAni(aniName)
  if not self.simpleAni or string.IsNullOrEmpty(aniName) then
    return
  end
  return self:PlayAnimationReturnTime(self.simpleAni, aniName)
end

function BountyHunterBaseItem:CrossFade(aniName, fadeLength)
  if not self.simpleAni or string.IsNullOrEmpty(aniName) then
    return false
  end
  local anim = self.simpleAni:GetState(aniName)
  if anim == nil then
    return false
  end
  if self.simpleAni:IsPlaying(aniName) then
    self.simpleAni:Rewind(aniName)
  else
    self.simpleAni:Stop()
    self.simpleAni:CrossFade(aniName, fadeLength or 0.2)
  end
  return true
end

function BountyHunterBaseItem:GetClipLength(animName)
  if not self.simpleAni or string.IsNullOrEmpty(animName) then
    return 0
  end
  return self.simpleAni:GetClipLength(animName)
end

function BountyHunterBaseItem:PlayAnimationReturnTime(simpleAni, animName)
  local anim = simpleAni:GetState(animName)
  if anim == nil then
    return false, 1
  end
  if simpleAni:IsPlaying(animName) then
    simpleAni:Rewind(animName)
  else
    simpleAni:Play(animName)
  end
  return true, simpleAni:GetClipLength(animName)
end

function BountyHunterBaseItem:GetAniTime(aniName)
  if not self.simpleAni then
    return 0
  end
  local anim = self.simpleAni:GetState(aniName)
  if anim == nil then
    return 0
  end
  return self.simpleAni:GetClipLength(aniName)
end

function BountyHunterBaseItem:BlindClickItem(clickBtn)
  self.bHunterClickBtn = clickBtn
  self:ShowHunterLog(string.format("start BlindClickItem uuid : %s", self.uuid))
end

function BountyHunterBaseItem:RemoveClickItem()
  self.bHunterClickBtn = nil
  self:ShowHunterLog(string.format("remove BlindClickItem uuid : %s", self.uuid))
end

function BountyHunterBaseItem:UpdateClickBtnPos(sceneCamera, rtRowWidth, rtRowHeight)
  if not (self.bHunterClickBtn and self.bHunterClickBtn.rectTransform and self.transform) or not sceneCamera then
    return
  end
  local worldPos = self.transform.position
  local offset = Vector3(0, self.modelHeight / 2, 0)
  local viewPortPos = sceneCamera:WorldToViewportPoint(worldPos + offset)
  local localPos = Vector2.New(rtRowWidth * viewPortPos.x, rtRowHeight * viewPortPos.y)
  self.bHunterClickBtn.rectTransform:Set_anchoredPosition(localPos.x, localPos.y)
  if self.bHunterClickBtn.rectTransform.name == "clickBtn" then
  end
end

function BountyHunterBaseItem:GenOneEff(effPath, parent, worldPos, initRotation, callback)
  if string.IsNullOrEmpty(effPath) then
    return
  end
  local effLoadReq = Resource:InstantiateAsync(effPath)
  effLoadReq:completed("+", function(req)
    if req.isError then
      return
    end
    local transform = effLoadReq.gameObject.transform
    if parent then
      transform:SetParent(parent.transform)
    end
    transform:Set_localScale(1, 1, 1)
    if worldPos then
      transform.position = worldPos
    else
      transform.localPosition = ResetPosition
    end
    if initRotation then
      transform:Set_localRotation(initRotation.x, initRotation.y, initRotation.z, 1)
    else
      transform:Set_localRotation(0, 0, 0, 1)
    end
    if callback then
      callback()
    end
  end)
  return effLoadReq
end

function BountyHunterBaseItem:ShowHunterLog(info)
end

function BountyHunterBaseItem:SetActive(value)
  if IsNotNull(self.transform) then
    self.transform.gameObject:SetActive(value)
  end
end

BountyHunterBaseItem.__init = __init
BountyHunterBaseItem.__delete = __delete
return BountyHunterBaseItem
