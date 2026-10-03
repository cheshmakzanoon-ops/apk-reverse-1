local base = UIBaseContainer
local LWUIWorldBossRecordTabItemRender = BaseClass("LWUIWorldBossRecordTabItemRender", base)
local tabBtn_path = ""
local tabText_path = "TabText"
local chooseState_path = "ChooseState"
local chooseTabText_path = "ChooseState/ChooseTabText"

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
  self.tabBtn = self:AddComponent(UIButton, tabBtn_path)
  self.tabText = self:AddComponent(UIText, tabText_path)
  self.chooseState = self:AddComponent(UIBaseContainer, chooseState_path)
  self.chooseTabText = self:AddComponent(UIText, chooseTabText_path)
  self.tabBtn:SetOnClick(function()
    self:TabBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabBtn = nil
  self.tabText = nil
  self.chooseState = nil
  self.chooseTabText = nil
end

local function DataDefine(self)
  self.itemIndex = 1
  self.data = nil
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeWorldBossRecordTab, self.SetSelectState)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeWorldBossRecordTab, self.SetSelectState)
  base.OnRemoveListener(self)
end

local function InitData(self, index, data, selectIndex)
  self.itemIndex = index
  self.data = data
  self:SetSelectState(selectIndex)
  local line = LocalController:instance():getLine(TableName.Activity, self.data)
  if line then
    self.tabText:SetLocalText(line.bannerTittle)
    self.chooseTabText:SetLocalText(line.bannerTittle)
  end
end

local function SetSelectState(self, selectIndex)
  self.chooseState:SetActive(self.itemIndex == selectIndex)
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.itemIndex)
  EventManager:GetInstance():Broadcast(EventId.ChangeWorldBossRecordTab, self.itemIndex)
end

LWUIWorldBossRecordTabItemRender.OnCreate = OnCreate
LWUIWorldBossRecordTabItemRender.OnDestroy = OnDestroy
LWUIWorldBossRecordTabItemRender.OnEnable = OnEnable
LWUIWorldBossRecordTabItemRender.OnDisable = OnDisable
LWUIWorldBossRecordTabItemRender.ComponentDefine = ComponentDefine
LWUIWorldBossRecordTabItemRender.ComponentDestroy = ComponentDestroy
LWUIWorldBossRecordTabItemRender.DataDefine = DataDefine
LWUIWorldBossRecordTabItemRender.DataDestroy = DataDestroy
LWUIWorldBossRecordTabItemRender.OnAddListener = OnAddListener
LWUIWorldBossRecordTabItemRender.OnRemoveListener = OnRemoveListener
LWUIWorldBossRecordTabItemRender.InitData = InitData
LWUIWorldBossRecordTabItemRender.SetSelectState = SetSelectState
LWUIWorldBossRecordTabItemRender.TabBtnClick = TabBtnClick
return LWUIWorldBossRecordTabItemRender
