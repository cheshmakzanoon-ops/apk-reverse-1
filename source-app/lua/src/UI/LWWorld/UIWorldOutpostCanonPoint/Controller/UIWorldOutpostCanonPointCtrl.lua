local UIWorldOutpostCanonPointCtrl = BaseClass("UIWorldOutpostCanonPointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local OutpostOwnerChanged = require("Net.Msgs.Season5.Outpost.PushOutpostOwnerChangedMessage")

function UIWorldOutpostCanonPointCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldOutpostCanonPoint)
end

function UIWorldOutpostCanonPointCtrl:InitData(cityId, pointId, serverId, uuid)
  self.uuid = uuid
  self.cityId = cityId
  self.pointId = pointId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if meta then
    self.meta = meta
    self.isKingCity = meta:IsThroneCity()
    self.worldCityType = meta.type
    self.outpostCityId = self.meta.parent_output
    self.serverId = meta:GetCurServerId(self.serverId)
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if self.pointInfo ~= nil then
    self.serverId = self.pointInfo.serverId
    FetchOutpostDetailInfo.GetDetailInfo(self.serverId, cityId, true, true)
    DataCenter.ZoneWarManager:UpdateBatteryFireTime(cityId, self.pointInfo.lastTowerAttackTime)
  end
  local seasonInfo = SeasonUtil.GetSeasonInfo(self.serverId)
  if seasonInfo then
    self.seasonType = seasonInfo:GetServerSubdivisionType(false)
  end
end

function UIWorldOutpostCanonPointCtrl:GetAllianceCityData()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local now = UITimeManager:GetInstance():GetServerTime()
  local oneData = {}
  oneData.btnList = {}
  oneData.cityId = self.cityId
  oneData.outpostCityId = self.outpostCityId
  oneData.isInAlliance = false
  oneData.pointId = self.pointId
  oneData.uuid = self.uuid
  oneData.serverId = self.serverId
  oneData.isKingCity = self.isKingCity
  oneData.worldCityType = self.worldCityType
  oneData.meta = self.meta
  oneData.type = self.meta.type
  oneData.mySourceServerId = mySourceServerId
  oneData.seasonType = self.seasonType
  if myAllianceId ~= nil and myAllianceId ~= "" then
    oneData.isInAlliance = true
    oneData.myAllianceId = myAllianceId
  end
  if self.meta then
    oneData.defence_buff = self.meta.defence_buff
  end
  local pointInfo = self.pointInfo or CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if pointInfo ~= nil then
    oneData.pointId = pointInfo.pointIndex
    oneData.uuid = pointInfo.uuid
    oneData.serverId = pointInfo.serverId
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if extraInfo ~= nil then
      oneData.extraInfo = extraInfo
      oneData.state = toInt(extraInfo.state)
      oneData.protectTime = toInt(extraInfo.protectTime)
      oneData.tmpOwnerServerId = toInt(extraInfo.tmpOwnerServerId)
      oneData.battleStartTime = toInt(extraInfo.battleStartTime)
      oneData.lastTowerAttackTime = toInt(extraInfo.lastTowerAttackTime)
      oneData.inProtectMode = now < toInt(oneData.protectTime)
      if oneData.state == 0 then
        oneData.fixActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
      else
        oneData.attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
      end
      if not SeasonUtil.InSourceMapNow() or oneData.type ~= WorldAllianceCityType.CrossZoneOutpostCanon or oneData.state == 0 then
      else
        WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
        local outpostDetailInfo = FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, false)
        local tmpOwnerServerId = extraInfo.tmpOwnerServerId
        local attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
        if outpostDetailInfo ~= nil then
          tmpOwnerServerId = outpostDetailInfo.tmpOwnerServerId
          if outpostDetailInfo.protectTime and oneData.protectTime ~= outpostDetailInfo.protectTime then
            oneData.protectTime = toInt(outpostDetailInfo.protectTime)
            oneData.inProtectMode = now < toInt(oneData.protectTime)
          end
        end
        if oneData.seasonType == SeasonMapType.NineNationRainforest then
          if attackActData == nil or oneData.inProtectMode then
            oneData.inProtectMode = true
          else
            local canJoinBattle = false
            local hasConnCity = SeasonUtil.CheckConnectSwitch(self.cityId, self.serverId, true)
            if hasConnCity or tmpOwnerServerId == mySourceServerId then
              canJoinBattle = true
            end
            if not canJoinBattle then
              oneData.btnList = {}
              return oneData
            end
            local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
            local tmpOwnerCampId = 0
            if tmpOwnerServerId ~= 0 then
              tmpOwnerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(tmpOwnerServerId)
            end
            if tmpOwnerCampId == myCampId then
              oneData.canAssistance = true
              UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.CrossZoneOutpostAssistance)
            else
              if oneData.attackActData ~= nil and tmpOwnerCampId ~= myCampId then
                table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostScout)
                table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostRally)
                table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostAttack)
                oneData.canBattle = true
              end
              if oneData.isInAlliance and oneData.attackActData ~= nil and not oneData.canBattle then
                UIUtil.ShowTipsId(120955)
              end
            end
          end
        elseif oneData.seasonType == SeasonMapType.NineNation then
          local _cityId, _serverId = SeasonUtil.GetOutpostId(mySourceServerId)
          if attackActData == nil or self.serverId ~= _serverId then
            oneData.inProtectMode = true
          elseif tmpOwnerServerId == mySourceServerId then
            oneData.canAssistance = true
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.CrossZoneOutpostAssistance)
          elseif not oneData.inProtectMode then
            local canAttack = SeasonUtil.CheckConnectSwitch(self.cityId, self.serverId)
            if not canAttack and self.cityId == _cityId and self.serverId == _serverId then
              canAttack = true
            end
            if oneData.attackActData ~= nil and canAttack then
              table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostScout)
              table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostRally)
              table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostAttack)
              oneData.canBattle = true
            end
            if oneData.isInAlliance and oneData.attackActData ~= nil and not canAttack then
              UIUtil.ShowTipsId(120955)
            end
          end
        end
      end
    end
  end
  return oneData
end

function UIWorldOutpostCanonPointCtrl:GetAllianceCityDetail()
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId) or {}
  local outpostDetailInfo = FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, false)
  data.cityId = self.cityId
  data.serverId = self.serverId
  if outpostDetailInfo ~= nil then
    data.assistanceList = outpostDetailInfo.assistanceList
    data.maxAssistance = outpostDetailInfo.maxAssistance
    data.currAssistance = outpostDetailInfo.currAssistance
    data.assistanceTotalPower = outpostDetailInfo.assistanceTotalPower
    data.outpostDetailInfo = outpostDetailInfo
  end
  return data
end

function UIWorldOutpostCanonPointCtrl:OnMarkClick(server, point, oname, olv, panelType)
  local share_param = {}
  share_param.sid = self.serverId or server
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  panelType = panelType or MarkGroup.Personal
  share_param.panelType = panelType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf()
end

function UIWorldOutpostCanonPointCtrl:OnShareClick(server, point, oname, uname, olv, alAbbr)
  local share_param = {}
  share_param.sid = self.serverId or server
  share_param.pos = point
  if not string.IsNullOrEmpty(alAbbr) then
    share_param.oname = 311026
    share_param.onameParam1 = alAbbr
    share_param.onameParamKey2 = oname
  else
    share_param.oname = tostring(oname)
  end
  share_param.uname = uname
  share_param.olv = olv
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

return UIWorldOutpostCanonPointCtrl
