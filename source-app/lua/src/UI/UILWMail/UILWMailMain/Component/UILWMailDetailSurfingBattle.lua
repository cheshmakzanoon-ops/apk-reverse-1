local base = UIBaseContainer
local UILWMailDetailSurfingBattle = BaseClass("UILWMailDetailSurfingBattle", base)
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local UILWMailDetailSurfingBattleRankItemRender = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailSurfingBattleRankItemRender")
local Localization = CS.GameEntry.Localization
local detailTitle_path = "Content/DetailTitle"
local detailMessage_path = "Content/DetailScroll/DetailViewport/DetailContent/DetailMessage"
local detailRewardContent_path = "Content/DetailScroll/DetailViewport/DetailContent/DetailRewardContent"
local mailRewardItem_path = "Content/DetailScroll/DetailViewport/DetailContent/MailRewardItem"
local heroRewardItem_path = "Content/DetailScroll/DetailViewport/DetailContent/HeroRewardItem"
local rankingTipsText_path = "Content/DetailScroll/DetailViewport/DetailContent/RankContent/zyf_tongmengjunyan_youjian_di2/RankingTipsText"
local commanderTipsText_path = "Content/DetailScroll/DetailViewport/DetailContent/RankContent/zyf_tongmengjunyan_youjian_di2/CommanderTipsText"
local roundTipsText_path = "Content/DetailScroll/DetailViewport/DetailContent/RankContent/zyf_tongmengjunyan_youjian_di2/RoundTipsText"
local rankLoopListView_path = "Content/DetailScroll/DetailViewport/DetailContent/RankContent/RankScroll"
local rankContent_path = "Content/DetailScroll/DetailViewport/DetailContent/RankContent/RankScroll/ViewPort/RankContent"
local detailTimeText_path = "Content/DetailTimeBg/DetailTimeText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveRewards()
  self:RemoveRanks()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.rankLoopListView then
    self.rankLoopListView:MovePanelToItemIndex(0)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.detailTitle = self:AddComponent(UITextMeshProUGUIEx, detailTitle_path)
  self.detailMessage = self:AddComponent(UITextMeshProUGUIEx, detailMessage_path)
  self.detailRewardContent = self:AddComponent(UIBaseContainer, detailRewardContent_path)
  self.mailRewardItem = self:AddComponent(UIBaseContainer, mailRewardItem_path)
  self.heroRewardItem = self:AddComponent(UIBaseContainer, heroRewardItem_path)
  self.rankingTipsText = self:AddComponent(UITextMeshProUGUIEx, rankingTipsText_path)
  self.commanderTipsText = self:AddComponent(UITextMeshProUGUIEx, commanderTipsText_path)
  self.roundTipsText = self:AddComponent(UITextMeshProUGUIEx, roundTipsText_path)
  self.rankLoopListView = self:AddComponent(UILoopListView2, rankLoopListView_path)
  self.rankContent = self:AddComponent(UIBaseContainer, rankContent_path)
  self.detailTimeText = self:AddComponent(UITextMeshProUGUIEx, detailTimeText_path)
  self.rankingTipsText:SetText(Localization:GetString("361013"))
  self.commanderTipsText:SetText(Localization:GetString("100184"))
  self.rewardObj = self.transform:Find(mailRewardItem_path).gameObject
  self.rewardObj:GameObjectCreatePool()
  self.rewardHeroObj = self.transform:Find(heroRewardItem_path).gameObject
  self.rewardHeroObj:GameObjectCreatePool()
  self.rankLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

local function ComponentDestroy(self)
  self.detailTitle = nil
  self.detailMessage = nil
  self.detailRewardContent = nil
  self.mailRewardItem = nil
  self.heroRewardItem = nil
  self.rankingTipsText = nil
  self.commanderTipsText = nil
  self.roundTipsText = nil
  self.rankLoopListView = nil
  self.rankContent = nil
  self.detailTimeText = nil
end

local function DataDefine(self)
  self.rewardIndex = 0
  self.rankIndex = 0
end

local function DataDestroy(self)
  self.rewardIndex = nil
  self.rankIndex = nil
  self.rankType = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

local function RefreshContent(self)
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
  self:ShowRanks(self.mailData)
end

local function RewardSuccess(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
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

local function RemoveRewards(self)
  self.detailRewardContent:RemoveComponents(UICommonResItem)
  self.detailRewardContent:RemoveComponents(HeroRewardItem)
  self.rewardObj.gameObject:GameObjectRecycleAll()
  self.rewardHeroObj.gameObject:GameObjectRecycleAll()
end

local function ShowRewards(self, mailData)
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

local function ShowRewardItem(self, rewardData)
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

local function RemoveRanks(self)
  self.rankContent:RemoveComponents(UILWMailDetailSurfingBattleRankItemRender)
  self.rankLoopListView:ClearAllItems()
end

local function ShowRanks(self, mailData)
  local extData = mailData:GetMailExt()
  if extData == nil then
    return
  end
  self.rankType = extData:GetRankType()
  self.roundTipsText:SetText(Localization:GetString("parkour_rank_title_5"))
  self.rankList = extData:GetRankList()
  local rankCount = table.count(self.rankList)
  if 0 < rankCount then
    self.rankLoopListView:SetListItemCount(rankCount, false, false)
    self.rankLoopListView:RefreshAllShownItem()
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  local count = table.count(self.rankList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("SurfingBattleRankItem")
  local script = self.rankContent:GetComponent(item.gameObject.name, UILWMailDetailSurfingBattleRankItemRender)
  if script == nil then
    local objectName = tostring(self.rankIndex)
    self.rankIndex = self.rankIndex + 1
    item.gameObject.name = objectName
    script = self.rankContent:AddComponent(UILWMailDetailSurfingBattleRankItemRender, objectName)
  end
  script:SetActive(true)
  local rankingInfo = self.rankList[index]
  script:SetData(rankingInfo, self.rankType)
  return item
end

UILWMailDetailSurfingBattle.OnCreate = OnCreate
UILWMailDetailSurfingBattle.OnDestroy = OnDestroy
UILWMailDetailSurfingBattle.OnEnable = OnEnable
UILWMailDetailSurfingBattle.OnDisable = OnDisable
UILWMailDetailSurfingBattle.ComponentDefine = ComponentDefine
UILWMailDetailSurfingBattle.ComponentDestroy = ComponentDestroy
UILWMailDetailSurfingBattle.DataDefine = DataDefine
UILWMailDetailSurfingBattle.DataDestroy = DataDestroy
UILWMailDetailSurfingBattle.RefreshContent = RefreshContent
UILWMailDetailSurfingBattle.RemoveRewards = RemoveRewards
UILWMailDetailSurfingBattle.ShowRewards = ShowRewards
UILWMailDetailSurfingBattle.ShowRewardItem = ShowRewardItem
UILWMailDetailSurfingBattle.RemoveRanks = RemoveRanks
UILWMailDetailSurfingBattle.ShowRanks = ShowRanks
UILWMailDetailSurfingBattle.OnGetItemByIndex = OnGetItemByIndex
UILWMailDetailSurfingBattle.OnAddListener = OnAddListener
UILWMailDetailSurfingBattle.OnRemoveListener = OnRemoveListener
UILWMailDetailSurfingBattle.RewardSuccess = RewardSuccess
return UILWMailDetailSurfingBattle
