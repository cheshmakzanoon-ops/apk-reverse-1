local base = UIBaseContainer
local UILWMailResConversion = BaseClass("UILWMailResConversion", base)
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailInfo = require("DataCenter.MailData.MailInfo")
local detailIcon_path = "System/DetailIcon"
local title_path = "System/DetailTitle"
local subTitle_path = "System/DScroll/DViewport/DContent/DSubTitle"
local content_path = "System/DScroll/DViewport/DContent/DMessage"
local originalTitle_path = "System/DScroll/DViewport/DContent/OriginalTitle"
local originalReward_path = "System/DScroll/DViewport/DContent/OriginalReward"
local targetTitle_path = "System/DScroll/DViewport/DContent/TargetTitle"
local targetReward_path = "System/DScroll/DViewport/DContent/TargetReward"
local detailTime_path = "System/DetailTimeBg/DetailTime"
local rewardItemPrefab_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local heroRewardItemPrefab_path = "System/DScroll/DViewport/DContent/HeroRewardItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.detailIcon = self:AddComponent(UIImage, detailIcon_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.subTitle = self:AddComponent(UITextMeshProUGUIEx, subTitle_path)
  self.content = self:AddComponent(UITextMeshProUGUIEx, content_path)
  self.originalTitle = self:AddComponent(UITextMeshProUGUIEx, originalTitle_path)
  self.originalReward = self:AddComponent(UIBaseContainer, originalReward_path)
  self.targetTitle = self:AddComponent(UITextMeshProUGUIEx, targetTitle_path)
  self.targetReward = self:AddComponent(UIBaseContainer, targetReward_path)
  self.detailTime = self:AddComponent(UITextMeshProUGUIEx, detailTime_path)
  self.rewardItemPrefab = self:AddComponent(UIBaseContainer, rewardItemPrefab_path)
  self.heroRewardItemPrefab = self:AddComponent(UIBaseContainer, heroRewardItemPrefab_path)
  self.rewarditem = self.rewardItemPrefab.gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.heroRewardItemPrefab.gameObject
  self.rewardheroitem:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:RemoveReward()
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.detailIcon = nil
  self.title = nil
  self.subTitle = nil
  self.content = nil
  self.originalTitle = nil
  self.originalReward = nil
  self.targetTitle = nil
  self.targetReward = nil
  self.detailTime = nil
  self.rewardItemPrefab = nil
  self.heroRewardItemPrefab = nil
end

local function DataDefine(self)
  self.mailUid = {}
  self.mailData = {}
  self.nameCount = 0
end

local function DataDestroy(self)
  self.mailUid = nil
  self.mailData = nil
  self.nameCount = nil
end

local function RefreshContent(self)
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.title:SetActive(true)
  self.title:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  if string.IsNullOrEmpty(_strSubTitle) then
    self.subTitle:SetActive(false)
  else
    self.subTitle:SetActive(true)
    self.subTitle:SetText(_strSubTitle)
  end
  local _strContents = self.mailData:GetMailMessage()
  local senderName = self.mailData.fromName
  local senderNameStr = ""
  if not string.IsNullOrEmpty(senderName) then
    senderNameStr = Localization:GetString("455148", senderName)
  end
  local message = _strContents .. senderNameStr
  if string.IsNullOrEmpty(message) then
    self.content:SetActive(false)
  else
    self.content:SetActive(true)
    self.content:SetText(message)
  end
  self:RemoveReward()
  self:ShowReward(self.mailData)
  self:ShowOriginalReward(self.mailData)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detailTime:SetText(_strTime)
end

local function ShowRewardItem(self, rewardData, parent)
  self.nameCount = self.nameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. "_" .. self.nameCount
    local item = self.rewardheroitem:GameObjectSpawn(parent.transform)
    item.name = objName
    local obj = parent:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. "_" .. self.nameCount
    local item = self.rewarditem:GameObjectSpawn(parent.transform)
    item.name = objName
    local obj = parent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

local function ShowReward(self, maildata)
  local pay = maildata:GetMailPay()
  local reward = maildata:GetMailReward()
  local hasReward = false
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      self:ShowRewardItem({
        rewardType = RewardType.GOLD,
        itemId = "gold",
        count = goldCnt
      }, self.targetReward)
      hasReward = true
    end
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    local tabReward = reward.rewardInfo
    for _, iteminfo in pairs(tabReward) do
      local param = MailInfo.GetRewardData(iteminfo)
      self:ShowRewardItem(param, self.targetReward)
    end
    hasReward = true
  end
  self.targetTitle:SetActive(hasReward)
  self.targetReward:SetActive(hasReward)
end

local function ShowOriginalReward(self, maildata)
  local reward = maildata:GetMailSFSObj()
  if reward then
    local showReward = reward.rewardInfo
    if showReward and table.count(showReward) > 0 then
      self.originalTitle:SetActive(true)
      self.originalReward:SetActive(true)
      for _, iteminfo in pairs(showReward) do
        local param = MailInfo.GetRewardData(iteminfo)
        self:ShowRewardItem(param, self.originalReward)
      end
      return
    end
  end
  self.originalTitle:SetActive(false)
  self.originalReward:SetActive(false)
end

local function RemoveReward(self)
  self.targetReward:RemoveComponents(HeroRewardItem)
  self.targetReward:RemoveComponents(UICommonResItem)
  self.originalReward:RemoveComponents(HeroRewardItem)
  self.originalReward:RemoveComponents(UICommonResItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
end

UILWMailResConversion.OnCreate = OnCreate
UILWMailResConversion.OnDestroy = OnDestroy
UILWMailResConversion.OnEnable = OnEnable
UILWMailResConversion.OnDisable = OnDisable
UILWMailResConversion.ComponentDefine = ComponentDefine
UILWMailResConversion.ComponentDestroy = ComponentDestroy
UILWMailResConversion.DataDefine = DataDefine
UILWMailResConversion.DataDestroy = DataDestroy
UILWMailResConversion.RefreshContent = RefreshContent
UILWMailResConversion.ShowRewardItem = ShowRewardItem
UILWMailResConversion.ShowReward = ShowReward
UILWMailResConversion.ShowOriginalReward = ShowOriginalReward
UILWMailResConversion.RemoveReward = RemoveReward
return UILWMailResConversion
