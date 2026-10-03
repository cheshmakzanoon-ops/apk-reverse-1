local UICreateAllianceCtrl = BaseClass("UICreateAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICreateAlliance)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function CheckName(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  Logger.Log("check type", type)
  return type
end

local function SendCheckNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.AlName, value)
end

local function OnCreateClick(self, name, icon, intro)
  SFSNetwork.SendMessage(MsgDefines.AlCreate, name, intro, icon)
end

UICreateAllianceCtrl.CloseSelf = CloseSelf
UICreateAllianceCtrl.Close = Close
UICreateAllianceCtrl.CheckName = CheckName
UICreateAllianceCtrl.SendCheckNameMessage = SendCheckNameMessage
UICreateAllianceCtrl.OnCreateClick = OnCreateClick
return UICreateAllianceCtrl
