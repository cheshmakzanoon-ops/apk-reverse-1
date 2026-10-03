local base = UIBaseView
local UICollectRewardView = BaseClass("UICollectRewardView", base)
local Localization = CS.GameEntry.Localization
local CollectRewardItem = require("UI.UICollectReward.Component.CollectRewardItem")
local FlowerTrainRewardItemComponent = require("UI.UICollectReward.Component.FlowerTrainRewardItemComponent")
local FlowerTrainRewardBoxItem = require("UI.UICollectReward.Component.FlowerTrainRewardBoxItemComponent")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local bgBtn_path = "UICommonPopUpTitle/panel"
local collectSv_path = "ImgBg/ScrollView"
local collectContent_path = "ImgBg/ScrollView/Viewport/Content"
local claimBtn_path = "ImgBg/claimBtn"
local claimBtnTxt_path = "ImgBg/claimBtn/claimBtnTxt"
local targetTxt_path = "ImgBg/select/targetTxt"
local rewardTxt_path = "ImgBg/select/rewardTxt"
local btn_hide_limit_tips_path = "ImgBg/BtnHideLimitTips"
local info_btn_path = "ImgBg/InfoBtn"
local CellType = {
  CardBox = 1,
  Collect = 2,
  FlowerTrain = 3,
  FlowerTrainCheerReward = 4
}
local CELL_CONFIG = {
  [CellType.Collect] = {
    prefabName = "CollectRewardItem",
    cls = CollectRewardItem
  },
  [CellType.CardBox] = {
    prefabName = "CollectRewardItem",
    cls = CollectRewardItem
  },
  [CellType.FlowerTrain] = {
    prefabName = "FlowerTrainRewardItem",
    cls = FlowerTrainRewardItemComponent
  },
  [CellType.FlowerTrainCheerReward] = {
    prefabName = "FlowerTrainRewardBoxItem",
    cls = FlowerTrainRewardBoxItem
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitUI()
  self:CheckFlowerTrain()
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(104292)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.ScrollView = self:AddComponent(UILoopListView2, collectSv_path)
  self.ScrollView:InitListView(0, function(loopView, index)
    return self:OnGetCellItemByIndex(loopView, index)
  end)
  self.contentN = self:AddComponent(UIBaseContainer, collectContent_path)
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.claimBtnTxtN = self:AddComponent(UIText, claimBtnTxt_path)
  self.claimBtnTxtN:SetLocalText(110132)
  self.targetTxtN = self:AddComponent(UIText, targetTxt_path)
  self.targetTxtN:SetLocalText(104293)
  self.rewardTxtN = self:AddComponent(UIText, rewardTxt_path)
  self.rewardTxtN:SetLocalText(104294)
  self.btn_hide_limit_tips = self:AddComponent(UIButton, btn_hide_limit_tips_path)
  self.btn_hide_limit_tips:SetOnClick(function()
    self:HideAllLimitTips()
  end)
  self.btn_hide_limit_tips:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(BindCallback(self.InfoBtnClick, self))
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleN = nil
  self.closeBtnN = nil
  self.bgBtnN = nil
  self.loopListView = nil
  self.contentN = nil
end

local function DataDefine(self)
  local seasonType = SeasonUtil.GetSeasonType()
  self.collectList = {}
  if seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.CityStronghold then
    SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
  end
end

local function DataDestroy(self)
  self.collectList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMonsterRewardBag, self.RefreshMonsterReward)
  self:AddUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshMonsterRewardBag, self.RefreshMonsterReward)
  self:RemoveUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  self:RefreshAll()
end

function UICollectRewardView:RefreshMonsterReward()
  self:RefreshAll()
end

function UICollectRewardView:OnGetCellItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.allCellDataList then
    return nil
  end
  local cellConfig = self:GetCellConfigByIndex(index)
  if not cellConfig then
    return nil
  end
  local prefabName = cellConfig.prefabName
  local cls = cellConfig.cls
  local item = loopView:NewListViewItem(prefabName)
  if not item then
    return nil
  end
  local script = self.contentN:GetComponent(item.gameObject.name, cls)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.contentN:AddComponent(cls, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(1, 1, 1)
  local data = self.allCellDataList[index]
  local dataType = self:GetCellTypeByIndex(index)
  script:SetItem(index, data, dataType)
  return item
end

function UICollectRewardView:GetCellConfigByIndex(index)
  local cellType = self:GetCellTypeByIndex(index)
  if cellType == CellType.Collect then
    cellType = self:SpecialCollectCellCheck(index)
  end
  if not table.containsKey(CELL_CONFIG, cellType) then
    return CELL_CONFIG[CellType.Collect]
  end
  return CELL_CONFIG[cellType]
end

function UICollectRewardView:SpecialCollectCellCheck(index)
  if not self.allCellDataList then
    return CellType.Collect
  end
  local data = self.allCellDataList[index]
  if not data then
    return CellType.Collect
  end
  local type = data.type
  if type == CollectRewardType.DISCOVER_SUPPLIES and data.contentId then
    local contentParam = string.split(data.contentId, "|")
    local configId = contentParam[1]
    local configData = configId and LocalController:instance():getLine(TableName.LWIceSupplies, configId)
    if not configData then
      return CellType.Collect
    end
    if configData.type == WorldSuppliesType.FlowerTrainCheerBoxType then
      return CellType.FlowerTrainCheerReward
    end
  end
  return CellType.Collect
end

function UICollectRewardView:GetCellTypeByIndex(index)
  if index <= self.flowerTrainCount then
    return CellType.FlowerTrain
  elseif index <= self.flowerTrainCount + self.cardBoxCount then
    return CellType.CardBox
  elseif index <= self.flowerTrainCount + self.cardBoxCount + self.collectCount then
    return CellType.Collect
  else
    return CellType.Collect
  end
end

function UICollectRewardView:ClearScroll()
  self.contentN:RemoveAllComponentes()
  self.ScrollView:ClearAllItems()
end

local function RefreshAll(self)
  self.allCellDataList = {}
  self.collectList = DataCenter.CollectRewardDataManager:GetRewardListBySort()
  local boxList = DataCenter.SeasonDataManager.cardBoxList
  local collectCount = #self.collectList
  local cardBoxCount = 0
  if BattleFieldUtil.InBattleField() then
    self.cardBoxList = {}
    self.cardBoxCount = 0
  elseif boxList and 0 < #boxList then
    local now = UITimeManager:GetInstance():GetServerTime()
    local theCardBoxList = {}
    for k, v in ipairs(boxList) do
      if v and v.expiredTime ~= nil and now < toInt(v.expiredTime) then
        table.insert(theCardBoxList, v)
      elseif v and v.expiredTime == nil then
        table.insert(theCardBoxList, v)
      end
    end
    cardBoxCount = #theCardBoxList
    self.cardBoxCount = cardBoxCount
    self.cardBoxList = theCardBoxList
  else
    self.cardBoxCount = 0
    self.cardBoxList = {}
  end
  if BattleFieldUtil.InBattleField() then
    self.flowerTrainList = {}
    self.flowerTrainCount = 0
  else
    self.flowerTrainList = DataCenter.FlowerTrainDataManager:GetPlayerAllFlowerTrainDataList() or {}
    self.flowerTrainCount = #self.flowerTrainList
  end
  for _, v in ipairs(self.flowerTrainList) do
    table.insert(self.allCellDataList, v)
  end
  for _, v in ipairs(self.cardBoxList) do
    table.insert(self.allCellDataList, v)
  end
  for _, v in ipairs(self.collectList) do
    table.insert(self.allCellDataList, v)
  end
  self.collectCount = collectCount
  if #self.allCellDataList > 0 then
    self.ScrollView:SetListItemCount(#self.allCellDataList, false, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.ScrollView:ClearAllItems()
    self.contentN:RemoveAllComponentes()
  end
  local isHaveNeedClaimItem = false
  for i, collect in ipairs(self.collectList) do
    if self:IsNeedClaimType(collect.type) then
      isHaveNeedClaimItem = true
      break
    end
  end
  if isHaveNeedClaimItem then
    self.claimBtnTxtN:SetLocalText(110132)
  else
    self.claimBtnTxtN:SetLocalText(451020)
  end
  local isEmpty = #self.allCellDataList == 0
  if isEmpty then
    self.ctrl:CloseSelf()
  end
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickClaimBtn(self)
  local isFull = false
  local totalNum = 0
  local uuidList = {}
  for i, collect in ipairs(self.collectList) do
    local rewardList = collect.rewardList
    if rewardList ~= nil then
      table.walk(rewardList, function(k, v)
        if isFull == false and v.rewardType == RewardType.RESOURCE_ITEM then
          totalNum = totalNum + v.count
          if DataCenter.ResourceItemDataManager:CheckIsStorageFull(totalNum) then
            isFull = true
          end
        end
      end)
    end
    if not isFull then
      table.insert(uuidList, collect.uuid)
    else
      break
    end
  end
  if 0 < #uuidList then
    DataCenter.LWSoundManager:PlaySound(62299, false)
    SFSNetwork.SendMessage(MsgDefines.GatherCollectReward, uuidList)
    self.ctrl:CloseSelf()
  elseif isFull then
    GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
  else
    self.ctrl:CloseSelf()
  end
  self:CheckClaimFlowerCheerReward()
end

local function IsNeedClaimType(self, type)
  if type == CollectRewardType.COLLECT or type == CollectRewardType.PLUNDER or type == CollectRewardType.FAKE_PLAYER or type == CollectRewardType.PLUNDER_LIMIT or type == CollectRewardType.RALLY_JOIN_LIMIT or type == CollectRewardType.RALLY_JOIN_CROCODILE_LIMIT or type == CollectRewardType.ALLIANCE_RESOURCE_COLLECT or type == CollectRewardType.ROB_BANK_STRONGHOLD then
    return false
  end
  return true
end

function UICollectRewardView:OnLimitTipsShown()
  self.btn_hide_limit_tips:SetActive(true)
end

function UICollectRewardView:HideAllLimitTips()
  self.btn_hide_limit_tips:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.CloseAllCollectRewardLimitTips)
end

function UICollectRewardView:InfoBtnClick()
  UIUtil.ShowBubbleTips(Localization:GetString("loot_tips_001"), self.info_btn.transform.position, 0, -20, 0)
end

function UICollectRewardView:CheckFlowerTrain()
  if self.flowerTrainCount > 0 then
    FlowerTrainUtils.ShowRecentlyLikeAndCheers()
    PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Tip_Panel)
  end
end

function UICollectRewardView:CheckClaimFlowerCheerReward()
  if not self:IsExistFlowerTrainCheerReward() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainCheerBoxBatch)
end

function UICollectRewardView:IsExistFlowerTrainCheerReward()
  if not self.allCellDataList then
    return false
  end
  for index, v in ipairs(self.allCellDataList) do
    local cellType = self:SpecialCollectCellCheck(index)
    if cellType == CellType.FlowerTrainCheerReward then
      return true
    end
  end
  return false
end

UICollectRewardView.OnCreate = OnCreate
UICollectRewardView.OnDestroy = OnDestroy
UICollectRewardView.OnAddListener = OnAddListener
UICollectRewardView.OnRemoveListener = OnRemoveListener
UICollectRewardView.ComponentDefine = ComponentDefine
UICollectRewardView.ComponentDestroy = ComponentDestroy
UICollectRewardView.DataDefine = DataDefine
UICollectRewardView.DataDestroy = DataDestroy
UICollectRewardView.InitUI = InitUI
UICollectRewardView.RefreshAll = RefreshAll
UICollectRewardView.OnClickCloseBtn = OnClickCloseBtn
UICollectRewardView.OnClickClaimBtn = OnClickClaimBtn
UICollectRewardView.IsNeedClaimType = IsNeedClaimType
return UICollectRewardView
