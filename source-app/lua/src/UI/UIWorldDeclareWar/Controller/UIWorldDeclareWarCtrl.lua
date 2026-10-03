local UIWorldDeclareWarCtrl = BaseClass("UIWorldDeclareWarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldDeclareWar)
end

local function GetStringCharCount(self, str)
  local lenInByte = #str
  local i = 1
  local result = 0
  while lenInByte >= i do
    local curByte = string.byte(str, i)
    local byteCount = 1
    if 0 < curByte and curByte <= 127 then
      byteCount = 1
    elseif 192 <= curByte and curByte < 223 then
      byteCount = 2
    elseif 224 <= curByte and curByte < 239 then
      byteCount = 3
    elseif 240 <= curByte and curByte <= 247 then
      byteCount = 4
    end
    i = i + byteCount
    result = result + 1
  end
  return result
end

UIWorldDeclareWarCtrl.CloseSelf = CloseSelf
UIWorldDeclareWarCtrl.GetStringCharCount = GetStringCharCount
return UIWorldDeclareWarCtrl
