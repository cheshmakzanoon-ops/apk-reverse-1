local UIActMonopolyLoopTaskView = BaseClass("UIActMonopolyLoopTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIActMonopolyLoopTaskItem = require("UI.UIActMonopoly.UIActMonopolyLoopTask.Component.UIActMonopolyLoopTaskItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local closeBtn_path = "UICommonPopUpTitle/CommonActivityPopUpBgPart/CloseBtn"
local colsebg_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "contentView/ScrollView"
local task_content_path = "contentView/ScrollView/Viewport/taskContent"
local u_i_act_slot_task_item_path = "contentView/itemContent/UIActMonopolyLoopTaskItem"
local task_item_content_path = "contentView/ScrollView/Viewport/taskContent/taskItemContent"
local progress_bg_path = "contentView/ScrollView/Viewport/taskContent/progressBg"
local progress_img_path = "contentView/ScrollView/Viewport/taskContent/progressBg/progressImg"
local tip_item_path = "contentView/infoContent/eventContent/tipItem"
local event_item_path = "contentView/infoContent/eventContent/eventIconItems/eventItem"
local time_content_path = "contentView/timeContent"
local time_txt_path = "contentView/timeContent/timeTxt"
local tip_btn_path = "UICommonPopUpTitle/TipBtn"
local tip_icon_path = "contentView/infoContent/tipContent/tipIcon"
local tip_icon_txt_path = "contentView/infoContent/tipContent/tipIconTxt"
local tipNum = 3
local eventNum = 3

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId, self.actMonopolyId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.actMonopolyId = tonumber(self.actMonopolyId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActTaskManager:GetActData(self.activityId)
  self.actMonopolyInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actMonopolyId)
  self.paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.actMonopolyInfo.richman_para)
  self:ComponentDefine()
  self:RefreshView()
  self:OnOpenJumpPos()
  self:SetConfigView()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  PostEventLog.Track(PostEventLog.Defines.ActMonopolyLoopTaskOpen, {})
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.colsebg = self:AddComponent(UIButton, colsebg_path)
  self.colsebg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.u_i_act_slot_task_item = self:AddComponent(UIBaseContainer, u_i_act_slot_task_item_path)
  self.task_content = self:AddComponent(UIBaseContainer, task_content_path)
  self.task_content:SetAnchoredPositionXY(0, 0)
  self.task_item_content = self:AddComponent(UIBaseContainer, task_item_content_path)
  self.taskItemList = {}
  self.u_i_act_slot_task_item:SetActive(false)
  self.u_i_act_slot_task_item.gameObject:GameObjectCreatePool()
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetActive(true)
  self.tip_btn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
  self.tipItemList = {}
  for i = 1, tipNum do
    local tip_item = self:AddComponent(UIBaseContainer, tip_item_path .. i)
    self.tipItemList[i] = {
      root = tip_item,
      tipTxt = tip_item:AddComponent(UITextMeshProUGUIEx, "tipTxt")
    }
  end
  self.eventItemList = {}
  for i = 1, eventNum do
    local event_item = self:AddComponent(UIBaseContainer, event_item_path .. i)
    self.eventItemList[i] = {
      root = event_item,
      bg = event_item:AddComponent(UIImage, ""),
      val = event_item:AddComponent(UITextMeshProUGUIEx, "ValContent/val"),
      icon = event_item:AddComponent(UIImage, "ValContent/icon"),
      btn = event_item:AddComponent(UIButton, "")
    }
    self.eventItemList[i].btn:SetOnClick(function()
      self:OnEventItemClick(i)
    end)
  end
  self.tip_icon = self:AddComponent(UIImage, tip_icon_path)
  self.tip_icon_txt = self:AddComponent(UITextMeshProUGUIEx, tip_icon_txt_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "UICommonPopUpTitle/CommonActivityPopUpBgPart")
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.tip_icon = nil
  self.tip_icon_txt = nil
  self.commonActivityPopUpBgPart = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetTaskDataChangeMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetTaskDataChangeMsg)
end

local function ClearAllItem(self)
  self.task_item_content:RemoveComponents(UIActMonopolyLoopTaskItem)
  for _, v in ipairs(self.task_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_act_slot_task_item.gameObject:GameObjectRecycleAll()
  self.taskItemList = {}
end

local function RefreshView(self)
  self.showData = DataCenter.ActTaskManager:GetLoopTaskShowData(self.activityId)
  self.taskShowData = self.showData.taskList
  self.isDailyTask = DataCenter.ActTaskManager:IsDailyTask(self.activityId)
  local count = #self.taskShowData
  if #self.taskItemList ~= count then
    self:ClearAllItem()
    if 0 < count then
      for i = 1, count do
        local item = self.u_i_act_slot_task_item.gameObject:GameObjectSpawn(self.task_item_content.transform)
        item.name = i
        local obj = self.task_item_content:AddComponent(UIActMonopolyLoopTaskItem, item.name)
        obj:SetActive(true)
        self.taskItemList[i] = obj
      end
    end
  end
  local curIndex = -1
  for i = 1, count do
    if self.taskShowData[i].data.state ~= TaskState.Received then
      curIndex = i
      break
    end
  end
  if curIndex < 0 then
    curIndex = count
  end
  for i = 1, count do
    self.taskItemList[i]:SetData(self.activityId, self.taskShowData[i], i, curIndex, self.showData.finTaskNum, self.actMonopolyInfo)
  end
  self.progress_bg:SetAnchoredPositionXY(32, -80)
  self.progress_bg:SetSizeDeltaXY(37, 172 * (count - 1))
  self.progress_img:SetSizeDeltaXY(37, 172 * (curIndex - 1))
  local tipData = {}
  local eventIdData = {}
  local actMonopolyInfo = self.actMonopolyInfo
  local goodsAddScore = 0
  local gridAddScore = 0
  local paraTemp
  if actMonopolyInfo then
    paraTemp = self.paraTemp
    if paraTemp then
      tipData = string.split(paraTemp.event_key, "|")
      eventIdData = string.string2array_i_oneSep(paraTemp.event_para, "|")
      local item_add_score_data = string.split(paraTemp.item_add_score, ";")
      if item_add_score_data and #item_add_score_data == 3 then
        goodsAddScore = item_add_score_data[3]
      end
      local grid_add_score_data = string.split(paraTemp.grid_add_score, ";")
      if grid_add_score_data and #grid_add_score_data == 2 then
        gridAddScore = grid_add_score_data[2]
      end
    end
  end
  if tipData then
    self.tip_icon_txt:SetLocalText(tipData[1])
    for i = 1, tipNum do
      if i <= #tipData - 1 then
        self.tipItemList[i].root:SetActive(true)
        self.tipItemList[i].tipTxt:SetLocalText(tipData[i + 1], gridAddScore, goodsAddScore)
      else
        self.tipItemList[i].root:SetActive(false)
      end
    end
  end
  if eventIdData then
    for i = 1, eventNum do
      local eventData
      if i <= #eventIdData then
        eventData = LocalController:instance():getLine(TableName.RichManEvent, eventIdData[i])
      end
      if eventData then
        self.eventItemList[i].root:SetActive(true)
        local valData = string.string2array_i_oneSep(eventData.train_value, ";")
        if #valData == 2 then
          local goodsId = valData[1]
          local num = valData[2]
          local pic = RewardUtil.GetPic(RewardType.GOODS, goodsId)
          self.eventItemList[i].icon:LoadSprite(pic)
          self.eventItemList[i].val:SetText("+" .. num)
          self.eventItemList[i].bg:LoadSprite(string.format(UIAssets.UIActMonopolySpritePath, eventData.pic))
        end
      else
        self.eventItemList[i].root:SetActive(false)
      end
    end
  end
  if self.isDailyTask then
    self.time_content:SetActive(true)
    self:Update1000MS()
  else
    self.time_content:SetActive(false)
  end
end

local function OnGetTaskDataChangeMsg(self)
  self:RefreshView()
end

local function OnOpenJumpPos(self)
  local count = #self.taskShowData
  local itemH = 172
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
  local scrollH = self.scroll_view.rectTransform.rect.height
  local contentH = count * itemH
  local curIndex = -1
  for i = 1, count do
    if self.taskShowData[i].data.state ~= TaskState.Received then
      curIndex = i
      break
    end
  end
  if curIndex < 0 then
    curIndex = count
  end
  local jumpPosY = (curIndex - 1) * itemH
  local maxJump = math.max(0, contentH - scrollH)
  if jumpPosY > maxJump then
    jumpPosY = maxJump
  end
  self.task_content:SetAnchoredPositionXY(0, jumpPosY)
end

local function Update1000MS(self)
  if not self.isDailyTask then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curTaskEndTime = DataCenter.ActTaskManager:GetTaskEndTine(self.activityId)
  if curTaskEndTime <= 0 then
    return
  end
  if curTime < curTaskEndTime then
    local remainTime = curTaskEndTime - curTime
    local showText = UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000)
    self.time_txt:SetLocalText("activity_sports_uitips_028", showText)
  end
end

local function OnEventItemClick(self, index)
  if self.actMonopolyId == nil then
    return
  end
  local actMonopolyInfo = self.actMonopolyInfo
  if actMonopolyInfo == nil then
    return
  end
  local paraTemp = self.paraTemp
  if paraTemp == nil then
    return
  end
  local eventIdData = string.string2array_i_oneSep(paraTemp.event_para, "|")
  if index > #eventIdData or index > eventNum then
    return
  end
  local eventTemp = LocalController:instance():getLine(TableName.RichManEvent, eventIdData[index])
  local param = {}
  param.type = "nameDesc"
  param.title = eventTemp.name
  param.desc = eventTemp.desc
  param.alignObject = self.eventItemList[index].bg
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function OnTipBtnClick(self)
  if self.actMonopolyId == nil then
    return
  end
  if self.paraTemp == nil then
    return
  end
  local ext_key = self.paraTemp.ext_key
  if string.IsNullOrEmpty(ext_key) then
    return
  end
  local strList = string.split(ext_key, "|")
  if #strList < 2 then
    return
  end
  local param = {}
  param.title = strList[1]
  param.activityId = self.activityId
  param.activityRulesStr = Localization:GetString(strList[2])
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
end

local function SetConfigView(self)
  local showTemp = self.actMonopolyInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec1) then
    local path = string.format(UIAssets.UIActMonopolySpritePath, showTemp.pic_spec1)
    self.tip_icon:LoadSprite(path)
  end
end

UIActMonopolyLoopTaskView.OnCreate = OnCreate
UIActMonopolyLoopTaskView.OnDestroy = OnDestroy
UIActMonopolyLoopTaskView.ComponentDefine = ComponentDefine
UIActMonopolyLoopTaskView.ComponentDestroy = ComponentDestroy
UIActMonopolyLoopTaskView.SetConfigView = SetConfigView
UIActMonopolyLoopTaskView.RefreshView = RefreshView
UIActMonopolyLoopTaskView.OnAddListener = OnAddListener
UIActMonopolyLoopTaskView.OnRemoveListener = OnRemoveListener
UIActMonopolyLoopTaskView.ClearAllItem = ClearAllItem
UIActMonopolyLoopTaskView.OnGetTaskDataChangeMsg = OnGetTaskDataChangeMsg
UIActMonopolyLoopTaskView.Update1000MS = Update1000MS
UIActMonopolyLoopTaskView.OnOpenJumpPos = OnOpenJumpPos
UIActMonopolyLoopTaskView.OnEventItemClick = OnEventItemClick
UIActMonopolyLoopTaskView.OnTipBtnClick = OnTipBtnClick
return UIActMonopolyLoopTaskView
