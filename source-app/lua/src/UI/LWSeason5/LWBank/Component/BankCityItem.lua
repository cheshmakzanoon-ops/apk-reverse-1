local base = UIBaseContainer
local BankCityItem = BaseClass("BankCityItem", base)
local itemBg_path = "content/itemBg1"
local root_path = "content/root"
local buildIcon_path = "content/root/building/icon"
local buildLevel_path = "content/root/txtLevel"
local posText_path = "content/root/Pos/Text"
local posBtn_path = "content/root/Pos"
local valueInfo_path = "content/root/valueInfo"
local valueCount_path = "content/root/valueInfo/valueCount"
local valueIcon_path = "content/root/valueInfo/valueIcon"
local stateText_path = "content/root/stateText"
local animator_path = "content"
local btnSetting_path = "content/root/btnSetting"
local saveLayout_path = "content/root/saveLayout"
local saveText_path = "content/root/saveLayout/save"
local iconBank_path = "content/root/saveLayout/iconBank"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.itemBg = self:AddComponent(UIImage, itemBg_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.buildIcon = self:AddComponent(UIImage, buildIcon_path)
  self.buildLevel = self:AddComponent(UIText, buildLevel_path)
  self.posText = self:AddComponent(UIText, posText_path)
  self.posBtn = self:AddComponent(UIButton, posBtn_path)
  self.valueInfo = self:AddComponent(UIBaseContainer, valueInfo_path)
  self.valueCount = self:AddComponent(UIText, valueCount_path)
  self.valueIcon = self:AddComponent(UIImage, valueIcon_path)
  self.stateText = self:AddComponent(UIText, stateText_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.btnSetting = self:AddComponent(UIButton, btnSetting_path)
  self.saveLayout = self:AddComponent(UIBaseContainer, saveLayout_path)
  self.saveText = self:AddComponent(UIText, saveText_path)
  self.iconBank = self:AddComponent(UIImage, iconBank_path)
  self.posBtn:SetOnClick(function()
    local v3 = SceneUtils.TileToWorld(self.data.pos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.serverId, 0)
  end)
  self.btnSetting:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankSetting, {anim = true}, self.data.id, self.data.serverId)
  end)
end

local function ComponentDestroy(self)
  self.canvasGroup = nil
  if not IsNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
  self.itemBg = nil
  self.root = nil
  self.buildIcon = nil
  self.buildLevel = nil
  self.posText = nil
  self.posBtn = nil
  self.valueInfo = nil
  self.valueCount = nil
  self.valueIcon = nil
  self.stateText = nil
  self.animator = nil
  self.btnSetting = nil
  self.saveLayout = nil
  self.saveText = nil
  self.iconBank = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankCityItem:ReInit(index, data, depositBanksDic, playAnim)
  self.index = index
  self.data = data
  self.posText:SetText(string.format("#%s %s", self.data.serverId, self.data.posStr))
  self.buildIcon:LoadSprite(self.data.iconPath)
  self.buildLevel:SetLocalText("140002", self.data.level)
  self.btnSetting:SetActive(self.data:IsOwner())
  self.saveText:SetLocalText(135225, self.data.curDepositNum, self.data.max_player or 0)
  self.iconBank:LoadSprite(DataCenter.SeasonBankManager:GetDepositIcon(depositBanksDic[data.id]))
  DataCenter.SeasonBankManager:LoadItemIcon(self.valueIcon, self.data:GetMeta())
  self.valueCount:SetText(string.GetFormattedStr2(self.data.curAsset))
end

function BankCityItem:PlayAnim(playAnim)
  if not self.animator then
    return
  end
  if playAnim == true then
    self.animator:Enable(false)
    if self.canvasGroup then
      self.canvasGroup:SetAlpha(0)
    end
    if not IsNull(self.sequence) then
      self.sequence:Pause()
      self.sequence:Kill()
      self.sequence = nil
    end
    self.sequence = DOTween.Sequence()
    self.sequence:AppendInterval(self.index * 0.02)
    self.sequence:AppendCallback(function()
      if self and self.animator then
        self.animator:Enable(true)
      end
    end)
  else
    self.animator:SampleAnimationAtTime("Eff_VipExtendCitySkinProduceItem", 1)
    self.animator:Enable(false)
    self:SetActive(true)
  end
end

BankCityItem.OnCreate = OnCreate
BankCityItem.OnDestroy = OnDestroy
BankCityItem.OnEnable = OnEnable
BankCityItem.OnDisable = OnDisable
BankCityItem.ComponentDefine = ComponentDefine
BankCityItem.ComponentDestroy = ComponentDestroy
BankCityItem.DataDefine = DataDefine
BankCityItem.DataDestroy = DataDestroy
return BankCityItem
