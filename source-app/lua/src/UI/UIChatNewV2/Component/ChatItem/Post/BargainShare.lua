local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_BargainShare = BaseClass("BargainShare", IChatItemPost)
local base = IChatItemPost
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local redKey = "<color=#dd2828> %s</color>"
local UIGray = CS.UIGray

function ChatItemPost_BargainShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_BargainShare:ComponentDefine()
  self.helpBtn = self:AddComponent(UIButton, "helpBtn")
  self.des = self:AddComponent(UIText, "des")
  self.helpCom = self:AddComponent(UIBaseContainer, "helpBtn/help")
  self.unHelpCom = self:AddComponent(UIBaseContainer, "helpBtn/unHelp")
  self.helpIcon = self:AddComponent(UIImage, "helpBtn/help/layout/icon")
  self.helpCount = self:AddComponent(UIText, "helpBtn/help/layout/count")
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.helpBtn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
end

function ChatItemPost_BargainShare:OnHelpBtnClick()
  if not self.data or not self.data.itemUid then
    return
  end
  if self:GetIsCanHelp() then
    local id = DataCenter.ActBargainShopData:GetBargainSeqId(self.data.activityId, self._chatData.roomId, self.seqId)
    local type = DataCenter.ActBargainShopData:GetChannelFromRoomId(self._chatData.roomId)
    SFSNetwork.SendMessage(MsgDefines.BargainHelp, self.data.itemUid, id, self.data.activityId, self.data.roomId, self.seqId, self._chatData.senderUid, type)
  else
    local itemData = DataCenter.ItemData:GetItemById(tonumber(self.itemTemp.bargainItemId))
    local curCount = self.itemTemp.bargainItemCount
    local count = itemData and itemData.count or 0
    LWResourceLackUtil:GotoGoodsItemLack(self.itemTemp.bargainItemId, curCount - count)
  end
end

function ChatItemPost_BargainShare:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = chatData:getMessageParam()
  self.data.roomId = chatData.roomId
  self.itemTemp = DataCenter.ActBargainShopTemplateManagaer:GetActBaragainShopPropTemplate(self.data.itemId)
  self:RefreshView()
end

function ChatItemPost_BargainShare:RefreshState()
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

function ChatItemPost_BargainShare:GetIsCanHelp()
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

function ChatItemPost_BargainShare:GetHelpCountText()
  local str
  if self:GetIsCanHelp() then
    str = "X" .. self.itemTemp.bargainItemCount
  else
    str = string.format(redKey, "X" .. self.itemTemp.bargainItemCount)
  end
  return str
end

function ChatItemPost_BargainShare:RefreshView()
  self:RefreshState()
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
  self.helpBtn:SetActive(not self._chatData:isMyChat())
  self.helpCount:SetText(self:GetHelpCountText())
end

function ChatItemPost_BargainShare:OnRecycle()
end

function ChatItemPost_BargainShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HelpBargainSuccess, self.RefreshState)
end

function ChatItemPost_BargainShare:OnRemoveListener()
  self:RemoveUIListener(EventId.HelpBargainSuccess, self.RefreshState)
  base.OnRemoveListener(self)
end

return ChatItemPost_BargainShare
