local UIKingBtn = BaseClass("UIKingBtn", UIBaseContainer)
local base = UIBaseContainer

function UIKingBtn:RefreshShowState()
  self.previewEndTime = nil
  if self:CheckLLOpen() then
    self:RefreshShowStateLL()
    return
  end
  self.llStage = nil
  self.llETime = 0
  if DataCenter.ZoneWarManager.configSchedulePreview ~= nil then
    local startTime = DataCenter.ZoneWarManager.configSchedulePreview.startTime
    local endTime = DataCenter.ZoneWarManager.configSchedulePreview.endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if startTime ~= nil and endTime ~= nil and endTime > curTime then
      self.previewEndTime = startTime
      self:SetActive(true)
      self:RefreshImg(false)
      self.redPoint:SetActive(false)
      self:Update1000MS()
    else
      self:SetActive(false)
      self.redPoint:SetActive(false)
      DataCenter.ZoneWarManager.configSchedulePreview = nil
    end
  elseif DataCenter.ZoneWarManager:CheckShowMainUIBtn() then
    self:SetActive(true)
    self:RefreshImg(false)
    self.actData = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    self.btnText:SetLocalText(self.actData and self.actData.cfg and self.actData.cfg.name or "801407")
    self:CheckRedPoint()
  else
    self:SetActive(false)
    self.redPoint:SetActive(false)
  end
end

function UIKingBtn:OnBtnClick()
  if self:CheckLLOpen() then
    self:OnBtnClickLL()
    return
  end
  local mgr = DataCenter.ZoneWarManager
  if mgr.configSchedulePreview ~= nil then
    UIUtil.ShowTipsId("season_tips231")
    local cfg = mgr.configSchedulePreview.cfg
    if cfg and cfg.plot then
      local plotId = toInt(cfg.plot)
      local key = string.format("CrossKingPlot_%s_%s", toInt(cfg.id), plotId)
      local alreadyShownPlot = Setting:GetPrivateBool(key, false)
      if alreadyShownPlot then
      else
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = true})
        Setting:SetPrivateBool(key, true)
      end
    end
    if self.previewEndTime == nil then
      mgr:InitData()
    end
  elseif mgr:CheckShowMainUIBtn() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif mgr:IsOver() then
    self:SetActive(false)
    self.redPoint:SetActive(false)
    UIUtil.ShowTipsId("458272")
  end
end

function UIKingBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.CheckRedPoint)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.OnRoundInfoRefresh)
  self:AddUIListener(EventId.CrossKingRoundInfoNowRefresh, self.OnRoundInfoRefresh)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.RefreshShowState)
  if SeasonUtil.IsInSeasonDarknessMode() then
    self:AddUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.CheckRedPoint)
    self:AddUIListener(EventId.SaveOwnPositionId, self.CheckRedPoint)
  end
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.RefreshShowState)
  self:AddUIListener(EventId.LandlordRedRefresh, self.CheckRedPoint)
end

function UIKingBtn:OnDestroy()
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.CheckRedPoint)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.OnRoundInfoRefresh)
  self:RemoveUIListener(EventId.CrossKingRoundInfoNowRefresh, self.OnRoundInfoRefresh)
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.RefreshShowState)
  if SeasonUtil.IsInSeasonDarknessMode() then
    self:RemoveUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.CheckRedPoint)
    self:RemoveUIListener(EventId.SaveOwnPositionId, self.CheckRedPoint)
  end
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.RefreshShowState)
  self:RemoveUIListener(EventId.LandlordRedRefresh, self.CheckRedPoint)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIKingBtn:OnRoundInfoRefresh()
  if self:CheckLLOpen() then
    return
  end
  if DataCenter.ZoneWarManager:IsOver() then
    self:SetActive(false)
    self.redPoint:SetActive(false)
  end
end

function UIKingBtn:CheckRedPoint()
  if not self.activeSelf then
    return
  end
  if self:CheckLLOpen() then
    self:CheckRedPointLL()
    return
  end
  local hasRedPoint = DataCenter.ZoneWarManager:HasRedPoint()
  if not hasRedPoint and self.actData and self.actData.configNow and self.actData.configNow.type == ServerBattleType.VSCamp and SeasonUtil.IsInSeasonDarknessMode() then
    hasRedPoint = DataCenter.CampWarManager:HasRedPoint()
  end
  self.redPoint:SetActive(hasRedPoint)
end

function UIKingBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "Bg")
  self.btnText = self:AddComponent(UIText, "BtnText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.redPoint = self:AddComponent(UIBaseComponent, "RedPoint")
  self.btnText:SetLocalText("801407")
end

function UIKingBtn:ComponentDestroy()
  self.actData = nil
  self.bg = nil
  self.btnText = nil
  self.btn = nil
  self.redPoint = nil
end

function UIKingBtn:Update1000MS()
  if self.previewEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.previewEndTime - curTime
    if 0 < deltaTime then
      self.btnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.previewEndTime = nil
      self.btnText:SetLocalText("372617")
    end
  end
  self:RefreshLLBtnTxt()
end

function UIKingBtn:RefreshImg(bLL)
  local path
  if bLL then
    path = string.format(LoadPath.LandlordPath, "lrb_jinmai_rukou.png")
  else
    path = string.format(LoadPath.LWMainUINew, "lrb_zhanqvduizhan_tubiao.png")
  end
  self.bg:LoadSpriteAuto(path)
end

function UIKingBtn:CheckLLOpen()
  local llData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActLandlord.Type)
  local isInMyServerGroup = DataCenter.LandlordMgr:IsInMyServerGroup()
  if llData and isInMyServerGroup then
    return true
  end
  return false
end

function UIKingBtn:RefreshShowStateLL()
  local curStage = DataCenter.LandlordMgr:GetActCurStage()
  if curStage ~= LLConst.LandlordStage.NONE then
    self:SetActive(true)
    self.btnText:SetLocalText("zonewar_landlord_tittle_10016")
    self:RefreshImg(true)
    self:CheckRedPointLL()
    self:RefreshActivityTimeCheck()
  else
    self.llStage = nil
    self.llETime = 0
    self:SetActive(false)
    self.redPoint:SetActive(false)
  end
end

function UIKingBtn:OnBtnClickLL()
  local curStage = DataCenter.LandlordMgr:GetActCurStage()
  if curStage ~= LLConst.LandlordStage.NONE then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILandlordMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    self:SetActive(false)
    self.redPoint:SetActive(false)
    UIUtil.ShowTipsId("458272")
  end
end

function UIKingBtn:CheckRedPointLL()
  local hasRedPoint = DataCenter.LandlordMgr:CheckRed()
  self.redPoint:SetActive(hasRedPoint)
end

function UIKingBtn:RefreshActivityTimeCheck()
  local actData = DataCenter.LandlordMgr:GetActData()
  local curStageInfo = actData ~= nil and actData:GetCurStageInfo() or nil
  local stage = curStageInfo ~= nil and curStageInfo.stage or nil
  if stage == LLConst.LandlordStage.PREPARE or stage == LLConst.LandlordStage.BATTLE then
    self.llETime = curStageInfo.eTime or 0
    self.llStage = stage
    self:RefreshLLBtnTxt()
  else
    self.llStage = nil
    self.llETime = 0
    self:SetLLBtnTxtDefault()
  end
end

function UIKingBtn:SetLLBtnTxtDefault()
  self.btnText:SetLocalText("zonewar_landlord_tittle_10016")
end

function UIKingBtn:RefreshLLBtnTxt()
  if self.llStage == nil then
    return
  end
  local remain = 0
  local needRefresh = false
  if self.llStage == LLConst.LandlordStage.PREPARE then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    remain = self.llETime - curSec
    if remain <= 0 then
      remain = 0
      self.llStage = nil
      self.llETime = 0
      needRefresh = true
    elseif remain > OneHourTime then
      remain = 0
      self:SetLLBtnTxtDefault()
    end
  elseif self.llStage == LLConst.LandlordStage.BATTLE then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    remain = self.llETime - curSec
    if remain <= 0 then
      remain = 0
      self.llStage = nil
      self.llETime = 0
      needRefresh = true
    end
  end
  if 0 < remain then
    self.btnText:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remain))
  end
  if needRefresh then
    self:RefreshActivityTimeCheck()
  end
end

return UIKingBtn
