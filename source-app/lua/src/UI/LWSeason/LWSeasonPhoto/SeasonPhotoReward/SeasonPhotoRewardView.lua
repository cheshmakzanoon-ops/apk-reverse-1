local base = UIBaseView
local SeasonPhotoReward = BaseClass("SeasonPhotoReward", base)
local SeasonPhotoTaskCell = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoTaskCell")
local UIGray = CS.UIGray
local TextTitle_path = "safeArea/titleText"
local BtnClose_path = "safeArea/CloseBtn"
local BtnPanel_path = "UICommonPopUpTitle/panel"
local ScrollView_path = "safeArea/ScrollView"
local BtnAll_path = "safeArea/BtnAll"
local GoRed_path = "safeArea/BtnAll/BtnRed"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self.EnableAnimation = true
  self:RefreshView(true)
  self:InitRedPoint()
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
  self.TextTitle = self:AddComponent(UIText, TextTitle_path)
  self.BtnClose = self:AddComponent(UIButton, BtnClose_path)
  self.BtnPanel = self:AddComponent(UIButton, BtnPanel_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.BtnAll = self:AddComponent(UIButton, BtnAll_path)
  self.GoRed = self:AddComponent(UIBaseContainer, GoRed_path)
  self.BtnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.BtnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.BtnAll:SetOnClick(BindCallback(self, self.OnClickAll))
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.TextTitle = nil
  self.BtnClose = nil
  self.BtnPanel = nil
  self.ScrollView = nil
  self.BtnAll = nil
  self.GoRed = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoTaskListUpdate, self.RefreshView)
  self:AddUIListener(EventId.SeasonPhotoTaskUpdate, self.SeasonPhotoTaskUpdate)
end

function SeasonPhotoReward:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoTaskListUpdate, self.RefreshView)
  self:RemoveUIListener(EventId.SeasonPhotoTaskUpdate, self.SeasonPhotoTaskUpdate)
  base.OnRemoveListener(self)
end

function SeasonPhotoReward:RefreshView()
  self.listData = DataCenter.SeasonPhotoManager.taskList
  local count = self.listData and #self.listData or 0
  self.TextTitle:SetLocalText("season_alliance_photo_UI_25")
  self:RefreshState()
  self:ClearScroll()
  self.ScrollView:SetTotalCount(count)
  self.ScrollView:RefillCells()
  self.EnableAnimation = nil
end

function SeasonPhotoReward:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPoint(self.CheckRedPoint, {
    RedDef.Season,
    tostring(self.activityId),
    RedDef.SeasonPhotoTask
  })
end

function SeasonPhotoReward:CheckRedPoint(count)
  local canReceive = 0 < count
  self.GoRed:SetActive(canReceive)
  UIGray.SetGray(self.BtnAll.transform, not canReceive, true)
end

function SeasonPhotoReward:RefreshState()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  local canReceive = DataCenter.SeasonPhotoManager.rewardRed > 0
  self.GoRed:SetActive(canReceive)
  UIGray.SetGray(self.BtnAll.transform, not canReceive, true)
end

function SeasonPhotoReward:OnClickAll()
  if self.listData then
    SFSNetwork.SendMessage(MsgDefines.SeasonPhotoTaskGetReward, self.activityId)
  end
end

function SeasonPhotoReward:SeasonPhotoTaskUpdate()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.listData = DataCenter.SeasonPhotoManager.taskList
  if not self.listData then
    return
  end
  self:RefreshState()
end

function SeasonPhotoReward:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonPhotoTaskCell)
end

function SeasonPhotoReward:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonPhotoTaskCell, itemObj)
  cellItem:ReInit(index, self.listData[index], self.activityId)
  if self.EnableAnimation then
    cellItem:ShowFadeInEffect()
  end
end

function SeasonPhotoReward:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonPhotoTaskCell)
end

SeasonPhotoReward.OnCreate = OnCreate
SeasonPhotoReward.OnDestroy = OnDestroy
SeasonPhotoReward.OnEnable = OnEnable
SeasonPhotoReward.OnDisable = OnDisable
SeasonPhotoReward.ComponentDefine = ComponentDefine
SeasonPhotoReward.ComponentDestroy = ComponentDestroy
SeasonPhotoReward.DataDefine = DataDefine
SeasonPhotoReward.DataDestroy = DataDestroy
return SeasonPhotoReward
