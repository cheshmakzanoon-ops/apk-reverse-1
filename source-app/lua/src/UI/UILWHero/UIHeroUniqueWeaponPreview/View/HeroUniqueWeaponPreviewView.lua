local HeroUniqueWeaponPreviewView = BaseClass("HeroUniqueWeaponPreviewView", UIBaseView)
HeroUniqueWeaponPreviewView.Toggle = {Effect = 1, Skill = 2}
HeroUniqueWeaponPreviewView.DEFAULT_CAMERA_ROTATION = Vector3(45.679, -51.973, -1.982)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeroWeaponModelViewer = require("UI.UILWHero.UIHeroDetailPanel.Component.HeroWeaponModelViewer")
local HeroUniqueWeaponPreviewEffectComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewEffectComponent")
local HeroUniqueWeaponPreviewSkillComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewSkillComponent")

function HeroUniqueWeaponPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function HeroUniqueWeaponPreviewView:OnDestroy()
  if self.shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(self.shadowDistance)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewView:OnOpen()
  self.heroId = self:GetUserData()
  local attrs, skills, previewSkills, maxLvTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelWeaponoEffects(self.heroId)
  if not maxLvTemplate then
    self.ctrl:CloseSelf()
    return
  end
  self.curSelectToggle = self.Toggle.Effect
  self:UpdateToggle()
  self.allLvList = string.string2array_num_oneSep(LuaEntry.DataConfig:TryGetStr("hero_unique_weapon", "k6"), ";")
  self.curSelectLv = nil
  self:SetSelectLv(maxLvTemplate.lv)
end

function HeroUniqueWeaponPreviewView:SetToggle(toggle, isFromOpen)
  if self.curSelectToggle == toggle then
    return
  end
  self.curSelectToggle = toggle
  self:UpdateModel()
  self:UpdateToggle()
  self:UpdateContent()
  if not isFromOpen and self.compHeroModelContainer then
    if self.curSelectToggle == self.Toggle.Effect then
      self.compHeroModelContainer:RotateCamera(self.DEFAULT_CAMERA_ROTATION, 0.2)
    elseif self.curSelectToggle == self.Toggle.Skill then
      self.compHeroModelContainer:ResetCameraRotation(0.2)
    end
  end
end

function HeroUniqueWeaponPreviewView:UpdateToggle()
  self.effectToggleSelect:SetActive(self.curSelectToggle == self.Toggle.Effect)
  self.skillToggleSelect:SetActive(self.curSelectToggle == self.Toggle.Skill)
end

function HeroUniqueWeaponPreviewView:UpdateContent()
  self.compEffectContent:SetActive(self.curSelectToggle == self.Toggle.Effect)
  self.compSkillContent:SetActive(self.curSelectToggle == self.Toggle.Skill)
  if self.curSelectToggle == self.Toggle.Effect then
    self.compEffectContent:ReInit()
  elseif self.curSelectToggle == self.Toggle.Skill then
    self.compSkillContent:ReInit()
  end
end

function HeroUniqueWeaponPreviewView:UpdateModel()
  if not self.weaponTemplate or not self.heroId then
    return
  end
  local modelPath = ""
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.heroId)
  if heroData then
    modelPath = HeroUtils.GetHeroModelData(self.heroId, HeroModelType.PBR, self.weaponTemplate.lv, heroData:GetSkinId(), heroData:GetRank())
  else
    local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(self.weaponTemplate.modelId)
    modelPath = appearanceTemplate.heroimg_model
  end
  self.compHeroModelContainer:SetModelPath(modelPath)
end

function HeroUniqueWeaponPreviewView:GetAllLvList()
  return self.allLvList
end

function HeroUniqueWeaponPreviewView:GetHeroId()
  return self.heroId
end

function HeroUniqueWeaponPreviewView:GetSelectLv()
  return self.curSelectLv
end

function HeroUniqueWeaponPreviewView:SetSelectLv(lv)
  if self.curSelectLv == lv then
    return
  end
  local canSelect = false
  if self.allLvList then
    for i, v in pairs(self.allLvList) do
      if v == lv then
        canSelect = true
        break
      end
    end
  end
  if not canSelect then
    return
  end
  self.curSelectLv = lv
  self.weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.curSelectLv)
  self:UpdateModel()
  self:UpdateContent()
end

function HeroUniqueWeaponPreviewView:OnHeroLoadedCallback()
  if self.compHeroModelContainer then
    if self.curSelectToggle == self.Toggle.Effect then
      self.compHeroModelContainer:RotateCamera(self.DEFAULT_CAMERA_ROTATION, 0)
    elseif self.curSelectToggle == self.Toggle.Skill then
      self.compHeroModelContainer:ResetCameraRotation(0)
    end
    self.compHeroModelContainer:SetHeroLoadedCallback(nil)
    self.shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(70)
  end
end

function HeroUniqueWeaponPreviewView:ComponentDefine()
  self.compHeroModelContainer = self:AddComponent(HeroWeaponModelViewer, "HeroModelContainer")
  self.compEffectContent = self:AddComponent(HeroUniqueWeaponPreviewEffectComponent, "EffectContent")
  self.compSkillContent = self:AddComponent(HeroUniqueWeaponPreviewSkillComponent, "SkillContent")
  self.btnEffectToggle = self:AddComponent(UIButton, "Toggle/EffectToggle")
  self.btnEffectToggle:SetOnClick(function()
    self:OnBtnEffectToggleClick()
  end)
  self.btnSkillToggle = self:AddComponent(UIButton, "Toggle/SkillToggle")
  self.btnSkillToggle:SetOnClick(function()
    self:OnBtnSkillToggleClick()
  end)
  self.btnBack = self:AddComponent(UIButton, "BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compCover3 = self:AddComponent(UIBaseContainer, "EffectContent/cover3")
  local curScreenRatio = Screen.width / Screen.height
  local rtWidth = self.compHeroModelContainer.rawImage.rectTransform.rect.width
  local rtHeight = self.compHeroModelContainer.rawImage.rectTransform.rect.height
  local designScreenRatio = DefaultScreenWidth / DefaultScreenHeight
  if curScreenRatio > designScreenRatio then
    local maxRTRatio = 1215 / DefaultScreenHeight
    local newRatio = math.min(curScreenRatio, maxRTRatio)
    rtWidth = rtHeight * newRatio
  end
  self.compHeroModelContainer:SetRTSize(math.ceil(rtWidth), math.ceil(rtHeight))
  self.compHeroModelContainer:SetEnableTouch(true)
  self.compHeroModelContainer:SetHeroLoadedCallback(BindCallback(self, self.OnHeroLoadedCallback))
  local cover3Height = rtHeight / DefaultScreenHeight * 389
  self.compCover3.rectTransform.sizeDelta = Vector2.New(self.compCover3.rectTransform.sizeDelta.x, cover3Height)
  self.effectToggleSelect = self.btnEffectToggle:AddComponent(UIBaseContainer, "Select")
  self.textEffect = self.btnEffectToggle:AddComponent(UITextMeshProUGUIEx, "Select/Text")
  self.textEffectDark = self.btnEffectToggle:AddComponent(UITextMeshProUGUIEx, "DarkText")
  self.skillToggleSelect = self.btnSkillToggle:AddComponent(UIBaseContainer, "Select")
  self.textSkill = self.btnSkillToggle:AddComponent(UITextMeshProUGUIEx, "Select/Text")
  self.textSkillDark = self.btnSkillToggle:AddComponent(UITextMeshProUGUIEx, "DarkText")
  self.textEffect:SetText(Localization:GetString("hero_weapon_preview_title_1"))
  self.textEffectDark:SetText(Localization:GetString("hero_weapon_preview_title_1"))
  self.textSkill:SetText(Localization:GetString("hero_weapon_preview_title_2"))
  self.textSkillDark:SetText(Localization:GetString("hero_weapon_preview_title_2"))
end

function HeroUniqueWeaponPreviewView:ComponentDestroy()
  self.compHeroModelContainer = nil
  self.compEffectContent = nil
  self.compSkillContent = nil
  self.btnEffectToggle = nil
  self.btnSkillToggle = nil
  self.btnBack = nil
  self.compCover3 = nil
end

function HeroUniqueWeaponPreviewView:DataDefine()
end

function HeroUniqueWeaponPreviewView:DataDestroy()
end

function HeroUniqueWeaponPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeroUniqueWeaponPreviewView:OnBtnEffectToggleClick()
  self:SetToggle(self.Toggle.Effect, false)
end

function HeroUniqueWeaponPreviewView:OnBtnSkillToggleClick()
  self:SetToggle(self.Toggle.Skill, false)
end

function HeroUniqueWeaponPreviewView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

return HeroUniqueWeaponPreviewView
