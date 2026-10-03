local Resource = CS.GameEntry.Resource
local MaxState = 10
local TriggerPointBuild = BaseClass("TriggerPointBuild")

function TriggerPointBuild:__init(triggerPoint)
  self.triggerPoint = triggerPoint
  self.stateList = {}
  self.currState = 1
  self.buildInst = nil
  self.gameObject = nil
  self.stateAni = {}
  self.stateParticle = {}
  self.playSound = false
end

function TriggerPointBuild:__delete()
end

function TriggerPointBuild:Create(buildName, onComplete)
  local buildPath = "Assets/Main/Prefabs/PVELevel/" .. buildName .. ".prefab"
  if buildName == "TriggerBuild_hj" then
    self.playSound = true
  else
    self.playSound = false
  end
  self.buildInst = Resource:InstantiateAsync(buildPath)
  self.buildInst:completed("+", function()
    self.gameObject = self.buildInst.gameObject
    local transform = self.gameObject.transform
    local showPos = self.triggerPoint:GetTilePos() or self.triggerPoint:GetShowPos()
    if showPos then
      local p = SceneUtils.TileToWorld(showPos)
      transform:Set_position(p.x, p.y, p.z)
      transform.localRotation = Quaternion.identity
    end
    local stateList = self.stateList
    for i = 1, MaxState do
      local state = transform:Find("State/state0" .. i)
      if state == nil then
        break
      end
      stateList[#stateList + 1] = state.gameObject
      local anis = state.gameObject:GetComponentsInChildren(typeof(CS.SimpleAnimation), true)
      local aniList = self.stateAni[i] or {}
      for i = 0, anis.Length - 1 do
        aniList[#aniList + 1] = anis[i]
      end
      self.stateAni[i] = aniList
      local particles = state.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem), true)
      local parList = self.stateParticle[i] or {}
      for i = 0, particles.Length - 1 do
        parList[#parList + 1] = particles[i]
      end
      self.stateParticle[i] = parList
      state.gameObject:SetActive(false)
    end
    if 1 <= #stateList then
      stateList[self.currState]:SetActive(true)
    end
    if onComplete then
      onComplete()
    end
  end)
end

function TriggerPointBuild:Destroy()
  if self.buildInst then
    self.buildInst:Destroy()
    self.buildInst = nil
  end
end

function TriggerPointBuild:ChangeState(state)
  if not self.buildInst.isDone then
    Logger.LogError("TriggerPointBuild not load ok, " .. tostring(self.triggerPoint:GetTriggerId()))
    return
  end
  if self.currState == state then
    return
  end
  self.stateList[self.currState]:SetActive(false)
  self.stateList[state]:SetActive(true)
  self.currState = state
  if state == 4 and self.playSound == true then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Rocket, false)
  end
  local aniList = self.stateAni[state]
  if aniList then
    for _, a in ipairs(aniList) do
      a:Play("Default")
    end
  end
  local parList = self.stateParticle[state]
  if parList then
    for _, p in ipairs(parList) do
      p:Simulate(0)
      p:Play()
    end
  end
end

function TriggerPointBuild:GetCurrState()
  return self.currState
end

function TriggerPointBuild:GetStateCount()
  return #self.stateList
end

return TriggerPointBuild
