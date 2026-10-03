local MailSoldierPageItem = BaseClass("MailSoldierPageItem", UIBaseContainer)
local base = UIBaseContainer
local UILostSoldierTip = require("UI.UILostSoldierTip.View.UILostSoldierTipView")

function MailSoldierPageItem:OnCreate()
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
    param.topDesc = self.topDesc
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILostSoldierTip, {anim = true}, param)
  end)
  self.tip_txt = self:AddComponent(UIText, "tip_txt")
  self.icon = self:AddComponent(UIImage, "icon")
end

function MailSoldierPageItem:OnDestroy()
  base.OnDestroy(self)
end

function MailSoldierPageItem:ReInit(dataList, language_id, iconPath, soldierData, topDesc, hideColor_)
  if table.IsNullOrEmpty(dataList) then
    self:SetActive(false)
  else
    self:SetActive(true)
    local totalDeathCount = 0
    for k, v in pairs(dataList) do
      if v then
        totalDeathCount = totalDeathCount + toInt(v.count)
      end
    end
    if iconPath then
      self.icon:LoadSpriteAsync(iconPath)
    end
    if hideColor_ then
      self.tip_txt:SetLocalText(language_id, totalDeathCount)
    else
      self.tip_txt:SetLocalText(language_id, string.format("<color=#E64141>%s</color>", totalDeathCount))
    end
    self.transform:SetAsLastSibling()
    self.dataList = dataList
    self.soldierData = soldierData
    self.topDesc = topDesc
  end
end

return MailSoldierPageItem
