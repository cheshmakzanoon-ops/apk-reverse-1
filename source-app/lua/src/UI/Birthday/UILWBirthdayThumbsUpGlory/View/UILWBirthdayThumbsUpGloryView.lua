local base = UIBaseView
local UILWBirthdayThumbsUpGloryView = BaseClass("UILWBirthdayThumbsUpGloryView", base)
local PlayerThumbsUpGloryHeartInfoComponent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpGlory.View.PlayerThumbsUpGloryHeartInfoComponent")
local PlayerThumbsUpGloryHeadItemComponent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpGlory.View.PlayerThumbsUpGloryHeadItemComponent")
local closeBtn_path = "Close"
local claimBtn_path = "Container/ClaimBtn"
local sendGiftGo_path = "Container/SendGift"
local lineGo_path = "Container/Line"
local thumbUpGo_path = "Container/ThumbUp"
local payGiftContent_path = "Container/SendGift/PayGiftContent"
local freeGiftContent_path = "Container/SendGift/FreeContent"
local headItem_path = "Container/PlayerThumbsUpGloryHeadItem"
local heartInfo_path = "Container/PlayerThumbsUpGloryHeartInfo"
local giftPlayerDesc_path = "Container/SendGift/GiftDesc/GiftDesc"
local giftInfoList_path = "Container/SendGift/GiftDesc/GiftInfoList"
local starContent_path = "Container/ThumbUp/StarContent"
local thumbUpDesc_path = "Container/ThumbUp/ThumbUpDesc/ThumbUpDesc"
local thumbUpHeartInfo_path = "Container/ThumbUp/ThumbUpDesc/ThumbUpHeartInfo"
local effect_path = "Container/titleArea/Effect"
local title_path = "Container/titleArea/title"
local Localization = CS.GameEntry.Localization
local ContainerShowType = {Single = 1, Double = 2}
local MAX_SHOW_PLAYER_NAME_NUM = 10
local Config = {
  ContainerHeight = {
    [ContainerShowType.Single] = 160,
    [ContainerShowType.Double] = 320
  },
  ContainerMaxPlayerNum = {
    [ContainerShowType.Single] = 9,
    [ContainerShowType.Double] = 18
  },
  ContainerLinePlayerNum = {
    [ContainerShowType.Single] = 4,
    [ContainerShowType.Double] = 8
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.claimBtn = self:AddComponent(UIButton, claimBtn_path)
  self.sendGiftGo = self:AddComponent(UIBaseContainer, sendGiftGo_path)
  self.lineGo = self:AddComponent(UIBaseContainer, lineGo_path)
  self.thumbUpGo = self:AddComponent(UIBaseContainer, thumbUpGo_path)
  self.payGiftContent = self:AddComponent(UIBaseContainer, payGiftContent_path)
  self.freeGiftContent = self:AddComponent(UIBaseContainer, freeGiftContent_path)
  self.headItem = self:AddComponent(UIBaseContainer, headItem_path)
  self.heartInfo = self:AddComponent(UIBaseContainer, heartInfo_path)
  self.giftPlayerDesc = self:AddComponent(UIText, giftPlayerDesc_path)
  self.giftInfoList = self:AddComponent(UIBaseContainer, giftInfoList_path)
  self.starContent = self:AddComponent(UIBaseContainer, starContent_path)
  self.thumbUpDesc = self:AddComponent(UIText, thumbUpDesc_path)
  self.thumbUpHeartInfo = self:AddComponent(UIBaseContainer, thumbUpHeartInfo_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.titleText = self:AddComponent(UIText, title_path)
  self.payGiftGrid = self:AddComponent(UIGridLayoutGroup, payGiftContent_path)
  self.freeGiftGrid = self:AddComponent(UIGridLayoutGroup, freeGiftContent_path)
  self.starGrid = self:AddComponent(UIGridLayoutGroup, starContent_path)
  self.giftInfoGrid = self:AddComponent(UIGridLayoutGroup, giftInfoList_path)
  self.thumbUpHeartInfoComponent = self:AddComponent(PlayerThumbsUpGloryHeartInfoComponent, thumbUpHeartInfo_path)
  self.closeBtn:SetOnClick(function()
    self:OnCloseView()
  end)
  self.claimBtn:SetOnClick(function()
    self:OnCloseView()
  end)
  self.headItemGo = self.headItem.gameObject
  self.headItemGo:GameObjectCreatePool()
  self.heartInfoGo = self.heartInfo.gameObject
  self.heartInfoGo:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.payGiftGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.freeGiftGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.starGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.giftInfoGrid:RemoveComponents(PlayerThumbsUpGloryHeartInfoComponent)
  self.headItemGo:GameObjectRecycleAll()
  self.heartInfoGo:GameObjectRecycleAll()
  self.headItemGo = nil
  self.heartInfoGo = nil
  self.closeBtn = nil
  self.claimBtn = nil
  self.sendGiftGo = nil
  self.lineGo = nil
  self.thumbUpGo = nil
  self.payGiftContent = nil
  self.freeGiftContent = nil
  self.headItem = nil
  self.heartInfo = nil
  self.giftPlayerDesc = nil
  self.giftInfoList = nil
  self.starContent = nil
  self.thumbUpDesc = nil
  self.thumbUpHeartInfo = nil
  self.effect = nil
  self.titleText = nil
end

local function DataDefine(self)
  self.playerMap = {}
end

local function DataDestroy(self)
  self.playerMap = {}
end

function UILWBirthdayThumbsUpGloryView:RefreshView()
  self.isShowThumbUp = false
  local info = self:GetUserData()
  self.data = info
  info = info or DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  if info then
    self:InitData(info)
    self.titleText:SetLocalText("birthday_tips_24")
    self:RefreshThumbUp(self:BuildThumbsUpInfo(info))
    self.sendGiftGo:SetActive(false)
    self.lineGo:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
    TimerManager:GetInstance():DelayFrameInvoke(function()
      self.effect:SetActive(true)
    end, 3)
  else
    self.ctrl:CloseSelf()
  end
end

function UILWBirthdayThumbsUpGloryView:BuildThumbsUpInfo(info)
  local lineNum = Config.ContainerLinePlayerNum[ContainerShowType.Double]
  local data = {}
  data = {
    isShow = self.isShowThumbUp,
    playerList = info.birthdayThumbsUpPlayerList or {},
    showType = self:IsOnlyThumbUp() and lineNum < #(info.birthdayThumbsUpPlayerList or {}) and ContainerShowType.Double or ContainerShowType.Single,
    diff = info.birthdayThumbsUpCountDiff or 0,
    lastCount = info.birthdayThumbsUpCountOld or 0,
    infoType = PlayerInfoHeartInfoType.BirthdayThumbsUp,
    desc = "birthday_tips_36"
  }
  return data
end

function UILWBirthdayThumbsUpGloryView:RefreshThumbUp(info)
  if not info.isShow then
    self.thumbUpGo:SetActive(false)
    return
  end
  self.thumbUpGo:SetActive(true)
  self:RefreshHeadContainer(self.starGrid, info.playerList, info.showType)
  local playerNames = self:GetPlayerNameString(info.playerList)
  local num = info.diff
  self.thumbUpDesc:SetText(playerNames .. Localization:GetString(info.desc, num, num))
  self.thumbUpHeartInfoComponent:RefreshView(info.lastCount, num, nil, info.infoType)
end

function UILWBirthdayThumbsUpGloryView:RefreshHeadContainer(container, playerList, showType)
  local count = 0
  for k, v in ipairs(playerList) do
    if count < Config.ContainerMaxPlayerNum[showType] then
      local goItem = self.headItemGo:GameObjectSpawn(container.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      local theItem = container:AddComponent(PlayerThumbsUpGloryHeadItemComponent, goItem.name)
      local info = self.playerMap[v.uid] or v
      theItem:RefreshView(v, info)
    end
    count = count + 1
  end
  if count > Config.ContainerLinePlayerNum[showType] then
    container:SetCellSize(144, 144)
    container:SetCellSpacing(-80, 0)
  else
    container:SetCellSize(144, 144)
    container:SetCellSpacing(0, 0)
  end
  container:SetSizeDeltaY(Config.ContainerHeight[showType])
end

function UILWBirthdayThumbsUpGloryView:InitData(info)
  self.isShowThumbUp = true
end

function UILWBirthdayThumbsUpGloryView:IsOnlyThumbUp()
  return not self.isShowFreeGift and not self.isShowPayGift and self.isShowThumbUp
end

function UILWBirthdayThumbsUpGloryView:GetPlayerNameString(playerList)
  local msg = ""
  local count = 1
  if type(playerList) ~= "table" then
    return msg
  end
  local maxShowName = MAX_SHOW_PLAYER_NAME_NUM
  if self.isShowThumbUp and (self.isShowPayGift or self.isShowFreeGift) then
    maxShowName = MAX_SHOW_PLAYER_NAME_NUM / 2
  end
  for _, v in ipairs(playerList) do
    local info = self.playerMap[v.uid] or v or {}
    if count < maxShowName then
      if string.IsNullOrEmpty(msg) then
        msg = UIUtil.FormatAllianceAndName(info.abbr, info.name)
      else
        msg = msg .. ", " .. UIUtil.FormatAllianceAndName(info.abbr, info.name)
      end
    elseif count == maxShowName then
      msg = msg .. " ..."
      break
    end
    count = count + 1
  end
  if not string.IsNullOrEmpty(msg) then
    msg = msg .. "\n"
  end
  return msg
end

function UILWBirthdayThumbsUpGloryView:OnCloseView()
  local data = self.data
  local isThumbsUp = data.thumbsUpCountDiff and data.ThumbsUpPlayerList and data.thumbsUpCountDiff > 0 and table.count(data.ThumbsUpPlayerList) ~= 0
  local hasFreeGift = data.freeFollowHint ~= nil and 0 < data.freeFollowHint.countDiff and table.count(data.freeFollowHint.playerList) ~= 0
  local hasPayGift = data.payFollowHint ~= nil and 0 < data.payFollowHint.countDiff and table.count(data.payFollowHint.playerList) ~= 0
  if isThumbsUp or hasFreeGift or hasPayGift then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpGlory, {anim = true}, data)
  end
  self.ctrl:CloseSelf()
end

UILWBirthdayThumbsUpGloryView.OnCreate = OnCreate
UILWBirthdayThumbsUpGloryView.OnDestroy = OnDestroy
UILWBirthdayThumbsUpGloryView.OnEnable = OnEnable
UILWBirthdayThumbsUpGloryView.OnDisable = OnDisable
UILWBirthdayThumbsUpGloryView.ComponentDefine = ComponentDefine
UILWBirthdayThumbsUpGloryView.ComponentDestroy = ComponentDestroy
UILWBirthdayThumbsUpGloryView.DataDefine = DataDefine
UILWBirthdayThumbsUpGloryView.DataDestroy = DataDestroy
return UILWBirthdayThumbsUpGloryView
