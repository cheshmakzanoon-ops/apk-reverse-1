local UIEnterEpidemicBattle = BaseClass("UIEnterEpidemicBattle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local actMgr = DataCenter.ActEpidemicZoneManager
local back_path = "Back"
local go_btn_path = "Back/GoBtn"
local text_go_btn_path = "Back/GoBtn/GoBtnText"
local small_btn_path = "Back/SmallBtn"
local leave_path = "Leave"
local close_btn_path = "Leave/CloseBtn"
local des_text_path = "Leave/DesText"
local EPIDEMIC_CLOSE_LEAVE = "_EPIDEMIC_CLOSE_LEAVE"
local checkSyncTime = 60000

function UIEnterEpidemicBattle:OnCreate()
  base.OnCreate(self)
  self.bSmall = false
  self.back = self:AddComponent(UIBaseContainer, back_path)
  self.back:SetActive(false)
  local cls = "UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneBattleInfo"
  local prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleInfo.prefab"
  self.battle_info = self:LoadComponentAsync(cls, prefab, self.back, function(_, go)
    go.transform:SetAsFirstSibling()
    go.transform:Set_localScale(0.8, 0.8, 1)
    go.name = "BattleInfo"
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_anchoredPosition(0, 89)
    end
    self.battle_info:SetMain(false, function()
      actMgr:TryEnterBattlefield()
    end)
  end)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    actMgr:TryEnterBattlefield()
  end)
  self.text_go_btn = self:AddComponent(UIText, text_go_btn_path)
  self.text_go_btn:SetLocalText("110003")
  self.small_btn = self:AddComponent(UIButton, small_btn_path)
  self.small_btn:SetOnClick(function()
    self.bSmall = true
    self.back:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  end)
  self.leave = self:AddComponent(UIButton, leave_path)
  self.leave:SetActive(false)
  self.leave:SetOnClick(function()
    local remainTime = actMgr:GetLeaveCDLeft()
    if 0 < remainTime then
      local timeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime)
      UIUtil.ShowTips(Localization:GetString("YiBianJinQu_battle_tips_5", timeStr))
      return
    end
    actMgr:TryEnterBattlefield()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:SignLeaveClose()
    self:Refresh()
  end)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function UIEnterEpidemicBattle:OnDestroy()
  self.bSmall = false
  base.OnDestroy(self)
end

function UIEnterEpidemicBattle:Refresh()
  if not self:GetActive() then
    return
  end
  if actMgr:GetLeaveCDLeft() <= 0 then
    self.leave:SetActive(false)
    self.back:SetActive(not self:IsSmallShow())
    local battleInfo = actMgr:GetBattleInfo()
    if table.IsNullOrEmpty(battleInfo.vsInfo) then
      actMgr:ReqBattleScore()
    end
  else
    local sign = self:GetLeaveCloseSign()
    self.leave:SetActive(not sign)
    self.back:SetActive(false)
  end
  self:Update1000MS()
end

function UIEnterEpidemicBattle:Update1000MS()
  if not self:GetActive() then
    return
  end
  if not actMgr:CanShowEnter() then
    self:SetActive(false)
    return
  end
  local stage = actMgr:FixStage()
  if stage == EpidemicZoneStage.Show then
    self:SetActive(false)
    return
  end
  if self.back:GetActive() then
    local lastSyncTime = actMgr.lastSyncTime or 0
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    if curSec - lastSyncTime >= checkSyncTime then
      actMgr:ReqBattleScore()
    end
  elseif self.leave:GetActive() then
    local remainTime = actMgr:GetLeaveCDLeft()
    if 0 < remainTime then
      local timeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime)
      self.des_text:SetLocalText("YiBianJinQu_battle_tips_5", timeStr)
    else
      self.des_text:SetLocalText("YiBianJinQu_battle_tips_1")
      if 0 >= actMgr:GetLeaveCDLeft() then
        self:Refresh()
      end
    end
  end
end

function UIEnterEpidemicBattle:IsSmallShow()
  local flag = self:GetActive() and self.bSmall
  return flag
end

function UIEnterEpidemicBattle:SetMaxShow()
  self.bSmall = false
  self:Refresh()
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
end

function UIEnterEpidemicBattle:GetLeaveCloseSign()
  local signTime = CommonUtil.PlayerPrefsGetInt(EPIDEMIC_CLOSE_LEAVE, 0)
  if signTime == 0 then
    return false
  end
  local leaveCDTime = actMgr:GetLeaveCDTime()
  return signTime >= leaveCDTime
end

function UIEnterEpidemicBattle:SignLeaveClose()
  local leaveCDTime = actMgr:GetLeaveCDTime()
  CommonUtil.PlayerPrefsSetInt(EPIDEMIC_CLOSE_LEAVE, leaveCDTime)
end

return UIEnterEpidemicBattle
