local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonBountyShopTitleCell = BaseClass("SeasonBountyShopTitleCell", UIBaseContainer)

function SeasonBountyShopTitleCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
end

function SeasonBountyShopTitleCell:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
end

function SeasonBountyShopTitleCell:DataDefine()
  self.TickAct = false
end

function SeasonBountyShopTitleCell:DataDestroy()
  self.TickAct = false
end

function SeasonBountyShopTitleCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonBountyShopTitleCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonBountyShopTitleCell:OnAddListener()
  base.OnAddListener(self)
end

function SeasonBountyShopTitleCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonBountyShopTitleCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonBountyShopTitleCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonBountyShopTitleCell:InitUi()
  self.TickAct = false
  self.NextTime = 0
  self.TimeKey = nil
  local isOpen, openTime = self.Data.Data:IsOpen()
  if isOpen then
    if not string.IsNullOrEmpty(self.Data.Data.ShopCell.refresh_desc) then
      self.TickAct = true
      self.TimeKey = self.Data.Data.ShopCell.refresh_desc
      self.NextTime = self.Data.Data:GetNextRefreshTime()
    elseif not string.IsNullOrEmpty(self.Data.Data.ShopCell.refresh_desc_special) then
      self.TickAct = false
      self.textTitle:SetLocalText(self.Data.Data.ShopCell.refresh_desc_special)
    else
      self.TickAct = false
      self.textTitle:SetText("")
    end
  else
    self.TickAct = true
    self.TimeKey = self.Data.Data.ShopCell.open_desc
    self.NextTime = openTime
  end
  local actData = DataCenter.SeasonBountyShopManager:GetActData()
  if actData ~= nil and self.NextTime >= actData.endTime then
    self.TickAct = true
    self.TimeKey = "372112"
    self.NextTime = actData.endTime
  end
  self:Update1000MS()
end

function SeasonBountyShopTitleCell:UpdateData()
  return true
end

function SeasonBountyShopTitleCell:UpdateUi()
end

function SeasonBountyShopTitleCell:Update1000MS()
  if not self.TickAct then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local timeLeft = math.max(-1, self.NextTime - now)
  if 0 <= timeLeft then
    if string.IsNullOrEmpty(self.TimeKey) then
      self.textTitle:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
    else
      self.textTitle:SetLocalText(self.TimeKey, UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
    end
  else
  end
end

return SeasonBountyShopTitleCell
