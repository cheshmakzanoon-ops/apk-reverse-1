local UILWMailDetailCommon = BaseClass("UILWMailDetailCommon", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local RewardUtil = require("Util.RewardUtil")
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local MailRankItem = require("UI.UILWMail.UILWMailMain.Component.MailRankItem")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_signature_txt_path = "System/DScroll/DViewport/DContent/DMessageSignature"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local detail_time_bg_path = "System/DetailTimeBg"
local detail_time_and_like_bg_path = "System/DetailTimeAndLikeBg"
local time2_txt_path = "System/DetailTimeAndLikeBg/DetailTime2"
local likeBtn_path = "System/DetailTimeAndLikeBg/likeContent/likeBtn"
local likeImg_path = "System/DetailTimeAndLikeBg/likeContent/likeBtn/likeImg"
local likeNum_path = "System/DetailTimeAndLikeBg/likeContent/likeBtn/likeNum"
local dislikeBtn_path = "System/DetailTimeAndLikeBg/likeContent/dislikeBtn"
local dislikeNum_path = "System/DetailTimeAndLikeBg/likeContent/dislikeBtn/dislikeNum"
local floatLike_path = "System/DetailTimeAndLikeBg/floatLike"
local headLike_path = "System/DetailTimeAndLikeBg/floatLike/headLike"
local likeContent_path = "System/DetailTimeAndLikeBg/likeContent"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local mail_reward_common_item_path = "System/DScroll/DViewport/DContent/MailRewardCommonItem"
local tra_divideImg_path = "System/DScroll/DViewport/DContent/TranslateObj/Image"
local tra_btn_path = "System/DetailTimeBg/TranslateBtn"
local tra_msgTxet_path = "System/DScroll/DViewport/DContent/TranslateText"
local tra_msgRichTxet_path = "System/DScroll/DViewport/DContent/TranslateRichText"
local tra_translatingTxet = "System/DScroll/DViewport/DContent/TranslatingText"
local tra_finishImg = "System/DetailTimeBg/TranslateFinishImg"
local translationRating_btn_path = "System/DScroll/DViewport/DContent/TranslationRatingEntranceBtn"
local translate_btn2_path = "System/DetailTimeAndLikeBg/likeContent/TranslateBtn2"
local translate_finish_img2_path = "System/DetailTimeAndLikeBg/likeContent/TranslateFinishImg2"
local rank_range_txt_path = "System/DScroll/DViewport/DContent/RankViewContent/RankInfoContent/RankRangeTxt"
local rank_fin_time_txt_path = "System/DScroll/DViewport/DContent/RankViewContent/RankInfoContent/RankFinTimeTxt"
local rank_my_item_path = "System/DScroll/DViewport/DContent/RankViewContent/RankMyItem"
local reportBtn_path = "reportBtn"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local likeType = 1
local dislikeType = 2

function UILWMailDetailCommon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailCommon:OnDestroy()
  DataCenter.MailRankDataManager:CancelGetMailRankData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailCommon:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UITextMeshProUGUIEx, message_txt_path)
  self.messageSignatureTxt = self:AddComponent(UITextMeshProUGUIEx, message_signature_txt_path)
  ChatInterface.SetEmojiTextProperty(self.messageTxt, true)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  ChatInterface.SetEmojiTextProperty(self.messageRichTxt, true)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.detail_time_bg = self:AddComponent(UIBaseContainer, detail_time_bg_path)
  self.detail_time_and_like_bg = self:AddComponent(UIBaseContainer, detail_time_and_like_bg_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.time2Txt = self:AddComponent(UIText, time2_txt_path)
  self.likeNum = self:AddComponent(UITextMeshProUGUIEx, likeNum_path)
  self.likeImg = self:AddComponent(UIImage, likeImg_path)
  self.dislikeNum = self:AddComponent(UITextMeshProUGUIEx, dislikeNum_path)
  self.likeBtn = self:AddComponent(UIButton, likeBtn_path)
  self.likeBtn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.dislikeBtn = self:AddComponent(UIButton, dislikeBtn_path)
  self.dislikeBtn:SetOnClick(function()
    self:OnDisLikeBtnClick()
  end)
  self.floatLike = self:AddComponent(UIBaseContainer, floatLike_path)
  self.headLike = self:AddComponent(UIHead, headLike_path)
  self.headLike:Refresh(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer, nil, nil, nil)
  self.floatLike:SetActive(false)
  self.likeContent = self:AddComponent(UIBaseContainer, likeContent_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(mail_reward_common_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.floatInsts = {}
  self.traDivImg = self:AddComponent(UIBaseContainer, tra_divideImg_path)
  self.traBtn = self:AddComponent(UIButton, tra_btn_path)
  self.traMsgText = self:AddComponent(UITextMeshProUGUIEx, tra_msgTxet_path)
  self.traMsgRichText = self:AddComponent(UIText, tra_msgRichTxet_path)
  self.traDoingText = self:AddComponent(UIText, tra_translatingTxet)
  self.traFinishImg = self:AddComponent(UIBaseContainer, tra_finishImg)
  self.traDoingText:SetText(Localization:GetString("120039"))
  self.translationRating_btn = self:AddComponent(UIButton, translationRating_btn_path)
  self.translationRating_btn:SetOnClick(function()
    if DataCenter.LWTranslationRatingManager:AlreadyScore(self.mailData.uid) then
      UIUtil.ShowTipsId("TranslationRate_tip_10003")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUITranslationRating, self.mailData.type, self.mailData.uid)
    end
  end)
  self.traBtn2 = self:AddComponent(UIButton, translate_btn2_path)
  self.traFinishImg2 = self:AddComponent(UIImage, translate_finish_img2_path)
  self.items = {}
  self.rankViewContent = self:AddComponent(UIBaseContainer, "System/DScroll/DViewport/DContent/RankViewContent")
  self.content = self:AddComponent(UIBaseContainer, "System/DScroll/DViewport/DContent/RankViewContent/RankScroll/ViewPort/RankContent")
  self.loopListView = self:AddComponent(UILoopListView2, "System/DScroll/DViewport/DContent/RankViewContent/RankScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.rank_range_txt = self:AddComponent(UITextMeshProUGUIEx, rank_range_txt_path)
  self.rank_fin_time_txt = self:AddComponent(UITextMeshProUGUIEx, rank_fin_time_txt_path)
  self.rank_my_item = self:AddComponent(MailRankItem, rank_my_item_path)
  self.reportBtn = self:AddComponent(UIButton, reportBtn_path)
  self.reportBtn:SetOnClick(function()
    self:OnReportBtnClick()
  end)
end

function UILWMailDetailCommon:ComponentDestroy()
  self:RemoveReward()
  self:RemoveRanks()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageSignatureTxt = nil
  self.messageRichTxt = nil
  self.detail_time_bg = nil
  self.detail_time_and_like_bg = nil
  self.timeTxt = nil
  self.time2Txt = nil
  self.likeNum = nil
  self.dislikeNum = nil
  self.likeBtn = nil
  self.dislikeBtn = nil
  self.floatLike = nil
  self.headLike = nil
  self.likeContent = nil
  self.rewardContent = nil
  self.rewarditem = nil
  if self.floatInsts then
    for _, floatInst in ipairs(self.floatInsts) do
      if not IsNull(floatInst) then
        CS.UnityEngine.GameObject.Destroy(floatInst)
      end
    end
    self.floatInsts = nil
  end
  self.traDivImg = nil
  self.traBtn = nil
  self.traMsgText = nil
  self.traMsgRichText = nil
  self.traDoingText = nil
  self.traFinishImg = nil
  self.traFinishImg2 = nil
  self.translationRating_btn = nil
  self.rank_range_txt = nil
  self.rank_fin_time_txt = nil
  self.rank_my_item = nil
end

function UILWMailDetailCommon:DataDefine()
  self.mailUid = {}
  self.mailData = {}
  self.mailRankDataUid = nil
  self.mailRankDataObj = nil
  self.rankShowData = nil
end

function UILWMailDetailCommon:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
  self.mailRankDataUid = nil
  self.mailRankDataObj = nil
  self.rankShowData = nil
end

function UILWMailDetailCommon:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailCommon:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailCommon:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeShowTranslatedStatus, self.OnTranslateFinish)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  self:AddUIListener(EventId.GetMailLikeData, self.OnGetMailLikeDataMsg)
  self:AddUIListener(EventId.RefreshMailLikeData, self.OnRefreshMailLikeDataMsg)
  self:AddUIListener(EventId.GetMailRankData, self.RefreshRankContent)
end

function UILWMailDetailCommon:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeShowTranslatedStatus, self.OnTranslateFinish)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  self:RemoveUIListener(EventId.GetMailLikeData, self.OnGetMailLikeDataMsg)
  self:RemoveUIListener(EventId.RefreshMailLikeData, self.OnRefreshMailLikeDataMsg)
  self:RemoveUIListener(EventId.GetMailRankData, self.RefreshRankContent)
end

function UILWMailDetailCommon:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  _strTitle = string.gsub(_strTitle, "\n", "")
  _strTitle = ChatInterface.CheckMessage(_strTitle)
  self.titleTxt:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.subTitleTxt:SetText(_strSubTitle)
  self.messageSignatureTxt:SetActive(self.mailData.type and UGCAnnouncementMailType[self.mailData.type])
  if self.mailData.type == nil or not UGCAnnouncementMailType[self.mailData.type] then
    self:HideTranslateComponent()
  else
    self:JudgeTranslate(self.mailData)
  end
  self.translationRating_btn:SetActive(self.mailData.type == MailType.TranslationRating or self.mailData.type == MailType.Automatic_TranslationRating)
  if self.mailData.type == MailType.COLLECT_OVER_FLOW_MAIL then
    self:setMailText(Localization:GetString("312084"))
  elseif self.mailData.type == MailType.MAIL_ALLIANCE_MARK_ADD then
    self:ParseAllianceMarkAddContent(self.mailData)
  elseif self.mailData.type == MailType.MARCH_DESTROY_MAIL then
    self:ParseMarchDestroyMail(self.mailData)
  elseif self.mailData.type == MailType.MAIL_PRESIDENT_SEND or self.mailData.type == MailType.MAIL_PRESIDENT_SEND_EIGHT then
    local _strContents = self.mailData:GetMailMessage()
    self.titleTxt:SetText(Localization:GetString("457072") .. _strTitle)
    local abbrStr = string.match(self.mailData.fromName, "^%b()")
    local showName, isRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.mailData.fromUser, self.mailData.fromName)
    if isRemark and abbrStr then
      showName = abbrStr .. showName
    end
    self:setMailText(_strContents)
    self.messageSignatureTxt:SetText(Localization:GetString("457073", showName))
  elseif self.mailData.type == MailType.LW_ALLIANCE_GROUP_MAIL then
    local _strContents = self.mailData:GetMailMessage()
    local senderName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.mailData.fromUser, self.mailData.fromName)
    local senderNameStr = ""
    if not string.IsNullOrEmpty(senderName) then
      senderNameStr = Localization:GetString("455148", senderName)
    end
    self:setMailText(_strContents)
    self.messageSignatureTxt:SetText(senderNameStr)
  elseif self.mailData.type == MailType.S0_ALLIANCE_BOSS_PERSONAL then
    local contentData = rapidjson.decode(self.mailData.contents)
    local dialog = contentData.b.content.dialog
    local id = dialog.id
    local params = dialog.params
    local newParams = {}
    for i, v in ipairs(params) do
      if i == 2 then
        local dmgStr = string.GetFormattedStr2(tonumber(v.text))
        newParams[i] = dmgStr
      else
        newParams[i] = v.text
      end
    end
    local _strContents = Localization:GetString(id, SafeUnpack(newParams))
    self:setMailText(_strContents)
  else
    local _strContents = self.mailData:GetMailMessage()
    self:setMailText(_strContents)
  end
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  if DataCenter.MailDataManager:IsHaveLikeData(self.mailData) then
    self.detail_time_bg:SetActive(false)
    self.detail_time_and_like_bg:SetActive(true)
    self.time2Txt:SetText(_strTime)
    if self.mailData.type and UGCAnnouncementMailType[self.mailData.type] then
      self.dislikeBtn:SetActive(false)
      self.likeImg:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png")
    else
      self.dislikeBtn:SetActive(true)
      self.likeImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png")
    end
    self:RefreshLikeDataView()
  else
    self.detail_time_bg:SetActive(true)
    self.detail_time_and_like_bg:SetActive(false)
    self.timeTxt:SetText(_strTime)
  end
  self.rewardContent:SetActive(true)
  self:ShowReward(self.mailData)
  self:TrySendMailDataReq()
  self:RefreshRankContent(self.rankShowData)
  self.reportBtn:SetActive(self.mailData.type and UGCAnnouncementMailType[self.mailData.type])
end

function UILWMailDetailCommon:ParseMarchDestroyMail(maildata)
  local extData = maildata:GetMailExt()
  local innerData = extData._destroyReport
  local name
  local targetName = extData:GetTargetName()
  local ownerName = extData:GetOwnerName()
  local dmg = LuaEntry.DataConfig:TryGetNum("hero_attack_city_duration_damage", "k1")
  if innerData.type == DestroyBuildType.Self then
    name = Localization:GetString("393053", ownerName, targetName, dmg)
  elseif innerData.type == DestroyBuildType.Other then
    name = Localization:GetString("393054", targetName, ownerName, dmg)
  end
  self:setMailText(name)
end

function UILWMailDetailCommon:JudgeTranslate()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local result = self.view.ctrl:JudgeMailTranslate()
  local resultEnum = self.view.ctrl.MailTranslateOpEnum
  self.traDivImg:SetActive(result == resultEnum.Doing or result == resultEnum.Finish)
  self.traBtn:SetActive(result == resultEnum.Can)
  self.traBtn2:SetActive(result == resultEnum.Can)
  self:SetTranslatMsgActive(result == resultEnum.Doing or result == resultEnum.Finish)
  self.traDoingText:SetActive(result == resultEnum.Doing)
  self.traFinishImg:SetActive(result == resultEnum.Doing or result == resultEnum.Finish)
  self.traFinishImg2:SetActive(result == resultEnum.Doing or result == resultEnum.Finish)
  if result == resultEnum.Can then
    self.traBtn2:SetOnClick(function()
      self:TryDoTranslate()
    end)
    self.traBtn:SetOnClick(function()
      self:TryDoTranslate()
    end)
  end
  if result == resultEnum.Finish then
    self:SetTranslatMsg(self.mailData.translateMsg)
  end
end

function UILWMailDetailCommon:TryDoTranslate()
  if not self.mailData:IsTranslating() then
    self.traDoingText:SetActive(true)
    self.traFinishImg:SetActive(true)
    self.view.ctrl:DoTranslate(self.mailData)
  end
end

function UILWMailDetailCommon:HideTranslateComponent()
  self.traDivImg:SetActive(false)
  self.traBtn:SetActive(false)
  self.traBtn2:SetActive(false)
  self:SetTranslatMsgActive(false)
  self.traDoingText:SetActive(false)
  self.traFinishImg:SetActive(false)
  self.traFinishImg2:SetActive(false)
end

function UILWMailDetailCommon:SetTranslatMsg(traMsg)
  self.traMsgText:SetText(traMsg)
  self.traMsgRichText:SetText(traMsg)
end

function UILWMailDetailCommon:SetTranslatMsgActive(state)
  local mailType = self.mailData.type
  local isPlayerMail = mailType and UGCAnnouncementMailType[mailType]
  self.traMsgText:SetActive(isPlayerMail and state)
  self.traMsgRichText:SetActive(not isPlayerMail and state)
end

function UILWMailDetailCommon:OnTranslateFinish()
  local translateMsg = self.mailData.translateMsg
  if not string.IsNullOrEmpty(translateMsg) then
    self.traDoingText:SetActive(false)
    self:SetTranslatMsgActive(true)
    self:SetTranslatMsg(translateMsg)
    self.traFinishImg:SetActive(true)
    self.traFinishImg2:SetActive(true)
    self.traBtn:SetActive(false)
    self.traBtn2:SetActive(false)
    self.traDivImg:SetActive(true)
  end
end

function UILWMailDetailCommon:ParseAllianceMarkAddContent(maildata)
  local contentData = rapidjson.decode(maildata.contents)
  local data = contentData.obj
  local dialog_id = "390815"
  local markInfo = {}
  local pointId = SceneUtils.BigIndexToStandardIndex(data.pointId, ForceChangeScene.World)
  if contentData.b ~= nil and contentData.b.content ~= nil and contentData.b.content.dialog ~= nil and contentData.b.content.dialog.id ~= nil then
    dialog_id = contentData.b.content.dialog.id
  end
  markInfo.server = data.server
  markInfo.pointId = pointId
  markInfo.markName = data.markName
  markInfo.markType = data.markType
  markInfo.name = data.name
  markInfo.rank = data.rank
  local param1 = markInfo.rank == 5 and Localization:GetString("390006") .. ": " or ""
  local param2 = markInfo.name
  local param3 = DataCenter.WorldFavoDataManager:GetBookMarkName(markInfo.markType, true)
  local param4 = ""
  if param3 ~= markInfo.markName then
    local tempMarkName = string.split(markInfo.markName, ";")
    if #tempMarkName == 1 then
      param4 = ": " .. markInfo.markName
    else
      param4 = ": " .. Localization:GetString(tempMarkName[2])
    end
  end
  local link = {
    action = "Jump",
    pointId = pointId,
    server = data.server,
    worldId = data.worldId
  }
  local json = rapidjson.encode(link)
  local linkId = base64.encode(json)
  local maskPosition = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local strMaskPosition = "<link='" .. linkId .. "'><u>(X:" .. math.tointeger(maskPosition.x) .. ", " .. "Y:" .. math.tointeger(maskPosition.y) .. ")</u></link>"
  local txt = Localization:GetString(dialog_id, param1, param2, param3, param4, strMaskPosition)
  self:setMailText(txt)
end

function UILWMailDetailCommon:RemoveReward()
  self.rewardContent:RemoveComponents(MailRewardCommonItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailCommon:ShowReward(maildata)
  self:RemoveReward()
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

function UILWMailDetailCommon:ShowRewardItem(rewardData)
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

function UILWMailDetailCommon:RewardSuccess()
  if not self.mailData then
    return
  end
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
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
    end
  end
  self:RefreshContent()
end

function UILWMailDetailCommon:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  txt = ChatInterface.CheckMessage(txt)
  self.messageTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self.messageRichTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  local mailType = self.mailData.type
  local isPlayerMail = mailType and UGCAnnouncementMailType[mailType]
  if isPlayerMail then
    self.messageTxt:SetText_NotNative(txt)
    self.messageTxt:SetActive(true)
    self.messageRichTxt:SetActive(false)
  else
    if self.mailData.type == MailType.LW_SURVEY_MONKEY_MAIL then
      txt = CommonUtil.ParseQuestionnaireURL(txt)
    end
    self.messageRichTxt:SetText_NotNative(txt)
    self.messageTxt:SetActive(false)
    self.messageRichTxt:SetActive(true)
  end
end

function UILWMailDetailCommon:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  UIUtil.MailDetailLinkClick(linkId, self.messageRichTxt, clickPos)
end

function UILWMailDetailCommon:RefreshLikeDataView(mailId, type)
  local refreshMailId = mailId
  local refreshType = type
  local curMailId = self.mailData.uid
  if refreshMailId ~= nil and refreshMailId ~= curMailId then
    return
  end
  local mailLikeData = DataCenter.MailDataManager:GetMailLikeData(curMailId)
  local likeNum = 0
  local dislikeNum = 0
  local selectType = 0
  if mailLikeData ~= nil then
    likeNum = mailLikeData.likeNum
    dislikeNum = mailLikeData.dislikeNum
    selectType = mailLikeData.selectType
  end
  local selectColor = Color32.New(0.39215686274509803, 0.7843137254901961, 0.39215686274509803, 1)
  local unselectColor = Color32.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1)
  self.likeNum:SetColor(selectType == likeType and selectColor or unselectColor)
  self.dislikeNum:SetColor(selectType == dislikeType and selectColor or unselectColor)
  self.likeNum:SetText(string.format("(%d)", likeNum))
  self.dislikeNum:SetText(string.format("(%d)", dislikeNum))
  local curMailType = self.mailData.type
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if (mailLikeData == nil or curTime > mailLikeData.expireTime) and refreshMailId == nil and not string.IsNullOrEmpty(curMailId) then
    if curMailType == MailType.MAIL_PRESIDENT_SEND or curMailType == MailType.MAIL_PRESIDENT_SEND_EIGHT then
      SFSNetwork.SendMessage(MsgDefines.MailThumbsUpInfo, curMailId)
    elseif curMailType == MailType.LW_ALLIANCE_GROUP_MAIL then
      SFSNetwork.SendMessage(MsgDefines.MailThumbsUpInfo, curMailId)
    else
      SFSNetwork.SendMessage(MsgDefines.MailExtInfo, curMailId)
    end
  end
  if type ~= nil then
    if type == 1 then
      self:ShowFloatLike(type, self.likeBtn, 100)
    elseif type == 2 then
    end
  end
end

function UILWMailDetailCommon:OnGetMailLikeDataMsg(mailId)
  self:RefreshLikeDataView(mailId)
end

function UILWMailDetailCommon:OnRefreshMailLikeDataMsg(msg)
  self:RefreshLikeDataView(msg.uid or msg.mailUuid, msg.type or msg.selectType or msg.like)
end

function UILWMailDetailCommon:OnLikeBtnClick()
  local curMailId = self.mailData.uid
  local senderUid = self.mailData.fromUser
  local curMailType = self.mailData.type
  local mailLikeData = DataCenter.MailDataManager:GetMailLikeData(curMailId)
  if mailLikeData ~= nil then
    if curMailType == MailType.MAIL_PRESIDENT_SEND or curMailType == MailType.MAIL_PRESIDENT_SEND_EIGHT then
      if mailLikeData.selectType == likeType then
        return
      end
      if senderUid == LuaEntry.Player.uid then
        UIUtil.ShowTipsId("avatar_tips001")
        return
      end
      InteractiveUtil.TryThumbsUp(senderUid, InteractiveUtil.ThumbsUpType.KingMail, curMailId, function()
        SFSNetwork.SendMessage(MsgDefines.MailThumbsUp, curMailId, likeType)
      end)
    elseif curMailType == MailType.LW_ALLIANCE_GROUP_MAIL then
      if mailLikeData.selectType == likeType then
        return
      end
      if senderUid == LuaEntry.Player.uid then
        UIUtil.ShowTipsId("avatar_tips001")
        return
      end
      InteractiveUtil.TryThumbsUp(senderUid, InteractiveUtil.ThumbsUpType.AllianceMail, curMailId, function()
        SFSNetwork.SendMessage(MsgDefines.MailThumbsUp, curMailId, likeType)
      end)
      AlPostEventLog.PostEventLog_Mail_Action(AlPostEventLog.MailAction.Like)
    elseif mailLikeData.selectType ~= likeType then
      SFSNetwork.SendMessage(MsgDefines.MailPraiseOp, curMailId, likeType)
    end
  end
end

function UILWMailDetailCommon:OnDisLikeBtnClick()
  local curMailId = self.mailData.uid
  local mailLikeData = DataCenter.MailDataManager:GetMailLikeData(curMailId)
  if mailLikeData ~= nil and mailLikeData.selectType ~= dislikeType then
    SFSNetwork.SendMessage(MsgDefines.MailPraiseOp, curMailId, dislikeType)
  end
end

function UILWMailDetailCommon:ShowFloatLike(type, target, startY)
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.floatLike.gameObject, self.floatLike.transform.parent)
  floatInst:SetActive(true)
  floatInst.transform:SetParent(self.likeContent.transform)
  table.insert(self.floatInsts, floatInst)
  local targetPos = target:GetAnchoredPosition()
  floatInst.transform.anchoredPosition = Vector2.New(targetPos.x, targetPos.y + startY - 100)
  floatInst.transform:DOAnchorPosY(targetPos.y + startY - 0, 2)
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

function UILWMailDetailCommon:TrySendMailDataReq()
  if self.mailData == nil then
    return
  end
  local contentData = rapidjson.decode(self.mailData.contents)
  self.mailRankDataUid = nil
  self.rankShowData = nil
  self.address = ""
  if contentData.obj and not string.IsNullOrEmpty(contentData.obj.rank_oss_uuid) then
    self.mailRankDataUid = contentData.obj.rank_oss_uuid
    self.mailRankDataObj = contentData.obj
    if BattleReportUtil.IsAddressMode(contentData.obj.rank_oss_address) then
      self.address = contentData.obj.rank_oss_address
    end
  end
  if self.mailRankDataUid then
    DataCenter.MailRankDataManager:TryGetMailRankData(self.mailRankDataUid, self.oss_crc, self.oss_size, self.address)
  end
end

function UILWMailDetailCommon:RefreshRankContent(data)
  if data == nil then
    self:RemoveRanks()
    return
  end
  if data.uuid == nil or data.uuid ~= self.mailRankDataUid then
    return
  end
  self.rankShowData = data
  local jsonDataStr = data.data.jsonData
  local jsonData = rapidjson.decode(jsonDataStr)
  local rankListData = jsonData.rankData
  local rankList = {}
  local maxScore = -1
  local rankType = self.mailRankDataObj.rank_oss_type or MailRankType.Player
  local activityId = tonumber(self.mailRankDataObj.activityId) or 0
  for k, v in pairs(rankListData) do
    local rankData = {
      rankType = rankType,
      score = tonumber(v.score),
      rank = v.rank,
      activityId = activityId
    }
    if rankType == MailRankType.Player then
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      rankData.playerData = playerData
    elseif rankType == MailRankType.Alliance then
      rankData.rankData = v
    end
    if self.mailData.type == MailType.MAIL_ALCOMPETE_WEEK_REPORT then
      rankData.iconName = "lrb_LMDJ_gerenjifen_daoju.png"
    end
    table.insert(rankList, rankData)
    if maxScore < rankData.score then
      maxScore = rankData.score
    end
  end
  self.rankList = rankList
  self.maxScore = maxScore
  self:RemoveRanks()
  if rankList and 1 <= #rankList then
    self.rankViewContent:SetActive(true)
    self.loopListView:SetListItemCount(#rankList, false, false)
    self.loopListView:RefreshAllShownItem()
    local rankRageMin = 1
    local rankRageMax = 1
    local rankRageList = {}
    local rank_range = self.mailRankDataObj.rank_range
    if not string.IsNullOrEmpty(rank_range) then
      rankRageList = string.split(rank_range, "-")
    end
    if rankRageList and #rankRageList == 2 then
      rankRageMin = tonumber(rankRageList[1])
      rankRageMax = tonumber(rankRageList[2])
    end
    self.rank_range_txt:SetLocalText("mail_rank_desc1", rankRageMin, rankRageMax)
    local end_time = self.mailRankDataObj.end_time
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(end_time * 1000)
    self.rank_fin_time_txt:SetLocalText("mail_rank_desc2", endTimeStr)
    local selfData = {
      rankType = rankType,
      score = math.floor(self.mailRankDataObj.owner_score),
      rank = self.mailRankDataObj.owner_rank,
      activityId = activityId
    }
    if rankType == MailRankType.Player then
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(LuaEntry.Player)
      selfData.playerData = playerData
    elseif rankType == MailRankType.Alliance then
      selfData.rankData = self.mailRankDataObj.alliance
    end
    if self.mailData.type == MailType.MAIL_ALCOMPETE_WEEK_REPORT then
      selfData.iconName = "lrb_LMDJ_gerenjifen_daoju.png"
    end
    self.rank_my_item:SetData(selfData, self.maxScore, true)
  else
  end
end

function UILWMailDetailCommon:RemoveRanks()
  self.rankViewContent:SetActive(false)
  self.items = {}
  self.content:RemoveComponents(MailRankItem)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailCommon:GetScrollItem(listview, index)
  local rankList = self.rankList
  if rankList == nil or #rankList < 1 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #rankList then
    return nil
  end
  local csItem = listview:NewListViewItem("MailRankItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "MailRankItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(MailRankItem, nameStr)
  end
  self.items[csItem]:SetData(rankList[index], self.maxScore)
  return csItem
end

function UILWMailDetailCommon:OnReportBtnClick()
  local groupMailId = ""
  local custom = self.mailData:GetMailCustom()
  if custom and custom.c and custom.c.groupId then
    groupMailId = custom.c.groupId or ""
  end
  if self.mailData.type == MailType.LW_ALLIANCE_GROUP_MAIL then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.mailR4,
      groupMailId = groupMailId,
      uid = self.mailData.fromUser
    })
  elseif self.mailData.type == MailType.MAIL_PRESIDENT_SEND or self.mailData.type == MailType.MAIL_PRESIDENT_SEND_EIGHT then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.mailPresident,
      groupMailId = groupMailId,
      uid = self.mailData.fromUser
    })
  end
end

return UILWMailDetailCommon
