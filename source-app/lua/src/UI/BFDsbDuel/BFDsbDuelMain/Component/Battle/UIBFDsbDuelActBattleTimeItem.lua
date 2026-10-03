local base = UIBaseContainer
local UIBFDsbDuelActBattleTimeItem = BaseClass("UIBFDsbDuelActBattleTimeItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActBattleTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleTimeItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleTimeItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textBattleTimeTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnChangeShowTime = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnChangeShowTime:SetOnClick(function()
    self:OnBtnChangeShowTimeClick()
  end)
  self.textBattleTimeData = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textBattleTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UIBFDsbDuelActBattleTimeItem:ComponentDestroy()
  self.viewSkin = nil
  self.textBattleTimeTips = nil
  self.btnChangeShowTime = nil
  self.textBattleTimeData = nil
  self.textBattleTime = nil
  self.textTips = nil
end

function UIBFDsbDuelActBattleTimeItem:DataDefine()
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
end

function UIBFDsbDuelActBattleTimeItem:DataDestroy()
  self.isShowLocalTime = nil
end

function UIBFDsbDuelActBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDsbDuelActChangeTimeType)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:AddUIListener(EventId.DsbDuelActTeamAssignSuccess, self.OnDsbDuelActTeamAssignSuccess)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnDsbDuelActTeamAssignSuccess)
end

function UIBFDsbDuelActBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnDsbDuelActTeamAssignSuccess)
  self:RemoveUIListener(EventId.DsbDuelActTeamAssignSuccess, self.OnDsbDuelActTeamAssignSuccess)
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.OnDsbDuelActTimePhaseChange)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDsbDuelActChangeTimeType)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleTimeItem:RefreshActive()
  local isInTeamSignUpPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamSignUpPhase()
  local isRegisteredAct = BattlefieldDsbDuelUtils.ActInfo:IsRegistered()
  self:SetActive(isRegisteredAct and isInTeamSignUpPhase)
end

function UIBFDsbDuelActBattleTimeItem:OnDsbDuelActTimePhaseChange()
end

local function RefreshTips(self)
  local isSelfInTeam = BattlefieldDsbDuelUtils.ActInfo:IsSelfInTeam(self.data.team)
  local selfTeamState = BattlefieldDsbDuelUtils.ActInfo:GetSelfAssigned()
  local IsTeamSignUp = BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(self.data.team)
  local maxNumMain = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
  local mainStr = Localization:GetString("458128", " " .. BattlefieldDsbDuelUtils.ActInfo:GetTeamMainPlayerNum(self.data.team) .. "/" .. maxNumMain)
  if isSelfInTeam and selfTeamState == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main and IsTeamSignUp then
    self.textTips:SetText(mainStr .. Localization:GetString("458284"))
  else
    self.textTips:SetText(mainStr)
  end
end

function UIBFDsbDuelActBattleTimeItem:OnDsbDuelActTeamAssignSuccess()
  RefreshTips(self)
end

function UIBFDsbDuelActBattleTimeItem:OnBtnChangeShowTimeClick()
  self.isShowLocalTime = not self.isShowLocalTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalTime)
end

function UIBFDsbDuelActBattleTimeItem:OnDsbDuelActChangeTimeType()
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self:RefreshBattleTimeShow()
end

function UIBFDsbDuelActBattleTimeItem:RefreshBattleTimeShow()
  self.battleBeginTime, self.battleEndTime = BattlefieldDsbDuelUtils.ActInfo:GetBattleTime()
  if self.isShowLocalTime then
    self.textBattleTimeTips:SetLocalText("Desert_strom_tips1001")
    local dataStr = UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(self.battleBeginTime))
    self.textBattleTimeData:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
    local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.battleBeginTime, true, true)
    local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.battleEndTime, true, true)
    self.textBattleTime:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
  else
    self.textBattleTimeTips:SetLocalText("Desert_strom_tips1002")
    local dataStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.battleBeginTime / 1000))
    self.textBattleTimeData:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.battleBeginTime, true)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.battleEndTime, true)
    self.textBattleTime:SetText(startTimeStr .. " ~ " .. endTimeStr)
  end
end

function UIBFDsbDuelActBattleTimeItem:SetData(data)
  self.data = data
  self:RefreshBattleTimeShow()
  RefreshTips(self)
  self:RefreshActive()
end

return UIBFDsbDuelActBattleTimeItem
