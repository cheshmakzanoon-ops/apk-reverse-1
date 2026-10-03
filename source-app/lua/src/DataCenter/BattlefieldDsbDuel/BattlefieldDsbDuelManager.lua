local base = BattlefieldManagerBase
local BattlefieldDsbDuelManager = BaseClass("BattlefieldDsbDuelManager", base)
local BattlefieldInfoDsb = require("DataCenter.BattlefieldDsbDuel.Impl.BattlefieldInfoDsb")
local ActInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActInfo")
local MyInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelMyInfo")

function BattlefieldDsbDuelManager:OnInit()
  self.bfType = BattleFieldType.DsbDuel
  self:ResetData()
  BattlefieldDsbDuelUtils.Log("Dsb inited.")
end

function BattlefieldDsbDuelManager:OnDelete()
  self:DoDelete()
  BattlefieldDsbDuelUtils.Log("Dsb deleted.")
end

function BattlefieldDsbDuelManager:DoDelete()
  if self.battleInfo then
    self.battleInfo:Delete()
    self.battleInfo = nil
  end
  if self.actInfo then
    self.actInfo:Delete()
    self.actInfo = nil
  end
  if self.myInfo then
    self.myInfo:Delete()
    self.myInfo = nil
  end
end

function BattlefieldDsbDuelManager:ResetData()
  self:DoDelete()
  self.actInfo = ActInfo.New()
  self.battleInfo = BattlefieldInfoDsb.New()
  self.myInfo = MyInfo.New()
end

function BattlefieldDsbDuelManager:GetActInfo()
  return self.actInfo
end

function BattlefieldDsbDuelManager:OnLeaveAlliance()
  self:ResetData()
  self.actInfo:SendActInfoMsg()
end

function BattlefieldDsbDuelManager:OnGetActInfoMsg(t)
  self.actInfo:OnGetActInfoMsg(t)
  self.myInfo:UpdateFromActInfo(self.actInfo)
end

function BattlefieldDsbDuelManager:OnGetBattleInfoMsg(t)
  self.actInfo:OnGetBattleInfoMsg(t)
  self.myInfo:UpdateFromBattleInfo(self.actInfo)
end

function BattlefieldDsbDuelManager:OnHandleBattlePlayerInfoMsg(t)
  if self.battleInfo then
    self.battleInfo:OnHandleBattlePlayerInfo(t)
  end
  self.myInfo:UpdateFromBattlePlayerInfo(self.battleInfo)
end

function BattlefieldDsbDuelManager:GetCurGroup()
  if self.actInfo then
    return self.actInfo:GetCurGroup()
  end
end

function BattlefieldDsbDuelManager:GetBattleInfo(bNew)
  if bNew then
    if self.battleInfo then
      self.battleInfo:Delete()
      self.battleInfo = nil
    end
    self.battleInfo = BattlefieldInfoDsb.New(BattleFieldType.DsbDuel)
  end
  return self.battleInfo
end

function BattlefieldDsbDuelManager:GetMyInfo()
  return self.myInfo
end

function BattlefieldDsbDuelManager:GetBattleStartTimeSec()
  if self.battleInfo then
    return self.battleInfo:GetBattleStartTimeSec()
  end
  return 0
end

function BattlefieldDsbDuelManager:CheckBattleStart()
  if not self.battleInfo then
    return false
  end
  return self.battleInfo:CheckBattleStart()
end

function BattlefieldDsbDuelManager:UpdateAreaMaterial(mapHandle)
  if mapHandle == nil then
    return
  end
  local battleInfo = self:GetBattleInfo()
  if not battleInfo then
    return
  end
  for role = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local index = role - 1
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(role, true)
    if color then
      local renderer = mapHandle:GetRenderer(index)
      if IsNotNull(renderer) then
        renderer.sharedMaterial = mapHandle:GetMaterial(color.bfMaterialIndex)
      end
    end
  end
end

function BattlefieldDsbDuelManager:OnPushBattleScore(msg)
  local errCode = msg.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif self.battleInfo then
    self.battleInfo:UpdateFromScoreUpdateMsg(msg)
    self.myInfo:UpdateFromScoreUpdateMsg(self.battleInfo)
  end
end

function BattlefieldDsbDuelManager:OnLeaveBattle(msg)
  if msg.errorCode then
    BattlefieldDsbDuelUtils.LogError("dsb.battle.leave failed. %s", msg.errorCode)
    UIUtil.ShowTipsId(msg.errorCode)
    return
  end
  if self.actInfo then
    self.actInfo:OnLeaveBattlefield()
  end
end

function BattlefieldDsbDuelManager:GetBuilding(buildUUID)
  if not self.battleInfo then
    return
  end
  return self.battleInfo:GetBuilding(buildUUID)
end

function BattlefieldDsbDuelManager:CheckTargetInSafeArea(pointId)
  local t = BattleFieldUtil.GetBlockRangeValue(pointId, BattleFieldType.DsbDuel)
  local myInfo = self:GetMyInfo()
  local curSide = myInfo and myInfo.selfRoleId or BattlefieldDsbConst.RoleType.None
  if t < 2 then
    return false
  end
  if curSide ~= t - 1 then
    return true
  end
  return false
end

function BattlefieldDsbDuelManager:GetClosestPos(pos)
  if self.battleInfo then
    return self.battleInfo:GetClosestPos(pos)
  end
end

function BattlefieldDsbDuelManager:GetBuildUpEffInfo()
  if self.battleInfo then
    return self.battleInfo:GetBuildUpEffInfo()
  end
  return false, 0
end

function BattlefieldDsbDuelManager:GetWorldCamp(role)
  if not role or role == 0 then
    return WorldCamp.Neutral
  end
  return BattlefieldDsbDuelUtils.GetMyRoleId() == role and WorldCamp.Self or WorldCamp.Enemy
end

function BattlefieldDsbDuelManager:SendDragonHospitalFinishMsg()
  if self.battleInfo then
    return self.battleInfo:SendDragonHospitalFinishMsg()
  end
end

function BattlefieldDsbDuelManager:SendDragonHospitalViewMsg()
  if self.battleInfo then
    return self.battleInfo:SendDragonHospitalViewMsg()
  end
end

function BattlefieldDsbDuelManager:GetTreatmentSpeed()
  if self.battleInfo then
    return self.battleInfo:GetTreatmentSpeed()
  end
  return 0
end

function BattlefieldDsbDuelManager:GetAccumulativeTreatmentSoldierNum()
  if self.battleInfo then
    return self.battleInfo:GetAccumulativeTreatmentSoldierNum()
  end
  return 0
end

function BattlefieldDsbDuelManager:GetTreatmentSoldierDataList()
  if self.battleInfo then
    return self.battleInfo:GetTreatmentSoldierDataList()
  end
  return
end

function BattlefieldDsbDuelManager:GetTreatmentFinishSoldierNum()
  if self.battleInfo then
    return self.battleInfo:GetTreatmentFinishSoldierNum()
  end
  return 0
end

function BattlefieldDsbDuelManager:ReqBattleEffect()
  if not self.battleInfo then
    return
  end
  local team = self.battleInfo:GetTeam()
  if not team then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleEffect, BattleFieldType.DsbDuel, team)
end

function BattlefieldDsbDuelManager:HandleEffects(msg)
  if self.battleInfo then
    return self.battleInfo:HandleEffects(msg)
  end
end

function BattlefieldDsbDuelManager:CheckAllianceIsValid()
  if self.actInfo then
    return self.actInfo:CheckAllianceIsValid()
  end
end

function BattlefieldDsbDuelManager:CheckSelfAssigned()
  if self.actInfo then
    return self.actInfo:CheckSelfAssigned()
  end
end

function BattlefieldDsbDuelManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("---DSB---")
  sb:AppendLine("\230\136\145\231\154\132\228\191\161\230\129\175(MyInfo)")
  local myInfo = self:GetMyInfo()
  sb:AppendLine(myInfo and myInfo:Description() or "\231\169\186")
  sb:AppendLine("\230\180\187\229\138\168\228\191\161\230\129\175(ActInfo)")
  local actInfo = self:GetActInfo()
  sb:AppendLine(actInfo and actInfo:Description() or "\231\169\186")
  sb:AppendLine()
  sb:AppendLine("\230\136\152\229\156\186\228\191\161\230\129\175(BattleInfo)")
  local battleInfo = self:GetBattleInfo()
  sb:AppendLine(battleInfo and battleInfo:Description() or "\231\169\186")
  sb:AppendLineFormat("\232\129\138\229\164\169\230\136\191\233\151\180(\230\136\145\230\150\185):%s", BattlefieldDsbDuelUtils.TryGetSelfBattleRoomId() or "")
  sb:AppendLine("\230\136\152\229\156\186\229\163\171\229\133\181\228\191\161\230\129\175")
  sb:AppendLineFormat(BattleFieldUtil.GetSoldierDescription())
  local txt = sb:ToString()
  Logger.Log(txt)
  return txt
end

BattleFieldUtil.MergeFunctions(BattlefieldDsbDuelManager, "DataCenter.BattlefieldDsbDuel.Module.BuildInfo")
BattleFieldUtil.MergeFunctions(BattlefieldDsbDuelManager, "DataCenter.BattlefieldDsbDuel.Module.EnterBattle")
Implement(BattlefieldDsbDuelManager, InterfaceConfig.BattlefieldManager, InterfaceConfig.BattlefieldTreatment, InterfaceConfig.BattlefieldEnterCheck)
return BattlefieldDsbDuelManager
