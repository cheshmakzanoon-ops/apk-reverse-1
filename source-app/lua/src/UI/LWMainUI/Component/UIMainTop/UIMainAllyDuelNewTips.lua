local UIMainAllyDuelNewTips = BaseClass("UIMainAllyDuelNewTips", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "icon"
local red_slider_path = "progressGo/mask/redSlider"
local red_rat_txt_path = "progressGo/redRatTxt"
local blue_tat_txt_path = "progressGo/blueTatTxt"

function UIMainAllyDuelNewTips:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.red_slider = self:AddComponent(UISlider, red_slider_path)
  self.red_rat_txt = self:AddComponent(UITextMeshProUGUIEx, red_rat_txt_path)
  self.blue_tat_txt = self:AddComponent(UITextMeshProUGUIEx, blue_tat_txt_path)
end

function UIMainAllyDuelNewTips:OnDestroy()
  self.icon = nil
  self.red_slider = nil
  self.red_rat_txt = nil
  self.blue_tat_txt = nil
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.PlayerPrefsSetInt("ALLY_DUEL_TIP_TIME", curTime)
  base.OnDestroy(self)
end

function UIMainAllyDuelNewTips:Refresh(meta)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  local eventInfo = actInfo ~= nil and actInfo:GetEventInfo() or nil
  if eventInfo == nil or eventInfo.vsAllianceList == nil then
    return
  end
  local heroEventCfg = LocalController:instance():getLine(TableName.HeroEvent, eventInfo.eventId)
  local missions = DataCenter.LeagueMatchManager:GetMissions(heroEventCfg)
  local mission = 0 < #missions and missions[1] or nil
  local iconPath = mission ~= nil and mission.icon or nil
  if not string.IsNullOrEmpty(iconPath) then
    self.icon:LoadSprite(mission.icon)
  end
  local myScore, otherScore
  for k, v in pairs(eventInfo.vsAllianceList) do
    local winTimes = toInt(v.alScore)
    local bLeft = k == LuaEntry.Player:GetAllianceUid()
    if bLeft then
      myScore = winTimes
    else
      otherScore = winTimes
    end
  end
  if myScore == otherScore then
    self.red_slider:SetValue(0.5)
    self.red_rat_txt:SetText("50%")
    self.blue_tat_txt:SetText("50%")
  else
    local total = myScore + otherScore
    local rate = tonumber(myScore / total)
    self.red_slider:SetValue(rate)
    local redRate = math.floor((1 - rate) * 100 + 0.5)
    local blueRate = math.floor(rate * 100 + 0.5)
    self.red_rat_txt:SetText(redRate .. "%")
    self.blue_tat_txt:SetText(blueRate .. "%")
  end
end

return UIMainAllyDuelNewTips
