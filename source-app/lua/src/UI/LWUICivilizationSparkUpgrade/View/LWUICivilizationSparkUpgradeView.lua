local LWUICivilizationSparkUpgradeView = BaseClass("LWUICivilizationSparkUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUICivilizationSparkUpgradePartsGroup = require("UI.LWUICivilizationSparkUpgrade.Component.LWUICivilizationSparkUpgradePartsGroup")
local LWUICivilizationSparkUpgradeBuffItem = require("UI.LWUICivilizationSparkUpgrade.Component.LWUICivilizationSparkUpgradeBuffItem")

function LWUICivilizationSparkUpgradeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkUpgradeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkUpgradeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTopTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnTip = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compPartsGroup = self.viewSkin:AddComponent(self, LWUICivilizationSparkUpgradePartsGroup, 7)
  self.compCompletedGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textBottomTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnUpgrade = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.rawImgDecoRawImage = self.viewSkin:AddComponent(self, UIRawImage, 12)
  self.compBottomGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textTopTitle:SetLocalText("civilization_spark_subtitle_limit_10")
  self.itemPool = self.transform:Find("Content/MainRoot/BuffList/Content/BuffItem").gameObject
  self.itemPool:GameObjectCreatePool()
end

function LWUICivilizationSparkUpgradeView:ComponentDestroy()
  self:ClearBuffList()
  self.itemPool = nil
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTopTitle = nil
  self.btnTip = nil
  self.compContent = nil
  self.compPartsGroup = nil
  self.compCompletedGroup = nil
  self.textBottomTip = nil
  self.btnUpgrade = nil
  self.btnGoto = nil
  self.rawImgDecoRawImage = nil
  self.compBottomGroup = nil
end

function LWUICivilizationSparkUpgradeView:DataDefine()
  local param = self:GetUserData()
  if param then
    self.needShowArrow = param.needShowArrow
  end
  self:Refresh()
end

function LWUICivilizationSparkUpgradeView:DataDestroy()
  self.level = nil
  self.template = nil
  self.needShowArrow = nil
  if self.arrowDelay then
    self.arrowDelay:Stop()
    self.arrowDelay = nil
    DataCenter.ArrowManager:RemoveFingerArrow()
  end
end

function LWUICivilizationSparkUpgradeView:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkUpgradeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkUpgradeView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function LWUICivilizationSparkUpgradeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUICivilizationSparkUpgradeView:OnBtnTipClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICivilizationSparkInfo, {anim = true})
end

function LWUICivilizationSparkUpgradeView:OnBtnUpgradeClick()
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.CivilizationSparkUpgrade, self.level + 1)
end

function LWUICivilizationSparkUpgradeView:OnBtnGotoClick()
  self.ctrl:CloseSelf()
  GoToUtil.GoToCurObstacle()
end

function LWUICivilizationSparkUpgradeView:ClearBuffList()
  self.compContent:RemoveAllComponentes()
  self.itemPool:GameObjectRecycleAll()
end

function LWUICivilizationSparkUpgradeView:Refresh()
  self.level = DataCenter.LWCivilizationSparkManager:GetLevel()
  self.template = DataCenter.LWCivilizationSparkManager:GetTemplate(self.level)
  self.rawImgDecoRawImage:LoadSpriteAuto(self.template.uiTitleImg, function()
    self.rawImgDecoRawImage:SetNativeSize()
  end)
  for i = 1, self.level do
    local template = DataCenter.LWCivilizationSparkManager:GetTemplate(i)
    local buffDesc = template.buffDesc
    local item = self.itemPool:GameObjectSpawn()
    item.name = "item_" .. i
    item:SetActive(true)
    item.transform:SetParent(self.compContent.transform)
    item.transform:Set_localScale(1, 1, 1)
    local comp = self.compContent:AddComponent(LWUICivilizationSparkUpgradeBuffItem, item)
    comp:Refresh(buffDesc, i)
  end
  local nextTemplate = DataCenter.LWCivilizationSparkManager:GetTemplate(self.level + 1)
  if nextTemplate then
    self.compCompletedGroup:SetActive(false)
    self.compPartsGroup:SetActive(true)
    self.compPartsGroup:Refresh(nextTemplate)
  else
    self.compCompletedGroup:SetActive(true)
    self.compPartsGroup:SetActive(false)
  end
  local upgradeNeed = self.template.upgradeNeed
  if upgradeNeed and upgradeNeed[2] then
    self.compBottomGroup:SetActive(true)
    local needItemId = upgradeNeed[1]
    local needItemCount = upgradeNeed[2]
    local curItemCount = DataCenter.ItemData:GetItemCount(needItemId)
    local costStr = ""
    local arrowBtn
    if needItemCount <= curItemCount then
      self.btnUpgrade:SetActive(true)
      self.btnGoto:SetActive(false)
      arrowBtn = self.btnUpgrade
      costStr = string.format("<color=#FFFFFF>%s</color>/<color=#FFFFFF>%s</color>", curItemCount, needItemCount)
    else
      self.btnUpgrade:SetActive(false)
      self.btnGoto:SetActive(true)
      arrowBtn = self.btnGoto
      costStr = string.format("<color=#F97077>%s</color>/<color=#FFFFFF>%s</color>", curItemCount, needItemCount)
    end
    if self.needShowArrow and arrowBtn then
      self.arrowDelay = TimerManager:GetInstance():DelayInvoke(function()
        local param = {}
        param.positionType = PositionType.Screen
        param.position = arrowBtn:GetPosition() + Vector3.New(50, -50, 0)
        param.isAutoClose = 3
        DataCenter.ArrowManager:ShowFingerArrow(param)
      end, 0.5)
    end
    self.textBottomTip:SetLocalText("civilization_spark_item_need_desc", costStr)
  else
    self.compBottomGroup:SetActive(false)
  end
end

return LWUICivilizationSparkUpgradeView
