local UILWMailDetailMeteoriteMoveNoticeBig = BaseClass("UILWMailDetailMeteoriteMoveNoticeBig", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local title_txt_path = "System/DetailTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"

function UILWMailDetailMeteoriteMoveNoticeBig:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailMeteoriteMoveNoticeBig:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailMeteoriteMoveNoticeBig:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
end

function UILWMailDetailMeteoriteMoveNoticeBig:ComponentDestroy()
  self:RemoveRewards()
  self.titleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
end

function UILWMailDetailMeteoriteMoveNoticeBig:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailMeteoriteMoveNoticeBig:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailMeteoriteMoveNoticeBig:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailMeteoriteMoveNoticeBig:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailMeteoriteMoveNoticeBig:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self:RemoveRewards()
  local totalCnt = self:ShowReward(self.mailData)
  self.rewardContent:SetActive(0 < totalCnt)
end

function UILWMailDetailMeteoriteMoveNoticeBig:RemoveRewards()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailMeteoriteMoveNoticeBig:ShowReward(maildata)
  local pay = maildata:GetMailPay()
  local reward = maildata:GetMailReward()
  local totalCnt = 0
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.GOLD,
        itemId = "gold",
        count = goldCnt
      })
    end
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    local tabReward = reward.rewardInfo
    for _, iteminfo in pairs(tabReward) do
      if iteminfo.type == RewardType.GOODS then
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = RewardType.GOODS,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = iteminfo.type,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  return totalCnt
end

function UILWMailDetailMeteoriteMoveNoticeBig:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  local objName = rewardData.rewardType .. NameCount
  local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
  item.name = objName
  local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
  obj:ReInit(rewardData)
end

function UILWMailDetailMeteoriteMoveNoticeBig:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.rewardContent.transform:GetChild(0).gameObject.transform.position, Vector3.New(0, 0, 0), 100, 100)
  end
  local reward = self.mailData:GetMailReward()
  local tempType = {}
  if reward and reward.rewardInfo then
    for i = 1, #reward.rewardInfo do
      if reward.rewardInfo[i].type ~= RewardType.FOOD and reward.rewardInfo[i].type ~= RewardType.GOLD then
        table.insert(tempType, RewardToResType[reward.rewardInfo[i].type])
      end
    end
  end
  if next(tempType) then
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    for i = 1, #reward.rewardInfo do
      local child = self.rewardContent.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
      if img then
        local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
        local flyPos = Vector3.New(0, 0, 0)
        UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
      end
    end
  end
end

function UILWMailDetailMeteoriteMoveNoticeBig:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  if hasLinkData or txt:find("<u>") ~= nil and txt:find("</u>") ~= nil then
    self.messageRichTxt:SetText(txt)
    self.messageTxt:SetActive(false)
    self.messageRichTxt:SetActive(true)
  else
    self.messageTxt:SetText(txt)
    self.messageTxt:SetActive(true)
    self.messageRichTxt:SetActive(false)
  end
end

function UILWMailDetailMeteoriteMoveNoticeBig:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return UILWMailDetailMeteoriteMoveNoticeBig
