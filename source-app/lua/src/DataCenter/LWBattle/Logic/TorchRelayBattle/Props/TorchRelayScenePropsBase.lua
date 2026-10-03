local TorchRelayScenePropsBase = BaseClass("TorchRelayScenePropsBase")
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local _AUTO_INC_ID = 1

function TorchRelayScenePropsBase:__init(bornData, sceneRoot, logic, loadResCallback)
  self:Init()
  self:InitBase(bornData, sceneRoot, logic)
  self.isLoaded = false
  self.isCheerItem = false
  self.isFollowPlayer = false
  self.loadResCallback = loadResCallback
  self.velocityTmp = Vector3.unity_vector3(0, 0, 0)
  self:Load()
end

function TorchRelayScenePropsBase:Init()
end

function TorchRelayScenePropsBase:__delete()
  self.bornData = nil
  self.colliderComponent:Destroy()
  self.colliderComponent = nil
  if self.handle ~= nil then
    self.handle:Destroy()
    self.handle = nil
  end
  self.gameObject = nil
  self.transform = nil
end

function TorchRelayScenePropsBase:Recycle()
  self.active = false
  self.isFollowPlayer = false
  self.bornData = nil
  self:SetHide()
end

function TorchRelayScenePropsBase:ReInit(bornData, sceneRoot, logic)
  self:InitBase(bornData, sceneRoot, logic)
  self:InitTransform()
end

function TorchRelayScenePropsBase:InitBase(bornData, sceneRoot, logic)
  self.id = _AUTO_INC_ID
  _AUTO_INC_ID = _AUTO_INC_ID + 1
  self.bornData = bornData
  self.sceneRoot = sceneRoot
  self.logic = logic
  self.active = true
end

function TorchRelayScenePropsBase:Load()
  if not self.bornData then
    return
  end
  local resId = self.bornData.props.config.resource_id
  self.resConfig = DataCenter.TorchRelayTemplateManager:GetStageResourceTemplate(resId)
  if self.resConfig == nil then
    Logger.LogError("[TorchRelay] resConfig is nil  resId:" .. resId)
    return
  end
  self.handle = CS.GameEntry.Resource:InstantiateAsync(self.resConfig.prefab)
  self.handle:completed("+", function()
    if self.handle.isError then
      Logger.LogError("[TorchRelay] \232\181\132\230\186\144\229\138\160\232\189\189\229\164\177\232\180\165  path:" .. self.resConfig.prefab)
      return
    end
    self.gameObject = self.handle.gameObject
    self.transform = self.gameObject.transform
    self:OnResLoaded()
  end)
end

function TorchRelayScenePropsBase:OnUpdate(dt)
  if self.colliderComponent then
    self.colliderComponent:CollisionDetect()
  end
end

function TorchRelayScenePropsBase:OnResLoaded()
  self.isLoaded = true
  self:InitTransform()
  self:InitCollider()
  if self.loadResCallback then
    self.loadResCallback(self)
    self.loadResCallback = nil
  end
end

function TorchRelayScenePropsBase:InitTransform()
  self.transform:SetParent(self.sceneRoot)
  self.transform:Set_localPosition(self.bornData.x, self.bornData.y, self.bornData.z)
  self.transform:Set_localEulerAngles(0, 0, 0)
  self:SetShow()
end

function TorchRelayScenePropsBase:InitCollider()
  if not self.colliderComponent and self.transform then
    self.colliderComponent = ColliderComponent.New()
    local childCpt = self.transform:GetComponentInChildren(typeof(CS.UnityEngine.Collider))
    if childCpt then
      self.colliderComponent:InitCollider(childCpt.transform, 10)
      
      local function onCollisionHandler(colliderCnt, colliderComponentArray)
        self:OnCollision(colliderCnt, colliderComponentArray)
      end
      
      self.colliderComponent:SetOnCollide(onCollisionHandler)
    else
      Logger.LogError("Not Find Collider!!!   " .. self.transform.name)
    end
  end
end

function TorchRelayScenePropsBase:OnCollision(colliderCnt, colliderComponentArray)
  for i = 0, colliderCnt - 1 do
    local other = colliderComponentArray[i]
    local trigger = other:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil then
      self.colliderComponent.active = false
      self:OnCollisionPlayer(other, trigger)
      break
    end
  end
end

function TorchRelayScenePropsBase:OnCollisionPlayer(playerCollider, cpt)
end

function TorchRelayScenePropsBase:SetHide()
  if self.gameObject then
    self.gameObject:SetActive(false)
    if self.colliderComponent then
      self.colliderComponent.active = false
    end
  end
end

function TorchRelayScenePropsBase:SetShow()
  if self.gameObject then
    self.gameObject:SetActive(true)
    if self.colliderComponent then
      self.colliderComponent.active = true
    end
  end
end

function TorchRelayScenePropsBase:DoDropToFloor()
end

return TorchRelayScenePropsBase
