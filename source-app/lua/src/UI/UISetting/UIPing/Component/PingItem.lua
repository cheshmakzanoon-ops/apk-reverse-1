local PingItem = BaseClass("PingItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function PingItem:OnCreate()
  base.OnCreate(self)
  self._name_txt = self:AddComponent(UIText, "Txt_name")
  self._des = self:AddComponent(UIText, "Txt_result")
  self.btn = self:AddComponent(UIButton, "challengeBtn")
  self.btn:SetOnClick(function()
    self:OnPingClick()
  end)
  self.pingScript = self.transform:Find(""):GetComponent(typeof(CS.UnityPing))
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.pingCount = 0
  self.receiveCount = 0
  self.totalCount = 0
  self.ReceiveList = {}
end

function PingItem:OnDestroy()
  self:DeleteTimer()
  base.OnDestroy(self)
end

function PingItem:OnEnable()
  base.OnEnable(self)
end

function PingItem:OnDisable()
  base.OnDisable(self)
end

function PingItem:InitData(url, name)
  self.url = url
  self._name_txt:SetText(name)
  self._des:SetText("")
end

function PingItem:OnChooseClick()
  self:OnPingClick()
end

function PingItem:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function PingItem:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(2, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function PingItem:RefreshTime()
  self.pingCount = self.pingCount - 1
  if self.pingCount >= 0 then
    self.pingScript:CreatePing(self.url, function(time)
      self:OnReceiveTime(time)
    end)
  else
    self:DeleteTimer()
  end
end

function PingItem:OnReceiveTime(time)
  Logger.Log("receive time" .. time)
  self.receiveCount = self.receiveCount - 1
  if 0 < time then
    table.insert(self.ReceiveList, time)
  end
  if self.receiveCount <= 0 then
    self:ShowResult()
  end
end

function PingItem:ShowResult()
  local min = 0
  local max = 0
  local average = 0
  local receiveCount = #self.ReceiveList
  local sendCount = self.totalCount
  local lostCount = sendCount - receiveCount
  if 0 < receiveCount then
    table.sort(self.ReceiveList, function(a, b)
      return a < b
    end)
    min = self.ReceiveList[1]
    max = self.ReceiveList[#self.ReceiveList]
    local count = 0
    for i = 1, receiveCount do
      count = count + self.ReceiveList[i]
    end
    average = count / receiveCount
  end
  local str = string.format("\230\149\176\230\141\174\229\140\133:\229\183\178\229\143\145\233\128\129=%d \229\183\178\230\142\165\230\148\182=%d \228\184\162\229\164\177=%d \n \230\156\128\231\159\173=%.2fms \230\156\128\233\149\191=%.2fms \229\185\179\229\157\135=%.2fms", sendCount, receiveCount, lostCount, min, max, average)
  self._des:SetText(str)
  self:ResetData()
end

function PingItem:OnPingClick()
  self:ResetData()
  local pingCount = self.view:GetPingCount()
  if pingCount <= 0 then
    pingCount = 20
  end
  self.pingCount = pingCount
  self.receiveCount = pingCount
  self.totalCount = pingCount
  self.ReceiveList = {}
  self._des:SetText("\230\149\176\230\141\174\230\148\182\233\155\134\228\184\173")
  self:AddTimer()
  self:RefreshTime()
end

function PingItem:ResetData()
  self.pingCount = 0
  self.receiveCount = 0
  self.totalCount = 0
  self.ReceiveList = {}
  self:DeleteTimer()
end

return PingItem
