local base = require("UI.UICommonTips.View.UICommonTipsView")
local UICommonTimeTipsView = BaseClass("UICommonTimeTipsView", base)

local function OnEnable(self)
  self.openTime = nil
  base.OnEnable(self)
  self:Update1000MS()
end

function UICommonTimeTipsView:Update1000MS()
  if self.param and self.param.timeStamp ~= nil then
    if not self.param.runType or self.param.runType == 0 then
      return
    end
    if self.param.runType == 1 then
      local deltaTime = 0
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.param.timeStamp then
        deltaTime = self.param.timeStamp - curTime
      end
      if 0 < deltaTime then
        local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
        self.textContent:SetText(showTime)
      else
        self.textContent:SetText("00:00:00")
      end
    end
    if not self.openTime then
      self.openTime = UITimeManager:GetInstance():GetServerTime()
    end
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = curTime - self.openTime
    local showTime = UITimeManager:GetInstance():TimeStampToTimeForServer(self.param.timeStamp + deltaTime)
    self.textContent:SetText(showTime)
  end
end

UICommonTimeTipsView.OnEnable = OnEnable
return UICommonTimeTipsView
