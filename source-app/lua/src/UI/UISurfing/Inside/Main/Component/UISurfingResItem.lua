local base = UIBaseContainer
local UISurfingResItem = BaseClass("UISurfingResItem", base)
local resource_num_path = "resourceNum"
local resource_icon_path = "resourceIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resAnim = self:AddComponent(UISimpleAnimation, "")
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
end

local function ComponentDestroy(self)
  self.resAnim = nil
  self.resource_icon = nil
  self.resource_num = nil
end

local function SetData(self, param)
  if param == nil then
    return
  end
  local count = param.showCount
  local iconName = param.iconName
  local numStr = string.GetFormattedStr(count)
  self.resource_icon:LoadSpriteAsync(iconName)
  self.resource_num:SetText(numStr)
end

local function RefreshData(self, showCount)
  showCount = showCount or 0
  local numStr = string.GetFormattedStr(showCount)
  self.resource_num:SetText(numStr)
  self.resAnim:Rewind("Default")
  self.resAnim:Play("Default")
end

UISurfingResItem.OnCreate = OnCreate
UISurfingResItem.OnDestroy = OnDestroy
UISurfingResItem.ComponentDefine = ComponentDefine
UISurfingResItem.ComponentDestroy = ComponentDestroy
UISurfingResItem.SetData = SetData
UISurfingResItem.RefreshData = RefreshData
return UISurfingResItem
