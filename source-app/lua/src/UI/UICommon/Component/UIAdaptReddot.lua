local UIAdaptReddot = BaseClass("UIAdaptReddot", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "imgDot",
    name = "imgDot",
    type = UIImage
  },
  {
    path = "imgDot/txtNum",
    name = "txtNum",
    type = UIText
  }
}
local __ALIGNMENT = {
  LEFT = 0,
  CENTER = 1,
  RIGHT = 2
}
local __dotImgWidth = 36
local __halfDotImgWidth = 18
local __dotImgHeight = 40
local __widthIncrement = 12

local function __InitAlignment(self, alignment)
  if alignment == __ALIGNMENT.LEFT then
    self.imgDot.transform.pivot = Vector2.New(0, 0.5)
    self.imgDot.transform.anchoredPosition = Vector2.New(-__halfDotImgWidth, 0)
  elseif alignment == __ALIGNMENT.CENTER then
    self.imgDot.transform.pivot = Vector2.New(0.5, 0.5)
    self.imgDot.transform.anchoredPosition = Vector2.New(0, 0)
  elseif alignment == __ALIGNMENT.RIGHT then
    self.imgDot.transform.pivot = Vector2.New(1, 0.5)
    self.imgDot.transform.anchoredPosition = Vector2.New(__halfDotImgWidth, 0)
  end
end

local function __AdaptWidth(self, len)
  self.dotW = __dotImgWidth + (len - 1) * __widthIncrement
  self.imgDot.transform.sizeDelta = Vector2.New(self.dotW, __dotImgHeight)
end

function UIAdaptReddot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.num = 0
  self.dotW = 0
  self.redDotType = UnreadNotificationType.ShowUnreadCount
  local alignment = self.transform.pivot.x == 0.5 and __ALIGNMENT.CENTER or self.transform.pivot.x == 1 and __ALIGNMENT.RIGHT or __ALIGNMENT.LEFT
  __InitAlignment(self, alignment)
  self:SetActive(false)
end

function UIAdaptReddot:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAdaptReddot:OnDisable()
  self.num = 0
  self.dotW = 0
end

function UIAdaptReddot:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIAdaptReddot:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIAdaptReddot:SetRedDotType(redDotType)
  self.redDotType = redDotType
end

function UIAdaptReddot:SetNumber(num, limit, autoHideWhenZero)
  autoHideWhenZero = autoHideWhenZero == nil and true or autoHideWhenZero
  self.num = tonumber(num) or 0
  limit = tonumber(limit) or 99
  if self.redDotType ~= UnreadNotificationType.NoNotification and self.num > 0 then
    self:SetActive(true)
    if self.redDotType == UnreadNotificationType.ShowUnreadCount then
      if limit < self.num then
        __AdaptWidth(self, #tostring(limit) + 1)
        self.txtNum:SetText(limit .. "+")
      else
        __AdaptWidth(self, #tostring(self.num))
        self.txtNum:SetText(self.num)
      end
    elseif self.redDotType == UnreadNotificationType.ShowUnreadDot then
      __AdaptWidth(self, 1)
      self.txtNum:SetText("")
    end
  else
    __AdaptWidth(self, 1)
    self.txtNum:SetText("")
    self:SetActive(not autoHideWhenZero)
  end
end

function UIAdaptReddot:SetRussianPosition()
  if ChatInterface.getLanguageName() == "ru" then
    self.imgDot.transform.anchoredPosition = Vector2.New(__halfDotImgWidth, 15.8)
  end
end

return UIAdaptReddot
