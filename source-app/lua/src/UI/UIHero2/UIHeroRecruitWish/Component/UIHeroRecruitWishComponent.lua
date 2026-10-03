local base = UIBaseContainer
local UIHeroRecruitWishComponent = BaseClass("UIHeroRecruitWishComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIHeroRecruitWishComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroRecruitWishComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitWishComponent:ComponentDefine()
  self.imgHeroIcon = self:AddComponent(UIImage, "HeroIconMask/HeroIcon")
  self.imgHeroTypeIcon = self:AddComponent(UIImage, "HeroTypeIcon")
  self.btnHeroTypeIcon = self:AddComponent(UIButton, "HeroTypeIcon")
  self.btnHeroTypeIcon:SetOnClick(function()
  end)
  self.imgHeroJobIcon = self:AddComponent(UIImage, "HeroJobIcon")
  self.btnHeroJobIcon = self:AddComponent(UIButton, "HeroJobIcon")
  self.btnHeroJobIcon:SetOnClick(function()
  end)
  self.textLevel = self:AddComponent(UIText, "LevelText")
  self.compWishIcon = self:AddComponent(UIBaseContainer, "WishIcon")
  self.compSelectFrame = self:AddComponent(UIBaseContainer, "SelectFrame")
  self.btnHeroItem = self:AddComponent(UIButton, "")
  self.btnHeroItem:SetOnClick(function()
    self:OnBtnHeroItemClick()
  end)
end

function UIHeroRecruitWishComponent:ComponentDestroy()
  self.imgHeroIcon = nil
  self.imgHeroTypeIcon = nil
  self.btnHeroTypeIcon = nil
  self.imgHeroJobIcon = nil
  self.btnHeroJobIcon = nil
  self.textLevel = nil
  self.compWishIcon = nil
  self.compSelectFrame = nil
  self.btnHeroItem = nil
end

function UIHeroRecruitWishComponent:DataDefine()
end

function UIHeroRecruitWishComponent:DataDestroy()
end

function UIHeroRecruitWishComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroRecruitWishComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroRecruitWishComponent:ReInit(heroId, lotteryId)
  self.heroId = heroId
  self.lotteryId = lotteryId
  self.textLevel:SetText("Lv.1")
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local iconPath = HeroUtils.GetHeroIconPath(heroTemplate.appearance, HeroIconType.half_portrait)
    self.imgHeroIcon:LoadSpriteAuto(iconPath)
    self.imgHeroTypeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroTemplate.type))
    self.imgHeroJobIcon:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
  end
  self:UpdateWish()
  self:UpdateSelect()
end

function UIHeroRecruitWishComponent:UpdateSelect()
  local curSelectHeroId = self.view.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  self.compSelectFrame:SetActive(curSelectHeroId == self.heroId)
end

function UIHeroRecruitWishComponent:UpdateWish()
  if self.lotteryId then
    local lotteryInfo = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
    if lotteryInfo then
      local curHero = lotteryInfo:GetCurSelectWishHeroId()
      self.compWishIcon:SetActive(curHero ~= nil and curHero == self.heroId)
    end
  end
end

function UIHeroRecruitWishComponent:OnBtnHeroTypeIconClick()
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
  if heroTemplate then
    local pos = self.imgHeroTypeIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByType(heroTemplate.type)
    local text = Localization:GetString("129213", Localization:GetString(tip))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitWishComponent:OnBtnHeroJobIconClick()
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
  if heroTemplate then
    local pos = self.imgHeroJobIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByJob(heroTemplate.job)
    local text = Localization:GetString(tip)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitWishComponent:OnBtnHeroItemClick()
  local curSelectHeroId = self.view.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  if curSelectHeroId ~= self.heroId then
    self.view.ctrl:SetFakeCurSelectHeroId(self.lotteryId, self.heroId)
    self.view:OnSelectChange()
  end
end

return UIHeroRecruitWishComponent
