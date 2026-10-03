local BuildFireEffect = BaseClass("BuildFireEffect")
local HeightPositionDelta = Vector3.New(0, 1, 0)
local SliderLength = Vector2.New(4.9, 1)
local Localization = CS.GameEntry.Localization
local WallBarPrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/World/WallBar.prefab"
local WallBar = require("Scene.BuildFireEffect.WallBar")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.isGuardianTower = false
  self.seasonType = SeasonUtil.GetSeasonType()
  self.debugMode = false
  self:ComponentDefine()
  self:DataDefine()
  self:AddListeners()
end

local function AddListeners(self)
  function self.OnUpdatePoint()
    if self and self.gameObject then
      self:OnUpdatePointData()
    end
  end
  
  EventManager:GetInstance():AddListener(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint)
end

local function OnDestroy(self)
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint)
  self.OnUpdatePoint = nil
end

local function OnUpdatePointData(self)
  ProfilerUtil.BeginSample("BuildFireEffect.OnUpdatePointData")
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.param.uuid)
  if not IsNull(info) then
    local skill_cfg
    local isGuardianTower = false
    local shieldSkillInfo = info.shieldSkillInfo
    if shieldSkillInfo ~= nil and self.seasonType == SeasonMapType.Darkness then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now < shieldSkillInfo.OverTime then
        local mgrSkill = DataCenter.AllianceGovernmentSkillManager
        skill_cfg = mgrSkill:GetTemplatesById(shieldSkillInfo.SkillId)
        if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower then
          isGuardianTower = true
          self.shieldSkillInfo = shieldSkillInfo
        end
      end
    end
    local curHp = info.curHp or 1
    local maxHp = self.param.maxHp
    local lastHpTime = info.lastHpTime or self.param.lastHpTime
    local recoverSpeed = self:GetRecoverSpeed()
    if isGuardianTower then
      self.shieldSkillInfo = shieldSkillInfo
    else
      self.shieldSkillInfo = nil
    end
    if info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if detailInfo ~= nil then
        curHp = detailInfo.durability or 0
        lastHpTime = (detailInfo.lastDurabilityTime or 0) * 0.001
        recoverSpeed = detailInfo.durabilitySpeed or 0
      end
    else
      self.param.info = info
    end
    local deltaHp = math.max(maxHp - curHp, 0)
    self.unavailableTime = info.unavailableTime
    self.param.curHp = curHp
    self.param.maxHp = maxHp
    self.param.lastHpTime = lastHpTime
    self.param.recoverSpeed = recoverSpeed
    self.isGuardianTower = isGuardianTower
    if recoverSpeed == 0 then
      self.endTime = lastHpTime
    else
      self.endTime = math.max(0, math.ceil(deltaHp / recoverSpeed)) + lastHpTime
    end
    self:ShowFarmAnim()
    self:GetParam()
  end
  ProfilerUtil.EndSample()
end

local function ComponentDefine(self)
  self.TowerRoot = self.transform:Find("PosGoTower")
  self.hpTowerText = self.transform:Find("PosGoTower/Bg/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
  self.sliderTower1 = self.transform:Find("PosGoTower/Bg/Slider"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.sliderTower2 = self.transform:Find("PosGoTower/Bg/Slider2"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.iconTower = self.transform:Find("PosGoTower/Bg/flag"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  if self.TowerRoot then
    self.TowerRoot.gameObject:SetActive(false)
  end
  self.hpRoot = self.transform:Find("PosGo/Bg")
  self.hpText = self.transform:Find("PosGo/Bg/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = self.transform:Find("PosGo/Bg/Slider"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.effect = self.transform:Find("FireEffRoot/BuildFireEffectMainBuild").gameObject
  self.effectRoot = self.transform:Find("FireEffRoot")
  self.protect_node = self.transform:Find("ProtectNode")
  if self.protect_node then
    self.protect_icon = self.transform:Find("ProtectNode/icon")
    self.protect_time = self.transform:Find("ProtectNode/time"):GetComponent(typeof(CS.SuperTextMesh))
  end
  if self.protect_node then
    self.protect_node.gameObject:SetActive(false)
  end
  self.battle_node = self.transform:Find("BattleNode")
  if self.battle_node then
    self.battle_icon = self.transform:Find("BattleNode/icon")
    self.battle_time = self.transform:Find("BattleNode/time"):GetComponent(typeof(CS.SuperTextMesh))
  end
  if self.battle_node then
    self.battle_node.gameObject:SetActive(false)
  end
  self.isDoAnim = false
  
  function self.timer_action()
    self:Update()
  end
  
  self:AddTimer()
end

local function ComponentDestroy(self)
  if self.wallBar then
    self.wallBar:Delete()
    self.wallBar = nil
  end
  if self.theUuid then
    CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(self.theUuid)
  end
  if self.protect_node and not IsNull(self.protect_node.gameObject) then
    self.protect_node.gameObject:SetActive(false)
  end
  if self.battle_node and not IsNull(self.battle_node.gameObject) then
    self.battle_node.gameObject:SetActive(false)
  end
  self.hpRoot = nil
  self.hpText = nil
  self.slider = nil
  self.effect = nil
  self.effectRoot = nil
  self.protect_node = nil
  self.protect_icon = nil
  self.protect_time = nil
  self.isDoAnim = false
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ShowFarmAnim(self)
  if IsNull(self.effect) then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not BattleFieldUtil.InBattleField() then
    if self.param.info.ownerUid == LuaEntry.Player.uid then
      if self.param.isFakePlayer then
        self.effect:SetActive(self.param.info.curHp < self.param.maxHp)
      else
        self.effect:SetActive(LuaEntry.Effect:CheckCityFarmState())
      end
    elseif curTime < self.param.info.unavailableTime or self.unavailableTime and curTime < self.unavailableTime then
      self.effect:SetActive(true)
    else
      self.effect:SetActive(false)
    end
  else
    self.effect:SetActive(true)
  end
end

local function ReInit(self, param)
  self.param = param
  self.endTime = self.param.endTime
  if self.hpRoot then
    if param.info and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      self.hpRoot:Set_localScale(2, 2, 1)
      self.effectRoot:Set_localPosition(0, 0, -3)
    else
      self.hpRoot:Set_localScale(1, 1, 1)
      self.effectRoot:Set_localPosition(0, 0, 0)
    end
    self.hpRoot:Set_localPosition(0, 1, 0)
  end
  if self.TowerRoot then
    if param.isGuardianTower then
      self.hpRoot.gameObject:SetActive(false)
      self.TowerRoot.gameObject:SetActive(true)
      if self.seasonType == SeasonMapType.Darkness then
        self.iconTower:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_guanzhijineng_mainUI_icon_dianta.png")
        self.iconTower.size = Vector2.New(1, 1)
      end
    else
      self.hpRoot.gameObject:SetActive(true)
      self.TowerRoot.gameObject:SetActive(false)
    end
  end
  self.isGuardianTower = param.isGuardianTower
  self.newRecoverSpeed = nil
  if param.info then
    self.unavailableTime = param.info.unavailableTime
  else
    self.unavailableTime = nil
  end
  if param.isGuardianTower then
    self.shieldSkillInfo = param.shieldSkillInfo
  else
    param.shieldSkillInfo = nil
    self.shieldSkillInfo = nil
  end
  if self.protect_node and param and param.info and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
    local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
    local isAllianceCenterFlag = false
    if self.seasonType == SeasonMapType.CityStronghold and WorldAllianceBuildUtil.IsAllianceCenterFlag(param.buildId) then
      mainBuildId = param.buildId
      isAllianceCenterFlag = true
    end
    if param.info.state == AllianceMineStatus.Build then
      if self.protect_node then
        self.protect_node.gameObject:SetActive(param.buildId == mainBuildId)
      end
      if isAllianceCenterFlag then
        local theUuid = param.uuid
        local now = UITimeManager:GetInstance():GetServerTime()
        self.theUuid = theUuid
        CityDomeProtectEffectManager:GetInstance():ShowBuildProtectEffect(theUuid, self.param.posIndex, now + OneDayTime, 3, nil, 1.5)
      end
    elseif self.battle_node and param.buildId == mainBuildId and param.info.fightState == 1 then
      local mgr = DataCenter.SeasonFactionWarDataManager
      local currStep = mgr:GetCurrStep()
      if self.isGuardianTower or currStep == SeasonFactionDeclareWarStep.battle then
        self.battle_node.gameObject:SetActive(true)
        self.battleStep = currStep
        self.battleEndTime = mgr.stepEndTime
      end
    end
  end
  self:ShowPanel()
  self.isDoAnim = true
  self:ShowFarmAnim()
  self:GetParam()
  self:Update()
  self:RefreshWallBar()
end

function BuildFireEffect:RefreshWallBar()
  local buildInfo = self.param and self.param.info
  local wallBarInfo = buildInfo and buildInfo.wallBarInfo
  if wallBarInfo and wallBarInfo:IsValid() then
    if self.wallBar then
      self.wallBar:SetData(wallBarInfo, self.param.info.pointIndex)
    else
      self.wallBar = WallBar.New("WallBar", self.hpRoot, WallBarPrefabPath)
      self.wallBar:SetData(wallBarInfo, self.param.info.pointIndex)
    end
  elseif self.wallBar then
    self.wallBar:Delete()
    self.wallBar = nil
    if buildInfo then
      self.param.forceShowHpBar = buildInfo.forceShowHpBar
    end
  end
end

local function ShowPanel(self)
  local mainBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
  local v3 = SceneUtils.TileIndexToWorld(self.param.posIndex, ForceChangeScene.World, self.param.serverId)
  if self.param and self.param.tileX == 1 and self.param.tileY == 1 then
    v3.y = 1.68
  end
  if self.param and self.param.info and self.param.info.itemId ~= nil then
    local itemId = self.param.info.itemId
    if self.seasonType == SeasonMapType.Darkness then
      if itemId == mainBuildId then
        v3.z = v3.z + 4
      elseif itemId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN1 or itemId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN2 or itemId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN3 then
        v3.z = v3.z + 2
      end
      if itemId == BuildingTypes.SEASON_POWER_CENTER_PLUGIN1 then
        v3.x = v3.x + 0.5
      end
    elseif itemId == mainBuildId then
      v3.y = v3.y + 3
    end
  end
  self.gameObject.transform.position = v3
end

local function OnUpdateTime(self, endTime, recoverSpeed, unavailableTime, param)
  self.endTime = endTime
  self.isDoAnim = true
  if recoverSpeed then
    self.newRecoverSpeed = recoverSpeed
  end
  if param then
    if self.param == nil then
      self.param = param
    elseif param.maxHp then
      self.param.maxHp = param.maxHp
    end
    self.param.forceShowHpBar = param.forceShowHpBar
  end
  if self.TowerRoot then
    if param.isGuardianTower then
      self.hpRoot.gameObject:SetActive(false)
      self.TowerRoot.gameObject:SetActive(true)
      if self.seasonType == SeasonMapType.Darkness then
        self.iconTower:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_guanzhijineng_mainUI_icon_dianta.png")
        self.iconTower.size = Vector2.New(1, 1)
      end
    else
      self.hpRoot.gameObject:SetActive(true)
      self.TowerRoot.gameObject:SetActive(false)
    end
  end
  self.isGuardianTower = param.isGuardianTower
  if param.isGuardianTower then
    self.shieldSkillInfo = param.shieldSkillInfo
  else
    param.shieldSkillInfo = nil
    self.shieldSkillInfo = nil
  end
  if unavailableTime then
    self.unavailableTime = unavailableTime
    self:ShowFarmAnim()
    self:GetParam()
  end
end

function BuildFireEffect:IsShowFarmAnim()
  local param = self.param
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if LuaEntry.Effect:CheckCityFarmState() and param.info.ownerUid == LuaEntry.Player.uid or curTime < param.info.unavailableTime and param.info.ownerUid ~= LuaEntry.Player.uid or self.unavailableTime and curTime < self.unavailableTime and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
    return true
  end
end

function BuildFireEffect:GetParam()
  local param = {}
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.param.isFakePlayer then
    param.state = WorldLifebaState.FakePlayer
  else
    local burnTime = self.param.info.unavailableTime / 1000
    if curTime < burnTime then
      param.state = WorldLifebaState.Burn
    elseif self.param.curHp < self.param.maxHp then
      param.state = WorldLifebaState.Normal
    end
  end
  self.stateParam = param
end

function BuildFireEffect:GetIsShowTimeEffect()
  if BattleFieldUtil.InBattleField() then
    return self.param.info.curHp < self.param.maxHp
  end
  local param = self.param
  if self.isGuardianTower or param.forceShowHpBar then
    return true
  end
  if param.info and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
    return self:GetCurHp() < self.param.maxHp
  end
  if self.stateParam.state == WorldLifebaState.FakePlayer then
    return true
  elseif self.stateParam.state == WorldLifebaState.Burn then
    return true
  elseif self.stateParam.state == WorldLifebaState.Normal then
    if self.param.info.curHp == self.param.maxHp then
      return false
    else
      return true
    end
  end
end

function BuildFireEffect:GetRecoverSpeed()
  if self.isGuardianTower or self.param and self.param.isGuardianTower == true then
    return 0
  end
  local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId(self.seasonType)
  local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2", 0.3)
  if self.param and (self.param.buildId == mainBuildId or self.param.buildId == carrierBuildId) then
    recoverSpeed = 0
  end
  if self.param and SeasonUtil.IsSeasonMilitaryCenterOrPlugin(self.param.buildId, self.seasonType) then
    recoverSpeed = 0
  end
  if self.param and self.param.recoverSpeed ~= nil and self.param.recoverSpeed ~= 0 then
    recoverSpeed = self.param.recoverSpeed
  end
  if self.newRecoverSpeed then
    recoverSpeed = self.newRecoverSpeed
  end
  return recoverSpeed
end

function BuildFireEffect:GetCurHp()
  if self.isGuardianTower or BattleFieldUtil.InBattleField() then
    return self.param.curHp
  elseif self.param and (self.stateParam.state == WorldLifebaState.Normal or self.stateParam.state == WorldLifebaState.Burn) then
    local param = self.param
    local cur_hp = param.curHp
    local recoverSpeed = self:GetRecoverSpeed()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = curTime - param.lastHpTime
    if 0 < recoverSpeed then
      if param.info and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
        cur_hp = math.min(deltaTime * recoverSpeed + cur_hp, param.maxHp)
      elseif param.info.unavailableTime and param.info.unavailableTime ~= 0 then
        cur_hp = BuildingUtils.GetBuildHp(param.curHp, param.info.lastHpTime, param.info.unavailableTime / 1000, recoverSpeed, param.info.fireSpeed)
      else
        cur_hp = math.min(deltaTime * recoverSpeed + cur_hp, param.maxHp)
      end
      if self.protect_node and not IsNull(self.protect_node.gameObject) then
        if param and self.protect_time and param.info and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD and param.info.state == AllianceMineStatus.Build then
          local deltaHP = param.maxHp - cur_hp
          if 0 < deltaHP then
            local needTime = deltaHP / recoverSpeed
            local txt = Localization:GetString("456521")
            self.protect_time.text = txt .. UITimeManager:GetInstance():SecondToFmtStringWithoutDay(needTime)
            local textWidth = self.protect_time:GetWidth()
            self.protect_icon.gameObject.transform:Set_localPosition(-textWidth * 0.5 - 0.14, 0, 0)
          elseif self.protect_node then
            self.protect_node.gameObject:SetActive(false)
          end
        elseif self.protect_node then
          self.protect_node.gameObject:SetActive(false)
        end
      end
      cur_hp = math.floor(math.min(cur_hp, param.maxHp))
      cur_hp = math.max(cur_hp, 0)
    elseif self.protect_node and not IsNull(self.protect_node.gameObject) then
      self.protect_node.gameObject:SetActive(false)
    end
    return cur_hp
  end
  return self.param.curHp
end

local function Update(self)
  if self.isDoAnim then
    local param = self.param
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if self.battle_node and param and param.info and (param.info.fightState == 1 or self.isGuardianTower) and param.info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      local cur_hp = toInt(param.curHp)
      if self.isGuardianTower and self.shieldSkillInfo then
        local now = UITimeManager:GetInstance():GetServerTime()
        local curHp = toInt(self.shieldSkillInfo.CurShield)
        local maxHp = toInt(self.shieldSkillInfo.MaxShield)
        local overTime = toInt(self.shieldSkillInfo.OverTime)
        self.hpTowerText.text = string.GetFormattedSeperatorNum(curHp)
        self.sliderTower1.size = Vector2.New(math.max(SliderLength.x * (curHp / maxHp), 0.1), SliderLength.y)
        self.sliderTower2.size = Vector2.New(math.max(4.98 * (cur_hp / param.maxHp), 0.1), 0.2)
        self.iconTower.size = Vector2.New(1, 1)
        if overTime ~= 0 and now > overTime and not self.over then
          local theUuid = param.uuid
          local _world = CS.SceneManager.World
          if _world ~= nil then
            local obj = _world:GetObjectByUuid(theUuid)
            if obj ~= nil then
              obj:Destroy()
              obj:CreateGameObject()
              self.isDoAnim = false
              BuildFireEffectManager:GetInstance():RemoveOneEffect(theUuid)
            end
          end
        end
      else
        self.hpText.text = string.GetFormattedSeperatorNum(cur_hp)
        self.slider.size = Vector2.New(math.max(SliderLength.x * (cur_hp / param.maxHp), 0.1), SliderLength.y)
      end
      if IsNotNull(self.effect) then
        self.effect:SetActive(cur_hp ~= param.maxHp)
      end
      if self.battleEndTime then
        local now = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.battleEndTime - now
        if 0 <= deltaTime then
          local txt = Localization:GetString("season_s2_win_popui008", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
          self.battle_time.text = txt
          local textWidth = self.battle_time:GetWidth()
          self.battle_icon.gameObject.transform:Set_localPosition(-textWidth * 0.5 - 0.14, 0, 0)
        else
          self.battle_node.gameObject:SetActive(false)
        end
      else
        self.battle_node.gameObject:SetActive(false)
      end
    elseif not self:GetIsShowTimeEffect(curTime) then
      self.isDoAnim = false
      EventManager:GetInstance():Broadcast(EventId.PlayerHPChanged, self.param.uuid)
      BuildFireEffectManager:GetInstance():RemoveOneEffect(self.param.uuid)
    else
      local cur_hp = self:GetCurHp(curTime)
      if param.maxHp ~= nil and cur_hp >= param.maxHp and self.stateParam.state ~= WorldLifebaState.Burn and not param.forceShowHpBar then
        self.isDoAnim = false
        EventManager:GetInstance():Broadcast(EventId.PlayerHPChanged, self.param.uuid)
        BuildFireEffectManager:GetInstance():RemoveOneEffect(self.param.uuid)
      elseif cur_hp ~= nil then
        self.hpText.text = string.GetFormattedSeparatorNum(cur_hp)
        self.slider.size = Vector2.New(math.max(SliderLength.x * (cur_hp / self.param.maxHp), 0.1), SliderLength.y)
        if self.debugMode then
          self.hpText.text = string.GetFormattedSeparatorNum(cur_hp) .. "/" .. string.GetFormattedSeparatorNum(param.maxHp)
        end
        self:RefreshWallBar()
      end
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function OnLodChange(self, lod)
  self.theLod = lod
  if not IsNull(self.gameObject) and lod then
    self.gameObject:SetActive(lod < 3)
  end
end

BuildFireEffect.OnCreate = OnCreate
BuildFireEffect.OnDestroy = OnDestroy
BuildFireEffect.ComponentDefine = ComponentDefine
BuildFireEffect.ComponentDestroy = ComponentDestroy
BuildFireEffect.DataDefine = DataDefine
BuildFireEffect.DataDestroy = DataDestroy
BuildFireEffect.ReInit = ReInit
BuildFireEffect.ShowPanel = ShowPanel
BuildFireEffect.OnUpdateTime = OnUpdateTime
BuildFireEffect.Update = Update
BuildFireEffect.DeleteTimer = DeleteTimer
BuildFireEffect.AddTimer = AddTimer
BuildFireEffect.OnLodChange = OnLodChange
BuildFireEffect.OnUpdatePointData = OnUpdatePointData
BuildFireEffect.AddListeners = AddListeners
BuildFireEffect.ShowFarmAnim = ShowFarmAnim
return BuildFireEffect
