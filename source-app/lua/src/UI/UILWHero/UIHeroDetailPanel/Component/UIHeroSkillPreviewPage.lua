local UIHeroSkillPage = BaseClass("UIHeroSkillPage", UIBaseContainer)
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
local equipBtnContainerPath = "EquipBtnContainer"
local equipBtnPath = "EquipBtnContainer/HeroEquipBtn"
local equipBtnRedPointPath = "EquipBtnContainer/HeroEquipBtn/EquipBtnRedPoint"
local hpBarParentPath = "HpBarParent"
local heroPropertyDetailBtnPath = "PropertyDetailInfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  DataCenter.PreviewSkillEffectManager:SetHpBarParent(self.hpBarParent.gameObject)
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
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.PreviewSkillEffectManager:UnSetHpBarParent()
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
  self.equipBtnCallback = nil
  self.heroData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  DataCenter.PreviewSkillEffectManager:Destroy()
end

local function OnClickEquipBtn(self)
  if self.equipBtnCallback ~= nil then
    self.equipBtnCallback()
  end
end

local function ComponentDefine(self)
  self.image = self:AddComponent(UIRawImage, rtPath)
  self.equipBtnContainer = self:AddComponent(UIBaseComponent, equipBtnContainerPath)
  self.equipBtn = self:AddComponent(UIButton, equipBtnPath)
  self.equipBtn:SetOnClick(function()
    OnClickEquipBtn(self)
  end)
  self.equipBtnRedPoint = self:AddComponent(UIBaseComponent, equipBtnRedPointPath)
  self.powerNumText = self:AddComponent(UIText, "PowerInfo/PowerNumberText")
  self.hpBarParent = self:AddComponent(UIBaseComponent, hpBarParentPath)
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
  self.equipBtn = nil
  self.equipBtnContainer = nil
  self.equipBtnRedPoint = nil
  self.powerNumText = nil
  self.hpBarParent = nil
  self.heroPropertyDetailBtn = nil
end

local function RefreshEquipBtnRedPoint(self)
  if not self.active or self.heroData == nil then
    return
  end
  local reachShowEquipBtnLimit = true
  if self.showEquipBtn ~= nil then
    reachShowEquipBtnLimit = self.showEquipBtn
  end
  if self.showEquipBtn == true then
    reachShowEquipBtnLimit = self.heroData:IsUnlockEquipFunction()
  end
  self.equipBtnContainer:SetActive(reachShowEquipBtnLimit)
  if reachShowEquipBtnLimit then
    self.equipBtnRedPoint:SetActive(self.heroData:ShowEquipRedPoint())
  end
end

local function SetData(self, heroData, skillSlotIndex, gotoEquipPageCallBack, showEquipBtn, showTip)
  if heroData == nil then
    return
  end
  self.heroData = heroData
  self.skillSlotIndex = skillSlotIndex
  self.showEquipBtn = showEquipBtn
  self.equipBtnCallback = gotoEquipPageCallBack
  local skillData = heroData:GetHeroSkillBySlotIndex(skillSlotIndex)
  if skillData == nil then
    return
  end
  local skillActionType = skillData:GetActionType()
  DataCenter.PreviewSkillEffectManager:Destroy()
  if skillActionType ~= SkillActionType.Bullet then
    if showTip then
      UIUtil.ShowTipsId(151123)
    end
    return
  end
  if self.renderTexture == nil then
    local rtWidth = 762
    local rtHeight = 658
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "SkillPreviewRT"
    self.image:SetTexture(self.renderTexture)
    self.image:SetEnable(true)
    self.image:SetColor(Color.white)
  end
  if self.templateHeroData == nil then
    self.templateHeroData = HeroInfo.New()
  end
  self.templateHeroData:UpdateFromTemplate(heroData.heroId)
  local properties = DataCenter.HeroParamDataManager.heroSkillPreviewProperties
  for id, value in pairs(properties) do
    self.templateHeroData.propertyData:SetProperty(id, value)
  end
  local curSkillData
  self.templateHeroData.skillDict = {}
  self.templateHeroData.skillList = DeepCopy(heroData.skillList)
  for index, skill in pairs(self.templateHeroData.skillList) do
    local heroSkillTemplate = DeepCopy(skill.skillTemplateData)
    heroSkillTemplate.pre_cd = DataCenter.HeroParamDataManager.skillPreviewStartDelay
    skill.skillTemplateData = heroSkillTemplate
    if skill ~= nil then
      if index ~= skillSlotIndex then
        skill.isUnlocked = false
      else
        skill.isUnlocked = true
        curSkillData = skill
      end
      self.templateHeroData.skillDict[skill.skillId] = skill
    end
  end
  if curSkillData == nil then
    return
  end
  local heroSkillPerformTemplate = DataCenter.HeroSkillPerformTemplateManager:GetTemplate(curSkillData.skillId)
  if heroSkillPerformTemplate == nil then
    return
  end
  local param = {}
  param.hero = self.templateHeroData
  param.monsterId = heroSkillPerformTemplate.monsterId
  param.monster_Rect = heroSkillPerformTemplate.monster_rect
  param.duration = heroSkillPerformTemplate.duration
  param.monster_CenterPoint = heroSkillPerformTemplate.monster_center
  DataCenter.PreviewSkillEffectManager:Enter(param)
  RefreshEquipBtnRedPoint(self)
  self.powerNumText:SetText(heroData.skillPower + heroData.propertyPower)
end

local function OnPreviewSkillInit(self)
  if self.image ~= nil and self.renderTexture ~= nil then
    DataCenter.PreviewSkillEffectManager.rtRect = self.image.transform
    DataCenter.PreviewSkillEffectManager.camera.targetTexture = self.renderTexture
  end
end

local function OnHeroChanged(self)
  if not self.active then
    return
  end
  if not self.heroData then
    return
  end
  self.powerNumText:SetText(self.heroData.skillPower + self.heroData.propertyPower)
end

local function OnHeroSkillChanged(self)
  if not self.active then
    return
  end
  OnHeroChanged(self)
  if not self.heroData or not self.skillSlotIndex then
    return
  end
  self:SetData(self.heroData, self.skillSlotIndex, self.equipBtnCallback, self.showEquipBtn, false)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PreviewSkillSceneInit, OnPreviewSkillInit)
  self:AddUIListener(EventId.HeroLvUpSuccess, OnHeroChanged)
  self:AddUIListener(EventId.HeroBeyondSuccess, OnHeroChanged)
  self:AddUIListener(EventId.SkillUpgradeEnd, OnHeroSkillChanged)
  self:AddUIListener(EventId.HeroEquipInstall, RefreshEquipBtnRedPoint)
  self:AddUIListener(EventId.HeroEquipUninstall, RefreshEquipBtnRedPoint)
  self:AddUIListener(EventId.HeroEquipUpgrade, RefreshEquipBtnRedPoint)
  self:AddUIListener(EventId.EquipDataUpdate, RefreshEquipBtnRedPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PreviewSkillSceneInit, OnPreviewSkillInit)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, OnHeroChanged)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, OnHeroChanged)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, OnHeroSkillChanged)
  self:RemoveUIListener(EventId.HeroEquipInstall, RefreshEquipBtnRedPoint)
  self:RemoveUIListener(EventId.HeroEquipUninstall, RefreshEquipBtnRedPoint)
  self:RemoveUIListener(EventId.HeroEquipUpgrade, RefreshEquipBtnRedPoint)
  self:RemoveUIListener(EventId.EquipDataUpdate, RefreshEquipBtnRedPoint)
  base.OnRemoveListener(self)
end

local function GetEquipBtnPos(self)
  if self.equipBtn == nil then
    return Vector3.zero
  end
  return self.equipBtn.transform.position
end

UIHeroSkillPage.OnCreate = OnCreate
UIHeroSkillPage.OnDestroy = OnDestroy
UIHeroSkillPage.OnEnable = OnEnable
UIHeroSkillPage.OnDisable = OnDisable
UIHeroSkillPage.DataDefine = DataDefine
UIHeroSkillPage.DataDestroy = DataDestroy
UIHeroSkillPage.ComponentDefine = ComponentDefine
UIHeroSkillPage.ComponentDestroy = ComponentDestroy
UIHeroSkillPage.SetData = SetData
UIHeroSkillPage.OnAddListener = OnAddListener
UIHeroSkillPage.OnRemoveListener = OnRemoveListener
UIHeroSkillPage.GetEquipBtnPos = GetEquipBtnPos
UIHeroSkillPage.RefreshEquipBtnRedPoint = RefreshEquipBtnRedPoint
return UIHeroSkillPage
