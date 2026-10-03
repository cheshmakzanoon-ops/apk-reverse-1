local UIHeroMilitaryRankIcon = BaseClass("UIHeroMilitaryRankIcon", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIImage, "ImgIcon")
end

local function ComponentDestroy(self)
end

local function SetData(self, rankId, nextTip)
  self.imgIcon:LoadSprite(HeroUtils.GetMilitaryRankIcon(rankId))
  local level = GetTableData(TableName.HeroMilitaryRankLv, rankId, "level")
  if level == "" then
  end
  CS.UIGray.SetGray(self.imgIcon.transform, level == 0, false)
end

UIHeroMilitaryRankIcon.OnCreate = OnCreate
UIHeroMilitaryRankIcon.OnDestroy = OnDestroy
UIHeroMilitaryRankIcon.OnEnable = OnEnable
UIHeroMilitaryRankIcon.ComponentDefine = ComponentDefine
UIHeroMilitaryRankIcon.ComponentDestroy = ComponentDestroy
UIHeroMilitaryRankIcon.SetData = SetData
return UIHeroMilitaryRankIcon
