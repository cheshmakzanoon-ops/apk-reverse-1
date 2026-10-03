local UICareerLabel = BaseClass("UICareerLabel", UIBaseContainer)
local base = UIBaseContainer
local root_path = "Root"
local name_path = "Root/Name"
local level_path = "Root/Level"
local BgColor = {
  [1] = "Common_bg_career_label_orange",
  [2] = "Common_bg_career_label_purple",
  [3] = "Common_bg_career_label_blue",
  [4] = "Common_bg_career_label_blue",
  [5] = "Common_bg_career_label_blue"
}
local MISSING_BG = string.format(LoadPath.CommonNewPath, Common_bg_career_label_blue)

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
  self.root_image = self:AddComponent(UIImage, root_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.level_text = self:AddComponent(UIText, level_path)
end

local function ComponentDestroy(self)
  self.root_image = nil
  self.name_text = nil
  self.level_text = nil
end

local function DataDefine(self)
  self.active = true
end

local function DataDestroy(self)
  self.active = nil
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
  if DataCenter.PlayerCareerManager:Enabled() then
    local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, careerLv)
    if careerTemplate then
      self.root_image:LoadSprite(string.format(LoadPath.CommonNewPath, BgColor[careerType]), MISSING_BG)
      self.name_text:SetLocalText(careerTemplate.name)
      self.level_text:SetText(NumToRoman(careerLv))
      self.root_image:SetActive(true)
      self.active = true
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_text.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.level_text.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root_image.transform)
    else
      self.root_image:SetActive(false)
      self.active = false
    end
  else
    self.root_image:SetActive(false)
    self.active = false
  end
end

local function IsActive(self)
  return self.active
end

local function SetRootActive(self, value)
  self.root_image:SetActive(value)
end

UICareerLabel.OnCreate = OnCreate
UICareerLabel.OnDestroy = OnDestroy
UICareerLabel.ComponentDefine = ComponentDefine
UICareerLabel.ComponentDestroy = ComponentDestroy
UICareerLabel.DataDefine = DataDefine
UICareerLabel.DataDestroy = DataDestroy
UICareerLabel.OnAddListener = OnAddListener
UICareerLabel.OnRemoveListener = OnRemoveListener
UICareerLabel.OnEnable = OnEnable
UICareerLabel.OnDisable = OnDisable
UICareerLabel.SetRootActive = SetRootActive
UICareerLabel.SetData = SetData
UICareerLabel.IsActive = IsActive
return UICareerLabel
