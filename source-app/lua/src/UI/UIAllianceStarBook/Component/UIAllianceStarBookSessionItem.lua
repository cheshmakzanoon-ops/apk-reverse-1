local UIAllianceStarBookSessionItem = BaseClass("UIAllianceStarBookSessionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textSession1 = self:AddComponent(UIText, "TextPanel/SessionText1")
  self.textSession2 = self:AddComponent(UIText, "TextPanel/SessionText2")
  self.textSession3 = self:AddComponent(UIText, "TextPanel/SessionText3")
  self.textPanel = self:AddComponent(UIBaseContainer, "TextPanel")
  self.textPanel:SetActive(false)
  self.textSession = self:AddComponent(UIText, "SessionText")
  self.textSession:SetActive(true)
  self.btnGoto = self:AddComponent(UIButton, "GotoBtn")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.imgLine = self:AddComponent(UIImage, "Line")
end

local function ComponentDestroy(self)
  self.textSession = nil
  self.btnGoto = nil
  self.imgLine = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnGotoClick(self)
  if self.data then
    self.view:TryShowSessionToWinnerAnim(self.data.ceremonyEdition)
  end
end

local function SetData(self, data)
  self.data = data
  local ceremonyEditionStr = tostring(data.ceremonyEdition)
  if data.ceremonyEdition < 10 then
    ceremonyEditionStr = "0" .. ceremonyEditionStr
  end
  self.textSession:SetLocalText("alliance_weeklyStar_book_column", ceremonyEditionStr, UITimeManager:GetInstance():GetTimeToMD(math.modf(data.startTimeStamp / 1000)))
end

UIAllianceStarBookSessionItem.OnCreate = OnCreate
UIAllianceStarBookSessionItem.OnDestroy = OnDestroy
UIAllianceStarBookSessionItem.OnEnable = OnEnable
UIAllianceStarBookSessionItem.OnDisable = OnDisable
UIAllianceStarBookSessionItem.ComponentDefine = ComponentDefine
UIAllianceStarBookSessionItem.ComponentDestroy = ComponentDestroy
UIAllianceStarBookSessionItem.DataDefine = DataDefine
UIAllianceStarBookSessionItem.DataDestroy = DataDestroy
UIAllianceStarBookSessionItem.OnAddListener = OnAddListener
UIAllianceStarBookSessionItem.OnRemoveListener = OnRemoveListener
UIAllianceStarBookSessionItem.OnBtnGotoClick = OnBtnGotoClick
UIAllianceStarBookSessionItem.SetData = SetData
return UIAllianceStarBookSessionItem
