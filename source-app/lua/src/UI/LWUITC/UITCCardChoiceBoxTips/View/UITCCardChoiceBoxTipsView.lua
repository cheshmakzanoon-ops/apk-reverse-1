local UITCCardChoiceBoxTipsView = BaseClass("UITCCardChoiceBoxTipsView", UIBaseView)
local base = UIBaseView
local UIBoxItemTipsCellComponent = require("UI/UIBoxItemTips/Component/UIBoxItemTipsCellComponent")
local Localization = CS.GameEntry.Localization
local Pivot_Max = 1.1
local Pivot_Min = -0.1
local Pivot_Mid = 0.5
local _cp_txtName = "root/TxtName"
local _cp_txtDesc = "root/TxtDesc"
local _cp_layout = "root/GridLayout"
local _cp_btnBg = "Panel"
local _cp_root = "root"
local _cp_imgArrow = "root/imgArrow"
local content_path = "root/GridLayout/Viewport/Content"
local normal_content_path = "root/GridLayout/Viewport/Content/normalContent"
local CARD_TYPE_SCALE = {
  [TacticalCardType.Core] = 0.45,
  [TacticalCardType.Battle] = 0.65,
  [TacticalCardType.Economy] = 0.65
}
local CARD_TYPE_SPACING = {
  [TacticalCardType.Core] = {-35, -45},
  [TacticalCardType.Battle] = {-35, -30},
  [TacticalCardType.Economy] = {-35, -30}
}

function UITCCardChoiceBoxTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITCCardChoiceBoxTipsView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITCCardChoiceBoxTipsView:ComponentDefine()
  self._btn = self:AddComponent(UIButton, _cp_btnBg)
  self._btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._txtName = self:AddComponent(UIText, _cp_txtName)
  self._txtDesc = self:AddComponent(UIText, _cp_txtDesc)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._imgArrow = self:AddComponent(UIBaseContainer, _cp_imgArrow)
  self._content = self:AddComponent(UIBaseContainer, content_path)
  self._layoutElement = self:AddComponent(UILayoutElement, _cp_layout)
  self.normal_content = self:AddComponent(UIGridLayoutGroup, normal_content_path)
end

function UITCCardChoiceBoxTipsView:ComponentDestroy()
  self._btn = nil
  self._txtName = nil
  self._txtDesc = nil
  self._root = nil
  self._imgArrow = nil
  self._content = nil
  self._layoutElement = nil
  self.normal_content = nil
end

function UITCCardChoiceBoxTipsView:DataDefine()
  self.param = nil
  self.itemTemplate = nil
  self.cardRequests = {}
end

function UITCCardChoiceBoxTipsView:DataDestroy()
  self.param = nil
  self.itemTemplate = nil
end

function UITCCardChoiceBoxTipsView:OnEnable()
  self:Init()
end

function UITCCardChoiceBoxTipsView:Init()
  self.param = self:GetUserData()
  assert(self.param.alignObject ~= nil)
  if self.param.alignObject.gameObject == nil or not self.param.alignObject.gameObject.activeInHierarchy then
    Logger.Log("UITCCardChoiceBoxTipsView init aborted because its alignObject has been destroyed.")
    self.ctrl:CloseSelf()
    return
  end
  if not self.param.customDataList then
    self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if self.itemTemplate == nil then
      Logger.Log("UITCCardChoiceBoxTipsView itemTemplate null.")
      self.ctrl:CloseSelf()
      return
    end
  end
  if self.param.customNameText == nil then
    local name = DataCenter.ItemTemplateManager:GetName(self.itemTemplate.id)
    self._txtName:SetText(name)
  else
    self._txtName:SetText(self.param.customNameText)
  end
  if self.param.customDesText == nil then
    local des = self.itemTemplate:GetTipsDescription()
    self._txtDesc:SetText(des)
  else
    self._txtDesc:SetText(self.param.customDesText)
  end
  local maxHeight = 340
  local oneLineHeight = 159
  local oneLineNum = 4
  self:InitCardList()
  local normalContentCellH = oneLineHeight
  local curContentHeight = 0
  local defaultTagNum = 0
  if self.cardInfos then
    defaultTagNum = #self.cardInfos
  end
  if 0 < defaultTagNum then
    curContentHeight = curContentHeight + math.ceil(defaultTagNum / oneLineNum) * normalContentCellH
  end
  if maxHeight < curContentHeight then
    self._layoutElement:SetPreferredHeight(maxHeight)
  else
    self._layoutElement:SetPreferredHeight(curContentHeight)
  end
  if self._root then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
    self:CheckAlign()
  end
end

function UITCCardChoiceBoxTipsView:InitCardList()
  self:ClearCardList()
  local cardInfos = {}
  if self.itemTemplate.para1 then
    local cardPairs = string.split(self.itemTemplate.para1, "|")
    for i = 1, #cardPairs do
      local cardPair = string.split(cardPairs[i], ",")
      if #cardPair == 2 then
        local cardId = tonumber(cardPair[1])
        local count = tonumber(cardPair[2])
        if cardId and count and 0 < count then
          local cardInfo = {cardId = cardId, count = count}
          table.insert(cardInfos, cardInfo)
          if not self.cardInfoMap then
            self.cardInfoMap = {}
          end
          self.cardInfoMap[cardInfo.cardId] = cardInfo
        end
      end
    end
  end
  if self.itemTemplate.type == GOODS_TYPE.GOODS_TYPE_185 and self.itemTemplate.para2 then
    local cardPairs = string.split(self.itemTemplate.para2, "|")
    if #cardPairs ~= #cardInfos then
      Logger.LogError("\229\141\161\231\137\140\230\149\176\233\135\143\229\146\140\229\175\185\229\186\148\231\154\132\229\177\158\230\128\167\230\149\176\233\135\143\228\184\141\229\140\185\233\133\141\239\188\129  goods ID:" .. tostring(self.itemTemplate))
      return
    end
    for i = 1, #cardPairs do
      local attrIdPairs = string.split(cardPairs[i], ",")
      local cardInfo = cardInfos[i]
      cardInfo.attributeList = {}
      for _, v in ipairs(attrIdPairs) do
        if not string.IsNullOrEmpty(v) then
          local attributeInfo = {}
          local attrId = tonumber(v)
          local detailTemplate = LocalController:instance():getLine("battle_card_random_attr_detail", attrId)
          if detailTemplate then
            local effectId = detailTemplate.effect_num
            local effectTemplate = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(effectId)
            if effectTemplate then
              attributeInfo.id = effectId
              attributeInfo.effectName = effectTemplate.effect_name
              local min = detailTemplate.quality_range[1]
              local max = detailTemplate.quality_range[2]
              if min ~= max then
                Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134 \229\141\154\232\175\173\232\175\180\232\191\153\231\167\141\230\131\133\229\134\181\228\184\138\228\184\139\233\153\144\231\154\132\229\128\188\229\186\148\232\175\165\228\184\128\230\160\183  \228\189\134\230\152\175\232\191\153\228\184\170\230\138\165\233\148\153\228\184\141\230\137\147\230\150\173\230\181\129\231\168\139")
              end
              attributeInfo.value = min
              attributeInfo.quality = effectTemplate:GetQuality(attributeInfo.value)
              table.insert(cardInfo.attributeList, attributeInfo)
            end
          end
        end
      end
      table.sort(cardInfo.attributeList, function(a, b)
        if a.quality ~= b.quality then
          return a.quality > b.quality
        end
        return a.id > b.id
      end)
    end
  end
  for i, cardInfo in ipairs(cardInfos) do
    self:CreateCardCell(cardInfo.cardId, i, cardInfo.count)
  end
  self.cardInfos = cardInfos
end

function UITCCardChoiceBoxTipsView:CreateCardCell(cardId, index, count)
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return
  end
  local cardType = cardTemplate.type
  local spacing = CARD_TYPE_SPACING[cardType]
  self.normal_content:SetCellSpacing(spacing[1], spacing[2])
  local request = TacticalCardUtil.CreateOneCardItem(self, cardType, self.normal_content, function(cardItem)
    local displayConfig = {}
    displayConfig.isDeluxeShow = true
    displayConfig.isShowLv = false
    displayConfig.showBg = true
    cardItem:SetConfigData(cardId, count, 0, displayConfig)
    cardItem:SetClickFunc(function()
      local level = 1
      local randomAttr
      if cardType == TacticalCardType.Battle or cardType == TacticalCardType.Economy then
        local cardInfo = self.cardInfoMap[cardId]
        for i, v in ipairs(cardInfo.attributeList) do
          if v.id == TacticalCardUtil.Effect_Card_Upgrade then
            level = level + 1
          end
        end
        randomAttr = cardInfo.attributeList
      end
      TacticalCardUtil:OpenViewCard(cardId, level, 0, randomAttr)
      self.ctrl:CloseSelf()
    end)
    cardItem:SetSelectObjState(false)
    local scale = CARD_TYPE_SCALE[cardType]
    cardItem:SetLocalScaleXYZ(scale, scale, scale)
  end)
  self.cardRequests[index] = request
end

function UITCCardChoiceBoxTipsView:CheckAlign()
  if self.param == nil or self._root == nil or self._imgArrow == nil then
    return
  end
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = ScreenWidth / DefaultScreenWidth
  local _rect = self._root.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * scale
  local alignObject = self.param.alignObject
  if not alignObject or IsNull(alignObject) then
    return
  end
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  local pivot = Vector2.New(0.5, 0.5)
  if BgWidth <= ScreenWidth - (_screenPos.x + objWidth * 0.4) then
    pivot.x = Pivot_Min
    self._imgArrow:SetActive(true)
    _arrowX = -BgWidth / scale * 0.5 - 8
  elseif BgWidth < _screenPos.x - objWidth * 0.4 then
    pivot.x = Pivot_Max
    self._imgArrow:SetActive(true)
    _arrowX = BgWidth / scale * 0.5 + 8
  else
    pivot.x = Pivot_Mid
    self._imgArrow:SetActive(false)
  end
  if _screenPos.y - BgHeight * 0.5 < 50 then
    pivot.y = Pivot_Min
    _arrowY = -BgHeight / scale * 0.5 - 2
  elseif _screenPos.y + BgHeight * 0.5 > ScreenHeight - 50 then
    pivot.y = Pivot_Max
    _arrowY = BgHeight / scale * 0.5 + 2
  else
    pivot.y = Pivot_Mid
  end
  self._root.rectTransform.pivot = pivot
  if pivot.x == Pivot_Mid and pivot.y == Pivot_Mid then
    self._imgArrow:SetActive(false)
    self._root.rectTransform.anchoredPosition = Vector3.New(0, 0, 0)
  else
    self._root.transform.position = alignObject.transform.position
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min or pivot.x == Pivot_Max and pivot.y == Pivot_Max or pivot.x == Pivot_Min and pivot.y == Pivot_Min or pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    self._imgArrow:SetActive(false)
    return
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 180
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 0
  end
  self._imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation + 180)
  self._imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
end

function UITCCardChoiceBoxTipsView:ClearCardList()
  for _, request in pairs(self.cardRequests) do
    if request and request.Destroy then
      request:Destroy()
    end
  end
  self.normal_content:RemoveAllComponentes()
  self.cardRequests = {}
end

return UITCCardChoiceBoxTipsView
