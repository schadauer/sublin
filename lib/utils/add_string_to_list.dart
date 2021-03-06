List<String> addStringToList(List<String> list, String itemToAdd) {
  if (list != null) {
    if (list.length == 0) {
      list = [itemToAdd];
    } else {
      if (!list.contains(itemToAdd)) {
        list.insert(0, itemToAdd);
      }
    }
  }
  return list ?? <String>[];
}
