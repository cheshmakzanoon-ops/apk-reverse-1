local AIHelpMessage = BaseClass("AIHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local rapidjson = require("rapidjson")

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    self:AIHelpDataInit(t)
  end
end

local function AIHelpDataInit(self, t)
  if not IsNull(CS.AIHelp.AIHelpProxy) and not IsNull(CS.AIHelp.AIHelpProxy.UpdateUserInfo) then
    local uid = tostring(LuaEntry.Player.uid)
    local uname = LuaEntry.Player.name
    local serverId = "s" .. tostring(LuaEntry.Player.serverId)
    local tag = "s" .. tostring(LuaEntry.Player.serverId)
    if DataCenter.VIPManager.vipinfo and DataCenter.VIPManager.vipinfo.level then
      tag = tag .. "," .. "vip" .. DataCenter.VIPManager.vipinfo.level
    end
    local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData() or {}
    local aiData = CS.AIHelp.AIHelpProxy.aIHelpDataTable
    local customData = {
      Main_Level = "lv" .. tostring(DataCenter.BuildManager.MainLv),
      Alliance_ID = LuaEntry.Player.allianceId,
      VIP_Level = "vip" .. tostring(DataCenter.VIPManager.vipinfo.level),
      Server_ID = serverId,
      Register_Date = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(LuaEntry.Player.regTime),
      Allliance_Name = alData.allianceName,
      Game_Version = aiData.Game_Version,
      Resource_Version = CS.GameEntry.Resource:GetResVersion(),
      Device_ID = aiData.Device_ID,
      Mail_Address = aiData.Mail_Address,
      AirKey = aiData.AirKey,
      Distinct_ID = aiData.Distinct_ID,
      Cross_Server_Id = tostring(LuaEntry.Player:GetCrossServerId()),
      Alliance_Rank = "R" .. tostring(alData.rank),
      is_whale = t.lwu_whale or "",
      userVipStage = t.userVipStage or "",
      contact_status = t.lwu_contact_status,
      contact_person = t.lwu_contact_person
    }
    local json = rapidjson.encode(customData)
    CS.AIHelp.AIHelpProxy.UpdateUserInfo(uid, uname, tag, serverId, json)
    CommonUtil.ProtectCall(function()
      CS.AIHelp.AIHelpProxy.OnAfterInitMessage()
    end)
  end
end

AIHelpMessage.OnCreate = OnCreate
AIHelpMessage.HandleMessage = HandleMessage
AIHelpMessage.AIHelpDataInit = AIHelpDataInit
return AIHelpMessage
