local base = UIBaseContainer
local AllianceCityTipResetFirstHeadLogic = BaseClass("AllianceCityTipResetFirstHeadLogic", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local AllianceCityTipResetFirstHeadInfo = require("DataCenter.AllianceCityTip.AllianceCityTipResetFirstHeadInfo")

function AllianceCityTipResetFirstHeadLogic:__init(gameObject)
  self.gameObject = gameObject
  self.lodCache = 1
end

function AllianceCityTipResetFirstHeadLogic:__delete()
  if self.headInfoRoot then
    self.headInfoRoot:Delete()
    self.headInfoRoot = nil
  end
  self.lodCache = 1
end

function AllianceCityTipResetFirstHeadLogic:SetLod(lod)
  self.lodCache = toInt(lod)
  if self.headInfoRoot then
    self.headInfoRoot:SetLod(self.lodCache)
  end
end

function AllianceCityTipResetFirstHeadLogic:CheckLod(lod)
  self.lodCache = toInt(lod)
  if self.headInfoRoot then
    self.headInfoRoot:CheckLod(self.lodCache)
  end
end

function AllianceCityTipResetFirstHeadLogic:ReInit(data)
  self.data = data
  self:DoRefresh()
end

function AllianceCityTipResetFirstHeadLogic:OnPointDateUpdate()
  self:DoRefresh()
end

function AllianceCityTipResetFirstHeadLogic:DoRefresh()
  if self.data == nil or tonumber(self.data.id) == nil then
    if self.headInfoRoot then
      self.headInfoRoot:Delete()
      self.headInfoRoot = nil
    end
    return
  end
  local roleInfo = DataCenter.OffSeason1RecaptureManager:GetServerRankFirstRoleInfo(tonumber(self.data.id))
  if roleInfo then
    if self.headInfoRoot == nil then
      self.headInfoRoot = AllianceCityTipResetFirstHeadInfo.New(self.gameObject)
      self.headInfoRoot:ReInit(roleInfo)
    else
      self.headInfoRoot:ReInit(roleInfo)
    end
  elseif self.headInfoRoot then
    self.headInfoRoot:ReInit(nil)
  end
  self:CheckLod(self.lodCache)
end

function AllianceCityTipResetFirstHeadLogic:OnPointOutView()
  self:DoRefresh()
end

return AllianceCityTipResetFirstHeadLogic
