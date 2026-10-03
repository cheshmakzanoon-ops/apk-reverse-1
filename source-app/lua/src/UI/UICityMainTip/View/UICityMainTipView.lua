local UICityMainTipView = BaseClass("UICityMainTipView", UIBaseView)
local UICityMainProgress = require("UI.UICityMainTip.Component.UICityMainProgress")
local base = UIBaseView
local obj_path = ""
local title_tips_txt_path = "tips/title_tips"
local return_btn_path = "panel"
local btn_path = "RightBtn"
local btn_txt_path = "RightBtn/RightBtnName"
local scroll_view_path = "ScrollView"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityMainTip, {anim = true})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICityManage)
  end)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.btn_txt:SetLocalText(100092)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.obj = self:AddComponent(UIAnimator, obj_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.itemList = {}
  self.cells = {}
  self:InitData()
  self:CreateData()
end

local function ComponentDestroy(self)
  self.btn_txt = nil
  self.return_btn = nil
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
end

local function InitData(self)
  local effectStatus = DataCenter.StatusManager:GetAllStatusItem()
  local now = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(effectStatus) do
    local intKey = tonumber(k)
    local numValue = tonumber(v)
    local statItem = LocalController:instance():getLine(TableName.StatusTab, tostring(intKey))
    if statItem then
      local item = DataCenter.ItemTemplateManager:GetItemByPara(intKey)
      if item ~= nil then
        if 0 < numValue - now then
          local param = {}
          param.endTime = numValue
          param.totalTime = statItem.time * 1000
          param.icon = item.icon
          param.description = item.name
          table.insert(self.itemList, param)
        end
      elseif tonumber(statItem.type2) == CityBuffType.WarFever then
        local tempItem = LocalController:instance():getLine(TableName.CityManage, intKey)
        local time = numValue - now
        if 0 < time and tempItem ~= nil then
          local param = {}
          param.endTime = numValue
          param.totalTime = statItem.time * 1000
          param.icon = tempItem.icon
          param.description = tempItem.name
          table.insert(self.itemList, param)
        end
      end
    end
  end
end

local function CreateData(self)
  self:ClearScroll(self)
  if #self.itemList > 0 then
    self.scroll_view:SetTotalCount(#self.itemList)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICityMainProgress)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  self.cells[index] = self.scroll_view:AddComponent(UICityMainProgress, itemObj)
  local param = {}
  param.endTime = self.itemList[index].endTime
  param.totalTime = self.itemList[index].totalTime
  param.description = self.itemList[index].description
  param.icon = self.itemList[index].icon
  param.index = index
  self.cells[index]:ReInit(param)
end

local function OnItemMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UICityMainProgress)
end

UICityMainTipView.OnCreate = OnCreate
UICityMainTipView.OnDestroy = OnDestroy
UICityMainTipView.ComponentDefine = ComponentDefine
UICityMainTipView.ComponentDestroy = ComponentDestroy
UICityMainTipView.InitData = InitData
UICityMainTipView.ClearScroll = ClearScroll
UICityMainTipView.OnItemMoveIn = OnItemMoveIn
UICityMainTipView.OnItemMoveOut = OnItemMoveOut
UICityMainTipView.CreateData = CreateData
return UICityMainTipView
