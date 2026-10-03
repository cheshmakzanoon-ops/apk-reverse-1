local UIBoxItemTipsView = BaseClass("UIBoxItemTipsView", UIBaseView)
local base = UIBaseView
local UIBoxItemTipsCellComponent = require("UI/UIBoxItemTips/Component/UIBoxItemTipsCellComponent")
local Localization = CS.GameEntry.Localization
local Pivot_Max = 1
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
local decoration_title_content_path = "root/GridLayout/Viewport/Content/decorationTitleContent"
local decoration_content_path = "root/GridLayout/Viewport/Content/decorationContent"
local hero_title_content_path = "root/GridLayout/Viewport/Content/heroTitleContent"
local hero_content_path = "root/GridLayout/Viewport/Content/heroContent"

function UIBoxItemTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBoxItemTipsView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBoxItemTipsView:ComponentDefine()
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
  self.decoration_title_content = self:AddComponent(UIBaseContainer, decoration_title_content_path)
  self.decoration_content = self:AddComponent(UIBaseContainer, decoration_content_path)
  self.hero_title_content = self:AddComponent(UIBaseContainer, hero_title_content_path)
  self.hero_content = self:AddComponent(UIBaseContainer, hero_content_path)
  self.awake_title_content = self:AddComponent(UIBaseContainer, "root/GridLayout/Viewport/Content/awakenTitleContent")
  self.awake_content = self:AddComponent(UIBaseContainer, "root/GridLayout/Viewport/Content/awakenContent")
end

function UIBoxItemTipsView:ComponentDestroy()
  self:ClearScroll()
  self._btn = nil
  self._txtName = nil
  self._txtDesc = nil
  self._root = nil
  self._imgArrow = nil
  self._content = nil
  self._layoutElement = nil
  self.normal_content = nil
  self.decoration_title_content = nil
  self.decoration_content = nil
  self.hero_title_content = nil
  self.hero_content = nil
  self.awake_title_content = nil
  self.awake_content = nil
end

function UIBoxItemTipsView:DataDefine()
  self.param = nil
  self.itemTemplate = nil
  self.requests = {}
end

function UIBoxItemTipsView:DataDestroy()
  self.param = nil
  self.itemTemplate = nil
  self.requests = nil
end

function UIBoxItemTipsView:OnEnable()
  self:Init()
end

function UIBoxItemTipsView:Init()
  self.param = self:GetUserData()
  assert(self.param.alignObject ~= nil)
  if self.param.alignObject.gameObject == nil or not self.param.alignObject.gameObject.activeInHierarchy then
    Logger.Log("UIBoxItemTipsView init aborted because its alignObject has been destroyed.")
    self.ctrl:CloseSelf()
    return
  end
  if not self.param.customDataList then
    self.itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if self.itemTemplate == nil then
      Logger.Log("UIBoxItemTipsView template null.")
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
  self:ClearScroll()
  local param2Data = self.itemTemplate and self.itemTemplate:GetTipsPara2DataWithTag() or self.param.customDataList
  local maxHeight = 550
  local oneLineHeight = 110
  local oneLineHeight2 = 130
  local titleHeight = 50
  local oneLineNum = 4
  do
    local index = 1
    for tagType, resData in pairs(param2Data) do
      for i, v in ipairs(resData) do
        local request = self:GameObjectInstantiateAsync(UIAssets.UIBoxItemTipsCell, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local targetContent = self.normal_content
          if tagType == CapacityBoxTagType.decoration then
            targetContent = self.decoration_content
          elseif tagType == CapacityBoxTagType.hero then
            targetContent = self.hero_content
          elseif tagType == CapacityBoxTagType.HeroAwaken then
            targetContent = self.awake_content
          end
          go.transform:SetParent(targetContent.transform)
          go.gameObject:SetActive(true)
          go.transform:Set_localScale(1, 1, 1)
          go.name = "item_" .. tostring(index)
          local cell = targetContent:AddComponent(UIBoxItemTipsCellComponent, go.name)
          local para = {}
          para.rewardType = RewardType.GOODS
          para.itemId = v.itemId
          para.count = v.count
          
          function para.clickAfterCallBack(param)
          end
          
          local cellData = {
            itemData = para,
            probability = v.probability
          }
          cell:ReInit(cellData)
          index = index + 1
        end)
        table.insert(self.requests, request)
      end
    end
    local normalContentCellType = self.itemTemplate and self.itemTemplate.tipsType or self.param.customTipsType
    local normalContentCellH = oneLineHeight
    if normalContentCellType == GOODS_TIPS_TYPE.Box then
      normalContentCellH = oneLineHeight2
    end
    local curContentHeight = 0
    local defaultTagNum = 0
    local decorationTagNum = 0
    local heroTagNum = 0
    local awakeTagNum = 0
    if param2Data[CapacityBoxTagType.default] then
      defaultTagNum = #param2Data[CapacityBoxTagType.default]
    end
    if param2Data[CapacityBoxTagType.decoration] then
      decorationTagNum = #param2Data[CapacityBoxTagType.decoration]
    end
    if param2Data[CapacityBoxTagType.hero] then
      heroTagNum = #param2Data[CapacityBoxTagType.hero]
    end
    if param2Data[CapacityBoxTagType.HeroAwaken] then
      awakeTagNum = #param2Data[CapacityBoxTagType.HeroAwaken]
    end
    self.decoration_title_content:SetActive(0 < decorationTagNum)
    self.hero_title_content:SetActive(0 < heroTagNum)
    self.normal_content:SetCellSize(oneLineHeight, normalContentCellH)
    self.awake_title_content:SetActive(0 < awakeTagNum)
    if 0 < defaultTagNum then
      curContentHeight = curContentHeight + math.ceil(defaultTagNum / oneLineNum) * normalContentCellH
    end
    if 0 < decorationTagNum then
      curContentHeight = curContentHeight + math.ceil(decorationTagNum / oneLineNum) * oneLineHeight + titleHeight
    end
    if 0 < heroTagNum then
      curContentHeight = curContentHeight + math.ceil(heroTagNum / oneLineNum) * oneLineHeight + titleHeight
    end
    if 0 < awakeTagNum then
      curContentHeight = curContentHeight + math.ceil(awakeTagNum / oneLineNum) * oneLineHeight + titleHeight
    end
    if maxHeight < curContentHeight then
      self._layoutElement:SetPreferredHeight(maxHeight)
    else
      self._layoutElement:SetPreferredHeight(curContentHeight)
    end
  end
  if self._root then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
    self:CheckAlign()
  end
end

function UIBoxItemTipsView:ClearScroll()
  if self.requests then
    if self.normal_content then
      self.normal_content:RemoveComponents(UIBoxItemTipsCellComponent)
    end
    if self.decoration_content then
      self.decoration_content:RemoveComponents(UIBoxItemTipsCellComponent)
    end
    if self.hero_content then
      self.hero_content:RemoveComponents(UIBoxItemTipsCellComponent)
    end
    if self.awake_content then
      self.awake_content:RemoveComponents(UIBoxItemTipsCellComponent)
    end
    for i, v in pairs(self.requests) do
      v:Destroy()
    end
  end
  self.requests = {}
end

function UIBoxItemTipsView:CheckAlign()
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

return UIBoxItemTipsView
