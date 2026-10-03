local UITaskMain = BaseClass("UITaskMain", UIBaseContainer)
local base = UIBaseContainer
local UIQuestCell = require("UI.UIMainTask.Component.UIQuestCellNew")
local this_path = "HaveTask/ScrollView/Content"
local rect_main_path = "HaveTask/ScrollView/Content/Rect_Main"
local txt_main_path = "HaveTask/ScrollView/Content/Rect_Main/Txt_Main"
local rect_vice_path = "HaveTask/ScrollView/Content/Rect_Vice"
local txt_vice_path = "HaveTask/ScrollView/Content/Rect_Vice/Txt_Vice"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.isTween = false
end

local function OnDisable(self)
  base.OnDisable(self)
  self:SetAllCellDestroy()
end

local function ComponentDefine(self)
  self.listGO = {}
  self.content = self:AddComponent(UIBaseContainer, this_path)
  self.scroll_view = self:AddComponent(UIBaseContainer, "HaveTask/ScrollView")
  self.rect_main = self:AddComponent(UIBaseContainer, rect_main_path)
  self.txt_main = self:AddComponent(UIText, txt_main_path)
  self.rect_vice = self:AddComponent(UIBaseContainer, rect_vice_path)
  self.txt_vice = self:AddComponent(UIText, txt_vice_path)
  self.animationList = {}
end

local function ComponentDestroy(self)
  self.content = nil
  self:DeleteTimer()
end

local function DataDefine(self)
  self.param = {}
  self.list = {}
  self.timer = nil
  self.deleteIndex = 0
  self.animIndex = 1
  self.isTween = false
  self.num = 0
end

local function DataDestroy(self)
  self.param = nil
  self.list = nil
  self.timer_action = nil
  self.timer = nil
  self.deleteIndex = nil
  self.isTween = nil
  self.num = nil
end

local function OnInitScroll(self, go, index)
  local item = self.scroll_view:AddComponent(UIQuestCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local sub = self.list[index + 1]
  local cellItem = self.listGO[go]
  if sub == nil then
    return
  end
  local param = {}
  param.id = sub.id
  param.index = index + 1
  
  function param.callBack(tempIndex)
    self:OnClickCallBack(tempIndex)
  end
  
  cellItem:ResetDoTween()
  cellItem:ReInit(param)
end

local function OnDestroyScrollItem(self, go, index)
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(UIQuestCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function ReInit(self)
  self:SetAllCellDestroy()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.txt_main:SetLocalText(170014)
  self.txt_vice:SetLocalText(170016)
  self.list = DataCenter.TaskManager:GetAllMainTask()
  local tempCount = table.count(self.list)
  self.cellList = {}
  self.model = {}
  if 0 < tempCount then
    local mainPos = 0
    local sidePos = 0
    for i = 1, #self.list do
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.list[i].id)
      if template.listType == 0 then
        mainPos = mainPos + 1
      elseif template.listType == 1 then
        sidePos = sidePos + 1
      end
    end
    if mainPos == 0 then
      self.rect_main:SetActive(false)
    else
      self.rect_main:SetActive(false)
      self.rect_main.transform:SetAsFirstSibling()
    end
    if sidePos == 0 then
      self.rect_vice:SetActive(false)
    else
      self.rect_vice:SetActive(false)
    end
    for i = 1, tempCount do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIQuestCellNew, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        local cell = self.content:AddComponent(UIQuestCell, go.name)
        local param = {}
        param.id = self.list[i].id
        param.index = i
        
        function param.callBack(tempIndex)
          self:OnClickCallBack(tempIndex)
        end
        
        cell:ResetDoTween()
        cell:ReInit(param)
        self.cellList[i] = cell
        if i == tempCount and sidePos ~= 0 then
          self.rect_vice.transform:SetSiblingIndex(mainPos + 1)
        end
      end)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

local function DoQuestShowAnimation(self)
  if #self.animationList > 0 then
    self.animatorIndex = 1
    self:AddTimer()
  end
end

local function SortAnimationList(self)
  self.animationList = {}
  table.walksort(self.listGO, function(leftKey, rightKey)
    return self.listGO[leftKey]:GetIndex() < self.listGO[rightKey]:GetIndex()
  end, function(k, v)
    if v ~= nil and v:GetIndex() >= self.deleteIndex then
      table.insert(self.animationList, k)
    end
  end)
end

local function AddTimer(self)
  for i = 1, #self.animationList do
    local key = self.animationList[i]
    if key ~= nil and self.listGO[key] ~= nil then
      self.listGO[key]:ResetTween()
    end
  end
  self.content:Remark(#self.list)
  self:DeleteTimer()
end

local function DeleteTimer(self)
  self.animatorIndex = 1
  self.deleteIndex = 0
  self.isTween = false
end

local function ForceUpdate(self)
  self.list = DataCenter.TaskManager:GetAllMainTask()
  self:AddAnimatorTimer()
end

local function OnClickCallBack(self, index)
  self.deleteIndex = index
  self.isTween = true
  DataCenter.TaskManager:SetMainTaskState(self.list[index].id)
  self:MainTaskSuccessSignal()
  self.num = self.num + 1
  EventManager:GetInstance():Broadcast(EventId.UpdateChatQuestRed, self.num)
end

local function AddAnimatorTimer(self)
  local mainPos = 0
  local sidePos = 0
  for i = 1, #self.list do
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.list[i].id)
    if template.listType == 0 then
      mainPos = mainPos + 1
    elseif template.listType == 1 then
      sidePos = sidePos + 1
    end
  end
  if mainPos == 0 then
    self.rect_main:SetActive(false)
  else
    self.rect_main:SetActive(false)
    self.rect_main.transform:SetAsFirstSibling()
  end
  if sidePos == 0 then
    self.rect_vice:SetActive(false)
  else
    self.rect_vice:SetActive(false)
  end
  for i = 1, #self.model do
    if i > self.deleteIndex then
      self.model[i].gameObject.transform:DOLocalMoveY(self.model[i - 1].gameObject.transform.anchoredPosition.y, 0.2):OnComplete(function()
        if i == #self.model then
          self.content:RemoveComponents(UIQuestCell)
          self:GameObjectDestroy(self.model[self.deleteIndex])
          table.remove(self.model, self.deleteIndex)
          table.remove(self.cellList, self.deleteIndex)
          local isNoCreateCell = true
          for k = 1, #self.list do
            if self.cellList[k] then
              local param = {}
              self.model[k].gameObject.name = "item" .. k
              param.id = self.list[k].id
              param.index = k
              
              function param.callBack(tempIndex)
                self:OnClickCallBack(tempIndex)
              end
              
              local cell = self.content:AddComponent(UIQuestCell, "item" .. k)
              cell:SetActive(true)
              cell:ResetDoTween()
              cell:ReInit(param)
              self.cellList[k] = cell
            else
              isNoCreateCell = false
              self.content:RemoveComponent("item" .. k, UIQuestCell)
              self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIQuestCellNew, function(request)
                if request.isError then
                  return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "item" .. k
                local cell = self.content:AddComponent(UIQuestCell, go.name)
                local param = {}
                param.id = self.list[k].id
                param.index = k
                
                function param.callBack(tempIndex)
                  self:OnClickCallBack(tempIndex)
                end
                
                cell:ResetDoTween()
                cell:ReInit(param)
                self.cellList[k] = cell
                self.isTween = false
                if k == #self.list and sidePos ~= 0 then
                  self.rect_vice.transform:SetSiblingIndex(mainPos + 1)
                end
              end)
            end
          end
          if isNoCreateCell then
            self.isTween = false
            if sidePos ~= 0 then
              self.rect_vice.transform:SetSiblingIndex(mainPos + 1)
            end
          end
        end
      end)
    end
  end
end

local function MainTaskSuccessSignal(self)
  if self.deleteIndex > 0 then
    self:ForceUpdate()
  end
end

local function IsTween(self)
  return self.isTween
end

UITaskMain.OnCreate = OnCreate
UITaskMain.OnDestroy = OnDestroy
UITaskMain.OnEnable = OnEnable
UITaskMain.OnDisable = OnDisable
UITaskMain.ComponentDefine = ComponentDefine
UITaskMain.ComponentDestroy = ComponentDestroy
UITaskMain.DataDefine = DataDefine
UITaskMain.DataDestroy = DataDestroy
UITaskMain.ReInit = ReInit
UITaskMain.OnAddListener = OnAddListener
UITaskMain.OnRemoveListener = OnRemoveListener
UITaskMain.MainTaskSuccessSignal = MainTaskSuccessSignal
UITaskMain.OnClickCallBack = OnClickCallBack
UITaskMain.SetAllCellDestroy = SetAllCellDestroy
UITaskMain.OnInitScroll = OnInitScroll
UITaskMain.OnDestroyScrollItem = OnDestroyScrollItem
UITaskMain.OnUpdateScroll = OnUpdateScroll
UITaskMain.ForceUpdate = ForceUpdate
UITaskMain.AddAnimatorTimer = AddAnimatorTimer
UITaskMain.DoQuestShowAnimation = DoQuestShowAnimation
UITaskMain.DeleteTimer = DeleteTimer
UITaskMain.AddTimer = AddTimer
UITaskMain.SortAnimationList = SortAnimationList
UITaskMain.IsTween = IsTween
return UITaskMain
