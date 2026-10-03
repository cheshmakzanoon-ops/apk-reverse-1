local UIAllianceInfoStarItem = BaseClass("UIAllianceInfoStarItem", UIBaseContainer)
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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.starImg = self:AddComponent(UIImage, "StarImg")
end

local function ComponentDestroy(self)
  self.starImg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

function UIAllianceInfoStarItem:SetData(num)
  if num <= 0 then
    self.starImg:SetFillAmount(0)
  elseif num <= 0.5 then
    self.starImg:SetFillAmount(0.5)
  else
    self.starImg:SetFillAmount(1)
  end
end

UIAllianceInfoStarItem.OnCreate = OnCreate
UIAllianceInfoStarItem.OnDestroy = OnDestroy
UIAllianceInfoStarItem.OnEnable = OnEnable
UIAllianceInfoStarItem.OnDisable = OnDisable
UIAllianceInfoStarItem.ComponentDefine = ComponentDefine
UIAllianceInfoStarItem.ComponentDestroy = ComponentDestroy
UIAllianceInfoStarItem.DataDefine = DataDefine
UIAllianceInfoStarItem.DataDestroy = DataDestroy
UIAllianceInfoStarItem.OnAddListener = OnAddListener
UIAllianceInfoStarItem.OnRemoveListener = OnRemoveListener
return UIAllianceInfoStarItem
