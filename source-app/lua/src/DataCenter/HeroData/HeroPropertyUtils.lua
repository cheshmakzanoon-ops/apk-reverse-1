local Localization = CS.GameEntry.Localization
local HeroPropertyUtils = {}

local function GetHeroHp(self, heroData)
  local hp = heroData:GetProperty(HeroEffectDefine.HealthPoint)
  hp = hp * (1 + heroData:GetProperty(HeroEffectDefine.HealthPointRate))
end

local function GetPhysicalAttack(self, heroData)
  local attack = heroData:GetProperty(HeroEffectDefine.PhysicalAttack)
  attack = attack * (1 + heroData:GetProperty(HeroEffectDefine.AttackRate))
end

local function GetMagicAttack(self, heroData)
  local attack = heroData:GetProperty(HeroEffectDefine.MagicAttack)
  attack = attack * (1 + heroData:GetProperty(HeroEffectDefine.AttackRate))
end

local function GetPhysicalDefense(self, heroData)
  local defense = heroData:GetProperty(HeroEffectDefine.PhysicalDefense)
  defense = defense * (1 + heroData:GetProperty(HeroEffectDefine.DefenseRate))
end

local function GetMagicDefense(self, heroData)
  local defense = heroData:GetProperty(HeroEffectDefine.MagicDefense)
  defense = defense * (1 + heroData:GetProperty(HeroEffectDefine.DefenseRate))
end

HeroPropertyUtils.GetHeroHp = GetHeroHp
HeroPropertyUtils.GetPhysicalAttack = GetPhysicalAttack
HeroPropertyUtils.GetMagicAttack = GetMagicAttack
HeroPropertyUtils.GetPhysicalDefense = GetPhysicalDefense
HeroPropertyUtils.GetMagicDefense = GetMagicDefense
return ConstClass("HeroPropertyUtils", HeroPropertyUtils)
