local BulletsAndEffectsModelManager = BaseClass("BulletsAndEffectsModelManager")
local Resource = CS.GameEntry.Resource
local BulletPath = "Assets/Main/Prefabs/UIChristmasPerfab/A_build_lihua.prefab"
local BulletEffectPath = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Danianshou/Eff_dafuweng_hongzha_hit.prefab"
local DamageFlyTextPath = "Assets/Main/Prefabs/UIChristmasPerfab/DamageFlyText.prefab"
local WeaponFireEffect1Path = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Danianshou/Eff_dafuweng_hongzha_kaihuo_danci.prefab"
local WeaponFireEffect2Path = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Danianshou/Eff_dafuweng_hongzha_kaihuo_lianfa.prefab"
local damageTxtAngle = Vector3.New(-14.8, -35.93, 10.47)
local White = Color.New(1, 1, 1, 1)
local Transparent = Color.New(0, 0, 0, 0)
local BulletHigh = 1.3
local textFlyTime = 0.6
local fireEffect1Time = 0.6
local fireEffect2Time = 1.4
local attackedEffectTime = 1
local bulletState = {
  Wait = 1,
  Fly = 2,
  Fin = 3
}
local bulletBaseWaitTime = 0.06
local bulletDelayTime = 0.1

function BulletsAndEffectsModelManager:__init()
  self:DataDefine()
end

function BulletsAndEffectsModelManager:__delete()
  self:OnDestroy()
end

function BulletsAndEffectsModelManager:DataDefine()
  self.modelShowManager = nil
  self.isAllModelLoad = false
  self.bulletUseList = {}
  self.bulletCacheList = {}
  self.fireEffect1UseList = {}
  self.fireEffect1CacheList = {}
  self.fireEffect2UseList = {}
  self.fireEffect2CacheList = {}
  self.attackedEffectUseList = {}
  self.attackedEffectCacheList = {}
  self.damageTxtUseList = {}
  self.damageTxtCacheList = {}
end

function BulletsAndEffectsModelManager:OnDestroy()
  self.modelShowManager = nil
  self.isAllModelLoad = nil
  self.fireEffect1UseList = nil
  self.fireEffect1CacheList = nil
  self.fireEffect2UseList = nil
  self.fireEffect2CacheList = nil
  self.bulletUseList = nil
  self.bulletCacheList = nil
  self.attackedEffectUseList = nil
  self.attackedEffectCacheList = nil
  self.damageTxtUseList = nil
  self.damageTxtCacheList = nil
end

function BulletsAndEffectsModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.isAllModelLoad = false
end

function BulletsAndEffectsModelManager:EndShow()
  self:FireEffect1EndShow()
  self:FireEffect2EndShow()
  self:BulletEndShow()
  self:AttackedEffectEndShow()
  self:DamageTxtEndShow()
end

function BulletsAndEffectsModelManager:AddBulletAniData(data, aniTime)
  if self.isAllModelLoad == false and self.modelShowManager.monsterModelManager.monster and self.modelShowManager.weaponModelManager.weapon then
    self.isAllModelLoad = true
  end
  if self.isAllModelLoad == false then
    return
  end
  self:BulletStart(data, aniTime)
end

function BulletsAndEffectsModelManager:OnUpdate(deltaTime)
  self:FireEffect1Update(deltaTime)
  self:FireEffect2Update(deltaTime)
  self:BulletUpdate(deltaTime)
  self:AttackedEffectUpdate(deltaTime)
  self:DamageTxtUpdate(deltaTime)
end

function BulletsAndEffectsModelManager:BulletStart(data, aniTime)
  local bulletDataList = data.bulletDataList
  local bulletNum = #bulletDataList
  if bulletNum == 1 then
    self:FireEffect1Start()
  else
    self:FireEffect2Start()
  end
  self.modelShowManager.weaponModelManager:TryWeaponPlayFireAni(0 < bulletNum)
  for i = 1, bulletNum do
    local data = bulletDataList[i]
    local bulletData
    if 0 < #self.bulletCacheList then
      local getInex = #self.bulletCacheList
      bulletData = self.bulletCacheList[getInex]
      self.bulletCacheList[getInex] = nil
    else
      bulletData = {}
    end
    bulletData.state = bulletState.Wait
    bulletData.data = data
    bulletData.waitTime = bulletBaseWaitTime + (i - 1) * bulletDelayTime
    bulletData.flyTime = aniTime - bulletBaseWaitTime - (bulletNum - 1) * bulletDelayTime
    bulletData.stateTime = bulletData.waitTime
    table.insert(self.bulletUseList, 1, bulletData)
  end
end

function BulletsAndEffectsModelManager:BulletUpdate(deltaTime)
  local useNum = #self.bulletUseList
  for i = 1, useNum do
    local data = self.bulletUseList[i]
    if data.state == bulletState.Wait then
      data.stateTime = data.stateTime - deltaTime
      if data.stateTime <= 0 then
        data.state = bulletState.Fly
        data.stateTime = data.flyTime
        local bulletDir = Vector3.New(0, 1, 0)
        local startPos = self.modelShowManager.weaponModelManager.weaponFirePoint.transform.position
        local monsterPos = self.modelShowManager.monsterModelManager.monster.transform.position
        monsterPos.z = monsterPos.z - 0.5
        local randomRadius = math.random() * 0.2
        local randomAngle = math.random() * 6.283
        local randomOffsetY = 0.66 - randomRadius
        local randomOffset = Vector3.New(math.cos(randomAngle), 0, math.sin(randomAngle)) * randomRadius
        randomOffset.y = randomOffsetY
        local endPos = monsterPos + randomOffset
        local flyHigh = BulletHigh
        local calPos = (startPos + endPos) / 3
        local randomPosRadius = math.random() * 0.2 + 0.2
        local randomPosOffset = Vector3.New(math.cos(randomAngle), 0, math.sin(randomAngle)) * randomPosRadius
        randomPosOffset.y = flyHigh
        local centerPos = calPos + randomPosOffset
        local path = CS.CatmullRomUtils.CalcCurveByPoints(startPos, endPos, centerPos)
        data.endPos = endPos
        data.path = path
        data.luaPath = {}
        data.angle = {}
        for i = 0, data.path.Count - 1 do
          local csVec = data.path[i]
          data.luaPath[i] = Vector3.New(csVec.x, csVec.y, csVec.z)
        end
        for i = 0, path.Count - 2 do
          if data.luaPath[i + 1] == data.luaPath[i] then
            if data.angle[i - 1] ~= nil then
              data.angle[i] = data.angle[i - 1]
            else
              data.angle[i] = CS.UnityEngine.Quaternion.FromToRotation(bulletDir, bulletDir).eulerAngles
            end
          else
            data.angle[i] = CS.UnityEngine.Quaternion.FromToRotation(bulletDir, data.luaPath[i + 1] - data.luaPath[i]).eulerAngles
          end
        end
        data.angle[path.Count - 1] = data.angle[path.Count - 2]
        if data.req == nil then
          local req = Resource:InstantiateAsync(BulletPath)
          data.req = req
          req:completed("+", function()
            CommonUtil.CallAutoArabicMirrorManually(req)
            local root = req.gameObject
            root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
            data.obj = root
            root.transform.localScale = Vector3.one * 0.3
            root:SetActive(data.state == bulletState.Fly)
          end)
        elseif data.obj ~= nil then
          data.obj:SetActive(true)
          data.obj.transform.position = data.luaPath[0]
          data.obj.transform.eulerAngles = data.angle[0]
        end
      end
    elseif data.state == bulletState.Fly then
      data.stateTime = data.stateTime - deltaTime
      local rate = 1 - data.stateTime / data.flyTime
      rate = math.min(rate, 1)
      rate = math.max(rate, 0)
      if data.obj ~= nil then
        local dataLen = data.path.Count
        local curDataRate = rate
        local dataRate = curDataRate * (dataLen - 1)
        local dataIndex1 = math.floor(dataRate)
        local dataIndex2 = dataIndex1 + 1
        dataIndex2 = math.min(dataIndex2, dataLen - 1)
        local bulletPos = Vector3.Lerp(data.luaPath[dataIndex1], data.luaPath[dataIndex2], dataRate - dataIndex1)
        data.obj.transform.position = bulletPos
        local bulletEuler = Vector3.Lerp(data.angle[dataIndex1], data.angle[dataIndex2], dataRate - dataIndex1)
        data.obj.transform.eulerAngles = bulletEuler
      end
      if data.stateTime < 0 then
        data.state = bulletState.Fin
        data.stateTime = 0
        if data.obj ~= nil then
          data.obj:SetActive(false)
        end
        local isCrit = data.data.isCrit
        self.modelShowManager.monsterModelManager:TryMonsterPlayAttackedAni(isCrit)
        self:AttackedEffectStart(data.endPos)
        self:DamageTxtStart(data.endPos, data.data.totalDamage, isCrit)
        EventManager:GetInstance():Broadcast(EventId.ActMonopolyOneBulletDeal, data.data)
      end
    elseif data.state == bulletState.Fin then
    end
  end
  for i = useNum, 1, -1 do
    local data = self.bulletUseList[i]
    if data.state == bulletState.Fin then
      table.insert(self.bulletCacheList, data)
      self.bulletUseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:BulletEndShow()
  for k, v in pairs(self.bulletUseList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.bulletUseList = {}
  for k, v in pairs(self.bulletCacheList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.bulletCacheList = {}
end

function BulletsAndEffectsModelManager:FireEffect1Start()
  local data
  if #self.fireEffect1CacheList > 0 then
    local getInex = #self.fireEffect1CacheList
    data = self.fireEffect1CacheList[getInex]
    self.fireEffect1CacheList[getInex] = nil
  else
    data = {}
  end
  table.insert(self.fireEffect1UseList, 1, data)
  data.stateTime = fireEffect1Time
  if data.req == nil then
    local req = Resource:InstantiateAsync(WeaponFireEffect1Path)
    data.req = req
    req:completed("+", function()
      CommonUtil.CallAutoArabicMirrorManually(req)
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      root.transform:SetParent(self.modelShowManager.weaponModelManager.weaponFirePoint)
      root.transform.localPosition = Vector3.zero
      root.transform:Set_localScale(1, 1, 1)
      root.transform:Set_eulerAngles(0, 0, 0)
      data.obj = root
      root:SetActive(0 < data.stateTime)
    end)
  elseif data.obj ~= nil then
    data.obj:SetActive(true)
  end
end

function BulletsAndEffectsModelManager:FireEffect1Update(deltaTime)
  local useNum = #self.fireEffect1UseList
  for i = 1, useNum do
    local data = self.fireEffect1UseList[i]
    data.stateTime = data.stateTime - deltaTime
    if data.stateTime < 0 and data.obj ~= nil then
      data.obj:SetActive(false)
    end
  end
  for i = useNum, 1, -1 do
    local data = self.fireEffect1UseList[i]
    if data.stateTime < 0 then
      table.insert(self.fireEffect1CacheList, data)
      self.fireEffect1UseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:FireEffect1EndShow()
  for k, v in pairs(self.fireEffect1UseList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.fireEffect1UseList = {}
  for k, v in pairs(self.fireEffect1CacheList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.fireEffect1CacheList = {}
end

function BulletsAndEffectsModelManager:FireEffect2Start()
  local data
  if #self.fireEffect2CacheList > 0 then
    local getInex = #self.fireEffect2CacheList
    data = self.fireEffect2CacheList[getInex]
    self.fireEffect2CacheList[getInex] = nil
  else
    data = {}
  end
  table.insert(self.fireEffect2UseList, 1, data)
  data.stateTime = fireEffect1Time
  if data.req == nil then
    local req = Resource:InstantiateAsync(WeaponFireEffect2Path)
    data.req = req
    req:completed("+", function()
      CommonUtil.CallAutoArabicMirrorManually(req)
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      root.transform:SetParent(self.modelShowManager.weaponModelManager.weaponFirePoint)
      root.transform.localPosition = Vector3.zero
      root.transform:Set_localScale(1, 1, 1)
      root.transform:Set_eulerAngles(0, 0, 0)
      data.obj = root
      root:SetActive(0 < data.stateTime)
    end)
  elseif data.obj ~= nil then
    data.obj:SetActive(true)
  end
end

function BulletsAndEffectsModelManager:FireEffect2Update(deltaTime)
  local useNum = #self.fireEffect2UseList
  for i = 1, useNum do
    local data = self.fireEffect2UseList[i]
    data.stateTime = data.stateTime - deltaTime
    if data.stateTime < 0 and data.obj ~= nil then
      data.obj:SetActive(false)
    end
  end
  for i = useNum, 1, -1 do
    local data = self.fireEffect2UseList[i]
    if data.stateTime < 0 then
      table.insert(self.fireEffect2CacheList, data)
      self.fireEffect2UseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:FireEffect2EndShow()
  for k, v in pairs(self.fireEffect2UseList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.fireEffect2UseList = {}
  for k, v in pairs(self.fireEffect2CacheList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.fireEffect2CacheList = {}
end

function BulletsAndEffectsModelManager:AttackedEffectStart(pos)
  local data
  if #self.attackedEffectCacheList > 0 then
    local getInex = #self.attackedEffectCacheList
    data = self.attackedEffectCacheList[getInex]
    self.attackedEffectCacheList[getInex] = nil
  else
    data = {}
  end
  table.insert(self.attackedEffectUseList, 1, data)
  data.stateTime = attackedEffectTime
  if data.req == nil then
    local req = Resource:InstantiateAsync(BulletEffectPath)
    data.req = req
    req:completed("+", function()
      CommonUtil.CallAutoArabicMirrorManually(req)
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      root.transform.position = pos
      data.obj = root
      root:SetActive(data.stateTime > 0)
    end)
  elseif data.obj ~= nil then
    data.obj.transform.position = pos
    data.obj:SetActive(true)
  end
end

function BulletsAndEffectsModelManager:AttackedEffectUpdate(deltaTime)
  local useNum = #self.attackedEffectUseList
  for i = 1, useNum do
    local data = self.attackedEffectUseList[i]
    data.stateTime = data.stateTime - deltaTime
    if data.stateTime < 0 and data.obj ~= nil then
      data.obj:SetActive(false)
    end
  end
  for i = useNum, 1, -1 do
    local data = self.attackedEffectUseList[i]
    if data.stateTime < 0 then
      table.insert(self.attackedEffectCacheList, data)
      self.attackedEffectUseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:AttackedEffectEndShow()
  for k, v in pairs(self.attackedEffectUseList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.attackedEffectUseList = {}
  for k, v in pairs(self.attackedEffectCacheList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.attackedEffectCacheList = {}
end

function BulletsAndEffectsModelManager:DamageTxtStart(pos, damageTxt, isHit)
  local data
  if #self.damageTxtCacheList > 0 then
    local getInex = #self.damageTxtCacheList
    data = self.damageTxtCacheList[getInex]
    self.damageTxtCacheList[getInex] = nil
  else
    data = {}
  end
  table.insert(self.damageTxtUseList, 1, data)
  data.stateTime = textFlyTime
  if data.req == nil then
    local req = Resource:InstantiateAsync(DamageFlyTextPath)
    data.req = req
    req:completed("+", function()
      CommonUtil.CallAutoArabicMirrorManually(req)
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      root.transform.localScale = Vector3.one * 0.2
      root.transform.eulerAngles = damageTxtAngle
      root.transform.position = pos
      local numText = root.transform:Find("Scale/num"):GetComponent(typeof(CS.SuperTextMesh))
      local critIcon = root.transform:Find("Scale/num/critIcon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if isHit then
        critIcon.color = White
      else
        critIcon.color = Transparent
      end
      numText.text = "-" .. damageTxt
      data.obj = root
      data.numText = numText
      data.critIcon = critIcon
      root:SetActive(data.stateTime > 0)
    end)
  elseif data.obj ~= nil then
    data.obj.transform.position = pos
    if isHit then
      data.critIcon.color = White
    else
      data.critIcon.color = Transparent
    end
    data.numText.text = "-" .. damageTxt
    data.obj:SetActive(true)
  end
end

function BulletsAndEffectsModelManager:DamageTxtUpdate(deltaTime)
  local useNum = #self.damageTxtUseList
  for i = 1, useNum do
    local data = self.damageTxtUseList[i]
    data.stateTime = data.stateTime - deltaTime
    if data.stateTime < 0 and data.obj ~= nil then
      data.obj:SetActive(false)
    end
  end
  for i = useNum, 1, -1 do
    local data = self.damageTxtUseList[i]
    if data.stateTime < 0 then
      table.insert(self.damageTxtCacheList, data)
      self.damageTxtUseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:DamageTxtEndShow()
  for k, v in pairs(self.damageTxtUseList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.damageTxtUseList = {}
  for k, v in pairs(self.damageTxtCacheList) do
    if v.req then
      v.req:RealDestroy()
    end
  end
  self.damageTxtCacheList = {}
end

return BulletsAndEffectsModelManager
