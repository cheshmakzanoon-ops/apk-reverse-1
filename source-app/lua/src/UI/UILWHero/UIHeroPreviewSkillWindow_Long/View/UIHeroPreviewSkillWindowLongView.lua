local base = require("UI/UILWHero/UIHeroPreviewSkillWindow/View/UIHeroPreviewSkillWindowView")
local UIHeroPreviewSkillWindowLongView = BaseClass("UIHeroPreviewSkillWindowLongView", base)
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
UIHeroPreviewSkillWindowLongView.RTWidth = 670
UIHeroPreviewSkillWindowLongView.RTHeight = 840

function UIHeroPreviewSkillWindowLongView:OnOpen()
  self.heroId, self.skillId, self.skillLv, self.skillMaxLv, self.weaponLv, self.addCustomSkillInfoList, self.customTitle, self.customDuration, self.isMonsterShowBorn = self:GetUserData()
  if not self.heroId or not self.skillId then
    self:OnBtnCloseClick()
    return
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  if skillTemplate == nil then
    self:OnBtnCloseClick()
    return
  end
  if not string.IsNullOrEmpty(self.customTitle) then
    self.skillNameText:SetText(self.customTitle)
  else
    local str = ""
    if self.skillLv > 0 then
      str = string.format("%s (Lv%d/%d)", Localization:GetString(skillTemplate.name), self.skillLv, self.skillMaxLv)
    else
      str = Localization:GetString(skillTemplate.name)
    end
    self.skillNameText:SetText(str)
  end
  self:RefreshSkillPreview()
end

function UIHeroPreviewSkillWindowLongView:RefreshSkillPreview()
  DataCenter.PreviewSkillEffectManager:Destroy()
  if self.renderTexture == nil then
    local rtWidth = self.RTWidth
    local rtHeight = self.RTHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "SkillPreviewRT"
    self.previewSkillRt:SetTexture(self.renderTexture)
    self.previewSkillRt:SetEnable(true)
    self.previewSkillRt:SetColor(Color.white)
  end
  if self.templateHeroData == nil then
    self.templateHeroData = HeroInfo.New()
  end
  self.templateHeroData:UpdateFromTemplate(self.heroId, nil, nil, nil, self.weaponLv)
  local properties = DataCenter.HeroParamDataManager.heroSkillPreviewProperties
  for id, value in pairs(properties) do
    self.templateHeroData.propertyData:SetProperty(id, value)
  end
  self.templateHeroData.skillDict = {}
  self.templateHeroData.skillList = {}
  local skillInfo = SkillInfo.New()
  local skillInfoParam = {}
  skillInfoParam.skillId = self.skillId
  skillInfoParam.level = self.skillLv
  skillInfoParam.state = 1
  skillInfo:UpdateSkillInfo(skillInfoParam)
  local heroSkillTemplate = DeepCopy(skillInfo.skillTemplateData)
  self.ctrl:ProcessSkillTemplate(heroSkillTemplate, false)
  skillInfo.skillTemplateData = heroSkillTemplate
  self.templateHeroData.skillDict[skillInfo.skillId] = skillInfo
  self.templateHeroData.skillList[1] = skillInfo
  if not skillInfo then
    return
  end
  local heroSkillPerformTemplate = DataCenter.HeroSkillPerformTemplateManager:GetTemplate(skillInfo.skillId)
  if heroSkillPerformTemplate == nil then
    return
  end
  local additionalSkillInfoList = heroSkillPerformTemplate:GetAdditionalSkillInfoList()
  if not table.IsNullOrEmpty(additionalSkillInfoList) then
    for i, v in ipairs(additionalSkillInfoList) do
      self.ctrl:ProcessSkillTemplate(v.skillTemplateData, true)
      self.templateHeroData.skillDict[v.skillId] = v
      self.templateHeroData.skillList[#self.templateHeroData.skillList + 1] = v
    end
  end
  if not table.IsNullOrEmpty(self.addCustomSkillInfoList) then
    for i, v in ipairs(self.addCustomSkillInfoList) do
      self.templateHeroData.skillDict[v.skillId] = v
      self.templateHeroData.skillList[#self.templateHeroData.skillList + 1] = v
    end
  end
  local param = {}
  param.hero = self.templateHeroData
  param.monsterId = heroSkillPerformTemplate.monsterId
  param.monster_Rect = heroSkillPerformTemplate.monster_rect
  param.duration = self.customDuration ~= nil and self.customDuration or heroSkillPerformTemplate.duration
  param.monster_CenterPoint = heroSkillPerformTemplate.monster_center
  param.teamMemberHero = heroSkillPerformTemplate:GetTeamMemberHeroData()
  param.cameraType = DataCenter.PreviewSkillEffectManager.CameraType.Long
  param.isMonsterIdleAtStart = true
  DataCenter.PreviewSkillEffectManager:Enter(param)
end

return UIHeroPreviewSkillWindowLongView
