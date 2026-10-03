local UIBattleFieldSelectTimeSecondView = BaseClass("UIBattleFieldSelectTimeSecondView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local img_corner_path = "PopUpTitle/Common_bg_orange/Corner/TeamIcon"
local title_text_path = "PopUpTitle/Common_bg_orange2/TitleText"
local btn_enroll_path = "PopUpTitle/Common_bg_orange2/BtnEnroll"
local time_path = "PopUpTitle/Content/TimeItem/time"
local time2_path = "PopUpTitle/Content/TimeItem/time2"

function UIBattleFieldSelectTimeSecondView:OnCreate()
  base.OnCreate(self)
  self.bfType, self.curTabIdx, self.battlePeriod, self.cb = self:GetUserData()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  local abStr = self.curTabIdx == 1 and "A" or "B"
  self.title_text:SetLocalText("Desert_strom_interface_1009", abStr)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.img_corner = self:AddComponent(UIImage, img_corner_path)
  local hadTeam2 = 0
  if self.bfType == BattleFieldType.Desert then
    local actInfo = DataCenter.ActDragonManager:GetActInfo()
    hadTeam2 = actInfo ~= nil and actInfo.hadTeam2 or 0
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local actInfo = DataCenter.ActEpidemicZoneManager:GetActInfo()
    hadTeam2 = actInfo ~= nil and actInfo.hadTeam2 or 0
  end
  self.img_corner.transform.parent.gameObject:SetActive(hadTeam2 ~= 0)
  if hadTeam2 ~= 0 then
    DataCenter.ActDragonManager:LoadTeamSprite(self.img_corner, self.curTabIdx)
  end
  self.btn_enroll = self:AddComponent(UIButton, btn_enroll_path)
  self.btn_enroll:SetOnClick(function()
    self:ClickEnroll()
  end)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.time2 = self:AddComponent(UITextMeshProUGUIEx, time2_path)
  self:UpdateData()
end

function UIBattleFieldSelectTimeSecondView:UpdateData()
  local battleTimes = DataCenter.ActDragonManager:GetBattleTimeInfo()
  if self.bfType == BattleFieldType.Desert then
    battleTimes = DataCenter.ActDragonManager:GetBattleTimeInfo()
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local actInfo = ActEpidemicUtils.GetActInfo()
    battleTimes = actInfo ~= nil and actInfo.battleTimes or nil
  end
  if battleTimes ~= nil then
    local mgr = UITimeManager:GetInstance()
    for _, v in ipairs(battleTimes) do
      if v ~= nil and v.battlePeriod == self.battlePeriod then
        local startTimeLocalStr = mgr:TimeStampToTimeForLocal(v.startTime)
        local endTimeLocalStr = mgr:TimeStampToTimeForLocalSimple(v.endTime)
        self.time:SetText(Localization:GetString("458280", " " .. startTimeLocalStr .. " ~ " .. endTimeLocalStr))
        local startTimeStr = mgr:TimeStampToTimeForServer(v.startTime)
        local endTimeStr = mgr:TimeStampToTimeForServer(v.endTime, true)
        self.time2:SetText(Localization:GetString("800811") .. ": " .. startTimeStr .. " ~ " .. endTimeStr)
      end
    end
  end
end

function UIBattleFieldSelectTimeSecondView:ClickEnroll()
  if self.cb then
    self.cb()
  end
  self.ctrl:CloseSelf()
end

return UIBattleFieldSelectTimeSecondView
