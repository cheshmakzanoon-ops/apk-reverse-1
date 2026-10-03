local MailDetailAllianceCityOccupyReward = BaseClass("MailDetailAllianceCityOccupyReward", UIBaseContainer)
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
local reward_title_1_content_path = "System/DScroll/DViewport/DContent/RewardTitle1"
local reward_title_2_content_path = "System/DScroll/DViewport/DContent/RewardTitle2"
local reward_1_content_path = "System/DScroll/DViewport/DContent/DReward1"
local reward_2_content_path = "System/DScroll/DViewport/DContent/DReward2"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function MailDetailAllianceCityOccupyReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDetailAllianceCityOccupyReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailAllianceCityOccupyReward:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardTitle1 = self:AddComponent(UIText, reward_title_1_content_path)
  self.rewardTitle2 = self:AddComponent(UIText, reward_title_2_content_path)
  self.rewardTitle1:SetText("rewardTitle1Text")
  self.rewardTitle2:SetText("rewardTitle2Text")
  self.reward1Content = self:AddComponent(UIBaseContainer, reward_1_content_path)
  self.reward2Content = self:AddComponent(UIBaseContainer, reward_2_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(reward_hero_item_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
end

function MailDetailAllianceCityOccupyReward:ComponentDestroy()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.reward1Content = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
end

function MailDetailAllianceCityOccupyReward:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function MailDetailAllianceCityOccupyReward:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function MailDetailAllianceCityOccupyReward:OnEnable()
  base.OnEnable(self)
end

function MailDetailAllianceCityOccupyReward:OnDisable()
  base.OnDisable(self)
end

function MailDetailAllianceCityOccupyReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function MailDetailAllianceCityOccupyReward:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function MailDetailAllianceCityOccupyReward:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self.reward1Content:SetActive(true)
  self.reward1Content:RemoveComponents(HeroRewardItem)
  self.reward2Content:RemoveComponents(HeroRewardItem)
  self.reward1Content:RemoveComponents(MailRewardItem)
  self.reward2Content:RemoveComponents(MailRewardItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local sfs = self.mailData:GetMailSFSObj()
  if sfs then
    self:ShowRewardNew(self.mailData)
  elseif self:ShowReward(self.mailData) == 0 then
    self.rewardTitle1:SetActive(false)
    self.reward1Content:SetActive(false)
  else
    self.rewardTitle1:SetActive(true)
    self.reward1Content:SetActive(true)
  end
end

function MailDetailAllianceCityOccupyReward:ParseMarchDestroyMail(maildata)
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

function MailDetailAllianceCityOccupyReward:ShowReward(maildata)
  self.rewardTitle2:SetActive(false)
  self.reward2Content:SetActive(false)
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
      }, self.reward1Content)
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
        self:ShowRewardItem(param, self.reward1Content)
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = iteminfo.type,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param, self.reward1Content)
      end
    end
  end
  return totalCnt
end

function MailDetailAllianceCityOccupyReward:ShowRewardItem(rewardData, content)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardheroitem:GameObjectSpawn(content.transform)
    item.name = objName
    local obj = content:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(content.transform)
    item.name = objName
    local obj = content:AddComponent(MailRewardItem, item.name)
    obj:RefreshData(rewardData)
    obj.name_text:SetActive(false)
  end
end

function MailDetailAllianceCityOccupyReward:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.reward1Content.transform:GetChild(0).gameObject.transform.position, Vector3.New(0, 0, 0), 100, 100)
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
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, self.reward1Content.transform.position, flyPos, 100, 100)
    end
  end
end

function MailDetailAllianceCityOccupyReward:setMailText(txt)
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

function MailDetailAllianceCityOccupyReward:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  GoToUtil.TryJumpToWorld(linkMsg)
end

function MailDetailAllianceCityOccupyReward:ShowRewardNew(mailData)
  self.rewardTitle2:SetActive(true)
  self.reward2Content:SetActive(true)
  local sfs = mailData:GetMailSFSObj()
  local joinReward = sfs.joinReward
  local allianceReward = sfs.allianceReward
  local hasJoinReward = sfs.hasJoinReward
  if hasJoinReward == 1 then
    self.rewardTitle1:SetLocalText(310189)
    self.rewardTitle2:SetLocalText(310190)
  else
    self.rewardTitle1:SetLocalText(310187)
    self.rewardTitle2:SetLocalText(310188)
  end
  if joinReward then
    self.rewardTitle1:SetActive(true)
    self.reward1Content:SetActive(true)
    self:ParseReward(joinReward.rewardInfo, self.reward1Content)
  else
    self.rewardTitle1:SetActive(false)
    self.reward1Content:SetActive(false)
  end
  if allianceReward then
    self:ParseReward(allianceReward.rewardInfo, self.reward2Content)
  else
    self.rewardTitle2:SetActive(false)
    self.reward2Content:SetActive(false)
  end
end

function MailDetailAllianceCityOccupyReward:ParseReward(rewards, content)
  for _, iteminfo in pairs(rewards) do
    if iteminfo.type == RewardType.GOODS then
      local itemId = iteminfo.id
      local itemCnt = iteminfo.num
      local param = {
        rewardType = RewardType.GOODS,
        itemId = itemId,
        count = itemCnt
      }
      self:ShowRewardItem(param, content)
    else
      local itemId = iteminfo.id
      local itemCnt = iteminfo.num
      local param = {
        rewardType = iteminfo.type,
        itemId = itemId,
        count = itemCnt
      }
      self:ShowRewardItem(param, content)
    end
  end
end

return MailDetailAllianceCityOccupyReward
