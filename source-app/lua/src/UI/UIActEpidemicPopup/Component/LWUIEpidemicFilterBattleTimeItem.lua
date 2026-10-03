local LWUIEpidemicFilterBattleTimeItem = BaseClass("LWUIEpidemicFilterBattleTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local data_text_path = "DataText"
local time_text_path = "TimeText"
local member_count_text_path = "MemberCountText"
local selected_path = "Selected"
local select_btn_path = "SelectBtn"

function LWUIEpidemicFilterBattleTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIEpidemicFilterBattleTimeItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIEpidemicFilterBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DesertBattleFilterSelectBattleTime, self.OnDesertBattleFilterSelectBattleTime)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.OnGetPlayerList)
end

function LWUIEpidemicFilterBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DesertBattleFilterSelectBattleTime, self.OnDesertBattleFilterSelectBattleTime)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.OnGetPlayerList)
  base.OnRemoveListener(self)
end

function LWUIEpidemicFilterBattleTimeItem:OnDesertBattleFilterSelectBattleTime(battleData)
  if self.data then
    if self.data.battlePeriod ~= nil then
      self.isSelected = battleData ~= nil and self.data.battlePeriod == battleData.battlePeriod
    elseif self.data.curTabIdx ~= nil then
      self.curTabIdx = battleData.curTabIdx
      self.isSelected = battleData ~= nil and self.data.curTabIdx == battleData.curTabIdx
    end
    self:RefreshSelectState()
  end
end

function LWUIEpidemicFilterBattleTimeItem:OnDesertBattleChangeShowLocalTime()
  local isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  if isShowLocalTime then
    self:ShowLocalTime()
  else
    self:ShowUTCTime()
  end
end

function LWUIEpidemicFilterBattleTimeItem:OnGetPlayerList()
  self:RefreshMemberCountData()
end

function LWUIEpidemicFilterBattleTimeItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.data_text = self:AddComponent(UIText, data_text_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.member_count_text = self:AddComponent(UIText, member_count_text_path)
  self.selected = self:AddComponent(UIImage, selected_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_btn:SetOnClick(function()
    self:SelectBtnClick()
  end)
end

function LWUIEpidemicFilterBattleTimeItem:ComponentDestroy()
  self.bg = nil
  self.data_text = nil
  self.time_text = nil
  self.member_count_text = nil
  self.selected = nil
  self.select_btn = nil
end

function LWUIEpidemicFilterBattleTimeItem:ReInit(data)
  self.data = data
  self.isSelected = false
  self:RefreshSelectState()
  self:RefreshMemberCountData()
  self:OnDesertBattleChangeShowLocalTime()
end

function LWUIEpidemicFilterBattleTimeItem:SetTeamShow(idx, curTabIdx)
  self.data = {curTabIdx = idx}
  self.curTabIdx = curTabIdx
  self.isSelected = idx == curTabIdx
  self:RefreshSelectState()
  self:RefreshMemberCountData()
  local langStr
  if idx == 0 then
    langStr = CS.GameEntry.Localization:GetString("Desert_strom_tips1036")
  else
    local baseStr = CS.GameEntry.Localization:GetString("Desert_strom_tips1034")
    langStr = baseStr .. " " .. (idx == 1 and "A" or "B")
  end
  self.data_text:SetText(langStr)
  self.time_text:SetActive(false)
end

function LWUIEpidemicFilterBattleTimeItem:ShowUTCTime()
  if self.data.curTabIdx ~= nil then
    return
  end
  local dataStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.data.startTime / 1000))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1002") .. ": " .. dataStr)
  local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.startTime, true)
  local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.endTime, true)
  self.time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
end

function LWUIEpidemicFilterBattleTimeItem:ShowLocalTime()
  if self.data.curTabIdx ~= nil then
    return
  end
  local dataStr = UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(self.data.startTime))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1001") .. ": " .. dataStr)
  local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.startTime, true, true)
  local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.endTime, true, true)
  self.time_text:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
end

function LWUIEpidemicFilterBattleTimeItem:RefreshSelectState()
  self.bg:SetActive(self.isSelected)
  self.selected:SetActive(self.isSelected)
  if self.isSelected then
    self.data_text:SetColor(DesertBattleSelectBattleTimeColor)
    self.time_text:SetColor(DesertBattleSelectBattleTimeColor)
  else
    self.data_text:SetColor(DesertBattleUnSelectBattleTimeColor)
    self.time_text:SetColor(DesertBattleUnSelectBattleTimeColor)
  end
end

function LWUIEpidemicFilterBattleTimeItem:SelectBtnClick()
  if self.data.curTabIdx ~= nil then
    EventManager:GetInstance():Broadcast(EventId.DesertBattleFilterSelectBattleTime, self.data)
    return
  end
  local curFilterBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
  if curFilterBattleTimeData == nil or self.data.battlePeriod ~= curFilterBattleTimeData.battlePeriod then
    self.view.ctrl:SetFilterBattleTimeData(self.data)
    EventManager:GetInstance():Broadcast(EventId.DesertBattleFilterSelectBattleTime, self.data)
  else
    self.view.ctrl:SetFilterBattleTimeData(nil)
    EventManager:GetInstance():Broadcast(EventId.DesertBattleFilterSelectBattleTime, nil)
  end
end

function LWUIEpidemicFilterBattleTimeItem:RefreshMemberCountData()
  local memberCount = 0
  local checkValue = self.data.curTabIdx
  local playerList = ActEpidemicUtils.GetAllPlayers()
  if checkValue ~= nil then
    for _, info in pairs(playerList) do
      if checkValue == 0 or info.group == checkValue then
        memberCount = memberCount + 1
      end
    end
  else
    checkValue = self.data.battlePeriod
    for _, info in pairs(playerList) do
      if info:IsContainerBattleTime(checkValue) then
        memberCount = memberCount + 1
      end
    end
  end
  self.member_count_text:SetText(tostring(memberCount))
end

return LWUIEpidemicFilterBattleTimeItem
