local base = UIBaseContainer
local UIActLotterySelfInfoBeSendContent = BaseClass("UIActLotterySelfInfoBeSendContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIActLotterySelfInfoBeSendItem = require("UI.UIActLottery.UIActLotterySelfInfo.Component.UIActLotterySelfInfoBeSendItem")
local be_send_scroll_path = "BeSendScroll"
local resource_num_path = "ResBar/numContent/resourceNum"
local resource_icon_path = "ResBar/resourceIcon"
local content_path = "BeSendScroll/viewPort/Content"

function UIActLotterySelfInfoBeSendContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotterySelfInfoBeSendContent:OnDestroy()
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
  local item = loopScroll:NewListViewItem("SelfBeSendItem")
  local script = self.content:GetComponent(item.gameObject.name, UIActLotterySelfInfoBeSendItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActLotterySelfInfoBeSendItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.targetActId, packData, self.targetActivityTemp.give_cost_item_tab[1], function(activityId, otherUid, num, returnGiftUuid)
    self:OnSendGiveMsg(activityId, otherUid, num, returnGiftUuid)
  end, self.be_send_scroll, index - 1, self.targetActId, self.nextOpenTimeReal)
  if index == #self.showData then
    self:TryGetNextShowData()
  end
  return item
end

function UIActLotterySelfInfoBeSendContent:TryGetNextShowData()
  if self.activityDetailData == nil then
    return
  end
  if self.activityDetailData:CheckGiveLogsExpired() then
    local totalNum = self.activityDetailData.giveLogsTotalNum
    if totalNum > #self.showData then
      SFSNetwork.SendMessage(MsgDefines.LottoGiveLogs, self.activityId, #self.showData + 1, #self.showData + 50)
    end
  end
end

function UIActLotterySelfInfoBeSendContent:ComponentDefine()
  self.be_send_scroll = self:AddComponent(UILoopListView2, be_send_scroll_path)
  self.be_send_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIActLotterySelfInfoBeSendContent:ComponentDestroy()
  self.be_send_scroll = nil
  self.resource_num = nil
  self.resource_icon = nil
  self.content = nil
end

function UIActLotterySelfInfoBeSendContent:DataDefine()
end

function UIActLotterySelfInfoBeSendContent:DataDestroy()
end

function UIActLotterySelfInfoBeSendContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryGiveLogs, self.GetActLotteryGiveLogsMsg)
  self:AddUIListener(EventId.ActGiftGivingGive, self.GetActSendGiveMsg)
  self:AddUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
end

function UIActLotterySelfInfoBeSendContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLotteryGiveLogs, self.GetActLotteryGiveLogsMsg)
  self:RemoveUIListener(EventId.ActGiftGivingGive, self.GetActSendGiveMsg)
  self:RemoveUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
end

function UIActLotterySelfInfoBeSendContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.targetActId = self.activityTemp.thanksgiving_activity_id
  self.targetActivityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActId(self.targetActId)
  if self.targetActivityTemp == nil then
    return
  end
  self.targetItemId = self.targetActivityTemp.give_item
  self.showData = self.activityDetailData:GetGiveLogs()
  self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
  if self.activityDetailData:CheckGiveLogsExpired() then
    SFSNetwork.SendMessage(MsgDefines.LottoGiveLogs, self.activityId)
  end
  self:RefreshView()
end

function UIActLotterySelfInfoBeSendContent:RefreshView()
  self:RefreshItemView()
  self:RefreshResBarContent()
end

function UIActLotterySelfInfoBeSendContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.be_send_scroll:SetListItemCount(#self.showData, false, false)
    self.be_send_scroll:RefreshAllShownItem()
  end
end

function UIActLotterySelfInfoBeSendContent:RefreshResBarContent()
  local itemId = self.targetItemId
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  self.resource_icon:LoadSprite(iconPath)
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  self.resource_num:SetText(curNum)
end

function UIActLotterySelfInfoBeSendContent:GetActLotteryGiveLogsMsg()
  self.showData = self.activityDetailData:GetGiveLogs()
  self:RefreshView()
end

function UIActLotterySelfInfoBeSendContent:GetActSendGiveMsg(msg)
  if msg.returnGiftUuid and msg.returnGiftUuid ~= 0 then
    for i, v in ipairs(self.showData) do
      if v.uuid == msg.returnGiftUuid then
        v.returnGift = 1
        v.isMult = true
        break
      end
    end
  end
  self:RefreshView()
end

function UIActLotterySelfInfoBeSendContent:GetActExchangeMsg()
  self:RefreshView()
end

function UIActLotterySelfInfoBeSendContent:ClearContent()
  self.content:RemoveComponents(UIActLotterySelfInfoBeSendItem)
  self.be_send_scroll:ClearAllItems()
end

function UIActLotterySelfInfoBeSendContent:OnSendGiveMsg(activityId, otherUid, num, returnGiftUuid)
  local leavingMessage = ""
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingGive, activityId, otherUid, num, returnGiftUuid, leavingMessage)
end

function UIActLotterySelfInfoBeSendContent:Update1000MS()
  if self.nextOpenTimeReal and self.nextOpenTimeReal > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.nextOpenTimeReal then
      self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
      self:RefreshItemView()
    end
  end
end

return UIActLotterySelfInfoBeSendContent
