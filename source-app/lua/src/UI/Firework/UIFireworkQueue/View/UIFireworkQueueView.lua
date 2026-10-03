local base = UIBaseView
local UIFireworkQueueView = BaseClass("UIFireworkQueueView", base)
local UIFireworkQueueItem = require("UI.Firework.UIFireworkQueue.Component.UIFireworkQueueItem")
local titleText_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local closePanel_path = "UICommonPopUpTitle/panel"
local desc_path = "Desc"
local scroll_path = "Scroll View"
local content_path = "Scroll View/Viewport/Content"
local toggle_path = "DefaultToggle/toggle"
local confirmBtn_path = "Btn_Confirm"
local cancelBtn_path = "Btn_Cancel"
local toggleTips_path = "DefaultToggle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.confirmBtn = self:AddComponent(UIButton, confirmBtn_path)
  self.cancelBtn = self:AddComponent(UIButton, cancelBtn_path)
  self.toggleTips = self:AddComponent(UIText, toggleTips_path)
  self.titleText:SetLocalText("firework_interface_1001")
  self.toggleTips:SetLocalText("firework_interface_1008")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn:SetOnClick(function()
    local defaultFireworkId = DataCenter.LWFireworkManager:GetDefaultFireworkItemId()
    if not string.IsNullOrEmpty(defaultFireworkId) then
      local itemData = DataCenter.ItemData:GetItemById(defaultFireworkId)
      DataCenter.LWFireworkManager:SendUseFireworkMessage(self.data.uid, itemData)
    end
    self.ctrl:CloseSelf()
  end)
  self.cancelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggle:SetOnValueChanged(function(tf)
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkQueue, not tf)
  end)
end

local function ComponentDestroy(self)
  self:ClearItems()
  self.titleText = nil
  self.closeBtn = nil
  self.closePanel = nil
  self.desc = nil
  self.scroll = nil
  self.content = nil
  self.toggle = nil
  self.confirmBtn = nil
  self.cancelBtn = nil
  self.toggleTips = nil
end

function UIFireworkQueueView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FireworkDataCsUpdate, self.OnRefreshPlayerData)
end

function UIFireworkQueueView:OnRemoveListener()
  self:RemoveUIListener(EventId.FireworkDataCsUpdate, self.OnRefreshPlayerData)
  base.OnRemoveListener(self)
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.itemIndex = nil
end

function UIFireworkQueueView:ReInit()
  self.data = self:GetUserData()
  self:OnRefreshPlayerData()
end

function UIFireworkQueueView:OnRefreshPlayerData()
  self.fireworkQueue = DataCenter.LWFireworkManager:GetFireworkQueueByUid(self.data.uid)
  self:RefreshCountDown()
  self:RefreshList()
end

function UIFireworkQueueView:ClearItems()
  self.content:RemoveComponents(UIFireworkQueueItem)
  if self.itemReqList then
    for k, v in pairs(self.itemReqList) do
      self:GameObjectDestroy(v)
    end
  end
  self.items = {}
  self.itemReqList = {}
end

function UIFireworkQueueView:RefreshList()
  self:ClearItems()
  if self.fireworkQueue then
    local totalSize = self.fireworkQueue:GetSize()
    self.lastSize = totalSize
    local fireworkQueueList = self.fireworkQueue:ToArray()
    for i = 1, totalSize do
      local idx = i
      local data = fireworkQueueList[idx]
      self.itemReqList[idx] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkQueueItem.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. idx
        self.items[idx] = self.content:AddComponent(UIFireworkQueueItem, go.name)
        self.items[idx]:SetData(data)
      end)
    end
  end
end

function UIFireworkQueueView:Update1000MS()
  self:RefreshCountDown()
  if not self.fireworkQueue then
    return
  end
  local totalSize = self.fireworkQueue:GetSize()
  for i = 1, #self.items do
    self.items[i]:UpdateRemainTimeTxt()
  end
  if totalSize ~= self.lastSize then
    self:RefreshList()
  end
end

function UIFireworkQueueView:RefreshCountDown()
  self.desc:SetLocalText("firework_interface_1002", UITimeManager:GetInstance():MilliSecondToFmtString(DataCenter.LWFireworkManager:GetFireworkQueueRemainTimeByUid(self.data.uid)))
end

UIFireworkQueueView.OnCreate = OnCreate
UIFireworkQueueView.OnDestroy = OnDestroy
UIFireworkQueueView.OnEnable = OnEnable
UIFireworkQueueView.OnDisable = OnDisable
UIFireworkQueueView.ComponentDefine = ComponentDefine
UIFireworkQueueView.ComponentDestroy = ComponentDestroy
UIFireworkQueueView.DataDefine = DataDefine
UIFireworkQueueView.DataDestroy = DataDestroy
return UIFireworkQueueView
