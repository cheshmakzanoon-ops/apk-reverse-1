local ActMonopolySaveEventItem = BaseClass("ActMonopolySaveEventItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local text_path = "Text"
local red_num_path = "RedPoint/RedNum"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.red_num = self:AddComponent(UITextMeshProUGUIEx, red_num_path)
  self.rootBtn = self:AddComponent(UIButton, "")
  self.rootBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.text = nil
  self.red_num = nil
  self.rootBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetClickFunc(self, func)
  self.clickFunc = func
end

local function SetData(self, itemShowData)
  self.itemShowData = itemShowData
  self:RefreshView()
end

local function RefreshView(self)
  local showNum = #self.itemShowData.data
  if showNum <= 0 then
    return
  end
  self.red_num:SetText(showNum)
  local showPara = self.itemShowData.data[1].entrance_pic
  local showParaList = {}
  if not string.IsNullOrEmpty(showPara) then
    showParaList = string.split(showPara, "|")
  end
  if showParaList and #showParaList == 2 then
    self.text:SetLocalText(showParaList[2])
    local iconName = showParaList[1]
    local path = string.format(UIAssets.UIActMonopolySpritePath, iconName)
    self.icon:LoadSprite(path)
  end
end

local function OnBtnClick(self)
  if self.clickFunc then
    local eventId = 0
    if self.itemShowData and 0 < #self.itemShowData.data then
      eventId = self.itemShowData.data[1].id
    end
    if 0 < eventId then
      self.clickFunc(eventId)
    end
  end
end

ActMonopolySaveEventItem.OnCreate = OnCreate
ActMonopolySaveEventItem.OnDestroy = OnDestroy
ActMonopolySaveEventItem.ComponentDefine = ComponentDefine
ActMonopolySaveEventItem.ComponentDestroy = ComponentDestroy
ActMonopolySaveEventItem.DataDefine = DataDefine
ActMonopolySaveEventItem.DataDestroy = DataDestroy
ActMonopolySaveEventItem.SetData = SetData
ActMonopolySaveEventItem.SetClickFunc = SetClickFunc
ActMonopolySaveEventItem.RefreshView = RefreshView
ActMonopolySaveEventItem.OnBtnClick = OnBtnClick
return ActMonopolySaveEventItem
