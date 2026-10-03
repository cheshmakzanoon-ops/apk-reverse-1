local base = UIBaseView
local LWUIZoneMobilizationPersonalRankView = BaseClass("LWUIZoneMobilizationPersonalRankView", base)
local LWUIZoneMobilizationPersonalRankItemRender = require("UI.LWUIZoneMobilization.LWUIPersonalRank.Component.LWUIZoneMobilizationPersonalRankItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local rankLoopListView_path = "PopUpContent/RankRoot/RankScrollView"
local rankScrollContent_path = "PopUpContent/RankRoot/RankScrollView/Viewport/RankScrollContent"
local selfRankObj_path = "PopUpContent/RankRoot/SelfRankItem"
local empty_text_path = "PopUpContent/EmptyText"
local rank_root_path = "PopUpContent/RankRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ClearRankLoopView()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.rankLoopListView = self:AddComponent(UILoopListView2, rankLoopListView_path)
  self.rankScrollContent = self:AddComponent(UIBaseContainer, rankScrollContent_path)
  self.selfRankObj = self:AddComponent(UIBaseContainer, selfRankObj_path)
  self.titleText:SetLocalText("zone_mobilization_person_rank_title")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rankLoopListView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.selfRankItemView = self:AddComponent(LWUIZoneMobilizationPersonalRankItemRender, selfRankObj_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.rank_root = self:AddComponent(UIBaseContainer, rank_root_path)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.rankLoopListView = nil
  self.rankScrollContent = nil
  self.selfRankObj = nil
  self.selfRankItemView = nil
  self.empty_text = nil
  self.rank_root = nil
end

local function DataDefine(self)
  self.rankInfoData = nil
end

local function DataDestroy(self)
  self.rankInfoData = nil
end

local function InitData(self)
  self.rankInfoData = self:GetUserData()
  if self.rankInfoData then
    local rankListCount = table.count(self.rankInfoData.personalRankDict)
    if 0 < rankListCount then
      self.rank_root:SetActive(true)
      self.empty_text:SetText("")
      self.rankLoopListView:SetListItemCount(rankListCount, false, false)
      self.rankLoopListView:RefreshAllShownItem()
      self:ShowSelfRank()
    else
      self.rank_root:SetActive(false)
      self.empty_text:SetLocalText("zone_mobilization_player_no_data")
    end
  end
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.rankInfoData.personalRankDict)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIZoneMobilizationPersonalRankItemRender")
  local script = self.rankScrollContent:GetComponent(item.gameObject.name, LWUIZoneMobilizationPersonalRankItemRender)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.rankScrollContent:AddComponent(LWUIZoneMobilizationPersonalRankItemRender, objectName)
  end
  script:SetActive(true)
  local rankData = self.rankInfoData.personalRankDict[index]
  script:InitData(rankData)
  return item
end

local function ClearRankLoopView(self)
  self.rankScrollContent:RemoveComponents(LWUIZoneMobilizationPersonalRankItemRender)
  self.rankLoopListView:ClearAllItems()
end

local function ShowSelfRank(self)
  local rankListCount = table.count(self.rankInfoData.personalRankDict)
  self.selfRankItemView:SetActive(0 < rankListCount)
  if 0 < rankListCount then
    self.selfRankItemView:InitData(self.rankInfoData.selfRankInfo)
  end
end

LWUIZoneMobilizationPersonalRankView.OnCreate = OnCreate
LWUIZoneMobilizationPersonalRankView.OnDestroy = OnDestroy
LWUIZoneMobilizationPersonalRankView.OnEnable = OnEnable
LWUIZoneMobilizationPersonalRankView.OnDisable = OnDisable
LWUIZoneMobilizationPersonalRankView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationPersonalRankView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationPersonalRankView.DataDefine = DataDefine
LWUIZoneMobilizationPersonalRankView.DataDestroy = DataDestroy
LWUIZoneMobilizationPersonalRankView.InitData = InitData
LWUIZoneMobilizationPersonalRankView.OnGetItemByIndex = OnGetItemByIndex
LWUIZoneMobilizationPersonalRankView.ClearRankLoopView = ClearRankLoopView
LWUIZoneMobilizationPersonalRankView.ShowSelfRank = ShowSelfRank
return LWUIZoneMobilizationPersonalRankView
