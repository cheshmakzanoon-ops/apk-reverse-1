local UIHeroExhibitPreviewPage = BaseClass("UIHeroExhibitPreviewPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local rtPath = "SkillPreviewRT"
local heroPropertyDetailBtnPath = "PropertyDetailInfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.isSetData = false
end

local function ReleaseRT(self)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function OnDestroy(self)
  if self.isSetData then
    self.isSetData = false
    DataCenter.PreviewHeroExhibitEffectManager:Exit()
  else
    DataCenter.PreviewHeroExhibitEffectManager:Destroy()
  end
  ReleaseRT(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.templateHeroData = nil
  self.heroData = nil
end

local function DataDestroy(self)
  if self.templateHeroData ~= nil then
    self.templateHeroData:Delete()
    self.templateHeroData = nil
  end
  self.heroData = nil
end

local function ComponentDefine(self)
  self.image = self:AddComponent(UIRawImage, rtPath)
  self.powerNumText = self:AddComponent(UIText, "PowerInfo/PowerNumberText")
  self.heroPropertyDetailBtn = self:AddComponent(UIButton, heroPropertyDetailBtnPath)
  self.heroPropertyDetailBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    HeroUtils.OpenHeroDetailPropertyView(self.heroData, UIHeroPropertyDetailType.Hero)
  end)
end

local function ComponentDestroy(self)
  self.image = nil
  self.powerNumText = nil
  self.heroPropertyDetailBtn = nil
end

local function SetData(self, heroData, gm_appearanceId)
  if heroData == nil then
    return
  end
  self.heroData = heroData
  if self.isSetData then
    self.isSetData = false
    DataCenter.PreviewHeroExhibitEffectManager:Exit()
  else
    DataCenter.PreviewHeroExhibitEffectManager:Destroy()
  end
  if self.renderTexture == nil then
    local rtWidth = DefaultScreenWidth
    local rtHeight = DefaultScreenHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "SkillPreviewRT"
    self.image:SetTexture(self.renderTexture)
    self.image:SetEnable(false)
    self.image:SetColor(Color.white)
  end
  if self.templateHeroData == nil then
    self.templateHeroData = HeroInfo.New()
  end
  self.templateHeroData:UpdateFromTemplate(heroData.heroId)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroData.modelId)
  if gm_appearanceId then
    newAppearanceId = gm_appearanceId
  end
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  local param = {}
  param.hero = self.templateHeroData
  param.modelData = line.hero_showtime_name
  param.modelDir = line.hero_showtime_name_path
  if not string.IsNullOrEmpty(param.modelData) then
    DataCenter.PreviewHeroExhibitEffectManager:Enter(param)
    self.isSetData = true
    self.image:SetActive(true)
  else
    self.image:SetActive(false)
    UIUtil.ShowTipsId(152070)
  end
  local soundId = tonumber(line.hero_showtime_sound) or 0
  if soundId and 0 < soundId then
    DataCenter.LWSoundManager:PlayEffect(soundId)
  end
end

local function OnPreviewSkillInit(self)
  if self.image ~= nil and self.renderTexture ~= nil then
    self.image:SetEnable(true)
    DataCenter.PreviewHeroExhibitEffectManager.rtRect = self.image.transform
    DataCenter.PreviewHeroExhibitEffectManager.camera.targetTexture = self.renderTexture
  end
end

local function OnHeroChanged(self)
  if not self.active then
    return
  end
  if not self.heroData then
    return
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PreviewHeroExhibitSceneInit, OnPreviewSkillInit)
  self:AddUIListener(EventId.HeroLvUpSuccess, OnHeroChanged)
  self:AddUIListener(EventId.HeroBeyondSuccess, OnHeroChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PreviewHeroExhibitSceneInit, OnPreviewSkillInit)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, OnHeroChanged)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, OnHeroChanged)
  base.OnRemoveListener(self)
end

UIHeroExhibitPreviewPage.OnCreate = OnCreate
UIHeroExhibitPreviewPage.OnDestroy = OnDestroy
UIHeroExhibitPreviewPage.DataDefine = DataDefine
UIHeroExhibitPreviewPage.DataDestroy = DataDestroy
UIHeroExhibitPreviewPage.ComponentDefine = ComponentDefine
UIHeroExhibitPreviewPage.ComponentDestroy = ComponentDestroy
UIHeroExhibitPreviewPage.SetData = SetData
UIHeroExhibitPreviewPage.OnAddListener = OnAddListener
UIHeroExhibitPreviewPage.OnRemoveListener = OnRemoveListener
return UIHeroExhibitPreviewPage
