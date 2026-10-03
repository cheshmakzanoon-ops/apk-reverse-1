local UIUtil = {}
local NORMAL = NewMarchType.NORMAL
local DIRECT_MOVE_MARCH = NewMarchType.DIRECT_MOVE_MARCH
local BOSS = NewMarchType.BOSS
local RUNNING_BOSS = NewMarchType.RUNNING_BOSS
local MONSTER = NewMarchType.MONSTER
local ACT_BOSS = NewMarchType.ACT_BOSS
local ASSEMBLY_MARCH = NewMarchType.ASSEMBLY_MARCH
local SCOUT = NewMarchType.SCOUT
local RESOURCE_HELP = NewMarchType.RESOURCE_HELP
local GOLLOES_EXPLORE = NewMarchType.GOLLOES_EXPLORE
local GOLLOES_TRADE = NewMarchType.GOLLOES_TRADE
local PUZZLE_BOSS = NewMarchType.PUZZLE_BOSS
local CHALLENGE_BOSS = NewMarchType.CHALLENGE_BOSS
local BEHEMOTH_BOSS = NewMarchType.BEHEMOTH_BOSS
local Localization = CS.GameEntry.Localization
local Data = CS.GameEntry.Data
local ResourceManager = CS.GameEntry.Resource
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local UICommonTipsAutoView = require("UI.UICommonTips.View.UICommonTipsAutoView")
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local Physics = CS.UnityEngine.Physics
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local string_split = string.split
local WorldPointUIType = _ENV.WorldPointUIType
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local CSWorldMeteoritePoint = CS.WorldMeteoritePoint
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)

local function GetCampColorType(uid, allianceId, serverId, currentServerId)
  if uid == LuaEntry.Player.uid then
    return CityLabelColorType.Green
  end
  if LuaEntry.Player:IsInAlliance() and LuaEntry.Player:GetAllianceUid() == allianceId then
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData and allianceBaseData.leaderUid == uid then
      return CityLabelColorType.Purple
    else
      return CityLabelColorType.Blue
    end
  end
  local playerType = CSharpCallLuaInterface.IsMyEnemy(serverId, allianceId, currentServerId)
  if playerType == CS.PlayerType.PlayerAllianceEnemy then
    return CityLabelColorType.AllianceEnemy
  elseif playerType == CS.PlayerType.PlayerZoneEnemy then
    return CityLabelColorType.ZoneEnemy
  elseif playerType == CS.PlayerType.PlayerSeasonEnemy then
    return CityLabelColorType.SeasonEnemy
  elseif playerType == CS.PlayerType.PlayerSeasonCamp then
    return CityLabelColorType.SeasonCamp
  elseif playerType == CS.PlayerType.PlayerSeasonAssist then
    return CityLabelColorType.SeasonAssist
  else
    return CityLabelColorType.White
  end
  return CityLabelColorType.White
end

function UIUtil.GetPlayerCampColor(uid, allianceId, serverId, currentServerId)
  local colorType = GetCampColorType(uid, allianceId, serverId, currentServerId)
  return DataCenter.DecorationTemplateManager:GetLabelSkinTextColor(nil, colorType)
end

local function ShowMessage(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, align, openEffect, btn_1_color, btn_2_color, showCloseBtn, costItemData, customTitleStr)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageTip, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = openEffect
  })
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageTip)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, align, showCloseBtn, costItemData, customTitleStr)
    if btn_1_color ~= nil and btn_2_color ~= nil then
      window.View:SetBtnSprite(btn_1_color, btn_2_color)
    end
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

local function TryConfirmUseLimitedDecorationItem(goodsId, confirmAction, cancelAction)
  local itemId = tonumber(goodsId)
  if itemId == nil or confirmAction == nil then
    return false
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template == nil or template.type ~= GOODS_TYPE.GOODS_TYPE_113 then
    return false
  end
  local duration = tonumber(template.para2) or 0
  if duration <= 0 then
    return false
  end
  local skinId = tonumber(template.para1) or 0
  if skinId <= 0 then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local isEmoji = decoTemp ~= nil and decoTemp.type == DecorationType.DecorationType_Emoji
  if isEmoji then
    local eTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(skinId)
    if DataCenter.DecorationDataManager:IsUnlock(skinId) and eTime ~= nil and eTime <= 0 then
      return false
    end
  else
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
    if DataCenter.DecorationDataManager:IsUnlock(skinId) and decoData ~= nil and 0 >= (decoData.expireTime or 0) then
      return false
    end
  end
  local expireTime = 0
  if isEmoji then
    expireTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByDecoId(skinId) or 0
  else
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
    expireTime = decoData ~= nil and (decoData.expireTime or 0) or 0
  end
  local isActiveLimited = 0 < expireTime and now < expireTime
  local itemName = DataCenter.ItemTemplateManager:GetName(tostring(itemId))
  local msgKey = isActiveLimited and "confirm_use_item_02" or "confirm_use_item_01"
  local msg
  if isActiveLimited then
    local decoName = ""
    if decoTemp ~= nil and not string.IsNullOrEmpty(decoTemp.name) then
      decoName = Localization:GetString(decoTemp.name)
    end
    msg = Localization:GetString(msgKey, itemName, decoName)
  else
    msg = Localization:GetString(msgKey, itemName)
  end
  UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    confirmAction()
  end, function()
    if cancelAction then
      cancelAction()
    end
  end)
  return true
end

local function ShowMessageWithCountdown(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, expTimestamp, countdownCallback)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageTip, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  })
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageTip)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText)
    window.View:SetExpTimestamp(expTimestamp, countdownCallback)
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

local function IsPad()
  local ret = false
  pcall(function()
    ret = not CS.UIUtils:IsPhone()
  end)
  return ret
end

local function LoadPrefab(prefabPath, scriptPath, parent, name, callback)
  local handle = CS.GameEntry.Resource:InstantiateAsync(prefabPath)
  handle:completed("+", function(req)
    if req.isError then
      return
    end
    local theItem = handle.gameObject
    local transform = theItem.transform
    transform:SetParent(parent.transform)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    theItem.name = name or parent.name
    theItem = parent:AddComponent(scriptPath, theItem.name)
    if callback then
      callback(theItem)
    end
  end)
  return handle
end

local function ShowIntro(title, subtitle, intro, closeAction)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonIntroTip)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonIntroTip)
  if window and window.View then
    window.View:SetData(title, subtitle, intro, closeAction)
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

local function ShowUseItemTip(title, param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonUseItemTip, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  })
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonUseItemTip)
  if window and window.View then
    window.View:SetData(title, param)
    return window.View
  end
end

local function ShowComplexTip(tipInfo)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIComplexTip)
  if window then
    window.View:PushTipInfo(tipInfo)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIComplexTip, {anim = true, playEffect = false}, tipInfo)
  end
end

local function ShowSecondMessage(titleText, tipText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle, costParam, delayConfirm, alignment, cdConfirm)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISellConfirm, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(titleText, tipText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle, costParam, delayConfirm, alignment, cdConfirm)
    if window.View:GetActive() then
      window.View:RefreshView()
    end
  end
end

local function ShowSecondMessageByParam(param)
  local titleText = param.titleText or ""
  local tipText = param.tipText
  local btnNum = param.btnNum or 1
  local text1 = param.text1 or GameDialogDefine.CONFIRM
  local text2 = param.text2 or GameDialogDefine.CANCEL
  local sureAction = param.sureAction
  local toggleAction = param.toggleAction
  local cancelAction = param.cancelAction
  local closeAction = param.closeAction
  local isChangeImg = param.isChangeImg
  local toggleText = param.toggleText
  local btnNoUseDialog = param.btnNoUseDialog
  local leftBtnPicName = param.leftBtnPicName
  local rightBtnPicName = param.rightBtnPicName
  local showToggle = param.showToggle
  local costParam = param.costParam
  local delayConfirm = param.delayConfirm
  local alignment = param.alignment
  local cdConfirm = param.cdConfirm
  UIUtil.ShowSecondMessage(titleText, tipText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle, costParam, delayConfirm, alignment, cdConfirm)
end

local function ShowTips(msg, showTime, playerHead, heroHead, isUseOldUI, showHeight, isAlHelpMsg, alHelpInfo)
  if isUseOldUI == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBarOld, {anim = true, playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBarOld)
    if window ~= nil and window.View ~= nil then
      window.View:AddNewMsg_Msg(msg, showTime, playerHead, heroHead, showHeight, isAlHelpMsg, alHelpInfo)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBar, {anim = true, playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBar)
    if window ~= nil and window.View ~= nil then
      window.View:AddNewMsg_Msg(msg, showTime, playerHead, heroHead, showHeight, isAlHelpMsg, alHelpInfo)
    end
  end
end

function UIUtil.ShowTipsWithImage(msg1, imgPath, msg2, showTime, showHeight)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageWithImageBar, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageWithImageBar)
  if window ~= nil and window.View ~= nil then
    window.View:AddNewMsg_Msg(msg1, imgPath, msg2, showTime, showHeight)
  end
end

local function ShowSpecialTips(msg, showTime)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageSpecialBar, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageSpecialBar)
  if window ~= nil and window.View ~= nil then
    window.View:AddNewMsg_Msg(msg, showTime)
  end
end

local function ShowSingleTip(msg)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSingleMsgBar, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonSingleMsgBar)
  if window ~= nil and window.View ~= nil then
    window.View:ShowStrTip(msg)
  end
end

local function ShowTipsId(msgId, showTime, playerHead, heroHead, isUseOldUI, offsetY, isAlHelpMsg, alHelpInfo)
  if isUseOldUI == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBarOld, {anim = true, playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBarOld)
    if window ~= nil and window.View ~= nil then
      window.View:AddNewMsg_MsgId(msgId, showTime, playerHead, heroHead, isAlHelpMsg, alHelpInfo)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBar, {anim = true, playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBar)
    if window ~= nil and window.View ~= nil then
      window.View:AddNewMsg_MsgId(msgId, showTime, playerHead, heroHead, offsetY, isAlHelpMsg, alHelpInfo)
    end
  end
end

local function ShowTipsLocalization(langKey, ...)
  local msg = Localization:GetString(langKey, ...)
  UIUtil.ShowTips(msg)
end

local function ShowBuyMessage(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, btnPriceTxt, item, noPlayCloseEffect, enableBtn1, enableBtn2)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonBuyItem)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonBuyItem)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, btnPriceTxt, item, noPlayCloseEffect, enableBtn1, enableBtn2)
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

local function ShowUseResItemMessage(tipText, text2, action2, closeAction, titleText, item, noPlayCloseEffect, enableBtn1, enableBtn2)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonUseResItemTips)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonUseResItemTips)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(tipText, text2, action2, closeAction, titleText, item, noPlayCloseEffect, enableBtn1, enableBtn2)
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

local function SetLeftTimeText(textComp, startTime, endTime, key_)
  local deltaTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if startTime and startTime > curTime then
    deltaTime = startTime - curTime
  elseif endTime and endTime > curTime then
    deltaTime = endTime - curTime
  end
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    if key_ then
      showTime = Localization:GetString(key_, showTime)
    end
    textComp:SetText(showTime)
  else
    local showTime = "00:00:00"
    if key_ then
      showTime = Localization:GetString(key_, showTime)
    end
    textComp:SetText(showTime)
    return true
  end
  return false
end

local function CalcConstructMilePointer(leftPadding, topPadding, mainWorldPos, targetWorldPos, ScreenWH)
  local show, dist, pos, eulerAngleZ = false, 0, VecZero, 0
  local world = CS.SceneManager.World
  if world == nil or targetWorldPos == nil then
    return show, dist
  end
  local mainTilePos = Vector2.New(math.floor(mainWorldPos.x / TileSize), math.floor(mainWorldPos.z / TileSize))
  local mainScreenPos = world:WorldToScreenPoint(mainWorldPos)
  local targetTilePos = Vector2.New(math.floor(targetWorldPos.x / TileSize), math.floor(targetWorldPos.z / TileSize))
  if mainTilePos.x == 0 and mainTilePos.y == 0 then
    return false
  end
  local screenX = ScreenWH ~= nil and ScreenWH.width or Screen.width
  local screenY = ScreenWH ~= nil and ScreenWH.height or Screen.height
  if 0 < mainScreenPos.x and screenX > mainScreenPos.x and 0 < mainScreenPos.y and screenY > mainScreenPos.y then
    return show, dist, pos.x, pos.y, eulerAngleZ, mainScreenPos
  end
  show = true
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  leftPadding = leftPadding * scaleFactor
  topPadding = topPadding * scaleFactor
  if leftPadding > mainScreenPos.x then
    mainScreenPos.x = leftPadding
  elseif mainScreenPos.x > screenX - leftPadding then
    mainScreenPos.x = screenX - leftPadding
  end
  if topPadding > mainScreenPos.y then
    mainScreenPos.y = topPadding
  elseif mainScreenPos.y > screenY - topPadding then
    mainScreenPos.y = screenY - topPadding
  end
  eulerAngleZ = math.deg(math.atan(mainWorldPos.z - targetWorldPos.z, mainWorldPos.x - targetWorldPos.x)) - 90
  dist = math.floor(Vector2.Distance(mainTilePos, targetTilePos))
  pos = CS.GameEntry.UICamera:ScreenToWorldPoint(mainScreenPos)
  return show, dist, pos.x, pos.y, eulerAngleZ, mainScreenPos
end

local function CalcMilePointer(leftPadding, topPadding)
  local world = CS.SceneManager.World
  if world == nil then
    return false, 0
  end
  local mainIndex = LuaEntry.Player:GetMainWorldPos()
  if mainIndex <= 0 then
    return false, 0
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if BattleFieldUtil.InBattleField() then
    loginServerId = LuaEntry.Player:GetCurServerId()
  end
  local mainWorldPos = SceneUtils.TileIndexToWorld(mainIndex, ForceChangeScene.World, loginServerId)
  local targetWorldPos = world.CurTarget
  return UIUtil.CalcConstructMilePointer(leftPadding, topPadding, mainWorldPos, targetWorldPos)
end

local function GetResourcePos(resourceType)
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View ~= nil then
      return window.View:GetResourcePos(resourceType)
    end
  end
end

local function GetAllianceItemPos(aItemType)
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View ~= nil then
      return window.View:GetAllianceItemPos(aItemType)
    end
  end
end

local function ClickWorldCloseWorldUI()
  UIUtil.ClickCloseWorldUI(CloseUIType.ClickWorld)
end

local function ClickUICloseWorldUI()
  UIUtil.ClickCloseWorldUI(CloseUIType.ClickUI)
end

local function DragWorldCloseWorldUI()
  UIUtil.ClickCloseWorldUI(CloseUIType.DragWorld)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHide)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
end

local function CheckNeedQuitFocus()
  local needQuit = false
  for k, v in ipairs(DragWorldNeedCloseExtraWorldUI) do
    if needQuit == false and UIManager:GetInstance():IsWindowOpen(v) then
      needQuit = true
    end
  end
  return needQuit
end

local function ClickCloseWorldUI(closeUIType)
  local needCloseList = {}
  if CS.SceneManager:IsInCity() and closeUIType == CloseUIType.DragWorld then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIWorldPoint)
    if window ~= nil and window.View ~= nil and window.View.activeSelf == true and window.Ctrl ~= nil and window.Ctrl.type == WorldPointUIType.SingleMapGarbage then
      table.insert(needCloseList, UIWindowNames.UIWorldPoint)
    end
  end
  for k, v in ipairs(ClickWorldNeedCloseWorldUI) do
    table.insert(needCloseList, v)
  end
  if closeUIType == CloseUIType.ClickUI then
    for k1, v1 in ipairs(ClickUINeedCloseExtraWorldUI) do
      table.insert(needCloseList, v1)
    end
    table.insert(needCloseList, UIWindowNames.UIWorldPoint)
  elseif closeUIType == CloseUIType.DragWorld then
    for k1, v1 in ipairs(DragWorldNeedCloseExtraWorldUI) do
      table.insert(needCloseList, v1)
    end
  end
  UIManager:GetInstance():DestroyViewList(needCloseList, closeUIType ~= CloseUIType.ClickUI)
  EventManager:GetInstance():Broadcast(EventId.HideMarchTip)
end

local function PlayAnimationReturnTime(unity_animator, animName)
  if unity_animator and animName then
    local duration = 0
    local clips = unity_animator.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
      if string.endswith(clips[i].name, animName) then
        duration = clips[i].length
        unity_animator:Play(animName, 0, 0)
        return true, duration
      end
    end
  end
  return false
end

local function ClickBuildAdjustCameraView(worldPoint, adjustTable, lossyScale, serverId)
  local world = CS.SceneManager.World
  local screen = world:WorldToScreenPoint(worldPoint)
  local Screen = CS.UnityEngine.Screen
  local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
  local ScreenY = Screen.height
  local ScreenX = Screen.width
  local touchCamera = CS.UnityEngine.Camera.main:GetComponent(typeof(MobileTouchCamera))
  local zoom = touchCamera.CamZoom
  local maxTop = ScreenY - adjustTable.top * lossyScale
  local maxBottom = adjustTable.bottom * lossyScale
  local maxLeft = adjustTable.left * lossyScale
  local maxRight = ScreenX - adjustTable.right * lossyScale
  local needMove = false
  if maxRight < screen.x then
    needMove = true
    screen.x = maxRight
  elseif maxLeft > screen.x then
    needMove = true
    screen.x = maxLeft
  end
  if maxTop < screen.y then
    needMove = true
    screen.y = maxTop
  elseif maxBottom > screen.y then
    needMove = true
    screen.y = maxBottom
  end
  if needMove then
    local posWorld = world:ScreenPointToWorld(screen)
    local CurTarget = world.CurTarget
    local curPos = CurTarget + worldPoint - posWorld
    local theServerId = serverId or LuaEntry.Player:GetCurServerId()
    if SceneUtils.GetIsInWorld() then
      local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
      if seasonInfo ~= nil and seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
        local xIndex = Mathf.Clamp(curPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
        local yIndex = Mathf.Clamp(curPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
        local bigZone = toInt(xIndex + 3 * yIndex + 1)
        theServerId = seasonInfo:GetNinePalacesServer(bigZone)
      end
    end
    GoToUtil.GotoPos(curPos, zoom, nil, nil, theServerId)
  end
end

local function ClickFarmAdjustPos(worldPoint, Adjust)
  local pos = worldPoint
  local lossyScale = UIManager:GetInstance():GetScaleFactor()
  local screen = CS.SceneManager.World:WorldToScreenPoint(worldPoint)
  local Screen = CS.UnityEngine.Screen
  local ScreenY = Screen.height
  local ScreenX = Screen.width
  local maxTop = ScreenY - Adjust.top * lossyScale
  local maxBottom = Adjust.bottom * lossyScale
  local maxLeft = Adjust.left * lossyScale
  local maxRight = ScreenX - Adjust.right * lossyScale
  local needMove = false
  if maxRight < screen.x then
    needMove = true
    screen.x = maxRight
  elseif maxLeft > screen.x then
    needMove = true
    screen.x = maxLeft
  end
  if maxTop < screen.y then
    needMove = true
    screen.y = maxTop
  elseif maxBottom > screen.y then
    needMove = true
    screen.y = maxBottom
  end
  if needMove then
    local posWorld = CS.SceneManager.World:ScreenPointToWorld(screen)
    pos = CS.SceneManager.World.CurTarget + worldPoint - posWorld
  end
  return pos, needMove
end

local function IsInView(worldPoint)
  local screen = CS.SceneManager.World:WorldToScreenPoint(worldPoint)
  local Screen = CS.UnityEngine.Screen
  return screen.x < Screen.width and screen.y < Screen.height
end

local function IsInViewByIndex(index, size)
  local tarTile = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  return UIUtil.IsInViewByTileXY(tarTile, size)
end

local function IsInViewByTileXY(tileXY, size)
  local half = math.max((size - 1) / 2, 0)
  local Screen = _ENV.Screen
  local tmpXY = {
    x = tileXY.x + half,
    y = tileXY.y + half
  }
  local maxScreen = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileToWorld(tmpXY))
  if 0 > maxScreen.x or 0 > maxScreen.y then
    return false
  end
  tmpXY = {
    x = tileXY.x - half,
    y = tileXY.y - half
  }
  local minScreen = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileToWorld(tmpXY))
  if minScreen.x > Screen.width or minScreen.y > Screen.height then
    return false
  end
  return true
end

local function OnClickWorldTrain(marchUuid)
end

local function OnClickMultiObjects(objects)
  UIUtil.ClickWorldCloseWorldUI()
  local needCloseUI = {}
  for k, v in ipairs(ClickUINeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  for k, v in pairs(needCloseUI) do
    if v then
      UIManager:GetInstance():DestroyWindow(k)
    end
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldMultiSelect, {anim = false}, objects)
end

local function OnClickWorldTroop(marchUuid)
  UIUtil.ClickWorldCloseWorldUI()
  CS.SceneManager.World:HideTouchEffect()
  local needCloseUI = {}
  for k, v in ipairs(ClickUINeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  if CS.CommonUtils.IsDebug() then
    Logger.Log("marchUuid = " .. marchUuid)
  end
  local needCloseWorldPointUI = true
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo then
    if marchInfo.isFake == true then
      return
    end
    local inBattleField = BattleFieldUtil.InBattleField()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local srcServer = marchInfo.srcServer
    local targetServer = marchInfo.targetServer
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(srcServer or targetServer or curServerId)
    local marchType = marchInfo:GetMarchType()
    if isBigMapMode and not inBattleField and marchType == NewMarchType.MONSTER and srcServer ~= curServerId and srcServer == targetServer and srcServer ~= nil and srcServer ~= 0 then
      local data = SeasonUtil.GetSeasonInfo(curServerId)
      if data and not data:IsInBattleServerGroupInt(srcServer) then
        Logger.LogError(string.format("ATTACK_MONSTER_ERROR : %s, %s, %s", marchUuid, curServerId, srcServer))
      end
    end
    if marchType == NORMAL or marchType == NewMarchType.FAKE_ATTACK or marchType == ASSEMBLY_MARCH or marchType == SCOUT or marchType == NewMarchType.TREAT_VIRUS or marchType == RESOURCE_HELP or marchType == GOLLOES_EXPLORE or marchType == GOLLOES_TRADE or marchType == DIRECT_MOVE_MARCH or marchType == NewMarchType.ALL_OUT or marchType == NewMarchType.LOTTO_RECEIVE or marchType == NewMarchType.ZONE_MOBILIZATION_DONATE or marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      CS.SceneManager.World.marchUuid = marchUuid
      CS.SceneManager.World:TrackMarch(marchUuid)
      WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
    elseif marchType == NewMarchType.TRAIN then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseWorldPointUI = false
      CS.SceneManager.World.marchUuid = marchUuid
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. WorldPointUIType.Train .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", WorldPointUIType.Train, 0, 0)
      end
      CS.SceneManager.World:TrackMarch(marchUuid)
    elseif marchType == NewMarchType.ZONE_TRAIN then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseWorldPointUI = false
      CS.SceneManager.World.marchUuid = marchUuid
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. WorldPointUIType.HSR .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", WorldPointUIType.HSR, 0, 0)
      end
      CS.SceneManager.World:TrackMarch(marchUuid)
    elseif marchType == NewMarchType.FLOWER_TRAIN then
      local carIndex = 1
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      CS.SceneManager.World.marchUuid = marchUuid
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local worldPoint = SceneUtils.WorldToTileIndex(marchInfo.position)
      CS.SceneManager.World:AutoZoom(CS.SceneManager.World.InitZoom, 0.1, function()
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = marchUuid .. ";" .. worldPoint .. ";" .. "" .. ";" .. WorldPointUIType.FlowerTrain .. ";" .. "0" .. ";" .. "0" .. ";" .. "0" .. ";" .. "0" .. ";" .. carIndex
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, marchUuid, worldPoint, "", WorldPointUIType.FlowerTrain, 0, 0, 0, 0, carIndex)
        end
        CS.SceneManager.World:TrackMarch(marchUuid)
      end)
    elseif marchType == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      UIUtil.OpenOrRefreshUIWorldPoint(marchUuid, marchInfo.targetPos, "", WorldPointUIType.DetectZombieBusTrain, 0, 0, 0, 0, 1)
      CS.SceneManager.World.marchUuid = marchUuid
      CS.SceneManager.World:TrackMarch(marchUuid)
    elseif marchInfo:IsMonsterOrOrdinaryBoss() or marchType == RUNNING_BOSS or marchType == BEHEMOTH_BOSS or marchType == NewMarchType.SANDFISH or marchType == NewMarchType.CROCODILE or marchType == NewMarchType.RUNNING_MUMMY or marchType == NewMarchType.DARKNESS_MONSTER or marchType == NewMarchType.BLOODY_QUEEN or marchType == NewMarchType.MUMMY then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local worldPointUIType = WorldPointUIType.Monster
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
      local targetPos = marchInfo.targetPos
      if monster then
        if monster.special == WorldMonsterSpecialType.AllyDrill then
          worldPointUIType = WorldPointUIType.DrillBase
        elseif monster.special == WorldMonsterSpecialType.AllyDrillHugeSandWorm then
          worldPointUIType = WorldPointUIType.AllyDrillHugeSandWorm
        elseif monster.special == WorldMonsterSpecialType.AllyDrillRoadHog then
          worldPointUIType = WorldPointUIType.AllyDrillRoadHog
        elseif monster.special == WorldMonsterSpecialType.FlowerBoss then
          targetPos = SceneUtils.WorldToTileIndex(marchInfo:GetMarchCurPos(), ForceChangeScene.World)
        elseif monster.special == WorldMonsterSpecialType.InvasionBigBoss then
          local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
          if not isMine then
            UIUtil.ShowTips(Localization:GetString("activity_godzilla_battle_other_alliance"))
            return
          end
          worldPointUIType = WorldPointUIType.Aisilla
        elseif monster.special == WorldMonsterSpecialType.HugeSandWorm or monster.special == WorldMonsterSpecialType.BigSandWorm then
          worldPointUIType = WorldPointUIType.SandWorm
        elseif monster.special == WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV then
          worldPointUIType = WorldPointUIType.KillZombieKirovBoss
        elseif monster.special == WorldMonsterSpecialType.S1RestCityDefendMonster then
          worldPointUIType = WorldPointUIType.S1RestCityDefendMonster
        elseif monster.special == WorldMonsterSpecialType.S1RestBloodyQueenMonster or monster.special == WorldMonsterSpecialType.S1RestBloodyQueenGunner or monster.special == WorldMonsterSpecialType.S1RestBloodyQueenButcher then
          worldPointUIType = WorldPointUIType.S1RestBloodyQueenMonster
        elseif monster.special == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
          worldPointUIType = WorldPointUIType.S0AllianceDrillBoss
        end
        if monster.special == WorldMonsterSpecialType.Normal and monster.level >= 4 and monster.monster_resistance ~= nil and monster.monster_resistance ~= 0 then
          UIUtil.CheckEventTrigger(OpMode.ClickMonsterWithVirus, 0, 0.5)
        end
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. targetPos .. ";" .. "" .. ";" .. worldPointUIType .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, targetPos, "", worldPointUIType, 0, 0)
      end
      if marchType == RUNNING_BOSS or marchType == BEHEMOTH_BOSS or marchType == NewMarchType.SANDFISH or marchType == NewMarchType.RUNNING_MUMMY or marchType == NewMarchType.MUMMY or marchType == NewMarchType.ZONE_MOBILIZATION_BOSS or marchInfo:IsWanderMonster() or marchInfo:IsBloodyQueenMonster() then
        CS.SceneManager.World:TrackMarch(marchUuid)
      elseif worldPointUIType == WorldPointUIType.S0AllianceDrillBoss then
        local worldPos = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World, marchInfo.targetServer)
        worldPos.z = worldPos.z + WORLD_MONSTER_FOCUS_OFFSET_Z
        worldPos.y = worldPos.y + 5
        CS.SceneManager.World:AutoLookat(worldPos, CS.SceneManager.World.InitZoom, 0.1)
      else
        local worldPos = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World, marchInfo.targetServer)
        worldPos.z = worldPos.z + WORLD_MONSTER_FOCUS_OFFSET_Z
        CS.SceneManager.World:AutoLookat(worldPos)
      end
      if marchInfo:IsOrdinaryBoss() and monster then
        DataCenter.LWActivityLockhartManager:TryOpenMonsterSpecialIdPlot(monster.special)
      end
      local param = {}
      param.monster = true
      DataCenter.GuideManager:SetCompleteNeedParam(param)
      DataCenter.GuideManager:CheckGuideComplete()
      if DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(marchInfo.targetPos) ~= nil then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickRadarMonster, SaveGuideDoneValue)
      else
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickMonster, tostring(marchInfo.monsterId))
      end
      needCloseWorldPointUI = false
    elseif marchType == ACT_BOSS then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. WorldPointUIType.ActBoss .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", WorldPointUIType.ActBoss, 0, 0)
      end
      needCloseWorldPointUI = false
    elseif marchType == PUZZLE_BOSS then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. WorldPointUIType.PuzzleBoss .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", WorldPointUIType.PuzzleBoss, 0, 0)
      end
      needCloseWorldPointUI = false
    elseif marchType == CHALLENGE_BOSS then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. WorldPointUIType.ChallengeBoss .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", WorldPointUIType.ChallengeBoss, 0, 0)
      end
      needCloseWorldPointUI = false
    elseif marchType == NewMarchType.ACT_BERSERK_BOSS then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      if LuaEntry.Player:AtHomeNow() then
      elseif isBigMapMode and loginSameGroup and srcSameGroup and srcServer == mySourceServerId and targetServer == mySourceServerId then
      elseif srcServer ~= mySourceServerId or targetServer ~= mySourceServerId then
        UIUtil.ShowTipsId("activity_berserkboss_tips_06")
        return
      else
        UIUtil.ShowTipsId("season_tips143")
        return
      end
      if 0 >= marchInfo.curHp then
        local isFromActivityPanel = DataCenter.LWBerserkBossManager:GetIsFromActivityJumpToWorldBossMark()
        if isFromActivityPanel then
          return
        end
        local alreadyReceiveReward = DataCenter.LWBerserkBossManager:GetBerserkBossAlreadyReceiveRewardStatus(marchInfo.uuid)
        if not alreadyReceiveReward then
          DataCenter.LWBerserkBossManager:RequestBerserkBossKillRewardData(marchInfo.uuid)
          return
        end
      end
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.startPos .. ";" .. "" .. ";" .. WorldPointUIType.BerserkBoss .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.startPos, "", WorldPointUIType.BerserkBoss, 0, 0)
      end
      needCloseWorldPointUI = false
    elseif marchType == NewMarchType.ZONE_MOBILIZATION_BOSS then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local worldPointUIType = WorldPointUIType.ZoneMobilizationBoss
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. marchInfo.targetPos .. ";" .. "" .. ";" .. worldPointUIType .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, marchInfo.targetPos, "", worldPointUIType, 0, 0)
      end
      CS.SceneManager.World:TrackMarch(marchUuid)
      needCloseWorldPointUI = false
    end
  else
    local hsrData = DataCenter.HSRDataManager:GetHSRData(marchUuid)
    local hsrViewFGO = DataCenter.HSRViewManager:GetHSRViewFollowGO(marchUuid)
    if hsrData then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      needCloseWorldPointUI = false
      CS.SceneManager.World.marchUuid = marchUuid
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = marchUuid .. ";" .. "0" .. ";" .. "" .. ";" .. WorldPointUIType.HSR .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, marchUuid, 0, "", WorldPointUIType.HSR, 0, 0)
      end
      CS.SceneManager.World:TrackHSR(marchUuid, hsrViewFGO)
    end
  end
  for k, v in pairs(needCloseUI) do
    if v then
      UIManager:GetInstance():DestroyWindow(k)
    end
  end
  if needCloseWorldPointUI == true and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
  end
end

local function OnClickSandWorm(pointId, sandWormUuid)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo == nil or pointInfo.sandWorm == nil then
    return
  end
  UIUtil.ClickWorldCloseWorldUI()
  CS.SceneManager.World:HideTouchEffect()
  local needCloseUI = {}
  for _, v in ipairs(ClickUINeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  WorldMarchTileUIManager:GetInstance():RemoveTroop()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  needCloseUI[UIWindowNames.UIWorldPoint] = nil
  local worldPointUIType = WorldPointUIType.SandWorm
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    local str = sandWormUuid .. ";" .. pointId .. ";" .. "" .. ";" .. worldPointUIType .. ";" .. "0" .. ";" .. "0"
    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, sandWormUuid, pointId, "", worldPointUIType, 0, 0)
  end
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  worldPos.z = worldPos.z + 10
  CS.SceneManager.World:AutoLookat(worldPos)
  for k, v in pairs(needCloseUI) do
    if v then
      UIManager:GetInstance():DestroyWindow(k)
    end
  end
end

local function OpenOrRefreshUIWorldPoint(uuid, pointIndex, ownerUid, worldPointUIType, isAlliance, buildId, isArrow, desertId, showGuide)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    local str = uuid .. ";" .. pointIndex .. ";" .. ownerUid .. ";" .. worldPointUIType .. ";" .. (isAlliance or 0) .. ";" .. (buildId or 0) .. (isArrow or 0) .. ";" .. (desertId or 0) .. ";" .. (showGuide or 0) .. ";"
    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, uuid, pointIndex, ownerUid, worldPointUIType, isAlliance, buildId, isArrow, desertId, showGuide)
  end
end

local function OnClickWorld(curIndex, clickType, triggerUuid)
  if CrossServerUtil.IsJumpToServerMode() then
    local data = CrossServerUtil.GetLastJumpToParam()
    if data and data.buildId and data.mode == JumpServerMode.PutAllianceBuild then
      local serverId = LuaEntry.Player:GetCurServerId()
      if DataCenter.AllianceMineManager:ExistAllianceFlagInServer(serverId) then
        CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.SeasonBattleDesert, curIndex)
      else
        BuildingUtils.ShowPutAllianceBuild(data.buildId, 0, toInt(curIndex), PlaceBuildType.Build)
      end
      return
    end
  end
  local needChangeCamera = UIUtil.CheckNeedQuitFocus()
  UIUtil.ClickWorldCloseWorldUI()
  local needCloseIsFocus = true
  local needCloseZoneEffect = true
  local needCloseWorldPointUI = true
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHide)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  EventManager:GetInstance():Broadcast(EventId.DestroyLandLockBubbleStateHide)
  EventManager:GetInstance():Broadcast(EventId.DestroyMonsterLockBubbleStateHide)
  EventManager:GetInstance():Broadcast(EventId.ClickAny)
  local needCloseUI = {}
  for k, v in ipairs(ClickUINeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  for k, v in ipairs(DragWorldNeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  if CS.CommonUtils.IsDebug() then
    Logger.Log("ClickWorld => " .. curIndex)
  end
  WorldMarchTileUIManager:GetInstance():RemoveTroop()
  CS.SceneManager.World:HideTouchEffect()
  EventManager:GetInstance():Broadcast(EventId.OnClickWorld, curIndex)
  if triggerUuid then
    local info = CS.SceneManager.World:GetWorldTriggerData(triggerUuid)
    if info then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, triggerUuid, curIndex, "", WorldPointUIType.WorldTrigger, 0)
      UIUtil.OnClickWorldPostProcess(needCloseWorldPointUI, needCloseZoneEffect, needCloseUI, needCloseIsFocus)
    end
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(curIndex)
  if info ~= nil and info.isMainPoint == false then
    info = CS.SceneManager.World:GetPointInfo(info.mainIndex)
  end
  if info ~= nil then
    if info.uuid ~= nil and CS.CommonUtils.IsDebug() then
      Logger.Log("uuid = " .. info.uuid)
    end
    if info.PointType == WorldPointType.PlayerBuilding then
      cast(info, typeof(CS.BuildPointInfo))
      local flagNormallBase = false
      if info ~= nil then
        if SeasonUtil.IsSeasonPlayerBuilding(info.itemId) then
          needCloseWorldPointUI = false
          SeasonUtil.OnClickWorldPlayerBuilding(curIndex, clickType, info, needCloseUI)
        elseif info.itemId == BuildingTypes.WORM_HOLE_CROSS then
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
          local isAlliance = 0
          if info.allianceId == LuaEntry.Player.allianceId then
            isAlliance = 1
          end
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.City .. ";" .. isAlliance .. ";" .. info.itemId
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, isAlliance, info.itemId)
          end
          flagNormallBase = true
        elseif info.ownerUid == LuaEntry.Player.uid then
          if info:IsNormalType() then
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(info.uuid)
            Logger.Log("main Uuid" .. info.uuid)
            if buildData ~= nil then
              if 0 < buildData.destroyStartTime then
                local isFinish = DataCenter.BuildManager:CheckSendFixBuildFinish(info.uuid)
                if 0 <= info.level and isFinish == true then
                  needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(info.mainIndex))
                  else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
                      anim = true,
                      playEffect = false,
                      UIMainAnim = UIMainAnimType.LeftRightBottomHide
                    }, tostring(info.mainIndex), needChangeCamera)
                  end
                end
              elseif info.level == 0 and info.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
                needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
                  anim = true,
                  playEffect = false,
                  UIMainAnim = UIMainAnimType.LeftRightBottomHide
                }, tostring(info.mainIndex), needChangeCamera)
              elseif 0 <= info.level then
                local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
                if buildTemplate ~= nil and buildData ~= nil then
                  local bUuid = buildData.uuid
                  local buildId = buildData.itemId
                  if info.level == 0 then
                    if buildData.updateTime == 0 then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
                    end
                  else
                    if buildTemplate.zoneMainType == BuildZoneMainType.Main then
                      DataCenter.BuildZoneManager:ShowZoneEffect(bUuid, buildId)
                      needCloseZoneEffect = false
                    end
                    do
                      local recommendParam = DataCenter.RecommendShowManager:CheckClickBuild(buildId)
                      if buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
                        if buildData.unavailableTime == 0 then
                          local now = UITimeManager:GetInstance():GetServerTime()
                          if now < buildData.produceEndTime and buildData.produceEndTime > buildData.lastCollectTime then
                            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIResourceCost) then
                              EventManager:GetInstance():Broadcast(EventId.UIResourceCostChangeState, bUuid)
                            else
                              UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceCost, bUuid)
                            end
                            needCloseUI[UIWindowNames.UIResourceCost] = nil
                          end
                        end
                      elseif buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
                        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ground, false)
                        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
                        if queueData ~= nil then
                          local onComplete
                          local state = queueData:GetQueueState()
                          local canIrrigate = DataCenter.PlayerCareerManager:CheckIfIrrigateAvailable(IrrigationType.Farmland)
                          local isIrrigated = queueData:CheckIfIrrigated()
                          local originalPos = SceneUtils.TileIndexToWorld(buildData.pointId)
                          local pos, needMove = UIUtil.ClickFarmAdjustPos(originalPos, FarmAdjust)
                          local alreadyShowUI = false
                          if state == NewQueueState.Finish then
                            needCloseUI[UIWindowNames.UIFarmGather] = nil
                            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmGather) then
                              alreadyShowUI = true
                              EventManager:GetInstance():Broadcast(EventId.RefreshFarmGatherUI, bUuid)
                            else
                              function onComplete()
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                                  anim = true,
                                  
                                  playEffect = false,
                                  UIMainAnim = UIMainAnimType.LeftRightBottomHide
                                }, bUuid)
                              end
                            end
                          elseif state == NewQueueState.Free then
                            needCloseUI[UIWindowNames.UIFarm] = nil
                            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarm) then
                              alreadyShowUI = true
                              EventManager:GetInstance():Broadcast(EventId.RefreshFarmUI, bUuid)
                            else
                              function onComplete()
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
                                  anim = true,
                                  
                                  playEffect = false,
                                  UIMainAnim = UIMainAnimType.LeftRightBottomHide
                                }, bUuid)
                              end
                            end
                          elseif state == NewQueueState.Work then
                            local signal = SFSObject.New()
                            signal:PutLong("bUuid", bUuid)
                            EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                            EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, bUuid)
                            if canIrrigate and not isIrrigated then
                              needCloseUI[UIWindowNames.UIFarmIrrigate] = nil
                              if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmIrrigate) then
                                alreadyShowUI = true
                                EventManager:GetInstance():Broadcast(EventId.RefreshFarmIrrigateUI, bUuid)
                              else
                                function onComplete()
                                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmIrrigate, {
                                    anim = true,
                                    
                                    playEffect = false,
                                    UIMainAnim = UIMainAnimType.LeftRightBottomHide
                                  }, bUuid)
                                end
                              end
                            end
                          end
                          needCloseIsFocus = false
                          WorldArrowManager:GetInstance():RemoveEffect()
                          if recommendParam ~= nil and alreadyShowUI == false then
                            local movePos = recommendParam.focusPos
                            if movePos == nil then
                              movePos = originalPos
                            end
                            CS.SceneManager.World:AutoFocus(movePos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                          elseif needMove == true and alreadyShowUI == false then
                            if state == NewQueueState.Work then
                              if isIrrigated then
                                local signal = SFSObject.New()
                                signal:PutLong("bUuid", bUuid)
                                EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                                EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, bUuid)
                              end
                              CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                            else
                              CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                            end
                          else
                            CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, false, false, onComplete)
                          end
                        end
                      elseif buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                        if buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_OstrichFarm, false)
                        elseif buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CattleFarm, false)
                        elseif buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CattleFarm, false)
                        end
                        local signal = SFSObject.New()
                        signal:PutLong("bUuid", bUuid)
                        local originalPos = SceneUtils.TileIndexToWorld(buildData.pointId)
                        local pos, needMove = UIUtil.ClickFarmAdjustPos(originalPos, PastureAdjust)
                        EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                        
                        local function onComplete()
                          UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
                            anim = true,
                            playEffect = false,
                            UIMainAnim = UIMainAnimType.LeftRightBottomHide
                          }, bUuid)
                        end
                        
                        needCloseIsFocus = false
                        if recommendParam ~= nil then
                          CS.SceneManager.World:AutoFocus(originalPos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                        elseif needMove == true then
                          CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
                        else
                          CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, false, true, onComplete)
                        end
                      elseif buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
                        UIUtil.CheckAndOpenBusinessCenter()
                      end
                      if (buildTemplate.build_type ~= BuildType.Second or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_MAIN or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildTemplate.id == BuildingTypes.WORM_HOLE_CROSS) and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_OSTRICH and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_CATTLE and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_SANDWORM and buildTemplate.id ~= BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
                        if buildTemplate.id == BuildingTypes.FUN_BUILD_CONDOMINIUM then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_LIBRARY, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_GROCERY_STORE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Build, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOODSHOP then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_FoodFactory, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Bakery, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD_2 then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Click_TuckerStore, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD_1 then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Bar, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_PVE_FACTORY then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_JewelryStore, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_OIL_REFINERY then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Factory, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FACTORY_STONE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Factory, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_MAIN then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Main_City, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_BARRACKS then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_BARRACKS, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CAR_BARRACK, false)
                        elseif buildTemplate.id == BuildingTypes.APS_BUILD_PUB then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Hero_Build, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_INFANTRY_BARRACK, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_AIRCRAFT_BARRACK, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_POLICE_STATION then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_POLICE_STATION, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_RADAR_CENTER then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Radar, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_DRONE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_DRONE, false)
                        elseif buildTemplate.id == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_ALLIANCE_CENTER, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_LIBRARY then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Apartment, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_COLD_STORAGE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_COLD_STORAGE, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_KONBINI then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_KONBINI, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENE then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_SCIENE, false)
                        elseif buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_1 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_2 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_3 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_TRAINFIELD, false)
                        else
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                        end
                        if info.itemId == BuildingTypes.FUN_BUILD_MAIN or info.itemId == BuildingTypes.WORM_HOLE_CROSS then
                          needCloseWorldPointUI = false
                          needCloseUI[UIWindowNames.UIWorldPoint] = nil
                          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.City .. ";" .. "1" .. ";" .. info.itemId
                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                          else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                              anim = true,
                              playEffect = false,
                              UIMainAnim = UIMainAnimType.LeftRightBottomHide
                            }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 1, info.itemId)
                          end
                          flagNormallBase = info.itemId == BuildingTypes.FUN_BUILD_MAIN
                        else
                          needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                            local isOpen = LuaEntry.DataConfig:CheckSwitch("factory_button")
                            if DataCenter.BuildManager:IsFactoryBuild(buildTemplate.id) and not isOpen then
                              if DataCenter.FactoryDataManager:HasUnlockItemByBuildId(buildTemplate.id) then
                                WorldArrowManager:GetInstance():RemoveEffect()
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, bUuid)
                              end
                            else
                              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(info.mainIndex))
                            end
                          elseif buildTemplate.id ~= BuildingTypes.APS_BUILD_FARM_FIELD then
                            local isOpen = LuaEntry.DataConfig:CheckSwitch("factory_button")
                            if DataCenter.BuildManager:IsFactoryBuild(buildTemplate.id) and not isOpen then
                              if DataCenter.FactoryDataManager:HasUnlockItemByBuildId(buildTemplate.id) then
                                WorldArrowManager:GetInstance():RemoveEffect()
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, bUuid)
                              end
                            else
                              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
                                anim = true,
                                playEffect = false,
                                UIMainAnim = UIMainAnimType.LeftRightBottomHide
                              }, tostring(info.mainIndex), needChangeCamera)
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.City .. ";" .. "1" .. ";" .. info.itemId
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 1, info.itemId)
            end
          end
        elseif info.ownerUid ~= LuaEntry.Player.uid then
          if info:IsNormalType() then
            if 0 <= info.level then
              local allianceId = LuaEntry.Player.allianceId
              if info.allianceId ~= nil and allianceId ~= nil and allianceId ~= "" and info.allianceId ~= "" and info.allianceId == allianceId then
                if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
                  if info.buildState == BuildingStateType.Crossing then
                    UIUtil.ShowTipsId("cross_server_tips01")
                  else
                    needCloseWorldPointUI = false
                    needCloseUI[UIWindowNames.UIWorldPoint] = nil
                    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                      local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.City .. ";" .. "1" .. ";" .. info.itemId
                      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                    else
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                        anim = true,
                        playEffect = false,
                        UIMainAnim = UIMainAnimType.LeftRightBottomHide
                      }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 1, info.itemId)
                    end
                  end
                  flagNormallBase = true
                else
                  needCloseWorldPointUI = false
                  needCloseUI[UIWindowNames.UIWorldPoint] = nil
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                    local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Build .. ";" .. "1" .. ";" .. info.itemId
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                  else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                      anim = true,
                      playEffect = false,
                      UIMainAnim = UIMainAnimType.LeftRightBottomHide
                    }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Build, 1, info.itemId)
                  end
                end
              elseif info.itemId == BuildingTypes.FUN_BUILD_MAIN then
                if info.buildState == BuildingStateType.Crossing then
                  UIUtil.ShowTipsId("cross_server_tips01")
                else
                  needCloseWorldPointUI = false
                  needCloseUI[UIWindowNames.UIWorldPoint] = nil
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                    local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.City .. ";" .. "0" .. ";" .. info.itemId
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                  else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                      anim = true,
                      playEffect = false,
                      UIMainAnim = UIMainAnimType.LeftRightBottomHide
                    }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 0, info.itemId)
                  end
                  flagNormallBase = true
                end
              else
                needCloseWorldPointUI = false
                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                  local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Build .. ";" .. "0" .. ";" .. info.itemId
                  EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                else
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                    anim = true,
                    playEffect = false,
                    UIMainAnim = UIMainAnimType.LeftRightBottomHide
                  }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Build, 0, info.itemId)
                end
              end
            end
          else
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Barricade .. ";" .. "0" .. ";" .. "0"
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Barricade, 1, info.itemId)
            end
          end
        end
        if (not CrossServerUtil:GetIsCrossServer() or CrossServerUtil:GetIsCrossServer() and BattleFieldUtil.InBattleField()) and info and not info:IsHasStatusOn(StatusType2.SkinAnimationType) and flagNormallBase and info.skinId and 0 < info.skinId then
          local template = DataCenter.DecorationTemplateManager:GetTemplate(info.skinId)
          if template and template.act_mod_open == 1 then
            local type = LuaEntry.Player.uid == info.ownerUid and 2 or 1
            local serverId = LuaEntry.Player:GetCrossServerId()
            local worldId = LuaEntry.Player:GetCurWorldId()
            SFSNetwork.SendMessage(MsgDefines.ClickWorldSkinAction, info.ownerUid, type, serverId, worldId)
          end
        end
      end
    elseif info.PointType == WorldPointType.WorldCollectResource then
      local collectInfo = CS.SceneManager.World:GetCollectInfoByIndex(info.pointIndex)
      if collectInfo ~= nil then
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local uiType = WorldPointUIType.CollectPoint
        if collectInfo.type == ResPointType.Alliance then
          uiType = WorldPointUIType.AllianceCollectPoint
        end
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = "0" .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. uiType .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, 0, info.mainIndex, "", uiType, 0)
        end
        local param = {}
        param.collectType = collectInfo:GetResourceType()
        DataCenter.GuideManager:SetCompleteNeedParam(param)
        DataCenter.GuideManager:CheckGuideComplete()
      end
    elseif info.PointType == WorldPointType.METEORITE_POINT then
      local pointInfo = CS.SceneManager.World:GetPointInfo(info.pointIndex)
      if pointInfo ~= nil then
        cast(pointInfo, typeof(CSWorldMeteoritePoint))
        if not pointInfo.CanCollect then
          UIUtil.ShowTipsId("yuntieBattle_tips_1010")
          return
        end
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local uiType = WorldPointUIType.MeteoriteResPoint
        if 0 < pointInfo.gatherUUID then
          local marchInfo = CS.SceneManager.World:GetMarch(pointInfo.gatherUUID)
          local isAlliance = 0
          if marchInfo then
            if marchInfo.allianceUid ~= "" and marchInfo.allianceUid == LuaEntry.Player.allianceId then
              isAlliance = 1
            end
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = pointInfo.gatherUUID .. ";" .. info.mainIndex .. ";" .. marchInfo.ownerUid .. ";" .. WorldPointUIType.MeteoriteResCollectArmy .. ";" .. isAlliance .. ";" .. "0"
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, pointInfo.gatherUUID, info.mainIndex, marchInfo.ownerUid, WorldPointUIType.MeteoriteResCollectArmy, isAlliance)
            end
          end
        elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = "0" .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. uiType .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, 0, info.mainIndex, "", uiType, 0)
        end
      end
    elseif info.PointType == WorldPointType.WorldResource then
      local data = CS.SceneManager.World:GetResourcePointInfoByIndex(info.pointIndex)
      if data ~= nil then
        if data:GetResPointType() == ResPointInfoType.Radar and data.ownerUid ~= LuaEntry.Player.uid then
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Barricade .. ";" .. "0" .. ";" .. "0"
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Barricade, 1, info.itemId)
          end
        elseif data.gatherMarchUuid ~= 0 then
          local marchInfo = CS.SceneManager.World:GetMarch(data.gatherMarchUuid)
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          local isAlliance = 0
          if marchInfo then
            if marchInfo.allianceUid ~= "" and marchInfo.allianceUid == LuaEntry.Player.allianceId then
              isAlliance = 1
            end
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = data.gatherMarchUuid .. ";" .. info.mainIndex .. ";" .. marchInfo.ownerUid .. ";" .. WorldPointUIType.CollectArmy .. ";" .. isAlliance
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, data.gatherMarchUuid, info.mainIndex, marchInfo.ownerUid, WorldPointUIType.CollectArmy, isAlliance)
            end
          elseif CS.CommonUtils.IsDebug() then
            Logger.LogError("\233\135\135\233\155\134\233\131\168\233\152\159\228\184\141\229\173\152\229\156\168\239\188\140id = " .. data.gatherMarchUuid)
            UIUtil.ShowTips("\229\135\186\233\148\153\229\149\166\239\188\140\232\191\153\229\186\148\232\175\165\230\152\175\232\135\170\229\183\177\231\154\132\233\135\135\233\155\134\231\130\185\239\188\140\228\189\134\230\152\175\230\137\190\228\184\141\229\136\176\229\175\185\229\186\148\231\154\132\233\135\135\233\155\134\233\131\168\233\152\159")
          end
        else
          local id = info.id
          local triggerType = GetTableData(TableName.GatherResource, id, "resource_type")
          local resourceType = tonumber(triggerType)
          if resourceType == ResourceType.ResourceItem then
            triggerType = triggerType .. ";" .. GetTableData(TableName.GatherResource, id, "param")
          else
            triggerType = tostring(triggerType)
          end
          if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickWorldCollectPoint, triggerType) then
            local pos = SceneUtils.TileIndexToWorld(curIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
            GoToUtil.GotoWorldPos(pos)
          else
            DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            local uiType = WorldPointUIType.CollectPoint
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = "0" .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. uiType .. ";" .. "0" .. ";" .. "0"
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, 0, info.mainIndex, "", uiType, 0)
            end
          end
        end
      end
    elseif info.PointType == WorldPointType.PlayerRoad then
      cast(info, typeof(CS.BoardPointInfo))
      if info ~= nil and info.ownerUid ~= LuaEntry.Player.uid then
        local allianceId = LuaEntry.Player.allianceId
        if (info.allianceId == nil or allianceId == nil or info.allianceId == "" or allianceId == "" or info.allianceId ~= allianceId) and info.inside == 0 then
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.Road .. ";" .. "0" .. ";" .. "0"
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.Road, 0)
          end
        end
      end
    elseif info.PointType == WorldPointType.MONSTER_REWARD then
      if info ~= nil then
        local uuid = info.uuid
        local rewardData = DataCenter.CollectRewardDataManager:GetRewardDataByUuid(uuid)
        if rewardData ~= nil then
          local param = {}
          param.monsterReward = true
          DataCenter.GuideManager:SetCompleteNeedParam(param)
          DataCenter.GuideManager:CheckGuideComplete()
          local isFull = false
          local totalNum = 0
          if rewardData.rewardList ~= nil then
            table.walk(rewardData.rewardList, function(k, v)
              if isFull == false and v.rewardType == RewardType.RESOURCE_ITEM then
                totalNum = totalNum + v.count
                if DataCenter.ResourceItemDataManager:CheckIsStorageFull(totalNum) then
                  isFull = true
                end
              end
            end)
          end
          if isFull then
            if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
              DataCenter.GuideManager:SetGuideEndCallBack(function()
                GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
              end)
            else
              GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
            end
          elseif DataCenter.BuildManager:CheckIsSendMessage(uuid) == false then
            EventManager:GetInstance():Broadcast(EventId.ShowCapacity)
            if rewardData ~= nil then
              DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.MonsterGetReward, tostring(rewardData.contentId))
            end
            DataCenter.BuildManager:DelayClearSendList(uuid)
          end
        end
      end
    elseif info.PointType == WorldPointType.SAMPLE_POINT or info.PointType == WorldPointType.SAMPLE_POINT_NEW or info.PointType == WorldPointType.RADAR_DOMINATOR_CURE then
      local data = CS.SceneManager.World:GetSamplePointInfoByIndex(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = data.uuid .. ";" .. info.pointIndex .. ";" .. "" .. ";" .. WorldPointUIType.Sample .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, data.uuid, info.pointIndex, "", WorldPointUIType.Sample, 0)
      end
    elseif info.PointType == WorldPointType.RESCUE_POINT then
      local data = CS.SceneManager.World:GetSamplePointInfoByIndex(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = data.uuid .. ";" .. info.pointIndex .. ";" .. "" .. ";" .. WorldPointUIType.Rescue .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, data.uuid, info.pointIndex, "", WorldPointUIType.Rescue, 0)
      end
    elseif info.PointType == WorldPointType.EXPLORE_POINT then
      local data = CS.SceneManager.World:GetExplorePointInfoByIndex(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if info.PointType == WorldPointType.EXPLORE_POINT then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Gulu, false)
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = data.uuid .. ";" .. info.pointIndex .. ";" .. "" .. ";" .. WorldPointUIType.Explore .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, data.uuid, info.pointIndex, "", WorldPointUIType.Explore, 0)
      end
    elseif info.PointType == WorldPointType.DETECT_EVENT_PVE then
      local data = CS.SceneManager.World:GetExplorePointInfoByIndex(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(data.uuid)
      if detectData == nil then
        return
      end
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectData.eventId)
      if template == nil then
        return
      end
      if template.type == DetectEventType.DetectEventPVE or template.type == DetectEventType.SPECIAL_OPS then
        UIUtil.OpenOrRefreshUIWorldPoint(data.uuid, info.pointIndex, "", WorldPointUIType.DetectEventPVE, 0)
      elseif template.type == DetectEventType.FAKE_PVP or template.type == DetectEventType.DOMINATOR_SPECIAL then
        UIUtil.OpenOrRefreshUIWorldPoint(data.uuid, info.pointIndex, "", WorldPointUIType.DetectEventFakePVP, 0)
      end
    elseif info.PointType == WorldPointType.GARBAGE then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_GroundGoods, false)
      local param = {}
      param.isClickGarbage = true
      DataCenter.GuideManager:SetCompleteNeedParam(param)
      DataCenter.GuideManager:CheckGuideComplete()
      local data = CS.SceneManager.World:GetGarbagePointInfoByIndex(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = data.uuid .. ";" .. info.pointIndex .. ";" .. "" .. ";" .. WorldPointUIType.PickGarbage .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, data.uuid, info.pointIndex, "", WorldPointUIType.PickGarbage, 0)
      end
    elseif info.PointType == WorldPointType.HERO_DISPATCH then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTask.Type)
      local actInfo = 0 < #actList and actList[1] or nil
      local theLevel = DataCenter.BuildManager.MainLv
      local atHomeNow = LuaEntry.Player:AtHomeNow()
      if actInfo == nil and atHomeNow and theLevel < 7 then
        UIUtil.ShowTipsId(456253)
      elseif actInfo == nil or not DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() and not atHomeNow then
        if actInfo == nil then
          Logger.LogInfo("DispatchTask actInfo nil")
        end
        UIUtil.ShowTipsId(500019)
      elseif actInfo.needMainCityLevel and theLevel < actInfo.needMainCityLevel then
        UIUtil.ShowTipsId(456253)
      else
        local data = CS.SceneManager.World:GetPointInfo(info.pointIndex)
        if data ~= nil and data.completionTime == 0 and LuaEntry.Player:GetUid() == data.ownerUid then
          UIUtil.OnClickDispatchTask(info.pointIndex)
        elseif data ~= nil then
          local now = UITimeManager:GetInstance():GetServerTime()
          local canAward = 0 < data.completionTime and now >= data.completionTime and data.rewarded == 0
          if canAward and LuaEntry.Player:GetUid() == data.ownerUid then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_GroundGoods, false)
            SFSNetwork.SendMessage(MsgDefines.DispatchReward, data.uuid)
          else
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = data.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.DispatchTask .. ";" .. "0" .. ";" .. "0"
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, data.uuid, info.mainIndex, "", WorldPointUIType.DispatchTask, 0)
            end
          end
        end
      end
    elseif info.PointType == WorldPointType.GHOSTRECON_POINT then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
      local actInfo = 0 < #actList and actList[1] or nil
      if actInfo == nil or actInfo.needMainCityLevel and actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
        UIUtil.ShowTipsId("ghostrecon_078")
      else
        local data = CS.SceneManager.World:GetPointInfo(info.pointIndex)
        needCloseWorldPointUI = UIUtil.OnClickGhostreconPoint(data, info)
        if not needCloseWorldPointUI then
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
        end
        DataCenter.ActGhostreconAnimManager:RemoveWorldFingerArrowByUUid(data.uuid)
      end
    elseif info.PointType == WorldPointType.WORLD_ALLIANCE_CITY or info.PointType == WorldPointType.WORLD_CITY_STRONGHOLD or info.PointType == WorldPointType.WORLD_CITY_OUTPOST or info.PointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER or info.PointType == WorldPointType.WORLD_CITY_TRADE or info.PointType == WorldPointType.ZWL_BUILDING or info.PointType == WorldPointType.ZWL_BUILDING_THRONE or info.PointType == WorldPointType.ZWL_BUILDING_BUFF or info.PointType == WorldPointType.ZWL_BUILDING_TOWER then
      local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
      local theCityId = info.CityId or info.cityId
      local temp = DataCenter.AllianceCityTemplateManager:GetTemplate(theCityId, info.serverId)
      if temp then
        do
          local cityType = toInt(temp.type)
          if cityType == WorldAllianceCityType.MiniGame then
            UIUtil.ShowTipsId("season_s4_spectacle_tips_1")
          elseif cityType == WorldAllianceCityType.GoldTree then
            UIUtil.ShowTipsId("season_s4_spectacle_tips_1")
          elseif cityType == WorldAllianceCityType.CrossZoneOutpostCanon then
            needCloseUI[UIWindowNames.UIWorldOutpostCanonPoint] = nil
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCanonPoint, theCityId, info.mainIndex, info.serverId, info.uuid)
            if seasonType == SeasonMapType.NineNationRainforest then
              UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
            end
          elseif cityType == WorldAllianceCityType.CrossZoneOutpost then
            needCloseUI[UIWindowNames.UIWorldOutpostCityPoint] = nil
            needCloseUI[UIWindowNames.UIWorldLLCityPoint] = nil
            local cityInfo = info.cityInfo
            if seasonType == SeasonMapType.NineNationRainforest and cityInfo ~= nil and cityInfo.DestroyServerId ~= 0 and cityInfo.DestroyAllianceId ~= nil and cityInfo.DestroyAllianceId ~= "" then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCityPoint, theCityId, info.mainIndex, info.serverId, info.uuid)
            elseif seasonType == SeasonMapType.NineNationRainforest and cityInfo ~= nil and cityInfo.LastRepairTime == 0 and cityInfo.BattleStartTime == 0 and cityInfo.ProtectTime == 0 and cityInfo.OwnerServerId == 0 then
              UIUtil.ShowTipsId("s6_outpost_limit_9")
              UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
            elseif DataCenter.LandlordMgr:IsCityWithBoom(theCityId) then
              if UITimeManager:GetInstance():GetServerTime() <= DataCenter.LandlordMgr:GetPreviewBoomTime() then
                local actStartTime = DataCenter.LandlordMgr:GetActStartTime() or 0
                local key = SettingKeys.LANDLORD_CITY_DETAIL_FIRST_SWITCH .. actStartTime
                if not CommonUtil.PlayerPrefsGetBool(key) then
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCityPoint, theCityId, info.mainIndex, info.serverId, info.uuid)
                  TimerManager:GetInstance():DelayInvoke(function()
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldOutpostCityPoint) then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCityPoint, {anim = false}, theCityId, info.mainIndex, info.serverId, info.uuid)
                    end
                  end, 1)
                else
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCityPoint, theCityId, info.mainIndex, info.serverId, info.uuid)
                end
              end
            else
              UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCityPoint, theCityId, info.mainIndex, info.serverId, info.uuid)
            end
          elseif cityType == WorldAllianceCityType.Mountain then
            local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSourceServerId())
            if stageTemp and stageTemp.blood_night_switch then
              needCloseUI[UIWindowNames.UIWorldSiegePointSeason] = nil
              needCloseUI[UIWindowNames.UIWorldSiegePoint] = nil
              UIUtil.ShowWorldSiegePoint(theCityId, info.mainIndex, info.serverId, info.uuid)
            else
              UIUtil.ShowTipsId("season_s4_spectacle_tips_1")
            end
          else
            needCloseUI[UIWindowNames.UIWorldSiegePointSeason] = nil
            needCloseUI[UIWindowNames.UIWorldSiegePoint] = nil
            needCloseUI[UIWindowNames.UIWorldLLCityPoint] = nil
            needCloseUI[UIWindowNames.UIWorldLLCanonPoint] = nil
            UIUtil.ShowWorldSiegePoint(theCityId, info.mainIndex, info.serverId, info.uuid)
          end
        end
      end
    elseif info.PointType == WorldPointType.CITY_ALTAR then
      local cityAltarInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if cityAltarInfo ~= nil then
        needCloseUI[UIWindowNames.UIWorldSiegePointSeason] = nil
        needCloseUI[UIWindowNames.UIWorldSiegePoint] = nil
        UIUtil.ShowWorldSiegePoint(cityAltarInfo.cityId, info.mainIndex, info.serverId, info.uuid)
      else
        UIUtil.ShowTipsId("season_s4_spectacle_tips_1")
      end
    elseif info.PointType == WorldPointType.GOLD_TREE then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if allianceCityPointInfo and curTime > allianceCityPointInfo.startTime then
        if curTime < allianceCityPointInfo.endTime then
          needCloseUI[UIWindowNames.UIWorldSiegePointSeason] = nil
          needCloseUI[UIWindowNames.UIWorldSiegePoint] = nil
          UIUtil.ShowWorldSiegePoint(allianceCityPointInfo.cityId, info.mainIndex, info.serverId, info.uuid)
        else
          UIUtil.ShowTipsId("season_s4_spectacle_tips_2")
        end
      else
        UIUtil.ShowTipsId("season_s4_spectacle_tips_1")
      end
    elseif info.PointType == WorldPointType.TREASURE then
      cast(info, typeof(CS.TreasurePointInfo))
      local pointObject = CS.SceneManager.World:GetObjectByPoint(info.mainIndex)
      if info and info:GetWorldTreasureType() == WorldTreasureType.WolfShadow then
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local uiType = WorldPointUIType.WolfShadow
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = info.uuid .. ";" .. info.mainIndex .. ";;" .. uiType .. ";0;0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, info.uuid, info.mainIndex, "", uiType, 0, 0)
        end
      elseif info ~= nil and pointObject ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local isComplete = info.complete or curTime > info.completionTime
        local worldTreasureType = info:GetWorldTreasureType()
        if worldTreasureType == WorldTreasureType.PlayerKillMonsterTreasure or worldTreasureType == WorldTreasureType.GeneFragment then
          if info.killerId == LuaEntry.Player.uid then
            SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, info.uuid, info.serverId)
            Logger.LogInfo(string.format("ClaimTreasure with killerId %s , %s", tostring(info.uuid), tostring(info.mainIndex)))
          else
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = info.uuid .. ";" .. info.mainIndex .. ";;" .. WorldPointUIType.PlayerKillMonsterTreasure .. ";0;0"
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, "", WorldPointUIType.PlayerKillMonsterTreasure, 0, 0)
            end
          end
        elseif not isComplete then
          if pointObject.CheckInteractAuthority and pointObject:CheckInteractAuthority(info) then
            if worldTreasureType == WorldTreasureType.ActivityRadarTreasure or worldTreasureType == WorldTreasureType.OffSeasonDetect then
              needCloseUI[UIWindowNames.UIWorldActRadarTreasurePoint] = nil
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldActRadarTreasurePoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.pointIndex, "", WorldPointUIType.Treasure, 0)
            else
              needCloseWorldPointUI = false
              needCloseUI[UIWindowNames.UIWorldPoint] = nil
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.pointIndex, "", WorldPointUIType.Treasure, 0)
            end
          elseif worldTreasureType == WorldTreasureType.ActivityRadarTreasure or worldTreasureType == WorldTreasureType.OffSeasonDetect then
            UIUtil.ShowTipsId("activity_wajueji_27000_tips5")
          else
            UIUtil.ShowTipsId("801353")
          end
        elseif worldTreasureType == WorldTreasureType.FlowerTrainCheerTreasure then
          UIUtil.GetDetectTreasureReward(info.mainIndex)
        else
          UIUtil.GetDetectTreasureReward(info.mainIndex)
        end
        if worldTreasureType == WorldTreasureType.GeneFragment then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnGeneFragment, 0, 0.5)
        end
      elseif info ~= nil and info:GetWorldTreasureType() == WorldTreasureType.FlowerTrainCheerTreasure then
        cast(info, typeof(CS.TreasurePointInfo))
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.FlowerTrainReward .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, info.uuid, info.mainIndex, "", WorldPointUIType.FlowerTrainReward, 0)
        end
      end
    elseif info.PointType == WorldPointType.DRAGON_BUILDING then
      local buildInfo = info.detail
      if buildInfo then
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local buildId = buildInfo.BuildId
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.DragonBuild .. ";" .. "0" .. ";" .. buildId
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          do
            local function cb()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, "", WorldPointUIType.DragonBuild, 0, buildId)
            end
            
            local serverId = LuaEntry.Player:GetCurServerId()
            local worldPointPos = SceneUtils.TileIndexToWorld(info.mainIndex) + UIBattlefieldCameraOffset.Desert
            GoToUtil.GotoDragonPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, cb, serverId)
          end
        end
      end
    elseif info.PointType == WorldPointType.DRAGON_SCORE_POINT then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local buildId = 10110
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.DragonBuild .. ";" .. "0" .. ";" .. buildId
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, info.uuid, info.mainIndex, "", WorldPointUIType.DragonBuild, 0, buildId)
      end
    elseif info.PointType == WorldPointType.Other then
      if SeasonUtil.IsInSeasonDesertMode() then
        needCloseWorldPointUI = SeasonUtil.OnClickWorldTile(curIndex, clickType, info, needCloseUI)
      else
        needCloseWorldPointUI = SeasonUtil.OnClickWorldTile(curIndex, clickType, info, needCloseUI)
        EventManager:GetInstance():Broadcast(EventId.OnClickEmpty)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Ground, false)
      end
    elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
      local alMinePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if alMinePointInfo then
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local buildId = alMinePointInfo.buildId
        local buildType = 0
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
        if template ~= nil then
          buildType = toInt(template.type)
        end
        if buildType == AllianceBuildType.StoveCenter or buildType == AllianceBuildType.Carrier or buildType == AllianceBuildType.Attachment or buildType == AllianceBuildType.MilitaryCenter or buildType == AllianceBuildType.MilitaryCenterS4 or WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) or WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) or buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.AllianceBuild .. ";" .. "0" .. ";" .. buildId
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, "", WorldPointUIType.AllianceBuild, 0, buildId)
          end
        elseif WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) then
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.AllianceMine .. ";" .. "0" .. ";" .. buildId
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, "", WorldPointUIType.AllianceMine, 0, buildId)
          end
        elseif WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) then
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.AllianceActMine .. ";" .. "0" .. ";" .. buildId
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, info.uuid, info.mainIndex, "", WorldPointUIType.AllianceActMine, 0, buildId)
          end
        elseif alMinePointInfo.zombieRushInfo then
          local allianceUid = alMinePointInfo.allianceId
          if allianceUid ~= LuaEntry.Player.allianceId then
            UIUtil.ShowTipsId("zombieRush_tips_19")
            return
          end
          local zombieRushInfo = alMinePointInfo.zombieRushInfo
          if zombieRushInfo then
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.ZombieRush .. ";" .. "0" .. ";" .. buildId
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, "", WorldPointUIType.ZombieRush, 0, buildId)
            end
          else
            Logger.LogError("WorldPointInfo \233\135\140\233\157\162\230\178\161\230\156\137\228\184\167\229\176\184\230\148\187\229\159\142\231\154\132\231\155\184\229\133\179\230\149\176\230\141\174")
          end
        end
        if buildType == AllianceBuildType.Outpost then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpost, 0, 0.5)
        end
      end
    elseif info.PointType == WorldPointType.WorldAllianceCollectResource then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.WorldAllianceResourceCollect
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.WorldSuppliesPoint then
      if info:GetType().Name == "WorldSuppliesPoint" then
        cast(info, typeof(CS.WorldSuppliesPoint))
        if info then
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          local uiType = WorldPointUIType.WorldSuppliesPoint
          local configData = LocalController:instance():getLine(TableName.LWIceSupplies, info.configId)
          if configData then
            if configData.type == WorldSuppliesType.ZoneMobilizationType or configData.type == WorldSuppliesType.ZoneMobilizationSmallType then
              uiType = WorldPointUIType.ZoneMobilizationSuppliesPoint
            elseif configData.type == WorldSuppliesType.DarknessSeasonType or configData.type == WorldSuppliesType.DarknessSeasonSmallType then
              uiType = WorldPointUIType.DarknessSuppliesPoint
            end
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, info.uuid, info.mainIndex, "", uiType, 0)
        end
      end
    elseif info.PointType == WorldPointType.CITY_ATTACHMENT_BUILD or info.PointType == WorldPointType.CITY_ATTACHMENT_WALL then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local pointId
      local uiType = WorldPointUIType.CityAttachmentBuild
      if info.PointType == WorldPointType.CITY_ATTACHMENT_WALL then
        local cityId = SceneUtils.GetZoneIdByPosId(info.mainIndex, info.serverId)
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, info.serverId)
        local slotIndex = 0
        if cityMeta and cityMeta.pos and cityMeta.pos.y and cityMeta.pos.x then
          local buildPos = SceneUtils.IndexToTilePos(info.mainIndex, ForceChangeScene.World)
          if buildPos.y > cityMeta.pos.y then
            slotIndex = 3
          elseif buildPos.x > cityMeta.pos.x and buildPos.y < cityMeta.pos.y then
            slotIndex = 2
          elseif buildPos.x < cityMeta.pos.x and buildPos.y < cityMeta.pos.y then
            slotIndex = 1
          end
        end
        local cfg = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(cityId)
        if cfg then
          if slotIndex == 0 then
            slotIndex = cfg:GetSlotIdByBuildPos(info.mainIndex)
          end
          pointId = cfg:GetBuildPosBySlot(slotIndex)
        end
        local tmp = CS.SceneManager.World:GetPointInfo(pointId or info.mainIndex)
        if tmp == nil or info.PointType ~= WorldPointType.CITY_ATTACHMENT_BUILD then
          pointId = nil
        end
      elseif info.PointType == WorldPointType.CITY_ATTACHMENT_BUILD then
        pointId = info.mainIndex
      end
      if pointId then
        do
          local uuid = info.uuid
          local focusPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
          GoToUtil.GotoWorldPos(focusPos, CS.SceneManager.World.Zoom, 0.12, function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, uuid, pointId, "", uiType, 0)
          end, LuaEntry.Player:GetCurServerId())
        end
      end
    elseif info.PointType == WorldPointType.RadarSeasonSnowSurvivor then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.WorldDetectSurvivor
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.CAVE_EXPLORATION then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.WorldDetectCaveExploration
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
      UIUtil.CheckEventTrigger(OpMode.ClickBtnDesertCity)
    elseif info.PointType == WorldPointType.WINTER_ENTITY then
      local buildInfo = info.detail
      if buildInfo then
        do
          local flag = true
          local buildId = buildInfo.BuildId
          local template = DataCenter.WinterStormTemplateManager:GetTemplate(buildId)
          if flag then
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            do
              local function cb()
                if not DataCenter.ActWinterStormManager:BattleOpenCheck(true) then
                  return
                end
                if buildInfo.State == WinterEntityState.Fixing then
                  UIUtil.ShowTipsId(458279)
                  return
                end
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                  local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.WinterEntity .. ";" .. "0" .. ";" .. buildId
                  EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
                else
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                    anim = true,
                    playEffect = false,
                    UIMainAnim = UIMainAnimType.LeftRightBottomHide
                  }, info.uuid, info.mainIndex, "", WorldPointUIType.WinterEntity, 0, buildId)
                end
              end
              
              local serverId = LuaEntry.Player:GetCurServerId()
              local worldPointPos = SceneUtils.TileIndexToWorld(info.mainIndex) + UIBattlefieldCameraOffset.Winter
              GoToUtil.GotoDragonPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, cb, serverId)
            end
          end
        end
      end
    elseif info.PointType == WorldPointType.BATTLEFIELD_BUILD then
      local buildInfo = info.detail
      local _bTemplate
      if buildInfo then
        do
          local buildId = buildInfo.BuildId
          local _bTemplate = BattleFieldUtil.GetBattlefieldBuildTemplate(buildId)
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          
          local function cb()
            if not BattleFieldUtil.BuildOpenCheckWithTime(buildInfo.OpenTime) then
              return
            end
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
              local str = info.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.EpidemicBuild .. ";" .. "0" .. ";" .. buildId
              EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, info.uuid, info.mainIndex, "", WorldPointUIType.EpidemicBuild, 0, buildId)
            end
          end
          
          if _bTemplate and _bTemplate:IsScoreBox() then
            cb()
          else
            do
              local serverId = LuaEntry.Player:GetCurServerId()
              local worldPointPos = SceneUtils.TileIndexToWorld(info.mainIndex) + UIBattlefieldCameraOffset.Epidemic
              GoToUtil.GotoDragonPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, cb, serverId)
            end
          end
        end
      end
    elseif info.PointType == WorldPointType.RADAR_DOMINATOR_GUIDE or info.PointType == WorldPointType.RADAR_DOMINATOR_CURE then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DominatorGuide
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.SURPRISE_POINT then
      local mainInfo = CS.SceneManager.World:GetPointInfo(info.mainIndex)
      if not DataCenter.SurprisePointManager:ClickSurprisePoint(mainInfo) then
        needCloseWorldPointUI = SeasonUtil.OnClickWorldTile(info.mainIndex, clickType, mainInfo, needCloseUI)
        UIUtil.CheckEventTrigger(OpMode.ClickBtnGetEasterEgg)
      end
    elseif info.PointType == WorldPointType.WORLD_RUIN_DESTROY_BUILDING then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = info.uuid .. ";" .. info.mainIndex .. ";" .. info.ownerUid .. ";" .. WorldPointUIType.WorldRuinDestroyBuilding .. ";" .. "0" .. ";" .. BuildingTypes.LW_CITY_RUIN
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.WorldRuinDestroyBuilding, 0, BuildingTypes.LW_CITY_RUIN)
      end
    elseif info.PointType == WorldPointType.ZONE_MOBILIZATION then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Kirov_reporting, false)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.ZoneMobilization
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.MONSETER_CHALLENGE_NEW_TREASURE then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if info.treasurePointInfo and info.treasurePointInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
        local uiType = WorldPointUIType.KillZombieKirovBox
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, info.uuid, info.mainIndex, "", uiType, 0)
      else
        UIUtil.ShowTipsId("challenge_zombie_reward_other_server")
      end
    elseif info.PointType == WorldPointType.ACTIVITY_WORLD_TREASURE then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.ChangeAllShow
      }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.WorldActivityTreasure, 0)
    elseif info.PointType == WorldPointType.TreasureChest then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local treasureChestData = CS.SceneManager.World:GetSamplePointInfoByIndex(info.mainIndex)
      local uiType = WorldPointUIType.Barricade
      if treasureChestData and treasureChestData.ownerUid and treasureChestData.ownerUid == LuaEntry.Player.uid then
        uiType = WorldPointUIType.TreasureChest
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.ChangeAllShow
      }, info.uuid, info.mainIndex, info.ownerUid, uiType, 0)
    elseif info.PointType == WorldPointType.SkyBattle then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local skyBattleData = CS.SceneManager.World:GetSamplePointInfoByIndex(info.mainIndex)
      local uiType = WorldPointUIType.Barricade
      if skyBattleData and skyBattleData.ownerUid and skyBattleData.ownerUid == LuaEntry.Player.uid then
        uiType = WorldPointUIType.SkyBattle
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.ChangeAllShow
      }, info.uuid, info.mainIndex, info.ownerUid, uiType, 0)
    elseif info.PointType == WorldPointType.DETECT_DIG_GAME then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DetectEventDigGame
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.DETECT_LAST_STAND then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DetectEventLastStand
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.DETECT_RETRY_TASK then
      local data = CS.SceneManager.World:GetDetectRetryTaskPointInfo(info.pointIndex)
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      if data.ownerUid ~= LuaEntry.Player.uid then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = data.uuid .. ";" .. info.pointIndex .. ";" .. data.ownerUid .. ";" .. WorldPointUIType.Barricade .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, data.uuid, info.pointIndex, data.ownerUid, WorldPointUIType.Barricade, 0)
        end
      elseif config.type == DetectEventType.COLLECT_TASK or config.type == DetectEventType.OFF_SEASON_COLLECT_TASK then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = data.uuid .. ";" .. info.pointIndex .. ";" .. data.ownerUid .. ";" .. WorldPointUIType.DetectRetryResource .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, data.uuid, info.pointIndex, data.ownerUid, WorldPointUIType.DetectRetryResource, 0)
        end
      elseif config.type == DetectEventType.RESCUE_TASK or config.type == DetectEventType.OFF_SEASON_RESCUE_TASK then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = data.uuid .. ";" .. info.pointIndex .. ";" .. data.ownerUid .. ";" .. WorldPointUIType.DetectRetryRescue .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, data.uuid, info.pointIndex, data.ownerUid, WorldPointUIType.DetectRetryRescue, 0)
        end
      end
    elseif info.PointType == WorldPointType.DETECT_ALLIANCE_CITY_SCOUT_MONSTER then
      local data = CS.SceneManager.World:GetDetectAttackCityS0TaskPointInfo(info.pointIndex)
      if data and not string.IsNullOrEmpty(data.eventId) then
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
        if config.type == DetectEventType.AttackCityS0_City_Monster then
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            local str = data.uuid .. ";" .. info.pointIndex .. ";" .. LuaEntry.Player.uid .. ";" .. WorldPointUIType.DetectAttackCityS0Monster .. ";" .. "0" .. ";" .. "0"
            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, data.uuid, info.pointIndex, LuaEntry.Player.uid, WorldPointUIType.DetectAttackCityS0Monster, 0)
          end
        end
      end
    elseif info.PointType == WorldPointType.DETECT_SUPPLIES_SEARCH then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DetectEventSuppliesSearch
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_1 then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DominatorCockatriceUnlock_1
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.RADAR_DOMINATOR__COCKATRICE_UNLOCK_2 then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      local uiType = WorldPointUIType.DominatorCockatriceUnlock_2
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", uiType, 0)
    elseif info.PointType == WorldPointType.ALLIANCE_BOSS_S0 then
      local buildPointInfo = info.buildPointInfo
      if buildPointInfo then
        local startTime = buildPointInfo.startTime
        if startTime > 0 then
          needCloseWorldPointUI = false
          needCloseUI[UIWindowNames.UIWorldPoint] = nil
          local uiType = WorldPointUIType.S0AllianceDrillBuilding
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, info.uuid, info.mainIndex, "", uiType, 0)
        else
          UIUtil.ShowTipsId("s0_alliance_boss_end_tips")
          return
        end
      end
    end
  else
    needCloseWorldPointUI = SeasonUtil.OnClickWorldTile(curIndex, clickType, info, needCloseUI)
    EventManager:GetInstance():Broadcast(EventId.OnClickEmpty)
  end
  UIUtil.OnClickWorldPostProcess(needCloseWorldPointUI, needCloseZoneEffect, needCloseUI, needCloseIsFocus)
  if GMUtils.GetBool(GMConst.DebugClickLogWarning, false) and info and info.Description then
    local desc = info:Description() or "NULL"
    desc = string.format("ccc:%s", desc)
    Logger.LogWarning(desc)
  end
end

local function OnClickWorldPostProcess(needCloseWorldPointUI, needCloseZoneEffect, needCloseUI, needCloseIsFocus)
  if needCloseWorldPointUI == true and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
  end
  if needCloseZoneEffect then
    DataCenter.BuildZoneManager:RemoveAll()
  end
  for k, v in pairs(needCloseUI) do
    if v then
      if (k == UIWindowNames.UIFormationSelectListNew or k == UIWindowNames.UIFormationSelectListV2) and UIManager:GetInstance():IsWindowOpen(k) then
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      end
      UIManager:GetInstance():DestroyWindow(k)
    end
  end
  if needCloseIsFocus and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoveCity) then
    CS.SceneManager.World:QuitFocus(LookAtFocusTime)
  end
end

local function CloseWorldMarchTileUI(uuid)
  if uuid ~= nil then
    WorldMarchTileUIManager:GetInstance():RemoveTroopByUuid(uuid)
  else
    WorldMarchTileUIManager:GetInstance():RemoveTroop()
  end
end

local function OnClickCity(curIndex, clickType)
  if GMUtils.GetBool(GMConst.DebugClickLogWarning, false) then
    DataCenter.LandLockManager:DebugClick(curIndex)
  end
  if DataCenter.GuideManager:GetGuideType() == GuideType.Bubble then
    return
  end
  if DataCenter.CityPioneerManager:IsBeforePrologue() then
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoInput) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISceneNoInput) then
    return
  end
  for _, blocker in ipairs(UIManager:GetInstance().interationBlockers) do
    if not IsNull(blocker) and not IsNull(blocker.gameobject) and blocker.gameobject.activeSelf == true then
      return
    end
  end
  local needChangeCamera = UIUtil.CheckNeedQuitFocus()
  UIUtil.ClickWorldCloseWorldUI()
  local needCloseIsFocus = true
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHide)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  EventManager:GetInstance():Broadcast(EventId.DestroyLandLockBubbleStateHide)
  EventManager:GetInstance():Broadcast(EventId.DestroyMonsterLockBubbleStateHide)
  EventManager:GetInstance():Broadcast(EventId.ClickAny)
  DataCenter.GuidePickGarbageBubbleManager:HideGarbageClickEffect()
  local needCloseUI = {}
  for k, v in ipairs(ClickUINeedCloseExtraWorldUI) do
    needCloseUI[v] = true
  end
  local needCloseGotoMoveBubble = true
  local needCloseWorldPointUI = true
  local needCloseZoneEffect = true
  EventManager:GetInstance():Broadcast(EventId.OnClickWorld, curIndex)
  EventManager:GetInstance():Broadcast(EventId.HideCityTroopHead)
  local type = DataCenter.CityPointManager:GetPointType(curIndex)
  if clickType == ClickWorldType.Collider then
    if type ~= CityPointType.Other then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
    end
  elseif clickType == ClickWorldType.Ground then
    WorldMarchTileUIManager:GetInstance():RemoveTroop()
  end
  if type == CityPointType.Building then
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(curIndex)
    if buildData ~= nil and GMUtils.GetBool(GMConst.DebugClickLogWarning, false) then
      local sb = StringBuilder.New()
      sb:Append("ccc:")
      sb:AppendFormatLine("<color=#FFFF00>-----City.Building----</color>")
      sb:AppendFormatLine("pointId:%s", buildData.pointId)
      sb:AppendFormatLine("level:%s", buildData.level)
      sb:AppendFormatLine("itemId:%s", buildData.itemId)
      sb:AppendFormatLine("uuid:%s", buildData.uuid)
      Logger.LogWarning(sb:ToString())
    end
    if buildData ~= nil and buildData.itemId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildData.itemId ~= BuildingTypes.WORM_HOLE_CROSS then
      if buildData.itemId == BuildingTypes.LW_BUILD_TREASURE_CHEST then
        return
      end
      if buildData.uuid ~= nil and CS.CommonUtils.IsDebug() then
        Logger.Log("build uuid = " .. buildData.uuid)
      end
      local isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
      if isFinish == true then
        local buildId = buildData.itemId
        local bUuid = buildData.uuid
        if DataCenter.RecommendShowManager:IsCanClickBuild(buildId, buildData) then
          do
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
            if buildData.level == 0 then
              local unlock = DataCenter.LWOpeningStageManager:IsAllDone()
              if unlock then
                if buildTemplate:CheckQuestConditionStatus(buildData, true, false, 0.01, false) then
                  return
                end
                if buildTemplate.id == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
                elseif buildTemplate.id == BuildingTypes.LW_BUILD_DISPATCH_TASK then
                elseif buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceGift)
                elseif buildData.itemId == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR then
                  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
                  if not isOpen then
                    local monthCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.MonthCard)
                    if monthCardTag then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
                    end
                  else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
                  end
                elseif buildData.itemId == BuildingTypes.LW_BUILD_PARKINGLOT_TWO or buildData.itemId == BuildingTypes.LW_BUILD_PARKINGLOT_THREE then
                  local needMaxLevelStr = LuaEntry.DataConfig:TryGetStr("guide_opt", "k5", 0)
                  if needMaxLevelStr then
                    local arr = string_split(needMaxLevelStr, ";")
                    if arr and 0 < #arr then
                      local itemId = buildData.itemId
                      local index = 1
                      if itemId == BuildingTypes.LW_BUILD_PARKINGLOT_THREE and 1 < #arr then
                        index = 2
                      end
                      if DataCenter.BuildManager:GetMainLevel() >= tonumber(arr[index]) and buildData.updateTime == 0 then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
                      end
                    end
                  end
                elseif buildData.itemId == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
                  DataCenter.BuildHeroCountdownManager:TryFixHero(buildData.uuid)
                elseif buildData.updateTime == 0 then
                  local isInCity = SceneUtils.GetIsInCity()
                  if isInCity and SeasonUtil.IsMummyYardBuilding(buildData.itemId) then
                    if SeasonUtil.IsInSeason() then
                      SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain, {anim = true})
                    elseif UIUtil.CheckEventTrigger(OpMode.ClickBtnMummyYardOffSeason) then
                    else
                      local msg = Localization:GetString("season_s3_building_tips01")
                      UIUtil.ShowMessage(msg, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                        Logger.Log("try open 787000")
                      end)
                    end
                  elseif isInCity and BuildingUtils.IsSeasonWeekCardCityBuilding(buildData.itemId) then
                    local flag = true
                    local actWeek = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonPeriodicCard.Type)
                    if actWeek ~= nil and actWeek.endTime ~= nil then
                      local now = UITimeManager:GetInstance():GetServerTime()
                      if now < actWeek.endTime then
                        local cardId = toInt(actWeek.para)
                        local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
                        if cardData and cardData:IsBought() then
                          flag = false
                        end
                      else
                        flag = false
                      end
                    end
                    if flag then
                      GoToUtil.GotoSeasonWeekCardView()
                    else
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
                    end
                  elseif buildData and buildData.uuid then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
                  end
                end
              elseif buildTemplate.id == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD or buildTemplate.id == BuildingTypes.LW_BUILD_FLAG then
              else
                UIUtil.ShowTipsId(800372)
              end
            else
              if buildTemplate.zoneMainType == BuildZoneMainType.Main then
                DataCenter.BuildZoneManager:ShowZoneEffect(bUuid, buildId)
                needCloseZoneEffect = false
              end
              local recommendParam = DataCenter.RecommendShowManager:CheckClickBuild(buildId)
              if buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
                if buildData.unavailableTime == 0 then
                  local now = UITimeManager:GetInstance():GetServerTime()
                  if now < buildData.produceEndTime and buildData.produceEndTime > buildData.lastCollectTime then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIResourceCost) then
                      EventManager:GetInstance():Broadcast(EventId.UIResourceCostChangeState, bUuid)
                    else
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceCost, bUuid)
                    end
                    needCloseUI[UIWindowNames.UIResourceCost] = nil
                  end
                end
              elseif buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
                DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ground, false)
                local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
                if queueData ~= nil then
                  local onComplete
                  local state = queueData:GetQueueState()
                  local originalPos = SceneUtils.TileIndexToWorld(buildData.pointId)
                  local pos, needMove = UIUtil.ClickFarmAdjustPos(originalPos, FarmAdjust)
                  local alreadyShowUI = false
                  if state == NewQueueState.Finish then
                    needCloseUI[UIWindowNames.UIFarmGather] = nil
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmGather) then
                      alreadyShowUI = true
                      EventManager:GetInstance():Broadcast(EventId.RefreshFarmGatherUI, bUuid)
                    else
                      function onComplete()
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
                          anim = true,
                          
                          playEffect = false,
                          UIMainAnim = UIMainAnimType.LeftRightBottomHide
                        }, bUuid)
                      end
                    end
                  elseif state == NewQueueState.Free then
                    needCloseUI[UIWindowNames.UIFarm] = nil
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarm) then
                      alreadyShowUI = true
                      EventManager:GetInstance():Broadcast(EventId.RefreshFarmUI, bUuid)
                    else
                      function onComplete()
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
                          anim = true,
                          
                          playEffect = false,
                          UIMainAnim = UIMainAnimType.LeftRightBottomHide
                        }, bUuid)
                      end
                    end
                  elseif state == NewQueueState.Work then
                    local signal = SFSObject.New()
                    signal:PutLong("bUuid", bUuid)
                    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, bUuid)
                  end
                  needCloseIsFocus = false
                  WorldArrowManager:GetInstance():RemoveEffect()
                  if recommendParam ~= nil and alreadyShowUI == false then
                    local movePos = recommendParam.focusPos
                    if movePos == nil then
                      movePos = originalPos
                    end
                    CS.SceneManager.World:AutoFocus(movePos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                  elseif needMove == true and alreadyShowUI == false then
                    if state == NewQueueState.Work then
                      local signal = SFSObject.New()
                      signal:PutLong("bUuid", bUuid)
                      EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                      EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, bUuid)
                    else
                      CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                    end
                  else
                    CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, false, false, onComplete)
                  end
                end
              elseif buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                if buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_OstrichFarm, false)
                elseif buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CattleFarm, false)
                elseif buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CattleFarm, false)
                end
                local signal = SFSObject.New()
                signal:PutLong("bUuid", bUuid)
                local originalPos = SceneUtils.TileIndexToWorld(buildData.pointId)
                local pos, needMove = UIUtil.ClickFarmAdjustPos(originalPos, PastureAdjust)
                EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
                
                local function onComplete()
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
                    anim = true,
                    playEffect = false,
                    UIMainAnim = UIMainAnimType.LeftRightBottomHide
                  }, bUuid)
                end
                
                needCloseIsFocus = false
                if recommendParam ~= nil then
                  CS.SceneManager.World:AutoFocus(originalPos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, false, onComplete)
                elseif needMove == true then
                  CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
                else
                  CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, false, true, onComplete)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
                UIUtil.CheckAndOpenBusinessCenter()
              elseif buildId == BuildingTypes.LW_BUILD_BLACKMARKET then
                local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.BlackMarket.Type)
                if actId and 0 < tonumber(actId) then
                  GoToUtil.GoActWindow({actId})
                else
                  UIUtil.ShowTipsId("blackmarket_tips2")
                end
                return
              end
              if (buildTemplate.build_type ~= BuildType.Second or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_MAIN or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_SUB) and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_OSTRICH and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_CATTLE and buildTemplate.id ~= BuildingTypes.APS_BUILD_PASTURE_SANDWORM and buildTemplate.id ~= BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
                needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                if buildTemplate.id == BuildingTypes.FUN_BUILD_CONDOMINIUM then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_LIBRARY, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOODSHOP then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_FoodFactory, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Bakery, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD_2 then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Click_TuckerStore, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FOOD_1 then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Bar, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_PVE_FACTORY then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_JewelryStore, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_FACTORY_STONE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Factory, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_OIL_REFINERY then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Factory, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_MAIN then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Main_City, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_BARRACKS then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_BARRACKS, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_CAR_BARRACK, false)
                elseif buildTemplate.id == BuildingTypes.APS_BUILD_PUB then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Hero_Build, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_INFANTRY_BARRACK, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_AIRCRAFT_BARRACK, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_POLICE_STATION then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_POLICE_STATION, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_RADAR_CENTER then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Radar, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_DRONE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_DRONE, false)
                elseif buildTemplate.id == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_ALLIANCE_CENTER, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_LIBRARY then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Apartment, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_COLD_STORAGE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_COLD_STORAGE, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_KONBINI then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_KONBINI, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_SCIENE, false)
                elseif buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Build, false)
                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_1 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_2 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_3 or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_TRAINFIELD, false)
                else
                  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Building, false)
                end
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                  local isOpen = LuaEntry.DataConfig:CheckSwitch("factory_button")
                  if DataCenter.BuildManager:IsFactoryBuild(buildTemplate.id) and not isOpen then
                    if DataCenter.FactoryDataManager:HasUnlockItemByBuildId(buildTemplate.id) then
                      WorldArrowManager:GetInstance():RemoveEffect()
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, bUuid)
                    end
                  else
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(curIndex))
                  end
                elseif buildTemplate.id ~= BuildingTypes.APS_BUILD_FARM_FIELD then
                  local isOpen = LuaEntry.DataConfig:CheckSwitch("factory_button")
                  if DataCenter.BuildManager:IsFactoryBuild(buildTemplate.id) and not isOpen then
                    if DataCenter.FactoryDataManager:HasUnlockItemByBuildId(buildTemplate.id) then
                      WorldArrowManager:GetInstance():RemoveEffect()
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, bUuid)
                    end
                  elseif buildTemplate.id == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR then
                    if not DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
                      if 0 < DataCenter.BuildManager.MainLv then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
                      end
                    else
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
                        anim = true,
                        playEffect = false,
                        UIMainAnim = UIMainAnimType.LeftRightBottomHide
                      }, tostring(curIndex), needChangeCamera)
                    end
                  elseif buildTemplate.id == BuildingTypes.LW_BUILD_TALENT_HALL then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true})
                  elseif buildTemplate.id == BuildingTypes.LW_BUILD_HERO then
                    DataCenter.BuildHeroManager:ShowHeroInfo(curIndex)
                  elseif buildTemplate.id == BuildingTypes.LW_FIRST_PAY then
                    EventManager:GetInstance():Broadcast(EventId.ShowFirstPayUI)
                  elseif buildTemplate.id == BuildingTypes.LW_MO_FIE_HERO then
                    local lotteryId = DataCenter.LotteryDataManager:GetBuildBubbleGotoLotteryId()
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, lotteryId)
                  elseif buildTemplate.id == BuildingTypes.LW_GIFT_PACKAGE then
                    local packId = buildTemplate.para1
                    local packValid = GiftPackageData.checkPackIsValid(packId)
                    if packValid then
                      local result, rechargeType, rechargeId = GiftPackageData.CheckIfIsPopupPackage(packId)
                      if result then
                        GiftPackageData.TryShowPopupPackage(pack, rechargeType, rechargeId)
                      else
                        local res, entryType, rechId = GiftPackageData.CheckPackageEntryType(packId)
                        if res and entryType == RechargeEntryType.DailySale then
                          GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
                            anim = false,
                            UIMainAnim = UIMainAnimType.AllHide
                          }, nil, rechId, nil)
                        end
                      end
                    end
                  elseif buildTemplate.id == BuildingTypes.LW_BUILD_TREASURE_CHEST_1 or buildTemplate.id == BuildingTypes.LW_BUILD_TREASURE_CHEST_2 or buildTemplate.id == BuildingTypes.LW_BUILD_TREASURE_CHEST_3 or buildTemplate.id == BuildingTypes.LW_BUILD_TREASURE_CHEST_4 then
                    local treasureChestId = 0
                    local extendInfo = string.format("%d", buildData.itemId)
                    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
                    if template and not string.IsNullOrEmpty(template.para1) then
                      treasureChestId = tonumber(template.para1) or 0
                    end
                    if 0 < treasureChestId then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureChest, {anim = false}, treasureChestId, extendInfo)
                    end
                  elseif buildTemplate.id == BuildingTypes.LW_BUILD_SKY_BATTLE_1 or buildTemplate.id == BuildingTypes.LW_BUILD_SKY_BATTLE_2 or buildTemplate.id == BuildingTypes.LW_BUILD_SKY_BATTLE_3 or buildTemplate.id == BuildingTypes.LW_BUILD_SKY_BATTLE_4 then
                    local levelId = 0
                    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
                    if template and not string.IsNullOrEmpty(template.para1) then
                      levelId = tonumber(template.para1) or 0
                    end
                    if 0 < levelId then
                      local battleParam = {}
                      battleParam.type = PVEType.SkyBattle
                      battleParam.enterType = PVEEnterType.CityBuilding
                      battleParam.levelId = levelId
                      DataCenter.LWBattleManager:Enter(battleParam)
                    end
                  else
                    if buildTemplate.id == BuildingTypes.LW_BUILD_WORKER_HOUSE then
                      if DataCenter.LWOpeningStageManager:IsAllDone() then
                      else
                        return
                      end
                    elseif buildTemplate.id == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
                      DataCenter.BuildHeroCountdownManager:TryFixHero(buildData.uuid)
                      return
                    end
                    local info = DataCenter.BuildManager:GetBuildingDataByPointId(curIndex)
                    if info.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
                      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
                      if DataCenter.GainWorkerManager:GetIsHavePveWorker() then
                        DataCenter.GainWorkerManager:ShowAllWorkers()
                      elseif buildData.level >= 3 then
                        UIUtil.OpenDetectEventView()
                      end
                    elseif info.itemId == BuildingTypes.LW_BUILD_SHOP then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
                    elseif info.itemId == BuildingTypes.LW_BUILD_RAILWAY_STATION then
                      RailwayUtil.ClickTrainStation()
                    elseif info.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_1 or info.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_2 or info.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_3 or info.itemId == BuildingTypes.LW_BUILD_TRUCK_STATION_4 then
                      RailwayUtil.ClickTruckStation(info)
                    elseif info.itemId == BuildingTypes.LW_BUILD_WORLDTREND then
                      local key = DataCenter.LWWorldTrendDataManager:GetCurEventDataKey()
                      if key then
                        local isFrist = CommonUtil.PlayerPrefsGetBool(key, false)
                        if not isFrist then
                          CommonUtil.PlayerPrefsSetBool(key, true)
                          EventManager:GetInstance():Broadcast(EventId.WorldTrendEventDataUpdate)
                        end
                      end
                      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldTrend)
                    elseif info.itemId == BuildingTypes.LW_BUILD_COUNT_BATTLE then
                      DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(TrailTowerTabType.None)
                    elseif info.itemId == BuildingTypes.LW_DECORATION_EXHIBITION then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook)
                    elseif buildTemplate.id == BuildingTypes.LW_BUILD_ACTIVITY_ALARM_CLOCK then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActivityAlarmClock, {anim = true})
                    elseif buildTemplate.id == BuildingTypes.LW_BUILD_DIG_GAME then
                      DataCenter.BuildingDigTreasureManager:OpenGameWindowByBuildingUuid(buildData.uuid)
                    elseif buildTemplate.id == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_1 or buildTemplate.id == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_2 or buildTemplate.id == BuildingTypes.LW_BUILD_SUPPLIES_SEARCH_3 then
                      DataCenter.SuppliesSearchManager:OpenSuppliesSearchWindow(SuppliesSearchType.Monopoly, buildData.uuid)
                    elseif buildTemplate.id == BuildingTypes.LW_BUILD_RACE_ENTRANCE then
                      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRaceEntrance)
                    else
                      local isB = LuaEntry.DataConfig:CheckSwitch("ABtest_chapter_1") and LuaEntry.Player.abTest == ABTestType.B
                      local mainLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.FUN_BUILD_MAIN)
                      if 1 <= mainLevel or not isB then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
                          anim = true,
                          playEffect = false,
                          UIMainAnim = UIMainAnimType.LeftRightBottomHide
                        }, tostring(curIndex), needChangeCamera)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  elseif type == CityPointType.Garbage then
    if Data.Fog:IsUnlock(curIndex) then
      local worldPointPos = SceneUtils.TileIndexToWorld(curIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
      local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(curIndex)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_GroundGoods, false)
      needCloseGotoMoveBubble = false
      if pointData ~= nil then
        DataCenter.GuidePickGarbageBubbleManager:ShowGarbageClickEffect(curIndex)
        if DataCenter.GuideManager.currentGetRewardGarbage == pointData.uuid then
          return
        end
        needCloseWorldPointUI = false
        needCloseUI[UIWindowNames.UIWorldPoint] = nil
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
          local str = pointData.uuid .. ";" .. curIndex .. ";" .. "" .. ";" .. WorldPointUIType.SingleMapGarbage .. ";" .. "0" .. ";" .. "0"
          EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, pointData.uuid, curIndex, "", WorldPointUIType.SingleMapGarbage, 0)
        end
        GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, LuaEntry.Player:GetCurServerId())
      else
        DataCenter.GotoMoveBubbleManager:ShowUI(curIndex)
      end
    end
  elseif type == CityPointType.Fog then
  elseif type == CityPointType.Monster then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Enemy1, false)
    local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(curIndex)
    if pointData ~= nil then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = pointData.uuid .. ";" .. pointData.pointId .. ";" .. "" .. ";" .. WorldPointUIType.Monster .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, pointData.uuid, pointData.pointId, "", WorldPointUIType.Monster, 0)
      end
    end
  elseif type == CityPointType.MonsterReward then
    local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(curIndex)
    if pointData ~= nil then
      local uuid = pointData.uuid
      local rewardData = pointData.rewardList
      if rewardData ~= nil then
        local param = {}
        param.monsterReward = true
        DataCenter.GuideManager:SetCompleteNeedParam(param)
        DataCenter.GuideManager:CheckGuideComplete()
        local isFull = false
        local totalNum = 0
        local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(rewardData)
        if rewardList ~= nil then
          table.walk(rewardList, function(k, v)
            if isFull == false and v.rewardType == RewardType.RESOURCE_ITEM then
              totalNum = totalNum + v.count
              if DataCenter.ResourceItemDataManager:CheckIsStorageFull(totalNum) then
                isFull = true
              end
            end
          end)
        end
        if isFull then
          if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
            DataCenter.GuideManager:SetGuideEndCallBack(function()
              GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
            end)
          else
            GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
          end
        elseif DataCenter.BuildManager:CheckIsSendMessage(uuid) == false then
          EventManager:GetInstance():Broadcast(EventId.ShowCapacity)
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
          if pointData ~= nil then
            local arr = string.split(pointData.itemId, ";")
            if 0 < #arr then
              DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.MonsterGetReward, arr[1])
            end
          end
          DataCenter.BuildManager:DelayClearSendList(uuid)
        end
      end
    end
  elseif type == CityPointType.GarbageReward then
    local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(curIndex)
    if pointData ~= nil then
      local uuid = pointData.uuid
      local rewardData = pointData.rewardList
      if rewardData ~= nil then
        local isFull = false
        local totalNum = 0
        local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(rewardData)
        if rewardList ~= nil then
          table.walk(rewardList, function(k, v)
            if isFull == false and v.rewardType == RewardType.RESOURCE_ITEM then
              totalNum = totalNum + v.count
              if DataCenter.ResourceItemDataManager:CheckIsStorageFull(totalNum) then
                isFull = true
              end
            end
          end)
        end
        if isFull then
          if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
            DataCenter.GuideManager:SetGuideEndCallBack(function()
              GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
            end)
          else
            GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
          end
        elseif DataCenter.BuildManager:CheckIsSendMessage(uuid) == false then
          SFSNetwork.SendMessage(MsgDefines.ReceiveCityGarbageReward, uuid)
          DataCenter.BuildManager:DelayClearSendList(uuid)
        end
      end
    end
  elseif type == CityPointType.Collect then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_GroundGoods, false)
    local pointData = DataCenter.CollectResourceManager:GetResourcePointInfoByIndex(curIndex)
    if pointData ~= nil then
      needCloseWorldPointUI = false
      needCloseUI[UIWindowNames.UIWorldPoint] = nil
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
        local str = "0" .. ";" .. pointData:GetPointId() .. ";" .. "" .. ";" .. WorldPointUIType.CityResPoint .. ";" .. "0" .. ";" .. "0"
        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, 0, pointData:GetPointId(), "", WorldPointUIType.CityResPoint, 0)
      end
      local param = {}
      param.collectType = pointData.resourceType
      DataCenter.GuideManager:SetCompleteNeedParam(param)
      DataCenter.GuideManager:CheckGuideComplete()
    end
  else
    if type == CityPointType.Other then
      EventManager:GetInstance():Broadcast(EventId.OnClickEmpty)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Ground, false)
    else
    end
  end
  if needCloseGotoMoveBubble then
    DataCenter.GotoMoveBubbleManager:RemoveUI()
  end
  if needCloseZoneEffect then
    DataCenter.BuildZoneManager:RemoveAll()
  end
  if needCloseWorldPointUI == true then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
    end
    DataCenter.BuildZoneManager:RemoveAll()
  end
  for k, v in pairs(needCloseUI) do
    if v then
      if DataCenter.GuideManager:IsCanCloseUI(k) then
        if k == "UIFingerArrow" then
          local param = DataCenter.ArrowManager:GetFingerArrowParam()
          if not param or param.id ~= param.guidId then
            UIManager:GetInstance():DestroyWindow(k)
          end
        else
          UIManager:GetInstance():DestroyWindow(k)
        end
      else
        needCloseIsFocus = false
      end
    end
  end
  if needCloseIsFocus and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoveCity) then
    CS.SceneManager.World:QuitFocus(LookAtFocusTime)
  end
end

local function ShowUseDiamondConfirm(todayType, tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName)
  local needShowConfirm = LuaEntry.Player:GetUserSetting(UserSettingKey.DIAMOND_USAGE_REMINDER) == "1"
  if needShowConfirm == true and DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
    UIUtil.ShowSecondMessage(titleText, tipText, btnNum, text1, text2, function()
      action1()
    end, function(needSellConfirm)
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(todayType, needSellConfirm)
    end, action2, closeAction, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), btnNoUseDialog, leftBtnPicName, rightBtnPicName)
  else
    action1()
  end
end

function UIUtil.OnClickCollider(pointIndex, buildId, identify)
  if pointIndex == nil or buildId == nil then
    return
  end
  if identify == "WorldOutpostBubble" then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    if DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(buildId, mySourceServerId) then
      local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
      if actData ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonOutpostAttackS6, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        })
        return
      end
    end
    UIUtil.ShowTipsId("s6_outpost_limit_9")
    UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
  elseif buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 2)
  end
end

function UIUtil.ShowUserPrompt(param)
  if param then
    if param.todayNotShown then
      local cnt = UIUtil.GetTodayActiveCount(param.todayNotShown, false)
      if 0 < cnt then
        if param.funConfirm ~= nil and type(param.funConfirm) == "function" then
          CommonUtil.ProtectCall(function()
            param.funConfirm()
          end)
        end
        return
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWUserPrompt, {anim = true, hideTop = false}, param)
  end
end

local function TryShowConfirm(todayType, tipText, btnNum, textConfirm, textCancel, actionConfirm, actionCancel, closeAction, titleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName)
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
    UIUtil.ShowSecondMessage(titleText, tipText, btnNum, textConfirm, textCancel, function()
      actionConfirm()
      Logger.Log("TryShowConfirm " .. todayType)
    end, function(needSellConfirm)
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(todayType, needSellConfirm)
      Logger.Log("TodayNoShow " .. todayType)
    end, actionCancel, closeAction, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), btnNoUseDialog, leftBtnPicName, rightBtnPicName)
  else
    actionConfirm()
    Logger.Log("AutoConfirm " .. todayType)
  end
end

local function TryShowConfirmParams(todayType, contentText, btnNum, confirmText, cancelText, confirmAction, cancelAction, closeAction, titleText, notUseDialog, confirmPicPath, cancelPicPath, btnType)
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
    local param = {
      title = titleText,
      contentText = contentText,
      btnNum = btnNum,
      btnType = btnType,
      notUseDialog = notUseDialog,
      confirmBtnParam = {
        context = confirmText,
        action = function(needSellConfirm)
          DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(todayType, needSellConfirm)
          if confirmAction then
            confirmAction()
          end
          Logger.Log("TryShowConfirm " .. todayType)
        end,
        btnPicPath = confirmPicPath
      },
      cancelBtnParam = {
        context = cancelText,
        action = cancelAction,
        btnPicPath = cancelPicPath
      },
      toggleParam = {
        toggleText = Localization:GetString(GameDialogDefine.TODAY_NO_SHOW)
      },
      closeAction = closeAction
    }
    UIUtil.ShowConfirmNew(param)
  else
    confirmAction()
    Logger.Log("AutoConfirm " .. todayType)
  end
end

local function TryShowConfirmNew(todayType, param)
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
    if param and param.confirmBtnParam then
      local action = param.confirmBtnParam.action
      
      function param.confirmBtnParam.action(isOn)
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(todayType, isOn)
        if action then
          action(isOn)
        end
      end
    end
    UIUtil.ShowConfirmNew(param)
  elseif param and param.confirmBtnParam and param.confirmBtnParam.action then
    param.confirmBtnParam.action()
  end
end

local function TryShowDiamondConfirm(todayType, param)
  local needShowConfirm = LuaEntry.Player:GetUserSetting(UserSettingKey.DIAMOND_USAGE_REMINDER) == "1"
  if needShowConfirm == true then
    UIUtil.TryShowConfirmNew(todayType, param)
  elseif param and param.confirmBtnParam and param.confirmBtnParam.action then
    param.confirmBtnParam.action()
  end
end

local function ShowConfirmNew(param)
  if param ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonConfirm, {anim = true, playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonConfirm)
    if window ~= nil and window.View ~= nil then
      window.View:SetData(param)
      if window.View:GetActive() then
        window.View:RefreshView()
      end
    end
  end
end

local function ShowUnlockWindow(title, icon, intro, type, flyEndPos)
  DataCenter.UnlockDataManager:AddData(title, icon, intro, type, flyEndPos)
  if UIManager:GetInstance():GetWindow(UIWindowNames.UIUnLockSuccess) == nil then
    local data = DataCenter.UnlockDataManager:GetFirstData()
    if data ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockSuccess, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, data)
    end
  end
end

local function ShowGuideBtnUnlockWindow(title, intro, btnType)
  DataCenter.UnlockDataManager:AddGuideBtnData(title, intro, btnType)
  if UIManager:GetInstance():GetWindow(UIWindowNames.UIUnLockSuccess) == nil then
    local data = DataCenter.UnlockDataManager:GetFirstData()
    if data ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockSuccess, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, data)
    end
  end
end

local function GetUIMainSavePos(posType)
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View ~= nil then
      return window.View:GetSavePos(posType)
    end
  end
end

local function OnPointDownMarch(marchUuid)
end

local function OnPointUpMarch(marchUuid)
end

local function OnMarchDragStart(marchUuid)
end

local function DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, isOnlyDisperse)
  DataCenter.FlyController.DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, isOnlyDisperse)
  local openParam = {
    stayTime = moveTime,
    rewardType = rewardType,
    isHaveEndPos = destPos ~= nil
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWResDoFlyUI, {anim = false}, openParam)
  if rewardType == RewardType.GOLD then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.DiamondsEmerges, false)
    local delayTime = moveTime or 0.5
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.DiamondsFlies, false)
    end, delayTime)
  end
end

local function DoFlyStraight(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent)
  DataCenter.FlyController.DoFlyStraight(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent)
end

local function DoFlyWithoutLogic(icon, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, moveTime1, moveTime2, initCallback)
  DataCenter.FlyController.DoFlyWithoutLogic(icon, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, moveTime1, moveTime2, initCallback)
end

local function DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, startDelay, parent, anim)
  DataCenter.FlyController.DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, startDelay, parent, anim)
end

local function DoFlySimpleFunc(path, srcPos, destPos, moveTime, parent, callback)
  DataCenter.FlyController.DoFlySimpleFunc(path, srcPos, destPos, moveTime, parent, callback)
end

local function DoFlySimpleFuncDelay(path, srcPos, destPos, moveTime, delay, parent, callback)
  if not delay or delay <= 0 then
    DoFlySimpleFunc(path, srcPos, destPos, moveTime, parent, callback)
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    DoFlySimpleFunc(path, srcPos, destPos, moveTime, parent, callback)
  end, delay)
end

local function DoFlyText(context, layer)
  if not context then
    return
  end
  if layer == nil then
    layer = UILayer.Info.Name
  end
  local infoLayer = UIManager:GetInstance():GetLayer(layer)
  if IsNull(infoLayer) then
    return
  end
  local infoLayerTrans = infoLayer.transform
  context:SetParent(infoLayerTrans)
  DataCenter.FlyController.DoFlyText(context)
end

local function GetSelfMarchCountExceptGolloes()
  local allianceId = LuaEntry.Player.allianceId
  local selfMarches = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
  local retCount = 0
  for _, tempMarch in pairs(selfMarches) do
    if tempMarch:GetMarchType() == NewMarchType.GOLLOES_EXPLORE and tempMarch:GetMarchType() == NewMarchType.GOLLOES_TRADE then
      retCount = retCount + 1
    end
  end
  return retCount
end

local function OpenHeroStationByBuildUuid(bUuid)
  local stationId = DataCenter.HeroStationManager:GetStationIdByBuildUuid(bUuid)
  UIUtil.OpenHeroStationByStationId(stationId)
end

local function OpenHeroStationByStationId(stationId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStation, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, stationId)
end

local function OpenHeroStationByEffectType(effectType, isArrow, highlightLevelUp)
  local skillId = DataCenter.HeroStationManager:GetSkillIdByEffectType(effectType)
  local stationId = DataCenter.HeroStationManager:GetStationIdBySkillId(skillId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStation, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, stationId, isArrow, highlightLevelUp)
end

local function CheckAndOpenBusinessCenter()
  local reachLimit = DataCenter.ResidentOrderDataManager:IsReachMax()
  if reachLimit == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter)
    return true
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIReachLimit, NextBusinessComeType.RESIDENT_ORDER)
    return false
  end
  return false
end

local function ShowPiggyBankTip(param)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPiggyBankTip) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPiggyBankTip)
    window.View:Refresh(param, 0)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPiggyBankTip, {anim = false}, param)
  end
end

local function ShowEnergyBankTip(param)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIEnergyBankTip) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIEnergyBankTip)
    window.View:Refresh(param, 0)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyBankTip, {anim = false}, param)
  end
end

local function DoJumpFly(icon, nums, srcPos, destPos, delay, width, height, callback)
  return DataCenter.FlyController.DoJumpFly(icon, nums, srcPos, destPos, delay, width, height, callback)
end

local function GetUIMainEnergySlider()
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View ~= nil then
      return window.View:GetEnergySlider()
    end
  end
  return nil
end

local function GetEnergyIconPos(useStatic)
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View ~= nil then
      return window.View:GetEnergyIconPos(useStatic)
    end
  end
  return nil
end

local function ShowSelectArmy(param)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISelectArmy)
  if window == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISelectArmy, {anim = false}, param)
  else
    window.View:ReInit(param)
    window.View:Show()
  end
end

local function GetFlyTargetPosByRewardType(rewardType)
  if rewardType == RewardType.FOOD then
    return UIUtil.GetResourcePos(ResourceType.Food)
  elseif rewardType == RewardType.METAL then
    return UIUtil.GetResourcePos(ResourceType.Metal)
  elseif rewardType == RewardType.OIL then
    return UIUtil.GetResourcePos(ResourceType.Oil)
  elseif rewardType == RewardType.ELECTRICITY then
    return UIUtil.GetResourcePos(ResourceType.Electricity)
  elseif rewardType == RewardType.WATER then
    return UIUtil.GetResourcePos(ResourceType.Water)
  elseif rewardType == RewardType.PEOPLE then
    return UIUtil.GetResourcePos(ResourceType.People)
  elseif rewardType == RewardType.POWER then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Power)
  elseif rewardType == RewardType.GOLD then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Gold)
  elseif rewardType == RewardType.FORMATION_STAMINA then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Stamina)
  elseif rewardType == RewardType.FAVOR then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Search)
  elseif rewardType == RewardType.GOODS then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.BagBtn)
  elseif rewardType == RewardType.WOOD then
    return UIUtil.GetResourcePos(ResourceType.Wood)
  elseif rewardType == RewardType.FLINT then
    return UIUtil.GetResourcePos(ResourceType.FLINT)
  elseif rewardType == RewardType.OBSIDIAN then
    return UIUtil.GetResourcePos(ResourceType.OBSIDIAN)
  elseif rewardType == RewardType.AllianceFarmerExp then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
  elseif rewardType == RewardType.AllianceFarmerExpItem then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
  elseif rewardType == RewardType.AllianceStone then
    return UIUtil.GetResourcePos(ResourceType.AllianceStone)
  elseif rewardType == RewardType.AllianceCoal then
    return UIUtil.GetResourcePos(ResourceType.AllianceCoal)
  elseif rewardType == RewardType.ALLIANCE_DONATE then
    return UIUtil.GetAllianceItemPos(RewardType.ALLIANCE_DONATE)
  elseif rewardType == RewardType.VISITOR then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.VisitorBtn)
  else
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
  end
end

local function ShowPvePowerLack(param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEPowerLack, {anim = true}, param)
end

local function PveSceneHeroListRefresh()
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
  if window then
    window.View.hero_list:ResetHeroList()
    window.View.ctrl:OnOneKeyFillClick()
    window.View:RefreshArmy()
  end
end

local function PveSceneHeroListScrollToHero(heroUuid)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
  if window then
    window.View.hero_list:ResetHeroList()
    window.View.hero_list:ScrollToHero(heroUuid, true)
  end
end

local function GetItemQualityBg(quality)
  if quality == nil then
    quality = 1
  end
  if quality and type(quality) == "string" then
    if quality:find("/Main/Sprites/") ~= nil then
      return quality
    else
      quality = toInt(quality)
    end
  end
  quality = math.max(1, math.min(quality, 6))
  return string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_daojukuang_%s.png", tostring(quality))
end

local qualityColor = {
  [1] = Color.New(0.917, 0.902, 0.925, 1),
  [2] = Color.New(0.502, 0.961, 0.773, 1),
  [3] = Color.New(0.439, 0.902, 0.945, 1),
  [4] = Color.New(0.922, 0.525, 1, 1),
  [5] = Color.New(1, 0.714, 0.267, 1),
  [6] = Color.New(0.984, 0.443, 0.337, 1)
}

local function GetColorByQuality(quality)
  local color
  if qualityColor[quality] == nil then
    color = qualityColor[1]
  else
    color = qualityColor[quality]
  end
  return color
end

local function ShowFlyText(content, parent)
  local pathText = "Assets/Main/Prefabs/CityScene/FlyText_UI.prefab"
  local flyTextInst = CS.GameEntry.Resource:InstantiateAsync(pathText)
  flyTextInst:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      req:Destroy()
      return
    end
    local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
      WorldBuildUtil.RemoveWorldAsyncObj(req)
    end, 2)
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Info.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    _go.transform.position = parent.position
    _go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local num = _go.transform:Find("objRoot/num"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    num.text = content
    WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
  end)
end

local function GetScaleFactor()
  return Screen.width / DefaultScreenWidth
end

local function ClearReward(content, rewardReqs)
  content:RemoveComponents(UICommonResItem)
  if rewardReqs ~= nil then
    for _, v in pairs(rewardReqs) do
      v:Destroy()
    end
  end
  rewardReqs = {}
end

local function RefreshReward(content, rewardReqs, param)
  UIUtil.ClearReward(content, rewardReqs)
  local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  local index = 0
  for _, v in pairs(rewards) do
    local req = ResourceManager:InstantiateAsync(UIAssets.UICommonResItem)
    local p = v
    index = index + 1
    local name = "UICommonResItem" .. index
    req:completed("+", function(req)
      local go = req.gameObject
      go.name = name
      go.transform:SetParent(content.transform)
      go.transform:Set_localScale(0.6, 0.6, 0.6)
      go.transform:Set_sizeDelta(150, 150)
      go.transform:Set_pivot(0, 1)
      local cell = content:AddComponent(UICommonResItem, go)
      cell:ReInit(p)
    end)
    table.insert(rewardReqs, req)
  end
end

local function GetFlyTargetByRewardType(type)
  local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if view then
    if type == RewardType.METAL or type == RewardType.FOOD or type == RewardType.WOOD then
      return view.View:GetResourcePos(RewardToResType[type])
    elseif type == RewardType.WORKER then
      return view.View:GetSavePos(UIMainSavePosType.VisitorBtn)
    elseif type == RewardType.GOLD then
      return view.View:GetSavePos(UIMainSavePosType.Gold)
    elseif type == RewardType.HERO then
      return view.View:GetSavePos(UIMainSavePosType.HeroBtn)
    elseif type == RewardType.VISITOR then
      return view.View:GetSavePos(UIMainSavePosType.VisitorBtn)
    end
    return view.View:GetSavePos(UIMainSavePosType.BagBtn)
  end
  return Vector3.zero
end

local function CheckHaveEnoughItemRename()
  local enough = false
  local item = DataCenter.ItemData:GetItemById(tostring(ITEM_RENAME))
  if item ~= nil and item.count > 0 then
    enough = true
  end
  return enough
end

local function IsRedPointCustomizeAvatar()
  local pic = LuaEntry.Player:GetPic()
  if pic ~= "" and LuaEntry.Player.modfiyPicStatus then
    local timeStamp = tonumber(Setting:GetPrivateString("nextUpdateHeadPicTime", "0"))
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftMin = math.ceil((timeStamp - now) / 60000)
    if leftMin < 0 then
      return true
    end
  end
  return false
end

local function OpenDetectEventView()
  if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept(500019) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function UIUtil.CheckDetectCanCrossServer(worldTreasureType)
  local isCanCroServer = false
  if SeasonUtil.IsUserInSeason() then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer and infoPlayer:GetServerType() == SeasonMapType.NineNation and SeasonUtil.IsInSeason() and LuaEntry.DataConfig:CheckSwitch("radar_cross_server") then
      isCanCroServer = true
    end
  end
  if worldTreasureType then
    if worldTreasureType == WorldTreasureType.FlowerTrainCheerTreasure then
      return true
    elseif worldTreasureType == WorldTreasureType.FlowerTrainUpgradeTreasure then
      return LuaEntry.Player:IsInSourceServer()
    elseif worldTreasureType == WorldTreasureType.ZWL_GIFT then
      return SeasonUtil.InSourceMapNow()
    end
  end
  return isCanCroServer
end

function UIUtil.IsInNineNationTruceMode()
  local result = false
  if SeasonUtil.IsInSeasonTruceMode() then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if infoPlayer and infoPlayer:GetServerType() == SeasonMapType.NineNation then
      result = true
    end
  end
  return result
end

local function OnClickDispatchTask(curIndex)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTask.Type)
  local actInfo = 0 < #actList and actList[1] or nil
  if actInfo == nil then
    UIUtil.ShowTipsId(456253)
    return
  end
  if actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
    UIUtil.ShowTipsId(456253)
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(curIndex)
  if info ~= nil then
    local mgr = DataCenter.ActDispatchTaskDataManager
    local selfUid = LuaEntry.Player:GetUid()
    local now = UITimeManager:GetInstance():GetServerTime()
    local canAward = 0 < info.completionTime and now >= info.completionTime and info.rewarded == 0
    if canAward then
      local allanceId = info.allianceId or ""
      if selfUid == info.ownerUid then
        SFSNetwork.SendMessage(MsgDefines.DispatchReward, info.uuid)
      elseif not string.IsNullOrEmpty(allanceId) and LuaEntry.Player.allianceId == allanceId then
        local todayAssistNum = mgr:GetTodayAssistNum()
        local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
        if todayAssistNum < assistMax then
          SFSNetwork.SendMessage(MsgDefines.DispatchAssist, info.uuid, LuaEntry.Player:GetCurServerId())
        else
          UIUtil.ShowTipsId(456225)
        end
      else
        local protectTime = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "protect_times")) * 60000
        if now >= info.completionTime + protectTime then
          if not info.stealList:Contains(selfUid) then
            local todayStealNum = mgr:GetTodayStealNum()
            local steal_count = mgr:GetDispatchSetting("steal_count")
            if todayStealNum < steal_count then
              local stealedMax = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "steal_maxtimes"))
              if stealedMax > info.stealList.Count then
                if DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() or not CrossServerUtil:NeedIntercept(500019) then
                  SFSNetwork.SendMessage(MsgDefines.DispatchSteal, info.uuid, LuaEntry.Player:GetCurServerId())
                end
              else
                UIUtil.ShowTipsId(456227)
              end
            else
              UIUtil.ShowTipsId(456226)
            end
          else
            UIUtil.ShowTipsId(456235)
          end
        else
          UIUtil.ShowTipsId(456223)
        end
      end
    elseif selfUid == info.ownerUid and info.completionTime == 0 then
      local maxMarch = DataCenter.ActDispatchTaskDataManager:GetMaxMarch()
      if maxMarch <= mgr:GetSingleTaskIngCount() then
        DataCenter.ActDispatchTaskDataManager:ShowMarchLimitTip()
      else
        local uuid = info.uuid
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(info.pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId()), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDispatchTask, uuid)
        end, serverId)
      end
    else
      UIUtil.ShowTipsId(456255)
    end
  end
end

local function OnClickGhostreconPoint(data, info)
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(data.uuid)
  local allianceInfo = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(data.uuid)
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(info.cfgId)
  local now = UITimeManager:GetInstance():GetServerTime()
  local needCloseWorldPointUI = false
  if info.completionTime > 0 then
    if now >= info.completionTime and info:OwnHaveReward() then
      SFSNetwork.SendMessage(MsgDefines.GhostReconReward, info.uuid, LuaEntry.Player:GetSourceServerId())
      needCloseWorldPointUI = true
    elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      local str = data.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.Ghostrecon .. ";" .. "0" .. ";" .. "0"
      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, data.uuid, info.mainIndex, "", WorldPointUIType.Ghostrecon, 0)
    end
  elseif info:OwnIsLeader() and taskInfo then
    if info.teamStartTime == 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconFormation, {anim = true}, taskInfo.uuid)
      needCloseWorldPointUI = true
    else
      if cfg:HaveSuperReward() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpSpecial, {anim = true}, taskInfo.uuid)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpNormal, {anim = true}, taskInfo.uuid)
      end
      needCloseWorldPointUI = true
    end
  elseif info:OwnIsJoin() and taskInfo then
    if cfg:HaveSuperReward() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpSpecial, {anim = true}, taskInfo.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpNormal, {anim = true}, taskInfo.uuid)
    end
    needCloseWorldPointUI = true
  elseif info:OwnIsAlly() and allianceInfo then
    if allianceInfo and table.length(allianceInfo.memberList) >= DataCenter.ActGhostreconManager:GetTeamMaxMemberNum() then
      UIUtil.ShowTipsId("ghostrecon_051")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconFormation, {anim = true}, allianceInfo.uuid, true)
    end
    needCloseWorldPointUI = true
  elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    local str = data.uuid .. ";" .. info.mainIndex .. ";" .. "" .. ";" .. WorldPointUIType.Ghostrecon .. ";" .. "0" .. ";" .. "0"
    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, data.uuid, info.mainIndex, "", WorldPointUIType.Ghostrecon, 0)
  end
  return needCloseWorldPointUI
end

local function ShowBubbleTips(content, position, deltaX, deltaY, contentX, closeCb, title, paramExe, endTime_, closePassClick)
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = content
  param.position = position
  param.deltaX = deltaX
  param.deltaY = deltaY
  param.contentX = contentX
  param.closeCallBack = closeCb
  param.title = title
  param.closePassClick = closePassClick
  param.endTime = endTime_
  if paramExe then
    param.exe = paramExe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

local function ShowBubbleTipsAuto(content, position, deltaX, deltaY, contentX, closeCb, title, paramExe, endTime_)
  local param = UICommonTipsAutoView.ParamDataClass.New()
  param.content = content
  param.position = position
  param.deltaX = deltaX
  param.deltaY = deltaY
  param.contentX = contentX
  param.closeCallBack = closeCb
  param.title = title
  param.endTime = endTime_
  if paramExe then
    param.exe = paramExe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTipsAuto, {anim = false}, param)
end

function UIUtil:ShowFightSoldierTips(position, deltaX, deltaY, contentX, closeCb, data, paramExe)
  local param = UICommonTipsView.ParamDataClass.New()
  param.position = position
  param.deltaX = deltaX * CommonUtil.ArabicAutoMirrorFactor()
  param.deltaY = deltaY
  param.contentX = contentX
  param.closeCallBack = closeCb
  param.data = data
  if paramExe then
    param.exe = paramExe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationSoldierTip, {anim = false}, param)
end

function UIUtil:ShowSoldierNumBubbleTips(content, position, deltaX, deltaY, contentX, closeCb, paramExe)
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = content
  param.position = position
  param.deltaX = deltaX
  param.deltaY = deltaY
  param.contentX = contentX
  param.closeCallBack = closeCb
  if paramExe then
    param.exe = paramExe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISoldierNumTips, {anim = false}, param)
end

function UIUtil.ShowArmyFormationPowerTips(position, deltaX, deltaY, sourceData)
  local param = {
    position = position,
    deltaX = deltaX,
    deltaY = deltaY,
    sourceData = sourceData
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.ArmyFormationPowerTips, {anim = false}, param)
end

function UIUtil.ShowBubbleTimeTips(timeStamp, runType, position, deltaX, deltaY, contentX, closeCb, title, paramExe)
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = timeStamp and UITimeManager:GetInstance():TimeStampToTimeForServer(timeStamp)
  param.timeStamp = timeStamp
  param.runType = runType
  param.position = position
  param.deltaX = deltaX
  param.deltaY = deltaY
  param.contentX = contentX
  param.closeCallBack = closeCb
  param.title = string.format("         %s", title or "")
  if paramExe then
    param.exe = paramExe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTimeTips, {anim = false}, param)
end

local function GetFreeStaminaTime()
  local todayFreeStamina = LuaEntry.Player.todayFreeStamina
  local lastClaimFreeStaminaTime = LuaEntry.Player.lastClaimFreeStaminaTime
  if todayFreeStamina == 0 and lastClaimFreeStaminaTime == 0 then
    return nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local count = LuaEntry.DataConfig:TryGetNum("role_stamina", "k2")
  local cd = LuaEntry.DataConfig:TryGetNum("role_stamina", "k3")
  local dayCd = UITimeManager:GetInstance():GetResSecondsTo24()
  local cdTime = 0
  local cy = (curTime - lastClaimFreeStaminaTime) / 1000
  if todayFreeStamina >= count then
    cdTime = dayCd
  else
    cdTime = math.min(cd - cy, dayCd)
  end
  return 0 < cdTime and cdTime or nil
end

local function ShowPowerUpTip(power)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPowerChangeTip, {
    anim = true,
    playEffect = SoundAssetId.PowerIncrease
  }, power)
end

local function ShowPowerUpTipNew(powerChange)
  local isOn = Setting:GetBool(SettingKeys.POWER_UP_BANNER_DETAIL, false)
  if isOn then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPowerChangeTip)
    if window and window.View then
      window.View:SetDataAndPlayNew(powerChange)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPowerChangeTip, {
        anim = true,
        playEffect = SoundAssetId.PowerIncrease
      }, powerChange)
    end
  else
    for _, value in ipairs(powerChange) do
      if value.key == "powerAdd" then
        UIUtil.ShowPowerUpTip(value.value)
        break
      end
    end
  end
end

local function StageJump()
  local isMonopolyEnd = DataCenter.MonopolyManager:GetIsEnd()
  local isJeepAdventureOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_OPEN_TOWER_JEEP_ADVENTURE)
  if not isMonopolyEnd then
    local curData = DataCenter.MonopolyManager.dataManager:GetCurData()
    local pointId = curData:GetCenterWorldPos()
    GoToUtil.GotoCityPos(pointId, nil, LookAtFocusTime, nil)
  elseif 0 < isJeepAdventureOpen then
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.LWHummerSceneManager:Enter()
    end, function()
      return DataCenter.LWHummerSceneManager:CheckLoadingState()
    end)
  end
end

local function FormatAllianceAndName(abbr, name, uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, name)
  if string.IsNullOrEmpty(abbr) then
    return showName or ""
  else
    return string.format("[%s]%s", abbr, showName or "")
  end
end

local function FormatServerAllianceName(serverId, abbr, name, uid)
  local showName = name
  if uid ~= nil and uid ~= "" and uid ~= 0 then
    showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, name)
  end
  if serverId and 0 < serverId then
    return string.format("#%s %s", serverId, UIUtil.FormatAllianceAndName(abbr, showName))
  else
    return UIUtil.FormatAllianceAndName(abbr, showName)
  end
end

local function FormatServerPosition(serverId, x, y)
  if serverId and 0 < serverId then
    return string.format("#%s(%s,%s)", serverId, x, y)
  else
    return string.format("(%s,%s)", x, y)
  end
end

local function FormatServerName(serverId)
  return string.format("#%s", serverId)
end

local function IsFreeMoveCityInOpenServerTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openServerTime = LuaEntry.Player.openServerTime
  local freeDayNum = LuaEntry.DataConfig:TryGetNum("alliance_newbeebuff", "k1")
  local freeEndTime = openServerTime + freeDayNum * 24 * 60 * 60 * 1000
  if curTime >= freeEndTime then
    return false
  end
  if not DataCenter.AllianceRallyPointDataManager:CheckMyBaseFarFromAnyRallyPoint() then
    return false
  end
  if not CS.SceneManager:IsInCity() and not CS.SceneManager:IsInWorld() then
    return false
  end
  return true
end

local function IsFormationBuffInfoOpen()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openServerTime = LuaEntry.Player.openServerTime
  local openHour = LuaEntry.DataConfig:TryGetNum("Camp_buff_unlock", "k1")
  local openTime = openServerTime + openHour * 60 * 60 * 1000
  if curTime > openTime then
    return true
  else
    return false
  end
end

local function ShowNoToggleSecondMessage(titleText, tipText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UINoToggleConfirm, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UINoToggleConfirm)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(titleText, tipText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle)
    if window.View:GetActive() then
      window.View:RefreshView()
    end
  end
end

local function OpenFreeMoveCityInOpenServerTimeConfirmPanel()
  if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
    UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
    return
  end
  local mainIndex = LuaEntry.Player:GetMainWorldPos()
  if mainIndex == nil or mainIndex <= 0 then
    local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if markInfo then
      mainIndex = markInfo:GetPointIndex()
    end
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local worldPointPos = SceneUtils.TileIndexToWorld(mainIndex, ForceChangeScene.World, curServerId)
  GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(1, false)
  end, curServerId)
end

local function PlayScaleAnim(rectTransform)
  local rootRt = rectTransform
  DOTween.Kill(rootRt)
  rootRt:DOScale(Vector3.New(1.5, 1.5, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.4)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OpenUIPlayerInfo(uid)
  if uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, uid)
  end
end

local function GetRewardOrShareTreasureBox(info)
  local isHaveReward = info:IsHaveGetReward(LuaEntry.Player.uid)
  if not isHaveReward then
    SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, info.uuid, info.serverId)
  else
    local share_param = {}
    share_param.sid = LuaEntry.Player:GetCurServerId()
    share_param.pos = info.pointIndex
    share_param.oname = GetTableData(TableName.WorldTreasure, info.eventId, "name", "new_city_activity_battle_tips1016")
    share_param.postType = PostType.Text_PointShare_Alliance
    share_param.addWorldChannel = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  end
end

local function GetFlowerTrainCheerTreasureBox(info, isCheckCD, worldTreasureType)
  local isHaveReward = info:IsHaveGetReward(LuaEntry.Player.uid)
  if not isHaveReward then
    if isCheckCD then
      local isInCD = FlowerTrainUtils.IsInCDForClaimLvBox(true)
      if isInCD then
        return
      end
    end
    SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, info.uuid, info.serverId, worldTreasureType)
  else
    local share_param = {}
    share_param.sid = LuaEntry.Player:GetCurServerId()
    share_param.pos = info.pointIndex
    share_param.oname = GetTableData(TableName.WorldTreasure, info.eventId, "name", "new_city_activity_battle_tips1016")
    share_param.postType = PostType.Text_PointShare
    share_param.addWorldChannel = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  end
end

local function ShareActTreasureBox(info, pointObject)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
  if template == nil then
    local eventId = info.eventId
    Logger.LogError("GetTreasureData template is nil, eventId = " .. tostring(eventId))
    return
  end
  local isCanShare = false
  if pointObject.GetCanBeShared then
    isCanShare = pointObject:GetCanBeShared()
  end
  local myAlId = LuaEntry.Player.allianceId
  local isHaveAliance = not string.IsNullOrEmpty(myAlId)
  if not isHaveAliance and not isCanShare then
    UIUtil.ShowTipsId("activity_wajueji_27000_tips17")
  else
    local share_param = {}
    share_param.sid = LuaEntry.Player:GetCurServerId()
    share_param.pos = info.pointIndex
    share_param.oname = template.name
    share_param.postType = PostType.Text_PointShare_Alliance
    share_param.addWorldChannel = isCanShare
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  end
end

local function GetDetectTreasureReward(posIndex)
  local info = CS.SceneManager.World:GetPointInfo(posIndex)
  if info == nil then
    return
  end
  cast(info, typeof(CS.TreasurePointInfo))
  if info == nil then
    return
  end
  local worldTreasureType = info:GetWorldTreasureType()
  local IsInNineNationTruceMode = UIUtil.IsInNineNationTruceMode()
  if not IsInNineNationTruceMode and not UIUtil.CheckDetectCanCrossServer(worldTreasureType) and not LuaEntry.Player:IsInSelfServer() then
    if worldTreasureType ~= WorldTreasureType.ZWL_GIFT then
      UIUtil.ShowTipsId("server_tips_002")
    end
    return
  end
  if worldTreasureType == WorldTreasureType.PlayerKillMonsterTreasure or worldTreasureType == WorldTreasureType.GeneFragment then
    if info.killerId == LuaEntry.Player.uid then
      SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, info.uuid, info.serverId)
      Logger.LogInfo(string.format("ClaimTreasure with killerId %s , %s", tostring(info.uuid), tostring(info.mainIndex)))
    elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
      local str = info.uuid .. ";" .. info.mainIndex .. ";;" .. WorldPointUIType.PlayerKillMonsterTreasure .. ";0;0"
      EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, info.uuid, info.mainIndex, "", WorldPointUIType.PlayerKillMonsterTreasure, 0, 0)
    end
    return
  end
  local pointObject = CS.SceneManager.World:GetObjectByPoint(posIndex)
  if pointObject == nil then
    return
  end
  if worldTreasureType == WorldTreasureType.RadarTreasure or worldTreasureType == WorldTreasureType.ActivityRadarTreasure or worldTreasureType == WorldTreasureType.OffSeasonDetect then
    if pointObject.CheckInteractAuthority and pointObject:CheckInteractAuthority(info) then
      local selfUid = LuaEntry.Player.uid
      local isHaveReward = info:IsHaveGetReward(selfUid)
      local receiveAllReward = info:IsReceiveAllReward()
      if receiveAllReward then
        SFSNetwork.SendMessage(MsgDefines.DetectEventGetTreasureClaimInfo, info.uuid, SeeDetectEventGetTreasureClaimInfoType.World, info.serverId)
      elseif not isHaveReward then
        SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, info.uuid, info.serverId)
      else
        ShareActTreasureBox(info, pointObject)
      end
    elseif worldTreasureType == WorldTreasureType.ActivityRadarTreasure or worldTreasureType == WorldTreasureType.OffSeasonDetect then
      UIUtil.ShowTipsId("activity_wajueji_27000_tips6")
    else
      UIUtil.ShowTipsId("801354")
      if pointObject.PostNoInteractAuthorityLog then
        pointObject:PostNoInteractAuthorityLog()
      end
    end
    return
  end
  local beGetNum = 0
  if info.rewardUserList then
    beGetNum = info.rewardUserList.Count
  else
    Logger.LogError("GetDetectTreasureReward info.rewardUserList is nil " .. worldTreasureType)
  end
  local maxNum = GetTableData(TableName.WorldTreasure, info.eventId, "max_reward_times", 10)
  if beGetNum >= maxNum then
    UIUtil.ShowTipsId("new_city_activity_battle_tips1025")
    return
  end
  if pointObject.CheckInteractAuthority and pointObject:CheckInteractAuthority(info) then
    if worldTreasureType == WorldTreasureType.SiegeTreasure or worldTreasureType == WorldTreasureType.InvasionTreasure or worldTreasureType == WorldTreasureType.AllianceBossSandBox then
      local targetAllianceId = string.split(info.allianceId, ";")
      local selfAllianceId = LuaEntry.Player.allianceId
      if selfAllianceId ~= nil then
        for _, v in pairs(targetAllianceId) do
          if v == selfAllianceId then
            GetRewardOrShareTreasureBox(info)
            return
          end
        end
      end
      if worldTreasureType == WorldTreasureType.InvasionTreasure then
        UIUtil.ShowTipsId("activity_godzilla_reward_other_alliance")
      elseif worldTreasureType == WorldTreasureType.AllianceBossSandBox then
        UIUtil.ShowTipsId("new_alliance_boss_tips_25")
      else
        UIUtil.ShowTipsId("new_city_activity_battle_tips1013")
      end
    elseif worldTreasureType == WorldTreasureType.ZONE_MOBILIZATION then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local serverId = info.serverId
      if mySourceServerId ~= serverId then
        UIUtil.ShowTipsId("activity_mobilization_reward_other_server")
        return
      end
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.SandWormTreasure then
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.Crocodile then
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.FlowerCar then
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.ZWL_GIFT then
      if SeasonUtil.InSourceMapNow() then
        GetRewardOrShareTreasureBox(info)
      end
    elseif worldTreasureType == WorldTreasureType.S1PrefabSeasonBossTreasure then
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.S1PrefabWorldBossTreasure then
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.BloodyQueen then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local serverId = info.serverId
      if mySourceServerId ~= serverId then
        UIUtil.ShowTipsId("s1_QueenChallenge_chest_errtips_01")
        return
      end
      GetRewardOrShareTreasureBox(info)
    elseif worldTreasureType == WorldTreasureType.FlowerTrainCheerTreasure then
      if info.ownerUid == LuaEntry.Player.uid then
        GetFlowerTrainCheerTreasureBox(info, false, worldTreasureType)
      else
        UIUtil.ShowTipsId("activity_treasure_error_alert15")
      end
    elseif worldTreasureType == WorldTreasureType.FlowerTrainUpgradeTreasure then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local serverId = info.serverId
      if mySourceServerId ~= serverId then
        UIUtil.ShowTipsId("s1_QueenChallenge_chest_errtips_01")
        return
      end
      GetFlowerTrainCheerTreasureBox(info, true, worldTreasureType)
    end
  elseif worldTreasureType == WorldTreasureType.SiegeTreasure then
    UIUtil.ShowTipsId("new_city_activity_battle_tips1013")
  elseif worldTreasureType == WorldTreasureType.InvasionTreasure then
    UIUtil.ShowTipsId("activity_godzilla_reward_other_alliance")
  elseif worldTreasureType == WorldTreasureType.AllianceBossSandBox then
    UIUtil.ShowTipsId("new_alliance_boss_tips_25")
  elseif worldTreasureType == WorldTreasureType.ZONE_MOBILIZATION then
    UIUtil.ShowTipsId("activity_mobilization_reward_other_server")
  elseif worldTreasureType == WorldTreasureType.FlowerTrainCheerTreasure then
    UIUtil.ShowTipsId("activity_treasure_error_alert15")
  end
end

local function IsFreeCreateAllianceInOpenServerTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openServerTime = LuaEntry.Player.openServerTime
  local freeDayNum = LuaEntry.DataConfig:TryGetNum("system_alliance", "k11")
  local freeEndTime = openServerTime + freeDayNum * 24 * 60 * 60 * 1000
  if curTime < freeEndTime then
    return true
  else
    return false
  end
end

local function PlayCutSceneAnim(midAction, holdFunc, toServerId, timeout, timeoutFunc, animSpeed)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCloud, {anim = true}, midAction, holdFunc, toServerId, timeout, timeoutFunc, animSpeed)
end

local function OnJoinAllianceBtnClick()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  end
end

local function GetDeltaTimeTimeStr(deltaTime)
  local timeStr = ""
  if 86400000 < deltaTime then
    local day = math.floor(deltaTime / 86400000)
    timeStr = Localization:GetString("390506", day)
  elseif 3600000 < deltaTime then
    local hour = math.floor(deltaTime / 3600000)
    timeStr = Localization:GetString("390505", hour)
  elseif 60000 < deltaTime then
    local minute = math.floor(deltaTime / 60000)
    timeStr = Localization:GetString("390504", minute)
  else
    timeStr = Localization:GetString("390504", 1)
  end
  return timeStr
end

local function IsOpenDeleteAccountFunc()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("account_del")
  return isOpen
end

local function DeleteAccountBtnClick()
  local param = {}
  param.title = Localization:GetString("121074")
  param.content = Localization:GetString("121070")
  
  function param.confirmFunc()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountDeleteVerify, {anim = true})
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountSetConfirm, {anim = true}, param)
end

function UIUtil.CanPutAllianceRallyPoint(pointId, serverId)
  if BattleFieldUtil.InBattleField() or not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return false
  end
  if SeasonUtil.IsInSeasonNineNationMode() then
    local canSetRally = SeasonUtil.IsInSameGroup(LuaEntry.Player:GetCurServerId()) and not DataCenter.AllianceRallyPointDataManager:CheckIfPointInUse(pointId * 10 + 1, serverId)
    return canSetRally
  else
    local canSetRally = LuaEntry.Player:AtHomeNow() and not DataCenter.AllianceRallyPointDataManager:CheckIfPointInUse(pointId * 10 + 1)
    return canSetRally
  end
end

function UIUtil.ShowWorldSiegePoint(cityId, pointIndex, serverId, uuid)
  local config = SeasonUtil.GetCurServerConfig()
  if config and config:GetServerType() ~= SeasonMapType.Nothing then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if meta then
      if DataCenter.LandlordMgr:IsCityWithBoom(meta.id) and (meta.type == WorldAllianceCityType.LLNormalCity or meta.type == WorldAllianceCityType.LLThroneCity or meta.type == WorldAllianceCityType.LLBuffCity or meta.type == WorldAllianceCityType.City or meta.type == WorldAllianceCityType.King or meta.type == WorldAllianceCityType.CrossZoneOutpost or meta.type == WorldAllianceCityType.Stronghold) then
        local llPreviewStage = DataCenter.LandlordMgr:GetActCurStage()
        local isNewCenterMap = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
        local isOldCityBoom = llPreviewStage == LLConst.LandlordStage.PREVIEW and not isNewCenterMap
        if isOldCityBoom then
          if UITimeManager:GetInstance():GetServerTime() <= DataCenter.LandlordMgr:GetPreviewBoomTime() then
            local actStartTime = DataCenter.LandlordMgr:GetActStartTime() or 0
            local key = SettingKeys.LANDLORD_CITY_DETAIL_FIRST_SWITCH .. actStartTime
            if not CommonUtil.PlayerPrefsGetBool(key) then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePointSeason, cityId, pointIndex, serverId, uuid)
              TimerManager:GetInstance():DelayInvoke(function()
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldSiegePointSeason) then
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCityPoint, {anim = false}, cityId, pointIndex, serverId, uuid)
                end
              end, 1)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCityPoint, cityId, pointIndex, serverId, uuid)
            end
          end
        else
          local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
          if pointInfo then
            local clientState = pointInfo.curClientState
            if clientState and clientState ~= LLConst.LLBuildingState.Exploding and clientState ~= LLConst.LLBuildingState.Ruins then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCityPoint, cityId, pointIndex, serverId, uuid)
            end
          end
        end
        return
      elseif meta.type == WorldAllianceCityType.CrossZoneOutpostCanon then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCanonPoint, cityId, pointIndex, serverId, uuid)
        return
      elseif meta.type == WorldAllianceCityType.CrossZoneOutpost then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOutpostCityPoint, cityId, pointIndex, serverId, uuid)
        return
      elseif meta.type == WorldAllianceCityType.LLCanon then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldLLCanonPoint, cityId, pointIndex, serverId, uuid)
        return
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePointSeason, cityId, pointIndex, serverId, uuid)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePoint, cityId, pointIndex, serverId, uuid)
  end
end

function UIUtil.DestroyWorldSiegePoint()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldSiegePoint)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldSiegePointSeason)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldOutpostCityPoint)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldOutpostCanonPoint)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldLLCityPoint)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldLLCanonPoint)
end

function UIUtil.ShowButtonTips(alignObject, title, desc, isLocal)
  if alignObject ~= nil and GameObjectIsValid(alignObject.gameObject) then
    local param = {}
    if string.IsNullOrEmpty(title) then
      param.type = "desc"
    else
      param.type = "nameDesc"
    end
    param.title = title
    param.desc = desc
    param.isLocal = isLocal
    param.alignObject = alignObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UIUtil.ShowResistanceDetail(selfPercent, otherPercent, bigUI)
  if selfPercent and otherPercent then
    local seasonType = SeasonUtil.GetSeasonType()
    local str1 = string.GetFormattedPercentStr(math.abs(selfPercent))
    local str2 = string.GetFormattedPercentStr(math.abs(otherPercent))
    if seasonType == SeasonMapType.Snow then
      UIUtil.ShowDetail(Localization:GetString("season_s2_tiles_popui_info008", str1, str2), nil, nil, bigUI)
    else
      UIUtil.ShowDetail(Localization:GetString("season_tiles_popui_info008", str1, str2), nil, nil, bigUI)
    end
  end
end

function UIUtil.ShowDetail(desc, title, subTitle, bigUI, hideSubTile)
  if not string.IsNullOrEmpty(desc) then
    local param = {}
    param.title = title
    param.hideSubTile = hideSubTile == nil and string.IsNullOrEmpty(subTitle) or hideSubTile == true
    param.subTitle = subTitle
    param.activityRulesStr = desc
    if bigUI then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
    end
  end
end

function UIUtil.CloseDetail()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDetail)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDetailPopup)
end

function UIUtil.OpenWorkerPreviewView(workerCfgId)
  local temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerCfgId)
  if temp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, workerCfgId, nil)
  end
end

function UIUtil.GetString(defaultText, dialogId, ...)
  return Localization:GetString(dialogId, ...)
end

function UIUtil.GetLocalizationString(id, ...)
  return Localization:GetString(id, ...)
end

local function SendDelAllAcctApplyCancelMsg()
  CS.LoginMessage.Instance:SendDelAccountApplyCancelMsg()
end

local function GetActiveCount(zeroTime, key, updateIt)
  local count = 0
  local base = SecToMilSec * SecToMilSec
  local v = Setting:GetPrivateString(key, "0")
  if string.IsNullOrEmpty(v) then
    v = 0
  end
  local dataFetch = tonumber(v)
  if dataFetch ~= nil and dataFetch ~= 0 then
    count = dataFetch % base
    if dataFetch ~= zeroTime * base + count then
      count = 0
    end
  end
  if updateIt == true then
    Setting:SetPrivateString(key, tostring(zeroTime * base + count + 1))
  end
  return count
end

function UIUtil.GetTodayActiveCount(key, updateIt)
  local todayZeroTime = UITimeManager:GetInstance():TodayZero()
  return GetActiveCount(todayZeroTime, key, updateIt)
end

function UIUtil.GetWeekActiveCount(key, updateIt)
  local weekZeroTime = UITimeManager:GetInstance():WeekZero()
  return GetActiveCount(weekZeroTime, key, updateIt)
end

function UIUtil.GetMonthActiveCount(key, updateIt)
  local monthZeroTime = UITimeManager:GetInstance():GetMonthZero()
  return GetActiveCount(monthZeroTime, key, updateIt)
end

function UIUtil.GetYearActiveCount(key, updateIt)
  local yearZeroTime = UITimeManager:GetInstance():GetYearZero()
  return GetActiveCount(yearZeroTime, key, updateIt)
end

function UIUtil.ShowLeaveAllianceTips(callbackYes, callbackNo, fromInvite)
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    local memberCount = DataCenter.AllianceMemberDataManager:GetAllianceMemberCount()
    if 1 < memberCount then
      local message = Localization:GetString("390793")
      UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        if callbackNo and type(callbackNo) == "function" then
          callbackNo()
        end
      end, function()
        if callbackNo and type(callbackNo) == "function" then
          callbackNo()
        end
      end)
    else
      if DataCenter.LWZombieRushManager:IsChallenging() then
        UIUtil.ShowTipsId("zombieRush_tips_18")
        return
      end
      local message = Localization:GetString("390093")
      UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceLeaveTips, {anim = true}, callbackYes, callbackNo)
      end, function()
        if callbackNo and type(callbackNo) == "function" then
          callbackNo()
        end
      end)
    end
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceLeaveTips, {anim = true}, callbackYes, callbackNo, fromInvite)
end

function UIUtil.GetLoopListItemIndex(prefix)
  NameCount = NameCount + 1
  if prefix ~= nil and type(prefix) == "string" then
    return prefix .. tostring(NameCount)
  end
  return tostring(NameCount)
end

local WorldPointBtnNotHideList = {
  [WorldPointBtnType.DeclareWar] = true,
  [WorldPointBtnType.AssistanceAllianceBuild] = true,
  [WorldPointBtnType.AssistanceBuild] = true,
  [WorldPointBtnType.AssistanceCity] = true,
  [WorldPointBtnType.AssistanceDesert] = true,
  [WorldPointBtnType.AssistanceDragonBuild] = true,
  [WorldPointBtnType.AssistanceWinterEntity] = true,
  [WorldPointBtnType.AssistanceEpidemic] = true,
  [WorldPointBtnType.AttackActBoss] = true,
  [WorldPointBtnType.AttackAisilla] = true,
  [WorldPointBtnType.AttackAllianceActMine] = true,
  [WorldPointBtnType.AttackAllianceBuild] = true,
  [WorldPointBtnType.AttackArmyCollect] = true,
  [WorldPointBtnType.AttackBuild] = true,
  [WorldPointBtnType.AttackCity] = true,
  [WorldPointBtnType.AttackDesert] = true,
  [WorldPointBtnType.AttackDragonBuild] = true,
  [WorldPointBtnType.AttackMonster] = true,
  [WorldPointBtnType.WhistleMonster] = true,
  [WorldPointBtnType.AttackPuzzleBoss] = true,
  [WorldPointBtnType.AttackRoad] = true,
  [WorldPointBtnType.AttackSandworm] = true,
  [WorldPointBtnType.AttackWinterEntity] = true,
  [WorldPointBtnType.AttackEpidemic] = true,
  [WorldPointBtnType.PutAresMissile] = true,
  [WorldPointBtnType.AllianceCityRally] = true,
  [WorldPointBtnType.RallyAllianceActMine] = true,
  [WorldPointBtnType.RallyAllianceBuild] = true,
  [WorldPointBtnType.RallyBoss] = true,
  [WorldPointBtnType.RallyBuild] = true,
  [WorldPointBtnType.RallyCity] = true,
  [WorldPointBtnType.RallyDragonBuild] = true,
  [WorldPointBtnType.RallyEpidemic] = true,
  [WorldPointBtnType.RallySandworm] = true,
  [WorldPointBtnType.BuildAllianceCenter] = true,
  [WorldPointBtnType.Collect] = true,
  [WorldPointBtnType.GiveUpDesert] = true,
  [WorldPointBtnType.GoBackToCity] = true,
  [WorldPointBtnType.GoddessMummy] = true,
  [WorldPointBtnType.MonsterLockAttack] = true,
  [WorldPointBtnType.PickDragonBuild] = true,
  [WorldPointBtnType.PickEpidemic] = true,
  [WorldPointBtnType.ReBuildAllianceRuin] = true,
  [WorldPointBtnType.ScoutAllianceActMine] = true,
  [WorldPointBtnType.ScoutAllianceBuild] = true,
  [WorldPointBtnType.ScoutArmyCollect] = true,
  [WorldPointBtnType.ScoutBuild] = true,
  [WorldPointBtnType.ScoutCity] = true,
  [WorldPointBtnType.ScoutDesert] = true,
  [WorldPointBtnType.ScoutDragonBuild] = true,
  [WorldPointBtnType.ScoutWinterEntity] = true,
  [WorldPointBtnType.ScoutEpidemic] = true,
  [WorldPointBtnType.StatusDragonBuild] = true,
  [WorldPointBtnType.StatusBattlefieldBuild] = true,
  [WorldPointBtnType.StealWinterEntity] = true,
  [WorldPointBtnType.CollectEpidemic] = true,
  [WorldPointBtnType.AttackDetectZombieBusTrain] = true,
  [WorldPointBtnType.KillZombieKirovBox] = true,
  [WorldPointBtnType.DetectEventAttackCityS0Radar] = true,
  [WorldPointBtnType.Fishing] = true,
  [WorldPointBtnType.AllianceSkillReinforceCharge] = true
}

function UIUtil.GetBtnShown(btnList, maxBtnCount)
  if btnList == nil or maxBtnCount >= table.count(btnList) then
    return btnList
  end
  local newBtnList = {}
  local count = 0
  local used = {}
  for k, v in pairs(btnList) do
    if v ~= nil and WorldPointBtnNotHideList[v] == true then
      table.insert(newBtnList, v)
      used[v] = true
      count = count + 1
      if maxBtnCount <= count then
        break
      end
    end
  end
  if maxBtnCount > count then
    for k, v in pairs(btnList) do
      if v ~= nil and used[v] == nil then
        table.insert(newBtnList, v)
        used[v] = true
        count = count + 1
        if maxBtnCount <= count then
          break
        end
      end
    end
  end
  return newBtnList
end

function UIUtil.GetAbsoluteTimeByStr(dateStr)
  local absoluteTime
  local date = string.split(dateStr, "-")
  if table.count(date) == 6 then
    local year = tonumber(date[1])
    local month = tonumber(date[2])
    local day = tonumber(date[3])
    local hour = tonumber(date[4])
    local min = tonumber(date[5])
    local sec = tonumber(date[6])
    absoluteTime = UIUtil.GetAbsoluteTimeByData(year, month, day, hour, min, sec)
  end
  return absoluteTime
end

function UIUtil.GetAbsoluteTimeByData(year, month, day, hour, min, sec)
  local absoluteTime = 0
  local curZoneTime = CS.GameEntry.Timer:GetUTCTimestamp(year, month, day, hour, min, sec)
  local serverDeltaTime = UITimeManager:GetInstance():GetTimezoneOffset() / 1000
  absoluteTime = curZoneTime - serverDeltaTime
  return absoluteTime
end

function UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(temp)
  local isShow = false
  if temp.tips == LWResourceLackGetWay.ActivityAndCheckOpen or temp.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf or temp.tips == LWResourceLackGetWay.GotoWorldBossTask then
    local idList = string.split(tostring(temp.para1), "|")
    for _, v in ipairs(idList) do
      local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
      if actInfo ~= nil then
        isShow = true
        break
      end
    end
  else
    isShow = true
  end
  return isShow
end

function UIUtil.ShowRedNumCheckMax(redNum)
  local maxNum = 99
  local str = ""
  if redNum > maxNum then
    str = maxNum .. "+"
  else
    str = tostring(redNum)
  end
  return str
end

function UIUtil.OpenPowerOverviewPanel()
  local minShowLevel = DataCenter.LWDevelopRecommendManager:GetEntranceShowLevel()
  if minShowLevel <= DataCenter.BuildManager.MainLv then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWPowerOverview, {anim = true})
  end
end

function UIUtil.IsShowWillExpired(id, ignoreDelay)
  local isShowExpireTime = DataCenter.ItemExchangeManager:IsShowWillExpired(tonumber(id), ignoreDelay)
  if isShowExpireTime then
    return isShowExpireTime
  end
  isShowExpireTime = DataCenter.ItemData:IsShowWillExpired(tonumber(id), ignoreDelay)
  if isShowExpireTime then
    return isShowExpireTime
  end
  return false
end

function UIUtil.GetWillExpireTime(id)
  local time = DataCenter.ItemExchangeManager:GetWillExpireTime(tonumber(id))
  if 0 < time then
    return time
  end
  time = DataCenter.ItemData:GetWillExpireTime(tonumber(id))
  if 0 < time then
    return time
  end
  return 0
end

function UIUtil.CheckItemIsExpired(itemId)
  itemId = tonumber(itemId)
  local isExpired = false
  if itemId and 0 < itemId then
    local expiredExchangeTemplate = DataCenter.ItemExchangeManager:GetItemExchangeTemplateByItemId(itemId)
    local isExpiredInItemInfoData = DataCenter.ItemData:CheckItemIsExpiredInOtherParamData(itemId)
    isExpired = expiredExchangeTemplate ~= nil and expiredExchangeTemplate:IsExpiredNow() or isExpiredInItemInfoData
  end
  return isExpired
end

function UIUtil.ShowShieldBreakTip(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, align, openEffect, btn_1_color, btn_2_color, showCloseBtn, costItemData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIShieldBreakTip, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = openEffect
  })
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIShieldBreakTip)
  if window ~= nil and window.View ~= nil then
    window.View:SetData(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, align, showCloseBtn, costItemData)
    if btn_1_color ~= nil and btn_2_color ~= nil then
      window.View:SetBtnSprite(btn_1_color, btn_2_color)
    end
    if window.View:GetActive() then
      window.View:RefreshData()
    end
  end
end

function UIUtil.UseNewPlayerInfo()
  return true
end

function UIUtil.GetPlayerInfoShowByUid(uid, fetchProfileHint, force)
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid, force)
  local oneData = {
    uid = uid,
    name = "",
    allianceName = "",
    power = 0,
    kill = 0,
    isSelf = false,
    pic = "",
    picVer = 0,
    allianceRank = -1
  }
  local thePlayerData = LuaEntry.Player
  if info ~= nil and (not fetchProfileHint or info.hasFetchProfileHint) then
    oneData.isSelf = thePlayerData and thePlayerData.uid == info.uid
    oneData.uid = info.uid
    oneData.name = info.name
    oneData.gender = info.gender
    oneData.moodStr = info.moodStr
    oneData.serverId = info.serverId
    oneData.allianceId = info.allianceId
    oneData.allianceRank = info.allianceRank or -1
    if info.alAbbr ~= nil and info.alAbbr ~= "" then
      oneData.allianceName = UIUtil.FormatAllianceAndName(info.alAbbr, info.allianceName)
      oneData.alAbbr = info.alAbbr
    else
      oneData.allianceName = ""
      oneData.alAbbr = ""
    end
    oneData.pic = info.pic
    oneData.picVer = info.picVer
    oneData.headBg = info:GetHeadBgImg()
    oneData.nation = info and info.countryFlag or DefaultNation
    oneData.power = info.power or 0
    oneData.kill = info.armyKill or 0
    oneData.level = info.level or 1
    oneData.careerType = info.careerType
    oneData.careerLv = info.careerLv
    oneData.thumbsUpCount = toInt(info.thumbsUpCount or 0)
    oneData.slotInfo = info.slotInfo
    oneData.photoAlbumStrDes = info.photoAlbumStrDes
    oneData.friendsCircleCommentIsOn = info.friendsCircleCommentIsOn
    oneData.friendsCircleAllianceVisibleIsOn = info.friendsCircleAllianceVisibleIsOn
    oneData.friendsCircleAllianceMomentIsOn = info.friendsCircleAllianceMomentIsOn
    oneData.giftLevel = info.giftLevel
    oneData.giftDataList = info.giftDataList
    oneData.title = info.title
    oneData.titleWall = info.titleWall
    oneData.birthday = info.birthday
    oneData.birthdayDisplay = info.birthdayDisplay
    oneData.zodDisplay = info.zodDisplay
    oneData.extraGiftShowNum = info.extraGiftShowNum
    oneData.isPlayGiftShowAni = info.isPlayGiftShowAni
    oneData.isKid = info.isKid or 0
    if oneData.isSelf then
      oneData.thumbsUpCountOld = toInt(info.thumbsUpCountOld or 0)
      oneData.thumbsUpCountDiff = toInt(info.thumbsUpCountDiff or 0)
      oneData.ThumbsUpPlayerList = info.ThumbsUpPlayerList or {}
      oneData.birthdayThumbsUpCountOld = toInt(info.birthdayThumbsUpCountOld or 0)
      oneData.birthdayThumbsUpCountDiff = toInt(info.birthdayThumbsUpCountDiff or 0)
      oneData.birthdayThumbsUpPlayerList = info.birthdayThumbsUpPlayerList or {}
      oneData.newGiftCount = toInt(info.newGiftCount)
      oneData.oldGiftCount = toInt(info.oldGiftCount)
      oneData.payFollowHint = info.payFollowHint
      oneData.freeFollowHint = info.freeFollowHint
      oneData.followUser = info.followUser
    end
    if not string.IsNullOrEmpty(info.allianceId) then
      local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(info.allianceId)
      if allianceInfo == nil then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, info.allianceId)
      else
        oneData.allianceIcon = allianceInfo.icon
      end
    end
  else
    DataCenter.PlayerInfoDataManager:RequestPlayerData(uid, fetchProfileHint)
    if thePlayerData and thePlayerData.uid == uid then
      oneData.isSelf = true
      oneData.uid = uid
      oneData.thumbsUpCount = 0
      oneData.thumbsUpCountOld = 0
      oneData.thumbsUpCountDiff = 0
      oneData.ThumbsUpPlayerList = {}
    end
  end
  if oneData.isSelf then
    oneData.name = thePlayerData:GetName()
    oneData.gender = thePlayerData:GetGender()
    oneData.moodStr = thePlayerData:GetValue("moodStr")
    oneData.serverId = thePlayerData.serverId
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.allianceName ~= "" then
      oneData.allianceId = data.uid
      oneData.allianceName = "[" .. data.abbr .. "]" .. data.allianceName
      oneData.alAbbr = data.abbr
      oneData.allianceRank = data.rank or -1
    else
      oneData.allianceName = ""
      oneData.alAbbr = ""
      oneData.allianceRank = -1
    end
    oneData.pic = thePlayerData:GetPic()
    oneData.picVer = thePlayerData:GetPicVer()
    oneData.headBg = thePlayerData:GetHeadBgImg()
    oneData.nation = thePlayerData.countryFlag
    oneData.level = thePlayerData.level
  end
  return oneData
end

function UIUtil.ShowThumbsUpBroadcastPopUI(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  DataCenter.WorldNoticeManager:ShowThumbsUpBroadcastPopUI(serverId, pointId, sender, text, iconPath, prefabPath, exText)
end

function UIUtil.ShowThumbsUpBroadcastPopUINow(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  if text == nil then
    text = Localization:GetString("thumbs_up_nority")
  end
  if iconPath == nil then
    iconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png"
  end
  if serverId == nil or serverId == 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  local UI_BUBBLE_PATH = prefabPath or "Assets/Main/Prefabs/UI/LWPlayerInfo/ThumbsUpMessageTip.prefab"
  local world = CS.SceneManager.World
  local bubbleHandle
  if not SceneUtils.GetIsInWorld() or world == nil then
    bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  else
    bubbleHandle = world:InstantiateAsyncDynamicObj(UI_BUBBLE_PATH, 0)
  end
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    local world = CS.SceneManager.World
    if not SceneUtils.GetIsInWorld() or world == nil then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    local headIcon = go.transform:Find("bg/headIcon")
    local txt = go.transform:Find("bg/txt")
    local heart = go.transform:Find("bg/heart")
    local exTxt = go.transform:Find("bg/exTxt")
    if headIcon and animRoot then
      local anim = go:GetComponent(typeof(CS.SimpleAnimation))
      local unity_icon = headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
      local unity_txt = txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
      if prefabPath then
        local tmp_unity_txt = txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
        if tmp_unity_txt then
          unity_txt = tmp_unity_txt
        end
      end
      local unity_txt_ex
      if exTxt then
        unity_txt_ex = exTxt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
      end
      local unity_heart_icon = heart.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if unity_icon and anim then
        local specifiedRes
        local playerUid = sender.uid
        local pic = sender.headPic or sender.pic
        local picVer = sender.headPicVer or sender.picVer or sender.picver
        if pic and pic ~= "" and type(pic) == "string" then
          local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
          if pic1 and pic2 then
            specifiedRes = pic2
          end
        end
        go.name = string.format("ThumbsUp_%s", pointId)
        go.transform:SetParent(world.DynamicObjNode)
        go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
        animRoot.gameObject:SetActive(true)
        go:SetActive(true)
        if specifiedRes then
          unity_icon:UseSpecifiedRes(specifiedRes)
        elseif not pic and not picVer then
          unity_icon:UseSystemHead()
        else
          unity_icon:SetData(sender.uid, pic, toInt(picVer), false)
        end
        if anim:IsPlaying("Default") then
          anim:Rewind("Default")
        else
          anim:Play("Default")
        end
        local collider = go.transform:Find("bg/btn"):GetComponent(typeof(TouchObjectEventTrigger))
        
        function collider.onPointerClick()
          if playerUid then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, playerUid)
          end
        end
        
        local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if req ~= nil then
            if collider then
              collider.onPointerClick = nil
            end
            req:Destroy()
          end
          WorldBuildUtil.RemoveWorldAsyncObj(req)
        end, 3)
        WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
      end
      if unity_txt then
        unity_txt.text = text
      end
      if unity_heart_icon then
        unity_heart_icon:LoadSprite(iconPath)
      end
      if unity_txt_ex and exText ~= nil then
        unity_txt_ex.text = exText
      end
    else
      req:Destroy()
    end
  end)
end

function UIUtil.ShowFireworkGiftGotBroadcastPopUI(pointId, sender, text, iconPath)
  if iconPath == nil then
    iconPath = "Assets/Main/Sprites/ItemIcons/item406.png"
  end
  local UI_BUBBLE_PATH = "Assets/Main/Prefabs/Firework/FireworkBoxGetMessageTip.prefab"
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    local headIcon = go.transform:Find("bg/headIcon")
    local txt = go.transform:Find("bg/txt")
    local icon = go.transform:Find("bg/icon")
    if headIcon and animRoot then
      local anim = go:GetComponent(typeof(CS.SimpleAnimation))
      local unity_icon = headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
      local unity_txt = txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
      local unity_item_icon = icon.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if unity_icon and anim then
        local specifiedRes
        local playerUid = sender.uid
        local pic = sender.headPic or sender.pic
        local picVer = sender.headPicVer or sender.picVer or sender.picver
        if pic and pic ~= "" and type(pic) == "string" then
          local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
          if pic1 and pic2 then
            specifiedRes = pic2
          end
        end
        go.name = string.format("FireworkGiftGot_%s", pointId)
        go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
        go.transform.position = Vector3.New(worldPos.x, worldPos.y + 3, worldPos.z)
        animRoot.gameObject:SetActive(true)
        go:SetActive(true)
        if specifiedRes then
          unity_icon:UseSpecifiedRes(specifiedRes)
        elseif not pic and not picVer then
          unity_icon:UseSystemHead()
        else
          unity_icon:SetData(sender.uid, pic, toInt(picVer), false)
        end
        if anim:IsPlaying("Default") then
          anim:Rewind("Default")
        else
          anim:Play("Default")
        end
        local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if req ~= nil then
            req:Destroy()
          end
          WorldBuildUtil.RemoveWorldAsyncObj(req)
        end, 3)
        WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
      end
      if unity_txt then
        unity_txt.text = text
      end
      if unity_item_icon then
        unity_item_icon:LoadSprite(iconPath)
      end
    else
      req:Destroy()
    end
  end)
end

function UIUtil.ShowThumbsUpBroadcastPopUIInCity(pos, sender, text, iconPath, prefabPath)
  if not SceneUtils.GetIsInCity() then
    return
  end
  if text == nil then
    text = Localization:GetString("thumbs_up_nority")
  end
  if iconPath == nil then
    iconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png"
  end
  local UI_BUBBLE_PATH = prefabPath or "Assets/Main/Prefabs/UI/LWPlayerInfo/TrainThumbsUpMessageTip.prefab"
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInCity() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    local headIcon = go.transform:Find("bg/headIcon")
    local txt = go.transform:Find("bg/txt")
    local heart = go.transform:Find("bg/heart")
    if headIcon and animRoot then
      local anim = go:GetComponent(typeof(CS.SimpleAnimation))
      local unity_icon = headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
      local unity_txt = txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
      if prefabPath then
        unity_txt = txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
      end
      local unity_heart_icon = heart.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if unity_icon and anim then
        local specifiedRes
        local playerUid = sender.uid
        local pic = sender.headPic or sender.pic
        local picVer = sender.headPicVer or sender.picVer or sender.picver
        if pic and pic ~= "" and type(pic) == "string" then
          local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
          if pic1 and pic2 then
            specifiedRes = pic2
          end
        end
        go.name = "ThumbsUp"
        go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        go.transform:Set_localPosition(pos.x, pos.y, pos.z)
        go.transform:Set_localScale(2, 2, 2)
        animRoot.gameObject:SetActive(true)
        go:SetActive(true)
        if specifiedRes then
          unity_icon:UseSpecifiedRes(specifiedRes)
        elseif not pic and not picVer then
          unity_icon:UseSystemHead()
        else
          unity_icon:SetData(sender.uid, pic, toInt(picVer), false)
        end
        if anim:IsPlaying("Default") then
          anim:Rewind("Default")
        else
          anim:Play("Default")
        end
        local collider = go.transform:Find("bg/btn"):GetComponent(typeof(TouchObjectEventTrigger))
        
        function collider.onPointerClick()
          if playerUid then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, playerUid)
          end
        end
        
        local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if req ~= nil then
            if collider then
              collider.onPointerClick = nil
            end
            req:Destroy()
          end
          WorldBuildUtil.RemoveWorldAsyncObj(req)
        end, 3)
        WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
      end
      if unity_txt then
        unity_txt.text = text
      end
      if unity_heart_icon then
        unity_heart_icon:LoadSprite(iconPath)
      end
    else
      req:Destroy()
    end
  end)
end

function UIUtil.ShowBuildingPopText(pointId, text, offsetY_, color_)
  local UI_BUBBLE_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/BuildingPopTextMessageTip.prefab"
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not CS.SceneManager.World then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local txt = go.transform:Find("bg/txt")
    local unity_txt = txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
    if not unity_txt then
      req:Destroy()
      return
    end
    go.name = string.format("BuildingPop_%s", pointId)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    if offsetY_ then
      pos.y = pos.y + offsetY_
    end
    go.transform.position = pos
    go:SetActive(true)
    unity_txt.text = text
    unity_txt.color32 = color_ or Color32.white
    go.transform:DOLocalMoveY(pos.y + 1, 2)
    local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
      WorldBuildUtil.RemoveWorldAsyncObj(req)
    end, 3)
    WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
  end)
end

function UIUtil.ShowBuildingPopIconText(pointId, text, offsetY_, color_, iconStr_)
  local UI_BUBBLE_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/BuildingPopIconTextMessageTip.prefab"
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not CS.SceneManager.World then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local txt = go.transform:Find("bg/txt")
    local unity_txt = txt and txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
    if not unity_txt then
      req:Destroy()
      return
    end
    go.name = string.format("BuildingPopIcon_%s", pointId)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    if offsetY_ then
      pos.y = pos.y + offsetY_
    end
    go.transform.position = pos
    go:SetActive(true)
    unity_txt.text = text
    unity_txt.color32 = color_ or Color32.white
    if not string.IsNullOrEmpty(iconStr_) then
      local icon = go.transform:Find("bg/icon")
      if icon then
        local unity_icon = icon.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        if unity_icon then
          unity_icon:LoadSprite(iconStr_)
          icon.gameObject:SetActive(true)
        end
      end
    end
    go.transform:DOLocalMoveY(pos.y + 1, 2)
    local theDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
      WorldBuildUtil.RemoveWorldAsyncObj(req)
    end, 3)
    WorldBuildUtil.UpdateWorldAsyncObj(req, theDelayTimer)
  end)
end

function UIUtil.ShowCostGoldBrickConfirm(giftPackName, costNum, confirmAction)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoldBrickConfirm, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  }, giftPackName, costNum, confirmAction)
end

function UIUtil.CheckActivityCanDrop(activityInfo)
  local isCanDrop = false
  if activityInfo.tableInfo == "activity_drop" and activityInfo:IsValid() then
    if activityInfo.type == EnumActivity.LimitedTimeFeast.Type then
      local activityId = tonumber(activityInfo.activityId)
      local limitPass = DataCenter.ActLimitedTimeFeastData:CheckActDropLimitPass(activityId)
      if limitPass then
        local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(activityId)
        local dataTime = DataCenter.ActLimitedTimeFeastData:GetDataAddServerTime(activityId) or 0
        dataTime = dataTime / 1000
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime, dataTime)
        if isSameDay then
          isCanDrop = cur < max
        else
          isCanDrop = true
        end
      end
    else
      isCanDrop = true
    end
  end
  return isCanDrop
end

function UIUtil.OpenLWUIBuildDetailsView(curBuildIndex)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBuildDetails, tonumber(curBuildIndex))
end

function UIUtil.CheckEventTrigger(opMode, data, delayTime, defaultPlotId, finishCallback)
  local isInSeason = SeasonUtil.IsInSeason()
  if not isInSeason and opMode ~= OpMode.ClickBtnMummyYardOffSeason then
    if finishCallback then
      finishCallback()
    end
    return false
  end
  local plotId = defaultPlotId or 0
  local param = toInt(data)
  local key
  local seasonIndex = SeasonUtil.GetSeason()
  local seasonType = SeasonUtil.GetSeasonSubdivisionType()
  if seasonType == SeasonMapType.Snow then
    key = opMode .. "_ClickGuideTriggerBtn_" .. param
  elseif seasonType ~= SeasonMapType.Nothing and seasonType ~= SeasonMapType.Desert then
    key = string.format("%s_Trigger_%s_%s_%s", opMode, param, seasonIndex, seasonType)
  else
    if finishCallback then
      finishCallback()
    end
    return false
  end
  local hasHistory = Setting:GetPrivateBool(key, false)
  if hasHistory then
    if CS.CommonUtils.IsDebug() then
      Logger.LogInfo("\229\183\178\231\187\143\229\164\132\231\144\134\232\191\135\232\175\165\228\186\139\228\187\182\231\154\132\232\181\155\229\173\163\229\188\149\229\175\188, code = " .. opMode)
    end
    if finishCallback then
      finishCallback()
    end
    return false
  else
    if seasonType == SeasonMapType.CityStronghold then
      if opMode == OpMode.ClickBtnVirusEntry then
        plotId = 104900
      elseif opMode == OpMode.ClickBtnSearchMonster then
        plotId = 105000
      elseif opMode == OpMode.ClickBtnStrongholdMonster then
        plotId = 105100
      elseif opMode == OpMode.ClickBtnWorldCity then
        plotId = 105200
      elseif opMode == OpMode.ClickBtnKingCity then
        plotId = 105300
      elseif opMode == OpMode.ClickBtnWeather then
        plotId = 105400
      elseif opMode == OpMode.ClickMonsterWithVirus then
        plotId = 105500
      elseif opMode == OpMode.ClickBtnOutpost then
        plotId = 105600
      elseif opMode == OpMode.ClickBtnGeneFragment then
        plotId = 105700
      end
    elseif seasonType == SeasonMapType.NineNationRainforest then
      if opMode == OpMode.ClickBtnMilitary then
        plotId = 6101
      elseif opMode == OpMode.ClickBtnStrongholdCity then
        plotId = 6102
      elseif opMode == OpMode.ClickBtnWorldCity then
        plotId = 6103
      elseif opMode == OpMode.ClickBtnKingCity then
        plotId = 6104
      elseif opMode == OpMode.ClickBtnTradeShop then
        plotId = 6105
      elseif opMode == OpMode.ClickBtnOutpostCity then
        plotId = 6106
      elseif opMode == OpMode.ClickBtnAltarCity then
        plotId = 6107
      elseif opMode == OpMode.ClickBtnBigKingCity then
        plotId = 6108
      end
    elseif seasonType == SeasonMapType.Darkness then
      if opMode == OpMode.ClickBtnMilitaryCenter or opMode == OpMode.ClickBtnAllianceCenter then
        plotId = 9056
      elseif opMode == OpMode.ClickBtnTradeShop then
        plotId = 9057
      elseif opMode == OpMode.ClickBtnKingCity then
        plotId = 9059
      elseif opMode == OpMode.ClickBtnWorldCity then
        plotId = 9058
      elseif opMode == OpMode.EnterWorld then
        if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
          plotId = 0
        else
          plotId = 0
        end
      elseif opMode == OpMode.ClickBtnFixLightHouse then
        plotId = 9051
      elseif opMode == OpMode.ClickBtnGotPowerWorker then
        plotId = 9052
      elseif opMode == OpMode.ClickBtnActiveLightHouse then
        plotId = 9053
      elseif opMode == OpMode.ClickBtnLightHouseTab2 then
        plotId = 9054
      elseif opMode == OpMode.ClickBtnMakeMarchWithLight then
        plotId = 9055
      elseif opMode == OpMode.ClickBtnMilitaryCenter then
        plotId = 9056
      elseif opMode == OpMode.ClickBtnBloodyNight then
        plotId = 9065
      elseif opMode == OpMode.ClickBtnS4Tree then
        plotId = 9066
      elseif opMode == OpMode.ClickBtnS4LuckyCat then
        plotId = 9067
      elseif opMode == OpMode.ClickBtnS4WinePub then
        plotId = 9068
      elseif opMode == OpMode.ClickBtnGetEasterEgg then
        plotId = 9069
      elseif opMode == OpMode.ClickBtnS4WinePub2 then
        plotId = 9070
      elseif opMode == OpMode.ClickBtnS4TreePray then
        plotId = 9071
      elseif opMode == OpMode.ClickBtnBloodyNightMonster then
        plotId = 9061
      elseif opMode == OpMode.ClickBtnBloodyNightFlowerCar then
        plotId = 9062
      elseif opMode == OpMode.ClickBtnBloodyNightBoss then
        plotId = 9063
      elseif opMode == OpMode.ClickBtnTacticalCards then
        plotId = 9064
      elseif opMode == OpMode.ClickGoldTreeThird then
        plotId = 9097
      end
    elseif seasonType == SeasonMapType.Mummy then
      if opMode == OpMode.ClickBtnResource and data then
        if param == ResourceType.OBSIDIAN then
          plotId = 8138
        elseif param == ResourceType.FLINT then
          plotId = 8139
        elseif param == ResourceType.AllianceStone then
          plotId = 8140
        end
      elseif opMode == OpMode.EnterWorld then
        plotId = 0
      elseif opMode == OpMode.ClickBtnWorldCity then
        plotId = 8146
      elseif opMode == OpMode.ClickBtnMummyYard then
        plotId = 8135
      elseif opMode == OpMode.ClickBtnMummyMainTab1 then
        plotId = 8136
      elseif opMode == OpMode.ClickBtnMummyMainTab2 then
        plotId = 8137
      elseif opMode == OpMode.ClickBtnResourceLack10 then
        plotId = 8138
      elseif opMode == OpMode.ClickBtnResourceLack13 then
        plotId = 8139
      elseif opMode == OpMode.ClickBtnResourceLack11014 then
        plotId = 8140
      elseif opMode == OpMode.ClickBtnGoldenBeetleBoss then
        plotId = 8141
      elseif opMode == OpMode.ClickBtnAllianceCenter then
        plotId = 8142
      elseif opMode == OpMode.ClickBtnTradeShop then
        plotId = 8143
      elseif opMode == OpMode.ClickBtnKingCity then
        plotId = 8144
      elseif opMode == OpMode.ClickBtnDesertCity then
        plotId = 8130
      elseif opMode == OpMode.ClickBtnDesertSupplies then
        plotId = 8131
      elseif opMode == OpMode.ClickBtnWorldSurprisePoint then
        plotId = 8132
      elseif opMode == OpMode.ClickBtnWorldGreen then
        plotId = 8133
      elseif opMode == OpMode.ClickBtnMainUISandWorm then
      elseif opMode == OpMode.ClickBtnMummyYardOffSeason then
        plotId = 8171
      else
        plotId = 0
      end
    elseif seasonType == SeasonMapType.NineNation then
      if opMode == OpMode.BuildBoxOpenFinish821000 then
        plotId = 9157
      elseif opMode == OpMode.ClickBtnShowMakingCoffeeView then
        plotId = 9158
      elseif opMode == OpMode.BuildBoxOpenFinish827000 then
        plotId = 9159
      elseif opMode == OpMode.ClickBtnStrongholdCity then
        plotId = 9160
      elseif opMode == OpMode.ClickBtnWorldCity then
        plotId = 9161
      elseif opMode == OpMode.ClickBtnKingCity then
        plotId = 9162
      elseif opMode == OpMode.ClickBtnTradeShop then
        plotId = 9163
      elseif opMode == OpMode.ClickBtnOutpostCity then
        plotId = 9164
      elseif opMode == OpMode.ClickBtnBigKingCity then
        plotId = 9165
      end
    elseif seasonType == SeasonMapType.Snow then
      if opMode == OpMode.ClickBtnResource and data then
        if param == ResourceType.OBSIDIAN then
          plotId = 8029
        elseif param == ResourceType.FLINT then
          plotId = 8028
        elseif param == ResourceType.AllianceStone then
          plotId = 8030
        end
      elseif opMode == OpMode.EnterWorld then
        plotId = 0
      elseif opMode == OpMode.ClickBtnThawing then
        plotId = 8023
      elseif opMode == OpMode.ClickBtnFrozen then
        plotId = 8024
      elseif opMode == OpMode.ClickBtnFireWillOn then
        plotId = 8025
      elseif opMode == OpMode.ClickBtnFireWillOff then
        plotId = 8026
      elseif opMode == OpMode.ClickBtnWorldSupplies then
        plotId = 8027
      end
    end
    if plotId ~= 0 then
      local numDelay = tonumber(delayTime)
      if numDelay then
        TimerManager:GetInstance():DelayInvoke(function()
          EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
            plotGroupId = plotId,
            hideMainUI = false,
            callback = finishCallback
          })
        end, numDelay)
      else
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = plotId,
          hideMainUI = false,
          callback = finishCallback
        })
      end
      Setting:SetPrivateBool(key, true)
      return true
    end
  end
  if finishCallback then
    finishCallback()
  end
  return false
end

function UIUtil.HexToColor32(hex)
  if string.IsNullOrEmpty(hex) then
    return Color32.black
  end
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)
  local a = 255
  if #hex == 8 then
    a = tonumber(hex:sub(7, 8), 16)
  end
  return Color32.New(r, g, b, a)
end

function UIUtil.HexToColor(hex)
  if string.IsNullOrEmpty(hex) then
    return Color.black
  end
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)
  local a = 255
  if #hex == 8 then
    a = tonumber(hex:sub(7, 8), 16)
  end
  return Color.New(r / 255, g / 255, b / 255, a / 255)
end

local _lastWantShowAlliance

function UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
  if allianceId == 0 or allianceId == "" or allianceId == nil then
    return
  end
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
  if data == nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    _lastWantShowAlliance = {
      id = allianceId,
      name = allianceName,
      server = serverId,
      timeStamp = curTime
    }
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
  else
    serverId = data.createServer or data.ownerServerId or serverId
    _lastWantShowAlliance = nil
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, allianceName, allianceId, serverId)
  end
end

function UIUtil.TryShowPlayerInfo(playerId)
  if not playerId then
    return
  end
  if playerId == LuaEntry.Player.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, playerId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, playerId)
  end
end

function UIUtil.CheckShowAllianceInfo(serverId, allianceId)
  if _lastWantShowAlliance ~= nil and _lastWantShowAlliance.id == allianceId then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > _lastWantShowAlliance.timeStamp + 3000 then
      _lastWantShowAlliance = nil
      return
    end
    local allianceName = _lastWantShowAlliance.name
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
    _lastWantShowAlliance = nil
    if data ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, allianceName, allianceId, serverId)
    end
  end
end

function UIUtil.TryOpenDetectEventTreasureClaimInfoView(data, windowsName)
  if UIManager:GetInstance():IsWindowOpen(windowsName) then
    EventManager:GetInstance():Broadcast(EventId.RefreshDetectEventGetTreasureClaimInfo, data)
  else
    UIManager:GetInstance():OpenWindow(windowsName, {anim = true}, data)
  end
end

function UIUtil.OpenDetectEventTreasureClaimInfoView(data)
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(data.eventId))
  local hasOpenWin = false
  if detectEventTemplate then
    if detectEventTemplate.type == DetectEventType.TREASURE then
      hasOpenWin = true
      UIUtil.TryOpenDetectEventTreasureClaimInfoView(data, UIWindowNames.UILWDetectEventTreasureClaimInfo)
    elseif detectEventTemplate.type == DetectEventType.TREASURE_ACTIVITY or detectEventTemplate.type == DetectEventType.OFF_SEASON_TREASURE then
      hasOpenWin = true
      local openWinName = UIWindowNames.UILWActDetectEventTreasureClaimInfo
      local isUseOldView = DataCenter.RadarCenterDataManager:GetIsActTreasureUseOldView(tonumber(data.eventId))
      if isUseOldView then
        openWinName = UIWindowNames.UILWActDetectEventTreasureClaimInfo
      else
        openWinName = UIWindowNames.UILWActDetectEventTreasureClaimInfoNew
      end
      UIUtil.TryOpenDetectEventTreasureClaimInfoView(data, openWinName)
    end
  end
  if not hasOpenWin then
    UIUtil.TryOpenDetectEventTreasureClaimInfoView(data, UIWindowNames.UILWDetectEventTreasureClaimInfo)
  end
end

function UIUtil.GetRankBgAndRankIconPathByRank(rank)
  local rankBgName = "cfm_panghangbang_2"
  local rankIconName = "cfm_panghangbang_3"
  if rank == 1 then
    rankBgName = "cfm_panghangbang_4"
    rankIconName = "cfm_panghangbang_5"
  elseif rank == 2 then
    rankBgName = "cfm_panghangbang_6"
    rankIconName = "cfm_panghangbang_7"
  end
  local rankBgPath = string.format(LoadPath.CommonApsNewPath, rankBgName)
  local rankIconPath = string.format(LoadPath.CommonApsNewPath, rankIconName)
  return rankBgPath, rankIconPath
end

function UIUtil.MakeJumpLink(pointId, serverId, worldId, message)
  local tilePos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local link = {
    action = "Jump",
    x = tilePos.x,
    y = tilePos.y,
    server = serverId or LuaEntry.Player:GetCurServerId(),
    worldId = worldId or 0
  }
  local json = rapidjson.encode(link)
  local linkId = base64.encode(json)
  local txt = UIUtil.FormatServerPosition(serverId, tilePos.x, tilePos.y)
  return string.format("<link='%s'><u>%s</u></link>", linkId, message or txt)
end

function UIUtil.UseJumpLink(textMeshPro, eventData, callback)
  if textMeshPro == nil then
    return
  end
  local linkId = textMeshPro:TryGetPointerClickLinkID(eventData.position)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg, callback)
  end
end

local MailDetailLinkOperateFuncDict = {
  [MailDetailLinkOperateType.COPY] = function(linkId, textMeshPro, clickPos)
    UIUtil.MailDetailLinkCopyFunc(linkId, textMeshPro, clickPos)
  end
}

function UIUtil.MailDetailLinkClick(linkId, textMeshPro, clickPos)
  if UIUtil.MailDetailLinkHaveOperateFuncAndRun(linkId, textMeshPro, clickPos) then
  elseif string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

function UIUtil.MailDetailLinkHaveOperateFuncAndRun(linkId, textMeshPro, clickPos)
  local isHave = false
  if MailDetailLinkOperateFuncDict[linkId] then
    isHave = true
    local func = MailDetailLinkOperateFuncDict[linkId]
    func(linkId, textMeshPro, clickPos)
  end
  return isHave
end

function UIUtil.MailDetailLinkCopyFunc(linkId, textMeshPro, clickPos)
  local linkItem = textMeshPro:TryGetPointerClickLinkItme(clickPos)
  if linkItem then
    local copyTxt = linkItem:GetLinkText()
    if not string.IsNullOrEmpty(copyTxt) then
      CommonUtil.CopyTextToClipboard(copyTxt)
      UIUtil.ShowTipsId(128031)
    end
  end
end

function UIUtil.ShowLootRewardList(position, rewardList, totalVal)
  local param = UIRewardTipView.ParamDataClass.New()
  param.totalVal = totalVal or 0
  if rewardList == nil then
    local extraRewards = DataCenter.SeasonDataManager:GetSeasonConfig()
    if extraRewards then
      param.totalVal = toInt(extraRewards.loot_reward_value)
    end
    rewardList = DataCenter.SeasonDataManager:GetLootRewardList()
  end
  if rewardList then
    local _screenPos = PosConverse.UIWorldToScreenPos(position)
    local ScreenSize = CS.UnityEngine.Screen
    if _screenPos.x * 2 < ScreenSize.width then
      param.deltaX = 30
      param.dir = UIRewardTipView.Direction.LEFT
    else
      param.deltaX = -30
      param.dir = UIRewardTipView.Direction.RIGHT
    end
    param.screenPos = _screenPos
    param.position = position
    param.deltaY = 0
    param.rewardList = rewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardTip, {anim = false}, param)
  end
end

function UIUtil.DecodeServerLang(lang)
  if lang == nil then
    return ""
  end
  if not string.IsNullOrEmpty(lang.value) then
    return lang.value
  end
  if not string.IsNullOrEmpty(lang.id) then
    if not table.IsNullOrEmpty(lang.params) then
      local params = {}
      for _, v in ipairs(lang.params) do
        table.insert(params, UIUtil.DecodeServerLang(v))
      end
      return Localization:GetString(lang.id, SafeUnpack(params))
    else
      return Localization:GetString(lang.id)
    end
  end
  return ""
end

local function JsonBuildData(t)
  if t and t.o == 0 then
    return UIUtil.JsonBuildText(t)
  end
  if t and t.o == 1 then
    return UIUtil.JsonBuildDialog(t)
  end
  return nil
end

local function JsonBuildText(t)
  local text = t.t
  return text
end

local function JsonBuildDialog(t)
  local dialog = t.d
  local params = {}
  if not table.IsNullOrEmpty(t.p) then
    for _, v in pairs(t.p) do
      local param = UIUtil.JsonBuildData(v)
      if not string.IsNullOrEmpty(param) then
        table.insert(params, param)
      else
        table.insert(params, "")
      end
    end
  end
  if not table.IsNullOrEmpty(params) then
    return Localization:GetString(dialog, SafeUnpack(params))
  else
    return Localization:GetString(dialog)
  end
end

function UIUtil.ParseEffectValue(effectId, value)
  if not effectId then
    return ""
  end
  local type = toInt(GetTableData(TableName.LW_Effect_Number, tonumber(effectId), "type"))
  local buffAddNum = ""
  if type == 0 then
    buffAddNum = string.GetFormattedSeperatorNum(value)
  elseif type == 1 then
    buffAddNum = string.GetFormattedPercentStr(value)
  elseif type == 2 then
    buffAddNum = "+" .. string.format("%s%%", string.format("%.2f", value * 100))
  elseif type == 3 then
    buffAddNum = "-" .. string.format("%s%%", string.format("%.2f", value * 100))
  end
  return buffAddNum
end

function UIUtil.OpenDecorationPrevieView(decorationId, goodId)
  if decorationId == nil then
    return
  end
  local showDecorationId = tonumber(decorationId) or 0
  if showDecorationId <= 0 then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationPreview, showDecorationId, goodId)
end

function UIUtil.SetTMPHorseRaceLamp(textComponent, widthLimit, rollingDelay, rollingSpeed, rollingHold, textRectTransform, noRollingAlignment)
  local rawWidth = textComponent:GetWidth()
  local width = math.min(widthLimit, rawWidth)
  if rawWidth > width then
    local startPox = 0
    local endPox = width - rawWidth
    if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == 1 then
      startPox = endPox
      endPox = 0
    end
    textRectTransform:Set_anchoredPosition(startPox, 0)
    local tweenSeq = DOTween.Sequence()
    tweenSeq:AppendInterval(rollingDelay)
    tweenSeq:Append(textComponent.transform:DOAnchorPosX(CommonUtil.ArabicAutoMirrorFactor() * endPox, (rawWidth - width) / rollingSpeed):SetEase(CS.DG.Tweening.Ease.Linear))
    tweenSeq:AppendInterval(rollingHold)
    tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    return tweenSeq
  else
    if noRollingAlignment == nil then
      noRollingAlignment = NoRollingAlignment.Middle
    end
    if noRollingAlignment == NoRollingAlignment.Middle then
      local position_x = (widthLimit - rawWidth) / 2
      textRectTransform:Set_anchoredPosition(CommonUtil.ArabicAutoMirrorFactor() * position_x, 0)
    elseif noRollingAlignment == NoRollingAlignment.Left then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        local position_x = widthLimit - rawWidth
        textRectTransform:Set_anchoredPosition(position_x, 0)
      else
        textRectTransform:Set_anchoredPosition(0, 0)
      end
    elseif noRollingAlignment == NoRollingAlignment.Right then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        textRectTransform:Set_anchoredPosition(0, 0)
      else
        local position_x = widthLimit - rawWidth
        textRectTransform:Set_anchoredPosition(position_x, 0)
      end
    end
  end
end

function UIUtil.ShowListItemAnim(item, index, canvas_)
  item:SetLocalScaleXYZ(0.8, 0.8, 1)
  local trans = item.transform
  local delayTime = toInt(index - 1) * 0.06
  local tweenSeq = DOTween.Sequence()
  tweenSeq:AppendInterval(delayTime)
  tweenSeq:Append(trans:DOScale(Vector3.New(1.02, 1.02, 1), 0.133))
  tweenSeq:Append(trans:DOScale(Vector3.New(1, 1, 1), 0.333))
  if canvas_ then
    canvas_:SetAlpha(0)
    tweenSeq:Join(canvas_.unity_canvas_group:DOFade(1, 0.14))
  end
  return tweenSeq
end

function UIUtil.CheckStateIsInRange(stateId)
  local isInRange = true
  local isMusicStatus = DataCenter.StatusManager:CheckStatusType2(stateId, StatusType2.MusicFestivalSkill)
  if isMusicStatus then
    local curScene = CS.SceneManager.CurrSceneID
    if curScene == SceneManagerSceneID.World then
      local effectRangeData = LuaEntry.Effect:GetStatusRange(stateId)
      if effectRangeData and effectRangeData.worldId then
        local targetWorldId = effectRangeData.worldId
        local curWorldId = LuaEntry.Player:GetCurWorldId()
        if curWorldId ~= targetWorldId then
          isInRange = false
        end
      end
    end
  end
  return isInRange
end

function UIUtil.ShowXCount(count)
  return string.format("x%s", count)
end

function UIUtil.CheckDispatchTaskOpen()
  local actDispatchMgr = DataCenter.ActDispatchTaskDataManager
  local isShow = actDispatchMgr:CheckUnlock()
  if not isShow then
    return false
  end
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  if not buildData or buildData.level < 1 then
    return false
  end
  return isShow
end

function UIUtil.ConvertColorToString(color)
  if color == nil or #color < 3 then
    return "#FFFFFF"
  end
  local result
  local r = string.format("%x", color[1])
  local g = string.format("%x", color[2])
  local b = string.format("%x", color[3])
  if color[4] and color[4] < 255 then
    local a = string.format("%x", color[4])
    result = string.format("#%s%s%s%s", r, g, b, a)
  else
    result = string.format("#%s%s%s", r, g, b)
  end
  return result
end

function UIUtil.ShowInfoPop(title, content)
  local param = {}
  param.title = title
  param.content = content
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWInfoPop, {anim = true}, param)
end

function UIUtil.GetHaveCount(theContextType, theId)
  local have = 0
  if theContextType == ResLackContextType.ResItem then
    have = DataCenter.ResourceItemDataManager:GetCountByItemId(theId)
  elseif theContextType == ResLackContextType.Good then
    have = DataCenter.ItemData:GetItemCount(theId)
  elseif theContextType == ResLackContextType.Soldier then
    have = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum(SoldierType.Player, theId)
  elseif theContextType == ResLackContextType.Mummy then
    have = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy, theId)
  else
    have = LuaEntry.Resource:GetCntByResType(theId)
  end
  return have
end

local function UICreateWorldMovingModel(modelPath, flag, point, size)
  if not string.IsNullOrEmpty(modelPath) and flag and 0 < flag and point and 0 < point and size and 0 < size then
    CS.SceneManager.World:UICreateWorldMovingModel(modelPath, flag, point, size)
  end
end

local function ShowAttackUnitsTips(bossType, targetList)
  if bossType and targetList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAttackUnitsTips, {anim = true}, {bossType = bossType, targetList = targetList})
  end
end

function UIUtil.OpenLWUIChatCommonShare(cfgId, extra)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIChatCommonShare, {anim = true}, cfgId, extra)
end

function UIUtil.GetPicUniqueName()
  NameCount = NameCount + 1
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local picName = string.format("pic_%s_%s", curTime, NameCount)
  return picName
end

function UIUtil.GetUICapturePath()
  return CS.UnityEngine.Application.temporaryCachePath .. "/UICapture"
end

function UIUtil.InitBtn(baseContainer, path, callback)
  if not (callback and path) or not baseContainer then
    return
  end
  local btn = baseContainer.AddComponent(baseContainer, UIButton, path)
  if btn then
    btn:SetOnClick(Bind(baseContainer, callback))
  end
  return btn
end

function UIUtil.InitText(baseContainer, path, localKey)
  if not baseContainer or not path then
    return
  end
  local comp = baseContainer:AddComponent(UIText, path)
  if comp and localKey then
    comp:SetLocalText(localKey)
  end
  return comp
end

function UIUtil.SetTextLit(tran, path, key)
  if not tran then
    return
  end
  local _t = tran:Find(path)
  if not _t then
    return
  end
  local lb = _t:GetComponent(UnityTextMeshProEx)
  if IsNotNull(lb) then
    lb.text = Localization:GetString(key)
  end
  return lb
end

function UIUtil.SetTextRaw(tran, path, text)
  if not tran then
    return
  end
  local _t = tran:Find(path)
  if not _t then
    return
  end
  local lb = _t:GetComponent(UnityTextMeshProEx)
  if IsNotNull(lb) then
    lb.text = text
  end
  return lb
end

function UIUtil.DebugSetName(gameObject, name)
  if CommonUtil.IsDebug() then
    gameObject.name = name
  end
end

function UIUtil.GetEffectStr(value_type, value_num, effectId)
  local effectValue = tonumber(value_num) or 0
  local effectType = toInt(value_type)
  local buffNumStr, buffNameStr
  if effectId ~= nil and effectId ~= 0 and effectId ~= "" then
    local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
    if effectLine then
      buffNameStr = effectLine.name
      if value_type == nil then
        effectType = toInt(effectLine.type)
      end
    end
  end
  if effectType == 0 then
    buffNumStr = string.GetFormattedSeparatorNum(toInt(effectValue))
  elseif effectType == 1 then
    buffNumStr = string.GetFormattedPercentStr(effectValue)
  elseif effectType == 2 then
    buffNumStr = "+" .. string.format("%s%%", string.format("%.2f", effectValue * 100))
  elseif effectType == 3 then
    buffNumStr = "-" .. string.format("%s%%", string.format("%.2f", effectValue * 100))
  elseif effectType == 4 then
    local time = ""
    local hour = math.modf(effectValue / 3600)
    local minute = math.modf(effectValue / 60) % 60
    local second = math.floor(effectValue % 60)
    if hour ~= 0 then
      time = time .. hour .. Localization:GetString(100166)
    end
    if minute ~= 0 then
      time = time .. minute .. Localization:GetString(100165)
    end
    if second ~= 0 then
      time = time .. second .. Localization:GetString(372115)
    end
    if time == "" then
      time = 0 .. Localization:GetString(372115)
    end
    if time ~= "" then
      buffNumStr = time
    end
  elseif effectType == 5 then
    return string.formatDecimal(effectValue, 3)
  elseif effectType == 6 then
    buffNumStr = string.GetFormattedStr2(toInt(effectValue))
  elseif effectType == 7 then
    buffNumStr = string.format("%s%%", string.format("%.2f", effectValue * 100))
  elseif effectType == 8 then
    buffNumStr = string.percentage(effectValue, 10000, 2)
  elseif effectType == 9 then
    buffNumStr = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, toInt(effectValue))
  end
  if buffNumStr == nil then
    local err = string.format("UIUtil GetEffectStr (%s, %s, %s)", value_type or "?.", value_num or "?.", effectId or "?.")
    buffNumStr = ""
    Logger.LogError(err)
  end
  return buffNumStr, buffNameStr
end

function UIUtil.GetMinuteSpeedStr(theValue, abbreviationMin)
  local value = toInt(theValue)
  if Localization:HasKey("season_s4_electricity_speed") then
    if value == nil or value == 0 then
      return Localization:GetString("season_s4_electricity_speed", "0")
    end
    if abbreviationMin ~= nil and abbreviationMin < math.abs(value) then
      if value < 0 then
        return Localization:GetString("season_s4_electricity_speed", string.GetFormattedStr2(value))
      end
      return Localization:GetString("season_s4_electricity_speed", "+" .. string.GetFormattedStr2(value))
    end
    if value < 0 then
      return Localization:GetString("season_s4_electricity_speed", string.GetFormattedSeparatorNum(value))
    end
    return Localization:GetString("season_s4_electricity_speed", "+" .. string.GetFormattedSeparatorNum(value))
  end
  if value == nil or value == 0 then
    return "0/min"
  end
  if abbreviationMin ~= nil and abbreviationMin < math.abs(value) then
    if value < 0 then
      return string.GetFormattedStr2(value) .. "/min"
    end
    return "+" .. string.GetFormattedStr2(value) .. "/min"
  end
  if value < 0 then
    return string.GetFormattedSeparatorNum(value) .. "/min"
  end
  return "+" .. string.GetFormattedSeparatorNum(value) .. "/min"
end

function UIUtil.GetFullPath(rootPath, fileName, fileExt)
  if fileName then
    if string.sub(fileName, 1, 7) == "Assets/" then
      return fileName
    end
    if string.endswith(rootPath, "%s") then
      if fileExt == nil or string.endswith(fileName, fileExt) then
        return string.format(rootPath, fileName)
      end
      return string.format(rootPath, fileName .. fileExt)
    end
    if fileExt == nil or string.endswith(fileName, fileExt) then
      return rootPath .. fileName
    end
    return rootPath .. fileName .. fileExt
  end
  return ""
end

local function OpenModuleCheck(key, contentKey, btnKey, callback, time)
  local customValue = LuaEntry.Player:GetUserSetting(key)
  if customValue == nil or customValue == "0" then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCommonModuleCheck, {anim = true}, key, contentKey, btnKey, callback, time)
    return true
  end
  return false
end

function UIUtil.MoveAnchoredPosition(container, tarPos, moveType, moveParam, callback)
  local curPos = container.rectTransform.anchoredPosition
  local nextPos = moveType == 1 and Vector2.Lerp(curPos, tarPos, moveParam) or curPos + Vector2.Normalize(tarPos - curPos) * moveParam * Time.deltaTime
  if moveType == 0 then
    local dotProduct = Vector2.Dot(tarPos - curPos, tarPos - nextPos)
    if dotProduct <= 0 then
      nextPos = tarPos
      if callback ~= nil then
        callback()
      end
    end
  else
    local distance = Vector2.Distance(nextPos, curPos)
    if distance < 1 then
      nextPos = tarPos
      if callback ~= nil then
        callback()
      end
    end
  end
  container.rectTransform:Set_anchoredPosition(nextPos.x, nextPos.y)
end

function UIUtil.GetComponent(go, theType, path)
  if theType ~= nil and IsNotNull(go) then
    if path == nil or path == "" then
      return go:GetComponent(typeof(theType))
    end
    local transform = go.transform
    if transform ~= nil then
      transform = transform:Find(path)
      if transform ~= nil then
        return transform:GetComponent(typeof(theType))
      end
    end
  end
  return nil
end

function UIUtil.MovePosition(container, tarPos, moveType, moveParam, callback)
  local curPos = container.rectTransform.position
  local nextPos = moveType == 1 and Vector3.Lerp(curPos, tarPos, moveParam) or curPos + Vector3.Normalize(tarPos - curPos) * moveParam * Time.deltaTime
  if moveType == 0 then
    local dotProduct = Vector3.Dot(tarPos - curPos, tarPos - nextPos)
    if dotProduct <= 0 then
      nextPos = tarPos
      if callback ~= nil then
        callback()
      end
    end
  else
    local distance = Vector3.Distance(nextPos, curPos)
    if distance < 1 then
      nextPos = tarPos
      if callback ~= nil then
        callback()
      end
    end
  end
  container:SetPosition(nextPos)
end

local function InsertAssistanceCityBtn(btnList, pointId, assistanceType, canMultipleAssistance)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(pointId)
    if 0 < assistanceCount then
      if canMultipleAssistance then
        table.insert(btnList, WorldPointBtnType.CallBack)
        table.insert(btnList, assistanceType)
      else
        table.insert(btnList, WorldPointBtnType.CallBack)
      end
    elseif assistanceType then
      table.insert(btnList, assistanceType)
    end
    return
  end
  if assistanceType then
    table.insert(btnList, assistanceType)
  end
end

local function ShowErrorCodeTips(message)
  if not message.errorCode then
    return
  end
  if message.chatBanTime then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local time = message.chatBanTime - serverTime
    local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(time / 1000)
    local strTips = Localization:GetString(message.errorCode, strExpireTime)
    UIUtil.ShowTips(strTips)
    return
  end
  local para2 = message.errorPara2
  if para2 == nil then
    UIUtil.ShowTipsId(message.errorCode)
  elseif type(para2) == "table" and 0 < #para2 then
    UIUtil.ShowTips(Localization:GetString(message.errorCode, table.unpack(para2)))
  end
end

function UIUtil.ShowCountdownTimeUI(endTimeMs, finalTxt, bannerTxt, openTimeMs_)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonCountdown, {anim = true}, {
    endTime = endTimeMs,
    finalTxt = finalTxt,
    bannerTxt = bannerTxt,
    openTimeMs = openTimeMs_ or UITimeManager:GetInstance():GetServerTime()
  })
end

function UIUtil.ShowGovernmentActivityMain()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentActivityMainS4, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentActivityMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

function UIUtil.ShowResistanceWarning(data, checkResistance, callback)
  local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
  if seasonType ~= SeasonMapType.CityStronghold or seasonVersion == 0 or not DataCenter.SeasonDataManager:InNormalMode() then
    return false
  end
  if data == nil then
    return false
  end
  if checkResistance and 0 <= data.selfPercent then
    return false
  end
  data.checkResistance = checkResistance
  if not checkResistance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResistanceWarningPanel, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, data, callback)
    return true
  elseif DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ResistanceWarningTip) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResistanceWarningPanel, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, data, callback)
    return true
  end
  return false
end

function UIUtil.OpenGiftShowDetailInfoView(targetUid, targetServerId, originIdList, originIdIndex)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIGiftShowDetailInfo) then
    local param = {
      targetUid = targetUid,
      targetServerId = targetServerId,
      originIdList = originIdList,
      originIdIndex = originIdIndex
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftShowDetailInfo, {anim = true}, param)
    EventManager:GetInstance():Broadcast(EventId.OnGiftShowDeatilViewReopen, param)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftShowDetailInfo, {anim = true}, {
      targetUid = targetUid,
      targetServerId = targetServerId,
      originIdList = originIdList,
      originIdIndex = originIdIndex
    })
  end
end

function UIUtil.ShowFloatAnim(uiBaseContainer, prefabPath, startAnchoredPosition, uiAsyncContainer, data)
  if uiBaseContainer == nil or string.IsNullOrEmpty(prefabPath) then
    Logger.LogError("UIUtil.ShowFloatAnim uiBaseContainer or prefabPath is nil")
    return
  end
  uiAsyncContainer = uiAsyncContainer or UIAsyncContainer
  startAnchoredPosition = startAnchoredPosition or Vector2.zero
  local floatItem = uiBaseContainer:LoadComponentAsync(uiAsyncContainer, prefabPath, nil, function(holder, go, item)
    item:SetAnchoredPosition(startAnchoredPosition)
    go.transform:DOAnchorPosY(startAnchoredPosition.y + 100, 2)
    local cg = go:GetOrAddComponent(typeof(CS.UnityEngine.CanvasGroup))
    if cg then
      cg.alpha = 1
      cg:DOFade(0, 2):OnComplete(function()
        uiBaseContainer:RemoveAsyncComponent(item)
      end)
    else
      go.transform:Set_localScale(1, 1, 1)
      go.transform:DOScale(Vector3.one * 0.5, 2):OnComplete(function()
        uiBaseContainer:RemoveAsyncComponent(item)
      end)
    end
  end)
  if data and floatItem.SetData then
    floatItem:SetData(data)
  end
end

function UIUtil.CheckGiftShowDetailInfoViewIsOpen()
  local k1 = LuaEntry.DataConfig:TryGetNum("gift_show_control", "k1")
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if CS.NetworkURLConfig.IsPressureTest then
    if k1 == 1 then
      if selfServerId <= 46 then
        return true
      end
    elseif k1 == 2 then
      return true
    end
  elseif CS.NetworkURLConfig.IsOnline then
    if k1 == 1 then
      if selfServerId <= 68 then
        return true
      end
    elseif k1 == 2 then
      return true
    end
  elseif k1 == 1 or k1 == 2 then
    return true
  end
  return false
end

function UIUtil.CheckIsArabicTMPFix()
  local open = LuaEntry.DataConfig:CheckSwitch("arabic_fix_test")
  CS.GameDefines.isArabicTMPFix = open
end

function UIUtil.CheckIsUploadImageFix()
  local open = LuaEntry.DataConfig:CheckSwitch("upload_image_fix")
  CS.SDKManager.isUploadImageFix = open
end

function UIUtil.CheckIsIgnoreWindowAtMobileInputFunc(windowName)
  if IGNORE_WINDOW_AT_MI_LIST[windowName] then
    return true
  end
  return false
end

function UIUtil.CheckNormalLayerWindowIsNotCovered(windowName)
  local isNotCovered = true
  if UIManager.Instance:HasWindowByLayer(UILayer.Dialog) then
    isNotCovered = false
    return isNotCovered
  end
  if UIManager.Instance:HasWindowByLayer(UILayer.Info) then
    isNotCovered = false
    return isNotCovered
  end
  local window = UIManager.Instance:GetWindow(windowName)
  if window then
    local wind = UIManager.Instance.windowStack:find(window)
    if wind then
      local windowStack = UIManager.Instance.windowStack
      while wind and isNotCovered do
        wind = windowStack:next(wind)
        if wind and wind.value then
          local config = UIManager.Instance:GetWindowConfig(wind.value.Name)
          if config ~= nil and config.Layer == UILayer.Normal then
            isNotCovered = false
          end
        end
      end
    end
  end
  return isNotCovered
end

function UIUtil.ShowS1HowToPlay(id)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType ~= SeasonMapType.CityStronghold then
    return false
  end
  local param = {}
  param.howToPlayList = {id}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  return true
end

local assetCheckCache = {}

function UIUtil.CheckAssetDownloaded(path)
  if not path then
    return false
  end
  local assetIsReady = assetCheckCache[path]
  if not assetIsReady then
    assetIsReady = CS.GameEntry.Resource:PrefabAssetsDownloaded(path)
    assetCheckCache[path] = assetIsReady
  end
  return assetIsReady
end

function UIUtil.ClearAssetDownloaded()
  assetCheckCache = {}
end

local screenToucher = CS.Framework.Utils.UnityEx.ScreenToucher

function UIUtil.TryRegisterScreenRectTouchEvent(rectTransform)
  if not rectTransform then
    return
  end
  if screenToucher then
    screenToucher.RegisterScreenRect(rectTransform)
  end
end

function UIUtil.ClearInterestedRect()
  if screenToucher then
    screenToucher.ClearInterestedRect()
  end
end

function UIUtil.OpenFormationSelectUI(...)
  if LuaEntry.DataConfig:CheckSwitch("formation_v2_switch") then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationSelectListV2, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, ...)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationSelectListNew, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, ...)
  end
end

function UIUtil.HandleDialogSkinByServerId()
  if type(Localization.UpdateSkinData) == "function" and LocalController:instance():hasTable(TableName.Dialog_Skin) then
    local serverId = LuaEntry.Player.serverId
    local dict = {}
    LocalController:instance():visitTable(TableName.Dialog_Skin, function(id, line)
      if line and not string.IsNullOrEmpty(line.server_condition) then
        local serverStr = string.split(line.server_condition, ";")
        if not table.IsNullOrEmpty(serverStr) then
          for _, server in pairs(serverStr) do
            local pair = string.split(server, "-")
            local sMin = 0
            local sMax = 0
            if table.count(pair) == 1 then
              sMin = checknumber(pair[1])
              sMax = checknumber(pair[1])
            elseif table.count(pair) == 2 then
              sMin = checknumber(pair[1])
              sMax = checknumber(pair[2])
            end
            if sMin <= serverId and sMax >= serverId then
              dict[line.dialog_1] = line.dialog_2
              break
            end
          end
        end
      end
    end)
    SeasonUtil.UpdateDialogSkin(dict, false)
  end
end

function UIUtil.IsEA()
  return CS.GrayUtils.InGrayServer(3, 68) or CS.GrayUtils.InGrayServer(8001, 8008)
end

function UIUtil.OpenAuto(name, ...)
  UIManager:GetInstance():OpenWindow(name, {anim = true}, ...)
end

function UIUtil.LoadSpriteRenderAuto(sprite, path, defaultPath)
  if sprite == nil then
    return
  end
  if string.IsNullOrEmpty(path) then
    if not string.IsNullOrEmpty(defaultPath) then
      sprite:LoadSprite(defaultPath)
    end
    return
  end
  local assetPath = path
  local nameLength = #path
  if 4 < nameLength and string.find(path, ".png", nameLength - 3, true) == nil then
    assetPath = path .. ".png"
  end
  if UIUtil.CheckAssetDownloaded(assetPath) then
    sprite:LoadSprite(assetPath)
  else
    sprite:LoadSpriteAsync(assetPath)
  end
end

function UIUtil.GetFixedArabicAddCharPosList(str, inputComp)
  local fixList = {}
  local ret, arabicCount = inputComp:HasArabic(str)
  local isFix = false
  if ret then
    if Localization.Language == CS.GameFramework.Localization.Language.Arabic then
      isFix = true
    else
      local count = string.word_count(str)
      if 0 < arabicCount and 0 < count and arabicCount / count >= CS.ArabicSupport.ArabicFixer.ArabicJudgeRate then
        isFix = true
      end
    end
  end
  if isFix then
    local unicodeMark = "\226\128\142"
    local fixStr = inputComp:FixSpaces(str)
    local len = string.len(fixStr)
    local left = len
    local cnt = 0
    local arr = {
      0,
      192,
      224,
      240,
      248,
      252
    }
    while 0 < left do
      local tmp = string.byte(fixStr, -left)
      local i = #arr
      while arr[i] do
        if tmp >= arr[i] then
          left = left - i
          break
        end
        i = i - 1
      end
      cnt = cnt + 1
      if i == 3 and 0 < left then
        local char = fixStr:sub(-(left + 3), -(left + 1))
        if char == unicodeMark then
          table.insert(fixList, cnt)
        end
      end
    end
  end
  return fixList
end

UIUtil.ShowSecondMessageByParam = ShowSecondMessageByParam
UIUtil.ShowMessage = ShowMessage
UIUtil.TryShowConfirm = TryShowConfirm
UIUtil.ShowUseDiamondConfirm = ShowUseDiamondConfirm
UIUtil.ShowMessageWithCountdown = ShowMessageWithCountdown
UIUtil.ShowBuyMessage = ShowBuyMessage
UIUtil.ShowNoToggleSecondMessage = ShowNoToggleSecondMessage
UIUtil.ShowSecondMessage = ShowSecondMessage
UIUtil.GetActiveCount = GetActiveCount
UIUtil.ShowIntro = ShowIntro
UIUtil.ShowUseItemTip = ShowUseItemTip
UIUtil.ShowComplexTip = ShowComplexTip
UIUtil.ShowTips = ShowTips
UIUtil.ShowTipsId = ShowTipsId
UIUtil.ShowTipsLocalization = ShowTipsLocalization
UIUtil.SetLeftTimeText = SetLeftTimeText
UIUtil.GetResourcePos = GetResourcePos
UIUtil.CalcConstructMilePointer = CalcConstructMilePointer
UIUtil.CalcMilePointer = CalcMilePointer
UIUtil.PlayAnimationReturnTime = PlayAnimationReturnTime
UIUtil.ClickBuildAdjustCameraView = ClickBuildAdjustCameraView
UIUtil.IsInView = IsInView
UIUtil.IsInViewByIndex = IsInViewByIndex
UIUtil.IsInViewByTileXY = IsInViewByTileXY
UIUtil.OpenOrRefreshUIWorldPoint = OpenOrRefreshUIWorldPoint
UIUtil.OnClickWorld = OnClickWorld
UIUtil.OnClickWorldPostProcess = OnClickWorldPostProcess
UIUtil.OnClickWorldTroop = OnClickWorldTroop
UIUtil.OnClickSandWorm = OnClickSandWorm
UIUtil.OnClickMultiObjects = OnClickMultiObjects
UIUtil.OnClickWorldTrain = OnClickWorldTrain
UIUtil.CloseWorldMarchTileUI = CloseWorldMarchTileUI
UIUtil.ClickCloseWorldUI = ClickCloseWorldUI
UIUtil.ClickWorldCloseWorldUI = ClickWorldCloseWorldUI
UIUtil.ClickUICloseWorldUI = ClickUICloseWorldUI
UIUtil.OnClickCity = OnClickCity
UIUtil.DragWorldCloseWorldUI = DragWorldCloseWorldUI
UIUtil.ShowUnlockWindow = ShowUnlockWindow
UIUtil.ShowGuideBtnUnlockWindow = ShowGuideBtnUnlockWindow
UIUtil.ClickFarmAdjustPos = ClickFarmAdjustPos
UIUtil.CheckNeedQuitFocus = CheckNeedQuitFocus
UIUtil.GetUIMainSavePos = GetUIMainSavePos
UIUtil.OnPointDownMarch = OnPointDownMarch
UIUtil.OnPointUpMarch = OnPointUpMarch
UIUtil.OnMarchDragStart = OnMarchDragStart
UIUtil.DoFly = DoFly
UIUtil.DoFlyStraight = DoFlyStraight
UIUtil.DoFlyCustom = DoFlyCustom
UIUtil.DoFlySimpleFunc = DoFlySimpleFunc
UIUtil.DoFlySimpleFuncDelay = DoFlySimpleFuncDelay
UIUtil.GetSelfMarchCountExceptGolloes = GetSelfMarchCountExceptGolloes
UIUtil.ShowSingleTip = ShowSingleTip
UIUtil.IsPad = IsPad
UIUtil.LoadPrefab = LoadPrefab
UIUtil.OpenHeroStationByBuildUuid = OpenHeroStationByBuildUuid
UIUtil.OpenHeroStationByStationId = OpenHeroStationByStationId
UIUtil.OpenHeroStationByEffectType = OpenHeroStationByEffectType
UIUtil.CheckAndOpenBusinessCenter = CheckAndOpenBusinessCenter
UIUtil.ShowPiggyBankTip = ShowPiggyBankTip
UIUtil.ShowEnergyBankTip = ShowEnergyBankTip
UIUtil.GetAllianceItemPos = GetAllianceItemPos
UIUtil.DoJumpFly = DoJumpFly
UIUtil.GetUIMainEnergySlider = GetUIMainEnergySlider
UIUtil.GetEnergyIconPos = GetEnergyIconPos
UIUtil.ShowSpecialTips = ShowSpecialTips
UIUtil.ShowSelectArmy = ShowSelectArmy
UIUtil.GetFlyTargetPosByRewardType = GetFlyTargetPosByRewardType
UIUtil.ShowPvePowerLack = ShowPvePowerLack
UIUtil.PveSceneHeroListRefresh = PveSceneHeroListRefresh
UIUtil.PveSceneHeroListScrollToHero = PveSceneHeroListScrollToHero
UIUtil.GetItemQualityBg = GetItemQualityBg
UIUtil.GetColorByQuality = GetColorByQuality
UIUtil.ShowFlyText = ShowFlyText
UIUtil.InsertAssistanceCityBtn = InsertAssistanceCityBtn
UIUtil.GetScaleFactor = GetScaleFactor
UIUtil.ClearReward = ClearReward
UIUtil.RefreshReward = RefreshReward
UIUtil.GetFlyTargetByRewardType = GetFlyTargetByRewardType
UIUtil.CheckHaveEnoughItemRename = CheckHaveEnoughItemRename
UIUtil.IsRedPointCustomizeAvatar = IsRedPointCustomizeAvatar
UIUtil.OpenDetectEventView = OpenDetectEventView
UIUtil.OnClickDispatchTask = OnClickDispatchTask
UIUtil.OnClickGhostreconPoint = OnClickGhostreconPoint
UIUtil.ShowBubbleTips = ShowBubbleTips
UIUtil.ShowBubbleTipsAuto = ShowBubbleTipsAuto
UIUtil.GetFreeStaminaTime = GetFreeStaminaTime
UIUtil.ShowPowerUpTip = ShowPowerUpTip
UIUtil.ShowPowerUpTipNew = ShowPowerUpTipNew
UIUtil.StageJump = StageJump
UIUtil.FormatAllianceAndName = FormatAllianceAndName
UIUtil.FormatServerAllianceName = FormatServerAllianceName
UIUtil.FormatServerPosition = FormatServerPosition
UIUtil.FormatServerName = FormatServerName
UIUtil.IsFreeMoveCityInOpenServerTime = IsFreeMoveCityInOpenServerTime
UIUtil.IsFormationBuffInfoOpen = IsFormationBuffInfoOpen
UIUtil.OpenFreeMoveCityInOpenServerTimeConfirmPanel = OpenFreeMoveCityInOpenServerTimeConfirmPanel
UIUtil.OpenUIPlayerInfo = OpenUIPlayerInfo
UIUtil.PlayScaleAnim = PlayScaleAnim
UIUtil.GetDetectTreasureReward = GetDetectTreasureReward
UIUtil.IsFreeCreateAllianceInOpenServerTime = IsFreeCreateAllianceInOpenServerTime
UIUtil.PlayCutSceneAnim = PlayCutSceneAnim
UIUtil.OnJoinAllianceBtnClick = OnJoinAllianceBtnClick
UIUtil.GetDeltaTimeTimeStr = GetDeltaTimeTimeStr
UIUtil.IsOpenDeleteAccountFunc = IsOpenDeleteAccountFunc
UIUtil.SendDelAllAcctApplyCancelMsg = SendDelAllAcctApplyCancelMsg
UIUtil.DeleteAccountBtnClick = DeleteAccountBtnClick
UIUtil.DoFlyText = DoFlyText
UIUtil.DoFlyWithoutLogic = DoFlyWithoutLogic
UIUtil.ShowUseResItemMessage = ShowUseResItemMessage
UIUtil.JsonBuildData = JsonBuildData
UIUtil.JsonBuildText = JsonBuildText
UIUtil.JsonBuildDialog = JsonBuildDialog
UIUtil.UICreateWorldMovingModel = UICreateWorldMovingModel
UIUtil.ShowAttackUnitsTips = ShowAttackUnitsTips
UIUtil.ShowErrorCodeTips = ShowErrorCodeTips
UIUtil.TryShowConfirmParams = TryShowConfirmParams
UIUtil.TryShowConfirmNew = TryShowConfirmNew
UIUtil.ShowConfirmNew = ShowConfirmNew
UIUtil.TryConfirmUseLimitedDecorationItem = TryConfirmUseLimitedDecorationItem
UIUtil.TryShowDiamondConfirm = TryShowDiamondConfirm
UIUtil.OpenModuleCheck = OpenModuleCheck
UIUtil.BtnColorSpriteName = {
  Red = "tongyong_cfm_anniu_4",
  Blue = "tongyong_cfm_anniu_5",
  Yellow = "tongyong_cfm_anniu_3"
}
return ConstClass("UIUtil", UIUtil)
