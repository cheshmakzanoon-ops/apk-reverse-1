local UILWMailDetailDesertBattleSignUp = BaseClass("UILWMailDetailDesertBattleSignUp", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local RewardUtil = require("Util.RewardUtil")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function UILWMailDetailDesertBattleSignUp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDesertBattleSignUp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDesertBattleSignUp:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(reward_hero_item_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
end

function UILWMailDetailDesertBattleSignUp:ComponentDestroy()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
end

function UILWMailDetailDesertBattleSignUp:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailDesertBattleSignUp:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailDesertBattleSignUp:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDesertBattleSignUp:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDesertBattleSignUp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailDesertBattleSignUp:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailDesertBattleSignUp:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.subTitleTxt:SetText(_strSubTitle)
  if self.mailData.type == MailType.COLLECT_OVER_FLOW_MAIL then
    self:setMailText(Localization:GetString("312084"))
  elseif self.mailData.type == MailType.MAIL_ALLIANCE_MARK_ADD then
    self:ParseAllianceMarkAddContent(self.mailData)
  elseif self.mailData.type == MailType.MARCH_DESTROY_MAIL then
    self:ParseMarchDestroyMail(self.mailData)
  elseif self.mailData.type == MailType.MAIL_PRESIDENT_SEND or self.mailData.type == MailType.MAIL_PRESIDENT_SEND_EIGHT then
    local _strContents = self.mailData:GetMailMessage()
    _strTitle = MailShowHelper.GetMainTitle(self.mailData)
    self.titleTxt:SetText(Localization:GetString("457072") .. _strTitle)
    self:setMailText(_strContents .. Localization:GetString("457073", self.mailData.fromName))
  else
    local _strContents = self.mailData:GetMailMessage()
    self:setMailText(_strContents)
  end
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self.rewardContent:SetActive(true)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  self:ShowReward(self.mailData)
end

function UILWMailDetailDesertBattleSignUp:ParseMarchDestroyMail(maildata)
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

function UILWMailDetailDesertBattleSignUp:ParseAllianceMarkAddContent(maildata)
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
    server = data.server
  }
  local json = rapidjson.encode(link)
  local linkId = base64.encode(json)
  local maskPosition = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local strMaskPosition = "<link='" .. linkId .. "'><u>(X:" .. math.tointeger(maskPosition.x) .. ", " .. "Y:" .. math.tointeger(maskPosition.y) .. ")</u></link>"
  local txt = Localization:GetString(dialog_id, param1, param2, param3, param4, strMaskPosition)
  self:setMailText(txt)
end

function UILWMailDetailDesertBattleSignUp:ShowReward(maildata)
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

function UILWMailDetailDesertBattleSignUp:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardheroitem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

function UILWMailDetailDesertBattleSignUp:RewardSuccess()
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
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
    end
  end
end

function UILWMailDetailDesertBattleSignUp:setMailText(txt)
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

function UILWMailDetailDesertBattleSignUp:OnPointerClick(clickPos)
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

return UILWMailDetailDesertBattleSignUp
