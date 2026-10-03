local base = UIBaseContainer
local ULWUIActValentineRankRewardContent = BaseClass("ULWUIActValentineRankRewardContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ULWUIActValentineRankRewardItem = require("UI.LWUIActValentineSendGiftRank.Component.ULWUIActValentineRankRewardItem")
local content_path = "RankRewardScroll/viewPort/Content"
local reward_scroll_path = "RankRewardScroll"
local tip_btn_path = "tipContent/tipBtn"

function ULWUIActValentineRankRewardContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function ULWUIActValentineRankRewardContent:OnDestroy()
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
  local item = loopScroll:NewListViewItem("RankRewardItem")
  local script = self.content:GetComponent(item.gameObject.name, ULWUIActValentineRankRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(ULWUIActValentineRankRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(packData)
  return item
end

function ULWUIActValentineRankRewardContent:ComponentDefine()
  self.reward_scroll = self:AddComponent(UILoopListView2, reward_scroll_path)
  self.reward_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function ULWUIActValentineRankRewardContent:ComponentDestroy()
  self.reward_scroll = nil
  self.content = nil
  self.tip_btn = nil
end

function ULWUIActValentineRankRewardContent:DataDefine()
end

function ULWUIActValentineRankRewardContent:DataDestroy()
end

function ULWUIActValentineRankRewardContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineSendGiftRankRewardData, self.GetActRecordMsgMsg)
end

function ULWUIActValentineRankRewardContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ValentineSendGiftRankRewardData, self.GetActRecordMsgMsg)
  base.OnRemoveListener(self)
end

function ULWUIActValentineRankRewardContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.showData = DataCenter.ValentineDataManager:GetActSendRankRewardData(self.activityId)
  if self.showData == nil then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendGiftReward, self.activityId)
  end
  self:RefreshView()
end

function ULWUIActValentineRankRewardContent:RefreshView()
  self:RefreshItemView()
end

function ULWUIActValentineRankRewardContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.reward_scroll:SetListItemCount(#self.showData, false, false)
    self.reward_scroll:RefreshAllShownItem()
  end
end

function ULWUIActValentineRankRewardContent:GetActRecordMsgMsg()
  self.showData = DataCenter.ValentineDataManager:GetActSendRankRewardData(self.activityId)
  self:RefreshView()
end

function ULWUIActValentineRankRewardContent:ClearContent()
  self.content:RemoveComponents(ULWUIActValentineRankRewardItem)
  self.reward_scroll:ClearAllItems()
end

function ULWUIActValentineRankRewardContent:OnTipBtnClick()
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  local num = temp and temp.rank_require or 0
  UIUtil.ShowBubbleTips(Localization:GetString("activity_99136_13", num), self.tip_btn.transform.position, 0, 20, 0, nil, nil, {reversal = true})
end

return ULWUIActValentineRankRewardContent
