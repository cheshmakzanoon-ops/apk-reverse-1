local UIKillZombieAlRewardPreviewItem = BaseClass("UIKillZombieAlRewardPreviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BarRootPath = "Assets/Main/Sprites/UIKillZombieAlReward/"
local JiaoRootPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/"
local BoxRootPath = "Assets/Main/TextureEx/UIActivityKillZombie/"
local KillZombieAlRewardLevelSetting = {
  [1] = {
    titleId = "challenge_zombie_reward_box_1",
    barImgPath = "zxl_jiangjun_pinzhi_bai",
    jiaoImgPath = "zxl_liwu_pinzhi_hui_jiao",
    boxImgPath = "wxy_jiangjunshilian_box01"
  },
  [2] = {
    titleId = "challenge_zombie_reward_box_2",
    barImgPath = "zxl_jiangjun_pinzhi_lv",
    jiaoImgPath = "zxl_liwu_pinzhi_lv_jiao",
    boxImgPath = "wxy_jiangjunshilian_lvbox01"
  },
  [3] = {
    titleId = "challenge_zombie_reward_box_3",
    barImgPath = "zxl_jiangjun_pinzhi_lan",
    jiaoImgPath = "zxl_liwu_pinzhi_lan_jiao",
    boxImgPath = "wxy_jiangjunshilian_lanbox01"
  },
  [4] = {
    titleId = "challenge_zombie_reward_box_4",
    barImgPath = "zxl_jiangjun_pinzhi_zi",
    jiaoImgPath = "zxl_liwu_pinzhi_zi_jiao",
    boxImgPath = "wxy_jiangjunshilian_zibox01"
  },
  [5] = {
    titleId = "challenge_zombie_reward_box_5",
    barImgPath = "zxl_jiangjun_pinzhi_cheng",
    jiaoImgPath = "zxl_liwu_pinzhi_cheng_jiao",
    boxImgPath = "wxy_jiangjunshilian_chengbox01"
  },
  [6] = {
    titleId = "challenge_zombie_reward_box_6",
    barImgPath = "zxl_jiangjun_pinzhi_hong",
    jiaoImgPath = "zxl_liwu_pinzhi_hong_jiao",
    boxImgPath = "wxy_jiangjunshilian_hongbox01"
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
  self.scrollView = self:AddComponent(UIScrollView, "RewardScorll")
  self.imgTitleImg1 = self:AddComponent(UIImage, "TitleBg/TitleImg1")
  self.imgTitleImg2 = self:AddComponent(UIImage, "TitleBg/TitleImg2")
  self.imgBox = self:AddComponent(UIRawImage, "TitleBg/BoxImg")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleBg/TitleText")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "TitleBg/TipText")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.scrollView = nil
  self.imgTitleImg1 = nil
  self.imgTitleImg2 = nil
  self.imgBox = nil
  self.textTitle = nil
  self.textTip = nil
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

local function Refresh(self, data, fullScore)
  self.level = tonumber(data[1])
  self.score = tonumber(data[2])
  self.rewardId = tonumber(data[3])
  local setting = KillZombieAlRewardLevelSetting[self.level]
  self.textTitle:SetLocalText(setting.titleId)
  self.textTip:SetLocalText("challenge_zombie_reward_drop", string.formatDecimal(self.score / fullScore * 100, 1) .. "%")
  self.imgTitleImg1:LoadSprite(BarRootPath .. setting.barImgPath)
  self.imgTitleImg2:LoadSprite(JiaoRootPath .. setting.jiaoImgPath)
  self.imgBox:LoadSprite(BoxRootPath .. setting.boxImgPath)
  local rewardData = DataCenter.RewardTemplateManager:GetList(self.rewardId)
  if rewardData and 0 < #rewardData then
    self.scrollView:SetActive(true)
    self.showDatalist = rewardData
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UICommonResItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:ReInit(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

UIKillZombieAlRewardPreviewItem.OnCreate = OnCreate
UIKillZombieAlRewardPreviewItem.OnDestroy = OnDestroy
UIKillZombieAlRewardPreviewItem.OnEnable = OnEnable
UIKillZombieAlRewardPreviewItem.OnDisable = OnDisable
UIKillZombieAlRewardPreviewItem.ComponentDefine = ComponentDefine
UIKillZombieAlRewardPreviewItem.ComponentDestroy = ComponentDestroy
UIKillZombieAlRewardPreviewItem.DataDefine = DataDefine
UIKillZombieAlRewardPreviewItem.DataDestroy = DataDestroy
UIKillZombieAlRewardPreviewItem.OnAddListener = OnAddListener
UIKillZombieAlRewardPreviewItem.OnRemoveListener = OnRemoveListener
UIKillZombieAlRewardPreviewItem.Refresh = Refresh
UIKillZombieAlRewardPreviewItem.OnItemMoveIn = OnItemMoveIn
UIKillZombieAlRewardPreviewItem.OnItemMoveOut = OnItemMoveOut
UIKillZombieAlRewardPreviewItem.ClearScroll = ClearScroll
return UIKillZombieAlRewardPreviewItem
