local LWUIMasteryChooseCompItem = BaseClass("LWUIMasteryChooseCompItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.bgBtn = self:AddComponent(UIButton, "")
  self.bgBtn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.bg = self:AddComponent(UIRawImage, "bg")
  self.nameTxt = self:AddComponent(UIText, "nameTxt")
  self.icon = self:AddComponent(UIImage, "iIcon")
  self.beselect = self:AddComponent(UIBaseContainer, "beselect")
  self.lock = self:AddComponent(UIBaseContainer, "lock")
end

local function ComponentDestroy(self)
  self.bgBtn = nil
  self.bg = nil
  self.nameTxt = nil
  self.icon = nil
  self.beselect = nil
  self.lock = nil
end

local function DataDefine(self)
  self.selfHomeId = 0
  self.selectHomeId = 0
  self.clickFunc = nil
end

local function DataDestroy(self)
  self.selfHomeId = nil
  self.selectHomeId = nil
  self.clickFunc = nil
end

local function SetData(self, selfHomeId, selectHomeId, clickFunc)
  self.selfHomeId = selfHomeId
  self.selectHomeId = selectHomeId
  self.clickFunc = clickFunc
  self:Refresh()
end

local function SetSelectData(self, selectHomeId)
  self.selectHomeId = selectHomeId
  self.beselect:SetActive(self.selectHomeId == self.selfHomeId)
end

local function Refresh(self)
  self.beselect:SetActive(self.selectHomeId == self.selfHomeId)
  local imgName = ""
  local imgPath = ""
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.selfHomeId)
  if showTemp then
    self.nameTxt:SetLocalText(showTemp.name)
    imgName = showTemp.icon
    imgPath = showTemp:GetIconFullPath()
    self.icon:LoadSprite(imgPath)
    imgName = showTemp.mastery_pic
    imgPath = showTemp:GetPicFullPath()
    self.bg:LoadSpriteAsync(imgPath)
    self.lock:SetActive(showTemp.lock)
    local itemColor = 255
    if showTemp.lock then
      itemColor = 41
    end
    self.bg:SetColorRGBA255(itemColor, itemColor, itemColor, 255)
    self.icon:SetColorRGBA255(itemColor, itemColor, itemColor, 255)
    self.nameTxt:SetColorRGBA255(itemColor, itemColor, itemColor, 255)
  end
end

local function OnBtnClickFunc(self)
  if self.clickFunc then
    self.clickFunc(self.selfHomeId)
  end
end

LWUIMasteryChooseCompItem.OnCreate = OnCreate
LWUIMasteryChooseCompItem.OnDestroy = OnDestroy
LWUIMasteryChooseCompItem.ComponentDefine = ComponentDefine
LWUIMasteryChooseCompItem.ComponentDestroy = ComponentDestroy
LWUIMasteryChooseCompItem.DataDefine = DataDefine
LWUIMasteryChooseCompItem.DataDestroy = DataDestroy
LWUIMasteryChooseCompItem.SetData = SetData
LWUIMasteryChooseCompItem.SetSelectData = SetSelectData
LWUIMasteryChooseCompItem.Refresh = Refresh
LWUIMasteryChooseCompItem.OnBtnClickFunc = OnBtnClickFunc
return LWUIMasteryChooseCompItem
