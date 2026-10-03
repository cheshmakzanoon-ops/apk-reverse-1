local Formation = {}
Formation.Pos = {
  [1] = Vector3.New(-1.5, 0, 1.5),
  [2] = Vector3.New(1.5, 0, 1.5),
  [3] = Vector3.New(-2.5, 0, -1.5),
  [4] = Vector3.New(0, 0, -3),
  [5] = Vector3.New(2.5, 0, -1.5),
  [6] = Vector3.New(0.81, 0, 5.64)
}
Formation.SinglePos = Vector3.zero
Formation.WeaponPos = Vector3.New(0, 0, -8)
Formation.SingleWeaponPos = Vector3.New(0, 0, -4)

function Formation.GetOffsetByIndex(index, total)
  if total == 1 then
    return Formation.SinglePos
  end
  return Formation.Pos[index]
end

function Formation.GetWeaponOffsetByIndex(total)
  if total == 1 then
    return Formation.SingleWeaponPos
  end
  return Formation.WeaponPos
end

function Formation.GetScaleByIndex(index)
  return 1
end

return Formation
