local WorldBookmarkRoot = BaseClass("WorldBookmarkRoot", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local WorldGotoItem = require("UI.UISearch.Component.WorldGotoItem")
local UISearchFov = require("UI.UISearch.Component.UISearchFov")
local goto_path = "Goto"
local bookmark_path = "Bookmark"
local btn_close_path = "btnClose"
local toggle_1_path = "Tab/Toggle1"
local toggle_2_path = "Tab/Toggle2"
local toggle_3_path = "Tab/Toggle3"
local toggle_4_path = "Tab/Toggle4"
local toggle_5_path = "Tab/Toggle5"
local book_mark_title_Text = "Tab/Bookmark_Title"
local toggle_name_1_path = "Tab/Toggle1/Text1"
local toggle_name_2_path = "Tab/Toggle2/Text2"
local toggle_name_3_path = "Tab/Toggle3/Text3"
local toggle_name_4_path = "Tab/Toggle4/Text4"
local toggle_name_5_path = "Tab/Toggle5/Text5"
local bookmark_root_path = "BookmarkRoot"

function WorldBookmarkRoot:OnCreate()
  base.OnCreate(self)
  if self.transform:Find(btn_close_path) ~= nil then
    self.btnClose = self:AddComponent(UIButton, btn_close_path)
    self.btnClose:SetOnClick(function()
      self.view:CloseBookMarkRoot()
    end)
  end
  self.toggle1_text = self:AddComponent(UIText, toggle_name_1_path)
  self.toggle2_text = self:AddComponent(UIText, toggle_name_2_path)
  self.toggle3_text = self:AddComponent(UIText, toggle_name_3_path)
  self.toggle4_text = self:AddComponent(UIText, toggle_name_4_path)
  self.toggle5_text = self:AddComponent(UIText, toggle_name_5_path)
  self.bookmarkTitle = self:AddComponent(UIText, book_mark_title_Text)
  self.toggle1_text:SetLocalText(100185)
  self.toggle2_text:SetLocalText(100186)
  self.toggle3_text:SetLocalText(GameDialogDefine.BOOKMARK_ENEMY)
  self.toggle4_text:SetLocalText(393081)
  self.toggle5_text:SetLocalText(800941)
  self.bookmarkTitle:SetLocalText(100188)
  self.toggle1 = self:AddComponent(UIToggle, toggle_1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle_2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle_3_path)
  self.toggle4 = self:AddComponent(UIToggle, toggle_4_path)
  self.toggle5 = self:AddComponent(UIToggle, toggle_5_path)
  local showFlag = DataCenter.LandlordMgr:CanShowWarZoneMark()
  self.toggle5:SetActive(showFlag)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:SelectMark(MarkType.Special)
    else
      self:CheckAllToggle()
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:SelectMark(MarkType.Friend)
    else
      self:CheckAllToggle()
    end
  end)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:SelectMark(MarkType.Enemy)
    else
      self:CheckAllToggle()
    end
  end)
  self.toggle4:SetOnValueChanged(function(tf)
    if tf then
      self:SelectMark(MarkType.Alliance_Attack)
    else
      self:CheckAllToggle()
    end
  end)
  self.toggle5:SetOnValueChanged(function(tf)
    if tf then
      self:SelectMark(MarkType.Country_A)
    else
      self:CheckAllToggle()
    end
  end)
  self.bookmarkRoot = self.transform:Find(bookmark_root_path)
  self:CloseBookMark()
  self:ShowGotoWorldItem()
end

function WorldBookmarkRoot:OnDestroy()
  if self.openShowDelay then
    self.openShowDelay:Stop()
    self.openShowDelay = nil
  end
  base.OnDestroy(self)
end

function WorldBookmarkRoot:OnEnable()
  base.OnEnable(self)
end

function WorldBookmarkRoot:OnDisable()
  base.OnDisable(self)
end

function WorldBookmarkRoot:DelayOpenWarZoneMark()
  if self.openShowDelay then
    self.openShowDelay:Stop()
  end
  if not self.toggle5:GetActive() then
    return
  end
  self.openShowDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.openShowDelay = nil
    self.toggle5:SetIsOn(true)
  end, 0.3)
end

function WorldBookmarkRoot:ShowGotoWorldItem()
  local showNewNode = false
  local seasonType = SeasonMapType.Nothing
  local config = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
  if config then
    local isInSeason = config:InNormalMode()
    local skin = config:GetSkinTemplate()
    seasonType = config:GetServerType(false)
    showNewNode = isInSeason and seasonType == SeasonMapType.NineNation and skin ~= nil and skin.season_type == SeasonMapType.NineNation
  end
  local isInWorld = SceneUtils.GetIsInWorld()
  if self.gotoWorld == nil then
    self.gotoWorld = self:TryAddComponent(WorldGotoItem, goto_path)
  end
  if self.gotoWorld ~= nil then
    self.gotoWorld:SetActive(not showNewNode and isInWorld)
  end
  if showNewNode and isInWorld and self.gotoWorldNew == nil then
    local luaPath = "UI.UISearch.Component.WorldGotoItemNew"
    local prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/GotoNew.prefab"
    self.gotoWorldNew = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self)
  end
end

local newWorldAnchorPosX = 335
local normalWorldAnchorPosX = 315
local worldAnchorPosY = -316

function WorldBookmarkRoot:RefreshTopToggleSelection()
  if not self.view or not self.view.ctrl then
    return
  end
  local curType = self.view.ctrl:GetCurBookMarkType()
  self.toggle1:SetIsOnWithoutNotify(curType == MarkType.Special)
  self.toggle2:SetIsOnWithoutNotify(curType == MarkType.Friend)
  self.toggle3:SetIsOnWithoutNotify(curType == MarkType.Enemy)
  self.toggle4:SetIsOnWithoutNotify(curType == MarkType.Alliance_Attack)
  self.toggle5:SetIsOnWithoutNotify(curType == MarkType.Country_A)
end

function WorldBookmarkRoot:ChangeMarkImpl(bookmarkType)
  if self.view.search_obj ~= nil then
    self.view.search_obj:SetActive(false)
  end
  local select
  if bookmarkType == MarkType.Special then
    select = self.toggle1
  elseif bookmarkType == MarkType.Friend then
    select = self.toggle2
  elseif bookmarkType == MarkType.Enemy then
    select = self.toggle3
  elseif bookmarkType == MarkType.Alliance_Attack then
    select = self.toggle4
  elseif bookmarkType == MarkType.Country_A then
    select = self.toggle5
  end
  self.bookmark:ReInit(bookmarkType, select.transform.position.x)
  self.view.ctrl:SetCurBookMarkType(bookmarkType)
  self:RefreshTopToggleSelection()
end

function WorldBookmarkRoot:SelectMark(bookmarkType)
  DataCenter.LWSoundManager:PlaySound(80079, false)
  if self.bookmark == nil then
    self.bookmark = UIAsyncLoaderBridge.New(self, "bookmark", self.bookmarkRoot, UIAssets.UISearchFov, UISearchFov, true)
  end
  self.bookmark:SetActive(true)
  if self.bookmark.isAsync then
    self:ChangeMarkImpl(bookmarkType)
  else
    local ct = self.bookmark:GetMultiCount()
    if 0 < ct then
      self:RefreshTopToggleSelection()
      local _bt = bookmarkType
      UIUtil.ShowMessage(Localization:GetString("world_tip10020"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:ChangeMarkImpl(_bt)
      end)
    else
      self:ChangeMarkImpl(bookmarkType)
    end
  end
end

function WorldBookmarkRoot:HideBookmarkItem()
  if self.view.search_obj ~= nil then
    self.view.search_obj:SetActive(false)
  end
  self.view.ctrl:SetCurBookMarkType(nil)
end

function WorldBookmarkRoot:CheckAllToggle()
  if not self.toggle1:GetIsOn() and not self.toggle2:GetIsOn() and not self.toggle3:GetIsOn() and not self.toggle4:GetIsOn() and not self.toggle5:GetIsOn() then
    self:CloseBookMark()
  end
end

function WorldBookmarkRoot:CloseBookMark()
  if self.bookmark then
    self.bookmark:SetActive(false)
  end
  self.toggle1:SetIsOn(false)
  self.toggle2:SetIsOn(false)
  self.toggle3:SetIsOn(false)
  self.toggle4:SetIsOn(false)
  self.toggle5:SetIsOn(false)
  if self.view.search_obj ~= nil then
    self.view.search_obj:SetActive(true)
  end
end

function WorldBookmarkRoot:HideBg()
  self.view:HideBg()
end

return WorldBookmarkRoot
