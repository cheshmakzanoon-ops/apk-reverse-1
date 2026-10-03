local UIHeroAdvanceListTitleLine = BaseClass("UIHeroAdvanceListTitleLine", UIBaseContainer)
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
end

local function ComponentDestroy(self)
end

local function SetData(self, masterToInt)
end

local function OnBtnTipClick(self)
end

UIHeroAdvanceListTitleLine.OnCreate = OnCreate
UIHeroAdvanceListTitleLine.OnDestroy = OnDestroy
UIHeroAdvanceListTitleLine.ComponentDefine = ComponentDefine
UIHeroAdvanceListTitleLine.ComponentDestroy = ComponentDestroy
UIHeroAdvanceListTitleLine.SetData = SetData
UIHeroAdvanceListTitleLine.OnBtnTipClick = OnBtnTipClick
return UIHeroAdvanceListTitleLine
