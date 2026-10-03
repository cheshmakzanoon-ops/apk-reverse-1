local DetectInfoGetMessage = BaseClass("DetectInfoGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isOpenView)
  base.OnCreate(self)
  local isView = true
  if isOpenView ~= nil then
    isView = isOpenView
  end
  self.sfsObj:PutBool("openWnd", isView)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RadarCenterDataManager:UpdateDetectEventInfo(t)
    EventManager:GetInstance():Broadcast(EventId.GetAllDetectInfo)
  end
end

DetectInfoGetMessage.OnCreate = OnCreate
DetectInfoGetMessage.HandleMessage = HandleMessage
return DetectInfoGetMessage
