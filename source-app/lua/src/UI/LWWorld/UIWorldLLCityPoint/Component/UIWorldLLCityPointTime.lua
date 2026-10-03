local base = UIBaseContainer
local UIWorldLLCityPointTime = BaseClass("UIWorldLLCityPointTime", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointTime:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointTime:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointTime:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
end

function UIWorldLLCityPointTime:ComponentDestroy()
  self.viewSkin = nil
  self.textRewardTips = nil
end

function UIWorldLLCityPointTime:DataDefine()
end

function UIWorldLLCityPointTime:DataDestroy()
end

function UIWorldLLCityPointTime:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
end

function UIWorldLLCityPointTime:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointTime:Refresh(data)
  if self.activeSelf then
    self.data = data
    self.timeKey = ""
    self.endTime = nil
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    local isHaveAct = DataCenter.LandlordMgr:GetActData()
    if not isHaveAct then
      self.textRewardTips:SetLocalText("370100")
      return
    end
    if self.data.clientState == LLConst.LLBuildingState.Fighting then
      if self.data.tmpOwnerCampId == LLConst.LandLordGroup.NONE then
        self.timeKey = "zonewar_landlord_limit_1032"
        self.endTime = DataCenter.LandlordMgr:GetActCurStageInfo() and DataCenter.LandlordMgr:GetActCurStageInfo().eTime * 1000 or 0
      else
        local template = DataCenter.LandlordMgr:GetCityTemplate(self.data.cityId)
        local isThroneCity = template ~= nil and template:IsLLThroneCity()
        self.curProgress, self.remainTime = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.data.occupyStartTime, self.data.occupyStartProgress, self.data.progressMax, self.data.tmpOwnerCampId, self.data.effectValue, isThroneCity)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if myCampId == LLConst.LandLordGroup.LORD and self.data.tmpOwnerCampId == LLConst.LandLordGroup.LORD and self.curProgress == 0 then
          self.textRewardTips:SetLocalText("zonewar_landlord_limit_1079")
        else
          self.timeKey = self.data.tmpOwnerCampId == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1078" or "zonewar_landlord_limit_1077"
          self.endTime = curTime + self.remainTime * 1000
        end
      end
    elseif self.data.clientState == LLConst.LLBuildingState.WillExplode then
      self.textRewardTips:SetLocalText(self.data.isOldCity and "zonewar_landlord_limit_1033" or "zonewar_landlord_limit_1080")
    elseif self.data.clientState == LLConst.LLBuildingState.Rebuilding then
      self.timeKey = "zonewar_landlord_limit_1066"
      self.endTime = self.data.fixEndTime
    elseif self.data.clientState == LLConst.LLBuildingState.NotOpen then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local curWeekBattleEndTime = DataCenter.LandlordMgr:GetWeekBattleEndTime(DataCenter.LandlordMgr:GetCurWeek()) or 0
      self.timeKey = curTime > curWeekBattleEndTime and DataCenter.LandlordMgr:GetCurWeek() == 3 and "zonewar_landlord_limit_1032" or "zonewar_landlord_limit_1031"
      local isUnlockWeek = DataCenter.LandlordMgr:IsUnlockCityByWeek(self.data.cityId)
      if not isUnlockWeek then
        local unlockWeek = DataCenter.LandlordMgr:GetCityUnlockWeek(self.data.cityId)
        self.endTime = DataCenter.LandlordMgr:GetWeekBattleStartTime(unlockWeek) * 1000
      else
        self.endTime = DataCenter.LandlordMgr:GetNextBattleStartTime() * 1000
      end
    elseif self.data.clientState == LLConst.LLBuildingState.OpenButShield then
      self.timeKey = "zonewar_landlord_limit_1031"
      self.endTime = self.data.unlockTime
    end
    self:Update1000MS()
  end
end

function UIWorldLLCityPointTime:Update1000MS()
  if self.data and self.endTime then
    local endTime = self.endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(endTime - curTime, 0)
    self.textRewardTips:SetLocalText(self.timeKey, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

return UIWorldLLCityPointTime
