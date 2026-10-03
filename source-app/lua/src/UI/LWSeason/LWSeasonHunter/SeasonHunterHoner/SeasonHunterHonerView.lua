local base = UIBaseView
local SeasonHunterHoner = BaseClass("SeasonHunterHoner", base)
local SeasonHunterRankItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterRankItem")
local SeasonHunterWinnerItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterWinnerItem")
local __TabInfoList = {
  {
    type = SeasonHunterRankType.Win,
    name = "season_s4_activity_1200011_name6",
    icon = "Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png"
  },
  {
    type = SeasonHunterRankType.Score,
    name = "season_s4_activity_1200011_name7",
    icon = "Assets/Main/SeasonRes/S4/Sprites/UI/Hunter/ljq_s4_paiming_jisha.png"
  },
  {
    type = SeasonHunterRankType.Time,
    name = "season_s4_activity_1200011_name8"
  }
}
local btnBack_path = "root/btnBack"
local txtTitle_path = "root/imgTopBg/txtTitle"
local tab_path = "root/tabScroll/Viewport/Content/tab"
local tabContent_path = "root/tabScroll/Viewport/Content"
local scrollView_path = "root/content/content1/list/ScrollView"
local selfData_path = "root/content/content1/list/SelfData"
local emptyDes_path = "root/content/content1/emptyDes"
local win1_path = "root/content/content1/winners/gold"
local win2_path = "root/content/content1/winners/silver"
local win3_path = "root/content/content1/winners/bronze"

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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.tab = self:AddComponent(UIToggle, tab_path)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.selfData = self:AddComponent(UIBaseContainer, selfData_path)
  self.emptyDes = self:AddComponent(UIBaseContainer, emptyDes_path)
  self.win1 = self:AddComponent(UIBaseContainer, win1_path)
  self.win2 = self:AddComponent(UIBaseContainer, win2_path)
  self.win3 = self:AddComponent(UIBaseContainer, win3_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.txtTitle:SetLocalText("season_s4_activity_1200011_btn1")
  self.win1 = self:AddComponent(SeasonHunterWinnerItem, win1_path)
  self.win2 = self:AddComponent(SeasonHunterWinnerItem, win2_path)
  self.win3 = self:AddComponent(SeasonHunterWinnerItem, win3_path)
  self.tabObj = self.tab.gameObject
  self.tabObj:GameObjectCreatePool()
  self.tabObj:SetActive(false)
  self.selfData = self:AddComponent(SeasonHunterRankItem, selfData_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self:InitTab()
end

local function ComponentDestroy(self)
  self.tabContent:RemoveComponents(UIToggle)
  self.tabObj:GameObjectRecycleAll()
  self.btnBack = nil
  self.txtTitle = nil
  self.tab = nil
  self.tabContent = nil
  self.scrollView = nil
  self.selfData = nil
  self.emptyDes = nil
  self.win1 = nil
  self.win2 = nil
  self.win3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterHoner:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetRankList, self.SeasonHunterGetRankList)
end

function SeasonHunterHoner:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetRankList, self.SeasonHunterGetRankList)
  base.OnRemoveListener(self)
end

function SeasonHunterHoner:InitTab()
  self.tabList = {}
  self.tabContent:RemoveComponents(UIToggle)
  self.tabObj:GameObjectRecycleAll()
  local parent = self.tabContent.transform
  for i, v in ipairs(__TabInfoList) do
    local goItem = self.tabObj:GameObjectSpawn(parent)
    goItem.name = string.format("tab_%d", i)
    local theItem = self.tabContent:AddComponent(UIToggle, goItem.name)
    theItem.textName = theItem:AddComponent(UIText, "img_off/text_off")
    theItem.textName2 = theItem:AddComponent(UIText, "img_on/text_on")
    theItem.textName:SetLocalText(v.name)
    theItem.textName2:SetLocalText(v.name)
    theItem:SetOnValueChanged(function(isOn)
      if isOn then
        self:OnToggleChange(v.type)
      end
    end)
    self.tabList[i] = theItem
  end
  self.tabList[1]:SetIsOn(true)
  self:OnToggleChange(__TabInfoList[1].type)
end

function SeasonHunterHoner:OnToggleChange(type)
  if self.curType == type then
    return
  end
  self.curType = type
  for i, v in ipairs(__TabInfoList) do
    if v.type == type then
      self.curInfo = v
      break
    end
  end
  self:RefreshView(true)
end

function SeasonHunterHoner:SeasonHunterGetRankList()
  self:RefreshView()
end

function SeasonHunterHoner:RefreshView(sendMsg)
  self:ClearScroll()
  self.data = DataCenter.SeasonHunterManager:GetRankData(self.curType, sendMsg)
  local rankList = self.data and self.data.rankArr or {}
  self.win1:Refresh(rankList[1], self.curInfo)
  self.win2:Refresh(rankList[2], self.curInfo)
  self.win3:Refresh(rankList[3], self.curInfo)
  local count = #rankList or 0
  self.emptyDes:SetActive(count <= 0)
  count = count - 3
  self.rankList = {}
  if count and 0 < count then
    for i = 1, count do
      self.rankList[i] = rankList[i + 3]
    end
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  end
  self:RefreshSelfContent()
end

function SeasonHunterHoner:RefreshSelfContent()
  local currentData = self.data and self.data.owner
  if currentData and table.IsNotEmpty(self.rankList) then
    self.selfData:SetItemShow(currentData, nil, self.curInfo)
    self.selfData:SetActive(true)
  else
    self.selfData:SetActive(false)
  end
end

function SeasonHunterHoner:ClearScroll()
  self.scrollView:RemoveComponents(SeasonHunterRankItem)
  self.scrollView:ClearCells()
end

function SeasonHunterHoner:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(SeasonHunterRankItem, itemObj)
  if cellItem then
    cellItem:SetItemShow(self.rankList[index], nil, self.curInfo)
  end
end

function SeasonHunterHoner:OnRankItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, SeasonHunterRankItem)
end

SeasonHunterHoner.OnCreate = OnCreate
SeasonHunterHoner.OnDestroy = OnDestroy
SeasonHunterHoner.OnEnable = OnEnable
SeasonHunterHoner.OnDisable = OnDisable
SeasonHunterHoner.ComponentDefine = ComponentDefine
SeasonHunterHoner.ComponentDestroy = ComponentDestroy
SeasonHunterHoner.DataDefine = DataDefine
SeasonHunterHoner.DataDestroy = DataDestroy
return SeasonHunterHoner
