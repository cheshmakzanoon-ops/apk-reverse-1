local EffectDropdown = BaseClass("EffectDropdown", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BarItemAsync = require("UI.UILWMail.UILWMailMain.Component.MailBattle.BarItemAsync")
local BarViewParam = DataClass("BarViewParam", {
  name = "",
  type = 0,
  val1 = 0,
  val2 = 0,
  myCamp = 0
})

function BarViewParam:__init(name, type, val1, val2, myCamp)
  self.name = name
  self.type = type
  self.val1 = val1
  self.val2 = val2
  self.myCamp = myCamp
end

EffectDropdown.BarViewParam = BarViewParam

function EffectDropdown:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function EffectDropdown:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EffectDropdown:ComponentDefine()
  self.title_txt = self:AddComponent(UIText, "title/title_txt")
  self.toggle = self:AddComponent(UIToggle, "title/title_txt/toggle")
  self.toggle:SetOnValueChanged(function(bool)
    self:OnClickToggle(bool)
  end)
  self.barList = self:AddComponent(UIBaseContainer, "barList")
  self.barList:SetActive(false)
  self.toggle:SetIsOn(false)
end

function EffectDropdown:ComponentDestroy()
end

function EffectDropdown:SetData()
end

function EffectDropdown:SetDataFunc(func)
  self.dataFunc = func
end

function EffectDropdown:SetTitle(title)
  self.title_txt:SetText(title)
end

function EffectDropdown:OnClickToggle(bool)
  self.barList:SetActive(bool)
  if self.viewData == nil and bool then
    if self.dataFunc then
      self.viewData = self.dataFunc()
    else
      Logger.LogError("EffectDropdown:OnClickToggle dataFunc is nil")
      return
    end
  end
  if bool then
    if self.viewData == nil then
      Logger.LogError("EffectDropdown:OnClickToggle viewData is nil")
      return
    end
    local showIndex = 1
    if not self.bars then
      self.bars = {}
    end
    for i = 1, #self.viewData do
      local oneData = self.viewData[i]
      local name = oneData.name
      local type = oneData.type
      local value1 = oneData.val1 or ""
      local value2 = oneData.val2 or ""
      local myCamp = oneData.myCamp
      if not self.bars[showIndex] then
        self.bars[showIndex] = self:LoadComponentAsync(BarItemAsync, BarItemAsync.PrefabPath, self.barList)
      end
      self.bars[showIndex]:SetActive(true)
      self.bars[showIndex]:SetData(name, type, value1, value2, myCamp)
      showIndex = showIndex + 1
    end
    if showIndex <= #self.bars then
      for i = showIndex, #self.bars do
        self.bars[i]:SetActive(false)
      end
    end
  end
end

function EffectDropdown:RemoveBars()
  for i = 1, #self.bars do
    self:RemoveAsyncComponent(self.bars[i])
  end
  self.bars = {}
end

return EffectDropdown
