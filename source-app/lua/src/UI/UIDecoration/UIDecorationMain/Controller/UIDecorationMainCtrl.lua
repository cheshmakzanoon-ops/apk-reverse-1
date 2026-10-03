local UIDecorationMainCtrl = BaseClass("UIDecorationMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, backToActivity)
  EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewClose)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationMain)
end

local function IsShowRedPointOrNew(self, skinTemplate)
  if skinTemplate == nil then
    return false, false, false
  end
  local showRedPoint = false
  local hasGainItem = false
  local hasNew = false
  local showNew = false
  local showAddRedPoint = false
  local methods = skinTemplate.gainMethod
  local data = DataCenter.DecorationDataManager:GetSkinDataById(skinTemplate.id)
  local isUnlock = skinTemplate:IsDefault() or data ~= nil and data:IsInExpireTime()
  for _, v in pairs(methods) do
    local itemCount = DataCenter.ItemData:GetItemCount(v.id)
    if 0 < itemCount then
      hasGainItem = true
      hasNew = hasNew or DataCenter.DecorationDataManager:IsNewDecorationItem(v.id)
    end
  end
  if not isUnlock then
    showRedPoint = hasGainItem
    showNew = hasNew
    if not showNew and skinTemplate:IsHot() then
      showNew = true
    end
  else
    showAddRedPoint = hasGainItem
  end
  return showRedPoint, showNew, showAddRedPoint
end

local function GetPanelData(self, currentSelectType, currentSelectDecoration)
  local allTypes = DataCenter.DecorationTemplateManager:GetAllTypes(DecorationShowGroup.City)
  currentSelectType = currentSelectType or allTypes[1]
  local allTypeDecoration = DataCenter.DecorationTemplateManager:GetTypeDecorations(currentSelectType)
  local allTypeResult = {}
  local allTypeDecorationResult = {}
  for _, v in ipairs(allTypes) do
    local tmp = {}
    tmp.id = v
    if tmp.id == DecorationType.DecorationType_Main_City then
      tmp.name = 2000459
    elseif tmp.id == DecorationType.DecorationType_Head_Frame then
      tmp.name = 2000460
    elseif tmp.id == DecorationType.DecorationType_TittleName then
      tmp.name = 2000461
    elseif tmp.id == DecorationType.DecorationType_Main_Effect then
      tmp.name = 2000483
    elseif tmp.id == DecorationType.DecorationType_Chat_Bubble then
      tmp.name = 2900048
    elseif tmp.id == DecorationType.DecorationType_Emoji then
      tmp.name = "map_stickers"
    elseif tmp.id == DecorationType.DecorationType_MultiKill then
      tmp.name = "killstreak_report_decoration_1"
    end
    tmp.icon1 = string.format(LoadPath.UIDecoration, "UIskin_btn_skin_" .. v .. "_1.png")
    tmp.icon2 = string.format(LoadPath.UIDecoration, "UIskin_btn_skin_" .. v .. "_2.png")
    if tmp.id == DecorationType.DecorationType_Emoji then
      table.insert(allTypeResult, tmp)
    elseif tmp.id ~= DecorationType.DecorationType_MultiKill or LuaEntry.DataConfig:CheckSwitch("killstreak_report_decoration") then
      table.insert(allTypeResult, tmp)
    end
  end
  local envelopSkinId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k4")
  local envelopSkinData = DataCenter.DecorationDataManager:GetSkinDataById(envelopSkinId)
  local canRemoveVipPreviewSkin = envelopSkinData ~= nil
  for _, v in ipairs(allTypeDecoration) do
    local tmp = {}
    tmp.id = v
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    local decorationIsUnlock = DataCenter.DecorationDataManager:IsUnlock(v)
    tmp.isUnlock = decorationIsUnlock
    local currentSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type, true)
    tmp.inUse = currentSkinId == tmp.id
    if template:CheckTemplateCanShow() or tmp.isUnlock then
      if currentSelectDecoration == nil and tmp.inUse then
        currentSelectDecoration = v
      end
      tmp.colorBg = DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
      tmp.icon = template.icon
      tmp.img = template.img
      tmp.order = template.order
      local showRedPoint, showNew, showAddRedPoint = IsShowRedPointOrNew(self, template)
      tmp.showRedPoint = showRedPoint
      tmp.showNew = showNew
      tmp.showAddRedPoint = showAddRedPoint
      tmp.name = template.name
      tmp.type = template.type
      tmp.customVariable = template.customVariable
      table.insert(allTypeDecorationResult, tmp)
    end
  end
  if currentSelectType == DecorationType.DecorationType_Emoji then
    local stickerUidDict = {}
    for i = #allTypeDecorationResult, 1, -1 do
      local decoId = allTypeDecorationResult[i].id
      local suid = DataCenter.StickerWithDecorationLinkManager:GetStickerUidByDecoId(decoId)
      if stickerUidDict[suid] then
        table.remove(allTypeDecorationResult, i)
      else
        stickerUidDict[suid] = true
      end
    end
  end
  local vipPreviewSkinId = LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  if vipPreviewSkinId ~= nil and 0 < vipPreviewSkinId and canRemoveVipPreviewSkin then
    for i = #allTypeDecorationResult, 1, -1 do
      if allTypeDecorationResult[i].id == vipPreviewSkinId then
        table.remove(allTypeDecorationResult, i)
        break
      end
    end
  end
  table.sort(allTypeDecorationResult, function(k, v)
    if k.isUnlock ~= v.isUnlock then
      return k.isUnlock
    end
    return k.order < v.order
  end)
  if currentSelectType == DecorationType.DecorationType_Emoji then
    currentSelectDecoration = DataCenter.DecorationDataManager:GetStickerPlaneIndex()
  else
    currentSelectDecoration = currentSelectDecoration or allTypeDecoration[1]
  end
  return currentSelectType, currentSelectDecoration, allTypeResult, allTypeDecorationResult
end

local function GetHeadFrameData(self, decorationId)
  local result = {}
  result.decorationId = decorationId
  result.frame = DataCenter.DecorationDataManager:GetHeadFrame(decorationId, LongMaxValue)
  return result
end

local function GetChatBubbleData(self, decorationId)
  local result = {}
  result.decorationId = decorationId
  result.frame = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  result.bubbleRes, result.msgColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(decorationId, LongMaxValue)
  return result
end

local function GetMainCityData(self, decorationId)
  local result = {}
  result.decorationId = decorationId
  local dazzleTemp = DataCenter.DecorationDazzleManager:GetWearDazzleTemp(decorationId)
  result.colourId = dazzleTemp and dazzleTemp.id
  return result
end

local function IsTypeShowRedPoint(self, type)
  local allTypeDecoration = DataCenter.DecorationTemplateManager:GetTypeDecorations(type)
  for _, v in pairs(allTypeDecoration) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    local showRedPoint, showNew, showAddRedPoint = IsShowRedPointOrNew(self, template)
    if showRedPoint then
      return true
    end
  end
  return false
end

function UIDecorationMainCtrl:GetStickerTabData()
  local tabDataList = {}
  local normalTabData = {}
  normalTabData.name = "auto_sticker_tab_1"
  table.insert(tabDataList, normalTabData)
  if DataCenter.LWSticker3DManager:IsCommonStickerTabOpen() then
    local tabData = {}
    tabData.name = "auto_sticker_tab_2"
    table.insert(tabDataList, tabData)
  end
  if DataCenter.LWSticker3DManager:IsSpecialStickerTabOpen() then
    local tabData = {}
    tabData.name = "auto_sticker_tab_3"
    table.insert(tabDataList, tabData)
  end
  return tabDataList
end

UIDecorationMainCtrl.CloseSelf = CloseSelf
UIDecorationMainCtrl.IsShowRedPointOrNew = IsShowRedPointOrNew
UIDecorationMainCtrl.GetPanelData = GetPanelData
UIDecorationMainCtrl.GetHeadFrameData = GetHeadFrameData
UIDecorationMainCtrl.GetChatBubbleData = GetChatBubbleData
UIDecorationMainCtrl.GetMainCityData = GetMainCityData
UIDecorationMainCtrl.IsTypeShowRedPoint = IsTypeShowRedPoint
return UIDecorationMainCtrl
