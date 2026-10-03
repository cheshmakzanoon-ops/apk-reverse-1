local base = UIAsyncContainer
local SeasonCampDestroyIdleDay = BaseClass("SeasonCampDestroyIdleDay", base)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyIdleDay:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyIdleDay:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyIdleDay:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textPOutWarDayDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPOutWarDayTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPOutWarDayDesc:SetLocalText("season_s5_activity_1200059_desc16")
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
end

function SeasonCampDestroyIdleDay:ComponentDestroy()
  self.viewSkin = nil
  self.textRemainTime = nil
  self.textPOutWarDayDesc = nil
  self.textPOutWarDayTime = nil
end

function SeasonCampDestroyIdleDay:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
end

function SeasonCampDestroyIdleDay:DataDestroy()
  self.mgr = nil
end

function SeasonCampDestroyIdleDay:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyIdleDay:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyIdleDay:Refresh()
  if not self.mgr then
    return
  end
  local timeInfo = self.mgr:GetTimeInfo()
  if timeInfo.currentBattleStage ~= SeasonCampDestroyStage.Idle then
    return
  end
  local start = timeInfo and timeInfo.warStart or 0
  local leftTime = math.max(0, start - UITimeManager:GetInstance():GetServerTime())
  self.textPOutWarDayTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

function SeasonCampDestroyIdleDay:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function SeasonCampDestroyIdleDay:OnDisable()
  base.OnDisable(self)
end

function SeasonCampDestroyIdleDay:Update1000MS()
  self:Refresh()
end

return SeasonCampDestroyIdleDay
