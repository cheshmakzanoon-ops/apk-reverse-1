local UICommonTipsView = BaseClass("UICommonTipsView", UIBaseView)
local base = UIBaseView
local DEF_CLS = "UI.UILWHero.UIHeroPropertyDetailTip.Component.UIHeroPropertyCell"
local DEF_PREFAB = "Assets/Main/Prefabs/UI/Common/PropertyItem.prefab"
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  title = "",
  content = "",
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  contentX = 0,
  closeCallBack = nil
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.param = self:GetUserData()
  if self.touchTrough then
    self.touchTrough:ToggleThrough(not self.param.closePassClick)
    self.touchTrough:SetPassPointer(not self.param.closePassClick)
  end
  local contentDeltaX = 166
  local contentDeltaY = 3
  local arrowMidPosX = 80
  self.contentWidth = self.content.transform.sizeDelta
  local arrowX = self.param.position.x + self.param.deltaX
  local arrowY = self.param.position.y + self.param.deltaY
  local reversalArrowY = arrowY
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y
  if anchoredPosition.x > 0 then
    if arrowMidPosX < anchoredPosition.x then
      contentPosX = arrowX - contentDeltaX
    else
      contentPosX = arrowX - contentDeltaX + (arrowMidPosX - anchoredPosition.x)
    end
  elseif anchoredPosition.x < -arrowMidPosX then
    contentPosX = arrowX + contentDeltaX
  else
    contentPosX = arrowX + contentDeltaX - (arrowMidPosX - anchoredPosition.x)
  end
  local screenWidth = Screen.width
  contentPosX = contentPosX + self.param.contentX
  local halfContent = self.contentWidth.x / 2
  local halfScreen = screenWidth / 2
  if halfScreen < contentPosX + halfContent then
    contentPosX = halfScreen - halfContent
  end
  if contentPosX - halfContent < -halfScreen then
    contentPosX = -halfScreen + halfContent
  end
  contentPosY = arrowY + contentDeltaY
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  if string.IsNullOrEmpty(self.param.title) then
    self.textTitle:SetActive(false)
    self.textContent:SetColor(CommonTipTxtColor1)
  else
    self.textTitle:SetActive(true)
    self.textTitle:SetText(self.param.title)
    self.textContent:SetColor(CommonTipTxtColor2)
  end
  if string.IsNullOrEmpty(self.param.title) then
    self.textContent:SetText(self.param.content)
  else
    self.textTitle:SetActive(true)
    self.textContent:SetText(self.param.content)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  if self.param.exe then
    if self.param.exe.titleAlignment then
      self.textTitle:SetAlignment(self.param.exe.titleAlignment)
    end
    if self.param.exe.contentAlignment then
      self.textContent:SetAlignment(self.param.exe.contentAlignment)
    end
    if self.param.exe.comtentWidthAdd then
      self.content.transform.sizeDelta = Vector2.New(self.content.transform.rect.size.x + self.param.exe.comtentWidthAdd, self.content.transform.rect.size.y)
    end
    if self.param.exe.layoutShow and self.param.exe.datalist then
      self.textContent:SetActive(false)
      self:RefreshContent()
      return
    else
      self.textContent:SetActive(true)
      if string.IsNullOrEmpty(self.param.title) then
        self.textContent:SetText(self.param.content)
      else
        self.textTitle:SetActive(true)
        self.textContent:SetText(self.param.content)
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    if self.param.exe.reversal then
      contentPosY = arrowY + self.content.transform.rect.height - 6
      self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
      self.imgArrow.transform.localRotation = Vector3.New(0, 0, 180)
    end
  else
    self.textContent:SetActive(true)
    if string.IsNullOrEmpty(self.param.title) then
      self.textContent:SetText(self.param.content)
    else
      self.textTitle:SetActive(true)
      self.textContent:SetText(self.param.content)
    end
  end
  if self.param.endTime ~= nil then
    self.rootTime:SetActive(true)
    self:Update1000MS()
  else
    self.rootTime:SetActive(false)
  end
end

function UICommonTipsView:RefreshContent()
  self:ClearCell()
  if #self.param.exe.datalist > 0 then
    local prefab = self.param.exe.prefab or DEF_PREFAB
    local cls = require(self.param.exe.cls or DEF_CLS)
    self.curCls = cls
    for k, v in pairs(self.param.exe.datalist) do
      self.cells[k] = self:GameObjectInstantiateAsync(prefab, function(request)
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        NameCount = NameCount + 1
        go.name = tostring(NameCount)
        local cell = self.content:AddComponent(cls, go.name)
        cell:Refresh(v)
      end)
    end
  end
end

local function OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    if self.param ~= nil and self.param.closeCallBack ~= nil then
      self.param.closeCallBack()
    end
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.textContent = self:AddComponent(UIText, "content/TextContent")
  self.textTitle = self:AddComponent(UIText, "content/TitleTextContent")
  self.cells = {}
  self.rootTime = self:AddComponent(UIBaseContainer, "content/rootTime")
  self.textTime = self:AddComponent(UIText, "content/rootTime/textTime")
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
end

local function ComponentDestroy(self)
  self:ClearCell()
  self.imgArrow.transform.localRotation = Vector3.New(0, 0, 0)
  self.content.transform.sizeDelta = self.contentWidth
  self.imgArrow = nil
  self.textContent = nil
  self.textTitle = nil
  self.cells = nil
  self.content = nil
end

function UICommonTipsView:ClearCell()
  if self.curCls then
    self.content:RemoveComponents(self.curCls)
  end
  self.curCls = nil
  if self.cells then
    for k, v in pairs(self.cells) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cells = {}
end

function UICommonTipsView:Update1000MS()
  if self.param and self.param.endTime ~= nil then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.param.endTime then
      deltaTime = self.param.endTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.textTime:SetText(showTime)
    else
      self.textTime:SetText("00:00:00")
    end
  end
end

UICommonTipsView.ParamDataClass = ParamDataClass
UICommonTipsView.Direction = Direction
UICommonTipsView.OnCreate = OnCreate
UICommonTipsView.OnDestroy = OnDestroy
UICommonTipsView.OnEnable = OnEnable
UICommonTipsView.OnDisable = OnDisable
UICommonTipsView.ComponentDefine = ComponentDefine
UICommonTipsView.ComponentDestroy = ComponentDestroy
return UICommonTipsView
