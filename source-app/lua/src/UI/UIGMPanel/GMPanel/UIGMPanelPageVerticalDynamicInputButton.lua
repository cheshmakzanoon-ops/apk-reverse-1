local base = UIAsyncContainer
local UIGMPanelPageVerticalDynamicInputButton = BaseClass("UIGMPanelPageVerticalDynamicInputButton", base)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageVerticalDynamicInputButton:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalDynamicInputButton:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalDynamicInputButton:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.input = self.viewSkin:AddComponent(self, UIInput, 1)
  self.btnInput = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInput:SetOnClick(function()
    self:OnBtnInputClick()
  end)
  self.textTmpBtnName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBtn = self.viewSkin:AddComponent(self, UIImage, 4)
  self.input:SetOnEndEdit(function(value)
    self:OnEndEdit(value)
  end)
end

function UIGMPanelPageVerticalDynamicInputButton:ComponentDestroy()
  self.viewSkin = nil
  self.input = nil
  self.btnInput = nil
  self.textTmpBtnName = nil
  self.imgBtn = nil
end

function UIGMPanelPageVerticalDynamicInputButton:DataDefine()
end

function UIGMPanelPageVerticalDynamicInputButton:DataDestroy()
end

function UIGMPanelPageVerticalDynamicInputButton:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageVerticalDynamicInputButton:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalDynamicInputButton:OnBtnClick()
end

function UIGMPanelPageVerticalDynamicInputButton:ReInit(data, parentItem)
  self.data = data
  self.parentItem = parentItem
  self.min = self.data.min or 0
  self.max = self.data.max or 100
  local defaultVal = self.data.get()
  if data.contentType then
    self.input:SetContentType(data.contentType)
  end
  self.input:SetText(defaultVal)
  self.onClicked = self.data.onClicked
  if data.btnName then
    self.textTmpBtnName:SetText(data.btnName)
  else
    self.textTmpBtnName:SetText("OK")
  end
  self.val = defaultVal
  self:RefreshSkin()
end

function UIGMPanelPageVerticalDynamicInputButton:OnEndEdit(val)
  if self.data.contentType == 2 or self.data.contentType == 3 then
    val = Mathf.Clamp(tonumber(val) or 0, self.min, self.max)
  end
  self.input:SetText(val)
  if self.data.set then
    self.data.set(val)
  end
  self.val = val
end

function UIGMPanelPageVerticalDynamicInputButton:OnBtnInputClick()
  if self.onClicked then
    self.onClicked(self.val)
  end
end

function UIGMPanelPageVerticalDynamicInputButton:RefreshSkin(skin)
  skin = skin or GMUtils.GetSkinPath()
  self.imgBtn:LoadSpriteAuto(skin.btnBg)
end

return UIGMPanelPageVerticalDynamicInputButton
