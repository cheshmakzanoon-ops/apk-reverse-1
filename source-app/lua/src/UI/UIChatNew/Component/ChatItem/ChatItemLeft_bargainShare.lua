local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemLeft_bargainShare = BaseClass("ChatItemLeft_bargainShare", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local redKey = "<color=#dd2828> %s</color>"
local base = IChatItem
local UIGray = CS.UIGray

function ChatItemLeft_bargainShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.helpBtn = self:AddComponent(UIButton, "ChatAnchor/ChatShareNode/helpBtn")
  self.des = self:AddComponent(UIText, "ChatAnchor/ChatShareNode/des")
  self.helpCom = self:AddComponent(UIBaseContainer, "ChatAnchor/ChatShareNode/helpBtn/help")
  self.unHelpCom = self:AddComponent(UIBaseContainer, "ChatAnchor/ChatShareNode/helpBtn/unHelp")
  self.helpIcon = self:AddComponent(UIImage, "ChatAnchor/ChatShareNode/helpBtn/help/layout/icon")
  self.helpCount = self:AddComponent(UIText, "ChatAnchor/ChatShareNode/helpBtn/help/layout/count")
  self.resItem = self:AddComponent(UICommonResItem, "ChatAnchor/ChatShareNode/UICommonResItem")
  self.helpBtn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
end

function ChatItemLeft_bargainShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HelpBargainSuccess, self.RefreshState)
end

function ChatItemLeft_bargainShare:OnRemoveListener()
  self:RemoveUIListener(EventId.HelpBargainSuccess, self.RefreshState)
  base.OnRemoveListener(self)
end

function ChatItemLeft_bargainShare:OnHelpBtnClick()
  if not self.data or not self.data.itemUid then
    return
  end
  if self:GetIsCanHelp() then
    local id = DataCenter.ActBargainShopData:GetBargainSeqId(self.data.activityId, self._chatData.roomId, self.seqId)
    SFSNetwork.SendMessage(MsgDefines.BargainHelp, self.data.itemUid, id, self.data.activityId, self.data.roomId, self.seqId)
  else
    local itemData = DataCenter.ItemData:GetItemById(tonumber(self.itemTemp.bargainItemId))
    local curCount = self.itemTemp.bargainItemCount
    local count = itemData and itemData.count or 0
    LWResourceLackUtil:GotoGoodsItemLack(self.itemTemp.bargainItemId, curCount - count)
  end
end

function ChatItemLeft_bargainShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemLeft_bargainShare:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = chatData:getMessageParam()
  self.data.roomId = chatData.roomId
  self.itemTemp = DataCenter.ActBargainShopTemplateManagaer:GetActBaragainShopPropTemplate(self.data.itemId)
  self:RefreshView()
end

function ChatItemLeft_bargainShare:RefreshState()
  local id = DataCenter.ActBargainShopData:GetBargainSeqId(self.data.activityId, self._chatData.roomId, self.seqId)
  local isBargain = DataCenter.ActBargainShopData:GetIsBargain(self.data.activityId, id)
  if isBargain then
    UIGray.SetGray(self.helpBtn.transform, true, false)
    self.unHelpCom:SetActive(true)
    self.helpCom:SetActive(false)
  else
    self.unHelpCom:SetActive(false)
    self.helpCom:SetActive(true)
    UIGray.SetGray(self.helpBtn.transform, false, true)
  end
end

function ChatItemLeft_bargainShare:GetIsCanHelp()
  local itemData = DataCenter.ItemData:GetItemById(self.itemTemp.bargainItemId)
  if itemData then
    local curCount = self.itemTemp.bargainItemCount
    if curCount <= itemData.count then
      return true
    else
      return false
    end
  end
end

function ChatItemLeft_bargainShare:GetHelpCountText()
  local str
  if self:GetIsCanHelp() then
    str = "X" .. self.itemTemp.bargainItemCount
  else
    str = string.format(redKey, "X" .. self.itemTemp.bargainItemCount)
  end
  return str
end

function ChatItemLeft_bargainShare:RefreshView()
  self:RefreshState()
  self._chatHead:UpdateHead(self._userInfo, self._chatData)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  if not self.itemTemp then
    Logger.LogError("\230\149\176\230\141\174\229\188\130\229\184\184")
    return
  end
  if self.itemTemp then
    local item = {
      rewardType = self.itemTemp.bargainRewardShowType,
      itemId = self.itemTemp.bargainRewardShowItemId,
      count = self.itemTemp.bargainRewardShowCount
    }
    self.resItem:ReInit(item)
  end
  local path = DataCenter.RewardManager:GetPicByType(self.itemTemp.bargainItemType, self.itemTemp.bargainItemId)
  if not string.IsNullOrEmpty(path) then
    self.helpIcon:LoadSprite(path)
  end
  self.helpCount:SetText(self:GetHelpCountText())
end

return ChatItemLeft_bargainShare
