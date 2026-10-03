local CollectPointContent = BaseClass("CollectPointContent", UIBaseContainer)
local base = UIBaseContainer
local WorldBookmarkItem = require("UI.UIMainMapPointToSelect.Component.WorldBookmarkItem")
local bookmark_path = "Bookmark"
local btn_close_path = "btnClose"
local toggle_1_path = "Tab/Toggle1"
local toggle_2_path = "Tab/Toggle2"
local toggle_3_path = "Tab/Toggle3"
local toggle_4_path = "Tab/Toggle4"
local book_mark_title_Text = "Tab/Bookmark_Title"
local toggle_name_1_path = "Tab/Toggle1/Text1"
local toggle_name_2_path = "Tab/Toggle2/Text2"
local toggle_name_3_path = "Tab/Toggle3/Text3"
local toggle_name_4_path = "Tab/Toggle4/Text4"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.toggle1_text = self:AddComponent(UIText, toggle_name_1_path)
  self.toggle2_text = self:AddComponent(UIText, toggle_name_2_path)
  self.toggle3_text = self:AddComponent(UIText, toggle_name_3_path)
  self.toggle4_text = self:AddComponent(UIText, toggle_name_4_path)
  self.bookmarkTitle = self:AddComponent(UIText, book_mark_title_Text)
  self.toggle1_text:SetLocalText(100185)
  self.toggle2_text:SetLocalText(100186)
  self.toggle3_text:SetLocalText(GameDialogDefine.BOOKMARK_ENEMY)
  self.toggle4_text:SetLocalText(393081)
  self.bookmarkTitle:SetLocalText(100188)
  self.toggle1 = self:AddComponent(UIToggle, toggle_1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle_2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle_3_path)
  self.toggle4 = self:AddComponent(UIToggle, toggle_4_path)
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
  if self.bookmark == nil then
    self.bookmark = self:AddComponent(WorldBookmarkItem, bookmark_path)
  end
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self)
  self:CloseBookMark()
end

function CollectPointContent:SelectMark(bookmarkType)
  self.bookmark:SetActive(true)
  if self.view.search_obj ~= nil then
    self.view.search_obj:SetActive(false)
  end
  self.toggle1:SetIsOn(bookmarkType == 0)
  self.toggle2:SetIsOn(bookmarkType == 1)
  self.toggle3:SetIsOn(bookmarkType == 2)
  self.toggle4:SetIsOn(bookmarkType == 3)
  local select
  if bookmarkType == 0 then
    select = self.toggle1
  elseif bookmarkType == 1 then
    select = self.toggle2
  elseif bookmarkType == 2 then
    select = self.toggle3
  elseif bookmarkType == 3 then
    select = self.toggle4
  end
  self.bookmark:ReInit(bookmarkType, select.transform.position.x)
  self.view.ctrl:SetCurBookMarkType(bookmarkType)
end

function CollectPointContent:CheckAllToggle()
  if not self.toggle1:GetIsOn() and not self.toggle2:GetIsOn() and not self.toggle3:GetIsOn() and not self.toggle4:GetIsOn() then
    self:CloseBookMark()
  end
end

function CollectPointContent:CloseBookMark()
  if self.bookmark and self.bookmark:GetActive() then
    self.bookmark:SetActive(false)
  end
  self.toggle1:SetIsOn(false)
  self.toggle2:SetIsOn(false)
  self.toggle3:SetIsOn(false)
  self.toggle4:SetIsOn(false)
  if self.view.search_obj ~= nil then
    self.view.search_obj:SetActive(true)
  end
end

CollectPointContent.OnCreate = OnCreate
CollectPointContent.OnDestroy = OnDestroy
CollectPointContent.OnAddListener = OnAddListener
CollectPointContent.OnRemoveListener = OnRemoveListener
CollectPointContent.ComponentDefine = ComponentDefine
CollectPointContent.ComponentDestroy = ComponentDestroy
CollectPointContent.DataDefine = DataDefine
CollectPointContent.DataDestroy = DataDestroy
CollectPointContent.SetData = SetData
return CollectPointContent
