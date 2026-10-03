local BuildIceEffect = BaseClass("BuildIceEffect")
local SliderLength = Vector2.New(4.9, 1)
local effectPath = "Assets/Main/Prefabs/Effect/Eff_Common_pobing_01.prefab"

function BuildIceEffect:OnCreate(req)
  if req ~= nil then
    self.request = req
    self.gameObject = req.gameObject
    self.transform = req.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function BuildIceEffect:OnDestroy()
  if self.iceReq then
    self.iceReq:Destroy()
    self.iceReq = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  self.OnUpdatePoint = nil
end

function BuildIceEffect:ComponentDefine()
  self.hpRoot = self.transform:Find("PosGo/Bg")
  self.hpText = self.transform:Find("PosGo/Bg/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = self.transform:Find("PosGo/Bg/Slider"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.effect = self.transform:Find("Ice")
end

function BuildIceEffect:ComponentDestroy()
  self.hpRoot = nil
  self.hpText = nil
  self.slider = nil
  self.effect = nil
  self.endTime = nil
  self.gameObject = nil
  self.transform = nil
end

function BuildIceEffect:DataDefine()
  self.param = nil
  self.maxLod = 2
  self.lastHp = nil
end

function BuildIceEffect:DataDestroy()
  self.param = nil
  self.lastHp = nil
end

function BuildIceEffect:ReInit(param)
  self.param = param
  if self.hpRoot then
    if param.info then
      if param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
        self.hpRoot:Set_localScale(2, 2, 1)
        self.effect:Set_localPosition(0, 0, -3)
      elseif param.isMarch and param.info.IsStrongholdBoss then
        self.hpRoot:Set_localScale(1, 1, 1)
        self.effect:Set_localPosition(0, 0, -6)
      elseif param.info.PointType == WorldPointType.RadarSeasonSnowSurvivor then
        self.hpRoot:Set_localScale(1, 1, 1)
        self.effect:Set_localPosition(0, -0.65, -0.65)
      elseif param.info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
        self.maxLod = 3
        self.hpRoot:Set_localScale(1, 1, 1)
        self.effect:Set_localPosition(0, -0.7, -2)
      else
        self.hpRoot:Set_localScale(1, 1, 1)
        self.effect:Set_localPosition(0, -0.7, -2)
      end
    else
      self.hpRoot:Set_localScale(1, 1, 1)
      self.effect:Set_localPosition(0, -0.7, -2)
    end
  end
  self:InitPosition()
  self:InitIce()
  self:Refresh(param.info)
end

function BuildIceEffect:InitIce()
  if self.iceReq and not self.param and not self.param.info then
    return
  end
  local thermalConductorType
  local worldPointType = self.param.info.PointType
  if worldPointType then
    if worldPointType == WorldPointType.PlayerBuilding then
      thermalConductorType = ThermalConductorType.Base
    elseif worldPointType == WorldPointType.WORLD_ALLIANCE_CITY then
      if SeasonUtil.IsKingCity(self.param.info.cityId) then
        thermalConductorType = ThermalConductorType.Throne
      else
        thermalConductorType = ThermalConductorType.City
      end
    elseif worldPointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      thermalConductorType = ThermalConductorType.Stronghold
    elseif worldPointType == WorldPointType.TREASURE then
      thermalConductorType = ThermalConductorType.Treasure
    elseif worldPointType == WorldPointType.WorldSuppliesPoint then
      thermalConductorType = ThermalConductorType.SeasonGoods
    elseif worldPointType == WorldPointType.RadarSeasonSnowSurvivor then
      thermalConductorType = ThermalConductorType.Survivor
    else
      Logger.LogError("\230\178\161\230\156\137\229\134\176\229\157\151\232\183\175\229\190\132\239\188\140worldPointType=" .. worldPointType)
      return
    end
  else
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.param.info.monsterId)
    if monster and monster.special == WorldMonsterSpecialType.CityStrongholdBOSS then
      thermalConductorType = ThermalConductorType.StrongholdBoss
    else
      thermalConductorType = ThermalConductorType.CommonBoss
    end
  end
  local path = DataCenter.ThermalConductorTemplateManager:GetIcePrefab(thermalConductorType, self.param.uuid)
  self.iceReq = CS.GameEntry.Resource:InstantiateAsync(path)
  self.iceReq:completed("+", function()
    local gameObject = self.iceReq.gameObject
    if IsNull(gameObject) then
      return
    end
    local transform = gameObject.transform
    gameObject:SetActive(true)
    transform:SetParent(self.effect)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_localPosition(0, 0, 0)
    transform:Set_localEulerAngles(-45, 0, 0)
  end)
end

function BuildIceEffect:InitPosition()
  local v3 = SceneUtils.TileIndexToWorld(self.param.posIndex, ForceChangeScene.World)
  if self.param and self.param.tileX == 1 and self.param.tileY == 1 then
    v3.y = 1.68
  else
    v3.y = 0.1
  end
  self.gameObject.transform.position = v3
end

function BuildIceEffect:Refresh(info)
  self.param.info = info
  local conductor = info.thermalConductor
  if conductor and self.hpRoot.gameObject then
    if conductor.hp >= conductor.maxHp then
      self.hpRoot.gameObject:SetActive(false)
    else
      self.hpRoot.gameObject:SetActive(true)
      self.hpText.text = string.GetFormattedSeparatorNum(conductor.hp)
      self.slider.size = Vector2.New(math.max(SliderLength.x * (conductor.hp / conductor.maxHp), 0.1), SliderLength.y)
    end
  end
  if self.lastHp then
    self:ShowReduceEffect(conductor.hp - self.lastHp)
  end
  self.lastHp = conductor.hp
end

function BuildIceEffect:ShowReduceEffect(change)
  if change and 0 <= change then
    return
  end
  if self.lastShowEffectTime and Time.time - self.lastShowEffectTime < 0.5 then
    return
  end
  self.lastShowEffectTime = Time.time
  local pos = self.transform.position
  local tileSize = self.param.info.tileSize or 3
  local position = Vector3.New(pos.x, pos.y, pos.z)
  local tempEffectHandle = CS.GameEntry.Resource:InstantiateAsync(effectPath)
  tempEffectHandle:completed("+", function(req)
    if req.isError then
      return
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if tempEffectHandle then
        tempEffectHandle:Destroy()
        tempEffectHandle = nil
      end
    end, 2)
    local go = req.gameObject
    local trans = go.transform
    trans.transform:Reset()
    tileSize = tileSize * 5
    local randomOffsetX = math.random(-tileSize, tileSize) * 0.1
    local randomOffsetZ = math.random(-tileSize, tileSize) * 0.1
    trans.transform.position = position + Vector3.New(randomOffsetX, 0, randomOffsetZ)
  end)
end

function BuildIceEffect:OnLodChange(lod)
  if self.gameObject and lod then
    self.gameObject:SetActive(lod <= self.maxLod)
  end
end

return BuildIceEffect
