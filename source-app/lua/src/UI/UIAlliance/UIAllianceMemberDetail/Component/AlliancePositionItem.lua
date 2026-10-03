local AlliancePositionItem = BaseClass("AlliancePositionItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Localization = CS.GameEntry.Localization
local add_path = "GameObject/head/Add"
local playerHead_path = "GameObject/head/PlayerHead/UIPlayerHead"
local playerHeadContainer_path = "GameObject/head/PlayerHead"
local playerHeadFg_path = "GameObject/head/PlayerHead/UIPlayerHead/Foreground"
local headBtn_path = "GameObject/head"
local playerName_path = "GameObject/playerName"
local playerPos_path = "GameObject/posName"
local posBtn_path = "GameObject/posName"
local icon_path = "GameObject/bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.addN = self:AddComponent(UIBaseContainer, add_path)
  self.playerHeadContainerN = self:AddComponent(UIBaseContainer, playerHeadContainer_path)
  self.playerHeadN = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHeadN:SetEnableClickShowInfo(true, false)
  self.headBtnN = self:AddComponent(UIButton, headBtn_path)
  self.headBtnN:SetOnClick(function()
    self:OnClickHeadBtn()
  end)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.playerPosN = self:AddComponent(UIText, playerPos_path)
  self.posBtnN = self:AddComponent(UIButton, posBtn_path)
  self.posBtnN:SetOnClick(function()
    self:OnClickPosBtn()
  end)
  self.offcialIcon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.addN = nil
  self.playerHeadN = nil
  self.headBtnN = nil
  self.playerNameN = nil
  self.playerPosN = nil
  self.posBtnN = nil
  self.offcialIcon = nil
end

local function DataDefine(self)
  self.officialPos = nil
end

local function DataDestroy(self)
  self.officialPos = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllianceOfficialPosChange, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllianceOfficialPosChange, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function SetItem(self, pos, isSelfAlliance)
  self.officialPos = pos
  self.isSelfAlliance = isSelfAlliance
  if self.isSelfAlliance == nil then
    self.isSelfAlliance = true
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  if not self.isSelfAlliance then
    self.memberInfo = DataCenter.AllianceTempListManager:GetMemberInfoByOfficialPos(self.officialPos)
  else
    self.memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.officialPos)
  end
  if self.memberInfo then
    self.addN:SetActive(false)
    self.playerHeadContainerN:SetActive(true)
    self.playerHeadN:SetData(self.memberInfo.uid, self.memberInfo.pic, self.memberInfo.picVer, nil, self.memberInfo:GetHeadBgImg())
    self.playerNameN:SetText(self.memberInfo.name)
  else
    self.addN:SetActive(true)
    self.playerHeadContainerN:SetActive(false)
    self.playerNameN:SetLocalText(391071)
  end
  self.playerPosN:SetLocalText(AllianceOfficialPosConf[self.officialPos].name)
  self.offcialIcon:LoadSprite(LWAlMemberOffcialParam[self.officialPos].Icon)
end

local function OnClickHeadBtn(self)
  if self.memberInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.memberInfo.uid)
  end
end

local function OnClickPosBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.posBtnN.transform.position + Vector3.New(30, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString(AllianceOfficialPosConf[self.officialPos].tip)
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

AlliancePositionItem.OnCreate = OnCreate
AlliancePositionItem.OnDestroy = OnDestroy
AlliancePositionItem.ComponentDefine = ComponentDefine
AlliancePositionItem.ComponentDestroy = ComponentDestroy
AlliancePositionItem.DataDefine = DataDefine
AlliancePositionItem.DataDestroy = DataDestroy
AlliancePositionItem.OnAddListener = OnAddListener
AlliancePositionItem.OnRemoveListener = OnRemoveListener
AlliancePositionItem.SetItem = SetItem
AlliancePositionItem.RefreshAll = RefreshAll
AlliancePositionItem.OnClickHeadBtn = OnClickHeadBtn
AlliancePositionItem.OnClickPosBtn = OnClickPosBtn
return AlliancePositionItem
