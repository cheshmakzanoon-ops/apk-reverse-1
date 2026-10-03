local PersonalTargetView = BaseClass("PersonalTargetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PersonalTargetItem = require("UI.UIGovernment.PersonalTarget.Component.PersonalTargetItem")
local kingStageType = 100
local panel_path = "panel"
local reward_item_path = "PopUpTitle/Common_bg_orange2/RewardItem"
local cell_path = "PopUpTitle/Common_bg_orange2/cell"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local info_btn_path = "PopUpTitle/InfoBtn"

function PersonalTargetView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.theCellItem = self.transform:Find(cell_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  self:ShowTasks()
end

function PersonalTargetView:ShowTasks()
  local goItem, theItem
  local data = DataCenter.ActivityStageTemplateManager:GetTemplate(kingStageType)
  if data == nil then
    return
  end
  local taskList = data:GetQuests()
  local tasks = {}
  local taskCount = 0
  for _, taskId in pairs(taskList) do
    local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
    if taskInfo then
      table.insert(tasks, taskId)
      taskCount = taskCount + 1
    end
  end
  table.sort(tasks, function(a, b)
    local taskValueA = DataCenter.TaskManager:FindTaskInfo(a)
    local taskValueB = DataCenter.TaskManager:FindTaskInfo(b)
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
      return tonumber(a) < tonumber(b)
    end
  end)
  self.content:RemoveComponents(PersonalTargetItem)
  self.theCellItem:GameObjectRecycleAll()
  self.theItem:GameObjectRecycleAll()
  self.taskList = tasks
  for i = 1, taskCount do
    local levelName = "item_" .. i
    goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    theItem = self.content:AddComponent(PersonalTargetItem, levelName)
    theItem:ReInit(i, self.theItem, tasks[i])
  end
end

function PersonalTargetView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PersonalTargetView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function PersonalTargetView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function PersonalTargetView:OnPassDay()
  if not DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.KingActivity.Type) then
    self.ctrl:CloseSelf()
  end
end

function PersonalTargetView:ComponentDefine()
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.reward_item = self:AddComponent(UIBaseContainer, reward_item_path)
  self.cell = self:AddComponent(UIImage, cell_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text:SetLocalText("457008")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("457009")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
end

function PersonalTargetView:ComponentDestroy()
  self.content:RemoveComponents(PersonalTargetItem)
  self.theCellItem:GameObjectRecycleAll()
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content = nil
  self.btn_back = nil
end

function PersonalTargetView:UpdateData()
end

return PersonalTargetView
