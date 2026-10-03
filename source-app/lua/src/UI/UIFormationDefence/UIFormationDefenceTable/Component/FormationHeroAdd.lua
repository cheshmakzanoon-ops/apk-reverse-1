local FormationHeroAdd = BaseClass("FormationHeroAdd", UIBaseContainer)
local base = UIBaseContainer
local add_img_path = "addImage"
local lock_txt_path = "lockTxt"
local btn_path = ""
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.add_img = self:AddComponent(UIText, add_img_path)
  self.lock_txt = self:AddComponent(UIText, lock_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
  end)
end

local function RefreshData(self, isLock, formationIndex, index, formationUuid)
  self.isLock = isLock
  self.formationUuid = formationUuid
  self.add_img:SetActive(isLock == false)
  self.lock_txt:SetActive(isLock)
  local data = self.view.ctrl:GetBuildTemplateData()
  if data.formationUnLockIndex ~= nil and data.formationUnLockIndex[formationIndex] ~= nil then
    local tempData = data.formationUnLockIndex[formationIndex]
    local level = tempData[index]
    if level ~= nil then
      self.lock_txt:SetLocalText(GameDialogDefine.UNLOCK_LEVEL, level)
    end
  end
end

local function OnSelectClick(self)
  if self.isLock == false then
    self.view:OnSelectClick(self.formationUuid)
  end
end

FormationHeroAdd.OnCreate = OnCreate
FormationHeroAdd.RefreshData = RefreshData
FormationHeroAdd.OnSelectClick = OnSelectClick
return FormationHeroAdd
