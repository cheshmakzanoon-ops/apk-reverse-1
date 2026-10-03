local WorldMvMessage = BaseClass("WorldMvMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("pointId", param.pointId)
    if param.itemUUid then
      self.sfsObj:PutUtfString("itemUUid", param.itemUUid)
    end
    if param.freeAllianceMove then
      self.sfsObj:PutBool("freeAllianceMove", param.freeAllianceMove)
    end
  end
  if BattleFieldUtil.InBattleField() then
    self.sfsObj:PutBool("moveCrossWormhole", true)
  end
  self.sfsObj:PutInt("worldType", LuaEntry.Player:GetCurWorldType())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:WorldMvHandle(t)
  if t.lastFreeMoveTime then
    LuaEntry.Player:SetLastFreeMvTime(t.lastFreeMoveTime)
  end
  if t.ZWLFreeMoveInfo then
    DataCenter.LandlordMgr:SetFreeMoveInfoEndTime(t.ZWLFreeMoveInfo.cdEndTime or 0)
  end
  if t.meteoriteFreeMoveCdEndTime then
    DataCenter.ActMeteoriteBattleManager:OnUpdateMoveCityFreeEndTime(t.meteoriteFreeMoveCdEndTime)
  end
  DataCenter.SeasonPowerWorkerManager:CheckMv()
end

WorldMvMessage.OnCreate = OnCreate
WorldMvMessage.HandleMessage = HandleMessage
return WorldMvMessage
