local UISeasonBtnEffect = BaseClass("UISeasonBtnEffect", UIAsyncContainer)
local base = UIAsyncContainer
local open_path = "open"
local idle_path = "idle"

function UISeasonBtnEffect:OnCreate()
  base.OnCreate(self)
  local seasonTypeNow = SeasonUtil.GetSeasonType()
  self.eff_ui_open = self:AddComponent(UIBaseComponent, open_path)
  self.eff_ui_idle = self:AddComponent(UIBaseComponent, idle_path)
  if seasonTypeNow == SeasonMapType.Darkness then
    self.common_xueye = self:TryAddComponent(UIAnimator, "common_xueye")
    self.xueye_common = self:TryAddComponent(UIAnimator, "xueye_common")
    self.xueye_idle = self:TryAddComponent(UIBaseContainer, "xueye_idle")
  end
  self.seasonTypeNow = seasonTypeNow
end

function UISeasonBtnEffect:OnDestroy()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.eff_ui_open = nil
  self.eff_ui_idle = nil
  self.common_xueye = nil
  self.xueye_common = nil
  self.xueye_idle = nil
  base.OnDestroy(self)
end

function UISeasonBtnEffect:UpdateData()
  if IsNotNull(self.gameObject) then
    self:ReInit()
  end
end

local function SetNodeActive(node, active)
  if node then
    node:SetActive(active)
  end
end

function UISeasonBtnEffect:ReInit()
  if IsNull(self.gameObject) then
    return
  end
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config then
    local theType = config.type
    self.isLondonSeason = config.season_icon == "Mjc_saiji2_zhujiemian_cion_new"
    self.seasonType = theType
  end
  if self.seasonTypeNow == SeasonMapType.Darkness then
    self:HandleDarkness()
  elseif self.seasonType == SeasonMapType.Snow and not self.isLondonSeason then
    if self.eff_ui_idle and not self.eff_ui_idle:GetActive() then
      local hasIceExist = Setting:GetPrivateString("eff_ui_snow_mode")
      self.iconHasSnow = string.IsNullOrEmpty(hasIceExist)
      self.eff_ui_idle:SetActive(self.iconHasSnow)
    end
  else
    SetNodeActive(self.eff_ui_idle, true)
  end
  SetNodeActive(self.eff_ui_open, false)
end

function UISeasonBtnEffect:TryShowOpenEffect(callback)
  if IsNull(self.gameObject) or self.isBloodyNight or self.timer ~= nil then
    if callback then
      pcall(callback)
    end
    return
  end
  if self.seasonType == SeasonMapType.Snow and not self.isLondonSeason then
  else
    SetNodeActive(self.eff_ui_idle, false)
    if self.eff_ui_open then
      self.eff_ui_open:SetActive(true)
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.timer = nil
        if callback then
          pcall(callback)
        end
      end, 0.3)
      return
    end
  end
  if callback then
    pcall(callback)
  end
end

function UISeasonBtnEffect:TryShowPlotEffect(callback)
  if IsNull(self.gameObject) then
    if callback then
      pcall(callback)
    end
    return
  end
  if self.iconHasSnow and self.seasonType == SeasonMapType.Snow and not self.isLondonSeason and self.eff_ui_idle and self.eff_ui_open then
    Setting:SetPrivateString("eff_ui_snow_mode", "2024")
    SetNodeActive(self.eff_ui_open, true)
    self.iconHasSnow = false
    TimerManager:GetInstance():DelayInvoke(function()
      self.iconHasSnow = false
      SetNodeActive(self.eff_ui_idle, false)
    end, 0.2)
    TimerManager:GetInstance():DelayInvoke(function()
      if callback then
        pcall(callback)
      end
      SetNodeActive(self.eff_ui_open, false)
    end, 1)
    return
  end
  if callback then
    pcall(callback)
  end
end

function UISeasonBtnEffect:HandleDarkness()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight()
  if self.isBloodyNight ~= nil and self.isBloodyNight ~= isBloodyNight then
    if isBloodyNight then
      SetNodeActive(self.xueye_idle, false)
      SetNodeActive(self.eff_ui_idle, false)
      SetNodeActive(self.common_xueye, true)
      SetNodeActive(self.xueye_common, false)
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        SetNodeActive(self.common_xueye, false)
        SetNodeActive(self.xueye_idle, true)
        self.timer = nil
      end, 2)
    else
      SetNodeActive(self.xueye_idle, false)
      SetNodeActive(self.eff_ui_idle, false)
      SetNodeActive(self.common_xueye, false)
      SetNodeActive(self.xueye_common, true)
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        SetNodeActive(self.xueye_common, false)
        SetNodeActive(self.eff_ui_idle, true)
        self.timer = nil
      end, 2)
    end
  elseif self.xueye_idle ~= nil and isBloodyNight then
    SetNodeActive(self.xueye_idle, true)
    SetNodeActive(self.eff_ui_idle, false)
    SetNodeActive(self.common_xueye, false)
    SetNodeActive(self.xueye_common, false)
  else
    SetNodeActive(self.eff_ui_idle, true)
    SetNodeActive(self.xueye_idle, false)
    SetNodeActive(self.common_xueye, false)
    SetNodeActive(self.xueye_common, false)
  end
  self.isBloodyNight = isBloodyNight
end

function UISeasonBtnEffect:OnCloseUI(uiName)
  if IsNull(self.gameObject) then
    return
  end
  SetNodeActive(self.eff_ui_idle, true)
  SetNodeActive(self.eff_ui_open, false)
end

function UISeasonBtnEffect.CreateEffectManager(parent, callback)
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config and ComponentIsValid(parent) and parent.instanceOf and parent:instanceOf("UIBaseComponent") then
    local effectPath
    local seasonType = config.type
    local seasonType2 = config.type2
    local isLondonSeason = config.season_icon == "Mjc_saiji2_zhujiemian_cion_new"
    if isLondonSeason then
      effectPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBtnEffectS1.prefab"
    elseif seasonType == SeasonMapType.Snow then
      effectPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBtnEffectS2.prefab"
    elseif seasonType == SeasonMapType.Mummy then
      effectPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWMainUI/LWSeasonBtnEffectS3.prefab"
    elseif seasonType == SeasonMapType.Darkness then
      effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/Eff_ui_saijirukou.prefab"
    end
    if effectPath then
      if not SeasonUtil.CheckSeasonResource() then
        local packageId, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(false)
        if packageId ~= nil and needInPreviewMode then
          return nil
        end
      end
      return UIBaseComponent.LoadComponentAsync(parent, UISeasonBtnEffect, effectPath, parent, callback)
    end
  end
  return nil
end

return UISeasonBtnEffect
