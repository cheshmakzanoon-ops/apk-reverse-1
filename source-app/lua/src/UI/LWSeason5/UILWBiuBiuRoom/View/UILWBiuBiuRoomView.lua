local base = UIBaseView
local UILWBiuBiuRoomView = BaseClass("UILWBiuBiuRoomView", base)
local UILWBiuBiuRoomPlayerItem = require("UI.LWSeason5.UILWBiuBiuRoom.Component.UILWBiuBiuRoomPlayerItem")
local LWBiuBiuPvpBoot = require("DataCenter.LWBiuBiu.LWBiuBiuPvpBoot")
local txt_tile_path = "Top/txt_tile"
local item_emeny_path = "Center/Item_emeny"
local item_self_path = "Center/Item_self"
local txt_time_path = "Buttom/txt_time"
local btn_cancel_path = "Buttom/btns/btn_cancel"
local btn_ready_path = "Buttom/btns/btn_ready"
local txt_tip_path = "Buttom/txt_tip"
local btn_bg_path = "btn_bg"
local btn_joinkick_path = "Buttom/btns/btn_joinkick"
local txt_ready_tip_path = "Buttom/txt_ready_tip"
local btn_exit_path = "Buttom/btns/btn_exit"
local btns_path = "Buttom/btns"
local battle_panel_path = "Buttom/battle_panel"
local slider_path = "Buttom/battle_panel/Slider"
local slider_text2_path = "Buttom/battle_panel/Slider/SliderText2"
local WAIT_TIME_CREATEOK = 4
local WAIT_TIME_GAMELIFT = 4
local WAIT_TIME_CREATEOK_SHOW = 0.2

function UILWBiuBiuRoomView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.room = DataCenter.LWBiuBiuDataManager:GetRoom()
  self.waitPlayerTime = nil
  self.waitReadyTime = nil
  self.waitEnterBattleTime = nil
  self.waitGameLiftTime = nil
  self.waitEnterGameTime = nil
  self.finish = nil
  self.waitToClose = nil
  self.boot = LWBiuBiuPvpBoot.New()
  self:RefreshTime()
  self:Refresh()
end

function UILWBiuBiuRoomView:OnDestroy()
  self.waitPlayerTime = nil
  self.room = nil
  self.waitPlayerTime = nil
  self.waitReadyTime = nil
  self.waitEnterBattleTime = nil
  self.waitGameLiftTime = nil
  self.waitEnterGameTime = nil
  self.finish = nil
  self.waitToClose = nil
  self.boot = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuRoomView:ComponentDefine()
  self.txt_tile = self:AddComponent(UITextMeshProUGUIEx, txt_tile_path)
  self.item_emeny = self:AddComponent(UILWBiuBiuRoomPlayerItem, item_emeny_path)
  self.item_self = self:AddComponent(UILWBiuBiuRoomPlayerItem, item_self_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_ready = self:AddComponent(UIButton, btn_ready_path)
  self.txt_tip = self:AddComponent(UITextMeshProUGUIEx, txt_tip_path)
  self.btn_bg = self:AddComponent(UIButton, btn_bg_path)
  self.btn_joinkick = self:AddComponent(UIButton, btn_joinkick_path)
  self.txt_ready_tip = self:AddComponent(UITextMeshProUGUIEx, txt_ready_tip_path)
  self.btn_exit = self:AddComponent(UIButton, btn_exit_path)
  self.btns = self:AddComponent(UIBaseContainer, btns_path)
  self.battle_panel = self:AddComponent(UIBaseContainer, battle_panel_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text2 = self:AddComponent(UITextMeshProUGUIEx, slider_text2_path)
  self.btn_exit:SetOnClick(BindCallback(self, self.OnCancelClick))
  self.btn_cancel:SetOnClick(BindCallback(self, self.OnCancelClick))
  self.btn_ready:SetOnClick(BindCallback(self, self.OnReadyClick))
  self.btn_bg:SetOnClick(BindCallback(self, self.OnBgClick))
  self.btn_joinkick:SetOnClick(BindCallback(self, self.OnJoinKickClick))
end

function UILWBiuBiuRoomView:ComponentDestroy()
  self.txt_tile = nil
  self.item_emeny = nil
  self.item_self = nil
  self.txt_time = nil
  self.btn_back = nil
  self.btn_ready = nil
  self.txt_tip = nil
  self.btn_bg = nil
  self.btn_joinkick = nil
  self.txt_ready_tip = nil
  self.btn_exit = nil
  self.btns = nil
  self.battle_panel = nil
  self.slider = nil
  self.slider_text2 = nil
end

function UILWBiuBiuRoomView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuReconnection, self.SeasonBiuBiuReconnectionHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPvpDestroyRoom, self.SeasonBiuBiuPvpDestroyRoomHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPvpUpdateInfo, self.SeasonBiuBiuPvpUpdateInfoHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPvpStateChange, self.SeasonBiuBiuPvpStateChangeHandle)
end

function UILWBiuBiuRoomView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuReconnection, self.SeasonBiuBiuReconnectionHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpDestroyRoom, self.SeasonBiuBiuPvpDestroyRoomHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpUpdateInfo, self.SeasonBiuBiuPvpUpdateInfoHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpStateChange, self.SeasonBiuBiuPvpStateChangeHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuRoomView:SeasonBiuBiuReconnectionHandle()
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  if not room:HasPvp() then
    self:ConnectFair()
  elseif room:GetState() == LittleGameRoomState.FightIng then
    room:BuildReConnectData()
  else
    self:ConnectFair()
  end
end

function UILWBiuBiuRoomView:SeasonBiuBiuPvpDestroyRoomHandle(t)
  self.ctrl:CloseSelf()
end

function UILWBiuBiuRoomView:SeasonBiuBiuPvpUpdateInfoHandle()
  self:Refresh()
end

function UILWBiuBiuRoomView:SeasonBiuBiuPvpStateChangeHandle()
  local state = self.room:GetState()
  if state == LittleGameRoomState.RoomFair then
    self:ConnectFair()
  elseif state <= LittleGameRoomState.WaitReady then
    self:RefreshTime()
    self:Refresh()
  elseif state == LittleGameRoomState.FightReady then
    self:Refresh()
    self:Update()
    self.waitEnterBattleTime = WAIT_TIME_CREATEOK
  elseif state == LittleGameRoomState.FightIng then
    local fightDescribeResult = self.room:GetBattleFightDescribeResult()
    if fightDescribeResult == nil or not fightDescribeResult.result then
      self:ConnectFair()
    end
  end
end

function UILWBiuBiuRoomView:OnCancelClick()
  self.room:ReqCancel()
end

function UILWBiuBiuRoomView:OnBgClick()
end

function UILWBiuBiuRoomView:OnJoinKickClick()
  local _, otherUser = self.room:GetRoomUsers()
  self.room:ReqJoinKick(otherUser.uid)
end

function UILWBiuBiuRoomView:OnReadyClick()
  self.room:ReqReady()
end

function UILWBiuBiuRoomView:RefreshTime()
  local waitPlayer = self.room:GetState() == LittleGameRoomState.WaitPlayer
  local waitReady = self.room:GetState() == LittleGameRoomState.WaitReady
  if waitPlayer then
    self.waitPlayerTime = self.room:GetRoomWaitPlayerTime()
    self.waitReadyTime = nil
  end
  if waitReady then
    self.waitReadyTime = self.room:GetRoomWaitReadyTime()
    self.waitPlayerTime = nil
  end
end

function UILWBiuBiuRoomView:RefreshWaitPlayer()
  self.btns:SetActive(true)
  self.txt_tip:SetActive(true)
  self.txt_tile:SetLocalText("season_s5_activity_1200045_desc51")
  self.txt_tip:SetLocalText("season_s5_activity_1200045_desc13")
  self.txt_time:SetActive(true)
  local myRoom = self.room:IsMyRoom()
  self.btn_cancel:SetActive(myRoom)
  self.btn_exit:SetActive(not myRoom)
end

function UILWBiuBiuRoomView:RefreshWaitReady()
  self.btns:SetActive(true)
  self.txt_ready_tip:SetActive(true)
  self.txt_tile:SetLocalText("season_s5_activity_1200045_desc15")
  self.txt_ready_tip:SetLocalText("season_s5_activity_1200045_desc18", self.room:GetRoomWaitReadyTime())
  self.txt_time:SetActive(true)
  local ready = self.room:GetReady(LuaEntry.Player.uid)
  self.btn_ready:SetActive(not ready)
  local myRoom = self.room:IsMyRoom()
  self.btn_exit:SetActive(not myRoom)
end

function UILWBiuBiuRoomView:RefreshFightReady()
  self.battle_panel:SetActive(true)
end

function UILWBiuBiuRoomView:Refresh()
  local roomUser, otherUser = self.room:GetRoomUsers()
  self.item_self:SetData(roomUser, self.room)
  self.item_emeny:SetData(otherUser, self.room)
  self.btns:SetActive(false)
  self.txt_tip:SetActive(false)
  self.txt_ready_tip:SetActive(false)
  self.battle_panel:SetActive(false)
  self.btn_joinkick:SetActive(false)
  self.btn_ready:SetActive(false)
  self.btn_cancel:SetActive(false)
  self.btn_exit:SetActive(false)
  self.txt_time:SetActive(false)
  local state = self.room:GetState()
  if state == LittleGameRoomState.WaitPlayer then
    self:RefreshWaitPlayer()
  elseif state == LittleGameRoomState.WaitReady then
    self:RefreshWaitReady()
  elseif state == LittleGameRoomState.FightReady or state == LittleGameRoomState.FightDescribe then
    self:RefreshFightReady()
  end
  self:Update1000MS()
end

function UILWBiuBiuRoomView:Update1000MS()
  if self.waitPlayerTime ~= nil and self.waitPlayerTime > 0 then
    self.waitPlayerTime = self.waitPlayerTime - 1
    self.txt_time:SetText(UITimeManager:GetInstance():SecondToFmtString(self.waitPlayerTime))
  end
  if self.waitReadyTime ~= nil and 0 < self.waitReadyTime then
    self.waitReadyTime = self.waitReadyTime - 1
    self.txt_time:SetText(UITimeManager:GetInstance():SecondToFmtString(self.waitReadyTime))
  end
end

function UILWBiuBiuRoomView:CloseMe()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UILWBiuBiuRoomView:SetEnterGameTime()
  self.waitEnterGameTime = WAIT_TIME_CREATEOK_SHOW
end

function UILWBiuBiuRoomView:ConnectFair()
  UIUtil.ShowTipsId(129063)
  self:CloseMe()
end

function UILWBiuBiuRoomView:Update()
  if IsNull(self.slider) then
    return
  end
  if self.waitToClose then
    return
  end
  if self.waitEnterGameTime ~= nil and self.waitEnterGameTime > 0 then
    local progress = 90 + (1 - self.waitEnterGameTime / WAIT_TIME_CREATEOK_SHOW) * 10
    self.slider:SetValue(progress)
    self.slider_text2:SetText(math.ceil(progress) .. "%")
    self.waitEnterGameTime = self.waitEnterGameTime - Time.deltaTime
    if self.waitEnterGameTime < 0 then
      self.room:Connect(false, BindCallback(self, self.CloseMe))
      self.slider:SetValue(100)
      self.slider_text2:SetText("100%")
      self.waitToClose = true
    end
    return
  end
  local fightDescribeResult = self.room:GetBattleFightDescribeResult()
  if fightDescribeResult ~= nil and self.waitGameLiftTime == nil then
    self.waitGameLiftTime = WAIT_TIME_GAMELIFT
    self.boot:ConnectGameLift(BindCallback(self, self.ConnectFair), BindCallback(self, self.SetEnterGameTime))
    return
  end
  if self.room:GetState() >= LittleGameRoomState.FightReady then
    if self.waitEnterBattleTime ~= nil and 0 < self.waitEnterBattleTime then
      local progress = (1 - self.waitEnterBattleTime / (WAIT_TIME_CREATEOK + 1)) * 40
      self.slider:SetValue(toInt(progress))
      self.slider_text2:SetText(math.ceil(progress) .. "%")
      self.waitEnterBattleTime = self.waitEnterBattleTime - Time.deltaTime
    end
    if self.waitGameLiftTime ~= nil and 0 < self.waitGameLiftTime then
      local progress = 40 + (1 - self.waitGameLiftTime / (WAIT_TIME_GAMELIFT + 1)) * 50
      self.slider:SetValue(toInt(progress))
      self.slider_text2:SetText(math.ceil(progress) .. "%")
      self.waitGameLiftTime = self.waitGameLiftTime - Time.deltaTime
    end
  end
end

return UILWBiuBiuRoomView
