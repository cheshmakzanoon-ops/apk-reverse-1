local WeaponObject = BaseClass("WeaponObject")
local Resource = CS.GameEntry.Resource
local TypeParticle = typeof(CS.UnityEngine.ParticleSystem)
local _cp_particle_fire = "VFX_pve_qianghuo"
local _cp_particle_fire_point = "firePoint"

function WeaponObject:__init()
  self.m_heroModel = nil
  self.m_gameObject = nil
  self.m_particle_fire = nil
end

function WeaponObject:AddWeapon(heroModel, weaponType)
  self.m_heroModel = heroModel
  self:InstantiateObj()
end

function WeaponObject:GetObjHeroHand()
  if self.m_heroModel:GetTransform() == nil then
    return nil
  end
  local childrenObj = self.m_heroModel:GetGameObject():GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true)
  if childrenObj.Length > 0 then
    for i = 0, childrenObj.Length - 1 do
      if childrenObj[i].name == "guadian" then
        childrenObj[i].gameObject:SetActive(true)
        return childrenObj[i].gameObject.transform
      end
    end
  end
end

function WeaponObject:GetModelResPath()
  return "Assets/Main/Prefabs/PVE/Obj_A_Weapons_th_spear.prefab"
end

function WeaponObject:InstantiateObj()
  local _prefabPath = self:GetModelResPath()
  self.m_req = Resource:InstantiateAsync(_prefabPath)
  self.m_req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_gameObject = _go
    local objHand = self:GetObjHeroHand()
    if objHand ~= nil then
      _go.transform.parent = objHand
    end
    _go.transform.localPosition = ResetPosition
    _go.transform.rotation = ResetEulerAngles
    self:SetActive(false)
    self:InitComponent()
    self.m_heroModel.weaponCreateFinish = true
  end)
end

function WeaponObject:GetTransform()
  return self.m_gameObject.transform
end

function WeaponObject:SetActive(isActive)
  if self.m_gameObject ~= nil then
    self.m_gameObject:SetActive(isActive)
  end
end

function WeaponObject:InitComponent()
  local _particle_fire = self:GetTransform():Find(_cp_particle_fire)
  if _particle_fire ~= nil then
    self.m_particle_fire = _particle_fire:GetComponent(TypeParticle)
  end
  self.firePoint = self:GetTransform():Find(_cp_particle_fire_point)
  self.firePointNull = IsNull(self.firePoint)
end

function WeaponObject:ToAttack()
  if self.m_particle_fire ~= nil then
    self.m_particle_fire:Simulate(0)
    self.m_particle_fire:Play()
  end
end

function WeaponObject:StopAttack()
  if self.m_particle_fire ~= nil then
    self.m_particle_fire:Stop()
  end
end

function WeaponObject:Destroy()
  if self.m_req ~= nil then
    self.m_req:Destroy()
  end
end

function WeaponObject:GetFirePoint()
  return self.firePoint, self.firePointNull
end

return WeaponObject
