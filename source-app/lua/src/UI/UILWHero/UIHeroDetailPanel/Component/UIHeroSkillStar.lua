local UIHeroSkillStar = BaseClass("UIHeroSkillStar", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function StopBreathEffect(self)
  if self.breathEffect then
    self.breathEffect:Kill()
    self.breathEffect = nil
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(1)
  end
  if self.filled then
    self.filled:SetAlpha(1)
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  StopBreathEffect(self)
end

local function ComponentDefine(self)
  self.filled = self:AddComponent(UIImage, "Filled")
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

local function ComponentDestroy(self)
  self.filled = nil
  self.canvasGroup = nil
end

local function SetFilled(self, filled)
  StopBreathEffect(self)
  self.filled:SetActive(filled)
end

local function PlayBreathEffect(self, roundTime)
  StopBreathEffect(self)
  if not self.canvasGroup then
    return
  end
  
  local function Getter()
    if self.canvasGroup then
      return self.canvasGroup:GetAlpha()
    end
  end
  
  local function Setter(x)
    if self.canvasGroup then
      self.canvasGroup:SetAlpha(x)
    end
  end
  
  self.canvasGroup:SetAlpha(0)
  roundTime = roundTime or 0.25
  self.breathEffect = DOTween.To(Getter, Setter, 1, roundTime):SetEase(CS.DG.Tweening.Ease.InOutCubic):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
end

local function SetStarIndex(self, index)
  self:SetStarImageByIndex(index)
end

function UIHeroSkillStar:SetStarImageByIndex(index)
  if not self.filled:GetActive() then
    return
  end
  if index <= 5 then
    self.filled:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star02.png")
  else
    self.filled:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star01.png")
  end
end

function UIHeroSkillStar:SetStarImageByPath(imagePath)
  if not self.filled:GetActive() then
    return
  end
  self.filled:LoadSpriteAsync(imagePath)
end

UIHeroSkillStar.OnCreate = OnCreate
UIHeroSkillStar.OnDestroy = OnDestroy
UIHeroSkillStar.OnEnable = OnEnable
UIHeroSkillStar.OnDisable = OnDisable
UIHeroSkillStar.DataDefine = DataDefine
UIHeroSkillStar.DataDestroy = DataDestroy
UIHeroSkillStar.ComponentDefine = ComponentDefine
UIHeroSkillStar.ComponentDestroy = ComponentDestroy
UIHeroSkillStar.SetFilled = SetFilled
UIHeroSkillStar.PlayBreathEffect = PlayBreathEffect
UIHeroSkillStar.SetStarIndex = SetStarIndex
return UIHeroSkillStar
