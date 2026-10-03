local UILWMailListItemCharge = BaseClass("UILWMailListItemCharge", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local RewardUtil = require("Util.RewardUtil")
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local sub_title_txt_path = "System/DSubTitle"
local message_txt_path = "System/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local item_bg_path = "System/itemBg"
local d_scroll_path = "System/DScroll"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local itemWidth = 800
local itemHeight = 710
local itemHeightNoReward = 410

function UILWMailListItemCharge:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItemCharge:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItemCharge:ComponentDefine()
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(reward_hero_item_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.d_scroll = self:AddComponent(UIScrollRect, d_scroll_path)
  self.root = self:AddComponent(UIBaseContainer, "")
end

function UILWMailListItemCharge:ComponentDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  for _, v in ipairs(self.rewardContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.item_bg = nil
  self.d_scroll = nil
  self.root = nil
end

function UILWMailListItemCharge:DataDefine()
  self.mailData = {}
end

function UILWMailListItemCharge:DataDestroy()
  self.mailData = nil
end

function UILWMailListItemCharge:SetData(params)
  self.mailData = params.mail_data
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  _strSubTitle = MailShowHelper.GetTextWithHighlight(_strSubTitle, params.filter or "")
  self.subTitleTxt:SetText(_strSubTitle)
  local _strContents = self.mailData:GetMailMessage()
  _strContents = MailShowHelper.GetTextWithHighlight(_strContents, params.filter or "")
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  self.rewardContent:SetActive(true)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  for _, v in ipairs(self.rewardContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  local rewardNum = self:ShowReward(self.mailData)
  if rewardNum <= 0 then
    self.item_bg:SetActive(false)
    self.d_scroll:SetActive(false)
    self.root:SetSizeDeltaXY(itemWidth, itemHeightNoReward)
  else
    self.item_bg:SetActive(true)
    self.d_scroll:SetActive(true)
    self.root:SetSizeDeltaXY(itemWidth, itemHeight)
  end
end

function UILWMailListItemCharge:ShowReward(maildata)
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

function UILWMailListItemCharge:ShowRewardItem(rewardData)
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
    param.iconScale = 1.07
    param.heroIconYPos = 5
    if toInt(param.heroId) == DataCenter.FirstPayManager.HeroId then
      param.showLv = 5
    end
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

function UILWMailListItemCharge:setMailText(txt)
  self.messageTxt:SetText(txt)
  self.messageTxt:SetActive(true)
end

return UILWMailListItemCharge
