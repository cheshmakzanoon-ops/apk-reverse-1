local UIPVEShopCostCell = BaseClass("UIPVEShopCostCell", UIBaseContainer)
local base = UIBaseContainer
local Const = require("Scene.PVEBattleLevel.Const")
local num_text_path = "Text_num"
local cost_icon_path = "layout/CostIcon"

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
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.cost_icon = self:AddComponent(UIImage, cost_icon_path)
end

local function ComponentDestroy(self)
  self.num_text = nil
  self.cost_icon = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  local imagePic
  if self.param.resType ~= nil then
    imagePic = Const.ResTypeIconPath[self.param.resType] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
  elseif self.param.resItemId ~= nil then
    imagePic = DataCenter.ResourceItemDataManager:GetIconPath(self.param.resItemId)
  else
    imagePic = Const.ResTypeIconPath[Const.CityCutResType.Stone]
  end
  self.cost_icon:LoadSprite(imagePic)
  self.num_text:SetText(tostring(self.param.count))
  self:Refresh()
end

local function Refresh(self)
  local count = 0
  if self.param.resType ~= nil then
    count = DataCenter.BattleLevel:GetResTypeCount(self.param.resType)
  elseif self.param.resItemId ~= nil then
    count = DataCenter.BattleLevel:GetResourceItemCountByResType(self.param.resItemId)
  end
  self.num_text:SetColor(count >= self.param.count and WhiteColor or RedColor)
end

UIPVEShopCostCell.OnCreate = OnCreate
UIPVEShopCostCell.OnDestroy = OnDestroy
UIPVEShopCostCell.ComponentDefine = ComponentDefine
UIPVEShopCostCell.ComponentDestroy = ComponentDestroy
UIPVEShopCostCell.DataDefine = DataDefine
UIPVEShopCostCell.DataDestroy = DataDestroy
UIPVEShopCostCell.OnEnable = OnEnable
UIPVEShopCostCell.OnDisable = OnDisable
UIPVEShopCostCell.OnAddListener = OnAddListener
UIPVEShopCostCell.OnRemoveListener = OnRemoveListener
UIPVEShopCostCell.ReInit = ReInit
UIPVEShopCostCell.Refresh = Refresh
return UIPVEShopCostCell
