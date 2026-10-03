local base = UIBaseView
local UIGMBarView = BaseClass("UIGMBarView", base)
local Localization = CS.GameEntry.Localization
local KEY_POS_X = "GM_Bar_Pos_X"
local KEY_POS_Y = "GM_Bar_Pos_Y"
local KEY_EXPAND = "GM_Bar_Expand"

function UIGMBarView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMBarView:OnDestroy()
  self:ClearItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMBarView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMiniNode = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compExpandNode = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.btnOpenPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnOpenPanel:SetOnClick(function()
    self:OnBtnOpenPanelClick()
  end)
  self.btnExpand = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnExpand:SetOnClick(function()
    self:OnBtnExpandClick()
  end)
  self.btnFold = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnFold:SetOnClick(function()
    self:OnBtnFoldClick()
  end)
  self.btnOpenPanel2 = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnOpenPanel2:SetOnClick(function()
    self:OnBtnOpenPanel2Click()
  end)
  self.textTmpNone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compDetailLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compSuspendNode = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.imgIcon0 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgIcon1 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgBtnOpenPanel = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgBtnOpenPanel2 = self.viewSkin:AddComponent(self, UIImage, 13)
  self:RefreshSkin()
  self.dragComp = self.compSuspendNode.gameObject:GetComponent(typeof(CS.UIDraggableComponent))
  self.barExpand = nil
  self.textTmpNone:SetText("o_o!!!")
  self:ResetBar()
  self.dragComp.onEndDragCallback = Bind(self, self.OnDragEnd)
  self:RefreshView(CommonUtil.GlobalPrefsGetBool(KEY_EXPAND, false))
end

function UIGMBarView:ResetBar()
  self:RefreshScale(GMUtils.GetInt(GMConst.GMBarScale, 100))
  local posX = CommonUtil.GlobalPrefsGetInt(KEY_POS_X, 0)
  posX = math.max(posX, 0)
  local posY = CommonUtil.GlobalPrefsGetInt(KEY_POS_Y, -400)
  self.compSuspendNode:SetAnchoredPositionXY(posX, posY)
end

function UIGMBarView:ComponentDestroy()
  self.viewSkin = nil
  self.compMiniNode = nil
  self.compExpandNode = nil
  self.btnOpenPanel = nil
  self.btnExpand = nil
  self.btnFold = nil
  self.btnOpenPanel2 = nil
  self.textTmpNone = nil
  self.compDetailLayout = nil
  self.compSuspendNode = nil
  self.imgIcon0 = nil
  self.imgIcon1 = nil
  self.imgBtnOpenPanel = nil
  self.imgBtnOpenPanel2 = nil
end

function UIGMBarView:DataDefine()
  self.sortItems = {}
end

function UIGMBarView:DataDestroy()
end

function UIGMBarView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_SomeValChanged, self.OnGMBarRefresh)
  self:AddUIListener(EventId.GM_GMBar_ScaleChanged, self.RefreshScale)
  self:AddUIListener(EventId.GM_GMBar_Reset, self.OnBarReset)
  self:AddUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
  self:AddUIListener(EventId.OnClickWorld, self.OnClickWorld)
  self:AddUIListener(EventId.CheckBlankLandResult, self.OnCheckBlankLandResult)
end

function UIGMBarView:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_SomeValChanged, self.OnGMBarRefresh)
  self:RemoveUIListener(EventId.GM_GMBar_ScaleChanged, self.RefreshScale)
  self:RemoveUIListener(EventId.GM_GMBar_Reset, self.OnBarReset)
  self:RemoveUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
  self:RemoveUIListener(EventId.OnClickWorld, self.OnClickWorld)
  self:RemoveUIListener(EventId.CheckBlankLandResult, self.OnCheckBlankLandResult)
  base.OnRemoveListener(self)
end

function UIGMBarView:OnBtnOpenPanelClick()
  GMUtils.Open()
end

function UIGMBarView:OnBtnOpenPanel2Click()
  GMUtils.Open()
end

function UIGMBarView:OnBtnExpandClick()
  self:RefreshView(true)
end

function UIGMBarView:OnBtnFoldClick()
  self:RefreshView(false)
end

function UIGMBarView:RefreshScale(scale)
  if type(scale) ~= "number" then
    return
  end
  self.compSuspendNode.transform.localScale = Vector3.New(scale * 0.01, scale * 0.01, 1)
  self:RefreshLayout()
end

function UIGMBarView:RefreshView(expand)
  if self.barExpand == expand then
    return
  end
  self.barExpand = expand
  self.compMiniNode:SetActive(not expand)
  self.compExpandNode:SetActive(expand)
  if expand then
    self:RefreshItems()
  end
  CommonUtil.GlobalPrefsSetBool(KEY_EXPAND, self.barExpand)
end

local function _ConvertName(name)
  return string.format("gmBarItem_%s", name)
end

function UIGMBarView:ClearItems()
  if self.itemNameSet then
    for k, v in pairs(self.itemNameSet) do
      if self[k] then
        self[k]:Delete()
        self[k] = nil
      end
    end
  end
  self.itemNameSet = nil
end

function UIGMBarView:RefreshItems()
  local dataList = self.ctrl:GetItemsData()
  self.textTmpNone:SetActive(#dataList <= 0)
  local _current = self.itemNameSet or {}
  local _new = {}
  self.sortItems = {}
  for k, v in ipairs(dataList) do
    local name = _ConvertName(v.name)
    table.insert(self.sortItems, name)
    if _current[name] then
      _current[name] = nil
      _new[name] = true
    else
      self[name] = self:CreateItem(name, v)
      _new[name] = true
    end
  end
  for k, v in pairs(_current) do
    local handle = self[k]
    if handle then
      handle:Delete()
      self[k] = nil
    end
  end
  self.itemNameSet = _new
  self:RefreshLayout()
end

function UIGMBarView:CreateItem(name, setting)
  local loader = UIAsyncLoaderBridge.New(self, name, self.compDetailLayout.transform, setting.prefab, setting.lua, false, Bind(self, self.RefreshLayout))
  loader:SetActive(true)
  return loader
end

function UIGMBarView:OnGMBarRefresh()
  if self.barExpand then
    self:RefreshItems()
  end
end

function UIGMBarView:RefreshLayout()
  if not self.compSuspendNode then
    return
  end
  if self.sortItems then
    for k, v in ipairs(self.sortItems) do
      if self[v]:AsyncLoadDone() then
        self[v]:SetAsLastSibling()
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compSuspendNode.rectTransform)
  self.dragComp:ClampToScreenBounds()
end

function UIGMBarView:OnDragEnd()
  local pos = self.compSuspendNode:GetAnchoredPosition()
  local posX = math.floor(pos.x)
  local posY = math.floor(pos.y)
  CommonUtil.GlobalPrefsSetInt(KEY_POS_X, posX)
  CommonUtil.GlobalPrefsSetInt(KEY_POS_Y, posY)
end

function UIGMBarView:RefreshSkin()
  local skin = GMUtils.GetSkinPath()
  self.imgIcon0:LoadSpriteAuto(skin.icon)
  self.imgIcon1:LoadSpriteAuto(skin.icon)
  self.imgBtnOpenPanel:LoadSpriteAuto(skin.barBg)
  self.imgBtnOpenPanel2:LoadSpriteAuto(skin.barBg)
end

function UIGMBarView:OnClickWorld(curIndex)
  if self.IsStartDebugWorldBlock then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    local touchPos = CS.SceneManager.World.curTouchPoint
    local xIndex = Mathf.Clamp(touchPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
    local yIndex = Mathf.Clamp(touchPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
    local bigZone = toInt(xIndex + 3 * yIndex + 1)
    local serverId = seasonInfo:GetNinePalacesServer(bigZone)
    SFSNetwork.SendMessage(MsgDefines.CheckBlankLand, curIndex, serverId)
  end
end

function UIGMBarView:StartDebugWorldBlockInfo()
  self.IsStartDebugWorldBlock = true
end

function UIGMBarView:OnCheckBlankLandResult(t)
  local isStaticPoint = t.isStaticPoint
  if isStaticPoint then
    UIUtil.ShowTips("\233\152\187\230\140\161!!!")
  else
    UIUtil.ShowTips("\231\169\186\229\156\176!!!")
  end
end

function UIGMBarView:OnBarReset()
  self:ResetBar()
end

return UIGMBarView
