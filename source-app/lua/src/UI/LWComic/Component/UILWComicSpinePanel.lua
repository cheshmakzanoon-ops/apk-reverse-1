local UILWComicSpinePanel = BaseClass("UILWComicSpinePanel", UIBaseContainer)
local base = UIBaseContainer
local UILWComicSpineDialogTextItem = require("UI.LWComic.Component.UILWComicSpineDialogTextItem")
local Localization = CS.GameEntry.Localization
local content_path = "Content"
local ENTER_ANIM = "idle"
local IDLE_ANIM = "idle2"
local SPINE_DIALOG_ROOT = "text0"
local SPINE_DIALOG_EVENT = "text"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.textLoadRequests = {}
end

local function DataDefine(self)
  self.lastSpinePath = ""
  self.spineLoadRequest = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  if self.spineLoadRequest ~= nil then
    self.spineLoadRequest:Destroy()
    self.spineLoadRequest = nil
  end
  self:SetAllCellDestroy()
  self.content = nil
  self.spine = nil
end

local function DataDestroy(self)
  self.curTemplate = nil
  self.lastSpinePath = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, curTemplate)
  self.curTemplate = curTemplate
  self:ReloadSpine(self.curTemplate.spine)
  self:SetAllCellDestroy()
end

local function ReloadSpine(self, spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if spinePath ~= self.lastSpinePath then
    if self.spine then
      self:RemoveComponent(self.spine:GetName(), UISpine)
    end
    if self.spineLoadRequest ~= nil then
      self:GameObjectDestroy(self.spineLoadRequest)
      self.spineLoadRequest = nil
    end
    local request = self:GameObjectInstantiateAsync(spinePath .. ".prefab")
    self.spineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.spineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.spine then
    self.spine:SetActive(false)
    self.spine:SetAnimation(0, ENTER_ANIM, false)
    self.spine:SetActive(true)
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    rectTransform:SetParent(self.transform)
    rectTransform:Set_localScale(1, 1, 1)
    rectTransform:Set_anchoredPosition(0, 0, 0)
    self.spine = self:AddComponent(UISpine, obj.transform:Find("New SkeletonGraphic").gameObject)
    self.spine:SetCustomEvent(BindCallback(self.OnCustomEvent, self))
    self.spine:SetCompleteEvent(BindCallback(self.OnComplete, self))
    self.spine:SetAnimation(0, ENTER_ANIM, false)
    self.spine:SetActive(true)
  end
end

local function IsComplete(self)
  local isComplete = false
  if self.spine then
    isComplete = self.spine:GetAnimationStateName() == IDLE_ANIM or self.spine:IsComplete()
  end
  return isComplete
end

local function Complete(self)
  if self.spine then
    self.spine:JumpToEnd()
  end
  local cells = self.content:GetComponents(UILWComicSpineDialogTextItem)
  for key, value in pairs(cells) do
    if value then
      value:CompleteDoText()
    end
  end
end

local function OnComplete(self)
  if self.spine then
    self.spine:SetAnimation(0, IDLE_ANIM, true)
  end
  self.view:ShowNextNarration()
end

local function SetAllCellDestroy(self)
  if self.content then
    self.content:RemoveComponents(UILWComicSpineDialogTextItem)
    if self.textLoadRequests ~= nil then
      for k, v in pairs(self.textLoadRequests) do
        if v ~= nil then
          self:GameObjectDestroy(v)
        end
      end
    end
  end
end

local function AddDialog(self, parent, index)
  if index <= #self.curTemplate.dialogList then
    local dialogList = self.curTemplate.dialogList
    local sizeList = self.curTemplate.dialogSizeList
    local timeList = self.curTemplate.dialogInTimeList
    local textLoadRequest = self:GameObjectInstantiateAsync(UIAssets.UIComicsSpineTextItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(parent)
      go.gameObject:SetActive(true)
      go.transform:Set_anchorMin(0.5, 0.5)
      go.transform:Set_anchorMax(0.5, 0.5)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "SpineText_" .. tostring(index)
      local cell = self.content:AddComponent(UILWComicSpineDialogTextItem, go)
      cell:SetSizeDelta(sizeList[index] or Vector2.New(200, 100))
      if self:IsComplete() then
        cell:SetData(dialogList[index])
      else
        cell:DoText(dialogList[index], timeList[index] or 2000)
      end
    end)
    table.insert(self.textLoadRequests, textLoadRequest)
  else
    Logger.LogInfo(string.format("%s\231\154\132text\228\186\139\228\187\182\230\149\176\233\135\143\229\146\140\233\133\141\231\189\174\229\175\185\228\184\141\228\184\138,commicId:%s,index:", self.curTemplate.spine, self.curTemplate.id, index))
  end
end

local function OnCustomEvent(self, trackEntry, spineEvent)
  if spineEvent and spineEvent.Data and spineEvent.Data.Name then
    local strs = string.split(spineEvent.Data.Name, "_")
    if strs[1] == SPINE_DIALOG_EVENT and self.spine then
      local index = tonumber(strs[2])
      local rootTrans = self.spine:GetBoneTransByName(SPINE_DIALOG_ROOT .. index)
      if rootTrans then
        self:AddDialog(rootTrans, index)
      end
    end
  end
end

UILWComicSpinePanel.OnCreate = OnCreate
UILWComicSpinePanel.OnEnable = OnEnable
UILWComicSpinePanel.OnAddListener = OnAddListener
UILWComicSpinePanel.OnRemoveListener = OnRemoveListener
UILWComicSpinePanel.OnDisable = OnDisable
UILWComicSpinePanel.ComponentDefine = ComponentDefine
UILWComicSpinePanel.ComponentDestroy = ComponentDestroy
UILWComicSpinePanel.ComponentDestroy = ComponentDestroy
UILWComicSpinePanel.DataDefine = DataDefine
UILWComicSpinePanel.DataDestroy = DataDestroy
UILWComicSpinePanel.OnDestroy = OnDestroy
UILWComicSpinePanel.SetData = SetData
UILWComicSpinePanel.ReloadSpine = ReloadSpine
UILWComicSpinePanel.ResetSpineTransform = ResetSpineTransform
UILWComicSpinePanel.IsComplete = IsComplete
UILWComicSpinePanel.Complete = Complete
UILWComicSpinePanel.OnComplete = OnComplete
UILWComicSpinePanel.SetAllCellDestroy = SetAllCellDestroy
UILWComicSpinePanel.AddDialog = AddDialog
UILWComicSpinePanel.OnCustomEvent = OnCustomEvent
return UILWComicSpinePanel
