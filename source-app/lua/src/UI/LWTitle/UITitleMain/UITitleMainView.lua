local base = UIBaseView
local UITitleMain = BaseClass("UITitleMain", base)
local UITitleMainShowItem = require("UI.LWTitle.Component.UITitleMainShowItem")
local UITitleMainItem = require("UI.LWTitle.Component.UITitleMainItem")
local UITitleSkillItem = require("UI.LWTitle.Component.UITitleSkillItem")
local BtnBack_path = "Root/BottomBar/BtnBack"
local TabItem1_path = "Root/Tab/TabItem1"
local TabItem2_path = "Root/Tab/TabItem2"
local ContentShow_path = "Root/Content/Content1/Content"
local TitleShowItem_path = "Root/Content/Content1/Content/TitleMainShowItem"
local ScrollView1_path = "Root/Content/Content1/ScrollView1/Content1"
local Content1_path = "Root/Content/Content1/ScrollView1"
local ScrollView2_path = "Root/Content/Content2/ScrollView2/Content2"
local Content2_path = "Root/Content/Content2/ScrollView2"
local EmptyTips_path = "Root/Content/Content1/EmptyTips"
local EmptyTips2_path = "Root/Content/Content2/EmptyTips2"

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
  self.BtnBack = self:AddComponent(UIButton, BtnBack_path)
  self.TabItem1 = self:AddComponent(UIToggle, TabItem1_path)
  self.TabItem2 = self:AddComponent(UIToggle, TabItem2_path)
  self.ContentShow = self:AddComponent(UIBaseContainer, ContentShow_path)
  self.TitleShowItem = self:AddComponent(UIBaseContainer, TitleShowItem_path)
  self.ScrollView1 = self:AddComponent(GridInfinityScrollView, ScrollView1_path)
  self.Content1 = self:AddComponent(UIBaseContainer, Content1_path)
  self.ScrollView2 = self:AddComponent(GridInfinityScrollView, ScrollView2_path)
  self.Content2 = self:AddComponent(UIBaseContainer, Content2_path)
  self.EmptyTips = self:AddComponent(UIText, EmptyTips_path)
  self.EmptyTips2 = self:AddComponent(UIText, EmptyTips2_path)
  self.BtnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.TabItem1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(1, true)
    end
  end)
  self.TabItem2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(2, true)
    end
  end)
  self.ItemObj = self.TitleShowItem.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
  self.itemListGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitItemScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateItemScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyItemScroll)
  self.ScrollView1:Init(bindFunc1, bindFunc2, bindFunc3)
  self.itemListGO2 = {}
  local bindFunc21 = BindCallback(self, self.OnInitItemScroll2)
  local bindFunc22 = BindCallback(self, self.OnUpdateItemScroll2)
  local bindFunc23 = BindCallback(self, self.OnDestroyItemScroll2)
  self.ScrollView2:Init(bindFunc21, bindFunc22, bindFunc23)
end

local function ComponentDestroy(self)
  self.ContentShow:RemoveComponents(UITitleMainShowItem)
  self.ItemObj:GameObjectRecycleAll()
  self.Content1:RemoveComponents(UITitleMainItem)
  self.ScrollView1:DestroyChildNode()
  self.Content2:RemoveComponents(UITitleSkillItem)
  self.ScrollView2:DestroyChildNode()
  self.BtnBack = nil
  self.TabItem1 = nil
  self.TabItem2 = nil
  self.ContentShow = nil
  self.TitleShowItem = nil
  self.ScrollView1 = nil
  self.Content1 = nil
  self.ScrollView2 = nil
  self.Content2 = nil
  self.EmptyTips = nil
  self.EmptyTips2 = nil
end

local function DataDefine(self)
  self.uid = LuaEntry.Player.uid
  self.TabItem1:SetIsOn(true)
  self:OnToggleChange(1)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerTitleDetail)
end

local function DataDestroy(self)
end

function UITitleMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshView)
  self:AddUIListener(EventId.UserTitleGetListMessage, self.RefreshView)
  self:AddUIListener(EventId.LWUseSkill, self.RefreshView)
end

function UITitleMain:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshView)
  self:RemoveUIListener(EventId.UserTitleGetListMessage, self.RefreshView)
  self:RemoveUIListener(EventId.LWUseSkill, self.RefreshView)
  base.OnRemoveListener(self)
end

function UITitleMain:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerTitleDetail)
  self:RefreshView()
end

function UITitleMain:RefreshView()
  self.data = UIUtil.GetPlayerInfoShowByUid(self.uid)
  if self.index == 1 then
    self:RefreshTitleMain()
  else
    self:RefreshTitleSkill()
  end
end

function UITitleMain:OnToggleChange(index)
  if self.index == index then
    return
  end
  self.index = index
  self:RefreshView()
end

function UITitleMain:RefreshTitleMain()
  self:RefreshTitleMainItem()
  self.titleList = DataCenter.PlayerInfoDataManager:GetTitleList()
  local count = #self.titleList
  if 0 < count then
    self.EmptyTips:SetActive(false)
    self.ScrollView1:SetActive(true)
    self.ScrollView1:SetItemCount(count)
    self.ScrollView1:ForceUpdate()
  else
    self.EmptyTips:SetActive(true)
    self.ScrollView1:SetActive(false)
  end
end

function UITitleMain:RefreshTitleSkill()
  local titleList = DataCenter.PlayerInfoDataManager:GetTitleList()
  self.allShowData = DataCenter.MasteryManager:GetTitleShowSkillList(titleList, LuaEntry.Player:GetMainWorldPos())
  local count = #self.allShowData
  if 0 < count then
    self.EmptyTips2:SetActive(false)
    self.ScrollView2:SetActive(true)
    self.ScrollView2:SetItemCount(count)
    self.ScrollView2:ForceUpdate()
  else
    self.EmptyTips2:SetActive(true)
    self.ScrollView2:SetActive(false)
  end
end

function UITitleMain:RefreshTitleMainItem()
  local titleWall = self.data and self.data.titleWall or {}
  local isInit = false
  if not self.tabItems then
    self.tabItems = {}
    isInit = true
  end
  for i = 1, TitleShowCount do
    local cell = self.tabItems[i]
    if not cell then
      local theItem = self.ItemObj:GameObjectSpawn(self.ContentShow.transform)
      theItem.name = string.format("UITitleMainShowItem_%d", i)
      theItem:SetActive(true)
      cell = self.ContentShow:AddComponent(UITitleMainShowItem, theItem.name)
      self.tabItems[i] = cell
    end
    cell:ReInit(i, titleWall[i], self.OnSelectItem, self)
  end
  if isInit and self.tabItems[1] then
    self.tabItems[1]:SetIsOn(true)
  end
end

function UITitleMain:OnSelectItem(position)
  self.selectedPosition = position
end

function UITitleMain:OnSelectMainItem(cfgId)
  if self.selectedPosition then
    SFSNetwork.SendMessage(MsgDefines.UserTitleSetPosition, self.selectedPosition, cfgId)
  end
end

function UITitleMain:OnInitItemScroll(go, index)
  self.itemListGO[go] = self.Content1:AddComponent(UITitleMainItem, go)
end

function UITitleMain:OnUpdateItemScroll(go, index)
  index = index + 1
  local item = self.itemListGO[go]
  item:ReInit(self.titleList[index], self.uid, self.OnSelectMainItem, self)
  go:SetActive(true)
end

function UITitleMain:OnDestroyItemScroll(go, index)
end

function UITitleMain:OnInitItemScroll2(go, index)
  self.itemListGO2[go] = self.Content2:AddComponent(UITitleSkillItem, go)
end

function UITitleMain:OnUpdateItemScroll2(go, index)
  index = index + 1
  local item = self.itemListGO2[go]
  item:ReInit(self.allShowData[index])
  go:SetActive(true)
end

function UITitleMain:OnDestroyItemScroll2(go, index)
end

UITitleMain.OnCreate = OnCreate
UITitleMain.OnDestroy = OnDestroy
UITitleMain.OnEnable = OnEnable
UITitleMain.OnDisable = OnDisable
UITitleMain.ComponentDefine = ComponentDefine
UITitleMain.ComponentDestroy = ComponentDestroy
UITitleMain.DataDefine = DataDefine
UITitleMain.DataDestroy = DataDestroy
return UITitleMain
