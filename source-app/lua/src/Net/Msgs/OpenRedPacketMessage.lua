local OpenRedPacketMessage = BaseClass("OpenRedPacketMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, redPacketId, chatType, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", uuid)
  self.sfsObj:PutInt("cfgId", redPacketId)
  self.sfsObj:PutInt("chatType", chatType)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  if t.errorCode ~= nil then
    if t.errorCode == "400600" then
      local count = LuaEntry.DataConfig:TryGetStr("red_pocket_config", "k1")
      local lang = Localization:GetString("red_pocket_desc13", count)
      UIUtil.ShowTips(lang)
      return
    end
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RedPacketManager:SetRedPacketGetNumData(t)
    EventManager:GetInstance():Broadcast(EventId.RedPacketOpen, t)
  end
end

OpenRedPacketMessage.OnCreate = OnCreate
OpenRedPacketMessage.HandleMessage = HandleMessage
return OpenRedPacketMessage
