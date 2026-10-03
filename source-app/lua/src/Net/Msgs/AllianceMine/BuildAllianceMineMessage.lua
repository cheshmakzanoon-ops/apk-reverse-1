local BuildAllianceMineMessage = BaseClass("BuildAllianceMineMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, pointId, buildId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutInt("buildId", buildId)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season4_build_tips01" then
      local leftTime = t.leftTime
      if leftTime then
        local now = UITimeManager:GetInstance():GetServerTime()
        local txt = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        local theActiveBuildId, theActiveBuildCD = DataCenter.AllianceMineManager:GetLastActiveBuildInfo()
        UIUtil.ShowTips(Localization:GetString("season4_build_tips01", txt))
        DataCenter.AllianceMineManager:SetBuildIdActive(theActiveBuildId, leftTime + now - 3000)
      else
        UIUtil.ShowTipsId("100381")
      end
    elseif errCode == "season4_tips002" then
      local center_distance = t.center_distance
      if center_distance == nil then
        local infoServer = DataCenter.SeasonDataManager:GetServerSeasonInfo()
        if infoServer then
          local cfg = infoServer:GetCurrentSeasonConfig()
          if cfg then
            center_distance = toInt(cfg.center_distance) - 4 - 4
          end
        end
      end
      if toInt(center_distance) <= 0 then
        center_distance = 3
      end
      UIUtil.ShowTips(Localization:GetString("season4_tips002", center_distance))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.GetAllAllianceMineList, false)
  end
end

BuildAllianceMineMessage.OnCreate = OnCreate
BuildAllianceMineMessage.HandleMessage = HandleMessage
return BuildAllianceMineMessage
