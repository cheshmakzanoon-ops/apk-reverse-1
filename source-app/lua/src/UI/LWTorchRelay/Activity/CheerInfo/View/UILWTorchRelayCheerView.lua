local UILWTorchRelayCheerView = BaseClass("UILWTorchRelayCheerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWTorchRelayCheerItemComponent = require("UI/LWTorchRelay/Activity/CheerInfo/Component/UILWTorchRelayCheerItemComponent")

function UILWTorchRelayCheerView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWTorchRelayCheerView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayCheerView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UIWidget/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UIWidget/TitleText")
  self.textTitle:SetText(Localization:GetString("activity_torch_relay_title_2"))
  self.btnClose = self:AddComponent(UIButton, "UIWidget/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDes = self:AddComponent(UIText, "Content/DesText")
  self.textDes:SetText(Localization:GetString("activity_torch_relay_desc_8"))
  self.textContentTitle = self:AddComponent(UIText, "Content/ContentTitleText")
  self.textContentTitle:SetText(Localization:GetString("activity_torch_relay_desc_9"))
  self.compCheerItemTemplate = self:AddComponent(UILWTorchRelayCheerItemComponent, "Content/ScrollView/CheerItemTemplate")
  self.compCheerItemTemplate:SetActive(false)
  self.compCheerItemTemplate.gameObject:GameObjectCreatePool()
  self.compContent = self:AddComponent(UIBaseContainer, "Content/ScrollView/Viewport/Content")
  self.btnShare = self:AddComponent(UIButton, "Content/ShareBtn")
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textBtn = self:AddComponent(UIText, "Content/ShareBtn/Btn/BtnText")
  self.textBtn:SetText(Localization:GetString("activity_torch_relay_button_8"))
end

function UILWTorchRelayCheerView:ComponentDestroy()
  self:ClearItems()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textDes = nil
  self.textContentTitle = nil
  self.compCheerItemTemplate = nil
  self.compContent = nil
  self.btnShare = nil
  self.textBtn = nil
end

function UILWTorchRelayCheerView:DataDefine()
end

function UILWTorchRelayCheerView:DataDestroy()
end

function UILWTorchRelayCheerView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.UpdateContent)
end

function UILWTorchRelayCheerView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.UpdateContent)
  base.OnRemoveListener(self)
end

function UILWTorchRelayCheerView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  self.activityId = self.param.activityId
  if self.activityId == nil then
    return
  end
  self:UpdateContent()
end

function UILWTorchRelayCheerView:UpdateContent()
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil then
    return
  end
  local cheerData = data:GetAllCheerPlayersData()
  local cheerCount = 0
  if not table.IsNullOrEmpty(cheerData) then
    cheerCount = #cheerData
  end
  self.textContentTitle:SetLocalText("activity_torch_relay_desc_9", tostring(cheerCount), tostring(data.config.cheer_num_max))
  if self.compsItems then
    for i = 1, data.config.cheer_num_max do
      if self.compsItems[i] and cheerData then
        self.compsItems[i]:ReInit(self.activityId, cheerData[i])
      end
    end
  else
    self.compsItems = {}
    for i = 1, data.config.cheer_num_max do
      local itemData
      local hasData = not table.IsNullOrEmpty(cheerData) and cheerData[i] ~= nil
      if hasData then
        itemData = cheerData[i]
      end
      local item = self.compCheerItemTemplate.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = "item_" .. tostring(i)
      local obj = self.compContent:AddComponent(UILWTorchRelayCheerItemComponent, item.name)
      obj:SetActive(true)
      self.compsItems[i] = obj
      obj:ReInit(self.activityId, itemData)
    end
  end
  self.isFull = cheerCount == data.config.cheer_num_max
end

function UILWTorchRelayCheerView:ClearItems()
  self.compContent:RemoveComponents(UILWTorchRelayCheerItemComponent)
  self.compCheerItemTemplate.gameObject:GameObjectRecycleAll()
  self.compsItems = nil
end

function UILWTorchRelayCheerView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWTorchRelayCheerView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWTorchRelayCheerView:OnBtnShareClick()
  if self.activityId then
    if self.isFull then
      UIUtil.ShowTipsId("ghostrecon_069")
      return
    end
    DataCenter.ActivityTorchRelayManager:ShareCheerToChat(self.activityId)
  end
end

return UILWTorchRelayCheerView
