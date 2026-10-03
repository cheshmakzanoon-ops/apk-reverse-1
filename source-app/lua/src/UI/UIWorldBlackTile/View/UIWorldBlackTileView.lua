local UIWorldBlackTileView = BaseClass("UIWorldBlackTileView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

function UIWorldBlackTileView:OnCreate()
  base.OnCreate(self)
  local pointId = self:GetUserData()
  self.pointId = tonumber(pointId)
  if self.pointId == 0 then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldBlackTile)
    return
  end
  TileBubbleManager:GetInstance():ShowBubble(self.pointId)
  self.show_pos_obj = self:AddComponent(UIBaseContainer, "showPos")
  self.left_obj = self:AddComponent(UIBaseContainer, "showPos/left")
  self.right_obj = self:AddComponent(UIBaseContainer, "showPos/right")
  self.top_obj = self:AddComponent(UIBaseContainer, "showPos/top")
  self.bottom_obj = self:AddComponent(UIBaseContainer, "showPos/buttom")
  self.view_obj = self:AddComponent(UIBaseContainer, "ImgBg")
  self._share_btn = self:AddComponent(UIButton, "ImgBg/Btn_share")
  self._share_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self._mark_btn = self:AddComponent(UIButton, "ImgBg/Btn_mark")
  self._mark_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
  self.markIcon = self:AddComponent(UIImage, "ImgBg/Btn_mark")
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.markIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_mark")
  else
    self.markIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_collect")
  end
  self._pos_txt = self:AddComponent(UIText, "ImgBg/Txt_Pos")
  self.animator = self:AddComponent(UIAnimator, "ImgBg/showObj")
  self._buildInfo_rect = self:AddComponent(UIBaseContainer, "ImgBg/showObj/BuildInfo")
  self._buildInfo_canvas = self:AddComponent(UICanvasGroup, "ImgBg/showObj/BuildInfo")
  self._buildInfo_canvas:SetAlpha(1)
  self._collect_txt = self:AddComponent(UIText, "ImgBg/showObj/BuildInfo/Txt_Collect")
  self._collectPlayerName_txt = self:AddComponent(UIText, "ImgBg/showObj/BuildInfo/Txt_CollectPlayerName")
  self._collectName_txt = self:AddComponent(UIText, "ImgBg/showObj/BuildInfo/Txt_CollectName")
  self._playerInfo_btn = self:AddComponent(UIButton, "ImgBg/showObj/BuildInfo/Btn_PlayerInfo")
  self._playerInfo_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnPlayerDetailClick()
  end)
  self._icon_img = self:AddComponent(UIImage, "ImgBg/showObj/BuildInfo/Rect_head/Img_Icon")
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self._watch_btn = self:AddComponent(UIButton, "ImgBg/Rect_Bottom/Btn_Watch")
  self._watch_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMoveCityClick()
  end)
  self._watch_txt = self:AddComponent(UIText, "ImgBg/Rect_Bottom/Btn_Watch/Txt_Watch")
  self._watch_txt:SetLocalText(GameDialogDefine.MOVE_CITY)
  self._attack_btn = self:AddComponent(UIButton, "ImgBg/Rect_Bottom/Btn_Attack")
  self._attack_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAttackClick()
  end)
  self._attack_txt = self:AddComponent(UIText, "ImgBg/Rect_Bottom/Btn_Attack/Txt_Attack")
  self._attack_txt:SetLocalText(GameDialogDefine.MARCH)
  self.data = {}
end

function UIWorldBlackTileView:OnDestroy()
  self.pointId = nil
  self.view_obj = nil
  self.show_pos_obj = nil
  self.left_obj = nil
  self.right_obj = nil
  self.top_obj = nil
  self.bottom_obj = nil
  self._share_btn = nil
  self._mark_btn = nil
  self._pos_txt = nil
  self.animator = nil
  self._buildInfo_rect = nil
  self._buildInfo_canvas = nil
  self._collect_txt = nil
  self._collectPlayerName_txt = nil
  self._collectName_txt = nil
  self._playerInfo_btn = nil
  self._icon_img = nil
  self._watch_btn = nil
  self._attack_btn = nil
  self.data = nil
  TileBubbleManager:GetInstance():HideBubble()
  base.OnDestroy(self)
end

function UIWorldBlackTileView:OnAddListener()
  self.hasListener = true
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
end

function UIWorldBlackTileView:OnRemoveListener()
  if self.hasListener then
    self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
    self.hasListener = false
  end
end

function UIWorldBlackTileView:OnEnable()
  base.OnEnable(self)
  self:SetPosition()
  self:SetData()
end

function UIWorldBlackTileView:OnDisable()
  base.OnDisable(self)
end

function UIWorldBlackTileView:OnAttackClick()
  self.ctrl:OnAttackClick(self.pointId)
end

function UIWorldBlackTileView:OnMoveCityClick()
  if CrossServerUtil:GetIsCrossServer() then
    UIUtil.ShowTipsId(500019)
    return
  end
  local item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
  if item and item.count > 0 then
    local serverId = LuaEntry.Player:GetCurServerId()
    MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity, serverId, LuaEntry.Player:GetMainWorldPos(), true)
  else
    LWResourceLackUtil:GotoGoodsItemLack(SpecialItemId.ITEM_MOVE_CITY, 1)
  end
end

function UIWorldBlackTileView:OnPlayerDetailClick()
end

function UIWorldBlackTileView:OnShareClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  self.ctrl:OnShareClick(LuaEntry.Player:GetCurServerId(), self.pointId, GameDialogDefine.BLACK_TILE)
end

function UIWorldBlackTileView:OnMarkClick()
  local point = self.pointId * 10 + 1
  self.ctrl:OnMarkClick(LuaEntry.Player:GetCurServerId(), point, GameDialogDefine.BLACK_TILE)
end

function UIWorldBlackTileView:SetData()
  self.data = self.ctrl:GetBlackData(self.pointId)
  local pos = SceneUtils.IndexToTilePos(self.pointId)
  self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, pos.x, pos.y)
  self._collectPlayerName_txt:SetText("")
  self._collectName_txt:SetLocalText(GameDialogDefine.BLACK_TILE)
end

function UIWorldBlackTileView:SetPosition()
  local worldPos = SceneUtils.TileIndexToWorld(self.pointId)
  self.view_obj.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPos)
end

function UIWorldBlackTileView:UpdateLod(lod)
  if 2 <= lod then
    self.ctrl:CloseSelf(false)
  end
end

return UIWorldBlackTileView
