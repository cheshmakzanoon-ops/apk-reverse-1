local Resource = CS.GameEntry.Resource
local CitySpaceManTrigger = typeof(CS.CitySpaceManTrigger)
local Const = require("Scene.PVEBattleLevel.Const")
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local CutStateCount = 6
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local SuperTextMeshType = typeof(CS.SuperTextMesh)
local SpriteRendererType = typeof(CS.UnityEngine.SpriteRenderer)
local TriggerPointCollection = BaseClass("TriggerPointCollection")

function TriggerPointCollection:__init(triggerPoint, origPos)
  self.triggerPoint = triggerPoint
  self.origPos = origPos
  self.m_gameObject = nil
  self.m_cutState = nil
  self.m_cutStateObj = {}
  self.m_cutStateAnim = {}
  self.c_resType = Const.CityCutResType.HeroExp
  self.m_curBloodNum = triggerPoint:GetMaxBlood()
  self.c_maxBloodNum = triggerPoint:GetMaxBlood()
  local expCount = triggerPoint:GetCollectExpCount()
  local cutOneCount = math.floor(expCount / CutStateCount)
  self.flyCount = {}
  for i = 1, CutStateCount - 1 do
    self.flyCount[i] = cutOneCount
  end
  self.flyCount[CutStateCount] = expCount - (CutStateCount - 1) * cutOneCount
  self.flyParticles = {}
  self.flyTexts = {}
  self.m_blockList = {}
end

function TriggerPointCollection:__delete()
end

function TriggerPointCollection:BindGameObject(obj)
  self.m_gameObject = obj
  local trigger = self.m_gameObject:GetComponentInChildren(CitySpaceManTrigger)
  if trigger ~= nil then
    trigger.ObjectId = self.triggerPoint:GetObjId()
    trigger.resType = self.c_resType
  end
  local t = self.m_gameObject.transform:Find("Collider")
  if t then
    self.m_colliderGO = t.gameObject
    self.m_colliderGO:SetActive(true)
  end
  self:InitModelAni()
end

function TriggerPointCollection:GetCurModelIndex()
  local maxBlood = self.c_maxBloodNum
  local curBlood = self.m_curBloodNum
  local cutBlood = maxBlood - curBlood
  local _index = math.floor(cutBlood / maxBlood * table.count(self.m_cutStateObj)) + 1
  return _index
end

local stateTable = {
  "state01",
  "state02",
  "state03",
  "state04",
  "state05",
  "state06"
}

local function getStateString(k)
  if 1 <= k and k <= #stateTable then
    return stateTable[k]
  end
  local modelPath = "state0" .. tostring(k)
  return modelPath
end

function TriggerPointCollection:InitModelAni()
  local _modelIndex = self:GetCurModelIndex()
  local transform = self.m_gameObject.transform
  for k = 1, CutStateCount do
    local modelPath = getStateString(k)
    local trans = transform:Find(modelPath)
    if trans ~= nil then
      self.m_cutStateObj[k] = trans.gameObject
      local simpleAnimation = trans:GetComponentInChildren(SimpleAnimationType)
      if simpleAnimation ~= nil then
        self.m_cutStateAnim[k] = simpleAnimation
      end
      if k == _modelIndex then
        self.m_cutStateObj[k]:SetActive(true)
      else
        self.m_cutStateObj[k]:SetActive(false)
      end
    end
  end
end

function TriggerPointCollection:RefreshCurState()
  for _, v in pairs(self.m_cutStateObj) do
    v:SetActive(false)
  end
  local _modelIndex = self:GetCurModelIndex()
  if self.m_cutStateObj[_modelIndex] then
    self.m_cutStateObj[_modelIndex]:SetActive(true)
  end
  if _modelIndex <= CutStateCount and self.m_cutStateAnim[_modelIndex] ~= nil then
    self.m_cutStateAnim[_modelIndex]:Play("dig")
  end
  if self.m_colliderGO then
    if self.m_curBloodNum > 0 then
      self.m_colliderGO:SetActive(true)
    else
      self.m_colliderGO:SetActive(false)
      self.triggerPoint.battleLevel:RemoveOneArrowByPos(self.origPos)
    end
  end
end

function TriggerPointCollection:PlayResSound()
  if self.c_resType == Const.CityCutResType.HeroExp then
    DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSulphur), false)
  end
end

function TriggerPointCollection:OnCutOnce(attack)
  if self.m_curBloodNum <= 0 then
    return
  end
  for i = 1, attack do
    self.m_curBloodNum = self.m_curBloodNum - 1
    self:ShowExpRefresh()
  end
  self:RefreshCurState()
  self:PlayResSound()
  self:FlyParticle()
end

function TriggerPointCollection:FlyParticle()
  local particlePath = ""
  if self.c_resType == Const.CityCutResType.HeroExp then
    particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_tuohuang_shuijingcaiji.prefab"
  end
  if particlePath == "" then
    return
  end
  local particleInst = Resource:InstantiateAsync(particlePath)
  particleInst:completed("+", function(req)
    local p = self.m_gameObject.transform.position
    req.gameObject.transform:Set_position(p.x, p.y, p.z)
    local particle = req.gameObject:GetComponent(TypeOfParticleSystem)
    particle:Simulate(0)
    particle:Play()
  end)
  local destroyTimer = TimerManager:GetInstance():GetTimer(0.6, function()
    particleInst:Destroy()
    self.flyParticles[particleInst] = nil
  end, nil, true, false, false)
  destroyTimer:Start()
  self.flyParticles[particleInst] = destroyTimer
end

function TriggerPointCollection:GetBloodLeftCnt(n)
  self.m_curBloodNum = math.max(self.m_curBloodNum, 0)
  return self.m_curBloodNum
end

function TriggerPointCollection:OnUpdate()
  for _, v in pairs(self.m_blockList) do
    local r = 1000 * Time.deltaTime
    if v.transform then
      v.transform:Rotate(0, r, 0)
    end
  end
  for t, v in pairs(self.flyTexts) do
    if t.gameObject ~= nil then
      t.gameObject.transform.rotation = self.triggerPoint.battleLevel:GetCameraRotation()
    end
  end
end

function TriggerPointCollection:Destroy()
  if self.flyParticles then
    for p, t in pairs(self.flyParticles) do
      p:Destroy()
      t:Stop()
    end
    self.flyParticles = nil
  end
  if self.flyTexts then
    for p, t in pairs(self.flyTexts) do
      p:Destroy()
      t:Stop()
    end
    self.flyTexts = nil
  end
  if self.m_blockList then
    for p, _ in pairs(self.m_blockList) do
      p:Destroy()
    end
    self.m_blockList = nil
  end
end

function TriggerPointCollection:ShowFlyBox()
end

function TriggerPointCollection:GetFlyNode()
  if self.m_flyNode == nil then
    local nodePath = "flynode"
    local nodeObject = self.m_gameObject.transform:Find(nodePath)
    if nodeObject then
      self.m_flyNode = nodeObject.gameObject
    end
  end
  return self.m_flyNode
end

function TriggerPointCollection:ShowFlyResAnim(attack)
  local flyIndex = self.c_maxBloodNum - self.m_curBloodNum
  local t = self.c_resType
  local flyTextInst = Resource:InstantiateAsync(UIAssets.CitySpaceManFlyText)
  flyTextInst:completed("+", function(req)
    local flyNode = self:GetFlyNode()
    if flyNode then
      local req_trans = req.gameObject.transform
      req_trans.position = flyNode.transform.position
      local num = req_trans:Find("num"):GetComponent(SuperTextMeshType)
      num.text = "+" .. attack
      local spr = req_trans:Find("num/icon"):GetComponent(SpriteRendererType)
      local sprImage = Const.ResTypeIconPath[Const.CityCutResType.Stone]
      spr:LoadSprite(sprImage)
    end
  end)
  local destroyTimer = TimerManager:GetInstance():GetTimer(0.8, function()
    flyTextInst:Destroy()
    self.flyTexts[flyTextInst] = nil
  end, nil, true, false, false)
  destroyTimer:Start()
  self.flyTexts[flyTextInst] = destroyTimer
end

function TriggerPointCollection:ShowExpRefresh()
  local flyIndex = self.c_maxBloodNum - self.m_curBloodNum
  local count = self.flyCount[flyIndex]
  EventManager:GetInstance():Broadcast(EventId.AddExpFromScene, count)
end

return TriggerPointCollection
