local UIPVEResourceLayer = BaseClass("UIPVEResourceLayer", UIBaseContainer)
local base = UIBaseContainer
local UIPVEResourceCell = require("UI.UIPVE.UIPVEMain.Component.UIPVEResourceCellNew")
local Const = require("Scene.PVEBattleLevel.Const")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.resource = {}
end

local function DataDestroy(self)
  self.resource = nil
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

local function ReInit(self)
  self:Refresh()
end

local function AddOneCell(self, index, own)
  local param = {}
  param.iconName = Const.ResTypeIconPath[own.resourceType] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
  param.curNum = own.num
  param.index = index
  param.resourceType = own.resourceType
  if self.resource[index] == nil then
    self.resource[index] = {}
    self.resource[index].param = param
    self.resource[index].req = self:GameObjectInstantiateAsync(UIAssets.UIMainTopResourceCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.resource[index].model = self:AddComponent(UIPVEResourceCell, nameStr)
      self.resource[index].model:ReInit(self.resource[index].param)
    end)
  elseif self.resource[index].model ~= nil then
    self.resource[index].param = param
    self.resource[index].model:ChangeParam(param)
  else
    self.resource[index].param = param
  end
end

local function RemoveOneCell(self, id)
  if self.resource[id] ~= nil and self.resource[id].req ~= nil then
    self.resource[id].req:Destroy()
    self.resource[id] = nil
  end
end

local function Refresh(self)
  self.list = DataCenter.BattleLevel:GetAllCarryResourceItemList()
  if self.list ~= nil then
    for k, v in ipairs(self.list) do
      self:AddOneCell(k, v)
    end
    local count = table.count(self.list)
    local curCount = table.count(self.resource)
    if count < curCount then
      for i = count + 1, curCount do
        self:RemoveOneCell(i)
      end
    end
  end
end

local function GetFlyNode(self, resType)
  for _, v in pairs(self.resource) do
    if v.model ~= nil and v.param.resourceType == resType then
      return v.model:GetFlyNode()
    end
  end
  return nil
end

UIPVEResourceLayer.OnCreate = OnCreate
UIPVEResourceLayer.OnDestroy = OnDestroy
UIPVEResourceLayer.ComponentDefine = ComponentDefine
UIPVEResourceLayer.ComponentDestroy = ComponentDestroy
UIPVEResourceLayer.DataDefine = DataDefine
UIPVEResourceLayer.DataDestroy = DataDestroy
UIPVEResourceLayer.OnEnable = OnEnable
UIPVEResourceLayer.OnDisable = OnDisable
UIPVEResourceLayer.OnAddListener = OnAddListener
UIPVEResourceLayer.OnRemoveListener = OnRemoveListener
UIPVEResourceLayer.AddOneCell = AddOneCell
UIPVEResourceLayer.RemoveOneCell = RemoveOneCell
UIPVEResourceLayer.ReInit = ReInit
UIPVEResourceLayer.Refresh = Refresh
UIPVEResourceLayer.GetFlyNode = GetFlyNode
return UIPVEResourceLayer
