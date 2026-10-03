local UILWAlModifyInfoCtrl = BaseClass("UILWAlModifyInfoCtrl", UIBaseCtrl)
local MIN_AL_NAME_CHAR = 3
local MAX_AL_NAME_CHAR = 20

function UILWAlModifyInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlModifyInfo)
end

function UILWAlModifyInfoCtrl:GetStringLength(inputstr)
  if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
    return 0
  end
  local length = 0
  local i = 1
  while true do
    local curByte = string.byte(inputstr, i)
    local byteCount = 1
    if 239 < curByte then
      byteCount = 4
    elseif 223 < curByte then
      byteCount = 3
    elseif 128 < curByte then
      byteCount = 2
    else
      byteCount = 1
    end
    i = i + byteCount
    length = length + 1
    if i > #inputstr then
      break
    end
  end
  return length
end

function UILWAlModifyInfoCtrl:CheckAlName(value)
  local type = CheckNameType.None
  local len = self:GetStringLength(value)
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  Logger.Log("check al name type", type)
  return type
end

function UILWAlModifyInfoCtrl:SendCheckAlNameMessage(value)
  SFSNetwork.SendMessage(MsgDefines.AlName, value)
end

function UILWAlModifyInfoCtrl:CheckAlTag(value)
  local type = CheckNameType.None
  local len = self:GetStringLength(value)
  if len < AL_TAG_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_TAG_CHAR then
    type = CheckNameType.MaxNameChar
  elseif string.match(value, "%W") then
    type = CheckNameType.IllegalChar
  end
  Logger.Log("check al abbr type", type)
  return type
end

function UILWAlModifyInfoCtrl:SendCheckAlTagMessage(value)
  SFSNetwork.SendMessage(MsgDefines.AlAbbr, value)
end

return UILWAlModifyInfoCtrl
