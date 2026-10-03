local base = UIBaseContainer
local BankRobTip = BaseClass("BankRobTip", base)
local ResourceManager = CS.GameEntry.Resource
local slider_path = "bg"
local slider_value_path = "bg/sliderValue"
local battle_icon_path = "bg/battleIcon"
local battle_time_path = "bg/battleTime"
local sliderH = 120

function BankRobTip:__init(gameObject)
  self.parentTabs = gameObject.transform
  self.lodCache = 1
  self:InitPrefab()
end

function BankRobTip:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.parentTabs = nil
  self.lodCache = 1
end

function BankRobTip:OnCreate()
  base.OnCreate(self)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderValue = self:AddComponent(UIText, slider_value_path)
  self.battleIcon = self:AddComponent(UIImage, battle_icon_path)
  self.battleTime = self:AddComponent(UIText, battle_time_path)
end

function BankRobTip:OnDestroy()
  self.slider = nil
  self.sliderValue = nil
  self.battleIcon = nil
  self.battleTime = nil
  base.OnDestroy(self)
end

function BankRobTip:UpdateData()
  self:DoRefresh()
end

function BankRobTip:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function BankRobTip:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function BankRobTip:ReInit(data, bankRobInfo, theExtraInfo)
  self.data = data
  self.bankRobInfo = bankRobInfo
  self.theExtraInfo = theExtraInfo
  self.battleEnd = false
  self:DoRefresh()
end

function BankRobTip:DoRefresh()
  self.endTime = self.bankRobInfo.robEndTime / 1000
  self:RefreshUI()
  self:Update1000MS()
end

function BankRobTip:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankRobTip.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTabs) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.parentTabs)
    go.transform:Set_localScale(0.01, 0.01, 0.01)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:UpdateData()
  end)
  self.request = request
end

function BankRobTip:Update1000MS()
  if not IsNotNull(self.gameObject) then
    return
  end
  if self.battleEnd then
    self.selfActive = false
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
    return
  end
  if self.endTime and self.endTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.battleTime:SetText(UITimeManager:GetInstance():SecondToFmtString(deltaTime))
    else
      self.battleEnd = true
      self.battleTime:SetText("00:00:00")
    end
  end
end

function BankRobTip:RefreshUI()
  if not IsNotNull(self.gameObject) or not self.bankRobInfo then
    return
  end
  self.robAmount = self.bankRobInfo.robAmount or 0
  local totalAmount = math.max(self.bankRobInfo.totalAmount or 1, 1)
  self.sliderValue:SetText(string.GetFormattedSeperatorNum(math.floor(totalAmount - self.robAmount)))
  local rate = 1 - self.robAmount / totalAmount
  self.slider:SetValue(rate)
  local cityTemplate = self.theExtraInfo and DataCenter.AllianceCityTemplateManager:GetTemplate(self.theExtraInfo.strongholdId, self.theExtraInfo.serverId)
  DataCenter.SeasonBankManager:LoadItemIcon(self.battleIcon, cityTemplate)
  local thisRobNum = self.bankRobInfo.ext and self.bankRobInfo.ext.thisRobNum
  if thisRobNum and 0 < thisRobNum and self.theExtraInfo and self.lodCache <= 3 then
    local itemConf = cityTemplate and DataCenter.ItemTemplateManager:GetItemTemplate(cityTemplate.asset or 0)
    local icon = itemConf and string.format(LoadPath.ItemPath, itemConf.icon) or ""
    DataCenter.SeasonBankManager:ShowBankPopText(self:GetPosition(), string.format("+%s", thisRobNum), icon, self.bankRobInfo.ext.robUser, 3.5)
    DataCenter.LWSoundManager:PlaySound(5100002, false)
    self.bankRobInfo.ext.thisRobNum = nil
  end
end

return BankRobTip
