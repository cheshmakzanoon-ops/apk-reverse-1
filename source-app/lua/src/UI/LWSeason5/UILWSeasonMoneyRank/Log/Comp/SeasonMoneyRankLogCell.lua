local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonMoneyRankLogCell = BaseClass("SeasonMoneyRankLogCell", UIBaseContainer)

function SeasonMoneyRankLogCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgColor = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textDesc:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function SeasonMoneyRankLogCell:ComponentDestroy()
  self.viewSkin = nil
  self.imgColor = nil
  self.imgIcon = nil
  self.textDesc = nil
  self.textTime = nil
  self.btnGoto = nil
end

function SeasonMoneyRankLogCell:DataDefine()
end

function SeasonMoneyRankLogCell:DataDestroy()
end

function SeasonMoneyRankLogCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonMoneyRankLogCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMoneyRankLogCell:OnAddListener()
  base.OnAddListener(self)
end

function SeasonMoneyRankLogCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonMoneyRankLogCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMoneyRankLogCell:InitData(data)
  if data ~= nil and data.LogData ~= nil then
    self.LogData = data.LogData
    return true
  end
  return false
end

function SeasonMoneyRankLogCell:InitUi()
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

function SeasonMoneyRankLogCell:OnBtnGotoClick()
  self.LogData:TryGotoPos()
end

function SeasonMoneyRankLogCell:OnPointerClick(clickPos)
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

return SeasonMoneyRankLogCell
