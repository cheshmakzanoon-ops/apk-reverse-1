local Save3V3ArenaFormationMessage = BaseClass("Save3V3ArenaFormationMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, saveType, teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", saveType)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 0 < #para2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(para2)))
    end
  elseif t.type then
    if t.type == 1 then
      DataCenter.LW3V3ArenaManager:ParseAtkTeams(t)
    elseif t.type == 2 then
      DataCenter.LW3V3ArenaManager:ParseDefenseTeams(t)
    end
    UIUtil.ShowTipsId(801154)
  end
end

Save3V3ArenaFormationMessage.OnCreate = OnCreate
Save3V3ArenaFormationMessage.HandleMessage = HandleMessage
return Save3V3ArenaFormationMessage
