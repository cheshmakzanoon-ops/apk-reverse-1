local UIDispatchTaskRecordNewView = BaseClass("UIDispatchTaskRecordNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDispatchTaskRecordItemNew = require("UI.UIDispatchTask.RecordNew.Component.UIDispatchTaskRecordItemNew")

function UIDispatchTaskRecordNewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.type = DispatchTaskRecordType.Assist
  self:RefreshList(DispatchTaskRecordType.Assist)
end

function UIDispatchTaskRecordNewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRecordNewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTab = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.toggleToggle1 = self.viewSkin:AddComponent(self, UIToggle, 5)
  self.textTab1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTab12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.toggleToggle2 = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.textTab2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTab22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.toggleToggle3 = self.viewSkin:AddComponent(self, UIToggle, 11)
  self.textTab3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTab32 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textNoLogTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 15)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.toggleToggle1:SetIsOn(true)
  self.toggleToggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DispatchTaskRecordType.Assist)
    end
  end)
  self.toggleToggle2:SetIsOn(false)
  self.toggleToggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DispatchTaskRecordType.Steal)
    end
  end)
  self.toggleToggle3:SetIsOn(false)
  self.toggleToggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DispatchTaskRecordType.Stolen)
    end
  end)
end

function UIDispatchTaskRecordNewView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.btnBlack = nil
  self.btnClose = nil
  self.compTab = nil
  self.toggleToggle1 = nil
  self.textTab1 = nil
  self.textTab12 = nil
  self.toggleToggle2 = nil
  self.textTab2 = nil
  self.textTab22 = nil
  self.toggleToggle3 = nil
  self.textTab3 = nil
  self.textTab32 = nil
  self.textNoLogTxt = nil
  self.scrollView = nil
  self.content = nil
end

function UIDispatchTaskRecordNewView:DataDefine()
  self.getTwo = nil
  self.getThree = nil
end

function UIDispatchTaskRecordNewView:DataDestroy()
  self:ClearScroll()
  self.showList = nil
  self.getTwo = nil
  self.getThree = nil
  self.type = nil
end

function UIDispatchTaskRecordNewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskGetNewRecord, self.RefreshList)
end

function UIDispatchTaskRecordNewView:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskGetNewRecord, self.RefreshList)
  base.OnRemoveListener(self)
end

function UIDispatchTaskRecordNewView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UIDispatchTaskRecordNewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIDispatchTaskRecordNewView:ToggleControlBorS(type)
  self.type = type
  if type == DispatchTaskRecordType.Steal and not self.getTwo then
    SFSNetwork.SendMessage(MsgDefines.DispatchGetRecord, type)
  elseif type == DispatchTaskRecordType.Stolen and not self.getThree then
    SFSNetwork.SendMessage(MsgDefines.DispatchGetRecord, type)
  else
    self:RefreshList(type)
  end
end

function UIDispatchTaskRecordNewView:RefreshList(recordType)
  if self.type == recordType then
    self:ClearScroll()
    if recordType == DispatchTaskRecordType.Steal and not self.getTwo then
      self.getTwo = true
    elseif recordType == DispatchTaskRecordType.Stolen and not self.getThree then
      self.getThree = true
    end
    self.showList = DataCenter.ActDispatchTaskDataManager:GetTypeRecordList(recordType)
    if self.showList and #self.showList > 0 then
      self.textNoLogTxt:SetActive(false)
      self.scrollView:SetActive(true)
      self.scrollView:SetTotalCount(#self.showList)
      self.scrollView:RefillCells()
    else
      self.textNoLogTxt:SetLocalText(456221)
      self.textNoLogTxt:SetActive(true)
      self.scrollView:SetActive(false)
    end
  end
end

function UIDispatchTaskRecordNewView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIDispatchTaskRecordItemNew, itemObj)
  local logInfo = self.showList[index]
  cellItem:SetItem(logInfo)
end

function UIDispatchTaskRecordNewView:OnDeleteCell(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIDispatchTaskRecordItemNew)
end

function UIDispatchTaskRecordNewView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIDispatchTaskRecordItemNew)
end

return UIDispatchTaskRecordNewView
