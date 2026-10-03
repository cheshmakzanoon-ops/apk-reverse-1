local UIHeroGuideTipsNewView = BaseClass("UIHeroGuideTipsNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local EffectTop_path = "bg/rect_effectBottom"
local EffectBottom_path = "bg/rect_effectTop"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddDelayTimer()
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
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "bg")
  self.bgCloseBtn:SetOnClick(function()
    self:OnClosed()
  end)
  self.iconTitle = self:AddComponent(UIImage, "bg/iconTitle")
  self.icon1 = self:AddComponent(UIImage, "bg/item1/icon1")
  self.icon2 = self:AddComponent(UIImage, "bg/item2/icon2")
  self.icon3 = self:AddComponent(UIImage, "bg/item3/icon3")
  self.iconTitle:LoadSprite(string.format(LoadPath.ItemPath, "item230006"))
  self.icon1:LoadSprite(string.format(LoadPath.ItemPath, "icon_expbox"))
  self.icon2:LoadSprite(string.format(LoadPath.ItemPath, "item2270503"))
  self.icon3:LoadSprite(string.format(LoadPath.ItemPath, "hero_fragment_orange"))
  self.tips = self:AddComponent(UITextMeshProUGUIEx, "bg/tips")
  self.bgCloseBtn:SetInteractable(false)
  self.tips:SetActive(false)
  self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayCloseTimer = nil
    self.bgCloseBtn:SetInteractable(true)
    self.tips:SetActive(true)
  end, 1.6600000000000001)
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.iconTitle = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

local function DataDefine(self)
  self.param = self:GetUserData()
end

local function DataDestroy(self)
  self:DeleteDelayTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnClosed(self)
  self.ctrl:CloseSelf()
end

local function DeleteDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function AddDelayTimer(self)
  DeleteDelayTimer(self)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if not self.effectBottom and not self.effectTop then
      self.effectBottom = self:AddComponent(UIVfx, EffectBottom_path, VfxAssets.HeroTipsEffectBottom, {
        lifeType = UIVfxLifeType.Stay
      })
      self.effectTop = self:AddComponent(UIVfx, EffectTop_path, VfxAssets.HeroTipsEffectTop, {
        lifeType = UIVfxLifeType.HideAfterOnce
      })
    end
    self.effectBottom:Replay()
    self.effectTop:Replay()
  end, 1.25)
  self.delayTimer:Start()
end

UIHeroGuideTipsNewView.OnCreate = OnCreate
UIHeroGuideTipsNewView.OnDestroy = OnDestroy
UIHeroGuideTipsNewView.OnEnable = OnEnable
UIHeroGuideTipsNewView.OnDisable = OnDisable
UIHeroGuideTipsNewView.ComponentDefine = ComponentDefine
UIHeroGuideTipsNewView.ComponentDestroy = ComponentDestroy
UIHeroGuideTipsNewView.DataDefine = DataDefine
UIHeroGuideTipsNewView.DataDestroy = DataDestroy
UIHeroGuideTipsNewView.OnAddListener = OnAddListener
UIHeroGuideTipsNewView.OnRemoveListener = OnRemoveListener
UIHeroGuideTipsNewView.OnClosed = OnClosed
UIHeroGuideTipsNewView.AddDelayTimer = AddDelayTimer
UIHeroGuideTipsNewView.DeleteDelayTimer = DeleteDelayTimer
return UIHeroGuideTipsNewView
