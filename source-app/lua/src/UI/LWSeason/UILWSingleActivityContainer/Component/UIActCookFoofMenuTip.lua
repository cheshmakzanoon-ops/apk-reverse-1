local base = UIBaseContainer
local UIActCookFoofMenuTip = BaseClass("UIActCookFoofMenuTip", base)
local foodIcon_path = {
  "fooo1",
  "fooo2",
  "fooo3",
  "fooo4",
  "fooo5"
}

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.foodIcon = {
    self:AddComponent(UIImage, foodIcon_path[1]),
    self:AddComponent(UIImage, foodIcon_path[2]),
    self:AddComponent(UIImage, foodIcon_path[3]),
    self:AddComponent(UIImage, foodIcon_path[4]),
    self:AddComponent(UIImage, foodIcon_path[5])
  }
end

local function ComponentDestroy(self)
  self.foodIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActCookFoofMenuTip:SetData(list)
  if #list == 5 then
    for index, value in ipairs(list) do
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(value)
      if goods then
        self.foodIcon[index]:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
      end
    end
  end
end

function UIActCookFoofMenuTip:CheckRect(touchInfo)
  local touchPos = touchInfo.pointerPos
  local result = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(self.transform, touchPos, CS.GameEntry.UICamera)
  return result
end

UIActCookFoofMenuTip.OnCreate = OnCreate
UIActCookFoofMenuTip.OnDestroy = OnDestroy
UIActCookFoofMenuTip.OnEnable = OnEnable
UIActCookFoofMenuTip.OnDisable = OnDisable
UIActCookFoofMenuTip.ComponentDefine = ComponentDefine
UIActCookFoofMenuTip.ComponentDestroy = ComponentDestroy
UIActCookFoofMenuTip.DataDefine = DataDefine
UIActCookFoofMenuTip.DataDestroy = DataDestroy
return UIActCookFoofMenuTip
