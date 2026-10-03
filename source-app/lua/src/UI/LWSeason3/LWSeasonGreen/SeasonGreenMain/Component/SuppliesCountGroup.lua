local base = UIBaseContainer
local SuppliesCountGroup = BaseClass("SuppliesCountGroup", base)
local SuppliesShowCountItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.SuppliesShowCountItem")
local countDes_path = "countDes"
local suppliesCount_path = "Icon/suppliesCount"
local countScrollView_path = "Icon/suppliesCount/Image/countScrollView"
local countParent_path = "Icon/suppliesCount/Image/countScrollView/countContent"
local closeTipBtn_path = "Icon/suppliesCount/closeTipBtn"
local countBtn_path = ""
local limitDes_1 = "Icon/suppliesCount/Image/Image_1/limitDes_1"
local limitDes_2 = "Icon/suppliesCount/Image/Image_1/limitDes_2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.countDes = self:AddComponent(UIText, countDes_path)
  self.suppliesCount = self:AddComponent(UIBaseContainer, suppliesCount_path)
  self.countScrollView = self:AddComponent(UIScrollRect, countScrollView_path)
  self.countParent = self:AddComponent(GridInfinityScrollView, countParent_path)
  self.closeTipBtn = self:AddComponent(UIButton, closeTipBtn_path)
  self.countBtn = self:AddComponent(UIButton, countBtn_path)
  self.desc1 = self:AddComponent(UIText, limitDes_1)
  self.desc2 = self:AddComponent(UIText, limitDes_2)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.desc1:SetLocalText("season_s2_ice_supplies_18")
    self.desc2:SetLocalText("season_s2_ice_supplies_17")
  else
    self.desc1:SetLocalText("season_s2_ice_supplies_17")
    self.desc2:SetLocalText("season_s2_ice_supplies_18")
  end
  self.countBtn:SetOnClick(function()
    self:ShowCount()
    self.suppliesCount:SetActive(true)
  end)
  self.closeTipBtn:SetOnClick(function()
    self.suppliesCount:SetActive(false)
  end)
  self.suppliesCount:SetActive(false)
  self.itemList = {}
  local bindFunc1 = BindCallback(self, self.OnInitItemScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateItemScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyItemScrollItem)
  self.countParent:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
  self.countDes = nil
  self.suppliesCount = nil
  self.countScrollView = nil
  self.countParent = nil
  self.closeTipBtn = nil
  self.countBtn = nil
end

local function DataDefine(self)
  self.hasRequest = false
end

local function DataDestroy(self)
end

function SuppliesCountGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshView)
end

function SuppliesCountGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshView)
  base.OnRemoveListener(self)
end

function SuppliesCountGroup:RefreshView()
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(not self.hasRequest)
  self.hasRequest = true
  local count = shareData and shareData.remainData and shareData.remainData.totalNum or 0
  count = string.format("<size=50>%s</size>", count)
  self.countDes:SetLocalText("season_oasis_UI_5", count)
end

function SuppliesCountGroup:ShowCount()
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo()
  self.remainData = shareData and shareData.remainData or {}
  self.countParent:SetItemCount(#self.remainData)
end

function SuppliesCountGroup:ClearTreasureScroll()
  if self.itemList then
    self.itemList = nil
    self.countScrollView:RemoveComponents(SuppliesShowCountItem)
    self.countParent:DestroyChildNode()
  end
end

function SuppliesCountGroup:OnInitItemScroll(go, index)
  self.itemList[go] = self.countScrollView:AddComponent(SuppliesShowCountItem, go)
end

function SuppliesCountGroup:OnUpdateItemScroll(go, index)
  local data = self.remainData[index + 1]
  local item = self.itemList[go]
  if data then
    item:ReInit(index, data)
    item:SetActive(true)
  else
    item:SetActive(false)
  end
end

function SuppliesCountGroup:OnDestroyItemScrollItem(go, index)
end

SuppliesCountGroup.OnCreate = OnCreate
SuppliesCountGroup.OnDestroy = OnDestroy
SuppliesCountGroup.OnEnable = OnEnable
SuppliesCountGroup.OnDisable = OnDisable
SuppliesCountGroup.ComponentDefine = ComponentDefine
SuppliesCountGroup.ComponentDestroy = ComponentDestroy
SuppliesCountGroup.DataDefine = DataDefine
SuppliesCountGroup.DataDestroy = DataDestroy
return SuppliesCountGroup
