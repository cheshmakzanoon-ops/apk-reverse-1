local UIActSlotMachineRecordDayItem = BaseClass("UIActSlotMachineRecordDayItem", UIBaseContainer)
local base = UIBaseContainer
local arrow_img_path = "arrowImg"
local time_txt_path = "timeTxt"
local bg_path = "bg"
local arrow_open_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
local arrow_close_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"

function UIActSlotMachineRecordDayItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineRecordDayItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineRecordDayItem:ComponentDefine()
  self.arrow_img = self:AddComponent(UIImage, arrow_img_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:OnBgClick()
  end)
end

function UIActSlotMachineRecordDayItem:ComponentDestroy()
  self.arrow_img = nil
  self.time_txt = nil
  self.bg = nil
end

function UIActSlotMachineRecordDayItem:DataDefine()
  self.param = nil
  self.isOpen = nil
  self.activityInfo = nil
  self.index = nil
  self.selectFunc = nil
end

function UIActSlotMachineRecordDayItem:DataDestroy()
  self.param = nil
  self.isOpen = nil
  self.activityInfo = nil
  self.index = nil
  self.selectFunc = nil
end

function UIActSlotMachineRecordDayItem:SetData(activityInfo, param, index, isOpen)
  self.activityInfo = activityInfo
  self.param = param
  self.index = index
  self.isOpen = isOpen
  local actStartTime = self.activityInfo.startTime
  local dayNum = self.param.dayNum
  local dayNumTime = actStartTime + (dayNum - 1) * 24 * 3600 * 1000
  local timeStr = DataCenter.ActSlotMachineDataManager:GetServerTimeStr(dayNumTime)
  self.time_txt:SetText(timeStr)
  self:RefreshSelectContent()
end

function UIActSlotMachineRecordDayItem:SetSelectFunc(func)
  self.selectFunc = func
end

function UIActSlotMachineRecordDayItem:SetSelectContent(isOpen)
  self.isOpen = isOpen
  self:RefreshSelectContent()
end

function UIActSlotMachineRecordDayItem:RefreshSelectContent()
  local arrowImgPath = arrow_open_img_path
  if not self.isOpen then
    arrowImgPath = arrow_close_img_path
  end
  self.arrow_img:LoadSprite(arrowImgPath)
end

function UIActSlotMachineRecordDayItem:OnBgClick()
  if self.selectFunc then
    self.selectFunc(self.index, not self.isOpen)
  end
end

return UIActSlotMachineRecordDayItem
