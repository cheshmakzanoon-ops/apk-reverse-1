local UIChampionDuelBattleLogView = BaseClass("UIChampionDuelBattleLogView", UIBaseView)
local base = UIBaseView
local UIChampionDuelBattleLogGroup = require("UI.UIChampionDuel.BattleLog.Component.UIChampionDuelBattleLogGroup")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local text_empty_path = "Common_bg_orange/Common_bg_orange2/EmptyText"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local item_path = "Common_bg_orange/Common_bg_orange2/Item"
local group_content_path = "Common_bg_orange/Common_bg_orange2/groupContent"
local inputField_path = "Common_bg_orange/Common_bg_orange2/objInput/InputField"
local inputField_placeholder_path = "Common_bg_orange/Common_bg_orange2/objInput/InputField/Placeholder"
local btn_search_path = "Common_bg_orange/Common_bg_orange2/objInput/SearchBtn"

function UIChampionDuelBattleLogView:OnCreate()
  base.OnCreate(self)
  self.timers = {}
  self.logs = {}
  self.keys = {}
  self:ComponentDefine()
  local uid, name = self:GetUserData()
  if uid == nil then
    uid = LuaEntry.Player:GetUid()
    name = LuaEntry.Player:GetName()
  end
  self.inputField:SetText(name)
  DataCenter.ChampionDuelManager:ReqBattleLog(uid)
  self.scroll_view:SetActive(false)
  self.text_empty:SetActive(true)
end

function UIChampionDuelBattleLogView:OnDestroy()
  self:ComponentDestroy()
  self.logs = {}
  self.keys = {}
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelLogRefresh, self.UpdateList)
end

function UIChampionDuelBattleLogView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelLogRefresh, self.UpdateList)
  base.OnRemoveListener(self)
end

function UIChampionDuelBattleLogView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("310101")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_empty = self:AddComponent(UIText, text_empty_path)
  self.text_empty:SetLocalText("champion_duel_tips1095")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.groupContent = self.transform:Find(group_content_path).gameObject
  self.groupContent:GameObjectCreatePool()
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:OnEndEdit(value)
  end)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.inputField_placeholder:SetLocalText("champion_duel_tips1080")
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_search:SetOnClick(BindCallback(self, self.OnSearchClick))
end

function UIChampionDuelBattleLogView:ComponentDestroy()
  self:ClearDelays()
  self.content:RemoveComponents(UIChampionDuelBattleLogGroup)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.groupContent:GameObjectRecycleAll()
  self.groupContent = nil
  self.content = nil
  self.scroll_view = nil
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.text_empty = nil
  self.inputField = nil
  self.inputField_placeholder = nil
  self.btn_search = nil
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogView:ForceUpdateCb()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UIChampionDuelBattleLogView:OnInputFieldValueChange(value)
  self.inputField_placeholder:SetActive(value == "")
  if string.IsNullOrEmpty(value) or #value > MAX_AL_NAME_CHAR then
    CS.UIGray.SetGray(self.btn_search.transform, true, true)
  else
    CS.UIGray.SetGray(self.btn_search.transform, false, true)
  end
end

function UIChampionDuelBattleLogView:OnEndEdit(value)
  if string.IsNullOrEmpty(value) then
    local uid = self:GetUserData() or LuaEntry.Player:GetUid()
    self:UpdateList(uid)
  end
end

function UIChampionDuelBattleLogView:OnSearchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local value = self.inputField:GetText()
  if string.IsNullOrEmpty(value) or #value > MAX_AL_NAME_CHAR then
    UIUtil.ShowTipsId(120193)
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnClickTime ~= nil and curTime - self.lastBtnClickTime <= 3000 then
    return
  end
  self.lastBtnClickTime = curTime
  DataCenter.ChampionDuelManager:ReqBattleLog(value)
end

function UIChampionDuelBattleLogView:UpdateList(uid)
  self.targetUid = uid
  local MyInsert = table.insert
  local logList = DataCenter.ChampionDuelManager:GetLogsByUid(uid) or {}
  local logs = {}
  local keys = {}
  for _, v in ipairs(logList) do
    if v.stageId == ChampionDuelState.PreStage then
      MyInsert(keys, v.uuid)
      logs[v.uuid] = {v}
    else
      local key = v.stageId .. "_" .. v.my.uid .. "_" .. v.target.uid
      local tmpLogs = logs[key]
      if tmpLogs == nil then
        tmpLogs = {}
        logs[key] = tmpLogs
        MyInsert(keys, key)
      end
      MyInsert(tmpLogs, v)
    end
  end
  self.keys = keys
  self.logs = logs
  local cnt = #self.keys
  self.scroll_view:SetActive(0 < cnt)
  self.text_empty:SetActive(cnt == 0)
  self:ClearDelays()
  if 0 < cnt then
    self:RefreshList()
  end
end

function UIChampionDuelBattleLogView:ClearDelays()
  if self.timers ~= nil then
    for _, v in pairs(self.timers) do
      v:Stop()
    end
  end
  self.timers = {}
end

function UIChampionDuelBattleLogView:RefreshList()
  local cnt = #self.keys
  local maxNum = math.max(cnt, self.content.transform.childCount)
  local forceCb = BindCallback(self, self.ForceUpdateCb)
  local lastStage = 0
  for i = 1, maxNum do
    local name = "item" .. i
    local item = self.content:GetComponent(name, UIChampionDuelBattleLogGroup)
    if item ~= nil then
      item:SetActive(false)
    end
    local key = self.keys[i]
    if key ~= nil then
      do
        local logs = self.logs[key] or {}
        local bNewType = false
        if 0 < #logs then
          local firstLog = logs[1]
          if lastStage ~= firstLog.stageId then
            lastStage = firstLog.stageId
            bNewType = true
          end
        end
        self.timers[i] = TimerManager:GetInstance():DelayFrameInvoke(function()
          local timer = self.timers ~= nil and self.timers[i] or nil
          if timer then
            timer:Stop()
            self.timers[i] = nil
          end
          local cell = self.content.transform:Find(name)
          item = self.content:GetComponent(name, UIChampionDuelBattleLogGroup)
          if cell == nil then
            cell = self.groupContent:GameObjectSpawn(self.content.transform)
            cell.name = name
          end
          if item == nil then
            item = self.content:AddComponent(UIChampionDuelBattleLogGroup, name)
          end
          item:SetActive(true)
          item:ReInit(logs, self.theItem, self.targetUid, bNewType, forceCb)
          if i == maxNum then
            self:ForceUpdateCb()
          end
        end, i * 2)
      end
    end
  end
  self.scroll_view:SetVerticalNormalizedPosition(1)
end

return UIChampionDuelBattleLogView
