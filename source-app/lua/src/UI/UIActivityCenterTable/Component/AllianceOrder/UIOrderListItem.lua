local base = UIBaseContainer
local UIOrderListItem = BaseClass("UIOrderListItem", base)
local this_path = ""
local root_path = "Root"
local btn_path = "Root/Btn"
local select_path = "Root/Select"
local tip_path = "Root/Tip"
local slider_path = "Root/Slider"
local count_path = "Root/Count"
local myOrder_path = "Root/MyOrder"
local itemImage_path = "Root/ItemImage"
local itemCount_path = "Root/ItemCountBg"
local itemCountText_path = "Root/ItemCountBg/ItemCount"
local taken_path = "Root/Taken"
local takenInfo_path = "Root/Taken/TakenInfo"
local takenOwner_path = "Root/Taken/TakenOwner"
local complete_path = "Root/Complete"
local completeInfo_path = "Root/Complete/CompleteInfo"
local completeOwner_path = "Root/Complete/CompleteOwner"
local completeBlack_path = "Root/Complete/CompleteBlack"
local completeTime_path = "Root/Complete/CompleteBlack/CompleteTime"
local completeIcon_path = "Root/Complete/CompleteBlack/CompleteIcon"
local completeDesc_path = "Root/Complete/CompleteBlack/CompleteDesc"

function UIOrderListItem:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.select_go = self:AddComponent(UIBaseContainer, select_path)
  self.tip_go = self:AddComponent(UIBaseContainer, tip_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.count_text = self:AddComponent(UIText, count_path)
  self.myOrder_text = self:AddComponent(UIText, myOrder_path)
  self.myOrder_text:SetLocalText(371056)
  self.itemImage_img = self:AddComponent(UIImage, itemImage_path)
  self.itemCount_go = self:AddComponent(UIBaseContainer, itemCount_path)
  self.itemCount_text = self:AddComponent(UIText, itemCountText_path)
  self.taken_go = self:AddComponent(UIBaseContainer, taken_path)
  self.takenInfo_text = self:AddComponent(UIText, takenInfo_path)
  self.takenInfo_text:SetLocalText(371068)
  self.takenOwner_text = self:AddComponent(UIText, takenOwner_path)
  self.complete_go = self:AddComponent(UIBaseContainer, complete_path)
  self.completeInfo_text = self:AddComponent(UIText, completeInfo_path)
  self.completeInfo_text:SetLocalText(371067)
  self.completeOwner_text = self:AddComponent(UIText, completeOwner_path)
  self.completeBlack_go = self:AddComponent(UIBaseContainer, completeBlack_path)
  self.completeTime_text = self:AddComponent(UIText, completeTime_path)
  self.completeIcon_text = self:AddComponent(UIImage, completeIcon_path)
  self.completeDesc_text = self:AddComponent(UIText, completeDesc_path)
  self.completeDesc_text:SetLocalText(371069)
  self.data = nil
  self.OnClickFunc = nil
  self.completeTimer = nil
  self.appearTimer = nil
  self.view = nil
  self.index = nil
  self.type = nil
end

function UIOrderListItem:OnDestroy()
  if self.completeTimer then
    self.completeTimer:Stop()
  end
  if self.appearTimer then
    self.appearTimer:Stop()
  end
  self.anim = nil
  self.root_go = nil
  self.btn = nil
  self.select_go = nil
  self.tip_go = nil
  self.slider = nil
  self.count_text = nil
  self.myOrder_text = nil
  self.itemImage_img = nil
  self.itemCount_go = nil
  self.itemCount_text = nil
  self.taken_go = nil
  self.takenInfo_text = nil
  self.takenOwner_text = nil
  self.complete_go = nil
  self.completeInfo_text = nil
  self.completeOwner_text = nil
  self.completeBlack_go = nil
  self.completeTime_text = nil
  self.completeIcon_text = nil
  self.completeDesc_text = nil
  self.data = nil
  self.OnClickFunc = nil
  self.completeTimer = nil
  self.appearTimer = nil
  self.view = nil
  self.index = nil
  self.type = nil
  base.OnDestroy(self)
end

function UIOrderListItem:SetType(type)
  self.type = type
  if self.type == EnumActivity.AllianceOrder.Type then
    self.completeInfo_text:SetLocalText(371067)
  elseif self.type == EnumActivity.IndividualOrder.Type then
    self.completeInfo_text:SetLocalText(170008)
  end
end

function UIOrderListItem:SetData(data)
  self.data = data
  local orderTemplate
  if self.type == EnumActivity.AllianceOrder.Type then
    orderTemplate = DataCenter.ActAllianceOrderManager:GetOrderTemplate(data.orderId)
    self.completeBlack_go:SetActive(true)
  elseif self.type == EnumActivity.IndividualOrder.Type then
    orderTemplate = DataCenter.ActIndividualOrderManager:GetOrderTemplate(data.orderId)
    self.completeBlack_go:SetActive(false)
  else
    return
  end
  local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(orderTemplate.product_id)
  self.select_go:SetActive(data.selected)
  self.itemImage_img:LoadSprite(string.format(LoadPath.ItemPath, resTemplate.pic))
  local isMine = self:IsMine()
  local isReceivable = self:IsReceivable()
  local isTaken = self:IsTaken()
  local isCompleted = self:IsCompleted()
  self.itemCount_go:SetActive(isReceivable)
  self.taken_go:SetActive(isTaken and not isMine)
  self.complete_go:SetActive(isCompleted)
  self.slider:SetActive(isTaken and isMine)
  self.count_text:SetActive(isTaken and isMine)
  self.myOrder_text:SetActive(isTaken and isMine)
  if self.completeTimer then
    self.completeTimer:Stop()
    self.completeTimer = nil
  end
  if isReceivable then
    local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
    local haveCount = resData and resData.number or 0
    local canFinish = haveCount >= orderTemplate.product_num
    self.btn:SetInteractable(true)
    self.tip_go:SetActive(canFinish)
    self.itemCount_text:SetText("x" .. orderTemplate.product_num)
    self.itemCount_text:SetColor(canFinish and WorldGreenColor or WhiteColor)
  elseif isTaken then
    self.btn:SetInteractable(isMine)
    self.tip_go:SetActive(false)
    self.takenOwner_text:SetText(data.ownerName)
    self.slider:SetValue(data.fill / orderTemplate.product_num)
    self.count_text:SetText(data.fill .. "/" .. orderTemplate.product_num)
  elseif isCompleted then
    self.btn:SetInteractable(false)
    self.tip_go:SetActive(false)
    self.completeOwner_text:SetText(data.ownerName)
    if data.cdTime and 0 < data.cdTime then
      self.completeTime_text:SetActive(true)
      self.completeIcon_text:SetActive(true)
      self.completeDesc_text:SetActive(false)
      self.completeTime_text:SetText(CS.GameEntry.Timer:MilliSecondToFmtString(self:GetRestTime()))
      self.completeTimer = TimerManager:GetInstance():GetTimer(0.5, function()
        self:CompleteTimerAction()
      end, self, false, false, false)
      self.completeTimer:Start()
    else
      self.completeTime_text:SetActive(false)
      self.completeIcon_text:SetActive(false)
      self.completeDesc_text:SetActive(true)
    end
  end
end

function UIOrderListItem:SetOnClick(func)
  self.OnClickFunc = func
end

function UIOrderListItem:OnClick()
  if self.OnClickFunc then
    self.OnClickFunc(self.view, self)
  end
  self.anim:Play("V_shangcheng_paizi_daiji", 0, 0)
end

function UIOrderListItem:SetSelection(selected)
  self.select_go:SetActive(selected)
  if not selected then
    self.anim:Play("V_shangcheng_paizi_idle", 0, 0)
  end
end

function UIOrderListItem:CompleteTimerAction()
  if self.data == nil then
    return
  end
  local restTime = self:GetRestTime()
  if 0 <= restTime then
    self.completeTime_text:SetText(CS.GameEntry.Timer:MilliSecondToFmtString(restTime))
  else
    self:SetData(self.data)
  end
end

function UIOrderListItem:GetRestTime()
  return math.floor((self.data.cdTime or 0) - UITimeManager:GetInstance():GetServerTime())
end

function UIOrderListItem:IsMine()
  if self.type == EnumActivity.AllianceOrder.Type then
    return self.data.ownerUid == LuaEntry.Player.uid
  elseif self.type == EnumActivity.IndividualOrder.Type then
    return self.data.state == 0 and 0 < self.data.fill
  else
    return false
  end
end

function UIOrderListItem:IsReceivable()
  if self.type == EnumActivity.AllianceOrder.Type then
    return self.data.state == 0 or 0 > self:GetRestTime() and 0 < self.data.cdTime
  elseif self.type == EnumActivity.IndividualOrder.Type then
    return self.data.state == 0 and self.data.fill == 0
  else
    return false
  end
end

function UIOrderListItem:IsTaken()
  if self.type == EnumActivity.AllianceOrder.Type then
    return self.data.state == 1
  elseif self.type == EnumActivity.IndividualOrder.Type then
    return self.data.state == 0 and 0 < self.data.fill
  else
    return false
  end
end

function UIOrderListItem:IsCompleted()
  if self.type == EnumActivity.AllianceOrder.Type then
    return self.data.state == 2 and (self:GetRestTime() >= 0 or self.data.cdTime == 0)
  elseif self.type == EnumActivity.IndividualOrder.Type then
    return self.data.state == 1
  else
    return false
  end
end

function UIOrderListItem:Appear(startRow)
  local index
  if self.type == EnumActivity.AllianceOrder.Type then
    index = DataCenter.ActAllianceOrderManager:GetOrderIndex(self.data.uuid)
  elseif self.type == EnumActivity.IndividualOrder.Type then
    index = DataCenter.ActIndividualOrderManager:GetOrderIndex(self.data.uuid)
  else
    return
  end
  local row = index // 4 - startRow
  local col = index % 4
  local delay = math.max((row + col) * 0.04, 0)
  self.anim:Play("V_shangcheng_paizi_idle", 0, 0)
  self.root_go:SetActive(false)
  self.appearTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.anim:GetActiveInHierarchy() then
      self.root_go:SetActive(true)
      self.anim:Play("V_shangcheng_paizi_chuxian", 0, 0)
      self.appearTimer = nil
    end
  end, delay)
end

function UIOrderListItem:Flip()
  self.anim:Play("V_shangcheng_paizi_zhuan", 0, 0)
end

return UIOrderListItem
