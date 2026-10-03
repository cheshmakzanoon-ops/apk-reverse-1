local base = UIBaseContainer
local RecordContent = BaseClass("RecordContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RecordItem = require("UI.LWUIActValentineReceiveGiftRecord.Component.RecordItem")
local be_Receive_scroll_path = "RecordScroll"
local content_path = "RecordScroll/viewPort/Content"
local empty_text_path = "EmptyText"
local onePageNum = 50

function RecordContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function RecordContent:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local packData = self.showData[index]
  local item = loopScroll:NewListViewItem("RecordItem")
  local script = self.content:GetComponent(item.gameObject.name, RecordItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(RecordItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.receiveTemp.send_activity_id, packData, nil, function(activityId, otherUid, num, returnGiftUuid)
  end, self.be_Receive_scroll, index - 1)
  if index == #self.showData then
    self:TryGetNextShowData()
  end
  return item
end

function RecordContent:TryGetNextShowData()
  if DataCenter.ValentineDataManager:CheckActReceiveGiftRecordDataNeedRefresh(self.activityId) then
    local recordData = DataCenter.ValentineDataManager:GetActReceiveGiftRecordData(self.activityId)
    local totalNum = recordData and recordData.recordCount or 0
    if totalNum > #self.showData then
      SFSNetwork.SendMessage(MsgDefines.ValentineOwnerReceivingHistory, self.activityId, #self.showData + 1, #self.showData + onePageNum)
    end
  end
end

function RecordContent:ComponentDefine()
  self.be_Receive_scroll = self:AddComponent(UILoopListView2, be_Receive_scroll_path)
  self.be_Receive_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.emptyText = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.emptyText:SetActive(false)
end

function RecordContent:ComponentDestroy()
  self.be_Receive_scroll = nil
  self.content = nil
  self.emptyText = nil
end

function RecordContent:DataDefine()
end

function RecordContent:DataDestroy()
end

function RecordContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineReceiveGiftRecordData, self.GetLogsMsg)
end

function RecordContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineReceiveGiftRecordData, self.GetLogsMsg)
end

function RecordContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.receiveData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if self.receiveData == nil then
    return
  end
  self.receiveTemp = self.receiveData.activityGetData
  if self.receiveTemp == nil then
    return
  end
  local recordData = DataCenter.ValentineDataManager:GetActReceiveGiftRecordData(self.receiveTemp.send_activity_id)
  self.showData = recordData and recordData.recordList or {}
  if DataCenter.ValentineDataManager:CheckActReceiveGiftRecordDataNeedRefresh(self.receiveTemp.send_activity_id) then
    SFSNetwork.SendMessage(MsgDefines.ValentineOwnerReceivingHistory, self.receiveTemp.send_activity_id, 1, onePageNum)
  end
  self:RefreshView()
end

function RecordContent:RefreshView()
  self:RefreshItemView()
end

function RecordContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.be_Receive_scroll:SetListItemCount(#self.showData, false, false)
    self.be_Receive_scroll:RefreshAllShownItem()
  end
  local showEmptyText = self.showData == nil or #self.showData == 0
  self.emptyText:SetActive(showEmptyText)
end

function RecordContent:GetLogsMsg()
  local recordData = DataCenter.ValentineDataManager:GetActReceiveGiftRecordData(self.receiveTemp.send_activity_id)
  self.showData = recordData and recordData.recordList or {}
  self:RefreshView()
end

function RecordContent:ClearContent()
  self.content:RemoveComponents(RecordItem)
  self.be_Receive_scroll:ClearAllItems()
end

return RecordContent
