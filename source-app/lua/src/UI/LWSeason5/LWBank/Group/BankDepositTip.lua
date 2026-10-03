local base = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationScoutSelectTip")
local BankDepositTip = BaseClass("BankDepositTip", base)
local Localization = CS.GameEntry.Localization
local BankDepositItem = require("UI.LWSeason5.LWBank.Component.BankDepositItem")
local arrow_path = "Arrow"
local deco_path = "deco"
local gotoBtn_path = "gotoBtn"
local gotoTxt_path = "gotoBtn/gotoTxt"
local costTxt_path = "gotoBtn/costTxt"
local remain_path = "remain"
local sliderGroup_path = "UISliderGroup"
local sliderIcon_path = "UISliderGroup/sliderIcon"
local sliderBtn_path = "UISliderGroup/sliderIcon"
local total_path = "list/total"
local bankDepositItem_path = "list/BankDepositItem"
local depositContent_path = "list"
local itemBtn_path = "ItemInfo/itemIcon"
local itemIcon_path = "ItemInfo/itemIcon"
local itemName_path = "ItemInfo/itemName"
local itemOwn_path = "ItemInfo/itemOwn"

local function ComponentDefine(self)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
  self.deco = self:AddComponent(UIRawImage, deco_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoTxt = self:AddComponent(UIText, gotoTxt_path)
  self.costTxt = self:AddComponent(UIText, costTxt_path)
  self.remain = self:AddComponent(UIText, remain_path)
  self.sliderGroup = self:AddComponent(UIBaseContainer, sliderGroup_path)
  self.sliderIcon = self:AddComponent(UIImage, sliderIcon_path)
  self.sliderBtn = self:AddComponent(UIButton, sliderBtn_path)
  self.total = self:AddComponent(UIText, total_path)
  self.bankDepositItem = self:AddComponent(UIBaseContainer, bankDepositItem_path)
  self.depositContent = self:AddComponent(UIBaseContainer, depositContent_path)
  self.itemBtn = self:AddComponent(UIButton, itemBtn_path)
  self.itemIcon = self:AddComponent(UIImage, itemIcon_path)
  self.itemName = self:AddComponent(UIText, itemName_path)
  self.itemOwn = self:AddComponent(UIText, itemOwn_path)
  self.gotoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Scout_Btn)
    self:OnClickStartInvestigate()
  end)
  self.sliderGroup = self:AddComponent(UISliderGroup, sliderGroup_path)
  self.sliderGroup:InitTextInput()
  self.sliderGroup:SetGap(1000)
  self.sliderGroup:SetOnNumChangedHandler(function(num)
    self.sliderGroup:SetTipText(num)
    self:RefreshValue()
  end)
  self.sliderBtn:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.sliderIcon, self.cityTemplate)
  end)
  self.depositObj = self.bankDepositItem.gameObject
  self.depositObj:GameObjectCreatePool()
  self.depositObj:SetActive(false)
  self.itemBtn:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.itemIcon, self.cityTemplate)
  end)
end

local function ComponentDestroy(self)
  self.depositContent:RemoveComponents(BankDepositItem)
  self.depositObj:GameObjectRecycleAll()
  self.arrow = nil
  self.deco = nil
  self.gotoBtn = nil
  self.gotoTxt = nil
  self.costTxt = nil
  self.remain = nil
  self.sliderGroup = nil
  self.sliderIcon = nil
  self.sliderBtn = nil
  self.total = nil
  self.bankDepositItem = nil
  self.depositContent = nil
  self.itemBtn = nil
  self.itemIcon = nil
  self.itemName = nil
  self.itemOwn = nil
end

function BankDepositTip:InitUI(targetPointId, tempIndex, targetServerId)
  self.targetPointId = targetPointId
  self.targetServerId = targetServerId
  self:RefreshUI(tempIndex)
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPointId, self.targetServerId)
  local extraInfo = pointInfo and SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
  local cityTemplate = extraInfo and DataCenter.AllianceCityTemplateManager:GetTemplate(extraInfo.cityId, extraInfo.serverId)
  if not cityTemplate then
    return
  end
  self.cityTemplate = cityTemplate
  self.cityId = extraInfo.cityId
  self.serverId = extraInfo.serverId
  self.deco:LoadSpriteAsync(cityTemplate:getValue("pop_pic"))
  local detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
  local userBankInfo = detail and detail.userBankInfo
  local bankDetail = detail and detail.bankDetail
  local setting = bankDetail and bankDetail.setting
  self.minDefault = setting and setting.minDepositAmount or 0
  self.minDefault = math.max(self.minDefault, LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k2", 1000))
  DataCenter.SeasonBankManager:LoadItemIcon(self.sliderIcon, cityTemplate)
  self.gotoTxt:SetLocalText("s5_bank_ui69")
  self.sliderGroup.textTips:SetLocalText("s5_bank_ui30", LuaEntry.Player:GetFullNameWithSourceServer())
  self.total:SetLocalText("s5_bank_ui29", self.minDefault)
  local depositCount = userBankInfo and userBankInfo.depositCount or 0
  local maxDepositCount = LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k1", 3)
  self.remain:SetLocalText("140403", maxDepositCount - depositCount)
  local curNum = DataCenter.ItemData:GetItemCount(cityTemplate.asset)
  if curNum < self.minDefault then
    self.sliderGroup:SetMinNum(math.min(curNum, self.minDefault))
    self.sliderGroup:SetMaxNum(math.min(curNum, cityTemplate.max_into_asset))
    self.sliderGroup:SetDefaultNum(math.min(curNum, self.minDefault))
    self.sliderGroup:ReInit()
    self.sliderGroup:SetInteractable(false)
  else
    self.sliderGroup:SetMinNum(self.minDefault)
    self.sliderGroup:SetMaxNum(math.min(curNum, cityTemplate.max_into_asset))
    self.sliderGroup:SetDefaultNum(math.min(6000, curNum))
    self.sliderGroup:ReInit()
    self.sliderGroup:SetInteractable(true)
  end
  DataCenter.SeasonBankManager:LoadItemIcon(self.itemIcon, cityTemplate)
  self.itemOwn:SetLocalText("130128", string.GetFormattedStr2(curNum))
  local itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(cityTemplate.asset)
  if itemMeta then
    self.itemName:SetLocalText(itemMeta.name)
  end
  local openTimeStamps = DataCenter.SeasonBankTemplateManager:GetOpenTimeStamps(cityTemplate.id, self.serverId)
  self.depositContent:RemoveComponents(BankDepositItem)
  self.depositObj:GameObjectRecycleAll()
  self.items = {}
  if not table.IsNullOrEmpty(cityTemplate.interest) then
    local parent = self.depositContent.transform
    for i, v in ipairs(cityTemplate.interest) do
      local theItem = self.depositObj:GameObjectSpawn(parent)
      theItem.name = string.format("interest_%d", i)
      theItem:SetActive(true)
      theItem = self.depositContent:AddComponent(BankDepositItem, theItem.name)
      theItem:ReInit(v, i, cityTemplate.deposit_time[i], cityTemplate, self.OnTogChanged, self, openTimeStamps[i])
      self.items[i] = theItem
    end
    self:RefreshValue()
  end
  local firstItem = self.items[1]
  if firstItem then
    firstItem.tog:SetIsOnWithoutNotify(true)
    self:OnTogChanged(firstItem.day)
  end
end

function BankDepositTip:RefreshUI(tempIndex)
  self.curSelectedIndex = tempIndex
  local timeCost = self.view:GetInvesCostTime(self.targetPointId, self.targetServerId)
  self.costTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeCost * 1000))
end

function BankDepositTip:RefreshValue()
  if not self.items then
    return
  end
  local curNum = self.sliderGroup:GetCurNum()
  for _, v in pairs(self.items) do
    v:RefreshValue(curNum)
  end
end

function BankDepositTip:OnTogChanged(day)
  self.day = day
end

function BankDepositTip:OnClickStartInvestigate()
  if not DataCenter.SeasonBankManager:CheckDepositCondition(self.cityId, self.serverId, true) then
    return
  end
  local curNum = self.sliderGroup:GetCurNum()
  if curNum == 0 or curNum > DataCenter.ItemData:GetItemCount(self.cityTemplate.asset) then
    UIUtil.ShowTipsId("120021")
    return
  end
  if curNum < self.sliderGroup.minNum then
    UIUtil.ShowTipsId("season_s5_s_bank_tips_15")
    return
  end
  if curNum > self.sliderGroup.maxNum then
    UIUtil.ShowTipsId("season_s5_s_bank_tips_16")
    return
  end
  local extraParam = SFSObject.New()
  local bankDeposit = SFSObject.New()
  extraParam:PutSFSObject("bankDeposit", bankDeposit)
  bankDeposit:PutLong("depositAmount", curNum)
  bankDeposit:PutInt("depositDays", self.day)
  bankDeposit:PutUtfString("itemId", tostring(self.cityTemplate.asset))
  self.view:OnClickStartInvestigate(extraParam)
end

function BankDepositTip:ResetTipPosition(posX, posY)
  local v3 = self.arrow.transform.position
  v3.x = posX
  self.arrow.transform.position = v3
end

BankDepositTip.ComponentDefine = ComponentDefine
BankDepositTip.ComponentDestroy = ComponentDestroy
return BankDepositTip
