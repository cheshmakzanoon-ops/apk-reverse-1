local UIActValentineGetGift1ContentComponent = BaseClass("UIActValentineGetGift1ContentComponent", UIBaseContainer)
local HeadItem = require("UI.LWUIActValentineGetGiftUpAtEnter.Component.UIActValentineGetGiftHeadItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local get_gift1_player_content_path = "GetGift1PlayerContent"
local u_i_act_valentine_get_gift_head_item_path = "GetGift1PlayerContent/UIActValentineGetGiftHeadItem"
local get_gift1_spurce_path = "GetGift1Change/GetGift1Spurce"
local get_gift1_spurce_num_path = "GetGift1Change/GetGift1Spurce/GetGift1SpurceNum"
local get_gift1_target_image_path = "GetGift1Change/GetGift1Target/GetGift1TargetImage"
local get_gift1_target_num_path = "GetGift1Change/GetGift1Target/GetGift1TargetNum"
local get_gift1_name_txt_path = "GetGift1NameContent/GetGift1NameTxt"
local get_gift1_num_txt_path = "GetGift1NameContent/GetGift1NameTxt/GetGift1NumTxt"
local Max_Show_Player_Name = 10

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
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.content = self:AddComponent(UIBaseContainer, get_gift1_player_content_path)
  self.headObjItem = self:AddComponent(UIBaseContainer, u_i_act_valentine_get_gift_head_item_path)
  self.headObjItem.gameObject:GameObjectCreatePool()
  self.sendGiftItemIconImg = self:AddComponent(UIImage, get_gift1_spurce_path)
  self.sendGiftItemNumText = self:AddComponent(UIText, get_gift1_spurce_num_path)
  self.convertItemIconImg = self:AddComponent(UIImage, get_gift1_target_image_path)
  self.convertItemNumText = self:AddComponent(UIText, get_gift1_target_num_path)
  self.playerNameDetailText = self:AddComponent(UIText, get_gift1_name_txt_path)
  self.playerNameOverviewText = self:AddComponent(UIText, get_gift1_num_txt_path)
  self.get_gift1_player_content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, get_gift1_player_content_path)
end

local function ComponentDestroy(self)
  self.headObjItem.gameObject:GameObjectRecycleAll()
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

function UIActValentineGetGift1ContentComponent:ReInit(param)
  self.data = param.data
  self.isSpecialGift = param.isSpecialGift
  self:RefreshGiftInfo()
  self:RefreshGiftSenderInfo()
  self:ResetAni()
end

function UIActValentineGetGift1ContentComponent:RefreshGiftInfo()
  local giftItemId = self.data.itemId
  local giftItemNum = self.data.num
  local convertItemId = self.data.convertItemId
  local convertNum = self.data.convertNum
  local giftIconPath = DataCenter.ItemTemplateManager:GetIconPath(giftItemId)
  if giftIconPath then
    self.sendGiftItemIconImg:LoadSprite(giftIconPath)
    self.sendGiftItemIconImg:SetNativeSize()
  end
  self.sendGiftItemNumText:SetText(string.format("\195\151%s", giftItemNum or 0))
  local convertIconPath = DataCenter.ItemTemplateManager:GetIconPath(convertItemId)
  if convertIconPath then
    self.convertItemIconImg:LoadSprite(convertIconPath)
    self.convertItemIconImg:SetNativeSize()
  end
  self.convertItemNumText:SetText(string.format("\195\151%s", convertNum or 0))
end

function UIActValentineGetGift1ContentComponent:RefreshGiftSenderInfo()
  self:RefreshGiftSenderHeadInfo()
  self:RefreshGiftSenderNameTextInfo()
end

function UIActValentineGetGift1ContentComponent:RefreshGiftSenderHeadInfo()
  self.headObjItem.gameObject:GameObjectRecycleAll()
  local playerListData = self.data.playerList
  if not playerListData or #playerListData <= 0 then
    return
  end
  self:SetLayout(#playerListData)
  for _, v in ipairs(playerListData) do
    local gameObject = self.headObjItem.gameObject:GameObjectSpawn(self.content.transform)
    local name = "item_" .. NameCount
    gameObject.name = name
    NameCount = NameCount + 1
    local headItem = self.content:AddComponent(HeadItem, name)
    headItem:ReInit(v)
  end
end

function UIActValentineGetGift1ContentComponent:SetLayout(playerNum)
  if playerNum < 5 then
    self.get_gift1_player_content:ChildControlWidth(false)
    self.get_gift1_player_content:SetSpacing(18)
    self.headObjItem:SetSizeDeltaX(110)
  else
    self.get_gift1_player_content:ChildControlWidth(true)
    self.get_gift1_player_content:SetSpacing(0)
  end
end

function UIActValentineGetGift1ContentComponent:RefreshGiftSenderNameTextInfo()
  local playerListData = self.data.playerList
  if not playerListData or #playerListData <= 0 then
    return
  end
  local detailNum = math.min(Max_Show_Player_Name, #playerListData)
  local detailInfoStr = ""
  for i = 1, detailNum do
    local playerInfo = playerListData[i]
    if playerInfo then
      local singlePlayerInfo = UIUtil.FormatAllianceAndName(playerInfo.abbr, playerInfo.name)
      detailInfoStr = detailInfoStr .. singlePlayerInfo
    end
  end
  if #playerListData > Max_Show_Player_Name then
    detailInfoStr = detailInfoStr .. " ..."
  end
  self.playerNameDetailText:SetText(detailInfoStr)
  local totalPlayerNum = #playerListData or 0
  local giftItemId = self.data.itemId
  local giftName = DataCenter.ItemTemplateManager:GetName(giftItemId) or ""
  self.playerNameOverviewText:SetLocalText("activity_99136_70", totalPlayerNum, giftName)
end

function UIActValentineGetGift1ContentComponent:ResetAni()
  if self.simpleAni:IsPlaying("Hide") then
    self.simpleAni:Rewind("Hide")
  else
    self.simpleAni:Stop()
    self.simpleAni:Play("Hide")
  end
end

function UIActValentineGetGift1ContentComponent:ShowDisplayAni()
  if self.isSpecialGift then
    self.simpleAni:Play("Special")
  else
    self.simpleAni:Play("Normal")
  end
end

function UIActValentineGetGift1ContentComponent:ShowDisappearAni()
  self.simpleAni:Play("FadeOut")
  local dataList = {}
  local param = {}
  param.startPos = self.convertItemIconImg.transform.position
  param[2] = DataCenter.ItemData:GetItemByItemId(self.data.convertItemId)
  table.insert(dataList, param)
  EventManager:GetInstance():Broadcast(EventId.ValentinePlayFlyRewardAni, dataList)
end

UIActValentineGetGift1ContentComponent.OnCreate = OnCreate
UIActValentineGetGift1ContentComponent.OnDestroy = OnDestroy
UIActValentineGetGift1ContentComponent.OnEnable = OnEnable
UIActValentineGetGift1ContentComponent.OnDisable = OnDisable
UIActValentineGetGift1ContentComponent.ComponentDefine = ComponentDefine
UIActValentineGetGift1ContentComponent.ComponentDestroy = ComponentDestroy
UIActValentineGetGift1ContentComponent.DataDefine = DataDefine
UIActValentineGetGift1ContentComponent.DataDestroy = DataDestroy
UIActValentineGetGift1ContentComponent.OnAddListener = OnAddListener
UIActValentineGetGift1ContentComponent.OnRemoveListener = OnRemoveListener
return UIActValentineGetGift1ContentComponent
