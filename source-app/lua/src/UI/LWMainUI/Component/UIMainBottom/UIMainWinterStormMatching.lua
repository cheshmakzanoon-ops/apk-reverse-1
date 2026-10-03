local UIMainWinterStormMatching = BaseClass("UIMainWinterStormMatching", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local go_btn_path = "Bg/goBtn"
local tip_text_path = "Bg/TipText"
local time_text_path = "Bg/TimeText"
local auto_tips_path = "Bg/AutoTips"
local AUTO_CLOSE_TIP = "WINTER_AUTO_CLOSE_TIP"

function UIMainWinterStormMatching:OnCreate()
  base.OnCreate(self)
  self.lod = 1
  self.status = 0
  self.time = 0
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.Btn = self:AddComponent(UIButton, go_btn_path)
  self.Btn:SetOnClick(function()
    RaceEntranceUtil.GotoOpenView(EnumActivity.ActWinterStorm.Type)
  end)
  self.auto_tips = self:AddComponent(UIBaseComponent, auto_tips_path)
  self.auto_tips:SetActive(false)
end

function UIMainWinterStormMatching:OnDestroy()
  self.tip_text = nil
  self.time_text = nil
  self.Btn = nil
  self.bg = nil
  self.auto_tips = nil
end

function UIMainWinterStormMatching:HideSelf()
  self.bg:SetActive(false)
end

function UIMainWinterStormMatching:Refresh()
  local status, time = 0, 0
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWinterStormMatching) and self.lod <= 3 then
    status, time = DataCenter.ActWinterStormManager:CheckMatchingShow()
  end
  local oldS = self.status
  self.status = status or 0
  self.time = time or 0
  self.bg:SetActive(0 < status)
  if 0 < status then
    if status ~= 2 then
      self.auto_tips:SetActive(false)
    end
    if oldS ~= self.status then
      self.tip_text:SetLocalText(status == 1 and "winter_battlefield_interface_tips1001" or "winter_battlefield_interface_tips1018")
      if status == 2 then
        self.tip_text:SetColorRGBA255(73, 247, 150, 255)
        local flag = Setting:GetPrivateBool(AUTO_CLOSE_TIP, false)
        if not flag then
          Setting:SetPrivateBool(AUTO_CLOSE_TIP, true)
          self.auto_tips:SetActive(true)
        end
      else
        self.tip_text:SetColorRGBA(1, 1, 1, 1)
      end
    end
    self:Update1000MS()
  else
    self.auto_tips:SetActive(false)
  end
end

function UIMainWinterStormMatching:Update1000MS()
  if not self.bg:GetActive() or self.status == 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.status == 1 then
    local passTime = curTime - self.time
    self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(passTime))
    return
  end
  if self.status == 2 then
    local remainTime = math.max(self.time - curTime, 0)
    self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime))
    if 0 < remainTime then
      return
    end
  end
  self.bg:SetActive(false)
end

function UIMainWinterStormMatching:SetLod(lod)
  if self.lod ~= lod then
    self.lod = lod
    self:Refresh()
  end
end

return UIMainWinterStormMatching
