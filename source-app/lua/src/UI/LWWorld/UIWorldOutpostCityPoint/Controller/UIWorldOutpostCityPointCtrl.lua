local UIWorldOutpostCityPointCtrl = BaseClass("UIWorldOutpostCityPointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local OutpostOwnerChanged = require("Net.Msgs.Season5.Outpost.PushOutpostOwnerChangedMessage")

function UIWorldOutpostCityPointCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldOutpostCityPoint)
end

function UIWorldOutpostCityPointCtrl:InitData(cityId, pointId, serverId, uuid)
  self.uuid = uuid
  self.cityId = cityId
  self.pointId = pointId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if meta then
    self.meta = meta
    self.isKingCity = meta:IsThroneCity()
    self.worldCityType = meta.type
    self.serverId = meta:GetCurServerId(self.serverId)
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if self.pointInfo ~= nil then
    self.serverId = self.pointInfo.serverId
    if self.pointInfo.buildState == 0 then
      FetchOutpostRepairInfo.GetRepairInfo(self.serverId, self.cityId, true, true)
    else
      FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, true, true)
    end
  end
  local seasonInfo = SeasonUtil.GetSeasonInfo(self.serverId)
  if seasonInfo then
    self.seasonType = seasonInfo:GetServerSubdivisionType(false)
  end
end

function UIWorldOutpostCityPointCtrl:GetAllianceCityData()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local now = UITimeManager:GetInstance():GetServerTime()
  local oneData = {}
  oneData.btnList = {}
  oneData.cityId = self.cityId
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
  local pointInfo = self.pointInfo or CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if pointInfo ~= nil then
    oneData.pointId = pointInfo.pointIndex
    oneData.uuid = pointInfo.uuid
    oneData.serverId = pointInfo.serverId
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if extraInfo ~= nil then
      DataCenter.BuildingOfficialManager:SetOwnerAllianceId(self.serverId, self.cityId, extraInfo.ownerAllianceId)
      oneData.extraInfo = extraInfo
      oneData.state = toInt(extraInfo.state)
      oneData.protectTime = toInt(extraInfo.protectTime)
      oneData.inProtectMode = now < toInt(oneData.protectTime)
      oneData.ownerAllianceId = extraInfo.ownerAllianceId
      if oneData.state == 0 then
        oneData.fixActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
      else
        oneData.attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
      end
      if extraInfo.destroyServerId ~= 0 and extraInfo.destroyAllianceId ~= nil and extraInfo.destroyAllianceId ~= "" then
        oneData.inProtectMode = true
        oneData.isDestroy = true
      elseif SeasonUtil.InSourceMapNow() and oneData.type == WorldAllianceCityType.CrossZoneOutpost then
        local _cityId, _serverId = SeasonUtil.GetOutpostId(mySourceServerId)
        if oneData.state == 0 then
          if oneData.fixActData ~= nil then
            if oneData.seasonType == SeasonMapType.NineNationRainforest then
              local isMyOutpost = DataCenter.SeasonOutpostManager:IsMyOutpost(self.serverId, self.cityId)
              if isMyOutpost then
                table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostFix)
              end
            elseif oneData.seasonType == SeasonMapType.NineNation and _cityId == self.cityId and self.serverId == _serverId then
              table.insert(oneData.btnList, WorldPointBtnType.CrossZoneOutpostFix)
            end
          end
        else
          WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
          local outpostDetailInfo = FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, false)
          local ownerServerId = extraInfo.ownerServerId
          local tmpOwnerServerId = extraInfo.tmpOwnerServerId
          local attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
          if outpostDetailInfo ~= nil then
            ownerServerId = outpostDetailInfo.ownerServerId
            tmpOwnerServerId = outpostDetailInfo.tmpOwnerServerId
            if outpostDetailInfo.protectTime and oneData.protectTime ~= outpostDetailInfo.protectTime then
              oneData.protectTime = toInt(outpostDetailInfo.protectTime)
              oneData.inProtectMode = now < toInt(oneData.protectTime)
            end
          end
          oneData.ownerServerId = ownerServerId
          oneData.tmpOwnerServerId = tmpOwnerServerId
          if oneData.seasonType == SeasonMapType.NineNationRainforest then
            if attackActData == nil or oneData.inProtectMode then
              oneData.inProtectMode = true
            else
              local canJoinBattle = false
              local hasConnCity = SeasonUtil.CheckConnectSwitch(self.cityId, self.serverId, true)
              if hasConnCity or ownerServerId == mySourceServerId or tmpOwnerServerId == mySourceServerId or DataCenter.SeasonAllyFriendManager:IsMyAllianceFriend(oneData.ownerAllianceId) then
                canJoinBattle = true
              end
              if not canJoinBattle then
                oneData.btnList = {}
                return oneData
              end
              local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
              local tmpOwnerCampId = 0
              if tmpOwnerServerId == 0 then
                tmpOwnerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(ownerServerId)
              else
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
            if attackActData == nil or self.serverId ~= _serverId then
              oneData.inProtectMode = true
            elseif tmpOwnerServerId == 0 and ownerServerId == mySourceServerId or tmpOwnerServerId == mySourceServerId then
              oneData.canAssistance = true
              UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.CrossZoneOutpostAssistance)
            elseif not oneData.inProtectMode then
              local canAttack = ownerServerId == mySourceServerId and tmpOwnerServerId ~= mySourceServerId
              if not canAttack and self.cityId == _cityId and self.serverId == _serverId then
                canAttack = true
              end
              canAttack = canAttack or SeasonUtil.CheckConnectSwitch(self.cityId, _serverId, false)
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
  end
  return oneData
end

function UIWorldOutpostCityPointCtrl:GetAllianceCityDetail()
  local outpostRepairInfo, outpostDetailInfo
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId) or {}
  if SeasonUtil.IsOutpost(self.cityId, self.serverId) then
    data.cityId = self.cityId
    data.serverId = self.serverId
    outpostRepairInfo = FetchOutpostRepairInfo.GetRepairInfo(self.serverId, self.cityId, false)
    outpostDetailInfo = FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, false)
  end
  if outpostDetailInfo ~= nil then
    data.assistanceList = outpostDetailInfo.assistanceList
    data.maxAssistance = outpostDetailInfo.maxAssistance
    data.currAssistance = outpostDetailInfo.currAssistance
    data.assistanceTotalPower = outpostDetailInfo.assistanceTotalPower
  end
  data.outpostRepairInfo = outpostRepairInfo
  data.outpostDetailInfo = outpostDetailInfo
  return data
end

function UIWorldOutpostCityPointCtrl:OnMarkClick(server, point, oname, olv, panelType)
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

function UIWorldOutpostCityPointCtrl:OnShareClick(server, point, oname, uname, olv, alAbbr)
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

return UIWorldOutpostCityPointCtrl
