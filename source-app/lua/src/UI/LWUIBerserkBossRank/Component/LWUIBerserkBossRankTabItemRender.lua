local base = UIBaseContainer
local LWUIBerserkBossRankTabItemRender = BaseClass("LWUIBerserkBossRankTabItemRender", base)
local tabBtn_path = ""
local tabText_path = "TabText"
local chooseTabText_path = "ChooseState/ChooseTabText"
local chooseState_path = "ChooseState"

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
  self.chooseTabText = self:AddComponent(UIText, chooseTabText_path)
  self.chooseState = self:AddComponent(UIBaseContainer, chooseState_path)
  self.tabBtn:SetOnClick(function()
    self:TabBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabBtn = nil
  self.tabText = nil
  self.chooseTabText = nil
  self.chooseState = nil
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
  self:AddUIListener(EventId.ChangeBerserkBossRankTable, self.SetSelectState)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeBerserkBossRankTable, self.SetSelectState)
  base.OnRemoveListener(self)
end

local function InitData(self, index, data, selectIndex)
  self.itemIndex = index
  self.data = data
  self.tabText:SetText(data.tabName)
  self.chooseTabText:SetText(data.tabName)
  self:SetSelectState(selectIndex)
end

local function SetSelectState(self, selectIndex)
  self.chooseState:SetActive(self.itemIndex == selectIndex)
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.itemIndex)
  EventManager:GetInstance():Broadcast(EventId.ChangeBerserkBossRankTable, self.itemIndex)
end

LWUIBerserkBossRankTabItemRender.OnCreate = OnCreate
LWUIBerserkBossRankTabItemRender.OnDestroy = OnDestroy
LWUIBerserkBossRankTabItemRender.OnEnable = OnEnable
LWUIBerserkBossRankTabItemRender.OnDisable = OnDisable
LWUIBerserkBossRankTabItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossRankTabItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRankTabItemRender.DataDefine = DataDefine
LWUIBerserkBossRankTabItemRender.DataDestroy = DataDestroy
LWUIBerserkBossRankTabItemRender.InitData = InitData
LWUIBerserkBossRankTabItemRender.OnAddListener = OnAddListener
LWUIBerserkBossRankTabItemRender.OnRemoveListener = OnRemoveListener
LWUIBerserkBossRankTabItemRender.SetSelectState = SetSelectState
LWUIBerserkBossRankTabItemRender.TabBtnClick = TabBtnClick
return LWUIBerserkBossRankTabItemRender
