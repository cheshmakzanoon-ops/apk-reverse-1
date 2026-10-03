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
  self.title = self:AddComponent(UIText, "TitleText")
end

local function ComponentDestroy(self)
end

local function SetData(self, data)
  self.title:SetLocalText(data.title)
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
