local UIWorldLLCityPointCtrl = BaseClass("UIWorldLLCityPointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldLLCityPoint)
end

function UIWorldLLCityPointCtrl:InitData(cityId, pointId, serverId, uuid)
  self.uuid = uuid
  self.cityId = cityId
  self.pointId = pointId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if meta then
    self.meta = meta
    self.isKingCity = meta.type == WorldAllianceCityType.LLThroneCity or meta.type == WorldAllianceCityType.King
    self.worldCityType = meta.type
    self.serverId = meta:GetCurServerId(self.serverId)
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if self.pointInfo ~= nil then
    self.serverId = self.pointInfo.serverId
  end
end

function UIWorldLLCityPointCtrl:GetAllianceCityData()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local actData = DataCenter.LandlordMgr:GetActData()
  local myCampId = DataCenter.LandlordMgr:GetMyGroup()
  local oneData = {}
  oneData.btnList = {}
  oneData.cityId = self.cityId
  oneData.isInAlliance = false
  oneData.pointId = self.pointId
  oneData.uuid = self.uuid
  oneData.serverId = self.serverId
  oneData.isKingCity = self.isKingCity
  oneData.worldCityType = self.worldCityType
  oneData.type = self.meta.type
  oneData.mySourceServerId = mySourceServerId
  oneData.landlordCityTemplate = self.meta
  if myAllianceId ~= nil and myAllianceId ~= "" then
    oneData.isInAlliance = true
    oneData.myAllianceId = myAllianceId
  end
  local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if pointInfo ~= nil then
    oneData.pointId = pointInfo.pointIndex
    oneData.uuid = pointInfo.uuid
    oneData.serverId = pointInfo.serverId
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if extraInfo ~= nil then
      oneData.extraInfo = extraInfo
      oneData.state = toInt(extraInfo.state)
      oneData.clientState = toInt(extraInfo.curClientState)
      if oneData.type == WorldAllianceCityType.City or oneData.type == WorldAllianceCityType.King or oneData.type == WorldAllianceCityType.CrossZoneOutpost or oneData.type == WorldAllianceCityType.Stronghold or oneData.type == WorldAllianceCityType.Canon or oneData.type == WorldAllianceCityType.CrossZoneOutpostCanon then
        oneData.isOldCity = true
        oneData.clientState = LLConst.LLBuildingState.WillExplode
      end
      oneData.progress = extraInfo.progress
      oneData.progressMax = extraInfo.progressMax
      oneData.fixStartTime = extraInfo.fixStartTime
      oneData.fixEndTime = extraInfo.fixEndTime
      oneData.occupyStartTime = extraInfo.occupyStartTime
      oneData.occupyStartProgress = extraInfo.occupyStartProgress
      oneData.overTime = extraInfo.overTime
      oneData.refreshTime = extraInfo.refreshTime
      oneData.unlockTime = extraInfo.unlockTime
      oneData.buffId = extraInfo.buffId
      oneData.alAbbr = extraInfo.alAbbr
      oneData.alServerId = extraInfo.alServerId
      oneData.actData = actData
      oneData.ownerCampId = extraInfo.ownerCampId or LLConst.LandLordGroup.NONE
      oneData.tmpOwnerCampId = extraInfo.tmpOwnerCampId or LLConst.LandLordGroup.NONE
      oneData.effectId = LLConst.OccupySpeedEffectId[oneData.tmpOwnerCampId]
      oneData.effectValue = 0
      if oneData.effectId and extraInfo.effects and extraInfo.effects:ContainsKey(oneData.effectId) then
        oneData.effectValue = extraInfo.effects[oneData.effectId] or 0
      end
      oneData.myCampEffectId = LLConst.OccupySpeedEffectId[myCampId]
      oneData.myCampEffectValue = 0
      if oneData.myCampEffectId and extraInfo.effects and extraInfo.effects:ContainsKey(oneData.myCampEffectId) then
        oneData.myCampEffectValue = extraInfo.effects[oneData.myCampEffectId] or 0
      end
      local curCampId = self.worldCityType == WorldAllianceCityType.LLBuffCity and oneData.ownerCampId or oneData.tmpOwnerCampId
      if SeasonUtil.InSourceMapNow() then
        if oneData.actData then
          WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
        end
        if actData == nil or self.serverId ~= curServerId or oneData.clientState ~= LLConst.LLBuildingState.Fighting then
          oneData.inProtectMode = self.worldCityType ~= WorldAllianceCityType.LLBuffCity
        elseif curCampId == myCampId and myCampId ~= LLConst.LandLordGroup.NONE then
          oneData.canAssistance = true
          UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.LLAssistanceCity)
        elseif not oneData.inProtectMode then
          local curStage = actData:GetCurStageInfo() and actData:GetCurStageInfo().stage or LLConst.LandlordStage.NONE
          local canAttack = myCampId ~= oneData.tmpOwnerCampId and curStage == LLConst.LandlordStage.BATTLE and DataCenter.LandlordMgr:IsUnlockCityByWeek(self.cityId)
          if oneData.actData ~= nil and canAttack then
            table.insert(oneData.btnList, WorldPointBtnType.LLScoutCity)
            table.insert(oneData.btnList, WorldPointBtnType.LLRallyCity)
            table.insert(oneData.btnList, WorldPointBtnType.LLAttackCity)
            oneData.canBattle = true
          end
        end
      end
    end
  end
  return oneData
end

function UIWorldLLCityPointCtrl:GetAllianceCityDetail()
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId) or {}
  return data
end

function UIWorldLLCityPointCtrl:OnMarkClick(server, point, oname, olv, panelType)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  panelType = panelType or MarkGroup.Personal
  share_param.panelType = panelType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf()
end

function UIWorldLLCityPointCtrl:OnShareClick(server, point, oname, uname, olv, alAbbr)
  local share_param = {}
  share_param.sid = server
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

return UIWorldLLCityPointCtrl
