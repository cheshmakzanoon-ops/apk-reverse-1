local AssemblyFormation = {}
AssemblyFormation.Pos = {
  [1] = Vector3.New(0, 0, 2.5),
  [2] = Vector3.New(2, 0, -0.5),
  [3] = Vector3.New(-2, 0, -0.5),
  [4] = Vector3.New(1.5, 0, -3),
  [5] = Vector3.New(-1.5, 0, -3)
}
AssemblyFormation.SinglePos = Vector3.zero
AssemblyFormation.WeaponPos = Vector3.New(0, 0, -8)
AssemblyFormation.SingleWeaponPos = Vector3.New(0, 0, -4)

function AssemblyFormation.GetOffsetByIndex(index, total)
  if total == 1 then
    return AssemblyFormation.SinglePos
  end
  return AssemblyFormation.Pos[index]
end

function AssemblyFormation.GetScaleByIndex(index)
  return index == 1 and 1.5 or 1
end

function AssemblyFormation.GetWeaponOffsetByIndex(total)
  if total == 1 then
    return AssemblyFormation.SingleWeaponPos
  end
  return AssemblyFormation.WeaponPos
end

return AssemblyFormation
