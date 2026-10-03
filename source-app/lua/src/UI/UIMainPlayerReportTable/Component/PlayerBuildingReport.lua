local PlayerBuildingReport = BaseClass("PlayerBuildingReport", UIBaseContainer)
local base = UIBaseContainer
local PlayerBuildingReportCell = require("UI.UIMainPlayerReportTable.Component.PlayerBuildingReportCell")
local Localization = CS.GameEntry.Localization
local name_path = "Obj/Text"
local num_path = "Obj/Text1"
local maintenance_path = "Obj/Text2"
local efficiency_path = "Obj/Text3"
local damage_path = "Obj/Text4"
local repair_path = "Obj/Text5"
local toogle1_path = "checkObj/item1"
local toogle2_path = "checkObj/item2"
local toogle3_path = "checkObj/item3"
local scroll_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.num = self:AddComponent(UIText, num_path)
  self.maintenance = self:AddComponent(UIText, maintenance_path)
  self.efficiency = self:AddComponent(UIText, efficiency_path)
  self.damage = self:AddComponent(UIText, damage_path)
  self.repair = self:AddComponent(UIText, repair_path)
  self.name:SetLocalText(100031)
  self.num:SetLocalText(100032)
  self.maintenance:SetLocalText(100033)
  self.efficiency:SetLocalText(100034)
  self.damage:SetLocalText(100035)
  self.repair:SetLocalText(GameDialogDefine.REPAIR)
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  self.toogle1:SetIsOn(true)
  self.toogle1:SetOnValueChanged(function(tf)
    self:OnRefresh()
  end)
  self.toogle1.text = self.toogle1:AddComponent(UIText, "Text")
  self.toogle1.text:SetLocalText(100028)
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetIsOn(false)
  self.toogle2:SetOnValueChanged(function(tf)
    self:OnRefresh()
  end)
  self.toogle2.text = self.toogle2:AddComponent(UIText, "Text")
  self.toogle2.text:SetLocalText(100029)
  self.toogle3 = self:AddComponent(UIToggle, toogle3_path)
  self.toogle3:SetIsOn(false)
  self.toogle3:SetOnValueChanged(function(tf)
    self:OnRefresh()
  end)
  self.toogle3.text = self.toogle3:AddComponent(UIText, "Text")
  self.toogle3.text:SetLocalText(100030)
  self.scrollView = self:AddComponent(UIScrollView, scroll_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnBuildItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnBuildItemMoveOut(itemObj, index)
  end)
  self.reportItems = nil
end

local function OnDestroy(self)
  self.name = nil
  self.num = nil
  self.maintenance = nil
  self.efficiency = nil
  self.damage = nil
  self.repair = nil
  self.toogle1.text = nil
  self.toogle1 = nil
  self.toogle2.text = nil
  self.toogle2 = nil
  self.toogle3.text = nil
  self.toogle3 = nil
  self.scrollView = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh(self)
end

local function OnDisable(self)
  self:ClearScroll(self)
  base.OnDisable(self)
end

local function OnRefresh(self)
  self:ClearScroll(self)
  self.reportItems = self.view.ctrl.GetBuildCurrentShowList(self.view.ctrl, self.toogle1:GetIsOn(), self.toogle2:GetIsOn(), self.toogle3:GetIsOn())
  self.scrollView:SetTotalCount(#self.reportItems)
  self.scrollView:RefillCells()
end

local function OnBuildItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(PlayerBuildingReportCell, itemObj)
  cellItem:SetItemShow(self.reportItems[index])
end

local function OnBuildItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, PlayerBuildingReportCell)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(PlayerBuildingReportCell)
end

PlayerBuildingReport.OnCreate = OnCreate
PlayerBuildingReport.OnDestroy = OnDestroy
PlayerBuildingReport.OnRefresh = OnRefresh
PlayerBuildingReport.OnEnable = OnEnable
PlayerBuildingReport.OnDisable = OnDisable
PlayerBuildingReport.OnBuildItemMoveIn = OnBuildItemMoveIn
PlayerBuildingReport.OnBuildItemMoveOut = OnBuildItemMoveOut
PlayerBuildingReport.ClearScroll = ClearScroll
return PlayerBuildingReport
