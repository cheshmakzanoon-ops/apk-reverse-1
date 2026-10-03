local LWUIMasteryCenterTabView = BaseClass("LWUIMasteryCenterTabView", UIBaseView)
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local u_i_common_tab_group_path = "Root/TabArea/UICommonTabGroup"
local content_root_path = "Root/ContentRoot"
local btn_back_path = "Root/BottomBar/BtnBack"
local TAB_KEY_CONFIG = {
  [MasteryTabType.MasterSkillTab] = "season_mastery_093",
  [MasteryTabType.TacticalCard] = "battle_card_title"
}
local PREFAB_PATH_CONFIG = {
  [MasteryTabType.MasterSkillTab] = {
    assetPath = UIAssets.MasterySkillPanelView,
    cls = "UI.LWUIMasterySkillPanel.View.LWUIMasterySkillPanelView"
  },
  [MasteryTabType.TacticalCard] = {
    assetPath = UIAssets.UITCCardMainPanel,
    cls = "UI.LWUITCCardMain.View.UITCCardMainPanelView"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.params = self:GetUserData()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshAllTabRed()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.tabGroup = self:AddComponent(UICommonTabGroup, u_i_common_tab_group_path)
  self.tabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style2)
  self:InitTabGroup()
  self.allCptList = {}
  self.contentRoot = self:AddComponent(UIBaseContainer, content_root_path)
  self.backBtn = self:AddComponent(UIButton, btn_back_path)
  self.backBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  for _, v in ipairs(self.allCptList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.allCptList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWMasteryChangeMsgGet, self.RefreshMasterRed)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RefreshMasterRed)
  self:AddUIListener(EventId.TacticalCardDataChanged, self.RefreshCardRed)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWMasteryChangeMsgGet, self.RefreshMasterRed)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RefreshMasterRed)
  self:RemoveUIListener(EventId.TacticalCardDataChanged, self.RefreshCardRed)
  base.OnRemoveListener(self)
end

function LWUIMasteryCenterTabView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    return self:RefreshTabRedPoint(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function LWUIMasteryCenterTabView:GetTabGroupList()
  self.tabList = {}
  table.insert(self.tabList, MasteryTabType.MasterSkillTab)
  if TacticalCardUtil.IsFunctionOpen() then
    table.insert(self.tabList, MasteryTabType.TacticalCard)
  end
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    groupList[index] = temp
  end
  return groupList
end

function LWUIMasteryCenterTabView:OnGroupLoadFinsh()
  local defaultSelectTab = MasteryTabType.MasterSkillTab
  if self.params and self.params.tabType then
    local canGoto = false
    for _, v in ipairs(self.tabList) do
      if v == self.params.tabType then
        canGoto = true
        break
      end
    end
    if canGoto then
      defaultSelectTab = self.params.tabType
    end
  end
  self.tabGroup:SelectTab(defaultSelectTab)
end

function LWUIMasteryCenterTabView:OnClickTab(index)
  self.selectIndex = index
  self.curSelectTab = self.tabList[index]
  self:RefreshView()
end

function LWUIMasteryCenterTabView:RefreshView()
  for tabType, v in pairs(self.allCptList) do
    if v.pageCpt then
      v.pageCpt:SetActive(tabType == self.curSelectTab)
    end
  end
  if self.allCptList[self.curSelectTab] ~= nil then
    return
  end
  local cptItem = {}
  local handleData = PREFAB_PATH_CONFIG[self.curSelectTab]
  cptItem.handleData = handleData
  self.allCptList[self.curSelectTab] = cptItem
  if not (handleData and handleData.assetPath) or not handleData.cls then
    return
  end
  local prefabPath = handleData.assetPath
  local cls = handleData.cls
  local targetTab = self.curSelectTab
  local targetParams = self.params.data
  cptItem.req = self:GameObjectInstantiateAsync(prefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.contentRoot.transform)
    go.transform:Set_localScale(1, 1, 1)
    local name = TAB_KEY_CONFIG[targetTab]
    go.name = name
    cls = require(cls)
    local pageCpt = self.contentRoot:AddComponent(cls, name)
    pageCpt.transform:Set_anchorMin(0, 0)
    pageCpt.transform:Set_anchorMax(1, 1)
    go.transform:Set_offsetMin(0, 0)
    go.transform:Set_offsetMax(0, 0)
    cptItem.pageCpt = pageCpt
    local isShow = self.curSelectTab == targetTab
    go:SetActive(isShow)
    pageCpt:ReInit(targetParams)
  end)
end

function LWUIMasteryCenterTabView:RefreshTabRedPoint(index)
  if index == MasteryTabType.MasterSkillTab then
    return SeasonRedPointUtils.IsShowMasteryRedPoint()
  elseif index == MasteryTabType.TacticalCard then
    return TacticalCardUtil.IsExistAnySlotShowRedDot() or TacticalCardUtil.IsExistCardCachaRed() or DataCenter.TacticalCardDataManager:CheckAllCoreStarUpgrade() or DataCenter.TacticalCardDataManager:HasCanReceiveBox()
  end
  return false
end

function LWUIMasteryCenterTabView:RefreshAllTabRed()
  self:RefreshMasterRed()
  self:RefreshCardRed()
end

function LWUIMasteryCenterTabView:RefreshMasterRed()
  self.tabGroup:RefreshRedDotStateDelay(MasteryTabType.MasterSkillTab)
end

function LWUIMasteryCenterTabView:RefreshCardRed()
  self.tabGroup:RefreshRedDotStateDelay(MasteryTabType.TacticalCard)
end

LWUIMasteryCenterTabView.OnCreate = OnCreate
LWUIMasteryCenterTabView.OnDestroy = OnDestroy
LWUIMasteryCenterTabView.OnEnable = OnEnable
LWUIMasteryCenterTabView.OnDisable = OnDisable
LWUIMasteryCenterTabView.ComponentDefine = ComponentDefine
LWUIMasteryCenterTabView.ComponentDestroy = ComponentDestroy
LWUIMasteryCenterTabView.DataDefine = DataDefine
LWUIMasteryCenterTabView.DataDestroy = DataDestroy
LWUIMasteryCenterTabView.OnAddListener = OnAddListener
LWUIMasteryCenterTabView.OnRemoveListener = OnRemoveListener
return LWUIMasteryCenterTabView
