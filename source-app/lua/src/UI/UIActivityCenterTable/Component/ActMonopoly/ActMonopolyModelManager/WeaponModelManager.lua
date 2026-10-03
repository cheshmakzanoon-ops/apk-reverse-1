local WeaponModelManager = BaseClass("WeaponModelManager")
local Resource = CS.GameEntry.Resource
local weaponIdle = "idle"
local weaponAttack = "attack2"
local weaponAttack2 = "attack"
local fire_point = "A_build_dafuwendapao/A_build@dafuwendapao_skin/to_unity/D/root/firepoint"
local WeapFireRealTime = 0.74
local WeapFireRealTime2 = 1.2

function WeaponModelManager:__init()
  self:DataDefine()
end

function WeaponModelManager:__delete()
  self:OnDestroy()
end

function WeaponModelManager:DataDefine()
  self.modelShowManager = nil
  self.weaponPath = "Assets/Main/Prefabs/UIChristmasPerfab/A_build_dafuwendapao.prefab"
  self.weaponLoadRequest = nil
  self.weaponRoot = nil
  self.weapon = nil
  self.weaponAni = nil
  self.weaponFirePoint = nil
  self.weaponFireEffect1 = nil
  self.weaponFireEffect2 = nil
  self.showDataWeaponIdelTime = 0
end

function WeaponModelManager:OnDestroy()
  self.modelShowManager = nil
  self.weaponPath = nil
  self.weaponLoadRequest = nil
  self.weaponRoot = nil
  self.weapon = nil
  self.weaponAni = nil
  self.weaponFirePoint = nil
  self.weaponFireEffect1 = nil
  self.weaponFireEffect2 = nil
  self.showDataWeaponIdelTime = nil
end

function WeaponModelManager:TryWeaponPlayFireAni(isBurst)
  if self.weaponAni then
    self.weaponAni:Stop()
    local atkName = weaponAttack
    local atkTime = WeapFireRealTime
    if isBurst then
      atkName = weaponAttack2
      atkTime = WeapFireRealTime2
    end
    self.weaponAni:Play(atkName)
    self.showDataWeaponIdelTime = atkTime
  end
end

function WeaponModelManager:TryWeaponPlayIdleAni()
  if self.weaponAni then
    self.weaponAni:Stop()
    self.weaponFireEffect1:SetActive(false)
    self.weaponFireEffect2:SetActive(false)
    self.weaponAni:Play(weaponIdle)
  end
end

function WeaponModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.weaponRoot = self.modelShowManager.scene.transform:Find("WeaponPos")
  self:CreateWeapon()
end

function WeaponModelManager:CreateWeapon()
  self.weaponLoadRequest = nil
  local req = Resource:InstantiateAsync(self.weaponPath)
  req:completed("+", function()
    local weaponRoot = req.gameObject.transform
    req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    weaponRoot:Set_localPosition(0, 0, 0)
    self.weapon = req.gameObject
    self.weapon.transform.position = self.weaponRoot.transform.position
    self.weapon.transform.localScale = Vector3.one
    self.weaponAni = self.weapon.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.weaponFirePoint = self.weapon.transform:Find(fire_point)
    self.weaponFireEffect1 = self.weaponFirePoint.transform:Find("Eff_dafuweng_hongzha_kaihuo_danci").gameObject
    self.weaponFireEffect2 = self.weaponFirePoint.transform:Find("Eff_dafuweng_hongzha_kaihuo_lianfa").gameObject
    self:TryWeaponPlayIdleAni()
  end)
  self.weaponLoadRequest = req
end

function WeaponModelManager:EndShow()
  if self.weaponLoadRequest then
    self.weaponLoadRequest:RealDestroy()
    self.weaponLoadRequest = nil
    self.weapon = nil
    self.weaponAni = nil
    self.weaponFirePoint = nil
    self.weaponFireEffect1 = nil
    self.weaponFireEffect2 = nil
  end
end

function WeaponModelManager:OnUpdate(deltaTime)
  if self.showDataWeaponIdelTime > 0 then
    self.showDataWeaponIdelTime = self.showDataWeaponIdelTime - deltaTime
    if self.showDataWeaponIdelTime <= 0 then
      self:TryWeaponPlayIdleAni()
    end
  end
end

return WeaponModelManager
