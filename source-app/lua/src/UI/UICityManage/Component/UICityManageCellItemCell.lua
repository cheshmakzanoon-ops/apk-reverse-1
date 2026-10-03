local UICityManageCellItemCell = BaseClass("UICityManageCellItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Cell = "Common_btn_close"
local listClose_btn_path = "ListcloseBtn"
local arrowIcon_path = "ListcloseBtn/Common_btn_listclose"
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local title_txt_path = "Text_title"
local des_txt_Path = "Text_des"
local slider_txt_Path = "Progress/Text_lv"
local slider_Path = "Progress/TimeSlider_up"
local sliderParent_Path = "Progress"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.cell_btn = self:AddComponent(UIButton, Cell)
  self.listClose_btn = self:AddComponent(UIButton, listClose_btn_path)
  self.arrowIcon = self:AddComponent(UIBaseContainer, arrowIcon_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_Path)
  self.cell_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnItemClick()
  end)
  self.listClose_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnItemClick()
  end)
  self.sliderParent = self:AddComponent(UIBaseContainer, sliderParent_Path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_Path)
  self.slider = self:AddComponent(UISlider, slider_Path)
  self.showTimer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function ComponentDestroy(self)
  self.cell_btn = nil
  self.item_icon = nil
  self.title_txt = nil
  self.des_txt = nil
  self.slider_txt = nil
  self.slider = nil
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.timer_action = nil
  self:DeleteTimer()
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  if self.param ~= nil then
    self.title_txt:SetLocalText(self.param.name)
    self.des_txt:SetLocalText(self.param.des)
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon))
    self.sliderParent.gameObject:SetActive(false)
    if self.param.endTime ~= nil and self.param.totalTime ~= nil then
      self:AddTimer()
      self:RefreshTime()
      self.sliderParent.gameObject:SetActive(true)
    end
  end
  if self.param.id == CityManageBuffType.GolloesFever or self.param.id == CityManageBuffType.GolloesGuard then
    self.arrowIcon:SetActive(false)
  else
    self.arrowIcon:SetActive(true)
  end
end

local function OnItemClick(self)
  if self.param.id == CityManageBuffType.GolloesGuard or self.param.id == CityManageBuffType.GolloesFever then
    return
  end
  self.view:SwitchContent(self.param)
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.param.endTime ~= nil then
    local leftTime = self.param.endTime - now
    if self.param.lastTime ~= leftTime and self.slider_txt ~= nil then
      self.param.lastTime = leftTime
      if leftTime <= 0 then
        self.slider_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
        self.slider:SetValue(1)
        LuaEntry.Effect:RemoveStatus(self.param.intKey)
        self.sliderParent.gameObject:SetActive(false)
      else
        self.slider_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        local percent = 1 - leftTime / math.max(1, self.param.totalTime)
        self.slider:SetValue(percent)
      end
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UICityManageCellItemCell.OnCreate = OnCreate
UICityManageCellItemCell.OnDestroy = OnDestroy
UICityManageCellItemCell.OnEnable = OnEnable
UICityManageCellItemCell.OnDisable = OnDisable
UICityManageCellItemCell.ComponentDefine = ComponentDefine
UICityManageCellItemCell.ComponentDestroy = ComponentDestroy
UICityManageCellItemCell.DataDefine = DataDefine
UICityManageCellItemCell.DataDestroy = DataDestroy
UICityManageCellItemCell.OnAddListener = OnAddListener
UICityManageCellItemCell.OnRemoveListener = OnRemoveListener
UICityManageCellItemCell.ReInit = ReInit
UICityManageCellItemCell.OnItemClick = OnItemClick
UICityManageCellItemCell.RefreshTime = RefreshTime
UICityManageCellItemCell.AddTimer = AddTimer
UICityManageCellItemCell.DeleteTimer = DeleteTimer
return UICityManageCellItemCell
