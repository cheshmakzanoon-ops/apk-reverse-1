local base = UIBaseView
local SeasonHunterRank = BaseClass("SeasonHunterRank", base)
local Localization = CS.GameEntry.Localization
local SeasonHunterRankItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterRankItem")
local __TabInfoList = {
  {
    type = SeasonHunterRankType.Survival
  },
  {
    type = SeasonHunterRankType.Kill
  }
}
local btnBack_path = "BottomBar/BtnBack"
local textTitle_path = "Root/TopBar/TextTitle"
local btnInfo_path = "Root/TopBar/InfoBtn"
local tab1_path = "Root/tabBtns/ConditionBtns/Tab1"
local tab2_path = "Root/tabBtns/ConditionBtns/Tab2"
local scrollView_path = "Root/List/ScrollView"
local selfData_path = "Root/List/SelfData"
local tips_path = "BottomBar/tips"
local emptyDes_path = "Root/List/ScrollView/emptyDes"

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
  self.textTitle = self:AddComponent(UIText, textTitle_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.tab1 = self:AddComponent(UIToggle, tab1_path)
  self.tab2 = self:AddComponent(UIToggle, tab2_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.selfData = self:AddComponent(UIBaseContainer, selfData_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle:SetLocalText("season_s4_activity_1200011_name3")
  self.tab1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(SeasonHunterRankType.Survival)
    end
  end)
  self.tab2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(SeasonHunterRankType.Kill)
    end
  end)
  self.selfData = self:AddComponent(SeasonHunterRankItem, selfData_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.tab1:SetIsOn(true)
  self:OnToggleChange(SeasonHunterRankType.Survival)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.tab1 = nil
  self.tab2 = nil
  self.scrollView = nil
  self.selfData = nil
  self.tips = nil
  self.emptyDes = nil
end

local function DataDefine(self)
  self.dataList = {}
end

local function DataDestroy(self)
end

function SeasonHunterRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetRankList, self.SeasonHunterGetRankList)
end

function SeasonHunterRank:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetRankList, self.SeasonHunterGetRankList)
  base.OnRemoveListener(self)
end

function SeasonHunterRank:OnToggleChange(type)
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

function SeasonHunterRank:SeasonHunterGetRankList()
  self:RefreshView()
end

function SeasonHunterRank:RefreshView(sendMsg)
  local isBegin = DataCenter.SeasonHunterManager:IsBattleBegin()
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  self.EndTime = isBegin and battleInfo and battleInfo.endTime
  if self.curType == SeasonHunterRankType.Survival then
    self.tips:SetText("")
  else
    self.tips:SetLocalText("season_s4_activity_1200011_desc41")
  end
  self:Update1000MS()
  self:RefreshList(sendMsg)
end

function SeasonHunterRank:RefreshList(sendMsg)
  self:ClearScroll()
  self.data = DataCenter.SeasonHunterManager:GetRankData(self.curType, sendMsg)
  self.rankList = self.data and self.data.rankArr or {}
  local count = #self.rankList or 0
  if count and 0 < count then
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  end
  self.emptyDes:SetActive(count <= 0)
  self:RefreshSelfContent()
end

function SeasonHunterRank:Update1000MS()
  if self.EndTime and UIUtil.SetLeftTimeText(self.tips, nil, self.EndTime, "season_s4_activity_1200011_desc40") then
    self.EndTime = nil
    self:RefreshList(true)
  end
end

function SeasonHunterRank:RefreshSelfContent()
  local currentData = self.data and self.data.owner
  if currentData and table.IsNotEmpty(self.rankList) then
    self.selfData:SetItemShow(currentData, nil, self.curInfo)
    self.selfData:SetActive(true)
  else
    self.selfData:SetActive(false)
  end
end

function SeasonHunterRank:ClearScroll()
  self.scrollView:RemoveComponents(SeasonHunterRankItem)
  self.scrollView:ClearCells()
end

function SeasonHunterRank:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(SeasonHunterRankItem, itemObj)
  if cellItem then
    cellItem:SetItemShow(self.rankList[index], self.EndTime, self.curInfo)
  end
end

function SeasonHunterRank:OnRankItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, SeasonHunterRankItem)
end

SeasonHunterRank.OnCreate = OnCreate
SeasonHunterRank.OnDestroy = OnDestroy
SeasonHunterRank.OnEnable = OnEnable
SeasonHunterRank.OnDisable = OnDisable
SeasonHunterRank.ComponentDefine = ComponentDefine
SeasonHunterRank.ComponentDestroy = ComponentDestroy
SeasonHunterRank.DataDefine = DataDefine
SeasonHunterRank.DataDestroy = DataDestroy
return SeasonHunterRank
