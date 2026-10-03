local tree = {}
tree[1] = {
  id = 1,
  style = 0,
  modelId = "23108",
  textKey = "393029",
  showWave = true,
  options = {
    {textKey = "", nextId = 2}
  }
}
tree[2] = {
  id = 2,
  style = 1,
  modelId = "40010",
  textKey = "393030",
  showWave = true,
  options = {
    {textKey = "", nextId = 3}
  }
}
tree[3] = {
  id = 3,
  style = 3,
  modelId = "40010",
  textKey = "393031",
  showWave = false,
  options = {
    {textKey = "", nextId = 4}
  }
}
tree[4] = {
  id = 4,
  style = 2,
  modelId = "0",
  textKey = "393032",
  showWave = false,
  options = {}
}
tree.rootId = 1
return tree
