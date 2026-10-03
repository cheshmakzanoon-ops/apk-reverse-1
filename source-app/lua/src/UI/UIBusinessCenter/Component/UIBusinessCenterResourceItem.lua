local UIBusinessCenterResourceItem = BaseClass("UIBusinessCenterResourceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  count
}
local this_path = ""
local need_text_path = "num/content_num"
local current_text_path = "num/current_num"
local need_icon_path = "item_icon"
local tag_path = "Searching_tag"
local num_layout_path = "num"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.need_text = self:AddComponent(UIText, need_text_path)
  self.current_text = self:AddComponent(UIText, current_text_path)
  self.need_text_shadow = self:AddComponent(UIShadow, need_text_path)
  self.need_icon = self:AddComponent(UIImage, need_icon_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.tag = self:AddComponent(UIBaseContainer, tag_path)
  self.num_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, num_layout_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.goto_btn = self:AddComponent(UIButton, "GotoBtn")
  self.goto_btn:SetOnClick(function()
    self:OnGoToClick()
  end)
end

local function ComponentDestroy(self)
  self.need_text = nil
  self.current_text = nil
  self.need_icon = nil
  self.btn = nil
  self.tag = nil
  self.need_text_shadow = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param ~= nil then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.itemId)
    if template ~= nil then
      self.need_icon:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
      self:RefreshState()
    end
  end
end

local function RefreshState(self)
  local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.itemId)
  local num = 0
  if data ~= nil then
    num = data.number
  end
  self.current_text:SetActive(false)
  self.need_text:SetLocalText(GameDialogDefine.SPLIT, num, self.param.count)
  self:RefreshIsRed(num < self.param.count, num, self.param.count)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.num_layout.rectTransform)
end

local function RefreshIsRed(self, isRed, curNum, needNum)
  self.goto_btn:SetActive(isRed)
  self.tag:SetActive(false)
  if isRed then
    self.need_text_shadow:AllEnable(true)
    self.need_text:SetColor(WhiteColor)
    self.current_text:SetActive(true)
    self.current_text:SetText(curNum)
    self.need_text:SetLocalText(GameDialogDefine.SPLIT, "", needNum)
  else
    self.need_text:SetColor(WhiteColor)
    self.need_text_shadow:AllEnable(true)
    self.current_text:SetActive(false)
    DOTween.Restart(self.tag.gameObject, "Searching_wancheng")
  end
end

local function OnGoToClick(self)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local lackTab = {}
  local param = {}
  param.type = ResLackType.ResItem
  param.itemId = self.param.itemId
  param.targetNum = self.param.count
  table.insert(lackTab, param)
  GoToResLack.GoToItemResLackList(lackTab)
end

local function OnBtnClick(self)
  local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.itemId)
  local num = 0
  if data ~= nil then
    num = data.number
  end
  if num < self.param.count then
    GoToUtil.GotoColdStorage(self.param.itemId)
    return
  end
  local tempParam = GoToUtil.GetSourceByResourceItem(self.param.itemId)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btn.gameObject.transform.position + Vector3.New(0, 60, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = tempParam.name
  param.content = tempParam.buildName
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIBusinessCenterResourceItem.OnCreate = OnCreate
UIBusinessCenterResourceItem.OnDestroy = OnDestroy
UIBusinessCenterResourceItem.Param = Param
UIBusinessCenterResourceItem.OnEnable = OnEnable
UIBusinessCenterResourceItem.OnDisable = OnDisable
UIBusinessCenterResourceItem.ComponentDefine = ComponentDefine
UIBusinessCenterResourceItem.ComponentDestroy = ComponentDestroy
UIBusinessCenterResourceItem.DataDefine = DataDefine
UIBusinessCenterResourceItem.DataDestroy = DataDestroy
UIBusinessCenterResourceItem.ReInit = ReInit
UIBusinessCenterResourceItem.RefreshIsRed = RefreshIsRed
UIBusinessCenterResourceItem.RefreshState = RefreshState
UIBusinessCenterResourceItem.OnGoToClick = OnGoToClick
UIBusinessCenterResourceItem.OnBtnClick = OnBtnClick
return UIBusinessCenterResourceItem
