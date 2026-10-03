local HeroItem = BaseClass("HeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local SLOWNESS = 1.5

function HeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function HeroItem:OnDestroy()
  self.heroData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnClickSlider(self, isDamage)
  local hero = self.heroData
  if hero and hero.stat then
    local detailStr = HeroUtils.GetDetialStatFromMailHeroStat(hero.stat, isDamage)
    if not string.IsNullOrEmpty(detailStr) then
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      param.title = UIUtil.GetString("", "battle_stats_detail1")
      param.content = detailStr
      param.alignObject = isDamage and self.slider1.gameObject or self.slider2.gameObject
      param.width = 400
      param.yPosFix = -5
      param.preferTop = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end
  end
end

function HeroItem:ComponentDefine()
  self.heroCell = self:AddComponent(UIHeroCellTiny, "Hero")
  self.value1 = self:AddComponent(UIText, "btn1/value1")
  self.slider1 = self:AddComponent(UISlider, "btn1/slider1")
  self.slider1:SetValue(0)
  self.btn1 = self:AddComponent(UIButton, "btn1")
  self.btn1:SetOnClick(function()
    OnClickSlider(self, true)
  end)
  self.value2 = self:AddComponent(UIText, "btn2/value2")
  self.slider2 = self:AddComponent(UISlider, "btn2/slider2")
  self.slider2:SetValue(0)
  self.btn2 = self:AddComponent(UIButton, "btn2")
  self.btn2:SetOnClick(function()
    OnClickSlider(self, false)
  end)
  self.value3 = self:AddComponent(UIText, "value3")
  self.slider3 = self:AddComponent(UISlider, "slider3")
  self.slider3:SetValue(0)
  self.value4 = self:AddComponent(UIText, "value4")
  self.slider4 = self:AddComponent(UISlider, "slider4")
  self.slider4:SetValue(0)
end

function HeroItem:ComponentDestroy()
  self.heroCell = nil
  self.value1 = nil
  self.slider1 = nil
  self.value2 = nil
  self.slider2 = nil
  self.value3 = nil
  self.slider3 = nil
  self.value4 = nil
  self.slider4 = nil
end

function HeroItem:SetData(battleData, heroData)
  if not heroData or not heroData.stat then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.heroCell:SetData(heroData.heroId, nil, heroData.heroLevel, heroData.weaponLevel, heroData.rankLv, heroData.heroSkinId)
  local damage = heroData.stat.damage
  local damagePercent = damage / battleData.maxDamage
  local damageDuration = damagePercent * SLOWNESS
  self.value1:SetText(string.GetFormattedStr(damage))
  self.slider1:DOValue(damagePercent, damageDuration)
  local injured = heroData.stat.injured
  local injuredPercent = injured / battleData.maxInjured
  local injuredDuration = injuredPercent * SLOWNESS
  self.value2:SetText(string.GetFormattedStr(injured))
  self.slider2:DOValue(injuredPercent, injuredDuration)
  local enhance = heroData.stat.enhance
  local enhancePercent = enhance / battleData.maxEnhance
  local enhanceDuration = enhancePercent * SLOWNESS
  self.value3:SetText(string.GetFormattedStr(enhance))
  self.slider3:DOValue(enhancePercent, enhanceDuration)
  local weaken = heroData.stat.weaken
  local weakenPercent = weaken / battleData.maxWeaken
  local weakenDuration = weakenPercent * SLOWNESS
  self.value4:SetText(string.GetFormattedStr(weaken))
  self.slider4:DOValue(weakenPercent, weakenDuration)
  self.heroData = heroData
end

return HeroItem
