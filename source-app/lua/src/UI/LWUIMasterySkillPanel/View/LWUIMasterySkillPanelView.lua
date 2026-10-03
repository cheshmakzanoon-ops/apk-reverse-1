local LWUIMasterySkillPanelView = BaseClass("LWUIMasterySkillPanelView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillPanelItem = require("UI.LWUIMasterySkillPanel.Component.LWUIMasterySkillPanelItem")
local BtnReset_path = "Root/BottomBar/BtnReset"
local content_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content"
local bgContent_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/bgContent"
local bgItem_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/bgContent/bgItem"
local levelContent_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/levelContent"
local levelItem_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/levelContent/levelItem"
local lineContent_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/lineContent"
local lineItem_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/lineContent/lineItem"
local openLineContent_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/openLineContent"
local openLineItem_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/openLineContent/openLineItem"
local itemContent_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/ItemContent"
local skillItem_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/ItemContent/skillItem"
local homeIcon_path = "Root/MiddleContentContainer/homeInfoContent/homeIcon"
local homeBigBg_path = "Root/MiddleContentContainer/homeInfoContent/homeBigBg"
local homeName_path = "Root/MiddleContentContainer/homeInfoContent/homeName"
local havePointTxt_path = "Root/MiddleContentContainer/homeInfoContent/havePointTxt"
local desTxt_path = "Root/MiddleContentContainer/homeInfoContent/desTxt"
local homeInfoContent_path = "Root/MiddleContentContainer/homeInfoContent"
local home_level_path = "Root/MiddleContentContainer/homeInfoContent/homeLevel"
local scroll_view_path = "Root/MiddleContentContainer/ScrollView"
local show_skill_btn_path = "Root/BottomBar/showSkillBtn"
local text_title_path = "Root/TopBar/TextTitle"
local red_point_path = "Root/BottomBar/showSkillBtn/redPoint"
local itemW = 780
local itemH = 260
local masteryItemLeftSpace = 10
local masteryItemW = 190
local masteryItemH = 170
local contentW = 780
local layerSpecialLv = 1
local layerIntervalLv = 5
local grayLineW = 10
local blueLineW = 16
local talentItemCount = 3
local talentItemWidth = 160
local talentItemHalfWidth = talentItemWidth / 2
local talentItemSpace = (contentW - talentItemWidth * talentItemCount) / (talentItemCount + 1)

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnReset = self:AddComponent(UIButton, BtnReset_path)
  self.btnReset:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnReset()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("building_name_10218000")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bgContent = self:AddComponent(UIBaseContainer, bgContent_path)
  self.bgItem = self:AddComponent(UIImage, bgItem_path)
  self.bgItem.gameObject:GameObjectCreatePool()
  self.bgItemDict = {}
  self.levelContent = self:AddComponent(UIBaseContainer, levelContent_path)
  self.levelReqs = {}
  self.levelItemDict = {}
  self.lineContent = self:AddComponent(UIBaseContainer, lineContent_path)
  self.lineItem = self:AddComponent(UIBaseContainer, lineItem_path)
  self.lineItem.gameObject:GameObjectCreatePool()
  self.lineItemDict = {}
  self.openLineContent = self:AddComponent(UIBaseContainer, openLineContent_path)
  self.openLineItem = self:AddComponent(UIBaseContainer, openLineItem_path)
  self.openLineItem.gameObject:GameObjectCreatePool()
  self.openLineItemDict = {}
  self.itemContent = self:AddComponent(UIBaseContainer, itemContent_path)
  self.itemReqs = {}
  self.skillItemDict = {}
  self.homeIcon = self:AddComponent(UIImage, homeIcon_path)
  self.homeBigBg = self:AddComponent(UIRawImage, homeBigBg_path)
  self.homeName = self:AddComponent(UIText, homeName_path)
  self.havePointTxt = self:AddComponent(UIText, havePointTxt_path)
  self.home_level = self:AddComponent(UITextMeshProUGUIEx, home_level_path)
  self.desTxt = self:AddComponent(UIText, desTxt_path)
  self.show_skill_btn = self:AddComponent(UIButton, show_skill_btn_path)
  self.show_skill_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowSkillBtnClick()
  end)
  self.homeInfoContent = self:AddComponent(UIBaseContainer, homeInfoContent_path)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

local function ComponentDestroy(self)
  self:RecycleAllItem()
  self.back_btn = nil
  self.btnReset = nil
  self.text_title = nil
  self.content = nil
  self.bgContent = nil
  self.bgItem = nil
  self.bgItemDict = nil
  self.levelContent = nil
  self.levelItemDict = nil
  self.lineContent = nil
  self.lineItem = nil
  self.lineItemDict = nil
  self.openLineContent = nil
  self.openLineItem = nil
  self.openLineItemDict = nil
  self.itemContent = nil
  self.skillItemDict = nil
  self.homeIcon = nil
  self.homeBigBg = nil
  self.homeName = nil
  self.home_level = nil
  self.havePointTxt = nil
  self.desTxt = nil
  self.show_skill_btn = nil
end

local function DataDefine(self)
  self.homeId = 0
  self.homeDict = nil
  self.layerShowData = {}
  self.lineShowData = {}
  self.skillShowData = {}
  self.masteryData = nil
  self.selfHomeId = 0
  DataCenter.MasteryManager:CalculateRecommend()
end

local function DataDestroy(self)
  self.homeId = nil
  self.homeDict = nil
  self.layerShowData = nil
  self.lineShowData = nil
  self.skillShowData = nil
  self.masteryData = nil
  self.selfHomeId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RefreshView)
  self:AddUIListener(EventId.LWMasterySkillJump, self.MasteryJumpFunc)
  self:AddUIListener(EventId.MasteryUseSkill, self.RefreshRedPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RefreshView)
  self:RemoveUIListener(EventId.LWMasterySkillJump, self.MasteryJumpFunc)
  self:RemoveUIListener(EventId.MasteryUseSkill, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

function LWUIMasterySkillPanelView:ReInit(params)
  self.homeId = params.homeId
  self.jumpMasteryId = params.jumpMasteryId
  self.jumpLinkSkill = params.jumpLinkSkill
  self.autoOpen = params.autoOpen
  self:InitView()
end

local function InitView(self)
  self.masteryData = DataCenter.MasteryManager:GetData()
  self.selfHomeId = self.masteryData.home_id
  self.homeDict = DataCenter.MasteryManager:GetHomeDict(self.homeId)
  self:InitShowData()
  self:InitBgContent()
  self:InitLevelContent()
  self:InitLineContent()
  self:InitItemContent()
  self:RefreshView()
end

local function InitShowData(self)
  local levelDict = {}
  local maxOpenLv = 0
  for _, masteryId in ipairs(self.homeDict) do
    local temp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(masteryId)
    if temp then
      local openLv = temp.need_home_lv
      if levelDict[openLv] == nil then
        levelDict[openLv] = {}
      end
      table.insert(levelDict[openLv], masteryId)
      if maxOpenLv < openLv then
        maxOpenLv = openLv
      end
      if 0 < #temp.nexts then
        for _, nextId in pairs(temp.nexts) do
          if self.lineShowData[masteryId] == nil then
            self.lineShowData[masteryId] = {}
          end
          self.lineShowData[masteryId][nextId] = false
        end
      end
    end
  end
  local normalLayerNum = math.ceil(maxOpenLv / layerIntervalLv)
  if 0 < maxOpenLv then
    local data = {
      levelMin = 0,
      levelMax = 1,
      masteryIdList = {}
    }
    table.insert(self.layerShowData, data)
  end
  if maxOpenLv > layerSpecialLv then
    for i = 1, normalLayerNum do
      local levelMin = math.max((i - 1) * layerIntervalLv, layerSpecialLv + 1)
      local levelMax = i * layerIntervalLv
      local data = {
        levelMin = levelMin,
        levelMax = levelMax,
        masteryIdList = {}
      }
      table.insert(self.layerShowData, data)
    end
  end
  for openLv, list in pairs(levelDict) do
    for layerNum, data in ipairs(self.layerShowData) do
      if openLv >= data.levelMin and openLv <= data.levelMax then
        for _, mId in pairs(list) do
          table.insert(data.masteryIdList, mId)
        end
        break
      end
    end
  end
  for _, _masteryId in ipairs(self.homeDict) do
    local homeId = self.homeId
    local masteryId = _masteryId
    local masteryData = DataCenter.MasteryManager:GetData()
    local selfHomeId = masteryData.home_id
    local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(masteryId)
    local maxLv = lvOneTemp.max_lv
    local needLv = lvOneTemp.need_home_lv
    local needMastery = lvOneTemp.need_mastery
    local skill_id = lvOneTemp.skill
    local needMasteryTemp
    if 0 < needMastery then
      needMasteryTemp = DataCenter.MasteryManager:GetTempById(needMastery)
    end
    local data = {
      homeId = homeId,
      masteryId = masteryId,
      masteryData = masteryData,
      selfHomeId = selfHomeId,
      lvOneTemp = lvOneTemp,
      maxLv = maxLv,
      needLv = needLv,
      needMastery = needMastery,
      needMasteryTemp = needMasteryTemp,
      skill_id = skill_id
    }
    table.insert(self.skillShowData, data)
  end
end

local function InitBgContent(self)
  local layerNum = #self.layerShowData
  local contentH = layerNum * itemH + 30
  self.content:SetSizeDeltaXY(contentW, contentH)
  self.content:SetAnchoredPositionXY(0, 0)
  for k, v in pairs(self.layerShowData) do
    local name = "bgItem" .. k
    local item = self.bgItem.gameObject:GameObjectSpawn(self.bgContent.transform)
    item.name = name
    item:SetActive(k % 2 == 0)
    local itemComp = self.bgContent:AddComponent(UIImage, name)
    itemComp:SetAnchoredPositionXY(0, (k - 1) * itemH)
    self.bgItemDict[k] = itemComp
  end
end

local function InitLevelContent(self)
  for k, v in pairs(self.layerShowData) do
    self.levelReqs[k] = self:GameObjectInstantiateAsync(UIAssets.MasteryLevelItem, function(request)
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.levelContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "levelItem" .. k
      go.name = nameStr
      local item = self.levelContent:AddComponent(UIBaseContainer, nameStr)
      item.levelNum = item:AddComponent(UIText, "levelNum")
      item:SetAnchoredPositionXY(0, k * itemH)
      item.levelNum:SetText(v.levelMax)
      self.levelItemDict[k] = item
    end)
  end
end

local function GetLayerNumByLv(self, level)
  local layerNum = 1
  if level <= layerSpecialLv then
    layerNum = 1
  else
    layerNum = math.ceil(level / layerIntervalLv) + 1
  end
  return layerNum
end

local function GetSkillItemPosX(self, pos)
  return pos * (talentItemSpace + talentItemHalfWidth) + (pos - 1) * talentItemHalfWidth
end

local function GetLineData(self, startLv, startPos, endLv, endPos)
  local lineDataList = {}
  local startLayerNum = self:GetLayerNumByLv(startLv)
  local startPosY = (startLayerNum - 1 + 0.5) * itemH
  local startPosX = self:GetSkillItemPosX(startPos)
  local endLayerNum = self:GetLayerNumByLv(endLv)
  local endPosY = (endLayerNum - 1 + 0.5) * itemH
  local endPosX = self:GetSkillItemPosX(endPos)
  local midPosX = (startPosX + endPosX) / 2
  local midPosY = (startPosY + endPosY) / 2
  if startPos == endPos then
    local data = {
      posX = startPosX,
      posY = startPosY,
      rotate = 0,
      len = endPosY - startPosY
    }
    table.insert(lineDataList, data)
  else
    local lineRightDir = startPosX < endPosX
    local data1 = {
      posX = startPosX,
      posY = startPosY,
      rotate = 0,
      len = midPosY - startPosY
    }
    local data2 = {
      posX = startPosX + (lineRightDir and -grayLineW / 2 or grayLineW / 2),
      posY = midPosY,
      rotate = lineRightDir and -90 or 90,
      len = math.abs(endPosX - startPosX) + grayLineW
    }
    local data3 = {
      posX = endPosX,
      posY = midPosY,
      rotate = 0,
      len = endPosY - midPosY
    }
    table.insert(lineDataList, data1)
    table.insert(lineDataList, data2)
    table.insert(lineDataList, data3)
  end
  return lineDataList
end

local function InitLineContent(self)
  for startId, startVal in pairs(self.lineShowData) do
    for endId, val in pairs(startVal) do
      local startTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(startId)
      local endTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(endId)
      local startLv = startTemp.need_home_lv
      local startPos = startTemp.pos
      local endLv = endTemp.need_home_lv
      local endPos = endTemp.pos
      local lineDataList = self:GetLineData(startLv, startPos, endLv, endPos)
      if self.lineItemDict[startId] == nil or self.lineItemDict[startId][endId] == nil then
        if self.lineItemDict[startId] == nil then
          self.lineItemDict[startId] = {}
        end
        self.lineItemDict[startId][endId] = {}
        for k, v in ipairs(lineDataList) do
          local name = string.format("%dT%dI%d", startId, endId, k)
          local item = self.lineItem.gameObject:GameObjectSpawn(self.lineContent.transform)
          item.name = name
          item:SetActive(true)
          local itemComp = self.lineContent:AddComponent(UIBaseContainer, name)
          itemComp:SetAnchoredPositionXY(v.posX, v.posY)
          itemComp:SetEulerAnglesXYZ(0, 0, v.rotate)
          itemComp:SetSizeDeltaXY(grayLineW, v.len)
          table.insert(self.lineItemDict[startId][endId], itemComp)
        end
      end
    end
  end
end

local function GetSkillItemPosById(self, masteryId)
  local temp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(masteryId)
  local layerNum = self:GetLayerNumByLv(temp.need_home_lv)
  local pos = temp.pos
  local posX = self:GetSkillItemPosX(pos)
  local posY = (layerNum - 1 + 0.5) * itemH
  return posX, posY
end

local function InitItemContent(self)
  for k, masteryId in ipairs(self.homeDict) do
    local skillData = self.skillShowData[k]
    self.itemReqs[k] = self:GameObjectInstantiateAsync(UIAssets.MasterySkillItem, function(request)
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.itemContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(masteryId)
      go.name = nameStr
      local item = self.itemContent:AddComponent(LWUIMasterySkillPanelItem, nameStr)
      local posX, posY = self:GetSkillItemPosById(masteryId)
      item:SetAnchoredPositionXY(posX, posY)
      item:SetData(masteryId, skillData)
      self.skillItemDict[masteryId] = item
      if self.jumpMasteryId ~= nil and masteryId == self.jumpMasteryId then
        self:MasteryJumpFunc(self.jumpMasteryId)
      elseif skillData.skill_id ~= 0 and self.jumpLinkSkill ~= nil then
        for _, skill_id in ipairs(self.jumpLinkSkill) do
          if skill_id == skillData.skill_id then
            self:MasteryJumpFunc(masteryId)
          end
        end
      end
    end)
  end
end

local function RefreshView(self)
  self:RefreshHomeInfoContent()
  self:RefreshSkillItems()
  self:RefreshRedPoint()
end

local function RefreshOpenLineContent(self)
  if self.selfHomeId ~= self.homeId then
    return
  end
  for _, v in ipairs(self.skillShowData) do
    local endId = v.masteryId
    if v.needMasteryTemp then
      local startId = v.needMasteryTemp.mastery_id
      local needLv = v.needMasteryTemp.lv
      local curLv = self.masteryData:GetCurLvByMasteryId(startId)
      if needLv <= curLv and (self.openLineItemDict[startId] == nil or self.openLineItemDict[startId][endId] == nil) then
        if self.openLineItemDict[startId] == nil then
          self.openLineItemDict[startId] = {}
        end
        self.openLineItemDict[startId][endId] = {}
        local startTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(startId)
        local endTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(endId)
        local startLv = startTemp.need_home_lv
        local startPos = startTemp.pos
        local endLv = endTemp.need_home_lv
        local endPos = endTemp.pos
        local lineDataList = self:GetLineData(startLv, startPos, endLv, endPos)
        for k, v in ipairs(lineDataList) do
          local name = string.format("%dT%dI%d", startId, endId, k)
          local item = self.openLineItem.gameObject:GameObjectSpawn(self.openLineContent.transform)
          item.name = name
          item:SetActive(true)
          local itemComp = self.openLineContent:AddComponent(UIBaseContainer, name)
          itemComp:SetAnchoredPositionXY(v.posX, v.posY)
          itemComp:SetEulerAnglesXYZ(0, 0, v.rotate)
          itemComp:SetSizeDeltaXY(blueLineW, v.len)
          table.insert(self.openLineItemDict[startId][endId], itemComp)
        end
      end
    end
  end
end

local function RefreshHomeInfoContent(self)
  local imgName = ""
  local imgPath = ""
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.homeId)
  if showTemp then
    imgName = showTemp.icon
    imgPath = showTemp:GetIconFullPath()
    self.homeIcon:LoadSprite(imgPath)
    imgName = showTemp.mastery_head_icon
    imgPath = string.format(LoadPath.LWMasteryTexturePath, imgName)
    self.homeBigBg:LoadSpriteAsync(imgPath)
    self.homeBigBg:SetSizeDeltaXY(showTemp.mastery_head_icon_width, showTemp.mastery_head_icon_height)
  end
  if showTemp then
    self.homeName:SetLocalText(showTemp.name)
  end
  local idlepoint = self.masteryData:GetCurPlanIdlePoint()
  self.havePointTxt:SetLocalText("season_mastery_094", idlepoint, self.masteryData.totalPoint)
  if self.selfHomeId == self.homeId then
    self.desTxt:SetLocalText("season_mastery_091")
    self.show_skill_btn:SetActive(true)
    self.btnReset:SetActive(true)
    self.homeInfoContent:SetActive(true)
    self.scroll_view:SetOffsetMaxXY(0, -300)
    if self.masteryData and self.masteryData.level then
      self.home_level:SetText(Localization:GetString("300665", self.masteryData.level))
    else
      self.home_level:SetText("")
    end
  else
    self.desTxt:SetText("")
    self.show_skill_btn:SetActive(false)
    self.btnReset:SetActive(false)
    self.homeInfoContent:SetActive(false)
    self.scroll_view:SetOffsetMaxXY(0, -10)
  end
end

local function RefreshSkillItems(self)
  for k, v in pairs(self.skillItemDict) do
    v:Refresh()
  end
end

local function OnBtnReset(self)
  local costId = LuaEntry.DataConfig:TryGetNum("lw_season_mastery", "k1")
  local costNum = 1
  local costItem = DataCenter.ItemData:GetItemById(costId)
  local costItemNum = costItem and costItem.count or 0
  if costNum <= costItemNum then
    local costItemData = {}
    costItemData.itemId = costId
    costItemData.count = costNum
    UIUtil.ShowMessage(Localization:GetString("season_mastery_095"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryReset)
    end, nil, function()
    end, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, costItemData)
  else
    LWResourceLackUtil:GotoGoodsItemLack(costId, 1)
  end
end

local function OnShowSkillBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUse, {anim = true, playEffect = false})
end

local function RecycleAllItem(self)
  self.bgContent:RemoveComponents(UIImage)
  self.bgItem.gameObject:GameObjectRecycleAll()
  self.bgItemDict = {}
  self.levelContent:RemoveComponents(UIBaseContainer)
  if self.levelReqs then
    for _, v in pairs(self.levelReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.levelReqs = {}
  self.levelItemDict = {}
  self.lineContent:RemoveComponents(UIBaseContainer)
  self.lineItem.gameObject:GameObjectRecycleAll()
  self.lineItemDict = {}
  self.openLineContent:RemoveComponents(UIBaseContainer)
  self.openLineItem.gameObject:GameObjectRecycleAll()
  self.openLineItemDict = {}
  self.itemContent:RemoveComponents(LWUIMasterySkillPanelItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.itemReqs = {}
  self.skillItemDict = {}
end

local function MasteryJumpFunc(self, jumpMasteryId)
  local contentH = self.content.rectTransform.rect.height
  local scrollH = self.scroll_view.rectTransform.rect.height
  local minContentPosY = 0
  if contentH > scrollH then
    minContentPosY = scrollH - contentH
  end
  local targetItem = self.skillItemDict[jumpMasteryId]
  if targetItem == nil then
    return
  end
  local itemAnchoredPosY = targetItem:GetAnchoredPositionY()
  local jumpPos = -(itemAnchoredPosY - 0.5 * itemH)
  if minContentPosY > jumpPos then
    jumpPos = minContentPosY
  end
  self.content:SetAnchoredPositionXY(0, jumpPos)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
  DataCenter.ArrowManager:RemoveArrow()
  local param = {}
  param.position = targetItem.transform.position
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  if self.autoOpen then
    local masteryParam = {}
    masteryParam.masteryId = jumpMasteryId
    masteryParam.isShowMaxLvl = false
    masteryParam.showSkillInfo = false
    masteryParam.showShareBtn = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = true}, masteryParam)
  else
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.ArrowManager:ShowArrow(param)
    end, 0.1)
  end
end

local function RefreshRedPoint(self)
  local have = DataCenter.MasteryManager:HaveSkillCanUse()
  self.red_point:SetActive(have)
end

LWUIMasterySkillPanelView.OnCreate = OnCreate
LWUIMasterySkillPanelView.OnDestroy = OnDestroy
LWUIMasterySkillPanelView.ComponentDefine = ComponentDefine
LWUIMasterySkillPanelView.ComponentDestroy = ComponentDestroy
LWUIMasterySkillPanelView.DataDefine = DataDefine
LWUIMasterySkillPanelView.DataDestroy = DataDestroy
LWUIMasterySkillPanelView.OnAddListener = OnAddListener
LWUIMasterySkillPanelView.OnRemoveListener = OnRemoveListener
LWUIMasterySkillPanelView.InitView = InitView
LWUIMasterySkillPanelView.InitShowData = InitShowData
LWUIMasterySkillPanelView.InitBgContent = InitBgContent
LWUIMasterySkillPanelView.InitLevelContent = InitLevelContent
LWUIMasterySkillPanelView.InitLineContent = InitLineContent
LWUIMasterySkillPanelView.InitItemContent = InitItemContent
LWUIMasterySkillPanelView.RefreshView = RefreshView
LWUIMasterySkillPanelView.RefreshHomeInfoContent = RefreshHomeInfoContent
LWUIMasterySkillPanelView.RefreshSkillItems = RefreshSkillItems
LWUIMasterySkillPanelView.RefreshOpenLineContent = RefreshOpenLineContent
LWUIMasterySkillPanelView.OnBtnReset = OnBtnReset
LWUIMasterySkillPanelView.RecycleAllItem = RecycleAllItem
LWUIMasterySkillPanelView.GetLineData = GetLineData
LWUIMasterySkillPanelView.GetLayerNumByLv = GetLayerNumByLv
LWUIMasterySkillPanelView.GetSkillItemPosX = GetSkillItemPosX
LWUIMasterySkillPanelView.GetSkillItemPosById = GetSkillItemPosById
LWUIMasterySkillPanelView.OnShowSkillBtnClick = OnShowSkillBtnClick
LWUIMasterySkillPanelView.MasteryJumpFunc = MasteryJumpFunc
LWUIMasterySkillPanelView.RefreshRedPoint = RefreshRedPoint
return LWUIMasterySkillPanelView
