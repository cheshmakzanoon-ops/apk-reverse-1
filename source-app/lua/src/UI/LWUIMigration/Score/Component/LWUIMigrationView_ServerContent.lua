local LWUIMigrationView_ServerContent = BaseClass("LWUIMigrationView_ServerContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ServerItem = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_ServerItem")
local text_title_path = "Title"
local btn_info_path = "Title/BtnInfo"
local text_desc_path = "Info/Desc"
local text_num_path = "Info/NumText"
local info2_path = "Info2"
local text_num2_path = "Info2/NumText2"
local di_path = "Di"
local scroll_view_path = "Di/ScrollView"
local text_wait_path = "Di/ScrollView/WaitTip"

function LWUIMigrationView_ServerContent:OnCreate()
  base.OnCreate(self)
  self.state = ActMigrationState.Notice
  self.endTime = 0
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.text_desc = self:AddComponent(UIText, text_desc_path)
  self.text_num = self:AddComponent(UIText, text_num_path)
  self.info2 = self:AddComponent(UIBaseComponent, info2_path)
  self.text_num2 = self:AddComponent(UIText, text_num2_path)
  self.di = self:AddComponent(UIBaseComponent, di_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.text_wait = self:AddComponent(UIText, text_wait_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  local openCfg = DataCenter.ActMigrationManager:GetOpenConfig()
  local num = openCfg ~= nil and openCfg.top_rank_count or 0
  self.text_title:SetLocalText("migration_activity_interface_10027", num)
end

function LWUIMigrationView_ServerContent:OnDestroy()
  self:DeleteTimer()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(ServerItem)
  self.state = ActMigrationState.Notice
  self.endTime = 0
  base.OnDestroy(self)
end

function LWUIMigrationView_ServerContent:OnBtnInfoClick()
  local str = Localization:GetString(DataCenter.ActMigrationManager:GetSeasonTips(2))
  UIUtil.ShowIntro(Localization:GetString("migration_activity_interface_10012"), nil, str)
end

function LWUIMigrationView_ServerContent:SetData()
  local mgr = DataCenter.ActMigrationManager
  local _, stageInfo = mgr:GetCurStageInfo()
  self.state = stageInfo ~= nil and stageInfo.state or ActMigrationState.Notice
  self.endTime = stageInfo ~= nil and stageInfo.eTime or 0
  self.text_wait:SetActive(self.state < ActMigrationState.Prepare)
  local diH = 510
  if self.state < ActMigrationState.Prepare then
    self:AddTimer()
    self.text_desc:SetLocalText("migration_activity_interface_10116")
    self.info2:SetActive(false)
    diH = 620
  else
    self:DeleteTimer()
    self.text_desc:SetLocalText("migration_activity_interface_10115")
    self.info2:SetActive(true)
    local actInfo = mgr:GetActInfo()
    local score = actInfo ~= nil and actInfo.baseScore or 0
    self.text_num:SetText(string.GetFormattedSeparatorNum(math.floor(score)))
    score = actInfo ~= nil and actInfo.baseScoreHalf or 0
    self.text_num2:SetText(string.GetFormattedSeparatorNum(math.floor(score)))
  end
  local size = self.di:GetSizeDelta()
  size.y = diH
  self.di:SetSizeDelta(size)
  local actInfo = mgr:GetActInfo()
  self.serverList = actInfo ~= nil and actInfo.serverIdList or {}
  local l = #self.serverList
  self.scroll_view:SetTotalCount(l)
  if 0 < l then
    self.scroll_view:RefillCells()
  end
end

function LWUIMigrationView_ServerContent:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local serverId = self.serverList[index]
  local item = self.scroll_view:AddComponent(ServerItem, itemObj)
  item:SetData(serverId, self.state)
end

function LWUIMigrationView_ServerContent:OnDeleteCell(itemObj, _)
  self.scroll_view:RemoveComponent(itemObj.name, ServerItem)
end

function LWUIMigrationView_ServerContent:AddTimer()
  self:DeleteTimer()
  if self.timer_action == nil then
    function self.timer_action(_)
      self:TimerAction()
    end
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, true, false)
  self.timer:Start()
end

function LWUIMigrationView_ServerContent:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWUIMigrationView_ServerContent:TimerAction()
  local uitMgr = UITimeManager:GetInstance()
  local curTime = uitMgr:GetServerTime()
  local remainTime = self.endTime - curTime
  remainTime = remainTime < 0 and 0 or remainTime
  self.text_num:SetText(uitMgr:SecondToFmtString(remainTime / 1000))
  if remainTime == 0 then
    self:DeleteTimer()
  end
end

return LWUIMigrationView_ServerContent
