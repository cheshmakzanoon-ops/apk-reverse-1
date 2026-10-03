local base = UIAsyncContainer
local UIWS_A_Line = BaseClass("UIWS_A_Line", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local UIWS_H_ACell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_H_ACell")

function UIWS_A_Line:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_A_Line:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_A_Line:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCell1 = self.viewSkin:AddComponent(self, UIWS_H_ACell, 1)
  self.compCell2 = self.viewSkin:AddComponent(self, UIWS_H_ACell, 2)
  self.compCell3 = self.viewSkin:AddComponent(self, UIWS_H_ACell, 3)
end

function UIWS_A_Line:ComponentDestroy()
  self.viewSkin = nil
  self.compCell1 = nil
  self.compCell2 = nil
  self.compCell3 = nil
end

function UIWS_A_Line:DataDefine()
end

function UIWS_A_Line:DataDestroy()
  self.data1 = nil
  self.data2 = nil
  self.data3 = nil
end

function UIWS_A_Line:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_A_Line:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_A_Line:SetDatas(data1, data2, data3)
  self.data1 = data1
  self.data2 = data2
  self.data3 = data3
  self:RefreshView()
end

function UIWS_A_Line:UpdateData()
  if self.data1 == nil and self.data2 == nil and self.data3 == nil then
    return
  end
  self.compCell1:SetActive(self.data1 ~= nil)
  self.compCell1:SetData(self.data1, true)
  self.compCell2:SetActive(self.data2 ~= nil)
  self.compCell2:SetData(self.data2, true)
  self.compCell3:SetActive(self.data3 ~= nil)
  self.compCell3:SetData(self.data3, true)
end

return UIWS_A_Line
