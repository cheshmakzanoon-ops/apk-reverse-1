local UIRowCell = BaseClass("UIRowCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  index,
  needPosition,
  originalPosition,
  isGray,
  originalScienceId,
  needScienceId,
  goName
}
local Scale = Vector3.New(1, 1, 1)
local ScaleWithLink = Vector3.New(-1, 1, 1)
local ReScale = Vector3.New(1, -1, 1)
local ReScaleWithLink = Vector3.New(-1, -1, 1)
local line_img_path = ""
local ResetHeight = 12
local FixLineWidth = 188

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
  self.line_img = self:AddComponent(UIImage, line_img_path)
end

local function ComponentDestroy(self)
  self.line_img = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  local x, y = self.transform:Get_lossyScale()
  local lossyScale = y
  if lossyScale <= 0 then
    lossyScale = 1
  end
  self.param = param
  local t = (param.originalPosition + param.needPosition) / 2
  self.transform:Set_position(t.x, t.y, t.z)
  if not param.isGray then
    local x, y, z = self.transform:Get_position()
    y = y + 2
    self.transform:Set_position(x, y, z)
  end
  local oriY = param.originalPosition.y
  local needY = param.needPosition.y
  local size = Vector2.New(param.originalPosition.x - param.needPosition.x, 0)
  local lineName = ""
  local scale = param.link == 1 and ScaleWithLink or Scale
  if oriY == needY then
    size.y = 0
    if param.isGray then
      lineName = "UITechnology_img_line01bg"
    else
      lineName = "UITechnology_img_line01"
    end
    scale = param.link == 1 and ScaleWithLink or Scale
  elseif oriY > needY then
    size.y = oriY - needY
    size.y = size.y
    if param.isGray then
      lineName = "UITechnology_img_line02bg"
    else
      lineName = "UITechnology_img_line02"
    end
    scale = param.link == 1 and ScaleWithLink or Scale
  else
    size.y = needY - oriY
    size.y = size.y
    if param.isGray then
      lineName = "UITechnology_img_line02bg"
    else
      lineName = "UITechnology_img_line02"
    end
    scale = param.link == 1 and ReScaleWithLink or ReScale
  end
  size.x = size.x / lossyScale
  size.y = size.y / lossyScale + ResetHeight
  self.line_img:SetSizeDelta(size)
  self.line_img:LoadSprite(string.format(LoadPath.UIScience, lineName))
  self.line_img:SetLocalScale(scale)
end

UIRowCell.OnCreate = OnCreate
UIRowCell.OnDestroy = OnDestroy
UIRowCell.Param = Param
UIRowCell.OnEnable = OnEnable
UIRowCell.OnDisable = OnDisable
UIRowCell.ComponentDefine = ComponentDefine
UIRowCell.ComponentDestroy = ComponentDestroy
UIRowCell.DataDefine = DataDefine
UIRowCell.DataDestroy = DataDestroy
UIRowCell.ReInit = ReInit
return UIRowCell
