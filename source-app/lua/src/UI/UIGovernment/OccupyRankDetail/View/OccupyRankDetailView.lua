local OccupyRankDetailView = BaseClass("OccupyRankDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local OccupyRankDetailItem = require("UI.UIGovernment.OccupyRankDetail.Component.OccupyRankDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_path = "PopUpTitle/title"
local item_path = "PopUpTitle/Item"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local desc_path = "PopUpTitle/desc"
local info_btn_path = "PopUpTitle/InfoBtn"

function OccupyRankDetailView:OnCreate()
  base.OnCreate(self)
  local curServerId = LuaEntry.Player:GetCurServerId()
  self.cityId = self:GetUserData()
  self.serverId = LuaEntry.Player:GetCurServerId()
  if self.cityId then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, LuaEntry.Player:GetCurServerId())
    if cityTemplate ~= nil and cityTemplate:IsCityStronghold() then
      self.isCityStronghold = true
      self.pointId = cityTemplate:GetPointId()
      self.serverId = cityTemplate:GetCurServerId(curServerId)
      self.stronghold_points = cityTemplate.stronghold_points
    else
      SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, curServerId)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, curServerId)
  end
  self:ComponentDefine()
  if self.isCityStronghold then
    self:OnPointDateUpdate()
  end
end

function OccupyRankDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OccupyRankDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityStrongholdOccupyProgressRefresh, self.RefreshCityStrongholdOccupy)
  self:AddUIListener(EventId.KingOccupyProgressRefresh, self.RefreshRankList)
  self:AddUIListener(EventId.StrongholdBattleStateUpdate, self.OnStrongholdBattleStateUpdate)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointDateUpdate)
end

function OccupyRankDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.CityStrongholdOccupyProgressRefresh, self.RefreshCityStrongholdOccupy)
  self:RemoveUIListener(EventId.KingOccupyProgressRefresh, self.RefreshRankList)
  self:RemoveUIListener(EventId.StrongholdBattleStateUpdate, self.OnStrongholdBattleStateUpdate)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointDateUpdate)
  base.OnRemoveListener(self)
end

function OccupyRankDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("457044")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title = self:AddComponent(UIText, title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.title:SetLocalText("457045")
  self.desc:SetLocalText("457046")
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.self_data = self:AddComponent(OccupyRankDetailItem, item_path)
  if self.isCityStronghold then
    self.desc:SetLocalText("season_tips238")
    self.desc:SetActive(true)
    self.info_btn:SetActive(true)
    self.info_btn:SetOnClick(function()
      local title = "2000047"
      local desc = Localization:GetString("season_UI_info_101")
      UIUtil.ShowDetail(desc, title)
    end)
  else
    self.desc:SetActive(true)
    self.info_btn:SetActive(false)
  end
  self.self_data:SetActive(false)
end

function OccupyRankDetailView:ComponentDestroy()
  self:ClearScroll()
  self.info_btn = nil
  self.btn_back = nil
end

function OccupyRankDetailView:OnPointDateUpdate()
  ProfilerUtil.BeginSample("OccupyRankDetailView:OnPointDateUpdate")
  if self.pointId == nil or self.isCityStronghold ~= true then
    ProfilerUtil.EndSample()
    return
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo ~= nil then
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if extraInfo ~= nil then
      if extraInfo.buildPointInfo == nil or toInt(extraInfo.battleStartTime) == 0 then
        SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, LuaEntry.Player:GetCurServerId())
        UIUtil.CloseDetail()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOccupyRankDetail)
        ProfilerUtil.EndSample()
        return
      end
      local attackInfo = extraInfo.buildPointInfo
      if attackInfo == nil or string.IsNullOrEmpty(attackInfo.allianceId) then
        SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, LuaEntry.Player:GetCurServerId())
        UIUtil.CloseDetail()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOccupyRankDetail)
        ProfilerUtil.EndSample()
        return
      end
      if self.stronghold_occupy_player == nil or self.stronghold_occupy_player.allianceId ~= attackInfo.allianceId then
        SFSNetwork.SendMessage(MsgDefines.GetStrongholdOccupyProgress, self.cityId, LuaEntry.Player:GetCurServerId())
      end
      self.stronghold_occupy_player = attackInfo
      self.battleStartTime = extraInfo.battleStartTime
      self.battleEndTime = extraInfo.battleEndTime
    end
  end
  ProfilerUtil.EndSample()
end

function OccupyRankDetailView:OnStrongholdBattleStateUpdate()
  if self.isCityStronghold then
    local serverId = LuaEntry.Player:GetCurServerId()
    local isBattle = DataCenter.WorldAllianceCityDataManager:GetStrongholdBattleState(serverId, self.cityId)
    if not isBattle then
      UIUtil.CloseDetail()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOccupyRankDetail)
    end
  end
end

function OccupyRankDetailView:RefreshCityStrongholdOccupy(data)
  if self.isCityStronghold and data and data.progress and data.strongholdId and self.cityId == data.strongholdId then
    self.rankList = data.progress
    local ownerPlayer
    if #self.rankList > 0 then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      for i, v in ipairs(self.rankList) do
        if 0 < toInt(v.speed) and not data.freeze then
          v.pointNow = v.point + v.speed * (curTime - v.buildStartTime)
        else
          v.pointNow = v.point
        end
        v.startTime = v.buildStartTime * 1000
        v.abbr = v.alAbbr
        v.name = v.alName
        v.icon = v.alIcon
        v.maxPoint = self.stronghold_points
      end
      table.sort(self.rankList, function(a, b)
        return a.pointNow > b.pointNow
      end)
      for i, v in ipairs(self.rankList) do
        if 0 < toInt(v.speed) and not data.freeze then
          ownerPlayer = v
          self.self_data:ReInit(i, v, true)
          self.self_data:SetActive(true)
          break
        end
      end
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
    if ownerPlayer == nil then
      self.self_data:ReInit(1, self.rankList[1], true)
      self.self_data:SetActive(true)
    end
  end
end

function OccupyRankDetailView:RefreshRankList()
  if self.isCityStronghold then
    return
  end
  local curServerId = self.serverId or LuaEntry.Player:GetCurServerId()
  local fightInfo = DataCenter.GovernmentManager:GetKingOccupyList(curServerId)
  self.rankList = fightInfo
  if self.rankList and #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
  if fightInfo then
    self:RefreshSelfContent()
  else
    self.self_data:SetActive(false)
  end
end

function OccupyRankDetailView:RefreshSelfContent()
  local index = 1000
  local currentData
  if self.isCityStronghold then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    local myAllianceId = "-"
    if hasAlliance then
      myAllianceId = LuaEntry.Player:GetAllianceUid()
      for i, v in ipairs(self.rankList) do
        if v.allianceId == myAllianceId then
          currentData = v
          index = i
          break
        end
      end
    end
    if currentData == nil then
      currentData = {
        aId = myAllianceId,
        abbr = "",
        name = "",
        point = 0,
        startTime = 0,
        speed = 0
      }
      if hasAlliance then
        local allianceBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if allianceBaseInfo ~= nil and allianceBaseInfo.abbr then
          currentData.aId = myAllianceId
          currentData.abbr = allianceBaseInfo.abbr
          currentData.name = allianceBaseInfo.allianceName
          currentData.icon = allianceBaseInfo.icon
        end
      end
    end
  else
    local curServerId = self.serverId or LuaEntry.Player:GetCurServerId()
    currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(curServerId)
    for i, v in ipairs(self.rankList) do
      if v.isBuilding == 1 then
        currentData = v
        index = i
        break
      end
    end
  end
  if currentData then
    self.self_data:ReInit(index, currentData, true)
    self.self_data:SetActive(true)
  else
    self.self_data:SetActive(false)
  end
end

function OccupyRankDetailView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(OccupyRankDetailItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index], false)
  end
end

function OccupyRankDetailView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, OccupyRankDetailItem)
end

function OccupyRankDetailView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(OccupyRankDetailItem)
end

function OccupyRankDetailView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function OccupyRankDetailView:OnAllianceDetailClick(allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(nil, allianceId, allianceName)
end

return OccupyRankDetailView
