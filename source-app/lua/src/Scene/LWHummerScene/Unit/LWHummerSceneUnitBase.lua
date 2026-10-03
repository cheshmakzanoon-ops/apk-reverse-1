local LWHummerSceneUnitBase = BaseClass("LWHummerSceneUnitBase")
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local CSCitySpaceManTrigger = CS.CitySpaceManTrigger
local CSUnityEngineCollider = CS.UnityEngine.Collider
local Resource = CS.GameEntry.Resource
local Time = _ENV.Time

function LWHummerSceneUnitBase:__init(param, loadResCallback)
  self.layerMask = 4294967295
  self:Init(param, loadResCallback)
end

function LWHummerSceneUnitBase:Init(param, loadResCallback)
  self.isLoaded = false
  self.loadResCallback = loadResCallback
  self.getPosCurFrame = 0
  self:InitBase(param)
  self:Load()
end

function LWHummerSceneUnitBase:__delete()
  self:OnDestroy()
end

function LWHummerSceneUnitBase:OnDestroy()
  if self.colliderComponent then
    self.colliderComponent:Destroy()
    self.colliderComponent = nil
  end
  if self.handle ~= nil then
    self.handle:Destroy()
    self.handle = nil
  end
  self.citySpaceManTrigger = nil
  self.gameObject = nil
  self.transform = nil
end

function LWHummerSceneUnitBase:ReInit(param, loadResCallback)
  if param.bornData.prefabPath ~= self.bornData.prefabPath then
    self:OnDestroy()
    self:Init(param, loadResCallback)
  else
    self:InitBase(param)
    self:InitTransform()
    self:OnInited()
    if loadResCallback then
      loadResCallback(self)
    end
  end
end

function LWHummerSceneUnitBase:Recycle()
  self.active = false
  self:SetHide()
end

function LWHummerSceneUnitBase:InitBase(param)
  self.sceneRoot = param.sceneRoot
  self.logic = param.logic
  self.stage = self.logic.data.stage
  self.bornData = param.bornData
  self.guid = param.guid
  self.unitType = param.unitType
  self.curPos = Vector3.New(0, 0, 0)
  self.active = true
end

function LWHummerSceneUnitBase:Load()
  local prefabPath = self.bornData.prefabPath
  self.handle = Resource:InstantiateAsync(prefabPath)
  self.handle:completed("+", function(request)
    if not self.logic or not self.logic.inLogic then
      request:Destroy()
      return
    end
    self.gameObject = self.handle.gameObject
    self.transform = self.gameObject.transform
    self:OnResLoaded()
  end)
end

function LWHummerSceneUnitBase:OnResLoaded()
  self.isLoaded = true
  self:InitTransform()
  self:InitComponent()
  self:OnInited()
  if self.loadResCallback then
    self.loadResCallback(self)
    self.loadResCallback = nil
  end
end

function LWHummerSceneUnitBase:InitTransform()
  self.transform:SetParent(self.sceneRoot)
  local pos = self.bornData.pos
  self:SetPosition(pos.x, pos.z)
  self.transform:Set_localEulerAngles(0, 0, 0)
  self:SetShow()
end

function LWHummerSceneUnitBase:InitComponent()
  if self.transform then
    if not self.colliderComponent then
      self.collider = self.transform:GetComponentInChildren(typeof(CSUnityEngineCollider))
      if self.collider then
        self.colliderComponent = ColliderComponent.New()
        self.colliderComponent:InitCollider(self.collider.transform, 10, self.layerMask)
        
        local function onCollisionHandler(colliderCnt, colliderComponentArray)
          self:OnCollision(colliderCnt, colliderComponentArray)
        end
        
        self.colliderComponent:SetOnCollide(onCollisionHandler)
      end
    end
    if not self.citySpaceManTrigger then
      self.citySpaceManTrigger = self.transform:GetComponentInChildren(typeof(CSCitySpaceManTrigger))
    end
    if not self.anim then
      self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    end
  end
end

function LWHummerSceneUnitBase:OnCollision(colliderCnt, colliderComponentArray)
  for i = 0, colliderCnt - 1 do
    local other = colliderComponentArray[i]
    local trigger = other:GetComponent(typeof(CSCitySpaceManTrigger))
    if trigger ~= nil and other.transform ~= self.colliderComponent.transform then
      self:OnCollisionPlayer(other, trigger)
    end
  end
end

function LWHummerSceneUnitBase:OnCollisionPlayer(other, trigger)
end

function LWHummerSceneUnitBase:SetHide()
  if self.gameObject then
    self.gameObject:SetActive(false)
    if self.colliderComponent then
      self.colliderComponent.active = false
    end
  end
end

function LWHummerSceneUnitBase:SetShow()
  if self.gameObject then
    self.gameObject:SetActive(true)
    if self.colliderComponent then
      self.colliderComponent.active = true
    end
  end
end

function LWHummerSceneUnitBase:OnUpdate(dt)
  if self.colliderComponent then
    self.colliderComponent:CollisionDetect()
  end
end

local function CheckAnimName(anim, name)
  if anim == nil or name == nil then
    return nil
  end
  local state = anim:GetState(name)
  if state ~= nil then
    return name
  end
  if name == "death" then
    state = anim:GetState("dead")
    if state ~= nil then
      return "dead"
    end
  end
  if name == "dead" then
    state = anim:GetState("death")
    if state ~= nil then
      return "death"
    end
  end
  return nil
end

function LWHummerSceneUnitBase:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.curAnimName = theAnimName
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function LWHummerSceneUnitBase:BlendSimpleAnim(name, targetWeight)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:Blend(theAnimName, targetWeight, 0)
  end
end

function LWHummerSceneUnitBase:CrossFadeSimpleAnim(name, fadeLength)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:CrossFade(theAnimName, fadeLength)
  end
end

function LWHummerSceneUnitBase:GetAnimLength(name)
  if self.anim then
    self.anim:SetStateSpeed(name, 1)
    return self.anim:GetClipLength(name)
  else
    return 0
  end
end

function LWHummerSceneUnitBase:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  if self.transform then
    self.transform:Set_position(x, 0, z)
  end
end

function LWHummerSceneUnitBase:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curPos
  end
  self.getPosCurFrame = curFrame
  if self.transform then
    local x, y, z = self.transform:Get_position()
    self.curPos.x = x
    self.curPos.z = z
  end
  return self.curPos
end

function LWHummerSceneUnitBase:OnInited()
  if self.citySpaceManTrigger then
    self.citySpaceManTrigger.ObjectId = self.guid
  end
end

function LWHummerSceneUnitBase:GetPoolName()
  return self.unitType .. self.bornData.prefabPath
end

function LWHummerSceneUnitBase:PlayReplayableEffect(path, pos, rot, time, transform, type)
  if not string.IsNullOrEmpty(path) then
    local id = self.logic:ShowEffectObj(path, pos, rot, time, transform, type)
  end
end

function LWHummerSceneUnitBase:OnBulletHit()
end

return LWHummerSceneUnitBase
