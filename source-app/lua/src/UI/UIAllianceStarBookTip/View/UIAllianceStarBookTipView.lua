local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIAllianceStarBookTipView = BaseClass("UIAllianceStarBookTipView", base)
local UIAllianceStarBookTipItem = require("UI.UIAllianceStarBookTip.Component.UIAllianceStarBookTipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
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
  base.ComponentDefine(self)
  self.tipCell = self:AddComponent(UIBaseComponent, "Root/ImgBg/Content/TipCell")
  self.tipCell:SetActive(false)
  self.tipCellPool = self.tipCell.gameObject
  self.tipCellPool:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.contentContainer:RemoveComponents(UIAllianceStarBookTipItem)
  self.tipCellPool:GameObjectRecycleAll()
  self.tipCellPool = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  self.scoreList = self.param.scoreTipList
  for i, v in ipairs(self.scoreList) do
    local obj = self.tipCellPool:GameObjectSpawn(self.contentContainer.transform)
    obj.name = "tipCellPool" .. i
    local tipItem = self.contentContainer:AddComponent(UIAllianceStarBookTipItem, obj.name)
    tipItem:SetData(self.scoreList[i])
  end
end

UIAllianceStarBookTipView.OnCreate = OnCreate
UIAllianceStarBookTipView.OnDestroy = OnDestroy
UIAllianceStarBookTipView.OnEnable = OnEnable
UIAllianceStarBookTipView.OnDisable = OnDisable
UIAllianceStarBookTipView.ComponentDefine = ComponentDefine
UIAllianceStarBookTipView.ComponentDestroy = ComponentDestroy
UIAllianceStarBookTipView.DataDefine = DataDefine
UIAllianceStarBookTipView.DataDestroy = DataDestroy
UIAllianceStarBookTipView.RefreshShow = RefreshShow
return UIAllianceStarBookTipView
