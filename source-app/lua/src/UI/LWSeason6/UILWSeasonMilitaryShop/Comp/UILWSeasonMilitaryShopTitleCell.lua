local base = UIBaseContainer
local UILWSeasonMilitaryShopTitleCell = BaseClass("UILWSeasonMilitaryShopTitleCell", UIBaseContainer)

function UILWSeasonMilitaryShopTitleCell:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "p_text_cell_title")
end

function UILWSeasonMilitaryShopTitleCell:ComponentDestroy()
  self.textTitle = nil
end

function UILWSeasonMilitaryShopTitleCell:DataDefine()
  self.TickAct = false
end

function UILWSeasonMilitaryShopTitleCell:DataDestroy()
  self.TickAct = false
end

function UILWSeasonMilitaryShopTitleCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryShopTitleCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryShopTitleCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryShopTitleCell:InitData(data)
  if data ~= nil and data.Data ~= nil then
    self.Data = data.Data
    return true
  end
  return false
end

function UILWSeasonMilitaryShopTitleCell:InitUi()
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

function UILWSeasonMilitaryShopTitleCell:Update1000MS()
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

return UILWSeasonMilitaryShopTitleCell
