local EpidemicZoneActApplyMessage = BaseClass("EpidemicZoneActApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, chooseTimeList)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  if not table.IsNullOrEmpty(chooseTimeList) then
    local list = SFSArray.New()
    table.walk(chooseTimeList, function(_, v)
      list:AddInt(v)
    end)
    self.sfsObj:PutSFSArray("chooseTimeList", list)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == 458258 or errCode == "458258" then
      local time = LuaEntry.DataConfig:TryGetNum("YiBianJinQu", "k5", 24)
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, time * 24))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityApplyMessage(t)
  DataCenter.ActEpidemicZoneManager:RequestActivityPlayerList()
end

EpidemicZoneActApplyMessage.OnCreate = OnCreate
EpidemicZoneActApplyMessage.HandleMessage = HandleMessage
return EpidemicZoneActApplyMessage
