local UILWSeasonCityAltarCityCell = require("UI.LWSeasonShared.UILWSeasonCityAltar.Comp.UILWSeasonCityAltarCityCell")
local base = UIBaseContainer
local UILWSeasonCityAltarGroupCell = BaseClass("UILWSeasonCityAltarGroupCell", UIBaseContainer)

function UILWSeasonCityAltarGroupCell:ComponentDefine()
  local p_list_hor_path = "p_list_hor"
  self.p_list_hor = self:AddComponent(UILoopListViewSimple, p_list_hor_path)
end

function UILWSeasonCityAltarGroupCell:ComponentDestroy()
  self.p_list_hor = nil
end

function UILWSeasonCityAltarGroupCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonCityAltarGroupCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarGroupCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonCityAltarGroupCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonCityAltarGroupCell:InitUi()
  self.p_list_hor:Clear()
  if not table.IsNullOrEmpty(self.Data) then
    self.p_list_hor:Init(UILWSeasonCityAltarCityCell)
    for _, cityTemplate in pairs(self.Data) do
      self.p_list_hor:AddData(cityTemplate)
    end
    self.p_list_hor:Show()
  end
end

return UILWSeasonCityAltarGroupCell
