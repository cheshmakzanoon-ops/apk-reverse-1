local base = UIBaseContainer
local LLMainUIScoreBar = BaseClass("LLMainUIScoreBar", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local REFRESH_CITY_INTERVAL = 3
local MIN_REQUEST_CITY_DETAIL_DIST = 10

function LLMainUIScoreBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIScoreBar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIScoreBar:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.slider = self.viewSkin:AddComponent(self, UISlider, 1)
  self.textSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnLWLandlordMainBattleScoreBar = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnLWLandlordMainBattleScoreBar:SetOnClick(function()
    self:OnBtnLWLandlordMainBattleScoreBarClick()
  end)
  self.compTipsParent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compTimeIcon = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compTime = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compBoomProgress = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compThroneBoomProgress = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.sliderThroneBoomProgress = self.viewSkin:AddComponent(self, UISlider, 11)
  self.textThroneProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgFill = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgThroneFill = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgThroneBg = self.viewSkin:AddComponent(self, UIImage, 15)
  self.compEffArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compArrowBlue = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compArrowRed = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.textEmpty:SetLocalText("zonewar_landlord_limit_1071")
end

function LLMainUIScoreBar:ComponentDestroy()
  self.viewSkin = nil
  self.slider = nil
  self.textSlider = nil
  self.textTime = nil
  self.btnLWLandlordMainBattleScoreBar = nil
  self.compTipsParent = nil
  self.compTimeIcon = nil
  self.compTime = nil
  self.textEmpty = nil
  self.compBoomProgress = nil
  self.compThroneBoomProgress = nil
  self.sliderThroneBoomProgress = nil
  self.textThroneProgress = nil
  self.imgFill = nil
  self.imgThroneFill = nil
  self.imgThroneBg = nil
  self.compEffArrow = nil
  self.compArrowBlue = nil
  self.compArrowRed = nil
end

function LLMainUIScoreBar:DataDefine()
  self.compSpeed = nil
  self.getCityPointInfoCounter = REFRESH_CITY_INTERVAL
  self.centerServerId = DataCenter.LandlordMgr:GetCenterServerId()
end

function LLMainUIScoreBar:DataDestroy()
  self.compSpeed = nil
  self.getCityPointInfoCounter = nil
  self.centerServerId = nil
end

function LLMainUIScoreBar:OnEnable()
  base.OnEnable(self)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local uuid = CS.SceneManager.World:GetLLCityPointUuidInView()
  if uuid and 0 < uuid then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if pointInfo then
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      self:InitLuaData(extraInfo)
    end
  else
    self.curZoneId = CS.SceneManager.GetCurZoneId()
    self:RequestCityDetailInfo()
  end
  self:Refresh()
end

function LLMainUIScoreBar:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordCityPointObjectUpdate, self.OnLandlordCityPointObjectUpdate)
  self:AddUIListener(EventId.WorldZoneTipChanged, self.OnWorldZoneTipChanged)
  self:AddUIListener(EventId.LandlordCityPointInfoUpdateByManual, self.OnLandlordCityPointInfoUpdate)
end

function LLMainUIScoreBar:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordCityPointObjectUpdate, self.OnLandlordCityPointObjectUpdate)
  self:RemoveUIListener(EventId.WorldZoneTipChanged, self.OnWorldZoneTipChanged)
  self:RemoveUIListener(EventId.LandlordCityPointInfoUpdateByManual, self.OnLandlordCityPointInfoUpdate)
  base.OnRemoveListener(self)
end

function LLMainUIScoreBar:ReInit()
  self:Refresh()
end

function LLMainUIScoreBar:Refresh()
  if self.pointInfo then
    if self.pointInfo.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE then
      self:RefreshOccupyingShow()
    else
      self:RefreshNoOccupyShow()
    end
  else
    self:RefreshDefaultShow()
  end
end

function LLMainUIScoreBar:RefreshDefaultShow()
  self.compEffArrow:SetActive(false)
  self.compTime:SetActive(false)
  self.compBoomProgress:SetActive(false)
  self.compThroneBoomProgress:SetActive(false)
  self.textEmpty:SetActive(true)
end

function LLMainUIScoreBar:RefreshNoOccupyShow()
  self.compEffArrow:SetActive(false)
  self.compTime:SetActive(true)
  self.compThroneBoomProgress:SetActive(self.pointInfo.isThrone)
  self.compBoomProgress:SetActive(not self.pointInfo.isThrone)
  self.textEmpty:SetActive(false)
  if self.pointInfo.isThrone then
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    local isMeLord = myCampId == LLConst.LandLordGroup.LORD
    self.imgThroneFill:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_RED or LLConst.THRONE_CITY_FILL_IMG_BLUE)
    self.imgThroneBg:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_BLUE or LLConst.THRONE_CITY_FILL_IMG_RED)
    self.sliderThroneBoomProgress:SetValue(self.pointInfo.progress / self.pointInfo.progressMax)
    self.textThroneProgress:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(self.pointInfo.progress), string.GetFormattedSeparatorNum(self.pointInfo.progressMax)))
  else
    self.imgFill:LoadSpriteAuto(LLConst.NORMAL_CITY_FILL_IMG_RED)
    self.slider:SetValue(self.pointInfo.progress / self.pointInfo.progressMax)
    self.textSlider:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(self.pointInfo.progress), string.GetFormattedSeparatorNum(self.pointInfo.progressMax)))
  end
  local isNotOpen = self.pointInfo.clientState == LLConst.LLBuildingState.NotOpen or self.pointInfo.clientState == LLConst.LLBuildingState.OpenButShield
  local isRuin = self.pointInfo.clientState == LLConst.LLBuildingState.Ruins
  local timeIconActive = true
  if isNotOpen then
    timeIconActive = false
    self.textTime:SetLocalText("zonewar_landlord_limit_1045")
  elseif isRuin then
    timeIconActive = false
    self.textTime:SetLocalText("zonewar_landlord_limit_1017")
  else
    timeIconActive = true
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local stageEndTime = DataCenter.LandlordMgr:GetActCurStageInfo() and DataCenter.LandlordMgr:GetActCurStageInfo().eTime or 0
    if DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE then
      self.textTime:SetText(DataCenter.LandlordMgr:SecondToFmtString((stageEndTime * 1000 - curTime) / 1000))
    else
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(stageEndTime * 1000 - curTime))
    end
  end
  self.compTimeIcon:SetActive(timeIconActive)
end

function LLMainUIScoreBar:RefreshOccupyingShow()
  self.compEffArrow:SetActive(true)
  self.compThroneBoomProgress:SetActive(self.pointInfo.isThrone)
  self.compBoomProgress:SetActive(not self.pointInfo.isThrone)
  self.compTime:SetActive(true)
  self.textEmpty:SetActive(false)
  self.compTimeIcon:SetActive(true)
  local myCampId = DataCenter.LandlordMgr:GetMyGroup()
  local isMeLord = myCampId == LLConst.LandLordGroup.LORD
  local isMyCity = myCampId == self.pointInfo.tmpOwnerCampId
  local curProgress, remainTime = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.pointInfo.occupyStartTime, self.pointInfo.occupyStartProgress, self.pointInfo.progressMax, self.pointInfo.tmpOwnerCampId, self.pointInfo.extraEffectValue, self.pointInfo.isThrone)
  local isBlue = false
  local flip = 1
  if self.pointInfo.isThrone then
    isBlue = not isMeLord
    flip = 1
    self.imgThroneFill:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_RED or LLConst.THRONE_CITY_FILL_IMG_BLUE)
    self.imgThroneBg:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_BLUE or LLConst.THRONE_CITY_FILL_IMG_RED)
    self.sliderThroneBoomProgress:SetValue(curProgress / self.pointInfo.progressMax)
    self.textThroneProgress:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(curProgress), string.GetFormattedSeparatorNum(self.pointInfo.progressMax)))
  else
    isBlue = isMyCity
    flip = -1
    self.imgFill:LoadSpriteAuto(isMyCity and LLConst.NORMAL_CITY_FILL_IMG_BLUE or LLConst.NORMAL_CITY_FILL_IMG_RED)
    self.slider:SetValue(curProgress / self.pointInfo.progressMax)
    self.textSlider:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(curProgress), string.GetFormattedSeparatorNum(self.pointInfo.progressMax)))
  end
  self.compArrowBlue:SetActive(isBlue)
  self.compArrowBlue:SetLocalScaleXYZ(1 * flip, 1, 1)
  self.compArrowRed:SetActive(not isBlue)
  self.compArrowRed:SetLocalScaleXYZ(1 * flip, 1, 1)
  self.textTime:SetText(DataCenter.LandlordMgr:SecondToFmtString(remainTime))
end

function LLMainUIScoreBar:Update1000MS()
  self:Refresh()
  self.getCityPointInfoCounter = self.getCityPointInfoCounter - 1
  if self.getCityPointInfoCounter <= 0 then
    self.getCityPointInfoCounter = REFRESH_CITY_INTERVAL
    self:RequestCityDetailInfo()
  end
end

function LLMainUIScoreBar:OnLandlordCityPointObjectUpdate(uuid)
  if uuid and 0 < uuid and LuaEntry.Player:GetCurServerId() == self.centerServerId then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if pointInfo and pointInfo.cityId == self.curZoneId then
      self.getCityPointInfoCounter = REFRESH_CITY_INTERVAL
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      self:InitLuaData(extraInfo)
    end
  end
  self:Refresh()
end

function LLMainUIScoreBar:InitLuaData(extraInfo)
  self.pointInfo = self.pointInfo or {}
  self.pointInfo.uuid = extraInfo.uuid
  self.pointInfo.cityId = extraInfo.cityId
  self.pointInfo.isThrone = extraInfo.type == WorldAllianceCityType.LLThroneCity
  self.pointInfo.state = toInt(extraInfo.state)
  self.pointInfo.clientState = toInt(extraInfo.curClientState)
  self.pointInfo.progress = extraInfo.progress
  self.pointInfo.progressMax = extraInfo.progressMax
  self.pointInfo.fixStartTime = extraInfo.fixStartTime
  self.pointInfo.fixEndTime = extraInfo.fixEndTime
  self.pointInfo.occupyStartTime = extraInfo.occupyStartTime
  self.pointInfo.occupyStartProgress = extraInfo.occupyStartProgress
  self.pointInfo.overTime = extraInfo.overTime
  self.pointInfo.refreshTime = extraInfo.refreshTime
  self.pointInfo.buffId = extraInfo.buffId
  self.pointInfo.ownerCampId = extraInfo.ownerCampId
  self.pointInfo.tmpOwnerCampId = extraInfo.tmpOwnerCampId
  if extraInfo.pointIndex then
    self.pointInfo.pointIndex = extraInfo.pointIndex
  end
  self.curZoneId = tonumber(extraInfo.cityId)
  self.pointInfo.extraEffectValue = 0
  local effectId = LLConst.OccupySpeedEffectId[self.pointInfo.tmpOwnerCampId]
  if effectId and extraInfo.effects and extraInfo.effects:ContainsKey(effectId) then
    self.pointInfo.extraEffectValue = extraInfo.effects[effectId] or 0
  elseif effectId and extraInfo.effect then
    self.pointInfo.extraEffectValue = extraInfo.effect[effectId] or 0
  end
  local myCampEffectId = LLConst.OccupySpeedEffectId[DataCenter.LandlordMgr:GetMyGroup()]
  if myCampEffectId and extraInfo.effects and extraInfo.effects:ContainsKey(myCampEffectId) then
    self.pointInfo.myCampExtraEffectValue = extraInfo.effects[myCampEffectId] or 0
  elseif myCampEffectId and extraInfo.effect then
    self.pointInfo.myCampExtraEffectValue = extraInfo.effect[myCampEffectId] or 0
  end
end

function LLMainUIScoreBar:OnBtnLWLandlordMainBattleScoreBarClick()
  if self.pointInfo then
    local curZoom = CS.SceneManager.World.Zoom or CS.SceneManager.World.InitZoom
    if curZoom <= 0 then
      curZoom = CS.SceneManager.World.InitZoom
    end
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(self.pointInfo.pointIndex, ForceChangeScene.World, DataCenter.LandlordMgr:GetCenterServerId()), curZoom, nil, nil, DataCenter.LandlordMgr:GetCenterServerId())
  end
end

function LLMainUIScoreBar:OnWorldZoneTipChanged(zoneId)
  if zoneId then
    if tonumber(zoneId) == 0 then
      self:OnLandlordEnterEmptyWorldZone()
    elseif self.curZoneId ~= tonumber(zoneId) and LuaEntry.Player:GetCurServerId() == self.centerServerId then
      self.curZoneId = tonumber(zoneId)
      self.getCityPointInfoCounter = REFRESH_CITY_INTERVAL
      self:RequestCityDetailInfo()
    end
  end
end

function LLMainUIScoreBar:RequestCityDetailInfo()
  if not (LuaEntry.Player:GetCurServerId() == self.centerServerId and self.curZoneId) or self.curZoneId == 0 then
    return
  end
  if not DataCenter.LandlordMgr:IsInMyServerGroup() then
    return
  end
  if DataCenter.LandlordMgr:GetActCurStage() ~= LLConst.LandlordStage.BATTLE then
    return
  end
  if self.pointInfo and self.pointInfo.clientState ~= LLConst.LLBuildingState.Fighting then
    return
  end
  if self.pointInfo and self.pointInfo.pointIndex then
    local curPos = CS.SceneManager.World.CurTarget
    if curPos then
      local curTile = SceneUtils.WorldToTile(curPos)
      local tarTile = SceneUtils.IndexToTilePos(self.pointInfo.pointIndex, ForceChangeScene.World)
      if curTile and tarTile then
        local dist = math.floor(Vector2.Distance(curTile, tarTile))
        SceneUtils.ReturnPoolV2(curTile)
        SceneUtils.ReturnPoolV2(tarTile)
        if dist < MIN_REQUEST_CITY_DETAIL_DIST then
          return
        end
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.LandlordGetCityPointInfo, self.centerServerId, self.curZoneId)
end

function LLMainUIScoreBar:OnLandlordCityPointInfoUpdate(msg)
  if not msg then
    return
  end
  if msg.cityId == self.curZoneId and msg.pointData then
    local extraInfo = PBController.ParsePbFromBytes(msg.pointData, "protobuf.WorldPointInfo")
    if extraInfo and extraInfo.zwlBuilding then
      self:InitLuaData(extraInfo.zwlBuilding)
      self.pointInfo.pointIndex = extraInfo.id
      self.pointInfo.clientState = DataCenter.LandlordMgr:DeriveState(extraInfo.zwlBuilding)
      self:Refresh()
    end
  end
end

function LLMainUIScoreBar:OnLandlordEnterEmptyWorldZone()
  self.curZoneId = nil
  self.pointInfo = nil
  self:Refresh()
end

return LLMainUIScoreBar
