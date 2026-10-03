local MailSoldierPageItemAsync = BaseClass("MailSoldierPageItemAsync", UIAsyncContainer)
local base = UIAsyncContainer
local UILostSoldierTip = require("UI.UILostSoldierTip.View.UILostSoldierTipView")

function MailSoldierPageItemAsync:OnCreate()
  base.OnCreate(self)
  self.tip_btn = self:AddComponent(UIButton, "tip_btn")
  self.tip_btn:SetOnClick(function()
    if self.dataList == nil or table.IsNullOrEmpty(self.dataList) then
      return
    end
    local param = UILostSoldierTip.ParamDataClass.New()
    param.position = self.tip_btn:GetPosition()
    param.deltaX = -20
    param.deltaY = 25
    param.contentX = 180
    param.data = {
      soldierData = self.soldierData,
      dataList = self.dataList
    }
    param.isPositive = self.isPositive
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILostSoldierTip, {anim = true}, param)
  end)
  self.tip_txt = self:AddComponent(UIText, "tip_txt")
  self.icon = self:AddComponent(UIImage, "icon")
  self.bg = self:AddComponent(UIImage, "")
end

function MailSoldierPageItemAsync:OnDestroy()
  base.OnDestroy(self)
end

function MailSoldierPageItemAsync:ReInit(dataList, language_id, iconPath, isPositive, soldierData, value)
  self.dataList = dataList
  self.language_id = language_id
  self.iconPath = iconPath
  self.isPositive = isPositive
  self.soldierData = soldierData
  self.value = value
  self:RefreshView()
end

local NEGATIVE_BG_PATH = "Assets/Main/Sprites/UI/UILWMail/zxl_zhanbao_tixing.png"
local POSITIVE_BG_PATH = "Assets/Main/Sprites/UI/UILWMail/fx_zhanbao_lv_diban.png"

function MailSoldierPageItemAsync:UpdateData()
  if table.IsNullOrEmpty(self.dataList) then
    self:SetActive(false)
  else
    self:SetActive(true)
    if self.iconPath then
      self.icon:LoadSprite(self.iconPath)
    end
    local colorStr = self.isPositive and "<color=#009b4a>%s</color>" or "<color=#E64141>%s</color>"
    self.tip_txt:SetLocalText(self.language_id, string.format(colorStr, self.value))
    self.transform:SetAsLastSibling()
    self.dataList = self.dataList
    if self.isPositive then
      self.bg:LoadSprite(POSITIVE_BG_PATH)
    else
      self.bg:LoadSprite(NEGATIVE_BG_PATH)
    end
  end
end

return MailSoldierPageItemAsync
