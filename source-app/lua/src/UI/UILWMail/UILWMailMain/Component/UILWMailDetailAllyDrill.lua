local UILWMailDetailAllyDrill = BaseClass("UILWMailDetailAllyDrill", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local AllyDrillRankItem = require("UI.UIAllyDrill.UIAllyDrillRank.Component.AllyDrillRankItem")
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_mvp_bg_path = "System/DScroll/DViewport/DContent/DReward/Image"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local mail_reward_common_item_path = "System/DScroll/DViewport/DContent/MailRewardCommonItem"

function UILWMailDetailAllyDrill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailAllyDrill:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailAllyDrill:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewardMvpBg = self:AddComponent(UIImage, reward_mvp_bg_path)
  self.rewarditem = self.transform:Find(mail_reward_common_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.bonus = self:AddComponent(UIText, "System/DScroll/DViewport/DContent/DReward/Image/bonus")
  self.mvp = self:AddComponent(UIBaseComponent, "System/DScroll/DViewport/DContent/MVP")
  self.mvpCity = self:AddComponent(UIDecorationMainCity, "System/DScroll/DViewport/DContent/MVP/cityIcon")
  self.mvpHead = self:AddComponent(UICommonHead, "System/DScroll/DViewport/DContent/MVP/head")
  self.mvpOfficial = self:AddComponent(UIImage, "System/DScroll/DViewport/DContent/MVP/officialIcon")
  self.mvpName = self:AddComponent(UIText, "System/DScroll/DViewport/DContent/MVP/mvpName")
  self.mvpPower = self:AddComponent(UIText, "System/DScroll/DViewport/DContent/MVP/mvpPower")
  self.mvpAttack = self:AddComponent(UIText, "System/DScroll/DViewport/DContent/MVP/mvpAttack")
  self.mvpDamage = self:AddComponent(UIText, "System/DScroll/DViewport/DContent/MVP/mvpDamage")
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "System/DScroll/DViewport/DContent/RankScroll/ViewPort/RankContent")
  self.loopListView = self:AddComponent(UILoopListView2, "System/DScroll/DViewport/DContent/RankScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function UILWMailDetailAllyDrill:ComponentDestroy()
  self:RemoveRewards()
  self:RemoveRanks()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewardMvpBg = nil
  self.rewarditem = nil
  self.loopListView = nil
end

function UILWMailDetailAllyDrill:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailAllyDrill:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailAllyDrill:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailAllyDrill:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailAllyDrill:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailAllyDrill:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailAllyDrill:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local data = rapidjson.decode(self.mailData.contents)
  local rankList = data.obj.rankList
  self.rankList = rankList
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self.rewardContent:SetActive(true)
  self:RemoveRewards()
  self:ShowReward(self.mailData)
  if data.obj.mvpBonus then
    self.rewardMvpBg:SetActive(true)
    self.bonus:SetActive(true)
    self.bonus:SetText(Localization:GetString(2010313) .. "x" .. data.obj.mvpBonus)
  else
    self.bonus:SetActive(false)
    self.rewardMvpBg:SetActive(false)
  end
  local mvpData = rankList and rankList[1]
  if mvpData then
    self.mvp:SetActive(true)
    self.mvpHead:SetEnableClickShowInfo(true, true)
    self.mvpHead:SetHeadAndFrame(mvpData.uid, mvpData.pic, mvpData.picVer, false, mvpData.headSkinId, mvpData.headSkinET)
    self.mvpCity:ReInit({
      decorationId = mvpData.baseSkinId or DEFAULT_CITY_SKIN,
      mainLevel = mvpData.level
    })
    self.mvpName:SetText(UIUtil.FormatAllianceAndName(mvpData.abbr, mvpData.name))
    self.mvpPower:SetText(string.GetFormattedSeparatorNum(mvpData.power))
    self.mvpAttack:SetLocalText(2010338, mvpData.atkCount)
    self.mvpDamage:SetLocalText(2010337, string.GetFormattedStr2(mvpData.damage))
    if mvpData.positionId and mvpData.positionId > 0 then
      self.mvpOfficial:SetActive(true)
      self.mvpOfficial:LoadSprite(LWAlMemberOffcialParam[mvpData.positionId].SmallIcon)
    elseif mvpData.alRank and mvpData.alRank >= 4 then
      self.mvpOfficial:SetActive(true)
      self.mvpOfficial:LoadSprite(LWAlMemberRankParam[mvpData.alRank].Icon)
    else
      self.mvpOfficial:SetActive(true)
    end
  else
    self.mvp:SetActive(false)
  end
  self:RemoveRanks()
  if rankList and 1 < #rankList then
    self.loopListView:SetActive(true)
    self.loopListView:SetListItemCount(#rankList - 1, false, false)
    self.loopListView:RefreshAllShownItem()
  else
    self.loopListView:SetActive(false)
  end
end

function UILWMailDetailAllyDrill:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(AllyDrillRankItem)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailAllyDrill:GetScrollItem(listview, index)
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
    self.items[csItem] = self.content:AddComponent(AllyDrillRankItem, nameStr)
  end
  self.items[csItem]:Refresh(rankList[index + 1])
  return csItem
end

function UILWMailDetailAllyDrill:RemoveRewards()
  self.rewardContent:RemoveComponents(MailRewardCommonItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailAllyDrill:ShowReward(maildata)
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

function UILWMailDetailAllyDrill:ShowRewardItem(rewardData)
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

function UILWMailDetailAllyDrill:RewardSuccess()
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

function UILWMailDetailAllyDrill:setMailText(txt)
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

function UILWMailDetailAllyDrill:OnPointerClick(clickPos)
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

return UILWMailDetailAllyDrill
