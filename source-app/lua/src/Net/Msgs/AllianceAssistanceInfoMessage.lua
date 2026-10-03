local AllianceAssistanceInfoMessage = BaseClass("AllianceAssistanceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid, assistanceType)
  base.OnCreate(self)
  if bUuid then
    self.sfsObj:PutLong("bUuid", bUuid)
  end
  self.sfsObj:PutLong("assistanceType", assistanceType)
  self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FormationAssistanceDataManager:UpdateAssistanceData(t)
  end
end

function AllianceAssistanceInfoMessage:GetTestData(bUuid, assistanceType)
  local member = {}
  local holdMembers = {}
  for i = 1, 10 do
    local allianceMember = DataCenter.AllianceMemberDataManager:GetRandomMember()
    table.insert(member, {
      uuid = tostring(1000 + i),
      ownerUid = allianceMember.uid,
      ownerName = allianceMember.name,
      status = MarchStatus.MOVING,
      startTime = 0,
      endTime = 0,
      teamUuid = tostring(3000 + i),
      ownerIcon = allianceMember.pic,
      ownerIconVer = allianceMember.picVer,
      armyInfos = {
        {
          armyId = 1,
          count = 1000 + i * 10
        },
        {
          armyId = 2,
          count = 2000 + i * 10
        }
      },
      monthCardEndTime = 0,
      power = 100000 + i * 1000,
      curHp = 5000 + i * 100,
      maxHp = 10000 + i * 100,
      headSkinId = nil,
      headSkinET = nil
    })
  end
  for i = 1, 20 do
    local allianceMember = DataCenter.AllianceMemberDataManager:GetRandomMember()
    table.insert(holdMembers, {
      uuid = tostring(2000 + i),
      ownerUid = allianceMember.uid,
      ownerName = allianceMember.name,
      status = MarchStatus.STATION,
      startTime = 0,
      endTime = 0,
      teamUuid = tostring(4000 + i),
      ownerIcon = allianceMember.pic,
      ownerIconVer = allianceMember.picVer,
      armyInfos = {
        {
          armyId = 1,
          count = 1000 + i * 10
        },
        {
          armyId = 2,
          count = 2000 + i * 10
        }
      },
      monthCardEndTime = 0,
      power = 100000 + i * 1000,
      curHp = 5000 + i * 100,
      maxHp = 10000 + i * 100,
      headSkinId = nil,
      headSkinET = nil
    })
  end
  local data = {
    uid = LuaEntry.Player.uid,
    uuid = bUuid,
    type = assistanceType,
    targetUuid = "505490",
    serverId = LuaEntry.Player:GetSelfServerId(),
    maxAssistance = 5,
    warFeverTime = 0,
    members = member,
    holdMembers = holdMembers
  }
  return data
end

AllianceAssistanceInfoMessage.OnCreate = OnCreate
AllianceAssistanceInfoMessage.HandleMessage = HandleMessage
return AllianceAssistanceInfoMessage
