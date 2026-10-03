local PlayerWeapon = BaseClass("PlayerWeapon")
local Resource = CS.GameEntry.Resource
local InitWeaponSize = 1.8

function PlayerWeapon:__init()
  self.transform = nil
  self.player = nil
  self.weaponName = nil
  self.isHero = nil
  self.weaponRoot = nil
  self.triggerEnterAction = nil
  self.visible = nil
  self.lossyScale = 1
end

function PlayerWeapon:__delete()
  self.transform = nil
  self.player = nil
  self.weaponName = nil
  self.isHero = nil
  self.weaponRoot = nil
  self.triggerEnterAction = nil
  self.visible = nil
  self.lossyScale = 1
end

function PlayerWeapon:Create(player, weaponName, isHero, weaponRoot, triggerEnterAction)
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

function PlayerWeapon:Destroy()
  self:ComponentDestroy()
  if self.inst ~= nil then
    self.inst:Destroy()
    self.inst = nil
  end
end

function PlayerWeapon:ComponentDefine()
  self.trail_effect_root = self.transform
end

function PlayerWeapon:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function PlayerWeapon:SetVisible(visible)
  if self.gameObject == nil then
    self.visible = visible
  else
    self.gameObject:SetActive(visible)
  end
end

function PlayerWeapon:SetWeaponColliderEnable(enable)
end

function PlayerWeapon:GetTrailEffectRoot()
  return self.trail_effect_root
end

function PlayerWeapon:RefreshWeaponSize()
  if self.transform ~= nil then
    local weaponSize = self.player:GetWeaponSize() * self.player.battleLevel:GetWeaponDefaultSize() * self.player.scale
    local scale = InitWeaponSize * weaponSize / self.lossyScale
    self.transform.localScale = Vector3.New(scale, scale, scale)
  end
end

return PlayerWeapon
