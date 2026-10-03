local base = UIBaseView
local SeasonWeatherDetailView = BaseClass("SeasonWeatherDetailView", base)
local SeasonWeatherDetailItem = require("UI.LWSeason.LWSeasonWeatherDetail.Component.SeasonWeatherDetailItem")
local panelBtn_path = "panel"
local closeBtn_path = "PopUpContent/CloseBtn"
local content_path = "PopUpContent/Content/ScrollView/Viewport/Content"
local seasonWeatherDetailItem_path = "PopUpContent/Content/ScrollView/Viewport/Content/SeasonWeatherDetailItem"
local compBook = {
  {
    path = "panel",
    name = "panelBtn",
    type = UIButton
  },
  {
    path = "PopUpContent/CloseBtn",
    name = "closeBtn",
    type = UIButton
  },
  {
    path = "PopUpContent/Content/ScrollView/Viewport/Content",
    name = "content",
    type = UIBaseContainer
  },
  {
    path = "PopUpContent/Content/ScrollView/Viewport/Content/SeasonWeatherDetailItem",
    name = "seasonWeatherDetailItem",
    type = UIBaseContainer
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView(true)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panelBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.itemObj = self.seasonWeatherDetailItem.gameObject
  self.itemObj:GameObjectCreatePool()
  self.itemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(SeasonWeatherDetailItem)
  self.itemObj:GameObjectRecycleAll()
  self.panelBtn = nil
  self.closeBtn = nil
  self.content = nil
  self.seasonWeatherDetailItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonWeatherDetailView:RefreshView(init)
  self.content:RemoveComponents(SeasonWeatherDetailItem)
  self.itemObj:GameObjectRecycleAll()
  local list = DataCenter.SeasonWeatherManager:GetWeatherTypeList()
  if not list then
    return
  end
  local theItem, goItem
  local trans = self.content.transform
  for i = 1, #list do
    goItem = self.itemObj:GameObjectSpawn(trans)
    goItem.name = string.format("SeasonWeatherDetailItem_%d", i)
    theItem = self.content:AddComponent(SeasonWeatherDetailItem, goItem.name)
    theItem:ReInit(i, list[i])
    goItem:SetActive(true)
  end
end

SeasonWeatherDetailView.OnCreate = OnCreate
SeasonWeatherDetailView.OnDestroy = OnDestroy
SeasonWeatherDetailView.OnEnable = OnEnable
SeasonWeatherDetailView.OnDisable = OnDisable
SeasonWeatherDetailView.ComponentDefine = ComponentDefine
SeasonWeatherDetailView.ComponentDestroy = ComponentDestroy
SeasonWeatherDetailView.DataDefine = DataDefine
SeasonWeatherDetailView.DataDestroy = DataDestroy
return SeasonWeatherDetailView
