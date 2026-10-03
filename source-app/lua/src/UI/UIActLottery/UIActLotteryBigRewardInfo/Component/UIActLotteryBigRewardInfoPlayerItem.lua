local base = UIBaseContainer
local UIActLotteryBigRewardInfoPlayerItem = BaseClass("UIActLotteryBigRewardInfoPlayerItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local name_path = "Content/Name"
local time_path = "Content/time"
local u_i_common_res_item_path = "Content/UICommonResItem"
local reward_content_path = "Content/rewardContent"
local no_val_path = "Content/NoVal"
local player_path = "Content/player"
local content_txt_path = "Content/contentTxt"

function UIActLotteryBigRewardInfoPlayerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotteryBigRewardInfoPlayerItem:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryBigRewardInfoPlayerItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.no_val = self:AddComponent(UITextMeshProUGUIEx, no_val_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.player:SetEnableClickShowInfo(true, true)
  self.content_txt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
end

function UIActLotteryBigRewardInfoPlayerItem:ComponentDestroy()
  self.name = nil
  self.time = nil
  self.u_i_common_res_item = nil
  self.reward_content = nil
  self.no_val = nil
  self.player = nil
  self.content_txt = nil
end

function UIActLotteryBigRewardInfoPlayerItem:DataDefine()
end

function UIActLotteryBigRewardInfoPlayerItem:DataDestroy()
end

function UIActLotteryBigRewardInfoPlayerItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryBigRewardInfoPlayerItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryBigRewardInfoPlayerItem:SetData(activityId, data, specialRewardData, scroll_view, index)
  self.activityId = activityId
  self.data = data
  self.specialRewardData = specialRewardData
  self.scroll_view = scroll_view
  self.index = index
  self:RefreshView()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function UIActLotteryBigRewardInfoPlayerItem:RefreshView()
  local data = self.data
  local presidentName
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  if not string.IsNullOrEmpty(data.abbr) then
    presidentName = "[" .. data.abbr .. "]" .. data.name
  else
    presidentName = data.name
  end
  self.content_txt:SetText(presidentName)
  self.player:SetHead(data.uid, data.pic, data.picVer or data.picver, nil, headBgImg)
  local tickerNumber = data.tickerNumber
  self.no_val:SetText(tickerNumber)
  if self.specialRewardData and #self.specialRewardData > 0 then
    for i, v in ipairs(self.specialRewardData) do
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
    for i = #self.specialRewardData + 1, #self.u_i_common_res_item_list do
      self.u_i_common_res_item_list[i]:SetActive(false)
    end
  end
  self.time:SetText(DataCenter.ActLotteryDataManager:GetLotteryOpenTime(self.data.tickerOpenTime * 1000))
end

function UIActLotteryBigRewardInfoPlayerItem:ClearAllItem()
  self.reward_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.u_i_common_res_item_list = {}
end

return UIActLotteryBigRewardInfoPlayerItem
