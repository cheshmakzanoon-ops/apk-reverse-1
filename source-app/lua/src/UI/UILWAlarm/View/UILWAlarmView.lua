local UILWAlarmView = BaseClass("UILWAlarmView", UIBaseView)
local AlarmInfoCell = require("UI.UILWAlarm.Component.AlarmInfoCell")
local SettingBtnCell = require("UI.UILWAlarm.Component.SettingBtnCell")
local btnPath = "Assets/Main/Prefabs/UI/LWMainUI/Alarm/SelectBtn.prefab"
local base = UIBaseView

function UILWAlarmView:OnCreate()
  base.OnCreate(self)
  self.openType = self:GetUserData()
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWAlarmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlarmView:DataDestroy()
  self.settingBtnCells = nil
end

function UILWAlarmView:ComponentDestroy()
end

function UILWAlarmView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.RefreshMarchItemTargetMe)
  self:AddUIListener(EventId.Alarm_Investigation_UpdateSetting, self.ShowScroll)
end

function UILWAlarmView:OnRemoveListener()
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.RefreshMarchItemTargetMe)
  self:RemoveUIListener(EventId.Alarm_Investigation_UpdateSetting, self.ShowScroll)
  base.OnRemoveListener(self)
end

function UILWAlarmView:RefreshMarchItemTargetMe()
  self:ShowScroll()
end

function UILWAlarmView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.alarmList:AddComponent(AlarmInfoCell, itemObj)
  item:ReInit(self.alarmDataList[index], self.openType)
end

function UILWAlarmView:OnDeleteCell(itemObj, index)
  self.alarmList:RemoveComponent(itemObj.name, AlarmInfoCell)
end

function UILWAlarmView:ShowScroll()
  self:ClearScroll()
  if self.activeTab == 1 then
    self.alarmDataList = self.ctrl:GetMarchDataList(self.openType)
    if self.alarmDataList == nil or #self.alarmDataList == 0 then
      self.viewRoot:SetActive(true)
      self.alarmRoot:SetActive(false)
      return
    end
    local count = #self.alarmDataList
    self.alarmList:SetTotalCount(count)
    if 0 < count then
      self.viewRoot:SetActive(false)
      self.alarmRoot:SetActive(true)
      self.alarmList:RefillCells()
    else
      self.viewRoot:SetActive(true)
      self.alarmRoot:SetActive(false)
    end
  elseif self.activeTab == 2 then
    local theDataList = {}
    local allEffectAlert = DataCenter.AllianceSkillManager:GetEffectAlert()
    if allEffectAlert then
      local now = UITimeManager:GetInstance():GetServerTime()
      for uuid, effect in pairs(allEffectAlert) do
        if effect and effect.mask_finish ~= true and effect.overTime ~= nil and now < effect.overTime and effect.skill_flag == AlOfficialSkillType.GuardianTower then
          table.insert(theDataList, {
            data = effect,
            type = "OfficialSkill"
          })
        end
      end
    end
    local count = #theDataList
    self.alarmDataList = theDataList
    self.alarmList:SetTotalCount(count)
    if 0 < count then
      self.viewRoot:SetActive(false)
      self.alarmRoot:SetActive(true)
      self.alarmList:RefillCells()
    else
      self.viewRoot:SetActive(true)
      self.alarmRoot:SetActive(false)
    end
  else
    self.viewRoot:SetActive(true)
    self.alarmRoot:SetActive(false)
  end
end

function UILWAlarmView:ClearScroll()
  if not self.alarmList then
    return
  end
  self.alarmList:ClearCells()
  self.alarmList:RemoveComponents(AlarmInfoCell)
end

function UILWAlarmView:DataDefine()
end

function UILWAlarmView:ComponentDefine()
  self.alarmList = self:AddComponent(UIScrollView, "Root/alarm/AlarmList")
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.selectBtnRoot = self:AddComponent(UIBaseContainer, "Root/selectBtnRoot")
  self.maskInfoBtn = self:AddComponent(UIButton, "Root/alarm/GoBtn")
  self.toggle1 = self:AddComponent(UIButton, "Root/tabButtonRoot/toggle1")
  self.toggle1SelectIcon = self:AddComponent(UIImage, "Root/tabButtonRoot/toggle1/selectIcon")
  self.toggle2 = self:AddComponent(UIButton, "Root/tabButtonRoot/toggle2")
  self.toggle2SelectIcon = self:AddComponent(UIImage, "Root/tabButtonRoot/toggle2/selectIcon2")
  self.viewRoot = self:AddComponent(UIButton, "Root/viewRoot")
  self.alarmRoot = self:AddComponent(UIBaseContainer, "Root/alarm")
  self.setBtn = self:AddComponent(UIButton, "Root/SetBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggle1:SetOnClick(function()
    self:ChangeIndex(1)
  end)
  self.toggle2:SetOnClick(function()
    self:ChangeIndex(2)
  end)
  self.maskInfoBtn:SetOnClick(function()
    self:OnMaskInfoBtnClick()
  end)
  self.alarmList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.alarmList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.setBtn:SetOnClick(function()
    self:ClickSetBtn()
  end)
  self.maskInfoBtn:SetActive(false)
end

function UILWAlarmView:ClickSetBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
end

function UILWAlarmView:OnMaskInfoBtnClick()
  self.ctrl:SetMaskUid(self.openType)
end

function UILWAlarmView:ChangeIndex(index)
  if index == 1 then
    self.toggle1SelectIcon:SetActive(true)
    self.toggle2SelectIcon:SetActive(false)
    if self.alarmDataList == nil or #self.alarmDataList == 0 then
      self.viewRoot:SetActive(true)
      self.alarmRoot:SetActive(false)
    else
      self.viewRoot:SetActive(false)
      self.alarmRoot:SetActive(true)
    end
  else
    self.toggle1SelectIcon:SetActive(false)
    self.toggle2SelectIcon:SetActive(true)
    self.viewRoot:SetActive(true)
    self.alarmRoot:SetActive(false)
  end
  self.activeTab = index
  self:ShowScroll()
end

function UILWAlarmView:ReInit()
  self:RefreshSettingBtns()
  self:OnMaskInfoBtnClick()
  local theDataList = self.ctrl:GetMarchDataList(self.openType)
  if theDataList == nil or #theDataList == 0 then
    self:ChangeIndex(2)
  else
    self:ChangeIndex(1)
  end
end

function UILWAlarmView:RefreshSettingBtns()
  self.settingBtnCells = {}
  local btns = self.ctrl:GetSettingBtn()
  self.btnList = {}
  for i = 1, #btns do
    self.settingBtnCells[i] = {}
    self.settingBtnCells[i].inst = self:GameObjectInstantiateAsync(btnPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.selectBtnRoot.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local model = self.selectBtnRoot:AddComponent(SettingBtnCell, nameStr)
      model:ReInit(btns[i])
      self.settingBtnCells[i].model = model
    end)
  end
end

return UILWAlarmView
