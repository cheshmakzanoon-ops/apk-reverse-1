local WarFeverContent = BaseClass("WarFeverContent", UIBaseContainer)
local base = UIBaseContainer
local WarFeverItemCell = require("UI.UICityManage.Component.WarFeverItemCell")
local Localization = CS.GameEntry.Localization
local des_txt_Path = "Text_Des"
local power_txt_Path = "Text_power"
local powerDes_txt_Path = "Text_power/Text_powerDes"
local state_txt_Path = "Text_State"
local cityLevel_txt_Path = "title_cityLevel"
local cityStatus_txt_Path = "title_cityStatus"
local scroll_view_path = "ScrollView"

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
  self.des_txt = self:AddComponent(UIText, des_txt_Path)
  self.power_txt = self:AddComponent(UIText, power_txt_Path)
  self.powerDes_txt = self:AddComponent(UIText, powerDes_txt_Path)
  self.state_txt = self:AddComponent(UIText, state_txt_Path)
  self.cityLevel_txt = self:AddComponent(UIText, cityLevel_txt_Path)
  self.cityStatus_txt = self:AddComponent(UIText, cityStatus_txt_Path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.itemList = {}
  self.cells = {}
  self.attackNum = warFeverAttackInit
end

local function ComponentDestroy(self)
  self.des_txt = nil
  self.power_txt = nil
  self.powerDes_txt = nil
  self.state_txt = nil
  self.cityLevel_txt = nil
  self.cityStatus_txt = nil
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
  self.attackNum = nil
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

local function ReInit(self)
  self.des_txt:SetLocalText(129027)
  self.power_txt:SetLocalText(129030)
  local param = DataCenter.StatusManager:WarFeverStatu()
  self.itemList = self:MakeData()
  if param ~= nil then
    self.state_txt:SetText(Localization:GetString("129025") .. "(" .. Localization:GetString("120204") .. ")")
  else
    self.state_txt:SetText(Localization:GetString("129025") .. "(" .. Localization:GetString("130261") .. ")")
  end
  self.cityLevel_txt:SetLocalText(130392)
  self.cityStatus_txt:SetLocalText(300648)
  self.powerDes_txt:SetText("+ " .. self.attackNum)
  self:InitData()
end

local function InitData(self)
  self:ClearScroll(self)
  if #self.itemList > 0 then
    self.scroll_view:SetTotalCount(#self.itemList)
    self.scroll_view:RefillCells()
  end
end

local function MakeData(self)
  local list = {}
  local tempList = DataCenter.StatusManager:GetWarFeverData()
  local feverList = {}
  for k, v in pairs(tempList) do
    local statItem = LocalController:instance():getLine(TableName.StatusTab, tostring(v.status))
    local param = {}
    param.level = v.level
    param.status = statItem.time
    table.insert(feverList, param)
    if param.level == DataCenter.BuildManager.MainLv then
      self.attackNum = statItem.effect_num
    else
      self.attackNum = warFeverAttackInit
    end
  end
  local tempParam = {}
  tempParam.level = feverList[1].level
  tempParam.status = feverList[1].status
  local endLevel, endStatu
  local isAdd = false
  for k, v in pairs(feverList) do
    isAdd = false
    if v.status == tempParam.status then
      endLevel = v.level
      endStatu = v.status
    else
      isAdd = true
    end
    if isAdd == true then
      local param = {}
      if endLevel ~= nil and endStatu ~= nil then
        param.level = tempParam.level .. "~" .. endLevel
        param.statu = endStatu
      else
        param.level = tempParam.level
        param.statu = tempParam.status
      end
      endLevel = nil
      endStatu = nil
      tempParam.level = v.level
      tempParam.status = v.status
      table.insert(list, param)
    end
    if k == #feverList then
      local param = {}
      param.level = tempParam.level
      param.statu = tempParam.status
      table.insert(list, param)
    end
  end
  return list
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(WarFeverItemCell)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  self.cells[index] = self.scroll_view:AddComponent(WarFeverItemCell, itemObj)
  self.cells[index]:ReInit(self.itemList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, WarFeverItemCell)
end

WarFeverContent.OnCreate = OnCreate
WarFeverContent.OnDestroy = OnDestroy
WarFeverContent.OnEnable = OnEnable
WarFeverContent.OnDisable = OnDisable
WarFeverContent.ComponentDefine = ComponentDefine
WarFeverContent.ComponentDestroy = ComponentDestroy
WarFeverContent.DataDefine = DataDefine
WarFeverContent.DataDestroy = DataDestroy
WarFeverContent.OnAddListener = OnAddListener
WarFeverContent.OnRemoveListener = OnRemoveListener
WarFeverContent.ReInit = ReInit
WarFeverContent.InitData = InitData
WarFeverContent.ClearScroll = ClearScroll
WarFeverContent.OnItemMoveIn = OnItemMoveIn
WarFeverContent.OnItemMoveOut = OnItemMoveOut
WarFeverContent.MakeData = MakeData
return WarFeverContent
