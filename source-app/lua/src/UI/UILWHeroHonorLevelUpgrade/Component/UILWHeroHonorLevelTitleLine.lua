local UILWHeroHonorLevelTitleLine = BaseClass("UILWHeroHonorLevelTitleLine", UIBaseContainer)
local base = UIBaseContainer

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

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, "SubTitleText")
end

local function ComponentDestroy(self)
  self.titleText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data)
  if data then
    self.titleText:SetText(data.title or "")
  end
end

UILWHeroHonorLevelTitleLine.OnCreate = OnCreate
UILWHeroHonorLevelTitleLine.OnDestroy = OnDestroy
UILWHeroHonorLevelTitleLine.OnEnable = OnEnable
UILWHeroHonorLevelTitleLine.OnDisable = OnDisable
UILWHeroHonorLevelTitleLine.ComponentDefine = ComponentDefine
UILWHeroHonorLevelTitleLine.ComponentDestroy = ComponentDestroy
UILWHeroHonorLevelTitleLine.DataDefine = DataDefine
UILWHeroHonorLevelTitleLine.DataDestroy = DataDestroy
UILWHeroHonorLevelTitleLine.ReInit = ReInit
return UILWHeroHonorLevelTitleLine
