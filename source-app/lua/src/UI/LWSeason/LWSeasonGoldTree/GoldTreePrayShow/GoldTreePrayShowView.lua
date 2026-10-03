local base = UIBaseView
local GoldTreePrayShow = BaseClass("GoldTreePrayShow", base)
local Localization = CS.GameEntry.Localization
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local GoldTreePrayDetail = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayDetail")
local btnBack_path = "Root/BottomBar/BtnBack"
local btnHelp_path = "Root/topArea/TopBar/helpBtn"
local tabGroup_path = "Root/topArea/UICommonTabGroup"
local emptyDes_path = "Root/emptyDes"
local goldTreePrayDetail_path = "Root/GoldTreePrayDetail"

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
  self.btnHelp = self:AddComponent(UIButton, btnHelp_path)
  self.tabGroup = self:AddComponent(UIBaseContainer, tabGroup_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.goldTreePrayDetail = self:AddComponent(UIBaseContainer, goldTreePrayDetail_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnHelp:SetOnClick(function()
    local strTips = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("record_help") or ""
    if not string.IsNullOrEmpty(strTips) then
      UIUtil.ShowIntro(Localization:GetString(2000047), Localization:GetString(2000048), Localization:GetString(strTips))
    end
  end)
  self.tabGroup = self:AddComponent(UICommonTabGroup, tabGroup_path)
  self.goldTreePrayDetail = self:AddComponent(GoldTreePrayDetail, goldTreePrayDetail_path)
  self:InitTabGroup()
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.btnHelp = nil
  self.tabGroup = nil
  self.emptyDes = nil
  self.goldTreePrayDetail = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePrayShow:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldTreeAnnouncement, self.RefreshView)
end

function GoldTreePrayShow:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreeAnnouncement, self.RefreshView)
  base.OnRemoveListener(self)
end

function GoldTreePrayShow:InitTabGroup()
  local groupList = {}
  self.curWeek = DataCenter.SeasonGoldTreeManager:GetPrayWeek()
  for index = 1, self.curWeek do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = Localization:GetString("season_s4_golden_tree_UI_38", index)
    temp.selectBgPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1.png")
    temp.arrowPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1_1.png")
    groupList[index] = temp
  end
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function GoldTreePrayShow:OnGroupLoadFinish()
  self.tabGroup:SelectTab(self.curWeek, true)
end

function GoldTreePrayShow:OnClickTab(index)
  local data = DataCenter.SeasonGoldTreeManager.announceMap[index]
  self.selectIndex = index or 0
  self.goldTreePrayDetail:RefreshView(data)
  DataCenter.SeasonGoldTreeManager:RequestAnnounceList(self.selectIndex)
end

function GoldTreePrayShow:RefreshView(data)
  if not data or not data.announceArr then
    return
  end
  if data.weekNum ~= self.selectIndex then
    return
  end
  self.goldTreePrayDetail:RefreshView(data)
end

GoldTreePrayShow.OnCreate = OnCreate
GoldTreePrayShow.OnDestroy = OnDestroy
GoldTreePrayShow.OnEnable = OnEnable
GoldTreePrayShow.OnDisable = OnDisable
GoldTreePrayShow.ComponentDefine = ComponentDefine
GoldTreePrayShow.ComponentDestroy = ComponentDestroy
GoldTreePrayShow.DataDefine = DataDefine
GoldTreePrayShow.DataDestroy = DataDestroy
return GoldTreePrayShow
