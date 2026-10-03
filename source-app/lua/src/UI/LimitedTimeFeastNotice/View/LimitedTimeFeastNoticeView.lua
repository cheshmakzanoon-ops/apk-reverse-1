local LimitedTimeFeastNoticeView = BaseClass("LimitedTimeFeastNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LimitedTimeFeastNoticeItem = require("UI.LimitedTimeFeastNotice.Component.LimitedTimeFeastNoticeItem")
local notice_item_path = "Root/noticeItem"
local content_path = "Root/scroll/Viewport/Content"
local item_content_path = "Root/scroll/Viewport/Content/ItemContent"
local tip_txt_path = "Root/scroll/Viewport/Content/TipTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.notice_item = self:AddComponent(UIImage, notice_item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.notice_item:SetActive(false)
  self.notice_item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.textTitle:SetLocalText("blackmarket_drop_tips1")
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.notice_item = nil
  self.content = nil
  self.item_content = nil
  self.tip_txt = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.activityId = self.param.activityId
  self.dataList = self.param.dataList
end

local function DataDestroy(self)
  self.param = nil
  self.activityId = nil
  self.dataList = nil
end

local function ClearAllItem(self)
  self.item_content:RemoveComponents(LimitedTimeFeastNoticeItem)
  for _, v in ipairs(self.item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.notice_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

local function OnOpen(self)
  self:ClearAllItem()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo then
    self.tip_txt:SetLocalText(activityInfo.story)
  else
    self.tip_txt:SetText("")
  end
  self.content:SetAnchoredPositionXY(0, 0)
  for i, v in ipairs(self.dataList) do
    local item = self.notice_item.gameObject:GameObjectSpawn(self.item_content.transform)
    item.name = i
    local obj = self.item_content:AddComponent(LimitedTimeFeastNoticeItem, item.name)
    obj:SetActive(true)
    self.itemList[i] = obj
    obj:SetData(v)
  end
end

LimitedTimeFeastNoticeView.OnCreate = OnCreate
LimitedTimeFeastNoticeView.OnDestroy = OnDestroy
LimitedTimeFeastNoticeView.ComponentDefine = ComponentDefine
LimitedTimeFeastNoticeView.ComponentDestroy = ComponentDestroy
LimitedTimeFeastNoticeView.DataDefine = DataDefine
LimitedTimeFeastNoticeView.DataDestroy = DataDestroy
LimitedTimeFeastNoticeView.ClearAllItem = ClearAllItem
LimitedTimeFeastNoticeView.OnOpen = OnOpen
return LimitedTimeFeastNoticeView
