local WorldAddAllianceMarkMessage = BaseClass("WorldAddAllianceMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, point, server, type, name, planTimeStamp, notice, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("serverId", server)
  self.sfsObj:PutInt("markType", type)
  self.sfsObj:PutUtfString("markName", name)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  if param then
    local ret = SFSObject.New()
    if param.uname then
      ret:PutUtfString("uname", param.uname)
    end
    if param.abbr then
      ret:PutUtfString("abbr", param.abbr)
    end
    if param.oname then
      ret:PutUtfString("oname", tostring(param.oname))
    end
    if param.olv then
      ret:PutInt("olv", param.olv)
    end
    if param.posType then
      ret:PutInt("posType", param.posType)
    end
    if param.uid then
      ret:PutUtfString("uid", param.uid)
    end
    self.sfsObj:PutSFSObject("pointInfo", ret)
  end
  if planTimeStamp and 0 < planTimeStamp then
    self.sfsObj:PutLong("planTimeStamp", planTimeStamp)
    self.sfsObj:PutBool("notice", notice == true)
  else
    self.sfsObj:PutLong("planTimeStamp", 0)
  end
  if param and param.viewRank then
    self.sfsObj:PutInt("viewRank", param.viewRank)
  else
    self.sfsObj:PutInt("viewRank", 0)
  end
  if param and param.operateType then
    self.sfsObj:PutInt("operateType", param.operateType)
  else
    self.sfsObj:PutInt("operateType", 0)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.WorldFavoDataManager:HandleAddAllianceMarkMessage(t)
  end
end

WorldAddAllianceMarkMessage.OnCreate = OnCreate
WorldAddAllianceMarkMessage.HandleMessage = HandleMessage
return WorldAddAllianceMarkMessage
