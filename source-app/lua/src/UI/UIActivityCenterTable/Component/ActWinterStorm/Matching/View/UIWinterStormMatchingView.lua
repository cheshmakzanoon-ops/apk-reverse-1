local UIWinterStormMatching = BaseClass("UIWinterStormMatching", UIBaseView)
local base = UIBaseView
local WInterStormPreparePlayerItem = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Matching.Component.WInterStormPreparePlayerItem")
local PLAYER_ITEM_OPT_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/WInterStormPreparePlayerItem.prefab"
local ActMgr = DataCenter.ActWinterStormManager
local text_title_path = "PopUpTitle/top/TitleText"
local text_ready_num_path = "PopUpTitle/top/layout/ReadyNumText"
local root01_path = "PopUpTitle/middle/root01"
local root02_path = "PopUpTitle/middle/root02"
local text_time_path = "PopUpTitle/middle/TimeText"
local btn_prepare_path = "PopUpTitle/bottom/PrepareBtn"
local txt_btn_prepare_path = "PopUpTitle/bottom/PrepareBtn/TextPrepareBtn"
local text_ready_path = "PopUpTitle/bottom/ReadyText"
local text_tip_path = "PopUpTitle/bottom/TipText"

function UIWinterStormMatching:OnCreate()
  base.OnCreate(self)
  self.timeoutEnd = 0
  self.addListener = false
  self:ComponentDefine()
  self:UpdateUI()
end

function UIWinterStormMatching:OnDestroy()
  self.timeoutEnd = 0
  self.addListener = false
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormMatching:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, text_title_path)
  self.textTitle:SetLocalText("winter_battlefield_interface_tips1017")
  self.textReadyNum = self:AddComponent(UIText, text_ready_num_path)
  self.textReady = self:AddComponent(UIText, text_ready_path)
  self.textReady:SetLocalText("winter_battlefield_interface_tips1018")
  self.middleRoot01 = self:AddComponent(UIBaseContainer, root01_path)
  self.middleRoot02 = self:AddComponent(UIBaseContainer, root02_path)
  self.playerItems = {}
  for i = 1, 5 do
    local parentRoot = i <= 3 and self.middleRoot01 or self.middleRoot02
    local item = self:LoadComponentAsync(WInterStormPreparePlayerItem, PLAYER_ITEM_OPT_PATH, parentRoot)
    table.insert(self.playerItems, item)
  end
  self.textTime = self:AddComponent(UIText, text_time_path)
  self.textBtnPrepare = self:AddComponent(UIText, txt_btn_prepare_path)
  self.textBtnPrepare:SetLocalText("winter_battlefield_interface_tips1020")
  self.btnPrepare = self:AddComponent(UIButton, btn_prepare_path)
  self.btnPrepare:SetOnClick(function()
    self:PrepareBtnClick()
  end)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  local needTip = DataCenter.StatusManager:WarFeverStatu() ~= nil
  self.text_tip:SetActive(needTip)
end

function UIWinterStormMatching:ComponentDestroy()
  self.textTitle = nil
  self.textReadyNum = nil
  self.textReady = nil
  self.middleRoot01 = nil
  self.middleRoot02 = nil
  self.playerItems = nil
  self.textTime = nil
  self.btnPrepare = nil
  self.textBtnPrepare = nil
end

function UIWinterStormMatching:OnAddListener()
  base.OnAddListener(self)
  if not self.addListener then
    self:AddUIListener(EventId.WinterStormMatchRefresh, self.UpdateUI)
    self.addListener = true
  end
end

function UIWinterStormMatching:OnRemoveListener()
  if self.addListener then
    self:RemoveUIListener(EventId.WinterStormMatchRefresh, self.UpdateUI)
    self.addListener = false
  end
  base.OnRemoveListener(self)
end

function UIWinterStormMatching:Update1000MS()
  if not self.textTime:GetActive() then
    return
  end
  if self:CheckReadyAutoClose() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.timeoutEnd - curTime
  local txt = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime < 0 and 0 or remainTime)
  self.textTime:SetText(txt)
  if remainTime < -10 then
    self.textTime:SetActive(false)
    ActMgr:ReqActInfo()
    self.ctrl:CloseSelf()
  end
end

function UIWinterStormMatching:CheckReadyAutoClose()
  if not ActMgr:MatchNewCheckFlag() then
    return false
  end
  local selfReadyTime = ActMgr.selfReadyTime or 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if 0 < selfReadyTime and 1 < curTime - selfReadyTime then
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
    return true
  end
  return false
end

function UIWinterStormMatching:TryAutoSendReady()
  if not ActMgr:MatchNewCheckFlag() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastMachClickTime = ActMgr.lastMachClickTime or 0
  local autoTime = LuaEntry.DataConfig:TryGetNum("winter_bf_S0", "k3", 180)
  if 0 < autoTime and 0 < lastMachClickTime and autoTime > curTime - lastMachClickTime then
    self:PrepareBtnClick()
  end
end

function UIWinterStormMatching:UpdateUI()
  if self:CheckReadyAutoClose() then
    return
  end
  local info = ActMgr:GetMatchPushInfo()
  if info == nil then
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
    return
  end
  self.timeoutEnd = info.timeoutEnd
  self.textTime:SetActive(true)
  local readyCnt = info.readyCnt == nil and 0 or info.readyCnt
  self.textReadyNum:SetText(readyCnt)
  local bSelfReady = false
  local selfUid = LuaEntry.Player:GetUid()
  if self.playerItems ~= nil then
    for i, v in ipairs(self.playerItems) do
      local teamArr = info.team[i]
      if teamArr ~= nil then
        if teamArr.uid == selfUid then
          bSelfReady = teamArr.b_ready
        end
        v:SetPlayer(teamArr)
      end
    end
  end
  self.btnPrepare:SetActive(not bSelfReady)
  self.textReady:SetActive(bSelfReady)
  if not bSelfReady then
    self:TryAutoSendReady()
  end
  self:Update1000MS()
end

function UIWinterStormMatching:RejectBtnClick()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.timeoutEnd - curSec
  if remainTime < 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.RejectBtnClickTime == nil or curTime - self.RejectBtnClickTime > 3000 then
    ActMgr:SendMatchReady(false)
    self.RejectBtnClickTime = curTime
  end
end

function UIWinterStormMatching:PrepareBtnClick()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.timeoutEnd - curSec
  if remainTime < 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastPrepareBtnClickTime == nil or curTime - self.lastPrepareBtnClickTime > 3000 then
    ActMgr:SendMatchReady(true)
    self.lastPrepareBtnClickTime = curTime
  end
end

return UIWinterStormMatching
