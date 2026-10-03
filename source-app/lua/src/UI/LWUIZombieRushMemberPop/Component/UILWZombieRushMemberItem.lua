local UILWZombieRushMemberItem = BaseClass("UILWZombieRushMemberItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.playerFlag = self:AddComponent(UICommonHead, "PlayerBtn/UIPlayerHead")
  self.playerBtn = self:AddComponent(UIButton, "PlayerBtn")
  self.femaleGenderIcon = self:AddComponent(UIImage, "NameContent/femaleGender")
  self.maleGenderIcon = self:AddComponent(UIImage, "NameContent/maleGender")
  self.nameText = self:AddComponent(UIText, "NameContent/NameText")
  self.powerText = self:AddComponent(UIText, "PowerText")
  self.waveText = self:AddComponent(UIText, "WaveText")
  self.selfBgImage = self:AddComponent(UIImage, "SelfBgImage")
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.playInfo.uid)
  end)
end

local function ComponentDestroy(self)
  self.playerFlag = nil
  self.playerBtn = nil
  self.femaleGenderIcon = nil
  self.maleGenderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.waveText = nil
  self.selfBgImage = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, playInfo)
  self.playInfo = playInfo
  self.playerFlag:SetHeadAndFrame(self.playInfo.uid, self.playInfo.pic, self.playInfo.picver, false, self.playInfo.headSkinId, self.playInfo.headSkinET)
  self.selfBgImage:SetActive(self.playInfo.uid == LuaEntry.Player.uid)
  self.maleGenderIcon:SetActive(self.playInfo.gender == 1)
  self.femaleGenderIcon:SetActive(self.playInfo.gender == 2)
  self.nameText:SetText(self.playInfo.name)
  self.powerText:SetText(self.playInfo.power)
  self.waveText:SetText(self.playInfo.recentCount)
end

UILWZombieRushMemberItem.OnCreate = OnCreate
UILWZombieRushMemberItem.OnDestroy = OnDestroy
UILWZombieRushMemberItem.OnEnable = OnEnable
UILWZombieRushMemberItem.OnDisable = OnDisable
UILWZombieRushMemberItem.ComponentDefine = ComponentDefine
UILWZombieRushMemberItem.ComponentDestroy = ComponentDestroy
UILWZombieRushMemberItem.DataDefine = DataDefine
UILWZombieRushMemberItem.DataDestroy = DataDestroy
UILWZombieRushMemberItem.OnAddListener = OnAddListener
UILWZombieRushMemberItem.OnRemoveListener = OnRemoveListener
UILWZombieRushMemberItem.SetData = SetData
return UILWZombieRushMemberItem
