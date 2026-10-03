local base = UIBaseContainer
local LWSeasonBossLoginRecordTabItemRender = BaseClass("LWSeasonBossLoginRecordTabItemRender", base)
local tabBtn_path = ""
local tabText_path = "TabText"
local chooseState_path = "ChooseState"
local chooseTabText_path = "ChooseState/ChooseTabText"
local go_reddot_path = "go_reddot"

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
  self.go_reddot = self:TryAddComponent(UIBaseContainer, go_reddot_path)
  self.go_img = self:AddComponent(UIImage, "")
  self.tabBtn:SetOnClick(function()
    self:TabBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabBtn = nil
  self.tabText = nil
  self.chooseState = nil
  self.chooseTabText = nil
  self.go_reddot = nil
  self.go_img = nil
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
  self.tabText:SetLocalText(self.data.title)
  self.chooseTabText:SetLocalText(self.data.title)
  self:SetReddot(false)
end

local function SetSelectState(self, selectIndex)
  self.chooseState:SetActive(self.itemIndex == selectIndex)
  self.go_img.unity_image.enabled = self.itemIndex ~= selectIndex
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.itemIndex)
  EventManager:GetInstance():Broadcast(EventId.ChangeWorldBossRecordTab, self.itemIndex)
end

local function SetReddot(self, state)
  if self.go_reddot then
    self.go_reddot:SetActive(state)
  end
end

LWSeasonBossLoginRecordTabItemRender.OnCreate = OnCreate
LWSeasonBossLoginRecordTabItemRender.OnDestroy = OnDestroy
LWSeasonBossLoginRecordTabItemRender.OnEnable = OnEnable
LWSeasonBossLoginRecordTabItemRender.OnDisable = OnDisable
LWSeasonBossLoginRecordTabItemRender.ComponentDefine = ComponentDefine
LWSeasonBossLoginRecordTabItemRender.ComponentDestroy = ComponentDestroy
LWSeasonBossLoginRecordTabItemRender.DataDefine = DataDefine
LWSeasonBossLoginRecordTabItemRender.DataDestroy = DataDestroy
LWSeasonBossLoginRecordTabItemRender.OnAddListener = OnAddListener
LWSeasonBossLoginRecordTabItemRender.OnRemoveListener = OnRemoveListener
LWSeasonBossLoginRecordTabItemRender.InitData = InitData
LWSeasonBossLoginRecordTabItemRender.SetSelectState = SetSelectState
LWSeasonBossLoginRecordTabItemRender.TabBtnClick = TabBtnClick
LWSeasonBossLoginRecordTabItemRender.SetReddot = SetReddot
return LWSeasonBossLoginRecordTabItemRender
