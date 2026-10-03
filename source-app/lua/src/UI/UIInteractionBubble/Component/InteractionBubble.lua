local InteractionBubble = BaseClass("InteractionBubble", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_path = "Root/Text"
local icon_path = "Root/Icon"
local head_path = "Root/head"
local root_path = "Root"

function InteractionBubble:OnCreate()
  base.OnCreate(self)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, true)
  self.head:SetFrameActive(false)
  self.root = self:AddComponent(UIImage, root_path)
  self.isFlyingOut = false
end

function InteractionBubble:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.timerFlyOut then
    self.timerFlyOut:Stop()
    self.timerFlyOut = nil
  end
  self.text = nil
  self.icon = nil
  self.head = nil
  base.OnDestroy(self)
end

function InteractionBubble:Init(data)
  local config = DataCenter.InteractionTemplateManager:GetBubbleTemplateByType(data.type)
  self.root:LoadSprite(config.banner)
  local bubbleShowTime = config and config.time or UIInteractionBubbleShowTime
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.view then
      self.view:FlyOutTaskEnqueue(self)
    end
  end, bubbleShowTime)
  if string.IsNullOrEmpty(config.icon) then
    self.icon:SetActive(false)
  else
    self.icon:SetActive(true)
    self.icon:LoadSprite(config.icon)
  end
  self.root:SetAnchoredPositionXY(350, 0)
  self.root.transform:DOAnchorPosX(0, UIInteractionBubbleFlyInTime):SetEase(CS.DG.Tweening.Ease.OutCubic)
  if data.uid then
    self.head:SetHead(data.uid, data.pic, data.picVer)
  end
  if data.type == InteractionBubbleType.STEALTH_MOBILE_FORCE then
    local text = DataCenter.InteractionTemplateManager:GetRandomHeroBubbleText()
    self.text:SetLocalText(text)
    local hero = DataCenter.HeroDataManager:GetHeroByUuid(data.heroUuid)
    if hero then
      local heroIcon = HeroUtils.GetHeroIconPath(hero.modelId)
      self.head:UseSpecifiedRes(heroIcon)
    end
  elseif data.type == InteractionBubbleType.ELECTRICITY_ASSISTANCE then
    self.text:SetLocalText(config.dialog)
  elseif data.type == InteractionBubbleType.BE_LIKED then
    local langKey = InteractiveUtil.GetLangKeyByThumbType(data.subType)
    self.text:SetLocalText(langKey, data.name)
  elseif data.type == InteractionBubbleType.BE_GIFTED then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(data.subType)
    self.text:SetLocalText(config.dialog, Localization:GetString(itemTemplate.name))
    self.icon:SetActive(true)
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
  elseif data.type == InteractionBubbleType.BE_ASSISTED then
    self.text:SetLocalText(config.dialog)
  elseif data.type == InteractionBubbleType.BE_EXTINGUISHED then
    self.text:SetLocalText(config.dialog)
  elseif data.type == InteractionBubbleType.BE_GIVEN_VOCATIONAL_SKILLS then
    local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(data.subType)
    if skillTemp then
      self.icon:SetActive(true)
      self.icon:LoadSprite(skillTemp:GetIconFullPath())
      self.text:SetLocalText(config.dialog, Localization:GetString(skillTemp.name))
    end
  end
end

function InteractionBubble:FlyOut()
  if self.isFlyingOut then
    return
  end
  self.isFlyingOut = true
  self.root:SetAnchoredPositionXY(0, 0)
  self.root.transform:DOAnchorPosX(350 * CommonUtil.ArabicAutoMirrorFactor(), UIInteractionBubbleFlyInTime):SetEase(CS.DG.Tweening.Ease.OutCubic)
  self.timerFlyOut = TimerManager:GetInstance():DelayInvoke(function()
    if self.view then
      self.view:DestroyBubble(self)
    end
  end, UIInteractionBubbleFlyOutTime)
end

return InteractionBubble
