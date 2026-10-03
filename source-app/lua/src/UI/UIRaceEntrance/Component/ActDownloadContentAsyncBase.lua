local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActDownloadContentAsyncBase = BaseClass("ActDownloadContentAsyncBase", base)
local ActDownloadContentBase = require("UI.UIRaceEntrance.Component.ActDownloadContentBase")

function ActDownloadContentAsyncBase:OnCreate()
  base.OnCreate(self)
  self.actDCBase = self:AddComponent(ActDownloadContentBase, "")
  self.actDCBase:SetLoadFinishCb(BindCallback(self, self.LoadActFinish))
end

function ActDownloadContentAsyncBase:OnDestroy()
  self.actDCBase = nil
  base.OnDestroy(self)
end

function ActDownloadContentAsyncBase:SetData(activityId)
  base.SetData(self, activityId)
  self.actDCBase:SetData(activityId)
end

function ActDownloadContentAsyncBase:EntranceReEnter()
  self.actDCBase:EntranceReEnter()
end

function ActDownloadContentAsyncBase:SetRootCP(cls, prefab)
  self.actDCBase:SetRootCP(cls, prefab)
end

function ActDownloadContentAsyncBase:LoadActFinish()
end

function ActDownloadContentAsyncBase.getters:compAct()
  return self.actDCBase.compAct
end

return ActDownloadContentAsyncBase
