local UIHeroPVPFormationPanelCtrl = BaseClass("UIHeroPVPFormationPanelCtrl", UIBaseCtrl)
local formationBuffCfg

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVPFormation)
end

local function OnCustomKeyCodeEscape(self)
  self.view:OnBackBtnClick()
end

local function SetView(self, view)
  self.view = view
end

function UIHeroPVPFormationPanelCtrl:SetSource(source)
  self.source = source
end

function UIHeroPVPFormationPanelCtrl:GetSource()
  return self.source
end

function UIHeroPVPFormationPanelCtrl:SetSquadIndex(squadIndex)
  self.squadIndex = squadIndex
end

function UIHeroPVPFormationPanelCtrl:GetSquadIndex()
  return self.squadIndex or 1
end

function UIHeroPVPFormationPanelCtrl:SetSquadBuffId(squadBuffId)
  self.squadBuffId = squadBuffId
end

function UIHeroPVPFormationPanelCtrl:GetSquadBuffId()
  return self.squadBuffId
end

function UIHeroPVPFormationPanelCtrl:SetRemoteSquadBuffId(remoteSquadBuffId)
  self.remoteSquadBuffId = remoteSquadBuffId
end

function UIHeroPVPFormationPanelCtrl:GetRemoteSquadBuffId()
  return self.remoteSquadBuffId
end

local function SaveSquad(self, entranceType, squadIndex, isManualSave)
  if entranceType == nil or squadIndex == nil then
    return
  end
  local squadData, curHeroes
  squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(entranceType, squadIndex)
  if squadData == nil then
    return
  end
  curHeroes = squadData:GenerateServerHeroArray()
  local saveType = 0
  if isManualSave == true then
    saveType = 1
  end
  if entranceType == EnterHeroSquadPanelWay.Gate then
    SFSNetwork.SendMessage(MsgDefines.DefenseInfoSave, squadData.uuid, curHeroes)
  elseif entranceType < EnterHeroSquadPanelWay.PVE then
    SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, squadData.uuid, curHeroes, saveType)
  else
    SFSNetwork.SendMessage(MsgDefines.FormationSave, squadData.index, curHeroes, saveType)
  end
end

function UIHeroPVPFormationPanelCtrl:GetFirstCanSelectHeroDataForEmptySlotIndex(squadData, heroDataList)
  local hasEmptySlot = false
  if squadData ~= nil and squadData.GetEmptySlotIndex ~= nil and squadData:GetEmptySlotIndex() ~= nil then
    hasEmptySlot = true
  end
  if not hasEmptySlot then
    return nil
  end
  local curSquadIndex = self:GetSquadIndex()
  for i, v in ipairs(heroDataList) do
    local isSelected = false
    if squadData and squadData.HasLocalHero ~= nil then
      isSelected = squadData:HasLocalHero(v.heroData.uuid)
    end
    local isInOtherFormation = false
    if v.squadIndex then
      isInOtherFormation = v.squadIndex ~= curSquadIndex
    end
    if isSelected == false and isInOtherFormation == false then
      return i
    end
  end
end

UIHeroPVPFormationPanelCtrl.CloseSelf = CloseSelf
UIHeroPVPFormationPanelCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIHeroPVPFormationPanelCtrl.SetView = SetView
UIHeroPVPFormationPanelCtrl.SaveSquad = SaveSquad
return UIHeroPVPFormationPanelCtrl
