local CitySpaceManWeapon = BaseClass("CitySpaceManWeapon")
local Resource = CS.GameEntry.Resource
local _cp_weapon_trigger = "collider"
local _cp_weapon_trigger_hero = "joint2"
local InitWeaponSize = 1.8

function CitySpaceManWeapon:__init()
  self.transform = nil
  self.player = nil
  self.weaponName = nil
  self.isHero = nil
  self.weaponRoot = nil
  self.triggerEnterAction = nil
  self.visible = nil
  self.lossyScale = 1
end

function CitySpaceManWeapon:__delete()
  self.transform = nil
  self.player = nil
  self.weaponName = nil
  self.isHero = nil
  self.weaponRoot = nil
  self.triggerEnterAction = nil
  self.visible = nil
  self.lossyScale = 1
end

function CitySpaceManWeapon:Create(player, weaponName, isHero, weaponRoot, triggerEnterAction)
  self.player = player
  self.weaponName = weaponName
  self.isHero = isHero
  self.weaponRoot = weaponRoot
  self.triggerEnterAction = triggerEnterAction
  self.visible = true
  self.inst = Resource:InstantiateAsync(weaponName)
  self.inst:completed("+", function(req)
    local transform = req.gameObject.transform
    transform:SetParent(weaponRoot)
    transform.localPosition = ResetPosition
    transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.lossyScale = self.weaponRoot.transform.lossyScale.x
    self.transform = transform
    self.gameObject = req.gameObject
    self:ComponentDefine()
    self:SetVisible(self.visible)
    self:RefreshWeaponSize()
  end)
end

function CitySpaceManWeapon:Destroy()
  self:ComponentDefine()
  if self.inst ~= nil then
    self.inst:Destroy()
  end
end

function CitySpaceManWeapon:ComponentDefine()
  local trigger = _cp_weapon_trigger
  if self.isHero then
    trigger = _cp_weapon_trigger_hero
    self.trail_effect_root = self.transform
  else
    self.trail_effect_root = self.transform
  end
  local triggerObj = self.transform:Find(trigger)
  if triggerObj then
    self.weaponCollider = triggerObj:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
    self.m_weaponTrigger = triggerObj:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_weaponTrigger then
      self.m_weaponTrigger.TriggerEnterAction = self.triggerEnterAction
    end
  end
end

function CitySpaceManWeapon:ComponentDestroy()
  if self.m_weaponTrigger then
    self.m_weaponTrigger.TriggerEnterAction = nil
    self.m_weaponTrigger = nil
  end
  self.weaponCollider = nil
  self.gameObject = nil
  self.transform = nil
end

function CitySpaceManWeapon:SetVisible(visible)
  if self.gameObject == nil then
    self.visible = visible
  else
    self.gameObject:SetActive(visible)
  end
end

function CitySpaceManWeapon:SetWeaponColliderEnable(enable)
  if self.weaponCollider then
    self.weaponCollider.enabled = enable
  end
end

function CitySpaceManWeapon:GetTrailEffectRoot()
  return self.trail_effect_root
end

function CitySpaceManWeapon:RefreshWeaponSize()
  if self.transform ~= nil then
    local weaponSize = self.player:GetWeaponSize()
    local scale = InitWeaponSize * weaponSize / self.lossyScale
    self.transform.localScale = Vector3.New(scale, scale, scale)
  end
end

return CitySpaceManWeapon
