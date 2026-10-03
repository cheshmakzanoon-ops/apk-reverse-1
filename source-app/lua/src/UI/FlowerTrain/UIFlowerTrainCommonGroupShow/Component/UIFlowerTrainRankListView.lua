local base = UIBaseContainer
local UIFlowerTrainRankListView = BaseClass("UIFlowerTrainRankListView", base)
local UIFlowerTrainRankListRankItemView = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainRankListRankItemView")
local UIFlowerTrainRankListRankPlayerView = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainRankListRankPlayerView")
local showAnimIndex = 4
local Localization = CS.GameEntry.Localization
local rank1_path = "areaRank/winners/Rank1"
local rank2_path = "areaRank/winners/Rank2"
local rank3_path = "areaRank/winners/Rank3"
local rankScroll_path = "areaRank/scrollRank"
local selfRank_path = "areaRank/selfRank"
local infoBtn_path = "btnInfo"
local bg_path = "bg"
local bgBottom_path = "bg_bottom"
local emptyTxt_path = "emptyTxt"
local rankTipTxt_path = "rankTip"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Rank_Panel)
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
  self.rank1 = self:AddComponent(UIBaseContainer, rank1_path)
  self.rank2 = self:AddComponent(UIBaseContainer, rank2_path)
  self.rank3 = self:AddComponent(UIBaseContainer, rank3_path)
  self.rankScroll = self:AddComponent(UIBaseContainer, rankScroll_path)
  self.selfRank = self:AddComponent(UIBaseContainer, selfRank_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.bgBottom = self:AddComponent(UIImage, bgBottom_path)
  self.emptyTxt = self:AddComponent(UIText, emptyTxt_path)
  self.rankTipTxt = self:AddComponent(UIText, rankTipTxt_path)
  self.compFirst = self:AddComponent(UIFlowerTrainRankListRankPlayerView, rank1_path)
  self.compSecond = self:AddComponent(UIFlowerTrainRankListRankPlayerView, rank2_path)
  self.compThird = self:AddComponent(UIFlowerTrainRankListRankPlayerView, rank3_path)
  self.selfRankComponent = self:AddComponent(UIFlowerTrainRankListRankItemView, selfRank_path)
  self.winnerComps = {
    self.compFirst,
    self.compSecond,
    self.compThird
  }
  self.rankScrollComponent = self:AddComponent(UIDynamicVerticleScrollRectEx, rankScroll_path)
  self.itemIncNo = 1
  self.rankItemMap = {}
  self.rankScrollComponent:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rankItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rankItem = self:AddComponent(UIFlowerTrainRankListRankItemView, itemObj)
    if rankItem then
      rankItem.__prefabIdx = prefabIdx
      self.rankItemMap[itemObj] = rankItem
    end
  end)
  self.rankScrollComponent:AddDisplayItemListener(function(itemObj, dataIdx)
    local rankItem = self.rankItemMap[itemObj]
    if rankItem then
      local player = self.rankDatas[dataIdx + 1]
      rankItem:ReInit(player, self.itemTemplateId, self.actBanquetTemplate)
      if self.showAnimIndex == nil then
        self.showAnimIndex = 1
      end
      if self.showAnimIndex <= showAnimIndex then
        self.showAnimIndex = self.showAnimIndex + 1
      end
    end
  end)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.rank1 = nil
  self.rank2 = nil
  self.rank3 = nil
  self.rankScroll = nil
  self.selfRank = nil
  self.infoBtn = nil
  self.bg = nil
  self.bgBottom = nil
  self.emptyTxt = nil
  self.rankTipTxt = nil
  self.rankScrollComponent = nil
  self.selfRankComponent = nil
end

local function DataDefine(self)
  self.groupId, self.activityId, self.actBanquetId = self.view:GetUserData()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local partyNewId = actInfo.subType
  local actBanquetTemplate = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(partyNewId)
  self.actBanquetTemplate = actBanquetTemplate
  self.itemTemplateId = actBanquetTemplate.treasure_id
  self.paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(self.itemTemplateId)
  self.rankActivityId = actBanquetTemplate.rank_actid
  self.rankDatas = {}
  self.curRankArr = {}
  self.ownerData = {}
end

local function DataDestroy(self)
  self.rankDatas = {}
  self.curRankArr = {}
  self.ownerData = {}
end

function UIFlowerTrainRankListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIFlowerTrain_RankList, self.OnRecRankData)
end

function UIFlowerTrainRankListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIFlowerTrain_RankList, self.OnRecRankData)
end

function UIFlowerTrainRankListView:OnRecRankData(rankData)
  rankData = rankData or {}
  self.ownerData = rankData.owner or {}
  self.curRankArr = rankData.rankArr or {}
  table.sort(self.curRankArr, function(a, b)
    return a.rank < b.rank
  end)
  self:RefreshTopThree()
  self:RefreshScroll()
  self:RefreshSelfItem()
end

function UIFlowerTrainRankListView:RequestServerData()
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainRankList, self.rankActivityId)
end

function UIFlowerTrainRankListView:RefreshScroll()
  self.rankDatas = {}
  local prefabIdxs = {}
  local dataCount = #self.curRankArr
  for i = 4, dataCount do
    table.insert(self.rankDatas, self.curRankArr[i])
    table.insert(prefabIdxs, 0)
  end
  self.rankScrollComponent:SetDatas(prefabIdxs)
  local rank = self.ownerData.rank or 3
  local selfDataIdx = rank <= 3 and 3 or rank
  local scrollOffset = self.rankScrollComponent:GetScrollOffsetOfDataIdx(selfDataIdx - 4)
  self.rankScrollComponent:SetScrollOffset(scrollOffset)
  self.emptyTxt:SetActive(#self.curRankArr == 0)
end

function UIFlowerTrainRankListView:RefreshTopThree()
  for i = 1, 3 do
    local winnerComp = self.winnerComps[i]
    winnerComp:ReInit(self.curRankArr[i] or {}, self.itemTemplateId, self.rankActivityId)
  end
end

function UIFlowerTrainRankListView:RefreshSelfItem()
  self.selfRankComponent:ReInitSelf(self.ownerData, self.itemTemplateId)
end

function UIFlowerTrainRankListView:RefreshView()
  self.emptyTxt:SetActive(true)
  self:RequestServerData()
  self:RefreshScroll()
  self:RefreshTopThree()
  self:RefreshSelfItem()
  if self.paraMeta then
    self.rankTipTxt:SetText(Localization:GetString("2025halloween_treasure_rank_desc1", self.paraMeta.rank_need))
  else
    self.rankTipTxt:SetText("")
  end
  self:ModifyPanelPacking()
end

function UIFlowerTrainRankListView:ModifyPanelPacking()
  if self.actBanquetTemplate ~= nil then
    local configList = string.split(self.actBanquetTemplate.treasure_para, "|")
    if configList[18] then
      self.bg:LoadSpriteAsync(string.format(UIAssets.UIActMonopolyTexturePath, configList[18]))
    end
    if configList[19] then
      self.bgBottom:LoadSpriteAsync(string.format(UIAssets.UIActMonopolySpritePath, configList[19]))
    end
    if configList[22] then
      local colors = string.split(configList[22], ",")
      self.emptyTxt:SetColorRGBA255(tonumber(colors[1]), tonumber(colors[2]), tonumber(colors[3]), tonumber(colors[4]))
    end
  end
end

function UIFlowerTrainRankListView:OnInfoBtnClick()
  if self.paraMeta == nil then
    return
  end
  local param = {}
  param.activityId = self.activityId
  local info = string.split(self.paraMeta.rank_info, "|")
  param.activityRulesStr = info[2] and Localization:GetString(info[2], self.paraMeta.rank_need) or ""
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
end

UIFlowerTrainRankListView.OnCreate = OnCreate
UIFlowerTrainRankListView.OnDestroy = OnDestroy
UIFlowerTrainRankListView.OnEnable = OnEnable
UIFlowerTrainRankListView.OnDisable = OnDisable
UIFlowerTrainRankListView.ComponentDefine = ComponentDefine
UIFlowerTrainRankListView.ComponentDestroy = ComponentDestroy
UIFlowerTrainRankListView.DataDefine = DataDefine
UIFlowerTrainRankListView.DataDestroy = DataDestroy
return UIFlowerTrainRankListView
