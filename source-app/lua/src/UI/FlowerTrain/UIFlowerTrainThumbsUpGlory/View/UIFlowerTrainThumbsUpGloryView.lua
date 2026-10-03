local base = UIBaseView
local UIFlowerTrainThumbsUpGloryView = BaseClass("UIFlowerTrainThumbsUpGloryView", base)
local Localization = CS.GameEntry.Localization
local closeBtn_path = "Close"
local claimBtn_path = "ClaimBtn"
local cheerGo_path = "Container/Cheer"
local thumbUpGo_path = "Container/ThumbUp"
local cheerContent_path = "Container/Cheer/CheerContent"
local cheerDesc_path = "Container/Cheer/CheerDesc/CheerDesc"
local starContent_path = "Container/ThumbUp/ThumbUpContent"
local thumbUpDesc_path = "Container/ThumbUp/ThumbUpDesc/ThumbUpDesc"
local thumbUpHeartInfo_path = "Container/ThumbUp/ThumbUpHeartInfo"
local effect_path = "Container/titleArea/Effect"
local heartTxt_path = "Container/ThumbUp/ThumbUpHeartInfo/heartText"
local cheerTxt_path = "Container/Cheer/CheerHeartInfo/CheerText"
local headItem_path = "Container/UIPlayerHead"
local container_path = "Container"
local cheerIcon_path = "Container/Cheer/CheerHeartInfo/heart"
local MAX_SHOW_PLAYER_NAME_NUM = 10
local ContainerShowType = {Single = 1, Double = 2}
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
  self.cheerGo = self:AddComponent(UIBaseContainer, cheerGo_path)
  self.thumbUpGo = self:AddComponent(UIBaseContainer, thumbUpGo_path)
  self.cheerContent = self:AddComponent(UIBaseContainer, cheerContent_path)
  self.cheerDesc = self:AddComponent(UIText, cheerDesc_path)
  self.starContent = self:AddComponent(UIBaseContainer, starContent_path)
  self.thumbUpDesc = self:AddComponent(UIText, thumbUpDesc_path)
  self.thumbUpHeartInfo = self:AddComponent(UIBaseContainer, thumbUpHeartInfo_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.heartTxt = self:AddComponent(UIText, heartTxt_path)
  self.cheerTxt = self:AddComponent(UIText, cheerTxt_path)
  self.headItem = self:AddComponent(UIBaseContainer, headItem_path)
  self.container = self:AddComponent(UIBaseContainer, container_path)
  self.cheerIcon = self:AddComponent(UIImage, cheerIcon_path)
  self.starGrid = self:AddComponent(UIGridLayoutGroup, starContent_path)
  self.cheerGrid = self:AddComponent(UIGridLayoutGroup, cheerContent_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.claimBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.headItem.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.starGrid:RemoveComponents(UICommonHead)
  self.cheerGrid:RemoveComponents(UICommonHead)
  self.headItem.gameObject:GameObjectRecycleAll()
  self.starGrid = nil
  self.cheerGrid = nil
  self.closeBtn = nil
  self.claimBtn = nil
  self.cheerGo = nil
  self.thumbUpGo = nil
  self.cheerContent = nil
  self.cheerDesc = nil
  self.starContent = nil
  self.thumbUpDesc = nil
  self.thumbUpHeartInfo = nil
  self.effect = nil
  self.heartTxt = nil
  self.cheerTxt = nil
  self.headItem = nil
  self.container = nil
  self.cheerIcon = nil
end

local function DataDefine(self)
  local info = self:GetUserData()
  self.praiseNum = info.praiseNum
  self.cheerNum = info.cheerNum
  self.playerPraiseNum = info.playerPraiseNum
  self.playerCheerNum = info.playerCheerNum
  self.praisePlayerArr = info.praisePlayerArr
  self.cheerPlayerArr = info.cheerPlayerArr
  self.activityId = info.activityId
end

local function DataDestroy(self)
end

function UIFlowerTrainThumbsUpGloryView:RefreshView()
  self.thumbUpGo:SetActive(false)
  self.cheerGo:SetActive(false)
  self:RefreshCheer()
  self:RefreshThumbUp()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.view == nil then
      return
    end
    self.effect:SetActive(true)
  end, 3)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.container.transform)
end

function UIFlowerTrainThumbsUpGloryView:RefreshCheer()
  if self.cheerNum == nil or self.cheerPlayerArr == nil then
    return
  end
  if self.cheerNum <= 0 or #self.cheerPlayerArr == 0 then
    return
  end
  local cheerNum = self.playerCheerNum
  self.cheerTxt:SetText("x" .. self.cheerNum)
  self.cheerGo:SetActive(true)
  local lineNum = Config.ContainerLinePlayerNum[ContainerShowType.Double]
  local showType = ContainerShowType.Single
  self:RefreshHeadContainer(self.cheerGrid, self.cheerPlayerArr, showType)
  local playerNames = self:GetPlayerNameString(self.cheerPlayerArr)
  self.cheerDesc:SetText(playerNames .. Localization:GetString("2025halloween_prompt_text3", cheerNum, cheerNum))
  self:RefreshCheerIcon()
end

function UIFlowerTrainThumbsUpGloryView:RefreshCheerIcon()
  if self.activityId == nil then
    return
  end
  local activityTmpData = LocalController:instance():getLine(TableName.Activity, tostring(self.activityId))
  if not activityTmpData then
    return
  end
  if not activityTmpData.tableInfo or not activityTmpData.tableInfoType then
    return
  end
  local paraCfg = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(activityTmpData.tableInfoType)
  if not paraCfg then
    return
  end
  local id = paraCfg.cheer_goods
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  if itemTemplate == nil then
    return
  end
  local iconName = string.format(LoadPath.ItemPath, itemTemplate.icon)
  self.cheerIcon:LoadSpriteAuto(iconName)
end

function UIFlowerTrainThumbsUpGloryView:RefreshThumbUp()
  if self.praiseNum == nil or self.praisePlayerArr == nil then
    return
  end
  if self.praiseNum <= 0 or #self.praisePlayerArr == 0 then
    return
  end
  local praiseNum = self.playerPraiseNum
  self.heartTxt:SetText("x" .. self.praiseNum)
  self.thumbUpGo:SetActive(true)
  local lineNum = Config.ContainerLinePlayerNum[ContainerShowType.Double]
  local showType = ContainerShowType.Single
  self:RefreshHeadContainer(self.starGrid, self.praisePlayerArr, showType)
  local playerNames = self:GetPlayerNameString(self.praisePlayerArr)
  self.thumbUpDesc:SetText(playerNames .. Localization:GetString("2025halloween_prompt_text5", praiseNum, praiseNum))
end

function UIFlowerTrainThumbsUpGloryView:RefreshHeadContainer(container, playerList, showType)
  local count = 0
  for k, v in ipairs(playerList) do
    if count < Config.ContainerMaxPlayerNum[showType] then
      local goItem = self.headItem.gameObject:GameObjectSpawn(container.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      local theItem = container:AddComponent(UICommonHead, goItem.name)
      theItem:ParseHeadInfo(v)
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

function UIFlowerTrainThumbsUpGloryView:GetPlayerNameString(playerList)
  local msg = ""
  local count = 1
  if type(playerList) ~= "table" then
    return msg
  end
  local maxShowName = MAX_SHOW_PLAYER_NAME_NUM / 2
  for _, v in ipairs(playerList) do
    local info = v or {}
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

UIFlowerTrainThumbsUpGloryView.OnCreate = OnCreate
UIFlowerTrainThumbsUpGloryView.OnDestroy = OnDestroy
UIFlowerTrainThumbsUpGloryView.OnEnable = OnEnable
UIFlowerTrainThumbsUpGloryView.OnDisable = OnDisable
UIFlowerTrainThumbsUpGloryView.ComponentDefine = ComponentDefine
UIFlowerTrainThumbsUpGloryView.ComponentDestroy = ComponentDestroy
UIFlowerTrainThumbsUpGloryView.DataDefine = DataDefine
UIFlowerTrainThumbsUpGloryView.DataDestroy = DataDestroy
return UIFlowerTrainThumbsUpGloryView
