local PushAllianceMarchRefreshMessage = BaseClass("PushAllianceMarchRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  local preData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(t.uuid)
  DataCenter.AllianceWarDataManager:UpdateOneAllianceWarList(t)
  DataCenter.AllianceWarDataManager:CalculateAlertNum()
  EventManager:GetInstance():Broadcast(EventId.AllianceWarUpdate)
  if next(t.members) then
    local flag = true
    if preData then
      for i, v in pairs(preData.memberList) do
        if LuaEntry.Player.uid == v.ownerUid then
          flag = false
          break
        end
      end
    end
    if flag then
      local members = t.members
      for i = 1, #members do
        if members[i].ownerUid == LuaEntry.Player.uid then
          UIUtil.ShowTips(Localization:GetString("128029", t.attackName))
          break
        end
      end
    end
  end
end

PushAllianceMarchRefreshMessage.OnCreate = OnCreate
PushAllianceMarchRefreshMessage.HandleMessage = HandleMessage
return PushAllianceMarchRefreshMessage
