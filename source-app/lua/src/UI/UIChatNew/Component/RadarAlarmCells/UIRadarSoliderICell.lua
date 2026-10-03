local UIRadarSoliderICell = BaseClass("UIRadarSoliderICell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local top_soliderNum_text_path = "Icon/lv"
local icon_path = "Icon"
local level_text_path = "count"

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
  self.top_soliderNum_text = self:AddComponent(UIText, top_soliderNum_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.top_soliderNum_text = nil
  self.level_text = nil
  self.icon = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.top_soliderNum_text:SetText("x" .. string.GetFormattedSeperatorNum(param.total))
  if param.armyId ~= nil then
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
    if template ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
    end
    if table.count(RomeNum) >= template.level then
      self.level_text:SetText(RomeNum[template.level])
    end
  end
end

UIRadarSoliderICell.OnCreate = OnCreate
UIRadarSoliderICell.OnDestroy = OnDestroy
UIRadarSoliderICell.OnEnable = OnEnable
UIRadarSoliderICell.OnDisable = OnDisable
UIRadarSoliderICell.ComponentDefine = ComponentDefine
UIRadarSoliderICell.ComponentDestroy = ComponentDestroy
UIRadarSoliderICell.DataDefine = DataDefine
UIRadarSoliderICell.DataDestroy = DataDestroy
UIRadarSoliderICell.ReInit = ReInit
return UIRadarSoliderICell
