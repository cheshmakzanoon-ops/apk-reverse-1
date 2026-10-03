local AllyDrillUpdateBossTipView = BaseClass("AllyDrillUpdateBossTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UpdateBossConfig = {
  [WorldMonsterSpecialType.AllyDrillHugeSandWorm] = {
    prefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillTipsItem.prefab",
    view = "UI.UIActAllyDrillUpdateBoss.AllyDrillTipsItemComponent",
    datas = {
      {
        banner = "Assets/Main/TextureEx/UIActivityBg/AllyBossSandWorm/lrb_shachongjunyan_shuoming_01_banner.png",
        desc = "1"
      },
      {
        banner = "Assets/Main/TextureEx/UIActivityBg/AllyBossSandWorm/lrb_shachongjunyan_shuoming_02_banner.png",
        desc = "2"
      },
      {
        banner = "Assets/Main/TextureEx/UIActivityBg/AllyBossSandWorm/lrb_shachongjunyan_shuoming_03_banner.png",
        desc = "3"
      }
    }
  },
  [WorldMonsterSpecialType.AllyDrillRoadHog] = {
    banner = "Assets/Main/SeasonRes/Shared/Textures/MadCowDrill/wxy_s5_tongmengjunyan_shuoming_banner.png"
  }
}

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
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textTmpConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textMain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpConfirm:SetLocalText("110006")
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.btnBlack = nil
  self.textTitle = nil
  self.rawImgBanner = nil
  self.btnConfirm = nil
  self.textTmpConfirm = nil
  self.textMain = nil
end

local function DataDefine(self)
  self.newBossSpecialType, self.titleKey, self.descKey = self:GetUserData()
  if not self.newBossSpecialType then
    return
  end
  self.config = UpdateBossConfig[self.newBossSpecialType]
  if not self.config then
    return
  end
  self.textTitle:SetLocalText(self.titleKey)
  self.textMain:SetLocalText(self.descKey)
  if self.config.banner then
    self.rawImgBanner:LoadSpriteAsync(self.config.banner)
    self.rawImgBanner:SetActive(true)
  else
    self.rawImgBanner:SetActive(false)
  end
end

local function DataDestroy(self)
  self.newBossSpecialType = nil
  self.config = nil
  self.ItemHandler = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnBlackClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnConfirmClick(self)
  self.ctrl:CloseSelf()
end

AllyDrillUpdateBossTipView.OnCreate = OnCreate
AllyDrillUpdateBossTipView.OnDestroy = OnDestroy
AllyDrillUpdateBossTipView.OnEnable = OnEnable
AllyDrillUpdateBossTipView.OnDisable = OnDisable
AllyDrillUpdateBossTipView.ComponentDefine = ComponentDefine
AllyDrillUpdateBossTipView.ComponentDestroy = ComponentDestroy
AllyDrillUpdateBossTipView.DataDefine = DataDefine
AllyDrillUpdateBossTipView.DataDestroy = DataDestroy
AllyDrillUpdateBossTipView.OnAddListener = OnAddListener
AllyDrillUpdateBossTipView.OnRemoveListener = OnRemoveListener
AllyDrillUpdateBossTipView.OnBtnBlackClick = OnBtnBlackClick
AllyDrillUpdateBossTipView.OnBtnConfirmClick = OnBtnConfirmClick
return AllyDrillUpdateBossTipView
