local UIWorldLLCanonPointCtrl = BaseClass("UIWorldLLCanonPointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIWorldLLCanonPointCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldLLCanonPoint)
end

function UIWorldLLCanonPointCtrl:InitData(cityId, pointId, serverId, uuid)
  self.uuid = uuid
  self.cityId = cityId
  self.pointId = pointId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if meta then
    self.meta = meta
    self.worldCityType = meta.type
    self.belongCityId = self.meta.belong_city_id
    self.serverId = meta:GetCurServerId(self.serverId)
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if self.pointInfo ~= nil then
    self.serverId = self.pointInfo.serverId
    DataCenter.ZoneWarManager:UpdateBatteryFireTime(cityId, self.pointInfo.lastTowerAttackTime)
  end
end

function UIWorldLLCanonPointCtrl:GetAllianceCityData()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local myCampId = DataCenter.LandlordMgr:GetMyGroup()
  local actData = DataCenter.LandlordMgr:GetActData()
  local oneData = {}
  oneData.btnList = {}
  oneData.cityId = self.cityId
  oneData.isInAlliance = false
  oneData.pointId = self.pointId
  oneData.uuid = self.uuid
  oneData.serverId = self.serverId
  oneData.worldCityType = self.worldCityType
  oneData.meta = self.meta
  oneData.type = self.worldCityType
  oneData.mySourceServerId = mySourceServerId
  oneData.battleStartTime = actData and actData:GetNextBattleStartTime() * 1000 or 0
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
      oneData.ownerCampId = toInt(extraInfo.ownerCampId)
      oneData.fireTime = extraInfo.fireTime
      oneData.actData = actData
      if SeasonUtil.InSourceMapNow() then
        if oneData.actData then
          WorldBattleUtil.TryRequestCityInfo(self.cityId, self.serverId)
        end
        if oneData.state ~= LLConst.ZWLBuildingState.NORMAL then
        else
          local ownerCampId = extraInfo.ownerCampId
          if actData == nil or self.serverId ~= LuaEntry.Player:GetCurServerId() then
            oneData.inProtectMode = true
          elseif ownerCampId == myCampId and myCampId ~= LLConst.LandLordGroup.NONE then
            oneData.canAssistance = true
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.LLAssistanceCity)
          elseif not oneData.inProtectMode then
            local curStage = actData:GetCurStageInfo() and actData:GetCurStageInfo().stage or LLConst.LandlordStage.NONE
            local canAttack = myCampId ~= ownerCampId and curStage == LLConst.LandlordStage.BATTLE and DataCenter.LandlordMgr:IsUnlockCityByWeek(self.cityId)
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
  end
  return oneData
end

function UIWorldLLCanonPointCtrl:GetAllianceCityDetail()
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId) or {}
  return data
end

function UIWorldLLCanonPointCtrl:OnMarkClick(server, point, oname, olv, panelType)
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

function UIWorldLLCanonPointCtrl:OnShareClick(server, point, oname, uname, olv, alAbbr)
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

return UIWorldLLCanonPointCtrl
