local base = require("UI.UIRaceEntrance.View.ActDownloadViewBase")
local UILandlordMainView = BaseClass("UILandlordMainView", base)
local Localization = CS.GameEntry.Localization
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainRoot.prefab"
local CLS = "UI.Landlord.Main.Component.LLMainRoot"

function UILandlordMainView:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActLandlord.Type)
  if actData then
    self.text_title:SetLocalText(actData.name or "zonewar_landlord_name_10008")
    self:SetData(actData.id)
  end
end

function UILandlordMainView:OnDestroy()
  if CommonUtil.IsDebug() then
    DataCenter.LandlordMgr.TEST_LL_NEWS = nil
  end
  base.OnDestroy(self)
end

function UILandlordMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILandlordMainView:LoadActFinish()
end

return UILandlordMainView
