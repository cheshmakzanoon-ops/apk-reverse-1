local base = UIBaseContainer
local UILWSeasonMilitaryEliteLogCell = BaseClass("UILWSeasonMilitaryEliteLogCell", UIBaseContainer)

function UILWSeasonMilitaryEliteLogCell:ComponentDefine()
  self.imgColor = self:AddComponent(UIImage, "p_log_color")
  self.imgIcon = self:AddComponent(UIImage, "p_log_icon")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "p_log_desc")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "p_log_time")
  self.btnGoto = self:AddComponent(UIButton, "p_btn_goto")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textDesc:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function UILWSeasonMilitaryEliteLogCell:ComponentDestroy()
  self.imgColor = nil
  self.imgIcon = nil
  self.textDesc = nil
  self.textTime = nil
  self.btnGoto = nil
end

function UILWSeasonMilitaryEliteLogCell:DataDefine()
end

function UILWSeasonMilitaryEliteLogCell:DataDestroy()
end

function UILWSeasonMilitaryEliteLogCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryEliteLogCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteLogCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryEliteLogCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteLogCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryEliteLogCell:InitData(data)
  if data ~= nil and data.LogData ~= nil then
    self.LogData = data.LogData
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteLogCell:InitUi()
  self.textDesc:SetText(self.LogData:GetDesc())
  self.textTime:SetText(self.LogData:GetTimeStr())
  local iconPath = self.LogData:GetIcon()
  if string.IsNullOrEmpty(iconPath) then
    self.imgIcon:SetActive(false)
  else
    self.imgIcon:SetActive(true)
    self.imgIcon:LoadSpriteAsyncWithCallback(iconPath, function(texture)
      if self and self.imgIcon then
        self.imgIcon:SetNativeSize()
      end
    end)
  end
  local colorPath = self.LogData:GetColorImg()
  if string.IsNullOrEmpty(colorPath) then
    self.imgColor:SetActive(false)
  else
    self.imgColor:SetActive(true)
    self.imgColor:LoadSprite(colorPath)
  end
end

function UILWSeasonMilitaryEliteLogCell:OnBtnGotoClick()
  self.LogData:TryGotoPos()
end

function UILWSeasonMilitaryEliteLogCell:OnPointerClick(clickPos)
  if IsNull(self.textDesc) then
    return
  end
  local linkId = self.textDesc:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    self:OnBtnGotoClick()
  elseif string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    self.LogData:TryJump(linkId)
  end
end

return UILWSeasonMilitaryEliteLogCell
