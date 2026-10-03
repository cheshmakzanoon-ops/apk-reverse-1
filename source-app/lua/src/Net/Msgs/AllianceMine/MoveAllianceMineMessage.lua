local MoveAllianceMineMessage = BaseClass("MoveAllianceMineMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, srcUuid, tarUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("srcUuid", srcUuid)
  self.sfsObj:PutLong("tarUuid", tarUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif not (t.srcUuid and t.tarUuid) or CS.SceneManager.World == nil or BattleFieldUtil.InBattleField() then
  else
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
    if theCarrier and theCarrier.uuid == t.tarUuid then
      local data = string.format("%s;%s;3", t.tarUuid, theCarrier.pointId)
      EventManager:GetInstance():Broadcast(EventId.ShowDomeShowEffect, data)
    elseif theStoveCenter and theStoveCenter.uuid == t.tarUuid then
      local data = string.format("%s;%s;3", t.tarUuid, theStoveCenter.pointId)
      EventManager:GetInstance():Broadcast(EventId.ShowDomeShowEffect, data)
    end
    DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
  end
end

MoveAllianceMineMessage.OnCreate = OnCreate
MoveAllianceMineMessage.HandleMessage = HandleMessage
return MoveAllianceMineMessage
