local UIGhostParkourWaitLoadingView = BaseClass("UIGhostParkourWaitLoadingView", UIBaseView)
local base = UIBaseView
local wait_text_path = "SafeArea/CenterRoot/WaitText"
local back_btn_path = "SafeArea/BottomGroup/BackBtn"
local DOT_INTERVAL = 0.4
local MAX_DOTS = 3

function UIGhostParkourWaitLoadingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIGhostParkourWaitLoadingView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourWaitLoadingView:ComponentDefine()
  self.wait_text = self:AddComponent(UITextMeshProUGUIEx, wait_text_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
end

function UIGhostParkourWaitLoadingView:ComponentDestroy()
  self.wait_text = nil
  self.back_btn = nil
end

function UIGhostParkourWaitLoadingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourOnBattleWaitingPaused, self.OnBattlePaused)
end

function UIGhostParkourWaitLoadingView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourOnBattleWaitingPaused, self.OnBattlePaused)
  base.OnRemoveListener(self)
end

function UIGhostParkourWaitLoadingView:DataDefine()
  self.pause = nil
  self.dotTimer = nil
  self.contextId = nil
end

function UIGhostParkourWaitLoadingView:DataDestroy()
  self.pause = nil
  self.dotTimer = nil
  self.contextId = nil
end

function UIGhostParkourWaitLoadingView:Update()
  if self.pause then
    return
  end
  if self.dotTimer == nil then
    return
  end
  self.dotTimer = self.dotTimer + Time.deltaTime
  if self.dotTimer >= DOT_INTERVAL then
    self.dotTimer = 0
    self.dot = (self.dot + 1) % (MAX_DOTS + 1)
  end
  self.wait_text:SetText(self.context .. string.rep(".", self.dot))
end

function UIGhostParkourWaitLoadingView:InitView()
  self.dot = 0
  self.dotTimer = 0
  self.context = CS.GameEntry.Localization:GetString("ghost_parkour_loading")
  self.wait_text:SetText(self.context .. "...")
  self.duration = 0
  local waitLoadingParam = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config_c", "k10", "")
  local arr = string.split(waitLoadingParam, "|")
  if arr and #arr == 2 then
    local sTime = tonumber(arr[1]) or 0
    local eTime = tonumber(arr[2]) or 0
    self.duration = eTime - sTime
  end
end

function UIGhostParkourWaitLoadingView:OnBattlePaused(pause)
  self.pause = pause
end

function UIGhostParkourWaitLoadingView:OnBackBtnClick()
  self.pause = true
  UIUtil.ShowConfirmNew({
    contentText = CS.GameEntry.Localization:GetString("ghost_parkour_loading_exit_check"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
        DataCenter.LWBattleManager:SetGameOver(true)
        DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
      end
    },
    cancelBtnParam = {
      action = function()
        self.pause = false
      end
    }
  })
end

return UIGhostParkourWaitLoadingView
