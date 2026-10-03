local base = UIBaseView
local UIChatAISettingView = BaseClass("UIChatAISettingView", base)
local SettingHeader = require("UI.UIChatAI.UIChatAISetting.Component.UIChatAISettingHeader")
local SettingItem = require("UI.UIChatAI.UIChatAISetting.Component.UIChatAISettingItem")
local txt_title_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local expand_content = "UICommonPopUpTitle/Common_bg_orange"
local return_btn_path = "UICommonPopUpTitle/panel"
local bg = "UICommonPopUpTitle/Common_bg_orange"
local content_path = "ImgBg/ScrollView/Viewport/Content"

function UIChatAISettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatAISettingView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatAISettingView:OnEnable()
  base.OnEnable(self)
  self:InitView()
end

function UIChatAISettingView:OnDisable()
  if self._isChangedData then
    SFSNetwork.SendMessage(MsgDefines.ChatGPTSwitchTrigger)
    self._isChangedData = false
  end
  base.OnDisable(self)
end

function UIChatAISettingView:InitView()
  self.content:RemoveComponents(SettingHeader)
  self.content:RemoveComponents(SettingItem)
  self.theHead:GameObjectRecycleAll()
  self.theItem:GameObjectRecycleAll()
  local dummyData = self.ctrl:GetDataForUI()
  local index = 1
  for _, v in ipairs(dummyData) do
    if v.head then
      local nameStr = "Head" .. index
      local header = self.theHead:GameObjectSpawn(self.content.transform)
      header.name = nameStr
      header:SetActive(true)
      self.content:AddComponent(SettingHeader, nameStr, v.text)
    else
      local nameStr = "Item" .. index
      local item = self.theItem:GameObjectSpawn(self.content.transform)
      item.name = nameStr
      item:SetActive(true)
      self.content:AddComponent(SettingItem, nameStr, v, self)
    end
    index = index + 1
  end
  self._isChangedData = false
end

function UIChatAISettingView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(280012)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_btn = self:AddComponent(UIButton, bg)
  self.bg_btn:SetOnClick(function()
    self:HideTooltip()
  end)
  self.content_btn = self:AddComponent(UIButton, "ImgBg/ScrollView")
  self.content_btn:SetOnClick(function()
    self:HideTooltip()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find("ItemRoot").gameObject
  self.theItem:GameObjectCreatePool()
  self.theHead = self.transform:Find("HeadRoot").gameObject
  self.theHead:GameObjectCreatePool()
  self._tooltipBtn = self:AddComponent(UIButton, "ImgBg/ScrollView/Viewport/tooltip")
  self._tooltipBtn:SetOnClick(function()
    self:HideTooltip()
  end)
  self._tooltipCanvasGroup = self:AddComponent(UICanvasGroup, "ImgBg/ScrollView/Viewport/tooltip")
  self._tooltipText = self:AddComponent(UIText, "ImgBg/ScrollView/Viewport/tooltip/txt")
end

function UIChatAISettingView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.expandBg = nil
  self.content:RemoveComponents(SettingHeader)
  self.content:RemoveComponents(SettingItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content = nil
end

function UIChatAISettingView:ShowTooltips(alignObject, detail)
  local pos = alignObject.transform.position
  self._tooltipText:SetText(detail)
  self._tooltipCanvasGroup:SetActive(false)
  self._tooltipCanvasGroup:SetActive(true)
  self._tooltipCanvasGroup:SetAlpha(1)
  self._tooltipCanvasGroup:SetPositionXYZ(pos.x - 20, pos.y + 20, pos.z)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._tooltipCanvasGroup.rectTransform)
  if self.fadeOutTimer ~= nil then
    self.fadeOutTimer:Stop()
  end
  self.fadeOutTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self._tooltipBtn ~= nil then
      self.fadeOutTimer = nil
      if self._tooltipBtn ~= nil and self._tooltipCanvasGroup ~= nil then
        self:HideTooltip()
      end
    end
  end, 5.0)
end

function UIChatAISettingView:HideTooltip()
  if self._tooltipCanvasGroup ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self._tooltipCanvasGroup.unity_canvas_group:DOFade(0, 0.3))
    sequence:AppendCallback(function()
      self._tooltipCanvasGroup:SetActive(false)
    end)
    if self.fadeOutTimer ~= nil then
      self.fadeOutTimer:Stop()
    end
  end
end

function UIChatAISettingView:OnSettingChanged()
  self._isChangedData = true
end

return UIChatAISettingView
