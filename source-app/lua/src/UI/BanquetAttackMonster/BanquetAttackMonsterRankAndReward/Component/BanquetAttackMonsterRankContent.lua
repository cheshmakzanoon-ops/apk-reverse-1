local BanquetAttackMonsterRankContent = BaseClass("BanquetAttackMonsterRankContent", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterRankAndReward.Component.RankItem")

function BanquetAttackMonsterRankContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BanquetAttackMonsterRankContent:OnDestroy()
  self:ClearRankScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BanquetAttackMonsterRankContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetRankUpdate, self.OnRefresh)
end

function BanquetAttackMonsterRankContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetRankUpdate, self.OnRefresh)
end

function BanquetAttackMonsterRankContent:ComponentDefine()
  self._self_Rank = self:AddComponent(RankItem, "SelfPlayer")
  self.scroll_rank_view = self:AddComponent(UIScrollView, "ScrollView")
  self.scroll_rank_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_rank_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self._noRank_txt = self:AddComponent(UIText, "TxtEmpty")
  self.need_score_tips_text = self:AddComponent(UIText, "NeedScoreTipsText")
end

function BanquetAttackMonsterRankContent:ComponentDestroy()
  self.need_score_tips_text = nil
end

function BanquetAttackMonsterRankContent:DataDefine()
  self.activityId = nil
  self.selectType = nil
end

function BanquetAttackMonsterRankContent:DataDestroy()
  self.activityId = nil
  self.selectType = nil
end

function BanquetAttackMonsterRankContent:SetData(activityId, selectType, actBanquetId)
  self.activityId = activityId
  self.selectType = selectType
  self.actBanquetId = actBanquetId
  local needScore = 0
  local actBanquetTemplate = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  if actBanquetTemplate == nil then
    return
  end
  local iconName = actBanquetTemplate.score_pic
  if string.IsNullOrEmpty(iconName) then
    iconName = "zyf_yanhuujifen_icon_daoju"
  end
  self.iconPath = string.format(LoadPath.ItemPath, iconName)
  if self.selectType == ActChristmasTreeBelongType.Personal then
    self.curSegment = BanquetRankType.Personal
    self:RefreshPersonalRank()
    if actBanquetTemplate then
      needScore = actBanquetTemplate.rank_minscore
    end
  elseif self.selectType == ActChristmasTreeBelongType.Alliance then
    self.curSegment = BanquetRankType.Ally
    self:RefreshAllyRank()
    if actBanquetTemplate then
      needScore = actBanquetTemplate.rank_minscore_alliance
    end
  end
  if 0 < needScore then
    self.need_score_tips_text:SetLocalText("activity_partyrank_tips10", needScore)
  else
    self.need_score_tips_text:SetText("")
  end
end

function BanquetAttackMonsterRankContent:OnRefresh()
  self:OnRefreshRank()
end

function BanquetAttackMonsterRankContent:RefreshPersonalRank()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetV2Data.actBanquetId
  param.type = BanquetRankType.Personal
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2RankInfo, param)
end

function BanquetAttackMonsterRankContent:RefreshAllyRank()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetV2Data.actBanquetId
  param.type = BanquetRankType.Ally
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2RankInfo, param)
end

function BanquetAttackMonsterRankContent:OnRefreshRank()
  local dataReach = DataCenter.ActBanquetV2Data:IsRankDataReach()
  if dataReach then
    self:ClearRankScroll()
    self.rankArr = DataCenter.ActBanquetV2Data:GetRankArr(self.curSegment)
    if self.rankArr and #self.rankArr > 0 then
      self.scroll_rank_view:SetTotalCount(#self.rankArr)
      self.scroll_rank_view:RefillCells()
      self._noRank_txt:SetActive(false)
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
    end
    self:RefreshSelfRank()
  end
end

function BanquetAttackMonsterRankContent:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_rank_view:AddComponent(RankItem, itemObj)
  local data = self.rankArr[index]
  local oneData = {}
  oneData.isSelf = false
  oneData.iconPath = self.iconPath
  if self.selectType == ActChristmasTreeBelongType.Personal then
    oneData.score = data.score
    if not string.IsNullOrEmpty(data.alAbbr) then
      oneData.name = "[" .. data.alAbbr .. "]" .. data.name
    else
      oneData.name = data.name
    end
    oneData.rank = data.ranking
    oneData.isSelf = data.uid == LuaEntry.Player.uid
    oneData.isAlly = false
    oneData.serverId = data.serverId
    oneData.uid = data.uid
    oneData.pic = data.pic
    oneData.picVer = data.picVer
    oneData.headSkinId = data.headSkinId
    oneData.headSkinET = data.headSkinET
  elseif self.selectType == ActChristmasTreeBelongType.Alliance then
    oneData.score = data.score
    oneData.name = "[" .. data.alAbbr .. "]" .. data.name
    oneData.rank = data.ranking
    local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    oneData.isSelf = allInfo.uid == data.aid
    oneData.isAlly = true
    oneData.icon = data.icon
    oneData.serverId = data.serverId
    oneData.uid = data.aid
    oneData.allianceName = data.name
  end
  cellItem:RefreshData(oneData)
end

function BanquetAttackMonsterRankContent:OnRankItemMoveOut(itemObj, index)
  self.scroll_rank_view:RemoveComponent(itemObj.name, RankItem)
end

function BanquetAttackMonsterRankContent:ClearRankScroll()
  self.scroll_rank_view:ClearCells()
  self.scroll_rank_view:RemoveComponents(RankItem)
end

function BanquetAttackMonsterRankContent:RefreshSelfRank()
  local oneData = {}
  oneData.isSelf = true
  oneData.iconPath = self.iconPath
  if self.selectType == ActChristmasTreeBelongType.Personal then
    local data = DataCenter.ActBanquetV2Data.selfRank
    oneData.score = data.score
    if LuaEntry.Player:IsInAlliance() then
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      oneData.name = "[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name
    else
      oneData.name = LuaEntry.Player.name
    end
    oneData.rank = (data.ranking == nil or data.ranking == 0) and -1 or data.ranking
    oneData.isAlly = false
  elseif self.selectType == ActChristmasTreeBelongType.Alliance then
    local data = DataCenter.ActBanquetV2Data.selfAllyRank
    oneData.score = data.score
    local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    oneData.name = "[" .. allInfo.abbr .. "]" .. allInfo.allianceName
    oneData.rank = (data.ranking == nil or data.ranking == 0) and -1 or data.ranking
    oneData.isAlly = true
    oneData.icon = allInfo.icon
  end
  self._self_Rank:RefreshData(oneData)
end

return BanquetAttackMonsterRankContent
