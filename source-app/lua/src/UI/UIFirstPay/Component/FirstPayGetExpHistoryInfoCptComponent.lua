local base = UIBaseContainer
local FirstPayGetExpHistoryInfoCptComponent = BaseClass("FirstPayGetExpHistoryInfoCptComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local FirstPayExpHistoryInfoItemComponent = require("UI.UIFirstPay.Component.FirstPayExpHistoryInfoItemComponent")
local TAB_KEY_CONFIG = {
  [1] = "fp_info_tab1",
  [2] = "fp_info_tab2"
}

function FirstPayGetExpHistoryInfoCptComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FirstPayGetExpHistoryInfoCptComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FirstPayGetExpHistoryInfoCptComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compUICommonTabGroup = self.viewSkin:AddComponent(self, UICommonTabGroup, 2)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compHistoryContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compInfoContent = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textDescText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textDescText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.loopListView2HistoryContent = self.viewSkin:AddComponent(self, UILoopListView2, 9)
  self.compEmptyTips = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compUICommonTabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style3)
  self:InitTabGroup()
  self.loopListView2HistoryContent:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.compItemRoot:SetActive(false)
  self.compEmptyTips:SetActive(false)
end

function FirstPayGetExpHistoryInfoCptComponent:ComponentDestroy()
  self.compContent:RemoveAllComponentes()
  self.viewSkin = nil
  self.compContent = nil
  self.compUICommonTabGroup = nil
  self.compItemRoot = nil
  self.compHistoryContent = nil
  self.compInfoContent = nil
  self.textDescText1 = nil
  self.textDescText2 = nil
  self.btnGoto = nil
  self.loopListView2HistoryContent = nil
  self.compEmptyTips = nil
end

function FirstPayGetExpHistoryInfoCptComponent:DataDefine()
  self.itemIndex = 0
  self.reqDataFlag = nil
end

function FirstPayGetExpHistoryInfoCptComponent:DataDestroy()
  self.itemIndex = nil
  self.reqDataFlag = nil
end

function FirstPayGetExpHistoryInfoCptComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FirstRechargeBuildingLogData, self.OnFirstRechargeBuildingLog)
end

function FirstPayGetExpHistoryInfoCptComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.FirstRechargeBuildingLogData, self.OnFirstRechargeBuildingLog)
  base.OnRemoveListener(self)
end

function FirstPayGetExpHistoryInfoCptComponent:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    return false
  end
  
  self.compUICommonTabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function FirstPayGetExpHistoryInfoCptComponent:GetTabGroupList()
  self.tabList = {}
  table.insert(self.tabList, 1)
  table.insert(self.tabList, 2)
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    temp.minWidth = self.holder:GetName() == UIWindowNames.FirstPayGetExpHistoryPopView and 347 or 244
    temp.minHeight = 66
    temp.arrowPath = false
    temp.selectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_1.png"
    groupList[index] = temp
  end
  return groupList
end

function FirstPayGetExpHistoryInfoCptComponent:OnGroupLoadFinsh()
  local defaultSelectTab = 1
  self.compUICommonTabGroup:SelectTab(defaultSelectTab)
end

function FirstPayGetExpHistoryInfoCptComponent:OnClickTab(index)
  self.selectIndex = index
  self:RefreshCptShowHide()
  if index == 2 and not self.reqDataFlag then
    self.reqDataFlag = true
    SFSNetwork.SendMessage(MsgDefines.FirstRechargeBuildingLog)
  end
end

function FirstPayGetExpHistoryInfoCptComponent:RefreshView()
  self:RefreshInfoView()
  self:RefreshHistoryView()
end

function FirstPayGetExpHistoryInfoCptComponent:RefreshInfoView()
  local buildingExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
  if not buildingExpData then
    return
  end
  local exExpPercent = buildingExpData.exExpPercent / 100
  local expMaxLimit = tostring(math.floor(buildingExpData.expMaxLimit))
  local curStashExp = buildingExpData:GetCurRemainStashExpStr()
  local curHadReceivedExp = tostring(math.floor(buildingExpData:GetCurHadReceivedExp()))
  self.historyExpBeforeFuncOn, self.historyExpTimeBeforeFuncOn = buildingExpData:GetHistoryExpBeforeFuncOn()
  local rewardStr = ""
  self.textDescText1:SetLocalText("fp_info_desc", exExpPercent, expMaxLimit, expMaxLimit, rewardStr, curStashExp, curHadReceivedExp)
  local isHasBoughtFirstPay = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
  self.textDescText2:SetActive(not isHasBoughtFirstPay)
  if not isHasBoughtFirstPay then
    self.textDescText2:SetLocalText("fp_tips_1")
  end
  local isShowJumpFirstPayBtn = not isHasBoughtFirstPay and self.holder:GetName() ~= UIWindowNames.FirstPayGetExpHistoryTipsView
  self.btnGoto:SetActive(isShowJumpFirstPayBtn)
end

function FirstPayGetExpHistoryInfoCptComponent:RefreshHistoryView()
  if not self.buildingLogDataList then
    return
  end
  self.loopListView2HistoryContent:SetListItemCount(#self.buildingLogDataList, false, false)
  self.loopListView2HistoryContent:RefreshAllShownItem()
  self.compEmptyTips:SetActive(#self.buildingLogDataList <= 0)
end

function FirstPayGetExpHistoryInfoCptComponent:RefreshCptShowHide()
  self.compInfoContent:SetActive(self.selectIndex == 1)
  self.compHistoryContent:SetActive(self.selectIndex == 2)
end

function FirstPayGetExpHistoryInfoCptComponent:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.buildingLogDataList then
    return nil
  end
  local buildingLogData = self.buildingLogDataList[index]
  local item = loopScroll:NewListViewItem("FirstPayExpHistoryInfoItem")
  local script = self.compContent:GetComponent(item.gameObject.name, FirstPayExpHistoryInfoItemComponent)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(FirstPayExpHistoryInfoItemComponent, objectName)
  end
  script:SetData(buildingLogData)
  return item
end

function FirstPayGetExpHistoryInfoCptComponent:OnFirstRechargeBuildingLog(data)
  self.buildingLogDataList = data
  if self.historyExpBeforeFuncOn and self.historyExpBeforeFuncOn > 0 then
    local historyExpData = {}
    historyExpData.addExp = self.historyExpBeforeFuncOn
    historyExpData.time = self.historyExpTimeBeforeFuncOn or 0
    historyExpData.isHistoryFlag = true
    table.insert(self.buildingLogDataList, historyExpData)
  end
  self:RefreshHistoryView()
end

function FirstPayGetExpHistoryInfoCptComponent:OnBtnGotoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, {delay = 0.5})
end

return FirstPayGetExpHistoryInfoCptComponent
