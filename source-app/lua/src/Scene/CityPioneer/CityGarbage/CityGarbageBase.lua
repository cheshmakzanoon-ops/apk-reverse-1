local Resource = CS.GameEntry.Resource
local CityGarbageBase = BaseClass("CityGarbageBase")
local CityGarbagePath = "Assets/Main/Prefabs/Garbage/"
local CitySpaceManTrigger = typeof(CS.CitySpaceManTrigger)
local Const = require("Scene.CityPioneer.Const")
local CityResConfig = typeof(CS.CityResConfig)
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local CutStateCount = 6
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local SuperTextMeshType = typeof(CS.SuperTextMesh)
local SpriteRendererType = typeof(CS.UnityEngine.SpriteRenderer)

function CityGarbageBase:__init(pointId, modelObjectType)
  self.m_instance = nil
  self.m_gameObject = nil
  self.m_cutState = nil
  self.m_cutStateObj = {}
  self.m_cutStateAnim = {}
  self.m_pointId = pointId
  self.m_modelObjectType = modelObjectType
  self._lastHitTime = 0
  self.c_resType = Const.CityCutResType.Stone
  self.c_rewardNum = 6
  self.c_refreshCD = 20
  self.m_curBloodNum = 6
  self.c_maxBloodNum = 6
  self.m_update = nil
  self.flyParticles = {}
  self.m_blockList = {}
  CityGarbageManager:GetInstance():AddGarbage(self)
end

function CityGarbageBase:__delete()
  CityGarbageManager:GetInstance():RemoveGarbage(self)
end

function CityGarbageBase:BindGameObject(uuid, obj)
  self.m_gameObject = obj
  local data = obj.gameObject:GetComponent(CityResConfig)
  if data ~= nil then
    self.c_resType = data.resType
    self.c_maxBloodNum = data.maxBlood
    self.m_curBloodNum = self.c_maxBloodNum
    self.c_refreshCD = data.refreshCd
  else
    Logger.LogError("CityResConfig not found!")
  end
  self._lastHitTime = UITimeManager:GetInstance():GetServerSeconds()
  local trigger = self.m_gameObject:GetComponentInChildren(CitySpaceManTrigger)
  if trigger ~= nil then
    trigger.ObjectId = uuid
    trigger.resType = self.c_resType or 0
  end
  local t = self.m_gameObject.transform:Find("Collider")
  if t then
    self.m_colliderGO = t.gameObject
  end
  self:InitModelAni()
end

function CityGarbageBase:CreateGameObject()
end

function CityGarbageBase:GetCurModelIndex()
  local _index = self.c_maxBloodNum - self.m_curBloodNum
  _index = _index < 0 and 0 or _index
  _index = _index > self.c_maxBloodNum and self.c_maxBloodNum or _index
  return _index + 1
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

function CityGarbageBase:InitModelAni()
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

function CityGarbageBase:RefreshCurState()
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
    end
  end
end

function CityGarbageBase:PlayResSound()
  if self.c_resType == Const.CityCutResType.Stone then
    DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerRock), false)
  elseif self.c_resType == Const.CityCutResType.Crystal then
    DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSulphur), false)
  elseif self.c_resType == Const.CityCutResType.GreenCrystal then
    DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSulphur), false)
  elseif self.c_resType == Const.CityCutResType.Cactus then
    DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerCactus), false)
  end
end

function CityGarbageBase:OnCutOnce()
  if self.m_curBloodNum <= 0 then
    return
  end
  self._lastHitTime = UITimeManager:GetInstance():GetServerSeconds()
  self.m_curBloodNum = self.m_curBloodNum - 1
  self:RefreshCurState()
  self:ShowFlyResAnim()
  self:ShowFlyBox()
  self:PlayResSound()
  self:FlyParticle()
  local oriPos = SceneUtils.TileIndexToWorld(SceneUtils.WorldToTileIndex(self.m_gameObject.transform.position))
  DataCenter.CityPioneerYellowArrowManager:RemoveOneArrowByPos(oriPos)
end

function CityGarbageBase:FlyParticle()
  local particlePath = ""
  if self.c_resType == Const.CityCutResType.Stone then
    particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_shitoucaiji.prefab"
  elseif self.c_resType == Const.CityCutResType.Crystal then
    particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_tuohuang_shuijingcaiji.prefab"
  elseif self.c_resType == Const.CityCutResType.GreenCrystal then
    particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_tuohuang_shuijingcaiji.prefab"
  elseif self.c_resType == Const.CityCutResType.Cactus then
    particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
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

function CityGarbageBase:OnResetRes()
  self.m_curBloodNum = self.c_maxBloodNum
  self:RefreshCurState()
end

function CityGarbageBase:GetBloodLeftCnt(n)
  self.m_curBloodNum = math.max(self.m_curBloodNum, 0)
  return self.m_curBloodNum
end

function CityGarbageBase:OnUpdate()
  self:CheckRecover()
  for _, v in ipairs(self.m_blockList) do
    local r = 1000 * Time.deltaTime
    local t = CS.UnityEngine.Space.World
    v:Rotate(0, r, 0)
  end
end

function CityGarbageBase:CheckRecover()
  if self.m_curBloodNum == self.c_maxBloodNum or self.c_refreshCD <= 0 then
    return
  end
  if UITimeManager:GetInstance():GetServerSeconds() - self._lastHitTime > self.c_refreshCD then
    self.m_curBloodNum = self.c_maxBloodNum
    self:OnResetRes()
  end
end

function CityGarbageBase:Destroy()
  if self.carryInst ~= nil then
    self.carryInst:Destroy()
  end
end

function CityGarbageBase:GetType()
  return self.type
end

function CityGarbageBase:ShowFlyBox()
  local restype = self.c_resType
  local resPath = Const.ResTypeFlyPrefabPath[restype]
  if string.IsNullOrEmpty(resPath) then
    return
  end
  local boxInst = Resource:InstantiateAsync(resPath)
  boxInst:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local obj = CitySpaceMan:GetInstance():GetInstantiateObj()
    if obj == nil then
      return
    end
    local desPosPath = "A_soldie_ben/sold_point"
    local destPos = obj.transform:Find(desPosPath)
    local go_transform = _go.transform
    go_transform.position = self.m_gameObject.transform.position
    go_transform:Set_localScale(2.5, 2.5, 2.5)
    self.m_blockList[#self.m_blockList + 1] = go_transform
    local flyControl = _go:GetComponent(typeof(CS.UIGoodsFly))
    flyControl:DoAnimBox(1, 1, go_transform.position, destPos.transform.position, function()
      CS.UnityEngine.GameObject.Destroy(_go)
      table.removebyvalue(self.m_blockList, go_transform)
    end)
  end)
end

function CityGarbageBase:GetFlyNode()
  if self.m_flyNode == nil then
    local nodePath = "flynode"
    local nodeObject = self.m_gameObject.transform:Find(nodePath)
    if nodeObject then
      self.m_flyNode = nodeObject.gameObject
    end
  end
  return self.m_flyNode
end

function CityGarbageBase:ShowFlyResAnim()
  local t = self.c_resType
  local flyTextInst = Resource:InstantiateAsync(UIAssets.CitySpaceManFlyText)
  flyTextInst:completed("+", function(req)
    local flyNode = self:GetFlyNode()
    if flyNode then
      local req_trans = req.gameObject.transform
      req_trans.position = flyNode.transform.position
      local num = req_trans:Find("num"):GetComponent(SuperTextMeshType)
      num.text = "+1"
      local spr = req_trans:Find("num/icon"):GetComponent(SpriteRendererType)
      local sprImage = Const.ResTypeIconPath[t] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
      spr:LoadSprite(sprImage)
      CS.UnityEngine.GameObject.Destroy(req.gameObject, 0.8)
    end
  end)
end

return CityGarbageBase
