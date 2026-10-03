local FirstPayBuildExpData = BaseClass("FirstPayBuildExpData")

local function __init(self)
  self.isOpen = false
  self.totalExp = 0
  self.receivedExp = 0
  self.bigReward = 0
  self.singleProgressExpLimit = 0
  self.expMaxLimit = 0
  self.goldPigItemId = -1
  self.expBeforeFuncOn = 0
  self.expTimeBeforeFuncOn = 0
end

local function __delete(self)
  self.isOpen = nil
  self.totalExp = nil
  self.receivedExp = nil
  self.bigReward = nil
  self.singleProgressExpLimit = nil
  self.expMaxLimit = nil
  self.goldPigItemId = nil
  self.expBeforeFuncOn = nil
  self.expTimeBeforeFuncOn = nil
end

function FirstPayBuildExpData:InitData(message)
  if not message then
    self.isOpen = false
    return
  end
  self:UpdateExpData(message)
  local str = LuaEntry.DataConfig:TryGetStr("firstpay_ab_2", "k2")
  if not string.IsNullOrEmpty(str) then
    local strArr = string.split(str, "|")
    if #strArr == 2 then
      self.singleProgressExpLimit = tonumber(strArr[1])
      self.expMaxLimit = tonumber(strArr[2])
    end
  end
  self.goldPigItemId = LuaEntry.DataConfig:TryGetNum("firstpay_ab_2", "k1")
  self.exExpPercent = LuaEntry.DataConfig:TryGetNum("firstpay_ab_2", "k10")
end

function FirstPayBuildExpData:UpdateExpData(t)
  if t.firstRechargeABInfo ~= nil then
    self.isOpen = t.firstRechargeABInfo.totalExp ~= nil
    self.totalExp = t.firstRechargeABInfo.totalExp or 0
    self.receivedExp = t.firstRechargeABInfo.receiveExp or 0
    self.bigReward = t.firstRechargeABInfo.bigReward or 0
    if t.firstRechargeABInfo.historyTotalExp then
      self.expBeforeFuncOn = t.firstRechargeABInfo.historyTotalExp or 0
    end
    if t.firstRechargeABInfo.historyTime then
      self.expTimeBeforeFuncOn = t.firstRechargeABInfo.historyTime or 0
    end
  else
    self.isOpen = false
  end
end

function FirstPayBuildExpData:GetCurRemainStashExp()
  return self.totalExp - self.receivedExp
end

function FirstPayBuildExpData:GetCurRemainStashExpStr()
  local value = self:GetCurRemainStashExp() or 0
  local iv = math.floor(value)
  return iv
end

function FirstPayBuildExpData:GetCurRemainExpInPool()
  return Mathf.Max(self.expMaxLimit - self.totalExp, 0)
end

function FirstPayBuildExpData:GetCurHadReceivedExp()
  return self.receivedExp or 0
end

function FirstPayBuildExpData:IsReceivedBigReward()
  return self.bigReward == 1
end

function FirstPayBuildExpData:IsExpPoolMax()
  return self:GetCurRemainExpInPool() <= 0
end

function FirstPayBuildExpData:GetHistoryExpBeforeFuncOn()
  return self.expBeforeFuncOn or 0, self.expTimeBeforeFuncOn
end

function FirstPayBuildExpData:IsOpen()
  return self.isOpen
end

FirstPayBuildExpData.__init = __init
FirstPayBuildExpData.__delete = __delete
return FirstPayBuildExpData
