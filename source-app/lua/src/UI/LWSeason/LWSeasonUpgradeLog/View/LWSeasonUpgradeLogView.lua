local base = UIBaseView
local LWSeasonUpgradeLogView = BaseClass("LWSeasonUpgradeLogView", base)
local LWSeasonUpgradeLogItemRenderer = require("UI.LWSeason.LWSeasonUpgradeLog.Component.LWSeasonUpgradeLogItemRenderer")
local btnBlack_path = "black"
local tmpTitle_path = "mailBg/title"
local mainScroller_path = "mailBg/ScrollView"
local btnConfirm_path = "mailBg/ConfirmBtn"
local tmpConfirm_path = "mailBg/ConfirmBtn/tmpConfirm"
local mainLoop_path = "mailBg/ScrollView"
local mainContent_path = "mailBg/ScrollView/Content"

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
  self:RefreshView()
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonUpgradeLogClosed)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBlack = self:AddComponent(UIButton, btnBlack_path)
  self.tmpTitle = self:AddComponent(UIText, tmpTitle_path)
  self.mainScroller = self:AddComponent(UIScrollRect, mainScroller_path)
  self.btnConfirm = self:AddComponent(UIButton, btnConfirm_path)
  self.tmpConfirm = self:AddComponent(UIText, tmpConfirm_path)
  self.mainLoop = self:AddComponent(UILoopListView2, mainLoop_path)
  self.mainContent = self:AddComponent(UIBaseContainer, mainContent_path)
  self.btnConfirm:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.btnBlack:SetOnClick(Bind(self, self.OnClickedBlack))
  self.tmpConfirm:SetLocalText("110006")
  self.mainLoop:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

local function ComponentDestroy(self)
  self.mainContent:RemoveComponents(LWSeasonUpgradeLogItemRenderer)
  self.mainLoop:ClearAllItems()
  self.items = nil
  self.btnBlack = nil
  self.tmpTitle = nil
  self.mainScroller = nil
  self.btnConfirm = nil
  self.tmpConfirm = nil
  self.mainLoop = nil
  self.mainContent = nil
end

local function DataDefine(self)
  local data = self:GetUserData() or {}
  self.season = data.season or SeasonUtil.GetSeasonId(true)
  self.server = data.server or LuaEntry.Player:GetSelfServerId()
  self.items = {}
  self.logs = DataCenter.SeasonUpgradeLogManager:GetUpgradeLog(self.server, self.season) or {}
end

local function DataDestroy(self)
  self.server = nil
  self.season = nil
end

function LWSeasonUpgradeLogView:RefreshView()
  if self.season then
    self.tmpTitle:SetLocalText("season_update_desc01", self.season)
  end
  self.mainLoop:SetListItemCount(#self.logs, false, false)
  self.mainLoop:RefreshAllShownItem()
  DataCenter.SeasonUpgradeLogManager:RecordReadState(self.server, self.season)
end

function LWSeasonUpgradeLogView:TryGetScrollItem(listview, index)
  local dataList = self.logs
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  csItem = listview:NewListViewItem("LWSeasonUpgradeLogItemRenderer")
  theScript = LWSeasonUpgradeLogItemRenderer
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.mainContent:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(self.mainLoop, index, data)
  end
  return csItem
end

function LWSeasonUpgradeLogView:OnClickedBlack()
  if CS.CommonUtils.IsDebug() then
    DataCenter.SeasonUpgradeLogManager:ClearReadState(self.server, self.season)
  end
end

LWSeasonUpgradeLogView.OnCreate = OnCreate
LWSeasonUpgradeLogView.OnDestroy = OnDestroy
LWSeasonUpgradeLogView.OnEnable = OnEnable
LWSeasonUpgradeLogView.OnDisable = OnDisable
LWSeasonUpgradeLogView.ComponentDefine = ComponentDefine
LWSeasonUpgradeLogView.ComponentDestroy = ComponentDestroy
LWSeasonUpgradeLogView.DataDefine = DataDefine
LWSeasonUpgradeLogView.DataDestroy = DataDestroy
return LWSeasonUpgradeLogView
