local UIPVESelectAdventureSubCell = BaseClass("UIPVESelectAdventureSubCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local icon_path = "Bg/Icon"
local name_path = "Bg/Name"
local power_go_path = "Bg/PowerGo"
local power_text_path = "Bg/PowerGo/PowerText"
local army_text_path = "Bg/PowerGo/ArmyText"
local scroll_view_path = "Bg/ScrollView"
local content_title_path = "Bg/ContentTitle"
local content_desc_path = "Bg/ContentDesc"
local content_log_path = "Bg/ContentLog"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.bg_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.power_go = self:AddComponent(UIBaseContainer, power_go_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.army_text = self:AddComponent(UIText, army_text_path)
  self.content_title_text = self:AddComponent(UIText, content_title_path)
  self.content_title_text:SetLocalText(300131)
  self.content_desc_text = self:AddComponent(UIText, content_desc_path)
  self.content_log_text = self:AddComponent(UIText, content_log_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.icon_image = nil
  self.name_text = nil
  self.power_go = nil
  self.power_text = nil
  self.army_text = nil
  self.content_title_text = nil
  self.content_desc_text = nil
  self.content_log_text = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.apsRandom = ApsRandom.New()
  self.subType = AdventureType.Default
  self.content = ""
  self.dataList = {}
  self.itemList = {}
end

local function DataDestroy(self)
  self.apsRandom = nil
  self.subType = nil
  self.content = nil
  self.dataList = nil
  self.itemList = nil
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
  self.power_go:SetActive(false)
  self.content_desc_text:SetActive(false)
  self.scroll_view:SetActive(false)
  local result = DataCenter.AdventureManager:GetSubContent(param)
  self.subType = result.subType
  self.content = result.content
  self.dataList = result.rewardList
  self.param = param
  if param.type == AdventureType.Monster then
    self.name_text:SetLocalText(302277)
    local power, army = self.view.ctrl:GetMonsterPower(tonumber(self.content))
    self.power_text:SetText(string.GetFormattedSeperatorNum(power))
    self.army_text:SetText(string.GetFormattedSeperatorNum(army))
    self.power_go:SetActive(true)
    self.scroll_view:SetActive(true)
    self:ShowScroll()
  elseif param.type == AdventureType.Buff then
    self.name_text:SetLocalText(100162)
    local descStrList = DataCenter.AdventureManager:GetBuffContentStrList(self.content)
    self.content_desc_text:SetText(string.join(descStrList, "\n"))
    self.content_desc_text:SetActive(true)
  elseif param.type == AdventureType.Reward then
    self.name_text:SetLocalText(130065)
    self.scroll_view:SetActive(true)
    self:ShowScroll()
  elseif param.type == AdventureType.Box then
    self.name_text:SetLocalText(302269)
    self.content_desc_text:SetText(result.desc)
    self.content_desc_text:SetActive(true)
  end
  if CS.CommonUtils.IsDebug() then
    self.content_log_text:SetActive(true)
    self.content_log_text:SetText(self.content)
  else
    self.content_log_text:SetActive(false)
  end
  self.icon_image:LoadSprite(result.icon)
  self.icon_image:SetNativeSize()
end

local function OnClick(self)
  if not self.view.canSelectCell then
    return
  end
  local resItemCount = 0
  for _, data in ipairs(self.dataList) do
    if data.rewardType == RewardType.RESOURCE_ITEM then
      resItemCount = resItemCount + data.count
    end
  end
  if DataCenter.ResourceItemDataManager:CheckIsStorageFull(resItemCount) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
    return
  end
  self.view.canSelectCell = false
  local selectInfo = {}
  selectInfo.triggerId = self.param.trigger.config.triggerId
  selectInfo.type = self.param.type
  selectInfo.subType = self.subType
  selectInfo.content = self.content
  DataCenter.AdventureManager:SetSelectInfo(selectInfo)
  if self.param.type == AdventureType.Monster then
    DataCenter.BattleLevel:EnterBattle(self.param.trigger)
  else
    DataCenter.AdventureManager:SendSelect()
  end
  self.view.ctrl:CloseSelf()
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local data = self.dataList[index]
  local item = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(data)
  self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
  self.itemList[index] = nil
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.dataList)
  if #self.dataList > 0 then
    self.scroll_view:RefillCells()
  end
end

UIPVESelectAdventureSubCell.OnCreate = OnCreate
UIPVESelectAdventureSubCell.OnDestroy = OnDestroy
UIPVESelectAdventureSubCell.ComponentDefine = ComponentDefine
UIPVESelectAdventureSubCell.ComponentDestroy = ComponentDestroy
UIPVESelectAdventureSubCell.DataDefine = DataDefine
UIPVESelectAdventureSubCell.DataDestroy = DataDestroy
UIPVESelectAdventureSubCell.OnEnable = OnEnable
UIPVESelectAdventureSubCell.OnDisable = OnDisable
UIPVESelectAdventureSubCell.OnAddListener = OnAddListener
UIPVESelectAdventureSubCell.OnRemoveListener = OnRemoveListener
UIPVESelectAdventureSubCell.ReInit = ReInit
UIPVESelectAdventureSubCell.OnClick = OnClick
UIPVESelectAdventureSubCell.OnCreateCell = OnCreateCell
UIPVESelectAdventureSubCell.OnDeleteCell = OnDeleteCell
UIPVESelectAdventureSubCell.ShowScroll = ShowScroll
return UIPVESelectAdventureSubCell
