local MailScoutHeroItem = BaseClass("MailScoutHeroItem", UIBaseContainer)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local heroCellSmall_path = "UIHeroCellSmall"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroCellSmallN = self:AddComponent(UIHeroCellSmall, heroCellSmall_path)
end

local function ComponentDestroy(self)
  self.heroCellSmallN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, scoutHero)
  local heroRankLv = scoutHero.heroRankLevel and scoutHero.heroRankLevel.value or 0
  self.heroCellSmallN:InitWithConfigId(scoutHero.heroId.value, scoutHero.heroQuality.value, scoutHero.heroLevel.value, nil, nil, heroRankLv)
end

MailScoutHeroItem.OnCreate = OnCreate
MailScoutHeroItem.OnDestroy = OnDestroy
MailScoutHeroItem.OnEnable = OnEnable
MailScoutHeroItem.OnDisable = OnDisable
MailScoutHeroItem.ComponentDefine = ComponentDefine
MailScoutHeroItem.ComponentDestroy = ComponentDestroy
MailScoutHeroItem.DataDefine = DataDefine
MailScoutHeroItem.DataDestroy = DataDestroy
MailScoutHeroItem.RefreshData = RefreshData
return MailScoutHeroItem
