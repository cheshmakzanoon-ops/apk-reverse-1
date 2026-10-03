local UINoEarthOrderView = BaseClass("UINoEarthOrderView", UIBaseView)
local base = UIBaseView
local return_btn_path = "UICommonPanel"
local txt_des_path = "popupBg/DesText"
local time_des1_path = "popupBg/DesText1/DesTime1"
local time_des_path = "popupBg/DesText/DesTime"
local txt_des1_path = "popupBg/DesText1"
local txt_next_title_path = "popupBg/titleBg/NextTitle"
local close_btn_path = "popupBg/CloseBtn"
local item_name_prefix = "ItemIcon"
local item_path_prefix = "popupBg/" .. item_name_prefix
local btn_prefix = "btn"
local max_item_num = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.time_des = self:AddComponent(UIText, time_des_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.txt_des1 = self:AddComponent(UIText, txt_des1_path)
  self.time_des1 = self:AddComponent(UIText, time_des1_path)
  self.txt_next_title = self:AddComponent(UIText, txt_next_title_path)
  self.txt_next_title:SetLocalText(130346)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  for index = 1, max_item_num do
    local itemName = item_name_prefix .. index
    local itemPath = item_path_prefix .. index
    self[itemName] = self:AddComponent(UIImage, itemPath)
    local btnName = btn_prefix .. index
    self[btnName] = self:AddComponent(UIButton, itemPath)
    self[btnName]:SetOnClick(function()
      self:OnItemClick(index, self[btnName])
    end)
  end
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.txt_des = nil
  self.close_btn = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.type = self:GetUserData()
  self.endTime = 0
  self.rewardList = self.ctrl:GetPanelData()
end

local function DataDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
  self.endTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.endTime = DataCenter.EarthOrderDataManager.nextEarthOrderTime
  if self.rewardList == nil or table.count(self.rewardList) == 0 then
    self.txt_des1:SetActive(false)
    self.txt_next_title:SetActive(false)
    self.txt_des:SetActive(true)
  else
    self.txt_des:SetActive(false)
    self.txt_des1:SetActive(true)
    self.txt_next_title:SetActive(true)
  end
  self:AddTimer()
  self:RefreshTime()
  self:ShowRewards()
end

local function ShowRewards(self)
  for index = 1, max_item_num do
    local itemName = item_name_prefix .. index
    local itemPath = item_path_prefix .. index
    if self.rewardList == nil or self.rewardList[index] == nil then
      self[itemName]:SetActive(false)
    else
      self[itemName]:SetActive(true)
      self[itemName]:LoadSprite(self.rewardList[index].icon)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - now
  leftTime = math.max(0, leftTime)
  local timeText = GameDialogDefine.EARTH_ORDER_NO_ARRIVED_TIP
  if self.txt_des:GetActive() then
    self.txt_des:SetLocalText(timeText, "")
    self.time_des:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.txt_des1:SetLocalText(timeText, "")
    self.time_des1:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

local function OnItemClick(self, index, item)
  if self.rewardList == nil or self.rewardList[index] == nil then
    return
  end
  local info = self.rewardList[index]
  local desc = DataCenter.RewardManager:GetDescByType(info.rewardType, info.itemId)
  local name = DataCenter.RewardManager:GetNameByType(info.rewardType, info.itemId)
  local param = {}
  param.itemName = name
  param.itemDesc = desc
  param.alignObject = item
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UINoEarthOrderView.OnCreate = OnCreate
UINoEarthOrderView.OnDestroy = OnDestroy
UINoEarthOrderView.OnEnable = OnEnable
UINoEarthOrderView.OnDisable = OnDisable
UINoEarthOrderView.OnAddListener = OnAddListener
UINoEarthOrderView.OnRemoveListener = OnRemoveListener
UINoEarthOrderView.ComponentDefine = ComponentDefine
UINoEarthOrderView.ComponentDestroy = ComponentDestroy
UINoEarthOrderView.DataDefine = DataDefine
UINoEarthOrderView.DataDestroy = DataDestroy
UINoEarthOrderView.ReInit = ReInit
UINoEarthOrderView.DeleteTimer = DeleteTimer
UINoEarthOrderView.AddTimer = AddTimer
UINoEarthOrderView.RefreshTime = RefreshTime
UINoEarthOrderView.ShowRewards = ShowRewards
UINoEarthOrderView.OnItemClick = OnItemClick
return UINoEarthOrderView
