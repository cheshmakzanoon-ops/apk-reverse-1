local WeaponModelManager = BaseClass("WeaponModelManager")
local Resource = CS.GameEntry.Resource
local weaponIdle = "idle"
local weaponAttack = "attack"
local fire_point = "A_build_dafuwendapao/A_build@dafuwendapao_skin/to_unity/D/root/firepoint"
local WeaponState = {
  NormalIdle = 1,
  NormalAttack = 2,
  NormalAttackFire = 3,
  SpecialAttack = 5,
  SpecialAttackFire = 6
}
local NormalAttackTime = 0.2
local NormalAttackFireTime = 0.3
local SpecialTypeTime = 0.1
local SpecialAttackTime = 0.2
local SpecialAttackFireTime = 0.8

function WeaponModelManager:__init()
  self:DataDefine()
end

function WeaponModelManager:__delete()
  self:OnDestroy()
end

function WeaponModelManager:DataDefine()
  self.modelShowManager = nil
  self.weaponLoadCache = {}
  self.weaponPath = nil
  self.weaponLoadRequest = nil
  self.weaponRoot = nil
  self.weapon = nil
  self.weaponAni = nil
  self.weaponFirePoint = nil
  self.showData = nil
  self.state = WeaponState.NormalIdle
  self.stateTime = 0
  self.soundHandleList = {}
end

function WeaponModelManager:OnDestroy()
  self.modelShowManager = nil
  self.weaponLoadCache = nil
  self.weaponPath = nil
  self.weaponLoadRequest = nil
  self.weaponRoot = nil
  self.weapon = nil
  self.weaponAni = nil
  self.weaponFirePoint = nil
  self.showData = nil
  self.state = nil
  self.stateTime = nil
  if self.soundHandleList then
    for i = 1, #self.soundHandleList do
      DataCenter.LWSoundManager:StopSound(self.soundHandleList[i])
    end
    self.soundHandleList = nil
  end
end

function WeaponModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.weaponRoot = self.modelShowManager.scene.transform:Find("WeaponPos")
  self:CreateWeapon()
end

function WeaponModelManager:CreateWeapon()
  for k, v in pairs(self.showData) do
    local modelPath = v.modelPath
    local modelId = k
    local req = Resource:InstantiateAsync(modelPath)
    req:completed("+", function()
      self:CreateWeaponCallback(req, modelId)
    end)
    self.weaponLoadCache[modelId] = req
  end
end

function WeaponModelManager:CreateWeaponCallback(req, id)
  req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
  self.weapon = req.gameObject
  self.weapon.transform.position = self.weaponRoot.transform.position
  self.weapon.transform.localScale = self.weaponRoot.transform.localScale
  self.weapon.transform.eulerAngles = self.weaponRoot.transform.eulerAngles
  self.weaponAni = self.weapon.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.weaponFirePoint = self.weapon.transform:Find(self.showData[id].firePoint)
  self.weapon:SetActive(DataCenter.ActBanquetV2Data.blood > 0)
  local isAllFin = true
  for k, v in pairs(self.weaponLoadCache) do
    if IsNull(v.gameObject) then
      isAllFin = false
      break
    end
  end
  if isAllFin then
    EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterCreateWeaponFin)
    self:SetCurWeaponComp(BanquetAttackMonsterBulletType.Normal)
  end
end

function WeaponModelManager:SetCurWeaponComp(bulletType)
  for k, v in pairs(self.weaponLoadCache) do
    if not IsNull(v.gameObject) then
      if k == bulletType then
        v.gameObject:SetActive(DataCenter.ActBanquetV2Data.blood > 0)
        self.weapon = v.gameObject
        self.weaponAni = self.weapon.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
        self.weaponFirePoint = self.weapon.transform:Find(self.showData[bulletType].firePoint)
      else
        v.gameObject:SetActive(false)
      end
    end
  end
end

function WeaponModelManager:EndShow()
  if self.weaponLoadCache then
    for k, v in pairs(self.weaponLoadCache) do
      v:Destroy()
    end
    self.weaponLoadCache = {}
    self.weaponLoadRequest = nil
    self.weapon = nil
    self.weaponAni = nil
    self.weaponFirePoint = nil
  end
end

function WeaponModelManager:OnUpdate(deltaTime)
  if self.stateTime > 0 then
    self.stateTime = self.stateTime - deltaTime
    if self.stateTime <= 0 then
      self:TryWeaponStateChange()
    end
  end
end

function WeaponModelManager:SetModelShowData(data)
  self.showData = data
end

function WeaponModelManager:BulletDataStart(data)
  self.bulletData = data
  local bulletType = data.type
  if bulletType == BanquetAttackMonsterBulletType.Normal then
    if self.state == WeaponState.SpecialAttack or self.state == WeaponState.SpecialAttackFire then
      self:SetCurWeaponComp(bulletType)
    end
    self.state = WeaponState.NormalAttack
    self.stateTime = NormalAttackFireTime / self.bulletData.speed
    if self.weaponAni then
      self.weaponAni:Stop()
      self.weaponAni:SetStateSpeed(weaponAttack, self.bulletData.speed)
      self.weaponAni:Play(weaponAttack)
    end
    local handle = DataCenter.LWSoundManager:PlaySound(91115, false)
    table.insert(self.soundHandleList, handle)
  else
    if self.state == WeaponState.NormalIdle or self.state == WeaponState.NormalAttack or self.state == WeaponState.NormalAttackFire then
      self:SetCurWeaponComp(bulletType)
    end
    self.state = WeaponState.SpecialAttack
    self.stateTime = SpecialAttackTime / self.bulletData.speed
    if self.weaponAni then
      self.weaponAni:Stop()
      self.weaponAni:SetStateSpeed(weaponAttack, self.bulletData.speed)
      self.weaponAni:Play(weaponAttack)
    end
  end
end

function WeaponModelManager:TryWeaponStateChange()
  if self.stateTime > 0 then
    return
  end
  if self.state == WeaponState.NormalAttack then
    self.state = WeaponState.NormalAttackFire
    self.stateTime = NormalAttackFireTime
    self.modelShowManager:TryBulletModelStart(self.bulletData)
  elseif self.state == WeaponState.NormalAttackFire then
    self.state = WeaponState.NormalIdle
    self.stateTime = 0
    if self.weaponAni then
      self.weaponAni:Stop()
      self.weaponAni:Play(weaponIdle)
    end
  elseif self.state == WeaponState.SpecialAttack then
    self.state = WeaponState.SpecialAttackFire
    self.stateTime = SpecialAttackFireTime
    self.modelShowManager:TryBulletModelStart(self.bulletData)
  elseif self.state == WeaponState.SpecialAttackFire then
    self:SetCurWeaponComp(BanquetAttackMonsterBulletType.Normal)
    self.state = WeaponState.NormalIdle
    self.stateTime = 0
    if self.weaponAni then
      self.weaponAni:Stop()
      self.weaponAni:Play(weaponIdle)
    end
  end
end

return WeaponModelManager
