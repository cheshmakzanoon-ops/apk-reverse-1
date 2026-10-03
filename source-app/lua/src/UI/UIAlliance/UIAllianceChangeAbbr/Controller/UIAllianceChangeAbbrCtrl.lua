local UIAllianceChangeAbbrCtrl = BaseClass("UIAllianceChangeAbbrCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceChangeAbbr)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function CheckName(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < AL_TAG_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_TAG_CHAR then
    type = CheckNameType.MaxNameChar
  elseif string.match(value, "%W") then
    type = CheckNameType.IllegalChar
  end
  Logger.Log("check type", type)
  return type
end

local function SendCheckNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.AlAbbr, value)
end

UIAllianceChangeAbbrCtrl.CloseSelf = CloseSelf
UIAllianceChangeAbbrCtrl.Close = Close
UIAllianceChangeAbbrCtrl.CheckName = CheckName
UIAllianceChangeAbbrCtrl.SendCheckNameMessage = SendCheckNameMessage
return UIAllianceChangeAbbrCtrl
