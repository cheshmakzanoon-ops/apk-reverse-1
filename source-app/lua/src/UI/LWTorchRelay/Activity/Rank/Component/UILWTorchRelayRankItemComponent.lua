local UILWTorchRelayRankItemComponent = BaseClass("UILWTorchRelayRankItemComponent", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankItem = require("UI/LWTorchRelay/Activity/Rank/Component/UILWTorchRelayRankItem")

function UILWTorchRelayRankItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayRankItemComponent:OnDestroy()
  self:ClearRankScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayRankItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActRankUpdate, self.OnRefresh)
  self:AddUIListener(EventId.ActivityTorchRelayActRankHideNationUpdate, self.OnRefresh)
end

function UILWTorchRelayRankItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityTorchRelayActRankUpdate, self.OnRefresh)
  self:RemoveUIListener(EventId.ActivityTorchRelayActRankHideNationUpdate, self.OnRefresh)
end

function UILWTorchRelayRankItemComponent:ComponentDefine()
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
  self.btnAuto = self:AddComponent(UIButton, "AutoBtn")
  self.btnAuto:SetOnClick(function()
  end)
  self.btnAuto:SetActive(false)
  self.compAutoBeSelect = self:AddComponent(UIBaseContainer, "AutoBtn/AutoBeSelect")
  self.textAuto = self:AddComponent(UIText, "AutoText")
  self.textAuto:SetText(Localization:GetString("activity_torch_relay_desc_19"))
  self.textAuto:SetActive(false)
end

function UILWTorchRelayRankItemComponent:ComponentDestroy()
  self.need_score_tips_text = nil
end

function UILWTorchRelayRankItemComponent:DataDefine()
  self.activityId = nil
  self.selectType = nil
end

function UILWTorchRelayRankItemComponent:DataDestroy()
  self.activityId = nil
  self.selectType = nil
end

function UILWTorchRelayRankItemComponent:SetData(activityId, selectType, actBanquetId)
  self.activityId = activityId
  self.selectType = selectType
  self.actBanquetId = actBanquetId
  local needScore = 0
  local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if actData == nil or actData.config == nil then
    return
  end
  self.iconPath = ""
  if self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    self:RefreshPersonalRank()
    needScore = math.ceil(actData.config.rank_minscore)
  elseif self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
    self:RefreshAllyRank()
    needScore = math.ceil(actData.config.rank_minscore_alliance)
  end
  if 0 < needScore then
    self.need_score_tips_text:SetLocalText("activity_torch_relay_ranklimit", needScore .. "m")
  else
    self.need_score_tips_text:SetText("")
  end
  self:UpdateNation()
end

function UILWTorchRelayRankItemComponent:OnRefresh()
  self:UpdateNation()
  self:OnRefreshRank()
end

function UILWTorchRelayRankItemComponent:RefreshPersonalRank()
  local param = {}
  param.aid = self.activityId
  param.type = DataCenter.ActivityTorchRelayManager.RankType.Personal - 1
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayRankInfo, param)
end

function UILWTorchRelayRankItemComponent:RefreshAllyRank()
  local param = {}
  param.aid = self.activityId
  param.type = DataCenter.ActivityTorchRelayManager.RankType.Alliance - 1
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayRankInfo, param)
end

function UILWTorchRelayRankItemComponent:OnRefreshRank()
  self:ClearRankScroll()
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if not data then
    return
  end
  self.rankArr = data:GetRankListInfo(self.selectType)
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

function UILWTorchRelayRankItemComponent:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_rank_view:AddComponent(RankItem, itemObj)
  local data = self.rankArr[index]
  local oneData = {}
  oneData.isSelf = false
  oneData.iconPath = self.iconPath
  if self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
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
    oneData.hideFlag = data.hideFlag
    oneData.countryflag = data.countryflag
  elseif self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
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
  cellItem:RefreshData(oneData, self.activityId)
end

function UILWTorchRelayRankItemComponent:OnRankItemMoveOut(itemObj, index)
  self.scroll_rank_view:RemoveComponent(itemObj.name, RankItem)
end

function UILWTorchRelayRankItemComponent:ClearRankScroll()
  self.scroll_rank_view:ClearCells()
  self.scroll_rank_view:RemoveComponents(RankItem)
end

function UILWTorchRelayRankItemComponent:RefreshSelfRank()
  local oneData = {}
  oneData.isSelf = true
  oneData.iconPath = self.iconPath
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if not activityData then
    return
  end
  if self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    local data = activityData:GetSelfRankInfoData(DataCenter.ActivityTorchRelayManager.RankType.Personal)
    if data then
      oneData.score = data.score
      if LuaEntry.Player:IsInAlliance() then
        local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        oneData.name = "[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name
      else
        oneData.name = LuaEntry.Player.name
      end
      oneData.rank = (data.rank == nil or data.rank == 0) and -1 or data.rank
      oneData.isAlly = false
    end
  elseif self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
    local data = activityData:GetSelfRankInfoData(DataCenter.ActivityTorchRelayManager.RankType.Alliance)
    if data then
      oneData.score = data.score
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      oneData.name = "[" .. allInfo.abbr .. "]" .. allInfo.allianceName
      oneData.rank = (data.rank == nil or data.rank == 0) and -1 or data.rank
      oneData.isAlly = true
      oneData.icon = allInfo.icon
    end
  end
  self._self_Rank:RefreshData(oneData, self.activityId)
end

function UILWTorchRelayRankItemComponent:UpdateNation()
end

function UILWTorchRelayRankItemComponent:OnBtnAutoClick()
  if self.activityId then
    local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if data then
      SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayRankHideNation, {
        activityId = self.activityId,
        hide = not data:GetIsHideNationFlag()
      })
    end
  end
end

return UILWTorchRelayRankItemComponent
