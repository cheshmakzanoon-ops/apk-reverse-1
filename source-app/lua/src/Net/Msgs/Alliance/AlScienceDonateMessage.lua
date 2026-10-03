local AlScienceDonateMessage = BaseClass("AlScienceDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local alScienceDonateBtnPos, alScienceDonateTechPointPos

local function OnCreate(self, scienceId, option, btnPos, techPointPos)
  base.OnCreate(self)
  self.sfsObj:PutInt("scienceId", scienceId)
  self.sfsObj:PutInt("option", option)
  alScienceDonateBtnPos = btnPos
  alScienceDonateTechPointPos = techPointPos
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.alliancepoint ~= nil then
      local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if data ~= nil then
        data.alliancePoint = t.alliancepoint
      end
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint, alScienceDonateBtnPos)
    end
    if t.criticalHitRatio then
      local ratio = tonumber(t.criticalHitRatio)
      if 0 < ratio then
        local param = {}
        param.type = 2
        param.ratio = ratio
        EventManager:GetInstance():Broadcast(EventId.ShowAlScienceCriticalHitRatio, param)
      end
    end
    DataCenter.AllianceScienceDataManager:EndRefreshAllScienceNum(t)
    DataCenter.AllianceScienceDataManager:UpdateOneAllianceScience(t)
    if alScienceDonateBtnPos ~= nil and alScienceDonateTechPointPos ~= nil then
      local iconPath3 = DataCenter.ItemTemplateManager:GetAllianceItemIconPath(RewardType.ALLIANCE_SCIENCE_TECH_POINT)
      UIUtil.DoFly(7, 3, iconPath3, alScienceDonateBtnPos, alScienceDonateTechPointPos)
      alScienceDonateBtnPos = nil
      alScienceDonateTechPointPos = nil
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
    if t.todayProgress then
      EventManager:GetInstance():Broadcast(EventId.AllianceCurrentDonatePointUpdate, t.todayProgress)
    end
  end
end

AlScienceDonateMessage.OnCreate = OnCreate
AlScienceDonateMessage.HandleMessage = HandleMessage
return AlScienceDonateMessage
