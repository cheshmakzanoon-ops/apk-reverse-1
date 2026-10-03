local ActMonopolyItemUseView = BaseClass("ActMonopolyItemUseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActMonopolyItemUseItem = require("UI.UIActMonopoly.ActMonopolyItemUse.Component.ActMonopolyItemUseItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "CommonActivityPopUpBgPart/Common_img_title/titleText"
local close_btn_path = "CommonActivityPopUpBgPart/CloseBtn"
local task_progressbg_path = "Root/ResourceInfo/taskProgressbg"
local task_progress_img_path = "Root/ResourceInfo/taskProgressbg/taskProgressImg"
local task_progress_num_path = "Root/ResourceInfo/taskProgressbg/taskProgressNum"
local content_path = "Root/Scroll/Viewport/Content"
local l_w_act_monopoly_item_use_item_path = "Root/LWActMonopolyItemUseItem"
local tip_txt_path = "Root/tipTxt"
local icon_path = "Root/ResourceInfo/icon"

function ActMonopolyItemUseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function ActMonopolyItemUseView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActMonopolyItemUseView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.task_progressbg = self:AddComponent(UIImage, task_progressbg_path)
  self.task_progress_img = self:AddComponent(UIImage, task_progress_img_path)
  self.task_progress_num = self:AddComponent(UITextMeshProUGUIEx, task_progress_num_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.l_w_act_monopoly_item_use_item = self:AddComponent(UIBaseContainer, l_w_act_monopoly_item_use_item_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.itemList = {}
  self.l_w_act_monopoly_item_use_item:SetActive(false)
  self.l_w_act_monopoly_item_use_item.gameObject:GameObjectCreatePool()
  self.title_text:SetLocalText("activity_sports_useitem_title")
  self.tip_txt:SetLocalText("activity_sports_useitem_desc1")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
end

function ActMonopolyItemUseView:ComponentDestroy()
  self:ClearList()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.task_progressbg = nil
  self.task_progress_img = nil
  self.task_progress_num = nil
  self.content = nil
  self.l_w_act_monopoly_item_use_item = nil
  self.tip_txt = nil
  self.commonActivityPopUpBgPart = nil
end

function ActMonopolyItemUseView:OnEnable()
  base.OnEnable(self)
end

function ActMonopolyItemUseView:OnDisable()
  base.OnDisable(self)
end

function ActMonopolyItemUseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetActTaskDataUpdateMsg)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnGetActTaskDataUpdateMsg)
end

function ActMonopolyItemUseView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetActTaskDataUpdateMsg)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnGetActTaskDataUpdateMsg)
end

function ActMonopolyItemUseView:ReInit()
  self:InitData()
  self:RefreshTaskContent()
  self:RefreshItemContent(true)
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
end

function ActMonopolyItemUseView:InitData()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  self.paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
  self.usebox_list = self.paraTemp.usebox_list
  self.targetActId = tonumber(self.activityDetailData.achieveActivityId)
  self.targetActData = DataCenter.ActTaskManager:GetActData(self.targetActId)
  self.isLoopTask = DataCenter.ActTaskManager:IsLoopTask(self.targetActId)
  self.isDailyTask = DataCenter.ActTaskManager:IsDailyTask(self.targetActId)
  if self.paraTemp and not string.IsNullOrEmpty(self.paraTemp.get_jindu) then
    local textPara = string.split(self.paraTemp.get_jindu, "|")
    if #textPara == 2 then
      self.title_text:SetLocalText(textPara[1])
      self.tip_txt:SetLocalText(textPara[2])
    end
  end
end

function ActMonopolyItemUseView:RefreshTaskContent()
  self.showData = DataCenter.ActTaskManager:GetLoopTaskShowData(self.targetActId)
  self.targetTaskData = nil
  for i, v in ipairs(self.showData.taskList) do
    if v.data.state ~= TaskState.Received then
      self.targetTaskData = v
      break
    end
  end
  if self.targetTaskData == nil then
    self.targetTaskData = self.showData.taskList[#self.showData.taskList]
  end
  local curNum = self.targetTaskData.data.num and self.targetTaskData.data.num or 0
  local targetNum = self.targetTaskData.temp:GetTargetNum()
  local process = curNum
  if self.targetTaskData.data.state ~= TaskState.Received then
    process = curNum .. "/" .. targetNum
  end
  local progressRate = 0
  if 0 < targetNum then
    progressRate = curNum / targetNum
    progressRate = math.min(progressRate, 1)
  end
  self.task_progress_num:SetText(process)
  local bgSizeDelta = self.task_progressbg:GetSizeDelta()
  self.task_progress_img:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
  local imgPath = string.format(LoadPath.ItemPath, self.targetTaskData.temp.slots_icon)
  self.icon:LoadSprite(imgPath)
end

function ActMonopolyItemUseView:RefreshItemContent(isFirst)
  local dataNum = #self.usebox_list
  local itemNum = #self.itemList
  if dataNum ~= itemNum then
    self:ClearList()
    for i = 1, dataNum do
      local index = i
      local item = self.l_w_act_monopoly_item_use_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = index
      local obj = self.content:AddComponent(ActMonopolyItemUseItem, item.name)
      obj:SetActive(true)
      self.itemList[index] = obj
    end
  end
  for i = 1, dataNum do
    self.itemList[i]:SetData(self.activityId, self.usebox_list[i], isFirst)
  end
end

function ActMonopolyItemUseView:ClearList()
  self.content:RemoveComponents(ActMonopolyItemUseItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.l_w_act_monopoly_item_use_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function ActMonopolyItemUseView:UseItemSuccessHandle()
  self:RefreshTaskContent()
  self:RefreshItemContent()
  local itemUseNum = self.activityDetailData:GetItemUseRedNum()
  if itemUseNum <= 0 then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ActMonopolyItemUseView:OnGetActTaskDataUpdateMsg()
  self:RefreshTaskContent()
end

return ActMonopolyItemUseView
