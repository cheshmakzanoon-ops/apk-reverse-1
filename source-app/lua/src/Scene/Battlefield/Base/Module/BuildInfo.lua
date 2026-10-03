local _CLASS = {}

function _CLASS:GetBuildData(pointId)
  return {}
end

function _CLASS:FillBuildBtnList(pointData, btnList)
end

function _CLASS:BuildOpenCheck(pointData)
  return true
end

function _CLASS:HandleBuildingHpChange(msg)
end

function _CLASS:CanMultiAssistance()
  return BattleFieldUtil.CanMultiAssistance(self.bfType)
end

function _CLASS:GetBuildBestMarch(buildUUID)
  return nil
end

function _CLASS:GetAttackInfo(pointId, sign)
  return 0, 0, 0, 0
end

return _CLASS
