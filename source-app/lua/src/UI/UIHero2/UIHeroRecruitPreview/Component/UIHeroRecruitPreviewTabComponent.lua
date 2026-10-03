local base = UIBaseContainer
local UIHeroRecruitPreviewTabComponent = BaseClass("UIHeroRecruitPreviewTabComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local PreviewComponent = require("UI/UIHero2/UIHeroRecruit/Component/Preview/UIHeroRecruitPreviewComponent")

function UIHeroRecruitPreviewTabComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroRecruitPreviewTabComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitPreviewTabComponent:ComponentDefine()
  self.btnRoot = self:AddComponent(UIButton, "Root")
  self.btnRoot:SetOnClick(function()
    self:OnBtnRootClick()
  end)
  self.imgPreview = self:AddComponent(UIImage, "Root/Preview")
  self.textName = self:AddComponent(UIText, "Root/NameText")
  self.compSelectedFrameBg = self:AddComponent(UIBaseContainer, "Root/SelectedFrameBg")
end

function UIHeroRecruitPreviewTabComponent:ComponentDestroy()
  self.btnRoot = nil
  self.imgPreview = nil
  self.textName = nil
  self.compSelectedFrameBg = nil
end

function UIHeroRecruitPreviewTabComponent:DataDefine()
end

function UIHeroRecruitPreviewTabComponent:DataDestroy()
end

function UIHeroRecruitPreviewTabComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroRecruitPreviewTabComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroRecruitPreviewTabComponent:ReInit(info, index, selectCallback)
  self.info = info
  self.index = index
  self.selectCallback = selectCallback
  self:UpdateContent()
end

function UIHeroRecruitPreviewTabComponent:Update1000MS()
  self:UpdateTimeShow()
end

function UIHeroRecruitPreviewTabComponent:UpdateContent()
  if self.info == nil then
    return
  end
  local curShowHeroId = self.info.heroId
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curShowHeroId)
  if heroTemplate then
    local iconPath = HeroUtils.GetHeroIconPath(heroTemplate.appearance, HeroIconType.recruit_preview_icon)
    if not string.IsNullOrEmpty(iconPath) then
      self.imgPreview:LoadSpriteAuto(iconPath)
    end
  end
  self:UpdateTimeShow()
  self:UpdateSelect()
end

function UIHeroRecruitPreviewTabComponent:UpdateTimeShow()
  if self.info == nil or self.info.startTime == nil then
    self.textName:SetActive(false)
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.info.startTime / 1000 - curSec
  if remainTime <= 0 then
    self.textName:SetActive(false)
    return
  end
  local leftTimeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime)
  self.textName:SetActive(true)
  self.textName:SetText(leftTimeStr)
end

function UIHeroRecruitPreviewTabComponent:UpdateSelect()
  if self.index then
    local curIndex = self.view.ctrl:GetCurIndex()
    self.compSelectedFrameBg:SetActive(self.index == curIndex)
  end
end

function UIHeroRecruitPreviewTabComponent:OnBtnRootClick()
  if self.selectCallback then
    self.selectCallback()
  end
end

return UIHeroRecruitPreviewTabComponent
