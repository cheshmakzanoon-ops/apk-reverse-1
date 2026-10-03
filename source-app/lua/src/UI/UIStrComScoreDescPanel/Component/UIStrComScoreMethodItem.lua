local UIStrComScoreMethodItem = BaseClass("UIStrComScoreMethodItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnClickGotoBtn(self)
  if self.data then
    GoToUtil.GoToByTypeAndParam(self.data.gotype2, self.data.gopara, self.data)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.gotoBtn = self:AddComponent(UIButton, "GotoBtn")
  self.gotoBtn:SetOnClick(function()
    OnClickGotoBtn(self)
  end)
end

local function OnDestroy(self)
  self.nameText = nil
  self.gotoBtn = nil
  base.OnDestroy(self)
end

local function SetData(self, data, showGotoBtn)
  self.nameText:SetLocalText(data.name)
  self.data = data
  self.gotoBtn:SetActive(showGotoBtn)
end

UIStrComScoreMethodItem.OnCreate = OnCreate
UIStrComScoreMethodItem.OnDestroy = OnDestroy
UIStrComScoreMethodItem.SetData = SetData
return UIStrComScoreMethodItem
