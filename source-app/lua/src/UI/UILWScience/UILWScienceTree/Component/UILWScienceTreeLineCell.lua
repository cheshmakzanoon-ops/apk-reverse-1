local UILWLineCell = BaseClass("UILWLineCell", UIBaseContainer)
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
local EulerAngles = Vector3.New(0, 0, 0)
local ReEulerAngles = Vector3.New(0, 0, 90)
local line_img_path = ""
local ResetWidth = 12

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
  local isOldLine = false
  local curTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplateById(param.originalScienceId)
  if curTemplate and curTemplate.line_type == 1 then
    isOldLine = true
  end
  local oriX = param.originalPosition.x
  local needX = param.needPosition.x
  local size = Vector2.New(0, param.needPosition.y - param.originalPosition.y)
  local lineName = ""
  local scale = param.link == 1 and ScaleWithLink or Scale
  local eulerAngles = ReEulerAngles
  if oriX == needX then
    size.x = 0
    if param.isGray then
      lineName = "cfm_keji_xian_4"
    else
      lineName = "cfm_keji_xian_3"
    end
    scale = param.link == 1 and ScaleWithLink or Scale
    eulerAngles = EulerAngles
    size.y = size.y / lossyScale
    size.x = size.x / lossyScale + ResetWidth
  elseif oriX > needX then
    size.x = oriX - needX
    local temp = size.x
    size.x = size.y
    size.y = temp
    if isOldLine then
      if param.isGray then
        lineName = "cfm_keji_xian_5"
      else
        lineName = "cfm_keji_xian_6"
      end
    elseif param.isGray then
      lineName = "zxl_keji_xian_5"
    else
      lineName = "zxl_keji_xian_6"
    end
    scale = param.link == 1 and ScaleWithLink or Scale
    size.x = size.x / lossyScale
    size.y = size.y / lossyScale + ResetWidth
  else
    size.x = needX - oriX
    local temp = size.x
    size.x = size.y
    size.y = temp
    if isOldLine then
      if param.isGray then
        lineName = "cfm_keji_xian_5"
      else
        lineName = "cfm_keji_xian_6"
      end
    elseif param.isGray then
      lineName = "zxl_keji_xian_5"
    else
      lineName = "zxl_keji_xian_6"
    end
    scale = param.link == 1 and ReScaleWithLink or ReScale
    size.x = size.x / lossyScale
    size.y = size.y / lossyScale + ResetWidth
  end
  self.line_img:SetSizeDelta(size)
  self.line_img:LoadSprite(string.format(LoadPath.UILWScience, lineName))
  self.line_img:SetLocalScale(scale)
  self.line_img:SetEulerAngles(eulerAngles)
end

UILWLineCell.OnCreate = OnCreate
UILWLineCell.OnDestroy = OnDestroy
UILWLineCell.Param = Param
UILWLineCell.OnEnable = OnEnable
UILWLineCell.OnDisable = OnDisable
UILWLineCell.ComponentDefine = ComponentDefine
UILWLineCell.ComponentDestroy = ComponentDestroy
UILWLineCell.DataDefine = DataDefine
UILWLineCell.DataDestroy = DataDestroy
UILWLineCell.ReInit = ReInit
return UILWLineCell
