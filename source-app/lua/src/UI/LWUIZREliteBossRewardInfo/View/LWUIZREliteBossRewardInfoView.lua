local LWUIZREliteBossRewardInfoView = BaseClass("LWUIZREliteBossRewardInfoView", UIBaseView)
local base = UIBaseView
local UIZombieEliteBossRewardItem = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.UIZombieEliteBossRewardItem")
local LWUIZRPlayerDropInfoItem = require("UI.LWUIZREliteBossRewardInfo.Component.LWUIZRPlayerDropInfoItem")
local panel_btn_path = "PanelBtn"
local title_text_path = "Content/TitleText"
local reward_tips_text_path = "Content/RewardTipsText"
local pic_raw_image_path = "Content/PicRawImage"
local close_btn_path = "Content/CloseBtn"
local player_scroll_view_path = "Content/PlayerScrollView"
local reward_item_path = "Content/RewardItem"
local reward_content_path = "Content/RewardContent"
local BG_PIC_PATH = "Assets/Main/TextureEx/UIActivityBg/UILWZombieRush/%s.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("zombierush_eliteBoss_alter_succeed_title")
  self.reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, reward_tips_text_path)
  self.reward_tips_text:SetLocalText("zombierush_eliteBoss_alter_succeed_tips")
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pic_raw_image = self:AddComponent(UIRawImage, pic_raw_image_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.player_scroll_view = self:AddComponent(UIScrollView, player_scroll_view_path)
  self.player_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnPlayerItemMoveIn(itemObj, index)
  end)
  self.player_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnPlayerItemMoveOut(itemObj, index)
  end)
  self.reward_item = self.transform:Find(reward_item_path).gameObject
  self.reward_item:GameObjectCreatePool()
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.reward_tips_text = nil
  self.panel_btn = nil
  self.pic_raw_image = nil
  self.close_btn = nil
  self:ClearPlayerInfoScroll()
  self.player_scroll_view = nil
  self.reward_content:RemoveComponents(UIZombieEliteBossRewardItem)
  self.reward_item:GameObjectRecycleAll()
  self.reward_item = nil
end

local function DataDefine(self)
  self.data = self:GetUserData()
  self.infoList = nil
  self.eliteBoss_reward_show = nil
  self.dropId = nil
end

local function DataDestroy(self)
  self.data = nil
  self.infoList = nil
  self.eliteBoss_reward_show = nil
  self.dropId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  if self.data == nil then
    self.ctrl:CloseSelf()
    return
  end
  local zombieRushId = self.data.zombieRushId
  local template = DataCenter.LWZombieRushTemplateManager:GetTemplate(zombieRushId)
  if template then
    local pic = template:GetCurSeasonEliteBgPic()
    if not string.IsNullOrEmpty(pic) then
      self.pic_raw_image:LoadSprite(string.format(BG_PIC_PATH, pic))
    end
    self.eliteBoss_reward_show = template.eliteBoss_reward_show
    self:RefreshRewardList(self:GetCurSeasonEliteDropId())
  end
  local infoList = self.data.infoList
  self:ShowPlayerInfo(infoList)
end

local function RefreshRewardList(self, dropId)
  if dropId and 0 < dropId then
    local rewardData = GetTableData(TableName.DropInfoDetail, dropId, "dropInfoDetail")
    if string.IsNullOrEmpty(rewardData) then
      return
    end
    self.dropList = string.split(rewardData, "|")
    local goItem, theItem
    if self.dropList and 0 < #self.dropList then
      for i = 1, #self.dropList do
        goItem = self.reward_item:GameObjectSpawn(self.reward_content.transform)
        goItem.name = "item_" .. i
        goItem:SetActive(true)
        theItem = self.reward_content:AddComponent(UIZombieEliteBossRewardItem, goItem.name)
        theItem:ReInit(self.dropList[i])
      end
    end
  end
end

local function ShowPlayerInfo(self, infoList)
  self.infoList = infoList
  if infoList == nil or table.countinfoList == 0 then
    return
  end
  self:ClearPlayerInfoScroll()
  local playerCount = table.count(infoList)
  if 0 < playerCount then
    self.player_scroll_view:SetTotalCount(playerCount)
    self.player_scroll_view:RefillCells()
  end
end

local function OnPlayerItemMoveIn(self, itemObj, index)
  if self.infoList == nil or table.count(self.infoList) == 0 then
    return
  end
  itemObj.name = tostring(index)
  local itemRender = self.player_scroll_view:AddComponent(LWUIZRPlayerDropInfoItem, itemObj)
  itemRender:ReInit(self.infoList[index])
end

local function OnPlayerItemMoveOut(self, itemObj, index)
  self.player_scroll_view:RemoveComponent(itemObj.name, LWUIZRPlayerDropInfoItem)
end

local function ClearPlayerInfoScroll(self)
  self.player_scroll_view:ClearCells()
  self.player_scroll_view:RemoveComponents(LWUIZRPlayerDropInfoItem)
end

local function GetCurSeasonEliteDropId(self)
  if self.dropId == nil then
    local dropId
    if not string.IsNullOrEmpty(self.eliteBoss_reward_show) then
      local seasonRewardsArr = string.split(self.eliteBoss_reward_show, "|")
      if seasonRewardsArr and 0 < #seasonRewardsArr then
        local season = DataCenter.SeasonDataManager:GetSeason()
        season = tostring(season)
        local defaultDropId
        for _, v in ipairs(seasonRewardsArr) do
          local arr = string.split(v, ";")
          if arr and 2 < #arr then
            if season == arr[1] then
              dropId = tonumber(arr[3])
              break
            end
            if tonumber(arr[1]) == 0 then
              defaultDropId = tonumber(arr[3])
            end
          end
        end
        if dropId == nil then
          dropId = defaultDropId
        end
      end
    end
    self.dropId = dropId
  end
  return self.dropId
end

LWUIZREliteBossRewardInfoView.OnCreate = OnCreate
LWUIZREliteBossRewardInfoView.OnDestroy = OnDestroy
LWUIZREliteBossRewardInfoView.ComponentDefine = ComponentDefine
LWUIZREliteBossRewardInfoView.ComponentDestroy = ComponentDestroy
LWUIZREliteBossRewardInfoView.DataDefine = DataDefine
LWUIZREliteBossRewardInfoView.DataDestroy = DataDestroy
LWUIZREliteBossRewardInfoView.OnAddListener = OnAddListener
LWUIZREliteBossRewardInfoView.OnRemoveListener = OnRemoveListener
LWUIZREliteBossRewardInfoView.RefreshView = RefreshView
LWUIZREliteBossRewardInfoView.RefreshRewardList = RefreshRewardList
LWUIZREliteBossRewardInfoView.ShowPlayerInfo = ShowPlayerInfo
LWUIZREliteBossRewardInfoView.OnPlayerItemMoveIn = OnPlayerItemMoveIn
LWUIZREliteBossRewardInfoView.OnPlayerItemMoveOut = OnPlayerItemMoveOut
LWUIZREliteBossRewardInfoView.ClearPlayerInfoScroll = ClearPlayerInfoScroll
LWUIZREliteBossRewardInfoView.GetCurSeasonEliteDropId = GetCurSeasonEliteDropId
return LWUIZREliteBossRewardInfoView
