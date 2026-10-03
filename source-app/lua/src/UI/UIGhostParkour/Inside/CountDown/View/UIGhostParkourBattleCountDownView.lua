local UIGhostParkourBattleCountDownView = BaseClass("UIGhostParkourBattleCountDownView", UIBaseView)
local base = UIBaseView
local UIGhostParkourMatchPlayerPanel = require("UI.UIGhostParkour.Inside.CountDown.Component.UIGhostParkourMatchPlayerPanel")
local title_txt_path = "SafeArea/TopRoot/MarchRoot/TitleTxt"
local count_down_text_path = "SafeArea/CenterRoot/CountDownText"
local center_root_path = "SafeArea/CenterRoot"
local march_root_path = "SafeArea/TopRoot/MarchRoot"

function UIGhostParkourBattleCountDownView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIGhostParkourBattleCountDownView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourBattleCountDownView:ComponentDefine()
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.count_down_text = self:AddComponent(UITextMeshProUGUIEx, count_down_text_path)
  self.center_root = self:AddComponent(UIBaseContainer, center_root_path)
  self.center_root:SetActive(false)
  self.march_root = self:AddComponent(UIGhostParkourMatchPlayerPanel, march_root_path)
  self.march_root:SetActive(false)
end

function UIGhostParkourBattleCountDownView:ComponentDestroy()
  self.title_txt = nil
  self.count_down_text = nil
  self.center_root = nil
  self.march_root = nil
end

function UIGhostParkourBattleCountDownView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourOnBattlePaused, self.OnBattlePaused)
end

function UIGhostParkourBattleCountDownView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourOnBattlePaused, self.OnBattlePaused)
  base.OnRemoveListener(self)
end

function UIGhostParkourBattleCountDownView:DataDefine()
  self.countDownTimer = nil
  self.curTimer = nil
  self.start = nil
  self.pause = nil
end

function UIGhostParkourBattleCountDownView:DataDestroy()
  self.countDownTimer = nil
  self.curTimer = nil
  self.start = nil
  self.pause = nil
end

function UIGhostParkourBattleCountDownView:Update()
  if self.pause then
    return
  end
  if self.curTimer == nil then
    return
  end
  self.curTimer = self.curTimer - Time.deltaTime
  if self.countDownTimer > 0 then
    if self.curTimer <= 0 then
      self.count_down_text:SetText(tostring(self.countDownTimer))
      self.countDownTimer = self.countDownTimer - 1
      self.curTimer = 1
    end
  elseif self.curTimer <= 0 then
    self.countDownTimer = nil
    self.curTimer = nil
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    if logic then
      if self.start then
        logic:OnStart()
      else
        logic:ContinueGame()
      end
    end
  end
end

function UIGhostParkourBattleCountDownView:InitView()
  local param = self:GetUserData()
  if param and param.message then
    local message = param.message
    local isPlayback = param.isPlayback
    if isPlayback then
      if message.firstInfo and message.otherInfo then
        self.march_root:InitItem(message, true)
        self.march_root:SetActive(true)
        self.title_txt:SetLocalText("ghost_parkour_replay_start")
      else
        self.title_txt:SetLocalText("")
      end
    else
      if message.fightType == 1 then
        self.title_txt:SetLocalText("ghost_parkour_match_start")
      elseif message.fightType == 2 then
        self.title_txt:SetLocalText("ghost_parkour_challenge_start")
      else
        self.title_txt:SetLocalText("")
      end
      if message.matchList then
        self.march_root:InitItem(message)
        self.march_root:SetActive(true)
      end
    end
  end
  self.start = param and param.start
  self.countDownTimer = 3
  self.curTimer = 0
  self.count_down_text:SetText(tostring(self.countDownTimer))
  self.center_root:SetActive(true)
  DataCenter.LWSoundManager:PlaySound(11027, false)
end

function UIGhostParkourBattleCountDownView:OnBattlePaused(pause)
  self.pause = pause
end

return UIGhostParkourBattleCountDownView
