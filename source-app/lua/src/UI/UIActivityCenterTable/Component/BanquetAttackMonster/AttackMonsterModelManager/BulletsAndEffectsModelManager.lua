local BulletsAndEffectsModelManager = BaseClass("BulletsAndEffectsModelManager")
local Resource = CS.GameEntry.Resource
local Bullet1Path = "Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_zidan.prefab"
local Bullet2Path = "Assets/_Art_LastWar/Effect/Prefab/Arms/Liudan_xin/Eff_hero_liudan_zidan_xin_01.prefab"
local BulletEffectPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/2026easter/Prefab/Eff_yanHuiBoss2026_hit_Variant.prefab"
local DamageFlyTextPath = "Assets/Main/Prefabs/UIChristmasPerfab/DamageFlyText.prefab"
local WeaponFireEffect1Path = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Danianshou/Eff_dafuweng_hongzha_kaihuo_danci.prefab"
local WeaponFireEffect2Path = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Danianshou/Eff_dafuweng_hongzha_kaihuo_lianfa.prefab"
local damageTxtAngle = Vector3.New(-30, 0, 0)
local White = Color.New(1, 1, 1, 1)
local Transparent = Color.New(0, 0, 0, 0)
local txtColor1 = Color.New(255, 255, 255, 255)
local iconColor1 = Color.New(1.0, 1.0, 1.0, 1)
local txtColor2 = Color.New(236, 131, 255, 255)
local iconColor2 = Color.New(1.0, 0.5843137254901961, 0.9176470588235294, 1)
local txtColor3 = Color.New(255, 236, 80, 255)
local iconColor3 = Color.New(1.0, 0.7372549019607844, 0.07058823529411765, 1)
local BulletHigh = 1.3
local textFlyTime = 0.6
local fireEffect1Time = 0.6
local fireEffect2Time = 1.4
local attackedEffectTime = 1
local normalBulletScale = 1
local specialBulletScale = 0.3
local bulletState = {
  Wait = 1,
  Fly = 2,
  Fin = 3
}

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
  self.bullet2UseList = {}
  self.bullet2CacheList = {}
  self.fireEffect1UseList = {}
  self.fireEffect1CacheList = {}
  self.fireEffect2UseList = {}
  self.fireEffect2CacheList = {}
  self.attackedEffectUseList = {}
  self.attackedEffectCacheList = {}
  self.damageTxtUseList = {}
  self.damageTxtCacheList = {}
  self.soundHandleList = {}
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
  self.bullet2UseList = nil
  self.bullet2CacheList = nil
  self.attackedEffectUseList = nil
  self.attackedEffectCacheList = nil
  self.damageTxtUseList = nil
  self.damageTxtCacheList = nil
  if self.soundHandleList then
    for i = 1, #self.soundHandleList do
      DataCenter.LWSoundManager:StopSound(self.soundHandleList[i])
    end
    self.soundHandleList = nil
  end
end

function BulletsAndEffectsModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.isAllModelLoad = false
end

function BulletsAndEffectsModelManager:EndShow()
  self:BulletEndShow()
  self:AttackedEffectEndShow()
  self:DamageTxtEndShow()
end

function BulletsAndEffectsModelManager:OnUpdate(deltaTime)
  self:BulletUpdate(deltaTime)
  self:AttackedEffectUpdate(deltaTime)
  self:DamageTxtUpdate(deltaTime)
end

function BulletsAndEffectsModelManager:BulletUpdate(deltaTime)
  self:BulletUpdateByType(deltaTime, BanquetAttackMonsterBulletType.Normal)
  self:BulletUpdateByType(deltaTime, BanquetAttackMonsterBulletType.Special)
end

function BulletsAndEffectsModelManager:BulletUpdateByType(deltaTime, bulletType)
  local bulletUseList = {}
  local bulletCacheList = {}
  if bulletType == BanquetAttackMonsterBulletType.Normal then
    bulletUseList = self.bulletUseList
    bulletCacheList = self.bulletCacheList
  elseif bulletType == BanquetAttackMonsterBulletType.Special then
    bulletUseList = self.bullet2UseList
    bulletCacheList = self.bullet2CacheList
  end
  local useNum = #bulletUseList
  for i = 1, useNum do
    local data = bulletUseList[i]
    if data.state == bulletState.Wait then
      data.stateTime = data.stateTime - deltaTime
      if data.stateTime <= 0 then
        local monsterCurData = self.modelShowManager.monsterModelManager.monsterCurData
        local monsterShowData = self.modelShowManager.monsterModelManager.monsterShowData
        local curId = monsterCurData.curMonsterId
        local targetMonsterTemp = monsterShowData[curId].monsterTemp
        local bulletFlyAngleOffset = Vector3.zero
        if bulletType == BanquetAttackMonsterBulletType.Normal and #targetMonsterTemp.com_attack_angle == 3 then
          bulletFlyAngleOffset = Vector3.New(-2.3, -49.7, -43.2)
        end
        data.state = bulletState.Fly
        data.stateTime = data.flyTime
        data.bulletFlyAngleOffset = bulletFlyAngleOffset
        local bulletDir = Vector3.New(0, 1, 0)
        local startPos = self.modelShowManager.weaponModelManager.weaponFirePoint.transform.position
        local monsterPos = self.modelShowManager.monsterModelManager.monster.transform.position
        monsterPos.z = monsterPos.z - 0.5
        local hitPos = self.modelShowManager.monsterModelManager:GetHitPos()
        if not hitPos then
          Logger.LogError("hit pos is nil ")
          hitPos = monsterPos
          local tempY = targetMonsterTemp.hit_pos
          hitPos.y = tempY
        end
        local endPos = hitPos
        local calPos = (startPos + endPos) / 2
        local path
        if bulletType == BanquetAttackMonsterBulletType.Normal then
          path = CS.CatmullRomUtils.CalcCurveByPoints(startPos, endPos, calPos)
        elseif bulletType == BanquetAttackMonsterBulletType.Special then
          calPos.y = calPos.y + BulletHigh
          path = CS.CatmullRomUtils.CalcCurveByPoints(startPos, endPos, calPos)
        end
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
          local reqPath
          local bulletScale = normalBulletScale
          if bulletType == BanquetAttackMonsterBulletType.Normal then
            reqPath = Bullet1Path
            bulletScale = normalBulletScale
          elseif bulletType == BanquetAttackMonsterBulletType.Special then
            reqPath = Bullet2Path
            bulletScale = specialBulletScale
          end
          local req = Resource:InstantiateAsync(reqPath)
          data.req = req
          req:completed("+", function()
            local root = req.gameObject
            root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
            data.obj = root
            data.trails = root.transform:GetComponentsInChildren(typeof(CS.UnityEngine.TrailRenderer))
            root.transform.localScale = Vector3.one * bulletScale
            root.transform.position = startPos
            root:SetActive(data.state == bulletState.Fly)
            for trailsIndex = 0, data.trails.Length - 1 do
              data.trails[trailsIndex]:Clear()
            end
          end)
        elseif data.obj ~= nil then
          data.obj:SetActive(true)
          for trailsIndex = 0, data.trails.Length - 1 do
            data.trails[trailsIndex]:Clear()
          end
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
        data.obj.transform.eulerAngles = bulletEuler + data.bulletFlyAngleOffset
      end
      if data.stateTime < 0 then
        data.state = bulletState.Fin
        data.stateTime = 0
        if data.obj ~= nil then
          data.obj:SetActive(false)
          data.obj.transform.position = data.luaPath[0]
        end
        local isCrit = data.data.type == BanquetAttackMonsterBulletType.Special
        self.modelShowManager.monsterModelManager:TryMonsterPlayAttackedAni(isCrit)
        self:AttackedEffectStart(data.endPos)
        self:DamageTxtStart(data.endPos, data.data.data.damage, data.data.data.critical == 1, data.data)
        EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterBulletFin)
      end
    elseif data.state == bulletState.Fin then
    end
  end
  for i = useNum, 1, -1 do
    local data = bulletUseList[i]
    if data.state == bulletState.Fin then
      table.insert(bulletCacheList, data)
      bulletUseList[i] = nil
    else
      break
    end
  end
end

function BulletsAndEffectsModelManager:BulletEndShow()
  for k, v in pairs(self.bulletUseList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.bulletUseList = {}
  for k, v in pairs(self.bulletCacheList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.bulletCacheList = {}
  for k, v in pairs(self.bullet2UseList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.bullet2UseList = {}
  for k, v in pairs(self.bullet2CacheList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.bullet2CacheList = {}
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
  local handle = DataCenter.LWSoundManager:PlaySound(202650, false)
  table.insert(self.soundHandleList, handle)
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
      v.req:Destroy()
    end
  end
  self.attackedEffectUseList = {}
  for k, v in pairs(self.attackedEffectCacheList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.attackedEffectCacheList = {}
end

function BulletsAndEffectsModelManager:DamageTxtStart(pos, damageTxt, isHit, bulletData)
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
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      root.transform.localScale = Vector3.one
      root.transform.eulerAngles = damageTxtAngle
      root.transform.position = pos
      local numText = root.transform:Find("Scale/num"):GetComponent(typeof(CS.SuperTextMesh))
      local critIcon = root.transform:Find("Scale/num/critIcon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      local scalex, scaley, scalez
      if bulletData.type == BanquetAttackMonsterBulletType.Normal then
        if not isHit then
          numText.color32 = txtColor1
          critIcon.color = iconColor1
          scalex = 0.8
          scaley = 0.8
          scalez = 0.8
        else
          numText.color32 = txtColor2
          critIcon.color = iconColor2
        end
      else
        numText.color32 = txtColor3
        critIcon.color = iconColor3
      end
      if not scalex then
        local x, y, z = root.transform:Get_localScale()
        scalex = x
        scaley = y
        scalez = z
      end
      if CommonUtil.IsArabicAutoMirrorOpen() then
        scalex = -scalex
      end
      root.transform:Set_localScale(scalex, scaley, scalez)
      numText.text = "-" .. damageTxt
      data.obj = root
      data.numText = numText
      data.critIcon = critIcon
      root:SetActive(data.stateTime > 0)
    end)
  elseif data.obj ~= nil then
    data.obj.transform.position = pos
    local scalex, scaley, scalez
    if bulletData.type == BanquetAttackMonsterBulletType.Normal then
      if not isHit then
        data.numText.color32 = txtColor1
        data.critIcon.color = iconColor1
        scalex = 0.8
        scaley = 0.8
        scalez = 0.8
      else
        data.numText.color32 = txtColor2
        data.critIcon.color = iconColor2
      end
    else
      data.numText.color32 = txtColor3
      data.critIcon.color = iconColor3
    end
    if not scalex then
      local x, y, z = data.obj.transform:Get_localScale()
      scalex = x
      scaley = y
      scalez = z
    end
    if CommonUtil.IsArabicAutoMirrorOpen() then
      scalex = -scalex
    end
    data.obj.transform:Set_localScale(scalex, scaley, scalez)
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
      v.req:Destroy()
    end
  end
  self.damageTxtUseList = {}
  for k, v in pairs(self.damageTxtCacheList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.damageTxtCacheList = {}
end

function BulletsAndEffectsModelManager:TryBulletModelStart(data)
  self.bulletData = data
  local type = data.type
  if type == BanquetAttackMonsterBulletType.Normal then
    local bulletData
    if #self.bulletCacheList > 0 then
      local getInex = #self.bulletCacheList
      bulletData = self.bulletCacheList[getInex]
      self.bulletCacheList[getInex] = nil
    else
      bulletData = {}
    end
    bulletData.state = bulletState.Wait
    bulletData.data = data
    bulletData.waitTime = 0.001
    bulletData.flyTime = 0.2 / data.speed
    bulletData.stateTime = bulletData.waitTime
    table.insert(self.bulletUseList, 1, bulletData)
  else
    local bulletData
    if 0 < #self.bullet2CacheList then
      local getInex = #self.bullet2CacheList
      bulletData = self.bullet2CacheList[getInex]
      self.bullet2CacheList[getInex] = nil
    else
      bulletData = {}
    end
    bulletData.state = bulletState.Wait
    bulletData.data = data
    bulletData.waitTime = 0.001
    bulletData.flyTime = 0.3 / data.speed
    bulletData.stateTime = bulletData.waitTime
    table.insert(self.bullet2UseList, 1, bulletData)
  end
end

return BulletsAndEffectsModelManager
