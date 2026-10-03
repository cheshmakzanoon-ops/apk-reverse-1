local UICD_LogPopItem = BaseClass("UICD_LogPopItem", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local img_bg_path = "root/Bg"
local text_time_path = "root/TimeText"
local headFrame_path = "root/HeadFrame/Head"
local text_name_path = "root/NameText"
local text_power_path = "root/Icon/PowerText"
local img_result_path = "root/Result"
local WIN_BG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_zhandou_zhanbao_win.png"
local LOSE_BG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_zhandou_zhanbao_lose.png"
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
local WIN_COLOR = "897764"
local LOSE_COLOR = "646889"

function UICD_LogPopItem:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, "")
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.img_result = self:AddComponent(UIImage, img_result_path)
end

function UICD_LogPopItem:OnDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.anim = nil
  self.img_bg = nil
  self.text_time = nil
  self.headFrame = nil
  self.text_name = nil
  self.text_power = nil
  self.img_result = nil
  base.OnDestroy(self)
end

function UICD_LogPopItem:ReInit(logData)
  local isWin = logData.isWin
  self.img_bg:LoadSpriteAuto(isWin and WIN_BG_PATH or LOSE_BG_PATH)
  local date = UITimeManager:GetInstance():TimeSecToServerDate(logData.time)
  local color = isWin and WIN_COLOR or LOSE_COLOR
  self.text_time:SetText(string.format("<color=#%s>%d %d/%02d/%02d:%02d:%02d</color>", color, date.year, date.month, date.day, date.hour, date.min, date.sec))
  self.img_result:LoadSpriteAsyncWithCallback(isWin and WIN_IMG_PATH or LOSE_IMG_PATH, function()
    if self.img_result then
      self.img_result:SetNativeSize()
    end
  end)
  local teamInfo = logData.target
  if teamInfo ~= nil then
    teamInfo:SetFrameShow(self.headFrame)
    teamInfo:SetNameShow(self.text_name)
    local power = teamInfo:GetPower()
    self.text_power:SetText(string.GetFormattedStr(math.floor(power)))
  end
end

function UICD_LogPopItem:PlayAnim(cb)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  local animName = "start"
  self.anim:Play(animName, 0, 0)
  local ret, time = self.anim:GetAnimationReturnTime(animName)
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      if cb then
        cb()
      end
    end, time)
  end
end

return UICD_LogPopItem
