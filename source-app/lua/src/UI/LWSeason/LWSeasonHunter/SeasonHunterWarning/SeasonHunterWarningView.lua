local SeasonHunterWarning = BaseClass("SeasonHunterWarning", UIBaseView)
local base = UIBaseView
local SeasonHunterWarningItem = require("UI.LWSeason.LWSeasonHunter.SeasonHunterWarning.SeasonHunterWarningItem")
local messageItem_path = "msgItem"
local timeBeforeFadeOut = 0.6

local function OnCreate(self)
  base.OnCreate(self)
  self.tempItem = self:AddComponent(SeasonHunterWarningItem, messageItem_path)
  self.btnClose = self.tempItem:AddComponent(UIButton, "doTween/Text/close")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self:AddNewMsg(self:GetUserData())
end

local function OnDestroy(self)
  self.tempItem:ResetItem()
  self:DeleteTimer()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function AddNewMsg(self, params)
  local showTime = params.showTime or 2
  self.callback = params.callback
  self.callbackObj = params.callbackObj
  self.tempItem:ReInit(params)
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(showTime, self.EndCallback, self, false, false, false)
    self.timer:Start()
    self.tempItem:FadeIn()
  else
    self.timer.delay = showTime
    self.timer:Reset()
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function EndCallback(self)
  self.ctrl:CloseSelf()
  if self.callback then
    self.callback(self.callbackObj)
  end
end

SeasonHunterWarning.OnCreate = OnCreate
SeasonHunterWarning.OnDestroy = OnDestroy
SeasonHunterWarning.OnEnable = OnEnable
SeasonHunterWarning.OnDisable = OnDisable
SeasonHunterWarning.AddNewMsg = AddNewMsg
SeasonHunterWarning.DeleteTimer = DeleteTimer
SeasonHunterWarning.EndCallback = EndCallback
return SeasonHunterWarning
