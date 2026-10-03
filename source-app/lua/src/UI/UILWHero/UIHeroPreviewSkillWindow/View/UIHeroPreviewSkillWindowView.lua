local UIHeroPreviewSkillWindowPanelView = BaseClass("UIHeroPreviewSkillWindowPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local bgPanelPath = "Panel"
local backBtnPath = "Root/BackBtn"
local skillNameTextPath = "Root/SkillNameText"
local previewSkillRtPath = "Root/PreviewSkillRt"
local hpBarParentPath = "Root/PreviewSkillRt/HpBarParent"
UIHeroPreviewSkillWindowPanelView.RTWidth = 670
UIHeroPreviewSkillWindowPanelView.RTHeight = 440

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.PreviewSkillEffectManager:SetHpBarParent(self.hpBarParent.gameObject)
  self:OnOpen()
end

local function ReleaseRT(self)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function OnDestroy(self)
  DataCenter.PreviewSkillEffectManager:Destroy()
  ReleaseRT(self)
  self:ComponentDestroy()
  self:DataDestroy()
  DataCenter.PreviewSkillEffectManager:UnSetHpBarParent()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgPanel = self:AddComponent(UIButton, bgPanelPath)
  self.bgPanel:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.backBtn = self:AddComponent(UIButton, backBtnPath)
  self.backBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.skillNameText = self:AddComponent(UIText, skillNameTextPath)
  self.previewSkillRt = self:AddComponent(UIRawImage, previewSkillRtPath)
  self.hpBarParent = self:AddComponent(UIBaseContainer, hpBarParentPath)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.backBtn = nil
  self.skillNameText = nil
  self.previewSkillRt = nil
  self.hpBarParent = nil
end

local function DataDestroy(self)
  self.heroId = nil
  self.skillId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnPreviewSkillInit(self)
  if self.previewSkillRt ~= nil and self.renderTexture ~= nil then
    DataCenter.PreviewSkillEffectManager.rtRect = self.previewSkillRt.transform
    DataCenter.PreviewSkillEffectManager.camera.targetTexture = self.renderTexture
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PreviewSkillSceneInit, OnPreviewSkillInit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PreviewSkillSceneInit, OnPreviewSkillInit)
  base.OnRemoveListener(self)
end

local function RefreshSkillPreview(self)
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
  self.templateHeroData:UpdateFromTemplate(self.heroId, nil, nil, nil, self.weaponLv, nil, self.awakenLv, self.skinId)
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
  local param = {}
  param.hero = self.templateHeroData
  param.monsterId = heroSkillPerformTemplate.monsterId
  param.monster_Rect = heroSkillPerformTemplate.monster_rect
  param.duration = heroSkillPerformTemplate.duration
  param.monster_CenterPoint = heroSkillPerformTemplate.monster_center
  param.teamMemberHero = heroSkillPerformTemplate:GetTeamMemberHeroData()
  DataCenter.PreviewSkillEffectManager:Enter(param)
end

local function OnOpen(self)
  self.heroId, self.skillId, self.skillLv, self.skillMaxLv, self.weaponLv, self.awakenLv, self.skinId = self:GetUserData()
  if not self.heroId or not self.skillId then
    self:OnBtnCloseClick()
    return
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  if skillTemplate == nil then
    self:OnBtnCloseClick()
    return
  end
  local str = ""
  if self.skillLv > 0 then
    str = string.format("%s (Lv%d/%d)", Localization:GetString(skillTemplate.name), self.skillLv, self.skillMaxLv)
  else
    str = Localization:GetString(skillTemplate.name)
  end
  self.skillNameText:SetText(str)
  self:RefreshSkillPreview()
end

local function OnBtnCloseClick(self)
  if self.closeCallBack ~= nil then
    self.closeCallBack()
    self.closeCallBack = nil
  end
  self.ctrl.CloseSelf()
end

UIHeroPreviewSkillWindowPanelView.OnCreate = OnCreate
UIHeroPreviewSkillWindowPanelView.OnDestroy = OnDestroy
UIHeroPreviewSkillWindowPanelView.OnEnable = OnEnable
UIHeroPreviewSkillWindowPanelView.OnDisable = OnDisable
UIHeroPreviewSkillWindowPanelView.OnAddListener = OnAddListener
UIHeroPreviewSkillWindowPanelView.OnRemoveListener = OnRemoveListener
UIHeroPreviewSkillWindowPanelView.ComponentDefine = ComponentDefine
UIHeroPreviewSkillWindowPanelView.DataDefine = DataDefine
UIHeroPreviewSkillWindowPanelView.ComponentDestroy = ComponentDestroy
UIHeroPreviewSkillWindowPanelView.DataDestroy = DataDestroy
UIHeroPreviewSkillWindowPanelView.OnOpen = OnOpen
UIHeroPreviewSkillWindowPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroPreviewSkillWindowPanelView.RefreshSkillPreview = RefreshSkillPreview
return UIHeroPreviewSkillWindowPanelView
