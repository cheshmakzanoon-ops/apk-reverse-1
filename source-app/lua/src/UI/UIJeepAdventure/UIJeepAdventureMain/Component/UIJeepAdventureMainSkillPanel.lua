local UIJeepAdventureMainSkillPanel = BaseClass("UIJeepAdventureMainSkillPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.imgClip:SetSizeDeltaY(self.imgClipHeight)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.imgClip = self:AddComponent(UIImage, "Clip")
  self.textTime = self:AddComponent(UIText, "TimeText")
  self.imgClipHeight = self.imgClip:GetSizeDelta().y
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.imgClip = nil
  self.textTime = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, cfg)
  if cfg.type == HummerSceneTriggerType.Air or cfg.type == HummerSceneTriggerType.SpeedAdd then
    self.imgIcon:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, cfg.buffIcon))
    self.cdDuration = cfg.showTime
    self.cdTimer = cfg.showTime
    self:SetActive(true)
    self.cfgType = cfg.type
    if cfg.type == HummerSceneTriggerType.Air then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.hummer_drone_warning, false)
      CommonUtil.VibratorLightImpact()
    elseif cfg.type == HummerSceneTriggerType.SpeedAdd then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.speed_up, false)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.speed_up_bgm, false)
      self.view:SetTopEffectActive(true)
    end
  end
  self:Update()
end

local function Update(self)
  if self.cdTimer then
    if self.cdTimer > 0 then
      local cd_progress = self.cdTimer / self.cdDuration
      self.imgClip:SetSizeDeltaY(self.imgClipHeight * cd_progress)
      self.textTime:SetText(string.format("%.2fs", self.cdTimer))
      self.cdTimer = self.cdTimer - Time.deltaTime
    else
      self.cdDuration = nil
      self.cdTimer = nil
      self:SetActive(false)
      if self.cfgType == HummerSceneTriggerType.Air then
        DataCenter.LWSoundManager:StopSound(50023)
      elseif self.cfgType == HummerSceneTriggerType.SpeedAdd then
        DataCenter.LWSoundManager:StopSound(50021)
        self.view:SetTopEffectActive(false)
      end
    end
  end
end

UIJeepAdventureMainSkillPanel.OnCreate = OnCreate
UIJeepAdventureMainSkillPanel.OnDestroy = OnDestroy
UIJeepAdventureMainSkillPanel.OnEnable = OnEnable
UIJeepAdventureMainSkillPanel.OnDisable = OnDisable
UIJeepAdventureMainSkillPanel.ComponentDefine = ComponentDefine
UIJeepAdventureMainSkillPanel.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainSkillPanel.DataDefine = DataDefine
UIJeepAdventureMainSkillPanel.DataDestroy = DataDestroy
UIJeepAdventureMainSkillPanel.OnAddListener = OnAddListener
UIJeepAdventureMainSkillPanel.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainSkillPanel.Refresh = Refresh
UIJeepAdventureMainSkillPanel.Update = Update
return UIJeepAdventureMainSkillPanel
