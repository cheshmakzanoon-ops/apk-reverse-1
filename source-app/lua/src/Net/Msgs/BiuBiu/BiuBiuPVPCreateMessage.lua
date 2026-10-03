local BiuBiuPVPCreateMessage = BaseClass("BiuBiuPVPCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, speak, cost, version, latencies)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("speak", speak)
  self.sfsObj:PutInt("cost", cost)
  self.sfsObj:PutUtfString("version", version)
  self.sfsObj:PutUtfString("latencies", latencies)
  if DataCenter.LWBiuBiuDataManager.GMParam ~= nil and not string.IsNullOrEmpty(DataCenter.LWBiuBiuDataManager.GMParam) then
    self.sfsObj:PutUtfString("preferstagecfgid", DataCenter.LWBiuBiuDataManager.GMParam)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc52")
  end
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  room:RespCreate(t, errCode)
end

BiuBiuPVPCreateMessage.OnCreate = OnCreate
BiuBiuPVPCreateMessage.HandleMessage = HandleMessage
return BiuBiuPVPCreateMessage
