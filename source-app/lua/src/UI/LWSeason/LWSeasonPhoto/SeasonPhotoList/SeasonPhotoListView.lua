local base = UIBaseView
local SeasonPhotoListView = BaseClass("SeasonPhotoListView", base)
local SeasonPhotoItem = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoItem")
local ScrollView_path = "Root/ScrollView"
local BtnBack_path = "Root/BottomBar/BtnBack"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  DataCenter.SeasonPhotoManager:RequestSeasonPhotoAllView()
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
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.BtnBack = self:AddComponent(UIButton, BtnBack_path)
  self.BtnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.ScrollView = nil
  self.BtnBack = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoSimpleAllView, self.RefreshView)
end

function SeasonPhotoListView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoSimpleAllView, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonPhotoListView:RefreshView()
  self.photoList = DataCenter.SeasonPhotoManager:GetAllViewData()
  self:ClearScroll()
  local count = math.max(#self.photoList, 10)
  self.ScrollView:SetTotalCount(count)
  self.ScrollView:RefillCells()
end

function SeasonPhotoListView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonPhotoItem)
end

function SeasonPhotoListView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonPhotoItem, itemObj)
  cellItem:ReInit(index, self.photoList[index])
end

function SeasonPhotoListView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonPhotoItem)
end

SeasonPhotoListView.OnCreate = OnCreate
SeasonPhotoListView.OnDestroy = OnDestroy
SeasonPhotoListView.OnEnable = OnEnable
SeasonPhotoListView.OnDisable = OnDisable
SeasonPhotoListView.ComponentDefine = ComponentDefine
SeasonPhotoListView.ComponentDestroy = ComponentDestroy
SeasonPhotoListView.DataDefine = DataDefine
SeasonPhotoListView.DataDestroy = DataDestroy
return SeasonPhotoListView
