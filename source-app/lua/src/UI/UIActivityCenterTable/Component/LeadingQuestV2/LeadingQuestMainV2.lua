local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LeadingQuestMainV2 = BaseClass("LeadingQuestMainV2", base)
local Localization = CS.GameEntry.Localization
local LeadingQuestItem = require("UI.UIActivityCenterTable.Component.LeadingQuestV2.LeadingQuestItemV2")
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local title_path = "RightView/Top/title"
local subTitle_path = "RightView/Top/subTitle"
local remainTime_path = "RightView/Top/TimeBg/remainTime"
local svQuest_path = "RightView/Rect_Bottom/ScrollView"
local content_path = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local bg1_path = "Bg1"
local activityDetailBtn_path = "RightView/Top/InfoBtn"
local progress_path = "RightView/Top/combatBg/progressBg/progress"
local progress_text_path = "RightView/Top/combatBg/progressBg/progressText"
local upgrade_btn_path = "RightView/Top/combatBg/upgradeBtn"

function LeadingQuestMainV2:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LeadingQuestMainV2:OnDestroy()
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LeadingQuestMainV2:ComponentDefine()
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.subTitleN = self:AddComponent(UITextMeshProUGUIEx, subTitle_path)
  self.remainTimeN = self:AddComponent(UITextMeshProUGUIEx, remainTime_path)
  self.svQuestsN = self:AddComponent(UIScrollView, svQuest_path)
  self.svQuestsN:SetOnItemMoveIn(function(itemObj, index)
    self:OnQuestItemMoveIn(itemObj, index)
  end)
  self.svQuestsN:SetOnItemMoveOut(function(itemObj, index)
    self:OnQuestItemMoveOut(itemObj, index)
  end)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.bg1N = self:AddComponent(UIImage, bg1_path)
  self.activityDetailBtn = self:AddComponent(UIButton, activityDetailBtn_path)
  self.activityDetailBtn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    param.hideSubTile = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.progress = self:AddComponent(UIImage, progress_path)
  self.fg = self.progress.transform:GetComponent(UnityRectTransform)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
end

function LeadingQuestMainV2:ComponentDestroy()
  self.titleN = nil
  self.subTitleN = nil
  self.remainTimeN = nil
  self.contentN = nil
  self.templateN = nil
  self.bg1N = nil
  self.activityDetailBtn = nil
  self.progress = nil
  self.progress_text = nil
  self.upgrade_btn = nil
end

function LeadingQuestMainV2:DataDefine()
  self.activityId = nil
  self.activityData = nil
  self.activityInfo = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
end

function LeadingQuestMainV2:DataDestroy()
  self.activityId = nil
  self.activityData = nil
  self.activityInfo = nil
  self.CountDownTimerAction = nil
  self.countDownTimer = nil
end

function LeadingQuestMainV2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeadingQuestV2TaskUpdated, self.ShowTasks)
  self:AddUIListener(EventId.OnLeadingQuestV2DataUpdated, self.RefreshWhenReceiveDataUpdate)
end

function LeadingQuestMainV2:OnRemoveListener()
  self:RemoveUIListener(EventId.OnLeadingQuestV2TaskUpdated, self.ShowTasks)
  self:RemoveUIListener(EventId.OnLeadingQuestV2DataUpdated, self.RefreshWhenReceiveDataUpdate)
  base.OnRemoveListener(self)
end

function LeadingQuestMainV2:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityInfo = DataCenter.LWLeadingQuestV2Manager.info
  self:RefreshAll()
  CS.GameEntry.Setting:SetBool("OpenedLeadingQuestV2View_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LeadingQuestMainV2:RefreshWhenReceiveDataUpdate()
  self.activityInfo = DataCenter.LWLeadingQuestV2Manager.info
  self:RefreshAll()
end

function LeadingQuestMainV2:RefreshAll()
  self.titleN:SetText(Localization:GetString(self.activityData.name))
  self.subTitleN:SetText(Localization:GetString(self.activityData.desc_info))
  self:AddCountDownTimer()
  self:RefreshRemainTime()
  self:ShowTasks()
  self:RefreshPower()
end

function LeadingQuestMainV2:RefreshPower()
  local cur = LuaEntry.Player.power
  local max = 0
  if self.activityData then
    max = tonumber(self.activityData.para) or 0
  end
  if cur >= max then
    self.progress_text:SetText("<color=#5fef87>" .. string.GetFormattedSeperatorNum(cur) .. "</color>" .. "/" .. string.GetFormattedSeperatorNum(max))
  else
    self.progress_text:SetText(string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(max))
  end
  local pro = 0
  if 0 < max then
    pro = cur / max
    pro = math.min(1, pro)
    self.fg:Set_sizeDelta(pro * 554, 41)
  end
end

function LeadingQuestMainV2:GetTaskListSorted()
  if not self.activityInfo then
    return {}
  end
  local tasks = self.activityInfo.taskArr
  table.sort(tasks, function(a, b)
    local taskValueA = a
    local taskValueB = b
    if not taskValueA then
      return false
    elseif not taskValueB then
      return true
    elseif taskValueA.state ~= taskValueB.state then
      if taskValueA.state == 1 then
        return true
      elseif taskValueB.state == 1 then
        return false
      elseif taskValueA.state == 2 then
        return false
      elseif taskValueB.state == 2 then
        return true
      end
    else
      return tonumber(a.taskId) < tonumber(b.taskId)
    end
  end)
  return tasks
end

function LeadingQuestMainV2:ShowTasks()
  self.taskList = self:GetTaskListSorted()
  if #self.taskList > 0 then
    self.svQuestsN:SetTotalCount(#self.taskList)
    self.svQuestsN:RefillCells()
  end
end

function LeadingQuestMainV2:AddCountDownTimer()
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

function LeadingQuestMainV2:RefreshRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remainTimeN:SetText("")
    self:DelCountDownTimer()
  end
end

function LeadingQuestMainV2:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function LeadingQuestMainV2:OnUpgradeBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILeadingQuestWay, {anim = false})
end

function LeadingQuestMainV2:OnQuestItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svQuestsN:AddComponent(LeadingQuestItem, itemObj)
  cellItem:SetItem(self.taskList[index], nil, self.activityInfo.activityId)
end

function LeadingQuestMainV2:OnQuestItemMoveOut(itemObj, index)
  self.svQuestsN:RemoveComponent(itemObj.name, LeadingQuestItem)
end

function LeadingQuestMainV2:ClearScroll()
  self.svQuestsN:ClearCells()
  self.svQuestsN:RemoveComponents(LeadingQuestItem)
end

return LeadingQuestMainV2
