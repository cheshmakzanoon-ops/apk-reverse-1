local UIEnterDragonBattle = BaseClass("UIEnterDragonBattle", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local time_path = "bg/time"
local flag_icon_l_path = "bg/infoL/flagIconL"
local text_player_l_path = "bg/infoL/numPL"
local text_score_l_path = "bg/infoL/numSL"
local flag_icon_r_path = "bg/infoR/flagIconR"
local text_player_r_path = "bg/infoR/numPR"
local text_score_r_path = "bg/infoR/numSR"
local go_btn_path = "bg/Btn/GoBtn"
local text_go_btn_path = "bg/Btn/GoBtn/GoBtnText"
local small_btn_path = "bg/Btn/SmallBtn"
local checkSyncTime = 60000

function UIEnterDragonBattle:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.remain_time = self:AddComponent(UIText, time_path)
  self.flag_icon_l = self:AddComponent(UIImage, flag_icon_l_path)
  self.text_player_l = self:AddComponent(UIText, text_player_l_path)
  self.text_score_l = self:AddComponent(UIText, text_score_l_path)
  self.flag_icon_r = self:AddComponent(UIImage, flag_icon_r_path)
  self.text_player_r = self:AddComponent(UIText, text_player_r_path)
  self.text_score_r = self:AddComponent(UIText, text_score_r_path)
  self.Btn = self:AddComponent(UIButton, "bg")
  self.Btn:SetOnClick(function()
    DataCenter.ActDragonManager:TryEnterBattlefield()
  end)
  self.GoBtn = self:AddComponent(UIButton, go_btn_path)
  self.GoBtn:SetOnClick(function()
    DataCenter.ActDragonManager:TryEnterBattlefield()
  end)
  self.text_go_btn = self:AddComponent(UIText, text_go_btn_path)
  self.text_go_btn:SetLocalText("110003")
  self.SmallBtn = self:AddComponent(UIButton, small_btn_path)
  self.SmallBtn:SetOnClick(function()
    self.bSmall = true
    self.bg:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  end)
  self:AddUIListener(EventId.DragonScoreRefresh, self.Refresh)
  self.bSmall = false
  self.bg:SetActive(true)
end

function UIEnterDragonBattle:OnDestroy()
  self:RemoveUIListener(EventId.DragonScoreRefresh, self.Refresh)
end

function UIEnterDragonBattle:Refresh()
  if not self:GetActive() then
    return
  end
  self:ShowVSAlliance()
  self:Update1000MS()
end

function UIEnterDragonBattle:Update1000MS()
  if DataCenter.ActDragonManager:CanShowEnter() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
    local endTime = dragonInfo ~= nil and dragonInfo.timeInfo.endTime or 0
    local remainTime = endTime - curTime
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    local lastSyncTime = DataCenter.ActDragonManager.lastSyncTime or 0
    if curTime - lastSyncTime >= checkSyncTime then
      DataCenter.ActDragonManager:RequestBattleInfo()
    end
  else
    self:SetActive(false)
  end
end

function UIEnterDragonBattle:ShowVSAlliance()
  local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
  local vsInfoArr = dragonInfo ~= nil and dragonInfo.vsInfoArr or nil
  if vsInfoArr == nil then
    return
  end
  local BattleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
  local selfScore, otherScore = 0, 0
  if BattleInfo ~= nil then
    selfScore = BattleInfo.selfSideScore or 0
    otherScore = BattleInfo.otherSideScore or 0
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local lastSyncTime = DataCenter.ActDragonManager.lastSyncTime or 0
    if curTime - lastSyncTime >= checkSyncTime then
      DataCenter.ActDragonManager:RequestBattleInfo()
    end
  end
  for _, v in ipairs(vsInfoArr) do
    if v.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.flag_icon_l:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
      self.text_player_l:SetText(v.battleNum)
      self.text_score_l:SetText(selfScore)
    else
      self.flag_icon_r:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
      self.text_player_r:SetText(v.battleNum)
      self.text_score_r:SetText(otherScore)
    end
  end
end

function UIEnterDragonBattle:IsSmallShow()
  local flag = self:GetActive() and self.bSmall
  return flag
end

function UIEnterDragonBattle:SetMaxShow()
  self.bSmall = false
  self.bg:SetActive(true)
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
end

return UIEnterDragonBattle
