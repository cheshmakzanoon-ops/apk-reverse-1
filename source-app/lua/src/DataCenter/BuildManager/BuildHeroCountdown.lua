local BuildHeroCountdown = BaseClass("BuildHeroCountdown")
local Resource = CS.GameEntry.Resource
local slowSpeed = 0.03

local function SetAnimationSpeedSlow(modelObject)
  local animation = modelObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(animation) then
    animation:Stop()
    animation:SetStateSpeed("idle", slowSpeed)
    animation:Play("idle")
  end
end

function BuildHeroCountdown:__init(param)
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self.pointId = param.pId
  self.buildId = param.bId
  self.herorId = param.heroId
  self.buildUuid = param.uuid
  self.bubbleTip = nil
  self.timelineSyncHandle = nil
  self.loadingRetryDelay = 0
  self.loadingRetryDelayStep = 0.02
  self:Create(self.loadingRetryDelay)
end

function BuildHeroCountdown:__delete()
  self:Destroy()
end

function BuildHeroCountdown:Destroy()
  if self.bubbleTip ~= nil then
    self.bubbleTip:OnDestroy()
    self.bubbleTip = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.gameObject = nil
  self.transform = nil
  self.param = nil
  self.pointId = nil
  self.buildId = nil
  self.herorId = nil
  self.buildTf = nil
  self.timelineSyncHandle = nil
  self.loadingRetryDelay = nil
  self.loadingRetryDelayStep = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function BuildHeroCountdown:Create(delay)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:LoadHero()
  end, delay)
end

function BuildHeroCountdown:Reset(param)
  self:Destroy()
  self.param = param
  self.pointId = param.pId
  self.buildId = param.bId
  self.herorId = param.heroId
  self.buildUuid = param.uuid
  self.loadingRetryDelay = 0
  self.loadingRetryDelayStep = 0.02
  self:LoadHero()
end

function BuildHeroCountdown:ReloadHero()
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
  self.param = prevParam
  self.pointId = prevPointId
  self.buildId = prevBuildId
  self.herorId = prevHerorId
  self.buildUuid = prevBuildUuid
  self.loadingRetryDelay = prevLoadingRetryDelay
  self.loadingRetryDelayStep = prevLoadingRetryDelayStep
  self:LoadHero()
end

function BuildHeroCountdown:GetBuildUuid()
  return self.buildUuid
end

function BuildHeroCountdown:LoadHero()
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
        self.gameObject:SetActive(true)
        self.animation = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if not IsNull(self.animation) then
          self.animation.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
        end
      end)
    end
  end
end

return BuildHeroCountdown
