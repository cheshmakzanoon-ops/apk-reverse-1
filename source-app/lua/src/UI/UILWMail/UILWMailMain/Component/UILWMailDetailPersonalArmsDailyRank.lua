local UILWMailDetailPersonalArmsDailyRank = BaseClass("UILWMailDetailPersonalArmsDailyRank", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local UIPersonalArmsRankItem = require("UI.UIActivityCenterTable.Component.PersonalArms.UIPersonalArmsRankItem")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local mail_reward_common_item_path = "System/DScroll/DViewport/DContent/MailRewardCommonItem"

function UILWMailDetailPersonalArmsDailyRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailPersonalArmsDailyRank:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailPersonalArmsDailyRank:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(mail_reward_common_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "System/DScroll/DViewport/DContent/RankScroll/ViewPort/RankContent")
  self.loopListView = self:AddComponent(UILoopListView2, "System/DScroll/DViewport/DContent/RankScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function UILWMailDetailPersonalArmsDailyRank:ComponentDestroy()
  self:RemoveRewards()
  self:RemoveRanks()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.loopListView = nil
end

function UILWMailDetailPersonalArmsDailyRank:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailPersonalArmsDailyRank:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailPersonalArmsDailyRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailPersonalArmsDailyRank:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailPersonalArmsDailyRank:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local data = rapidjson.decode(self.mailData.contents)
  local rankListData = data.obj.list
  local rankList = {}
  local maxScore = -1
  for k, v in pairs(rankListData) do
    local playerData = BasePlayerInfo.New()
    playerData:ParseData(v)
    playerData.score = tonumber(v.score)
    playerData.rank = v.rank
    playerData.changerank = 0
    table.insert(rankList, playerData)
    if maxScore < playerData.score then
      maxScore = playerData.score
    end
  end
  self.rankList = rankList
  self.maxScore = maxScore
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self.rewardContent:SetActive(true)
  self:RemoveRewards()
  self:ShowReward(self.mailData)
  self:RemoveRanks()
  if rankList and 1 < #rankList then
    self.loopListView:SetActive(true)
    self.loopListView:SetListItemCount(#rankList, false, false)
    self.loopListView:RefreshAllShownItem()
  else
    self.loopListView:SetActive(false)
  end
end

function UILWMailDetailPersonalArmsDailyRank:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(UIPersonalArmsRankItem)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailPersonalArmsDailyRank:GetScrollItem(listview, index)
  local rankList = self.rankList
  if rankList == nil or #rankList <= 1 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #rankList then
    return nil
  end
  local csItem = listview:NewListViewItem("NormalRankItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "NormalRankItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(UIPersonalArmsRankItem, nameStr)
  end
  self.items[csItem]:SetData(rankList[index], self.maxScore)
  return csItem
end

function UILWMailDetailPersonalArmsDailyRank:RemoveRewards()
  self.rewardContent:RemoveComponents(MailRewardCommonItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailPersonalArmsDailyRank:ShowReward(maildata)
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
  if maildata.type == MailType.COLLECT_OVER_FLOW_MAIL then
    local data = maildata:GetMailSFSObj()
    if data and data.resourceItem then
      for i = 1, table.count(data.resourceItem) do
        local param = {
          rewardType = RewardType.RESOURCE_ITEM,
          itemId = data.resourceItem[i].t,
          count = data.resourceItem[i].v
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  return totalCnt
end

local NameCount = 0

function UILWMailDetailPersonalArmsDailyRank:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(MailRewardCommonItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param, self.mailData.rewardStatus == 1)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(MailRewardCommonItem, item.name)
    obj:ReInit(rewardData, self.mailData.rewardStatus == 1)
  end
end

function UILWMailDetailPersonalArmsDailyRank:RewardSuccess()
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
      local img = child.gameObject.transform:Find("MailRewardItem/clickBtn/ItemIcon")
      if img then
        local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
        local flyPos = Vector3.New(0, 0, 0)
        UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
      end
    end
  end
end

function UILWMailDetailPersonalArmsDailyRank:setMailText(txt)
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

function UILWMailDetailPersonalArmsDailyRank:OnPointerClick(clickPos)
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

return UILWMailDetailPersonalArmsDailyRank
