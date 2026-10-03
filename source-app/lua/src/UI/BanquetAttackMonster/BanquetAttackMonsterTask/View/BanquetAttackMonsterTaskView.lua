local BanquetAttackMonsterTaskView = BaseClass("BanquetAttackMonsterTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BanquetAttackMonsterTaskItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterTask.Component.BanquetAttackMonsterTaskItem")
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local colsebg_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "contentView/ScrollView"
local task_content_path = "contentView/ScrollView/Viewport/taskContent"
local u_i_act_slot_task_item_path = "contentView/UIActSlotTaskItem"
local task_item_content_path = "contentView/ScrollView/Viewport/taskContent/taskItemContent"
local progress_bg_path = "contentView/ScrollView/Viewport/taskContent/progressBg"
local progress_img_path = "contentView/ScrollView/Viewport/taskContent/progressBg/progressImg"
local time_txt_path = "contentView/timeTxt"
local confirm_btn_path = "contentView/confirmBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActBanquetV2Data
  self:ComponentDefine()
  self:RefreshView()
  self:Update1000MS()
  self:OnOpenJumpPos()
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
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetAttackMonsterTaskDataUpdate, self.OnGetTaskDataChangeMsg)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterTaskDataUpdate, self.OnGetTaskDataChangeMsg)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function ClearAllItem(self)
  self.task_item_content:RemoveComponents(BanquetAttackMonsterTaskItem)
  for _, v in ipairs(self.task_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_act_slot_task_item.gameObject:GameObjectRecycleAll()
  self.taskItemList = {}
end

local function RefreshView(self)
  self.taskShowData = self.activityDetailData.taskArrData
  local count = #self.taskShowData
  if #self.taskItemList ~= count then
    self:ClearAllItem()
    if 0 < count then
      for i = 1, count do
        local showData = self.taskShowData[i]
        local item = self.u_i_act_slot_task_item.gameObject:GameObjectSpawn(self.task_item_content.transform)
        item.name = i
        local obj = self.task_item_content:AddComponent(BanquetAttackMonsterTaskItem, item.name)
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
    self.taskItemList[i]:SetData(self.activityId, self.taskShowData[i], i, curIndex)
  end
  self.progress_bg:SetAnchoredPositionXY(37.6, -80)
  self.progress_bg:SetSizeDeltaXY(37, 172 * (count - 1))
  self.progress_img:SetSizeDeltaXY(37, 172 * (curIndex - 1))
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
  if self.time_txt ~= nil then
    local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
    self.time_txt:SetLocalText("104209", UITimeManager:GetInstance():SecondToFmtString(remainTime))
  end
end

local function OnPassDay(self)
  if self.activityId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if not actData or not actData:IsValid() then
      self.ctrl:CloseSelf()
      return
    end
  end
end

BanquetAttackMonsterTaskView.OnCreate = OnCreate
BanquetAttackMonsterTaskView.OnDestroy = OnDestroy
BanquetAttackMonsterTaskView.ComponentDefine = ComponentDefine
BanquetAttackMonsterTaskView.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterTaskView.RefreshView = RefreshView
BanquetAttackMonsterTaskView.OnAddListener = OnAddListener
BanquetAttackMonsterTaskView.OnRemoveListener = OnRemoveListener
BanquetAttackMonsterTaskView.ClearAllItem = ClearAllItem
BanquetAttackMonsterTaskView.OnGetTaskDataChangeMsg = OnGetTaskDataChangeMsg
BanquetAttackMonsterTaskView.Update1000MS = Update1000MS
BanquetAttackMonsterTaskView.OnPassDay = OnPassDay
BanquetAttackMonsterTaskView.OnOpenJumpPos = OnOpenJumpPos
return BanquetAttackMonsterTaskView
