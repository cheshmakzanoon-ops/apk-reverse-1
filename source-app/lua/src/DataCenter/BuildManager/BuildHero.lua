local BuildHero = BaseClass("BuildHero")
local Resource = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local AirDropTimeLine1 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline.prefab"
local AirDropTimeLine2 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline02.prefab"
local AirDropEffectPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_tudou_somke.prefab"
local HeroBoxPrefabPath = "Assets/_Art_LastWar/Models/Characters/Object/A_pror_container_01/prefab/A_pror_container_01_1.prefab"
local HeroBoxOpenPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_xiangzi_open.prefab"
local slowSpeed = 0.03

local function SetAnimationSpeedSlow(modelObject)
  local animation = modelObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(animation) then
    animation:Stop()
    animation:SetStateSpeed("idle", slowSpeed)
    animation:Play("idle")
  end
end

function BuildHero:__init(param, is_init)
  self.isInit = is_init or false
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self.pointId = param.pId
  self.buildId = param.bId
  self.herorId = param.prodStatus
  self.buildUuid = param.uuid
  self.bubbleTip = nil
  self.timelineSyncHandle = nil
  self.loadingRetryDelay = 0
  self.loadingRetryDelayStep = 0.02
  self:Create(self.loadingRetryDelay)
end

function BuildHero:Destroy()
  if self.bubbleTip ~= nil then
    self.bubbleTip:OnDestroy()
    self.bubbleTip = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  if self.herorId then
    DataCenter.BuildHeroManager.dropAnimCtrl:DestroyBox(self.herorId)
  end
  self.gameObject = nil
  self.transform = nil
  self.param = nil
  self.pointId = nil
  self.buildId = nil
  self.herorId = nil
  self.isInit = nil
  self.buildTf = nil
  self.timelineSyncHandle = nil
  self.loadingRetryDelay = nil
  self.loadingRetryDelayStep = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function BuildHero:Create(delay)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:LoadHero()
  end, delay)
end

function BuildHero:Reset(param)
  self:Destroy()
  self.isInit = true
  self.param = param
  self.pointId = param.pId
  self.buildId = param.bId
  self.herorId = param.prodStatus
  self.buildUuid = param.uuid
  self.loadingRetryDelay = 0
  self.loadingRetryDelayStep = 0.02
  self:LoadHero()
end

function BuildHero:ReloadHero()
  if not self.buildUuid then
    return
  end
  local prevParam = self.param
  local prevPointId = self.pointId
  local prevBuildId = self.buildId
  local prevHerorId = self.herorId
  local prevBuildUuid = self.buildUuid
  local prevLoadingRetryDelay = self.loadingRetryDelay
  local prevLoadingRetryDelayStep = self.loadingRetryDelayStep
  self:Destroy()
  self.isInit = true
  self.param = prevParam
  self.pointId = prevPointId
  self.buildId = prevBuildId
  self.herorId = prevHerorId
  self.buildUuid = prevBuildUuid
  self.loadingRetryDelay = prevLoadingRetryDelay
  self.loadingRetryDelayStep = prevLoadingRetryDelayStep
  self:LoadHero()
end

function BuildHero:GetBuildUuid()
  return self.buildUuid
end

function BuildHero:LoadHero()
  if self.req == nil then
    local city_build_obj = CS.SceneManager.World and CS.SceneManager.World:GetBuildingByPoint(self.pointId) or nil
    if IsNull(city_build_obj) then
      self.loadingRetryDelay = self.loadingRetryDelay + self.loadingRetryDelayStep
      self.loadingRetryDelayStep = self.loadingRetryDelayStep * 2
      self:Create(self.loadingRetryDelay)
      return
    end
    self.buildTf = city_build_obj.gameObject.transform:Find("ModelGo/Normal")
    if not IsNull(self.buildTf) then
      local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(self.herorId)
      local modelId = self.herorId
      if hero_data then
        modelId = hero_data.modelId
      end
      local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
      if not line then
        Logger.LogError("TableName.HeroAppearance line not found. id:" .. self.herorId)
        return
      end
      self.req = Resource:InstantiateAsync(line.city_model_path)
      self.req:completed("+", function()
        self.gameObject = self.req.gameObject
        self.transform = self.req.gameObject.transform
        self.transform:SetParent(self.buildTf)
        self.transform.localPosition = Vector3.New(-1, 0, -1)
        self.transform:Set_eulerAngles(0, 180, 0)
        self.transform:Set_localScale(1, 1, 1)
        self.gameObject:SetActive(self.isInit)
        self.animation = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if not IsNull(self.animation) then
          self.animation.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
        end
        local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(self.herorId)
        if hero_data and hero_data.heroType == HeroType.Aircraft then
          SetAnimationSpeedSlow(self.gameObject)
        end
        if not self.isInit then
          local pos = SceneUtils.TileIndexToWorld(self.pointId)
          DataCenter.BuildHeroManager.dropAnimCtrl:CreateQuest(self.herorId, pos, Vector3(0, 0, -1), Vector3(-1, 0, -1), Vector3(-1, 0, -1), function(self)
            if not IsNull(self.gameObject) then
              self.gameObject:SetActive(true)
            end
          end, self)
        end
      end)
    end
  end
end

function BuildHero:CheckHeroUpgrade()
  local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(self.herorId)
  if hero_data == nil then
    return false
  end
  if hero_data:ShowSkillRedPoint() then
    return true
  end
  if hero_data:ShowReplaceEquipRedPoint() then
    return true
  end
  if self:ShowUpgradeRedPoint(hero_data) then
    return true
  end
  return false
end

function BuildHero:ShowUpgradeRedPoint(hero_data)
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  local heroFianlLevel = hero_data.finalLevel
  local heroLevel = hero_data.level
  if heroFianlLevel <= heroLevel then
    return false
  elseif heroLevelLimit <= heroLevel then
    return false
  else
    local showUpgradeRedPoint = true
    local costMoneyCount = HeroUtils.GetLevelUpSpeedGold(heroLevel)
    local hasMoneyCount = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
    if 0 < costMoneyCount and costMoneyCount > hasMoneyCount then
      showUpgradeRedPoint = false
    end
    local costExpCount = HeroUtils.GetLevelUpNeedExp(hero_data.level)
    local hasExpCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
    if 0 < costExpCount and costExpCount > hasExpCount then
      showUpgradeRedPoint = false
    end
    return showUpgradeRedPoint
  end
end

return BuildHero
