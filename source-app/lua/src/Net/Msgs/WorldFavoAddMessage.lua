local WorldFavoAddMessage = BaseClass("WorldFavoAddMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, name, point, type, server, topFlag, isModifyTime, isAdd, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", name)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("server", server)
  self.sfsObj:PutInt("topFlag", topFlag)
  self.sfsObj:PutInt("isModifyTime", isModifyTime)
  self.sfsObj:PutInt("isAdd", isAdd)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  if param then
    local ret = SFSObject.New()
    if param.uname then
      ret:PutUtfString("uname", param.uname)
    end
    if param.abbr then
      ret:PutUtfString("abbr", param.abbr)
    end
    if param.posType then
      ret:PutInt("posType", param.posType)
    end
    if param.uid then
      ret:PutUtfString("uid", param.uid)
    end
    if param.oname then
      ret:PutUtfString("oname", tostring(param.oname))
    end
    if param.olv then
      ret:PutInt("olv", param.olv)
    end
    self.sfsObj:PutSFSObject("pointInfo", ret)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.point ~= nil and t.server ~= nil and t.createTime ~= nil then
    DataCenter.WorldFavoDataManager:AddBookmarkSucceed(t)
    DataCenter.WorldFavoDataManager:UpdateBookmark(t.point, t.server, t.createTime)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
    UIUtil.ShowTipsId(300044)
  end
end

WorldFavoAddMessage.OnCreate = OnCreate
WorldFavoAddMessage.HandleMessage = HandleMessage
return WorldFavoAddMessage
