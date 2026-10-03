local UISubWayItem = BaseClass("UISubWayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UISubWayItem:OnCreate()
  base.OnCreate(self)
  self._name_txt = self:AddComponent(UIText, "Txt_name")
  self._dirStart_txt = self:AddComponent(UIText, "Rect_Dir/ImageHole/Txt_StartPos")
  self._dirTarget_txt = self:AddComponent(UIText, "Rect_Dir/ImageHole/Txt_TargetPos")
  self._imgHole = self:AddComponent(UIBaseContainer, "Rect_Dir/ImageHole")
  self._imgMove = self:AddComponent(UIBaseContainer, "Rect_Dir/ImageMove")
  self._dirDes_txt = self:AddComponent(UIText, "Rect_Dir/ImageMove/Txt_des")
  self._endTime_txt = self:AddComponent(UIText, "Rect_Dir/Txt_EndTime")
  self._troopsNum_txt = self:AddComponent(UIText, "Rect_Troops/Rect_TroopsInfo/Rect_TroopsNum/Txt_TroopsNum")
  self._troopsPower_txt = self:AddComponent(UIText, "Rect_Troops/Rect_TroopsInfo/Rect_TroopsPower/Txt_TroopsPower")
  self._timer_march = nil
  
  function self._timer_action(temp)
    self:UpdateMarchTime()
  end
end

function UISubWayItem:OnDestroy()
  self:DeleteMarchTimer()
  base.OnDestroy(self)
end

function UISubWayItem:OnEnable()
  base.OnEnable(self)
end

function UISubWayItem:OnDisable()
  base.OnDisable(self)
end

function UISubWayItem:RefreshData(march)
  self:DeleteMarchTimer()
  self.data = self.view.ctrl:GetMarchData(march.uuid, march.ownerFormationUuid)
  if self.data ~= nil then
    self._name_txt:SetText(Localization:GetString("300621", self.data.index))
    self._troopsNum_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.curSoldierNum)))
    self._troopsPower_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.power)))
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.data.targetUuid)
    if buildData ~= nil then
      local buildId = buildData.itemId
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if (self.data.targetType == MarchTargetType.GO_WORM_HOLE or self.data.targetType == MarchTargetType.CROSS_SERVER_WORM) and self.data.status ~= MarchStatus.IN_WORM_HOLE and self.data.status ~= MarchStatus.CROSS_SERVER then
        self._imgHole:SetActive(false)
        self._imgMove:SetActive(true)
        if self.data.targetType == MarchTargetType.CROSS_SERVER_WORM then
          local startTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
          if startTemplate ~= nil then
            self._dirDes_txt:SetText(Localization:GetString("140047") .. ": " .. Localization:GetString(startTemplate.name))
          end
        elseif buildTemplate ~= nil then
          self._dirDes_txt:SetText(Localization:GetString("140047") .. ": " .. Localization:GetString(buildTemplate.name))
        end
      else
        self._imgHole:SetActive(true)
        self._imgMove:SetActive(false)
        if buildTemplate ~= nil then
          self._dirTarget_txt:SetText(Localization:GetString(buildTemplate.name))
        end
        if buildId == BuildingTypes.FUN_BUILD_MAIN then
          local startBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
          if startBuildData ~= nil then
            local startTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
            if startTemplate ~= nil then
              self._dirStart_txt:SetText(Localization:GetString(startTemplate.name))
            end
          end
        elseif buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildId == BuildingTypes.WORM_HOLE_CROSS then
          local startBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
          if startBuildData ~= nil then
            local startTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
            if startTemplate ~= nil then
              self._dirStart_txt:SetText(Localization:GetString(startTemplate.name))
            end
          end
        end
      end
    end
    self:AddMarchTimer()
    self:UpdateMarchTime()
  end
end

function UISubWayItem:AddMarchTimer()
  if self._timer_march == nil then
    self._timer_march = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
    self._timer_march:Start()
  end
end

function UISubWayItem:DeleteMarchTimer()
  if self._timer_march ~= nil then
    self._timer_march:Stop()
    self._timer_march = nil
  end
end

function UISubWayItem:UpdateMarchTime()
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  deltaTime = self.data.endTime - curTime
  if deltaTime <= 0 then
    self:DeleteMarchTimer()
    self._endTime_txt:SetText(Localization:GetString("110209"))
  else
    self._endTime_txt:SetText(Localization:GetString("302217", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
  end
end

return UISubWayItem
