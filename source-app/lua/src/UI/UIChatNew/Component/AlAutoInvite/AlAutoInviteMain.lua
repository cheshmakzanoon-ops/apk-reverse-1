local AlAutoInviteMain = BaseClass("AlAutoInviteMain", UIBaseContainer)
local base = UIBaseContainer
local AlAutoInviteItem = require("UI.UIChatNew.Component.AlAutoInvite.AlAutoInviteItem")
local inviteContent_path = "Content"
local inviteSr_path = ""

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

local function OnEnable(self)
  base.OnEnable(self)
  DataCenter.AllianceAutoInviteManager:ResetUnreadCount()
  EventManager:GetInstance():Broadcast(EventId.OnGetNewAllianceAutoInvite)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.inviteSrN = self:AddComponent(UIBaseContainer, inviteSr_path)
  self.inviteContentN = self:AddComponent(GridInfinityScrollView, inviteContent_path)
  self.inviteItemsTb = {}
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.inviteContentN = nil
  self.inviteSrN = nil
  self.inviteItemsTb = nil
end

local function DataDefine(self)
  self.inviteList = {}
end

local function DataDestroy(self)
  self.inviteList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  self:SetAllCellDestroy()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.inviteContentN:Init(bindFunc1, bindFunc2, bindFunc3)
  self.inviteList = DataCenter.AllianceAutoInviteManager:GetAutoInviteList()
  local tempCount = #self.inviteList
  if 0 < tempCount then
    self.inviteContentN:SetItemCount(tempCount)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.inviteSrN:AddComponent(AlAutoInviteItem, go)
  self.inviteItemsTb[go] = item
end

local function OnUpdateScroll(self, go, index)
  local inviteInfo = self.inviteList[index + 1]
  local cellItem = self.inviteItemsTb[go]
  if inviteInfo == nil then
    return
  end
  cellItem:SetItem(inviteInfo)
end

local function OnDestroyScrollItem(self, go, index)
end

local function SetAllCellDestroy(self)
  self.inviteSrN:RemoveComponents(AlAutoInviteItem)
  self.inviteContentN:DestroyChildNode()
end

AlAutoInviteMain.OnCreate = OnCreate
AlAutoInviteMain.OnDestroy = OnDestroy
AlAutoInviteMain.OnEnable = OnEnable
AlAutoInviteMain.OnDisable = OnDisable
AlAutoInviteMain.ComponentDefine = ComponentDefine
AlAutoInviteMain.ComponentDestroy = ComponentDestroy
AlAutoInviteMain.DataDefine = DataDefine
AlAutoInviteMain.DataDestroy = DataDestroy
AlAutoInviteMain.OnAddListener = OnAddListener
AlAutoInviteMain.OnRemoveListener = OnRemoveListener
AlAutoInviteMain.Refresh = Refresh
AlAutoInviteMain.OnInitScroll = OnInitScroll
AlAutoInviteMain.OnUpdateScroll = OnUpdateScroll
AlAutoInviteMain.OnDestroyScrollItem = OnDestroyScrollItem
AlAutoInviteMain.SetAllCellDestroy = SetAllCellDestroy
return AlAutoInviteMain
