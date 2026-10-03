local LWUIMigrationResultView = BaseClass("LWUIMigrationResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MatterItem = require("UI.LWUIMigration.Result.Component.LWUIMigration_Matter")
local closeBg_path = "panel"
local bg_path = "Common_bg_orange"
local close_btn_path = "Common_bg_orange/CloseBtn"
local btn_go_path = "Common_bg_orange/Bg2/GoBtn"
local toggle_check_path = "Common_bg_orange/Bg2/Info/CheckToggle"
local content_path = "Common_bg_orange/Bg2/Info/Content"
local item_path = "Common_bg_orange/Bg2/Info/Item"
local text_count_path = "Common_bg_orange/Bg2/Info/CountText"
local player_path = "Common_bg_orange/Bg3/Player"
local text_server_path = "Common_bg_orange/Bg3/ServerText"
local text_name_path = "Common_bg_orange/Bg3/NameText"
local text_word_path = "Common_bg_orange/Bg3/WordBg/WordText"
local btn_info_path = "Common_bg_orange/Bg2/Info/CountDesc/BtnInfo"
local NBM_MSG_SEND_TIME = 0
local FAKE_TEST = false

function LWUIMigrationResultView:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self, self.OnClickPanel))
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(BindCallback(self, self.OnBtnGoClick))
  self.toggle_check = self:AddComponent(UIToggle, toggle_check_path)
  self.toggle_check:SetOnValueChanged(function(_)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.text_count = self:AddComponent(UIText, text_count_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_word = self:AddComponent(UIText, text_word_path)
  self.panelLoading = self:AddComponent(UIBaseContainer, "panelLoading")
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    local strTip = Localization:GetString("migration_activity_interface_10135")
    UIUtil.ShowBubbleTips(strTip, self.btn_info.transform.position, 0, -30, 0)
  end)
  self:UpdateUI()
end

function LWUIMigrationResultView:OnDestroy()
  NBM_MSG_SEND_TIME = 0
  self.content:RemoveComponents(MatterItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  DataCenter.ActMigrationManager:ClearFakeLoading()
  base.OnDestroy(self)
end

function LWUIMigrationResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationMsg, self.HandleMigrateMsg)
  self:AddUIListener(EventId.ActMigrationPushMsg, self.HandleMigratePushMsg)
end

function LWUIMigrationResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationMsg, self.HandleMigrateMsg)
  self:RemoveUIListener(EventId.ActMigrationPushMsg, self.HandleMigratePushMsg)
  base.OnRemoveListener(self)
end

function LWUIMigrationResultView:OnClickPanel()
  if not self.panelLoading:GetActive() then
    self.ctrl:CloseSelf()
  end
end

function LWUIMigrationResultView:OnBtnGoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local checkC = self.toggle_check:GetIsOn()
  if not checkC then
    UIUtil.ShowTipsId("migration_activity_tips_20018")
    return
  end
  if not self.allFinish then
    return
  end
  if self.eTime and self.eTime > 0 then
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("migration_activity_tips_20016"),
      btnNum = 2,
      showToggle = false,
      sureAction = function()
        UIUtil.ShowSecondMessageByParam({
          tipText = Localization:GetString("migration_activity_tips_20019", LuaEntry.Player:GetSourceServerId(), self.serverId),
          btnNum = 2,
          showToggle = false,
          sureAction = function()
            NBM_MSG_SEND_TIME = UITimeManager:GetInstance():GetServerTime()
            self.accept = true
            if self.eTime and self.eTime > 0 then
              DataCenter.ActMigrationManager:ReqMigrate()
            else
              UIUtil.ShowTipsId("migration_activity_tips_20046")
            end
          end
        })
      end
    })
  else
    UIUtil.ShowTipsId("migration_activity_tips_20046")
  end
end

function LWUIMigrationResultView:HandleMigrateMsg(status)
  local accept = self.accept
  if accept and status == 0 then
    local remainTime = UITimeManager:GetInstance():GetServerTime() - NBM_MSG_SEND_TIME
    Logger.LogInfo("[LWUIMigrationResultView:HandleMigrateMsg] costTime=", remainTime, "accept=", tostring(accept))
    if remainTime < 3000 then
      TimerManager:GetInstance():DelayInvoke(function()
        self:DealMigrate(accept, status)
      end, (3000 - remainTime) / 1000)
      return
    end
  end
  self:DealMigrate(accept, status)
end

function LWUIMigrationResultView:DealMigrate(accept, status)
  if accept and status == 0 then
    CS.ApplicationLaunch.Instance:ReloadGame()
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIMigrationResultView:HandleMigratePushMsg()
  local cb
  if FAKE_TEST then
    self.accept = true
    
    function cb()
      self:HandleMigrateMsg(0)
    end
  end
  self.bg:SetActive(false)
  DataCenter.ActMigrationManager:LoadFakeLoading(self.panelLoading, cb)
end

function LWUIMigrationResultView:UpdateUI()
  self.bg:SetActive(true)
  self.panelLoading:SetActive(false)
  self:UpdateInfo()
  self:UpdateLayout()
  self:Update1000MS()
end

function LWUIMigrationResultView:UpdateInfo()
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local aInfo = myInfo ~= nil and myInfo.approverInfo or nil
  if aInfo then
    self.player:ParseHeadInfo(aInfo)
    self.serverId = myInfo.serverId
    local sInfo = mgr:GetServerInfo(self.serverId)
    local bQueen = sInfo ~= nil and sInfo.firstLadyInfo ~= nil and sInfo.firstLadyInfo.uid == aInfo.uid
    local zz = Localization:GetString(bQueen and 457203 or 457202)
    self.text_server:SetText("#" .. self.serverId .. " " .. zz)
    local text = UIUtil.FormatAllianceAndName(aInfo.abbr, aInfo.name, aInfo.uid)
    self.text_name:SetText(text)
    self.text_word:SetLocalText("migration_activity_interface_10076", self.serverId)
  end
  local _, stageInfo = mgr:GetCurStageInfo()
  self.eTime = mgr:GetStageEndTime(stageInfo)
end

function LWUIMigrationResultView:UpdateLayout()
  local flag = true
  for i = 1, 4 do
    local name = "item" .. i
    local cell = self.theItem:GameObjectSpawn(self.content.transform)
    cell.name = name
    local item = self.content:AddComponent(MatterItem, name)
    item:SetActive(true)
    if not item:SetData(i) then
      flag = false
    end
  end
  self.allFinish = flag
  CS.UIGray.SetGray(self.btn_go.transform, not flag, flag)
end

function LWUIMigrationResultView:Update1000MS()
  if self.eTime and self.eTime > 0 then
    local uitMgr = UITimeManager:GetInstance()
    local curTime = uitMgr:GetServerTime()
    local remainTime = self.eTime - curTime
    remainTime = remainTime < 0 and 0 or remainTime
    self.text_count:SetText(uitMgr:SecondToFmtString(remainTime / 1000))
    if remainTime == 0 then
      self.eTime = nil
    end
  end
end

return LWUIMigrationResultView
