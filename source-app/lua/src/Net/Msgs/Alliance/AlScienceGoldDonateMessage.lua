local AlScienceGoldDonateMessage = BaseClass("AlScienceGoldDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local alScienceDonateBtnPos, alScienceDonateTechPointPos

local function OnCreate(self, scienceId, btnPos, techPointPos)
  base.OnCreate(self)
  self.sfsObj:PutInt("scienceId", scienceId)
  alScienceDonateBtnPos = btnPos
  alScienceDonateTechPointPos = techPointPos
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.gold then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
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
      if 1 < ratio then
        local param = {}
        param.type = 1
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

AlScienceGoldDonateMessage.OnCreate = OnCreate
AlScienceGoldDonateMessage.HandleMessage = HandleMessage
return AlScienceGoldDonateMessage
