local base = UIBaseContainer
local RecordContent = BaseClass("RecordContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RecordItem = require("UI.LWUIActValentineSendGiftRecord.Component.RecordItem")
local be_send_scroll_path = "RecordScroll"
local content_path = "RecordScroll/viewPort/Content"
local u_i_common_res_item1_path = "BottomContent/itemContent/item1Content/UICommonResItem1"
local item1_num_path = "BottomContent/itemContent/item1Num"
local u_i_common_res_item2_path = "BottomContent/itemContent/item2Content/UICommonResItem2"
local item2_num_path = "BottomContent/itemContent/item2Num"
local empty_text_path = "EmptyText"
local gift_content_path = "BottomContent/ScrollView/Viewport/Content1"
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
  script:SetData(self.targetActId, packData, nil, function(activityId, otherUid, num, returnGiftUuid)
  end, self.be_send_scroll, index - 1, self.targetActId, self.nextOpenTimeReal)
  if index == #self.showData then
    self:TryGetNextShowData()
  end
  return item
end

function RecordContent:TryGetNextShowData()
  if DataCenter.ValentineDataManager:CheckActSendGiftRecordDataNeedRefresh(self.activityId) then
    local recordData = DataCenter.ValentineDataManager:GetActSendGiftRecordData(self.activityId)
    local totalNum = recordData and recordData.recordCount or 0
    if totalNum > #self.showData then
      SFSNetwork.SendMessage(MsgDefines.LottoGiveLogs, self.activityId, #self.showData + 1, #self.showData + onePageNum)
    end
  end
end

function RecordContent:ComponentDefine()
  self.be_send_scroll = self:AddComponent(UILoopListView2, be_send_scroll_path)
  self.be_send_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.u_i_common_res_item1 = self:AddComponent(UICommonResItem, u_i_common_res_item1_path)
  self.item1_num = self:AddComponent(UITextMeshProUGUIEx, item1_num_path)
  self.u_i_common_res_item2 = self:AddComponent(UICommonResItem, u_i_common_res_item2_path)
  self.item2_num = self:AddComponent(UITextMeshProUGUIEx, item2_num_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.empty_text:SetActive(false)
  self.giftContent = self:AddComponent(UIBaseContainer, gift_content_path)
end

function RecordContent:ComponentDestroy()
  self:DestroyAllGiftItem()
  self.be_send_scroll = nil
  self.content = nil
  self.u_i_common_res_item1 = nil
  self.item1_num = nil
  self.u_i_common_res_item2 = nil
  self.item2_num = nil
  self.empty_text = nil
  self.giftContent = nil
end

function RecordContent:DataDefine()
  self.rewardModel = {}
end

function RecordContent:DataDestroy()
  self.rewardModel = {}
end

function RecordContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineSendGiftRecordData, self.GetLogsMsg)
end

function RecordContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineSendGiftRecordData, self.GetLogsMsg)
end

function RecordContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if self.actTemp == nil then
    return
  end
  local recordData = DataCenter.ValentineDataManager:GetActSendGiftRecordData(self.activityId)
  self.showData = recordData and recordData.recordList or {}
  if DataCenter.ValentineDataManager:CheckActSendGiftRecordDataNeedRefresh(self.activityId) then
    SFSNetwork.SendMessage(MsgDefines.GiftOwnerSendHistory, self.activityId, 1, onePageNum)
  end
  self:RefreshView()
end

function RecordContent:RefreshView()
  self:RefreshItemView()
  self:RefreshAllGifts()
end

function RecordContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.be_send_scroll:SetListItemCount(#self.showData, false, false)
    self.be_send_scroll:RefreshAllShownItem()
  end
  local showEmptyText = self.showData == nil or #self.showData == 0
  self.empty_text:SetActive(showEmptyText)
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if temp then
    local recordData = DataCenter.ValentineDataManager:GetActSendGiftRecordData(self.activityId)
    local send_fast = temp.send_fast
    if send_fast[1] then
      self.u_i_common_res_item1:SetActive(true)
      self.item1_num:SetActive(true)
      local itemId = send_fast[1]
      local param = {
        rewardType = RewardType.GOODS,
        itemId = itemId
      }
      self.u_i_common_res_item1:ReInit(param)
      local num = 0
      if recordData and recordData.totalSendHistory and recordData.totalSendHistory[tostring(itemId)] then
        num = recordData.totalSendHistory[tostring(itemId)]
      end
      self.item1_num:SetText("x" .. num)
    else
      self.u_i_common_res_item1:SetActive(false)
      self.item1_num:SetActive(false)
    end
    if send_fast[2] then
      self.u_i_common_res_item2:SetActive(true)
      self.item2_num:SetActive(true)
      local itemId = send_fast[2]
      local param = {
        rewardType = RewardType.GOODS,
        itemId = itemId
      }
      self.u_i_common_res_item2:ReInit(param)
      local num = 0
      if recordData and recordData.totalSendHistory and recordData.totalSendHistory[tostring(itemId)] then
        num = recordData.totalSendHistory[tostring(itemId)]
      end
      self.item2_num:SetText("x" .. num)
    else
      self.u_i_common_res_item2:SetActive(false)
      self.item2_num:SetActive(false)
    end
  end
end

function RecordContent:GetLogsMsg()
  local recordData = DataCenter.ValentineDataManager:GetActSendGiftRecordData(self.activityId)
  self.showData = recordData and recordData.recordList or {}
  self:RefreshView()
end

function RecordContent:ClearContent()
  self.content:RemoveComponents(RecordItem)
  self.be_send_scroll:ClearAllItems()
end

local NameCount = 1

function RecordContent:RefreshAllGifts()
  self:DestroyAllGiftItem()
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if temp then
    local recordData = DataCenter.ValentineDataManager:GetActSendGiftRecordData(self.activityId)
    if recordData and recordData.totalSendHistory then
      local num = 0
      for itemId, n in pairs(recordData.totalSendHistory) do
        num = num + 1
        self.rewardModel[itemId] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local transform = go.transform
          go:SetActive(true)
          transform:SetParent(self.giftContent.transform)
          transform:Set_sizeDelta(150, 150)
          transform:Set_localScale(0.5, 0.5, 0.5)
          transform:Set_pivot(0, 1)
          local nameString = tostring(NameCount)
          go.name = nameString
          NameCount = NameCount + 1
          local param = {
            rewardType = RewardType.GOODS,
            itemId = itemId,
            count = n
          }
          local cell = self.giftContent:AddComponent(UICommonResItem, nameString)
          cell:ReInit(param)
        end)
      end
    end
  end
end

function RecordContent:DestroyAllGiftItem()
  self.giftContent:RemoveComponents(UICommonResItem)
  if self.rewardModel ~= nil then
    for k, v in pairs(self.rewardModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModel = {}
end

return RecordContent
