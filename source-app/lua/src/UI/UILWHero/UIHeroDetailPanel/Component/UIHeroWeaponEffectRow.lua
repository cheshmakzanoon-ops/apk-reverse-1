local UIHeroWeaponEffectRow = BaseClass("UIHeroWeaponEffectRow", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
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
  self.effect1 = self:AddComponent(UIBaseContainer, "Effect1")
  self.effect2 = self:AddComponent(UIBaseContainer, "Effect2")
  self.effect3 = self:AddComponent(UIBaseContainer, "Effect3")
  self.effect4 = self:AddComponent(UIBaseContainer, "Effect4")
  self.effects = {
    self.effect1,
    self.effect2,
    self.effect3,
    self.effect4
  }
  self.effect1Arrow = self:AddComponent(UIImage, "Effect1/Arrow1")
  self.effect2Arrow = self:AddComponent(UIImage, "Effect2/Arrow2")
  self.effect3Arrow = self:AddComponent(UIImage, "Effect3/Arrow3")
  self.effect4Arrow = self:AddComponent(UIImage, "Effect4/Arrow4")
  self.effectArrows = {
    self.effect1Arrow,
    self.effect2Arrow,
    self.effect3Arrow,
    self.effect4Arrow
  }
  self.effect1Icon = self:AddComponent(UIImage, "Effect1/Effect1IconBtn/Effect1Icon")
  self.effect2Icon = self:AddComponent(UIImage, "Effect2/Effect2IconBtn/Effect2Icon")
  self.effect3Icon = self:AddComponent(UIImage, "Effect3/Effect3IconBtn/Effect3Icon")
  self.effect4Icon = self:AddComponent(UIImage, "Effect4/Effect4IconBtn/Effect4Icon")
  self.effectIcons = {
    self.effect1Icon,
    self.effect2Icon,
    self.effect3Icon,
    self.effect4Icon
  }
  self.effect1Btn = self:AddComponent(UIButton, "Effect1/Effect1IconBtn")
  self.effect1Btn:SetOnClick(function()
    self:OnClick(1)
  end)
  self.effect2Btn = self:AddComponent(UIButton, "Effect2/Effect2IconBtn")
  self.effect2Btn:SetOnClick(function()
    self:OnClick(2)
  end)
  self.effect3Btn = self:AddComponent(UIButton, "Effect3/Effect3IconBtn")
  self.effect3Btn:SetOnClick(function()
    self:OnClick(3)
  end)
  self.effect4Btn = self:AddComponent(UIButton, "Effect4/Effect4IconBtn")
  self.effect4Btn:SetOnClick(function()
    self:OnClick(4)
  end)
end

local function ComponentDestroy(self)
  self.effect1 = nil
  self.effect2 = nil
  self.effect3 = nil
  self.effect4 = nil
  self.effects = nil
  self.effect2Arrow = nil
  self.effect3Arrow = nil
  self.effect4Arrow = nil
  self.effectArrows = nil
  self.effect1Icon = nil
  self.effect2Icon = nil
  self.effect3Icon = nil
  self.effect4Icon = nil
  self.effectIcons = nil
  self.effect1Btn = nil
  self.effect2Btn = nil
  self.effect3Btn = nil
  self.effect4Btn = nil
end

local function DataDefine(self)
  self.effectData = {}
end

local function DataDestroy(self)
  self.effectData = nil
  self.callback = nil
end

local function SetData(self, effects, callback, ShowLastArrow)
  local effectCount = #effects
  local showArrow = {
    false,
    false,
    false,
    false
  }
  for i = 1, 4 do
    if effectCount >= i then
      self.effects[i]:SetActive(true)
      local effectTemplate = DataCenter.HeroWeaponEffectTemplateManager:GetTemplate(effects[i])
      if effectTemplate ~= nil then
        self.effectIcons[i]:LoadSprite(string.format(LoadPath.HeroDetailPath, effectTemplate.icon .. ".png"))
        if effectTemplate.level > 0 then
          UIGray.SetGray(self.effects[i].transform, false, true)
        else
          UIGray.SetGray(self.effects[i].transform, true, true)
        end
        if 2 <= i then
          showArrow[i - 1] = true
        end
      else
        self.effects[i]:SetActive(false)
      end
    else
      self.effects[i]:SetActive(false)
    end
  end
  showArrow[4] = ShowLastArrow
  for i = 1, 4 do
    self.effectArrows[i]:SetActive(showArrow[i])
  end
  self.callback = callback
  self.effectData = effects
end

local function SetSingleEffect(self, data, index)
end

local function OnClick(self, index)
  if self.callback ~= nil then
    self.callback(self.effectData[index])
  end
end

UIHeroWeaponEffectRow.OnCreate = OnCreate
UIHeroWeaponEffectRow.OnDestroy = OnDestroy
UIHeroWeaponEffectRow.OnEnable = OnEnable
UIHeroWeaponEffectRow.OnDisable = OnDisable
UIHeroWeaponEffectRow.ComponentDefine = ComponentDefine
UIHeroWeaponEffectRow.ComponentDestroy = ComponentDestroy
UIHeroWeaponEffectRow.DataDefine = DataDefine
UIHeroWeaponEffectRow.DataDestroy = DataDestroy
UIHeroWeaponEffectRow.SetData = SetData
UIHeroWeaponEffectRow.OnClick = OnClick
return UIHeroWeaponEffectRow
