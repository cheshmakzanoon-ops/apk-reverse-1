local base = UIBaseContainer
local UILWMailDetailBankReport = BaseClass("UILWMailDetailBankReport", base)
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local Localization = CS.GameEntry.Localization
local detailTitle_path = "Content/DetailTitle"
local detailMessage_path = "Content/DetailScroll/DetailViewport/DetailContent/DetailMessage"
local detailRewardContent_path = "Content/DetailScroll/DetailViewport/DetailContent/DetailRewardContent"
local mailRewardItem_path = "Content/DetailScroll/DetailViewport/DetailContent/MailRewardItem"
local heroRewardItem_path = "Content/DetailScroll/DetailViewport/DetailContent/HeroRewardItem"
local detailTimeText_path = "Content/DetailTimeBg/DetailTimeText"
local detailContent_path = "Content/DetailScroll/DetailViewport/DetailContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveRewards()
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
  self.detailTitle = self:AddComponent(UIText, detailTitle_path)
  self.detailMessage = self:AddComponent(UIText, detailMessage_path)
  self.detailRewardContent = self:AddComponent(UIBaseContainer, detailRewardContent_path)
  self.mailRewardItem = self:AddComponent(UIBaseContainer, mailRewardItem_path)
  self.heroRewardItem = self:AddComponent(UIBaseContainer, heroRewardItem_path)
  self.detailTimeText = self:AddComponent(UIText, detailTimeText_path)
  self.detailContent = self:AddComponent(UIBaseContainer, detailContent_path)
  self.rewardObj = self.transform:Find(mailRewardItem_path).gameObject
  self.rewardObj:GameObjectCreatePool()
  self.rewardHeroObj = self.transform:Find(heroRewardItem_path).gameObject
  self.rewardHeroObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.detailTitle = nil
  self.detailMessage = nil
  self.detailRewardContent = nil
  self.mailRewardItem = nil
  self.heroRewardItem = nil
  self.detailTimeText = nil
  self.detailContent = nil
end

local function DataDefine(self)
  self.rewardIndex = 0
  self.rankIndex = 0
end

local function DataDestroy(self)
  self.rewardIndex = nil
  self.rankIndex = nil
end

function UILWMailDetailBankReport:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailBankReport:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailBankReport:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detailTimeText:SetText(strTime)
  local strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.detailTitle:SetText(strTitle)
  local strContents = self.mailData:GetMailMessage()
  self.detailMessage:SetText(strContents)
  local rewardCount = self:ShowRewards(self.mailData)
  self.detailRewardContent:SetActive(0 < rewardCount)
  self:RefreshBanKReport()
end

function UILWMailDetailBankReport:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.detailRewardContent.transform:GetChild(0).gameObject.transform.position, Vector3.New(0, 0, 0), 100, 100)
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
      local child = self.detailRewardContent.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
      if img then
        local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
        local flyPos = Vector3.New(0, 0, 0)
        UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
      end
    end
  end
end

function UILWMailDetailBankReport:RefreshBanKReport()
  local ext = self.mailData:GetMailExt()
  local extData = ext and ext:GetExtData()
  if table.IsNullOrEmpty(extData) or not extData.depositAmount then
    if self.bankReportReq then
      self.bankReportReq:Destroy()
      self.bankReportReq = nil
    end
    return
  end
  if self.reportContent then
    self.reportContent:ReInit(extData, self.mailData)
    return
  end
  if not self.bankReportReq then
    self.bankReportReq = self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankReportContent.prefab", function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local trans = obj.transform
      trans:SetParent(self.detailContent.transform)
      trans.localScale = Vector3.one
      trans.localPosition = Vector3.zero
      obj.name = "reportCell"
      local script = require("UI.LWSeason5.LWBank.Group.BankReportContent")
      local reportCell = self.detailContent:AddComponent(script, obj.name)
      self.reportContent = reportCell
      ext = self.mailData:GetMailExt()
      extData = ext and ext:GetExtData()
      self.reportContent:ReInit(extData, self.mailData)
      self.reportContent.transform:SetAsFirstSibling()
      self.detailMessage.transform:SetAsFirstSibling()
    end)
  end
end

function UILWMailDetailBankReport:RemoveRewards()
  self.detailRewardContent:RemoveComponents(UICommonResItem)
  self.detailRewardContent:RemoveComponents(HeroRewardItem)
  self.rewardObj.gameObject:GameObjectRecycleAll()
  self.rewardHeroObj.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailBankReport:ShowRewards(mailData)
  self:RemoveRewards()
  local pay = mailData:GetMailPay()
  local reward = mailData:GetMailReward()
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
    for _, itemInfo in pairs(tabReward) do
      if itemInfo.type == RewardType.GOODS then
        local itemId = itemInfo.id
        local itemCnt = itemInfo.num
        local param = {
          rewardType = RewardType.GOODS,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      else
        local itemId = itemInfo.id
        local itemCnt = itemInfo.num
        local param = {
          rewardType = itemInfo.type,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  if mailData.type == MailType.COLLECT_OVER_FLOW_MAIL then
    local data = mailData:GetMailSFSObj()
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

function UILWMailDetailBankReport:ShowRewardItem(rewardData)
  self.rewardIndex = self.rewardIndex + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. self.rewardIndex
    local item = self.rewardHeroObj:GameObjectSpawn(self.detailRewardContent.transform)
    item.name = objName
    local obj = self.detailRewardContent:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. self.rewardIndex
    local item = self.rewardObj:GameObjectSpawn(self.detailRewardContent.transform)
    item.name = objName
    local obj = self.detailRewardContent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

UILWMailDetailBankReport.OnCreate = OnCreate
UILWMailDetailBankReport.OnDestroy = OnDestroy
UILWMailDetailBankReport.OnEnable = OnEnable
UILWMailDetailBankReport.OnDisable = OnDisable
UILWMailDetailBankReport.ComponentDefine = ComponentDefine
UILWMailDetailBankReport.ComponentDestroy = ComponentDestroy
UILWMailDetailBankReport.DataDefine = DataDefine
UILWMailDetailBankReport.DataDestroy = DataDestroy
return UILWMailDetailBankReport
