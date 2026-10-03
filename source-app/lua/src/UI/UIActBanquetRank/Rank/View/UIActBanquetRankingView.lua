local UIActBanquetRankingView = BaseClass("UIActBanquetRankingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.UIActBanquetRank.Rank.Component.RankItem")
local SegmentName = {
  [BanquetRankType.Personal] = "thanksactivity_UI039",
  [BanquetRankType.Ally] = "thanksactivity_UI040"
}

function UIActBanquetRankingView:OnCreate()
  base.OnCreate(self)
  self.panel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/safearea/BtnClose")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UIText, "UICommonPopUpTitle/safearea/TopBar/TextTitle")
  self.title:SetLocalText("390040")
  self.segmentN = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content")
  self.segmentTbN = {}
  for i = 0, 1 do
    local segment = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content/Tab" .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(SegmentName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(SegmentName[i])
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      btnN = btn
    }
    table.insert(self.segmentTbN, newSeg)
  end
  self._self_Rank = self:AddComponent(RankItem, "RankObj/SelfPlayer")
  self.scroll_rank_view = self:AddComponent(UIScrollView, "RankObj/ScrollView")
  self.scroll_rank_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_rank_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self._noRank_txt = self:AddComponent(UIText, "RankObj/TxtEmpty")
  local actId = self:GetUserData()
  self:SetData(actId)
end

function UIActBanquetRankingView:OnDestroy()
  self.actEnd = nil
  self.curSegment = nil
  self:ClearRankScroll()
  base.OnDestroy(self)
end

function UIActBanquetRankingView:OnEnable()
  base.OnEnable(self)
  self._noRank_txt:SetActive(false)
end

function UIActBanquetRankingView:OnDisable()
  base.OnDisable(self)
end

function UIActBanquetRankingView:SetData(actId)
  self.activityId = actId
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.activityId))
  if actData then
    self.actEndTime = actData.endTime
  end
  self:SelectSegment(BanquetRankType.Personal)
end

function UIActBanquetRankingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetRankUpdate, self.OnRefresh)
end

function UIActBanquetRankingView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetRankUpdate, self.OnRefresh)
end

function UIActBanquetRankingView:OnRefresh()
  self:OnRefreshRank()
end

function UIActBanquetRankingView:RefreshPersonalRank()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Personal
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankInfo, param)
end

function UIActBanquetRankingView:RefreshAllyRank()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Ally
  param.startN = 1
  param.endN = 100
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankInfo, param)
end

function UIActBanquetRankingView:OnRefreshRank()
  local dataReach = DataCenter.ActBanquetData:IsRankDataReach()
  if dataReach then
    self:ClearRankScroll()
    self.rankArr = DataCenter.ActBanquetData:GetRankArr(self.curSegment)
    if self.rankArr and #self.rankArr > 0 then
      self.scroll_rank_view:SetTotalCount(#self.rankArr)
      self.scroll_rank_view:RefillCells()
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
    end
    self:RefreshSelfRank()
  end
end

function UIActBanquetRankingView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_rank_view:AddComponent(RankItem, itemObj)
  local data = self.rankArr[index]
  local oneData = {}
  oneData.isSelf = false
  if self.curSegment == BanquetRankType.Personal then
    oneData.score = data.score
    oneData.name = data.name
    oneData.rank = data.ranking
    oneData.isSelf = data.uid == LuaEntry.Player.uid
    oneData.isAlly = false
    oneData.serverId = data.serverId
    oneData.uid = data.uid
    oneData.pic = data.pic
    oneData.picVer = data.picVer
    oneData.headSkinId = data.headSkinId
    oneData.headSkinET = data.headSkinET
  elseif self.curSegment == BanquetRankType.Ally then
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

function UIActBanquetRankingView:OnRankItemMoveOut(itemObj, index)
  self.scroll_rank_view:RemoveComponent(itemObj.name, RankItem)
end

function UIActBanquetRankingView:ClearRankScroll()
  self.scroll_rank_view:ClearCells()
  self.scroll_rank_view:RemoveComponents(RankItem)
end

function UIActBanquetRankingView:RefreshSelfRank()
  local oneData = {}
  oneData.isSelf = true
  if self.curSegment == BanquetRankType.Personal then
    local data = DataCenter.ActBanquetData.selfRank
    oneData.score = data.score
    if LuaEntry.Player:IsInAlliance() then
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      oneData.name = "[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name
    else
      oneData.name = LuaEntry.Player.name
    end
    oneData.rank = data.ranking == 0 and -1 or data.ranking
    oneData.isAlly = false
  elseif self.curSegment == BanquetRankType.Ally then
    local data = DataCenter.ActBanquetData.selfAllyRank
    oneData.score = data.score
    local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    oneData.name = "[" .. allInfo.abbr .. "]" .. allInfo.allianceName
    oneData.rank = data.ranking == 0 and -1 or data.ranking
    oneData.isAlly = true
    oneData.icon = allInfo.icon
  end
  self._self_Rank:RefreshData(oneData)
end

function UIActBanquetRankingView:OnClickSegment(index)
  if index == BanquetRankType.Personal or LuaEntry.Player:IsInAlliance() then
    self:SelectSegment(index)
  else
    UIUtil.ShowTipsId(800935)
  end
end

function UIActBanquetRankingView:SelectSegment(seg)
  if self.curSegment == seg then
    return
  end
  self.curSegment = seg
  for i, v in ipairs(self.segmentTbN) do
    if i - 1 == seg then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  self:ShowPanel()
end

function UIActBanquetRankingView:ShowPanel()
  if self.curSegment == BanquetRankType.Personal then
    self:RefreshPersonalRank()
  elseif self.curSegment == BanquetRankType.Ally then
    self:RefreshAllyRank()
  end
end

return UIActBanquetRankingView
