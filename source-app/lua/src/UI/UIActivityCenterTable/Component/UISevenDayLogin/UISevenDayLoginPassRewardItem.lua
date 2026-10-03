local UISevenDayLoginPassRewardItem = BaseClass("UISevenDayLoginPassRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISevenDayLoginPassItemCell = require("UI.UIActivityCenterTable.Component.UISevenDayLogin.UISevenDayLoginPassItemCell")
local root_path = "Root"
local free_cell_path = "Root/FreeCell"
local pay_cell1_path = "Root/PayCell1"
local pay_cell2_path = "Root/PayCell2"
local desc_path = "Root/Desc"
local icon_path = "Root/Icon"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.free_cell = self:AddComponent(UISevenDayLoginPassItemCell, free_cell_path)
  self.pay_cell_1 = self:AddComponent(UISevenDayLoginPassItemCell, pay_cell1_path)
  self.pay_cell2_path = self:AddComponent(UISevenDayLoginPassItemCell, pay_cell2_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.free_cell = nil
  self.pay_cell_1 = nil
  self.pay_cell2_path = nil
  self.desc_text = nil
  self.icon = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, view)
  self.view = view
  self.data = data
  self.root_go:SetActive(true)
  self.desc_text:SetText(data.level)
  local locked
  locked = data.curLv < data.level
  if data.normalReward[1] then
    local dataTop = {
      locked = locked,
      reward = data.normalReward[1],
      state = data.normalState,
      isTop = true,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.free_cell:SetActive(true)
    self.free_cell:SetData(dataTop)
  else
    self.free_cell:SetActive(false)
  end
  if #data.specialReward == 2 then
    table.sort(data.specialReward, function(a, b)
      return a.type == RewardType.GOLD
    end)
  end
  if data.specialReward[1] then
    local dataBottom1 = {
      locked = locked,
      reward = data.specialReward[1],
      state = data.specialState,
      isTop = false,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.pay_cell_1:SetActive(true)
    self.pay_cell_1:SetData(dataBottom1)
  else
    self.pay_cell_1:SetActive(false)
  end
  if data.specialReward[2] then
    local dataBottom2 = {
      locked = locked,
      reward = data.specialReward[2],
      state = data.specialState,
      isTop = false,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.pay_cell2_path:SetActive(true)
    self.pay_cell2_path:SetData(dataBottom2)
  else
    self.pay_cell2_path:SetActive(false)
  end
  if data.curLv < data.level then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/zyf_7ridenglu_jindutiao2.png")
  elseif data.curLv == data.level then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/zyf_7ridenglu_tianshu1.png")
  elseif data.curLv > data.level then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/zyf_7ridenglu_tianshu2.png")
  end
end

local function SetBlank(self)
  self.root_go:SetActive(false)
end

UISevenDayLoginPassRewardItem.OnCreate = OnCreate
UISevenDayLoginPassRewardItem.OnDestroy = OnDestroy
UISevenDayLoginPassRewardItem.OnEnable = OnEnable
UISevenDayLoginPassRewardItem.OnDisable = OnDisable
UISevenDayLoginPassRewardItem.ComponentDefine = ComponentDefine
UISevenDayLoginPassRewardItem.ComponentDestroy = ComponentDestroy
UISevenDayLoginPassRewardItem.DataDefine = DataDefine
UISevenDayLoginPassRewardItem.DataDestroy = DataDestroy
UISevenDayLoginPassRewardItem.OnAddListener = OnAddListener
UISevenDayLoginPassRewardItem.OnRemoveListener = OnRemoveListener
UISevenDayLoginPassRewardItem.SetData = SetData
UISevenDayLoginPassRewardItem.SetBlank = SetBlank
return UISevenDayLoginPassRewardItem
