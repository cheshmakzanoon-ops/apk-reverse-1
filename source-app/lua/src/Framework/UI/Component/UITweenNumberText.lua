local UITweenNumberText = BaseClass("UITweenNumberText", UIText)
local base = UIText

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.initNum = false
  self.curNum = 0
  self.targetNum = 0
  self.seq = nil
  self.prefix = ""
  self.suffix = ""
  self.textFunc = nil
  self.decimal = false
  self.separator = false
  self.kmg = false
  self.active = true
end

local function DataDestroy(self)
  self.initNum = nil
  self.curNum = nil
  self.targetNum = nil
  self.seq = nil
  self.prefix = nil
  self.suffix = nil
  self.textFunc = nil
  self.decimal = nil
  self.separator = nil
  self.kmg = nil
  self.active = nil
end

local function GetCurNum(self)
  return self.curNum
end

local function GetTargetNum(self)
  return self.targetNum
end

local function SetNum(self, num)
  assert(type(num) == "number")
  self:Stop()
  self.targetNum = num
  self.curNum = num
  self:UpdateText()
  self.initNum = true
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

local function TweenToNum(self, targetNum, duration, delay, scale, callback)
  assert(type(targetNum) == "number")
  assert(type(duration) == "number")
  assert(type(delay) == "number" or type(delay) == "nil")
  assert(type(scale) == "number" or type(scale) == "nil")
  assert(type(callback) == "function" or type(callback) == "nil")
  if scale == nil then
    scale = 1
  end
  if delay == nil then
    delay = 0
  end
  self.targetNum = targetNum
  if self.initNum and 0 < duration then
    self:Stop()
    self.seq = DOTween.Sequence()
    if 0 < delay then
      self.seq:AppendInterval(delay)
    end
    local cutNum = 0
    if self.decimal then
      cutNum = self:GetCutNum(targetNum - self.curNum)
    end
    if scale ~= 1 then
      self.seq:Append(self.transform:DOScale(Vector3.New(scale, scale, 1), duration * 0.15)):Append(DOTween.To(function(x)
        if self.active then
          self.curNum = self.decimal and x - x % cutNum or math.floor(x + 0.5)
          self:UpdateText()
        end
      end, self.curNum, self.targetNum, duration * 0.7)):Append(self.transform:DOScale(ResetScale, duration * 0.15))
    else
      self.seq:Append(DOTween.To(function(x)
        if self.active then
          self.curNum = self.decimal and x - x % cutNum or math.floor(x + 0.5)
          self:UpdateText()
        end
      end, self.curNum, self.targetNum, duration))
    end
    self.seq:AppendCallback(function()
      if self.active then
        self.curNum = self.targetNum
        self:UpdateText()
        if callback then
          callback()
        end
      end
    end)
  else
    self:SetNum(targetNum)
    if callback then
      callback()
    end
  end
end

local function FromNumTweenToNum(self, startNum, targetNum, duration, delay, scale, callback)
  assert(type(startNum) == "number")
  assert(type(targetNum) == "number")
  assert(type(duration) == "number")
  assert(type(delay) == "number" or type(delay) == "nil")
  assert(type(scale) == "number" or type(scale) == "nil")
  assert(type(callback) == "function" or type(callback) == "nil")
  self:SetNum(startNum)
  self:TweenToNum(targetNum, duration, delay, scale, callback)
end

local function GetPrefix(self)
  return self.prefix
end

local function GetSuffix(self)
  return self.suffix
end

local function SetAffix(self, prefix, suffix)
  assert(type(prefix) == "string")
  assert(type(suffix) == "string")
  self:SetPrefix(prefix)
  self:SetSuffix(suffix)
end

local function SetPrefix(self, prefix)
  assert(type(prefix) == "string")
  self.prefix = prefix
end

local function SetSuffix(self, suffix)
  assert(type(suffix) == "string")
  self.suffix = suffix
end

local function GetSequence(self)
  return self.seq
end

local function IsPlaying(self)
  return self.seq ~= nil and self.seq:IsPlaying()
end

local function Stop(self)
  if self.seq ~= nil then
    self.seq:Kill()
    self.seq = nil
  end
end

local function SetTextFunc(self, func)
  assert(type(func) == "function" or type(func) == "nil")
  self.textFunc = func
end

local function SetDecimal(self, show)
  assert(type(show) == "boolean")
  self.decimal = show
end

local function SetSeparator(self, show)
  assert(type(show) == "boolean")
  self.separator = show
end

local function SetKmg(self, show)
  assert(type(show) == "boolean")
  self.kmg = show
end

local function UpdateText(self)
  local numStr = tonumber(self.curNum)
  if self.separator then
    numStr = string.GetFormattedSeperatorNum(numStr)
  elseif self.kmg then
    numStr = string.GetFormattedStr(numStr)
  end
  if self.textFunc ~= nil then
    self:SetText(self.textFunc(numStr))
  else
    self:SetText(self.prefix .. numStr .. self.suffix)
  end
end

local function GetCutNum(self, changeVal)
  local result = 1
  local temp = tostring(changeVal)
  local para = string.split_ii_array(temp, ".")
  if 1 < table.count(para) then
    local sub = string.len(para[2])
    for i = 1, sub do
      result = result * 0.1
    end
  end
  return result
end

UITweenNumberText.OnCreate = OnCreate
UITweenNumberText.OnDestroy = OnDestroy
UITweenNumberText.DataDefine = DataDefine
UITweenNumberText.DataDestroy = DataDestroy
UITweenNumberText.GetCurNum = GetCurNum
UITweenNumberText.GetTargetNum = GetTargetNum
UITweenNumberText.SetNum = SetNum
UITweenNumberText.TweenToNum = TweenToNum
UITweenNumberText.FromNumTweenToNum = FromNumTweenToNum
UITweenNumberText.GetSequence = GetSequence
UITweenNumberText.GetPrefix = GetPrefix
UITweenNumberText.GetSuffix = GetSuffix
UITweenNumberText.SetAffix = SetAffix
UITweenNumberText.SetPrefix = SetPrefix
UITweenNumberText.SetSuffix = SetSuffix
UITweenNumberText.IsPlaying = IsPlaying
UITweenNumberText.Stop = Stop
UITweenNumberText.SetTextFunc = SetTextFunc
UITweenNumberText.SetDecimal = SetDecimal
UITweenNumberText.SetSeparator = SetSeparator
UITweenNumberText.SetKmg = SetKmg
UITweenNumberText.UpdateText = UpdateText
UITweenNumberText.GetCutNum = GetCutNum
return UITweenNumberText
