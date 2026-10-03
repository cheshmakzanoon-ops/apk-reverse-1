local MailDetailAllianceCityRank = BaseClass("MailDetailAllianceCityRank", UIBaseContainer)
local AllianceCityRankRewardCell = require("UI.UILWMail.UILWMailMain.Component.AllianceCityRankRewardCell")
local base = UIBaseContainer
local title_txt_path = "System/DetailTitle"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local content_path = "System/DScroll/DViewport/DContent/Reward"
local item_prefab_path = "System/DScroll/DViewport/DContent/RewardDetailItem"
local title1_path = "System/DScroll/DViewport/DContent/Reward/Titles/Title1"
local title2_path = "System/DScroll/DViewport/DContent/Reward/Titles/Title2"
local title3_path = "System/DScroll/DViewport/DContent/Reward/Titles/Title3"
local desc_path = "System/DScroll/DViewport/DContent/DMessage"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function MailDetailAllianceCityRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDetailAllianceCityRank:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MailDetailAllianceCityRank:OnEnable()
  base.OnEnable(self)
end

function MailDetailAllianceCityRank:OnDisable()
  base.OnDisable(self)
end

function MailDetailAllianceCityRank:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.title1Txt = self:AddComponent(UIText, title1_path)
  self.title2Txt = self:AddComponent(UIText, title2_path)
  self.title3Txt = self:AddComponent(UIText, title3_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.itemPrefab = self.transform:Find(item_prefab_path).gameObject
  self.itemPrefab:GameObjectCreatePool()
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.title1Txt:SetLocalText(310183)
  self.title3Txt:SetLocalText(310186)
end

function MailDetailAllianceCityRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function MailDetailAllianceCityRank:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function MailDetailAllianceCityRank:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.content.transform.position, Vector3.New(0, 0, 0), 100, 100)
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
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, self.content.transform.position, flyPos, 100, 100)
    end
  end
end

function MailDetailAllianceCityRank:ComponentDestroy()
  self.titleTxt = nil
  self.timeTxt = nil
end

function MailDetailAllianceCityRank:DataDefine()
end

function MailDetailAllianceCityRank:DataDestroy()
end

function MailDetailAllianceCityRank:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.itemPrefab.gameObject:GameObjectRecycleAll()
  self:ParseAllianceRank(self.mailData)
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
end

function MailDetailAllianceCityRank:ParseAllianceRank(maildata)
  local extData = maildata:GetMailExt()
  local list = extData._worldCityRankMail.rankInfos
  if extData._worldCityRankMail.type == 0 then
    self.title2Txt:SetLocalText(310184)
  else
    self.title2Txt:SetLocalText(310185)
  end
  local extData = maildata:GetMailExt()
  local content = extData:GetDes()
  self.messageRichTxt:SetText(content)
  if list then
    for k, v in pairs(list) do
      local rank = v.rank
      local playerInfo = v.playerInfo
      local rewardList = v.rewardInfo
      if rewardList ~= nil and 0 < table.count(rewardList) then
        self:ShowRewardCell(playerInfo, v.scord, rewardList)
      end
    end
  end
end

function MailDetailAllianceCityRank:ShowRewardCell(playerInfo, dmg, rewardList)
  NameCount = NameCount + 1
  local objName = NameCount
  local item = self.itemPrefab:GameObjectSpawn(self.content.transform)
  item.name = objName
  local obj = self.content:AddComponent(AllianceCityRankRewardCell, item.name)
  obj:RefreshData(playerInfo, dmg, rewardList)
end

function MailDetailAllianceCityRank:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  linkMsg.pointId = SceneUtils.BigIndexToStandardIndex(linkMsg.pointId)
  GoToUtil.TryJumpToWorld(linkMsg)
end

return MailDetailAllianceCityRank
