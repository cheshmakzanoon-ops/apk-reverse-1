local UICareerIcon = BaseClass("UICareerIcon", UIBaseContainer)
local base = UIBaseContainer
local level_path = "Level"
local name_path = "Name"

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
  self.level_text = self:AddComponent(UIText, level_path)
  self.name_text = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.level_text = nil
  self.name_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, careerType, careerLv)
  local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, careerLv)
  if careerTemplate == nil then
    Logger.LogError("UICareerIcon, SetData, careerTemplate = null")
    return
  end
  self.level_text:SetText(NumToRoman(careerLv))
  self.name_text:SetLocalText(careerTemplate.name)
end

UICareerIcon.OnCreate = OnCreate
UICareerIcon.OnDestroy = OnDestroy
UICareerIcon.ComponentDefine = ComponentDefine
UICareerIcon.ComponentDestroy = ComponentDestroy
UICareerIcon.DataDefine = DataDefine
UICareerIcon.DataDestroy = DataDestroy
UICareerIcon.OnAddListener = OnAddListener
UICareerIcon.OnRemoveListener = OnRemoveListener
UICareerIcon.OnEnable = OnEnable
UICareerIcon.OnDisable = OnDisable
UICareerIcon.SetData = SetData
return UICareerIcon
