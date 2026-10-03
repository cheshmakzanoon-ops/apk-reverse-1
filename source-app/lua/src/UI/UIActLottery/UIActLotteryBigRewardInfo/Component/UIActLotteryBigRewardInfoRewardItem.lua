local base = UIBaseContainer
local UIActLotteryBigRewardInfoRewardItem = BaseClass("UIActLotteryBigRewardInfoRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local name_path = "Content/Name"
local rate_path = "Content/Rate"
local u_i_common_res_item_path = "Content/UICommonResItem"
local reward_content_path = "Content/rewardContent"
local bg_path = "Content/bg"
local raw_bg_path = "Content/rawBg"
local name_normal_path = "Content/NameNormal"

function UIActLotteryBigRewardInfoRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotteryBigRewardInfoRewardItem:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryBigRewardInfoRewardItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.rate = self:AddComponent(UITextMeshProUGUIEx, rate_path)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
  self.bg = self:AddComponent(UIImage, bg_path)
  self.raw_bg = self:AddComponent(UIRawImage, raw_bg_path)
  self.name_normal = self:AddComponent(UITextMeshProUGUIEx, name_normal_path)
end

function UIActLotteryBigRewardInfoRewardItem:ComponentDestroy()
  self.name = nil
  self.rate = nil
  self.u_i_common_res_item = nil
  self.reward_content = nil
  self.bg = nil
  self.raw_bg = nil
  self.name_normal = nil
end

function UIActLotteryBigRewardInfoRewardItem:DataDefine()
end

function UIActLotteryBigRewardInfoRewardItem:DataDestroy()
end

function UIActLotteryBigRewardInfoRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryBigRewardInfoRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryBigRewardInfoRewardItem:SetData(activityId, data, scroll_view, index)
  self.activityId = activityId
  self.data = data
  self.scroll_view = scroll_view
  self.index = index
  self:RefreshView()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function UIActLotteryBigRewardInfoRewardItem:RefreshView()
  if self.data.reward and #self.data.reward > 0 then
    for i, v in ipairs(self.data.reward) do
      if self.u_i_common_res_item_list[i] == nil then
        local showIndex = "Item" .. i
        local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.reward_content.transform)
        item.name = showIndex
        local obj = self.reward_content:AddComponent(UICommonResItem, item.name)
        self.u_i_common_res_item_list[i] = obj
      end
      self.u_i_common_res_item_list[i]:SetActive(true)
      self.u_i_common_res_item_list[i]:ReInit(v)
    end
    for i = #self.data.reward + 1, #self.u_i_common_res_item_list do
      self.u_i_common_res_item_list[i]:SetActive(false)
    end
  end
  local rateTxt = ""
  local nameTxt = ""
  if self.data.rank == 0 then
    rateTxt = Localization:GetString("thxgiv_Lottery_DailyOne")
    nameTxt = DataCenter.ActLotteryDataManager:GetLotteryRankName(0, true)
  else
    rateTxt = string.format("%.2f", self.data.rate * 100)
    rateTxt = rateTxt .. "%"
    nameTxt = DataCenter.ActLotteryDataManager:GetLotteryRankName(self.data.rank)
  end
  self.rate:SetText(rateTxt)
  local comonBgImg = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_common_2XP"
  if self.data.rank == 0 then
    self.raw_bg:LoadSprite("Assets/Main/TextureEx/ActLottery/lrb_ganenjiecaiquanjilu_tittle_cai")
    self.raw_bg:SetActive(true)
    self.bg:SetActive(false)
    self.name_normal:SetActive(false)
    self.name:SetActive(true)
    self.name:SetText(nameTxt)
  elseif self.data.rank == 1 then
    self.raw_bg:LoadSprite("Assets/Main/TextureEx/ActLottery/lrb_ganenjiecaiquanjilu_tittle_cheng")
    self.raw_bg:SetActive(true)
    self.bg:SetActive(false)
    self.name_normal:SetActive(false)
    self.name:SetActive(true)
    self.name:SetText(nameTxt)
  elseif self.data.rank == 2 then
    self.bg:LoadSprite(comonBgImg)
    self.bg:SetColorRGBA255(243, 224, 255, 255)
    self.raw_bg:SetActive(false)
    self.bg:SetActive(true)
    self.name_normal:SetActive(true)
    self.name:SetActive(false)
    self.name_normal:SetText(nameTxt)
    self.name_normal:SetColorRGBA255(180, 95, 198, 255)
  else
    self.bg:LoadSprite(comonBgImg)
    self.bg:SetColorRGBA255(229, 244, 255, 255)
    self.raw_bg:SetActive(false)
    self.bg:SetActive(true)
    self.name_normal:SetActive(true)
    self.name:SetActive(false)
    self.name_normal:SetText(nameTxt)
    self.name_normal:SetColorRGBA255(70, 167, 203, 255)
  end
end

function UIActLotteryBigRewardInfoRewardItem:ClearAllItem()
  self.reward_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.u_i_common_res_item_list = {}
end

return UIActLotteryBigRewardInfoRewardItem
