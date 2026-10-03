local DominatorGuideManager = BaseClass("DominatorGuideManager")
local DominatorInfo = require("DataCenter/Dominator/Main/DominatorInfo")
local DominatorGorillaInfo = require("DataCenter/Dominator/Main/DominatorGorillaInfo")
local DominatorTrainInfo = require("DataCenter/Dominator/Train/DominatorTrainInfo")

function DominatorGuideManager:__init()
  self.dominatorGuid = nil
end

function DominatorGuideManager:__delete()
  self.dominatorGuid = nil
end

function DominatorGuideManager:UpdateGuideProgress(message, isFromInit)
  if message and message.dominatorGuid then
    local needBroadEvent = false
    if self.dominatorGuid ~= message.dominatorGuid and not isFromInit then
      needBroadEvent = true
    end
    self.dominatorGuid = message.dominatorGuid
    if needBroadEvent then
      EventManager:GetInstance():Broadcast(EventId.DominatorGuideProgressChanged)
    end
  end
end

function DominatorGuideManager:GetSmallGorillaDetectEventId()
  return toInt(LuaEntry.DataConfig:TryGetNum("dominator_para", "k8", 0))
end

function DominatorGuideManager:GetBigGorillaDetectEventId()
  return toInt(LuaEntry.DataConfig:TryGetNum("dominator_para", "k6", 0))
end

function DominatorGuideManager:IsBigGorillaDetectEventClaimed()
  return self.dominatorGuid ~= nil and self.dominatorGuid == 2
end

function DominatorGuideManager:HasStartGorillaGuide()
  return self.dominatorGuid ~= nil and self.dominatorGuid > 0
end

function DominatorGuideManager:SendSetGuideProgressMessage(progress)
  if self.dominatorGuid ~= nil and progress <= self.dominatorGuid then
    DataCenter.DominatorManager:PrintRealErrorLog("guide progress must bigger then current")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DominatorSetGuideProgress, {guid = progress})
end

function DominatorGuideManager:IsHasShownTrainUpgradeGuide()
  local key = "dominator_guide_train_upgrade"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function DominatorGuideManager:SetHasShownTrainUpgradeGuide()
  local key = "dominator_guide_train_upgrade"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim()
  local key = "dominator_upgrade_unlock_anim"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function DominatorGuideManager:SetHasShownUpgradeRankAndSkillUnlockAnim()
  local key = "dominator_upgrade_unlock_anim"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():Broadcast(EventId.DominatorMainViewRedPointChanged)
  DataCenter.DominatorManager:TryRefreshMainBuildingBubble()
end

return DominatorGuideManager
