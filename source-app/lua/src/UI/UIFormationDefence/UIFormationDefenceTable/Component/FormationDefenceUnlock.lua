local FormationDefenceUnlock = BaseClass("FormationDefenceUnlock", UIBaseContainer)
local base = UIBaseContainer
local lock_txt_path = "lockTxt"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.lock_txt = self:AddComponent(UIText, lock_txt_path)
end

local function RefreshData(self, index)
  local data = self.view.ctrl:GetBuildTemplateData()
  if data.FormationUnLockLevel ~= nil then
    local level = data.FormationUnLockLevel[index]
    if level ~= nil then
      self.lock_txt:SetLocalText(GameDialogDefine.UNLOCK_LEVEL, level)
    end
  end
end

local function SetSelectState(self)
end

FormationDefenceUnlock.OnCreate = OnCreate
FormationDefenceUnlock.RefreshData = RefreshData
FormationDefenceUnlock.SetSelectState = SetSelectState
return FormationDefenceUnlock
