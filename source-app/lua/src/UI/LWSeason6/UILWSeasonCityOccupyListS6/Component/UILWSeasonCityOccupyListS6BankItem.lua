local base = require("UI.LWSeason6.UILWSeasonCityOccupyListS6.Component.UILWSeasonCityOccupyListS6Item")
local UILWSeasonCityOccupyListS6BankItem = BaseClass("UILWSeasonCityOccupyListS6BankItem", base)
local btnSetting_path = "btnSetting"
local valueInfo_path = "valueInfo"
local valueCount_path = "valueInfo/valueCount"
local valueIcon_path = "valueInfo/valueIcon"

function UILWSeasonCityOccupyListS6BankItem:OnCreate()
  base.OnCreate(self)
  self.btnSetting = self:AddComponent(UIButton, btnSetting_path)
  self.valueInfo = self:AddComponent(UIBaseContainer, valueInfo_path)
  self.valueCount = self:AddComponent(UIText, valueCount_path)
  self.valueIcon = self:AddComponent(UIImage, valueIcon_path)
  self.btnSetting:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankSetting, {anim = true}, self.dataConfig.id, self.serverId)
  end)
end

function UILWSeasonCityOccupyListS6BankItem:ReInit(index, dataConfig, isCity)
  base.ReInit(self, index, dataConfig, isCity)
  DataCenter.SeasonBankManager:LoadItemIcon(self.valueIcon, dataConfig)
  local list, value = DataCenter.SeasonDataManager.CrossOccupyStrongholdList
  if list then
    for _, v in ipairs(list) do
      if v.id == self.cityId then
        value = v
      end
    end
  end
  self.valueCount:SetText(string.GetFormattedStr2(value and value.depositAmount or 0))
  local hasDeposit = DataCenter.SeasonBankManager:HasDepositInBank(self.cityId)
  self.member_icon:LoadSprite(DataCenter.SeasonBankManager:GetDepositIcon(hasDeposit))
end

return UILWSeasonCityOccupyListS6BankItem
