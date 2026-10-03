local UIBFBaseFilterBattleTimeItem = BaseClass("UIBFBaseFilterBattleTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local data_text_path = "DataText"
local time_text_path = "TimeText"
local member_count_text_path = "MemberCountText"
local selected_path = "Selected"
local select_btn_path = "SelectBtn"

function UIBFBaseFilterBattleTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBFBaseFilterBattleTimeItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFBaseFilterBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattlefieldFilterSelectBattleTime, self.OnFilterSelectBattleTime)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
  self:AddUIListener(EventId.BattlefieldPlayerListUpdate, self.OnGetPlayerList)
end

function UIBFBaseFilterBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.BattlefieldFilterSelectBattleTime, self.OnFilterSelectBattleTime)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
  self:RemoveUIListener(EventId.BattlefieldPlayerListUpdate, self.OnGetPlayerList)
  base.OnRemoveListener(self)
end

function UIBFBaseFilterBattleTimeItem:OnFilterSelectBattleTime(battleData)
  if self.data then
    if self.data.battlePeriod ~= nil then
      self.isSelected = battleData ~= nil and self.data.battlePeriod == battleData.battlePeriod
    elseif self.data.curTabIdx ~= nil then
      self.curTabIdx = battleData ~= nil and battleData.curTabIdx
      self.isSelected = battleData ~= nil and self.data.curTabIdx == battleData.curTabIdx
    end
    self:RefreshSelectState()
  end
end

function UIBFBaseFilterBattleTimeItem:OnChangeShowLocalTime()
  local isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  if isShowLocalTime then
    self:ShowLocalTime()
  else
    self:ShowUTCTime()
  end
end

function UIBFBaseFilterBattleTimeItem:OnGetPlayerList()
  self:RefreshMemberCountData()
end

function UIBFBaseFilterBattleTimeItem:ComponentDefine()
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

function UIBFBaseFilterBattleTimeItem:ComponentDestroy()
  self.bg = nil
  self.data_text = nil
  self.time_text = nil
  self.member_count_text = nil
  self.selected = nil
  self.select_btn = nil
end

function UIBFBaseFilterBattleTimeItem:ReInit(data)
  self.data = data
  local isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self.isSelected = false
  self:RefreshSelectState()
  self:RefreshMemberCountData()
  if isShowLocalTime then
    self:ShowLocalTime()
  else
    self:ShowUTCTime()
  end
end

function UIBFBaseFilterBattleTimeItem:SetTeamShow(idx, curTabIdx)
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

function UIBFBaseFilterBattleTimeItem:ShowUTCTime()
  if self.data.curTabIdx ~= nil then
    return
  end
  local dataStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.data.startTime / 1000))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1002") .. ": " .. dataStr)
  local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.startTime, true)
  local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.endTime, true)
  self.time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
end

function UIBFBaseFilterBattleTimeItem:ShowLocalTime()
  if self.data.curTabIdx ~= nil then
    return
  end
  local dataStr = UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(self.data.startTime))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1001") .. ": " .. dataStr)
  local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.startTime, true, true)
  local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.endTime, true, true)
  self.time_text:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
end

function UIBFBaseFilterBattleTimeItem:RefreshSelectState()
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

function UIBFBaseFilterBattleTimeItem:SelectBtnClick()
  if self.data.curTabIdx ~= nil then
    EventManager:GetInstance():Broadcast(EventId.BattlefieldFilterSelectBattleTime, self.data)
    return
  end
  local curFilterBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
  if curFilterBattleTimeData == nil or self.data.battlePeriod ~= curFilterBattleTimeData.battlePeriod then
    self.view.ctrl:SetFilterBattleTimeData(self.data)
    EventManager:GetInstance():Broadcast(EventId.BattlefieldFilterSelectBattleTime, self.data)
  else
    self.view.ctrl:SetFilterBattleTimeData(nil)
    EventManager:GetInstance():Broadcast(EventId.BattlefieldFilterSelectBattleTime, nil)
  end
end

function UIBFBaseFilterBattleTimeItem:RefreshMemberCountData()
  local memberCount = 0
  local playerList = self.view.ctrl:GetPlayerList()
  local checkValue = self.data.curTabIdx
  if checkValue ~= nil then
    for _, info in pairs(playerList) do
      if checkValue == 0 or info.team == checkValue or info.group == checkValue then
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

return UIBFBaseFilterBattleTimeItem
