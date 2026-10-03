local base = UIBaseContainer
local LWUIActValentineRankContent = BaseClass("LWUIActValentineRankContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUIActValentineRankItem = require("UI.LWUIActValentineSendGiftRank.Component.LWUIActValentineRankItem")
local rank_scroll_path = "RankScroll"
local content_path = "RankScroll/viewPort/Content"
local self_player_path = "SelfPlayer"
local described_text_path = "DescribedText"

function LWUIActValentineRankContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActValentineRankContent:OnDestroy()
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
  local item = loopScroll:NewListViewItem("RankItem")
  local script = self.content:GetComponent(item.gameObject.name, LWUIActValentineRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(LWUIActValentineRankItem, objectName, self.activityId)
  end
  script:SetActive(true)
  script:SetData(packData, self.iconPath, self.activityId)
  return item
end

function LWUIActValentineRankContent:ComponentDefine()
  self.rank_scroll = self:AddComponent(UILoopListView2, rank_scroll_path)
  self.rank_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.self_player = self:AddComponent(LWUIActValentineRankItem, self_player_path)
  self.described_text = self:AddComponent(UITextMeshProUGUIEx, described_text_path)
end

function LWUIActValentineRankContent:ComponentDestroy()
  self.rank_scroll = nil
  self.content = nil
  self.self_player = nil
  self.described_text = nil
end

function LWUIActValentineRankContent:DataDefine()
end

function LWUIActValentineRankContent:DataDestroy()
end

function LWUIActValentineRankContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineSendGiftRankData, self.RefreshView)
end

function LWUIActValentineRankContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineSendGiftRankData, self.RefreshView)
end

function LWUIActValentineRankContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.iconPath = ""
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if temp then
    local itemId = temp.rank_score
    self.iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  end
  local isNeed = DataCenter.ValentineDataManager:CheckActSendRankDataNeedRefresh(self.activityId)
  if isNeed then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendGiftRank, self.activityId)
  end
  self:RefreshView()
end

function LWUIActValentineRankContent:RefreshView()
  local rankData = DataCenter.ValentineDataManager:GetActSendRankData(self.activityId)
  self.showData = {}
  self.owner = {score = 0, rank = 0}
  if rankData then
    self.showData = rankData.rankArr
    self.owner = rankData.owner
  end
  self.owner.isSelf = true
  self:RefreshItemView()
  self.self_player:SetData(self.owner, self.iconPath)
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  self.described_text:SetText(Localization:GetString("chocolateStar_ranksend_desc", temp.rank_max_score))
end

function LWUIActValentineRankContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.rank_scroll:SetListItemCount(#self.showData, false, false)
    self.rank_scroll:RefreshAllShownItem()
  end
end

function LWUIActValentineRankContent:GetActSendGiveMsg(msg)
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

function LWUIActValentineRankContent:GetActExchangeMsg()
  self:RefreshView()
end

function LWUIActValentineRankContent:ClearContent()
  self.content:RemoveComponents(LWUIActValentineRankItem)
  self.rank_scroll:ClearAllItems()
end

function LWUIActValentineRankContent:OnSendGiveMsg(activityId, otherUid, num, returnGiftUuid)
  local leavingMessage = ""
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingGive, activityId, otherUid, num, returnGiftUuid, leavingMessage)
end

return LWUIActValentineRankContent
