local DecorationBookPropertyItem = require("UI.LWDecorationBookProperty.Component.DecorationBookPropertyItem")
local LWDecorationBookPropertyView = BaseClass("LWDecorationBookPropertyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Pivot_MaxY = 0.7
local Pivot_MinY = 0.3
local Pivot_MaxX = 1.1
local Pivot_MinX = -0.1
local Pivot_Mid = 0.5
local MAX_SCROLL_HEIGHT = 600
local Level_Item_Height = 58
local Property_Sub_Item_Height = 33
local icon_b_g_path = "safeArea/panelContainer/IconBG"
local icon_path = "safeArea/panelContainer/Icon"
local name_text_path = "safeArea/panelContainer/NameText"
local desc_text_path = "safeArea/panelContainer/DescScroll/ViewPort/DescText"
local title_path = "safeArea/panelContainer/Title"
local title_text_path = "safeArea/panelContainer/Title/TitleText"
local scroll_view_path = "safeArea/panelContainer/Scroll View"
local content_path = "safeArea/panelContainer/Scroll View/Viewport/Content"
local panel_btn_path = "safeArea/panel"
local down_icon_path = "safeArea/panelContainer/Scroll View/DownIcon"
local img_arrow_path = "safeArea/panelContainer/ImgArrow"
local root_path = "safeArea/panelContainer"
local bg_path = "safeArea/panelContainer/BG"
local BG_PATH = "Assets/Main/Sprites/UI/LWDecorationBook/FX_ZSWTIPS_0%d.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon_bg = self:AddComponent(UIImage, icon_b_g_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.title = self:AddComponent(UIImage, title_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.closeBtn = self:AddComponent(UIButton, panel_btn_path)
  self.down_icon = self:AddComponent(UIImage, down_icon_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
  self._root = self:AddComponent(UIBaseContainer, root_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
end

local function ComponentDestroy(self)
  self.icon_bg = nil
  self.icon = nil
  self.name_text = nil
  self.desc_text = nil
  self.title = nil
  self.title_text = nil
  self.scroll_view = nil
  self.content = nil
  self.closeBtn = nil
  self.down_icon = nil
  self.img_arrow = nil
  self._root = nil
  self.bg = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.data = self:GetUserData()
  self.baseBuildingId = self.data.baseBuildingId
  self:OnRefreshView()
end

function LWDecorationBookPropertyView:ScrollToCurLevel()
  local curLevel = 0
  local curLevelHeight = 0
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.baseBuildingId, true)
  if buildData ~= nil then
    curLevel = buildData.level
  end
  if self.propertyMap ~= nil then
    for i = 1, table.length(self.propertyMap) do
      if i < curLevel then
        curLevelHeight = curLevelHeight + Level_Item_Height
        table.walk(self.propertyMap[i], function(k, v)
          curLevelHeight = curLevelHeight + Property_Sub_Item_Height
        end)
      end
    end
  end
  local scrollHeight = self.scroll_view.rectTransform.rect.height
  if curLevelHeight > scrollHeight then
    local contentHeight = self.content.rectTransform.rect.height
    local maxPos = math.max(0, contentHeight - scrollHeight)
    self.content.transform:Set_anchoredPosition(0, math.min(curLevelHeight, maxPos))
  end
end

local function OnRefreshView(self)
  self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.baseBuildingId, 1), DefaultImage)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.baseBuildingId)
  self.icon_bg:LoadSprite(string.format(BG_PATH, tonumber(template.para3) - 1))
  self.name_text:SetLocalText(template.name)
  self.desc_text:SetLocalText(template.des)
  self.propertyMap = DataCenter.BuildTemplateManager:GetAllLevelEffectMapByBaseBuildingId(self.baseBuildingId)
  self.propertyList = {}
  table.walk(self.propertyMap, function(k, v)
    local oneData = {effectId = k, value = v}
    table.insert(self.propertyList, oneData)
  end)
  self:SetAllCellDestroy()
  if self.propertyMap ~= nil then
    local num = 0
    for i = 1, table.length(self.propertyMap) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIDecorationBookPropertyItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(DecorationBookPropertyItem, nameStr)
        local propertyList = {}
        table.walk(self.propertyMap[i], function(k, v)
          local oneData = {effectId = k, value = v}
          table.insert(propertyList, oneData)
        end)
        local oneData = {
          level = i,
          propertyList = propertyList,
          baseBuildingId = self.baseBuildingId
        }
        cell:SetData(oneData, i)
        if i == table.length(self.propertyMap) and 5 <= i then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content)
          TimerManager:GetInstance():DelayFrameInvoke(function()
            if self.content then
              self:AdjustHeight()
              local scrollHeight = self.scroll_view.rectTransform.rect.height
              local contentHeight = self.content.rectTransform.rect.height
              self.down_icon:SetActive(scrollHeight < contentHeight)
            end
          end, 10)
        else
        end
      end)
    end
  end
end

local function AdjustHeight(self)
  local firstFiveItemHeight = 10
  for i = 1, 5 do
    local childItem = self.content.transform:GetChild(i - 1)
    local rectTransform = childItem:GetComponent(typeof(CS.UnityEngine.RectTransform))
    firstFiveItemHeight = firstFiveItemHeight + rectTransform.rect.height + 10
  end
  self.down_icon:SetActive(firstFiveItemHeight > MAX_SCROLL_HEIGHT)
  firstFiveItemHeight = math.min(MAX_SCROLL_HEIGHT, firstFiveItemHeight)
  self.scroll_view:SetSizeDeltaXY(self.scroll_view:GetSizeDelta().x, firstFiveItemHeight)
  self._root:SetSizeDeltaXY(self._root:GetSizeDelta().x, firstFiveItemHeight + 360)
  self:ScrollToCurLevel()
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(DecorationBookPropertyItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function CheckAlign(self)
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
  local alignObject = self.data.alignObject
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  self.img_arrow:SetActive(true)
  local midX = false
  local midY = false
  local pivot = Vector2.New(0.5, 0.5)
  if ScreenWidth < _screenPos.x + objWidth * 0.4 + BgWidth and 0 < _screenPos.x - objWidth * 0.4 - BgWidth then
    pivot.x = Pivot_MaxX
    _arrowX = BgWidth / scale * 0.5 + 5
  elseif ScreenWidth > _screenPos.x + objWidth * 0.4 + BgWidth and 0 > _screenPos.x - objWidth * 0.4 - BgWidth then
    pivot.x = Pivot_MinX
    _arrowX = -BgWidth / scale * 0.5 - 5
  else
    pivot.x = Pivot_Mid
    midX = true
    self.img_arrow:SetActive(false)
  end
  if 0 > _screenPos.y - BgHeight and ScreenHeight < _screenPos.y + BgHeight then
    pivot.y = Pivot_MinY
    _arrowY = -BgHeight / scale * (0.5 - Pivot_MinY)
  elseif 0 < _screenPos.y - BgHeight and ScreenHeight > _screenPos.y + BgHeight then
    pivot.y = Pivot_MaxY
    _arrowY = BgHeight / scale * (Pivot_MaxY - 0.5)
  else
    pivot.y = Pivot_Mid
    midY = true
    self.img_arrow:SetActive(false)
  end
  if pivot.x == Pivot_MaxX then
    _rotation = 180
  elseif pivot.x == Pivot_MinX then
    _rotation = 0
  end
  self.img_arrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation + 180)
  self.img_arrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
end

LWDecorationBookPropertyView.OnCreate = OnCreate
LWDecorationBookPropertyView.OnDestroy = OnDestroy
LWDecorationBookPropertyView.OnEnable = OnEnable
LWDecorationBookPropertyView.OnDisable = OnDisable
LWDecorationBookPropertyView.ComponentDefine = ComponentDefine
LWDecorationBookPropertyView.ComponentDestroy = ComponentDestroy
LWDecorationBookPropertyView.OnAddListener = OnAddListener
LWDecorationBookPropertyView.OnRemoveListener = OnRemoveListener
LWDecorationBookPropertyView.ReInit = ReInit
LWDecorationBookPropertyView.OnRefreshView = OnRefreshView
LWDecorationBookPropertyView.SetAllCellDestroy = SetAllCellDestroy
LWDecorationBookPropertyView.CheckAlign = CheckAlign
LWDecorationBookPropertyView.AdjustHeight = AdjustHeight
return LWDecorationBookPropertyView
