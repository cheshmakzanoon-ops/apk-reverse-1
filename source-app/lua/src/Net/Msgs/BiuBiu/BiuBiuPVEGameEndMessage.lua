local BiuBiuPVEGameEndMessage = BaseClass("BiuBiuPVEGameEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, bid, replayData, fireCount, battleTimeMills, version, stageCfgId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("bid", bid)
  self.sfsObj:PutUtfString("data", replayData)
  self.sfsObj:PutInt("bulletNum", fireCount)
  self.sfsObj:PutLong("costTimeInMills", battleTimeMills)
  self.sfsObj:PutUtfString("version", version)
  self.sfsObj:PutUtfString("stageCfgId", stageCfgId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWBiuBiuDataManager:UpdateInfo(t)
  end
end

BiuBiuPVEGameEndMessage.OnCreate = OnCreate
BiuBiuPVEGameEndMessage.HandleMessage = HandleMessage
return BiuBiuPVEGameEndMessage
