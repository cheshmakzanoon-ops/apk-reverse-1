local UIMonsterInvasionRecordView = BaseClass("UIMonsterInvasionRecordView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMonsterInvasionRecordItem = require("UI.MonsterInvasion.UIMonsterInvasionRecord.Component.UIMonsterInvasionRecordItem")
local txt_title_path = "UICommonPopUpTitle/safearea/TopBar/TextTitle"
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local itemScrollPath = "RecordObj/ScrollView"
local itemContentPath = "RecordObj/ScrollView/Viewport/Content"
local emptyTipPath = "RecordObj/emptyTip"

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local ShowInfo = self.showDataList[index]
  local item = loopScroll:NewListViewItem("TargetItem")
  local script = self.itemContent:GetComponent(item.gameObject.name, UIMonsterInvasionRecordItem)
  if script == nil then
    local objectName = tostring(GetItemNameSequence(self))
    item.gameObject.name = objectName
    script = self.itemContent:AddComponent(UIMonsterInvasionRecordItem, objectName)
  end
  script:SetActive(true)
  script:SetData(ShowInfo, self.activityId)
  return item
end

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = tonumber(self:GetUserData())
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemScroll = self:AddComponent(UILoopListView2, itemScrollPath)
  self.itemScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.itemContent = self:AddComponent(UIBaseContainer, itemContentPath)
  self.emptyTip = self:AddComponent(UIBaseContainer, emptyTipPath)
  self:RefreshList()
  SFSNetwork.SendMessage(MsgDefines.MonsterInvasionRecord, self.activityId)
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.emptyTip = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterInvasionGetRecord, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterInvasionGetRecord, self.RefreshList)
end

local function RefreshList(self)
  self.showDataList = {}
  local RecordRecordData = DataCenter.ActivityMonsterInvasionDataManager:GetRecordData(self.activityId)
  self.showDataList = RecordRecordData
  if not table.IsNullOrEmpty(self.showDataList) and #self.showDataList > 0 then
    self.itemScroll:SetActive(true)
    self.itemScroll:SetListItemCount(#self.showDataList, false, false)
    self.itemScroll:RefreshAllShownItem()
    self.emptyTip:SetActive(false)
  else
    self.itemScroll:SetActive(false)
    self.emptyTip:SetActive(true)
  end
end

UIMonsterInvasionRecordView.OnCreate = OnCreate
UIMonsterInvasionRecordView.OnDestroy = OnDestroy
UIMonsterInvasionRecordView.OnAddListener = OnAddListener
UIMonsterInvasionRecordView.OnRemoveListener = OnRemoveListener
UIMonsterInvasionRecordView.RefreshList = RefreshList
return UIMonsterInvasionRecordView
