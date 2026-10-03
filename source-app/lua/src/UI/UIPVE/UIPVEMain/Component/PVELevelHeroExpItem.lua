local PVELevelHeroExpItem = BaseClass("PVELevelHeroExpItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local normal_path = "Bg/Normal"
local add_path = "Bg/Add"
local lock_path = "Bg/Lock"
local hero_path = "Bg/Normal/Top/UIHeroCellSmall"
local effect_path = "Bg/Normal/Top/EffectGlow"
local beyond_btn_path = "Bg/Normal/Top/BeyondBtn"
local bar_bg_path = "Bg/Normal/BarBg"
local bar_b_path = "Bg/Normal/BarB"
local bar_a_path = "Bg/Normal/BarA"
local add_exp_path = "Bg/Normal/AddExp"
local add_level_go_path = "Bg/Normal/UIPVEHeroLevelUp"
local add_level_text_path = "Bg/Normal/UIPVEHeroLevelUp/LevelUpText"
local exp_glow1_path = "Bg/Normal/Top/VFX_uiherocellsmall_glow"
local exp_glow2_path = "Bg/Normal/VFX_ui_uiherocellsmall_tiao"
local DURATION = 0.5
local ADD_DELAY = 2

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.normal_go = self:AddComponent(UIBaseContainer, normal_path)
  self.add_go = self:AddComponent(UIBaseContainer, add_path)
  self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
  self.hero = self:AddComponent(UIHeroCellSmall, hero_path)
  self.effect_go = self:AddComponent(UIBaseContainer, effect_path)
  self.beyond_btn = self:AddComponent(UIButton, beyond_btn_path)
  self.beyond_btn:SetOnClick(function()
    self:OnBeyondClick()
  end)
  self.bar_bg_image = self:AddComponent(UIImage, bar_bg_path)
  self.barSize = self.bar_bg_image.rectTransform.sizeDelta
  self.bar_b_image = self:AddComponent(UIImage, bar_b_path)
  self.bar_a_image = self:AddComponent(UIImage, bar_a_path)
  self.add_exp_text = self:AddComponent(UIText, add_exp_path)
  self.add_level_go = self:AddComponent(UIBaseContainer, add_level_go_path)
  self.add_level_text = self:AddComponent(UIText, add_level_text_path)
  self.add_level_text:SetLocalText(100091)
  self.exp_glow1_particle = self.transform:Find(exp_glow1_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.exp_glow2_particle = self.transform:Find(exp_glow2_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
end

local function ComponentDestroy(self)
  self.normal_go = nil
  self.add_go = nil
  self.lock_go = nil
  self.hero = nil
  self.effect_go = nil
  self.beyond_btn = nil
  self.bar_bg_image = nil
  self.bar_b_image = nil
  self.bar_a_image = nil
  self.add_exp_text = nil
  self.add_level_go = nil
  self.add_level_text = nil
  self.exp_glow1_particle = nil
  self.exp_glow2_particle = nil
end

local function DataDefine(self)
  self.heroUuid = 0
  self.curLevel = 0
  self.curExp = 0
  self.toLevel = 0
  self.toExp = 0
  self.addingExp = 0
  self.barSize = Vector2.New(0, 0)
  self.tween = nil
  self.addExpTimer = nil
  self.addLevelTimer = nil
end

local function DataDestroy(self)
  self.heroUuid = nil
  self.curLevel = nil
  self.curExp = nil
  self.toLevel = nil
  self.toExp = nil
  self.addingExp = nil
  self.barSize = nil
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = nil
  if self.addExpTimer ~= nil then
    self.addExpTimer:Stop()
  end
  self.addExpTimer = nil
  if self.addLevelTimer ~= nil then
    self.addLevelTimer:Stop()
  end
  self.addLevelTimer = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetHeroUuid(self, heroUuid)
  self.normal_go:SetActive(true)
  self.add_go:SetActive(false)
  self.lock_go:SetActive(false)
  self.heroUuid = heroUuid
  self.hero:SetData(heroUuid)
  local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
  local level = heroData.level
  local exp = heroData.exp
  local maxExp = HeroUtils.GetLevelUpNeedExp(level)
  self.levelA = level
  self.levelB = level
  self.expA = exp
  self.expB = exp
  self.maxLevel = heroData.curMaxLevel
  self.finalLevel = heroData.finalLevel
  self:SetLevelText(level)
  if level < self.maxLevel then
    self:SetBarAPercent(exp / maxExp)
    self:SetBarBPercent(exp / maxExp)
    self.beyond_btn:SetActive(false)
    self.effect_go:SetActive(false)
  else
    self:SetBarAPercent(1)
    local canBeyond = level < self.finalLevel
    self.beyond_btn:SetActive(canBeyond)
    self.effect_go:SetActive(canBeyond)
  end
  self.add_exp_text:SetText("")
  self.add_level_go:SetActive(false)
end

local function SetToAdd(self)
  self.normal_go:SetActive(false)
  self.add_go:SetActive(true)
  self.lock_go:SetActive(false)
end

local function SetToLock(self)
  self.normal_go:SetActive(false)
  self.add_go:SetActive(false)
  self.lock_go:SetActive(true)
end

local function RefreshExpA(self, info)
  self.expA = info.oldExp
  self:TweenExpA(info.level, info.nowExp)
  if info.expAdd > 0 then
    self:ShowAddExpText(info.expAdd)
  end
end

local function TweenExpA(self, toLevel, toExp)
  local maxExp = HeroUtils.GetLevelUpNeedExp(self.levelA)
  
  local function Getter()
    return self.expA
  end
  
  local function Setter(x)
    self.expA = x
    self:SetBarAPercent(x / maxExp)
  end
  
  if toLevel > self.levelA then
    local duration = (maxExp - self.expA) / maxExp * DURATION
    if self.tween ~= nil then
      self.tween:Kill()
    end
    self.tween = DOTween.To(Getter, Setter, maxExp, duration):OnComplete(function()
      self.levelA = self.levelA + 1
      self.expA = 0
      self:RefreshExpB()
      self:SetLevelText(self.levelA)
      self:ShowAddLevelText()
      if self.levelA < self.maxLevel then
        self:SetBarAPercent(0)
        self:TweenExpA(toLevel, toExp)
      else
        self:SetBarAPercent(1)
        local canBeyond = self.levelA < self.finalLevel
        self.beyond_btn:SetActive(canBeyond)
        self.effect_go:SetActive(canBeyond)
      end
    end)
    self.tween:Play()
  else
    if self.levelA == toLevel then
      if self.levelA < self.maxLevel then
        local duration = (toExp - self.expA) / maxExp * DURATION
        if self.tween ~= nil then
          self.tween:Kill()
        end
        self.tween = DOTween.To(Getter, Setter, toExp, duration)
        self.tween:Play()
      else
        self:SetBarAPercent(1)
        local canBeyond = self.levelA < self.finalLevel
        self.beyond_btn:SetActive(canBeyond)
        self.effect_go:SetActive(canBeyond)
      end
    else
    end
  end
end

local function AddExpB(self, addExp)
  local maxExp = HeroUtils.GetLevelUpNeedExp(self.levelB)
  self.expB = self.expB + addExp
  while maxExp <= self.expB do
    self.expB = self.expB - maxExp
    self.levelB = self.levelB + 1
    maxExp = HeroUtils.GetLevelUpNeedExp(self.levelB)
  end
  self:RefreshExpB()
end

local function RefreshExpB(self)
  if self.levelB > self.levelA then
    self:SetBarBPercent(1)
  else
    local maxExp = HeroUtils.GetLevelUpNeedExp(self.levelB)
    self:SetBarBPercent(self.expB / maxExp)
  end
end

local function SetBarAPercent(self, p)
  p = Mathf.Min(p, 1)
  local width = self.barSize.x * p
  self.bar_a_image.rectTransform.sizeDelta = Vector2.New(width, self.barSize.y)
end

local function SetBarBPercent(self, p)
  p = Mathf.Min(p, 1)
  local width = self.barSize.x * p
  self.bar_b_image.rectTransform.sizeDelta = Vector2.New(width, self.barSize.y)
end

local function SetLevelText(self, level)
  self.hero:SetDisplayLevel(level)
end

local function ShowAddExpText(self, addExp)
  if self.addExpTimer ~= nil then
    self.addExpTimer:Stop()
  end
  self.addingExp = self.addingExp + addExp
  self.add_exp_text:SetText("+" .. self.addingExp)
  self.addExpTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.add_exp_text:SetText("")
    self.addingExp = 0
  end, ADD_DELAY)
end

local function ShowAddLevelText(self)
  if self.addLevelTimer ~= nil then
    self.addLevelTimer:Stop()
  end
  self.add_level_go:SetActive(true)
  self.addLevelTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.add_level_go:SetActive(false)
  end, ADD_DELAY)
end

local function ShowExpGlow(self)
  self.exp_glow1_particle:Play()
  self.exp_glow2_particle:Play()
end

local function OnBeyondClick(self)
  DataCenter.HeroDataManager:BeyondHero(self.heroUuid)
end

PVELevelHeroExpItem.OnCreate = OnCreate
PVELevelHeroExpItem.OnDestroy = OnDestroy
PVELevelHeroExpItem.ComponentDefine = ComponentDefine
PVELevelHeroExpItem.ComponentDestroy = ComponentDestroy
PVELevelHeroExpItem.DataDefine = DataDefine
PVELevelHeroExpItem.DataDestroy = DataDestroy
PVELevelHeroExpItem.OnEnable = OnEnable
PVELevelHeroExpItem.OnDisable = OnDisable
PVELevelHeroExpItem.OnAddListener = OnAddListener
PVELevelHeroExpItem.OnRemoveListener = OnRemoveListener
PVELevelHeroExpItem.SetHeroUuid = SetHeroUuid
PVELevelHeroExpItem.SetToAdd = SetToAdd
PVELevelHeroExpItem.SetToLock = SetToLock
PVELevelHeroExpItem.RefreshExpA = RefreshExpA
PVELevelHeroExpItem.TweenExpA = TweenExpA
PVELevelHeroExpItem.AddExpB = AddExpB
PVELevelHeroExpItem.RefreshExpB = RefreshExpB
PVELevelHeroExpItem.SetBarAPercent = SetBarAPercent
PVELevelHeroExpItem.SetBarBPercent = SetBarBPercent
PVELevelHeroExpItem.SetLevelText = SetLevelText
PVELevelHeroExpItem.ShowAddExpText = ShowAddExpText
PVELevelHeroExpItem.ShowAddLevelText = ShowAddLevelText
PVELevelHeroExpItem.ShowExpGlow = ShowExpGlow
PVELevelHeroExpItem.OnBeyondClick = OnBeyondClick
return PVELevelHeroExpItem
